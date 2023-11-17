/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (G.Battiston,  L. Corno, E. La Ferrara)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :      02 - IMPORTING THE DATA OF THE ENDLINE FROM PAPER QUESTIONNAIRES
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*
02_paper_questionnaire.do
Date Created:  May 7, 2020
Date Last Modified: June 5, 2020
Created by: Laïla SOUALI
Last modified by: Laïla SOUALI
*	Inputs: .xlsx file(s) digitalized from paper questionnaires
	Short School Survey: 
		"logistics\08_follow_up2\lycee_survey\presence_enquete_filled\second_visits\ready_second\deuxième_visite`num'.xlsx" (1/30)
		"logistics\08_follow_up2\lycee_survey\presence_enquete_filled\ready\presence_enquete`num'.xlsx" (1/131)
		"logistics\08_follow_up2\lycee_survey\presence_enquete_filled\ready\transfered.xlsx"
	Phone Enumerators Files: 
		"Data\correction_file\correction_followup2\phone_survey\comment_section_phone_files.xlsx"
		"Data\correction_file\correction_followup2\phone_survey\phone_files.xlsx"
*	Outputs: 
		"Data\output\followup2\intermediaire\presence_enquete_filled_all.dta"
		"Data\output\followup2\intermediaire\phone_files.dta"


		
Outline :
1- Short School Survey
	1.1- Second visits
	1.2- First visits
	1.3- Transfers
	1.4- Merging first and second visits
	1.5- Merging with transfers
	1.6- Students with unclear status on the files 
	1.7- Cleaning
2- Phone Enumerators Files
	1.1- Comment section
	1.2- Results of the calls

*/

* initialize Stata
clear all
set more off

*user: Laïla
global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

/////////////////////////////////////////////////////////////////////////////
/////////      			1 - SHORT SCHOOL SURVEYS				/////////////////
/////////////////////////////////////////////////////////////////////////////

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.1 - SECOND VISITS
***_____________________________________________________________________________

*SAVE AS DTA ALL THE PAPER QUESTIONNAIRE
        foreach num of numlist 1/30 {
				clear
				import excel "${main}\logistics\08_follow_up2\lycee_survey\presence_enquete_filled\second_visits\ready_second\deuxième_visite`num'.xlsx", firstrow
				save ${main}\logistics\08_follow_up2\data\paper_questionnaire\deuxieme_visite`num', replace
        }

		
**APPEND
use "${main}\logistics\08_follow_up2\data\paper_questionnaire\deuxieme_visite1.dta", clear
        foreach num of numlist 2/30 {
                append using "${main}\logistics\08_follow_up2\data\paper_questionnaire\deuxieme_visite`num'", force
        }

rename classe_option_baselineander classe_option_baseline

**CREATE UNIQUE STUDENT ID
egen id_cto_checked=concat(school_id num_elv)

** DROPPING DUPLICATES (due to empty cells in excel)
duplicates tag id_cto_checked, gen(dup)
drop if dup == 235

*duplicates : id_cto_checked 91102523 / 91522039
drop dup 

*surveyed_2
replace surveyed_2 = "0" if(regexm(surveyed_2, "non"))
replace surveyed_2 = "1" if(regexm(surveyed_2, "oui"))
tab surveyed_2

*present_3
replace present_2 = "0" if(regexm(present_2, "non"))
replace present_2 = "1" if(regexm(present_2, "oui"))
tab present_2

** DROP EMPTY COLUMNS
drop N O P Q R S T

destring surveyed_2, replace
destring present_2, replace

la def yesno 0 "no" 1 "yes"
la val surveyed_2 present_2 yesno

/*
gen date_fu2_2_str=date_fu2_2

split date_fu2_2 ,g(part) p("/")
tostring date_fu2_2_str, replace
replace date_fu2_2_str=date_fu2_2

replace date_fu2_2 = 0 + date_fu2_2 
if substr(date_fu2_2, 2, 1) == "/"
*/

