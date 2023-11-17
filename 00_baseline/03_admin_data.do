/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE      :    03 - CLEANING ADMIN DATA
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
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

*findit renvars
*ssc install cleanchars

*Cloe User
*global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

********************************************************************************
//,\\'//,\\'//,\\'//,\\           PARAMETRES            //,\\'//,\\'//,\\'//,\\'
********************************************************************************
* chemins
global output "$main/Data/output/admin"

local general "$main/Data/raw/admin/admin_data_ministery/01_general.xlsx"
local locals "$main/Data/raw/admin/admin_data_ministery/02_locals.xlsx"
local teachers "$main/Data/raw/admin/admin_data_ministery/03_teacher.xlsx"
local selected "$main/school_selection/selected_schools_final.xlsx"
local fees "$main/Data/raw/admin/tuition_fees.xlsx"

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*** 1- MERGING THE 3 TYPES OF ADMIN DATA          
***_____________________________________________________________________________


********************************************************************************
********* restricting the data for the 160 selected schools *******************
********************************************************************************

import excel using "`general'", firstrow clear
tempfile general_new


*DUPLICATES CLEANING
*dropping the duplicates in the list of the ministery (none of them is part of our sample)
	duplicates list CODE
*>>no duplicates

*checking duplicates for schools'names
	duplicates list NOM_ETABLISSEMENT Prefecture
*there are 3 real duplicates and 4 schools which have the same name =not a duplicates
*I drop the 3 real duplicates and rename the other schools
	replace NOM_ETABLISSEMENT="GS/ SAINT DAVID TOMBOLIA" if _n==327
	replace NOM_ETABLISSEMENT="LAVOISIER COLLEGE" if _n==242
	replace NOM_ETABLISSEMENT="SAINT MICHEL SIMBAYA" if _n==570
	replace NOM_ETABLISSEMENT="GANGAN BONFI" if _n==65
	duplicates drop NOM_ETABLISSEMENT, force
	
save `general_new', replace





import excel using "`selected'", firstrow clear
tempfile selected_new
rename etab_admin_data NOM_ETABLISSEMENT
save `selected_new', replace




use "`selected_new'", clear
merge 1:1 NOM_ETABLISSEMENT using "`general_new'"
keep if _merge==3
drop _merge
tempfile gen_selected_new
save `gen_selected_new', replace



********************************************************************************
******* Merging the general inforamtion and the data on the locals ************
********************************************************************************
*wide reshaping the information on locals
import excel using "`locals'", firstrow clear
bys CODE : gen number_local=_N

foreach x in TYPE_LOCAL NATURE_MUR NATURE_PORTE NATURE_SOL NATURE_TOIT FINANCEMENT{
		if "`x'" ~= "" {
			encode `x',gen(`x'_coded)
			drop `x'
			rename `x'_coded `x'
		}
		}

reshape wide TYPE_LOCAL SURFACE_LOCAL NATURE_MUR NATURE_PORTE NATURE_SOL NATURE_TOIT FINANCEMENT, i(CODE) j(NUMERO_LOCAL)

order CODE Region Prefecture LIBELLE_DSEE NOM_ETABLISSEMENT Type Statut Nature 
tempfile locals_new
save `locals_new', replace

*merge
use "`gen_selected_new'", clear
merge 1:1 CODE NOM_ETABLISSEMENT using "`locals_new'"
keep if _merge==3 //keeping the info on the 160 selected schools only
drop _merge
tempfile gen_loc_selected_new
save `gen_loc_selected_new', replace


********************************************************************************
*******          Merge with the data on the data on teachesr        ************
********************************************************************************
*wide reshaping the information teachers
import excel using "`teachers'", firstrow clear
keep Region Prefecture LIBELLE_DSEE NOM_ETABLISSEMENT CODE NO SEXE DIPLOME_ACADEMIQUE DIPLOME_PROFESSIONNEL

foreach x in SEXE DIPLOME_ACADEMIQUE DIPLOME_PROFESSIONNEL{
		if "`x'" ~= "" {
			encode `x',gen(`x'_coded)
			drop `x'
			rename `x'_coded `x'
		}
		}
