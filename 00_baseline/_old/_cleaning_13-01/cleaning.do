/*Date Created:  December 7, 2018
Date Last Modified: November 28, 2018
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
Uses data: guinea_baseline_csv
Creates data: 
*/


***************************************************************
***********************   REAGIND THE DATA *********************
****************************************************************

clear
set more off 
capture  log  close

global main "C:\Users\cloes_000\Documents\RA-Guinée\Lapa Lapa\logistics\03_data\04_final_data"

import delimited "$main/raw\guinea_baseline_questionnaire_WIDE_from26nov_9dec.csv"

local output "$main/output/questionnaire_baseline_clean.dta"

* fichiers de corrections
local corrfile1 "$main/correction_file/unfinished_questionnaire_1.xlsx" // Les questionnaires non-finalisés 1
local corrfile2 "$main/correction_file/unfinished_questionnaire_2.xlsx" //Les questionnaires non-finalisés 1
local corrfile3 "$main/correction_file/unfinished_questionnaire_3.xlsx" //Les questionnaires non-finalisés 1
local nbcorr 1 2 3




***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   Applique les fichiers de correction                  
***_____________________________________________________________________________

foreach x of local nbcorr {
* apply corrections 
capture confirm file "`corrfile`x''"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile`x''"
	disp

	* save primary data in memory
	preserve

	* load corrections
	import excel using "`corrfile`x''", firstrow clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		*drop notes
		
		* make sure that all values are in string format to start
		gen origvalue=value
		tostring value, format(%100.0g) replace
		cap replace value="" if origvalue==.
		drop origvalue
		replace value=trim(value)
		
		* correct field names to match Stata field names (lowercase, drop -'s and .'s)
		replace fieldname=lower(subinstr(subinstr(fieldname,"-","",.),".","",.))
		
		* format date and date/time fields (taking account of possible wildcards for repeat groups)
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvar in `datetime_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						gen origvalue=value
						replace value=string(clock(value,"DMYhms",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
						* allow for cases where seconds haven't been specified
						replace value=string(clock(origvalue,"DMYhm",2025),"%25.0g") if strmatch(fieldname,"`dtvar'") & value=="." & origvalue~="."
						drop origvalue
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvar in `date_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						replace value=string(clock(value,"DMY",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
					}
				}
			}
		}

		* write out a temp file with the commands necessary to apply each correction
		tempfile tempdo
		file open dofile using "`tempdo'", write replace
		local N = _N
		forvalues i = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local keyval=key[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if key=="`keyval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if key=="`keyval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if key=="`keyval'""' _n
			}
			file write dofile _tab `"if _rc ~= 0 {"' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab _tab `"disp "CAN'T APPLY CORRECTION IN ROW #`rownumval'""' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab `"}"' _n
			file write dofile `"}"' _n
		}
		file close dofile
	
		* restore primary data
		restore
		
		* execute the .do file to actually apply all corrections
		do "`tempdo'"

		* re-save data
		save "`output'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile`x''"
	disp
}

}



//////////////////////////////////////////////////////////////////////////
///////////////////// DELETING THE OBSERVATIONS I SENT ///////////////////
///////////////////       DURING ADAMA'S TRAINING     ////////////////////
//////////////////////////////////////////////////////////////////////////

drop if sec0_q1_a=="Hji"



* groupes de variables
local datetime_fields1 "submissiondate starttime endtime"

local introduction "commune lycee_name sec0_q1_a sec0_q1_b sec0_q2 sec0_q3 sec0_q4 sec0_q5_b sec0_q6 sec0_q6_fb sec0_q6_mail friend_name1 friend_phone1 friend_name2 friend_phone2 "
local family "sec1_1 sec1_2 sec1_3 sec1_5 sec1_6 sec1_7 sec1_8 sec1_9 sec1_10 sec1_12 sec1_13 sec1_14 sec1_15 sister_no brother_no"
local mig_desire "sec2_q1 sec2_q2 sec2_q3 sec2_q3_1 sec2_q3_2 sec2_q3_3 sec2_q3_4 sec2_q3_5 sec2_q3_6 sec2_q3_7 sec2_q3_other_reasonmig sec2_q4 sec2_q5 sec2_q7 sec2_q7_example sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3 sec2_q8 sec2_q9 sec2_q10_a sec2_q10_b sec2_q10_c sec2_q11 "
local italy "sec3_0 sec3_1 sec3_2 sec3_3 sec3_4 sec3_5 sec3_6 sec3_7 sec3_8"
local spain "sec3_10 sec3_11 sec3_12 sec3_14 sec3_15 sec3_16 sec3_17 sec3_18 sec3_19"
local ceuta "sec3_23 sec3_24 sec3_25 sec3_26 sec3_27 sec3_28 sec3_29 sec3_30 sec3_31"
local expectation "sec3_32 sec3_34 sec3_34_error_millions sec3_34_error_thousands sec3_34_error_millions_2 sec3_34_error_thousands_2 sec3_34_bis sec3_35 sec3_37 sec3_38 sec3_39 sec3_40 sec3_41 sec3_42"
local money_quest "sec3_2 sec3_12 sec3_25 sec3_34 sec3_34_bis sec3_42 sec4_q1 sec4_q2 sec4_q3 sec4_q4 sec8_q5 sec8_q6"











***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   Applique les fichiers de correction                  
***_____________________________________________________________________________

foreach x of local nbcorr {
* apply corrections 
capture confirm file "`corrfile`x''"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile`x''"
	disp

	* save primary data in memory
	preserve

	* load corrections
	import excel using "`corrfile`x''", firstrow clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		*drop notes
		
		* make sure that all values are in string format to start
		gen origvalue=value
		tostring value, format(%100.0g) replace
		cap replace value="" if origvalue==.
		drop origvalue
		replace value=trim(value)
		
		* correct field names to match Stata field names (lowercase, drop -'s and .'s)
		replace fieldname=lower(subinstr(subinstr(fieldname,"-","",.),".","",.))
		
		* format date and date/time fields (taking account of possible wildcards for repeat groups)
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvar in `datetime_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						gen origvalue=value
						replace value=string(clock(value,"DMYhms",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
						* allow for cases where seconds haven't been specified
						replace value=string(clock(origvalue,"DMYhm",2025),"%25.0g") if strmatch(fieldname,"`dtvar'") & value=="." & origvalue~="."
						drop origvalue
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvar in `date_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						replace value=string(clock(value,"DMY",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
					}
				}
			}
		}

		* write out a temp file with the commands necessary to apply each correction
		tempfile tempdo
		file open dofile using "`tempdo'", write replace
		local N = _N
		forvalues i = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local keyval=key[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if key=="`keyval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if key=="`keyval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if key=="`keyval'""' _n
			}
			file write dofile _tab `"if _rc ~= 0 {"' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab _tab `"disp "CAN'T APPLY CORRECTION IN ROW #`rownumval'""' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab `"}"' _n
			file write dofile `"}"' _n
		}
		file close dofile
	
		* restore primary data
		restore
		
		* execute the .do file to actually apply all corrections
		do "`tempdo'"

		* re-save data
		save "`output'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile`x''"
	disp
}

}























//////////////////////////////////////////////////////////////////////////
///////////////////// PART 0 : labeling the variable /////////////////////
//////////////////////////////////////////////////////////////////////////


label variable consent_agree "Do you accept to participate in the survey ?"
note consent_agree : "Do you accept to participate in the survey ?"
label define yes_no 1"Yes" 2"No"

//////////////  SECTION 0 ///////////////// 

rename sec0_q1_a first_name
label variable first_name "What is your first name ?"
note  first_name : "What is your first name ?"


rename sec0_q1_b family_name
label variable family_name "What is your family name ?"
note  family_name : "What is your family name ?"


rename sec0_q2 gender
label variable gender "What is your gender ?"
note  gender : "What is your gender ?"
label define gender 1 "Male" 2 "Female"
label values gender gender

rename sec0_q3 birth_date
label variable birth_date "What is your birth date ?"
note  birth_date : "What is your birth date ?"


rename sec0_q4 grade
label variable grade " Which grade are you enrolled in ?"
label define grade 5 "11th grade" 6 "12th grade" 7"13th grade"
label values grade grade
note grade : " Which grade are you enrolled in ? (UK system)"


rename sec0_q5_a option
label variable option "Which speciality did you select ?"
note option : "Which speciality did you select ?"
label define option 1 "Experimental Sciences" 2 "Social Science" 3 "Mathematical Sciences"
label values option option


rename sec0_q5_b section
label variable section "Which section are you enrolled in ?"
note section : "Which section are you enrolled in ?"


rename sec0_q6 phone_number
label variable phone_number "What is your main phone number ?"
note section : "What is your main phone number ?"


rename sec0_q6_fb facebook_yes_no
label variable facebook_yes_no "Do you have a facebook account ?"
note facebook_yes_no : "Do you have a facebook account ?"
label values facebook_yes_no yes_no

rename sec0_q6_mail facebook_mail
label variable facebook_mail "What is the mail adress associated with your facebook account"
note facebook_mail : "What is the mail adress associated with your facebook account"


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


rename sec0_q7 birth_place
label variable birth_place "Where were you born"
note birth_place : "Where were you born"
label define place_short 1 "In Conakry" 2"Outside Conakry, in Guinea" 3 "Outside Guinea, in Africa" 4 "Other"
label values birth_place place_short



rename sec0_q8 living_place
label variable living_place "Where are you currently living ?"
note living_place : "Where are you currently living ?"
label values living_place place_short



/* FOR PREVIOUS VERSION OF THE QUESTIONNAIRE
rename sec0_q9 ever_migrate_after12
label variable "Since turning 12, have you ever lived outside of the city or village you currently reside in for AT LEAST 1 YEAR ? "
note ever_migration_after12 : ""Since turning 12, have you ever lived outside of the city or village you currently reside in for AT LEAST 1 YEAR ? "

*/

rename sec0_q10 religion
label variable religion " What is your religion ?"
note religion : " What is your religion ?"
label define religion 1 "Muslim" 2 "Catholic" 3"Evangelist" 4 "Protestant (not Evangelist)" 5 "Other" 6"None"
label values religion religion


rename sec0_q11 language
label variable language "In addition to French, which language do you speak the most with your family ?"
note language : "In addition to French, which language do you speak the most with your family ?"
label define language 1 "Sousou" 2 "Malinké" 3 "Pular" 4 "Kpele" 5 "Kissi" 6 "Loma" 7 "Baga" 8 "Coniagui" 9 "Other Guinean language" 10 "Other language" 11 "I speak French only"
label values language language


///////////////////////////////////////////
//////////////  SECTION 1 /////////////////
///////////////////////////////////////////

rename sec1_1 no_family_member
label variable no_family_member "What is the total number of people in your household (including yourself) ?"
note no_family_member : "What is the total number of people in your household (including yourself) ?"

rename sec1_2 alive_m
label variable alive_m "Is your mother alive ?"
note alive_m : "Is your mother alive ?"
label values alive_m yes_no


rename sec1_3 place_m
label variable place_m " Where does your mother live ?"
note place_m :  " Where does your mother live ?"
/*we changed the choices starting from the version 1812042013. We grouped 4 to 9 into the category "Other"*/
replace place_m=4 if place_m!=. & place_m!=1 & place_m!=2 & place_m!=3
label values place_m place_short


/* FROM VERSION 1812042013 upwards, we deleted this question"
rename sec1_4 birth_ place_m
label variable place_m " Where was she born ?"
note birth_place_m :  " Where was she born ?"
label define place_long 1 "In Conakry" 2"Outisde Conakry, in Guinea" 3"Outside Guinea, but in Africa" 4"In Europe" 5"In the US" 6"In North America, except for the US" 7"In South America" 8 "In Asia" 9"In Oceania"
*/

rename sec1_5 education_yes_no_m
label variable education_yes_no_m "Has she ever attended school ?"
note education_yes_no_m : "Has she ever attended school ?"
label values education_yes_no_m yes_no


rename sec1_6 education_m
label variable education_m "What is the highest level of education she completed ?"
note education_m : "What is the highest level of education she completed ?"
*incorportating "no formal education" in the level of education"
replace education_m=999 if education_yes_no_m==2
label define education_m 0 "Preschool" 1"Primary" 2"Secondary school"  3"Higher (University, etc.)" 99"Don't know" 999"No education"
label values education_m education_m


rename sec1_7 work_yes_no_m
label variable work_yes_no_m "Has your mother been working over the last 12 months ?"
note work_yes_no_m :"Has your mother been working over the last 12 months ?"
label values work_yes_no_m yes_no


rename sec1_8 occupation_m
label variable occupation_m "Over the last 12 months, what has been her main occupation ?"
note occupation_m : "Over the last 12 months, what has been her main occupation ?"
label define occupation_short  1	"Sales and Services (ex : salesperson/entrepreneur)" 2	"Agriculture (including fishermen, foresters, and hunters)" 3	"Skilled manual worker (ex : machiner operator/carpenter)" 4	"Unskilled manual worker (ex : road construction/assembler)" 5	"Professional/technical/managerial (e.g. engineer/computer assistant/manager/nurse)" 6	"Clerical (ex : secretary)" 7	"Military/Paramilitary" 8	"Domestic service for another house (e.g. housekeeper)" 99	"Don't know"
label values occupation_m occupation_short




rename sec1_9 alive_f
label variable alive_f "Is your father alive ?"
note alive_f : "Is your father alive ?"
label values alive_f yes_no


rename sec1_10 place_f
label variable place_f " Where does your father live ?"
note place_f :  " Where does your father live ?"
/*we changed the choices starting from the version 1812042013. We grouped 4 to 9 into the category "Other"*/
replace place_f=4 if place_f!=. & place_f!=1 & place_f!=2 & place_f!=3
label values place_f place_short


/* FROM VERSION 1812042013 upwards, we deleted this question"
rename sec1_11 birth_ place_f
label variable place_f " Where was she born ?"
note birth_place_f :  " Where was she born ?"
label define place_long 1 "In Conakry" 2"Outisde Conakry, in Guinea" 3"Outside Guinea, but in Africa" 4"In Europe" 5"In the US" 6"In North America, except for the US" 7"In South America" 8 "In Asia" 9"In Oceania"
*/

rename sec1_12 education_yes_no_f
label variable education_yes_no_f "Has she ever attended school ?"
note education_yes_no_f : "Has she ever attended school ?"
label values education_yes_no_f yes_no


rename sec1_13 education_f
label variable education_f "What is the highest level of education she completed ?"
note education_f : "What is the highest level of education she completed ?"
*incorportating "no formal education" in the level of education"
replace education_f=999 if education_yes_no_f==2
label define education_f 0 "Preschool" 1"Primary" 2"Secondary school"  3"Higher (University, etc.)" 99"Don't know" 999"No education"
label values education_f education_f


rename sec1_14 work_yes_no_f
label variable work_yes_no_f "Has your father been working over the last 12 months ?"
note work_yes_no_f :"Has your father been working over the last 12 months ?"
*incorporation "no" if father is not alive
label values work_yes_no_f yes_no

rename sec1_15 occupation_f
label variable occupation_f "Over the last 12 months, what has been her main occupation ?"
note occupation_f : "Over the last 12 months, what has been her main occupation ?"
label values occupation_f occupation_short


label variable sister_no "How many sisters do you have ?"
note sister_no : "How many sisters do you have ?"

/* for version previous to 1812042013
rename sec1_16 older_sister_no
label variable older_sister_no "How many older sisters do you have ?"
note older_sister_no : "How many older sisters do you have ?"
rename sec1_17 older_brother_no
label variable older_brother_no "How many older brothers do you have ?"
note older_brother_no : "How many older brothers do you have ?"
*/
label variable brother_no "How many brothers do you have ?"
note brother_no : "How many brothers do you have ?"




///////////////////////////////////////////
//////////////  SECTION 2 /////////////////
///////////////////////////////////////////

rename sec2_q1 mig_desire
label variable mig_desire "Ideally, if you had the opportunity, would you like to move permanently to another country or would you like to continue living in Guinea?"
note mig_desire : "Ideally, if you had the opportunity, would you like to move permanently to another country or would you like to continue living in Guinea?"
label define mig_desire 1	"Yes, I would like to move permanently to another country." 2	"No, I would like to continue living in Guinea."
label values mig_desire mig_desire

rename sec2_q2 mig_ideal_country
label variable mig_ideal_country "If you could go anywhere in the world, which country would you like to live in ? "
note mig_ideal_country : "If you could go anywhere in the world, which country would you like to live in ? "


rename sec2_q3 mig_reason
label variable mig_reason "Why would you like to move permanently to another country? "
note mig_reason : "Why would you like to move permanently to another country? "

rename sec2_q3_1 mig_reason_studies
label variable mig_reason_studies "I want to migrate to continue your studies ?"
note mig_reason_studies : "I want to migrate to continue to continue your studies ? (dummy created with mig_reason)"
label define yes_no_bis 1 "Yes" 2"No"
label values mig_reason_studies yes_no_bis

rename sec2_q3_2 mig_reason_eco
label variable mig_reason_eco "I want to migrate for economic reasons ?"
note mig_reason_eco : " I want to migrate for for economic reasons ? (dummy created with mig_reason)"
label values mig_reason_eco yes_no_bis

rename sec2_q3_3 mig_reason_family
label variable mig_reason_family "I want to migrate for family reasons ? (to join a relative abroad etc.)"
note mig_reason_family : " I want to migrate for economic reasons ? (dummy created with mig_reason)"
label values mig_reason_family yes_no_bis

rename sec2_q3_4 mig_reason_conflict
label variable mig_reason_conflict "I want to migrate because my area is affected by war/conflict ? (dummy created with mig_reason)"
note mig_reason_conflict: "I want to migrate because my area is affected by war/conflict ? (dummy created with mig_reason)"
label values mig_reason_conflict yes_no_bis

rename sec2_q3_5 mig_reason_persecution
label variable mig_reason_persecution "I want to migrate because I am or could be the victim of violence or persecution ? (dummy created with mig_reason)"
note mig_reason_persecution: "I want to migrate because I am or could be the victim of violence or persecution ?  ? (dummy created with mig_reason)"
label values mig_reason_persecution yes_no_bis

rename sec2_q3_6 mig_reason_climat
label variable mig_reason_climat "Do you want to migrate because region has been affected by extreme climatic events ? (dummy created with mig_reason)"
note mig_reason_climat :" Do we change the question ? Do you want to migrate because region has been affected by extreme climatic events ? (dummy created with mig_reason)"
label values mig_reason_climat yes_no_bis

rename sec2_q3_7 mig_reason_other_yes_no
label variable mig_reason_other_yes_no "Do you want to migrate for other reasons ? (dummy created with mig_reason)"
note mig_reason_other_yes_no :" Do we change the question ? Do you want to migrate for other reasons ? (dummy created with mig_reason)"
label values mig_reason_climat yes_no_bis


rename sec2_q3_other_reasonmig mig_reason_other
label variable mig_reason_other " Could you specify the other reason why you want to migrate to another country ?"
note mig_reason_other : " Could you specify the other reason why you want to migrate to another country ?"


rename sec2_q4 migration_next_year
label variable migration_next_year "Are you planning to move permanently to another country in the next 12 months, or not?"
note migration_next_year : "Are you planning to move permanently to another country in the next 12 months, or not?"
label values migration_next_year yes_no

rename sec2_q5 mig_next_year_country
label variable mig_next_year_country "Which country are you planning to move to?"
note mig_next_year_country : "Which country are you planning to move to?"

rename sec2_q7 mig_preparation_yes_no
label variable mig_preparation_yes_no " Have you made any preparations for this move?"
note mig_preparation_yes_no : " Have you made any preparations for this move?"
label values mig_preparation_yes_no yes_no

rename sec2_q7_example_1 mig_preparation_type_1
label variable mig_preparation_type_1 "I am saving money to prepare my trip" 
note mig_preparation_type_1 : "I am saving money to prepare my trip" 

rename sec2_q7_example_2 mig_preparation_type_2
label variable mig_preparation_type_2 "I have contacted someone I know who is living in the country where I want to go." 
note mig_preparation_type_2 : "I have contacted someone I know who is living in the country where I want to go." 

rename sec2_q7_example_3 mig_preparation_type_3
label variable mig_preparation_type_3 "I made some of my relatives aware of my desire to migrate."
note mig_preparation_type_3 : "I made some of my relatives aware of my desire to migrate."

rename sec2_q8 mig_date_yes_no
label variable mig_date_yes_no "Did you plan a date to migrate?"
note mig_date_yes_no :  "Did you plan a date to migrate?"
label values mig_date_yes_no yes_no

rename sec2_q9	mig_date
label variable mig_date "In which month/year are you planning to leave Guinea?"
note mig_date : "In which month/year are you planning to leave Guinea?"

rename sec2_q10_a mig_visa_next_year
label variable  mig_visa_next_year "Did you already applied to get a visa to enter in this country during the next 12 months ?"
note mig_visa_next_year : "Did you already applied to get a visa to enter in this country during the next 12 months ?"

rename sec2_q10_b mig_visa_a
label variable  mig_visa_a "Do you believe that you will applied for getting a visa in order to migrate to this country ?"
note mig_visa_a : "For people who do not want migrate in the next 12 months : Do you believe that you will applied for getting a visa in order to migrate to this country ?"

rename sec2_q10_c mig_visa_b
label variable  mig_visa_b "Do you believe that you will applied for getting a visa in order to migrate to this country ?"
note mig_visa_b : "For people who want migrate in the next 12 months : Do you believe that you will applied for getting a visa in order to migrate to this country ?"


rename sec2_q11 mig_discussion
label variable mig_discussion "Did you discuss about migration with your friends or siblings over last week ?"
note mig_discussion : "Did you discuss about migration with your friends or siblings over last week ?"
label values mig_discussion yes_no

rename sec2_q12 spillover_yes_no
label variable spillover_yes_no "Over last week, did you discuss about migration with students enrolled in other high school than yours ? "
note spillover_yes_no : "Over last week, did you discuss about migration with students enrolled in other high school than yours ? "
label values spillover_yes_no yes_no

rename sec2_q13 spillover_HS_1
label variable spillover_HS_1 "Name of the 1srt high school"
note spillover_HS_1 : "Name of the 1srt high school (99=none)"

rename sec2_q14 spillover_HS_2
label variable spillover_HS_2 "Name of the 1srt high school"
note spillover_HS_2 : "Name of the 2nd high school (99=none)"

rename sec2_q15 spillover_HS_3
label variable spillover_HS_3 "Name of the 1srt high school"
note spillover_HS_3 : "Name of the 2nd high school (99=none)"


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



///////////////// MIGRATION ///////////////////
drop unique_draws upper_bound num_draws random_* scaled*


/*correcting the coding error in questionnaire version 1811251456. the name of the country specified when students answered "other" did not appear in the following questions...*/
replace sec3_21=sec3_21_nb_other if formdef_version==1811251456 & sec3_21_nb_other!=""
rename sec3_21 mig_choice_eu_cty
label variable mig_choice_eu_cty "Consider one Guinean person who is EXACTLY LIKE YOU. Suppose he or she has to choose his or her way to migrate to Europe from Guinea. Which EUROPEAN COUNTRY would he/she plan to settle in ?"
note mig_choice_eu_cty : "Which EUROPEAN COUNTRY would he/she plan to settle in ?"


label variable sec3_21_nb_other "Please, specify the other EUROPEAN COUNTRY, he/she would plan to settle in ?"


rename sec3_22 italy_spain_boat
label variable	italy_spain_boat "Between the two roads we have just described, which road would he/she select to go to in ${sec3_21}?"
note italy_spain_boat : "Between the two roads we have just described, which road would he/she select to go to in ${sec3_21}?"
label define select_2_road 1 " This person would first reach North Africa shore and then take a boat to ITALY." 2 "This person would first reach North Africa shore and then take a boat to Ceuta or Melilla."
label values italy_spain_boat select_2_road




/////////////////Ceuta or Melila //////////////////
/////////// note : if they know Ceuta /////////


rename sec3_23 Ceuta_awareness
label variable Ceuta_awareness "Have ever heard about a road that allows people to go to Europe by climbing over the fence of Ceuta or Melilla ?"
note Ceuta_awareness : "Have ever heard about a road that allows people to go to Europe by climbing over the fence of Ceuta or Melilla ?"
label values Ceuta_awareness aware



rename sec3_24 Ceuta_duration
label variable  Ceuta_duration "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"
note Ceuta_duration : "In average, how long would it take them to arrive in Europe from Guinea ? (in months)"


rename sec3_25 Ceuta_cost
label variable  Ceuta_cost "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"
note Ceuta_cost : "How much money would those people need to pay for their WHOLE JOURNEY from Guinea ? (in Guinean Francs)"


rename sec3_26 Ceuta_beaten
label variable Ceuta_beaten "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"
note Ceuta_beaten : "Among those 100 people, how many of them will be beaten or physically abused during the travel ?"

rename sec3_27 Ceuta_forced_work
label variable Ceuta_forced_work "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"
note Ceuta_forced_work : "Among those 100 people, how many of them will be urged to work or will work without being paid during the travel ?"

rename sec3_28 Ceuta_kidnapped
label variable Ceuta_kidnapped "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"
note Ceuta_kidnapped : "Among those 100 people, how many of them will be kept against their will (put in jail or kidnapped) during the travel ?"


rename sec3_29 Ceuta_die_bef_boat
label variable Ceuta_die_bef_boat "Among those 100 people who left Guinea, how many of them will DIE BEFORE arriving in Europe ?"
note Ceuta_die_bef_boat : "Among those 100 people who left Guinea, how many of them will DIE BEFORE arriving in Europe ?"

rename sec3_30 Ceuta_die
label variable Ceuta_die "Among those 100 people who left Guinea, how many of them will arrive in Europe ?"
note Ceuta_die : "Among those 100 people who left Guinea, how many of them will arrive in Europe ?"


rename sec3_31 Ceuta_sent_back
label variable Ceuta_sent_back "Now, imagine that 100 Guinean people exactly like you arrive in Ceuta or Melilla over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"
note Ceuta_sent_back :  "Now, imagine that 100 Guinean people exactly like you arrive in Ceuta or Melilla over next year. How many of them will be sent back to Guinea 1 year after their arrival ?"



rename sec3_31_bis italy_spain_ceuta
label variable	italy_spain_ceuta "Between the three roads we have just described, which road would he/she select to go to in ${sec3_21} ?"
note italy_spain_ceuta : "If you know Ceuta, Between the three roads we have just described, which road would he/she select to go to in ${sec3_21} ?"
label define select_3_road 1 " This person would first reach North Africa shore and then take a boat to ITALY." 2 "This person would first reach North Africa shore and then take a boat to Ceuta or Melilla." 3 "This person would first reach North Africa shore and then climb over the fence of CEUTA or MELILLA."
label values italy_spain_ceuta select_3_road


rename sec3_32 expectation_job
label variable expectation_job "Among those 100 people who are like you, how many of them will find a job in ${sec3_21}, if this is what they want ?"
note expectation_job : "Consider 100 Guinean people who are EXACTLY LIKE YOU and who manage to arrive in ${sec3_21} over next year. Each of them arrived in Europe following the road that depart from Guinea following your prefered road. Among those 100 people who are like you, how many of them will find a job in ${sec3_21}, if this is what they want ?"


rename sec3_34 expectation_wage
label variable expectation_wage "Thanks to their work in ${sec3_21}, how much would each of these ${sec3_32} people earn on average PER MONTH ? Please, write the amount converted in Guinean Francs."
note expectation_wage : "Thanks to their work in ${sec3_21}, how much would each of these ${sec3_32} people earn on average PER MONTH ? Please, write the amount converted in Guinean Francs."


label variable sec3_34_error_millions_2	"You mean that on average, the wage of those people who work in ${sec3_21} would reach ${sec3_34_error_millions} GF per month ?"
note sec3_34_error_millions_2 : "If the amount is less than 100 : You mean that on average, the wage of those people who work in ${sec3_21} would reach ${sec3_34_error_millions} GF per month ?"
label values sec3_34_error_millions_2 yes_no


label variable sec3_34_error_thousands_2	"You mean that on average, the wage of those people who work in ${sec3_21} would reach ${sec3_34_error_thousands} GF per month ?"
note sec3_34_error_thousands_2 : "If the amount is less between 99 and 99999 : You mean that on average, the wage of those people who work in ${sec3_21} would reach ${sec3_34_error_thousands} GF per month ?"
label values sec3_34_error_thousands_2 yes_no


rename sec3_34_bis expectation_wage_bis
label variable expectation_wage_bis " Could you please, re-write what would be on average the monthly wage of those ${sec3_32} people who work in ${sec3_21} ?"
note expectation_wage_bis : "Could you please, re-write what would be on average the monthly wage of those ${sec3_32} people who work in ${sec3_21} ?"

rename sec3_35 expectation_studies
label variable expectation_studies "Among those 100 people who arrived in ${sec3_21}, how many of them will continue their studies in ${sec3_21} ?"
note expectation_studies : "Among those 100 people who arrived in ${sec3_21}, how many of them will continue their studies in ${sec3_21} ?"


rename sec3_36 expectation_citizenship
label variable expectation_citizenship "Among those 100 who arrived in ${sec3_21}, how many of them would become a citizen of this country ?"
note expectation_citizenship : "Among those 100 who arrived in ${sec3_21}, how many of them would become a citizen of this country ?"

rename sec3_37 expected_back_5yr
label variable expected_back_5yr "Among those 100 people who arrived in ${sec3_21}, how many of them would permanently return to Guinea within 5 years after their arrival in ${sec3_21} ?"
note expected_back_5yr : "Among those 100 people who arrived in ${sec3_21}, how many of them would permanently return to Guinea within 5 years after their arrival in ${sec3_21} ?"

rename sec3_38 expectation_shelter
label  variable expectation_shelter "Among those 100 people who arrived in ${sec3_21}, how many of them would be offered a bed, from the government of ${sec3_21}, in a shelter at their arrival ?"
note expectation_shelter : "Among those 100 people who arrived in ${sec3_21}, how many of them would be offered a bed, from the government of ${sec3_21}, in a shelter at their arrival ?"

rename sec3_39 expectation_gov_help
label  variable expectation_gov_help "Among these 100 people who arrived in ${sec3_21}, how many of them will receive money from the GOVERNMENT of ${sec3_21}  over year after their arrival ?"
note expectation_gov_help : "Among these 100 peopls who arrived in ${sec3_21}, how many of them will receive money from the GOVERNMENT of ${sec3_21}  over year after their arrival ?"

rename sec3_40 expectation_asylum
label  variable expectation_asylum "Imagine that 100 Guinean people, who are exactly like you, applied for asylum in${sec3_21} for the first time. According to you, how many of them would you expect to be given a positive response ?"
note expectation_asylum : "Imagine that 100 Guinean people, who are exactly like you, applied for asylum in${sec3_21} for the first time. According to you, how many of them would you expect to be given a positive response ?"


rename sec3_41 expectation_in_favor_mig
label  variable expectation_in_favor_mig "Now consider 100 citizens of ${sec3_21}. In your opinion, among these 100 citizens of ${sec3_21}, how many of them are in favor of immigration ?"
note expectation_in_favor_mig : "Now consider 100 citizens of ${sec3_21}. In your opinion, among these 100 citizens of ${sec3_21}, how many of them are in favor of immigration ?"


rename sec3_42 expected_change_living_cost
label variable expected_change_living_cost "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in ${sec3_21} in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."
note expected_change_living_cost : "Consider one person who is living alone in Conakry. This person spends 1 000 000 GF PER MONTH to cover all his/her expenses (rent, food, transport, etc.). How much should this person spend to live THE SAME WAY in ${sec3_21} in GUINEAN FRANCS. We suppose that his/her consumptions (rent, food, transport, etc.) remain the same."



///////////////////////////////////////////
//////////////  SECTION 4 /////////////////
///////////////////////////////////////////

rename sec4_q1 price_onion
label variable price_onion "In your opinion, what is the price of 1kg of onion in ${sec3_21} in Guinean Francs ?"
note price_onion : "In your opinion, what is the price of 1kg of onion ?"

rename sec4_q2 price_chicken
label variable price_chicken "In your opinion, what is the price of 1kg of chicken in ${sec3_21} in Guinean Francs ?"
note price_chicken : "In your opinion, what is the price of 1kg of chicken in ${sec3_21} in Guinean Francs ?"

rename sec4_q3 price_gas
label variable price_gas "In your opinion, what is the price of a liter of gasoline in ${sec3_21} in Guinean Francs ?"
note price_gas : "In your opinion, what is the price of a liter of gasoline in ${sec3_21} in Guinean Francs ?"

rename sec4_q4 price_paracetamol
label variable price_paracetamol "In your opinion, what is the price of 1 box of 10 Doliprane tablets in ${sec3_21} in Guinean Francs ?"
note price_paracetamol : "In your opinion, what is the price of 1 box of 10 Doliprane tablets in ${sec3_21} in Guinean Francs?"



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
label define conso  1	"I did not spend money" 2	"Les than 10 000 FG" 3	"Between 10 000 and 50 000 FG" 4	"Between 50 000 and 100 000 FG" 5	"Between 100 000 and 200 000 FG" 6	"More than 200 000 FG"
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











/* cleaning */
replace phone_number=. if phone_number==999999999


replace facebook_mail="je ne sais pas" if facebook_mail=="99"


replace sec10_q1_1="" if sec10_q1_1=="99"
replace sec10_q5_1="" if sec10_q5_1=="99"
replace sec10_q1_2="" if sec10_q1_2=="99"
replace sec10_q5_2="" if sec10_q5_2=="99"


/* cleaning ideal mig country */
replace mig_ideal_country=upper(mig_ideal_country)

replace mig_ideal_country="FRANCE" if mig_ideal_country=="FRANÃ§E" |  mig_ideal_country=="IA FRANCE" |mig_ideal_country=="LA FRANÃ§E" | mig_ideal_country=="FRANÃ§AIS" | mig_ideal_country=="A PARIS" | mig_ideal_country=="EN FRANCE" | mig_ideal_country=="FRANÃ§AIS"| mig_ideal_country=="LA FRANCE" | mig_ideal_country=="FRANCE " | mig_ideal_country==" FRANCE " | mig_ideal_country=="EN FRANCE, BANQUE" | mig_ideal_country=="EN FRANCS" | mig_ideal_country=="EN FRANÃ§E" | mig_ideal_country=="PARI" | mig_ideal_country=="PARIS" | mig_ideal_country=="PARIE"

replace mig_ideal_country="CANADA" if  mig_ideal_country=="AU CANADAT" | mig_ideal_country=="AU CANADA" | mig_ideal_country=="GANADA" | mig_ideal_country=="AU CANADA " | mig_ideal_country=="KANADA" | mig_ideal_country=="LE CANADA" | mig_ideal_country=="CANADA " | mig_ideal_country==" CANADA " | mig_ideal_country=="En AmÃ©rique  (Canada)" |mig_ideal_country=="Ã? CANADA"

replace mig_ideal_country="ALLEMAGNE" if mig_ideal_country=="ALLEMANGNE" 

replace mig_ideal_country="ETATS UNIS" if mig_ideal_country=="USA" | mig_ideal_country=="LES USA" |  mig_ideal_country=="LOS ANGELES" | mig_ideal_country=="AU USA" | mig_ideal_country=="Ã?TATS UNIS D'AMÃ©RIQUE"| mig_ideal_country=="AUX U .S. A (EN AMÃ©RIQUE )" | mig_ideal_country==" AUX U .S. A (EN AMÃ©RIQUE ) " | mig_ideal_country=="Ã?TAS UNIS D'AMÃ©RIQUE" | mig_ideal_country=="Etats_Unis" | mig_ideal_country=="Au U.S.A" | mig_ideal_country=="Ã?TATS-UNIS" | mig_ideal_country=="Ã?TATS UNIS" | mig_ideal_country==" Ã?TATS UNIS D'AMÃ©RIQUE" | mig_ideal_country=="Ã?TAT UNIS D'AMÃ?RIQUE" | mig_ideal_country=="Ã?TAT UNIS" | mig_ideal_country=="Ã?TAT  UNIS D AMÃ©RIQUE"| mig_ideal_country==" Ã?TAS UNIS D'AMÃ©RIQUE"| mig_ideal_country=="USA D'AMERIQUE"| mig_ideal_country=="USA AMERIQUE"| mig_ideal_country=="U.S.A" | mig_ideal_country=="ETAT-UNIS UNIS" | mig_ideal_country=="ETATS UNIS D'AMÃ©RIQUE" | mig_ideal_country=="ETATS-UNIS" | mig_ideal_country=="EUAMÃ©RIQUE"


replace mig_ideal_country="ESPAGNE" if  mig_ideal_country=="EN ESPAGNE" | mig_ideal_country=="ESPANE"


replace mig_ideal_country="BELGIQUE" if mig_ideal_country=="EN BELGIQUE" | mig_ideal_country=="LA BELGIQUE"


replace mig_ideal_country="ANGLETERRE" if  mig_ideal_country=="ENGLETTERE"  | mig_ideal_country=="L'ANGLETERRE" | mig_ideal_country=="ANGLETAIRE" | mig_ideal_country=="EN ANGLETERRE" | mig_ideal_country=="ENGLETERRE" | mig_ideal_country=="ENGLETTERRE" | mig_ideal_country=="LONDRE" | mig_ideal_country=="LONDRE"


replace mig_ideal_country="AMERIQUE" if mig_ideal_country=="L'AMÃ©RIQUE" | mig_ideal_country=="AMERIC" | mig_ideal_country=="EN AMERIQUE" | mig_ideal_country=="AMERIQEU"| mig_ideal_country=="AMÃ©RIQUE" | mig_ideal_country==" EN AMERIQUE" | mig_ideal_country=="EN AMÃ©RIQUE" | mig_ideal_country=="L' AMERIQUE"| mig_ideal_country=="L' AMÃ©RIQUE"| mig_ideal_country=="L'AMERIQUE"| mig_ideal_country==" L'AMÃ©RIQUE"


replace mig_ideal_country="ITALIE" if mig_ideal_country=="ITALI"


replace  mig_ideal_country="RUSSIE" if mig_ideal_country=="LA RUSSIE"

replace mig_ideal_country="EUROPE" if mig_ideal_country=="EN EUROPE" | mig_ideal_country=="L'EUROPE" | mig_ideal_country=="LÃ? L'EUROPE" | mig_ideal_country=="IEUROPE" | mig_ideal_country=="EROPE"