save ${main}\Data\output\followup2\intermediaire\presence_enquete_filled_second, replace


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.2 - FIRST VISITS
***_____________________________________________________________________________
clear

 foreach num of numlist 1/131 {
				clear
                import excel "${main}\logistics\08_follow_up2\lycee_survey\presence_enquete_filled\ready\presence_enquete`num'.xlsx", firstrow
				save ${main}\logistics\08_follow_up2\data\paper_questionnaire\presence_enquete`num', replace
        }
		
use "${main}\logistics\08_follow_up2\data\paper_questionnaire\presence_enquete1.dta", clear
        foreach num of numlist 2/131 {
                append using "${main}\logistics\08_follow_up2\data\paper_questionnaire\presence_enquete`num'", force
        }

rename classe_option_baselineander classe_option_baseline

**CREATE UNIQUE STUDENT ID
egen id_cto_checked=concat(school_id num_elv)

** DROPPING DUPLICATES (due to empty cells in excel)
drop if id_cto_checked=="."

duplicates tag id_cto_checked, gen(dup)
tab dup
drop dup

replace comment = "refus" if(regexm(surveyed, "refus"))
replace comment = "refus" if(regexm(surveyed, "X"))

*surveyed
replace surveyed = "0" if(regexm(surveyed, "non"))
replace surveyed = "0" if(regexm(surveyed, "refus"))
replace surveyed = "0" if(regexm(surveyed, "X"))
replace surveyed = "1" if(regexm(surveyed, "oui"))

*present
replace present = "0" if(regexm(present, "non"))
replace present = "1" if(regexm(present, "oui"))
replace present = "0" if(regexm(present, "X"))
tab present

*changed_school 
replace changed_school = "0" if(regexm(changed_school, "non"))
replace changed_school = "1" if(regexm(changed_school, "oui"))
*tab changed_school

*abandon
replace abandon = "0" if(regexm(abandon, "non"))
replace abandon = "1" if(regexm(abandon, "oui"))
replace abandon = "." if(regexm(abandon, "X"))
tab abandon

*passed_bac
replace passed_bac = "0" if(regexm(passed_bac, "non"))
replace passed_bac = "1" if(regexm(passed_bac, "oui"))
tab passed_bac

*left_conakry
replace left_conakry = "0" if(regexm(left_conakry, "non"))
replace left_conakry = "1" if(regexm(left_conakry, "oui"))
replace left_conakry = "." if(regexm(left_conakry, "X"))
tab left_conakry

*left_guinea
replace left_guinea = "0" if(regexm(left_guinea, "non"))
replace left_guinea = "1" if(regexm(left_guinea, "oui"))
replace left_guinea = "." if(regexm(left_guinea, "X"))
tab left_guinea

destring surveyed, replace
destring present, replace
destring abandon, replace
destring passed_bac, replace
destring left_conakry, replace
destring left_guinea, replace

la def yesno 0 "no" 1 "yes"
la val surveyed present abandon passed_bac left_conakry left_guinea yesno

save ${main}\Data\output\followup2\intermediaire\presence_enquete_filled_first, replace

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.3 - TRANSFERS
***_____________________________________________________________________________

clear

import excel "${main}\logistics\08_follow_up2\lycee_survey\presence_enquete_filled\ready\transfered.xlsx", firstrow

**CREATE UNIQUE STUDENT ID
egen id_cto_checked=concat(school_id num_elv)

** DROP EMPTY COLUMN
drop U

*surveyed
replace surveyed_3 = "0" if(regexm(surveyed_3, "non"))
replace surveyed_3 = "0" if(regexm(surveyed_3, "refus"))
replace surveyed_3 = "0" if(regexm(surveyed_3, "X"))
replace surveyed_3 = "1" if(regexm(surveyed_3, "oui"))

*present
replace present_3 = "0" if(regexm(present_3, "non"))
replace present_3 = "1" if(regexm(present_3, "oui"))
replace present_3 = "0" if(regexm(present_3, "X"))
tab present_3

*changed_school 
replace changed_school_3 = "0" if(regexm(changed_school_3, "non"))
replace changed_school_3 = "1" if(regexm(changed_school_3, "oui"))
*tab changed_school_3

*abandon
replace abandon_3 = "0" if(regexm(abandon_3, "non"))
replace abandon_3 = "1" if(regexm(abandon_3, "oui"))
replace abandon_3 = "." if(regexm(abandon_3, "X"))
tab abandon_3

*passed_bac
replace passed_bac_3 = "0" if(regexm(passed_bac_3, "non"))
replace passed_bac_3 = "1" if(regexm(passed_bac_3, "oui"))
tab passed_bac_3

