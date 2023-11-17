/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*   TITLE      :    05 - CREATING ID NUMBER
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*
********************************************************************************/


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

use "$main/output/admin/admin_data", clear
keep N CODE NOM_ETABLISSEMENT etab_quest etab
rename etab_quest lycee_name_string

*merging with student questionnaire
merge 1:m lycee_name_string using "$main/output/baseline/questionnaire_baseline_clean_rigourous_cleaning.dta", keepusing(key lycee_name lycee_name_string sec0_q1_a sec0_q1_b commune sec0_q4 sec0_q5_a sec0_q5_b)
keep if _merge==3
drop _merge

/*
**correction error lycee name 
*correction obtained thanks to the sensibilisation (not by calling them)
*those observation had been removed from questionnaire_cleaned. and there have not been used for randomization
key="uuid:cf8a4a12-196a-4107-9b50-e433ca98ca9c" and key=="uuid:522d727d-65f9-4040-bf8d-7fb1b44cc92d" have the wrong lycee name */
drop if key=="uuid:cf8a4a12-196a-4107-9b50-e433ca98ca9c"
drop if key=="uuid:522d727d-65f9-4040-bf8d-7fb1b44cc92d"


local new= _N+2
set obs `new'
replace key="uuid:cf8a4a12-196a-4107-9b50-e433ca98ca9c" in 7398
replace lycee_name_string="ABDOUL MAZID DIABY" in 7398
replace commune=5 in 7398
replace CODE=915083 in 7398
replace N=257 in 7398
replace NOM_ETABLISSEMENT="G S ABDOUL MAJID DIABY" in 7398
replace etab="abdoul mazid diaby" in 7398
replace lycee_name=3 in 7398
replace sec0_q1_a="adama oury" in 7398
replace sec0_q1_b="diallo" in 7398
replace sec0_q4=5 in 7398
replace sec0_q5_a=3 in 7398
replace sec0_q5_b="1" in 7398

replace key="uuid:522d727d-65f9-4040-bf8d-7fb1b44cc92d" in 7399
replace lycee_name_string="HAMAS" in 7399
replace commune=5 in 7399
replace CODE=915355 in 7399
replace N=263 in 7399
replace NOM_ETABLISSEMENT="GS/ HADJA HAWA SACKO (HAMAS)" in 7399
replace etab="hamas" in 7399
replace lycee_name=67 in 7399
replace sec0_q1_a="gabriel" in 7399
replace sec0_q1_b="kamano" in 7399
replace sec0_q4=7 in 7399
replace sec0_q5_a=3 in 7399
replace sec0_q5_b="1" in 7399

*/

*merging with treatment status
merge m:1 CODE using "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\07_sensibilization\planning\sensi.dta",  keepusing(treatment CODE) 
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

sort schoolid sec0_q4 sec0_q5_a sec0_q5_b
bys schoolid : gen id_elv=_n


tostring schoolid, gen(schoolid_str)
tostring id_elv, gen(id_elv_str)
gen id_number_str=schoolid_str+id_elv_str
destring id_number_str,gen(id_number)

keep schoolid_str schoolid id_elv id_elv_str id_number id_number_str key lycee_name_string commune sec0_q1_a_baseline sec0_q1_b_baseline treatment sec0_q4 sec0_q5_a sec0_q5_b
order schoolid_str schoolid id_elv id_elv_str id_number id_number_str key lycee_name_string commune sec0_q1_a_baseline sec0_q1_b_baseline treatment sec0_q4 sec0_q5_a sec0_q5_b


save "$main/output/baseline/identification2.dta", replace


cfout key using "$main/output/baseline/identification.dta", id(id_number)


