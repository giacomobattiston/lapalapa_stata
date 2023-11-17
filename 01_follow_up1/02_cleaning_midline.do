/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :    02 - CLEANING MIDLINE DATA
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*cleaning_midline.do
Date Created:  May 14, 2018
Date Last Modified: May 22 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: .dta file(s) "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\output\midline\guinea_questionnaire_imported_midline.dta"
*	Outputs: "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\output\midline\guinea_questionnaire_imported_cleaned.dta"
*
*Outline :
- 0 - Parameters
- 1 - Reading the data
- 2 - Labeling
- 3 - cleaning
- 4 - saving 
*/ 


* initialize Stata
*clear all
set more off
set mem 100m


*Cloe user
*global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

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
local proba "sec3_32 sec3_35 sec3_36 sec3_37 sec3_39 sec3_40 sec3_41 italy_beaten italy_forced_work italy_kidnapped italy_die_bef_boat italy_die_boat italy_sent_back spain_beaten spain_forced_work spain_kidnapped spain_die_bef_boat spain_die_boat spain_sent_back"
local money_quest "sec3_42 sec3_34 sec3_34_bis italy_journey_cost spain_journey_cost sec3_42"


	
***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***  1- READING THE DATA
***_____________________________________________________________________________
use "$main/Data/output/midline/questionnaire_midline_imported.dta", clear

drop time* unique_draws upper_bound num_draws random* setofrandom_draws

drop if consent==2

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*** 2- LABELING THE VARIABLES                
***_____________________________________________________________________________

label variable key "Unique submission ID"
cap label variable submissiondate "Date/time submitted"
cap label variable formdef_version "Form version used on device"
cap label variable review_status "Review status"
cap label variable review_comments "Comments made during review"
cap label variable review_corrections "Corrections made during review"



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

label variable id_cto "Student ID, first try (from the tablets)"
note id_cto : "Student ID (composed by the school_id and the num_elv entered in the tablets)"

label variable prenom_baseline "Student's name (from the baseline)"
note prenom_baseline: "Student's name (from the baseline)"

label variable nom_baseline "Student's family name (from the baseline)"
note nom_baseline: "Student's family name (from the baseline)"

label variable classe_baseline "Student's grade (from the baseline)"
note classe_baseline: "Student's grade (from the baseline)"

label variable option_baseline "Speciality choosen by the student (from the baseline)"
note option_baseline: "Speciality choosen by the student(from the baseline)"

label variable consent_agree "Do you accept to participate in the survey ?"
note consent_agree : "Do you accept to participate in the survey ?"
label define yes_no 1"Yes" 2"No"
label values consent_agree yes_no

label variable check_id "Are you [prenom_baseline] [nom_baseline] [classe_baseline] [option_baseline] ?"
note : "This question allows to check if enumerator did a mistake en entering the student ID of the student"
label values check_id  yes_no


label variable num_elv2 "check : ID number of the student"
note num_elv2  : "check : ID number of the student (if there was an error)"

label variable id_cto_check "Student ID"
note id_cto_check : "Student ID"


label variable participation "Did the student participate to the information session ?"
note participation : "Did the student participate to the information session ?"



///////////////////////////////////////////
//////////////  SECTION 0 /////////////////
///////////////////////////////////////////

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


///////////////////////////////////////////
//////////////  SECTION 2 /////////////////
///////////////////////////////////////////

label variable sec2_q1 "Ideally, would you like to move permanently to another country or would you like to continue living in Guinea?"
note sec2_q1 : "Ideally, if you had the opportunity, would you like to move permanently to another country or would you like to continue living in Guinea?"
label define mig_desire 1 "Yes, I would like to move permanently to another country." 2 "No, I would like to continue living in Guinea."
label values sec2_q1 mig_desire



label variable sec2_q2 "If you could go anywhere in the world, which country would you like to live in ? "
note sec2_q2 : "If you could go anywhere in the world, which country would you like to live in ? "

label variable sec2_q3 "Why would you like to move permanently to another country? "
note sec2_q3 : "Why would you like to move permanently to another country? "

label variable sec2_q3_1 "I want to migrate to continue your studies ?"
note sec2_q3_1 : "I want to migrate to continue to continue your studies ? (dummy created with mig_reason)"
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


label variable sec2_q3_other_reasonmig "Could you specify the other reason why you want to migrate to another country ?"
note sec2_q3_other_reasonmig : "Could you specify the other reason why you want to migrate to another country ?"


label variable sec2_q4 "Are you planning to move permanently to another country in the next 12 months, or not?"
note sec2_q4 : "Are you planning to move permanently to another country in the next 12 months, or not?"
label values sec2_q4 yes_no

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


rename sec2_q13 sell_asset
label variable sell_asset "Did you or you family sell any asset in the last 3 months ?"
label values sell_asset yes_no

rename sec2_q14 money_from_asset
label variable money_from_asset "How much money did you or they get from it ?"

rename sec2_q15 mig_asset
label variable mig_asset "Will you use this money or part of this money in order to migrate ?"
label values mig_asset yes_no


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



///////////////// SPAIN ///////////////////


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
label variable sec3_21 "Destination country : Consider one Guinean person who is EXACTLY LIKE YOU. Suppose he or she has to choose his or her way to migrate to Europe from Guinea. Which EUROPEAN COUNTRY would he/she plan to settle in ?"
note sec3_21: "Which EUROPEAN COUNTRY would he/she plan to settle in ?"

label variable sec3_21_nb_other "Please, specify the other EUROPEAN COUNTRY, he/she would plan to settle in ?"


destring sec3_22, replace
label variable sec3_22 "Between the two roads we have just described, which road would he/she select to go to in [sec3_21] ?"
note sec3_22 : "Between the two roads we have just described, which road would he/she select to go to in [sec3_21] ?"
label define road_select1 1 " Favorite road is Italy : This person would first reach North Africa shore and then take a boat to ITALY." 2 "Favorite road is Spain : This person would first reach North Africa shore and then take a boat to Spain."
label values sec3_22 road_select1

///////////////// CEUTA//////////////////

rename sec3_23 ceuta_awareness
label variable ceuta_awareness "Have ever heard about a road that allows people to go to Europe by climbing over the fence of ceuta or Melilla ?"
note ceuta_awareness : "Have ever heard about a road that allows people to go to Europe by climbing over the fence of ceuta or Melilla ?"
label values ceuta_awareness aware


label variable	sec3_31_bis "Between the three roads we have just described, which road would he/she select to go to [sec3_21] ?"
note sec3_31_bis : "If you know ceuta, Between the three roads we have just described, which road would he/she select to go to [sec3_21] ?"
label define sec3_31_bis 1 " This person would first reach North Africa shore and then take a boat to ITALY." 2 "This person would first reach North Africa shore and then take a boat to Spain." 3 "This person would first reach North Africa shore and then climb over the fence of ceuta or MELILLA."
label values sec3_31_bis sec3_31_bis



///////////////// BENEFIT FROM MIGRATION //////////////////
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

label variable sec3_34_euros "Expected wage in EUROS : Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH IN EUROS ?"
note sec3_34_euros : "Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH PER MONTH IN EUROS"

label variable sec3_34_livres "Expected wage in POUNDS : Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH IN POUNDS ?"
note sec3_34_livres: "Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH PER MONTH IN POUNDS ?"
rename sec3_34_livres sec3_34_pounds

label variable sec3_34_local "Expected wage in LOCAL CURRENCY of [sec3_21] : Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH LOCAL CURRENCY OF [sec3_21] ?"
note sec3_34_local: "Thanks to their work in [sec3_21], how much would each of these ${sec3_32} people earn on average PER MONTH LOCAL CURRENCY OF [sec3_21] ?"


