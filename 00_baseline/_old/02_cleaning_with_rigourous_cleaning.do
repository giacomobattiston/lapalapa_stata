/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   TITLE      :    01 - CLEANING THE DATA OF THE BASELINE
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*
********************************************************************************/
/*
name : cleaning_with_rigourous_cleaning.do
Date Created:  December 26, 2018
Date Last Modified: January 20, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\do_file\baseline_questionnaire_imported.dta"
*	Outputs: "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data/output/baseline/questionnaire_baseline_clean_rigourous_cleaning.dta"

OUPUT :
- 00 READING THE DATA
- 01 KEEPING RELEVANT INFORMATION
- 02 LABELLING
- 03CLEANING
*/

* initialize Stata
clear all
set more off
set mem 100m


*Cloe user
global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

********************************************************************************
//,\\'//,\\'//,\\'//,\\           PARAMETERS            //,\\'//,\\'//,\\'//,\\'
********************************************************************************

/*data type*/
local note_fields1 "note_consent note_friend1 note_friend2 note_sec1_a note_sec1_b note_sec1_c note_sec1_d note_sec2_a note_sec2_b note_sec3_a note_sec3_b note_sec3_e note_sec3_g note_sec3_h note_sec3_i_a note_sec3_i_b"
local note_fields2 "note_sec3_i_c note_sec4 note_sec5 note_sec6_a note_sec6_b note_sec7_a note_sec7_b note_sec7_c note_sec9 note_sec10_a note_sec10_b note_sec10_c note_fin"
local text_fields1 "deviceid subscriberid simid devicephonenum time_begin commune lycee_name sec0_q1_a sec0_q1_b sec0_q5_b sec0_q6 sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 time0 time1 sec2_q2"
local text_fields2 "sec2_q3 sec2_q3_other_reasonmig sec2_q5 sec2_q7_example sec2_q13 sec2_q14 sec2_q15 time2 time3a time3b upper_bound num_draws random_draws_count random_draw_* scaled_draw_* unique_draws randomoption1"
local text_fields3 "randomoption2 randomoption3 randomoption4 randomoption5 randomoption6 sec3_21_nb_other sec3_21 time3c sec3_34_error_millions sec3_34_error_thousands time3d time4 time5 time6a time6b time7"
local text_fields4 "sec8_q4_other_occup time8 time9 sec10_q1_1 sec10_q5_1 sec10_q1_2 sec10_q5_2 time10a time10b time10c finished instanceid"
local date_fields1 "sec0_q3 sec2_q9"
local datetime_fields1 "submissiondate starttime endtime"

local introduction "commune lycee_name sec0_q1_a sec0_q1_b sec0_q2 sec0_q3 sec0_q4 sec0_q5_b sec0_q6 sec0_q6_fb sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 "
local family "sec1_1 sec1_2 sec1_3 sec1_5 sec1_6 sec1_7 sec1_8 sec1_9 sec1_10 sec1_12 sec1_13 sec1_14 sec1_15 sister_no brother_no"
local mig_desire "sec2_q1 sec2_q2 sec2_q3 sec2_q3_1 sec2_q3_2 sec2_q3_3 sec2_q3_4 sec2_q3_5 sec2_q3_6 sec2_q3_7 sec2_q3_other_reasonmig sec2_q4 sec2_q5 sec2_q7 sec2_q7_example sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3 sec2_q8 sec2_q9 sec2_q10_a sec2_q10_b sec2_q10_c sec2_q11 "
local italy "sec3_0 sec3_1 sec3_2 sec3_3 sec3_4 sec3_5 sec3_6 sec3_7 sec3_8"
local spain "sec3_10 sec3_11 sec3_12 sec3_14 sec3_15 sec3_16 sec3_17 sec3_18 sec3_19"
local ceuta "sec3_23 sec3_24 sec3_25 sec3_26 sec3_27 sec3_28 sec3_29 sec3_30 sec3_31"
local proba "sec3_32 sec3_35 sec3_36 sec3_37 sec3_38 sec3_39 sec3_40 sec3_41 italy_beaten italy_forced_work italy_kidnapped italy_die_bef_boat italy_die_boat italy_sent_back spain_beaten spain_forced_work spain_kidnapped spain_die_bef_boat spain_die_boat spain_sent_back ceuta_beaten ceuta_forced_work ceuta_kidnapped ceuta_die_bef_boat ceuta_die ceuta_sent_back"
local money_quest "sec3_42 sec3_34 sec3_34_bis italy_journey_cost spain_journey_cost ceuta_journey_cost sec3_42 sec4_q1 sec4_q2 sec4_q3 sec4_q4 sec8_q5 sec8_q6"


	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  0- Reading the data
***_____________________________________________________________________________
use "$main/Data/output/baseline/questionnaire_baseline_imported.dta", clear

drop time* unique_draws upper_bound num_draws random*

	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - keeping the relevant information               
***_____________________________________________________________________________


 * the baseline started on November 26. I delete all the observation before this date 
		drop if starttime_new_date<date("11262018","MDY")

 * deleting questionnaire that i sent by mistake during adama's training 
		drop if sec0_q1_a=="Hji"


*drop obs if the student's name is not specified (this is certainaly technical issue or the questionnaire has not been savec correctly)
		drop if sec0_q1_a==""

 *deleting questionnaire of Kaba Bintou (Sylla Lamine) she was not selected
 *but she wanted to do the questionnaire*
		drop if key=="uuid:b4ecbeab-e381-4b0a-9ec0-29524afeb80a"

* deleting questionnaire of Sekouma Kourouma (Nelson mandela simbaya). We end up with 51 
*students because 2 remplaçant came instead of one.Sekouma Kourouma was the last
*remplacant according to the list.
		drop if key=="uuid:daf05498-1cf8-4e2a-9302-3e12e3802edd"

*in KOFI ANNAN, I had to inform the students + remplaçants before the day before the survey
*in the end, we got 52 participants because there were more remplacants than missing students.
*So I delete the last two remplaçants 
		drop if key=="uuid:2e8d37f8-bc14-4556-af82-94351762f583" | key=="uuid:36638e4f-174a-4640-9b08-80f18485d7ce"

*dropping the 2 FA SCHOOLS that we surveyed
	drop if lycee_name=="ABOUBACAR SIDIK" & starttime_new_date==date("12172018","MDY")
	drop if lycee_name=="EL HADJ KARAMOKO KABA" & starttime_new_date==date("12102018","MDY")


*dropping the 5 schools that we decided to exclude because there was to much selection
		drop if lycee_name=="LA COLOMBE" & (starttime_new_date==date("01162019","MDY") | starttime_new_date==date("02012019","MDY"))
		drop if lycee_name=="SALIM" & starttime_new_date==date("11282018","MDY")
		drop if lycee_name=="HAMAC" & starttime_new_date==date("11282018","MDY")
		drop if lycee_name=="CHATEAU BRIAND" & starttime_new_date==date("11292018","MDY")
		drop if lycee_name=="LES BOBELS" & starttime_new_date==date("11262018","MDY")


*dropping the school with 3 students (el Asad)
		drop if key=="uuid:88de3369-ca0a-4429-8195-a21866843a8d" | key=="uuid:94512a4b-4de0-4a60-9871-f2326e697e37" | key=="uuid:0aa9b618-078d-4d3c-a860-61eb2ecb4ff9"


*in Lambandji 2, we had to reprogram the second session because a lot of students went out at 12 am.
*there were clearly selection and we did not manage to find the students selected by the python program.
* I delete the students that were not selected by the python program and they we have substituted another day. 
#delimit ;
drop if key=="uuid:a210aabb-9f7e-4118-8610-dbaafbdf490c" |
key =="uuid:69ef4072-a5b2-4e6d-bbbd-cc859412a7b8" |
key=="uuid:b23193e5-7673-4be4-bfcb-2ccf9f6a0bca" |
key=="uuid:b114fd50-fada-4cb1-8641-b3e1aab2570c" |
key=="uuid:1f6349bd-14af-465c-9e90-89f27962200d" |
key=="uuid:0663f676-091d-4ba9-91a4-7ddc821c355a" |
key=="uuid:9f3f11f7-7ead-42a9-9a08-a260e4eb742d" |
key=="uuid:9194dc96-1193-4e34-8297-e67d6068259a" |
key=="uuid:fe635b0f-0722-43d7-922e-7e0fcdc4aa11" |
key=="uuid:61cef479-e97d-4008-98e9-f19be6b84050" |
key=="uuid:b16828d7-0182-4192-a4ca-3efed767890e" |
key=="uuid:668749b0-64ad-40ac-a2c2-6af2fe29c3e2" ;

*In martin luther king, surveyors choose 7 voluntary students because the others refused to participate
*I delete the voluntary students
#delimit ;
drop if key=="uuid:fffaad44-8cb3-4762-9825-021c22bee489" |
key=="uuid:cdbeb896-1173-469b-bb90-2d7a4ba327fa" |
key=="uuid:dfc8c111-1bbd-43e1-8f69-a8ee04fc04a2" |
key=="uuid:2bfd6730-9994-4f50-add7-4c71936c7338" |
key=="uuid:b16cae47-76a2-4675-9448-3917bb876eb2" |
key=="uuid:6a2bb006-452c-423d-b234-e9605ede6b39" |
key=="uuid:10c1f594-2544-4819-845e-91d232c430ee" ;

#delimit cr

////DUPLICATE
*Sometimes students started to answer and because they misused the tablet,
*they had to start again the questionnaire.
*finding duplicates in terms of name/telephone number/grade :

*sort sec0_q3 sec0_q1_a
*duplicates tag lycee_name sec0_q1_a sec0_q1_b sec0_q3 sec0_q4 sec0_q5_a sec0_q6, gen(dup)
*browse if dup==1


*I delete the questionnaire that have been completed by the students and
*keep the one which is complete
drop if key=="uuid:00257075-1e3b-4ee4-835c-316844cea722"
drop if key=="uuid:e476a8cd-6510-4515-b8b5-dbbb350cbdd1"
drop if key=="uuid:c73169c3-a095-483e-a3fc-76ae9bcc9986"
drop if key=="uuid:7dd5ed96-9262-42e6-8aaf-19489c1f09d7" 
// for the last student telephone number is different but name, first contact is the same and this is the same tablet


*deleting student that completed the questionnaire a second time :
drop if key=="uuid:713b3bd6-5f0a-4046-877b-e660dea98652"
drop if key=="uuid:dd1df22a-3f97-45fd-892e-348c6d8f7d79"
drop if key=="uuid:83dc91f7-0b45-48cd-b27e-33c269a581d7"
drop if key=="uuid:1b2ed783-36d8-445d-83d8-edfe628fc551"
drop if key=="uuid:0b7f2fc0-1ebe-4513-91e4-1cef39ca2dcb"





***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 2- LABELING THE VARIABLES                
***_____________________________________________________________________________


label variable key "Unique submission ID"
cap label variable submissiondate "Date/time submitted"
cap label variable formdef_version "Form version used on device"
cap label variable review_status "Review status"
cap label variable review_comments "Comments made during review"
cap label variable review_corrections "Corrections made during review"


label variable consent_agree "Do you accept to participate in the survey ?"
note consent_agree : "Do you accept to participate in the survey ?"
label define yes_no 1"Yes" 2"No"

//////////////  SECTION 0 ///////////////// 
label variable commune "In which commune is located your high school ?"
note commune : "In which commune is located your high school ?"

label variable lycee_name "What is the name of your high school ?"
note lycee_name : "What is the name of your high school ?"

label variable sec0_q1_a "What is your first name ?"
note  sec0_q1_a : "What is your first name ?"


label variable sec0_q1_b "What is your family name ?"
note  sec0_q1_b : "What is your family name ?"


label variable sec0_q2 "What is your gender ?"
note  sec0_q2 : "What is your gender ?"
label define gender 1 "Male" 2 "Female"
label values sec0_q2 gender


label variable sec0_q3 "What is your birth date ?"
note  sec0_q3 : "What is your birth date ?"


label variable sec0_q4 " Which grade are you enrolled in ?"
label define grade 1 "7th grade" 2 "8th grade" 3"9th grade" 4"10th grade" 5 "11th grade" 6 "12th grade" 7"13th grade"
label values sec0_q4 grade
note sec0_q4 : " Which grade are you enrolled in ? (UK system)"


label variable sec0_q5_a "Which speciality did you select ?"
note sec0_q5_a: "Which speciality did you select ?"
label define option 1 "Experimental Sciences" 2 "Social Science" 3 "Mathematical Sciences"
label values sec0_q5_a option


label variable sec0_q5_b "Which section are you enrolled in ?"
note sec0_q5_b : "Which section are you enrolled in ?"


label variable sec0_q6 "What is your main phone number ?"
note sec0_q6 : "What is your main phone number ?"


label variable  sec0_q6_fb "Do you have a facebook account ?"
note  sec0_q6_fb : "Do you have a facebook account ?"
label values  sec0_q6_fb yes_no

label variable  sec0_q6_mail "What is the mail adress associated with your facebook account"
note  sec0_q6_mail : "What is the mail adress associated with your facebook account"


rename friend_name1 name_contact1
label variable name_contact1 "Name and family name of your 1rst contact person"
note name_contact1 : "In case you leave the city, can you tell us the names of a friend or family member who are sure to know where you are, and how to contact you? (They should be friends or family members whom we could find in your community if you moved away)"

rename friend_phone1 phone_contact1
label variable phone_contact1 "Phone of your 1rst contact person"
note phone_contact1 : "In case you leave the city, can you tell us the names of a friend or family member who are sure to know where you are, and how to contact you? (They should be friends or family members whom we could find in your community if you moved away)"


rename friend_name2 name_contact2
label variable name_contact2 "Name and family name of your 2nd contact person"
note name_contact2 : "In case you leave the city, can you tell us the names of a friend or family member who are sure to know where you are, and how to contact you? (They should be friends or family members whom we could find in your community if you moved away)"

