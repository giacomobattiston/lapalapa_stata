/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (G.Battiston,  L. Corno, E. La Ferrara)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :    01 - IMPORTING THE DATA OF THE FOLLOW-UP 2
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*
import_guinea_followup2_lycee.do
* 	Imports and aggregates "guinea_endline_lycee" (ID: guinea_mid_questionnaire) data.
*	Inputs: .csv file(s) exported by the SurveyCTO Sync
*	Outputs: "guinea_endline_lycee_imported.dta"

outline :
0- parameters
1- import datasets
2- format dates/time
3- duplicates check
4- errer in id_number
5- correction files
6- appending previous files

*/

* initialize Stata
clear all
set more off

* initialize workflow-specific parameters
*	Set overwrite_old_data to 1 if you use the review and correction
*	workflow and allow un-approving of submissions. If you do this,
*	incoming data will overwrite old data, so you won't want to make
*	changes to data in your local .dta file (such changes can be
*	overwritten with each new import).
local overwrite_old_data 0

********************************************************************************
//,\\'//,\\'//,\\'//,\\           PARAMETERS            //,\\'//,\\'//,\\'//,\\'
********************************************************************************
*users
*Laïla
global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

* chemins
local csvfile "$main/Data/raw/followup2/guinea_endline_lycee.csv"
local dtafile "$main/Data/dta/guinea_endline_lycee.dta"
local output "$main/Data/output/followup2/questionnaire_lycee_endline_imported.dta"

* initialize form-specific parameters
*local note_fields1 "note_consent error_id note_friend1 note_friend2 note_sec2_a note_sec3_a note_sec3_b note_sec3_e note_sec3_g note_sec3_g_bis note_sec3_i_a note_sec3_i_b note_sec3_i_c note_42_euros note_42_livres"
*local note_fields2 "note_42_local note_sec5 note_sec7_a note_sec9 classmate1note classmate2note classmate3note note_sec10_a note_sec10_b note_sec10_c quest_chiffre quest_chiffre2 debate_statements videos_statements"
*local note_fields3 "note_last_section note_check note_fin"
local text_fields1 "deviceid subscriberid simid devicephonenum commune lycee_name lycee_name2 treatment school_id id_cto prenom_baseline nom_baseline classe_baseline option_baseline time_begin id_cto_checked"
local text_fields2 "participation sec0_q6 sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 time0 sec2_q2 sec2_q3 sec2_q3_other_reasonmig sec2_q5 sec2_q7_example time2 time3a time3b upper_bound num_draws"
local text_fields3 "random_draws_count unique_draws randomoption1 randomoption2 randomoption3 randomoption4 randomoption5 randomoption6 sec3_21_nb_other sec3_21 time3c sec3_34_error_millions sec3_34_error_thousands"
local text_fields4 "time3d time5 time7 sec9_q3_1_a sec9_q3_1_b sec9_q3_2_a sec9_q3_2_b sec9_q3_3_a sec9_q3_3_b time9 sec10_q1_1 sec10_q5_1 sec10_q1_2 sec10_q5_2 time10a time10b time10c partb_q0_other partb_q1_other"
local text_fields5 "partb_q3 partb_q3_other time_partb finished time_check"
local date_fields1 "sec2_q9"
local datetime_fields1 "submissiondate starttime endtime"

* correction file *
local corrfile1 "$main/Data/correction_file/correction_followup2/fu2_unfinished_questionnaire.xlsx" // unfinished questionnaires
local corrfile2 "$main/Data/correction_file/correction_followup2/duplicates.xlsx"
local nbcorr 1 2

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   1 - Imports datasets                                                  
***_____________________________________________________________________________

disp
disp "Starting import of: `csvfile'"
disp

* import data from primary .csv file
insheet using "`csvfile'", names clear

* drop extra table-list columns
cap drop reserved_name_for_field_*
cap drop generated_table_list_lab*


drop if consent_agree==2

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   2 - Formats                                          
***_____________________________________________________________________________
*avoiding pb with the string variables