label variable sec3_35 "Expectation studies : Among those 100 people who arrived in [sec3_21], how many of them will continue their studies in [sec3_21] ?"
note sec3_35 : "Among those 100 people who arrived in [sec3_21], how many of them will continue their studies in [sec3_21] ?"


label variable sec3_36 "Expectation citizenship : Among those 100 who arrived in [sec3_21], how many of them would become a citizen of this country ?"
note sec3_36: "Among those 100 who arrived in [sec3_21], how many of them would become a citizen of this country ?"


label variable sec3_37 "Expectation return 5yr : Among those 100 people who arrived in [sec3_21], how many of them would permanently return to Guinea within 5 years after their arrival in [sec3_21] ?"
note sec3_37 : "Among those 100 people who arrived in [sec3_21], how many of them would permanently return to Guinea within 5 years after their arrival in [sec3_21] ?"

label  variable sec3_39 "Expectation help from government : Among these 100 people who arrived in [sec3_21], how many of them will receive money from the GOVERNMENT of [sec3_21]  over year after their arrival ?"
note sec3_39 : "Among these 100 peopls who arrived in [sec3_21], how many of them will receive money from the GOVERNMENT of [sec3_21]  over year after their arrival ?"

label  variable sec3_40 "Expectation asylum request accepted : Imagine that 100 Guinean people, who are exactly like you, applied for asylum in[sec3_21] for the first time. According to you, how many of them would you expect to be given a positive response ?"
note sec3_40 : "Imagine that 100 Guinean people, who are exactly like you, applied for asylum in[sec3_21] for the first time. According to you, how many of them would you expect to be given a positive response ?"


label  variable sec3_41 "Expectation number of citizen in favor of immigration: Now consider 100 citizens of [sec3_21]. In your opinion, among these 100 citizens of [sec3_21], how many of them are in favor of immigration ?"
note sec3_41 : "Now consider 100 citizens of [sec3_21]. In your opinion, among these 100 citizens of [sec3_21], how many of them are in favor of immigration ?"


label variable sec3_42 "Expected living cost : Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
note sec3_42 : "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."


label variable sec3_42_euros "Expected living cost in EUROS: Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in EUROS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
note sec3_42_euros : "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in EUROS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."

label variable sec3_42_livre "Expected living cost in POUNDS: Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in POUNDS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
note sec3_42_livre : "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in POUNDS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
rename sec3_42_livre sec3_42_pounds

label variable sec3_42_local "Expected living cost in the LOCAL CURRENCY of [sec3_21]: Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in the LOCAL CURRENCY of [sec3_21]. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
note sec3_42_local : "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in [sec3_21] in the LOCAL CURRENCY of [sec3_21]. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."



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
//////////////  SECTION 7 /////////////////
///////////////////////////////////////////

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
//////////////  SECTION 9 /////////////////
///////////////////////////////////////////
label variable sec9_q1 "Did any of your siblings or friend leave Guinea over the last six months ?"
note sec9_q2 : "Did any of your siblings or friend leave Guinea over the last six months ?"
label values sec9_q1 yes_no

label variable sec9_q2 "How many of your classmates left Guinea over the last six  months ?"
note sec9_q2 : "How many of your classmates left Guinea over the last six  months ?"

label variable outside_contact_no "In total, how many familly members or friends living OUTSIDE Guinea and with whom you are in contact do you know ?"
note outside_contact_no : "In total, how many familly members or friends living OUTSIDE Guinea and with whom you are in contact do you know ?"

label variable sec9_q3_1_a "Name 1rst classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
label variable sec9_q3_1_b "Family name 1rst classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
note sec9_q3_1_a :"Name 1rst classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
note sec9_q3_1_b : "Family name 1rst classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"


label variable sec9_q3_2_a "Name 2nd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
label variable sec9_q3_2_b "Family name  2nd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
note sec9_q3_2_a : "Name  2nd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
note sec9_q3_2_b : "Family name  2nd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"

label variable sec9_q3_3_a "Name 3rd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
label variable sec9_q3_3_b "Family name 3rd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
note sec9_q3_3_a : "Name 3rd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"
note sec9_q3_3_b : "Family name 3rd classmate who migrated: Could you tell me the name of your CLASSMATE who left Guinea over the last siw months ?"


///////////////////////////////////////////
//////////////  SECTION 10 ////////////////
///////////////////////////////////////////

label variable sec10_q1_1	"Name or nickname of your first contact living outside Guinea"
label variable sec10_q5_1	"In which country does your first contact live ?"

label variable sec10_q1_2	"Name or nickname of your second contact living outside Guinea"
label variable sec10_q5_2	"In which country does your second contact live ?"

label define relation 1	"Spouse/FiancÈ(e)" 2	"Mother/Father or parents in law" 3	"Siblings/ Siblings in law" 4	"Other member of my family" 5	"Children" 6	"Friend" 7	"Other"
label define education_long 0	"No formal schooling" 1	"Preschool" 2	"Primary" 3	"Secondary school (lower and upper secondary)" 4	"Post secondary degree (University etc.)" 99	"Don't know"
label define occupation_long 1	"Student" 2	"Sales and Services (ex : salesperson/entrepreneur)" 3	"Agriculture (including fishermen, foresters, and hunters)" 4	"Skilled manual worker (ex : machiner operator/carpenter)" 5	"Unskilled manual worker (ex†: road construction/assembler)" 6	"Professional/technical/managerial (e.g. engineer/computer assistant/manager/nurse)" 7	"Clerical (ex : secretary)" 8	"Military" 9	"Domestic service for another house (e.g. housekeeper)" 10	"Housewife" 11	"Unemployed" 99	"Don't know"
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


///////////////////////////////////////////
////////////////  PART B  /////////////////
///////////////////////////////////////////

label variable partb_participation "Participation status for schools without attendance sheet"
note partb_participation : "Some weeks ago, some members of the NGO Aguidie went to your school to organise an information session. During this session, they have showed some testimonies and statistics, organised a debate and handed out flyers. Did you participate to this information session ?"
label values partb_participation yesno

label variable partb_q0 "Do you remember what this session was about?"
note partb_q0 : "Some week ago, the members of the NGO Aguidie came to your school to organize an information session.  Do you remember what this session was about? "
label define partb_q0 1 "Explain job opportunities in Guinea" 2"Explain job opportunities in Europe" 3"Talk about international migration" 4"Poverty in Africa" 5"Don't remember" 6"Other specify"
label values partb_q0 partb_q0 

label variable partb_q0_bis "Do you remember what this session was about? "
note partb_q0_bis : "for schools without attendance sheet : Some week ago, the members of the NGO Aguidie came to your school to organize an information session.  Do you remember what this session was about? "
label values partb_q0_bis partb_q0 

label variable partb_q0_other "Specify the other subject of the information session"
note partb_q0_other : "Specify the other subject of the information session"

label variable partb_q1 "What was the FIRST activity of this information session?"
note partb_q1 : "What was the FIRST activity of this information session?"
label define partb_q1 2"A migrant came to the school to explain his story" 3"We watched videos of migrant recounting their stories" 4" We were shown some numbers on migration" 5"Other(Specify)"
label values partb_q1 partb_q1

label variable partb_q1_other "Specify the FIRST activity of this information session ?"
note partb_q1_other : "Specify the FIRST activity of this information session ?"


label variable partb_q2 "On a scale from 1 to 10, how much did you like the information session? 1 means not at all and 10 means very much."
note partb_q2 : "On a scale from 1 to 10, how much did you like the information session? 1 means not at all and 10 means very much."

label variable partb_q3 "About the videos you watched during the information session, what are the main experiences of individuals depicted?"
note partb_q3 : "About the videos you watched during the information session, what are the main experiences of individuals depicted? TICK ALL THAT APPLY"

