/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (G.Battiston,  L. Corno, E. La Ferrara)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :      03 - CORRECTION SURVEYS CTO
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*
03_correction_surveys_CTO.do
Date Created:  May 7, 2020
Date Last Modified: June 5, 2020
Created by: Laïla SOUALI
Last modified by: Laïla SOUALI
*	Inputs: .dta files 
	"Data\dta\guinea_endline_lycee_raw.dta" 
	"Data\dta\guinea_endline_phone_raw.dta
*	Outputs: 
	"Data\output\followup2\intermediaire\guinea_endline_lycee_corrected.dta"
	"Data\output\followup2\intermediaire\guinea_endline_phone_corrected.dta"


Outline :
- 1 - School Survey
	1.1 - Correction of students entered under a wrong school
	1.2 - Correction of studenteds entered under a wrong ID within the right school
	1.3 - Students with unclear status on the files
	1.4 - Droping surveys when consent was "no"
	1.5 - Survey cut in two by SurveyCTO
	1.6 - Unfinished questionnaire
	1.7 - Missing question (job) in the first 8 schools
	1.8 - Droping duplicates and extra surveys
- 2 - Phone Survey
	2.1 - Duplicates
	2.2 - Other mismatches
	2.3 - Drop duplicates
- 3 - Saving	

*/

* initialize Stata
clear all
set more off

*user: Laïla
global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

/////////////////////////////////////////////////////////////////////////////
/////////      			 1- SCHOOL SURVEY					/////////////////
/////////////////////////////////////////////////////////////////////////////

use ${main}\Data\dta\guinea_endline_lycee_raw

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.1 - CORRECTION OF STUDENTS ENTERED UNDER A WRONG SCHOOL
***_____________________________________________________________________________

*use ${main}\data\guinea_endline_lycee

*creating a variable to keep track of the corrections: rematch=1 if the school survey was corrected
gen rematch="."

*VARIABLES TO CORRECT
*commune lycee_name lycee_name2 treatment school_id id_cto 
*prenom_baseline nom_baseline classe_baseline option_baseline 
*id_cto_checked participation
destring treatment, replace
destring school_id, replace
destring id_cto, replace
destring participation, replace

*12 students to correct for Saint Denis 2 (Nelson Mandela Simbaya)

*1 -> 0 change made
replace commune="RATOMA" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace lycee_name="SAINT DENIS 2" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace treatment=1 if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace school_id=915197 if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace id_cto=9151971 if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace prenom_baseline="kadiatou issatou" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace nom_baseline="barry" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace classe_baseline="11" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace option_baseline="SE" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace id_cto_checked="9151971" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"
replace participation=0 if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"

replace rematch="1" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"

*2
replace commune="RATOMA" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace lycee_name="SAINT DENIS 2" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace treatment=1 if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace school_id=915197 if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace id_cto=9151972 if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"

replace prenom_baseline="rouguiatou sow" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace nom_baseline="rouguiatou sow" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace classe_baseline="11" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace option_baseline="SE" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace id_cto_checked="9151972" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"
replace participation=0 if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"

replace rematch="1" if key=="uuid:c028c97d-b120-46c6-a347-d5f404ca2f84"

*5
replace commune="RATOMA" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace lycee_name="SAINT DENIS 2" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace treatment=1 if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace school_id=915197 if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace id_cto=9151975 if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"

replace prenom_baseline="djenabou" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace nom_baseline="balde" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace classe_baseline="11" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace option_baseline="SE" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace id_cto_checked="9151975" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"
replace participation=0 if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"

replace rematch="1" if key=="uuid:623ac3d1-35c1-42cd-b1b9-09d18fc4dacf"


*6
replace commune="RATOMA" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace lycee_name="SAINT DENIS 2" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace treatment=1 if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace school_id=915197 if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace id_cto=9151976 if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"

replace prenom_baseline="mamadou" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace nom_baseline="bah" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace classe_baseline="11" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace option_baseline="SS" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace id_cto_checked="9151976" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"
replace participation=0 if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"

replace rematch="1" if key=="uuid:5eb268ba-37be-40ae-b31e-95740418353c"

*7
replace commune="RATOMA" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace lycee_name="SAINT DENIS 2" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace treatment=1 if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace school_id=915197 if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace id_cto=9151977 if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"

replace prenom_baseline="mamadou hady" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace nom_baseline="bah" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace classe_baseline="11" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace option_baseline="SS" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace id_cto_checked="9151977" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"
replace participation=0 if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"

replace rematch="1" if key=="uuid:7688d8e4-23e3-4592-8cf5-3c891d734d37"

*8
replace commune="RATOMA" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace lycee_name="SAINT DENIS 2" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace treatment=1 if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace school_id=915197 if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace id_cto=9151978 if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"

replace prenom_baseline="mohamed" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace nom_baseline="mara" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace classe_baseline="11" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace option_baseline="SS" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace id_cto_checked="9151978" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"
replace participation=0 if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"

replace rematch="1" if key=="uuid:795c5062-bbb8-4358-b4de-7cc43f438336"

*12
replace commune="RATOMA" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace lycee_name="SAINT DENIS 2" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace treatment=1 if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace school_id=915197 if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace id_cto=91519712 if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"

replace prenom_baseline="amadou bailo" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace nom_baseline="diallo" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace classe_baseline="11" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace option_baseline="SM" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace id_cto_checked="91519712" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"
replace participation=0 if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"

replace rematch="1" if key=="uuid:ffcde8f1-8b9f-4e97-8c80-50a5cc495a1c"

*13
replace commune="RATOMA" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace lycee_name="SAINT DENIS 2" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace treatment=1 if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace school_id=915197 if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace id_cto=91519713 if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"

replace prenom_baseline="thierno demand" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace nom_baseline="diallo" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace classe_baseline="11" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace option_baseline="SM" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace id_cto_checked="91519713" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"
replace participation=0 if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"

replace rematch="1" if key=="uuid:3181e6f2-a57b-49f5-b0e3-6ccd965e23dd"

*14 
replace commune="RATOMA" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace lycee_name="SAINT DENIS 2" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace treatment=1 if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace school_id=915197 if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace id_cto=91519714 if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"

replace prenom_baseline="sow mamadou alpha" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace nom_baseline="sow" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace classe_baseline="11" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace option_baseline="SM" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace id_cto_checked="91519714" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"
replace participation=0 if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"

replace rematch="1" if key=="uuid:fdc0ed3f-e124-4a55-bf83-e9cae5452bb7"

*16
replace commune="RATOMA" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace lycee_name="SAINT DENIS 2" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace treatment=1 if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace school_id=915197 if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace id_cto=91519716 if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"

replace prenom_baseline="tolno helene sia" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace nom_baseline="tolno" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace classe_baseline="11" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace option_baseline="SM" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace id_cto_checked="91519716" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"
replace participation=0 if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"

replace rematch="1" if key=="uuid:c6b4ab0d-cffc-4f07-814c-3dcac3e9e776"

*17 -> 0 change made
replace commune="RATOMA" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace lycee_name="SAINT DENIS 2" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace treatment=1 if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace school_id=915197 if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace id_cto=91519717 if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"

replace prenom_baseline="amadou sadjo" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace nom_baseline="diallo" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace classe_baseline="11" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace option_baseline="SM" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace id_cto_checked="91519717" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"
replace participation=0 if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"

replace rematch="1" if key=="uuid:a683fe14-7c0f-4ae5-8907-aac66f89a1b5"

*39
replace commune="RATOMA" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace lycee_name="SAINT DENIS 2" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace lycee_name2="SAINT DENIS 2" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace treatment=1 if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace school_id=915197 if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace id_cto=91519739 if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"

replace prenom_baseline="djienabou barry" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace nom_baseline="barry" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace classe_baseline="T" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace option_baseline="SS" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace id_cto_checked="91519739" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"
replace participation=0 if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"

replace rematch="1" if key=="uuid:4a95ba06-496e-4814-a38f-366d629368fc"

***14 students to correct for Noumandian Keita (Abdoulaye Sangareah/Nelson Mandela Simbaya))
*2, 5, 6, 10, 11, 13, 16, 18, 19, 22, 26, 27, 30, 31, 33

*2: 17-Feb-2020 07:18:48 /17-Feb-2020 08:13:48/	ABDOULAYE SANGAREAH	/2/9153282
replace commune="RATOMA" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace treatment=1 if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace school_id=915046 if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace id_cto=9150462 if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"

replace prenom_baseline="elhadj sadou" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace nom_baseline="balde" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace classe_baseline="11" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace option_baseline="SE" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace id_cto_checked="9150462" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"
replace participation=0 if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"

replace rematch="1" if key=="uuid:adc51c31-fc5b-4bde-af51-679c0d8eb1cb"

*5
replace commune="RATOMA" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace treatment=1 if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace school_id=915046 if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace id_cto=9150465 if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"

replace prenom_baseline="mamy edith" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace nom_baseline="mamy" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace classe_baseline="11" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace option_baseline="SE" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace id_cto_checked="9150465" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"
replace participation=0 if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"

replace rematch="1" if key=="uuid:2682ea58-d975-4a87-9e3e-81edd8f10176"

*6
replace commune="RATOMA" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace treatment=1 if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace school_id=915046 if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace id_cto=9150466 if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"

replace prenom_baseline="camara" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace nom_baseline="salematou" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace classe_baseline="11" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace option_baseline="SE" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace id_cto_checked="9150466" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"
replace participation=0 if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"

replace rematch="1" if key=="uuid:1b0bda1d-26a8-4055-acbe-611472b5c553"

*10
replace commune="RATOMA" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace treatment=1 if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace school_id=915046 if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace id_cto=91504610 if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"

replace prenom_baseline="mouctar" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace nom_baseline="sylla" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace classe_baseline="11" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace option_baseline="SS" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace id_cto_checked="91504610" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"
replace participation=0 if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"

replace rematch="1" if key=="uuid:6a814677-78ce-4233-823b-7058e0ec148d"