rename friend_phone2 phone_contact2
label variable phone_contact2 "Phone of your 2nd contact person"
note phone_contact2 : "In case you leave the city, can you tell us the names of a friend or family member who are sure to know where you are, and how to contact you? (They should be friends or family members whom we could find in your community if you moved away)"


label variable sec0_q7 "Where were you born"
note sec0_q7 : "Where were you born"
label define place_short 1 "In Conakry" 2"Outside Conakry, in Guinea" 3 "Outside Guinea, in Africa" 4 "Other"
label values sec0_q7 place_short



label variable sec0_q8 "Where are you currently living ?"
note sec0_q8 : "Where are you currently living ?"
label values sec0_q8 place_short



/* FOR PREVIOUS VERSION OF THE QUESTIONNAIRE
rename sec0_q9 ever_migrate_after12
label variable "Since turning 12, have you ever lived outside of the city or village you currently reside in for AT LEAST 1 YEAR ? "
note ever_migration_after12 : ""Since turning 12, have you ever lived outside of the city or village you currently reside in for AT LEAST 1 YEAR ? "

*/

label variable sec0_q10 " What is your religion ?"
note sec0_q10: " What is your religion ?"
label define religion 1 "Muslim" 2 "Catholic" 3"Evangelist" 4 "Protestant (not Evangelist)" 5 "Other" 6"None"
label values sec0_q10 religion


label variable sec0_q11 "In addition to French, which language do you speak the most with your family ?"
note sec0_q11 : "In addition to French, which language do you speak the most with your family ?"
label define language 1 "Sousou" 2 "Malinké" 3 "Pular" 4 "Kpele" 5 "Kissi" 6 "Loma" 7 "Baga" 8 "Coniagui" 9 "Other Guinean language" 10 "Other language" 11 "I speak French only"
label values sec0_q11 language


///////////////////////////////////////////
//////////////  SECTION 1 /////////////////
///////////////////////////////////////////

rename sec1_1 no_family_member
label variable no_family_member "What is the total number of people in your household (including yourself) ?"
note no_family_member : "What is the total number of people in your household (including yourself) ?"

label variable sec1_2 "Is your mother alive ?"
note sec1_2 : "Is your mother alive ?"
label values sec1_2 yes_no


label variable sec1_3 " Where does your mother live ?"
note sec1_3 :  " Where does your mother live ?"
/*we changed the choices starting from the version 1812042013. We grouped 4 to 9 into the category "Other"*/
replace sec1_3=4 if sec1_3!=. & sec1_3!=1 & sec1_3!=2 & sec1_3!=3
label values sec1_3 place_short


/* FROM VERSION 1812042013 upwards, we deleted this question"
label variable sec1_4 " Where was she born ?"
note sec1_4 :  " Where was she born ?"
label define place_long 1 "In Conakry" 2"Outisde Conakry, in Guinea" 3"Outside Guinea, but in Africa" 4"In Europe" 5"In the US" 6"In North America, except for the US" 7"In South America" 8 "In Asia" 9"In Oceania"
*/


label variable sec1_5 "Has your mother ever attended school ?"
note sec1_5 : "Has your mother ever attended school ?"
label values sec1_5 yes_no



label variable sec1_6 "What is the highest level of education she completed ?"
note sec1_6 : "What is the highest level of education she completed ?"
*incorportating "no formal education" in the level of education"
replace sec1_6=999 if sec1_5==2
label define education_m 0 "Preschool" 1"Primary" 2"Secondary school"  3"Higher (University, etc.)" 99"Don't know" 999"No education"
label values sec1_6 education_m


label variable sec1_7"Has your mother been working over the last 12 months ?"
note sec1_7 :"Has your mother been working over the last 12 months ?"
label values sec1_7 yes_no



label variable sec1_8 "Over the last 12 months, what has been her main occupation ?"
note sec1_8 : "Over the last 12 months, what has been her main occupation ?"
label define occupation_short  1	"Sales and Services (ex : salesperson/entrepreneur)" 2	"Agriculture (including fishermen, foresters, and hunters)" 3	"Skilled manual worker (ex : machiner operator/carpenter)" 4	"Unskilled manual worker (ex : road construction/assembler)" 5	"Professional/technical/managerial (e.g. engineer/computer assistant/manager/nurse)" 6	"Clerical (ex : secretary)" 7	"Military/Paramilitary" 8 "Domestic service for another house (e.g. housekeeper)" 99	"Don't know"
label values sec1_8 occupation_short



label variable sec1_9 "Is your father alive ?"
note sec1_9 : "Is your father alive ?"
label values sec1_9 yes_no



label variable sec1_10 " Where does your father live ?"
note sec1_10 :  " Where does your father live ?"
/*we changed the choices starting from the version 1812042013. We grouped 4 to 9 into the category "Other"*/
replace sec1_10=4 if sec1_10!=. & sec1_10!=1 & sec1_10!=2 & sec1_10!=3
label values sec1_10 place_short


/* FROM VERSION 1812042013 upwards, we deleted this question"
label variable sec1_11 " Where was she born ?"
note sec1_11 :  " Where was she born ?"
label define place_long 1 "In Conakry" 2"Outisde Conakry, in Guinea" 3"Outside Guinea, but in Africa" 4"In Europe" 5"In the US" 6"In North America, except for the US" 7"In South America" 8 "In Asia" 9"In Oceania"
*/

label variable sec1_12 "Has she ever attended school ?"
note sec1_12 : "Has she ever attended school ?"
label values sec1_12 yes_no


label variable sec1_13 "What is the highest level of education she completed ?"
note sec1_13 : "What is the highest level of education she completed ?"
*incorportating "no formal education" in the level of education"
replace sec1_13=999 if sec1_13==2
label define education_f 0 "Preschool" 1"Primary" 2"Secondary school"  3"Higher (University, etc.)" 99"Don't know" 999"No education"
label values sec1_13 education_f


label variable sec1_14 "Has your father been working over the last 12 months ?"
note sec1_14 :"Has your father been working over the last 12 months ?"
*incorporation "no" if father is not alive
label values sec1_14 yes_no


label variable  sec1_15"Over the last 12 months, what has been her main occupation ?"
note  sec1_15: "Over the last 12 months, what has been her main occupation ?"
label values  sec1_15 occupation_short


label variable sister_no "How many sisters do you have ?"
note sister_no : "How many sisters do you have ?"


label variable brother_no "How many brothers do you have ?"
note brother_no : "How many brothers do you have ?"


/* for version previous to 1812042013
rename sec1_16 older_sister_no
label variable older_sister_no "How many older sisters do you have ?"
note older_sister_no : "How many older sisters do you have ?"
rename sec1_17 older_brother_no
label variable older_brother_no "How many older brothers do you have ?"
note older_brother_no : "How many older brothers do you have ?"
*/

///////////////////////////////////////////
//////////////  SECTION 2 /////////////////
///////////////////////////////////////////

label variable sec2_q1 "Ideally, would you like to move permanently to another country or would you like to continue living in Guinea?"
note sec2_q1 : "Ideally, if you had the opportunity, would you like to move permanently to another country or would you like to continue living in Guinea?"
label define sec2_q1 1	"Yes, I would like to move permanently to another country." 2	"No, I would like to continue living in Guinea."
label values sec2_q1 mig_desire

label variable sec2_q2 "If you could go anywhere in the world, which country would you like to live in ? "
note sec2_q2 : "If you could go anywhere in the world, which country would you like to live in ? "

label variable sec2_q3 "Why would you like to move permanently to another country? "
note sec2_q3 : "Why would you like to move permanently to another country? "

label variable sec2_q3_1 "I want to migrate to continue your studies ?"
note sec2_q3_1 : "I want to migrate to continue to continue your studies ? (dummy created with mig_reason)"
label define yes_no_bis 1 "Yes" 0"No"
label values sec2_q3_1 yes_no_bis


label variable sec2_q3_2 "I want to migrate for economic reasons ?"
note sec2_q3_2 : " I want to migrate for for economic reasons ? (dummy created with mig_reason)"
label values sec2_q3_2 yes_no_bis


label variable sec2_q3_3"I want to migrate for family reasons ? (to join a relative abroad etc.)"
note sec2_q3_3: " I want to migrate for economic reasons ? (dummy created with mig_reason)"
label values sec2_q3_3 yes_no_bis

label variable sec2_q3_4 "I want to migrate because my area is affected by war/conflict ?"
note sec2_q3_4: "I want to migrate because my area is affected by war/conflict ? (dummy created with mig_reason)"
label values sec2_q3_4 yes_no_bis

label variable sec2_q3_5 "I want to migrate because I am or could be the victim of violence or persecution ?"
note sec2_q3_5 : "I want to migrate because I am or could be the victim of violence or persecution ?  ? (dummy created with mig_reason)"
label values sec2_q3_5 yes_no_bis

label variable sec2_q3_6 "I want to migrate because region has been affected by extreme climatic events "
note sec2_q3_6 :" I want to migrate because region has been affected by extreme climatic events (dummy created with mig_reason)"
label values sec2_q3_6 yes_no_bis


label variable sec2_q3_7 "Do you want to migrate for other reasons ?"
note sec2_q3_7 :" Do we change the question ? Do you want to migrate for other reasons ? (dummy created with mig_reason)"
label values sec2_q3_7 yes_no_bis


label variable sec2_q3_other_reasonmig " Could you specify the other reason why you want to migrate to another country ?"
note sec2_q3_other_reasonmig : " Could you specify the other reason why you want to migrate to another country ?"


label variable sec2_q4 "Are you planning to move permanently to another country in the next 12 months, or not?"
note sec2_q4 : "Are you planning to move permanently to another country in the next 12 months, or not?"
label values sec2_q4 yes_no

label variable sec2_q5 "Which country are you planning to move to?"
note sec2_q5 : "Which country are you planning to move to?"

label variable sec2_q7  " Have you made any preparations for this move?"
note sec2_q7  : " Have you made any preparations for this move?"
label values sec2_q7  yes_no

label variable sec2_q7_example  " Which types of preparations have you made for this move?"
note sec2_q7  : " Which types of preparations have you made  for this move?"


label variable sec2_q7_example_1 "I am saving money to prepare my trip" 
note sec2_q7_example_1 : "I am saving money to prepare my trip" 
label values sec2_q7_example_1 yes_no_bis

label variable sec2_q7_example_2 "I have contacted someone I know who is living in the country where I want to go." 
note sec2_q7_example_2 : "I have contacted someone I know who is living in the country where I want to go." 
label values sec2_q7_example_2 yes_no_bis

label variable sec2_q7_example_3 "I made some of my relatives aware of my desire to migrate."
note sec2_q7_example_3 : "I made some of my relatives aware of my desire to migrate."
label values sec2_q7_example_3 yes_no_bis

label variable sec2_q8 "Did you plan a date to migrate?"
note sec2_q8 :  "Did you plan a date to migrate?"
label values sec2_q8 yes_no

label variable sec2_q9 "In which month/year are you planning to leave Guinea?"
note sec2_q9 : "In which month/year are you planning to leave Guinea?"

label variable  sec2_q10_a "Did you already applied to get a visa to enter in [sec2_q5] during the next 12 months ?"
note sec2_q10_a : "Have you already applied to get a visa to enter in this country [sec2_q5] during the next 12 months ?"

label variable  sec2_q10_b "Do you believe that you will applied for getting a visa to migrate to [sec2_q2] ?"
note sec2_q10_b: "For people who do not want migrate in the next 12 months : Do you believe that you will applied for getting a visa in order to migrate to this country ?"


label variable sec2_q10_c "Do you believe that you will applied for getting a visa to migrate to [sec2_q2] ?"
note sec2_q10_c : "For people who want migrate in the next 12 months : Do you believe that you will applied for getting a visa in order to migrate to this country ?"


label variable sec2_q11  "Did you discuss about migration with your friends or siblings over last week ?"
note sec2_q11 : "Did you discuss about migration with your friends or siblings over last week ?"
label values sec2_q11  yes_no

label variable sec2_q12 "Over last week, did you discuss about migration with students enrolled in other high school than yours ? "
note sec2_q12: "Over last week, did you discuss about migration with students enrolled in other high school than yours ? "
label values sec2_q12 yes_no

label variable sec2_q13 "Name of the 1srt high school"
note sec2_q13 : "Name of the 1srt high school (99=none)"

label variable sec2_q14  "Name of the 1srt high school"
note sec2_q14  : "Name of the 2nd high school (99=none)"

label variable sec2_q15"Name of the 1srt high school"
note sec2_q15 : "Name of the 2nd high school (99=none)"


///////////////////////////////////////////
//////////////  SECTION 3 /////////////////
///////////////////////////////////////////

///////////////// ITALY ///////////////////


rename sec3_0 italy_awareness
label variable italy_awareness "Have you ever heard about boats transporting migrants from Libya to Italy ?"
note italy_awareness : "Have you ever heard about boats transporting migrants from Libya to Italy ?"
label define aware 1 "Yes, mainly when watching TV." 2 "Yes, mainly when speaking to family member or friends." 3 "Yes, mainly by the social networks (ex : Facebook)." 4 "Yes, mainly by other communication means." 5	"No, I have never heard about it."
label values italy_awareness aware



rename sec3_1 italy_duration
label variable  italy_duration "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"
note italy_duration : "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"


rename sec3_2 italy_journey_cost
label variable  italy_journey_cost "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"
note italy_journey_cost : "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"


rename sec3_3 italy_beaten
label variable italy_beaten "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"
note italy_beaten : "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"

rename sec3_4 italy_forced_work
label variable italy_forced_work "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"
note italy_forced_work : "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"