reshape wide SEXE DIPLOME_ACADEMIQUE DIPLOME_PROFESSIONNEL, i(CODE) j(NO)

	
keep CODE SEXE* DIPLOME_ACADEMIQUE* DIPLOME_PROFESSIONNEL*
tempfile teacher_new
save `teacher_new', replace



*merge general/teacher/local
use `gen_loc_selected_new', clear
merge 1:1 CODE using `teacher_new'
keep if _merge==3
drop _merge
tempfile gen_loc_selected_new
save `gen_loc_selected_new', replace




********************************************************************************
****************       ADDING THE DATA ON TUITION FEES       *******************
********************************************************************************

import excel using "`fees'", firstrow clear
keep N inscription_fee inscription_fee_terminal reinscription_fee reinscription_fee_terminale tuition_fee_11e tuition_fee_12e tuition_fee_terminale frais_inscrip_inclu status


*cleaning
replace inscription_fee="." if inscription_fee==""
replace inscription_fee_terminal="." if inscription_fee_terminal==""
replace reinscription_fee="." if reinscription_fee==""
replace reinscription_fee_terminale="." if reinscription_fee_terminale==""

destring *_fee*, replace


*generating total fees
if status==.{
egen fee_11_a=rowtotal(inscription_fee tuition_fee_11e)
egen fee_11_b=rowtotal(reinscription_fee tuition_fee_11e)

egen fee_12_a=rowtotal(inscription_fee tuition_fee_12e)
egen fee_12_b=rowtotal(reinscription_fee tuition_fee_12e)

replace inscription_fee_terminal=inscription_fee if inscription_fee_terminal==.
replace reinscription_fee_terminale=reinscription_fee if reinscription_fee_terminale==.
egen fee_Term_a=rowtotal(inscription_fee_terminal tuition_fee_terminale )
egen fee_Term_b=rowtotal(reinscription_fee_terminale tuition_fee_terminale)
}

keep N fee_11_a fee_11_b fee_12_a fee_12_b fee_Term_a fee_Term_b status

*label
label var fee_11_a "Tuition fees for 11e students (including inscription fees"
label var fee_11_b "Tuition fees for 11e students (including rÈinscription fees"

label var fee_12_a "Tuition fees for 12e students (including inscription fees"
label var fee_12_b "Tuition fees for 12e students (including rÈinscription fees"

label var fee_Term_a "Tuition fees for Terminale students (including inscription fees"
label var fee_Term_b "Tuition fees for Terminale students (including rÈinscription fees"