*11
replace commune="RATOMA" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace treatment=1 if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace school_id=915046 if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace id_cto=91504611 if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"

replace prenom_baseline="kemoko" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace nom_baseline="soumah" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace classe_baseline="11" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace option_baseline="SS" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace id_cto_checked="91504611" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"
replace participation=0 if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"

replace rematch="1" if key=="uuid:83a47d07-d2ed-4c98-815d-84e9a1105fdc"

*13
replace commune="RATOMA" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace treatment=1 if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace school_id=915046 if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace id_cto=91504613 if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"

replace prenom_baseline="elisabeth" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace nom_baseline="dopavogui" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace classe_baseline="11" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace option_baseline="SS" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace id_cto_checked="91504613" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"
replace participation=0 if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"

replace rematch="1" if key=="uuid:98ec202b-a9bb-4907-9521-5adccc81b378"

*16 : uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154
replace commune="RATOMA" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace treatment=1 if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace school_id=915046 if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace id_cto=91504616 if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"

replace prenom_baseline="bah" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace nom_baseline="fatoumata binta" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace classe_baseline="11" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace option_baseline="SS" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace id_cto_checked="91504616" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"
replace participation=0 if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"

replace rematch="1" if key=="uuid:f7b39b84-19a0-40e3-a271-ec70adb9a154"

*18
replace commune="RATOMA" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace treatment=1 if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace school_id=915046 if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace id_cto=91504618 if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"

replace prenom_baseline="lancinet" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace nom_baseline="diane" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace classe_baseline="11" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace option_baseline="SS" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace id_cto_checked="91504618" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"
replace participation=0 if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"

replace rematch="1" if key=="uuid:9fc87d8d-0b3c-4f04-93d9-752d61c4c0e9"

*19
replace commune="RATOMA" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace treatment=1 if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace school_id=915046 if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace id_cto=91504619 if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"

replace prenom_baseline="fatoumata binta" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace nom_baseline="conde" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace classe_baseline="11" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace option_baseline="SS" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace id_cto_checked="91504619" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"
replace participation=0 if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"

replace rematch="1" if key=="uuid:4cda315c-3b99-450e-bea9-ffda9375461d"

*22
replace commune="RATOMA" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace treatment=1 if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace school_id=915046 if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace id_cto=91504622 if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"

replace prenom_baseline="moniafa capi" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace nom_baseline="lamah" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace classe_baseline="11" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace option_baseline="SM" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace id_cto_checked="91504622" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"
replace participation=0 if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"

replace rematch="1" if key=="uuid:8dd6b989-7d65-4879-868c-34cd47b651c0"

*26
replace commune="RATOMA" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace treatment=1 if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace school_id=915046 if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace id_cto=91504626 if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"

replace prenom_baseline="thierno daouda" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace nom_baseline="diallo" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace classe_baseline="11" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace option_baseline="SM" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace id_cto_checked="91504626" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"
replace participation=0 if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"

replace rematch="1" if key=="uuid:57ae293f-86d8-47de-94b7-4bb20a8f8be1"

*27
replace commune="RATOMA" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace treatment=1 if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace school_id=915046 if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace id_cto=91504627 if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"

replace prenom_baseline="abdoulaye" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace nom_baseline="camara" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace classe_baseline="11" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace option_baseline="SM" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace id_cto_checked="91504627" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"
replace participation=0 if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"

replace rematch="1" if key=="uuid:3d6dd44d-916a-4fd7-bc7a-51d35e8aad14"

*30
replace commune="RATOMA" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace treatment=1 if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace school_id=915046 if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace id_cto=91504630 if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"

replace prenom_baseline="mamadi" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace nom_baseline="diallo" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace classe_baseline="11" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace option_baseline="SM" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace id_cto_checked="91504630" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"
replace participation=0 if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"

replace rematch="1" if key=="uuid:ef2bfa4e-8b2e-47a6-a124-f7346cc4a163"

*31
replace commune="RATOMA" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace treatment=1 if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace school_id=915046 if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace id_cto=91504631 if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"

replace prenom_baseline="mamady" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace nom_baseline="kouyate" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace classe_baseline="11" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace option_baseline="SM" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace id_cto_checked="91504631" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"
replace participation=0 if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"

replace rematch="1" if key=="uuid:7e1237fa-5b2c-430d-91b2-71fb840b5569"

*33
replace commune="RATOMA" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace lycee_name="NOUMANDIAN KEITA" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace lycee_name2="NOUMANDIAN KEITA" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace treatment=1 if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace school_id=915046 if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace id_cto=91504633 if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"

replace prenom_baseline="alseny" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace nom_baseline="bah" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace classe_baseline="11" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace option_baseline="SM" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace id_cto_checked="91504633" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"
replace participation=0 if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"

replace rematch="1" if key=="uuid:58cc0f55-4ed9-4812-90eb-fa7206dcb486"

*** 12 students for Assiatou Bah (instead of Santa Maria)
* school_id=915311
*4, 13, 15, 19, 20, 22, 24, 26, 29, 30, 31, 32, 
*13: 
*uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c
replace commune="RATOMA" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace lycee_name="ASSIATOU BAH" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace treatment=1 if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace school_id=915311 if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace id_cto=91531113 if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"

replace prenom_baseline="fatou" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace nom_baseline="cisse" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace classe_baseline="11" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace option_baseline="SM" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace id_cto_checked="91531113" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"
replace participation=0 if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"

replace rematch="1" if key=="uuid:3b5abe40-6639-46bf-8fb2-26515a42c84c"

*20:
*uuid:f5f8b531-4188-49e1-86fe-212d621c956e
replace commune="RATOMA" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace lycee_name="ASSIATOU BAH" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace treatment=1 if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace school_id=915311 if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace id_cto=91531120 if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"

replace prenom_baseline="jeannette  tewa" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace nom_baseline="kamano" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace classe_baseline="11" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace option_baseline="SM" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace id_cto_checked="91531120" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"
replace participation=0 if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"

replace rematch="1" if key=="uuid:f5f8b531-4188-49e1-86fe-212d621c956e"

*22:
*uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af
replace commune="RATOMA" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace lycee_name="ASSIATOU BAH" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace treatment=1 if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace school_id=915311 if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace id_cto=91531122 if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"

replace prenom_baseline="mariama kesso" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace nom_baseline="diallo" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace classe_baseline="11" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace option_baseline="SM" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace id_cto_checked="91531122" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"
replace participation=0 if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"

replace rematch="1" if key=="uuid:151c965e-dab8-4b53-bfd0-2eee21d2f7af"

*26:
*uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1
replace commune="RATOMA" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace lycee_name="ASSIATOU BAH" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace treatment=1 if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace school_id=915311 if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace id_cto=91531126 if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"

replace prenom_baseline="fatoumata binta" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace nom_baseline="diallo" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace classe_baseline="12" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace option_baseline="SE" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace id_cto_checked="91531126" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"
replace participation=0 if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"

replace rematch="1" if key=="uuid:f607bdaa-c157-40a1-a52d-10bd3e4912b1"

*29:
*uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d
replace commune="RATOMA" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace lycee_name="ASSIATOU BAH" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace treatment=1 if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace school_id=915311 if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace id_cto=91531129 if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"

replace prenom_baseline="mariama" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace nom_baseline="diallo" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace classe_baseline="12" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace option_baseline="SM" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace id_cto_checked="91531129" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"
replace participation=0 if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"

replace rematch="1" if key=="uuid:a05b49bb-49b2-4569-a1ef-9bafc21ed11d"

*30:
*uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68
replace commune="RATOMA" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace lycee_name="ASSIATOU BAH" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace treatment=1 if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace school_id=915311 if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace id_cto=91531130 if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"

replace prenom_baseline="salematou" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace nom_baseline="diallo" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace classe_baseline="12" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace option_baseline="SM" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace id_cto_checked="91531130" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"
replace participation=0 if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"

replace rematch="1" if key=="uuid:0bc9d8fd-43a4-43aa-91fb-8b875150bf68"

*31:
*uuid:8a7424f2-4576-4fdc-8053-c507b83f305e
replace commune="RATOMA" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace lycee_name="ASSIATOU BAH" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace treatment=1 if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace school_id=915311 if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace id_cto=91531131 if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"

replace prenom_baseline="taibou" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace nom_baseline="diallo" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace classe_baseline="12" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace option_baseline="SM" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace id_cto_checked="91531131" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"
replace participation=0 if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"

replace rematch="1" if key=="uuid:8a7424f2-4576-4fdc-8053-c507b83f305e"

*32
*uuid:65d8b628-23b8-41da-91c8-b0859ffce259
replace commune="RATOMA" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace lycee_name="ASSIATOU BAH" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace treatment=1 if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace school_id=915311 if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace id_cto=91531132 if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"

replace prenom_baseline="hassatou" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace nom_baseline="diallo" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace classe_baseline="12" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace option_baseline="SM" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace id_cto_checked="91531132" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"
replace participation=0 if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"

replace rematch="1" if key=="uuid:65d8b628-23b8-41da-91c8-b0859ffce259"

*4 
replace commune="RATOMA" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace lycee_name="ASSIATOU BAH" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace treatment=1 if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace school_id=915311 if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace id_cto=9153114 if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"

replace prenom_baseline="aly badara" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace nom_baseline="conde" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace classe_baseline="11" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace option_baseline="SS" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace id_cto_checked="9153114" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"
replace participation=0 if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"

replace rematch="1" if key=="uuid:ca11b125-c49b-40e3-b6ec-b0ca3761d1c6"

*15 
replace commune="RATOMA" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace lycee_name="ASSIATOU BAH" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace treatment=1 if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace school_id=915311 if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace id_cto=91531115 if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"

replace prenom_baseline="bakary" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace nom_baseline="camara" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace classe_baseline="11" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace option_baseline="SM" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace id_cto_checked="91531115" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"
replace participation=0 if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"