*left_conakry
replace left_conakry_3 = "0" if(regexm(left_conakry_3, "non"))
replace left_conakry_3 = "1" if(regexm(left_conakry_3, "oui"))
replace left_conakry_3 = "." if(regexm(left_conakry_3, "X"))
tab left_conakry_3

*left_guinea
replace left_guinea_3 = "0" if(regexm(left_guinea_3, "non"))
replace left_guinea_3 = "1" if(regexm(left_guinea_3, "oui"))
replace left_guinea_3 = "." if(regexm(left_guinea_3, "X"))
tab left_guinea_3

destring surveyed_3, replace
destring present_3, replace
destring abandon_3, replace
destring passed_bac_3, replace
destring left_conakry_3, replace
destring left_guinea_3, replace


la def yesno 0 "no" 1 "yes"
la val surveyed_3 present_3 abandon_3 passed_bac_3 left_conakry_3 left_guinea_3 yesno

save ${main}\Data\output\followup2\intermediaire\presence_enquete_transfered, replace

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.4 		 MERGING FIRST AND SECOND VISITS
***_____________________________________________________________________________
clear

use ${main}\Data\output\followup2\intermediaire\presence_enquete_filled_first

merge m:m id_cto_checked using "${main}\Data\output\followup2\intermediaire\presence_enquete_filled_second"

*id_cto_checked:91546051 - student 51 from Pellal International only in using
*I probably printed the file for the first visit leaving him out as he is number 51
*that's why he is only in the second visit files.

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.5 	 MERGING WITH TRANSFERS
***_____________________________________________________________________________

drop _merge

merge m:m id_cto_checked using "${main}\Data\output\followup2\intermediaire\presence_enquete_transfered", force

/*    
    Result                           # of obs.
    -----------------------------------------
    not matched                         6,019
        from master                     6,019  (_merge=
> =1)
        from using                          0  (_merge=
> =2)

    matched                                40  (_merge=
> =3)
    -----------------------------------------
*/

*drop empty line
drop if _merge==2

*** CREATE SURVEYED VAR
/*
tab surveyed_2 surveyed

           |       surveyed
surveyed_2 |        no        yes |     Total
-----------+----------------------+----------
        no |       158          1 |       159 
       yes |       205          7 |       212 
-----------+----------------------+----------
     Total |       363          8 |       371 

*/

gen surveyed_all = "."

*REPLACING BY YES FROM FIRST VISIT

replace surveyed_all = "1" if surveyed==1

*REPLACING BY YES FROM SECOND VISIT

replace surveyed_all = "1" if surveyed_2==1

**REPLACING BY YES FROM TRANSFERS

replace surveyed_all = "1" if surveyed_3==1

*REPLACING MISSING BY 0
replace surveyed_all = "0" if surveyed_all=="."

tab surveyed_all

/*
surveyed_al |
          l |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      3,687       60.85       60.85
          1 |      2,372       39.15      100.00
------------+-----------------------------------
      Total |      6,059      100.00
*/

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.6 - STUDENTS WITH UNCLEAR STATUS ON THE FILES
***_____________________________________________________________________________

*Student 34 from Grande Ecole, surveyed
replace surveyed=1 if id_cto_checked=="91535234"
replace surveyed_all="1" if id_cto_checked=="91535234"

*Student 42 from Lycee Lambandji, surveyed
replace surveyed=1 if id_cto_checked=="91508742"
replace surveyed_all="1" if id_cto_checked=="91508742"

*Student 16 from Safiatou Bah, surveyed
replace surveyed=1 if id_cto_checked=="91418716"
replace surveyed_all="1" if id_cto_checked=="91418716"

*DUPLICATES
duplicates list id_cto_checked

drop if _n==4940 
drop if _n==166



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.7 - CLEANING
***_____________________________________________________________________________

label variable date_fu2 "Date of the school survey (first visit)."
note date_fu2 : "Date of the school survey (first visit)."

label variable enumerators "Name of the enumerators (first visit)."
note enumerators : "Name of the enumerators (first visit)."

label variable surveyed "Was this student surveyed at school? (first visit)"
note surveyed : "Was this student surveyed at school? (first visit)"
label values surveyed yesno

