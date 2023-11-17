/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   TITLE      :    03 - MERGING BASELINE MIDLINE
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*
********************************************************************************/

/*03_merge
Date Created:  May 24, 2019
Date Last Modified: May 24, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: 
*   Outputs : "$main\Data\output\analysis\guinea_final_dataset.dta"

Comment : please look at my question in 1.b. !
*/



* initialize Stata
clear all
set more off
set mem 100m


*Cloe user
global user "C:\Users\cloes_000"
global main "$user\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"




********************************************************************************
//,\\'// 01 -   MERGING ADMIN/BASELINE DATA AND IDENTIFICATION DATABASE  '//,\\'
********************************************************************************


***   a. - merging midline surveys, admin data and identification database                                             
***_____________________________________________________________________________

* merging admin data and identification database
use "$main\Data\output\admin\admin_data.dta", clear
rename CODE schoolid
merge 1:m schoolid using "$main\Data\output\baseline\identification.dta"
/*   Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                             7,399  (_merge==3)
    -----------------------------------------
*/
drop _merge sec0_q1_a_baseline sec0_q1_b_baseline
rename key key_base
tempfile admin
save `admin'



*merging admin_id and participation
import excel "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\raw\midline\participation_elv.xlsx", firstrow clear
keep participation key tel2
rename key key_base
rename participation participation_elv
tempfile participation
save `participation'
merge 1:1 key_base using "`admin'"
 /*   Result                           # of obs.
    -----------------------------------------
    not matched                             1
        from master                         0  (_merge==1)
        from using                          1  (_merge==2)

    matched                             7,398  (_merge==3)
    -----------------------------------------
_merge==1 corresponds to the student of ABDOUL MAZID DIABY that had a wrong lycee_name,
its questionnaire had been deleted for the balance check but that we manage to rectify this data
duringg the information session.
WHAT DO WE DO OF THIS INFORMATION ?
*/

drop _merge
tempfile admin_id
save `admin_id'



*merging midline data and the identification dataset
use "$main\Data\output\midline\questionnaire_midline_clean.dta",clear
rename key key_mid
destring id_number,replace
merge 1:1 id_number using  "`admin_id'"

 /*   Result                           # of obs.
    -----------------------------------------
    not matched                         2,893
        from master                        7  (_merge==1)
        from using                      2,888  (_merge==2)

    matched                             4,511  (_merge==3)
    -----------------------------------------
_merge=2 corresponded to people that did not participate to the midline survey
_merge==1 are the 7 students with an wrong id_number and that do not answer to our calls !!
*/
keep if _merge==3 | _merge==1
drop _merge

gen time=1 // in order to specify that those are MIDLINE data

tempfile admin_midline
save `admin_midline'



***   b. - Appending the baseline questionnaires                                            
***_____________________________________________________________________________

use "$main\Data\output\baseline\questionnaire_baseline_clean_rigourous_cleaning.dta", clear
rename key key_base
merge m:1 key_base using "`admin_id'"


/*
    Result                           # of obs.
    -----------------------------------------
    not matched                            1
        from master                         0  (_merge==1)
        from using                         1  (_merge==2)

    matched                             7,386  (_merge==3)
    -----------------------------------------

_merge==1 corresponds to the student that had a wrong lycee_name, whose obseratoin has been 
deleted for the balance check but that we manage to find durnig the information session.
and the 12 questionnaires that I have deleted in the baseline dataset 
after checking the duplicates in details (see the dofile 03_id_correction)
WHAT DO WE DO OF THIS INFORMATION ?
*/
keep if _merge==3
drop _merge
gen time=0 // in order to specify that those are baseline data


* appending
append using "`admin_midline'"
tempfile base_midline
save `base_midline'




***   c. - merge with the two datasets related to logistics and  coordinates                                           
***_____________________________________________________________________________

import excel "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\raw\lycee_conakry.xlsx", firstrow clear
drop if N==.
tempfile lycee_conakry
save `lycee_conakry'


import excel "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\raw\sensi_mid_planning.xlsx", firstrow clear
drop if schoolid==.
drop treatment_status
tempfile planning
save `planning'


use "`base_midline'"
merge m:1 N using "`lycee_conakry'",force
/*
				  Result                           # of obs.
    -----------------------------------------
    not matched                           177
        from master                         7  (_merge==1)
        from using                        170  (_merge==2)

    matched                            11,910  (_merge==3)
    -----------------------------------------

_merge==2 are the non selected schools
_merge==1 are the 7 students with an wrong id_number and that do not answer to our calls !!
*/

keep if _merge==3 | _merge==1
drop _merge


