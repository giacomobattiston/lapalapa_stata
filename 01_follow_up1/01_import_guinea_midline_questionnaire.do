/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (G.Battiston,  L. Corno, E. La Ferrara)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :    01 - IMPORTING THE DATA OF THE MIDLINE
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*
import_guinea_midline_questionnaire.do
Date Created:  May 24, 2018
Date Last Modified: May 24, 2018
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
* 	Imports and aggregates "guinea_midline_questionnaire" (ID: guinea_mid_questionnaire) data.
*	Inputs: .csv file(s) exported by the SurveyCTO Sync
*	Outputs: "guinea_midline_questionnaire_imported.dta"

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
*users
*Cloe user
*global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

* chemins
local csvfile "$main/Data/raw/midline/guinea_midline_questionnaire.csv"
local dtafile "$main/Data/dta/guinea_midline_questionnaire.dta"
local output "$main/Data/output/midline/questionnaire_midline_imported.dta"

* initialize form-specific parameters
local note_fields1 "note_consent error_id note_friend1 note_friend2 note_sec2_a note_sec3_a note_sec3_b note_sec3_e note_sec3_g note_sec3_g_bis note_sec3_i_a note_sec3_i_b note_sec3_i_c note_42_euros note_42_livres"
local note_fields2 "note_42_local note_sec5 note_sec7_a note_sec9 classmate1note classmate2note classmate3note note_sec10_a note_sec10_b note_sec10_c quest_chiffre quest_chiffre2 debate_statements videos_statements"
local note_fields3 "note_last_section note_check note_fin"
local text_fields1 "deviceid subscriberid simid devicephonenum commune lycee_name lycee_name2 treatment school_id id_cto prenom_baseline nom_baseline classe_baseline option_baseline time_begin id_cto_checked"
local text_fields2 "participation sec0_q6 sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 time0 sec2_q2 sec2_q3 sec2_q3_other_reasonmig sec2_q5 sec2_q7_example time2 time3a time3b upper_bound num_draws"
local text_fields3 "random_draws_count unique_draws randomoption1 randomoption2 randomoption3 randomoption4 randomoption5 randomoption6 sec3_21_nb_other sec3_21 time3c sec3_34_error_millions sec3_34_error_thousands"
local text_fields4 "time3d time5 time7 sec9_q3_1_a sec9_q3_1_b sec9_q3_2_a sec9_q3_2_b sec9_q3_3_a sec9_q3_3_b time9 sec10_q1_1 sec10_q5_1 sec10_q1_2 sec10_q5_2 time10a time10b time10c partb_q0_other partb_q1_other"
local text_fields5 "partb_q3 partb_q3_other time_partb finished time_check"
local date_fields1 "sec2_q9"
local datetime_fields1 "submissiondate starttime endtime"

* correction file *
local corrfile1 "$main/Data/correction_file/correction_midline/mid_unfinished_questionnaire.xlsx" // non finished questionnaires
local corrfile2 "$main/Data/correction_file/correction_midline/id_error.xlsx"
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
replace `dtvarlist'2="4" if `dtvarlist'2=="avr."
replace `dtvarlist'2="5" if `dtvarlist'2=="mai"
replace `dtvarlist'2="6" if `dtvarlist'2=="juin"
}
}
}

* date 
foreach var in starttime submissiondate endtime {
g `var'_new=`var'2 +"-" + `var'1 + "-"+ `var'3 
gen `var'_new_date=date(`var'_new, "MDY", 2021)
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

	

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   3 -  DUPLICATES CHECK                                           
***_____________________________________________________________________________

duplicates report id_cto_checked

/*---------------------------------
   copies | observations      surplus
----------+--------------------------
        1 |         4476            0
        2 |           50           25
-------------------------------------
We called all those 50 students and 4 students did not answer.
The modifications have been done in the correction_file id_error.
All the explanations are in "Logistics/03_data/04_correction_file/duplicate_log.".
Bellow, I also delete the questionnaires of student who did the survey twice
or who should not have done the survey : */

*she completed the survey twice (same telephone number, same contact), I drop the second quetionnaire:
drop if key=="uuid:7fd4fb4a-4079-4f83-82ef-11b2465aa2f4"

*the student completed the survey twice (same telephone number, same contact), I drop the second questionnaire:
drop if key=="uuid:04b0db40-d99b-42dc-8c1e-ab29df180a88"

*the student completed the survey twice (same telephone number, same contact, same tablets), I drop the second questionnaire:
drop if key=="uuid:3e20c1d8-2c09-44b1-ab60-14ebcd98488b"