label variable present "Was this student present at school? (first visit)"
note present : "Was this student present at school? (first visit)"
label values surveyed yesno

label variable changed_school "Did this student change school? (first visit)"
note changed_school : "Did this student change school? (first visit)"

label variable abandon "Did this student quit school? (first visit)"
note abandon : "Did this student quit school? (first visit)"
label values abandon yesno

label variable passed_bac "Did this student graduate from high school last year? (first visit)"
note passed_bac : "Did this student graduate from high school last year? (first visit)"
label values passed_bac yesno

label variable left_conakry "Did this student leave Conakry? (first visit)"
note left_conakry : "Did this student leave Conakry? (first visit)"
label values left_conakry yesno

label variable left_guinea "Did this student leave Guinea? (first visit)"
note left_guinea : "Did this student leave Guinea? (first visit)"
label values left_guinea yesno

label variable current_country "In which country does he live now? (first visit)"
note current_country : "In which country does he live now? (first visit)"

label variable info_source "Who gave the previous information? (first visit)"
note info_source : "Who gave the previous information? (first visit)"
*label define source D "Administration member" E "classmate"
*label values info_source source

label variable tuition "Did the student ever struggle to pay tuition fees? (first visit)"
note tuition : "Did the student ever struggle to pay tuition fees? (first visit)"

label variable new_num "Does the student have a new phone number? (first visit)"
note new_num : "Does the student have a new phone number? (first visit)"

label variable comment "Comments made by the enumerators. (first visit)"
note comment : "Comments made by the enumerators. (first visit)"



label variable date_fu2_2 "Date of the second school survey."
note date_fu2_2 : "Date of the second school survey."

label variable enumerators_2 "Name of the enumerators for the second visit."
note enumerators_2 : "Name of the enumerators for the second visit."

label variable surveyed_2 "Was this student surveyed at school during the second visit?"
note surveyed_2 : "Was this student surveyed at school during the second visit?"
label values surveyed_2 yesno

label variable present_2 "Was this student present at school during the second visit?"
note present_2 : "Was this student present at school during the second visit?"
label values surveyed_2 yesno

label variable comment_2 "Comments made by the enumerators during the second visit."
note comment_2 : "Comments made by the enumerators during the second visit."

label variable info_source_2 "Who gave the previous information? (from the second visit)"
note info_source_2 : "Who gave the previous information? (from the second visit)"

label variable tuition_2 "Did the student ever struggle to pay tuition fees (second visit)?"
note tuition_2 : "Did the student ever struggle to pay tuition fees (second visit)?"



label variable date_fu2_3 "Date of the school survey (transfer)."
note date_fu2_3 : "Date of the school survey (student surveyed in a different school than his baseline school)."

label variable enumerators_3 "Name of the enumerators (transfer)."
note enumerators_3 : "Name of the enumerators (student surveyed in a different school than his baseline school)."

label variable surveyed_3 "Was this student surveyed at school (transfer)?"
note surveyed_3 : "Was this student surveyed at school (student surveyed in a different school than his baseline school)?"
label values surveyed_3 yesno

label variable present_3 "Was this student present at school (transfer)?"
note present_3 : "Was this student present at school (student surveyed in a different school than his baseline school)?"
label values surveyed_3 yesno

label variable changed_school_3 "Did this student change school (transfer)?"
note changed_school_3 : "Did this student change school (student surveyed in a different school than his baseline school)?"

label variable abandon_3 "Did this student quit school (transfer)?"
note abandon_3 : "Did this student quit school (student surveyed in a different school than his baseline school)?"
label values abandon_3 yesno

label variable passed_bac_3 "Did this student graduate from high school last year (transfer)?"
note passed_bac_3 : "Did this student graduate from high school last year (student surveyed in a different school than his baseline school)?"
label values passed_bac_3 yesno

label variable left_conakry_3 "Did this student leave Conakry (transfer)?"
note left_conakry_3 : "Did this student leave Conakry (student surveyed in a different school than his baseline school)?"
label values left_conakry_3 yesno

label variable left_guinea_3 "Did this student leave Guinea (transfer)?"
note left_guinea_3 : "Did this student leave Guinea (student surveyed in a different school than his baseline school)?"
label values left_guinea_3 yesno