rename sec3_5 italy_kidnapped
label variable italy_kidnapped "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"
note italy_kidnapped : "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"


rename sec3_6 italy_die_bef_boat
label variable italy_die_bef_boat "Among those 100 people who left Guinea, how many of them will DIE BEFORE the travel by boat to Italy ?"
note italy_die_bef_boat : "Among those 100 people who left Guinea, how many of them will DIE BEFORE the travel by boat to Italy ?"

rename sec3_7 italy_die_boat
label variable italy_die_boat "Now, imagine that 100 Guinean people exactly like you take to boat over next year to go to ITALY from Libya. How many of them will die DURING the travel by BOAT ?"
note italy_die_boat : "Now, imagine that 100 Guinean people exactly like you take to boat over next year to go to ITALY from Libya. How many of them will die DURING the travel by BOAT ?"


rename sec3_8 italy_sent_back
label variable italy_sent_back "Now, imagine that 100 Guinean people exactly like you arrive in Italy over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"
note italy_sent_back :  "Now, imagine that 100 Guinean people exactly like you arrive in Italy over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"



///////////////// spain///////////////////


rename sec3_10 spain_awareness
label variable spain_awareness "Have you ever heard about boats transporting migrants from Morocco or Algeria to Spain ?"
note spain_awareness : "Have you ever heard about boats transporting migrants Morocco or Algeria to Spain ?"
label values spain_awareness aware



rename sec3_11 spain_duration
label variable  spain_duration "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"
note spain_duration : "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"


rename sec3_12 spain_journey_cost
label variable  spain_journey_cost "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"
note spain_journey_cost : "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"


rename sec3_14 spain_beaten
label variable spain_beaten "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"
note spain_beaten : "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"

rename sec3_15 spain_forced_work
label variable spain_forced_work "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"
note spain_forced_work : "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"

rename sec3_16 spain_kidnapped
label variable spain_kidnapped "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"
note spain_kidnapped : "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"


rename sec3_17 spain_die_bef_boat
label variable spain_die_bef_boat "Among those 100 people who left Guinea, how many of them will DIE BEFORE the travel by boat to Spain ?"
note spain_die_bef_boat : "Among those 100 people who left Guinea, how many of them will DIE BEFORE the travel by boat to Spain ?"

rename sec3_18 spain_die_boat
label variable spain_die_boat "Now, imagine that 100 Guinean people exactly like you take to boat over next year to go to Spain from Morocco or Algeria. How many of them will die DURING the travel by BOAT ?"
note spain_die_boat : "Now, imagine that 100 Guinean people exactly like you take to boat over next year to go to Spain from Morocco or Algeria. How many of them will die DURING the travel by BOAT ?"


rename sec3_19 spain_sent_back
label variable spain_sent_back "Now, imagine that 100 Guinean people exactly like you arrive in Spain over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"
note spain_sent_back :  "Now, imagine that 100 Guinean people exactly like you arrive in Spain over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"



///////////////// MIGRATION //////////////////


/*correcting the coding error in questionnaire version 1811291838 and 1811251456. the name of the country specified when students answered "other" did not appear in the following questions...*/
replace sec3_21=sec3_21_nb_other if (formdef_version==1811251456 | formdef_version==1811291838)& sec3_21_nb==7
label variable sec3_21 "Destination country : Consider one Guinean person who is EXACTLY LIKE YOU. Suppose he or she has to choose his or her way to migrate to Europe from Guinea. Which EUROPEAN COUNTRY would he/she plan to settle in ?"
note sec3_21: "Which EUROPEAN COUNTRY would he/she plan to settle in ?"


label variable sec3_21_nb_other "Please, specify the other EUROPEAN COUNTRY, he/she would plan to settle in ?"


destring sec3_22, replace
label variable sec3_22 "Between the two roads we have just described, which road would he/she select to go to in [sec3_21] ?"
note sec3_22 : "Between the two roads we have just described, which road would he/she select to go to in [sec3_21] ?"
label define road_select1 1 " This person would first reach North Africa shore and then take a boat to ITALY." 2 "This person would first reach North Africa shore and then take a boat to Spain."
label values sec3_22 road_select1

/////////////////ceuta or Melila //////////////////
/////////// note : if they know ceuta /////////


rename sec3_23 ceuta_awareness
label variable ceuta_awareness "Have ever heard about a road that allows people to go to Europe by climbing over the fence of ceuta or Melilla ?"
note ceuta_awareness : "Have ever heard about a road that allows people to go to Europe by climbing over the fence of ceuta or Melilla ?"
label values ceuta_awareness aware



rename sec3_24 ceuta_duration
label variable  ceuta_duration "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"
note ceuta_duration : "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"


rename sec3_25 ceuta_journey_cost
label variable  ceuta_journey_cost "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"
note ceuta_journey_cost : "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"


rename sec3_26 ceuta_beaten
label variable ceuta_beaten "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"
note ceuta_beaten : "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"

rename sec3_27 ceuta_forced_work
label variable ceuta_forced_work "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"
note ceuta_forced_work : "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"

rename sec3_28 ceuta_kidnapped
label variable ceuta_kidnapped "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"
note ceuta_kidnapped : "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"


rename sec3_29 ceuta_die_bef_boat
label variable ceuta_die_bef_boat "Among those 100 people who left Guinea, how many of them will DIE BEFORE arriving in Europe ?"
note ceuta_die_bef_boat : "Among those 100 people who left Guinea, how many of them will DIE BEFORE arriving in Europe ?"

rename sec3_30 ceuta_die
label variable ceuta_die "Among those 100 people who left Guinea, how many of them will arrive in Europe ?"
note ceuta_die : "Among those 100 people who left Guinea, how many of them will arrive in Europe ?"


rename sec3_31 ceuta_sent_back
label variable ceuta_sent_back "Now, imagine that 100 Guinean people exactly like you arrive in ceuta or Melilla over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"
note ceuta_sent_back :  "Now, imagine that 100 Guinean people exactly like you arrive in ceuta or Melilla over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"




label variable	sec3_31_bis "Between the three roads we have just described, which road would he/she select to go to [sec3_21] ?"
note sec3_31_bis : "If you know ceuta, Between the three roads we have just described, which road would he/she select to go to [sec3_21] ?"
label define sec3_31_bis 1 " This person would first reach North Africa shore and then take a boat to ITALY." 2 "This person would first reach North Africa shore and then take a boat to Spain." 3 "This person would first reach North Africa shore and then climb over the fence of ceuta or MELILLA."
label values sec3_31_bis sec3_31_bis


label variable sec3_32 "Expectation job : Among those 100 people who are like you, how many of them will find a job in [sec3_21], if this is what they want ?"
note sec3_32 : "Consider 100 Guinean people who are EXACTLY LIKE YOU and who manage to arrive in [sec3_21] over next year. Each of them arrived in Europe following the road that depart from Guinea following your prefered road. Among those 100 people who are like you, how many of them will find a job in [sec3_21], if this is what they want ?"


label variable sec3_34 "Expected wage first answer : Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH ? Please, write the amount converted in Guinean Francs."
note sec3_34 : "Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH ? Please, write the amount converted in Guinean Francs."


label variable sec3_34_error_millions_2	"You mean that on average, the wage of those people who work in [sec3_21] would reach ${sec3_34_error_millions} GF per month ?"
note sec3_34_error_millions_2 : "If the amount is less than 100 : You mean that on average, the wage of those people who work in [sec3_21] would reach ${sec3_34_error_millions} GF per month ?"
label values sec3_34_error_millions_2 yes_no


label variable sec3_34_error_thousands_2 "You mean that on average, the wage of those people who work in [sec3_21] would reach ${sec3_34_error_thousands} GF per month ?"
note sec3_34_error_thousands_2 : "If the amount is less between 99 and 99999 : You mean that on average, the wage of those people who work in [sec3_21] would reach ${sec3_34_error_thousands} GF per month ?"
label values sec3_34_error_thousands_2 yes_no


label variable sec3_34_bis "Could you please, re-write what would be on average the monthly wage of those ${sec3_32} people who work in [sec3_21] ?"
note sec3_34_bis : "Could you please, re-write what would be on average the monthly wage of those ${sec3_32} people who work in [sec3_21] ?"

label variable sec3_35 "Expectation studies : Among those 100 people who arrived in [sec3_21], how many of them will continue their studies in [sec3_21] ?"
note sec3_35 : "Among those 100 people who arrived in [sec3_21], how many of them will continue their studies in [sec3_21] ?"


label variable sec3_36 "Expectation citizenship : Among those 100 who arrived in [sec3_21], how many of them would become a citizen of this country ?"
note sec3_36: "Among those 100 who arrived in [sec3_21], how many of them would become a citizen of this country ?"


label variable sec3_37 "Expectation return 5yr : Among those 100 people who arrived in [sec3_21], how many of them would permanently return to Guinea within 5 years after their arrival in [sec3_21] ?"
note sec3_37 : "Among those 100 people who arrived in [sec3_21], how many of them would permanently return to Guinea within 5 years after their arrival in [sec3_21] ?"

label  variable sec3_38 "Expectation shelter : Among those 100 people who arrived in [sec3_21], how many of them would be offered a bed, from the government of [sec3_21], in a shelter at their arrival ?"
note sec3_38 : "Among those 100 people who arrived in [sec3_21], how many of them would be offered a bed, from the government of [sec3_21], in a shelter at their arrival ?"


label  variable sec3_39 "Expectation help from government : Among these 100 people who arrived in [sec3_21], how many of them will receive money from the GOVERNMENT of [sec3_21]  over year after their arrival ?"
note sec3_39 : "Among these 100 peopls who arrived in [sec3_21], how many of them will receive money from the GOVERNMENT of [sec3_21]  over year after their arrival ?"

label  variable sec3_40 "Expectation asylum request accepted : Imagine that 100 Guinean people, who are exactly like you, applied for asylum in[sec3_21] for the first time. According to you, how many of them would you expect to be given a positive response ?"
note sec3_40 : "Imagine that 100 Guinean people, who are exactly like you, applied for asylum in[sec3_21] for the first time. According to you, how many of them would you expect to be given a positive response ?"


label  variable sec3_41 "Expectation number of citizen in favor of immigration: Now consider 100 citizens of [sec3_21]. In your opinion, among these 100 citizens of [sec3_21], how many of them are in favor of immigration ?"
note sec3_41 : "Now consider 100 citizens of [sec3_21]. In your opinion, among these 100 citizens of [sec3_21], how many of them are in favor of immigration ?"


label variable sec3_42 "Expected living cost : Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
note sec3_42 : "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."



///////////////////////////////////////////
//////////////  SECTION 4 /////////////////
///////////////////////////////////////////

label variable sec4_q1 "In your opinion, what is the price of 1kg of onion in [sec3_21] in Guinean Francs ?"
note sec4_q1 : "In your opinion, what is the price of 1kg of onion ?"

label variable sec4_q2 "In your opinion, what is the price of 1kg of chicken in [sec3_21] in Guinean Francs ?"
note sec4_q2 : "In your opinion, what is the price of 1kg of chicken in [sec3_21] in Guinean Francs ?"

label variable sec4_q3 "In your opinion, what is the price of a liter of gasoline in [sec3_21] in Guinean Francs ?"
note sec4_q3 : "In your opinion, what is the price of a liter of gasoline in [sec3_21] in Guinean Francs ?"

label variable sec4_q4 "In your opinion, what is the price of 1 box of 10 Doliprane tablets in [sec3_21] in Guinean Francs ?"
note sec4_q4 : "In your opinion, what is the price of 1 box of 10 Doliprane tablets in [sec3_21] in Guinean Francs?"



///////////////////////////////////////////
//////////////  SECTION 5 /////////////////
///////////////////////////////////////////

label variable sec5_q1	"True or false : Suppose that a migrant enters Italy illegally. S/he then applies for asylum and goes to France in search of a job. French authorities can deport her/him to Italy, before she receives a decision on her application."
note sec5_q2 : "True or false : Suppose that a migrant enters Italy illegally. S/he then applies for asylum and goes to France in search of a job. French authorities can deport her/him to Italy, before she receives a decision on her application."
label define true_false 1 "True" 2"False" 3"I don't know"
label values sec5_q1 true_false

label variable sec5_q2	"True or false : A  Guinean national who is extremely poor has right to asylum in Italy."
note sec5_q2 : "True or false : A  Guinean national who is extremely poor has right to asylum in Italy."
label values sec5_q2 true_false

label variable sec5_q3	"True or false : Consider a Guinean woman who resides in Italy illegally. Suppose she is pregnant, and she bears her child in Italy. Her child becomes an Italian citizen as soon as he is born."
note sec5_q3 : "True or false : Consider a Guinean woman who resides in Italy illegally. Suppose she is pregnant, and she bears her child in Italy. Her child becomes an Italian citizen as soon as he is born."
label values sec5_q3 true_false

label variable sec5_q4	"True or false : Consider a Guinean man who resides in Italy LEGALLY. Suppose he marries an Italian woman. After 2 years, he can become an Italian citizen."
note sec5_q4 : "True or false : Consider a Guinean man who resides in Italy LEGALLY. Suppose he marries an Italian woman. After 2 years, he can become an Italian citizen."
label values sec5_q4 true_false

label variable sec5_q5	"True or false : A migrant lodging an asylum request in Italy has to be given a positive or negative response within 6 months."
note sec5_q5 : "True or false : A migrant lodging an asylum request in Italy has to be given a positive or negative response within 6 months."
label values sec5_q5 true_false

label variable sec5_q6	"True or false : A migrant lodging an asylum request in Italy can legally start working before s/he receives a response."
note sec5_q6 : "True or false : A migrant lodging an asylum request in Italy can legally start working before s/he receives a response."
label values sec5_q6 true_false




///////////////////////////////////////////
//////////////  SECTION 6 /////////////////
///////////////////////////////////////////


