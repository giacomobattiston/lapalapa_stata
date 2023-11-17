/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :    	05 - CLEANING ENDLINE PHONE DATA
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*05_cleaning_followup2_phone.do
Date Created:  May 2, 2020
Date Last Modified: June 5, 2020
Created by: Laïla SOUALI
Last modified by: Laïla SOUALI
*	Inputs: .dta file "guinea_endline_phone_corrected.dta"
*	Outputs: "questionnaire_endline_phone_clean.dta"

*Outline :
- 0 - Parameters
- 1 - Reading the data
- 2 - Labeling
	2.1- Student Survey
	2.2- Contact Survey
- 3 - cleaning	
	3.1 - Cleaning countries names
	3.2 - Cleaning continent names
	3.3 - Cleaning text variables
- 4 - Joining student and contact surveys
	4.1 - Adding variables for a second contact surveys
	4.2 - 3 duplicates (1 student, 2 contacts)
	4.3 - Only 2 duplicates
	4.4 - Merging
- 5 - Labeling variables from second contact survey
- 6 - Cleaning dates
- 7 - Saving dataset
*/ 

* initialize Stata
clear all
set more off

*Laïla user
global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

********************************************************************************
//,\\'//,\\'//,\\'//,\\           PARAMETERS            //,\\'//,\\'//,\\'//,\\'
********************************************************************************

/*data type*/
local note_fields1 "note_consent note_friend1 note_friend2 note_sec1_a note_sec1_b note_sec1_c note_sec1_d note_sec2_a note_sec2_b note_sec3_a note_sec3_b note_sec3_e note_sec3_g note_sec3_h note_sec3_i_a note_sec3_i_b"
local note_fields2 "note_sec3_i_c note_sec4 note_sec5 note_sec6_a note_sec6_b note_sec7_a note_sec7_b note_sec7_c note_sec9 note_sec10_a note_sec10_b note_sec10_c note_fin"
local text_fields1 "deviceid subscriberid simid devicephonenum time_begin commune lycee_name sec0_q1_a sec0_q1_b sec0_q5_b sec0_q6 sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 time0 time1 sec2_q2"
local text_fields2 "sec2_q3 sec2_q3_other_reasonmig sec2_q5 sec2_q7_example sec2_q13 sec2_q14 sec2_q15 time2 time3a time3b upper_bound num_draws random_draws_count random_draw_* scaled_draw_* unique_draws randomoption1"
local text_fields4 "sec8_q4_other_occup time8 time9 sec10_q1_1 sec10_q5_1 sec10_q1_2 sec10_q5_2 time10a time10b time10c finished instanceid"
local date_fields1 "sec0_q3 sec2_q9"
local datetime_fields1 "submissiondate starttime endtime"

	
***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***  1- READING THE DATA
***_____________________________________________________________________________
use "$main\Data\output\followup2\intermediaire\guinea_endline_phone_corrected.dta", clear

drop time*

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*** 2- LABELING THE VARIABLES                
***_____________________________________________________________________________

label variable key "Endline: Unique submission ID"
cap label variable submissiondate "Date/time submitted"
cap label variable formdef_version "Form version used on device"
cap label variable rematch "Corrections made during review"


///////////////////////////////////////////
////////////    IDENTIFICATION  ///////////
///////////////////////////////////////////

/////////////  PRELOADED DATA /////////////////
*data that enumerators had to fill in themselves
*and data imported from the baseline data 

label variable commune "In which commune are you ?"
note commune : "In which commune are you ? (filled in by enumerators)"

label variable lycee_name "High School name"
note lycee_name : "What is the name of the high school (filled in by enumerators) ?"

label variable lycee_name2 "What is the name of the high school (check) ?"
note lycee_name2 : "What is the name of the high school (filled in by enumerators) ?"

label variable num_elv "ID number of the student"
note num_elv  : "ID number of the student"

label variable treatment "Treatment status of the school"
note treatment : "Treatment status of the school"

label variable school_id "School ID"
note school_id : "School ID"

label variable id_number "Student ID (from the tablets)"
note id_number : "Student ID (composed by the school_id and the num_elv entered in the tablets)"

label variable prenom_baseline "Student's name (from the baseline)"
note prenom_baseline: "Student's name (from the baseline)"

label variable nom_baseline "Student's family name (from the baseline)"
note nom_baseline: "Student's family name (from the baseline)"

label variable classe_baseline "Student's grade (from the baseline)"
note classe_baseline: "Student's grade (from the baseline)"

label variable option_baseline "Speciality choosen by the student (from the baseline)"
note option_baseline: "Speciality choosen by the student(from the baseline)"

label variable subcon "Is it the student or his contact?"
note subcon : "Is it the student or his contact? (filled by the enumerator)"
label define subcon 1"Student" 2"Contact"
label values subcon subcon

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.1 - STUDENT SURVEY
***_____________________________________________________________________________


label variable check_id "Are you [prenom_baseline] [nom_baseline] [classe_baseline] [option_baseline] ?"
note : "This question allows to check if enumerator did a mistake in entering the student ID of the student or the phone number"
label define yes_no 1"Yes" 2"No"
label values check_id  yes_no

label variable remember "Do you remember participating in our survey last year at your school with the tablets?"
note remember : "Do you remember participating in our survey last year at your school with the tablets?"
label values remember  yes_no

label variable check_id2 "Last year, were you in school  {lycee_name} in [classe_baseline] [option_baseline] ?"
note check_id2 : "This question allows to check if enumerator did a mistake in entering the student ID of the student or the phone number"
label values check_id2  yes_no

*Variable which calculated if the survey could keep going
drop right_id

label variable consent_agree "Do you accept to participate in the survey ?"
note consent_agree : "Do you accept to participate in the survey ?"
label values consent_agree yes_no


///////////////////////////////////////////
//////////////  SECTION WHERE /////////////
///////////////////////////////////////////

label variable  where_9 "Do you currently live in Conakry?"
note  where_9 : "Do you currently live in Conakry?"
label values where_9 yes_no

label variable  where_10 "When did you leave Conakry for the last time?"
note  where_10 : "When did you leave Conakry for the last time?"

label variable  where_11 "Do you currently live in Guinea?"
note  where_11 : "Do you currently live in Guinea?"
destring where_11, replace
label values where_11 yes_no

label variable  where_1 "Did you go to school in the past 30 days?"
note  where_1 : "Did you go to school in the past 30 days?"
label values where_1 yes_no

label variable  where_2_a "Did you graduate from high school last year?"
note  where_2_a : "Did you graduate from high school last year?"
label values where_2_a yes_no

label variable  where_2_b "Do you plan on going back to high school before the end of the school year?"
note  where_2_b : "Do you plan on going back to high school before the end of the school year?"
label values where_2_b yes_no

label variable  where_2_c "Do you study at university?"
note  where_2_c : "Do you study at university?"
label values where_2_b yes_no

label variable  where_3 "Did you pass last year?"
note  where_3 : "Did you pass last year?"
label values where_3 yes_no

label variable  where_8 "During the past month, did you have a paid job?"
note  where_8 : "During the past month, did you have a paid job?"
label values where_8 yes_no

label variable  where_4 "Did you go to {lycee_name}"
note  where_4 : "Did you go to {lycee_name}"
label values where_4 yes_no

label variable  where_5 "Which high school did you go to?"
note  where_5 : "Which high school did you go to?"

label variable  where_6 "In which class are you this year?"
note  where_6 : "In which class are you this year?"
label define classe 1"11ème" 2"12ème" 3"Terminale"
label values where_6  classe

label variable  where_7 "During the past month, did you have a paid job outside of school?"
note  where_7 : "During the past month, did you have a paid job outside of school?"
label values where_7 yes_no


///////////////////////////////////////////
//////////////  SECTION 2 /////////////////
///////////////////////////////////////////

label variable sec2_q11  "Did you discuss migration with your friends or siblings over last week?"
note sec2_q11 : "Did you discuss migration with your friends or siblings over last week?"
label values sec2_q11  yes_no

label variable sec2_q13  "Did any of your siblings or friend leave Guinea over the last six months?"
note sec2_q13 : "Did any of your siblings or friend leave Guinea over the last six months?"
label values sec2_q13  yes_no

label variable sec2_q14  "How many of your classmates from last year left Guinea over the last 6 months?"
note sec2_q14 : "How many of your classmates from last year left Guinea over the last 6 months?"

label variable sec2_q15  "Did at least one of your classmates from last year leave Guinea during the last 6 months?"
note sec2_q15 : "Did at least one of your classmates from last year leave Guinea during the last 6 months?"
label values sec2_q15  yes_no

label variable outside_contact_no "In total, how many familly members or friends living OUTSIDE Guinea and with whom you are in contact do you know ?"
note outside_contact_no : "In total, how many familly members or friends living OUTSIDE Guinea and with whom you are in contact do you know ?"


///////////////////////////////////////////
//////////////  OUTSIDE GUINEA ////////////
///////////////////////////////////////////

label variable mig_1 "Which continent are you in right now?"
note mig_1 : "Which continent are you in right now?"

label variable mig_2 "Which country are you in right now?"
note mig_2 : "Which country are you in right now?"

label variable mig_3 "Are you in Africa right now?"
note mig_3 : "Are you in Africa right now?"
label values mig_3 yesno

label variable mig_4 "Are you in Europe right now?"
note mig_4 : "Are you in Europe right now?"
label values mig_4 yesno

label variable mig_6 "What means of transportations did you use?"
note mig_6 : "What means of transportations did you use?"
label define transport 1 "Plane" 2 "Car" 3 "Bus" 4 "Train" 5 "Boat" 6 "By foot" 7 "Other"
label values mig_6 transport

label variable mig_6_1 "I went by plane."
note mig_6_1 : "I went by plane."
label values mig_6_1 yesno

label variable mig_6_2 "I went by car."
note mig_6_2 : "I went by car."
label values mig_6_2 yesno

label variable mig_6_3 "I went by bus."
note mig_6_3 : "I went by bus."
label values mig_6_3 yesno

label variable mig_6_4 "I went by train."
note mig_6_4 : "I went by train."
label values mig_6_4 yesno

label variable mig_6_5 "I went by boat."
note mig_6_5 : "I went by boat."
label values mig_6_5 yesno

label variable mig_6_6 "I went by foot."
note mig_6_6 : "I went by foot."
label values mig_6_6 yesno

label variable mig_6_7 "I went by another mean of transport."
note mig_6_7 : "I went by another mean of transport."
label values mig_6_7 yesno

label variable mig_7 "Specify other means of transport."
note mig_7 : "Specify other means of transport."


*label variable mig_5 "When did you leave Guinea for the last time?"
*note mig_5 : "When did you leave Guinea for the last time?"

*Country

label variable mig_9 "How much money did you spend until now converted in Guinean Francs for the journey?"
note mig_9 : "How much money did you spend until now converted in Guinean Francs for the journey?"

label variable mig_11 "Are you planning on moving to another country in the 12 months to come?"
note mig_11 : "Are you planning on moving to another country in the 12 months to come?"
label values mig_11  yes_no

label variable mig_12 "Did you plan a date to migrate? "
note mig_12 : "Did you plan a date to migrate? "
label values mig_12  yes_no

label variable mig_13 "Which month/year do you plan to leave {mig_2} ?"
note mig_13 : "Which month/year do you plan to leave {mig_2} ?"

label variable mig_14 "In which continent do you want to arrive? "
note mig_14 : "In which continent do you want to arrive? "

label variable mig_15 "In which country do you want to arrive? "
note mig_15 : "In which country do you want to arrive? "

label variable mig_16 "Is the country in Africa?"
note mig_16 : "Is the country in Africa?"
label values mig_16 yesno

label variable mig_17 "Is the country in Europe?"
note mig_17 : "Is the country in Europe?"
label values mig_17 yesno

label variable mig_18 "Why would you like to move permanently to another country? "
note mig_18 : "Why would you like to move permanently to another country? "

label variable mig_18_1 "You want to migrate to continue your studies?"
note mig_18_1 : "You want to migrate to continue your studies? (dummy created with mig_reason)"
label values mig_18_1 yes_no

label variable mig_18_2 "You want to migrate for economic reasons?"
note mig_18_2 : "You want to migrate for economic reasons? (dummy created with mig_reason)"
label values mig_18_2 yes_no

label variable mig_18_3"You want to migrate for family reasons ? (to join a relative abroad etc.)"
note mig_18_3: "You want to migrate for family reasons ? (dummy created with mig_reason)"
label values mig_18_3 yes_no

label variable mig_18_4 "You want to migrate because your area is affected by war/conflict?"
note mig_18_4: "You want to migrate because your area is affected by war/conflict? (dummy created with mig_reason)"
label values mig_18_4 yes_no

label variable mig_18_5 "You want to migrate because you are or could be the victim of violence or persecution?"
note mig_18_5 : "You want to migrate because you are or could be the victim of violence or persecution? (dummy created with mig_reason)"
label values mig_18_5 yes_no

label variable mig_18_6 "You want to migrate because your region has been affected by extreme climatic events? "
note mig_18_6 :"You want to migrate because your region has been affected by extreme climatic events? (dummy created with mig_reason)"
label values mig_18_6 yes_no

label variable mig_18_7 "Do you want to migrate for other reasons ?"
note mig_18_7 :"Do you want to migrate for other reasons ? (dummy created with mig_reason)"
label values mig_18_7 yes_no

label variable mig_19 "Could you specify the other reason why you want to migrate to another country ?"
note mig_19 : "Could you specify the other reason why you want to migrate to another country ?"

label variable mig_20 "Did you already apply to get a visa to enter in {mig_15} during the next 12 months?"
note mig_20 : "Did you already apply to get a visa to enter in {mig_15} during the next 12 months?"
label values mig_20  yes_no

label variable mig_21 "Do you believe that you will apply for a visa in order to migrate to {mig_15}?"
note mig_21 : "Do you believe that you will apply for a visa in order to migrate to {mig_15}?"
label values mig_21  yes_no

label variable mig_22 "Did you already apply to get a visa to enter in {mig_2} during the next 12 months?"
note mig_22 : "Did you already apply to get a visa to enter in {mig_2} during the next 12 months?"
label values mig_22  yes_no

label variable mig_22_a "Did you receive a visa to enter in {mig_2}?"
note mig_22_a : "Did you receive a visa to enter in {mig_2}?"
label values mig_22_a  yes_no

///////////////////////////////////////////
//////////  DESTINATION EUROPE ////////////
///////////////////////////////////////////


label variable mig_23 "Do you plan to cross by boat from Lybia?"
note mig_23 : "Do you plan to cross by boat from Lybia?"
label values mig_23  yes_no

label variable mig_24 "Do you plan to cross by boat from Morocco or Algeria?"
note mig_24 : "Do you plan to cross by boat from Morocco or Algeria?"
label values mig_24  yes_no

label variable mig_25 "Do you plan to cross the “grillage” in Ceuta or Melilla?"
note mig_25 : "Do you plan to cross the “grillage” in Ceuta or Melilla?"
label values mig_25  yes_no

label variable mig_26 "How do you plan to go?"
note mig_26 : "How do you plan to go?"

label variable mig_27 "How much money do you think you will spend converted in Guinean Francs for your journey to {mig_15}?"
note mig_27 : "How much money do you think you will spend converted in Guinean Francs for your journey to {mig_15}?"

label variable mig_28 "Did you cross the Mediterranean sea by boat from Libya?"
note mig_28 : "Did you cross the Mediterranean sea by boat from Libya?"
label values mig_28  yes_no

label variable mig_29 "Did you cross the Mediterranean by boat from Morocco or Algeria?"
note mig_29 : "Did you cross the Mediterranean by boat from Morocco or Algeria?"
label values mig_29  yes_no

label variable mig_30 "Did you cross the “grillage” in Ceuta or Melilla?"
note mig_30 : "Did you cross the “grillage” in Ceuta or Melilla?"
label values mig_30  yes_no

label variable mig_31 "How did you get to {mig_2} ?"
note mig_31 : "How did you get to {mig_2} ?"


*ILLEGAL MIGRATION
label variable mig_10 "How many people have you travelled with until  {mig_2}?"
note mig_10 : "How many people have you travelled with until {mig_2}?"

label variable mig_32 "Were you forced to work during your journey?"
note mig_32 : "Were you forced to work during your journey?"
label values mig_32  yes_no

label variable mig_33 "Were you held against your will during your journey?"
note mig_33 : "Were you held against your will during your journey?"
label values mig_33  yes_no

label variable mig_34 "Have you witnessed anyone suffering violence during your journey?"
note mig_34 : "Have you witnessed anyone suffering violence during your journey?"
label values mig_34  yes_no

label variable mig_35 "Did you suffer episodes of violence during your journey?"
note mig_35 : "Did you suffer episodes of violence during your journey?"
label values mig_35  yes_no

label variable mig_36 "Were you to go back in time, would you leave Guinea again?"
note mig_36 : "Were you to go back in time, would you leave Guinea again?"
label values mig_36  yes_no


///////////////////////////////////////////
//////////////  PAST MIGRATION ////////////
///////////////////////////////////////////

label variable migrated_returned "During the last year, did you leave Guinea for more than 3 months?"
note migrated_returned : "During the last year, did you leave Guinea for more than 3 months?"
label values migrated_returned  yes_no

label variable past_mig1 "During this time outside of Guinea, in which continent did you stay for the longest period?"
note past_mig1 : "During this time outside of Guinea, in which continent did you stay for the longest period?"

label variable past_mig2 "During this time outside of Guinea, in which country did you stay for the longest period?"
note past_mig2 : "During this time outside of Guinea, in which country did you stay for the longest period?"

label variable past_mig9 "What means of transportations did you use to get to {past_mig2}?"
note past_mig9 : "What means of transportations did you use to get to {past_mig2}?"
label values past_mig9 transport

label variable past_mig9_1 "I went by plane."
note past_mig9_1 : "I went by plane."
label values past_mig9_1 yesno

label variable past_mig9_2 "I went by car."
note past_mig9_2 : "I went by car."
label values past_mig9_2 yesno

label variable past_mig9_3 "I went by bus."
note past_mig9_3 : "I went by bus."
label values past_mig9_3 yesno

label variable past_mig9_4 "I went by train."
note past_mig9_4 : "I went by train."
label values past_mig9_4 yesno

label variable past_mig9_5 "I went by boat."
note past_mig9_5 : "I went by boat."
label values past_mig9_5 yesno

label variable past_mig9_6 "I went by foot."
note past_mig9_6 : "I went by foot."
label values past_mig9_6 yesno

label variable past_mig9_7 "I went by another mean of transport."
note past_mig9_7 : "I went by another mean of transport."
label values past_mig9_7 yesno

label variable past_mig9_a "Specify the other means of transportation you used."
note past_mig9_a : "Specify the other means of transportation you used."

label variable past_mig10 "How much money did you spend, converted in Guinean Francs, for the journey to {past_mig2}?"
note past_mig10 : "How much money did you spend, converted in Guinean Francs, for the journey to {past_mig2}?"

label variable past_mig11 "How many people did you travel with to get to {mig_2}?"
note past_mig11 : "How many people have you travelled with until {mig_2}?"

label variable past_mig3 "Were you forced to work during your journey?"
note past_mig3 : "Were you forced to work during your journey?"
label values past_mig3  yes_no

label variable past_mig4 "Were you held against your will during your journey?"
note past_mig4 : "Were you held against your will during your journey?"
label values past_mig4  yes_no

label variable past_mig5 "Have you witnessed anyone suffering violence during your journey?"
note past_mig5 : "Have you witnessed anyone suffering violence during your journey?"
label values past_mig5  yes_no

label variable past_mig6 "Did you suffer episodes of violence during your journey?"
note past_mig6 : "Did you suffer episodes of violence during your journey?"
label values past_mig6  yes_no

label variable past_mig7 "When you left Guinea, did you plan to stay outside Guinea for a longer period?"
note past_mig7 : "When you left Guinea, did you plan to stay outside Guinea for a longer period?"
label values past_mig7  yes_no

label variable past_mig8 "Were you to go back in time, would you leave Guinea again?"
note past_mig8 : "Were you to go back in time, would you leave Guinea again?"
label values past_mig8  yes_no

///////////////////////////////////////////
//////////////  MIGRATION INTENTION ///////
///////////////////////////////////////////