label variable current_country_3 "In which country does he live now (transfer)?"
note current_country_3 : "In which country does he live now (student surveyed in a different school than his baseline school)?"

label variable info_source_3 "Who gave the previous information (transfer)?"
note info_source_3 : "Who gave the previous information (student surveyed in a different school than his baseline school)?"

label variable tuition_3 "Did the student ever struggle to pay tuition fees (transfer)?"
note tuition_3 : "Did the student ever struggle to pay tuition fees (student surveyed in a different school than his baseline school)?"

label variable new_num_3 "Does the student have a new phone number (transfer)?"
note new_num_3 : "Does the student have a new phone number (student surveyed in a different school than his baseline school)?"

label variable current_lycee "Name of the current high school of the student where he participated in the endline survey"
note current_lycee : "Name of the current high school of the student where he participated in the endline survey"

*Information source

gen id_info=info_source if info_source!="E" & info_source!="D"
label variable id_info "What is the ID number of the student who gave the previous information? (first visit)"
note id_info : "What is the ID number of the student who gave the previous information? (first visit)"
replace info_source="1" if id_info!=""
replace info_source="2" if info_source=="E"
replace info_source="3" if info_source=="D"
label define info_source 1"Another student from our sample" 2"Another student, not from our sample" 3"A member of the administration"
destring info_source, replace
label values info_source info_source

gen id_info_2=info_source_2 
label variable id_info_2 "What is the ID number of the student who gave the previous information? (second visit)"
note id_info_2 : "What is the ID number of the student who gave the previous information? (second visit)"
replace info_source_2=2 if !missing(id_info_2)
destring info_source_2, replace
label values info_source_2 info_source

replace info_source_3="2" if info_source_3=="E"
destring info_source_3, replace
label values info_source_3 info_source

*Transfer away from baseline school
gen transferred=.
replace transferred=1 if changed_school!="0"
replace transferred=0 if transferred==.

replace changed_school="" if changed_school=="0"
replace changed_school="" if changed_school=="1"

rename changed_school new_school

rename changed_school_3 transferred_3

label variable transferred "Did this student change school?"
note transferred : "Did this student change school?"
label values transferred yesno

label variable new_school "What is the name of the school where the student goes this year (endline)?"
note new_school : "What is the name of the school where the student goes this year (endline)"


*RENAMING VARIABLES 

local all_var 	new_school transferred transferred_3 date_fu2	enumerators	surveyed	present	abandon	passed_bac	left_conakry	left_guinea	current_country	 info_source	tuition	comment	new_num	date_fu2_2	enumerators_2	surveyed_2	present_2	comment_2	info_source_2	tuition_2	date_fu2_3	enumerators_3 	surveyed_3	present_3	abandon_3	passed_bac_3	left_conakry_3	left_guinea_3	current_country_3	info_source_3	tuition_3	current_lycee	new_num_3	surveyed_all	id_info id_info_2																																																																																																																																																																																																																																																																																																																																																																																						
foreach var of local all_var {
rename `var' `var'_sss
}

*ENUMERATORS' NAMES

gen enumerator_1=.
gen enumerator_2=.
*1: Adama
replace enumerator_1=1 if enumerators_sss=="ADAMA / JP"
replace enumerator_1=1 if enumerators_sss=="ADAMA / AMARA"
*2: JP
replace enumerator_2=2 if enumerators_sss=="ADAMA / JP"
*3: Mohamed
replace enumerator_1=3 if enumerators_sss=="MOHAMED / MOUSSA"
replace enumerator_1=3 if enumerators_sss=="MOHAMED/ MOUSSA"
*4: Moussa
replace enumerator_2=4 if enumerators_sss=="MOHAMED / MOUSSA"
replace enumerator_2=4 if enumerators_sss=="MOHAMED/ MOUSSA"
*5: Amara
replace enumerator_2=5 if enumerators_sss=="ADAMA / AMARA"

label variable enumerator_1 "Enumerator 1 - Endline"
label variable enumerator_2 "Enumerator 2 - Endline"
label define enumerators_endline 1 "Adama" 2 "Jean-Pierre" 3 "Mohamed" 4 "Moussa" 5 "Amara"
label values enumerator_2 enumerators_endline
label values enumerator_1 enumerators_endline