replace rematch="1" if key=="uuid:42c31e4a-b4a5-4401-9d9d-f21c74a10334"

*19
replace commune="RATOMA" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace lycee_name="ASSIATOU BAH" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace treatment=1 if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace school_id=915311 if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace id_cto=91531119 if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"

replace prenom_baseline="kadiatou" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace nom_baseline="kaba" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace classe_baseline="11" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace option_baseline="SM" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace id_cto_checked="91531119" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"
replace participation=0 if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"

replace rematch="1" if key=="uuid:682f4b0f-f7e8-4a57-9a42-de67fa709e98"

*24
replace commune="RATOMA" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace lycee_name="ASSIATOU BAH" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace lycee_name2="ASSIATOU BAH" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace treatment=1 if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace school_id=915311 if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace id_cto=91531124 if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"

replace prenom_baseline="hadja habibatou" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace nom_baseline="diallo" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace classe_baseline="11" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace option_baseline="SM" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace id_cto_checked="91531124" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"
replace participation=0 if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"

replace rematch="1" if key=="uuid:058a64d0-2bb8-48d4-b8c2-55dedd077ebe"

*1 student for Santa Maria (instead of Assiatou Bah)
*school_id=915310 / 3 / uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5

replace commune="RATOMA" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace lycee_name="SANTA MARIA" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace lycee_name2="SANTA MARIA" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace treatment=1 if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace school_id=915310 if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace id_cto=9153103 if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"

replace prenom_baseline="laye seinkoun" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace nom_baseline="kourouma" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace classe_baseline="11" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace option_baseline="SS" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace id_cto_checked="9153103" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"
replace participation=0 if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"

replace rematch="1" if key=="uuid:ca8c43f1-abd9-4a09-8e94-73bf452d52b5"

*** 1 for Cheick Cherif Sagale (instead of Kelefa Diallo)
*school_id=911036 / 49 / uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea

replace commune="DIXINN" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace lycee_name="CHEICK CHERIF SAGALE" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace lycee_name2="CHEICK CHERIF SAGALE" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace treatment=3 if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace school_id=911036 if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace id_cto=91103649 if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"

replace prenom_baseline="aissata deen" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace nom_baseline="soumah" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace classe_baseline="11" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace option_baseline="SS" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace id_cto_checked="91103649" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"
replace participation=1 if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"

replace rematch="1" if key=="uuid:1b760c03-6190-4f55-bb8f-10c34193e0ea"

*Student 35 from Abdoulaye Sangareah (instead of El Ibrahima Bah)
replace commune="RATOMA" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace lycee_name="ABDOULAYE SANGAREAH" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace lycee_name2="ABDOULAYE SANGAREAH" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace treatment=2 if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace school_id=915328 if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace id_cto=91532835 if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"

replace prenom_baseline="mamadou billo" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace nom_baseline="balde" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace classe_baseline="11" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace option_baseline="SM" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace id_cto_checked="91532835" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"
replace participation=1 if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"

replace rematch="1" if key=="uuid:7cef5e51-99bd-4583-b723-27340a59e112"

*Student 16 from Hadja Ouma Diallo (instead of Hadja Oumou)
replace commune="RATOMA" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace lycee_name="HADJA OUMA DIALLO" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace lycee_name2="HADJA OUMA DIALLO" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace treatment=4 if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace school_id=915144 if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace id_cto=91514416 if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"

replace prenom_baseline="mamadou lamine" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace nom_baseline="barry" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace classe_baseline="11" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace option_baseline="SM" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace id_cto_checked="91514416" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"
replace participation=1 if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"

replace rematch="1" if key=="uuid:6df039c1-e9c7-4c1a-9d05-f0182144fc24"

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.2 - CORRECTION OF STUDENTS ENTERED UNDER A WRONG ID WITHIN THE RIGHT SCHOOL
***_____________________________________________________________________________

*Student 43 Gnenouyah, registered under 5
replace id_cto_checked="91440643" if key=="uuid:bfc47a82-c31e-4738-8567-7d437d11f4f6"
replace rematch="1" if key=="uuid:bfc47a82-c31e-4738-8567-7d437d11f4f6"

*Student 2 from Olusegun Obasanjo, registered under 21
replace id_cto_checked="9153632" if key=="uuid:6300dbe4-5684-4150-ada2-f07d4c88b394"
replace rematch="1" if key=="uuid:6300dbe4-5684-4150-ada2-f07d4c88b394"

*Student 50 from Hadja Aissata Drame, registered under 25
replace id_cto_checked="91545950" if key=="uuid:de97efa0-0498-49b1-ad90-5b33e5e251e4"
replace rematch="1" if key=="uuid:de97efa0-0498-49b1-ad90-5b33e5e251e4"

*Student 47 from Kabassan Keita, registered under 46
replace id_cto_checked="91511147" if key=="uuid:f86123fb-2d0e-4c6c-8b50-90f4284da39a"
replace rematch="1" if key=="uuid:f86123fb-2d0e-4c6c-8b50-90f4284da39a"

*Student 1 from Dr Ibrahima Fofana, registered under 11
replace id_cto_checked="9142441" if key=="uuid:f5fbcee0-7aef-4755-83ac-528976d9c60b"
replace rematch="1" if key=="uuid:f5fbcee0-7aef-4755-83ac-528976d9c60b"

///////////*Student 18 from Hadja Fatou Diaby, registered under 41
*O change made for rematch
replace id_cto_checked="91527018" if key=="uuid:8a6dd237-5ca9-478b-9989-d6b31a24f3bf"
replace rematch="1" if key=="uuid:6a7ae52c-1447-44d7-9d29-8984ca5e2e3f"

*Student 49 from Jean Mermoz, registered under 24
replace id_cto_checked="91415949" if key=="uuid:7765883f-70a3-4604-8c6e-90650167506d"
replace rematch="1" if key=="uuid:7765883f-70a3-4604-8c6e-90650167506d"

*Student 6 from Hadja N'Nabitou Touré, registered under 6
replace id_cto_checked="9149996" if key=="uuid:896bb95c-68ae-4264-9060-61850442b3df"
replace rematch="1" if key=="uuid:896bb95c-68ae-4264-9060-61850442b3df"

*Student 25 from Cam-Syl, registered under 27
replace id_cto_checked="91412525" if key=="uuid:63bab74c-12b9-4b09-ae3f-244e6454e080"
replace rematch="1" if key=="uuid:63bab74c-12b9-4b09-ae3f-244e6454e080"

*Student 8 from Thierno Monenembo, registered under 12
replace id_cto_checked="9142348" if key=="uuid:1ac93594-1c37-47a3-9c6b-d1b819f8535e"
replace rematch="1" if key=="uuid:1ac93594-1c37-47a3-9c6b-d1b819f8535e"

/***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.3 - STUDENTS WITH UNCLEAR STATUS ON THE FILES
***_____________________________________________________________________________

Corrected directly in the short school survey in the do_file 02_paper_questionnaire
*Student 34 from Grande Ecole -> surveyed
*Student 42 from Lycee Lambandji -> surveyed
*Student 16 from Safiatou Bah -> surveyed
*/
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.4 - DROPING SURVEYS WHEN CONSENT WAS NO
***_____________________________________________________________________________

*TWO STUDENTS ANSWERED "NO" TO THE QUESTION ABOUT CONSENT AND THEN DID THE SURVEY
drop if key=="uuid:93668f45-2fb8-4019-a419-a6d6fda9142e"
drop if key=="uuid:de7f9e4e-c011-478a-8618-bafa84c7e57e"


/***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.5 - SURVEY CUT IN TWO BY SURVEYCTO
***_____________________________________________________________________________

browse if time_check==.

The following surveys were cut by surveyCTO because the students wrote a comma
"," in one of the text answer of their survey. I manually corrected this in the
 csv imported from SurveyCTO before importing it and saving in as dta

For details, see the excel file "cut_surveys" in 
"C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\correction_file\correction_followup2"

*Student 17 - William Du Bois
*Student 41 - William Du Bois
*Student 10 - Safiatou Bah
*Student 6 - Hadja Fatimatou Barry
*Student 27 - Van Vollenhoven
*Student 6 - Abdoulaye Sangareah
*Student 13 - Baptiste

*Student 15 - Ousmane Ly
*Student 17 - Nelson Mandela Simbaya
*Student 20 - La Tourterelle
*/
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.6 - UNFINISHED QUESTIONNAIRE
***_____________________________________________________________________________

*browse if check3==987
*4 unfinished questionnaire, but 2 were re-done afterwards and will therefore be dropped
*only 2 need to be corrected

*First questionnaire: 
local unfinished1 "check1 check1_bis check2 check3 check3_bis finished time_check"