label variable sec2_q1 "Ideally, would you like to move permanently to another country or would you like to continue living in Guinea?"
note sec2_q1 : "Ideally, if you had the opportunity, would you like to move permanently to another country or would you like to continue living in Guinea?"
label define mig_desire 1 "Yes, I would like to move permanently to another country." 2 "No, I would like to continue living in Guinea."
label values sec2_q1 mig_desire

label variable sec2_q2_a "If you could go anywhere in the world, which continent would you like to live in? "
note sec2_q2_a : "If you could go anywhere in the world, which continent would you like to live in? "

label variable sec2_q2 "If you could go anywhere in the world, which country would you like to live in? "
note sec2_q2 : "If you could go anywhere in the world, which country would you like to live in? "

label variable sec2_q3 "Why would you like to move permanently to another country? "
note sec2_q3 : "Why would you like to move permanently to another country? "

label variable sec2_q3_1 "You want to migrate to continue your studies?"
note sec2_q3_1 : "You want to migrate to continue your studies? (dummy created with mig_reason)"
label values sec2_q3_1 yes_no_bis

label variable sec2_q3_2 "You want to migrate for economic reasons?"
note sec2_q3_2 : "You want to migrate for economic reasons? (dummy created with mig_reason)"
label values sec2_q3_2 yes_no_bis

label variable sec2_q3_3"You want to migrate for family reasons ? (to join a relative abroad etc.)"
note sec2_q3_3: "You want to migrate for family reasons ? (dummy created with mig_reason)"
label values sec2_q3_3 yes_no_bis

label variable sec2_q3_4 "You want to migrate because your area is affected by war/conflict?"
note sec2_q3_4: "You want to migrate because your area is affected by war/conflict? (dummy created with mig_reason)"
label values sec2_q3_4 yes_no_bis

label variable sec2_q3_5 "You want to migrate because you are or could be the victim of violence or persecution?"
note sec2_q3_5 : "You want to migrate because you are or could be the victim of violence or persecution? (dummy created with mig_reason)"
label values sec2_q3_5 yes_no_bis

label variable sec2_q3_6 "You want to migrate because your region has been affected by extreme climatic events? "
note sec2_q3_6 :"You want to migrate because your region has been affected by extreme climatic events? (dummy created with mig_reason)"
label values sec2_q3_6 yes_no_bis

label variable sec2_q3_7 "Do you want to migrate for other reasons ?"
note sec2_q3_7 :"Do you want to migrate for other reasons ? (dummy created with mig_reason)"
label values sec2_q3_7 yes_no_bis

label variable sec2_q3_other_reasonmig "Could you specify the other reason why you want to migrate to another country ?"
note sec2_q3_other_reasonmig : "Could you specify the other reason why you want to migrate to another country ?"


label variable sec2_q4 "Are you planning to move permanently to another country in the next 12 months, or not?"
note sec2_q4 : "Are you planning to move permanently to another country in the next 12 months, or not?"
label values sec2_q4 yes_no

label variable sec2_q5a "Which continent are you planning to move to?"
note sec2_q5a : "Which continent are you planning to move to?"

label variable sec2_q5 "Which country are you planning to move to?"
note sec2_q5 : "Which country are you planning to move to?"

label variable sec2_q7  "Have you made any preparations for this move?"
note sec2_q7  : "Have you made any preparations for this move?"
label values sec2_q7  yes_no

label variable sec2_q7_example  "Which types of preparations have you made for this move?"
note sec2_q7  : "Which types of preparations have you made  for this move?"

label variable sec2_q7_example_1 "I am saving money to prepare my trip" 
note sec2_q7_example_1 : "I am saving money to prepare my trip" 
label values sec2_q7_example_1 yes_no_bis

label variable sec2_q7_example_2 "I have contacted someone I know who is living in the country where I want to go." 
note sec2_q7_example_2 : "I have contacted someone I know who is living in the country where I want to go." 
label values sec2_q7_example_2 yes_no_bis

label variable sec2_q7_example_3 "I made some of my relatives aware of my desire to migrate."
note sec2_q7_example_3 : "I made some of my relatives aware of my desire to migrate."
label values sec2_q7_example_3 yes_no_bis

label variable sec2_q7_example_4 "I made other types of preparation."
note sec2_q7_example_4 : "I made other types of preparation."
label values sec2_q7_example_4 yes_no_bis


label variable sec2_q7_other_plan "Could you specify the other types of preparations you have made for this move?"
note sec2_q7_other_plan : "Could you specify the other types of preparations you have made for this move?"

label variable sec2_q8 "Did you plan a date to migrate?"
note sec2_q8 :  "Did you plan a date to migrate?"
label values sec2_q8 yes_no

label variable  sec2_q10_a "Did you already apply to get a visa to enter in [sec2_q5] during the next 12 months?"
note sec2_q10_a : "Have you already applied to get a visa to enter in this country [sec2_q5] during the next 12 months?"

label variable  sec2_q10_b "Do you believe that you will apply for a visa to migrate to [sec2_q2]?"
note sec2_q10_b: "For people who do not want migrate in the next 12 months : Do you believe that you will apply for a visa in order to migrate to this country?"

label variable sec2_q10_c "Do you believe that you will apply for a visa to migrate to [sec2_q2]?"
note sec2_q10_c : "For people who want migrate in the next 12 months : Do you believe that you will apply for a visa in order to migrate to this country?"

///////////////// OPTIMISM //////////////////  
label variable optimism "Compared to your current situation, do you think your future situation will be:"
label define optimism 1 "A lot worse" 2	"A little worse" 3	"The same" 4	"A little better" 5 "A lot better"
label values optimism optimism

label variable  sec0_q6_fb "Do you have a facebook account ?"
note  sec0_q6_fb : "Do you have a facebook account ?"
label values  sec0_q6_fb yes_no





***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.2 - CONTACT SURVEY
***_____________________________________________________________________________


label variable check_con "Do you know  {subject_name}?"
note check_con : "This question allows to check if enumerator did a mistake in entering the ID of the student or if the phone number"
label values check_con  yes_no

label variable consent_agree_contact "Do you accept to participate in the survey ?"
note consent_agree_contact : "Do you accept to participate in the survey ?"
label values consent_agree_contact yes_no

label variable gender "What is the gender of the contact?"
note gender : "What is the gender of the contact? (filled in by enumerators)"
label define gender 1 "Male" 2 "Female"
label values gender  gender


///////////////////////////////////////////
//////////////  SECTION 0 /////////////////
///////////////////////////////////////////

label variable sec0_q0_contact "How do you know {subject_name}?"
note sec0_q0_contact : "This question allows to check if enumerator did a mistake en entering the student ID of the student"
replace sec0_q0_contact="6" if sec0_q0_contact=="1 2"
replace sec0_q0_contact="7" if sec0_q0_contact=="2 5"
replace sec0_q0_contact="8" if sec0_q0_contact=="3 4"
replace sec0_q0_contact="9" if sec0_q0_contact=="4 5"
destring sec0_q0_contact, replace
label define relation 1"Father/Mother" 2"Brother/Sister" 3"Friend" 4"Classmate" 5"Other family member" 6 "Father/Mother AND Brother/Sister" 7 "Brother/Sister AND Other family member" 8 "Friend AND Classmate" 9 "Classmate AND Other family member"
label values sec0_q0_contact relation

label variable sec0_q0_contact_1 "It is the father/mother of the student."
note sec0_q0_contact_1 : "It is the father/mother of the student."
label values sec0_q0_contact_1 yesno

label variable sec0_q0_contact_2 "It is the sister/brother of the student."
note sec0_q0_contact_2 : "It is the sister/brother of the student."
label values sec0_q0_contact_2 yesno

label variable sec0_q0_contact_3 "It is a friend of the student."
note sec0_q0_contact_3 : "It is a friend of the student."
label values sec0_q0_contact_3 yesno

label variable sec0_q0_contact_4 "It is a classmate of the student."
note sec0_q0_contact_4 : "It is a classmate of the student."
label values sec0_q0_contact_4 yesno

label variable sec0_q0_contact_5 "It is another family member of the student."
note sec0_q0_contact_5 : "It is another family member of the student."
label values sec0_q0_contact_5 yesno


label variable sec0_q1_contact "When did you last communicate with {subject_name}?"
note sec0_q1_contact : "When did you last communicate with {subject_name}?"
label define last_seen 1"Today" 2"Yesterday" 3"Less than a week ago" 4"Less than a month ago" 5"Less than 6 months ago" 6"More than 6 months ago"
label values sec0_q1_contact last_seen

label variable sec0_q4_contact "How did you last communicate with {subject_name}?"
note sec0_q4_contact : "How did you last communicate with {subject_name}?"
replace sec0_q4_contact="7" if sec0_q4_contact=="1 2"
replace sec0_q4_contact="8" if sec0_q4_contact=="2 3"
replace sec0_q4_contact="9" if sec0_q4_contact=="2 5"
destring sec0_q4_contact, replace
label define media 1"In person" 2"By phone" 3"Whatsapp" 4"Facebook" 5"Other social media" 6"Other" 7 "In person AND By Phone" 8 "By phone AND Whatsapp" 9 "By phone AND Other social media"
label values sec0_q4_contact media

label variable sec0_q4_contact_1 "He last communicated with the student in person."
note sec0_q4_contact_1 : "He last communicated with the student in person."
label values sec0_q4_contact_1 yesno

label variable sec0_q4_contact_2 "He last communicated with the student by phone."
note sec0_q4_contact_2 : "He last communicated with the student by phone."
label values sec0_q4_contact_2 yesno

label variable sec0_q4_contact_3 "He last communicated with the student by Whatsapp."
note sec0_q4_contact_3 : "He last communicated with the student by whatsapp."
label values sec0_q4_contact_3 yesno

label variable sec0_q4_contact_4 "He last communicated with the student by Facebook."
note sec0_q4_contact_4 : "He last communicated with the student by Facebook."
label values sec0_q4_contact_4 yesno

label variable sec0_q4_contact_5 "He last communicated with the student by another social media."
note sec0_q4_contact_5 : "He last communicated with the student by another social media."
label values sec0_q4_contact_5 yesno

label variable sec0_q4_contact_6 "He last communicated with the student by another mean."
note sec0_q4_contact_6 : "He last communicated with the student by another mean."
label values sec0_q4_contact_6 yesno


label variable sec0_q4_a_contact "Specify other media."
note sec0_q4_a_contact : "Specify other media."


///////////////////////////////////////////
//////////////  SECTION WHERE /////////////
///////////////////////////////////////////

label variable  where_9_contact "Does she you currently live in Conakry?"
note  where_9_contact : "Does he/she you currently live in Conakry?"
label values where_9_contact yes_no

label variable  where_10_contact "When did she leaves Conakry for the last time?"
note  where_10_contact : "When did she leave Conakry for the last time?"

label variable  where_11_contact "Does she currently live in Guinea?"
note  where_11_contact : "Does she currently live in Guinea?"
label values where_11_contact yes_no

label variable  where_1_contact "Did she go to school in the past 30 days?"
note  where_1_contact : "Did she go to school in the past 30 days?"
label values where_1_contact yes_no

label variable  where_2_a_contact "Did she graduate from high school last year?"
note  where_2_a_contact : "Did she graduate from high school last year?"
label values where_2_a_contact yes_no

label variable  where_2_b_contact "Does she plan on going back to high school before the end of the school year?"
note  where_2_b_contact : "Does she plan on going back to high school before the end of the school year?"
label values where_2_b_contact yes_no

label variable  where_2_c_contact "Does she study at university?"
note  where_2_c_contact : "Does she study at university?"
label values where_2_b_contact yes_no

label variable  where_3_contact "Did she pass last year?"
note  where_3_contact : "Did she pass last year?"
label values where_3_contact yes_no

label variable  where_4_contact "Did she go to {lycee_name}"
note  where_4_contact : "Did she go to {lycee_name}"
label values where_4_contact yes_no

label variable  where_5_contact "Which high school did she go to?"
note  where_5_contact : "Which high school did she go to?"

label variable  where_6_contact "In which class is she this year?"
note  where_6_contact : "In which class is she this year?"
label values where_6_contact classe

label variable  where_7_contact "During the past month, did she have a paid job outside of school?"
note  where_7_contact : "During the past month, did she have a paid job outside of school?"
label values where_7_contact yes_no

label variable  where_8_contact "During the past month, did she have a paid job?"
note  where_8_contact : "During the past month, did she have a paid job?"
label values where_8_contact yes_no

///////////////////////////////////////////
//////////////  SECTION 2 /////////////////
///////////////////////////////////////////

label variable sec2_q13_contact  "Did any of her siblings or friend leave Guinea over the last six months?"
note sec2_q13_contact : "Did any of her siblings or friend leave Guinea over the last six months?"
label values sec2_q13_contact  yes_no

label variable sec2_q14_contact  "How many of her classmates from last year left Guinea over the last 6 months?"
note sec2_q14_contact : "How many of her classmates from last year left Guinea over the last 6 months?"

label variable sec2_q15_contact  "Did at least one of her classmates from last year leave Guinea during the last 6 months?"
note sec2_q15_contact : "Did at least one of her classmates from last year leave Guinea during the last 6 months?"
label values sec2_q15_contact  yes_no


///////////////////////////////////////////
//////////////  OUTSIDE GUINEA ////////////
///////////////////////////////////////////

label variable mig_1_contact "Which continent is she in right now?"
note mig_1_contact : "Which continent is she in right now?"

label variable mig_2_contact "Which country is she in right now?"
note mig_2_contact : "Which country is she in right now?"

label variable mig_3_contact "Is she in Africa right now?"
note mig_3_contact : "Is she in Africa right now?"
label values mig_3_contact yesno

label variable mig_4_contact "Is she in Europe right now?"
note mig_4_contact : "Is she in Europe right now?"
label values mig_4_contact yesno

*label variable mig_5_contact "When did you leave Guinea for the last time?"
*note mig_5_contact : "When did you leave Guinea for the last time?"

label variable mig_6_contact "What means of transportations did she use?"
note mig_6_contact : "What means of transportations did she use?"
label values mig_6_contact transport

label variable mig_6_contact_1 "She went by plane."
note mig_6_contact_1 : "She went by plane."
label values mig_6_contact_1 yesno

label variable mig_6_contact_2 "She went by car."
note mig_6_contact_2 : "She went by car."
label values mig_6_contact_2 yesno

label variable mig_6_contact_3 "She went by bus."
note mig_6_contact_3 : "She went by bus."
label values mig_6_contact_3 yesno

label variable mig_6_contact_4 "She went by train."
note mig_6_contact_4 : "She went by train."
label values mig_6_contact_4 yesno

label variable mig_6_contact_5 "She went by boat."
note mig_6_contact_5 : "She went by boat."
label values mig_6_contact_5 yesno

label variable mig_6_contact_6 "She went by foot."
note mig_6_contact_6 : "She went by foot."
label values mig_6_contact_6 yesno

label variable mig_6_contact_7 "She went by another mean of transport."
note mig_6_contact_7 : "She went by another mean of transport."
label values mig_6_contact_7 yesno

label variable mig_7_contact "Specify other means of transport."
note mig_7_contact : "Specify other means of transport."

*Country
label variable mig_9_contact "How much money did she spend until now converted in Guinean Francs for the journey?"
note mig_9_contact : "How much money did she spend until now converted in Guinean Francs for the journey?"

label variable mig_10_contact "How many people did she travel with?"
note mig_10_contact : "How many people did she travel with?"

label variable mig_11_contact "Is she planning on moving to another country in the 12 months to come?"
note mig_11_contact : "Is she planning on moving to another country in the 12 months to come?"
label values mig_11_contact  yes_no

label variable mig_12_contact "Did she plan a date to migrate? "
note mig_12_contact : "Did she plan a date to migrate? "
label values mig_12_contact  yes_no

label variable mig_13_contact "Which month/year does she plan to leave {mig_2} ?"
note mig_13_contact : "Which month/year does she plan to leave {mig_2} ?"

label variable mig_14_contact "In which continent does she want to arrive? "
note mig_14_contact : "In which continent does she want to arrive? "

label variable mig_15_contact "In which country does she want to arrive? "
note mig_15_contact : "In which country does she want to arrive? "

label variable mig_16_contact "Is the country in Africa?"
note mig_16_contact : "Is the country in Africa?"
label values mig_16_contact yesno

label variable mig_17_contact "Is the country in Europe?"
note mig_17_contact : "Is the country in Europe?"
label values mig_17_contact yesno

label variable mig_18_contact "Why would she like to move permanently to another country? "
note mig_18_contact : "Why would she like to move permanently to another country? "

label variable mig_18_contact_1 "She wants to migrate to continue her studies?"
note mig_18_contact_1 : "She wants to migrate to continue her studies? (dummy created with mig_reason)"
label values mig_18_contact_1 yes_no_bis

label variable mig_18_contact_2 "She wants to migrate for economic reasons?"
note mig_18_contact_2 : "She wants to migrate for economic reasons? (dummy created with mig_reason)"
label values mig_18_contact_2 yes_no_bis

label variable mig_18_contact_3 "She wants to migrate for family reasons ? (to join a relative abroad etc.)"
note mig_18_contact_3: "She wants to migrate for family reasons ? (dummy created with mig_reason)"
label values mig_18_contact_3 yes_no_bis

label variable mig_18_contact_4 "She wants to migrate because your area is affected by war/conflict?"
note mig_18_contact_4: "She wants to migrate because your area is affected by war/conflict? (dummy created with mig_reason)"
label values mig_18_contact_4 yes_no_bis

label variable mig_18_contact_5 "She wants to migrate because you are or could be the victim of violence or persecution?"
note mig_18_contact_5 : "She wants to migrate because you are or could be the victim of violence or persecution? (dummy created with mig_reason)"
label values mig_18_contact_5 yes_no_bis

label variable mig_18_contact_6 "She wants to migrate because your region has been affected by extreme climatic events? "
note mig_18_contact_6 :"She wants to migrate because your region has been affected by extreme climatic events? (dummy created with mig_reason)"
label values mig_18_contact_6 yes_no_bis

label variable mig_18_contact_7 "Does she want to migrate for other reasons ?"
note mig_18_contact_7 :"Does she want to migrate for other reasons ? (dummy created with mig_reason)"
label values mig_18_contact_7 yes_no_bis

label variable mig_19_contact "Could you specify the other reason why she wants to migrate to another country ?"
note mig_19_contact : "Could you specify the other reason why she wants to migrate to another country ?"

label variable mig_20_contact "Did she already apply to get a visa to enter in {mig_15} during the next 12 months?"
note mig_20_contact : "Did she already apply to get a visa to enter in {mig_15} during the next 12 months?"
label values mig_20_contact  yes_no

label variable mig_21_contact "Do you believe that she will apply for a visa in order to migrate to {mig_15}?"
note mig_21_contact : "Do you believe that she will apply for a visa in order to migrate to {mig_15}?"
label values mig_21_contact  yes_no

label variable mig_22_contact "Did you already apply to get a visa to enter in {mig_2} during the next 12 months?"
note mig_22_contact : "Did you already apply to get a visa to enter in {mig_2} during the next 12 months?"
label values mig_22_contact  yes_no

label variable mig_22_a_contact "Did she receive a visa to enter in {mig_2}?"
note mig_22_a_contact : "Did she receive a visa to enter in {mig_2}?"
label values mig_22_a_contact  yes_no

///////////////////////////////////////////
//////////  DESTINATION EUROPE ////////////
///////////////////////////////////////////


label variable mig_23_contact "Does she plan to cross by boat from Lybia?"
note mig_23_contact : "Does she plan to cross by boat from Lybia?"
label values mig_23_contact  yes_no

label variable mig_24_contact "Does she plan to cross by boat from Morocco or Algeria?"
note mig_24_contact : "Does she plan to cross by boat from Morocco or Algeria?"
label values mig_24_contact  yes_no

label variable mig_25_contact "Does she plan to cross the “grillage” in Ceuta or Melilla?"
note mig_25_contact : "Does she plan to cross the “grillage” in Ceuta or Melilla?"
label values mig_25_contact  yes_no

label variable mig_26_contact "How does she plan to go?"
note mig_26_contact : "How does she plan to go?"

