/*******************************************************************************
*
*   PROJET     :    INFORMING RISKY MIGRATION  
*					2018
*				
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   TITRE      :    05 - Identification -Correction error lycee name
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*
********************************************************************************/
/* BE CAREFULL THE CURRENT IDENTIFICATION DATABASE IS NOT REPRODUCTIBLE !! YOU WILL NOT FIND THE
CURRENT IDENTIFICATION DATABASE BY RUNNING THIS CODE...
EXPLANATION
some students have mispecified the name of their lycee during the baseline.
some where called and we deleted the data of the 11 students with a wrong lycee name.
Those observation have been removed from the dataset questionnaire_cleaned and they have not been used for randomization
But thank to the sensibilisation we can correct two of them.

clear all

set more off
pause on

***Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯
***   0 - Parameters                                               
***_____________________________________________________________________________


*Cloe User
global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"


use "$main/output\baseline\_old\identification_non_corrected.dta", clear


***Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â
***   1 -FIRST CASE                                      
***_____________________________________________________________________________


*"uuid:cf8a4a12-196a-4107-9b50-e433ca98ca9c" is not in the database because 
*we knew that the lycee name was wrong but did not manage to identify the right lycee.

local new= _N+2
set obs `new'
replace key="uuid:cf8a4a12-196a-4107-9b50-e433ca98ca9c" in 7399
replace lycee_name_string="ABDOUL MAZID DIABY" in 7399
replace commune=5 in 7399
replace sec0_q1_a="adama oury" in 7399
replace sec0_q1_b="diallo" in 7399
replace sec0_q4=5 in 7399
replace sec0_q5_a=3 in 7399
replace sec0_q5_b="1" in 7399
replace schoolid=915083 in 7399
replace schoolid_str="915083" in 7399
replace id_elv=50 in 7399
replace id_elv_str="50" in 7399
replace id_number=91508350 in 7399
replace id_number_str="91508350" in 7399
replace treatment_status=4 in 7399


***Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â¯Â
***   2- SECOND CASE                                      
***_____________________________________________________________________________


*the observation with the key=="uuid:522d727d-65f9-4040-bf8d-7fb1b44cc92d" is not associated with the right lycee name
drop if key=="uuid:522d727d-65f9-4040-bf8d-7fb1b44cc92d"
replace key="uuid:522d727d-65f9-4040-bf8d-7fb1b44cc92d" in 7399
replace lycee_name_string="HAMAS" in 7399
replace commune=5 in 7399
replace sec0_q1_a="gabriel" in 7399
replace sec0_q1_b="kamano" in 7399
replace sec0_q4=7 in 7399
replace sec0_q5_a=3 in 7399
replace sec0_q5_b="1" in 7399
replace schoolid=915355 in 7399
replace schoolid_str="915355" in 7399
replace id_elv=51 in 7399
replace id_elv_str="51" in 7399
replace id_number=91535551 in 7399
replace id_number_str="91535551" in 7399
replace treatment_status=3 in 7399


save "$main/output/baseline/_old/identification.dta", replace
cfout key using "$main/output/baseline/_old/identification_non_corrected.dta", id(id_number)
/*

note: the following observations are only in the master data:

  +-----------+
  | id_number |
  |-----------|
  |  91508350 |
  |  91535551 |
  +-----------+

note: the following observations are only in the using data:

  +-----------+
  | id_number |
  |-----------|
  |  91527044 |
  +-----------+


  -------------------------------
  Number of differences: 0
  Number of values compared: 7397
  Percent differences: 0.000%
  -------------------------------


    =====> there is no difference with the initial dataset except the 2
modifications that we've jsut done.

*/
save "$main/output/baseline/identification.dta", replace