foreach var in `unfinished1'  {
tostring `var', replace
replace `var'="." if key=="uuid:1bb1e6b6-5cdf-45ce-b4b1-efdbbf05a2cf" 
}

*Second questionnaire:
local unfinished2str sec2_q5 sec2_q7_example sec2_q8 sec2_q9 sec2_q10_c sec2_q11 sec2_q12 sec2_q13  time2 sec3_0 sec3_1 sec3_2 sec3_3 sec3_4 sec3_5 sec3_6 sec3_7 sec3_8 time3a sec3_10 sec3_11 sec3_12 sec3_14 sec3_15 sec3_16 sec3_17 sec3_18 sec3_19 time3b upper_bound num_draws random_draws_count  unique_draws randomoption1 randomoption2 randomoption3 randomoption4 randomoption5 randomoption6 sec3_21_nb sec3_21_nb_other sec3_21 sec3_22 sec3_23 sec3_31_bis time3c sec3_32 sec3_34 sec3_34_error_millions  sec3_34_error_thousands  sec3_34_error_millions_2  sec3_34_euros  sec3_35 sec3_36 sec3_37 sec3_39 sec3_40 sec3_41 sec3_42 sec9_q3_1_a sec9_q3_1_b sec9_q3_2_a sec9_q3_2_b sec9_q3_3_a sec9_q3_3_b time9 outside_contact_no sec10_q1_1 sec10_q5_1 sec10_q1_2 sec10_q5_2 time10a sec10_q2_1 sec10_q3_1   partb_q0_other   partb_q1_other partb_q3 partb_q3_3 partb_q3_other check1 check1_bis check2 check3 check3_bis finished time_check time3d time5 time7 time10b time10c time_partb
local unfinished2num sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3  sec2_q10_a sec2_q10_b  sec2_q15 random_draw_1 scaled_draw_1 random_draw_2 scaled_draw_2 random_draw_3 scaled_draw_3 random_draw_4 scaled_draw_4 random_draw_5 scaled_draw_5 random_draw_6 scaled_draw_6 random_draw_7 scaled_draw_7 random_draw_8 scaled_draw_8 random_draw_9 scaled_draw_9 random_draw_10 scaled_draw_10 random_draw_11 scaled_draw_11 random_draw_12 scaled_draw_12 random_draw_13 scaled_draw_13 random_draw_14 scaled_draw_14 random_draw_15 scaled_draw_15 random_draw_16 scaled_draw_16 random_draw_17 scaled_draw_17 random_draw_18 scaled_draw_18 random_draw_19 scaled_draw_19 random_draw_20 scaled_draw_20 random_draw_21 scaled_draw_21 random_draw_22 scaled_draw_22 random_draw_23 scaled_draw_23 random_draw_24 scaled_draw_24 random_draw_25 scaled_draw_25 random_draw_26 scaled_draw_26 random_draw_27 scaled_draw_27 random_draw_28 scaled_draw_28 random_draw_29 scaled_draw_29 random_draw_30 scaled_draw_30 random_draw_31 scaled_draw_31 random_draw_32 scaled_draw_32 random_draw_33 scaled_draw_33 random_draw_34 scaled_draw_34 random_draw_35 scaled_draw_35 random_draw_36 scaled_draw_36 random_draw_37 scaled_draw_37 random_draw_38 scaled_draw_38 random_draw_39 scaled_draw_39 random_draw_40 scaled_draw_40 random_draw_41 scaled_draw_41 random_draw_42 scaled_draw_42 random_draw_43 scaled_draw_43 random_draw_44 scaled_draw_44 random_draw_45 scaled_draw_45 random_draw_46 scaled_draw_46 random_draw_47 scaled_draw_47 random_draw_48 scaled_draw_48 random_draw_49 scaled_draw_49 random_draw_50 scaled_draw_50 random_draw_51 scaled_draw_51 random_draw_52 scaled_draw_52 sec3_34_error_thousands_2 sec3_34_bis sec3_34_livres sec3_34_local sec3_42_euros sec3_42_livre sec3_42_local sec5_q1 sec5_q2 sec5_q3 sec5_q4 sec5_q5 sec5_q6  sec7_q7 sec7_q8 sec7_q9 sec7_q10  sec9_q1 sec9_q2  sec10_q4_1 sec10_q6_1 sec10_q7_1 sec10_q8_1 sec10_q9_1 sec10_q11_1 sec10_q12_1 sec10_q13_1 sec10_q14_1 sec10_q15_1 sec10_q16_1 sec10_q17_1 sec10_q18_1 sec10_q19_1  sec10_q2_2 sec10_q3_2 sec10_q4_2 sec10_q6_2 sec10_q7_2 sec10_q8_2 sec10_q9_2 sec10_q11_2 sec10_q12_2 sec10_q13_2 sec10_q14_2 sec10_q15_2 sec10_q16_2 sec10_q17_2 sec10_q18_2 sec10_q19_2  optimism partb_participation partb_q0 partb_q0_bis partb_q1  partb_q2 partb_q3_1 partb_q3_2  partb_q3_4 partb_q3_99 partb_q3_5  partb_q5 partb_q6 partb_q8 partb_q9 partb_q11_a partb_q11_b partb_q11_c partb_q11_f partb_q11_g partb_q11_h partb_q11_j partb_q11_k partb_q11_l partb_q11_m partb_q12 partb_q13 

foreach var in `unfinished2str'  {
tostring `var', replace
replace `var'="." if key=="uuid:33d9b76a-f2d5-4b51-8c70-5ff684a82d13" 
}

foreach var in `unfinished2num'  {
replace `var'=. if key=="uuid:33d9b76a-f2d5-4b51-8c70-5ff684a82d13" 
}


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.7 - MISSING QUESTION (JOB) IN THE FIRST 8 SCHOOLS
***_____________________________________________________________________________

*creating a variable to know how this question was answered: 
*1=at school by the student (tablet),2=by phone by the student, 3=by phone by a contact
gen sec0_q6_job_1="1"
replace sec0_q6_job_1="." if sec0_q6_job==.

*browse if sec0_q6_job==.

local yes "9130262 9130267	91302611 91302612 91418729 91418731 91102824"
foreach v of local yes  {
replace sec0_q6_job=1 if id_cto_checked=="`v'"
}

local no "9130196 9130198	9130199	91301910	91301911	91301926	91301929	91301944	9110145	9110146	9110149	91101412	91101413	91101415	91101419	91101421	91101422	91101428	9149984	9149988	91499810	91499811	91499813	91499816	91499817	91499818	91499819	91499820	91499821	91499823	91499825	91499834	91499837	91499840	91499841	91499844	91499845	91499846	91499847	9130268	9130269	91302610	91302617	91302618	91302620	91302622	91302623	91302624	91302628	91302630	91302631	91302633	91302646	91302647	9141873	9141878	9141879	91418710	91418714	91418717	91418723	91418725	91418728	91418736	91418743	91102813	91102821	91102823	9143301	9143304	91433014	91433020	91433022	91433023	91433026	91433027	91433045	9130071	9130073	9130077	91300717	91300723	91300727	91300734	91300737	91300741 9153285	91516716	91518627	9110283	9110287	91102814	91102829	9130192	9130195	91301916	91301920	91301927	91301928	91301931	91523937	91302613	91302614	91302616	91302634	91533915	91499815	91499824	91499826	91499828	91499839	91499848	91499849	91502714	9141871	9141874	9141876	91418711	91418712	91418716	91418722	91418726	91418730	91418738	91418741	9110148	91101414	91101416	91101418	91101425	91101427	9143302	9143305	9143309	91433016	91433017	91433019	91433021	91433025	91433030	9142344	9130078	91300714	91300726	91300731	91300732	91300747"
foreach v of local no  {
replace sec0_q6_job=2 if id_cto_checked=="`v'"
}

*browse if sec0_q6_job==.

local student "9130196	9130198	91301910	91301911	91301929	91301944	9110145	9110146	91101412	91101413	91101419	91101422	9149984	9149988	91499810	91499811	91499816	91499817	91499818	91499819	91499820	91499821	91499823	91499834	91499840	91499841	91499844	91499845	91499846	91499847	9130262	9130267	91302611	91302612	91302622	91302624	91302631	91302646	91302647	9141873	9141878	9141879	91418714	91418717	91418723	91418725	91418728	91418729	91418731	91418736	91418743	91102813	91102821	91102823	91102824	9143301	9143304	91433014	91433020	91433022	91433023	91433026	91433027	91433045	9130071	9130073	91300717	91300723	91300727	91300734	91300737	91300741 9153285	91516716	91518627	9110283	9110287	91102814	91102829	9130192	9130195	91301916	91301920	91301927	91301928	91301931	91523937	91302613	91302614	91302616	91302634	91533915	91499815	91499824	91499826	91499828	91499839	91499848	91499849	91502714	9141871	9141874	9141876	91418712	91418716	91418722	91418726	91418730	91418738	91418741	9110148	91101414	91101416	91101418	91101425	91101427	9143302	9143305	9143309	91433016	91433017	91433019	91433021	91433025	91433030	9142344	9130078	91300714	91300726	91300731	91300732	91300747"
local contact "9130199	91301926	9110149	91101415	91101421	91101428	91499813	91499825	91499837	9130268	9130269	91302610	91302617	91302618	91302620	91302623	91302628	91302630	91302633	91418710	9130077 91418711"																																																																	

foreach v of local student  {
replace sec0_q6_job_1="2" if id_cto_checked=="`v'"
}

foreach v of local contact  {
replace sec0_q6_job_1="3" if id_cto_checked=="`v'"
}

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1.8 - DROPING DUPLICATES AND EXTRA SURVEYS
***_____________________________________________________________________________

*these duplicates do not correspond to the phone surveys, the other was kept
drop if key=="uuid:b4259ade-ea84-4533-9314-252c21bcff79"
drop if key=="uuid:2f7fc370-758b-4ae1-bd10-73f40532c808"
drop if key=="uuid:0eaf403d-4ec0-4954-a5ac-8844045a3538"
drop if key=="uuid:aca9aa17-ce42-4d5f-96de-3d8ebfa82eb5"
drop if key=="uuid:6e4d5f74-ecf4-4f20-b87b-f03f62551add"
drop if key=="uuid:9b5a01e3-4e94-472e-a9dd-718500849f42"
drop if key=="uuid:50fcf2b8-bd4d-4c96-8db2-a6108099d348"
drop if key=="uuid:b9f86bd6-ed28-4a23-b3dd-7eeddeaf1213"
drop if key=="uuid:d08f507e-49ce-4eb1-b296-0b80bc2d2e26"
drop if key=="uuid:8738f75f-6901-467a-9673-958027d962b6"
drop if key=="uuid:00fe383e-90d6-4a16-aa82-8d1d5875b327"

*these students are marked as not surveyed at school, but they do have a survey 
*and this survey does not correspond to the phone survey for the student
drop if key=="uuid:52d76ecf-73c6-4f3b-8506-4ba74110b009"
drop if key=="uuid:da7ca860-ad44-4d7b-a61a-3cedde863c81"
drop if key=="uuid:08fd6b51-706e-49b0-bc91-d903acc45c28"
drop if key=="uuid:c138970d-8ee2-4d08-80ae-fdd553e7419e"
drop if key=="uuid:d735b895-228e-416a-8bdd-3795e8749db0"
drop if key=="uuid:2c91c373-153b-4d7f-a2ec-1e9294737f30"
drop if key=="uuid:9546d51d-f728-4d3b-a358-f250d14245c4"
drop if key=="uuid:ef95d770-34f6-45c8-aca8-ee924ef2c313"
drop if key=="uuid:0735b112-7b86-4a2c-a571-6f0d9dbe8061"
drop if key=="uuid:224e9460-6910-4f8c-92e9-b298eb8e67db"
drop if key=="uuid:1f62a156-cf14-4f3b-9a6f-7a4ab53e5e78"
drop if key=="uuid:84f5dd96-15de-4913-9bed-b34f7184419a"
drop if key=="uuid:53fa48dd-c3d9-4f3f-bf98-3529f9ba706b"
drop if key=="uuid:7cac03f6-e33b-497e-83c8-3647b0252d5b"
drop if key=="uuid:18b200b9-d95a-4e4c-9530-ae32011a7c13"
drop if key=="uuid:be8d062f-f8e4-47e2-b1a4-fe16affefc69"