label variable mig_27_contact "How much money does he think he will spend converted in Guinean Francs for his journey to {mig_15_contact}?"
note mig_27_contact : "How much money does he think he will spend converted in Guinean Francs for his journey to {mig_15_contact}?"

label variable mig_28_contact "Did she cross the Mediterranean sea by boat from Libya?"
note mig_28_contact : "Did she cross the Mediterranean sea by boat from Libya?"
label values mig_28_contact  yes_no

label variable mig_29_contact "Did she cross the Mediterranean by boat from Morocco or Algeria?"
note mig_29_contact : "Did she cross the Mediterranean by boat from Morocco or Algeria?"
label values mig_29_contact  yes_no

label variable mig_30_contact "Did she cross the “grillage” in Ceuta or Melilla?"
note mig_30_contact : "Did she cross the “grillage” in Ceuta or Melilla?"
label values mig_30_contact  yes_no

label variable mig_31_contact "How did she get to {mig_2_contact} ?"
note mig_31_contact : "How did she get to {mig_2_contact} ?"


*ILEGAL MIGRATION

label variable mig_32_contact "Was she forced to work during her journey?"
note mig_32_contact : "Was she forced to work during her journey?"
label values mig_32_contact  yes_no

label variable mig_33_contact "Was she held against her will during your journey?"
note mig_33_contact : "Was she held against her will during your journey?"
label values mig_33_contact  yes_no

label variable mig_34_contact "Did she witnessed anyone suffering violence during her journey?"
note mig_34_contact : "Did she witnessed anyone suffering violence during her journey?"
label values mig_34_contact  yes_no

label variable mig_35_contact "Did she suffer episodes of violence during her journey?"
note mig_35_contact : "Did she suffer episodes of violence during her journey?"
label values mig_35_contact  yes_no


///////////////////////////////////////////
//////////////  PAST MIGRATION ////////////
///////////////////////////////////////////

label variable migrated_returned_contact "During the last year, did she leave Guinea for more than 3 months?"
note migrated_returned_contact : "During the last year, did she leave Guinea for more than 3 months?"
label values migrated_returned_contact  yes_no

label variable past_mig1_contact "During this time outside of Guinea, in which continent did she stay for the longest period?"
note past_mig1_contact : "During this time outside of Guinea, in which continent did she stay for the longest period?"

label variable past_mig2_contact "During this time outside of Guinea, in which country did she stay for the longest period?"
note past_mig2_contact : "During this time outside of Guinea, in which country did she stay for the longest period?"

label variable past_mig9_contact "What means of transportations did she use to get to {past_mig2_contact}?"
note past_mig9_contact : "What means of transportations did she use to get to {past_mig2_contact}?"
label values past_mig9_contact transport

label variable past_mig9_contact_1 "She went by plane."
note past_mig9_contact_1 : "She went by plane."
label values past_mig9_contact_1 yesno

label variable past_mig9_contact_2 "She went by car."
note past_mig9_contact_2 : "She went by car."
label values past_mig9_contact_2 yesno

label variable past_mig9_contact_3 "She went by bus."
note past_mig9_contact_3 : "She went by bus."
label values past_mig9_contact_3 yesno

label variable past_mig9_contact_4 "She went by train."
note past_mig9_contact_4 : "She went by train."
label values past_mig9_contact_4 yesno

label variable past_mig9_contact_5 "She went by boat."
note past_mig9_contact_5 : "She went by boat."
label values past_mig9_contact_5 yesno

label variable past_mig9_contact_6 "She went by foot."
note past_mig9_contact_6 : "She went by foot."
label values past_mig9_contact_6 yesno

label variable past_mig9_contact_7 "She went by another mean of transport."
note past_mig9_contact_7 : "She went by another mean of transport."
label values past_mig9_contact_7 yesno

label variable past_mig9_a_contact "Specify the other means of transportation she used."
note past_mig9_a_contact : "Specify the other means of transportation she used."

label variable past_mig10_contact "How much money did she spend, converted in Guinean Francs, for the journey to {past_mig2_contact}?"
note past_mig10_contact : "How much money did she spend, converted in Guinean Francs, for the journey to {past_mig2_contact}?"

label variable past_mig11_contact "How many people did she travel with to get to  {mig_2_contact}?"
note past_mig11_contact : "How many people did she travelled with until {mig_2_contact}?"

label variable past_mig3_contact "Was she forced to work during her journey?"
note past_mig3_contact : "Was she forced to work during her journey?"
label values past_mig3_contact  yes_no

label variable past_mig4_contact "Was she held against her will during her journey?"
note past_mig4_contact : "Was she held against her will during her journey?"
label values past_mig4_contact  yes_no

label variable past_mig5_contact "Did she witness anyone suffering violence during her journey?"
note past_mig5_contact : "Did she witness anyone suffering violence during her journey?"
label values past_mig5_contact  yes_no

label variable past_mig6_contact "Did she suffer episodes of violence during her journey?"
note past_mig6_contact : "Did she suffer episodes of violence during her journey?"
label values past_mig6_contact  yes_no

label variable past_mig7_contact "When she left Guinea, did she plan to stay outside Guinea for a longer period?"
note past_mig7_contact : "When she left Guinea, did she plan to stay outside Guinea for a longer period?"
label values past_mig7_contact  yes_no


///////////////////////////////////////////
//////////////  MIGRATION INTENTION ///////
///////////////////////////////////////////

label variable sec2_q1_contact "Do you think that, ideally, if she had the opportunity, she would like to move permanently to another country or to continue living in Guinea?"
note sec2_q1_contact : "Do you think that, ideally, if she had the opportunity, she would like to move permanently to another country or to continue living in Guinea?"
label define mig_desire_contact 1 "Yes, she would like to move permanently to another country." 2 "No, she would like to continue living in Guinea."
label values sec2_q1_contact mig_desire_contact

rename sec2_q2_a_contact sec2_q2a_contact
label variable sec2_q2a_contact "If you could go anywhere in the world, which continent would you like to live in? "
note sec2_q2a_contact : "If you could go anywhere in the world, which continent would you like to live in? "

label variable sec2_q2_contact "If she could go anywhere in the world, which country would she like to live in? "
note sec2_q2a_contact : "If she could go anywhere in the world, which country would she like to live in? "

label variable sec2_q3_contact "Why would she like to move permanently to another country? "
note sec2_q3_contact : "Why would she like to move permanently to another country? "

label variable sec2_q3_contact_1 "She wants to migrate to continue her studies?"
note sec2_q3_contact_1 : "She wants to migrate to continue her studies? (dummy created with mig_reason)"
label values sec2_q3_contact_1 yes_no_bis

label variable sec2_q3_contact_2 "She wants to migrate for economic reasons?"
note sec2_q3_contact_2 : "She wants to migrate for economic reasons? (dummy created with mig_reason)"
label values sec2_q3_contact_2 yes_no_bis

label variable sec2_q3_contact_3 "She wants to migrate for family reasons ? (to join a relative abroad etc.)"
note sec2_q3_contact_3: "She wants to migrate for family reasons ? (dummy created with mig_reason)"
label values sec2_q3_contact_3 yes_no_bis

label variable sec2_q3_contact_4 "She wants to migrate because her area is affected by war/conflict?"
note sec2_q3_contact_4: "She wants to migrate because her area is affected by war/conflict? (dummy created with mig_reason)"
label values sec2_q3_contact_4 yes_no_bis

label variable sec2_q3_contact_5 "She wants to migrate because she is or could be the victim of violence or persecution?"
note sec2_q3_contact_5 : "She wants to migrate because she is or could be the victim of violence or persecution? (dummy created with mig_reason)"
label values sec2_q3_contact_5 yes_no_bis

label variable sec2_q3_contact_6 "She wants to migrate because her region has been affected by extreme climatic events? "
note sec2_q3_contact_6 :"She wants to migrate because her region has been affected by extreme climatic events? (dummy created with mig_reason)"
label values sec2_q3_contact_6 yes_no_bis

label variable sec2_q3_contact_7 "Does she want to migrate for other reasons ?"
note sec2_q3_contact_7 :"Does she want to migrate for other reasons ? (dummy created with mig_reason)"
label values sec2_q3_contact_7 yes_no_bis

label variable sec2_q3_other_reasonmig_contact "Could you specify the other reason why she wants to migrate to another country ?"
note sec2_q3_other_reasonmig_contact : "Could you specify the other reason why she wants to migrate to another country ?"


label variable sec2_q4_contact "Is she planning to move permanently to another country in the next 12 months, or not?"
note sec2_q4_contact : "Is she planning to move permanently to another country in the next 12 months, or not?"
label values sec2_q4_contact yes_no

label variable sec2_q5a_contact "Which continent is she planning to move to?"
note sec2_q5a_contact : "Which continent is she planning to move to?"

label variable sec2_q5_contact "Which country is she planning to move to?"
note sec2_q5_contact : "Which country is she planning to move to?"

label variable sec2_q7_contact  "Did she make any preparations for this move?"
note sec2_q7_contact  : "Did she make any preparations for this move?"
label values sec2_q7_contact  yes_no

label variable sec2_q7_example_contact  "Which types of preparations did she make for this move?"
note sec2_q7_example_contact  : "Which types of preparations did she mae for this move?"

label variable sec2_q7_example_contact_1 "She is saving money to prepare her trip" 
note sec2_q7_example_contact_1 : "She is saving money to prepare her trip" 
label values sec2_q7_example_contact_1 yes_no_bis

label variable sec2_q7_example_contact_2 "She has contacted someone she knows who is living in the country where she wants to go." 
note sec2_q7_example_contact_2 : "She has contacted someone she knows who is living in the country where she wants to go." 
label values sec2_q7_example_contact_2 yes_no_bis

label variable sec2_q7_example_contact_3 "She made some of her relatives aware of her desire to migrate."
note sec2_q7_example_contact_3 : "She made some of her relatives aware of her desire to migrate."
label values sec2_q7_example_contact_3 yes_no_bis

label variable sec2_q7_example_contact_4 "She made other types of preparation."
note sec2_q7_example_contact_4 : "She made other types of preparation."
label values sec2_q7_example_contact_4 yes_no_bis

label variable sec2_q7_other_plan_contact "Could you specify the other types of preparations she has made for this move?"
note sec2_q7_other_plan_contact : "Could you specify the other types of preparations she has made for this move?"

label variable sec2_q8_contact "Did she plan a date to migrate?"
note sec2_q8_contact :  "Did she plan a date to migrate?"
label values sec2_q8_contact yes_no

label variable sec2_q9_contact "When does she plan to leave Guinea?"
note sec2_q9_contact :  "When does she plan to leave Guinea?"

label variable  sec2_q10_a_contact "Did she already apply to get a visa to enter in [sec2_q5_contact] during the next 12 months?"
note sec2_q10_a_contact : "Did she already applied to get a visa to enter in this country [sec2_q5_contact] during the next 12 months?"

label variable  sec2_q10_b_contact "Does she believe that she will apply for a visa to migrate to [sec2_q2_contact]?"
note sec2_q10_b_contact: "For people who do not want to migrate in the next 12 months : Does she believe that she will apply for a visa in order to migrate to this country?"

label variable sec2_q10_c_contact "Does she believe that she will apply for a visa to migrate to [sec2_q2_contact]?"
note sec2_q10_c_contact : "For people who want to migrate in the next 12 months : Does she believe that she will apply for a visa in order to migrate to this country?"


label variable  sec0_q6_fb_contact "Does she have a facebook account ?"
note  sec0_q6_fb_contact : "Does she have a facebook account ?"
label values  sec0_q6_fb_contact yes_no


label variable surveycto_phone "Does this student have a school survey completed on surveyCTO?"
note surveycto_phone : "Does this student have a school survey completed on surveyCTO?"
destring surveycto_phone, replace
label values surveycto_phone yesno


***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   3- Cleaning                                     
***_____________________________________________________________________________


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3.1 - CLEANING COUNTRIES NAMES
***_____________________________________________________________________________


foreach x in mig_2 mig_15 past_mig2 sec2_q2 sec2_q5 mig_2_contact mig_15_contact past_mig2_contact sec2_q2_contact sec2_q5_contact{
replace `x'=upper(`x')
replace `x'=trim(`x')

replace `x'="SOUTH AFRICA" if `x'=="AFRIQUE DU SUD" 
replace `x'="ALGERIA" if `x'=="ALGERIE"
replace `x'="GERMANY" if `x'=="ALLEMAGNE" 
replace `x'="SAUDI ARABIA" if  `x'=="ARABIE SAOUDITE" 
replace `x'="AUSTRALIA" if `x'=="AUSTRALIE" 
replace `x'="AUSTRIA" if `x'=="AUTRICHE"
replace `x'="BELGIUM" if `x'=="BELGIQUE"
replace `x'="BRAZIL" if `x'=="BRESIL"
replace `x'="CHINA" if `x'=="CHINE"
replace `x'="CYPRUS" if `x'=="CHYPRE"
replace `x'="IVORY COAST" if `x'=="COTE D'IVOIRE" 
replace `x'="EGYPT" if `x'=="EGYPTE" 
replace `x'="UNITED ARAB EMIRATES" if `x'=="EMIRATS ARABES UNIS" 
replace `x'="SPAIN" if `x'=="ESPAGNE" 
replace `x'="ESTONIA" if `x'=="ESTONIE"
replace `x'="UNITED STATES" if `x'=="ETATS-UNIS" 
replace `x'="GAMBIA" if `x'=="GAMBIE"
replace `x'="GUINEA" if `x'=="GUINEE" 
replace `x'="GUINEA BISSAU" if `x'=="GUINEE BISSAU" 
replace `x'="EQUATORIAL GUINEA" if `x'=="GUINEE EQUATORIALE" 
replace `x'="ISLANDS OF BERMUDA" if `x'=="ILES BERMUDES"
replace `x'="INDIA" if `x'=="INDE"
replace `x'="IRELAND" if  `x'=="IRLANDE"
replace `x'="ICELAND" if `x'=="ISLANDE"
replace `x'="ITALY" if `x'=="ITALIE" 
replace `x'="LEBANON" if `x'=="LIBAN" 
replace `x'="LIBYA" if `x'=="LIBYE"
replace `x'="JAPAN" if `x'=="JAPON" 
replace `x'="MALAISIA" if `x'=="MALAISIE" 
replace `x'="MOROCCO" if `x'=="MAROC"
replace `x'="MAURITANIA" if `x'=="MAURITANIE" 
replace `x'="MEXICO" if `x'=="MEXIQUE"
replace `x'="NORWAY" if `x'=="NORVEGE"
replace `x'="NETHERLANDS" if `x'=="PAYS-BAS" 
replace `x'="POLAND" if `x'=="POLOGNE"
replace `x'="ROMANIA" if `x'=="ROUMANIE"
replace `x'="UNITED KINGDOM" if `x'=="ROYAUME-UNI"
replace `x'="RUSSIA" if  `x'=="RUSSIE"
replace `x'="SWEDEN" if `x'=="SUEDE" 
replace `x'="SWITZERLAND" if `x'=="SUISSE" 
replace `x'="TUNISIA" if `x'=="TUNISIE"
replace `x'="TURKEY" if `x'=="TURQUIE" 

}

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3.2 - CLEANING CONTINENT'S NAME
***_____________________________________________________________________________

foreach x in mig_1 mig_14 past_mig1 sec2_q2_a sec2_q5a mig_1_contact mig_14_contact past_mig1_contact sec2_q2a_contact sec2_q5a_contact{
replace `x'=upper(`x')
replace `x'=trim(`x')
replace `x'="NORTH AMERICA" if `x'=="AMERIQUE DU NORD" 
replace `x'="SOUTH AMERICA" if `x'=="AMERIQUE DU SUD" 
replace `x'="ASIA" if `x'=="ASIE" 
replace `x'="AFRICA" if `x'=="AFRIQUE" 
}

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   3.3 - CLEANING TEXT VARIABLES
***_____________________________________________________________________________

*cf excel file "cleaning_text" in \Data\correction_file\correction_followup2\phone_survey

foreach x in where_5 mig_7 mig_19 mig_26 mig_31 sec2_q3_other_reasonmig sec2_q7_other_plan sec0_q4_a_contact where_5_contact mig_7_contact mig_19_contact mig_26_contact mig_31_contact past_mig9_a_contact sec2_q3_other_reasonmig_contact sec2_q7_other_plan_contact{
replace `x'= subinstr(`x', "Ã©", "e",.)
replace `x'= subinstr(`x', "Ã¯", "a",.)
replace `x'= subinstr(`x', "Ãª", "e",.)
replace `x'= subinstr(`x', "Ã¨", "e",.)
replace `x'= subinstr(`x', "Ã ", "E",.)
replace `x'= subinstr(`x', "Ã´", "o",.)
replace `x'= subinstr(`x', "Ã", "E",.)
replace `x'= subinstr(`x', "Ã¢", "a",.)
replace `x'= subinstr(`x', "Ã®", "i",.)
replace `x'= subinstr(`x', "Ã¼", "u",.)
replace `x'= subinstr(`x', "Ã¢", "a",.)
replace `x'= subinstr(`x', "Ã ", "a",.)
replace `x'=upper(`x')
replace `x'= subinstr(`x', "GROUPE SCOLAIRE ", "",.)
replace `x'= subinstr(`x', "GROUPE  SCOLAIRE ", "",.)
replace `x'= subinstr(`x', "GS ", "",.)
}


	*New high school name: where_5  and where_5_contact