label variable sec6_lottery1 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 200 100 FG IN 2 MONTHS."
label define sec6_lottery1 1 "Receiving 200 000 FG TODAY" 2"Receiving 200 100 FG IN 2 MONTHS"
label values sec6_lottery1 sec6_lottery1

label variable sec6_lottery2 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 240 000 FG IN 2 MONTHS."
label define sec6_lottery2 1 "Receiving 200 000 FG TODAY" 2"Receiving 240 000 FG IN 2 MONTHS"
label values sec6_lottery2 sec6_lottery2


label variable sec6_lottery3 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 280 000 FG IN 2 MONTHS."
label define sec6_lottery3 1 "Receiving 200 000 FG TODAY" 2"Receiving 280 000 FG IN 2 MONTHS"
label values sec6_lottery3 sec6_lottery3


label variable sec6_lottery4 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 320 000 FG IN 2 MONTHS."
label define sec6_lottery4 1 "Receiving 200 000 FG TODAY" 2"Receiving 320 000 FG IN 2 MONTHS"
label values sec6_lottery4 sec6_lottery4


label variable sec6_lottery5 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 360 000 FG IN 2 MONTHS."
label define sec6_lottery5 1 "Receiving 200 000 FG TODAY" 2"Receiving 360 000 FG IN 2 MONTHS"
label values sec6_lottery5 sec6_lottery5


label variable sec6_lottery6 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 400 000 FG IN 2 MONTHS."
label define sec6_lottery6 1 "Receiving 200 000 FG TODAY" 2"Receiving 400 000 FG IN 2 MONTHS"
label values sec6_lottery6 sec6_lottery6


label variable sec6_lottery7 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 440 000 FG IN 2 MONTHS."
label define sec6_lottery7 1 "Receiving 200 000 FG TODAY" 2"Receiving 440 000 FG IN 2 MONTHS"
label values sec6_lottery7 sec6_lottery7


label variable sec6_lottery8 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 480 000 FG IN 2 MONTHS."
label define sec6_lottery8 1 "Receiving 200 000 FG TODAY" 2"Receiving 480 000 FG IN 2 MONTHS"
label values sec6_lottery8 sec6_lottery8


label variable sec6_lottery9 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 520 000 FG IN 2 MONTHS."
label define sec6_lottery9 1 "Receiving 200 000 FG TODAY" 2"Receiving 520 000 FG IN 2 MONTHS"
label values sec6_lottery9 sec6_lottery9


label variable sec6_lottery10 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 560 000 FG IN 2 MONTHS."
label define sec6_lottery10 1 "Receiving 200 000 FG TODAY" 2"Receiving 560 000 FG IN 2 MONTHS"
label values sec6_lottery10 sec6_lottery10

label variable sec6_lottery11 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 600 000 FG IN 2 MONTHS."
label define sec6_lottery11 1 "Receiving 200 000 FG TODAY" 2"Receiving 600 000 FG IN 2 MONTHS"
label values sec6_lottery11 sec6_lottery11


label variable sec6_lottery12 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 640 000 FG IN 2 MONTHS."
label define sec6_lottery12 1 "Receiving 200 000 FG TODAY" 2"Receiving 640 000 FG IN 2 MONTHS"
label values sec6_lottery12 sec6_lottery12


label variable sec6_lottery13 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 680 000 FG IN 2 MONTHS."
label define sec6_lottery13 1 "Receiving 200 000 FG TODAY" 2"Receiving 680 000 FG IN 2 MONTHS"
label values sec6_lottery13 sec6_lottery13


label variable sec6_lottery14 " Which option do you prefer between :Receiving 200 000 FG TODAY and Receiving 720 000 FG IN 2 MONTHS."
label define sec6_lottery14 1 "Receiving 200 000 FG TODAY" 2"Receiving 720 000 FG IN 2 MONTHS"
label values sec6_lottery14 sec6_lottery14





label variable sec6_lottery15 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 100 FG for sure."
label define sec6_lottery15 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 100 FG for sure."
label values sec6_lottery15 sec6_lottery15


label variable sec6_lottery16 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 10 000 FG for sure."
label define sec6_lottery16 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 10 000 FG for sure."
label values sec6_lottery16 sec6_lottery16

label variable sec6_lottery17 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 20 000 FG for sure."
label define sec6_lottery17 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 20 000 FG for sure."
label values sec6_lottery17 sec6_lottery17

label variable sec6_lottery18 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 30 000 FG for sure."
label define sec6_lottery18 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 30 000 FG for sure."
label values sec6_lottery18 sec6_lottery18

label variable sec6_lottery19 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 40 000 FG for sure."
label define sec6_lottery19 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 40 000 FG for sure."
label values sec6_lottery19 sec6_lottery19


label variable sec6_lottery20 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 50 000 FG for sure."
label define sec6_lottery20 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 50 000 FG for sure."
label values sec6_lottery20 sec6_lottery20

label variable sec6_lottery21 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 60 000 FG for sure."
label define sec6_lottery21 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 60 000 FG for sure."
label values sec6_lottery21 sec6_lottery21


label variable sec6_lottery22 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 70 000 FG for sure."
label define sec6_lottery22 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 70 000 FG for sure."
label values sec6_lottery22 sec6_lottery22


label variable sec6_lottery23 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 80 000 FG for sure."
label define sec6_lottery23 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 80 000 FG for sure."
label values sec6_lottery23 sec6_lottery23

label variable sec6_lottery24 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 90 000 FG for sure."
label define sec6_lottery24 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 90 000 FG for sure."
label values sec6_lottery24 sec6_lottery24

label variable sec6_lottery25 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 100 000 FG for sure."
label define sec6_lottery25 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 100 000 FG for sure."
label values sec6_lottery25 sec6_lottery25


label variable sec6_lottery26 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 110 000 FG for sure."
label define sec6_lottery26 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 110 000 FG for sure."
label values sec6_lottery26 sec6_lottery26

label variable sec6_lottery27 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 120 000 FG for sure."
label define sec6_lottery27 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 120 000 FG for sure."
label values sec6_lottery27 sec6_lottery27


label variable sec6_lottery28 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 130 000 FG for sure."
label define sec6_lottery28 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 120 000 FG for sure."
label values sec6_lottery28 sec6_lottery28

label variable sec6_lottery29 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 140 000 FG for sure."
label define sec6_lottery29 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 140 000 FG for sure."
label values sec6_lottery29 sec6_lottery29


label variable sec6_lottery30 " Which option do you prefer between : 50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF OR Receiving 150 000 FG for sure."
label define sec6_lottery30 1 "50:50 chance of receiving 200 000 GF and 50:50 chance of receiving 0 GF." 2"Receiving 150 000 FG for sure."
label values sec6_lottery30 sec6_lottery30





///////////////////////////////////////////
//////////////  SECTION 7 /////////////////
///////////////////////////////////////////

/*for version previous to 1812042013
label variable sec7_q1 "How many rooms for sleeping does your house have? (This does not include kitchen, bathroom, etc.)"
note sec7_q1 : "How many rooms for sleeping does your house have? (This does not include kitchen, bathroom, etc.)"

label variable sec7_q2 "What is the MAIN material of the house roof"
note sec7_q1 : "What is the MAIN material of the house roof"
label define roof 1	"Metal/Corrugated Iron Sheets" 2	"Cement" 3	"Sacks/plastic sheets" 4	"Tiles" 5	"Carton" 6	"Thatch / Palm leaf" 7	"Wood" 8	"Cement fiber / Calamin" 9	"No roof" 10	"Other"
label values sec7_q2 roof

label variable sec7_q3 "What is the MAIN material of the house floor"
note sec7_q3 : "What is the MAIN material of the house floor"
label define floor sec7_q3  1	"Ceramic tiles" 2	"Cement" 3	"Earth / Sand" 4	"Gravel" 5	"Wood planks" 6	"Parquet or polished wood" 7	"Vinyl or asphalt strips" 8	"Other"
label values sec7_q3 floor
*/


label variable sec7_q4	"What is the MAIN source of drinking water for the household ?"
note sec7_q4 : "What is the MAIN source of drinking water for the household ?"
label define water 1	"Tap in the house"2	"Yard taps"3	"Public tap /  Fontain" 4	"Tap in neighboor's house" 5	"Borehole" 6	"Well" 7	"Bottled water" 8	"Plastic bag of water" 9	"Rain water"10	"Tanker-truck" 11	"Cart with small tank / drum"  12	"Surface water (river, stream, dam, lake, pond, canal, irrigation channel, hole in river bed)" 13	"Water from spring"14	"Other"
label values sec7_q4 water

label variable sec7_q5	"What type of toilet does the household use?"
note sec7_q5 :	"What type of toilet does the household use?"
label define toilet  1	"Douche avec pot à la maison" 2	"Douche avec pot dans la latrine" 3	"Douche avec pot dans le WC" 4	"Fosse d’aisance sans dalle/trou ouvert à la maison" 5	"Fosse d’aisance sans dalle/trou ouvert dans la latrine" 6	"Fosse d’aisance sans dalle/trou ouvert dans le WC" 7	"No facility, Bush, Field, Beach"
label values sec7_q5 toilet



label variable sec7_q6_a "Does your household have ELECTRICTY ? "
note sec7_q6_a : "Does your household have ELECTRICTY ? "
label values sec7_q6_a yes_no

label variable sec7_q6_b "Does your household have a RADIO ? "
note sec7_q6_b : "Does your household have a RADIO ? "
label values sec7_q6_b yes_no

label variable sec7_q6_c "Does your household have a TELEVISION ? "
note sec7_q6_c : "Does your household have a TELEVISION ? "
label values sec7_q6_c yes_no


label variable sec7_q6_d "Does your household have a MOBILE PHONE ? "
note sec7_q6_d : "Does your household have a MOBILE PHONE ? "
label values sec7_q6_d yes_no


label variable sec7_q6_f "Does your household have a WATCH ? "
note sec7_q6_f: "Does your household have a WATCH ? "
label values sec7_q6_f yes_no


label variable sec7_q6_g "Does your household have a CAR ? "
note sec7_q6_g: "Does your household have a CAR ? "
label values sec7_q6_g yes_no


label variable sec7_q6_h "Does your household have a BIKE ? "
note sec7_q6_h: "Does your household have a BIKE ? "
label values sec7_q6_h yes_no

label variable sec7_q6_i "Does your household have a REFRIGERATOR ? "
note sec7_q6_i: "Does your household have a REFRIGERATOR ? "
label values sec7_q6_i yes_no

label variable sec7_q6_j "Does your household have a FAN ? "
note sec7_q6_j: "Does your household have a FAN ? "
label values sec7_q6_j yes_no


label variable sec7_q6_k "Does your household have AIR CONDITIONER? "
note sec7_q6_k: "Does your household have a AIR CONDITIONER ? "
label values sec7_q6_k yes_no


label variable sec7_q6_l "Does your household have a MOTORBIKE ? "
note sec7_q6_l: "Does your household have a MOTORBIKE ? "
label values sec7_q6_l yes_no


label variable sec7_q6_m "Does your household have a BANK ACCOUNT ? "
note sec7_q6_m: "Does your household have a BANK ACCOUNT ? "
label values sec7_q6_m yes_no



label variable sec7_q7 "How often do you listen to the radio ?"
note sec7_q7 : " How often do you listen to the radio ?"
label define frequence  1	"Daily" 2	"2-3 times a week" 3	"Once a week" 4	"Once a month" 5	"Less than once a month" 6	"Never"
label values sec7_q7 frequence

label variable sec7_q8 "How often do you watch television ?"
note sec7_q8 : "How often do you watch television ?"
label values sec7_q8 frequence


label variable sec7_q9 "How often do you watch French television ?"
note sec7_q9 : "How often do you watch French television ?"
label values sec7_q9 frequence


label variable sec7_q10 "How often do you use internet ?"
note sec7_q10 : "How often do you use internet ?"
label values sec7_q10 frequence



///////////////////////////////////////////
//////////////  SECTION 8 /////////////////
///////////////////////////////////////////

label variable sec8_q1 "Over the past week, how much money did you spend in total to buy food for yourself ?"
note sec8_q1 : "Over the past week, how much money did you spend in total to buy food for yourself ?"
label define conso  1	"I did not spend money" 2	"Less than 10 000 FG" 3	"Between 10 000 and 50 000 FG" 4	"Between 50 000 and 100 000 FG" 5	"Between 100 000 and 200 000 FG" 6	"More than 200 000 FG"
label values sec8_q1 conso

label variable sec8_q2 "Over the past week, how much money did you spend in total to buy other things different from food for yourself (ex: clothes, airtime?)"
note sec8_q2 : "Over the past week, how much money did you spend in total to buy other things different from food for yourself (ex: clothes, airtime?)"
label values sec8_q2 conso


label variable sec8_q3	"During the LAST MONTH, did you yourself work OUTSIDE school?"
note sec8_q3 : "During the LAST MONTH, did you yourself work OUTSIDE school?"
label values sec8_q3 yes_no


label variable sec8_q4	"During the LAST MONTH, what was your main job beside studying ?"
note sec8_q4 : "During the LAST MONTH, what was your main job beside studying ?"
label define occupation2 1	"Sales and Services (ex : salesperson/entrepreneur)" 2	"Agriculture (including fishermen, foresters, and hunters)" 3	"Skilled manual worker (ex : machiner operator/carpenter)" 4	"Unskilled manual worker (ex : road construction/assembler)" 5	"Clerical (ex : secretary)" 6	"Domestic service for another house (e.g. housekeeper)" 7	"Other (specify)"
label values sec8_q4 occupation2


label variable sec8_q4_other_occup	"Please, specify the job"
note sec8_q4 : "Please, specify the job"

label variable sec8_q5 "How much do you yourself earn PER MONTH thanks to your job ?"
note sec8_q5 : "How much do you yourself earn PER MONTH thanks to your job ?"