destring surveyed_all_sss, replace
label variable surveyed_all_sss "Was this student surveyed at school (during any of the visits)?"
note surveyed_all_sss : "Was this student surveyed at school (during any of the visits)?"
label values surveyed_all_sss yesno

***SAVING DATA SET WITH BOTH FIRST, SECOND VISITS AND TRANSFERS PAPER QUESTIONNAIRES
drop _merge 

save ${main}\Data\output\followup2\intermediaire\presence_enquete_filled_all, replace




/////////////////////////////////////////////////////////////////////////////
/////////      			2 - PHONE ENUMERATORS FILES				/////////////////
/////////////////////////////////////////////////////////////////////////////


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2.1 - COMMENT SECTION
***_____________________________________________________________________________

clear
import excel "${main}\Data\correction_file\correction_followup2\phone_survey\comment_section_phone_files.xlsx", firstrow

*replace outside_conakry_pf=0 if outside_conakry_pf==.
*replace abroad_pf=0 if abroad_pf==.

label variable outside_conakry_pf "Did the student leave Conakry (according to contacts or classmates)?"
note outside_conakry_pf : "Did the student leave Conakry (according to contacts or classmates)?"
label values outside_conakry_pf yesno

label variable abroad_pf "Did the student leave Guinea (according to contacts or classmates)?"
note abroad_pf : "Did the student leave Guinea (according to contacts or classmates)?"
label values abroad_pf yesno

label variable country_pf "In which country is the student (according to contacts or classmates)?"
note country_pf : "In which country is the student (according to contacts or classmates)?"

label variable comment_pf "Comments given by phone by contacts or classmates."
note comment_pf : "Comments given by phone by contacts or classmates."

label variable irregular_mig_pf "Did the student leave Guinea irregularly (according to contacts or classmates)?"
note irregular_mig_pf : "Did the student leave Guinea irregularly (according to contacts or classmates)?"
label values irregular_mig_pf yesno

label variable continent_pf "In which continent is the student (according to contacts or classmates)?"
note continent_pf : "In which continent is the student (according to contacts or classmates)?"

label variable num_elv "Id within school"
note num_elv : "Id within school"

destring id_number, replace

save ${main}\Data\output\followup2\intermediaire\phone_files, replace

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2.2 - RESULTS OF THE CALLS
***_____________________________________________________________________________

clear
import excel "${main}\Data\correction_file\correction_followup2\phone_survey\phone_files.xlsx", firstrow

label variable date_first_call_pf "What is the day of the first call made to the student?"
note date_first_call_pf : "What is the day of the first call made to the student?"

label variable result_first_call_pf "What was the result of the first call made to the student?"
note result_first_call_pf : "What was the result of the first call made to the student?"
label define result_call 1 "Phone on but did not pick up" 2 "Phone off" 3 "No signal" 4 "Answered" 5 "Wrong number"
label values result_first_call_pf result_call

label variable phone_on_pf "Was the student's phone ever turned on?"
note phone_on_pf : "Was the student's phone ever turned on?"
la def yesno 0 "no" 1 "yes"
label values phone_on_pf yesno

label variable date_last_call_pf "What is the day of the last call made to the student?"
note date_last_call_pf : "What is the day of the last call made to the student?"

label variable enumerator_pf "Name of the phone enumerator."
note enumerator_pf : "Name of the phone enumerator."
label define enumerator 1 "Mariam" 2 "M'Mahawa" 3 "Marie-Claire" 4 "Iffono" 5 "Ousmane" 6 "Bangaly" 7 "Saran"
label values enumerator_pf enumerator

label variable comment_pf2 "Comments about the work of the phone enumerators."
note comment_pf2 : "Comments about the work of the phone enumerators."

*Merging with the comment sections
merge 1:1 id_number using ${main}\Data\output\followup2\intermediaire\phone_files, force

tab abroad_pf abroad_pf2
drop abroad_pf2

replace comment_pf="DIED" if comment_pf2=="died"
replace country_pf="ITALY" if comment_pf2=="ITALY"
replace comment_pf2="" if comment_pf2=="ITALY"
replace comment_pf2="" if comment_pf2=="died"

drop _merge

*Saving whole phone enumerators' files

save ${main}\Data\output\followup2\intermediaire\phone_files, replace