label variable partb_q3_1 "Dummy for having watch videos on Their journey to reach Europe"
note partb_q3 : "Dummy for having watched videos on Their journey to reach Europe"
label values partb_q3_1 yesno_bis

label variable partb_q3_2 "Dummy for having watch videos on Their life in Europe"
note partb_q3_2 : "Dummy for having watched videos on Their life in Europe"
label values partb_q3_2 yesno_bis

label variable partb_q3_3 "Dummy for having watch videos on Their life in Africa"
note partb_q3_3 : "Dummy for having watched videos on Their life in Africa"
label values partb_q3_3 yesno_bis

label variable partb_q3_4 "Dummy for having watch videos on Their journey to reach Africa"
note partb_q3_4 : "Dummy for having watched videos on Their jounrey to reach Africa"
label values partb_q3_4 yesno_bis

label variable partb_q3_99 "Dummy for not remembering what was the main experiences of individuals that was depicted in the video"
note partb_q3_99 : "Dummy for not remembering what was the main experiences of individuals that were depicted in the video"
label values partb_q3_99 yesno_bis

label variable partb_q3_5 "Dummy to specify the other experiences of individuals that were depicted in the video"
note partb_q3_5 : "Dummy  to specify the other experiences of individuals that were depicted in the video"
label values partb_q3_5 yesno_bis

label variable partb_q3_other "Specify the other experiences of individuals that were depicted in the videos"
note partb_q3_other : "Specify the other experiences of individuals that were depicted in the videos"

label variable partb_q5 "Statistics on migrant who do not work : During the information session, one of the presenters told you the proportion of young Africans having resided in a European country for 3 YEARS OR LESS who are not working. Do you remember how many of them donít work out of 10? Write 99 if you don't remember"
note partb_q5 : "Statistics on migrant who do not work : During the information session, one of the presenters told you the proportion of young Africans having resided in a European country for 3 YEARS OR LESS who are not working. Do you remember how many of them donít work out of 10? Write 99 if you don't remember"

label variable partb_q6 "Statistic on migrants who do not study : During the information session, one of the presenters told you the proportion of young Africans having resided in a European country for 3 YEARS OR LESS who are not studying. Do you remember how many of them donít study of 10? Write 99 if you don't remember."
note partb_q6 : "Statistic on migrants who do not study : During the information session, one of the presenters told you the proportion of young Africans having resided in a European country for 3 YEARS OR LESS who are not studying. Do you remember how many of them donít study of 10? Write 99 if you don't remember."

label variable partb_q8 "Statistics on migrants who have undergo violence or physical abuse : During the information session, one of the presenters told you the proportion of Africans who undergo VIOLENCE OR PHYSICAL ABUSE WHILE TRAVELLING to Europe. Do you remember how many of them suffer violence or physical abuse out of 10?  Write 99 if you don't remember"
note partb_q8 : "Statistic on migrants who have undergo violence or physical abuse : During the information session, one of the presenters told you the proportion of Africans who undergo VIOLENCE OR PHYSICAL ABUSE WHILE TRAVELLING to Europe. Do you remember how many of them suffer violence or physical abuse out of 10?  Write 99 if you don't remember"

label variable partb_q9 "Statistics on migrant who took more than 6 months to reach Europe : During the information session, one of the presenters told you the proportion of young Guineans who take MORE THAN 6 MONTHS TO REACH EUROPE. Do you remember how manytake more than 6 months out of 10.  Write 99 if you don't remember."
note partb_q9 : "Statistics on migrant who took more than 6 months to reach Europe. During the information session, one of the presenters told you the proportion of young Guineans who take MORE THAN 6 MONTHS TO REACH EUROPE. Do you remember how many take more than 6 months out of 10?  Write 99 if you don't remember."


label define agree_scale 1 "Strongly Disagree" 2"Disagree" 3"Neither Agree Neither disagree" 4"Agree" 5"Strongly disagree"

label variable partb_q11_a "While participating in the debate : You were distracted by activities in the room around you, while the debate was going on."
note partb_q11_a : "While participating in the debate : You were distracted by activities in the room around you, while the debate was going on."

label variable partb_q11_b "You were really following the debate"
note partb_q11_b : "You were really following the debate."

label variable partb_q11_c "The debate affected you emotionally."
note partb_q11_c : "The debate affected you emotionally."


label variable partb_q11_f "While watching the videos : You were distracted by activities in the room around you, while watching the videos."
note partb_q11_a : "While watching the videos : You were distracted by activities in the room around you, while watching the videos."

label variable partb_q11_g "You were really following the videos."
note partb_q11_b : "You were really following the videos."

label variable partb_q11_h "The videos affected you emotionally."
note partb_q11_c : "The videos affected you emotionally."

label variable partb_q11_j "You understand the reasons why the people in videos did what they did."
note partb_q11_j : "You understand the reasons why the people in videos did what they did."

label variable partb_q11_k "While viewing the videos you could feel the emotions the people displayed."
note partb_q11_k : "While viewing the videos you could feel the emotions the people displayed."

label variable partb_q11_l "At key moments in the show, you felt that you could experience the same as what people in videos have experienced."
note partb_q11_l : "At key moments in the show, you felt that you could experience the same as what people in videos have experienced."

label variable partb_q11_m "While viewing the videos, you wanted the people in it to succeed in achieving their goals."
note partb_q11_m : "While viewing the videos, you wanted the people in it to succeed in achieving their goals."

label values partb_q11* agree_scale

label variable partb_q12 "Did you receive a comic strip at the end of the session ?"
note partb_q12 : "Did you receive a comic strip at the end of the session ?"
label values partb_q12 yesno

label variable partb_q13 "Did you give the comic strip you received to someone?"
note partb_q13 : "Did you give the comic strip you received to someone?"

label variable check1 "Imagine that you have 10 balls in a bag: 2 white and 8 black. Imagine that 100 people, in turn, pick one ball from the bag, and put it back in it. How many of them do you expect to pick a black ball?"
note check1 : "Imagine that you have 10 balls in a bag: 2 white and 8 black. Imagine that 100 people, in turn, pick one ball from the bag, and put it back in it. How many of them do you expect to pick a black ball?"

label variable check1_bis "So there are 8 black balls and 2 white balls, which means there are more black balls than white. Imagine that 100 people, in turn, pick one ball from the bag, and put it back in it. How many of them do you expect to pick a black ball? "
note check1_bis : "So there are 8 black balls and 2 white balls, which means there are more black balls than white. Imagine that 100 people, in turn, pick one ball from the bag, and put it back in it. How many of them do you expect to pick a black ball? "

label variable check2 "Imagine 100 people exactly like you. How many of them will go to the market between today and tomorrow?"
note check2 : "Imagine 100 people exactly like you. How many of them will go to the market between today and tomorrow?"

label variable check3 "How many of these 100 people like you will go to the market at least once between today and 2 weeks from now?"
note check3 : "How many of these 100 people like you will go to the market at least once between today and 2 weeks from now?"

label variable check3_bis "But you told me that the number of people who will go the market between today and tomorrow is out of 100. Note that tomorrow is also included between today and 2 weeks from now, so the number of people going to the market between today and 2 weeks from now should be at least as high. So how many of them will go to the market will go to the market at least once between today and 2 weeks from now? "
note check3_bis : "But you told me that the number of people who will go the market between today and tomorrow is out of 100. Note that tomorrow is also included between today and 2 weeks from now, so the number of people going to the market between today and 2 weeks from now should be at least as high. So how many of them will go to the market will go to the market at least once between today and 2 weeks from now? "



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   3- Cleaning                                     
***_____________________________________________________________________________



//////////////  CLEANING COUNTRY'S NAME ///////////////// 


