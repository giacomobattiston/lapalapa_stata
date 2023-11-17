/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   TITLE      :    03 - CLEANING ADMIN DATA
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*
********************************************************************************/
/*admin_data.do
Date Created:  January 20, 2019
Date Last Modified: January 20, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: .
*	Outputs: 
*/



* initialize Stata
clear all
set more off
set mem 100m


*Cloe User
global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
********************************************************************************
//,\\'//,\\'//,\\'//,\\           PARAMETRES            //,\\'//,\\'//,\\'//,\\'
********************************************************************************
* chemins
global output "$main\Data\output\admin"


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 1- DROPPING USELESS INFORMATION      
***_____________________________________________________________________________

use "$output\admin_data.dta",replace

drop etab Statut status_tuition_collect source Status_admin_collect TELEPHONE


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 1- RENAMING THE INFORMATION     
***_____________________________________________________________________________
label variable status "Public/Private"
label define STATUS 1"Private"  2"Public"
label values status STATUS

label define NATURE 1"OTHER" 2"SECULAR"
label values nature NATURE 

label variable fee_11_a "Tuition fees for 11th students(including inscription fee)"
label variable fee_11_b "Tuition fees for 11th students(including reinscription fee)"
label variable fee_12_a "Tuition fees for 12th students(including inscription fee)"
label variable fee_12_b "Tuition fees for 12th students(including reinscription fee)"
label variable fee_Term_a "Tuition fees for 13th students(including reinscription fee)"
label variable fee_Term_b "Tuition fees for 13th students(including reinscription fee)"

label variable nb_students "Total number of high school students"
label variable nb_girls "Total number of femanal high school students"

rename Annecration foundation_date
label variable foundation_date "Year of fondation"

rename nb_GP nb_gp
label variable nb_gp "Number of educational groups"

label variable nb_classroom "Number of classrooms"

label variable nb_teachers "Number of teachers"

label variable admin_staff "Number administration and maintenance staff"

rename Eau_Ecole water
label variable water "Water in the school ?"

rename INFIRMERIE infirmary
label  variable infirmary "Infirmary in the school ?"

rename LATRINES_DISPO toilets
label variable toilets "Toilets in the school ?"

rename NB_LATRINES nb_toilets
label variable nb_toilets "Number of toilets facilities in the school? "

rename LATRINES_SEPAREES  separate_toilets
label variable separate_toilets "Separate toilets facilities in the school ?"

rename LATRINES_FILLES toilets_girls
label variable toilets_girls "Number of separate toilets facilities for girls ?"

rename LATRINES_GARCONS toilets_boys
label variable toilets_boys "Number of separate toilets facilities for boys ?"

rename BIBLIOTHEQUE library
label variable library "Library in the school ?"

rename RedoublGarcons male_repeaters
label variable male_repeaters "Number of male repeaters last year"

rename RedoublFilles female_repeaters
label variable female_repeaters "Number of female repeaters last year"

rename TransArGarcons male_transfers
label variable male_transfers "Number of male students who come from another school last year ?"

rename TransArFilles female_transfers
label variable female_transfers "Number of female students who come from another school last year ?"

rename Ordinateurs computer
label variable computer "Number of computers in the school"

rename Imprimantes printer
label variable printer "Number of printers in the school"

rename Tlviseur television
label variable television "Number Television in the school"

rename Duplicaturs scanner
label variable scanner "Number of Duplicators/Scanner in the school"

rename Photocopieurs photocopiers
label variable photocopiers "Number of photocopiers in the school"

label variable number_local "Number of rooms in the school"

rename Connexion connexion

label define locals 2 "Other" 3  5"Classroom"
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 2 - CLEANING
***_____________________________________________________________________________

destring(foundation_date), replace

encode(water), gen(WATER)
	drop water
	rename WATER water
	label define yes_no3 3"Yes" 2"No"
	label values water yes_no3

encode(infirmary), gen(INFIRMARY)
	drop infirmary
	rename INFIRMARY infirmary
	label values infirmary yes_no3
	
encode(toilets), gen(TOILETS)
	drop toilets
	rename TOILETS toilets
	label values toilets yes_no3
	
encode(separate_toilets), gen(S_TOILETS)
	drop separate_toilets
	rename S_TOILETS separate_toilets
	label values separate_toilets yes_no3

encode(library), gen(LIBRARY)
	drop library
	rename LIBRARY library
	label values library yes_no3
	
encode(connexion), gen(CONNEXION)
	drop connexion
	rename CONNEXION connexion
	label values connexion yes_no3
	
	
destring(nb_toilets), replace
destring(toilets_girls), replace
destring(toilets_boys), replace
destring(male_repeaters),replace
destring(female_repeaters),replace
destring(male_transfers),replace
destring(female_transfers),replace
destring(computer),replace
destring(printer),replace
destring(photocopiers),replace
destring(television),replace
destring(scanner),replace
