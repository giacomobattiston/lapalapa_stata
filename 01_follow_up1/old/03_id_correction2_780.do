/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*   TITLE      :    03 - CHECKING THE IDENTIFICATION NUMBERS
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*
********************************************************************************/
/*04_id_correction
Date Created:  June 5, 2019
Date Last Modified: May 24, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: "output\midline\questionnaire_midline_clean.dta"
			"output\baseline\questionnaire_baseline_clean_rigourous_cleaning.dta"
			"output\baseline\identification.dta"
			
*   Outputs: "output\midline\questionnaire_midline_clean.dta"
			 "output\baseline\questionnaire_baseline_final_cleaning.dta"

The aim of this dofile is to check if the identification number associated with
the student is reliable. This is done by comparing the information given during 
the baseline and during the midline.
I create a dataset with the students for which we have no signal that the
identification has been well done. 
Then we have to call all of them to include the correction.
*/




***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - Parameters                                               
***_____________________________________________________________________________
clear all
set more off
pause on


*Lucia User
*global user "C:\Users\CornoL"

*Giacomo User
*global user "C:\Users\BattistonG"

*Cloe User
global user "C:\Users\cloes_000"


global main "$user/Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - CREATING THE DATASET
***_____________________________________________________________________________
*I merge the data with the current identification number and then
*I check if the data match

* merging identification database and midline data
use"$main\output\baseline\identification.dta"
rename key key_base 
keep id_number schoolid key_base
tempfile id
save `id'


*merging midline data and the identification dataset
use "$main\output\midline\questionnaire_midline_clean.dta",clear
rename key key_mid
destring id_number,replace
merge 1:1 id_number using  "`id'"

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

tempfile id_midline
save `id_midline'

*appending the baseline data
use "$main\output\baseline\questionnaire_baseline_clean_rigourous_cleaning.dta", clear
rename key key_base
merge 1:1 key_base using "`id'"

/*Result                           # of obs.
    -----------------------------------------
    not matched                             1
        from master                         1  (_merge==1)
        from using                          0  (_merge==2)

    matched                             7,398  (_merge==3)
    -----------------------------------------
_merge==1 corresponds to the student that had a wrong lycee_name, whose obseratoin has been 
deleted for the balance check but that we manage to find durnig the information session.
WHAT DO WE DO OF THIS INFORMATION ?
*/
drop _merge
gen time=0 // in order to specify that those are baseline data