*the student did the survey twice, he did not finished the first one and start again.
*I delete the first survey, the one that he did not finish.
drop if key=="uuid:ec9f1c87-e0d6-43c9-ac7b-dae8e1616ea5"

*the student did the survey twice, he did not finished the first one and start again.
*I delete the first survey, the one that he did not finish.
drop if key=="uuid:cc4da6e2-785f-482a-8f64-5850fdd3045e"

*this student has the same name as a student who did the baseline but he did not participated to
*the baseline survey. I delete this questionnaire
drop if key=="uuid:b1aa8af8-1c78-4674-81a4-217c2f36375f"

**the student did the survey twice, he did not finished the first one and start again.
*I delete the one that he did not finish.
drop if key=="uuid:8ce72ec5-1762-4d36-bd2b-79f91cdd2583"

** this student was not survyed during the baseline but did the endline because 
* he wanted to participatte. 
drop if key=="uuid:ab747333-304a-48dc-aec3-f84ef7ca1435"

*he completed the survey twice : same tablet, same tel
drop if key=="uuid:4870853f-e50f-49f4-b8f5-5a87be2112e0"


/* those students have a wrong id_number. Those are duplicates 
and we called the students who had the same id_number, hence their
identification is wrong.I cannot find the right id_number since
I did not manage to reach them*/
replace id_cto_checked="1" if key=="uuid:70ba1229-d3fc-4dc8-891b-6d10d7f29bb7"
replace id_cto_checked="2" if key=="uuid:dcc34351-fc1e-4bc1-96a5-ec04bc5c584b"
replace id_cto_checked="3" if key=="uuid:ebc22f3d-5cb9-4fe6-ab07-855ff7ff1ad3"
replace id_cto_checked="4" if key=="uuid:a51b87fb-d0a2-49ba-a993-10104fb4f958"



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   4 - TECHNICAL ERROR IN ID NUMBER                                         
***_____________________________________________________________________________

browse if participation==""

* The id number of the student of maimouna balde have not
*been correctly computed. Their id is composed of num_elv instead of schoolid+num_elv.
replace school_id="915324" if lycee_name=="MAIMOUNA BALDE"
	egen id_cto_balde=concat(school_id num_elv) if lycee_name=="MAIMOUNA BALDE"
	replace id_cto_checked=id_cto_balde if lycee_name=="MAIMOUNA BALDE" & check_id==1
	replace id_cto=id_cto_balde if lycee_name=="MAIMOUNA BALDE"
	drop id_cto_balde

*the other correction have been done in "id_error". 
*All the explanation are in "Logistics/03_data/04_correction_file/duplicate_log.".


/* those students have a wrong id_number. Those are duplicates 
and we called the students who had the same id_number, hence their
identification is wrong.I cannot find the right id_number since
I did not manage to reach them*/

replace id_cto_checked="5" if key=="uuid:82afe7e2-933e-410e-9dfe-9ef71035f31f"
replace id_cto_checked="6" if key=="uuid:6d31bfa0-74c4-45be-ac2d-1635fd132055"
replace id_cto_checked="7" if key=="uuid:7d13be56-414b-4d68-a057-858fde15bd4d"



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

/*
rename id_cto_checked id_number


foreach x of local nbcorr_bis {
* apply corrections 
capture confirm file "`corrfile_bis`x''"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile_bis`x''"
	disp

	* save primary data in memory
	preserve

	* load corrections
	import excel using "`corrfile_bis`x''", firstrow clear
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
		tempfile tempdo_bis
		file open dofile using "`tempdo_bis'", write replace
		local N = _N
		forvalues j = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local id_numberval=id_number[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if id_number=="`id_numberval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if id_number=="`id_numberval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if id_number=="`id_numberval'""' _n
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
		do "`tempdo_bis'"
		

	
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
	disp "Finished applying corrections in: `corrfile_bis`x''"
	disp
}

}
*/



duplicates report id_cto_checked

/*Duplicates in terms of id_cto_checked

-------------------------------------
   copies | observations      surplus
----------+--------------------------
        1 |         4518            0
-------------------------------------
*/


/////////////////////////////////////////////////////////////////////////
//////////    append old, previously-imported data (if any) /////////////
/////////////////////////////////////////////////////////////////////////

	cap confirm file "`dtafile'"
	if _rc == 0 {
		* mark all new data before merging with old data
		gen new_data_row=1
		
		* pull in old data
		append using "`dtafile'",force
		
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


save "`output'", replace

