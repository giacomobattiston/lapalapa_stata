/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*   TITLE      :    05 - CREATING ID NUMBER :
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*
********************************************************************************/
/* BE CAREFULL THE IDENTIFICATION DATABASE IS NOT REPRODUCTIBLE 
BY RUNNING THIS FILE YOU WILL NOT FIND THE CURRENT DATABASE BECAUSE THE STUDENT
ID CHANGE EVERY TIME YOU RUN THE CODE 

clear all

set more off
pause on

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - Parameters                                               
***_____________________________________________________________________________

*Lucia User
*global main "C:\Users\CornoL\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"

*Giacomo User
*global main "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo/Data"
*global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"

*Cloe User
global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - Importing the data                                               
***_____________________________________________________________________________

*merging with treatment status
import excel using "$main/output/randomization/final_randomization/assignment.xls", clear
keep A AB
rename AB treatment
rename A CODE

merge 1:1 CODE using "$main/output/admin/admin_data"
assert _merge==3 // OK
drop _merge
keep N CODE NOM_ETABLISSEMENT etab_quest etab treatment
rename etab_quest lycee_name_string

*merging with student questionnaire
merge 1:m lycee_name_string using "$main/output/baseline/questionnaire_baseline_clean_rigourous_cleaning.dta", keepusing(key lycee_name lycee_name_string sec0_q1_a sec0_q1_b commune sec0_q4 sec0_q5_a sec0_q5_b)
assert _merge==3 //OK

drop _merge


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   Cleaning                                           
***_____________________________________________________________________________
rename CODE schoolid
label var schoolid "id school number"

rename sec0_q1_a sec0_q1_a_baseline
rename sec0_q1_b sec0_q1_b_baseline

replace sec0_q1_a_baseline=trim(sec0_q1_a_baseline)
replace sec0_q1_b_baseline=trim(sec0_q1_b_baseline)



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - Identification number with school id                                               
***_____________________________________________________________________________
/*the process of associating each student to a number has been done without this
 student because the name of their lycee was wrong.
we finally found them suring the information session and included them in the baseline database them
*/

sort schoolid sec0_q4 sec0_q5_a sec0_q5_b
bys schoolid : gen id_elv=_n


tostring schoolid, gen(schoolid_str)
tostring id_elv, gen(id_elv_str)
gen id_number_str=schoolid_str+id_elv_str
destring id_number_str,gen(id_number)

keep schoolid_str schoolid id_elv id_elv_str id_number id_number_str key lycee_name_string commune sec0_q1_a_baseline sec0_q1_b_baseline treatment sec0_q4 sec0_q5_a sec0_q5_b
order schoolid_str schoolid id_elv id_elv_str id_number id_number_str key lycee_name_string commune sec0_q1_a_baseline sec0_q1_b_baseline treatment sec0_q4 sec0_q5_a sec0_q5_b


*save "$main/output/baseline/_old/identification_non_corrected.dta", replace


