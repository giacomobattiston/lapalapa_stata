/*
import_guinea_baseline_questionnaire.do
Date Created:  December 7, 2018
Date Last Modified: November 28, 2018
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
* 	Imports and aggregates "guinea_baseline_questionnaire" (ID: guinea_baseline_questionnaire) data.
*	Inputs: .csv file(s) exported by the SurveyCTO Sync
*	Outputs: "C:/Users/cloes_000/Documents/RA-Guinee/Lapa Lapa/logistics/03_data/04_final_data/data/guinea_baseline_questionnaire.dta"

outline :
0- parameters
1- import datasets
2- format dates/time
3- correction files (unfinished correction file + error in lycee names)
4- keeping the relevant information

*/




* initialize Stata
clear all
set more off
set mem 100m

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
* chemins
global main "C:\Users\cloes_000\Documents\RA-Guinée\Lapa Lapa\logistics\03_data\04_final_data"
local csvfile "$main/raw/guinea_baseline_questionnaire.csv"
local dtafile "$main/data/guinea_baseline_questionnaire.dta"
local output "$main/output/questionnaire_baseline_clean.dta"

/*data type*/
local note_fields1 "note_consent note_friend1 note_friend2 note_sec1_a note_sec1_b note_sec1_c note_sec1_d note_sec2_a note_sec2_b note_sec3_a note_sec3_b note_sec3_e note_sec3_g note_sec3_h note_sec3_i_a note_sec3_i_b"
local note_fields2 "note_sec3_i_c note_sec4 note_sec5 note_sec6_a note_sec6_b note_sec7_a note_sec7_b note_sec7_c note_sec9 note_sec10_a note_sec10_b note_sec10_c note_fin"
local text_fields1 "deviceid subscriberid simid devicephonenum time_begin commune lycee_name sec0_q1_a sec0_q1_b sec0_q5_b sec0_q6 sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 time0 time1 sec2_q2"
local text_fields2 "sec2_q3 sec2_q3_other_reasonmig sec2_q5 sec2_q7_example sec2_q13 sec2_q14 sec2_q15 time2 time3a time3b"
local text_fields3 "sec3_21_nb_other sec3_21 time3c sec3_34_error_millions sec3_34_error_thousands time3d time4 time5 time6a time6b time7"
local text_fields4 "sec8_q4_other_occup time8 time9 sec10_q1_1 sec10_q5_1 sec10_q1_2 sec10_q5_2 time10a time10b time10c finished"
local randomization "upper_bound num_draws random_draws_count random_draw_* scaled_draw_* unique_draws randomoption1 randomoption2 randomoption3 randomoption4 randomoption5 randomoption6"
local date_fields1 "sec0_q3 sec2_q9"
local datetime_fields1 "submissiondate starttime endtime"

local introduction "commune lycee_name sec0_q1_a sec0_q1_b sec0_q2 sec0_q3 sec0_q4 sec0_q5_b sec0_q6 sec0_q6_fb sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 "
local family "sec1_1 sec1_2 sec1_3 sec1_5 sec1_6 sec1_7 sec1_8 sec1_9 sec1_10 sec1_12 sec1_13 sec1_14 sec1_15 sister_no brother_no"
local mig_desire "sec2_q1 sec2_q2 sec2_q3 sec2_q3_1 sec2_q3_2 sec2_q3_3 sec2_q3_4 sec2_q3_5 sec2_q3_6 sec2_q3_7 sec2_q3_other_reasonmig sec2_q4 sec2_q5 sec2_q7 sec2_q7_example sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3 sec2_q8 sec2_q9 sec2_q10_a sec2_q10_b sec2_q10_c sec2_q11 "
local italy "sec3_0 sec3_1 sec3_2 sec3_3 sec3_4 sec3_5 sec3_6 sec3_7 sec3_8"
local spain "sec3_10 sec3_11 sec3_12 sec3_14 sec3_15 sec3_16 sec3_17 sec3_18 sec3_19"
local ceuta "sec3_23 sec3_24 sec3_25 sec3_26 sec3_27 sec3_28 sec3_29 sec3_30 sec3_31"
local expectation "sec3_32 sec3_34 sec3_34_error_millions sec3_34_error_thousands sec3_34_error_millions_2 sec3_34_error_thousands_2 sec3_34_bis sec3_35 sec3_37 sec3_38 sec3_39 sec3_40 sec3_41 sec3_42"
local money_quest "sec3_2 sec3_12 sec3_25 sec3_34 sec3_34_bis sec3_42 sec4_q1 sec4_q2 sec4_q3 sec4_q4 sec8_q5 sec8_q6"


* fichiers de corrections *
*unfinished questionnaire
local corrfile1 "$main/correction_file/unfinished_questionnaire_1.xlsx" // Les questionnaires non-finalisés 1
local corrfile2 "$main/correction_file/unfinished_questionnaire_2.xlsx" //Les questionnaires non-finalisés 2
local corrfile3 "$main/correction_file/unfinished_questionnaire_3.xlsx" //Les questionnaires non-finalisés 3
local corrfile4 "$main/correction_file/error_lycee_name.xlsx" //Les questionnaires avec de mauvais nom de lycées
local nbcorr 1 2 3 4


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
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