replace where_5="" if where_5=="A" | where_5=="L"
replace where_5="1ER MARS" if where_5=="LYCEE 1ER MARS"
replace where_5="AHMED SEKOU TOURE" if where_5=="LYCEE  AMEDE SEKOU TOURE  MATOTO" | where_5=="LYCEE AHMED SEKOU TOURE" | where_5=="LYCEE AMEDE SEKOU TOURE  MATOTO" | where_5=="LYCEE AST" | where_5=="LYCEE AVIATION AHMED SEKOU TOURE"
replace where_5="ABDOUL MALICK DIALLO" if where_5=="ADOULICKMALICK DIALLO  RATOMA"
replace where_5="ABDRAHAMANE SIDIBE" if where_5=="CS ABDRAHAMANE SIDIBE"
replace where_5="ABOULAYE SANGAREAH" if where_5=="SANGAREYA"
replace where_5="ALAMA TRAORE" if where_5=="ALAMA  TRAORE"
replace where_5="ALBERT BAUER" if where_5=="ALBERT BAUYER"
replace where_5="ALBERT CAMUS" if where_5=="FRANCIS CAMUS"
replace where_5="ALBERT DE MONACO" if where_5=="ALBERT DE MONNACO"
replace where_5="ALHASSANE SOUMAH" if where_5=="ALHASSANE  SOUMAH"
replace where_5="AMADOU SADIGOU DIALLO" if where_5=="AMADOU  SADIGOU DIALLO" | where_5=="AMADOU  SADIGOU DIALO" | where_5=="AMADOU SADIBOU DAILLO" | where_5=="AMADOU SADIGOU" | where_5=="AMADOU SADIGOU  DIALLO" | where_5=="AMADOU SADIOU DIALLO" | where_5=="AMADOU SALIOU DIALLO" 
replace where_5="BADEMBA FOFANA" if where_5=="BA DEMBA FOFANA" | where_5=="BABADI FOFANA" | where_5=="BADEMDEBA FOFANA"
replace where_5="BAH KANE" if where_5=="BAH-KAN" | where_5=="BAHKANE" 
replace where_5="BAKARY KOUROUMA" if where_5=="BAKARY  KOUROUMA"
replace where_5="BAPTISTE" if where_5=="BASTIS" | where_5=="BATISTE" | where_5=="GROUPE BATISTE"
replace where_5="BILL CLINTON" if where_5=="BILLY CLINTON" | where_5=="COMPLEXE SCOLAIRE BILL CLINTON" | where_5=="CS BILL CLINTON"
replace where_5="BILL GATES" if where_5=="BILL GUET"
replace where_5="BOUBACAR BIRO DIALLO" if where_5=="BOCAR BIRO DE SANGOYA" | where_5=="BOUBACAR BIRO" | where_5=="BOUBACAR BIRO DE SANGOYA" | where_5=="BOUBACAR BIRO DIALLO DE SANGOYA"
replace where_5="CAMESS" if where_5=="CAMES" | where_5=="GSM CAMESS"
replace where_5="CDLEX" if where_5=="CDELEX"
replace where_5="CHATEAUBRIAND" if where_5=="CHATEAU BRIAND" | where_5=="CHATEAU BRILLANT" | where_5=="CHATEAUX BRILLANT"
replace where_5="CHEICK ABDOUL KABA" if where_5=="CHEICK ABDUL KABA" | where_5=="CHEIK ABDOUL KABA"
replace where_5="CHEICK CHERIF SAGALE" if where_5=="SAGALE"
replace where_5="CHRISTINE CAMARA" if where_5=="CHRISTINE  CAMARA MATOTO"  | where_5=="CHRISTINE CAMARA Ã  MATOTO"
replace where_5="CIBLE DU FORMATEUR" if where_5=="CIBLE DE FORMATEUR" | where_5=="LA CIBLE"
replace where_5="CS LAMBANDJI" if where_5=="CS DE LAMBNGNI"
replace where_5="DENIS GALEMA" if where_5=="GALEMA" | where_5=="LYCEE GALEMA"
replace where_5="DONKA" if where_5=="LYCEE  DONKA" | where_5=="LYCEE DONKA"
replace where_5="DR IBRAHIMA FOFANA" if where_5=="DOCTEUR IBRAHIM FOFANA" | where_5=="IBRAHIMA  FOFANA" | where_5=="IBRAHIMA FOFANA"
replace where_5="E.I.C." if where_5=="ECOLE INTERNATIONALE DE CONAKRY" | where_5=="EIC"
replace where_5="EL HADJ ALPHA OUMAR" if where_5=="ELHADJ ALPHA OUMAR"
replace where_5="EL IBRAHIMA BAH" if where_5=="ELHADJ IBRAHIM BAH" | where_5=="ELHADJ IBRAHIMA BAH" | where_5=="IBRAHIMA BAH" | where_5=="LYCEE BAH IBRAHIMA" 
replace where_5="EL. NOUHOU DIALLO" if where_5=="DIALLO ELHADJ NOUHOU 2" | where_5=="ELHADJ NOUHOU" | where_5=="ELHADJ NOUHOU DIALLO DE CIMENTERIE"
replace where_5="ELHADJ AMADOU BAILO BAH" if where_5=="ELHADJ AMADOU BAALLO" | where_5=="ELHADJ AMADOU BAALLO BAH" | where_5=="ELHADJ AMADOU BAILLO" | where_5=="ELHADJ AMADOU BAILLO BAH" | where_5=="ELHADJI  AMADOU  BAILO BAH" | where_5=="ELHADJI AMADOU BAILO" 
replace where_5="ELHADJ BAFODE TOURE" if where_5=="ELHADJ BAFODE TOURE Ã  KHABITAYA"
replace where_5="ELHADJ BOUBACAR BIRO DIALLO" if where_5=="ELHADJ ABOUBACAR BIRO DIALLO" | where_5=="ELHADJ BOUBACAR BIRO" | where_5=="ELHADJ BOUBACAR BIRO DIALLO  MATOTO" | where_5=="ELHADJI BOCARBIRO" | where_5=="LYCEE ELHADJ BOUBACAR BIRO DIALLO" 
replace where_5="EMMAUS" if where_5=="EMAUS" | where_5=="EMAUS ENTA" | where_5=="EMMAIS" | where_5=="EMMAUS DE ENTA" | where_5=="EMMAUS DE PETIT SIMBAYA" | where_5=="EMMAUS PETIT SIMBAYA" | where_5=="EMMEIS"
replace where_5="ENFANT NOIR" if where_5=="ENFANTS NOIR" | where_5=="L'ENFANT NOIR"
replace where_5="ESPOIR" if where_5=="COMPLEXE DE LESPOIRE" | where_5=="L'ESPOIR" 
replace where_5="EXCELLENCE PROFESSEUR ALPHA CONDE" if where_5=="EXCELLENCE  ALPHA  CONDE  MATOTO" | where_5=="EXCELLENCE ALPHA CONDE" | where_5=="EXCELLENCE PROFESSSEUR ALPHA CONDE" | where_5=="LYCEE DE L'EXCELLENCE" | where_5=="LYCEE D'EXCELLENCE PROFESSEUR ALPHA CONDE" | where_5=="LYCEE EXCELLENCE" | where_5=="LYCEE EXCELLENCE PROFESSEUR ALPHA CONDE"
replace where_5="FIDEL CASTRO" if where_5=="CIBEL CASTRO"  | where_5=="FIDELE CAS TRO"   | where_5=="FIDELE CASTRO" 
replace where_5="FRANCOIS MITTERAND" if where_5=="FRANÃ§OIS MITERAN" | where_5=="FRANÃ§OISE  MITTRAND  MATOTO" 
replace where_5="FUTURE GENERATION" if where_5=="FUTUR  GENERATION" | where_5=="FUTURE GENERATIONS" | where_5=="LA FUTURE GENERATION" 
replace where_5="GANGAN KANYA" if where_5=="GAGNANT KANYA" | where_5=="GANGAN KANYA DE SANGOYA" 
replace where_5="GARAYA 1" if where_5=="A GARAYA 1"
replace where_5="GARAYA 2" if where_5=="GARAYA II"
replace where_5="HADJA HABIBATA TOUNKARA" if where_5=="HADJA HABIBATOU TOU" | where_5=="HADJA HABIBATOU TOUNKARA" | where_5=="HADJA HADIATOU TOUNKARA" 
replace where_5="HADJA MAGUETTE TRAORE" if where_5=="MAGUETTE TRAORE"
replace where_5="HADJA MARIAMA SOUMAH" if where_5=="HADJA MARIAME SOUMAH"
replace where_5="HADJA M'BALLOU" if where_5=="HADJA MBALOU"  | where_5=="HADJA M'BALOU" 
replace where_5="HADJA NANSIRA KEITA" if where_5=="HADJA NANSIRA KEITA Ã  DUBREKA"
replace where_5="HADJA RAMATOULAYE BODJE BALDE" if where_5=="HADJA  RAMATOULAYE  BODJE  BALDE" | where_5=="HADJA RAMATOULAYE BODE BALDE" | where_5=="HADJA RAMATOULAYE BODHISATTVA BALDE" | where_5=="HADJA RAMATOULAYE BODJE" | where_5=="HADJA RAMATOULAYE BODJE BALDE  MATOTO"  | where_5=="HADJA RAMATOULAYE BODJI BALDE"   | where_5=="HADJA RAMATOULAYE BODY BAH" 
replace where_5="HAMDALLAYE SECONDAIRE" if where_5=="HAMDALAYE SECONDAIRE" | where_5=="HAMDANLAYE SECONDAIRE" 
replace where_5="HYNDAYE" if where_5=="HYNDAIY"
replace where_5="IBRAHIMA KALIL KOUROUMA" if where_5=="IBRAHIMA KOUROUMA DE YATTAYA"
replace where_5="INSET" if where_5=="COMPLEXE SCOLAIRE INSET"
replace where_5="JACQUELINE BANGOURA" if where_5=="JACKELINE BANGOURA"
replace where_5="JEAN BAPTISTE" if where_5=="JEAN-BAPTISTE"
replace where_5="JEAN MERMOZ" if where_5=="MERMOZ"
replace where_5="JOHN KENNEDY" if where_5=="JHON KENNEDY" | where_5=="JOHN S KENNEDY" | where_5=="KENEDI"
replace where_5="KEITAYA" if where_5=="KEITAYA Ã   KAGBELEN"
replace where_5="KELEFA DIALLO" if where_5=="KELEFA" 
replace where_5="KK1" if where_5=="KOUMANDJAN KEITA 1 (KK1)" | where_5=="KOUMANDJAN KEITA1"
replace where_5="KOFFI ANNAN" if where_5=="KOFFI ANANN" | where_5=="KOFFI ANNA"
replace where_5="LA GRACE" if where_5=="L' AGRACE" | where_5=="LAGRACE" 
replace where_5="LA GRANDE ECOLE" if where_5=="LA GRANDE  ECOLE"
replace where_5="LA SPHERE" if where_5=="CS LA SPHERE"
replace where_5="LA TOURTERELLE" if where_5=="COURTOIRELLE" | where_5=="TOURTERELLE" | where_5=="TOURTERELLES" 
replace where_5="LADY DIANA" if where_5=="LEDY DIANA"
replace where_5="LE SANOU" if where_5=="LE SANNOU Ã  KOUNTIA"
replace where_5="LE SOUMBOUYAH" if where_5=="SOUMBOUYA"| where_5=="SOUMBOUYA  Ã  YATTAYA" | where_5=="SOUMBOUYA Ã  YATTAYA" | where_5=="SOUMBOUYAH" 
replace where_5="LEOPOLD SEDAR SENGHOR" if where_5=="LEOPOL SEDARD SENGHORD" | where_5=="LEOPOL SEDARD SENGHORD  RATOMA" | where_5=="LYCEE LEOPARD SEDAR SENGHOR" | where_5=="LYCEE SENGHOR" | where_5=="LYCEE SENGHOR YIMBAYA" | where_5=="LYCEE SENGHORE" | where_5=="SENGHOR"
replace where_5="LES LEADERS DE DEMAIN" if where_5=="LES LEADERS" | where_5=="LES LEADERS DE  DEMAIN"  | where_5=="LES LEADERS DEMAIN" 
replace where_5="LMD" if where_5=="LMD DE DIXINN"
replace where_5="LYCEE KIPEE" if where_5=="LYCEE  KIPE" | where_5=="LYCEE KIPEE " 
replace where_5="LYCEE 02 OCTOBRE" if where_5=="02/10/2020"  | where_5=="LYCEE 2 OCTOBRE" 
replace where_5="LYCEE DES JEUNES FILLES" if where_5=="LYCEE  DES JEUNES FILLES" | where_5=="LYCEE DES JEUNES" | where_5=="LYCEE DES JEUNES FILLES  DE L'AMBANGNI" | where_5=="LYCEE DES JEUNES FILLES Ã  LAMBANDJI" | where_5=="LYCEES DES JEUNES" 
replace where_5="LYCEE COBAYAH" if where_5=="LYCEE COBAYA"
replace where_5="LYCEE LAMBANDJI" if where_5=="LYCEE LAMBANYI" | where_5=="LAMBANDJI 1" | where_5=="LYCEE LAMBAYI" | where_5=="LYCEE LAMBNGNI"
replace where_5="LYCEE LAMBANDJI 2" if where_5=="CS DE LAMBANDJI 2" | where_5=="DE LAMBAYI" | where_5=="LAMBAYI 2" | where_5=="LYCEE 2 DE LAMBAGNI"
replace where_5="LYCEE MODERNE FOULA MADINA" if where_5=="LYCEE MODERNE DE FOULA MADINA" | where_5=="LYCEE MODERNE FOULARD"
replace where_5="MAHATMA GANDHI" if where_5=="GHANDHI"  | where_5=="LYCEE MAHATMA GHANDI" 
replace where_5="MAMA AICHA CONDE" if where_5=="HADJA MAMAN AICHA CONDE"  | where_5=="MAMAISSATA CONDE" | where_5=="MAMAN AACHA CONDE" | where_5=="MAMAN AACHAISSATA  CONDE MAC MATOTO" | where_5=="MAMAN AICHA CONDE" 
replace where_5="MAMADOU SIDIBE" if where_5=="MAMADOU SIDIBE  MATOTO"
replace where_5="MANGUE JUNIOR" if where_5=="MANGUE JUNIOR Ã  SIMANBOSSYA" | where_5=="MANQUE JUNIOR"
replace where_5="MARTIN LUTHER KING" if where_5=="E EASEUR MARTIN LUTTER"
replace where_5="MARTINE AUBRY" if where_5=="MARTINE  AUBRY" | where_5=="MARTINE AURY" 
replace where_5="MELI MOUSSA CAMARA" if where_5=="MELIMOUSSA" | where_5=="MELLY MOUSSA" | where_5=="MELLY MOUSSA CAMARA" 
replace where_5="MICHELLE OBAMA" if where_5=="MICHEL  OBAMA" | where_5=="MICHEL OBAMA"
replace where_5="MIOD BOWAL" if where_5=="LES ECOLES MIOD BOWAL" | where_5=="MIOBOWAL" | where_5=="MODE BOWAL"
replace where_5="MOHAMED LAMINE SOUARE" if where_5=="MLS"
replace where_5="MOUCTAR DIALLO" if where_5=="MOUCTAR DIALLO MATOTO"
replace where_5="NIMBA ELISA" if where_5=="NIMBE ELISA"
replace where_5="NOTRE MERE PLUS" if where_5=="NOTRE  MERE  PLUS" | where_5=="NOTRE MERE" | where_5=="NOTRE MERE  PLUS MOTOTO" | where_5=="NOTRE MERE PLUS DE DAPOMPA" | where_5=="NOTRE PLUS" 
replace where_5="OUMAR CAMARA" if where_5=="OC"
replace where_5="OUMAR KALOGA" if where_5=="OK"
replace where_5="OUSMANE CAMARA" if where_5=="OUSMANE  CAMARA" | where_5=="OUSMANE CARAMA"
replace where_5="PAS A PAS" if where_5=="LYCEE PAS Ã  PAS"
replace where_5="PELLAL INTERNATIONALE" if where_5=="PELLAL INTERNATIONAL"
replace where_5="PROVIDENCE" if where_5=="CROVIDENCE" | where_5=="LA PROVIDENCE"
replace where_5="PROVIDENCE 2" if where_5=="LA PROVIDENCE 2" | where_5=="PROVENCE 2" | where_5=="PROVIDENCE2" 
replace where_5="RAKA FOFANA GBESSIA" if where_5=="RAKA FOFANA" | where_5=="RAKA GBESSIA" | where_5=="RATA FOFANA"
replace where_5="ROI HASSANE 2" if where_5=="ROI HASSANE LL" | where_5=="ROI HASSANE2" 
replace where_5="ROI MOHAMED 6" if where_5=="ROI MOHAMED VI"  | where_5=="ROI MOHAMED6" 
replace where_5="SAFIA ECOLE" if where_5=="CS SAFIA ECOLE"
replace where_5="SAINT GEORGES" if where_5=="SAINT GEORGE" | where_5=="ST GEORGES"
replace where_5="SAINT JOSEPH LAMBANDJI" if where_5=="SAINT JOSEPH DE  LAMBANDJI" | where_5=="SAINT JOSEPH DE  LAMBANYI"
replace where_5="SAINT LOUIS" if where_5=="SAINT LOUIS Ã  SONFONIA GARE"
replace where_5="SAINTE MAGALIE" if where_5=="MAGAÄºIE" | where_5=="SAINT MAGALI" | where_5=="SAINTE MAVALI"  
replace where_5="SAINTE MARIE" if where_5=="LYCEE SAINTE MARIE" | where_5=="SAINT MARIE DE DIXINN" 
replace where_5="SALEM" if where_5=="SALEHM" | where_5=="SALIM" | where_5=="SALIM  ECOLE  MOTOTO" | where_5=="SALIM ECOLE"
replace where_5="SANTA MARIA" if where_5=="SANTAMARIA" | where_5=="SATAN MARIA" 
replace where_5="SEMYG" if where_5=="LYCEE SEMYG" | where_5=="SEMIG" | where_5=="SEMIG 1" | where_5=="SEMING" | where_5=="SEMIYE" | where_5=="SEMMIC" | where_5=="SEMYG 1"
replace where_5="SEMYG 2" if where_5=="SEMIG 2" | where_5=="SEMYG2" 
replace where_5="SICAG" if where_5=="CICAG" 
replace where_5="SONFONIA" if where_5=="LYCEE SONFONIA" | where_5=="SONFONYA"
replace where_5="SOPHIAPOLE" if where_5=="SOFIAPOL" 
replace where_5="SYLLA LAMINE" if where_5=="SYLLA  LAMINE" | where_5=="SYLLA LAMINE DE TAOUYAH" 
replace where_5="THIERNO MONENEMBO" if where_5=="THIERNO MONENEBO" | where_5=="THIERNO MONEUNBO"
replace where_5="TITI 1" if where_5=="TITI1" 
replace where_5="TITI 2" if where_5=="TITI2" 
replace where_5="VAN VOLLENHOVEN" if where_5=="VAN VOLL" 
replace where_5="VINGT-HUIT SEPTEMBRE" if where_5=="LYCEE 28 SEPTEMBRE" | where_5=="VINGT HUIT SEPTEMBRE" | where_5=="28/09/2020" 
replace where_5="WILLIAM DU BOIS" if where_5=="WILLIAMS DU BOIS"
replace where_5="WINFREY OPRAH DE GUINEE" if where_5=="WINFREY OPRAH" | where_5=="WINFREY OPRAH  DE GUINEE" | where_5=="WINFREY OPRAH A LA CIMENTERIE"
replace where_5="WINFREY OPRAH DE GUINEE DUBREKA" if where_5=="COMPLEXE  SCOLAIRE  WRNFREY OPRAH DE GUINEE  DUBREKA"
replace where_5="WODIA BERETE" if where_5=="ODIA BERETE"
replace where_5="YAMASSAFOU BAH" if where_5=="YAMA SADOU BAH" | where_5=="YAMASSAFOU" | where_5=="YAMOUSSA FOU BAH" | where_5=="YAMOUSSAFOU BAH" | where_5=="YAMSSAFOI BAH" 
replace where_5="YATTAYA" if where_5=="YATTEYA"
	 
*browse if where_5_contact!=""
replace where_5_contact="1ER MARS" if where_5_contact=="LYCEE 1ER MARS" 
replace where_5_contact="AMADOU SADIGOU DIALLO" if where_5_contact=="GS AMADOU SADIOU DIALLO" 
replace where_5_contact="BADEMBA FOFANA" if where_5_contact=="BA DEMBA" 
replace where_5_contact="CIBLE DU FORMATEUR" if where_5_contact=="LA CIBLE" 
replace where_5_contact="DAR ES SALAM" if where_5_contact=="DARSALAM" | where_5_contact=="QUARTIER DARSALAM"	 
replace where_5_contact="EMMAUS" if where_5_contact=="EMMAIS" 
replace where_5_contact="HADJA HABIBATA TOUNKARA" if where_5_contact=="ABIBATOU TOUNKARA" 
replace where_5_contact="HADJA RAMATOULAYE BODJE BALDE" if where_5_contact=="HADJA RAMATOULAYE BODJI" | where_5_contact=="HADJA RAMATOULAYE BODJI BALDE"	
replace where_5_contact="LYCEE 02 OCTOBRE" if where_5_contact=="O2 OCTOBRE" 
replace where_5_contact="LYCEE KIPEE" if where_5_contact=="LYCEE KIPE" 
replace where_5_contact="LYCEE LAMBANDJI" if where_5_contact=="LYCEE LAMBANYI" 
replace where_5_contact="MAHATMA GANDHI" if where_5_contact=="GANDHI" 
replace where_5_contact="NELSON MANDELA" if where_5_contact=="NELSON MANDELA ECOLE DE SANTE" 
replace where_5_contact="OUSMANE CAMARA" if where_5_contact=="OC" 
replace where_5_contact="SALEM" if where_5_contact=="SALIM" 
replace where_5_contact="SAMATARA" if where_5_contact=="SAMATARA Ã  SONFONIA" 
replace where_5_contact="THIERNO MONENEMBO" if where_5_contact=="THIERNO MONENEBO" 


	*How do you plan to go?
*browse if mig_26!=""
replace mig_26="I WILL GO TO UNIVERSITY IN SENEGAL" if mig_26=="APRES AVOIR EU MON BAC DONC J'AI DEMANDE AUX PARENTS DE M'ENVOYER FAIRE L'UNIVERSITE AU SENEGAL"

	*How do you plan to go
*browse if mig_31!=""
replace mig_28=. if mig_31=="PAR AVION VOYAGE LEGALE"
replace mig_29=. if mig_31=="PAR AVION VOYAGE LEGALE"
replace mig_30=. if mig_31=="PAR AVION VOYAGE LEGALE"
replace mig_31="" if mig_31=="PAR AVION VOYAGE LEGALE"

replace mig_28=. if mig_31=="AVION"
replace mig_29=. if mig_31=="AVION"
replace mig_30=. if mig_31=="AVION"
replace mig_31="" if mig_31=="AVION"
	  