label variable sec8_q6	"Putting all activities together (including livestock, businesses, wage labour, and other income-generating activities) and considering all the members of the household, in a TYPICAL month how much does your household earn in total?"
note sec8_q6 :"Putting all activities together (including livestock, businesses, wage labour, and other income-generating activities) and considering all the members of the household, in a TYPICAL month how much does your household earn in total?"




///////////////////////////////////////////
//////////////  SECTION 9 /////////////////
///////////////////////////////////////////


label variable sec9_q1 "Did any of your siblings or friend leave Guinea over the last six months ?"
note sec9_q2 : "Did any of your siblings or friend leave Guinea over the last six months ?"
label values sec9_q1 yes_no

label variable sec9_q2 "How many of your classmates left Guinea over the last six  months ?"
note sec9_q2 : "How many of your classmates left Guinea over the last six  months ?"

label variable outside_contact_no "In total, how many familly members or friends living OUTSIDE Guinea and with whom you are in contact do you know ?"
note outside_contact_no : "In total, how many familly members or friends living OUTSIDE Guinea and with whom you are in contact do you know ?"



///////////////////////////////////////////
//////////////  SECTION 10 ////////////////
///////////////////////////////////////////

label variable sec10_q1_1	"Name or nickname of your first contact living outside Guinea"
label variable sec10_q5_1	"In which country does your first contact live ?"

label variable sec10_q1_2	"Name or nickname of your second contact living outside Guinea"
label variable sec10_q5_2	"In which country does your second contact live ?"

/*for version previous to 1812042013
label variable sec10_q1_3	"Name or nickname of your third contact living outside Guinea"
label variable sec10_q5_3	"In which country does your third contact live ?"
*/

label define relation 1	"Spouse/Fiancé(e)" 2	"Mother/Father or parents in law" 3	"Siblings/ Siblings in law" 4	"Other member of my family" 5	"Children" 6	"Friend" 7	"Other"
label define education_long 0	"No formal schooling" 1	"Preschool" 2	"Primary" 3	"Secondary school (lower and upper secondary)" 4	"Post secondary degree (University etc.)" 99	"Don't know"
label define occupation_long 1	"Student" 2	"Sales and Services (ex : salesperson/entrepreneur)" 3	"Agriculture (including fishermen, foresters, and hunters)" 4	"Skilled manual worker (ex : machiner operator/carpenter)" 5	"Unskilled manual worker (ex : road construction/assembler)" 6	"Professional/technical/managerial (e.g. engineer/computer assistant/manager/nurse)" 7	"Clerical (ex : secretary)" 8	"Military" 9	"Domestic service for another house (e.g. housekeeper)" 10	"Housewife" 11	"Unemployed" 99	"Don't know"
label define money_contact 1	"Between 0 and 1 000 000 FG" 2	"Between 1 000 000 and 2 500 000 FG" 3	"Between 2 500 000 and 5 000 000 FG" 4	"Between 5 000 000 and 10 000 000 FG" 5	"Between 10 000 000 and 20 000 000 FG" 6	"More than 20 000 000 FG" 99	"Don't know"
label define freq_contact 1	"At least once a day" 2	"At least once a week" 3	"At least once a month" 4	"At least once every 3 months" 5	"At least once every 6 months" 6	"At least once a year"
label define com_mean 1	"Social Network (ex: Facebook, Twitter)" 2	"Instant Messenger (ex: Whatsapp, Messenger)" 3	"Mobile phone" 4	"Skype" 5	"Email" 6	"Landline" 99	"Other"
label define freq_remittance 1	"Weekly" 2	"Monthly" 3	"Every 3 months" 4	"Every 6 months" 5	"Once a year" 6	"Sporadically (less often than yearly" 7	"Never" 99	"I do not know"
label define alike 1 "Not like him/her at all" 2	"Little like him/her" 3	"Somewhat like hmi/her" 4	"Very much like him/her"




foreach num in 1 2 {

label variable sec10_q2_`num' "What is your relation with your contact ?"
label values sec10_q2_`num' relation

label variable sec10_q3_`num' "What is the gender of your contact ?"
label values sec10_q3_`num' gender 

label variable sec10_q4_`num' "What is the age of your contact ?"

label variable sec10_q6_`num' "What is the highest level of education that your contact has completed ? "
label values sec10_q6_`num' education_long

label variable sec10_q7_`num' "Do you know the current occupation of your contact ? "
label values sec10_q7_`num' occupation_long

label variable sec10_q8_`num' "Do you know how much money does your contact earn per month in GUINEAN FRANCS ?"
label values sec10_q8_`num' money_contact 

label variable sec10_q9_`num' "How often do you contact your relation living outside Guinea ?"
label values sec10_q9_`num' freq_contact

label variable sec10_q10_`num'	"What primary method do you use to contact your contact?"
label values sec10_q10_`num' com_means

label variable sec10_q11_`num'	"Do you generally discuss with your contact about the level of wages in the country where your contact lives?"
label values sec10_q11_`num' yes_no

label variable sec10_q12_`num'	"Do you generally discuss with your contact about job availability in the country where your contact lives ?"
label values sec10_q12_`num' yes_no

label variable sec10_q13_`num'	"Do you generally discuss with your contact about unemployment benefits in the country where your contact lives?"
label values sec10_q13_`num' yes_no

label variable sec10_q14_`num'	"Did you discuss with $your contact about the trip he/she went through to reach the country where he/she is currently living?"
label values sec10_q14_`num' yes_no

label variable sec10_q15_`num'	"Do you generally discuss with your contacthis/her financial situation?"
label values sec10_q15_`num' yes_no

label variable sec10_q16_`num'	"How often has your contact sent/brought remittances (money) to your household in the past year while living where he or she lives now ?"
label values sec10_q16_`num' freq_remittance


label variable sec10_q17_`num'	"What is the total value of remittances (money) your contact has sent/brought to your household in the past year while living where he or she lives now?"
label values sec10_q17_`num' money_contact 

label variable sec10_q18_`num'	"Now imagine a migrant who is NOT doing very well in the country where he/she migrated, but is ashamed of telling the family hence exaggerates news positively (for example by saying he his earning a lot of money!)."
label values sec10_q18_`num' alike


label variable sec10_q19_`num'	"Now imagine a migrant who is doing very well but is afraid that family members will want money if he says so, hence he under-reports his earnings when he talks to them. "
label values sec10_q19_`num' alike

}






***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3 - Cleaning                                     
***_____________________________________________________________________________



//////////////  CLEANING COUNTRY'S NAME ///////////////// 


foreach x in sec2_q2 sec3_21 sec2_q5 sec10_q5_1 sec10_q5_2{
replace `x'=upper(`x')

replace `x'="" if `x'=="UUU" |`x'=="THIERNO MARINA SOW" |`x'=="SEIRALEON" |`x'=="SDIMA" |`x'=="SANKOUMBA" |`x'=="SANA" |`x'=="S SANTIGUI TOURE" |`x'=="ROI" |`x'=="NDEYE DIALLO" |`x'=="MOUSSA" |`x'=="HAFIA" |`x'=="GAJA" |`x'=="FODE MOUSSA BERETE" |`x'=="EN" |`x'=="CONA" |`x'=="CHEICK" |`x'=="BOUBA" | `x'=="BOH SARAN" |`x'=="BALDE" |`x'=="BADEMBA" |`x'=="YOUNONSSA" |`x'=="YARIE" |`x'=="TY" |`x'=="THIERNO BAH" |`x'=="TONTON PAPA" |`x'=="TAMBOUR MORY KAMANO" |`x'=="TAIBOU BAH" |`x'=="SÃ¨" |`x'=="SYLLA" |`x'=="SOS" |`x'=="SILLO KAMONO" |`x'=="SIGURI" |`x'=="SIDIKI" |`x'=="SAÃ¯DOU" |`x'=="SARAH TOURE" | `x'=="SANNY CAMARA OU VERRETY" | `x'=="SALIOU"
replace `x'="" if `x'=="MARIAME" |`x'=="MAMADOU LAMINE DIALLO" | `x'=="MAMADOU LAMARANA" |`x'=="KORKA" |`x'=="KALIL CAMARA" |`x'=="KADIZA" |`x'=="JOAO MIGUEL" |`x'=="AIMÃ© SIDIBE" |  `x'=="SABANA" | `x'=="PAR" |`x'=="PAPA" |`x'=="OUSMANE KEITA" | `x'=="OUSMANE" | `x'=="N'ZEREKORE" | `x'=="N'ASSURE BERETE" | `x'=="MOUSTAPHA" |`x'=="MOHAMED SANOUSSI CAMARA" |`x'=="MOHAMED CONDE" |`x'=="MILÃ©N" |`x'=="MARIE LOUISE CAMARA" |`x'=="MARIE" |`x'=="MARIE" |`x'=="MARIAMA" |`x'=="MARCEILLE" |`x'=="MAMAN" |`x'=="MAMADOU SOW" |`x'=="MAMADOU DIAN" |`x'=="MAMADOU" |`x'=="MAMADI" |`x'=="MAMADAMA" | `x'=="MADOU TOURE"
replace `x'="" if `x'=="MAROMAC" | `x'=="BEN" |`x'=="MA BOSSOIR CAMARA" | `x'=="LIMA KEITA" | `x'=="LERO" |`x'=="KONGUEL" | `x'=="KANABA" | `x'=="KALOU" |`x'=="JOSÃ© DA GAMA" | `x'=="INTERNET" |`x'=="IBRAHIMA KENNEDY BAH" |`x'=="IBRAHIMA DIALLO" | `x'=="IBRAHIMA CAMARA" |`x'=="HABIB BALDE" | `x'=="GOMBO" |`x'=="FODÃ© SYLLA" |`x'=="FATOUMATA MANSARE" | `x'=="GGUI" |`x'=="FANTA" |`x'=="EN GUINÃ©E 625812444" |`x'=="DÃ©DÃ©" |  `x'=="DJEDA" |`x'=="DJADA" |`x'=="DABY" |`x'=="CONTÃ©" |`x'=="CONCON" |`x'=="CISSÃ©" |`x'=="CON" |`x'=="CAMARA" |`x'=="BECKAYE NIANE" | `x'=="BARRY" | `x'=="BANKOKE" | `x'=="BANJUL" |`x'=="BAH" | `x'=="AÃ¯CHA" | `x'=="ANYER"
replace `x'="" if `x'=="VANNE" |`x'=="OUMAR" |`x'=="O" |`x'=="AMINATA TRAORE" |`x'=="AMARA" |`x'=="AMADOU" |`x'=="AMA" |`x'=="ALIOU" |`x'=="ALIMOUDIAWBHE BALDE" |`x'=="ALHASSANE KOUMBASSA" | `x'=="ABJA" | `x'=="ABDOURAHIM" |`x'=="ABDOULAYE CONTE" |`x'=="A CON" |`x'=="NOM" |`x'=="HABA" |`x'=="AMRE" | `x'=="JUIVE" |`x'=="RIEN" |`x'=="99" |`x'=="NON" |`x'=="AUTRE" |`x'=="U.A" | `x'=="SIMONE" |`x'=="POUR PRATIQUE LE SPORT" | `x'=="OUI" | `x'=="JUIF" |`x'=="G" |`x'=="1" | `x'=="12 .0000" | `x'=="2HM" | `x'=="AMRAO" 
replace `x'="" if `x'=="0" | `x'=="6" |`x'=="622113643" |`x'=="622969364" | `x'=="623456789" | `x'=="62354325" | `x'=="9177743205" | `x'=="999" 
replace `x'="" if `x'=="0032488021127"| `x'=="999999999" | `x'=="999" |`x'=="669201012" |`x'=="664969637" | `x'=="664784505" |`x'=="664038791" | `x'=="661708083" |`x'=="661202160" | `x'=="656722464"|`x'=="656400987"|`x'=="0077243"|`x'=="333753167816" | `x'=="622029210" | `x'=="622691862"

replace `x'="YEMEN" if `x'=="YÃ©MEN"

replace `x'="FRANCE" if `x'=="Ã€ PARIS" |`x'=="MARSEILLE" |`x'=="AVRE" |`x'=="LE HAVRE" | `x'=="FRANCE  LION" | `x'=="FRACNCE" |`x'=="ANGER" | `x'=="JE VOUDRAI HABITER EN FRANCE" | `x'=="MFRANCE" | `x'=="A   PARIS" | `x'=="SKANTE  PARIS" | `x'=="ENFRANCE"|`x'=="NANTES"|`x'=="LYON"| `x'=="FRENCE" | `x'=="FRANCE SAYON CAMARA" | `x'=="FRANCE  002245689" | `x'=="FANCE" |`x'=="SAINT Ã‰TIENNE" | `x'=="TOULOUSE" | `x'=="STRASBOURG" | `x'=="NANTE"| `x'=="MONACO"| `x'=="LION" | `x'=="LILLE" | `x'=="EN FANCE" | `x'=="ÃŽLE DE FRANCE"| `x'=="FRANCE ABACARCONDE" | `x'=="FRANCE 625241415" | `x'=="FRANC" | `x'=="A FRANCE"
replace `x'="FRANCE " if  `x'=="A FANCE" | `x'=="FRANÃ§E" | `x'=="ITALIE APRÃ¨S LA FRANCE" | `x'=="LE PARIE" | `x'=="FRANCS" | `x'=="IA FRANCE" |`x'=="LA FRANÃ§E" | `x'=="FRANÃ§AIS" | `x'=="A PARIS" | `x'=="EN FRANCE" | `x'=="FRANÃ§AIS"| `x'=="LA FRANCE" | `x'=="FRANCE " | `x'==" FRANCE " | `x'=="EN FRANCE, BANQUE" | `x'=="EN FRANCS" | `x'=="EN FRANÃ§E" | `x'=="PARI" | `x'=="PARIS" | `x'=="PARIE"

