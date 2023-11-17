/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :    	06 - MERGING ALL SOURCES FOR THE ENDLINE
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*06_merging_endline.do
Date Created:  May 7, 2020
Date Last Modified: June 5, 2020
Created by: Laïla SOUALI
Last modified by: Laïla SOUALI
*	Inputs: .dta file 
	School:
		- SurveyCTO school surveys:
		"Data\output\followup2\intermediaire\guinea_endline_lycee_corrected.dta"
		- Short school surveys:
		"Data\output\followup2\intermediaire\presence_enquete_filled_all.dta"
	Phone:
		- All school surveys (surveyCTO + short school survey):
		"Data\output\followup2\intermediaire\endline_lycee_all_clean.dta"
		- All phone surveys (surveyCTO + enumerators' files):
		"Data\output\followup2\intermediaire\endline_phone_all_clean.dta"
	
*	Outputs: 
	"Data\output\followup2\intermediaire\endline_phone_all_clean.dta"
	"Data\output\followup2\intermediaire\endline_lycee_all_clean.dta"
	"Data\output\followup2\questionnaire_endline_clean"

*Outline :
- 1 - School survey
- 2 - Phone survey
- 3 - Merging phone and school survey
- 4 - Saving

*/ 

* initialize Stata
clear all
set more off

*Laïla user
*global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
*Giacomo
global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

/////////////////////////////////////////////////////////////////////////////
/////////      					1- SCHOOL					/////////////////
/////////////////////////////////////////////////////////////////////////////
/*inputs: 
- SurveyCTO school surveys:
${main}\Data\output\followup2\intermediaire\guinea_endline_lycee_corrected.dta

- Short school surveys:
${main}\Data\output\followup2\intermediaire\presence_enquete_filled_all.dta
*/

***   MERGING SURVEYCTO DATA AND PAPER QUESTIONNAIRES

use ${main}\Data\output\followup2\intermediaire\presence_enquete_filled_all
rename id_cto_checked id_number
destring id_number, replace
merge m:m id_number using "$main\Data\output\followup2\questionnaire_endline_lycee_clean.dta", force

/*  
    Result                           # of obs.
    -----------------------------------------
    not matched                         3,726
        from master                     3,725 
>  (_merge==1)
        from using                          1 
>  (_merge==2)

    matched                             2,385 
>  (_merge==3)
    -----------------------------------------
*/
*browse if _merge==2: student 15 from Ociss surveyed at 11am the 17/03
*not in any file from the school surveyed that day
*id_number:91526515
*key: uuid:a38aeb27-bea7-41f3-809f-02bee3c74dbd

*DUPLICATES
duplicates list id_number
drop if _n==3322
drop if _n==4638
drop if _n==5500

drop _merge
save ${main}\Data\output\followup2\intermediaire\endline_lycee_all_clean, replace



/////////////////////////////////////////////////////////////////////////////
/////////      					2-  PHONE					/////////////////
/////////////////////////////////////////////////////////////////////////////
/*inputs: 
- SurveyCTO phone surveys:
${main}\Data\output\followup2\intermediaire\guinea_endline_phone_corrected

- Enumerators' paper files:
${main}\Data\output\followup2\intermediaire\phone_files
*/
clear
use ${main}\Data\output\followup2\intermediaire\phone_files

merge 1:1 id_number using "$main\Data\output\followup2\questionnaire_endline_phone_clean.dta", force

*Comment_pf: comments about the situation of the students given by classmates or contacts
*Comment pf2: comments about the work of the phone enumerators (e.g. students who were wrongly marked 
*surveyed and therefore have only been called only once instead of the usual 4 days)


drop _merge
save ${main}\Data\output\followup2\intermediaire\endline_phone_all_clean, replace



/////////////////////////////////////////////////////////////////////////////
/////////      			3-	MERGING SCHOOL AND PHONE		/////////////////
/////////////////////////////////////////////////////////////////////////////
/*inputs: 
- All school surveys (surveyCTO + short school survey):
${main}\Data\output\followup2\intermediaire\endline_lycee_all_clean

- All phone surveys (surveyCTO + enumerators' files):
${main}\Data\output\followup2\intermediaire\endline_phone_all_clean
*/
clear
use ${main}\Data\output\followup2\intermediaire\endline_lycee_all_clean
merge 1:1 id_number using "${main}\Data\output\followup2\intermediaire\endline_phone_all_clean", force
/*
    Result                           # of obs.
    -----------------------------------------
    not matched                         3,409
        from master                     2,136  (_merge==1)
        from using                      1,273  (_merge==2)

    matched                             3,967  (_merge==3)
    -----------------------------------------

*/
*TIME VARIABLE INDICATING ENDLINE
gen time=2

drop classe_option_baseline

rename school_id schoolid

*duplicates tag id_number, gen(dupid)
*tab dupid

*UNIQUE VARIABLE FOR MISMATCHES CORRECTED
gen rematched=.
replace rematched=1 if rematch=="1"
replace rematched=2 if rematch_p=="2"
label define rematch 1 "School survey" 2 "Phone survey"
destring rematch, replace
destring rematch_p, replace


label variable rematched "The ID number was corrected during the data cleaning"
note rematched : "The ID number was corrected during the data cleaning"
label values rematched rematch 

label variable rematch "The ID number was corrected during the data cleaning (school survey)"
note rematch : "The ID number was corrected during the data cleaning (school survey)"
label values rematch yesno 

label variable rematch_p "The ID number was corrected during the data cleaning (phone survey)"
note rematch_p : "The ID number was corrected during the data cleaning (phone survey)"
label values rematch_p yesno 

rename rematch rematch_school
rename rematch_p rematch_phone

tostring schoolid, gen(schoolid_str)

/*Variables only in baseline
ceuta_duration ceuta_journey_cost ceuta_beaten ceuta_forced_work ceuta_kidnapped ceuta_die_bef_boat ceuta_sent_back ceuta_die
sec4_q1 sec4_q2 sec4_q3 sec4_q4
sec6_lottery15 sec6_lottery16 sec6_lottery17 sec6_lottery18 sec6_lottery19 sec6_lottery20 sec6_lottery21 sec6_lottery23 sec6_lottery24 sec6_lottery25 sec6_lottery26 sec6_lottery27 sec6_lottery28 sec6_lottery29 sec6_lottery30
sec6_lottery1 sec6_lottery2 sec6_lottery3 sec6_lottery4 sec6_lottery5 sec6_lottery6 sec6_lottery7 sec6_lottery8 sec6_lottery9 sec6_lottery11 sec6_lottery10 sec6_lottery12 sec6_lottery13 sec6_lottery14
sec7_q4 sec7_q5 sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_h sec7_q6_g sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m
sec8_q1 sec8_q2 sec8_q3 sec8_q4 sec8_q4_other_occup sec8_q5 sec8_q6
sec10_q10_2

sec3_38 not found
*/

*destring
local format_str sec2_q10_c italy_beaten italy_duration italy_kidnapped italy_die_bef_boat italy_die_boat italy_sent_back italy_forced_work spain_duration spain_beaten spain_forced_work spain_kidnapped spain_die_bef_boat spain_die_boat spain_sent_back sec3_32 sec3_34_euros sec3_35 sec3_36 sec3_37 sec3_39 sec3_40 sec3_41 outside_contact_no  check1   check1_bis check2 check3 check3_bis                                     
foreach var of local format_str {
destring `var', replace
}

/////////////////////////////////////////////////////////////////////////////
/////////      			4-	MERGING SCHOOL AND PHONE		/////////////////
/////////////////////////////////////////////////////////////////////////////

save ${main}\Data\output\followup2\questionnaire_endline_clean, replace