*browse if mig_31_contact!=""
replace mig_28_contact=. if mig_31_contact=="AVION"
replace mig_29_contact=. if mig_31_contact=="AVION"
replace mig_30_contact=. if mig_31_contact=="AVION"
replace mig_31_contact="" if mig_31_contact=="AVION"
	
replace mig_28_contact=. if mig_31_contact=="PAR AVION"
replace mig_29_contact=. if mig_31_contact=="PAR AVION"
replace mig_30_contact=. if mig_31_contact=="PAR AVION"
replace mig_31_contact="" if mig_31_contact=="PAR AVION"
	  
	*Other type of preparation:
*browse if sec2_q7_other_plan!=""
replace sec2_q7_other_plan="APPLICATION FORM FOR CANADA" if sec2_q7_other_plan=="DEMANDE D'ADMISSION POUR LE CANADA"
replace sec2_q7_other_plan="CAMPUS FRANCE (A WAY TO GET A VISA TO STUDY IN FRANCE)" if sec2_q7_other_plan=="J'AI TENTE CAMPUS FRANCE" | sec2_q7_other_plan=="J'AI TENTE LE CAMPUS FRANCE" | sec2_q7_other_plan=="JE RENTRE AU CAMPUS" | sec2_q7_other_plan=="JE SUIS RENTRE DANS LE CAMPUS FRANCE" | sec2_q7_other_plan=="J'ESPERE  ETRE LAUREATE" | sec2_q7_other_plan=="L'ADMISSION CAMPUS FRANCE" 
replace sec2_q7_other_plan="I AM GETTING A PASSPORT" if sec2_q7_other_plan=="ARRANGER MON PASPORT" | sec2_q7_other_plan=="FAIRE UN PASPORT" | sec2_q7_other_plan=="J'AI FAIT MON PASSEPORT" | sec2_q7_other_plan=="JE CHERCHE UN PASSEPORT" | sec2_q7_other_plan=="JE FAIS MON PASSEPORT" 
replace sec2_q7_other_plan="I AM LEARNING THE LANGUAGE" if sec2_q7_other_plan=="JE SUIS DES COURS ALLEMANDE" | sec2_q7_other_plan=="JE SUIS DES COURS DE LANGUE"
replace sec2_q7_other_plan="MY BROTHER CONTACTED A SMUGGLER IN MOROCCO TO GET IN SPAIN THEN FRANCE" if sec2_q7_other_plan=="MON FRERE A CONTACTE UN PASSEUR AU MAROC POUR ME FAIRE RENTRER EN ESPAGNE PUIS LA FRANCE"
replace sec2_q7_other_plan="MY PARENTS HAVE MADE PREPARATIONS" if sec2_q7_other_plan=="C'EST  MES PARENTS  QUI ONT  EFFECTUE  DES  PREPARATIFS" | sec2_q7_other_plan=="LES PARENTS ONT  EFFECTUE LES PREPARATIFS" | sec2_q7_other_plan=="LES PREPARATIFS SONT  FAITS PAR LES PARENTS" | sec2_q7_other_plan=="MES PARENTS ONT FAIT DES PREPARATIFS" 
replace sec2_q7_other_plan="PREPARING APPLICATION FORM" if sec2_q7_other_plan=="DOSSIER PREPARER"
replace sec2_q7_other_plan="PREPARING PAPERS FOR THE EMBASSY" if sec2_q7_other_plan=="PREPARE SES DOSSIERS POUR L'AMBASSADE"
replace sec2_q7_other_plan="WAITING FOR HER HUSBAND" if sec2_q7_other_plan=="ATTEND SON MARI"

replace sec2_q7_example_3=1 if sec2_q7_other_plan=="J'AI INFORME  MON FRERE"
replace sec2_q7_other_plan="" if sec2_q7_other_plan=="J'AI INFORME  MON FRERE"


//////////////  OTHER REASONS TO MIGRATE ///////////////// 

***STUDENT: sec2_q3_other_reasonmig 

*Economic : making sure they checked reason 2
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="A cause de la monnaie"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="A cause du chômage"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Améliorer ma condition de vie"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Belle vie"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Chercher  du travail"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Chômage"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Entrepreneur"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Informatique"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Ingénieur"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="La jeunesse souffre"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="La pauvreté"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="La pauvreté et la famine"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="La pauvreté et le d'emploi"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="L'argent de mon pays n'a pas de valeur"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Le chômage"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Le chômage ,mauvaise éducation"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Le commerce"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Le pays ne vas pas bien ya trop de souffrance"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Manque d'emploi"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Manque d'emploi, pays sale"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Parce-que ya trop de galère de misere en Guinée"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Problème de moyens"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Rien ne vas en Guinée"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Travail"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Travailler"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Travailler Ã  la banque"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Travailler ou medecine"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Travailler se marier laba"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Un boulot"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Un manque d'emploi"
replace sec2_q3_2=1 if sec2_q3_other_reasonmig=="Une meilleure vie"

*erasing the "other reason" as it fits in the category "economic reasons"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="A cause de la monnaie"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="A cause du chômage"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Améliorer ma condition de vie"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Belle vie"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Chercher  du travail"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Chômage"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Entrepreneur"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Informatique"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Ingénieur"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="La jeunesse souffre"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="La pauvreté"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="La pauvreté et la famine"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="La pauvreté et le d'emploi"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="L'argent de mon pays n'a pas de valeur"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Le chômage"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Le chômage ,mauvaise éducation"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Le commerce"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Le pays ne vas pas bien ya trop de souffrance"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Manque d'emploi"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Manque d'emploi, pays sale"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Parce-que ya trop de galère de misere en Guinée"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Problème de moyens"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Rien ne vas en Guinée"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Travail"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Travailler"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Travailler Ã  la banque"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Travailler ou medecine"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Travailler se marier laba"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Un boulot"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Un manque d'emploi"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Une meilleure vie"

*Continue my studies -> all 4 already had 1: replace by "" ?
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Apprendre la médecine  ou la pharmacie"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Apprendre l'Architecture"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Apprendre l'astronomie"
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Médecine"

*Family reasons
replace sec2_q3_3=1 if sec2_q3_other_reasonmig=="Aider ma mère"

replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="Aider ma mère"

*Translation
replace sec2_q3_other_reasonmig="Bad education system" if sec2_q3_other_reasonmig=="La valeur des diplômes" | sec2_q3_other_reasonmig=="Le chômage ,mauvaise éducation" | sec2_q3_other_reasonmig=="Le systeme educatif" | sec2_q3_other_reasonmig=="Le système éducatif n'est pas favorable" | sec2_q3_other_reasonmig=="Pas de bonne etude en Guinée"
replace sec2_q3_other_reasonmig="Because of my friends" if sec2_q3_other_reasonmig=="A cause de mes amis"
replace sec2_q3_other_reasonmig="Become an artist, actress, dancer, model, singer" if sec2_q3_other_reasonmig=="Artiste" | sec2_q3_other_reasonmig=="Actrice ou chanteuse" | sec2_q3_other_reasonmig=="Mannequina" | sec2_q3_other_reasonmig=="Ãtre un danseur" | sec2_q3_other_reasonmig=="Cinéma"
replace sec2_q3_other_reasonmig="Better life conditions" if sec2_q3_other_reasonmig=="Les conditions  ne sont pas  bonnes ici" | sec2_q3_other_reasonmig=="Les conditions de vie de la France" | sec2_q3_other_reasonmig=="Les meilleurs conditions de vie" | sec2_q3_other_reasonmig=="Meilleurs  conditions  de vie" | sec2_q3_other_reasonmig=="Mener une vie heureuse" | sec2_q3_other_reasonmig=="Rien ne vas en Guinée" | sec2_q3_other_reasonmig=="Un pays de merde" | sec2_q3_other_reasonmig=="Une meilleure vie" | sec2_q3_other_reasonmig=="Belle vie"
replace sec2_q3_other_reasonmig="Come back to Guinea to help the poor" if sec2_q3_other_reasonmig=="Revenir aider les pauvres et les orphelins"
replace sec2_q3_other_reasonmig="Discover a new culture" if sec2_q3_other_reasonmig=="Changer de culture"
replace sec2_q3_other_reasonmig="Discover Europe" if sec2_q3_other_reasonmig=="Découvrir l'Europe"
replace sec2_q3_other_reasonmig="Discover the country" if sec2_q3_other_reasonmig=="ConnaÃ®tre un peu le canada" | sec2_q3_other_reasonmig=="Juste une curiosité" | sec2_q3_other_reasonmig=="Pour une decouverte" | sec2_q3_other_reasonmig=="Tourisme" | sec2_q3_other_reasonmig=="Visiter lÃ -bas"
replace sec2_q3_other_reasonmig="Discover the world" if sec2_q3_other_reasonmig=="Découvrir  le monde" | sec2_q3_other_reasonmig=="Découvrir d'autres horizons" 
replace sec2_q3_other_reasonmig="Dream country" if sec2_q3_other_reasonmig=="Payé de rêve" | sec2_q3_other_reasonmig=="Payé rêve" | sec2_q3_other_reasonmig=="Pays de rêve" | sec2_q3_other_reasonmig=="Réaliser mes reves" | sec2_q3_other_reasonmig=="Réaliser mes rêves" | sec2_q3_other_reasonmig=="Réaliser ses reves" | sec2_q3_other_reasonmig=="Rêve" | sec2_q3_other_reasonmig=="Rêve d'enfance" | sec2_q3_other_reasonmig=="Rêve d'enfants" 
replace sec2_q3_other_reasonmig="Hairdresser" if sec2_q3_other_reasonmig=="Coiffure" | sec2_q3_other_reasonmig=="La coiffure" 
replace sec2_q3_other_reasonmig="Health reasons" if sec2_q3_other_reasonmig=="Maladie" | sec2_q3_other_reasonmig=="Me faire soigner" | sec2_q3_other_reasonmig=="Sante" | sec2_q3_other_reasonmig=="Traitement médical" 
replace sec2_q3_other_reasonmig="I love nature" if sec2_q3_other_reasonmig=="Aime la nature"
replace sec2_q3_other_reasonmig="I love the country" if sec2_q3_other_reasonmig=="Aime Belgique" | sec2_q3_other_reasonmig=="Aime la France" | sec2_q3_other_reasonmig=="J'aime la France" | sec2_q3_other_reasonmig=="J'aime le canada" | sec2_q3_other_reasonmig=="J'aime le pays" 
replace sec2_q3_other_reasonmig="Join the army" if sec2_q3_other_reasonmig=="Armée" | sec2_q3_other_reasonmig=="Faire l'armée" | sec2_q3_other_reasonmig=="Formation militaire" | sec2_q3_other_reasonmig=="Intégrer l'armée" | sec2_q3_other_reasonmig=="Je veux faire l'armée" 
replace sec2_q3_other_reasonmig="Learn English and play basketball" if sec2_q3_other_reasonmig=="Apprendre l'anglais et le basket"
replace sec2_q3_other_reasonmig="Learn English and play football" if sec2_q3_other_reasonmig=="Apprendre l'anglais et le foot ball"
replace sec2_q3_other_reasonmig="Learn/Play music" if sec2_q3_other_reasonmig=="Apprendre la musique" | sec2_q3_other_reasonmig=="Faire la musique"
replace sec2_q3_other_reasonmig="Learn the language" if sec2_q3_other_reasonmig=="Apprendre  l'anglais" | sec2_q3_other_reasonmig=="Apprendre la langue" | sec2_q3_other_reasonmig=="Apprendre la langue espagnole" | sec2_q3_other_reasonmig=="Apprendre l'anglais" | sec2_q3_other_reasonmig=="Apprendre l'anglais et l'allemand" | sec2_q3_other_reasonmig=="Apprendre l'engrais" | sec2_q3_other_reasonmig=="Apprendre leur langue" | sec2_q3_other_reasonmig=="Etudier  l'anglais" | sec2_q3_other_reasonmig=="Etudier la langue allemande" | sec2_q3_other_reasonmig=="J'aime la langue allemande" | sec2_q3_other_reasonmig=="La beauté de ville apprendre la langue" | sec2_q3_other_reasonmig=="Parler  anglais"
replace sec2_q3_other_reasonmig="No racism there" if sec2_q3_other_reasonmig=="Parce que lÃ -bas il n'y a pas de racisme"
replace sec2_q3_other_reasonmig="Basketball" if sec2_q3_other_reasonmig=="Basket" | sec2_q3_other_reasonmig=="Basket ball" | sec2_q3_other_reasonmig=="Basketball" | sec2_q3_other_reasonmig=="Basket-ball" | sec2_q3_other_reasonmig=="Le basket" 
replace sec2_q3_other_reasonmig="Football" if sec2_q3_other_reasonmig=="Foot ball" | sec2_q3_other_reasonmig=="Football" | sec2_q3_other_reasonmig=="Football ou bisness man" | sec2_q3_other_reasonmig=="Football réalisé ses rêves" | sec2_q3_other_reasonmig=="Footballeur" | sec2_q3_other_reasonmig=="Jouer au foot ball" | sec2_q3_other_reasonmig=="Jouer le foot" | sec2_q3_other_reasonmig=="Le football" | sec2_q3_other_reasonmig=="Pour le football"
replace sec2_q3_other_reasonmig="Political instability" if sec2_q3_other_reasonmig=="A cause des grèves répétées" | sec2_q3_other_reasonmig=="Insécurité" | sec2_q3_other_reasonmig=="Instabilité politique" | sec2_q3_other_reasonmig=="Les conditions  de vie et de sécurité" | sec2_q3_other_reasonmig=="Mauvaise gouvernance"  | sec2_q3_other_reasonmig=="Tranquillité  et la paix" | sec2_q3_other_reasonmig=="Le pays ne vas pas bien ya trop de souffrance"
replace sec2_q3_other_reasonmig="Religious reason" if sec2_q3_other_reasonmig=="Pour faire  le hadj"
replace sec2_q3_other_reasonmig="Sport" if sec2_q3_other_reasonmig=="Sport karaté"
replace sec2_q3_other_reasonmig="Unemployment" if sec2_q3_other_reasonmig=="Manque d'emploi"  | sec2_q3_other_reasonmig=="Manque d'emploi, pays sale" 
replace sec2_q3_other_reasonmig="Want to change country" if sec2_q3_other_reasonmig=="Envie de changer de pays"
replace sec2_q3_other_reasonmig="Want to travel" if sec2_q3_other_reasonmig=="Envie de voyager" | sec2_q3_other_reasonmig=="Je veux voyager" 
replace sec2_q3_other_reasonmig="Peaceful country" if sec2_q3_other_reasonmig=="Pays calme"
replace sec2_q3_other_reasonmig="Their lifestyle" if sec2_q3_other_reasonmig=="Leur mode de vie"
replace sec2_q3_other_reasonmig="Ambition" if sec2_q3_other_reasonmig=="Elle a l'ambition"
replace sec2_q3_other_reasonmig="Breeding" if sec2_q3_other_reasonmig=="Elevage"
replace sec2_q3_other_reasonmig="Mechanics" if sec2_q3_other_reasonmig=="La mecanique"

***CONTACT: sec2_q3_other_reasonmig_contact
 
*Economic reasons
replace sec2_q3_contact_2=1 if sec2_q3_other_reasonmig_contact=="Le pays est pauvre"

replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig_contact=="Le pays est pauvre"

*Translation
replace sec2_q3_other_reasonmig_contact="Football" if sec2_q3_other_reasonmig_contact=="Jouer au foot" | sec2_q3_other_reasonmig_contact=="Foot" | sec2_q3_other_reasonmig_contact=="Football" | sec2_q3_other_reasonmig_contact=="Foot ball" | sec2_q3_other_reasonmig_contact=="Jouer au foot ball"   
replace sec2_q3_other_reasonmig="Health reasons" if sec2_q3_other_reasonmig=="Traitement de son ouae"  

*STUDENT ALREADY ABROAD: mig_19

replace mig_18_2=1 if mig_19=="Vérification la société de mon papa"
replace mig_18_3=1 if mig_19=="Vérification la société de mon papa"
replace mig_19="To check my dad's company" if mig_19=="Vérification la société de mon papa"


//////////////  MONEY QUESTIONS /////////////////

*mig_9 : 7
*mig_27 : 200


***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   4- JOINING STUDENT AND CONTACT SURVEYS                             
***_____________________________________________________________________________

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   4.1 - ADDING VARIABLES FOR A SECOND CONTACT SURVEYS
***_____________________________________________________________________________

rename sec2_q3_other_reasonmig_contact sec2_q3_other_reasonmig_c

local contact_var sec2_q3_other_reasonmig_c sec2_q9_contact mig_13_contact check_con	consent_agree_contact	gender	sec0_q0_contact	sec0_q0_contact_1	sec0_q0_contact_2	sec0_q0_contact_3	sec0_q0_contact_4	sec0_q0_contact_5	sec0_q1_contact	sec0_q4_contact	sec0_q4_contact_1	sec0_q4_contact_2	sec0_q4_contact_3	sec0_q4_contact_4	sec0_q4_contact_5	sec0_q4_contact_6	sec0_q4_a_contact	where_9_contact	where_10_contact where_11_contact	where_1_contact	where_2_a_contact	where_2_c_contact	where_2_b_contact	where_3_contact	where_8_contact	where_4_contact	where_5_contact	where_6_contact	where_7_contact	sec2_q13_contact	sec2_q14_contact	sec2_q15_contact	mig_1_contact	mig_2_contact	mig_3_contact	mig_4_contact	mig_6_contact	mig_6_contact_1	mig_6_contact_2	mig_6_contact_3	mig_6_contact_4	mig_6_contact_5	mig_6_contact_6	mig_6_contact_7	mig_7_contact	mig_9_contact	mig_10_contact	mig_11_contact	mig_12_contact	mig_14_contact	mig_15_contact	mig_16_contact	mig_17_contact	mig_18_contact	mig_18_contact_1	mig_18_contact_2	mig_18_contact_3	mig_18_contact_4	mig_18_contact_5	mig_18_contact_6	mig_18_contact_7	mig_19_contact	mig_20_contact	mig_21_contact	mig_22_contact	mig_22_a_contact	mig_23_contact	mig_24_contact	mig_25_contact	mig_26_contact	mig_27_contact	mig_28_contact	mig_29_contact	mig_30_contact	mig_31_contact	mig_32_contact	mig_33_contact	mig_34_contact	mig_35_contact	migrated_returned_contact	past_mig1_contact	past_mig2_contact	past_mig9_contact	past_mig9_contact_1	past_mig9_contact_2	past_mig9_contact_3	past_mig9_contact_4	past_mig9_contact_5	past_mig9_contact_6	past_mig9_contact_7	past_mig9_a_contact	past_mig10_contact	past_mig11_contact	past_mig3_contact	past_mig4_contact	past_mig5_contact	past_mig6_contact	past_mig7_contact	sec2_q1_contact	sec2_q2a_contact	sec2_q2_contact	sec2_q3_contact	sec2_q3_contact_1	sec2_q3_contact_2	sec2_q3_contact_3	sec2_q3_contact_4	sec2_q3_contact_5	sec2_q3_contact_6	sec2_q3_contact_7	sec2_q4_contact	sec2_q5a_contact	sec2_q5_contact	sec2_q7_contact	sec2_q7_example_contact	sec2_q7_example_contact_1	sec2_q7_example_contact_2	sec2_q7_example_contact_3	sec2_q7_example_contact_4	sec2_q7_other_plan_contact	sec2_q8_contact	sec2_q10_a_contact	sec2_q10_b_contact	sec2_q10_c_contact	sec0_q6_fb_contact starttime_date starttime_hour endtime_date endtime_hour
foreach var of local contact_var {
gen `var'_sec=.
}

local contact_date starttime_date starttime_hour endtime_date endtime_hour
foreach var of local contact_date {
gen `var'_contact=.
}

drop dup3
duplicates tag id_number, gen(dup4)
save "$main\Data\output\followup2\intermediaire\endline_phone_almost", replace

*tab dup4 subcon
/*
           | Is it the student or
           |     his contact?
      dup4 |   Student    Contact |     Total
-----------+----------------------+----------
         0 |     4,841        102 |     4,943 
         1 |       214        230 |       444 
         2 |         5         10 |        15 
-----------+----------------------+----------
     Total |     5,060        342 |     5,402 
*/