*Student 2 from Noumandian Keita appeared on the list for the second and was 
*surveyed a second time: dropping the second
drop if key=="uuid:264adef8-fd65-4733-9fbb-f233f63d7dc6"

*Student 16 from Noumandian Keita, surveyed during both visits under wrong school
drop if key=="uuid:54f0755b-635d-48fa-9179-a0e475bab1aa"

*2 were called to know which one to drop:
drop if key=="uuid:f744dcba-20f9-4a9d-86f8-e0c8a58dab48"
drop if key=="uuid:a75057dd-d6b6-4c25-8f78-c4980ca91aae"

duplicates tag id_cto, gen(dup)
*browse if dup!=0

save ${main}\Data\output\followup2\intermediaire\guinea_endline_lycee_corrected, replace





/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////      					2 - PHONE					/////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

clear
use ${main}\Data\dta\guinea_endline_phone_raw

rename id_cto id_number
*creating a variable to keep track of the corrections: rematch=2 if the phone survey was corrected
gen rematch="."
*See details of all corrections in the excel file "correction_phone_mismatch"
*"Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\correction_file\correction_followup2"

duplicates tag id_number subcon, gen(dup)
*tab dup subcon

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

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2.1 - DUPLICATES: 78
***_____________________________________________________________________________

*See details in the tab student_chrono in the excel file duplicates_phone in
*"Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\correction_file\correction_followup2"

*Student 31 - Garaya 1
replace id_number="91102831" if key=="uuid:a50a05b0-af6a-487b-a354-8eeaf36316ad"
replace rematch="2" if key=="uuid:a50a05b0-af6a-487b-a354-8eeaf36316ad"

*Student 32 - Sansy Kaba Diakite
replace id_number="91433032" if key=="uuid:b8c832f9-16eb-4298-a2f8-fed40369ef7e"
replace rematch="2" if key=="uuid:b8c832f9-16eb-4298-a2f8-fed40369ef7e"

*Student 49 - Sansy Kaba Diakite
replace id_number="91433049" if key=="uuid:78101bc0-e96f-412e-bd35-7359cbf2fbd7"
replace rematch="2" if key=="uuid:78101bc0-e96f-412e-bd35-7359cbf2fbd7"

*Student 24 - William du Bois
replace id_number="91300724" if key=="uuid:e337bba4-2696-4705-8b12-3d8bc4cdce1a"
replace rematch="2" if key=="uuid:e337bba4-2696-4705-8b12-3d8bc4cdce1a"

*Student 32 - Mohamed Lamine Souare
replace id_number="91499832" if key=="uuid:8de1c490-5361-46a2-9781-e5fd6a1583f4"
replace rematch="2" if key=="uuid:8de1c490-5361-46a2-9781-e5fd6a1583f4"

*Student 9 - Hadja Fatimatou Barry
replace id_number="9110209" if key=="uuid:7c91aec5-1673-4f38-96c5-63fe4d246da2"
replace rematch="2" if key=="uuid:7c91aec5-1673-4f38-96c5-63fe4d246da2"

*Student 44 - Garaya 1
replace id_number="91102844" if key=="uuid:26270639-a28d-470f-9411-4aef3ecffadd"
replace rematch="2" if key=="uuid:26270639-a28d-470f-9411-4aef3ecffadd"

*Student 19 - La Source
replace id_number="91100919" if key=="uuid:81726e3c-d0b1-4c89-b2fc-0899fcc06b47"
replace rematch="2" if key=="uuid:81726e3c-d0b1-4c89-b2fc-0899fcc06b47"

*Student 18 - La Source
replace id_number="91100918" if key=="uuid:7cf9c6b0-c020-4208-9da8-52b4072dce8b"
replace rematch="2" if key=="uuid:7cf9c6b0-c020-4208-9da8-52b4072dce8b"

*Student 3 - La Sagesse
replace id_number="9155133" if key=="uuid:3faded5a-3876-4a44-be82-2a6d359ccf56"
replace rematch="2" if key=="uuid:3faded5a-3876-4a44-be82-2a6d359ccf56"

*Student 17 - La Sagesse
replace id_number="91551317" if key=="uuid:c754222a-0cc2-46fd-bbaf-27dc07c60a5c"
replace rematch="2" if key=="uuid:c754222a-0cc2-46fd-bbaf-27dc07c60a5c"

*Student 13 - Kelefa Diallo
replace id_number="91106413" if key=="uuid:67750def-90b1-44fa-8adb-6c19e6e951fd"
replace rematch="2" if key=="uuid:67750def-90b1-44fa-8adb-6c19e6e951fd"

*Student 43 - Mission Kalima
replace id_number="91533943" if key=="uuid:588ada49-ea11-4509-b952-23e86ca6368e"
replace rematch="2" if key=="uuid:588ada49-ea11-4509-b952-23e86ca6368e"

*Student 28 - Olusegun Obasanjo
replace id_number="91536328" if key=="uuid:413b088c-66ea-4287-afa4-45f779a92ef6"
replace rematch="2" if key=="uuid:413b088c-66ea-4287-afa4-45f779a92ef6"

*Student 29 - Kabassan Keita
replace id_number="91511129" if key=="uuid:2c362ee7-ba70-4741-b964-16968d81b80a"
replace rematch="2" if key=="uuid:2c362ee7-ba70-4741-b964-16968d81b80a"

*Student 42 - Kabassan Keita
replace id_number="91511142" if key=="uuid:dc8e736d-6ea8-46b0-91cf-1881a7ebaef0"
replace rematch="2" if key=="uuid:dc8e736d-6ea8-46b0-91cf-1881a7ebaef0"

*Student 15 - Kabassan Keita
replace id_number="91511115" if key=="uuid:ee01039b-4a76-4547-a28c-361ae4e16f71"
replace rematch="2" if key=="uuid:ee01039b-4a76-4547-a28c-361ae4e16f71"

*Student 19 - Hadja Oumou (under id. 18)
replace id_number="91517119" if key=="uuid:d9d89ed4-7966-4900-a00a-7ad12e8ff2e3"
replace rematch="2" if key=="uuid:d9d89ed4-7966-4900-a00a-7ad12e8ff2e3"

*Student 31 - Providence 3
replace id_number="91505331" if key=="uuid:31bc3d06-efca-40ce-8c9c-aae096d472e9"
replace rematch="2" if key=="uuid:31bc3d06-efca-40ce-8c9c-aae096d472e9"

*Student 46 - Loukatin
replace id_number="91415646" if key=="uuid:1915650e-e1e1-4f2a-8361-e4ecc3f01cba"
replace rematch="2" if key=="uuid:1915650e-e1e1-4f2a-8361-e4ecc3f01cba"

*Student 6 - Providence 3
replace id_number="9150536" if key=="uuid:595098f6-82b8-4c97-b925-1a8559c7cb9d"
replace rematch="2" if key=="uuid:595098f6-82b8-4c97-b925-1a8559c7cb9d"

*Student 4 - Providence 3
replace id_number="9150534" if key=="uuid:7e9c0815-36b9-46b0-b054-0fee6d75f2c7"
replace rematch="2" if key=="uuid:7e9c0815-36b9-46b0-b054-0fee6d75f2c7"

*Student 30 - Providence 3
replace id_number="91505330" if key=="uuid:9d31589c-6b6c-489b-b776-695594c64426"
replace rematch="2" if key=="uuid:9d31589c-6b6c-489b-b776-695594c64426"

*Student 45 - Providence 3
replace id_number="91505345" if key=="uuid:bed0b6ed-ddd5-4552-80fd-92728af1c724"
replace rematch="2" if key=="uuid:bed0b6ed-ddd5-4552-80fd-92728af1c724"

*Student 29 - Christine Camara
replace id_number="91410129" if key=="uuid:8d47f3bd-de6c-4524-9711-d37549c742d7"
replace rematch="2" if key=="uuid:8d47f3bd-de6c-4524-9711-d37549c742d7"

*Student 9 - Hadja Ouma Diallo
replace id_number="9151449" if key=="uuid:a498c419-03a1-4ee0-8208-cb20a2f4df4c"
replace rematch="2" if key=="uuid:a498c419-03a1-4ee0-8208-cb20a2f4df4c"

*Student 11 - Hadja Ouma Diallo
replace id_number="91514411" if key=="uuid:7fe1819b-5898-43b9-958d-ef6b5b8a2905"
replace rematch="2" if key=="uuid:7fe1819b-5898-43b9-958d-ef6b5b8a2905"

*Student 12 - Hadja Ouma Diallo
replace id_number="91514412" if key=="uuid:9f08ccff-9749-4372-92c6-3048d22104df"
replace rematch="2" if key=="uuid:9f08ccff-9749-4372-92c6-3048d22104df"

*Student 13 - Hadja Ouma Diallo
replace id_number="91514413" if key=="uuid:044ae7bd-7f18-4750-9d05-dfb3820f237c"
replace rematch="2" if key=="uuid:044ae7bd-7f18-4750-9d05-dfb3820f237c"

*Student 17 - Hadja Ouma Diallo
replace id_number="91514417" if key=="uuid:754fae92-af83-4ea6-8fcd-d5a3e2a1cb66"
replace rematch="2" if key=="uuid:754fae92-af83-4ea6-8fcd-d5a3e2a1cb66"

*Student 18 - Hadja Ouma Diallo
replace id_number="91514418" if key=="uuid:86a177b0-74ac-4aa2-8e2b-cc2810846659"
replace rematch="2" if key=="uuid:86a177b0-74ac-4aa2-8e2b-cc2810846659"

*Student 22 - Hadja Ouma Diallo
replace id_number="91514422" if key=="uuid:a6e85e66-42b2-4ae5-ba5f-ee45101c2c0c"
replace rematch="2" if key=="uuid:a6e85e66-42b2-4ae5-ba5f-ee45101c2c0c"

