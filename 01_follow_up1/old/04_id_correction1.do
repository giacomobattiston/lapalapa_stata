/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*   TITLE      :    04 - CHECKING THE ID NUMBER
*                   ____________________________________________________________
*                   ������������������������������������������������������������
*
********************************************************************************/
/*04_id_correction
Date Created:  June 5, 2019
Date Last Modified: May 24, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: "Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\output\analysis\guinea_final_dataset.dta"
*   Outputs : 

The aim of this dofile is to check if the identification number associated with
the student is reliable. This is done by comaring the information given during 
the baseline and during the midline.
I create a dataset with the students for which we have no signal that the
identification has been well done.
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


use "$main\output\analysis\guinea_final_dataset.dta", clear



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - ID MATCHES
***_____________________________________________________________________________
*this part aims at finding the matches


preserve
*cleaning of phone number
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



***   b. - student's tel number is the first contact phone number              
***_____________________________________________________________________________

*student's phone number of the midline is the first contact phone number of the baseline                                             
*58
gen phone_st_contact1=1 if sec0_q6[_n+1]==phone_contact1[_n] & time==0 & phone_contact1[_n]!=""
tab phone_st_contact1
replace phone_st_contact1=1 if phone_st_contact1[_n-1]==1 & time==1
drop if phone_st_contact1==1

*student's tel number of the baseline is the first contact phone number of the midline                                            
*79
gen phone_st_contact1_bis=1 if sec0_q6[_n]==phone_contact1[_n+1] & time==0 & phone_contact1[_n+1]!=""
tab phone_st_contact1_bis
replace phone_st_contact1_bis=1 if phone_st_contact1_bis[_n-1]==1 & time==1
drop if phone_st_contact1_bis==1






***   c. - student's tel number is the second contact phone number                
***_____________________________________________________________________________

*Student's tel number of the midline is the second contact phone number of the baseline                                             
gen phone_st_contact2=1 if sec0_q6[_n+1]==phone_contact2[_n] & time==0 & phone_contact2[_n]!=""
tab phone_st_contact2
replace phone_st_contact2=1 if phone_st_contact2[_n-1]==1 & time==1
*52
drop if phone_st_contact2==1

*student's tel number of the baseline is the second contact phone number of the midline                                            
*34
gen phone_st_contact2_bis=1 if sec0_q6[_n]==phone_contact2[_n+1] & time==0 & phone_contact2[_n+1]!=""
tab phone_st_contact2_bis
replace phone_st_contact2_bis=1 if phone_st_contact2_bis[_n-1]==1 & time==1
drop if phone_st_contact2_bis==1





***   d. - the first contact phone number of the baseline is the first contact phone number of the endline             
***_____________________________________________________________________________
gen same_contact1=1 if phone_contact1[_n+1]==phone_contact1[_n]  & time==0 & phone_contact1[_n]!="" 
*308
tab same_contact1
replace same_contact1=1 if same_contact1[_n-1]==1 & time==1
drop if same_contact1==1




***   e. - the second contact phone number of the baseline is the second contact phone number of the endline             
***_____________________________________________________________________________
gen same_contact2=1 if phone_contact2[_n+1]==phone_contact2[_n]  & time==0 & phone_contact2[_n]!="" 
tab same_contact2
*60
replace same_contact2=1 if same_contact2[_n-1]==1 & time==1
drop if same_contact2==1






***   f. - the second contact phone number of the baseline is the 
****   first contact phone number of the midline and the reverse          
***_____________________________________________________________________________
gen same_contact_inverted=1 if phone_contact1[_n+1]==phone_contact2[_n] | phone_contact2[_n+1]==phone_contact1[_n]  & time==0 & phone_contact2[_n]!=""  & phone_contact1[_n+1]!="" 
tab same_contact_inverted
*162
replace same_contact_inverted=1 if same_contact_inverted[_n-1]==1 & time==1
drop if same_contact_inverted==1





***   g. - same contact names forthe midline and the baseline 
***_____________________________________________________________________________
**cleaning
replace name_contact1=trim(name_contact1)
replace name_contact1=lower(name_contact1)
replace name_contact2=trim(name_contact2)
replace name_contact2=lower(name_contact2)

gen same_name_contact1=1 if name_contact1[_n+1]==name_contact1[_n]  & time==0 & name_contact1[_n]!="" 
tab same_name_contact1 //18
replace same_name_contact1=1 if same_name_contact1[_n-1]==1 & time==1
drop if same_name_contact1==1


gen same_name_contact2=1 if name_contact2[_n+1]==name_contact2[_n]  & time==0 & name_contact2[_n]!="" 
tab same_name_contact2 //9
replace same_name_contact2=1 if same_name_contact2[_n-1]==1 & time==1
drop if same_name_contact2==1


gen same_name_inverted=1 if time==0 & name_contact1[_n+1]==name_contact2[_n] | name_contact2[_n+1]==name_contact1[_n]  & time==0 & name_contact2[_n+1]!=""  & name_contact1[_n+1]!="" 
tab same_name_inverted // 14
replace same_name_inverted=1 if same_name_inverted[_n-1]==1 & time==1
drop if same_name_inverted==1



***   g. - same mail adress forthe midline and the baseline 
***_____________________________________________________________________________
gen same_mail=sec0_q6_mail[_n]==sec0_q6_mail[_n+1] & sec0_q6_mail[_n+1]!="" & & sec0_q6_mail!="Don't know" & time==0
tab same_mail // 20
replace same_mail=1 if same_mail[_n-1]==1 & time==1
drop if same_mail==1




***   h. - same phone number between the midline and the sensibiliation
***_____________________________________________________________________________
gen same_phone_sensi=tel2[_n]==sec0_q6[_n+1] & sec0_q6[_n+1]!="" & time==0
tab same_phone_sensi //*7
replace same_phone_sensi=1 if same_phone_sensi[_n-1]==1 & time==1
drop if same_phone_sensi==1



///////////////////////////////////////////////////////////////////////
////////////////////////////// CONCLUSION /////////////////////////////
///////////////////////////////////////////////////////////////////////
/*=>240 obs not matched
 GENERETING A DMUMMY FOR NON MATCHED OBSERVATIONS and keeping 
this variable in a file to merge it with the final dataset */