* appending
append using "`id_midline'"
tempfile base_midline
save `base_midline'



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - ID MATCHES
***_____________________________________________________________________________
*this part aims at finding the matches

*cleaning of phone number
duplicates tag id_number, gen(mid_participant)
replace  sec0_q6="" if sec0_q6=="Don't know/Don't know want to answer"

*keeping the participants of the midline survey
keep if mid_participant!=0
xtset id_number time



***   a. - same phone number between midline and baseline                                              
***_____________________________________________________________________________
*3450 students with the same id have the same phone number between the baseline 
*and the midline
gen same_phone=sec0_q6[_n]==sec0_q6[_n+1] & sec0_q6[_n+1]!="" & time==0 
tab same_phone

replace same_phone=1 if same_phone[_n-1]==1 & time==1
drop if same_phone==1


***   b. - same mail adress forthe midline and the baseline without phone number
***_____________________________________________________________________________
gen same_mail=sec0_q6_mail[_n]==sec0_q6_mail[_n+1] & sec0_q6_mail[_n+1]!="" & sec0_q6_mail!="Don't know" & time==0 & substr(sec0_q6_mail,1,1)!="6"
tab same_mail // 69

replace same_mail=1 if same_mail[_n-1]==1 & time==1
drop if same_mail==1


***   c. - the 3 phone number of the midline are the 3 phone numbers given during the baseline             
***_______________________________________________
*keeping the obs when all the 3 phone numbers are not missing
gen missing=1 if (sec0_q6=="" | phone_contact1=="" | phone_contact2=="") & time==0
gen missing2=1 if (sec0_q6=="" | phone_contact1=="" | phone_contact2=="") & time==1
replace missing=1 if missing[_n-1]==1 & time==1
replace missing2=1 if missing2[_n+1]==1 & time==0
replace missing=1 if missing2==1
drop missing2


gen crit1=1 if  missing!=1 & ( (sec0_q6[_n]==phone_contact1[_n+1] & time==0 ) |(sec0_q6[_n]==phone_contact2[_n+1] & time==0))

gen crit2=1 if missing!=1 & ((phone_contact1[_n]==phone_contact1[_n+1] & time==0) | (phone_contact1[_n]==sec0_q6[_n+1] & time==0) | (phone_contact1[_n]==phone_contact2[_n+1] & time==0))

gen crit3=1 if  missing!=1 & ((phone_contact2[_n]==phone_contact2[_n+1] & time==0) | (phone_contact2[_n]==sec0_q6[_n+1] & time==0) | (phone_contact2[_n]==phone_contact1[_n+1] & time==0) )

gen match3=1 if  crit1==1 & crit2==1 & crit3==1 // 42 matches

replace match3=1 if match3[_n-1]==1 & time==1
drop if match3==1


/*
***   c._bis - when the 3 phone number are different and the 3 phone number of the midline are the 3 phone number given in the baseline             
***_______________________________________________
*keeping the ob when all the 3 phone number are not missing
gen missing=1 if (sec0_q6=="" | phone_contact1=="" | phone_contact2=="") & time==0
gen missing2=1 if (sec0_q6=="" | phone_contact1=="" | phone_contact2=="") & time==1
replace missing=1 if missing[_n-1]==1 & time==1
replace missing2=1 if missing2[_n+1]==1 & time==0
replace missing=1 if missing2==1

*at least one of the phone number given in the baseline is the same
gen repeatition=1 if (sec0_q6==phone_contact1 | sec0_q6==phone_contact2 | phone_contact1==phone_contact2) & time==0
gen repeatition2=1 if (sec0_q6==phone_contact1 | sec0_q6==phone_contact2 | phone_contact1==phone_contact2) & time==1
replace repeatition=1 if repeatition[_n-1]==1 & time==1
replace repeatition2=1 if repeatition2[_n+1]==1 & time==0
gen excluded=1 if repeatition==1 | repeatition2==1 | missing==1


gen crit1=1 if  excluded!=1 & ( (sec0_q6[_n]==phone_contact1[_n+1] & time==0 ) |(sec0_q6[_n]==phone_contact2[_n+1] & time==0))

gen crit2=1 if excluded!=1 & ((phone_contact1[_n]==phone_contact1[_n+1] & time==0) | (phone_contact1[_n]==sec0_q6[_n+1] & time==0) | (phone_contact1[_n]==phone_contact2[_n+1] & time==0))

gen crit3=1 if  excluded!=1 & ((phone_contact2[_n]==phone_contact2[_n+1] & time==0) | (phone_contact2[_n]==sec0_q6[_n+1] & time==0) | (phone_contact2[_n]==phone_contact1[_n+1] & time==0) )

gen match_check3_bis=1 if  crit1==1 & crit2==1 & crit3==1 //9
 
replace match_check3_bis=1 if match_check3[_n-1]==1 & time==1 
drop if match_check3_bis==1

*/

tempfile check
save `check'






***   d. - same phone number between the midline and the sensibiliation
***_____________________________________________________________________________

import excel "$main\raw\midline\participation_elv.xlsx", firstrow clear
keep key tel2
rename key key_base
tempfile participation
save `participation'

merge 1:m key_base using `check'
keep if _merge==3

xtset id_number time
gen same_phone_sensi=tel2[_n]==sec0_q6[_n+1] & sec0_q6[_n+1]!="" & time==0
tab same_phone_sensi //*59

replace same_phone_sensi=1 if same_phone_sensi[_n-1]==1 & time==1
drop if same_phone_sensi==1


/// CONCLUSION ///
*890 non matched data
*we have already called 110 of them
*sttil 780 students to call



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - CREATING THE DATASET TO CALL THE STUDENTS
***_____________________________________________________________________________


*preserve
sort id_number
order time	sec0_q6	id_number	lycee_name_str
gen tel=sec0_q6[_n+1] if time==0
replace key_mid=key_mid[_n+1] if time==0
keep if time==0
keep id_number key_mid key_base lycee_name_str sec0_q1_a sec0_q1_b	sec0_q2	sec0_q3	sec0_q4	sec0_q5_a	sec0_q5_b tel	sec0_q6_mail	name_contact1	phone_contact1	name_contact2	phone_contact2
export excel using "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Logistics\03_data\04_correction_file\check2.xls", replace firstrow(var)
tempfile final_check
save `final_check'


import excel "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Logistics\03_data\04_correction_file\not_matched_correction1.xlsx", clear firstrow
drop if key_mid=="" | key_mid=="key_mid"
tempfile correction1
save `correction1'

use "`final_check'"
merge 1:1 key_mid using "`correction1'",force