sort id_number subcon
order id_number subcon

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   4.2 - 3 DUPLICATES (1 Student, 2 Contacts)
***_____________________________________________________________________________

clear
use "$main\Data\output\followup2\intermediaire\endline_phone_almost"
keep if dup4==2

gen z=0
*Salem 6 - student survey too
replace z=1 if key=="uuid:8c18565a-16fe-4c5b-89a0-5113b501e6f3"
replace z=2 if key=="uuid:1a70abdd-6603-441a-a512-894ba99c3d5b"
*Garaya 1 - student survey too
replace z=1 if key=="uuid:e4af3702-5a14-4e16-9b35-72a547051eed"
replace z=2 if key=="uuid:bef0bb65-58a4-44e2-b255-7c9b19249376"
*Cam-Syl 30 - student survey too
replace z=2 if key=="uuid:bf502f30-c27d-4ebc-af16-a9f981d29150"
replace z=1 if key=="uuid:feb9f590-cd42-42ad-8ce7-3416b67c42ab"
*E.I.C. Sonfonia - student survey too
replace z=2 if key=="uuid:d108f1b2-c37d-4ddd-a5e7-145ea96be13a"
replace z=1 if key=="uuid:e22213b3-5384-4e52-b791-5e44cf9d9d70"
order id_number lycee_name z key 
sort id_number lycee_name z key 

*Adding answers from the contact survey to the row/observation of the student survey
local contact_var check_con	consent_agree_contact sec2_q9_contact	gender	sec0_q0_contact	sec0_q0_contact_1	sec0_q0_contact_2	sec0_q0_contact_3	sec0_q0_contact_4	sec0_q0_contact_5	sec0_q1_contact	sec0_q4_contact	sec0_q4_contact_1	sec0_q4_contact_2	sec0_q4_contact_3	sec0_q4_contact_4	sec0_q4_contact_5	sec0_q4_contact_6	sec0_q4_a_contact	where_9_contact	where_11_contact	where_1_contact	where_2_a_contact	where_2_c_contact	where_2_b_contact	where_3_contact	where_8_contact	where_4_contact	where_5_contact	where_6_contact	where_7_contact	sec2_q13_contact	sec2_q14_contact	sec2_q15_contact	mig_1_contact	mig_2_contact	mig_3_contact	mig_4_contact	mig_6_contact	mig_6_contact_1	mig_6_contact_2	mig_6_contact_3	mig_6_contact_4	mig_6_contact_5	mig_6_contact_6	mig_6_contact_7	mig_7_contact	mig_9_contact	mig_10_contact	mig_11_contact	mig_12_contact	mig_14_contact	mig_15_contact	mig_16_contact	mig_17_contact	mig_18_contact	mig_18_contact_1	mig_18_contact_2	mig_18_contact_3	mig_18_contact_4	mig_18_contact_5	mig_18_contact_6	mig_18_contact_7	mig_19_contact	mig_20_contact	mig_21_contact	mig_22_contact	mig_22_a_contact	mig_23_contact	mig_24_contact	mig_25_contact	mig_26_contact	mig_27_contact	mig_28_contact	mig_29_contact	mig_30_contact	mig_31_contact	mig_32_contact	mig_33_contact	mig_34_contact	mig_35_contact	migrated_returned_contact	past_mig1_contact	past_mig2_contact	past_mig9_contact	past_mig9_contact_1	past_mig9_contact_2	past_mig9_contact_3	past_mig9_contact_4	past_mig9_contact_5	past_mig9_contact_6	past_mig9_contact_7	past_mig9_a_contact	past_mig10_contact	past_mig11_contact	past_mig3_contact	past_mig4_contact	past_mig5_contact	past_mig6_contact	past_mig7_contact	sec2_q1_contact	sec2_q2a_contact	sec2_q2_contact	sec2_q3_contact	sec2_q3_contact_1	sec2_q3_contact_2	sec2_q3_contact_3	sec2_q3_contact_4	sec2_q3_contact_5	sec2_q3_contact_6	sec2_q3_contact_7	sec2_q3_other_reasonmig_c	sec2_q4_contact	sec2_q5a_contact	sec2_q5_contact	sec2_q7_contact	sec2_q7_example_contact	sec2_q7_example_contact_1	sec2_q7_example_contact_2	sec2_q7_example_contact_3	sec2_q7_example_contact_4	sec2_q7_other_plan_contact	sec2_q8_contact	sec2_q10_a_contact	sec2_q10_b_contact	sec2_q10_c_contact	sec0_q6_fb_contact
foreach var of local contact_var {
replace `var'=`var'[_n+1] if z==0 & missing(`var')
}

*adding the time info of the first contact survey
local contact_date starttime_date starttime_hour endtime_date endtime_hour
foreach var of local contact_date {
replace `var'_contact=`var'[_n+1] if z==0 
}

*Adding answers from the second contact survey to the row of the student survey
*numeric var
local contact_var check_con	consent_agree_contact 	gender	sec0_q0_contact	sec0_q0_contact_1	sec0_q0_contact_2	sec0_q0_contact_3	sec0_q0_contact_4	sec0_q0_contact_5	sec0_q1_contact	sec0_q4_contact	sec0_q4_contact_1	sec0_q4_contact_2	sec0_q4_contact_3	sec0_q4_contact_4	sec0_q4_contact_5	sec0_q4_contact_6	where_9_contact	where_11_contact	where_1_contact	where_2_a_contact	where_2_c_contact	where_2_b_contact	where_3_contact	where_8_contact	where_4_contact	where_6_contact	where_7_contact	sec2_q13_contact	sec2_q14_contact	sec2_q15_contact	mig_3_contact	mig_4_contact	mig_6_contact	mig_6_contact_1	mig_6_contact_2	mig_6_contact_3	mig_6_contact_4	mig_6_contact_5	mig_6_contact_6	mig_6_contact_7	mig_9_contact	mig_10_contact	mig_11_contact	mig_12_contact	mig_16_contact	mig_17_contact	mig_18_contact_1	mig_18_contact_2	mig_18_contact_3	mig_18_contact_4	mig_18_contact_5	mig_18_contact_6	mig_18_contact_7	mig_20_contact	mig_21_contact	mig_22_contact	mig_22_a_contact	mig_23_contact	mig_24_contact	mig_25_contact	mig_27_contact	mig_28_contact	mig_29_contact	mig_30_contact		mig_32_contact	mig_33_contact	mig_34_contact	mig_35_contact	migrated_returned_contact	past_mig9_contact	past_mig9_contact_1	past_mig9_contact_2	past_mig9_contact_3	past_mig9_contact_4	past_mig9_contact_5	past_mig9_contact_6	past_mig9_contact_7		past_mig10_contact	past_mig11_contact	past_mig3_contact	past_mig4_contact	past_mig5_contact	past_mig6_contact	past_mig7_contact	sec2_q1_contact	sec2_q3_contact_1	sec2_q3_contact_2	sec2_q3_contact_3	sec2_q3_contact_4	sec2_q3_contact_5	sec2_q3_contact_6	sec2_q3_contact_7	sec2_q4_contact	sec2_q7_contact	sec2_q7_example_contact	sec2_q7_example_contact_1	sec2_q7_example_contact_2	sec2_q7_example_contact_3	sec2_q7_example_contact_4 sec2_q8_contact	sec2_q10_a_contact	sec2_q10_b_contact	sec2_q10_c_contact	sec0_q6_fb_contact starttime_date starttime_hour endtime_date endtime_hour
foreach var of local contact_var {
destring `var'_sec, replace
replace `var'_sec=`var'[_n+2] if z==0 
}

*string var 
local contact_var_str sec0_q4_a_contact sec2_q9_contact mig_13_contact where_5_contact mig_1_contact mig_2_contact mig_7_contact mig_14_contact mig_15_contact mig_18_contact mig_19_contact mig_26_contact mig_31_contact past_mig1_contact past_mig2_contact past_mig9_a_contact  sec2_q2a_contact sec2_q2_contact sec2_q3_contact sec2_q3_other_reasonmig_c sec2_q5a_contact sec2_q5_contact sec2_q7_other_plan_contact
foreach var of local contact_var_str {
tostring `var'_sec, replace
replace `var'_sec = `var'[_n+2] if z==0 
}

drop if z==1 | z==2
drop z

save "$main\Data\output\followup2\intermediaire\student_filled_2contacts", replace

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   4.3 - ONLY 2 DUPLICATES
***_____________________________________________________________________________

clear
use "$main\Data\output\followup2\intermediaire\endline_phone_almost"
sort id_number subcon
order id_number subcon

keep if dup4!=0

****ONLY DUPLICATES WITH ONE STUDENT SURVEY AND ONE CONTACT SURVEY
duplicates tag id_number subcon, gen(dup6)
keep if dup6==0

*Adding answers from the contact surveys to the row/observation of the student survey
bysort id_number: gen z=_n
local contact_var check_con	consent_agree_contact	gender	sec0_q0_contact	sec0_q0_contact_1	sec0_q0_contact_2	sec0_q0_contact_3	sec0_q0_contact_4	sec0_q0_contact_5	sec0_q1_contact	sec0_q4_contact	sec0_q4_contact_1	sec0_q4_contact_2	sec0_q4_contact_3	sec0_q4_contact_4	sec0_q4_contact_5	sec0_q4_contact_6	sec0_q4_a_contact	where_9_contact	where_11_contact	where_1_contact	where_2_a_contact	where_2_c_contact	where_2_b_contact	where_3_contact	where_8_contact	where_4_contact	where_5_contact	where_6_contact	where_7_contact	where_10_contact sec2_q13_contact	sec2_q14_contact	sec2_q15_contact	mig_1_contact	mig_2_contact	mig_3_contact	mig_4_contact	mig_6_contact	mig_6_contact_1	mig_6_contact_2	mig_6_contact_3	mig_6_contact_4	mig_6_contact_5	mig_6_contact_6	mig_6_contact_7	mig_7_contact	mig_9_contact	mig_10_contact	mig_11_contact	mig_12_contact	mig_14_contact	mig_15_contact	mig_16_contact	mig_17_contact	mig_18_contact	mig_18_contact_1	mig_18_contact_2	mig_18_contact_3	mig_18_contact_4	mig_18_contact_5	mig_18_contact_6	mig_18_contact_7	mig_19_contact	mig_20_contact	mig_21_contact	mig_22_contact	mig_22_a_contact	mig_23_contact	mig_24_contact	mig_25_contact	mig_26_contact	mig_27_contact	mig_28_contact	mig_29_contact	mig_30_contact	mig_31_contact	mig_32_contact	mig_33_contact	mig_34_contact	mig_35_contact	migrated_returned_contact	past_mig1_contact	past_mig2_contact	past_mig9_contact	past_mig9_contact_1	past_mig9_contact_2	past_mig9_contact_3	past_mig9_contact_4	past_mig9_contact_5	past_mig9_contact_6	past_mig9_contact_7	past_mig9_a_contact	past_mig10_contact	past_mig11_contact	past_mig3_contact	past_mig4_contact	past_mig5_contact	past_mig6_contact	past_mig7_contact	sec2_q1_contact	sec2_q2a_contact	sec2_q2_contact	sec2_q3_contact	sec2_q3_contact_1	sec2_q3_contact_2	sec2_q3_contact_3	sec2_q3_contact_4	sec2_q3_contact_5	sec2_q3_contact_6	sec2_q3_contact_7	sec2_q3_other_reasonmig_c	sec2_q4_contact	sec2_q5a_contact	sec2_q5_contact	sec2_q7_contact	sec2_q7_example_contact	sec2_q7_example_contact_1	sec2_q7_example_contact_2	sec2_q7_example_contact_3	sec2_q7_example_contact_4	sec2_q7_other_plan_contact	sec2_q8_contact	sec2_q10_a_contact	sec2_q10_b_contact	sec2_q10_c_contact	sec0_q6_fb_contact
foreach var of local contact_var {
replace `var'=`var'[_n+1] if z==1 & missing(`var')
}

drop if subcon==2
save "$main\Data\output\followup2\intermediaire\student_filled_contact", replace

****ONLY DUPLICATES BOTH CONTACT SURVEYS
clear
use "$main\Data\output\followup2\intermediaire\endline_phone_almost"
keep if dup4==1
duplicates tag id_number subcon, gen(dup7)
keep if dup7!=0

gen z=0
order id_number lycee_name key z 

*see excel file "two_contact_surveys" for details

*Cam-Syl 23
replace z=2 if key=="uuid:53bc272b-10f8-47d7-96b3-a0f791ce0c4d"
replace z=1 if key=="uuid:b7304569-d5a7-4e49-914c-0efd563db848"
*Notre Mère 45
replace z=2 if key=="uuid:f94eed70-8db8-4939-833d-04b5ea06a4ee"
replace z=1 if key=="uuid:7692eeae-22c9-4d42-93ee-ae63cddd65ba"
*Notre Mère 49
replace z=2 if key=="uuid:a0e6c86d-7233-45ae-9d7d-c702fa213f1c"
replace z=1 if key=="uuid:48b00fcd-7a7e-4110-bca3-e835489f8a50"
*Salem 25
replace z=2 if key=="uuid:1391a680-1ba8-4d2c-83f2-a56d92e61838"
replace z=1 if key=="uuid:18da5a0e-99a9-47ae-92d2-62308dfb967d"
*Noumandian keita
replace z=2 if key=="uuid:6089676d-5211-4d0c-b0d1-f44f77cf669f"
replace z=1 if key=="uuid:e3ca9953-377a-41f3-8f35-299819ab515b"
*El Hadj Alpha Oumar 31
replace z=2 if key=="uuid:14f4bde6-1435-4c6e-b566-16e15371e0bc"
replace z=1 if key=="uuid:eb4350ce-8bd8-42e3-8604-9c84178d4a73"
*El Hadj Alpha Oumar 54
replace z=2 if key=="uuid:257e0025-8501-4a8b-96fb-f7985422cee8"
replace z=1 if key=="uuid:25c68f18-ac45-4dba-9358-4ad3fe56994b"
*Abdoul Mazid Diaby
replace z=2 if key=="uuid:5970f2e5-ed7f-4d97-9a2b-0f92a2954462"
replace z=1 if key=="uuid:1b8be671-3b49-439f-b529-0e617f6dedde"


*numeric var
local contact_var check_con	consent_agree_contact	gender	sec0_q0_contact	sec0_q0_contact_1	sec0_q0_contact_2	sec0_q0_contact_3	sec0_q0_contact_4	sec0_q0_contact_5	sec0_q1_contact	sec0_q4_contact	sec0_q4_contact_1	sec0_q4_contact_2	sec0_q4_contact_3	sec0_q4_contact_4	sec0_q4_contact_5	sec0_q4_contact_6	where_9_contact where_11_contact	where_1_contact	where_2_a_contact	where_2_c_contact	where_2_b_contact	where_3_contact	where_8_contact	where_4_contact	where_6_contact	where_7_contact	sec2_q13_contact	sec2_q14_contact	sec2_q15_contact	mig_3_contact	mig_4_contact	mig_6_contact	mig_6_contact_1	mig_6_contact_2	mig_6_contact_3	mig_6_contact_4	mig_6_contact_5	mig_6_contact_6	mig_6_contact_7	mig_9_contact	mig_10_contact	mig_11_contact	mig_12_contact	mig_16_contact	mig_17_contact	mig_18_contact_1	mig_18_contact_2	mig_18_contact_3	mig_18_contact_4	mig_18_contact_5	mig_18_contact_6	mig_18_contact_7	mig_20_contact	mig_21_contact	mig_22_contact	mig_22_a_contact	mig_23_contact	mig_24_contact	mig_25_contact	mig_27_contact	mig_28_contact	mig_29_contact	mig_30_contact		mig_32_contact	mig_33_contact	mig_34_contact	mig_35_contact	migrated_returned_contact	past_mig9_contact	past_mig9_contact_1	past_mig9_contact_2	past_mig9_contact_3	past_mig9_contact_4	past_mig9_contact_5	past_mig9_contact_6	past_mig9_contact_7		past_mig10_contact	past_mig11_contact	past_mig3_contact	past_mig4_contact	past_mig5_contact	past_mig6_contact	past_mig7_contact	sec2_q1_contact	sec2_q3_contact_1	sec2_q3_contact_2	sec2_q3_contact_3	sec2_q3_contact_4	sec2_q3_contact_5	sec2_q3_contact_6	sec2_q3_contact_7	sec2_q4_contact	sec2_q7_contact	sec2_q7_example_contact	sec2_q7_example_contact_1	sec2_q7_example_contact_2	sec2_q7_example_contact_3	sec2_q7_example_contact_4 sec2_q8_contact	sec2_q10_a_contact	sec2_q10_b_contact	sec2_q10_c_contact	sec0_q6_fb_contact
foreach var of local contact_var {
destring `var'_sec, replace
replace `var'_sec=`var'[_n+1] if z==1 
}

*string var 
local contact_var_str sec0_q4_a_contact where_10_contact where_5_contact mig_1_contact mig_2_contact mig_7_contact mig_14_contact mig_15_contact mig_18_contact mig_19_contact mig_26_contact mig_31_contact past_mig1_contact past_mig2_contact past_mig9_a_contact  sec2_q2a_contact sec2_q2_contact sec2_q3_contact sec2_q3_other_reasonmig_c sec2_q5a_contact sec2_q5_contact sec2_q7_other_plan_contact
foreach var of local contact_var_str {
tostring `var'_sec, replace
replace `var'_sec = `var'[_n+1] if z==1 
}

drop if z==2
drop dup7
save "$main\Data\output\followup2\intermediaire\both_contacts", replace

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   4.4 - MERGING
***_____________________________________________________________________________

*2 contacts
clear
use "$main\Data\output\followup2\intermediaire\both_contacts"
merge 1:m id_number using "$main\Data\output\followup2\intermediaire\endline_phone_almost", force

drop dup4
duplicates tag id_number subcon, gen(dup4)
duplicates drop id_number subcon, force
drop dup4
drop _merge
save "$main\Data\output\followup2\intermediaire\endline_phone_almost1", replace

*1 student/1 contact
clear 
use "$main\Data\output\followup2\intermediaire\student_filled_contact"
merge 1:m id_number using "$main\Data\output\followup2\intermediaire\endline_phone_almost1", force
drop _merge
save "$main\Data\output\followup2\intermediaire\endline_phone_almost2", replace

*1 student/2 contacts
clear
use "$main\Data\output\followup2\intermediaire\student_filled_2contacts"
merge 1:m id_number using "$main\Data\output\followup2\intermediaire\endline_phone_almost2", force

duplicates tag id_number subcon, gen(dup3)
sort id_number
duplicates drop id_number subcon, force

drop dup4 dup6 dup3 z



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   5- LABELING VARIABLES FROM SECOND CONTACT SURVEY                             
***_____________________________________________________________________________


label variable check_con_sec "Do you know the student ?"
note check_con_sec : "This question allows to check if enumerator did a mistake in entering the ID of the student or if the phone number"
label values check_con_sec  yes_no

label variable consent_agree_contact_sec "Do you accept to participate in the survey ?"
note consent_agree_contact_sec : "Do you accept to participate in the survey ?"
label values consent_agree_contact_sec yes_no

label variable gender_sec "What is the gender of the contact?"
note gender_sec : "What is the gender of the contact? (filled in by enumerators)"
label values gender_sec  gender


///////////////////////////////////////////
//////////////  SECTION 0 /////////////////
///////////////////////////////////////////

label variable sec0_q0_contact_sec "How do you know the student?"
note sec0_q0_contact_sec : "This question allows to check if enumerator did a mistake en entering the student ID of the student"
label values sec0_q0_contact_sec relation

label variable sec0_q0_contact_1_sec "It is the father/mother of the student."
note sec0_q0_contact_1_sec : "It is the father/mother of the student."
label values sec0_q0_contact_1_sec yesno

label variable sec0_q0_contact_2_sec "It is the sister/brother of the student."
note sec0_q0_contact_2_sec : "It is the sister/brother of the student."
label values sec0_q0_contact_2_sec yesno

label variable sec0_q0_contact_3_sec "It is a friend of the student."
note sec0_q0_contact_3_sec : "It is a friend of the student."
label values sec0_q0_contact_3_sec yesno

label variable sec0_q0_contact_4_sec "It is a classmate of the student."
note sec0_q0_contact_4_sec : "It is a classmate of the student."
label values sec0_q0_contact_4_sec yesno

