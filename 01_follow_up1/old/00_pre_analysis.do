
/*midline_merge
Date Created:  April 16, 2019
Date Last Modified: April 16, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: .dta file(s) "C:/Users/cloes_000/Documents/RA-Guinee/Lapa Lapa/logistics/03_data/04_final_data/data/questionnaire_midline_imported.xlsx"
*	Outputs: "C:/Users/cloes_000/Documents/RA-Guinee/Lapa Lapa/logistics/03_data/04_final_data/data/guinea_questionnaire.dta"
*
*/


* initialize Stata
clear all
set more off
set mem 100m


*Cloe user
global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

********************************************************************************
//,\\'//,\\'//,\\'//,\\            CHECKS             //,\\'//,\\'//,\\'//,\\'
********************************************************************************

import delimited C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\raw\midline\guinea_midline_questionnaire_WIDE.csv
rename id_cto_checked id_number

drop if id_number==.
duplicates tag id_number, gen(dup)

browse if dup==1
drop if dup==1 /*NEED TO CHECK THOSE 6 ERRORS! */

rename * *_mid
rename id_number_mid id_number
save "$main\Data\output\midline\questionnaire_midline_imported.dta",replace


********************************************************************************
//,\\'//,\\'//,\\'//,\\           merging            //,\\'//,\\'//,\\'//,\\'
********************************************************************************
*with the identification.dtafile*
merge 1:1 id_number using "$main\Data\output\baseline\identification.dta", force
keep if _merge==3
drop _merge


*with the baseline.questionnaire*
merge 1:1 key using "$main\Data\output\baseline\questionnaire_baseline_clean_rigourous_cleaning.dta", force
keep if _merge==3
drop _merge



********************************************************************************
//,\\'//,\\'//,\\'//,\\         SOME ANALYSIS          //,\\'//,\\'//,\\'//,\\'
********************************************************************************

*changes in road selection

gen road_selection_mid=sec3_31_bis_mid if sec3_23_mid!=5
replace road_selection_mid=sec3_22_mid if sec3_23_mid==5 | sec3_23_mid==.
label variable	road_selection_mid "Road selection : Which road would he/she select to go to sec3_21 ?"
note road_selection_mid : "Which road would he/she select to go to sec3_21 ?"
label define road_selection_mid 1 "Take a boat to ITALY." 2 "Take a boat to Spain." 3 "Climb over the fence of ceuta or MELILLA."
label values road_selection_mid road_selection_mid


gen change_road=1 if road_selection_mid!=road_selection
replace change_road=0 if road_selection_mid==road_selection


*change in road selection : ceuta
gen change_to_ceuta=1 if road_selection_mid!=road_selection & road_selection_mid==3
replace change_to_ceuta=0 if road_selection_mid==road_selection | road_selection_mid!=3

tab change_to_ceuta


*change in road selection : italy
gen change_to_italy=1 if road_selection_mid!=road_selection & road_selection_mid==1
replace change_to_italy=0 if road_selection_mid==road_selection | road_selection_mid!=1

tab change_to_italy


*change in road selection : spain
gen change_to_spain=1 if road_selection_mid!=road_selection & road_selection_mid==2
replace change_to_spain=0 if road_selection_mid==road_selection | road_selection_mid!=2

tab change_to_spain



********************************************************************************
//,\\'//,\\'//,\\'//,\\         SOME ANALYSIS          //,\\'//,\\'//,\\'//,\\'
********************************************************************************
gen treated=1 if treatment_mid!=1
replace treated=0 if treatment_mid==1