replace `x'="CANADA" if `x'=="AUCANADA" | `x'=="M'ONT REAL" | `x'=="CANADAN" |`x'=="CANADAN"| `x'=="L'AMÃ©RIQUE PRÃ©CISÃ©MENT AU CANADA" | `x'=="CANADAT" | `x'=="AU CANADAT" | `x'=="EN AMÃ©RIQUE  (CANADA)" | `x'=="Ã€ CANADA" | `x'=="I'AMÃ©RIQUE PRÃ©CISÃ©MENT Ã  CANADA" | `x'=="A CANADA"| `x'=="AU CANADA" | `x'=="GANADA" | `x'=="AU CANADA " | `x'=="KANADA" | `x'=="LE CANADA" | `x'=="CANADA " | `x'==" CANADA " | `x'=="En AmÃ©rique  (Canada)" |`x'=="Ã? CANADA"

replace `x'="GERMANY" if `x'=="ALLEMANG" |`x'=="ALLEMANE" |`x'=="ALMANGNE" | `x'=="ALLEMAGNE 663241415" |`x'=="ALMAGNE" | `x'=="ALLÃ©MAGNE" | `x'=="ALLEMAN3" | `x'=="ALLEAGNE" | `x'=="EN ALLEMAGNE" | `x'=="ALLEMAGNE" | `x'=="ALLEMANGNE" | `x'==" L'ALLEMAGNE" | `x'=="L'ALLEMAGNE"
/*line10*/
replace `x'="UNITED STATES" if `x'=="AMÃ©RIQUE  (NEW YORK )" | `x'=="MON PAYS DE RÃªVE C'EST L'AMÃ©RIQUE" |`x'=="Ã‰TATS-UNIS  D'AMÃ©RIQUE" |`x'=="L'AMÃ‰RIQUE"|`x'=="U SA"| `x'=="AUX ETATS-UNIS"| `x'=="A PHILADELPHIA" | | `x'=="LES Ã‰TATS UNIS D'AMÃ©RIQUE" | `x'=="LES Ã‰TATS UNIS D'AMERIQUE" | `x'=="AUX Ã‰TATS-UNIS" | `x'=="NEW-YORK" | `x'=="U Ã©TAT UNIS" | `x'=="Ã‰TATS UNIS D'AMÃ©RIQUE" | `x'=="Ã‰TAT UNIS" | `x'=="Ã‰TATS-UNIS D'AMÃ©RIQUE" |`x'=="Ã‰TAT UNIS D'AMÃ©RIQUE" | `x'=="USA AMÃ©RIQUE" | `x'=="AU Ã‰TATS-UNIS" | `x'=="A LOS ANGELES" 

replace `x'="UNITED STATES" if `x'=="Ã‰TATS-UNIS D'AMÃ©RIQUE, " | `x'=="PENTAGONE" |`x'=="AUX Ã‰TATS-UNIS D'AMÃ©RIQUE" | `x'=="Ã‰TATUNIS" |`x'=="CALIFORNIE" |`x'=="AMRIQUE" |`x'=="AMERICA" |`x'=="Ã‰TAS UNI D'AMÃ©RIQUE" |`x'==" Ã‰TATS-UNIS  D'AMÃ©RIQUE" |`x'=="Ã‰TAT UNIS AMÃ©RIQUE" |`x'=="Ã‰TAT -UNIS" |`x'=="WASHINGTON" |`x'=="U,.S,A" | `x'=="CHICAGO"| `x'=="USA" |  `x'=="AU Ã©TAT UNIS" | `x'==" Ã‰TATS-UNIS" | `x'=="Ã‰TATS-UNIS" | `x'=="Ã‰TATS UNIS" | `x'==" Ã‰TATS UNIS D'AMÃ©RIQUE" | `x'=="Ã‰TAS UNIS D'AMÃ©RIQUE"| `x'=="Ã‰TAT  UNIS D AMÃ©RIQUE" | `x'=="Ã‰TAT UNIS D'AMÃ‰RIQUE" | `x'==" Ã‰TAT UNIS" | `x'=="Ã‰TAS UNIS" | `x'=="LES USA" | `x'=="U S A" 

replace `x'="UNITED STATES" if `x'=="J'AIMERAIS M'INSTALLER AUX Ã‰TATS-UNIS" |`x'=="AMÃ©RIQUE  (NEW YORK)" |`x'=="ETATS UNIS D'AMERIQUE" |`x'=="ETATS UNIS" |`x'=="ETATS UNIES" |`x'=="U . S.A" | `x'=="ETATS-UNIS D'AMÃ©RIQUE" |`x'=="ETAS UNIS" | `x'=="NEYWORK" | `x'=="NEW YORK" | `x'=="ETAS UNIS" |`x'=="ETAT-UNIS" | `x'=="ETAT UNIS" | `x'=="LOS ANGELES" | `x'=="AU USA" | `x'=="Ã?TATS UNIS D'AMÃ©RIQUE"| `x'=="AUX U .S. A (EN AMÃ©RIQUE )" | `x'==" AUX U .S. A (EN AMÃ©RIQUE ) " | `x'=="Ã?TAS UNIS D'AMÃ©RIQUE" | `x'=="Etats_Unis" | `x'=="Au U.S.A" | `x'=="Ã?TATS-UNIS" | `x'=="Ã?TATS UNIS" | `x'==" Ã?TATS UNIS D'AMÃ©RIQUE" | `x'=="Ã?TAT UNIS D'AMÃ?RIQUE" | `x'=="Ã?TAT UNIS" | `x'=="Ã?TAT  UNIS D AMÃ©RIQUE"| `x'==" Ã?TAS UNIS D'AMÃ©RIQUE"| `x'=="USA D'AMERIQUE"| `x'=="USA AMERIQUE"| `x'=="U.S.A" | `x'=="ETAT-UNIS UNIS" | `x'=="ETATS UNIS D'AMÃ©RIQUE" | `x'=="ETATS-UNIS" | `x'=="EUAMÃ©RIQUE"

replace `x'="EQUATORIAL GUINEA" if `x'=="GUINÃ©E  EQUATORIAL" | `x'=="GUINÃ©E EQUATORIAL" | `x'=="GUINEE EQUATORIALE"

replace `x'="SPAIN" if `x'=="BARCELO6" |`x'=="ESPANCE" |`x'=="ESPAGUE" | `x'==" ESPAGUE" |`x'=="MADRID" | `x'=="ESPANGNE" |`x'=="SPAGNE"| `x'=="ESPAGN"| `x'=="EN MADRID" | `x'=="ESPAGNE" | `x'=="EN ESPAGNE" | `x'=="ESPANE"

replace `x'="BELGIUM" if `x'=="BRUXELLE" |`x'=="BLEGIQUE" | `x'=="BELGIQU" |`x'=="IA BELGIQUE" | `x'=="BELGIQUE 0032465789089" | `x'=="BERGIQUE"| `x'=="BELGIQUE" | `x'=="EN BELGIQUE" | `x'=="BELSIQUE" | `x'=="LA BELGIQUE"

replace `x'="ENGLAND" if `x'=="ANGLETTE" |`x'=="ANGLETAIS" | `x'=="LONDRES" | `x'=="ANGLLETERE" | `x'=="LONDON"| `x'=="BINTA BARRY  ANGLETERRE"| `x'=="EN ENGLETERRE" | `x'=="ANGLERRE" | `x'=="ANGLETERRE" |  `x'=="ENGLETTERE"  | `x'=="ANGLETERE"| `x'=="L'ANGLETERRE" | `x'=="ANGLETAIRE" | `x'=="EN ANGLETERRE" | `x'=="ENGLETERRE" | `x'=="ENGLETTERRE" | `x'=="LONDRE" | `x'=="LONDRE"

replace `x'="UNITED STATES" if `x'=="ETAS UNIS AMERIQUE"| `x'=="LESUSA"| `x'=="ETAT UNIE"| `x'=="AMÃ©RICAIN"| `x'=="AMÃ©RIQUES" | `x'=="AMERQUE" | `x'=="AMERICAINE" | `x'=="AMERIQUE" | `x'=="LA L'AMÃ©RIQUE" |`x'=="L'AMÃ©RIQUE" | `x'=="AMERIC" | `x'=="EN AMERIQUE" | `x'=="AMERIQEU"| `x'=="AMÃ©RIQUE" | `x'==" EN AMERIQUE" | `x'=="EN AMÃ©RIQUE" | `x'=="L' AMERIQUE"| `x'=="L' AMÃ©RIQUE"| `x'=="L'AMERIQUE"| `x'==" L'AMÃ©RIQUE"

replace `x'="ITALY" if `x'=="LATE ITALI" | `x'=="ITALI 664971432" | `x'=="POUR LE MOMENT C'EST EN ITALIE" | `x'=="L'ITALIE" |`x'=="ITAY" |`x'=="ITALIA" | `x'=="ROME" | `x'=="ITALIE"  | `x'=="EN ITALI" | `x'=="ITALI" | `x'=="ITALY" | `x'=="EN ITALIE"

replace `x'="RUSSIA" if  `x'=="RUISSIE"| `x'=="MOSCOW" | `x'=="LA RUSSIE" | `x'=="RUSSIE"

/*line 20*/
replace `x'="TOGO" if `x'=="AU TOGO"

replace `x'="EUROPE" if `x'=="EN EUROPE" | `x'=="Ã€ L'EUROPE" | `x'=="L'EUROPE" | `x'=="LÃ? L'EUROPE" | `x'=="IEUROPE" | `x'=="EROPE"

replace `x'="NETHERLANDS" if `x'=="PAYS BAS" |`x'=="OLENDE" | `x'=="HOLANDE" | `x'=="HOLLAND"| `x'=="PAYBAS" | `x'=="HOLLANDE" | `x'==" HOLLANDE" | `x'=="LES PAYS BAS" | `x'=="HOLAND"

replace `x'="SAUDI ARABIA" if `x'=="MECQUE" | `x'=="ARABIE SAOUDITE" | `x'=="EN ARABI SAOUDITE" | `x'=="ARABIS SAODI" | `x'=="ARABE SAOUDI" | `x'=="EN ARABE SAOUDITE"  | `x'==" ARABIS SAODI" | `x'=="SAODIA" | `x'=="SAOUDI" | `x'=="SAOUDIA" | `x'=="SAOUDINE"

replace `x'="MOROCCO" if `x'=="MACOC"|`x'=="RABAT"| `x'=="MARAOC"| `x'=="MARCO" | `x'=="LE MAROC" | `x'=="AU MAROC" | `x'=="MAROC"

replace `x'="AUSTRALIA" if `x'=="A LA AUSTRALIE" |`x'=="AUSTRALIE" | `x'=="AUSTRALI" | `x'=="POUR TRAVAILLER SURTOUT EN AUSTRALIE" | `x'=="EN AUSTRALIE"

replace `x'="" if `x'=="MATOTO"  |`x'=="LA GUINÃ©E CONAKRY"  |`x'=="LANSANAYAH"  |`x'=="LA GUINÃ©E  CONAKRY"  | `x'=="IL VIT EN GUINÃ©E"  | `x'=="GUINÃ‰E"  |`x'=="LE GUINÃ©E" |`x'=="LA GUINÃ‰E" | `x'=="FRIA"| `x'=="COONAKRRY" |`x'=="CNAKRY" | `x'=="CANAKRY" | `x'=="MAMOU" | `x'=="KANKAN" | `x'=="Ã€ CONACKRY"| `x'=="LA GUINÃ¨E"| `x'=="LA GUINNEE"| `x'=="IL GUINE"| `x'=="IA GUINÃ©E" | `x'=="GUINÃ©E CONAKRY"| `x'=="GUINNEE" | `x'=="GUINNE" | `x'=="GUINEEE" | `x'=="GUINEA" | `x'=="EN GUINNEE" | `x'=="EN GUINEE"| `x'=="CONACKRY"| `x'=="CON1KRY"| `x'=="COKNARY"| `x'=="A CONAKRY"|`x'=="GUINEE"| `x'=="CONAKRY" | `x'=="A' CONAKRG" | `x'=="SANGOYAH" | `x'=="A CONAKRG" | `x'=="EN GUINÃ©E" | `x'=="GUINÃ©E" | `x'=="GUINÃ©E  CONAKRY" |  `x'=="LA GUINÃ©E"

replace `x'="IVORY COAST" if `x'=="EN CÃ´TÃ© D'IVOIRE" |`x'=="EN CÃ´TE D'IVOIRE" |`x'=="CÃ´TÃ© D 'IVOIRE" |`x'=="COTE D'IVOIRE" |`x'=="ABIDJAN" | `x'=="IVOIRE"| `x'=="CÃ´TÃ© DIVOIRE" | `x'=="CÃ´TÃ© D'IVOIRE" | `x'=="CÃ´TÃ© D'IVOIR" | `x'=="COTE D IVOR" | `x'=="CÃ´TE DIVOIR" | `x'=="CÃ´TE D'IVOIRE" | `x'==" CÃ´TE DIVOIR"

replace `x'="IVORY COAST" if `x'=="EN CÃ´TE IVOIRE" |`x'=="CÃ´TE-D'IVOIRE" |`x'=="CÃ´TE D'IVOIR" | `x'=="CÃ´TE DIVOIRE" | `x'=="CÃ´TÃ© D IVOIRE" | `x'=="CÃ´TÃ© IVOIRE"

replace `x'="UNITED KINGDOM" if `x'=="ROYAUM UNI" | `x'=="ROYAUME-UNI"
*line 30
replace `x'="EGYPT" if `x'=="EN Ã‰GYPTE" | `x'=="Ã‰GYPTE" | `x'=="EGYPE" | `x'=="EJIPT" | `x'=="EGYPTE"

replace `x'="BRAZIL" if `x'=="BRASIL" |`x'=="BRÃ¨SIL"| `x'=="BRESIL"| `x'=="BRÃ©SIL" | `x'=="AU BRAZIL"

replace `x'="GREECE" if `x'=="GRECEE" |  `x'=="GRECE" | `x'=="GRÃ¨CE"