label variable sec0_q0_contact_5_sec "It is another family member of the student."
note sec0_q0_contact_5_sec : "It is another family member of the student."
label values sec0_q0_contact_5_sec yesno

label variable sec0_q1_contact_sec "When did you last communicate with {subject_name}?"
note sec0_q1_contact_sec : "When did you last communicate with {subject_name}?"
label values sec0_q1_contact_sec last_seen

label variable sec0_q4_contact_sec "How did you last communicate with {subject_name}?"
note sec0_q4_contact_sec : "How did you last communicate with {subject_name}?"
label values sec0_q4_contact_sec media

label variable sec0_q4_contact_1_sec "He last communicated with the student in person."
note sec0_q4_contact_1_sec : "He last communicated with the student in person."
label values sec0_q4_contact_1_sec yesno

label variable sec0_q4_contact_2_sec "He last communicated with the student by phone."
note sec0_q4_contact_2_sec : "He last communicated with the student by phone."
label values sec0_q4_contact_2_sec yesno

label variable sec0_q4_contact_3_sec "He last communicated with the student by Whatsapp."
note sec0_q4_contact_3_sec : "He last communicated with the student by whatsapp."
label values sec0_q4_contact_3_sec yesno

label variable sec0_q4_contact_4_sec "He last communicated with the student by Facebook."
note sec0_q4_contact_4_sec : "He last communicated with the student by Facebook."
label values sec0_q4_contact_4_sec yesno

label variable sec0_q4_contact_5_sec "He last communicated with the student by another social media."
note sec0_q4_contact_5_sec : "He last communicated with the student by another social media."
label values sec0_q4_contact_5_sec yesno

label variable sec0_q4_contact_6_sec "He last communicated with the student by another mean."
note sec0_q4_contact_6_sec : "He last communicated with the student by another mean."
label values sec0_q4_contact_6_sec yesno

label variable sec0_q4_a_contact_sec "Specify other media."
note sec0_q4_a_contact_sec : "Specify other media."


///////////////////////////////////////////
//////////////  SECTION WHERE /////////////
///////////////////////////////////////////

label variable  where_9_contact_sec "Does she you currently live in Conakry?"
note  where_9_contact_sec : "Does she you currently live in Conakry?"
label values where_9_contact_sec yes_no

label variable  where_10_contact_sec "When did she leave Conakry for the last time?"
note  where_10_contact_sec : "When did she leave Conakry for the last time?"

label variable  where_11_contact_sec "Does she currently live in Guinea?"
note  where_11_contact_sec : "Does she currently live in Guinea?"
label values where_11_contact_sec yes_no

label variable  where_1_contact_sec "Did she go to school in the past 30 days?"
note  where_1_contact_sec : "Did she go to school in the past 30 days?"
label values where_1_contact_sec yes_no

label variable  where_2_a_contact_sec "Did she graduate from high school last year?"
note  where_2_a_contact_sec : "Did she graduate from high school last year?"
label values where_2_a_contact_sec yes_no

label variable  where_2_b_contact_sec "Does she plan on going back to high school before the end of the school year?"
note  where_2_b_contact_sec : "Does she plan on going back to high school before the end of the school year?"
label values where_2_b_contact_sec yes_no

label variable  where_2_c_contact_sec "Does she study at university?"
note  where_2_c_contact_sec : "Does she study at university?"
label values where_2_b_contact_sec yes_no

label variable  where_3_contact_sec "Did she pass last year?"
note  where_3_contact_sec : "Did she pass last year?"
label values where_3_contact_sec yes_no

label variable  where_4_contact_sec "Did she go to {lycee_name}?"
note  where_4_contact_sec : "Did she go to {lycee_name}?"
label values where_4_contact_sec yes_no

label variable  where_5_contact_sec "Which high school did she go to?"
note  where_5_contact_sec : "Which high school did she go to?"

label variable  where_6_contact_sec "In which class is she this year?"
note  where_6_contact_sec : "In which class is she this year?"
label values where_6_contact_sec classe

label variable  where_7_contact_sec "During the past month, did you have a paid job outside of school?"
note  where_7_contact_sec : "During the past month, did you have a paid job outside of school?"
label values where_7_contact_sec yes_no

label variable  where_8_contact_sec "During the past month, did she have a paid job?"
note  where_8_contact_sec : "During the past month, did she have a paid job?"
label values where_8_contact_sec yes_no


///////////////////////////////////////////
//////////////  SECTION 2 /////////////////
///////////////////////////////////////////

label variable sec2_q13_contact_sec  "Did any of her siblings or friend leave Guinea over the last six months?"
note sec2_q13_contact_sec : "Did any of her siblings or friend leave Guinea over the last six months?"
label values sec2_q13_contact_sec  yes_no

label variable sec2_q14_contact_sec  "How many of her classmates from last year left Guinea over the last 6 months?"
note sec2_q14_contact_sec : "How many of her classmates from last year left Guinea over the last 6 months?"

label variable sec2_q15_contact_sec "Did at least one of her classmates from last year leave Guinea during the last 6 months?"
note sec2_q15_contact_sec : "Did at least one of her classmates from last year leave Guinea during the last 6 months?"
label values sec2_q15_contact_sec  yes_no


///////////////////////////////////////////
//////////////  OUTSIDE GUINEA ////////////
///////////////////////////////////////////

label variable mig_1_contact_sec "Which continent is she in right now?"
note mig_1_contact_sec : "Which continent is she in right now?"

label variable mig_2_contact_sec "Which country is she in right now?"
note mig_2_contact_sec : "Which country is she in right now?"

label variable mig_3_contact_sec "Is she in Africa right now?"
note mig_3_contact_sec : "Is she in Africa right now?"
label values mig_3_contact_sec yesno

label variable mig_4_contact_sec "Is she in Europe right now?"
note mig_4_contact_sec : "Is she in Europe right now?"
label values mig_4_contact_sec yesno

*label variable mig_5_contact "When did you leave Guinea for the last time?"
*note mig_5_contact : "When did you leave Guinea for the last time?"

label variable mig_6_contact_sec "What means of transportations did she use?"
note mig_6_contact_sec : "What means of transportations did she use?"
label values mig_6_contact_sec transport

label variable mig_6_contact_1_sec "She went by plane."
note mig_6_contact_1_sec : "She went by plane."
label values mig_6_contact_1_sec yesno

label variable mig_6_contact_2_sec "She went by car."
note mig_6_contact_2_sec : "She went by car."
label values mig_6_contact_2_sec yesno

label variable mig_6_contact_3_sec "She went by bus."
note mig_6_contact_3_sec : "She went by bus."
label values mig_6_contact_3_sec yesno

label variable mig_6_contact_4_sec "She went by train."
note mig_6_contact_4_sec : "She went by train."
label values mig_6_contact_4_sec yesno

label variable mig_6_contact_5_sec "She went by boat."
note mig_6_contact_5_sec : "She went by boat."
label values mig_6_contact_5_sec yesno

label variable mig_6_contact_6_sec "She went by foot."
note mig_6_contact_6_sec : "She went by foot."
label values mig_6_contact_6_sec yesno

label variable mig_6_contact_7_sec "She went by another mean of transport."
note mig_6_contact_7_sec : "She went by another mean of transport."
label values mig_6_contact_7_sec yesno

label variable mig_7_contact_sec "Specify other means of transport."
note mig_7_contact_sec : "Specify other means of transport."

*Country
label variable mig_9_contact_sec "How much money did she spend until now converted in Guinean Francs for the journey?"
note mig_9_contact_sec : "How much money did she spend until now converted in Guinean Francs for the journey?"

label variable mig_10_contact_sec "How many people did she travel with?"
note mig_10_contact_sec : "How many people did she travel with?"

label variable mig_11_contact_sec "Is she planning on moving to another country in the 12 months to come?"
note mig_11_contact_sec : "Is she planning on moving to another country in the 12 months to come?"
label values mig_11_contact_sec  yes_no

label variable mig_12_contact_sec "Did she plan a date to migrate? "
note mig_12_contact_sec : "Did she plan a date to migrate? "
label values mig_12_contact_sec  yes_no

label variable mig_13_contact_sec "Which month/year does she plan to leave {mig_2} ?"
note mig_13_contact_sec : "Which month/year does she plan to leave {mig_2} ?"

label variable mig_14_contact_sec "In which continent does she want to arrive? "
note mig_14_contact_sec : "In which continent does she want to arrive? "

label variable mig_15_contact_sec "In which country does she want to arrive? "
note mig_15_contact_sec : "In which country does she want to arrive? "

label variable mig_16_contact_sec "Is the country in Africa?"
note mig_16_contact_sec : "Is the country in Africa?"
label values mig_16_contact_sec yesno

label variable mig_17_contact_sec "Is the country in Europe?"
note mig_17_contact_sec : "Is the country in Europe?"
label values mig_17_contact_sec yesno

label variable mig_18_contact_sec "Why would she like to move permanently to another country? "
note mig_18_contact_sec : "Why would she like to move permanently to another country? "

label variable mig_18_contact_1_sec "She wants to migrate to continue her studies?"
note mig_18_contact_1_sec : "She wants to migrate to continue her studies? (dummy created with mig_reason)"
label values mig_18_contact_1_sec yes_no_bis

label variable mig_18_contact_2_sec "She wants to migrate for economic reasons?"
note mig_18_contact_2_sec : "She wants to migrate for economic reasons? (dummy created with mig_reason)"
label values mig_18_contact_2_sec yes_no_bis

label variable mig_18_contact_3_sec "She wants to migrate for family reasons ? (to join a relative abroad etc.)"
note mig_18_contact_3_sec: "She wants to migrate for family reasons ? (dummy created with mig_reason)"
label values mig_18_contact_3_sec yes_no_bis

label variable mig_18_contact_4_sec "She wants to migrate because your area is affected by war/conflict?"
note mig_18_contact_4_sec: "She wants to migrate because your area is affected by war/conflict? (dummy created with mig_reason)"
label values mig_18_contact_4_sec yes_no_bis

label variable mig_18_contact_5_sec "She wants to migrate because you are or could be the victim of violence or persecution?"
note mig_18_contact_5_sec : "She wants to migrate because you are or could be the victim of violence or persecution? (dummy created with mig_reason)"
label values mig_18_contact_5_sec yes_no_bis

label variable mig_18_contact_6_sec "She wants to migrate because your region has been affected by extreme climatic events? "
note mig_18_contact_6_sec :"She wants to migrate because your region has been affected by extreme climatic events? (dummy created with mig_reason)"
label values mig_18_contact_6_sec yes_no_bis

label variable mig_18_contact_7_sec "Does she want to migrate for other reasons ?"
note mig_18_contact_7_sec :"Does she want to migrate for other reasons ? (dummy created with mig_reason)"
label values mig_18_contact_7_sec yes_no_bis

label variable mig_19_contact_sec "Could you specify the other reason why she wants to migrate to another country ?"
note mig_19_contact_sec : "Could you specify the other reason why she wants to migrate to another country ?"

label variable mig_20_contact_sec "Did she already apply to get a visa to enter in {mig_15} during the next 12 months?"
note mig_20_contact_sec : "Did she already apply to get a visa to enter in {mig_15} during the next 12 months?"
label values mig_20_contact_sec  yes_no

label variable mig_21_contact_sec "Do you believe that she will apply for a visa in order to migrate to {mig_15}?"
note mig_21_contact_sec : "Do you believe that she will apply for a visa in order to migrate to {mig_15}?"
label values mig_21_contact_sec  yes_no

label variable mig_22_contact_sec "Did you already apply to get a visa to enter in {mig_2} during the next 12 months?"
note mig_22_contact_sec : "Did you already apply to get a visa to enter in {mig_2} during the next 12 months?"
label values mig_22_contact_sec  yes_no

label variable mig_22_a_contact_sec "Did she receive a visa to enter in {mig_2}?"
note mig_22_a_contact_sec : "Did she receive a visa to enter in {mig_2}?"
label values mig_22_a_contact_sec  yes_no

///////////////////////////////////////////
//////////  DESTINATION EUROPE ////////////
///////////////////////////////////////////


label variable mig_23_contact_sec "Does she plan to cross by boat from Lybia?"
note mig_23_contact_sec : "Does she plan to cross by boat from Lybia?"
label values mig_23_contact_sec  yes_no

label variable mig_24_contact_sec "Does she plan to cross by boat from Morocco or Algeria?"
note mig_24_contact_sec : "Does she plan to cross by boat from Morocco or Algeria?"
label values mig_24_contact_sec  yes_no

label variable mig_25_contact_sec "Does she plan to cross the “grillage” in Ceuta or Melilla?"
note mig_25_contact_sec : "Does she plan to cross the “grillage” in Ceuta or Melilla?"
label values mig_25_contact_sec  yes_no

label variable mig_26_contact_sec "How does she plan to go?"
note mig_26_contact_sec : "How does she plan to go?"

label variable mig_27_contact_sec "How much money does he think he will spend converted in Guinean Francs for his journey to {mig_15_contact}?"
note mig_27_contact_sec : "How much money does he think he will spend converted in Guinean Francs for his journey to {mig_15_contact}?"

label variable mig_28_contact_sec "Did she cross the Mediterranean sea by boat from Libya?"
note mig_28_contact_sec : "Did she cross the Mediterranean sea by boat from Libya?"
label values mig_28_contact_sec  yes_no

label variable mig_29_contact_sec "Did she cross the Mediterranean by boat from Morocco or Algeria?"
note mig_29_contact_sec : "Did she cross the Mediterranean by boat from Morocco or Algeria?"
label values mig_29_contact_sec  yes_no

label variable mig_30_contact_sec "Did she cross the “grillage” in Ceuta or Melilla?"
note mig_30_contact_sec : "Did she cross the “grillage” in Ceuta or Melilla?"
label values mig_30_contact_sec  yes_no

label variable mig_31_contact_sec "How did she get to {mig_2_contact} ?"
note mig_31_contact_sec : "How did she get to {mig_2_contact} ?"


*ILEGAL MIGRATION

label variable mig_32_contact_sec "Was she forced to work during her journey?"
note mig_32_contact_sec : "Was she forced to work during her journey?"
label values mig_32_contact_sec  yes_no

label variable mig_33_contact_sec "Was she held against her will during your journey?"
note mig_33_contact_sec : "Was she held against her will during your journey?"
label values mig_33_contact_sec  yes_no

label variable mig_34_contact_sec "Did she witnessed anyone suffering violence during her journey?"
note mig_34_contact_sec : "Did she witnessed anyone suffering violence during her journey?"
label values mig_34_contact_sec  yes_no

label variable mig_35_contact_sec "Did she suffer episodes of violence during her journey?"
note mig_35_contact_sec : "Did she suffer episodes of violence during her journey?"
label values mig_35_contact_sec  yes_no


///////////////////////////////////////////
//////////////  PAST MIGRATION ////////////
///////////////////////////////////////////

label variable migrated_returned_contact_sec "During the last year, did she leave Guinea for more than 3 months?"
note migrated_returned_contact_sec : "During the last year, did she leave Guinea for more than 3 months?"
label values migrated_returned_contact_sec  yes_no

label variable past_mig1_contact_sec "During this time outside of Guinea, in which continent did she stay for the longest period?"
note past_mig1_contact_sec : "During this time outside of Guinea, in which continent did she stay for the longest period?"

label variable past_mig2_contact_sec "During this time outside of Guinea, in which country did she stay for the longest period?"
note past_mig2_contact_sec : "During this time outside of Guinea, in which country did she stay for the longest period?"

label variable past_mig9_contact_sec "What means of transportations did she use to get to {past_mig2_contact}?"
note past_mig9_contact_sec : "What means of transportations did she use to get to {past_mig2_contact}?"
label values past_mig9_contact_sec transport

label variable past_mig9_contact_1_sec "She went by plane."
note past_mig9_contact_1_sec : "She went by plane."
label values past_mig9_contact_1_sec yesno

label variable past_mig9_contact_2_sec "She went by car."
note past_mig9_contact_2_sec : "She went by car."
label values past_mig9_contact_2_sec yesno

label variable past_mig9_contact_3_sec "She went by bus."
note past_mig9_contact_3_sec : "She went by bus."
label values past_mig9_contact_3_sec yesno

label variable past_mig9_contact_4_sec "She went by train."
note past_mig9_contact_4_sec : "She went by train."
label values past_mig9_contact_4_sec yesno

label variable past_mig9_contact_5_sec "She went by boat."
note past_mig9_contact_5_sec : "She went by boat."
label values past_mig9_contact_5_sec yesno

label variable past_mig9_contact_6_sec "She went by foot."
note past_mig9_contact_6_sec : "She went by foot."
label values past_mig9_contact_6_sec yesno

label variable past_mig9_contact_7_sec "She went by another mean of transport."
note past_mig9_contact_7_sec : "She went by another mean of transport."
label values past_mig9_contact_7_sec yesno

label variable past_mig9_a_contact_sec "Specify the other means of transportation she used."
note past_mig9_a_contact_sec : "Specify the other means of transportation she used."

label variable past_mig10_contact_sec "How much money did she spend, converted in Guinean Francs, for the journey to {past_mig2_contact}?"
note past_mig10_contact_sec : "How much money did she spend, converted in Guinean Francs, for the journey to {past_mig2_contact}?"

label variable past_mig11_contact_sec "How many people did she travel with to get to  {mig_2_contact}?"
note past_mig11_contact_sec : "How many people did she travelled with until  {mig_2_contact}?"

label variable past_mig3_contact_sec "Was she forced to work during her journey?"
note past_mig3_contact_sec : "Was she forced to work during her journey?"
label values past_mig3_contact_sec  yes_no

label variable past_mig4_contact_sec "Was she held against her will during her journey?"
note past_mig4_contact_sec : "Was she held against her will during her journey?"
label values past_mig4_contact_sec  yes_no

label variable past_mig5_contact_sec "Did she witness anyone suffering violence during her journey?"
note past_mig5_contact_sec : "Did she witness anyone suffering violence during her journey?"
label values past_mig5_contact_sec  yes_no

label variable past_mig6_contact_sec "Did she suffer episodes of violence during her journey?"
note past_mig6_contact_sec : "Did she suffer episodes of violence during her journey?"
label values past_mig6_contact_sec  yes_no

label variable past_mig7_contact_sec "When she left Guinea, did she plan to stay outside Guinea for a longer period?"
note past_mig7_contact_sec : "When she left Guinea, did she plan to stay outside Guinea for a longer period?"
label values past_mig7_contact_sec  yes_no


///////////////////////////////////////////
//////////////  MIGRATION INTENTION ///////
///////////////////////////////////////////

label variable sec2_q1_contact_sec "Do you think that, ideally, if she had the opportunity, she would like to move permanently to another country or to continue living in Guinea?"
note sec2_q1_contact_sec : "Do you think that, ideally, if she had the opportunity, she would like to move permanently to another country or to continue living in Guinea?"
label values sec2_q1_contact_sec mig_desire_contact

label variable sec2_q2a_contact_sec "If she could go anywhere in the world, which continent would she like to live in? "
note sec2_q2a_contact_sec : "If she could go anywhere in the world, which continent would she like to live in? "

label variable sec2_q2_contact_sec "If she could go anywhere in the world, which country would she like to live in? "
note sec2_q2_contact_sec : "If she could go anywhere in the world, which country would she like to live in? "

label variable sec2_q3_contact_sec "Why would she like to move permanently to another country? "
note sec2_q3_contact_sec : "Why would she like to move permanently to another country? "

label variable sec2_q3_contact_1_sec "She wants to migrate to continue her studies?"
note sec2_q3_contact_1_sec : "She wants to migrate to continue her studies? (dummy created with mig_reason)"
label values sec2_q3_contact_1_sec yes_no_bis

label variable sec2_q3_contact_2_sec "She wants to migrate for economic reasons?"
note sec2_q3_contact_2_sec : "She wants to migrate for economic reasons? (dummy created with mig_reason)"
label values sec2_q3_contact_2_sec yes_no_bis

label variable sec2_q3_contact_3_sec "She wants to migrate for family reasons ? (to join a relative abroad etc.)"
note sec2_q3_contact_3_sec : "She wants to migrate for family reasons ? (dummy created with mig_reason)"
label values sec2_q3_contact_3_sec yes_no_bis

