clear all
set more off

/*This do_file identifies all the duplicates and mismatches in the surveys 
(wrong id or wrong school name entered by the enumerators) by comparing the 
surveys imported from SurveyCTO and the paper files used by the enumerators 
to say which students they surveyed and on which day.
*/
global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"


/////////////////////////////////////////////////////////////////////////////
/////////      					 LYCEE						/////////////////
/////////////////////////////////////////////////////////////////////////////

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - DUPLICATES IN SURVEYCTO
***_____________________________________________________________________________

use ${main}\Data\dta\guinea_endline_lycee_raw

duplicates tag id_cto_checked, gen(dupCTO2)
*tab dupCTO2

/*
    dupCTO2 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      2,356       97.52       97.52
          1 |         48        1.99       99.50
          2 |         12        0.50      100.00
------------+-----------------------------------
      Total |      2,416      100.00

For details, see duplicates_lycee in 
"C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\correction_file\correction_followup2"
*/
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - MERGING SURVEYCTO DATA AND PAPER QUESTIONNAIRES
***_____________________________________________________________________________
clear
use ${main}\Data\output\followup2\intermediaire\presence_enquete_filled_all
drop _merge
merge m:m id_cto_checked using "${main}\Data\dta\guinea_endline_lycee_raw.dta", force

/* 
    Result                           # of obs.
    -----------------------------------------
    not matched                         3,728
        from master                     3,725  (_merg
> e==1)
        from using                          3  (_merg
> e==2)

    matched                             2,413  (_merg
> e==3)
    -----------------------------------------

*/

*save ${main}\Data\output\followup2\intermediaire\endline_lycee, replace


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3 - STUDENTS WHO HAVE A SURVEY WHEN THEY SHOULDNT / 
***			SHOULD HAVE HAVE ONE BUT DONT
***_____________________________________________________________________________

*use ${main}\Data\output\followup2\intermediaire\endline_lycee
destring surveycto, replace
destring surveyed_all, replace
keep if surveyed_all==1 & surveycto==0 | surveyed_all==0 & surveycto==1

*53
/*For details, see the excel file "mismatch_lycee" in 
*"C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\correction_file\correction_followup2"

*128 mismatches: 92 corrected, 36 remaining
*19 should have a survey but don't / 17 should not have a survey but do

*WRONG SCHOOL NAME: 72

*wrong_school_1: 42 students
6/6 Nelson Mandela Simbaya/Saint Denis 2 (12)
14 students to correct for Noumandian Keita (Abdoulaye Sangareah/Nelson Mandela Simbaya))
9 Nelson Mandela Simbaya (to match Noumandian Keita)
6 students to correct for Saint Denis 

*wrong_school_2: 22 students
9/9 Assiatou Bah/Santa Maria (18)
4 students to correct for Assiatou Bah

*wrong_school_3: 8 students
1/1 Kofi Annan/Salem
1/1 Abdoulaye Sangareah/El Ibrahima Bah
1/1 Cheick Cherif Sagale / Kelefa Diallo (2)
1/1 Hadja Ouma Diallo/Hadja Oumou

*WRONG ID: 17 students
2 Olusegun Obasanjo (2/21)
2 Kabassan Keita (46/47)
2 Jean Mermoz (24/49)
2 Hadja N'Nabitou Touré (48/6)
2 Hadja Fatou Diaby (18/41)
2 Hadja Aissata Drame (25/50)
2 Gnenouyah (43/5)
2 Dr Ibrahima Fofana (1/11)
1 Cam-Syl (25)

*UNCLEAR STATUS: 3
*/

save ${main}\Data\output\followup2\intermediaire\endline_lycee_mismatch, replace





/////////////////////////////////////////////////////////////////////////////
/////////      					 PHONE						/////////////////
/////////////////////////////////////////////////////////////////////////////
clear

use ${main}\Data\dta\guinea_endline_phone_raw

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - DUPLICATES
***_____________________________________________________________________________

duplicates tag id_cto subcon, gen(dup)

tab dup
/*
        dup |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |      5,153       94.19       94.19
          1 |        306        5.59       99.78
          2 |         12        0.22      100.00
------------+-----------------------------------
      Total |      5,471      100.00

85
*/
tab dup subcon

/*
           |        subcon
       dup |         1          2 |     Total
-----------+----------------------+----------
         0 |     4,835        318 |     5,153 
         1 |       280         26 |       306 
         2 |        12          0 |        12 
-----------+----------------------+----------
     Total |     5,127        344 |     5,471 

*/