*Student 30 - Hadja Ouma Diallo
replace id_number="91514430" if key=="uuid:cce1f079-c4e9-43b0-8917-0d2209b3154d"
replace rematch="2" if key=="uuid:cce1f079-c4e9-43b0-8917-0d2209b3154d"

*Student 31 - Hadja Ouma Diallo
replace id_number="91514431" if key=="uuid:629b4d41-f6e6-45bd-8995-b9fce3265aeb"
replace rematch="2" if key=="uuid:629b4d41-f6e6-45bd-8995-b9fce3265aeb"

*Student 32 - Hadja Ouma Diallo
replace id_number="91514432" if key=="uuid:c96b2738-97e8-4fbc-9d70-0a283070d6c1"
replace rematch="2" if key=="uuid:c96b2738-97e8-4fbc-9d70-0a283070d6c1"

*Student 34 - Hadja Ouma Diallo
replace id_number="91514434" if key=="uuid:5d98e5ce-9eaa-43e6-bd96-8057c3981d0b"
replace rematch="2" if key=="uuid:5d98e5ce-9eaa-43e6-bd96-8057c3981d0b"

*Student 39 - Hadja Ouma Diallo
replace id_number="91514439" if key=="uuid:c7fa489a-b7af-4dce-9e04-42524c6cba4e"
replace rematch="2" if key=="uuid:c7fa489a-b7af-4dce-9e04-42524c6cba4e"

*Student 44 - Hadja Ouma Diallo
replace id_number="91514444" if key=="uuid:b10f9409-f2f6-49cb-9a3e-2d9e4143dc82"
replace rematch="2" if key=="uuid:b10f9409-f2f6-49cb-9a3e-2d9e4143dc82"

*Student 46 - Hadja Ouma Diallo
replace id_number="91514446" if key=="uuid:5c427d8e-a82e-4f16-9450-bcef3fba60df"
replace rematch="2" if key=="uuid:5c427d8e-a82e-4f16-9450-bcef3fba60df"

*Student 48 - Hadja Ouma Diallo
replace id_number="91514448" if key=="uuid:a65ad928-abd6-4633-ab68-6d824c072c21"
replace rematch="2" if key=="uuid:a65ad928-abd6-4633-ab68-6d824c072c21"

*Student 49 - Hadja Ouma Diallo
replace id_number="91514449" if key=="uuid:73bf5a5c-644b-42ed-840d-23fed3a77f0b"
replace rematch="2" if key=="uuid:73bf5a5c-644b-42ed-840d-23fed3a77f0b"

*Student 17 - Saint Andre
replace id_number="91506617" if key=="uuid:5c00aee3-8ff5-4c20-9443-10f88019fadc"
replace rematch="2" if key=="uuid:5c00aee3-8ff5-4c20-9443-10f88019fadc"

*Student 13 - Alpha Amadou Tahirou Diallo
replace id_number="91528713" if key=="uuid:061e58f1-79bf-486c-bd7a-91a3e0878e15"
replace rematch="2" if key=="uuid:061e58f1-79bf-486c-bd7a-91a3e0878e15"

*Student 15 - Saint Andre
replace id_number="91506615" if key=="uuid:4282d546-ef64-4187-bca4-790a57305e85"
replace rematch="2" if key=="uuid:4282d546-ef64-4187-bca4-790a57305e85"

*Student 6 - Gnenouyah
replace id_number="9144066" if key=="uuid:011c2557-b3ee-454f-a5ba-ce83f3154e2c"
replace rematch="2" if key=="uuid:011c2557-b3ee-454f-a5ba-ce83f3154e2c"

*Student 38 - Lansana Diaby
replace id_number="91514838" if key=="uuid:d8ca6cba-21fd-4162-923c-d5c9e14fc3e9"
replace rematch="2" if key=="uuid:d8ca6cba-21fd-4162-923c-d5c9e14fc3e9"

*Student 41 - Hadja Mariama Soumah
replace id_number="91522141" if key=="uuid:31ab611b-b015-4432-a169-2a5e04893578"
replace rematch="2" if key=="uuid:31ab611b-b015-4432-a169-2a5e04893578"

*Student 40 - Koumandian Keita 3
replace id_number="91512340" if key=="uuid:b1436ac1-feb4-475f-b574-feece3810df5"
replace rematch="2" if key=="uuid:b1436ac1-feb4-475f-b574-feece3810df5"

*Student 42 - Koumandian Keita 3
replace id_number="91512342" if key=="uuid:d5e06c47-dfba-4c2d-bf83-0cce485e491f"
replace rematch="2" if key=="uuid:d5e06c47-dfba-4c2d-bf83-0cce485e491f"

*Student 34 - Mahatma Gandhi
replace id_number="91518834" if key=="uuid:f75c15d2-1c9e-4d4f-9303-b86a1e68539a"
replace rematch="2" if key=="uuid:f75c15d2-1c9e-4d4f-9303-b86a1e68539a"

*Student 46 - Alama Traoré
replace id_number="91508446" if key=="uuid:fa36c1da-b0a1-44a0-a4cd-a886a5fdfc8d"
replace rematch="2" if key=="uuid:fa36c1da-b0a1-44a0-a4cd-a886a5fdfc8d"

*Student 31 - Alama Traoré
replace id_number="91508431" if key=="uuid:fc8d2822-ad73-4fa6-8eb5-849f25d3f8da"
replace rematch="2" if key=="uuid:fc8d2822-ad73-4fa6-8eb5-849f25d3f8da"

*Student 5 - M'Balia Bangoura
replace id_number="9142325" if key=="uuid:0ee5d3f0-1525-41c8-bd08-a318ad70a808"
replace rematch="2" if key=="uuid:0ee5d3f0-1525-41c8-bd08-a318ad70a808"

*Student 34 - Fella 2
replace id_number="91518634" if key=="uuid:a2282b70-2ac7-4a1f-8d0c-c37f2cbf49fd"
replace rematch="2" if key=="uuid:a2282b70-2ac7-4a1f-8d0c-c37f2cbf49fd"

*Student 39 - Abdoul Mazid Diaby
replace id_number="91508339" if key=="uuid:68da9833-e4e5-47e0-ad9b-45e78dfa0251"
replace rematch="2" if key=="uuid:68da9833-e4e5-47e0-ad9b-45e78dfa0251"

*Student 33 - KK1
replace id_number="91301133" if key=="uuid:9b6bddda-4d59-4c25-8a90-1e8714a006fa"
replace rematch="2" if key=="uuid:9b6bddda-4d59-4c25-8a90-1e8714a006fa"

*Student 31 - KK1
replace id_number="91301131" if key=="uuid:d8e54dd6-dc67-4e32-ac6e-d1be17ba652c"
replace rematch="2" if key=="uuid:d8e54dd6-dc67-4e32-ac6e-d1be17ba652c"

*Student 21 - Jean Mermoz
replace id_number="91415921" if key=="uuid:1ed89b99-b4f5-4ee3-8d67-adff2da17eb7"
replace rematch="2" if key=="uuid:1ed89b99-b4f5-4ee3-8d67-adff2da17eb7"

*Student 16 - Ahmed Sekou Toure
replace id_number="91401116" if key=="uuid:04f713a7-873f-42d0-aadf-9d649f283dc1"
replace rematch="2" if key=="uuid:04f713a7-873f-42d0-aadf-9d649f283dc1"

*Student 10 - Nelson Mandela Simbaya
replace id_number="91435810" if key=="uuid:be30dff0-035e-4dbf-a83c-9569af033329"
replace rematch="2" if key=="uuid:be30dff0-035e-4dbf-a83c-9569af033329"

*Student 41 - Nelson Mandela Simbaya
replace id_number="91435841" if key=="uuid:67a4bead-3991-495b-bf30-e69ff12b827c"
replace rematch="2" if key=="uuid:67a4bead-3991-495b-bf30-e69ff12b827c"

*Student 15 - Saint Joseph Plus
replace id_number="91505715" if key=="uuid:2cae317c-1794-46d2-802a-ba6ca92bd47b"
replace rematch="2" if key=="uuid:2cae317c-1794-46d2-802a-ba6ca92bd47b"

*Student 46 - Sonfonia
replace id_number="91503646" if key=="uuid:9cc36024-7668-461b-80ff-b6d945b5b919"
replace rematch="2" if key=="uuid:9cc36024-7668-461b-80ff-b6d945b5b919"

*Student 17 - CDLEX
replace id_number="91407917" if key=="uuid:18bc20a9-352d-440d-8f62-3255fc196b79"
replace rematch="2" if key=="uuid:18bc20a9-352d-440d-8f62-3255fc196b79"

*Student 12 - Cible du Formateur
replace id_number="91450212" if key=="uuid:b743cd57-44fd-4ebe-b4bf-349946c543e4"
replace rematch="2" if key=="uuid:b743cd57-44fd-4ebe-b4bf-349946c543e4"

*Student 23 - CDLEX
replace id_number="91407923" if key=="uuid:153cb2c6-c66c-4137-9b7a-47aebe53a541"
replace rematch="2" if key=="uuid:153cb2c6-c66c-4137-9b7a-47aebe53a541"

*Student 23 - Vingt-Huit Septembre
replace id_number="91200923" if key=="uuid:9b5e521c-6f6c-4bb9-8c98-fc7127f96f76"
replace rematch="2" if key=="uuid:9b5e521c-6f6c-4bb9-8c98-fc7127f96f76"

*Student 9 - Haute Marée 2
replace id_number="9153329" if key=="uuid:c496226e-1de8-459e-9e69-ed31f5e03dbd"
replace rematch="2" if key=="uuid:c496226e-1de8-459e-9e69-ed31f5e03dbd"

*Student 26 - Vingt-Huit Septembre
replace id_number="91200926" if key=="uuid:a0ee8ea7-8c97-4028-b86e-0f9d5a725eda"
replace rematch="2" if key=="uuid:a0ee8ea7-8c97-4028-b86e-0f9d5a725eda"

*Student 14 - Saint Georges
replace id_number="91501114" if key=="uuid:f0f3caa4-7a39-426f-a75f-0df81df65405"
replace rematch="2" if key=="uuid:f0f3caa4-7a39-426f-a75f-0df81df65405"