foreach var in `date_fields1' `datetime_fields1'  {
replace `var' = subinstr( `var', "√©", "é",.) 
replace `var' = subinstr( `var', "√ª", "û",.) 
}

	* drop note fields (since they don't contain any real data)
	*forvalues i = 1/100 {
	*	if "`note_fields`i''" ~= "" {
	*		drop `note_fields`i''
	*	}
	*}
	
		* format date and date/time fields
forvalues i = 1/100 {
	if "`datetime_fields`i''" ~= "" {
	foreach dtvarlist in `datetime_fields`i'' {
split `dtvarlist' // split the variables into 2 sub-variables
}
}
}

* date 
foreach var in starttime submissiondate endtime {
gen `var'_date=date(`var'1, "DMY")
format `var'_date %td
gen `var'_hour=clock(`var'2,"hms")
format `var'_hour %tcHH:MM:SS
}

drop submissiondate1 submissiondate2 starttime1 starttime2 endtime1 endtime2 

*droping questionnaires from the pilot phase
drop if endtime_date < date("30jan2020", "DMY")


	* ensure that text fields are always imported as strings (with "" for missing values)
	* (note that we treat "calculate" fields as text; you can destring later if you wish)
	tempvar ismissingvar
	quietly: gen `ismissingvar'=.
	forvalues i = 1/100 {
		if "`text_fields`i''" ~= "" {
			foreach svarlist in `text_fields`i'' {
				cap unab svarlist : `svarlist'
				if _rc==0 {
					foreach stringvar in `svarlist' {
						quietly: replace `ismissingvar'=.
						quietly: cap replace `ismissingvar'=1 if `stringvar'==.
						cap tostring `stringvar', format(%100.0g) replace
						cap replace `stringvar'="" if `ismissingvar'==1
					}
				}
			}
		}
	}
	quietly: drop `ismissingvar'


	* consolidate unique ID into "key" variable
	replace key=instanceid if key==""
	drop instanceid


	*cleaning the name of the lycee
	replace lycee_name=trim(lycee_name)

	
***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   3 -  DUPLICATES CHECK                                           
***_____________________________________________________________________________

duplicates report id_cto_checked

/*
--------------------------------------
   copies | observations       surplus
----------+---------------------------
        1 |         2371             0
        2 |           46            23
        3 |           12             8
--------------------------------------
*/

*31 
*39 en double? et 1 en triple

duplicates tag id_cto_checked, gen(dup)

browse if dup != 0

*correction in 6_correction_lycee_mismatch

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   4 - TECHNICAL ERROR IN ID NUMBER                                         
***_____________________________________________________________________________

browse if participation==""


***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   6 - CORRECTION FILES   
***_____________________________________________________________________________


foreach x of local nbcorr {
* apply corrections 
capture confirm file "`corrfile`x''"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile`x''"
	disp

	* save primary data in memory
	preserve

	* load corrections
	import excel using "`corrfile`x''", firstrow clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		*drop notes
		
		* make sure that all values are in string format to start
		gen origvalue=value
		tostring value, format(%100.0g) replace
		cap replace value="" if origvalue==.
		drop origvalue
		replace value=trim(value)
		
		* correct field names to match Stata field names (lowercase, drop -'s and .'s)
		replace fieldname=lower(subinstr(subinstr(fieldname,"-","",.),".","",.))
		
		* format date and date/time fields (taking account of possible wildcards for repeat groups)
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvar in `datetime_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						gen origvalue=value
						replace value=string(clock(value,"DMYhms",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
						* allow for cases where seconds haven't been specified
						replace value=string(clock(origvalue,"DMYhm",2025),"%25.0g") if strmatch(fieldname,"`dtvar'") & value=="." & origvalue~="."
						drop origvalue
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvar in `date_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						replace value=string(clock(value,"DMY",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
					}
				}
			}
		}

		* write out a temp file with the commands necessary to apply each correction
		tempfile tempdo
		file open dofile using "`tempdo'", write replace
		local N = _N
		forvalues i = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local keyval=key[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if key=="`keyval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if key=="`keyval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if key=="`keyval'""' _n
			}
			file write dofile _tab `"if _rc ~= 0 {"' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab _tab `"disp "CAN'T APPLY CORRECTION IN ROW #`rownumval'""' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab `"}"' _n
			file write dofile `"}"' _n
		}
		file close dofile
	
		* restore primary data
		restore
		
		* execute the .do file to actually apply all corrections
		do "`tempdo'"
		
		
		
	
		*replace missing values as " " if the values is a string
		forvalues k = 1/100 {
		foreach variable in `text_fields`k'' {
			replace `variable'="" if `variable'=="."
			}
			}
		
		* re-save data
		save "`output'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile`x''"
	disp
}

}