replace `x'="QATAR" if `x'=="KATAR" | `x'=="QUATAR"

replace `x'="ALGERIA" if `x'=="ALGERI"|`x'=="ALGER"| `x'=="ALGÃ©RIE" | `x'=="ALGERI"

replace `x'="NIGERIA" if `x'=="LAGOS"

replace `x'="JAMAICA" if `x'=="LION DU FOUTA JAMAIK"

replace `x'="DUBAI" if `x'=="DOUBAÃ¯" |`x'=="DUBAÃ¯" | `x'=="DOUBAI" | `x'=="DOUBAYE"

replace `x'="TURKEY" if `x'=="TURQUIS" | `x'=="TURKIE" | `x'=="TURQUIE" | `x'=="USTANBUL"

replace `x'="INDIA" if `x'=="INDE" |`x'=="INDI"

replace `x'="KOWIET" if `x'=="KOWEÃ¯T" 

replace `x'="JAPAN" if `x'=="JAPON"

replace `x'="ICELAND" if `x'=="ISLANDE"
*line40
replace `x'="VIETNAM" if `x'=="HANOÃ¯"

replace `x'="ALGERIA" if `x'=="ALGERIE"

replace `x'="ANGOLA" if `x'=="ANGOLALA" | `x'=="ENGOLA" |`x'=="LUANDA" | `x'=="Ã€ LOUANDA" |`x'=="LWOUANDA"

replace `x'="AUSTRIA" if `x'=="AUTRICHE"

replace `x'="MALI" if `x'=="AU MALI" |`x'=="MALI 664334354" 

replace `x'="GABON" if `x'=="AU GABON" | `x'=="GHABON"

replace `x'="DON'T KNOW" if `x'=="JE NE CONNAIS" |`x'=="JE NE CONNAI" | `x'=="JE SAIS PAS" | `x'=="JE NE SAIS PAS"

replace `x'="BURKINA FASSO" if `x'=="BURKINA"

replace `x'="BENIN" if `x'=="BÃ©NIN" | `x'=="BÃ©NIN +223 7539  87"

replace `x'="LIBYA" if `x'=="LIBYE" | `x'=="LYBIE" | `x'=="IIBY"
*line50
replace `x'="CONGO" if `x'=="CONCO" | `x'=="CONGO BRAZZAVILLE"

replace `x'="GAMBIA" if `x'=="GAMBIE"

replace `x'="GHANA" if `x'=="GANAH" |`x'=="ACRA"

replace `x'="SIERRA LEONE" if `x'=="SIERRA  LÃ©ON" |`x'=="SIERRA-LEONNE" |`x'=="SIERRA LÃ©ON" | `x'=="SERRA LÃ©ONE" | `x'=="SIERRA LEONNE"| `x'=="LA SIERRA LÃ©ONE"

replace `x'="LIBERIA" if `x'=="LIBÃ©RIA" | `x'=="IIBERIA" | `x'=="LIBERIA 00231888989734" |`x'=="LIBERIA 6662678754"

replace `x'="MALAISIA" if `x'=="MALAISIE" | `x'=="MALESIE"

replace `x'="SWITZERLAND" if `x'=="SUISSE" | `x'=="LA SUISSE" | `x'=="SUSSE"  | `x'=="GENÃ¨VE" 

replace `x'="SENEGAL" if `x'=="SENGAL" |`x'=="SENEGAL 624341513" | `x'=="SÃ©NEGALE" |`x'=="SÃ©NEGAL" | `x'=="AU SÃ©NÃ©GAL" | `x'=="SEGALE" | `x'=="SÃ©NÃ©GAL  00221 77 918 45" | `x'=="SÃ©NÃ©GAL"|`x'=="SEGAL" | `x'=="SENEGALE" | `x'=="DAKAR"

replace `x'="TUNISIA" if `x'=="TUNISIE"

replace `x'="THAILAND" if `x'=="TAILAND" | `x'=="TAILLAND"

replace `x'="GUINEA BISSAU" if `x'=="GUINEE-BISSAU" |`x'=="GUINÃ©E-BISSAU" | `x'=="GUINÃ©E BISSAU" | `x'=="BISSAU"

replace `x'="NORWAY" if `x'=="NORVÃ¨GE" | `x'=="NORVEGE"

replace `x'="MALI" if `x'=="BAMAKO"

replace `x'="SWEDEN" if `x'=="SUEDE" | `x'=="SUÃ¨DE"

replace `x'="MAURITANIA" if `x'=="MAURITANI" | `x'=="A MORRITANI" |`x'=="MORRITANI" | `x'=="MAURITANIE"

replace `x'="IRELAND" if  `x'=="IRLANDE DU NORD" | `x'=="A IRLANDE" | `x'=="IRLANDE"

replace `x'="SOUTH AFRICA" if `x'=="AFRIQUE DU SUD"

replace `x'="CHINA" if `x'=="CHINE"

replace `x'="SOUTH KOREA" if `x'=="CORÃ©E"| `x'=="CORÃ©E  DU SUD"| `x'=="CORRÃ© DU SUD" | `x'=="CORÃ© DU SUD"

replace `x'="POLAND" if `x'=="POLOGNE"

}



//////////////  SECTION 0 ///////////////// 
encode commune, gen(communes)
drop commune
rename communes commune


*error in the name of the lycee in the list deployed on the tablet
* - actif no longer exist
* - we have to distinguish SOPHIAPOLE DE MATOTO et SOPHIAPOLE DE RATOMA
*- I downloaded the wrong lycee list on February, 6.
replace lycee_name="MOHAMED BARRY" if lycee_name=="ACTIF"

replace lycee_name="SOPHIAPOLE DE RATOMA" if lycee_name=="SOPHIAPOLE" & starttime_new_date== date("01/21/19","MDY",2020)

replace lycee_name="JOHN KENNEDY" if lycee_name=="OUMAR CAMARA" & starttime_new_date== date("02/06/19","MDY",2020)

replace lycee_name="KOUMANDIAN KEITA 3" if lycee_name=="GUELO" & starttime_new_date== date("02/06/19","MDY",2020)

replace lycee_name="SAINTE MARIE DE RATOMA" if lycee_name=="LYCEE KIPE" & starttime_new_date== date("02/06/19","MDY",2020)

gen lycee_name_string=lycee_name

encode lycee_name, gen(lycee_names)
drop lycee_name
rename lycee_names lycee_name


*sec0_q3
split sec0_q3 
replace sec0_q32="1" if sec0_q32=="janv."
replace sec0_q32="2" if sec0_q32=="fÃ©vr."
replace sec0_q32="3" if sec0_q32=="mars"
replace sec0_q32="4" if sec0_q32=="avr."
replace sec0_q32="5" if sec0_q32=="mai"
replace sec0_q32="6" if sec0_q32=="juin"
replace sec0_q32="7" if sec0_q32=="juil."
replace sec0_q32="8" if sec0_q32=="aoÃ»t"
replace sec0_q32="9" if sec0_q32=="sept."
replace sec0_q32="10" if sec0_q32=="oct."
replace sec0_q32="11" if sec0_q32=="nov."
replace sec0_q32="12" if sec0_q32=="dÃ©c."

g birth_date=sec0_q32 +"-" + sec0_q31 + "-"+ sec0_q33 
gen birth_date_new=date(birth_date, "MDY",2019)
format birth_date_new %td

drop sec0_q3
rename birth_date_new sec0_q3
label variable sec0_q3 "What is your birth date ?"
note  sec0_q3 : "What is your birth date ?"

drop birth_date sec0_q31 sec0_q32 sec0_q33


*cleaing names
foreach x in sec0_q1_a sec0_q1_b {
replace `x'=lower(`x')

replace `x'= subinstr(`x',"Ã¯","ï",.)
replace `x'= subinstr(`x',"Ã©","é",.)
replace `x'= subinstr(`x',"Ã§","ç",.)
replace `x'= subinstr(`x',"Ã¶","ö",.)
replace `x'= subinstr(`x',"Ã‰","é",.)
replace `x'= subinstr(`x',"Ã¨","é",.)
replace `x'= subinstr(`x',"Ã«","ë",.)
}


* sec0_q6
replace sec0_q6="Don't know/Don't know want to answer" if sec0_q6=="999999999"


*sec0_q6_mail
replace sec0_q6_mail="Don't know" if sec0_q6_mail=="99"

*contact phone number
replace phone_contact1="Don't know/Don't want to answer" if phone_contact1=="999999999"
replace phone_contact2="Don't know/Don't want to answer" if phone_contact2=="999999999"



//////////////  SECTION 1 ///////////////// 
//mother//
*sec1_3 
gen sec1_3_bis=sec1_3
replace sec1_3_bis=5 if sec1_2==2
label variable sec1_3_bis "Where is your mother living ? (with the category not alive)"
note sec1_3_bis : "Where is your mother living ? (with the category not alive)"
label define place_short2 1 "In Conakry" 2"Outside Conakry, in Guinea" 3 "Outside Guinea, in Africa" 4 "Other" 5"Not alive"
label values sec1_3_bis place_short2

*sec1_7
replace sec1_7=2 if sec1_2==2

*sec1_8
gen sec1_8_bis=sec1_8
replace sec1_8_bis=9 if sec1_7==2
label variable sec1_8_bis "Over the last 12 months, what has been her main occupation (with the category no occupation) ?"
note sec1_8_bis : "Over the last 12 months, what has been her main occupation (with the category no occupation) ?"
label define occupation_short2  1 "Sales and Services (ex : salesperson/entrepreneur)" 2	"Agriculture (including fishermen, foresters, and hunters)" 3	"Skilled manual worker (ex : machiner operator/carpenter)" 4	"Unskilled manual worker (ex : road construction/assembler)" 5	"Professional/technical/managerial (e.g. engineer/computer assistant/manager/nurse)" 6	"Clerical (ex : secretary)" 7	"Military/Paramilitary" 8 "Domestic service for another house (e.g. housekeeper)" 9 "No occupation" 99	"Don't know"
label values sec1_8_bis occupation_short2

gen sec1_8_long=sec1_8_bis
replace sec1_8_long=10 if sec1_2==2
label variable sec1_8_long "Over the last 12 months, what has been her main occupation (with the category no occupation) ?"
note sec1_8_long : "Over the last 12 months, what has been her main occupation (with the category no occupation) ?"
label define occupation_short3  1 "Sales and Services (ex : salesperson/entrepreneur)" 2	"Agriculture (including fishermen, foresters, and hunters)" 3	"Skilled manual worker (ex : machiner operator/carpenter)" 4	"Unskilled manual worker (ex : road construction/assembler)" 5	"Professional/technical/managerial (e.g. engineer/computer assistant/manager/nurse)" 6	"Clerical (ex : secretary)" 7	"Military/Paramilitary" 8 "Domestic service for another house (e.g. housekeeper)" 9 "No occupation" 10 "Not alive" 99	"Don't know"
label values sec1_8_long occupation_short3



//father//
*sec1_3 
gen sec1_10_bis=sec1_10
replace sec1_10_bis=5 if sec1_9==2
label variable sec1_10_bis "Where is your father living ? (with the category not alive)"
note sec1_10_bis : "Where is your father living ? (with the category not alive)"
label values sec1_10_bis place_short2

*sec1_7
replace sec1_14=2 if sec1_9==2

*sec1_8
gen sec1_15_bis=sec1_15
replace sec1_15_bis=9 if sec1_14==2
label variable sec1_15_bis "Over the last 12 months, what has been his main occupation (with the category no occupation) ?"
note sec1_15_bis : "Over the last 12 months, what has been his main occupation (with the category no occupation) ?"
label values sec1_15_bis occupation_short2


gen sec1_15_long=sec1_15_bis
replace sec1_15_long=10 if sec1_9==2
label variable sec1_15_long "Over the last 12 months, what has been her main occupation (with the category no occupation) ?"
note sec1_15_long : "Over the last 12 months, what has been her main occupation (with the category no occupation) ?"
label values sec1_15_long occupation_short3



//////////////  SECTION 2 ///////////////// 

#delimit cr
*sec2_q3_other_reasonmig
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="99"


*sec2_q4
gen sec2_q4_bis=sec2_q4
replace sec2_q4_bis=2 if sec2_q1==2
label variable sec2_q4_bis "Are you planning to move permanently to another country in the newt 12 months, or not ? (with no if they do not want to stay permanently in Guinea)"
note sec2_q4_bis : "Are you planning to move permanently to another country in the newt 12 months, or not ? (with no if they do not want to stay permanently in Guinea)"
label values sec2_q4_bis yes_no


#delimit cr
*sec2_q9
split sec2_q9
replace sec2_q92="1" if sec2_q92=="janv."
replace sec2_q92="2" if sec2_q92=="fÃ©vr."
replace sec2_q92="3" if sec2_q92=="mars"
replace sec2_q92="4" if sec2_q92=="avr."
replace sec2_q92="5" if sec2_q92=="mai"
replace sec2_q92="6" if sec2_q92=="juin"
replace sec2_q92="7" if sec2_q92=="juil."
replace sec2_q92="8" if sec2_q92=="aoÃ»t"
replace sec2_q92="9" if sec2_q92=="sept."
replace sec2_q92="10" if sec2_q92=="oct."
replace sec2_q92="11" if sec2_q92=="nov."
replace sec2_q92="12" if sec2_q92=="dÃ©c."

g migration_date_new=sec2_q92 +"-" + "-"+ sec2_q93 
gen migration_date=date(migration_date_new, "MY",2050)
format migration_date %td