*Student 17 - Lucien Guilao
replace id_number="91411617" if key=="uuid:b2a395d5-a943-4458-90d2-8e496505fded"
replace rematch="2" if key=="uuid:b2a395d5-a943-4458-90d2-8e496505fded"

*Student 8 - Emmaus
replace id_number="9140198" if key=="uuid:63dc44a4-4f01-4b98-a2f3-d53fef40fe89"
replace rematch="2" if key=="uuid:63dc44a4-4f01-4b98-a2f3-d53fef40fe89"

*Student 2 - Victor Hugo
replace id_number="9149962" if key=="uuid:3284333d-e5f8-4c56-b99b-81b4495c5183"
replace rematch="2" if key=="uuid:3284333d-e5f8-4c56-b99b-81b4495c5183"

*Student 5 - Victor Hugo
replace id_number="9149965" if key=="uuid:0d0f8c6f-c9c5-44a8-aecd-47e9831e6721"
replace rematch="2" if key=="uuid:0d0f8c6f-c9c5-44a8-aecd-47e9831e6721"

*Student 13 - Victor Hugo
replace id_number="91499613" if key=="uuid:4bad0149-dd9f-442b-a2ce-2ae4fb5d8d26"
replace rematch="2" if key=="uuid:4bad0149-dd9f-442b-a2ce-2ae4fb5d8d26"

*Student 15 - Victor Hugo
replace id_number="91499615" if key=="uuid:2baddcd1-17b5-4325-92e6-f73d07802d0f"
replace rematch="2" if key=="uuid:2baddcd1-17b5-4325-92e6-f73d07802d0f"

*Student 16 - Victor Hugo
replace id_number="91499616" if key=="uuid:616e5077-166a-4e55-a27b-325d7f26437d"
replace rematch="2" if key=="uuid:616e5077-166a-4e55-a27b-325d7f26437d"

*Student 17 - Victor Hugo
replace id_number="91499617" if key=="uuid:81f0b971-e6df-461b-b5cc-b62b145f7051"
replace rematch="2" if key=="uuid:81f0b971-e6df-461b-b5cc-b62b145f7051"

*Identified in the excel file duplicate_phone1

*Student 45 - Saint Georges
replace id_number="91501145" if key=="uuid:f61654f5-de6d-40e1-bf7a-f69f65386831"
replace rematch="2" if key=="uuid:f61654f5-de6d-40e1-bf7a-f69f65386831"

*Student 14 - La Merveille
replace id_number="91532514" if key=="uuid:237e1f47-b6b5-456b-9a97-eb4b483e8b06"
replace rematch="2" if key=="uuid:237e1f47-b6b5-456b-9a97-eb4b483e8b06"

*Student 4 - Djibril Tamsir N (under id.3)
replace id_number="9140034" if key=="uuid:12ae1b81-c6e2-4425-9226-75c82acf701a"
replace rematch="2" if key=="uuid:12ae1b81-c6e2-4425-9226-75c82acf701a"

*Student 3 - Providence 3 (under id.11)
replace id_number="9150533" if key=="uuid:0fcc0952-2581-4a66-be6a-571bc4105bd7"
replace rematch="2" if key=="uuid:0fcc0952-2581-4a66-be6a-571bc4105bd7"


***UNSURE
*Student 10 - Donka
*replace id_number="91104710" if key=="uuid:88588729-c983-43d7-aff4-47d92be81b52"

drop dup
duplicates tag id_number subcon, gen(dup1)
tab dup1 subcon

/*
           |        subcon
      dup1 |         1          2 |     Total
-----------+----------------------+----------
         0 |     4,990        318 |     5,308 
         1 |       134         26 |       160 
         2 |         3          0 |         3 
-----------+----------------------+----------
     Total |     5,127        344 |     5,471 

*/


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2.2 - OTHER MISMATCHES: 24 	
***_____________________________________________________________________________

**********  WRONG SCHOOL   **********

*Students from Hadja Ouma Diallo: 915144 (registered under Hadja Oumou)
*3
replace id_number="9151443" if key=="uuid:a56e428b-f0d3-425b-bd49-d28c5b46fff8"
replace rematch="2" if key=="uuid:a56e428b-f0d3-425b-bd49-d28c5b46fff8"

*7
replace id_number="9151447" if key=="uuid:a8a6a802-468d-4608-82ee-90201b0aef5a"
replace rematch="2" if key=="uuid:a8a6a802-468d-4608-82ee-90201b0aef5a"

*19
replace id_number="91514419" if key=="uuid:7b930204-face-44da-8375-76c770099d6a"
replace rematch="2" if key=="uuid:7b930204-face-44da-8375-76c770099d6a"

*24
replace id_number="91514424" if key=="uuid:9c4148bc-85f4-4d1e-84e6-4fc338e79c36"
replace rematch="2" if key=="uuid:9c4148bc-85f4-4d1e-84e6-4fc338e79c36"

*28
replace id_number="91514428" if key=="uuid:0fc1cac0-bb8c-490e-abc0-658ff4282dc5"
replace rematch="2" if key=="uuid:0fc1cac0-bb8c-490e-abc0-658ff4282dc5"

*29
replace id_number="91514429" if key=="uuid:de226637-55ae-402d-8aaa-2f8af83df7e3"
replace rematch="2" if key=="uuid:de226637-55ae-402d-8aaa-2f8af83df7e3"

*35
replace id_number="91514435" if key=="uuid:40d390a8-cf2d-4ce6-b65a-94dfbb6c4db1"
replace rematch="2" if key=="uuid:40d390a8-cf2d-4ce6-b65a-94dfbb6c4db1"

*38
replace id_number="91514438" if key=="uuid:5458d9a2-d21a-47f5-92ed-31e6c254d3d7"
replace rematch="2" if key=="uuid:5458d9a2-d21a-47f5-92ed-31e6c254d3d7"

*42
replace id_number="91514442" if key=="uuid:fa77b635-fc4d-47e9-9618-b025bca4454c"
replace rematch="2" if key=="uuid:fa77b635-fc4d-47e9-9618-b025bca4454c"

*43
replace id_number="91514443" if key=="uuid:ffe908ca-4c37-4124-9c4e-c03f79f7e7cd"
replace rematch="2" if key=="uuid:ffe908ca-4c37-4124-9c4e-c03f79f7e7cd"

*Students from Saint Andre (registered under Hadja Ouma Diallo)
*7
replace id_number="9150667" if key=="uuid:a0ba21bb-50d9-4591-8be0-f24439c7d058"
replace rematch="2" if key=="uuid:a0ba21bb-50d9-4591-8be0-f24439c7d058"

//////////////*19
*No change for rematch
replace id_number="91506619" if key=="uuid:0e7a1d2b-0a38-46d8-80ef-b77b3b03b1ff"
replace rematch="2" if key=="uuid:0e7a1d2b-0a38-46d8-80ef-b77b3b03b1ff"

*24
replace id_number="91506624" if key=="uuid:9c4148bc-85f4-4d1e-84e6-4fc338e79c36"
replace rematch="2" if key=="uuid:9c4148bc-85f4-4d1e-84e6-4fc338e79c36"

*Students from Providence 3 (under Providence)
////////*5
*0 change for both
replace id_number="9150535" if key=="uuid:3d26ab46-932f-4e20-b202-c462260ededa"
replace rematch="2" if key=="uuid:3d26ab46-932f-4e20-b202-c462260ededa"

*16
replace id_number="91505316" if key=="uuid:c097735b-36d7-4ca6-aca6-b69733d4dfba"
replace rematch="2" if key=="uuid:c097735b-36d7-4ca6-aca6-b69733d4dfba"

*Student 7 from Gnenouyah (under El Hadj Alpha Oumar)
replace id_number="9144067" if key=="uuid:5e331f9d-09de-43ca-b750-782b08ecc0e6"
replace rematch="2" if key=="uuid:5e331f9d-09de-43ca-b750-782b08ecc0e6"

*Students from Benda (under Koumandian Keita 3)
*2
replace id_number="9141322" if key=="uuid:82258c98-ee0f-4e1b-98fc-ab974fdf9a57"
replace rematch="2" if key=="uuid:82258c98-ee0f-4e1b-98fc-ab974fdf9a57"

*4
replace id_number="9141324" if key=="uuid:fcf36271-24d9-4559-95e1-85d352f2fd0e"
replace rematch="2" if key=="uuid:fcf36271-24d9-4559-95e1-85d352f2fd0e"

*Student 28 - Alama Traore (under Koumandian Keita 3) - contact survey
replace id_number="91508428" if key=="uuid:bda77d1a-d675-4918-bd92-7d1d1b3100f1"
replace rematch="2" if key=="uuid:bda77d1a-d675-4918-bd92-7d1d1b3100f1"

*Student from Nelson Mandela (under Nelson Mandela de Simbaya)
*1
replace id_number="9149951" if key=="uuid:2b00cb39-f40f-457a-afcf-4a44e61330a9"
replace rematch="2" if key=="uuid:2b00cb39-f40f-457a-afcf-4a44e61330a9"

*2
replace id_number="9149952" if key=="uuid:181ea825-9db9-4c95-ac2b-349763841f86"
replace rematch="2" if key=="uuid:181ea825-9db9-4c95-ac2b-349763841f86"

*Student 12 from Hadja Aissata Drame (under Kabassan Keita)
replace id_number="91545912" if key=="uuid:1992d848-5854-41dd-9158-84829059283a"
replace rematch="2" if key=="uuid:1992d848-5854-41dd-9158-84829059283a"

*Student 25 from Cam-Syl (under Abou Fote) -> contact survey
replace id_number="91412525" if key=="uuid:1accc8f9-9e07-46d5-80da-f3b8700780db"
replace rematch="2" if key=="uuid:1accc8f9-9e07-46d5-80da-f3b8700780db"

***Student Survey for student 46 from La Semence (under contact survey for student 46 from Noumandian Keita)
replace id_number="91523946" if key=="uuid:a41000a8-b184-4630-9a3d-c57ed1f6f51a"
replace subcon=1 if key=="uuid:a41000a8-b184-4630-9a3d-c57ed1f6f51a"
replace rematch="2" if key=="uuid:a41000a8-b184-4630-9a3d-c57ed1f6f51a"