gen mismatch=1
keep id_number lycee_name_str time commune	sec0_q1_a	sec0_q1_b	sec0_q2	sec0_q3	sec0_q4	sec0_q5_a	sec0_q5_b	sec0_q6	sec0_q6_mail	name_contact1	phone_contact1	name_contact2	phone_contact2 mismatch key_mid sec0_q6 time mid_participant
tempfile mismatch
save `mismatch'

/* TABLET TO VISUALLY CHECK THE MATCHES
preserve
keep id_number key_mid lycee_name_str time commune	sec0_q1_a	sec0_q1_b	sec0_q2	sec0_q3	sec0_q4	sec0_q5_a	sec0_q5_b	sec0_q6	sec0_q6_mail	name_contact1	phone_contact1	name_contact2	phone_contact2
sort lycee_name_str id_number time
export excel using "$users/Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Logistics\03_data\04_correction_file\not_matched.xls", replace firstrow(var)
restore

*=> We can see 43 other matches by doing a visual comparison
*=>197 obs not matched
*/

restore





***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - CORRECTION
***_____________________________________________________________________________
/*
We tried to call all of those students and we manage to reach 110 of them
correction explaned in Logistics\03_data\04_correction_file\not_matched correction*/

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


///////////////////////////////////////////////////////////////////////
//////////////     IS THERE DUPLICATES IN TERMS OF       ///////////////
//////////////     PHONE NUMBER                         ///////////////
///////////////////////////////////////////////////////////////////////
merge 1:1 id_number time using "`mismatch'", keepusing(mismatch)