foreach x in sec2_q2 sec3_21 sec2_q5 sec10_q5_1 sec10_q5_2{
replace `x'=upper(`x')
replace `x'=trim(`x')
replace `x'="" if `x'=="," |`x'=="NIAN" | `x'=="J'IGNORE" | `x'=="8" | `x'=="UUU" |`x'=="THIERNO MARINA SOW" |`x'=="SDIMA" |`x'=="SANKOUMBA" |`x'=="SANA" |`x'=="S SANTIGUI TOURE" |`x'=="ROI" |`x'=="NDEYE DIALLO" |`x'=="MOUSSA" |`x'=="HAFIA" |`x'=="GAJA" |`x'=="FODE MOUSSA BERETE"
replace `x'="" if `x'=="TTHHJ" |`x'=="EN" |`x'=="CONA" |`x'=="CHEICK" |`x'=="BOUBA" | `x'=="BOH SARAN" |`x'=="BALDE" |`x'=="BADEMBA" |`x'=="YOUNONSSA" |`x'=="YARIE" |`x'=="TY" |`x'=="THIERNO BAH" |`x'=="TONTON PAPA" |`x'=="TAMBOUR MORY KAMANO" |`x'=="TAIBOU BAH" |`x'=="S√®" |`x'=="SYLLA" |`x'=="SOS" |`x'=="SILLO KAMONO" |`x'=="SIGURI" |`x'=="SIDIKI" |`x'=="SA√ØDOU" |`x'=="SARAH TOURE" | `x'=="SANNY CAMARA OU VERRETY" | `x'=="SALIOU"
replace `x'="" if `x'=="MARIAME" |`x'=="MAMADOU LAMINE DIALLO" | `x'=="MAMADOU LAMARANA" |`x'=="KORKA" |`x'=="KALIL CAMARA" |`x'=="KADIZA" |`x'=="JOAO MIGUEL" |`x'=="AIMé SIDIBE" |  `x'=="SABANA" | `x'=="PAR" |`x'=="PAPA" |`x'=="OUSMANE KEITA" | `x'=="OUSMANE" | `x'=="N'ZEREKORE" | `x'=="N'ASSURE BERETE" | `x'=="MOUSTAPHA" |`x'=="MOHAMED SANOUSSI CAMARA" |`x'=="MOHAMED CONDE" |`x'=="MILéN" |`x'=="MARIE LOUISE CAMARA"
replace `x'="" if `x'=="MARIE" |`x'=="MARIE" |`x'=="MARIAMA" |`x'=="MARCEILLE" |`x'=="MAMAN" |`x'=="MAMADOU SOW" |`x'=="MAMADOU DIAN" |`x'=="MAMADOU" |`x'=="MAMADI" |`x'=="MAMADAMA" | `x'=="MADOU TOURE"
replace `x'="" if `x'=="MAROMAC" | `x'=="BEN" |`x'=="MA BOSSOIR CAMARA" | `x'=="LIMA KEITA" | `x'=="LERO" |`x'=="KONGUEL" | `x'=="KANABA" | `x'=="KALOU" |`x'=="JOSé DA GAMA" | `x'=="IBRAHIMA  DIALLO" | `x'=="INTERNET" |`x'=="IBRAHIMA KENNEDY BAH" |`x'=="IBRAHIMA DIALLO" | `x'=="IBRAHIMA CAMARA" |`x'=="HABIB BALDE" | `x'=="GOMBO" |`x'=="FODé SYLLA" |`x'=="FATOUMATA MANSARE" | `x'=="GGUI" |`x'=="FANTA" |`x'=="EN GUINéE 625812444" |`x'=="DéDé" 
replace `x'="" if  `x'=="DJEDA" |`x'=="DJADA" |`x'=="DABY" |`x'=="CONTé" |`x'=="CONCON" |`x'=="CISSé" |`x'=="CON" |`x'=="CAMARA" |`x'=="BECKAYE NIANE" | `x'=="BARRY" | `x'=="BANKOKE" | `x'=="BANJUL" |`x'=="BAH" | `x'=="A√ØCHA" | `x'=="ANYER"
replace `x'="" if `x'=="VANNE" |`x'=="OUMAR" |`x'=="O" |`x'=="AMINATA TRAORE" |`x'=="AMARA" |`x'=="AMADOU" |`x'=="AMA" |`x'=="ALIOU" |`x'=="ALIMOUDIAWBHE BALDE" |`x'=="ALHASSANE KOUMBASSA" | `x'=="ABJA" | `x'=="ABDOURAHIM" |`x'=="ABDOULAYE CONTE" |`x'=="A CON" |`x'=="NOM" |`x'=="HABA" |`x'=="AMRE" | `x'=="JUIVE" |`x'=="RIEN" |`x'=="99" |`x'=="NON" |`x'=="AUTRE" |`x'=="U.A" | `x'=="SIMONE" |`x'=="POUR PRATIQUE LE SPORT"
replace `x'="" if  `x'=="CR7" | `x'=="OUI" | `x'=="JUIF" |`x'=="G" |`x'=="1" | `x'=="12 .0000" | `x'=="2HM" | `x'=="AMRAO" | `x'=="MIROITANT" | `x'=="MOHAMED LAMINE"
replace `x'="" if `x'=="ICI" | `x'=="0" | `x'=="√?TUDIANTS" | `x'=="6" |`x'=="622113643" |`x'=="622969364" | `x'=="623456789" | `x'=="62354325" | `x'=="9177743205" | `x'=="999" 
replace `x'="" if `x'=="0032488021127"| `x'=="999999999" | `x'=="999" |`x'=="669201012" |`x'=="664969637" | `x'=="664784505" |`x'=="664038791" | `x'=="661708083" |`x'=="661202160" | `x'=="656722464"|`x'=="656400987"|`x'=="0077243"|`x'=="333753167816" | `x'=="622029210" | `x'=="622691862"
replace `x'="" if `x'=="629301883" |`x'=="22249845494" |`x'=="00" |`x'=="+22575410670" | `x'=="00244922634337" | `x'=="54" | `x'=="ADJA"| `x'=="ABDOULAYE" | `x'=="21" | `x'=="654276756" | `x'=="661219453" | `x'=="666158165"
replace `x'="" if `x'=="TOLNO" | `x'=="SARAN" | `x'=="H" | `x'=="MAMADOU SALIOU BALDé" | `x'=="MORLAYE SYLLA" | `x'=="MODESTE" | `x'=="KSKSDK" | `x'=="IBRAHIMA" | `x'=="HASSANATOU  DIALLO" | `x'=="BORDO" | `x'=="FRAMORI" | `x'=="BOKE" | `x'=="BINTA DIALLO" | `x'=="ALPHA OUMAR BAH DIT RONALDINHO" | `x'=="S√∂PI" | `x'=="LELSLDLDL" | `x'=="KADIATOU" | `x'=="FATOUMATA BINTA BARRY" | `x'=="BEAVOGUI" |  `x'=="DIALLO ALHASSANE" | `x'=="AUEB" | `x'=="CYCAGO" | `x'=="SAIS PAS" |`x'=="FRAN√ßOIS" | `x'=="OU" | `x'=="AICHA" | `x'=="BABIEN" | `x'=="YAMOUSSA" | `x'=="YAYA CAMARA" | `x'=="YAHYA DIALLO" | `x'=="SOUMAH" | `x'=="THIERNO" | `x'=="SWITCH" | `x'=="KEITA" | `x'=="ANG" | `x'=="BANGOURA" | `x'=="CHARABIA" | `x'=="DIALLO" | `x'=="SANDALI" |`x'=="FERLAND" | `x'=="GEANS" | `x'=="GUILAVOGUI" | `x'=="HABIB" | `x'=="HYY8P" | `x'=="IBRAHIMA DIALLO"

replace `x'="TANZANIA" if `x'=="TANZANIE"

replace `x'="YEMEN" if `x'=="YéMEN"

replace `x'="FRANCE" if `x'=="LA  FRANCE" | `x'=="KA FRANCE" | `x'=="LA FRAN√ßAIS " |`x'=="√Ä PARIS" |`x'=="MARSEILLE" |`x'=="AVRE" |`x'=="LE HAVRE" | `x'=="FRANCE  LION" | `x'=="FRACNCE" |`x'=="ANGER" | `x'=="JE VOUDRAI HABITER EN FRANCE" | `x'=="MFRANCE" | `x'=="A   PARIS" | `x'=="SKANTE  PARIS" | `x'=="ENFRANCE"|`x'=="NANTES"
replace `x'="FRANCE" if `x'=="IAN FRANCE" |`x'=="FRANCIS" |`x'=="FRANCHE" | `x'=="LYON"| `x'=="FRENCE" | `x'=="FRANCE SAYON CAMARA" | `x'=="FRANCE  002245689" | `x'=="FANCE" |`x'=="SAINT √âTIENNE" | `x'=="TOULOUSE" | `x'=="STRASBOURG" | `x'=="NANTE"| `x'=="MONACO"| `x'=="LION" | `x'=="LILLE" | `x'=="EN FANCE" | `x'=="√éLE DE FRANCE"| `x'=="FRANCE ABACARCONDE" | `x'=="FRANCE 625241415" | `x'=="FRANC" | `x'=="A FRANCE"
/*line17*/
replace `x'="FRANCE" if `x'=="√?LE DE FRANCE" | `x'=="C'EST A FRANCE" |`x'=="IA  FRANCE" | `x'=="√? PARIS" |`x'=="LAFRANCE" | `x'=="FRANCE " |`x'=="FRANCCE" | `x'=="A FANCE" | `x'=="FRAN√ßE" | `x'=="ITALIE APR√®S LA FRANCE" | `x'=="LE PARIE" | `x'=="FRANCS" | `x'=="IA FRANCE" |`x'=="LA FRAN√ßE" | `x'=="FRAN√ßAIS" | `x'=="A PARIS" | `x'=="EN FRANCE" | `x'=="FRAN√ßAIS"| `x'=="LA FRANCE" | `x'=="FRANCE " | `x'==" FRANCE " | `x'=="EN FRANCE, BANQUE" | `x'=="EN FRANCS" | `x'=="EN FRAN√ßE" | `x'=="PARI" | `x'=="PARIS" | `x'=="PARIE"

replace `x'="CANADA" if `x'=="CAANDA" | `x'=="A  CANADA" | `x'=="A CANADA" |`x'=="AUCANADA" | `x'=="M'ONT REAL" | `x'=="CANADAN" |`x'=="CANADAN"| `x'=="L'AMéRIQUE PRéCISéMENT AU CANADA" | `x'=="CANADAT" | `x'=="AU CANADAT" | `x'=="EN AMéRIQUE  (CANADA)" | `x'=="√Ä CANADA" | `x'=="I'AMéRIQUE PRéCISéMENT √† CANADA" | `x'=="A CANADA"| `x'=="AU CANADA" | `x'=="GANADA" | `x'=="AU CANADA " | `x'=="KANADA" | `x'=="LE CANADA" | `x'=="CANADA " | `x'==" CANADA " | `x'=="En Amérique  (Canada)" |`x'=="√? CANADA"

replace `x'="GERMANY" if `x'=="ALLEMAND" |`x'=="L ALLEMAGNE" |`x'=="ALLEMANGNE " | `x'=="ALLEMANDE" |`x'=="ALLEMAGNE " |`x'=="ALLEMANG" |`x'=="ALLEMANE" | `x'=="ALEMANGNE" |`x'=="ALMANGNE" | `x'=="ALLEMAGNE 663241415" |`x'=="ALMAGNE" | `x'=="ALLéMAGNE" | `x'=="ALLEMAN3" | `x'=="ALLEAGNE" | `x'=="EN ALLEMAGNE" | `x'=="ALLEMAGNE" | `x'=="ALLEMANGNE" | `x'==" L'ALLEMAGNE" | `x'=="L'ALLEMAGNE"

replace `x'="UNITED STATES" if `x'=="A L'AMéRIQUE" | `x'=="AMéRIQUE DU NORD" | `x'=="AMéRIQUE  (NEW YORK )" | `x'=="MON PAYS DE R√™VE C'EST L'AMéRIQUE" |`x'=="√âTATS-UNIS  D'AMéRIQUE" |`x'=="L'AM√âRIQUE"|`x'=="U SA"| `x'=="AUX ETATS-UNIS"| `x'=="A PHILADELPHIA" | `x'=="LES √âTATS UNIS D'AMéRIQUE" | `x'=="LES √âTATS UNIS D'AMERIQUE" | `x'=="AUX √âTATS-UNIS" | `x'=="NEW-YORK" | `x'=="U éTAT UNIS" | `x'=="√âTATS UNIS D'AMéRIQUE" | `x'=="√âTAT UNIS" | `x'=="√âTATS-UNIS D'AMéRIQUE" |`x'=="√âTAT UNIS D'AMéRIQUE" | `x'=="USA AMéRIQUE" | `x'=="AU √âTATS-UNIS" | `x'=="A LOS ANGELES" 

replace `x'="UNITED STATES" if `x'=="AMéRIQUES" | `x'=="AMéRIQUE DU NORD " |`x'=="AMéRIQUE " |`x'==" √?TATS  UNIS D'AMéRIQUE" |`x'=="√âTATS-UNIS D'AMéRIQUE, " | `x'=="NEW JERSEY" | `x'=="PENTAGONE" |`x'=="AUX √âTATS-UNIS D'AMéRIQUE" | `x'=="√âTATUNIS" |`x'=="CALIFORNIE" |`x'=="AMRIQUE" |`x'=="AMERICA" |`x'=="√âTAS UNI D'AMéRIQUE" |`x'==" √âTATS-UNIS  D'AMéRIQUE" |`x'=="√âTAT UNIS AMéRIQUE" |`x'=="√âTAT -UNIS" |`x'=="WASHINGTON" |`x'=="U,.S,A" | `x'=="CHICAGO"| `x'=="USA" |  `x'=="AU éTAT UNIS" | `x'==" √âTATS-UNIS" | `x'=="√âTATS-UNIS" | `x'=="√âTATS UNIS" | `x'==" √âTATS UNIS D'AMéRIQUE" | `x'=="√âTAS UNIS D'AMéRIQUE"| `x'=="√âTAT  UNIS D AMéRIQUE" | `x'=="√âTAT UNIS D'AM√âRIQUE" | `x'==" √âTAT UNIS" | `x'=="√âTAS UNIS" | `x'=="LES USA" | `x'=="U S A" 

replace `x'="UNITED STATES" if `x'=="J'AIMERAIS M'INSTALLER AUX √âTATS-UNIS" |`x'=="AMéRIQUE  (NEW YORK)" |`x'=="ETATS UNIS D'AMERIQUE" |`x'=="ETATS UNIS" |`x'=="ETATS UNIES" |`x'=="U . S.A" | `x'=="ETATS-UNIS D'AMéRIQUE" |`x'=="ETAS UNIS" | `x'=="NEYWORK" | `x'=="NEW YORK" | `x'=="ETAS UNIS" |`x'=="ETAT-UNIS" | `x'=="ETAT UNIS" | `x'=="LOS ANGELES" | `x'=="AU USA" | `x'=="√?TATS UNIS D'AMéRIQUE"| `x'=="AUX U .S. A (EN AMéRIQUE )" | `x'==" AUX U .S. A (EN AMéRIQUE ) "
replace `x'="UNITED STATES" if `x'=="√?TATS-UNIS D'AMéRIQUE" | `x'=="√?TATS UNIES D'AMéRIQUE" | `x'=="√?TATS UNIES" |`x'=="√?TATS UNI" | `x'=="MARYLAND" | `x'=="√?TAT UNIES" |  `x'=="MIAMI" | `x'=="MIAMI BITCH" |`x'=="MANATHAM" |`x'=="√?TAS UNIS D'AMéRIQUE" | `x'=="Etats_Unis" | `x'=="Au U.S.A" | `x'=="√?TATS-UNIS" | `x'=="√?TATS UNIS" | `x'==" √?TATS UNIS D'AMéRIQUE" | `x'=="√?TAT UNIS D'AM√?RIQUE" | `x'=="√?TAT UNIS" | `x'=="√?TAT  UNIS D AMéRIQUE"|  `x'=="√?TAS UNIS" |`x'==" √?TAS UNIS D'AMéRIQUE"| `x'=="USA D'AMERIQUE"| `x'=="USA AMERIQUE"| `x'=="U.S.A" | `x'=="ETAT-UNIS UNIS" | `x'=="ETATS UNIS D'AMéRIQUE" | `x'=="ETATS-UNIS" | `x'=="EUAMéRIQUE" | `x'=="L'éTATS UNIES D'AMéRIQUE"
replace `x'="UNITED STATES" if  `x'=="DALLAS" | `x'=="COLORADO" | `x'=="AUX √?TATS-UNIS" |`x'=="√?TATS-UNIES" | `x'=="√?TATS UNIS D'AMERIQUE," | `x'=="√?TATS UNIS D'AMERIQUE" | `x'=="√?TATS UNIS AMERIQUE" | `x'=="AMERIQUE  (NEW YORK)" | `x'=="QUE AMéRIQUE" | `x'=="AM√®RIQUE" |`x'=="AUX USA" | `x'=="PENTAGON" | `x'=="LES √?TATS UNIS" | `x'=="LES √?TATS UNIS  D'AMéRIQUE" | `x'=="L'USA"
replace `x'="EQUATORIAL GUINEA" if `x'=="GUINéE  EQUATORIAL" | `x'=="GUINéE EQUATORIAL" | `x'=="GUINEE EQUATORIALE"

replace `x'="SPAIN" if `x'=="BARCELO6" |`x'=="ESPANCE" |`x'=="ESPAGUE" | `x'==" ESPAGUE" |`x'=="MADRID" | `x'=="ESPANGNE" |`x'=="SPAGNE"| `x'=="ESPAGN"| `x'=="EN MADRID" | `x'=="ESPAGNE" | `x'=="EN ESPAGNE" | `x'=="ESPANE" | `x'=="L'ESPAGNE"

replace `x'="BELGIUM" if `x'=="LI√®GE" | `x'=="OU BELGIQUE" |`x'=="BRUXELLE" |`x'=="BLEGIQUE" | `x'=="BELGIQU" |`x'=="IA BELGIQUE" | `x'=="BELGIQUE 0032465789089" | `x'=="BERGIQUE"| `x'=="BELGIQUE" | `x'=="EN BELGIQUE" | `x'=="BELSIQUE" | `x'=="LA BELGIQUE"

replace `x'="ENGLAND" if `x'=="L'ANGLETERRE " |`x'=="ANGLETTE" |`x'=="ANGLETAIS" | `x'=="√? LONDRES" | `x'=="LONDRES" | `x'=="ANGLLETERE" | `x'=="LONDON"| `x'=="BINTA BARRY  ANGLETERRE"| `x'=="EN ENGLETERRE" | `x'=="ANGLERRE" | `x'=="ANGLETERRE" |  `x'=="ENGLETTERE"  | `x'=="ANGLETERE"| `x'=="L'ANGLETERRE" | `x'=="ANGLETAIRE" | `x'=="EN ANGLETERRE" | `x'=="ENGLETERRE" | `x'=="ENGLETTERRE" | `x'=="LONDRE" | `x'=="LONDRE"
replace `x'="ENGLAND" if `x'=="8ENGLETTERE"  |`x'=="ENGLETAIRE" |`x'=="ALLETERRE" |`x'=="ENGLETER" |`x'=="ANGLETER" | `x'=="ANGLETRRE"
replace `x'="UNITED STATES" if `x'=="NEW WORK" | `x'=="AUX éTATS UNIS" |`x'=="CANSAS" |`x'=="√?TATS  UNIS D'AMéRIQUE"  | `x'=="ETAT UNIS D'AMéRIQUE" | `x'=="ETAS UNIS AMERIQUE"| `x'=="LESUSA"| `x'=="ETAT UNIE"| `x'=="AMéRICAIN"| `x'=="AMéRIQUES" | `x'=="AMERQUE" | `x'=="AMERICAINE" | `x'=="AMERIQUE" | `x'=="LA L'AMéRIQUE" |`x'=="L'AMéRIQUE" | `x'=="AMERIC" | `x'=="EN AMERIQUE" | `x'=="AMERIQEU"| `x'=="AMéRIQUE" | `x'==" EN AMERIQUE" | `x'=="EN AMéRIQUE" | `x'=="L' AMERIQUE"| `x'=="L' AMéRIQUE"| `x'=="L'AMERIQUE"| `x'==" L'AMéRIQUE"

replace `x'="ITALY" if `x'=="ROME" | `x'=="ITAL" |  `x'=="ITALIEN" | `x'=="LATE ITALI" | `x'=="ITALI 664971432" | `x'=="POUR LE MOMENT C'EST EN ITALIE" | `x'=="L'ITALIE" |`x'=="ITAY" |`x'=="ITALIA" | `x'=="ROME" | `x'=="ITALIE"  | `x'=="EN ITALI" | `x'=="ITALI" | `x'=="ITALY" | `x'=="EN ITALIE"

replace `x'="RUSSIA" if  `x'=="RUISSIE"| `x'=="MOSCOW" | `x'=="LA RUSSIE" | `x'=="RUSSIE" | `x'=="RUSIE"

/*line 33*/
replace `x'="TOGO" if `x'=="AU TOGO"

replace `x'="EUROPE" if `x'=="EN EUROPE" |  `x'=="EUROPéENNE" | `x'=="√Ä L'EUROPE" | `x'=="L'EUROPE" | `x'=="L√? L'EUROPE" | `x'=="IEUROPE" | `x'=="EROPE"

replace `x'="NETHERLANDS" if `x'=="PAYS  BAS" | `x'=="PAYS BAS" |`x'=="OLENDE" | `x'=="HOLANDE" | `x'=="HOLLAND"| `x'=="PAYBAS" | `x'=="HOLLANDE" | `x'==" HOLLANDE" | `x'=="LES PAYS BAS" | `x'=="HOLAND"

replace `x'="SAUDI ARABIA" if `x'=="RABIAT0U SAOUDITE" | `x'=="ARABIA SAOUDITE" | `x'=="ARABISAOUDITE" | `x'=="MECQUE" | `x'=="ARABIE SAOUDITE" | `x'=="EN ARABI SAOUDITE" | `x'=="ARABIS SAODI" | `x'=="ARABE SAOUDI" | `x'=="EN ARABE SAOUDITE"  | `x'==" ARABIS SAODI" | `x'=="SAODIA" | `x'=="SAOUDI" | `x'=="SAOUDIA" | `x'=="SAOUDINE"

replace `x'="MOROCCO" if `x'=="MARROC"| `x'=="MACOC"|`x'=="RABAT"|  `x'=="MAROQUE" | `x'=="MARAOC"| `x'=="MARCO" | `x'=="LE MAROC" | `x'=="AU MAROC" | `x'=="MAROC"

replace `x'="AUSTRALIA" if `x'=="L'AUSTRALIE" | `x'=="HOSTRALIE" | `x'=="AUTRALIE" |`x'=="A LA AUSTRALIE" |`x'=="AUSTRALIE" | `x'=="AUSTRALI" | `x'=="POUR TRAVAILLER SURTOUT EN AUSTRALIE" | `x'=="EN AUSTRALIE"

replace `x'="" if `x'=="GUINE" |`x'=="LA GUIN√?E" | `x'=="ENGUINEE" |`x'=="IA GUINEE" |`x'=="OUIENGUINE" |`x'=="LA GUINEE" |`x'=="MATOTO"  |`x'=="LA GUINéE CONAKRY"  |`x'=="LANSANAYAH"  |`x'=="LA GUINéE  CONAKRY"  | `x'=="IL VIT EN GUINéE"  | `x'=="GUIN√âE"  |`x'=="LE GUINéE" |`x'=="LA GUIN√âE" | `x'=="FRIA"| `x'=="COONAKRRY" |`x'=="CNAKRY" | `x'=="CANAKRY" | `x'=="MAMOU" | `x'=="KANKAN" | `x'=="√Ä CONACKRY"| `x'=="LA GUIN√®E"| `x'=="LA GUINNEE"| `x'=="IL GUINE"| `x'=="IA GUINéE" | `x'=="GUINéE CONAKRY"| `x'=="GUINNEE" | `x'=="GUINNE" | `x'=="GUINEEE" | `x'=="GUINEA" | `x'=="EN GUINNEE" | `x'=="EN GUINEE"| `x'=="CONACKRY"| `x'=="CON1KRY"| `x'=="COKNARY"| `x'=="A CONAKRY"|`x'=="GUINEE"| `x'=="CONAKRY" | `x'=="A' CONAKRG" | `x'=="SANGOYAH" | `x'=="A CONAKRG" | `x'=="EN GUINéE" | `x'=="GUINéE" | `x'=="GUINéE  CONAKRY" |  `x'=="LA GUINéE"
replace `x'="" if `x'=="LAGUINEE" | `x'=="EN GUINNéE" | `x'=="IAN GUINNEE" |`x'=="GUINN√®E" | `x'=="GUIN√®E"

replace `x'="IVORY COAST" if `x'=="EN C√¥Té D'IVOIRE" |`x'=="EN C√¥TE D'IVOIRE" |`x'=="C√¥Té D 'IVOIRE" |`x'=="COTE D'IVOIRE" |`x'=="ABIDJAN" | `x'=="IVOIRE"| `x'=="C√¥Té DIVOIRE" | `x'=="C√¥Té D'IVOIRE" | `x'=="C√¥Té D'IVOIR" | `x'=="COTE D IVOR" | `x'=="C√¥TE DIVOIR" | `x'=="C√¥TE D'IVOIRE" | `x'==" C√¥TE DIVOIR"

replace `x'="IVORY COAST" if `x'=="C√¥TE  D'IVOIRE" | `x'=="C√?T√? D'IVOIRE" |`x'=="EN C√¥TE IVOIRE" |`x'=="C√¥TE-D'IVOIRE" |`x'=="C√¥TE D'IVOIR" | `x'=="C√¥TE DIVOIRE" | `x'=="C√¥Té D IVOIRE" | `x'=="C√¥Té IVOIRE"
 
replace `x'="UNITED KINGDOM" if `x'=="ROYAUM UNI" | `x'=="ROYAUME-UNI"
*line 44
replace `x'="EGYPT" if `x'=="√?GYPTE" | `x'=="EN √âGYPTE" | `x'=="√âGYPTE" | `x'=="EGYPE" | `x'=="EJIPT" | `x'=="EGYPTE"

replace `x'="BRAZIL" if `x'=="BRASIL" |`x'=="BR√®SIL"| `x'=="BRESIL"| `x'=="BRéSIL" | `x'=="AU BRAZIL"

replace  `x'="GREECE" if `x'=="GR√¢CE" | `x'=="GRECEE" |  `x'=="GRECE" | `x'=="GR√®CE"

replace `x'="QATAR" if `x'=="KATAR" | `x'=="QUATAR"

replace `x'="ALGERIA" if `x'=="ALGERI"|`x'=="ALGER"| `x'=="ALGéRIE" | `x'=="ALGERI"

replace `x'="NIGERIA" if `x'=="LAGOS" | `x'=="NIGéRIA"

replace `x'="JAMAICA" if `x'=="JAMA√ØQUE" |`x'=="LION DU FOUTA JAMAIK"

replace `x'="UNITED ARAB EMIRATES" if `x'=="DOUBA√Ø" |`x'=="DUBA√Ø" | `x'=="DOUBAI" | `x'=="DOUBAYE"

replace `x'="TURKEY" if `x'=="TURQUI" | `x'=="TURQUE" | `x'=="TURKY" | `x'=="TURKI" |`x'=="TURQUIS" | `x'=="TURKIE" | `x'=="TURQUIE" | `x'=="USTANBUL" | `x'=="OUSTANBUL"

replace `x'="INDIA" if `x'=="INDE" |`x'=="INDI"

replace `x'="KOWIET" if `x'=="KOWE√ØT" | `x'=="KOWIET"

replace `x'="JAPAN" if  `x'=="JAPONAIS" | `x'=="JAPON" | `x'=="TOKYO"

replace `x'="ICELAND" if `x'=="ISLANDE"
*line58
replace `x'="VIETNAM" if `x'=="HANO√Ø"

replace `x'="ALGERIA" if `x'=="ALGERIE"

replace `x'="ANGOLA" if `x'=="ANGOLALA" | `x'=="ENGOLA" |`x'=="LUANDA" | `x'=="√Ä LOUANDA" |`x'=="LWOUANDA"

replace `x'="AUSTRIA" if `x'=="AUTRICHE"

replace `x'="MALI" if `x'=="AU MALI" |`x'=="MALI 664334354" 

replace `x'="GABON" if `x'=="AU GABON" | `x'=="GHABON"

replace `x'="DON'T KNOW" if `x'=="JE NE CONNAIS" |`x'=="JE NE CONNAI" | `x'=="JE SAIS PAS" | `x'=="JE NE SAIS PAS"

replace `x'="BURKINA FASSO" if `x'=="BURKINA"

replace `x'="BENIN" if `x'=="COTONOU" | `x'=="BéNIN" | `x'=="BéNIN +223 7539  87"

replace `x'="LIBYA" if `x'=="LIBY" | `x'=="LIBYE" | `x'=="LYBIE" | `x'=="IIBY"
*line68
replace `x'="DRC" if  `x'=="BRAZZAVILLE" | `x'=="CONGO  BRAZZAVILLE" | `x'=="CONGO" | `x'=="ZA√ØR" |`x'=="CONCO" | `x'=="CONGO BRAZZAVILLE"

replace `x'="GAMBIA" if `x'=="GAMBIE"

replace `x'="GHANA" if `x'=="GANAH" |`x'=="ACRA"

replace `x'="SIERRA LEONE" if `x'=="SIERRA LIONNE" | `x'=="SIERRA  LéON" |`x'=="SEIRALEON" | `x'=="SERA LEONNE" | `x'=="SERRA LEONNE" | `x'=="SIERRA-LEONNE" |`x'=="SIERRA LéON" | `x'=="SERRA LéONE" | `x'=="SIERRA LEONNE"| `x'=="LA SIERRA LéONE"

replace `x'="LIBERIA" if `x'=="LIBéRIA" | `x'=="IIBERIA" | `x'=="LIBERIA 00231888989734" |`x'=="LIBERIA 6662678754"

replace `x'="MALAISIA" if `x'=="MALIAISIE" | `x'=="MALAISIE" | `x'=="MALESIE" | `x'=="MALLESIE"

replace `x'="SWITZERLAND" if `x'=="SUISE" |`x'=="SUISSE" | `x'=="LA SUISSE" | `x'=="SUSSE"  | `x'=="GEN√®VE" 

replace `x'="SENEGAL" if `x'=="DIAKAR" | `x'=="SENGAL" |`x'=="SENEGAL 624341513" | `x'=="SENéGAL" | `x'=="SéNEGALE" |`x'=="SéNEGAL" | `x'=="AU SéNéGAL" | `x'=="SEGALE" | `x'=="SéNéGAL  00221 77 918 45" | `x'=="SéNéGAL"|`x'=="SEGAL" | `x'=="SENEGALE" | `x'=="DAKAR"

replace `x'="TUNISIA" if `x'=="TUNISIE"

replace `x'="CAMEROUN" if `x'=="AU CAMEROUN" | `x'=="CAMEROUM"

replace `x'="THAILAND" if `x'=="TAILAND" | `x'=="TAILLAND" | `x'=="THA√ØLANDE"

*line80
replace `x'="GUINEA BISSAU" if `x'=="GUINEE BISSAU" |`x'=="GUINéE BISEAU" | `x'=="GUINéE  BISSAU" | `x'=="BISSAO" | `x'=="GUINEE-BISSAU" |`x'=="GUINéE-BISSAU" | `x'=="GUINéE BISSAU" | `x'=="BISSAU"

replace `x'="NORWAY" if `x'=="NORWAIL" |`x'=="NORV√®GE" | `x'=="NORVEGE"

replace `x'="MALI" if `x'=="BAMAKO"

replace `x'="SWEDEN" if `x'=="SUEDE" | `x'=="SU√®DE"

replace `x'="MAURITANIA" if `x'=="MAURITANIE Q" | `x'=="A MAURITANIE" | `x'=="MAURITANI" | `x'=="A MORRITANI" |`x'=="MORRITANI" | `x'=="MAURITANIE"

replace `x'="IRELAND" if  `x'=="IRLANDE DU NORD" | `x'=="A IRLANDE" | `x'=="IRLANDE"

replace `x'="SOUTH AFRICA" if `x'=="AFRIQUE DU SUD" | `x'=="SUD AFRIQUE"

replace `x'="CHINA" if `x'=="CHINE"

replace `x'="SOUTH KOREA" if `x'=="KOREE DU NORD" | `x'=="CORé" | `x'=="CORéE DU SUD" | `x'=="CORéE"| `x'=="CORéE  DU SUD"| `x'=="CORRé DU SUD" | `x'=="CORé DU SUD"

replace `x'="POLAND" if `x'=="POLOGNE"

*line91
replace `x'="COLOMBIA" if `x'=="COLOMBI"

replace `x'="DENMARK" if `x'=="DANEMARK"

replace `x'="MOSCOW" if  `x'=="MOSCOU"

replace `x'="PHILIPPINES" if `x'=="PHILIPINES" | `x'=="PHILIPPINE"

replace `x'="PORTUGAL" if `x'=="LE PORTUGAL"

replace `x'="CZECK REPUBLIC" if `x'=="TCH√®QUE"

replace `x'="KENYA" if `x'=="NAIROBI"

replace `x'="SOMALIA" if `x'=="SOMALIE"

replace `x'="CYPRUS" if `x'=="CHYPRE"

}