*browse if dup!=0

rename id_cto id_number

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - MERGE WITH BASELINE TO CHECK WITH FICHIERS D'APPELS
***_____________________________________________________________________________

destring id_number, replace
merge m:1 id_number using "${main}\logistics\08_follow_up2\matching\dta\baseline_data.dta", force

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                         2,305
        from master                         2  (_merge=
> =1)
        from using                      2,303  (_merge=
> =2)

    matched                             5,469  (_merge=
> =3)
    -----------------------------------------
*/

** not matched from master -> surveycto survey does not correspond to any id_number from the baseline
browse if _merge==1

** not matched from using -> does not have a surveycto phone survey 
*either found in school / not found by phone / mismatch
keep if _merge==2

*keep starttime_date starttime_hour deviceid endtime_date endtime_hour id_number sec0_q1_a1 sec0_q61 sec0_q1_b1 name_contact11 phone_contact11 phone_contact21 class1 id_within_school1 lycee_name_str1 commune1 id_within_school0 class0 phone_contact20 name_contact20 phone_contact10 name_contact10 sec0_q60 sec0_q1_b0 sec0_q1_a0 commune0 lycee_name_str0

save ${main}\Data\output\followup2\intermediaire\no_phone_survey, replace


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3 - MERGING STUDENTS WITHOUT PHONE SURVEY WITH LYCEE SURVEYS
***_____________________________________________________________________________

*clear
*use \Data\output\followup2\intermediaire\not_matched_phone

rename id_number id_cto_checked
tostring id_cto_checked, replace
drop _merge
merge 1:m id_cto_checked using "${main}\Data\dta\guinea_endline_lycee_raw.dta", force

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                           602
        from master                       246  (_merge=
> =1)
        from using                        356  (_merge=
> =2)

    matched                             2,068  (_merge=
> =3)
    -----------------------------------------


*1: 246 not matched from master i.e. no phone survey AND no school survey
*are both students who were not found by phone and mismatches

*2: 356 not matched from using i.e. has school survey and a phone survey
 cf. 3.2)

*3: 2068 matched i.e. does not have a phone survey, but has a school survey -> ok

*/
save ${main}\Data\output\followup2\intermediaire\no_phone_survey_merged_lycee, replace

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3. 1) - NOT MATCHED FROM MASTER : 254
***_____________________________________________________________________________

*keeping only students who don't have any survey (neither phone nor school)
keep if _merge==1

*compare with fichier d'appels to see if they correspond to the students marked
*as not found by the phone team
*see "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\correction_file\correction_followup2\not_surveyed"

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3. 2) - NOT MATCHED FROM USING : 332
***_____________________________________________________________________________

*keeping only students who have both survey
keep if _merge==2
rename _merge _merge1

*compare with second visits to identify which students are supposed to have
*both a school and a phone survey (making sure the phone survey is before)

merge m:m id_cto_checked using "${main}\Data\output\followup2\intermediaire\presence_enquete_filled_second", force

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                           357
        from master                       157  (_merge=
> =1)
        from using                        200  (_merge=
> =2)

    matched                               199  (_merge=
> =3)
    -----------------------------------------
	
*1: not matched from master i.e. students who have both phone/school survey 
and did not participate in the second visits (as in appeared on the list)
*2: not matched from using i.e. students who participated in the second visits
and don't have both phone/school survey*/

tab surveyed_2 _merge 	
	
/*
           |        _merge
surveyed_2 | using onl  matched ( |     Total
-----------+----------------------+----------
        no |       159          4 |       163 
       yes |        24        195 |       219 
-----------+----------------------+----------
     Total |       183        199 |       382 
	
195 students have both phone/school survey because they were surveyed during 
a second visit.
157+5=162 come from mismatches.	
*/

keep if _merge==1

/*
There must be some of the 41 that I corrected, who were written as surveyed at 
school but had their survey registered under the wrong school. We could drop 
their phone survey now that we re-attached their school survey to their id.

14 phone surveys can be dropped because of that school_name error:
Student 49 from Cheick Cherif Sagale (obs 38)
All 12 students from Assiatou Bah (obs 86 to 97)
Student 3 from Santa Maria

Student 46 from Noumandian Keita is not one of the mismatch I corrected
None for Saint Denis because I corrected the file on the day they made the mistake

This leaves 109 student who have both a school and a phone survey for no reason.

ANSWER: We noticed that our code for making the phone files included all the students 
who had two surveys at school (duplicates). This explains why so many students 
have both a school survey and a phone survey.
*/