replace  sec0_q6="" if sec0_q6=="Don't know/Don't know want to answer"

*phone number duplicates if the id_number is not the same
xtset id_number time
duplicates report sec0_q6 if id_number[_n]!=id_number[_n+1] & sec0_q6!=""
duplicates tag sec0_q6 if id_number[_n]!=id_number[_n+1] & sec0_q6!="" & sec0_q6!="", gen(dup)


browse if dup==1
sort sec0_q6 time
order time sec0_q6 mismatch
count if dup==1 & mismatch==1
*==> 66 duplicates (33*2) which are not matched yet and people which are matched also.
* I have duplicates from the baseline !!!! => NEED TO CHECK because they may put
* phone number of their friend if they had no phone.
*10 duplicates for non matched obs.


browse if dup==2
*people who put wrong number "123456789"

/*
preserve
keep if dup==1
sort sec0_q6
order time	sec0_q6	mismatch	id_number	lycee_name_str
keep id_number key_mid key_base lycee_name_str time sec0_q1_a mismatch	sec0_q1_b	sec0_q2	sec0_q3	sec0_q4	sec0_q5_a	sec0_q5_b	sec0_q6	sec0_q6_mail	name_contact1	phone_contact1	name_contact2	phone_contact2
export excel using "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Logistics\03_data\04_correction_file\phone_number_check2.xls", replace firstrow(var)
restore
*/


*I deleted the last survey when the information of the contacts are the same
*or dropping when the student completed two surveys and did not finish the first one.
#delimit ;
drop if 
key_base=="uuid:9787855d-7323-4d62-9f79-6ea174653320" |
key_base=="uuid:dc714f81-2475-432e-be04-be179d4648be" |
key_base=="uuid:87ff3fce-0e67-42b8-bc96-083e8b62954c" |
key_base=="uuid:6ffc2c43-d5ca-4503-98fd-223fb6ce14e0" |
key_base=="uuid:98a66732-e975-44d6-8864-6144ba43df1f" & time==0 |
key_base=="uuid:7af742fa-ba9b-40e0-815a-8c827722bad5" |
key_base=="uuid:560dad7d-d44f-43cd-8077-f68b5b210c3d" & time==0 |
key_base=="uuid:8fa24750-f657-49c3-b721-cc64ff8d228a" |
key_base=="uuid:bc027a0b-0020-42d7-99d9-ab2a01d04d7e" |
key_base=="uuid:13d0a018-53e3-4fb4-acb6-1ace9e7d7223" |
key_base=="uuid:45db49a6-8357-43ad-9671-0690b86a15cb" |
key_base=="uuid:4e5f67a3-62eb-44c3-8887-3e62725413e1" 
;

replace id_number=91537716 if key_base=="uuid:431da8b3-8546-4dfa-877c-7b47af29968d" & time==0
replace id_number=9151714 if key_mid=="uuid:f2854af5-96df-4397-8283-1555d0f59798"
replace id_number=9141743 if key_mid=="uuid:d6244aac-c43f-40f2-b18e-8c8d1ed33297"
replace id_number=91532031 if key_mid=="uuid:c4f0237f-a154-419c-9e0e-cc59a27ca7e8"
replace id_number=91402648 if key_mid=="uuid:045ad4b0-243a-45d3-b80b-499d46632a1e"
replace id_number=91102824 if key_mid=="uuid:f6955adc-cc14-4753-9a93-58a5cb89aa72"
replace id_number=91516748 if key_mid=="uuid:5dc64fdb-3e0d-4211-a7a8-b8469931ba1a"
replace id_number=91102814 if key_mid=="uuid:a9d4ddb8-ae7e-489c-aad7-462113ffb783"



********************************
********** saving ************
********************************
save "$main\Data\output\analysis\guinea_final_dataset.dta", replace