//////////////  SECTION 0 ///////////////// 

replace partb_participation=0 if partb_participation==2


* sec0_q6
replace sec0_q6="" if sec0_q6=="999999999"

*sec0_q6_mail
replace sec0_q6_mail="Don't know" if sec0_q6_mail=="99"

*contact phone number
replace phone_contact1="" if phone_contact1=="999999999"
replace phone_contact2="" if phone_contact2=="999999999"



//////////////  SECTION 2 ///////////////// 

*sec2_q3_other_reasonmig
replace sec2_q3_other_reasonmig="" if sec2_q3_other_reasonmig=="99"


*sec2_q4
gen sec2_q4_bis=sec2_q4
replace sec2_q4_bis=2 if sec2_q1==2
label variable sec2_q4_bis "Are you planning to move permanently to another country in the newt 12 months, or not ? (with no if they do not want to stay permanently in Guinea)"
note sec2_q4_bis : "Are you planning to move permanently to another country in the newt 12 months, or not ? (with no if they do not want to stay permanently in Guinea)"
label values sec2_q4_bis yes_no


*sec2_q9
split sec2_q9
replace sec2_q92="1" if sec2_q92=="janv."
replace sec2_q92="2" if sec2_q92=="févr."
replace sec2_q92="3" if sec2_q92=="mars"
replace sec2_q92="4" if sec2_q92=="avr."
replace sec2_q92="5" if sec2_q92=="mai"
replace sec2_q92="6" if sec2_q92=="juin"
replace sec2_q92="7" if sec2_q92=="juil."
replace sec2_q92="8" if sec2_q92=="ao√ªt"
replace sec2_q92="8" if sec2_q92=="août"
replace sec2_q92="9" if sec2_q92=="sept."
replace sec2_q92="10" if sec2_q92=="oct."
replace sec2_q92="11" if sec2_q92=="nov."
replace sec2_q92="12" if sec2_q92=="déc."

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