merge m:1 schoolid using "`planning'", force
/*Result                           # of obs.
    -----------------------------------------
    not matched                             7
        from master                         7  (_merge==1)
        from using                          0  (_merge==2)

    matched                            11,910  (_merge==3)
    -----------------------------------------
_merge==1 are the 7 students with an wrong id_number and that do not answer to our calls !!
*/
keep if _merge==3 | _merge==1
drop _merge







********************************************************************************
//,\\'//          02 -   PREPARING THE FINAL DATA SET           //'//,\\'//,\\'
********************************************************************************


***   a. - Dropping useless information                                       
***_____________________________________________________________________________

drop instanceID N note_* etab_quest school_id schoolid id_elv id_elv_str lycee_name treatment consent_agree setofrandom_draws deviceid subscriberid simid devicephonenum formdef_version consent_agree
drop living_cost sec6_lottery_risk sec6_lottery_time sec7_index sec7_q9_bis sec8_q4_bis sec8_q5_bis



***   b. - labelling somes variables                                     
***_____________________________________________________________________________

label var time "Before or after the sensibilisation"
label var schoolid_str "Identification number of the school"
label var id_number "Student ID"
label var id_number_str "Identification number of the student string"

rename lycee_name_string lycee_name_str
label var lycee_name_str "High school name"

label var sec2_q4_bis "Cleaned sec2_q4"

label var participation_elv "Participation status from the attendance sheet"
label var participation "Participation status from the questionnaire"




***   c. - cleaning                                 
***_____________________________________________________________________________


gen PARTICIPATION=1 if participation_elv=="oui"
	replace PARTICIPATION=0 if participation_elv=="non"
	replace PARTICIPATION=2 if treatment_status==1
	replace PARTICIPATION=participation if lycee_name_str=="SAINTE MARIE" | lycee_name_str=="MARTIN LUTHER KING" // those correspond to schools for which we had no attendence sheet
	drop participation_elv participation
	rename PARTICIPATION participation
	label var participation "Participation to the information session"
	label define part 0"No" 1"Yes" 2"Control group"
	label values participation part

duplicates tag id_number,gen(mid_participant)
	label var mid_participant "Student who participated to the midline survey"
	label value mid_participant yes_no_bis
	

/*when there were some mistake in identification numbers, some students
answered the questions on the information session while they did not participation
I erase those data. */
count if participation==0 & partb_q0!=. // 2 obs

local partb_str "partb_q0_other partb_q1_other partb_q3_other  partb_q3"
local partb "partb_q0_bis partb_q1 partb_q2 partb_q3_1 partb_q3_2 partb_q3_3 partb_q3_4 partb_q3_99 partb_q3_5 partb_q5 partb_q6 partb_q8 partb_q9 partb_q11_a partb_q11_b partb_q11_c partb_q11_f partb_q11_g partb_q11_h partb_q11_j partb_q11_k partb_q11_l partb_q11_m partb_q12 partb_q13"
foreach var in `partb' {
replace `var'=. if participation==0 & partb_q0!=.
}

foreach var in `partb_str' {
replace `var'="" if participation==0 & partb_q0!=.
}

replace partb_q0=. if participation==0 & partb_q0!=.


*generating number of female teachers
gen nb_teacher_f=0
forvalues i=1/115 {
replace nb_teacher_f=nb_teacher_f+1 if gender`i'==2
}
label var nb_teacher_f "Number of female teachers in secondary high school (lycee+college) ?"

***   d. - Ordering                                  
***_____________________________________________________________________________


order time schoolid_str id_number id_number_str lycee_name_str lycee_name commune treatment participation
order submissiondate starttime endtime finished starttime_new_date starttime_new_hour submissiondate_new_date submissiondate_new_hour endtime_new_date endtime_new_hour sec2_q4_bis, last
order sell_asset money_from_asset mig_asset, after(sec2_q15)
order sec3_34_euros sec3_34_pounds sec3_34_local, after(sec3_34)
order sec3_42_euros sec3_42_pounds sec3_42_local, after(sec3_42)
order sec2_q4_bis, after(sec2_q4)
order road_selection, after(ceuta_sent_back)
order expectation_wage, after(sec3_34_bis)
order sec9_q3_1_a sec9_q3_1_b sec9_q3_2_a sec9_q3_2_b sec9_q3_3_a sec9_q3_3_b, after( sec9_q2)
order partb* check*, after(sec10_q19_2)
order key_mid, after(key_base)
order nb_teacher_f, after(nb_teachers)





********************************
***********  saving ************
********************************
save "$main\Data\output\analysis\guinea_final_dataset.dta", replace


