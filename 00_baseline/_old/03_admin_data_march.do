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

local general "$main/Data\raw\admin\admin_data_ministery/01_general.xlsx"
local locals "$main/Data\raw\admin\admin_data_ministery/02_locals.xlsx"
local teachers "$main/Data\raw\admin\admin_data_ministery/03_teacher.xlsx"
local selected "$main/school_selection/selected_schools_final.xlsx"
local fees "$main/Data/raw/admin/tuition_fees.xlsx"

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
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

reshape wide TYPE_LOCAL SURFACE_LOCAL NATURE_MUR NATURE_PORTE NATURE_SOL NATURE_TOIT FINANCEMENT, i(CODE) j(NUMERO_LOCAL)

forvalues i = 1/51{
	foreach x in TYPE_LOCAL NATURE_MUR NATURE_PORTE NATURE_SOL NATURE_TOIT FINANCEMENT{
		if "`x'`i'" ~= "" {
			encode `x'`i',gen(`x'`i'_coded)
}
}
}
order CODE Region Prefecture LIBELLE_DSEE NOM_ETABLISSEMENT Type Statut Nature 
keep CODE Region Prefecture LIBELLE_DSEE NOM_ETABLISSEMENT Type Statut Nature number_local *coded
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
bys CODE : gen number_teachers=_N
keep Region Prefecture LIBELLE_DSEE NOM_ETABLISSEMENT CODE NO SEXE DIPLOME_ACADEMIQUE DIPLOME_PROFESSIONNEL number_teachers
reshape wide SEXE DIPLOME_ACADEMIQUE DIPLOME_PROFESSIONNEL, i(CODE) j(NO)


forvalues i = 1/115{
	foreach x in SEXE DIPLOME_ACADEMIQUE DIPLOME_PROFESSIONNEL{
		if "`x'`i'" ~= "" {
			encode `x'`i',gen(`x'`i'_coded)
}
}
}

keep CODE number_teachers *coded
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
if status!="a demander" {
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
label var fee_11_b "Tuition fees for 11e students (including réinscription fees"

label var fee_12_a "Tuition fees for 12e students (including inscription fees"
label var fee_12_b "Tuition fees for 12e students (including réinscription fees"

label var fee_Term_a "Tuition fees for Terminale students (including inscription fees"
label var fee_Term_b "Tuition fees for Terminale students (including réinscription fees"

rename status status_tuition_collect
tempfile fees
save `fees', replace


*merging fees with the other admin data
use `gen_loc_selected_new', clear
merge 1:1 N using `fees'
keep if _merge==3
drop AK AL



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 2-CLEANING      
***_____________________________________________________________________________
*keeping the relevant info
drop MEL CHEF_ETABLISSEMENT Region commune quartier _merge


* labeling 
label var etab_quest "School names used in the student questionnaire"
label var etab "School names used in the file lycee_conakry"
label var NOM_ETABLISSEMENT "School names used by the Ministry"

label var CODE "School identification number used by the Ministry"
label var N "School number used in the excel file lycee_conarky"

*encoding the variables

encode Prefecture, gen(commune)
drop Prefecture

encode LIBELLE_DSEE, gen(libelle_dsee)
drop LIBELLE_DSEE

encode Type, gen(type)
drop Type

encode DescriptifGlobalStatut, gen(status)
drop DescriptifGlobalStatut

encode Nature, gen(nature)
drop Nature

destring(Eff_Filles), replace
rename Eff_Filles nb_girls

destring(Eff_Elves), replace
rename Eff_Elves nb_students

destring(NB_GP), replace
rename NB_GP nb_GP

destring(NB_Salles), replace
rename NB_Salle nb_classroom

destring(Enseignants), replace
rename Enseignants nb_teachers

destring(PersAdminEntretien), replace
rename PersAdminEntretien admin_staff


order N CODE NOM_ETABLISSEMENT etab_quest etab commune libelle_dsee type status nature fee* status_tuition_collect


save "$output\admin_data.dta",replace