//////////////  SECTION 7 ///////////////// 

///French television///
*adding students who do no watch Tv to stuents that do not watch French TV
 gen sec7_q9_bis=sec7_q9
 replace sec7_q9_bis=6 if sec7_q8==6
 label variable sec7_q9_bis "How often do you watch French television ? (including people that do not watch TV)"

 

replace sec10_q1_1="" if sec10_q1_1=="99"
replace sec10_q5_1="" if sec10_q5_1=="99"
replace sec10_q1_2="" if sec10_q1_2=="99"
replace sec10_q5_2="" if sec10_q5_2=="99"


replace sec10_q4_1=. if sec10_q4_1==99
replace sec10_q4_2=. if sec10_q4_1==99



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   4- SAVING THE DATASET                             
***_____________________________________________________________________________
rename id_cto_checked id_number
destring id_number, replace
drop commune lycee_name lycee_name2 deviceid simid subscriberid devicephonenum num_elv treatment school_id id_cto prenom_baseline nom_baseline classe_baseline option_baseline consent_agree check_id num_elv2 participation

# delimit ;
order submissiondate starttime endtime id_number sec0_q6 sec0_q6_fb sec0_q6_mail name_contact1 phone_contact1 name_contact2 phone_contact2 
sec2_q1 sec2_q2 sec2_q3 sec2_q3_1 sec2_q3_2 sec2_q3_3 sec2_q3_4 sec2_q3_5 sec2_q3_6 sec2_q3_7 sec2_q3_other_reasonmig sec2_q4 sec2_q5 sec2_q7 sec2_q7_example sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3 sec2_q8 sec2_q9_month sec2_q9_year sec2_q9 sec2_q10_a sec2_q10_b sec2_q10_c sec2_q11 sec2_q12 sell_asset money_from_asset mig_asset
italy_awareness italy_duration italy_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_die_bef_boat italy_die_boat italy_sent_back 
spain_awareness spain_duration spain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_die_bef_boat spain_die_boat spain_sent_back sec3_21 sec3_22
ceuta_awareness sec3_31 sec3_31_bis
sec3_32 sec3_34 sec3_34_error_millions sec3_34_error_thousands sec3_34_error_millions_2 sec3_34_error_thousands_2 sec3_34_bis sec3_35 sec3_36 sec3_37 sec3_39 sec3_40 sec3_41 sec3_42;

# delimit cr

save "$main/Data/output/midline/questionnaire_midline_clean.dta", replace