*Student 24 from Noumandian Keita (under Cam-Syl)
replace id_number="91504624" if key=="uuid:9964ad74-4c50-47ac-8ad1-29ac347b39b0"
replace rematch="2" if key=="uuid:9964ad74-4c50-47ac-8ad1-29ac347b39b0"

***Student 7 - Hadja Oumou (registered under Hadja Ouma Diallo)
*replace id_number="" if key=="uuid:a0ba21bb-50d9-4591-8be0-f24439c7d058"
*replace rematch="2" if key=="uuid:a0ba21bb-50d9-4591-8be0-f24439c7d058"


**********    WRONG ID NUMBER    **********
*Student 45 - Yagoubaya (under id. 16)
replace id_number="91425645" if key=="uuid:1e0932ef-d2b6-445e-81e8-38bc043f8a06"
replace rematch="2" if key=="uuid:1e0932ef-d2b6-445e-81e8-38bc043f8a06"

*Student 15 - Hadja N'Nabitou Toure (under id. 11)
replace id_number="91499915" if key=="uuid:a6226c40-436b-408f-a47d-f1de01387782"
replace rematch="2" if key=="uuid:a6226c40-436b-408f-a47d-f1de01387782"

*Student 14 - Hyndaye (under id. 12)
replace id_number="91522014" if key=="uuid:745b0286-8b93-458f-ae48-0032ad7bd647"
replace rematch="2" if key=="uuid:745b0286-8b93-458f-ae48-0032ad7bd647"

*Student 31 - Jean Mermoz (under id. 27)
replace id_number="91415931" if key=="uuid:338a07bc-0292-4f0d-9a2f-4a225f1e7352"
replace rematch="2" if key=="uuid:338a07bc-0292-4f0d-9a2f-4a225f1e7352"


drop dup1
duplicates tag id_number subcon, gen(dup2)
tab dup2 subcon

/*
           |        subcon
      dup2 |         1          2 |     Total
-----------+----------------------+----------
         0 |     4,993        317 |     5,310 
         1 |       132         26 |       158 
         2 |         3          0 |         3 
-----------+----------------------+----------
     Total |     5,128        343 |     5,471 

*/


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2.3 - DROP DUPLICATES
***_____________________________________________________________________________

*unfinished survey
*student 38 Sansy Kaba
drop if key=="uuid:ae73e9be-f8b4-4ea7-af76-e4ab68c4b659"

*student 35 
drop if key=="uuid:48dc9b35-9fd1-467f-baf8-64f778b6e2cf"

*15 inconsistent duplicates, case of mistaken identity
drop if key=="uuid:0d6ab97f-d50f-4eaa-b962-6268cf74a6b2"
drop if key=="uuid:5a5b0cca-65a1-44e5-ac85-6ebcc293e594"
drop if key=="uuid:d9d89ed4-7966-4900-a00a-7ad12e8ff2e3"
drop if key=="uuid:3273f414-afeb-4e11-8ff9-dd022baac652"
drop if key=="uuid:9f42ff57-007e-4a7e-9fa4-6566f3007e15"
drop if key=="uuid:37e4b43d-ccb5-4286-b584-1da555449a08"
drop if key=="uuid:a0a561fd-223a-41df-987d-5e61bb801db6"
drop if key=="uuid:ab76c293-2395-4171-a84e-b5fe244b5092"
drop if key=="uuid:83b68832-3a0e-44a2-ae52-b871ff1291cd"
drop if key=="uuid:0e3537f5-9d58-4ee5-b819-93dee2a49f85"
drop if key=="uuid:9263ec6f-6019-407e-8e01-87a8c70ef778"
drop if key=="uuid:44a0ab88-ba02-41fc-887a-dc18fa89660c"
drop if key=="uuid:813ae059-4e11-4f64-baba-f6256e843c14"
drop if key=="uuid:e9f1f58c-bf6f-4ce2-b5cb-0db8c67cc272"
drop if key=="uuid:c3a0df29-06a5-4130-b833-4a0c9b8a09b8"
*
drop if key=="uuid:15b787f8-0ce5-4203-bca4-13418b6201ec"
*10 inconsistent surveys (called to make sure)
*Student 24 - Kelefa Diallo
drop if key=="uuid:c6ce2c42-ea4e-4110-abee-8811aee6409b"
*Student 3 - Djomba Drame
drop if key=="uuid:ecd4793c-9bfa-4f48-ae18-5b20edd338c0"
*Student 11 - Donka
replace id_number="91104710" if key=="uuid:88588729-c983-43d7-aff4-47d92be81b52"
*Student 38 - Garaya 2: both inconsistent
drop if key=="uuid:7cd4b2db-0712-476b-becd-e2bca0e17ae9"
drop if key=="uuid:869231f4-5d39-416d-8f21-897a53385443"
*Student 44 - Mama Aicha Condé
drop if key=="uuid:686d585e-f709-4592-bd14-78803589a2a1"
*Student 24 - Loukatin
drop if key=="uuid:d2d51d75-9474-4007-869b-89ff2973ae16"
*Student 36 - Thierno Monenembo
*drop if key==""
*Student 28 - Grande Ecole
drop if key=="uuid:bf97ea7c-8072-4a66-8881-8325ca990d61"

*student surveyed twice by mistake, we keep the first one and drop the second
drop if key=="uuid:459b7135-545a-4b8e-a794-4314a13e7a60"
drop if key=="uuid:70076ed3-0876-4f1c-9ab1-a0388b91c199"
drop if key=="uuid:7a132836-7ca8-460f-b9b8-71da7cf6a553"

*40 students (details in the tab all_dup of the excel file duplicates_phone)
drop if key=="uuid:5c3e4ee9-e308-4465-9ef0-8384fc61b31c"
drop if key=="uuid:886902e2-9aa6-4a31-91bf-44062dcb9489"
drop if key=="uuid:49f40319-cf19-44ac-9f6b-e9211cef645b"
drop if key=="uuid:fd12d82b-4084-4c47-a1fe-540b128ba836"
drop if key=="uuid:6d7edb72-ec84-42cb-a383-00dd72cbb9ac"
drop if key=="uuid:8b1a82d3-8f3e-48ab-a460-deb2ba958192"
drop if key=="uuid:443fb954-95a3-4b82-8f45-b1ce4b390506"
drop if key=="uuid:bdcf52d3-a84f-497f-8b90-2f166b89a078"
drop if key=="uuid:29940a10-d9d5-40bc-941b-dbc00877c06e"
drop if key=="uuid:99ecccd7-ec2d-46f1-b80a-6e6c645f4f70"
drop if key=="uuid:9e89593d-2654-4655-b062-fde93463cf74"
drop if key=="uuid:49906cf7-e5fd-41e7-bc2c-7733bc2b7cfd"
drop if key=="uuid:8a9728ff-fb69-49ce-9a5b-acaff66bb54d"
drop if key=="uuid:4f6f5968-6a15-4138-bfac-145c2a54ac55"
drop if key=="uuid:a54941c1-1aa9-4cef-8f81-372cbc253aa8"
drop if key=="uuid:ffe49bb4-9a23-4b78-8fa0-33c5de06c26e"
drop if key=="uuid:e652b152-5ec2-4684-a22d-66d0eb6558b4"
drop if key=="uuid:451503ed-1295-4b90-9e2e-0340ff885067"
drop if key=="uuid:9526aa5f-86b6-4b60-b0c7-d11efda5e480"
drop if key=="uuid:2a8c9b48-5b58-4222-ba0f-2a27d9a2cc71"
drop if key=="uuid:f12b4237-3138-4d91-988b-2988b4f70866"
drop if key=="uuid:cbf561a2-20af-4cad-ba27-a14a0b3e2c16"
drop if key=="uuid:694f3c01-aa76-43f6-812e-ea2964ffc51a"
drop if key=="uuid:c1de0fe8-898d-49cd-9814-3a035d792c37"
drop if key=="uuid:9a0d2b19-8dc5-4c83-88d7-085093812277"
drop if key=="uuid:e8391db9-603e-489d-9263-3208593ae11f"
drop if key=="uuid:19a3a16c-9711-45d1-b047-f2a98f209b0c"
drop if key=="uuid:7b295ae7-5f96-4002-8ead-84394c0e9734"
drop if key=="uuid:181ea825-9db9-4c95-ac2b-349763841f86"
drop if key=="uuid:303d0e80-7a9c-42e3-9e69-f098314e7c42"
drop if key=="uuid:8f41cd5e-c663-4aed-add9-ea0ca6d3db5b"
drop if key=="uuid:5a043165-cc05-4ef5-aefb-334cbfe78d24"
drop if key=="uuid:e1e06843-6ea7-4f6c-9def-44dc54c56007"
drop if key=="uuid:250056ae-0538-48a3-b503-95ba54b6a58c"
drop if key=="uuid:82c12723-0f93-4b02-a55b-25ae1e72869e"
drop if key=="uuid:a103b19a-f6d5-48ca-8a09-2d95bff4e1a0"
drop if key=="uuid:e156573d-2fea-4bd6-b536-5d77eb2a772a"
drop if key=="uuid:a31ff487-7b43-4201-bd57-ab8a4e357769"
drop if key=="uuid:d163cecc-7dd1-4d97-afd6-9343f67f4b7e"
drop if key=="uuid:f5a7aca7-d02a-49a6-870b-130a29c2374c"

*extra contact survey student 12 Donka
drop if key=="uuid:5655ef6c-2041-4af1-bd57-c5855a72d636"

*identical contact surveys
drop if key=="uuid:33cefbde-4d15-4b58-8ec3-a61247d570af"

*There is no student 49 in Noumandian Keita 
drop if key=="uuid:62143bad-87ba-44a5-afa8-bb8806a8200e"


drop dup2
duplicates tag id_number subcon, gen(dup3)
tab dup3 subcon

/*
           |        subcon
      dup3 |         1          2 |     Total
-----------+----------------------+----------
         0 |     5,060        316 |     5,376 
         1 |         0         26 |        26 
-----------+----------------------+----------
     Total |     5,060        342 |     5,402 

*/

/////////////////////////////////////////////////////////////////////////////
/////////      			 3- SAVING					/////////////////
/////////////////////////////////////////////////////////////////////////////


save ${main}\Data\output\followup2\intermediaire\guinea_endline_phone_corrected, replace







