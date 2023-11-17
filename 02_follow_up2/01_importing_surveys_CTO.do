/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (G.Battiston,  L. Corno, E. La Ferrara)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :    01 - IMPORTING THE DATA OF THE ENDLINE FROM SURVEYCTO
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*
01_import_surveys_CTO.do
Date Created:  May 7, 2020
Date Last Modified: June 5, 2020
Created by: Laïla SOUALI
Last modified by: Laïla SOUALI
*	Inputs: .csv file(s) exported by the SurveyCTO Sync
	"Data\raw\followup2\guinea_endline_lycee_WIDE_corr.csv"
	"Data\raw\followup2\guinea_endline_phone_WIDE.csv"
*	Outputs: 
	"Data\dta\guinea_endline_lycee_raw.dta" 
	"Data\dta\guinea_endline_phone_raw.dta"

outline :
1- School Survey
2- Phone Survey

*/

* initialize Stata
clear all
set more off

*user: Laïla
global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - SCHOOL SURVEYS
***_____________________________________________________________________________

import delimited "${main}\Data\raw\followup2\guinea_endline_lycee_WIDE_corr.csv"

***DATE 
local date_fields1 "sec2_q9"
local datetime_fields1 "submissiondate starttime endtime"

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

* ensure that text fields are always imported as strings (with "" for missing values)
* (note that we treat "calculate" fields as text; you can destring later if you wish)
local text_fields1 "deviceid subscriberid simid devicephonenum commune lycee_name lycee_name2 treatment school_id id_cto prenom_baseline nom_baseline classe_baseline option_baseline time_begin id_cto_checked"
local text_fields2 "participation time0 sec2_q2 sec2_q3 sec2_q3_other_reasonmig sec2_q5 sec2_q7_example time2 time3a time3b upper_bound num_draws"
local text_fields3 "random_draws_count unique_draws randomoption1 randomoption2 randomoption3 randomoption4 randomoption5 randomoption6 sec3_21_nb_other sec3_21 time3c sec3_34_error_millions sec3_34_error_thousands"
local text_fields4 "time3d time5 time7 sec9_q3_1_a sec9_q3_1_b sec9_q3_2_a sec9_q3_2_b sec9_q3_3_a sec9_q3_3_b time9 sec10_q1_1 sec10_q5_1 sec10_q1_2 sec10_q5_2 time10a time10b time10c partb_q0_other partb_q1_other"
local text_fields5 "partb_q3 partb_q3_other time_partb finished time_check"

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

	
*droping questionnaires from the pilot phase
drop if endtime_date < date("30jan2020", "DMY")

*same format to merge
tostring id_cto_checked, replace

*Dummy to indicate if the student has a school survey
gen surveycto_lycee="1"

*Saving raw dta
save ${main}\Data\dta\guinea_endline_lycee_raw, replace


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - PHONE SURVEYS
***_____________________________________________________________________________

clear
import delimited "${main}\Data\raw\followup2\guinea_endline_phone_WIDE.csv"

***DATE 
local date_fields1 "where_11"
local datetime_fields1 "submissiondate starttime endtime"
	
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

* ensure that text fields are always imported as strings (with "" for missing values)
* (note that we treat "calculate" fields as text; you can destring later if you wish)
local text_fields1 "deviceid subscriberid simid devicephonenum commune lycee_name lycee_name2 num_elv treatment school_id id_cto prenom_baseline nom_baseline classe_baseline option_baseline time_begin"
local text_fields2 "where_5 mig_7 mig_19 mig_26 mig_31 past_mig_9 sec2_q3_other_reasonmig sec2_q7_other_plan"
local text_fields4 "time1 time_check time_3_contact time_check_contact" 
local text_fields5 "sec0_q4_a_contact where_5_contact mig_7_contact mig_19_contact mig_26_contact mig_31_contact past_mig9_a_contact sec2_q3_other_reasonmig_contact sec2_q7_other_plan_contact"

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
	
*droping questionnaires from the pilot phase
drop if endtime_date < date("31jan2020", "DMY")

*Dummy to indicate if the student has a phone survey
gen surveycto_phone="1"

*Saving raw dta
save ${main}\Data\dta\guinea_endline_phone_raw, replace