rename status status_tuition_collect
tempfile fees
save `fees', replace


*merging fees with the other admin data
use `gen_loc_selected_new', clear
merge 1:1 N using `fees'
keep if _merge==3
drop AK AL



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*** 2-CLEANING      
***_____________________________________________________________________________

cleanchars , in("è") out("") vname
cleanchars , in("é") out("") vname

*keeping the relevant info
drop MEL CHEF_ETABLISSEMENT Region commune quartier _merge etab Statut status_tuition_collect source Status_admin_collect TELEPHONE

*cleaning
label define yes_no_bis 0"No" 1"Yes"

label var N "School number used in the excel file lycee_conarky"

label var NOM_ETABLISSEMENT "School names used by the Ministry of Edcuation"

label var etab_quest "School names used in the student questionnaire"

encode Prefecture, gen(commune)
drop Prefecture
label var commune "Commune"

encode LIBELLE_DSEE, gen(libelle_dsee)
drop LIBELLE_DSEE
label var libelle_dsee "Area"

label var CODE "School identification number used by the Ministry of education"

encode Type, gen(type)
	drop Type
	label variable type "Type of school : College/LycÈe/College and LycÈe "


encode DescriptifGlobalStatut, gen(status)
	drop DescriptifGlobalStatut
	label variable status "Public/Private"
	label define STATUS 1"Private"  2"Public"
	label values status STATUS


encode Nature, gen(nature)
	drop Nature
	label define NATURE 1"OTHER" 2"SECULAR"
	label values nature NATURE 


destring(Eff_Filles), replace
	rename Eff_Filles nb_girls
	label variable nb_girls "Total number of female students in secondary high school (lycee+college)"

destring(Eff_Elves), replace
	rename Eff_Elves nb_students
	label variable nb_students "Total number of students in secondary high school (lycee+college)"
	
rename Annecration foundation_date
	label variable foundation_date "Year of fondation"
	destring(foundation_date), replace
	
destring(NB_GP), replace
	rename NB_GP nb_educ_group
	label variable nb_educ_group "Number of educational groups  in secondary high school (lycee+college)"
	
destring(NB_Salles), replace
	rename NB_Salle nb_classroom
	label variable nb_classroom "Number of classrooms  in secondary high school (lycee+college)"

destring(Enseignants), replace
	rename Enseignants nb_teachers
	label variable nb_teachers "Number of teachers in secondary high school (lycee+college)"

destring(PersAdminEntretien), replace
	rename PersAdminEntretien admin_staff
	label variable admin_staff "Number administration and maintenance staff  in secondary high school (lycee+college)"
	
	
rename Eau_Ecole water
	label values water yes_no_bis
	label variable water "Water in the school ?"
	
rename INFIRMERIE infirmary 
	label values infirmary yes_no_bis
	label  variable infirmary "Infirmary in the school ?"
	
	
rename LATRINES_DISPO toilets
	label values toilets yes_no_bis
	label variable toilets "Toilets in the school ?"

rename NB_LATRINES nb_toilets
	label variable nb_toilets "Number of toilets facilities in the school? "

rename LATRINES_SEPAREES separate_toilets
	label values separate_toilets yes_no_bis
	label variable separate_toilets "Separate toilets facilities in the school ?"
	
rename LATRINES_FILLES toilets_girls
	label variable toilets_girls "Number of separate toilets facilities for girls ?"

rename LATRINES_GARCONS toilets_boys
	label variable toilets_boys "Number of separate toilets facilities for boys ?"
	
rename BIBLIOTHEQUE library
	label values library yes_no_bis
	label variable library "Library in the school ?"

rename Connexion connexion
	label values connexion yes_no_bis
	label var connexion "Connexion in the school ?"
	
	
rename RedoublGarcons male_repeaters
	label variable male_repeaters "Number of male repeaters last year in secondary high school (lycee+college)"

rename RedoublFilles female_repeaters
	label variable female_repeaters "Number of female repeaters last year  in secondary high school (lycee+college)"

rename TransArGarcons male_transfers
	label variable male_transfers "Number of male students who come from another school last year in secondary high school (lycee+college)"

rename TransArFilles female_transfers
	label variable female_transfers "Number of female students who come from another school last year  in secondary high school (lycee+college)"

rename Ordinateurs computer
	label variable computer "Number of computers in the school"

rename Imprimantes printer
	label variable printer "Number of printers in the school"

rename Tlviseur television
	label variable television "Number of televisions in the school"

rename Duplicaturs scanner
	label variable scanner "Number of duplicators/Scanner in the school"

rename Photocopieurs photocopiers
	label variable photocopiers "Number of photocopiers in the school"

label variable number_local "Number of rooms in secondary high school (lycee+college)"

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




***  ROOMS ***
rename TYPE_LOCAL* room*
	recode room* (9=1) (10=2) (11=3) (4=4) (3=5) (2=6) (6=7) (5=8) (7=9) (8=10) (1=11)
	label define type_local 1"Classrrom" 2"Computer room" 3"Teacher's room"  4"Office" 5"Toilets" 6"Library" 7"Infirmary"  8"School Canteen"  9"Accomodation" 10 "Shop" 11"Other" 

rename NATURE_MUR* wall*
	label define wall_type 1 "Hard wall" 2"No wall"

rename NATURE_PORTE* door*
	recode door* (2=1) (4=2) (1=3) (4=4)
	label define door_type 1"Metal" 2"Sheet metal/Wood" 3"Wood" 4"No Door"

rename NATURE_SOL* ground*
	recode ground* (2=1) (4=2) (3=3) (1=4)
	label define ground_type 1"Concrete" 2"Tiles" 3"Ground" 4"Other"

rename NATURE_TOIT* roof*
	recode roof* (3=1) (2=2) (3=1)
	label define roof_type 1"Sheet metal" 2"Roof tile/Concrete" 3"No Roof"

rename FINANCEMENT* procurement*
	recode procurement* (5=1) (4=2) (3=3) (2=4) (1=5)
	label define finance_source 1"Private" 2"State" 3"Self financing" 4"From outside" 5"Parent's school/Communauty"

forvalues i=1/51 {
	destring SURFACE_LOCAL`i',replace
	rename SURFACE_LOCAL`i' surface_room`i'
	label var surface_room`i' "Surface of Room `i'"
	
	label values room`i' type_local
	label var room`i' "Type of Room `i'"
	
	label values wall`i' wall_type
	label var wall`i' "Type of Wall `i'"
	
	label values door`i' door_type
	label var door`i' "Type of Door `i'"
	
	label values ground`i' ground_type
	label var ground`i' "Type of Ground `i'"
	
	label values roof`i' roof_type
	label var roof`i' "Type of Roof `i'"
	
	label values procurement`i' finance_source
	label var procurement`i' "Type of financing for room`i'"
	
	}