drop if bonid_number!=""
keep id_number key_mid lycee_name_str sec0_q1_a sec0_q1_b	sec0_q2	sec0_q3	sec0_q4	sec0_q5_a	sec0_q5_b tel	sec0_q6_mail	name_contact1	phone_contact1	name_contact2	phone_contact2
order id_number key_mid lycee_name_str sec0_q1_a sec0_q1_b	sec0_q2	sec0_q3	sec0_q4	sec0_q5_a	sec0_q5_b tel	sec0_q6_mail	name_contact1	phone_contact1	name_contact2	phone_contact2
sort lycee_name_str id_number
export excel using "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Logistics\03_data\04_correction_file\check2.xls", replace firstrow(var)

*restore



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3 - CORRECTION
***_____________________________________________________________________________
/*
We are currently trying to call all of those students in Logistics\03_data\04_correction_file\not_matched correction1*/
use "$main\output\analysis\guinea_final_dataset.dta", clear

*type of error 1 : Inversion of id_number
replace id_number=91401127 if key_mid=="uuid:cc4e2e92-1943-4d00-bc20-c00824e67368" & time==1
replace id_number=91533220 if key_mid=="uuid:66a24683-fd05-4e63-ae9f-bf1c51cbf13a" & time==1
replace id_number=91502145 if key_mid=="uuid:c92283ee-3469-4033-bbd5-b400059c2ebb" & time==1
replace id_number=91499417 if key_mid=="uuid:da7c23ff-74b6-411a-b323-99a8c22ef225" & time==1
replace id_number=91101444 if key_mid=="uuid:6b84e1ed-3d8a-4918-aabf-21abf826b7d1" & time==1
replace id_number=91443331 if key_mid=="uuid:af663139-7a0e-494e-9071-8b83ccc6dea2" & time==1
replace id_number=91413931 if key_mid=="uuid:155aaf22-cab4-42a0-9f90-755471d78e7c" & time==1


*type of error 2 : Those students were not selected but did the midline survey.
#delimit ; 
drop if key_mid=="uuid:b052176c-adfa-4aa9-96c9-0bddea01198c" |
key_mid=="uuid:0a93687c-462b-4b23-ad94-200a4e08f6e4" |
key_mid=="uuid:43a2ac12-9051-4092-a148-edd46b9954eb" |
key_mid=="uuid:401f9a40-ac5b-4a6a-8a26-6d22fbd65e7d" |
key_mid=="uuid:43a2ac12-9051-4092-a148-edd46b9954eb" |
key_mid=="uuid:3635d6c8-c8cb-4622-af24-059e9b9eea2a" |
key_mid=="uuid:4532416b-bc21-4a5a-8072-d4f23164dac6" |
key_mid=="uuid:0883f75d-dc42-4780-9dab-0d08ef4f0481" |
key_mid=="uuid:bd5713de-eed6-41b2-b12a-0a0431bd8d48" |
key_mid=="uuid:1acec795-fb11-4d56-8172-f13c0a28a56e" |
key_mid=="uuid:4023e4ca-3faf-4b7a-a4fe-14312a74c5fb" |
key_mid=="uuid:8c1423ac-f418-4607-8170-c6d47787dcc4" |
key_mid=="uuid:f1bd337b-96e4-43ad-b97f-06c630151e3a" |
key_mid=="uuid:a68ffaa3-c9e0-4481-8c40-de4677465bf8" |
key_mid=="uuid:609ed825-bd14-4182-8aa3-d407f282666c" |
key_mid=="uuid:a7e4b724-bb37-4424-bfee-33c70432fd78" |
key_mid=="uuid:0d59d0d4-37aa-4639-a832-3ed17d795503" |
key_mid=="uuid:3551a211-06e1-4ceb-b241-b8d78f3f8d6c" |
key_mid=="uuid:0883f75d-dc42-4780-9dab-0d08ef4f0481" |
key_mid=="uuid:51588b7c-286d-4fd4-a179-24195c4362e3" |
key_mid=="uuid:b85ae82e-bb86-488b-995d-b8118bb37e62" |
key_mid=="uuid:6c81638a-ca18-4e52-a7f8-81f9c1697e4a" |
key_mid=="uuid:53b9cc43-4eae-47cf-906a-d4a9ab056fd8" ;

#delimit cr

/*type of pb 3 : those students do not have the good id_number
since another student that we manage to call told us that name 
and surname*/
replace id_number=11 if key_mid=="uuid:89ad35b5-4f67-43fa-812f-ab89b68580ec" 




