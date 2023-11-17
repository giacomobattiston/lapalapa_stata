
/* verifying the correction files */

* initialize Stata
clear all
set more off
set mem 100m

********************************************************************************
//,\\'//,\\'//,\\'//,\\           PARAMETRES            //,\\'//,\\'//,\\'//,\\'
********************************************************************************
* chemins
global main "C:\Users\cloes_000\Documents\RA-Guinée\Lapa Lapa\logistics\03_data\04_final_data"

* fichiers de corrections *
local corrfile1 "$main/correction_file/unfinished_questionnaire_1.xlsx" // Les questionnaires non-finalisés 1
local corrfile2 "$main/correction_file/unfinished_questionnaire_2.xlsx" //Les questionnaires non-finalisés 2
local corrfile3 "$main/correction_file/unfinished_questionnaire_3.xlsx" //Les questionnaires non-finalisés 3
local nbcorr 1 2 3


********************************************************************************
//,\\'//,\\'//,\\'//,\\          Code           //,\\'//,\\'//,\\'//,\\'
********************************************************************************
*creating the file of corrections with the three excel files of correction
import excel using "`corrfile1'", firstrow clear
tempfile verif1
save `verif1', replace

import excel using "`corrfile2'", firstrow clear
tempfile verif2
save `verif2', replace

import excel using "`corrfile3'", firstrow clear
tempfile verif3
save `verif3', replace

use "`verif1'", clear
append using "`verif2'"
tempfile corrfile1_2
save `corrfile1_2', replace

use "`corrfile1_2'", clear
append using "`verif3'"

* keeping the first modification of each unfinished questionnaire to check 
*later if this corresponds to the question where the student stopped to answer
duplicates drop key, force
drop comments value
save "$main/correction_file/correction_file.dta",replace


/* comparing the first change that I have done and the question "where did the student stop to answer ?""
*in order to verify that I did all the needed changes */
use "$main\output\questionnaire_baseline_clean.dta", clear
keep finished key
rename finished fieldname

cfout * using "$main/correction_file/correction_file.dta", id(key) saving("$main/correction_file/diffV2")


/*this dataset allows me to compare the changes that I have done and the ones I should have done. */



/* is there some modification that I have not done ? */

use "$main\output\questionnaire_baseline_clean.dta", clear
keep finished key
keep if finished!=""
rename finished fieldname
merge 1:1 key using "$main/correction_file/correction_file.dta"
browse if _merge==1 | _merge==2

*there are five change that I have done because students enterred my secret code to the question "outside contact member". This is not because they did not finished the questionnaire, this is because they dd not know how many people they have abroad.