rename sec2_q93 sec2_q9_year
rename sec2_q92 sec2_q9_month
drop migration_date_new sec2_q91 sec2_q9
rename migration_date sec2_q9

label variable sec2_q9 "In which month/year are you planning to leave Guinea?"
note sec2_q9 : "In which month/year are you planning to leave Guinea?"

label variable sec2_q9_year "In which year are you planning to leave Guinea?"
note sec2_q9_year : "In which year are you planning to leave Guinea?"


label variable sec2_q9_month "In which month are you planning to leave Guinea?"
note sec2_q9_month : "In which month are you planning to leave Guinea?"


*sec2_q13
replace sec2_q13="" if sec2_q13=="99"
replace sec2_q14="" if sec2_q14=="99"
replace sec2_q15="" if sec2_q15=="99"




//////////////  SECTION 3 /////////////////
destring sec3_36,replace

*issues with 99 and 999 !!!!!!!!!!!
foreach var of local proba {
replace `var'=. if `var'==999
}


foreach var of local money_quest {
replace `var'=. if `var'==99
}


*sec3_21
replace sec3_21="" if sec3_21=="99"

/*gen sec3_21_7cat=sec3_21
replace sec3_21_7cat="OTHER" if sec3_21_nb_other!=""
label variable sec3_21_7cat "Consider one Guinean person who is EXACTLY LIKE YOU. Suppose he or she has to choose his or her way to migrate to Europe from Guinea. Which EUROPEAN COUNTRY would he/she plan to settle in ?"
note sec3_21_7cat: "Which EUROPEAN COUNTRY would he/she plan to settle in ?"
*/

drop sec3_21_nb sec3_21_nb_other



*new variable road selection. this variables combines the 2 questions on road selection
gen road_selection=sec3_31_bis if ceuta_awareness!=5
replace road_selection=sec3_22 if ceuta_awareness==5 | ceuta_awareness==.
label variable	road_selection "Road selection : Which road would he/she select to go to sec3_21 ?"
note road_selection : "Which road would he/she select to go to sec3_21 ?"
label define road_selection 1 "Take a boat to ITALY." 2 "Take a boat to Spain." 3 "Climb over the fence of ceuta or MELILLA."
label values road_selection road_selection



*new variable expectation_wage. This variables deals with errors with the 0 + incoherent values
destring sec3_34_error_millions,replace
destring sec3_34_error_thousands, replace

gen expectation_wage=sec3_34
replace  expectation_wage=sec3_34_error_millions if sec3_34_error_millions_2==1
replace expectation_wage=sec3_34_error_thousands if sec3_34_error_thousands_2==1

replace  expectation_wage=sec3_34_bis if sec3_34_error_millions_2==2
replace expectation_wage=sec3_34_bis if sec3_34_error_thousands_2==2

label variable expectation_wage "Cleaned expected wage : Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH ? Please, write the amount converted in Guinean Francs."
note expectation_wage : "Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH ? Please, write the amount converted in Guinean Francs."


*new variable expected living_cost
gen living_cost=sec3_42

label variable living_cost "Expected living cost : Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
note living_cost : "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."



*lottery : risk
*generating a variable that indicates at which lottery the students stopped to answer.
gen sec6_lottery_risk=""
forvalues num = 15/30{
replace sec6_lottery_risk="sec6_lottery`num'" if sec6_lottery`num'==2
}

*if students wants more than 150 000 FG.
replace sec6_lottery_risk="sec6_lottery17" if sec6_lottery30==1
*if students accepts 100 euros and accept 1000 this means that they stop at 100.
replace sec6_lottery_risk="sec6_lottery15" if sec6_lottery15==2 & sec6_lottery_risk=="sec6_lottery16"

*putting a missing values if the did not finished to answer to this section : they refuse 1000 and stop answering question 17.
replace sec6_lottery_risk="" if sec6_lottery16==1 & sec6_lottery17==.


rename sec6_lottery_risk sec6_lottery_risk2
encode sec6_lottery_risk2, gen(sec6_lottery_risk)
drop sec6_lottery_risk2

# delimit ;
label variable sec6_lottery_risk "Amount that the student wants to receive instead of participating to the lottery";
label define risk 
1"Receiving 100 FG for sure."
2"Receiving 10 000 FG for sure."
3"Receiving 20 000 FG for sure."
4"Receiving 30 000 FG for sure."
5"Receiving 40 000 FG for sure."
6"Receiving 50 000 FG for sure."
7"Receiving 60 000 FG for sure."
8"Receiving 70 000 FG for sure."
9"Receiving 80 000 FG for sure."
10"Receiving 90 000 FG for sure."
11"Receiving 100 000 FG for sure."
12"Receiving 110 000 FG for sure."
13"Receiving 120 000 FG for sure."
14"Receiving 120 000 FG for sure."
15"Receiving 140 000 FG for sure."
16"Receiving 150 000 FG for sure."
17"Receiving More than 150 000 FG for sure." ;
label values sec6_lottery_risk risk
;



# delimit cr

*lottery : time preferences
*generating a variable that indicate at which lottery the students stopped to answer.
gen sec6_lottery_time=""
forvalues num = 1/14{
replace sec6_lottery_time="sec6_lottery`num'" if sec6_lottery`num'==2
}


replace sec6_lottery_time="sec6_lottery01" if sec6_lottery_time=="sec6_lottery1"
replace sec6_lottery_time="sec6_lottery02" if sec6_lottery_time=="sec6_lottery2"
replace sec6_lottery_time="sec6_lottery03" if sec6_lottery_time=="sec6_lottery3"
replace sec6_lottery_time="sec6_lottery04" if sec6_lottery_time=="sec6_lottery4"
replace sec6_lottery_time="sec6_lottery05" if sec6_lottery_time=="sec6_lottery5"
replace sec6_lottery_time="sec6_lottery06" if sec6_lottery_time=="sec6_lottery6"
replace sec6_lottery_time="sec6_lottery07" if sec6_lottery_time=="sec6_lottery7"
replace sec6_lottery_time="sec6_lottery08" if sec6_lottery_time=="sec6_lottery8"
replace sec6_lottery_time="sec6_lottery09" if sec6_lottery_time=="sec6_lottery9"

*if students wants more than 150 000 FG.
replace sec6_lottery_time="sec6_lottery14_More" if sec6_lottery14==1
*if students accepts 200 100 euros today and accept 240 000 in 2 month this means that they stop at 200 100.
replace sec6_lottery_time="sec6_lottery02" if sec6_lottery2==2 & sec6_lottery_time=="sec6_lottery01"

*putting a missing values if the did not finished to answer to this section : they refuse 1000 and stop answering question 17.
replace sec6_lottery_time="" if sec6_lottery2==1 & sec6_lottery3==.


rename sec6_lottery_time sec6_lottery_time2
encode sec6_lottery_time2, gen(sec6_lottery_time)
drop sec6_lottery_time2

# delimit ;
label variable sec6_lottery_time "Amount that the student would like to receive tomorrow instead of receiving 200 000 FG today";
label define time
1"Receiving 200 100 FG IN 2 MONTHS"
2"Receiving 240 000 FG IN 2 MONTHS"
3"Receiving 280 000 FG IN 2 MONTHS"
4"Receiving 320 000 FG IN 2 MONTHS"
5"Receiving 360 000 FG IN 2 MONTHS"
6"Receiving 400 000 FG IN 2 MONTHS"
7"Receiving 440 000 FG IN 2 MONTHS"
8"Receiving 480 000 FG IN 2 MONTHS"
9"Receiving 520 000 FG IN 2 MONTHS"
10"Receiving 560 000 FG IN 2 MONTHS"
11"Receiving 600 000 FG IN 2 MONTHS"
12"Receiving 640 000 FG IN 2 MONTHS"
13"Receiving 680 000 FG IN 2 MONTHS"
14"Receiving 720 000 FG IN 2 MONTHS"
15"Receiving more than 720 000 FG IN 2 MONTHS"
;
label values sec6_lottery_time time;



//////////////  SECTION 7 ///////////////// 
#delimit cr

foreach var in sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m {
replace `var'=0 if `var'==2
label values `var' yes_no_bis
}

egen sec7_index=rowtotal(sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m)
label variable sec7_index "Index summarizing the items own by the household"
note sec7_index: "Index summarizing the items own by the household."

*putting a missing values for the index if one of the variables "sec7_q6" is missing"
egen missing_item=rowmiss(sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m)
replace sec7_index=. if  missing_item!=0
drop missing_item


///French television///
*adding students who do no watch Tv to stuents that do not watch French TV
 gen sec7_q9_bis=sec7_q9
 replace sec7_q9_bis=6 if sec7_q8==6
 
 
 
 
//////////////  SECTION 8 /////////////////
*creating a variable similar to sec8_q4 but with the category "no occupation"
gen sec8_q4_bis=sec8_q4
replace sec8_q4_bis=8 if sec8_q3==2

label variable sec8_q4_bis	"During the LAST MONTH, what was your main job beside studying ?"
note sec8_q4_bis: "During the LAST MONTH, what was your main job beside studying ?"
label define occupation2_bis 1	"Sales and Services (ex : salesperson/entrepreneur)" 2	"Agriculture (including fishermen, foresters, and hunters)" 3	"Skilled manual worker (ex : machiner operator/carpenter)" 4	"Unskilled manual worker (ex : road construction/assembler)" 5	"Clerical (ex : secretary)" 6	"Domestic service for another house (e.g. housekeeper)" 7	"Other (specify)" 8 "No occupation"
label values sec8_q4_bis occupation2_bis


*dealing with missing values for sec8_q5
replace sec8_q5=. if sec8_q5==99

*creating a variable similar to sec8_q5 but with 0 if students do not work
gen sec8_q5_bis=sec8_q5
replace sec8_q5_bis=0 if sec8_q3==2
label variable sec8_q5_bis "How much do you yourself earn PER MONTH thanks to your job ?"
note sec8_q5_bis: "How much do you yourself earn PER MONTH thanks to your job ?"




*dealing with missing values for sec8_q6
replace sec8_q6=. if sec8_q6==99


replace sec10_q1_1="" if sec10_q1_1=="99"
replace sec10_q5_1="" if sec10_q5_1=="99"
replace sec10_q1_2="" if sec10_q1_2=="99"
replace sec10_q5_2="" if sec10_q5_2=="99"


replace sec10_q4_1=. if sec10_q4_1==99
replace sec10_q4_2=. if sec10_q4_1==99





# delimit ;
order submissiondate starttime endtime deviceid subscriberid simid devicephonenum 
consent_agree commune lycee_name lycee_name_string sec0_q1_a sec0_q1_b sec0_q2 sec0_q3 sec0_q4 sec0_q5_a sec0_q5_b sec0_q5_b sec0_q6 sec0_q6_fb sec0_q6_mail name_contact1 phone_contact1 name_contact2 phone_contact2 sec0_q7 sec0_q8 sec0_q10 sec0_q11
no_family_member sec1_2 sec1_3 sec1_3_bis sec1_5 sec1_6 sec1_7 sec1_8 sec1_8_bis sec1_8_long sec1_9 sec1_10 sec1_10_bis sec1_12 sec1_13 sec1_14 sec1_15 sec1_15_bis sec1_15_long sister_no brother_no
sec2_q1 sec2_q2 sec2_q3 sec2_q3_1 sec2_q3_2 sec2_q3_3 sec2_q3_4 sec2_q3_5 sec2_q3_6 sec2_q3_7 sec2_q3_other_reasonmig sec2_q4 sec2_q5 sec2_q7 sec2_q7_example sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3 sec2_q8 sec2_q9_month sec2_q9_year sec2_q9 sec2_q10_a sec2_q10_b sec2_q10_c sec2_q11 sec2_q12 sec2_q13 sec2_q14 sec2_q15
italy_awareness italy_duration italy_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_die_bef_boat italy_die_boat italy_sent_back 
spain_awareness spain_duration spain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_die_bef_boat spain_die_boat spain_sent_back sec3_21 sec3_22
ceuta_awareness ceuta_duration ceuta_journey_cost ceuta_beaten ceuta_forced_work ceuta_kidnapped ceuta_die_bef_boat ceuta_die ceuta_sent_back sec3_31 sec3_31_bis
sec3_32 sec3_34 sec3_34_error_millions sec3_34_error_thousands sec3_34_error_millions_2 sec3_34_error_thousands_2 sec3_34_bis sec3_35 sec3_36 sec3_37 sec3_38 sec3_39 sec3_40 sec3_41 sec3_42;


*erros in lycee_name : some students have mispecified the name of their school
*we decided to delete those data
# delimit ;
drop if key=="uuid:cae4c6a9-f65f-4a96-bcf8-a7ed0625ee5d" |
key=="uuid:594fba17-4ae4-41a8-a93b-81f045c05f07" |
key=="uuid:c7c3ff88-0f30-4f4d-8fde-d0c7b269f570" |
key=="uuid:cbcf6559-b3dc-4d60-9001-d1ec90b0a563" |
key=="uuid:20982cb3-3faf-4c1a-987e-96a98cfd594f" |
key=="uuid:935c2ca5-ae3e-4a9f-a2e8-2b9b22b6bd60" |
key=="uuid:479c52e1-5a97-4bd4-bc8d-7fa445ea010a" |
key=="uuid:cf8a4a12-196a-4107-9b50-e433ca98ca9c" |
key=="uuid:bc0a6456-ad48-4e27-989a-49c464b2cb61" |
key=="uuid:896b317b-d5b3-4e66-ae4f-83a9fbfca4e7" |
key=="uuid:3df3820a-7ed3-4226-ab28-eb65bd88a952";
# delimit cr


*erros in lycee_name


save "$main/Data/output/baseline/questionnaire_baseline_clean_rigourous_cleaning.dta", replace