*teachers
rename SEXE* gender*
recode gender* (1=2) (2=1)
label define gender 1"Male" 2"Female"

rename DIPLOME_ACADEMIQUE* degree_t*
recode degree_t* (10=1) (11=2) (7=3) (8=4) (9=5) (3=6) (4=7) (5=8) (6=9) (2=10) (1=11)
label define degree_t 1" Bachelor" 2"1rst year of Master (Bac+4)" 3"Master (DEA/DESS/Master2)" 4"Two-year university degree (DEUG, Bac+2)" 5"PhD"  6"Bac (2nd part)" 7"Bac1" 8"Brevet (General Certificate of Secondary Education)" 9"CEPE (Examen 7Ë)" 10"Other" 11"No Degree"

rename DIPLOME_PROFESSIONNEL* degree_t_pro*
recode degree_t_pro* (6=1) (7=2) (8=2) (4=3) (5=4) (3=5) (2=6) (1=7) (9=8)
label define degree_t_pro 1"Diploma from University/Engineer" 2"Diploma in Education(ISSEG/ENS/ENI)" 3"Advanced Technical Diplima (BTS)" 4 "National Vocational Qualification (CAP, two years after 8th grade)" 5"Vocational Training Certificate (BEP, two years after 9th grade)" 6"Other" 7"None" 8"Unspecified"

forvalues i=1/115 {
label var gender`i' "Gender of teacher`i'"
label values gender`i' gender

label var degree_t`i' "Degree of teacher`i'"
label values degree_t`i' degree_t

label var degree_t_pro`i' "Profesionnal Degree of teacher`i'"
label values degree_t_pro`i' degree_t_pro

}


* tuition fees
label variable fee_11_a "Tuition fees for 11th students(including inscription fee)"
label variable fee_11_b "Tuition fees for 11th students(including reinscription fee)"
label variable fee_12_a "Tuition fees for 12th students(including inscription fee)"
label variable fee_12_b "Tuition fees for 12th students(including reinscription fee)"
label variable fee_Term_a "Tuition fees for 13th students(including reinscription fee)"
label variable fee_Term_b "Tuition fees for 13th students(including reinscription fee)"



order N NOM_ETABLISSEMENT etab_quest CODE commune libelle_dsee type status nature nb_students nb_girls foundation_date nb_educ_group nb_classroom nb_teachers admin_staff nb_toilets toilets_girls toilets_boys water infirmary toilets separate_toilets library connexion computer printer photocopiers television scanner male_repeaters female_repeaters male_transfers female_transfers 

order toilets, before(nb_toilets)
order separate_toilets,after(nb_toilets)
	
save "$output/admin_data.dta",replace