label variable sec2_q3_contact_4_sec "She wants to migrate because her area is affected by war/conflict?"
note sec2_q3_contact_4_sec : "She wants to migrate because her area is affected by war/conflict? (dummy created with mig_reason)"
label values sec2_q3_contact_4_sec yes_no_bis

label variable sec2_q3_contact_5_sec "She wants to migrate because she is or could be the victim of violence or persecution?"
note sec2_q3_contact_5_sec : "She wants to migrate because she is or could be the victim of violence or persecution? (dummy created with mig_reason)"
label values sec2_q3_contact_5_sec yes_no_bis

label variable sec2_q3_contact_6_sec "She wants to migrate because her region has been affected by extreme climatic events? "
note sec2_q3_contact_6_sec :"She wants to migrate because her region has been affected by extreme climatic events? (dummy created with mig_reason)"
label values sec2_q3_contact_6_sec yes_no_bis

label variable sec2_q3_contact_7_sec "Does she want to migrate for other reasons ?"
note sec2_q3_contact_7_sec :"Does she want to migrate for other reasons ? (dummy created with mig_reason)"
label values sec2_q3_contact_7_sec yes_no_bis

label variable sec2_q3_other_reasonmig_c_sec "Could you specify the other reason why she wants to migrate to another country ?"
note sec2_q3_other_reasonmig_c_sec : "Could you specify the other reason why she wants to migrate to another country ?"


label variable sec2_q4_contact_sec "Is she planning to move permanently to another country in the next 12 months, or not?"
note sec2_q4_contact_sec : "Is she planning to move permanently to another country in the next 12 months, or not?"
label values sec2_q4_contact_sec yes_no

label variable sec2_q5a_contact_sec "Which continent is she planning to move to?"
note sec2_q5a_contact_sec : "Which continent is she planning to move to?"

label variable sec2_q5_contact_sec "Which country is she planning to move to?"
note sec2_q5_contact_sec : "Which country is she planning to move to?"

label variable sec2_q7_contact_sec  "Did she make any preparations for this move?"
note sec2_q7_contact_sec  : "Did she make any preparations for this move?"
label values sec2_q7_contact_sec  yes_no

label variable sec2_q7_example_contact_sec  "Which types of preparations did she make for this move?"
note sec2_q7_example_contact_sec  : "Which types of preparations did she mae for this move?"

label variable sec2_q7_example_contact_1_sec "She is saving money to prepare her trip" 
note sec2_q7_example_contact_1_sec : "She is saving money to prepare her trip" 
label values sec2_q7_example_contact_1_sec yes_no_bis

label variable sec2_q7_example_contact_2_sec "She has contacted someone she knows who is living in the country where she wants to go." 
note sec2_q7_example_contact_2_sec : "She has contacted someone she knows who is living in the country where she wants to go." 
label values sec2_q7_example_contact_2_sec yes_no_bis

label variable sec2_q7_example_contact_3_sec "She made some of her relatives aware of her desire to migrate."
note sec2_q7_example_contact_3_sec : "She made some of her relatives aware of her desire to migrate."
label values sec2_q7_example_contact_3_sec yes_no_bis

label variable sec2_q7_example_contact_4_sec "She made other types of preparation."
note sec2_q7_example_contact_4_sec : "She made other types of preparation."
label values sec2_q7_example_contact_4_sec yes_no_bis

label variable sec2_q7_other_plan_contact_sec "Could you specify the other types of preparations she has made for this move?"
note sec2_q7_other_plan_contact_sec : "Could you specify the other types of preparations she has made for this move?"

label variable sec2_q8_contact_sec "Did she plan a date to migrate?"
note sec2_q8_contact_sec :  "Did she plan a date to migrate?"
label values sec2_q8_contact_sec yes_no

label variable sec2_q9_contact_sec "When does she plan to leave Guinea?"
note sec2_q9_contact_sec :  "When does she plan to leave Guinea?"

label variable  sec2_q10_a_contact_sec "Did she already apply to get a visa to enter in [sec2_q5_contact] during the next 12 months?"
note sec2_q10_a_contact_sec : "Did she already applied to get a visa to enter in this country [sec2_q5_contact] during the next 12 months?"

label variable  sec2_q10_b_contact_sec "Does she believe that she will apply for a visa to migrate to [sec2_q2_contact]?"
note sec2_q10_b_contact_sec: "For people who do not want to migrate in the next 12 months : Does she believe that she will apply for a visa in order to migrate to this country?"

label variable sec2_q10_c_contact_sec "Does she believe that she will apply for a visa to migrate to [sec2_q2_contact]?"
note sec2_q10_c_contact_sec : "For people who want to migrate in the next 12 months : Does she believe that she will apply for a visa in order to migrate to this country?"


label variable  sec0_q6_fb_contact_sec "Does she have a facebook account ?"
note  sec0_q6_fb_contact_sec : "Does she have a facebook account ?"
label values  sec0_q6_fb_contact_sec yes_no


///////////////////////////////////////////
//////////////     TIME   /////////////////
///////////////////////////////////////////

label variable starttime "Time the survey started on the tablet"
note starttime : "Time the survey started on the tablet"

label variable endtime "Time the survey ended on the tablet"
note endtime : "Time the survey ended on the tablet"

label variable starttime_date "Date the survey started on the tablet"
note starttime_date : "Date the survey started on the tablet"

label variable starttime_hour "Time the survey started on the tablet"
note starttime_hour : "Time the survey started on the tablet"

label variable endtime_date "Date the survey ended on the tablet"
note endtime_date : "Date the survey ended on the tablet"

label variable endtime_hour "Time the survey ended on the tablet"
note endtime_hour : "Time the survey ended on the tablet"

*contact: starttime_date_contact
label variable starttime_date_contact "Date the survey started on the tablet"
note starttime_date_contact : "Date the survey started on the tablet"

label variable starttime_hour_contact "Time the survey started on the tablet"
note starttime_hour_contact : "Time the survey started on the tablet"

label variable endtime_date_contact "Date the survey ended on the tablet"
note endtime_date_contact : "Date the survey ended on the tablet"

label variable endtime_hour_contact "Time the survey ended on the tablet"
note endtime_hour_contact : "Time the survey ended on the tablet"

*contact second survey
label variable starttime_date_sec "Date the survey started on the tablet"
note starttime_date_sec : "Date the survey started on the tablet"

label variable starttime_hour_sec "Time the survey started on the tablet"
note starttime_hour_sec : "Time the survey started on the tablet"

label variable endtime_date_sec "Date the survey ended on the tablet"
note endtime_date_sec : "Date the survey ended on the tablet"

label variable endtime_hour_sec "Time the survey ended on the tablet"
note endtime_hour_sec : "Time the survey ended on the tablet"



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   6- CLEANING DATES                             
***_____________________________________________________________________________


foreach var in sec2_q9 where_10 where_10_contact  mig_13 mig_13_contact  {
split `var', p("-")
replace `var'2="01" if `var'2=="Jan"
replace `var'2="02" if `var'2=="Feb"
replace `var'2="03" if `var'2=="Mar"
replace `var'2="04" if `var'2=="Apr"
replace `var'2="05" if `var'2=="May"
replace `var'2="06" if `var'2=="Jun"
replace `var'2="07" if `var'2=="Jul"
replace `var'2="08" if `var'2=="Aug"
replace `var'2="09" if `var'2=="Sep"
replace `var'2="10" if `var'2=="Oct"
replace `var'2="11" if `var'2=="Nov"
replace `var'2="12" if `var'2=="Dec"

g migration_date_new=`var'2 +"-" + "-"+ `var'3 
gen migration_date=date(migration_date_new, "MY",2050)
format migration_date %td

rename `var'3 `var'_year
rename `var'2 `var'_month
drop migration_date_new `var'1 `var'
rename migration_date `var'
}

*sec2_q9
label variable sec2_q9 "In which month/year are you planning to leave Guinea?"
note sec2_q9 : "In which month/year are you planning to leave Guinea?"

label variable sec2_q9_year "In which year are you planning to leave Guinea?"
note sec2_q9_year : "In which year are you planning to leave Guinea?"

label variable sec2_q9_month "In which month are you planning to leave Guinea?"
note sec2_q9_month : "In which month are you planning to leave Guinea?"

*where_10
label variable where_10 "In which month/year did you leave Conakry for the last time?"
note where_10 : "In which month/year did you leave Conakry for the last time?"

label variable where_10_year "In which year did you leave Conakry for the last time?"
note where_10_year : "In which year did you leave Conakry for the last time??"

label variable where_10_month "In which month did you leave Conakry for the last time?"
note where_10_month : "In which month did you leave Conakry for the last time?"

*where_10_contact
label variable where_10_contact "In which month/year did she leave Conakry for the last time?"
note where_10_contact : "In which month/year did she leave Conakry for the last time?"

label variable where_10_contact_year "In which year did she leave Conakry for the last time?"
note where_10_contact_year : "In which year did she leave Conakry for the last time?"

label variable where_10_contact_month "In which month did she leave Conakry for the last time?"
note where_10_contact_month : "In which month did she leave Conakry for the last time?"

*mig_13
label variable mig_13 "In which month/year are you planning to leave {mig_2}?"
note mig_13 : "In which month/year are you planning to leave {mig_2}?"

label variable mig_13_year "In which year are you planning to leave {mig_2}?"
note mig_13_year : "In which year are you planning to leave {mig_2}?"

label variable mig_13_month "In which month are you planning to leave {mig_2}?"
note mig_13_month : "In which month are you planning to leave {mig_2}?"

*mig_13_contact
label variable mig_13_contact "In which month/year is she planning to leave {mig_2}?"
note mig_13_contact : "In which month/year is she planning to leave {mig_2}?"

label variable mig_13_contact_year "In which year is she planning to leave {mig_2}?"
note mig_13_contact_year : "In which year is she planning to leave {mig_2}?"

label variable mig_13_contact_month "In which month is she planning to leave {mig_2}?"
note mig_13_contact_month : "In which month is she planning to leave {mig_2}?"





***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   7- SAVING THE DATASET                             
***_____________________________________________________________________________

destring id_number, replace
drop  lycee_name2 deviceid simid subscriberid devicephonenum num_elv treatment consent_agree check_id _merge


*RENAMING VARIABLES SO THAT THEY ARE DIFFERENT THAN THE ONES FROM THE SCHOOL SURVEYS
local all_var key	submissiondate	rematch starttime	endtime	subcon	remember check_id2	where_9	where_11	where_1	where_2_a	where_2_c	where_2_b	where_3	where_8	where_4	where_5	where_6	where_7	sec2_q11	sec2_q13	sec2_q14	sec2_q15	outside_contact_no	mig_1	mig_2	mig_3	mig_4	mig_6	mig_6_1	mig_6_2	mig_6_3	mig_6_4	mig_6_5	mig_6_6	mig_6_7	mig_7	mig_9	mig_11	mig_12	mig_14	mig_15	mig_16	mig_17	mig_18	mig_18_1	mig_18_2	mig_18_3	mig_18_4	mig_18_5	mig_18_6	mig_18_7	mig_19	mig_20	mig_21	mig_22	mig_22_a	mig_23	mig_24	mig_25	mig_26	mig_27	mig_28	mig_29	mig_30	mig_31	mig_10	mig_32	mig_33	mig_34	mig_35	mig_36	migrated_returned	past_mig1	past_mig2	past_mig9	past_mig9_1	past_mig9_2	past_mig9_3	past_mig9_4	past_mig9_5	past_mig9_6	past_mig9_7	past_mig9_a	past_mig10	past_mig11	past_mig3	past_mig4	past_mig5	past_mig6	past_mig7	past_mig8	sec2_q1	sec2_q2_a	sec2_q2	sec2_q3	sec2_q3_1	sec2_q3_2	sec2_q3_3	sec2_q3_4	sec2_q3_5	sec2_q3_6	sec2_q3_7	sec2_q3_other_reasonmig	sec2_q4	sec2_q5a	sec2_q5	sec2_q7	sec2_q7_example	sec2_q7_example_1	sec2_q7_example_2	sec2_q7_example_3	sec2_q7_example_4	sec2_q7_other_plan	sec2_q8	sec2_q10_a	sec2_q10_b	sec2_q10_c	optimism	sec0_q6_fb	check_con	consent_agree_contact	gender	sec0_q0_contact	sec0_q0_contact_1	sec0_q0_contact_2	sec0_q0_contact_3	sec0_q0_contact_4	sec0_q0_contact_5	sec0_q1_contact	sec0_q4_contact	sec0_q4_contact_1	sec0_q4_contact_2	sec0_q4_contact_3	sec0_q4_contact_4	sec0_q4_contact_5	sec0_q4_contact_6	sec0_q4_a_contact	where_9_contact	where_11_contact	where_1_contact	where_2_a_contact	where_2_c_contact	where_2_b_contact	where_3_contact	where_8_contact	where_4_contact	where_5_contact	where_6_contact	where_7_contact	sec2_q13_contact	sec2_q14_contact	sec2_q15_contact	mig_1_contact	mig_2_contact	mig_3_contact	mig_4_contact	mig_6_contact	mig_6_contact_1	mig_6_contact_2	mig_6_contact_3	mig_6_contact_4	mig_6_contact_5	mig_6_contact_6	mig_6_contact_7	mig_7_contact	mig_9_contact	mig_10_contact	mig_11_contact	mig_12_contact	mig_14_contact	mig_15_contact	mig_16_contact	mig_17_contact	mig_18_contact	mig_18_contact_1	mig_18_contact_2	mig_18_contact_3	mig_18_contact_4	mig_18_contact_5	mig_18_contact_6	mig_18_contact_7	mig_19_contact	mig_20_contact	mig_21_contact	mig_22_contact	mig_22_a_contact	mig_23_contact	mig_24_contact	mig_25_contact	mig_26_contact	mig_27_contact	mig_28_contact	mig_29_contact	mig_30_contact	mig_31_contact	mig_32_contact	mig_33_contact	mig_34_contact	mig_35_contact	migrated_returned_contact	past_mig1_contact	past_mig2_contact	past_mig9_contact	past_mig9_contact_1	past_mig9_contact_2	past_mig9_contact_3	past_mig9_contact_4	past_mig9_contact_5	past_mig9_contact_6	past_mig9_contact_7	past_mig9_a_contact	past_mig10_contact	past_mig11_contact	past_mig3_contact	past_mig4_contact	past_mig5_contact	past_mig6_contact	past_mig7_contact	sec2_q1_contact	sec2_q2a_contact	sec2_q2_contact	sec2_q3_contact	sec2_q3_contact_1	sec2_q3_contact_2	sec2_q3_contact_3	sec2_q3_contact_4	sec2_q3_contact_5	sec2_q3_contact_6	sec2_q3_contact_7	sec2_q3_other_reasonmig_c	sec2_q4_contact	sec2_q5a_contact	sec2_q5_contact	sec2_q7_contact	sec2_q7_example_contact	sec2_q7_example_contact_1	sec2_q7_example_contact_2	sec2_q7_example_contact_3	sec2_q7_example_contact_4	sec2_q7_other_plan_contact	sec2_q8_contact	sec2_q10_a_contact	sec2_q10_b_contact	sec2_q10_c_contact	sec0_q6_fb_contact	instanceid	formdef_version	starttime_date	starttime_hour	submissiondate_date	submissiondate_hour	endtime_date	endtime_hour	sec2_q9_month	sec2_q9_year	sec2_q9		sec2_q9_contact	where_10_month	where_10_year	where_10	where_10_contact_month	where_10_contact_year	where_10_contact	mig_13_month	mig_13_year	mig_13	mig_13_contact_month	mig_13_contact_year	mig_13_contact	sec2_q3_other_reasonmig_c_sec	check_con_sec	consent_agree_contact_sec	gender_sec	sec0_q0_contact_sec	sec0_q0_contact_1_sec	sec0_q0_contact_2_sec	sec0_q0_contact_3_sec	sec0_q0_contact_4_sec	sec0_q0_contact_5_sec	sec0_q1_contact_sec	sec0_q4_contact_sec	sec0_q4_contact_1_sec	sec0_q4_contact_2_sec	sec0_q4_contact_3_sec	sec0_q4_contact_4_sec	sec0_q4_contact_5_sec	sec0_q4_contact_6_sec	sec0_q4_a_contact_sec	where_9_contact_sec	where_11_contact_sec	where_1_contact_sec	where_2_a_contact_sec	where_2_c_contact_sec	where_2_b_contact_sec	where_3_contact_sec	where_8_contact_sec	where_4_contact_sec	where_5_contact_sec	where_6_contact_sec	where_7_contact_sec	sec2_q13_contact_sec	sec2_q14_contact_sec	sec2_q15_contact_sec	mig_1_contact_sec	mig_2_contact_sec	mig_3_contact_sec	mig_4_contact_sec	mig_6_contact_sec	mig_6_contact_1_sec	mig_6_contact_2_sec	mig_6_contact_3_sec	mig_6_contact_4_sec	mig_6_contact_5_sec	mig_6_contact_6_sec	mig_6_contact_7_sec	mig_7_contact_sec	mig_9_contact_sec	mig_10_contact_sec	mig_11_contact_sec	mig_12_contact_sec	mig_14_contact_sec	mig_15_contact_sec	mig_16_contact_sec	mig_17_contact_sec	mig_18_contact_sec	mig_18_contact_1_sec	mig_18_contact_2_sec	mig_18_contact_3_sec	mig_18_contact_4_sec	mig_18_contact_5_sec	mig_18_contact_6_sec	mig_18_contact_7_sec	mig_19_contact_sec	mig_20_contact_sec	mig_21_contact_sec	mig_22_contact_sec	mig_22_a_contact_sec	mig_23_contact_sec	mig_24_contact_sec	mig_25_contact_sec	mig_26_contact_sec	mig_27_contact_sec	mig_28_contact_sec	mig_29_contact_sec	mig_30_contact_sec	mig_31_contact_sec	mig_32_contact_sec	mig_33_contact_sec	mig_34_contact_sec	mig_35_contact_sec	migrated_returned_contact_sec	past_mig1_contact_sec	past_mig2_contact_sec	past_mig9_contact_sec	past_mig9_contact_1_sec	past_mig9_contact_2_sec	past_mig9_contact_3_sec	past_mig9_contact_4_sec	past_mig9_contact_5_sec	past_mig9_contact_6_sec	past_mig9_contact_7_sec	past_mig9_a_contact_sec	past_mig10_contact_sec	past_mig11_contact_sec	past_mig3_contact_sec	past_mig4_contact_sec	past_mig5_contact_sec	past_mig6_contact_sec	past_mig7_contact_sec	sec2_q1_contact_sec	sec2_q2a_contact_sec	sec2_q2_contact_sec	sec2_q3_contact_sec	sec2_q3_contact_1_sec	sec2_q3_contact_2_sec	sec2_q3_contact_3_sec	sec2_q3_contact_4_sec	sec2_q3_contact_5_sec	sec2_q3_contact_6_sec	sec2_q3_contact_7_sec	sec2_q4_contact_sec	sec2_q5a_contact_sec	sec2_q5_contact_sec	sec2_q7_contact_sec	sec2_q7_example_contact_sec	sec2_q7_example_contact_1_sec	sec2_q7_example_contact_2_sec	sec2_q7_example_contact_3_sec	sec2_q7_example_contact_4_sec	sec2_q7_other_plan_contact_sec	sec2_q8_contact_sec	sec2_q10_a_contact_sec	sec2_q10_b_contact_sec	sec2_q10_c_contact_sec	sec0_q6_fb_contact_sec	starttime_date_sec	starttime_hour_sec	endtime_date_sec	endtime_hour_sec	starttime_date_contact	starttime_hour_contact	endtime_date_contact	endtime_hour_contact
foreach var of local all_var {
rename `var' `var'_p
}

save "$main/Data/output/followup2/questionnaire_endline_phone_clean.dta", replace

erase "$main\Data\output\followup2\intermediaire\endline_phone_almost1.dta"
erase "$main\Data\output\followup2\intermediaire\endline_phone_almost2.dta"
erase "$main\Data\output\followup2\intermediaire\student_filled_contact.dta"
erase "$main\Data\output\followup2\intermediaire\student_filled_2contacts.dta"
erase "$main\Data\output\followup2\intermediaire\both_contacts.dta"