***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - Formats                                          
***_____________________________________________________________________________


* drop note fields (since they don't contain any real data)
	forvalues i = 1/100 {
		if "`note_fields`i''" ~= "" {
			drop `note_fields`i''
		}
	}
	
	* format date and date/time fields
forvalues i = 1/100 {
	if "`datetime_fields`i''" ~= "" {
	foreach dtvarlist in `datetime_fields`i'' {
split `dtvarlist' // split the variables into 4 sub-variables
* replace months into numbers 
replace `dtvarlist'2="10" if `dtvarlist'2=="oct."
replace `dtvarlist'2="11" if `dtvarlist'2=="nov."
replace `dtvarlist'2="12" if `dtvarlist'2=="dÃ©c."
replace `dtvarlist'2="1" if `dtvarlist'2=="janv."
replace `dtvarlist'2="2" if `dtvarlist'2=="feb."

}
}
}

*the update of some tablets changed the date in the tablets.
replace starttime1="19" if starttime1=="17" & starttime3=="1922"
replace starttime2="1" if starttime2=="12" & starttime3=="1922"
replace starttime3="2019" if starttime3=="1922"




* date 
foreach var in starttime submissiondate endtime {
g `var'_new=`var'2 +"-" + `var'1 + "-"+ `var'3 
gen `var'_new_date=date(`var'_new, "MDY", 2018) if `var'3=="2018"
replace `var'_new_date=date(`var'_new, "MDY", 2019) if `var'3=="2019"
format `var'_new_date %td
gen `var'_new_hour=clock(`var'4,"hms")
format `var'_new_hour %tC
}


drop submissiondate1 submissiondate2 submissiondate3 submissiondate4 starttime1 starttime2 starttime3 starttime_new starttime4 endtime1 endtime2 endtime3 endtime4 submissiondate_new endtime_new


  

	
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

	

	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3 - keeping the relevant information               
***_____________________________________________________________________________


 * the baseline started on November 26. I delete all the observation before this date 
drop if starttime_new_date<date("11262018","MDY")

 * deleting questionnaire that i sent by mistake adama's training 
drop if sec0_q1_a=="Hji"

*drop obs if the student did not agree to answer the questionnaire
drop if consent_agree==2


 * deleting questionnaire of Kaba Bintou (Sylla Lamine) she was not selected
 *but she wanted to do the questionnaire*
drop if key=="uuid:b4ecbeab-e381-4b0a-9ec0-29524afeb80a"


* deleting questionnaire of Sekouma Kourouma (Nelson mandela simbaya). We end up with 51 
*students because 2 remplaçant came instead of one.Sekouma Kourouma was the last
*remplacant according to the list.
drop if key=="uuid:daf05498-1cf8-4e2a-9302-3e12e3802edd"

*in KOFI ANNAN, I had to inform the students + remplaçants before the day before the survey
*in the end, we got 53 participants because there were more remplacants than missing students.
*So I delete the students the last three remplaçants 

drop if key=="uuid:2e8d37f8-bc14-4556-af82-94351762f583" | key=="uuid:36638e4f-174a-4640-9b08-80f18485d7ce" | key=="uuid:d96b08c4-41b3-4314-951f-2618bc807d7a"


*dropping the 2 FA SCHOOLS that we surveyed
drop if lycee_name=="ABOUBACAR SIDIK" | lycee_name=="EL HADJ KARAMOKO KABA"

*dropping the school with 3 students (el Asad)
drop if key=="uuid:88de3369-ca0a-4429-8195-a21866843a8d" | key=="uuid:94512a4b-4de0-4a60-9871-f2326e697e37" | key=="uuid:0aa9b618-078d-4d3c-a860-61eb2ecb4ff9"


	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3 - correction files          : unfinished questionnaire     
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




/////////////////////////////////////////////////////////////////////////
//////////    append old, previously-imported data (if any) /////////////
/////////////////////////////////////////////////////////////////////////

	cap confirm file "`dtafile'"
	if _rc == 0 {
		* mark all new data before merging with old data
		gen new_data_row=1
		
		* pull in old data
		append using "`dtafile'"
		
		* drop duplicates in favor of old, previously-imported data if overwrite_old_data is 0
		* (alternatively drop in favor of new data if overwrite_old_data is 1)
		sort key
		by key: gen num_for_key = _N
		drop if num_for_key > 1 & ((`overwrite_old_data' == 0 & new_data_row == 1) | (`overwrite_old_data' == 1 & new_data_row ~= 1))
		drop num_for_key

		* drop new-data flag
		drop new_data_row
	}
	
	* save data to Stata format
	save "`dtafile'", replace

	* show codebook and notes
	codebook
	notes list

disp
disp "Finished import of: `csvfile'"
disp




