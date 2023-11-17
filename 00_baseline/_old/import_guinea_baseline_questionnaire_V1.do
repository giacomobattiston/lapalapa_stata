/*
import_guinea_baseline_questionnaire.do
Date Created:  December 7, 2018
Date Last Modified: November 28, 2018
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
* 	Imports and aggregates "guinea_baseline_questionnaire" (ID: guinea_baseline_questionnaire) data.
*	Inputs: .csv file(s) exported by the SurveyCTO Sync
*	Outputs: "C:/Users/cloes_000/Documents/RA-Guinee/Lapa Lapa/logistics/03_data/04_final_data/data/guinea_baseline_questionnaire.dta"
*
*/


* initialize Stata
clear all
set more off
set mem 100m

* initialize workflow-specific parameters
*	Set overwrite_old_data to 1 if you use the review and correction
*	workflow and allow un-approving of submissions. If you do this,
*	incoming data will overwrite old data, so you won't want to make
*	changes to data in your local .dta file (such changes can be
*	overwritten with each new import).
local overwrite_old_data 0

********************************************************************************
//,\\'//,\\'//,\\'//,\\           PARAMETRES            //,\\'//,\\'//,\\'//,\\'
********************************************************************************
* chemins
global main "C:\Users\cloes_000\Documents\RA-Guin�e\Lapa Lapa\logistics\03_data\04_final_data"
local csvfile "$main/raw/guinea_baseline_questionnaire_WIDE.csv"
local dtafile "$main/data/guinea_baseline_questionnaire.dta"
local output "$main/output/questionnaire_baseline_clean.dta"

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
local expectation "sec3_32 sec3_34 sec3_34_error_millions sec3_34_error_thousands sec3_34_error_millions_2 sec3_34_error_thousands_2 sec3_34_bis sec3_35 sec3_37 sec3_38 sec3_39 sec3_40 sec3_41 sec3_42"
local money_quest "sec3_2 sec3_12 sec3_25 sec3_34 sec3_34_bis sec3_42 sec4_q1 sec4_q2 sec4_q3 sec4_q4 sec8_q5 sec8_q6"


* fichiers de corrections *
*unfinished questionnaire
local corrfile1 "$main/correction_file/unfinished_questionnaire_1.xlsx" // Les questionnaires non-finalis�s 1
local corrfile2 "$main/correction_file/unfinished_questionnaire_2.xlsx" //Les questionnaires non-finalis�s 2
local corrfile3 "$main/correction_file/unfinished_questionnaire_3.xlsx" //Les questionnaires non-finalis�s 3
local nbcorr 1 2 3



***�����������������������������������������������������������������������������
***   1 - Imports datasets                                                  
***_____________________________________________________________________________

disp
disp "Starting import of: `csvfile'"
disp

* import data from primary .csv file
insheet using "`csvfile'", names clear


* drop extra table-list columns
cap drop reserved_name_for_field_*
cap drop generated_table_list_lab*




***�����������������������������������������������������������������������������
***   2 - Formats                                          
***_____________________________________________________________________________


	* drop note fields (since they don't contain any real data)
	forvalues i = 1/100 {
		if "`note_fields`i''" ~= "" {
			drop `note_fields`i''
		}
	}
	



	
		* format date and date/time fields
forvalues i = 1/100 {
	if "`datetime_fields`i''" ~= "" {
	foreach dtvarlist in `datetime_fields`i'' {
split `dtvarlist' // split the variables into 4 sub-variables
* replace months into numbers 
replace `dtvarlist'2="10" if `dtvarlist'2=="oct."
replace `dtvarlist'2="11" if `dtvarlist'2=="nov."
replace `dtvarlist'2="12" if `dtvarlist'2=="déc."
replace `dtvarlist'2="1" if `dtvarlist'2=="janv."
replace `dtvarlist'2="2" if `dtvarlist'2=="feb."

}
}
}

* date 
foreach var in starttime submissiondate endtime {
g `var'_new=`var'2 +"-" + `var'1 + "-"+ `var'3 
gen `var'_new_date=date(`var'_new, "MDY", 2018) if `var'3=="2018"
replace `var'_new_date=date(`var'_new, "MDY", 2019) if `var'3=="2019"
format `var'_new_date %td


gen `var'_new_hour=clock(`var'4,"hms")
format `var'_new_hour %tC
}

drop submissiondate1 submissiondate2 submissiondate3 submissiondate4 starttime1 starttime2 starttime3 starttime_new starttime4 endtime1 endtime2 endtime3 endtime4 submissiondate_new endtime_new


  

	
	
	
	e
	
	* ensure that text fields are always imported as strings (with "" for missing values)
	* (note that we treat "calculate" fields as text; you can destring later if you wish)
	tempvar ismissingvar
	quietly: gen `ismissingvar'=.
	forvalues i = 1/100 {
		if "`text_fields`i''" ~= "" {
			foreach svarlist in `text_fields`i'' {
				cap unab svarlist : `svarlist'
				if _rc==0 {
					foreach stringvar in `svarlist' {
						quietly: replace `ismissingvar'=.
						quietly: cap replace `ismissingvar'=1 if `stringvar'==.
						cap tostring `stringvar', format(%100.0g) replace
						cap replace `stringvar'="" if `ismissingvar'==1
					}
				}
			}
		}
	}
	quietly: drop `ismissingvar'


	* consolidate unique ID into "key" variable
	replace key=instanceid if key==""
	drop instanceid


	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable consent_agree "Acceptes-tu de participer à l’enquête ?"
	note consent_agree: "Acceptes-tu de participer à l’enquête ?"
	label define consent_agree 1 "Oui" 2 "Non"
	label values consent_agree consent_agree

	label variable commune "Dans commune se trouve ton lycée ?"
	note commune: "Dans commune se trouve ton lycée ?"

	label variable lycee_name "Dans quel lycée étudies-tu ?"
	note lycee_name: "Dans quel lycée étudies-tu ?"

	label variable sec0_q1_a "Quels sont ton/tes prénom(s) ?"
	note sec0_q1_a: "Quels sont ton/tes prénom(s) ?"

	label variable sec0_q1_b "Quel est ton nom ?"
	note sec0_q1_b: "Quel est ton nom ?"

	label variable sec0_q2 "De quel sexe es-tu ?"
	note sec0_q2: "De quel sexe es-tu ?"
	label define sec0_q2 1 "Homme" 2 "Femme"
	label values sec0_q2 sec0_q2

	label variable sec0_q3 "Quelle est ta date de naissance ?"
	note sec0_q3: "Quelle est ta date de naissance ?"

	label variable sec0_q4 "En quelle classe es-tu ?"
	note sec0_q4: "En quelle classe es-tu ?"
	label define sec0_q4 1 "7e" 2 "8e" 3 "9e" 4 "10e" 5 "11e" 6 "12e" 7 "Terminale"
	label values sec0_q4 sec0_q4

	label variable sec0_q5_a "Quelle est ton option ?"
	note sec0_q5_a: "Quelle est ton option ?"
	label define sec0_q5_a 1 "Sciences Expérimentales" 2 "Sciences Sociales" 3 "Sciences Mathématiques"
	label values sec0_q5_a sec0_q5_a

	label variable sec0_q5_b "Quel est le numéro ou la lettre de ta classe ?"
	note sec0_q5_b: "Quel est le numéro ou la lettre de ta classe ?"

	label variable sec0_q6 "Quel est ton numéro de téléphone principal ?"
	note sec0_q6: "Quel est ton numéro de téléphone principal ?"

	label variable sec0_q6_fb "As-tu un compte facebook ?"
	note sec0_q6_fb: "As-tu un compte facebook ?"
	label define sec0_q6_fb 1 "Oui" 2 "Non"
	label values sec0_q6_fb sec0_q6_fb

	label variable sec0_q6_mail "Quel est l'adresse mail associée à ton compte facebook ?"
	note sec0_q6_mail: "Quel est l'adresse mail associée à ton compte facebook ?"

	label variable friend_name1 "Prénom et nom de la 1ère personne à contacter :"
	note friend_name1: "Prénom et nom de la 1ère personne à contacter :"

	label variable friend_phone1 "Numéro de téléphone de la 1ère personne à contacter :"
	note friend_phone1: "Numéro de téléphone de la 1ère personne à contacter :"

	label variable friend_name2 "Prénom et nom de la 2nde personne à contacter :"
	note friend_name2: "Prénom et nom de la 2nde personne à contacter :"

	label variable friend_phone2 "Numéro de téléphone de la 2nde personne à contacter :"
	note friend_phone2: "Numéro de téléphone de la 2nde personne à contacter :"

	label variable sec0_q7 "Où es-tu né(e) ?"
	note sec0_q7: "Où es-tu né(e) ?"
	label define sec0_q7 1 "À Conakry" 2 "En dehors de Conakry, mais en Guinée" 3 "En dehors de la Guinée, mais en Afrique" 4 "Autre"
	label values sec0_q7 sec0_q7

	label variable sec0_q8 "Où habites-tu ?"
	note sec0_q8: "Où habites-tu ?"
	label define sec0_q8 1 "À Conakry" 2 "En dehors de Conakry, mais en Guinée" 3 "En dehors de la Guinée, mais en Afrique" 4 "Autre"
	label values sec0_q8 sec0_q8

	label variable sec0_q10 "À quelle religion appartiens-tu ?"
	note sec0_q10: "À quelle religion appartiens-tu ?"
	label define sec0_q10 1 "Musulmane" 2 "Chrétienne Catholique" 3 "Chrétienne Evangéliste" 4 "Chrétienne Protestante (sauf Evangéliste)" 5 "Autre" 6 "Aucune"
	label values sec0_q10 sec0_q10

	label variable sec0_q11 "EN PLUS DU FRANÇAIS, quelle est la langue que tu parles le plus avec ta famille?"
	note sec0_q11: "EN PLUS DU FRANÇAIS, quelle est la langue que tu parles le plus avec ta famille?"
	label define sec0_q11 1 "Soussou" 2 "Malinké" 3 "Pular" 4 "Kpele" 5 "Kissi" 6 "Loma" 7 "Baga" 8 "Coniagui" 9 "Autre langue parlée en Guinée" 10 "Autre langue" 11 "Je ne parle que français"
	label values sec0_q11 sec0_q11

	label variable sec1_1 "Combien de personnes vivent dans ta maison toi inclus ?"
	note sec1_1: "Combien de personnes vivent dans ta maison toi inclus ?"

	label variable sec1_2 "Ta mère est-elle toujours en vie?"
	note sec1_2: "Ta mère est-elle toujours en vie?"
	label define sec1_2 1 "Oui" 2 "Non"
	label values sec1_2 sec1_2

	label variable sec1_3 "Où vit-elle ?"
	note sec1_3: "Où vit-elle ?"
	label define sec1_3 1 "À Conakry" 2 "En dehors de Conakry, mais en Guinée" 3 "En dehors de la Guinée, mais en Afrique" 4 "Autre"
	label values sec1_3 sec1_3

	label variable sec1_5 "A-t-elle déjà fréquenté l’école ?"
	note sec1_5: "A-t-elle déjà fréquenté l’école ?"
	label define sec1_5 1 "Oui" 2 "Non"
	label values sec1_5 sec1_5

	label variable sec1_6 "Quel est le plus haut niveau d’étude qu’elle a complété ?"
	note sec1_6: "Quel est le plus haut niveau d’étude qu’elle a complété ?"
	label define sec1_6 0 "Maternelle" 1 "Ecole Primaire" 2 "Ecole Secondaire (Collège, Lycée)" 3 "Etudes supérieures (Université)" 99 "Je ne sais pas"
	label values sec1_6 sec1_6

	label variable sec1_7 "Ta mère a-t-elle eu un travail au cours des 12 derniers mois ?"
	note sec1_7: "Ta mère a-t-elle eu un travail au cours des 12 derniers mois ?"
	label define sec1_7 1 "Oui" 2 "Non"
	label values sec1_7 sec1_7

	label variable sec1_8 "Au cours des 12 derniers mois, quel est a été son principal travail ?"
	note sec1_8: "Au cours des 12 derniers mois, quel est a été son principal travail ?"
	label define sec1_8 1 "Ventes et Services (ex : vendeuse/entrepreneure)" 2 "Agriculture (incluant pêche, élevage et chasse)" 3 "Travailleuse manuelle qualifiée (ex : machiniste/charpentière)" 4 "Travailleuse manuelle non qualifiée (ex : constructrice de route/assembleuse)" 5 "Professionnel/technique/managérial (ex : ingénieure/assistante informatique/infi" 6 "Administratif (ex : secrétaire)" 7 "Militaire/ Paramilitaire" 8 "Service domestique pour quelqu'un d'autre (ex : employée de maison)" 99 "Je ne sais pas"
	label values sec1_8 sec1_8

	label variable sec1_9 "Ton père est-il toujours en vie?"
	note sec1_9: "Ton père est-il toujours en vie?"
	label define sec1_9 1 "Oui" 2 "Non"
	label values sec1_9 sec1_9

	label variable sec1_10 "Où vit-il ?"
	note sec1_10: "Où vit-il ?"
	label define sec1_10 1 "À Conakry" 2 "En dehors de Conakry, mais en Guinée" 3 "En dehors de la Guinée, mais en Afrique" 4 "Autre"
	label values sec1_10 sec1_10

	label variable sec1_12 "A-t-il déjà fréquenté l’école ?"
	note sec1_12: "A-t-il déjà fréquenté l’école ?"
	label define sec1_12 1 "Oui" 2 "Non"
	label values sec1_12 sec1_12

	label variable sec1_13 "Quel est le plus haut niveau d’étude qu’il a complété ?"
	note sec1_13: "Quel est le plus haut niveau d’étude qu’il a complété ?"
	label define sec1_13 0 "Maternelle" 1 "Ecole Primaire" 2 "Ecole Secondaire (Collège, Lycée)" 3 "Etudes supérieures (Université)" 99 "Je ne sais pas"
	label values sec1_13 sec1_13

	label variable sec1_14 "Ton père a-t-il eu un travail au cours des 12 derniers mois ?"
	note sec1_14: "Ton père a-t-il eu un travail au cours des 12 derniers mois ?"
	label define sec1_14 1 "Oui" 2 "Non"
	label values sec1_14 sec1_14

	label variable sec1_15 "Au cours des 12 derniers mois, quel est a été son principal travail ?"
	note sec1_15: "Au cours des 12 derniers mois, quel est a été son principal travail ?"
	label define sec1_15 1 "Ventes et Services (ex : vendeur/entrepreneur)" 2 "Agriculture (incluant pêche, élevage et chasse)" 3 "Travailleur manuel qualifié (ex : machiniste/charpentier)" 4 "Travailleur manuel non qualifié (ex : constructeur de route/assembleur)" 5 "Professionnel/technique/managérial (ex : ingénieur/assistant informatique/infirm" 6 "Administratif (ex : secrétaire)" 7 "Militaire / Paramilitaire" 8 "Service domestique pour quelqu'un d'autre (ex : employé de maison)" 99 "Je ne sais pas"
	label values sec1_15 sec1_15

	label variable sister_no "Combien de SOEURS as-tu ?"
	note sister_no: "Combien de SOEURS as-tu ?"

	label variable brother_no "Combien de FRERES as-tu ?"
	note brother_no: "Combien de FRERES as-tu ?"

	label variable sec2_q1 "Dans l’idéal, si tu en avais la possibilité, aimerais-tu t’installer de façon dé"
	note sec2_q1: "Dans l’idéal, si tu en avais la possibilité, aimerais-tu t’installer de façon définitive dans un autre pays ou aimerais-tu continuer de vivre en Guinée ?"
	label define sec2_q1 1 "Oui, je voudrais m’installer de façon définitive dans un autre pays" 2 "Non, je ne voudrais pas quitter la Guinée de façon définitive"
	label values sec2_q1 sec2_q1

	label variable sec2_q2 "Si tu pouvais t'installer n'importe où dans le monde, quel serait le pays idéal "
	note sec2_q2: "Si tu pouvais t'installer n'importe où dans le monde, quel serait le pays idéal où tu voudrais habiter?"

	label variable sec2_q3 "Pourquoi aimerais-tu t’installer de façon définitive dans un autre pays ?"
	note sec2_q3: "Pourquoi aimerais-tu t’installer de façon définitive dans un autre pays ?"

	label variable sec2_q3_other_reasonmig "Spécifie l'autre raison qui te pousse à migrer dans un autre pays."
	note sec2_q3_other_reasonmig: "Spécifie l'autre raison qui te pousse à migrer dans un autre pays."

	label variable sec2_q4 "Prévois-tu de t’installer de façon définitive dans un autre pays dans les 12 pro"
	note sec2_q4: "Prévois-tu de t’installer de façon définitive dans un autre pays dans les 12 prochains mois ?"
	label define sec2_q4 1 "Oui" 2 "Non"
	label values sec2_q4 sec2_q4

	label variable sec2_q5 "Dans quel pays prévois-tu de t’installer ?"
	note sec2_q5: "Dans quel pays prévois-tu de t’installer ?"

	label variable sec2_q7 "As-tu déjà effectué des préparatifs pour cette migration ?"
	note sec2_q7: "As-tu déjà effectué des préparatifs pour cette migration ?"
	label define sec2_q7 1 "Oui" 2 "Non"
	label values sec2_q7 sec2_q7

	label variable sec2_q7_example "Quel(s) type(s) de préparatifs as-tu fait ?"
	note sec2_q7_example: "Quel(s) type(s) de préparatifs as-tu fait ?"

	label variable sec2_q8 "As-tu planifié la date de ta migration ?"
	note sec2_q8: "As-tu planifié la date de ta migration ?"
	label define sec2_q8 1 "Oui" 2 "Non"
	label values sec2_q8 sec2_q8

	label variable sec2_q9 "Quel mois/année as-tu prévu de quitter la Guinée ?"
	note sec2_q9: "Quel mois/année as-tu prévu de quitter la Guinée ?"

	label variable sec2_q10_a "As-tu déjà demandé un visa pour entrer en \${sec2_q5} au cours des 12 prochains "
	note sec2_q10_a: "As-tu déjà demandé un visa pour entrer en \${sec2_q5} au cours des 12 prochains mois ?"
	label define sec2_q10_a 1 "Oui" 2 "Non"
	label values sec2_q10_a sec2_q10_a

	label variable sec2_q10_b "Penses-tu que tu demanderas un visa pour migrer en \${sec2_q2} ?"
	note sec2_q10_b: "Penses-tu que tu demanderas un visa pour migrer en \${sec2_q2} ?"
	label define sec2_q10_b 1 "Oui" 2 "Non"
	label values sec2_q10_b sec2_q10_b

	label variable sec2_q10_c "Penses-tu que tu demanderas un visa pour migrer en \${sec2_q5} ?"
	note sec2_q10_c: "Penses-tu que tu demanderas un visa pour migrer en \${sec2_q5} ?"
	label define sec2_q10_c 1 "Oui" 2 "Non"
	label values sec2_q10_c sec2_q10_c

	label variable sec2_q11 "Au cours de la SEMAINE dernière, as-tu abordé le sujet de la migration avec tes "
	note sec2_q11: "Au cours de la SEMAINE dernière, as-tu abordé le sujet de la migration avec tes amis, frères ou sœurs ?"
	label define sec2_q11 1 "Oui" 2 "Non"
	label values sec2_q11 sec2_q11

	label variable sec2_q12 "Au cours de la SEMAINE DERNIERE, as-tu abordé le sujet de la migration avec des "
	note sec2_q12: "Au cours de la SEMAINE DERNIERE, as-tu abordé le sujet de la migration avec des élèves d'AUTRES LYCEES ?"
	label define sec2_q12 1 "Oui" 2 "Non"
	label values sec2_q12 sec2_q12

	label variable sec2_q13 "Nom du premier lycée:"
	note sec2_q13: "Nom du premier lycée:"

	label variable sec2_q14 "Nom du deuxième lycée:"
	note sec2_q14: "Nom du deuxième lycée:"

	label variable sec2_q15 "Nom du troisième lycée:"
	note sec2_q15: "Nom du troisième lycée:"

	label variable sec3_0 "As-tu déjà entendu parler de bateaux qui emmènent des migrants de la Lybie à l'I"
	note sec3_0: "As-tu déjà entendu parler de bateaux qui emmènent des migrants de la Lybie à l'Italie ?"
	label define sec3_0 1 "Oui, principalement par la télévision" 2 "Oui, principalement en parlant avec des amis ou ma famille" 3 "Oui, principalement par les réseaux sociaux (ex : Facebook)" 4 "Oui, principalement par d'autres moyens de communication" 5 "Non, je n'en ai jamais entendu parlé"
	label values sec3_0 sec3_0

	label variable sec3_1 "En moyenne, combien de mois prendront ces personnes pour arriver en Europe après"
	note sec3_1: "En moyenne, combien de mois prendront ces personnes pour arriver en Europe après être parties de la Guinée ?"

	label variable sec3_2 "En moyenne, combien d’argent ces personnes devront dépenser pour la TOTALITE de "
	note sec3_2: "En moyenne, combien d’argent ces personnes devront dépenser pour la TOTALITE de leur voyage depuis la Guinée en Francs Guinéens ?"

	label variable sec3_3 "Parmi ces 100 personnes, combien d'entre elles vont être frappées ou abusées phy"
	note sec3_3: "Parmi ces 100 personnes, combien d'entre elles vont être frappées ou abusées physiquement durant leur trajet ?"

	label variable sec3_4 "Parmi ces 100 personnes, combien d'entre elles vont être forcées à travailler ou"
	note sec3_4: "Parmi ces 100 personnes, combien d'entre elles vont être forcées à travailler ou travailler sans être payées durant leur trajet ?"

	label variable sec3_5 "Parmi ces 100 personnes, combien d'entre elles vont être retenues contre leur vo"
	note sec3_5: "Parmi ces 100 personnes, combien d'entre elles vont être retenues contre leur volonté (emprisonnées ou kidnappées) durant leur trajet ?"

	label variable sec3_6 "Parmi ces 100 personnes qui sont parties de la Guinée, combien d'entre elles von"
	note sec3_6: "Parmi ces 100 personnes qui sont parties de la Guinée, combien d'entre elles vont MOURIR AVANT de pouvoir embarquer sur le bateau qui part vers l’Italie ?"

	label variable sec3_7 "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours "
	note sec3_7: "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours de l’année prochaine, EMBARQUENT SUR LE BATEAU pour l’Italie depuis la Lybie. Combien d’entre elles vont mourir pendant le trajet en BATEAU ?"

	label variable sec3_8 "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours "
	note sec3_8: "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours de l’année prochaine, arrivent en Italie. Combien d'entre elles vont être renvoyées en Guinée moins d'1 an après leur arrivée ?"

	label variable sec3_10 "As-tu déjà entendu parler de bateaux qui emmènent des migrants en Espagne depuis"
	note sec3_10: "As-tu déjà entendu parler de bateaux qui emmènent des migrants en Espagne depuis le Maroc ou l'Algérie ?"
	label define sec3_10 1 "Oui, principalement par la télévision" 2 "Oui, principalement en parlant avec des amis ou ma famille" 3 "Oui, principalement par les réseaux sociaux (ex : Facebook)" 4 "Oui, principalement par d'autres moyens de communication" 5 "Non, je n'en ai jamais entendu parlé"
	label values sec3_10 sec3_10

	label variable sec3_11 "En moyenne, combien de mois prendront ces personnes pour arriver en Europe après"
	note sec3_11: "En moyenne, combien de mois prendront ces personnes pour arriver en Europe après être parties de la Guinée ?"

	label variable sec3_12 "En moyenne, combien d’argent ces personnes devront dépenser pour la TOTALITE de "
	note sec3_12: "En moyenne, combien d’argent ces personnes devront dépenser pour la TOTALITE de son voyage depuis la Guinée en Francs Guinéens ?"

	label variable sec3_14 "Parmi ces 100 personnes, combien d'entre elles vont être frappées ou abusées phy"
	note sec3_14: "Parmi ces 100 personnes, combien d'entre elles vont être frappées ou abusées physiquement durant leur trajet ?"

	label variable sec3_15 "Parmi ces 100 personnes, combien d'entre elles vont être forcées à travailler ou"
	note sec3_15: "Parmi ces 100 personnes, combien d'entre elles vont être forcées à travailler ou travailler sans être payées durant leur trajet ?"

	label variable sec3_16 "Parmi ces 100 personnes, combien d'entre elles vont être retenues contre leur vo"
	note sec3_16: "Parmi ces 100 personnes, combien d'entre elles vont être retenues contre leur volonté (emprisonnées ou kidnappées) durant leur trajet ?"

	label variable sec3_17 "Parmi ces 100 personnes qui sont parties de la Guinée, combien d'entre elles von"
	note sec3_17: "Parmi ces 100 personnes qui sont parties de la Guinée, combien d'entre elles vont MOURIR AVANT de pouvoir embarquer sur le bateau qui part vers l’Espagne ?"

	label variable sec3_18 "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours "
	note sec3_18: "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours de l’année prochaine, EMBARQUENT SUR LE BATEAU pour l’Espagne depuis le Maroc ou l'Algérie. Combien d’entre elles vont mourir pendant le trajet en BATEAU ?"

	label variable sec3_19 "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours "
	note sec3_19: "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours de l’année prochaine, arrivent en Espagne. Combien d'entre elles vont être renvoyées en Guinée moins d'1 an après leur arrivée ?"

	label variable sec3_21_nb "Dans quel PAYS situé en EUROPE planifierait-elle de s'installer?"
	note sec3_21_nb: "Dans quel PAYS situé en EUROPE planifierait-elle de s'installer?"
	label define sec3_21_nb 1 "\${randomoption1}" 2 "\${randomoption2}" 3 "\${randomoption3}" 4 "\${randomoption4}" 5 "\${randomoption5}" 6 "\${randomoption6}" 7 "Autre (Spécifier)"
	label values sec3_21_nb sec3_21_nb

	label variable sec3_21_nb_other "Spécifie, s'il te plait, l'autre PAYS situé en EUROPE dans lequel elle planifier"
	note sec3_21_nb_other: "Spécifie, s'il te plait, l'autre PAYS situé en EUROPE dans lequel elle planifierait de s'installer ?"

	label variable sec3_22 "Quel trajet choisirait cette personne pour arriver en \${sec3_21} entre les deux"
	note sec3_22: "Quel trajet choisirait cette personne pour arriver en \${sec3_21} entre les deux routes décrites avant ?"
	label define sec3_22 1 "Cette personne atteindrait la rive d’Afrique du Nord en premier et ensuite prend" 2 "Cette personne atteindrait la rive d’Afrique du Nord en premier et ensuite prend"
	label values sec3_22 sec3_22

	label variable sec3_23 "As-tu déjà entendu parler de la route qui permet d'arriver en Europe en escalada"
	note sec3_23: "As-tu déjà entendu parler de la route qui permet d'arriver en Europe en escaladant le grillage de Ceuta ou de Melilla ?"
	label define sec3_23 1 "Oui, principalement par la télévision" 2 "Oui, principalement en parlant avec des amis ou ma famille" 3 "Oui, principalement par les réseaux sociaux (ex : Facebook)" 4 "Oui, principalement par d'autres moyens de communication" 5 "Non, je n'en ai jamais entendu parlé"
	label values sec3_23 sec3_23

	label variable sec3_24 "En moyenne, combien de mois prendront ces personnes pour arriver en Europe après"
	note sec3_24: "En moyenne, combien de mois prendront ces personnes pour arriver en Europe après être parties de la Guinée ?"

	label variable sec3_25 "En moyenne, combien d’argent ces personnes devra dépenser pour la TOTALITE de so"
	note sec3_25: "En moyenne, combien d’argent ces personnes devra dépenser pour la TOTALITE de son voyage depuis la Guinée en Francs Guinéens ?"

	label variable sec3_26 "Parmi ces 100 personnes, combien d'entre elles vont être frappées ou abusées phy"
	note sec3_26: "Parmi ces 100 personnes, combien d'entre elles vont être frappées ou abusées physiquement durant leur trajet ?"

	label variable sec3_27 "Parmi ces 100 personnes, combien d'entre elles vont être forcées à travailler ou"
	note sec3_27: "Parmi ces 100 personnes, combien d'entre elles vont être forcées à travailler ou travailler sans être payées durant leur trajet ?"

	label variable sec3_28 "Parmi ces 100 personnes, combien d'entre elles vont être retenues contre leur vo"
	note sec3_28: "Parmi ces 100 personnes, combien d'entre elles vont être retenues contre leur volonté (emprisonnées ou kidnappées) durant leur trajet ?"

	label variable sec3_29 "Parmi ces 100 personnes, combien d'entre elles vont mourir lors de leur trajet a"
	note sec3_29: "Parmi ces 100 personnes, combien d'entre elles vont mourir lors de leur trajet avant d'arriver en Europe ?"

	label variable sec3_30 "Parmi ces 100 personnes, combien d'entre elles vont arriver en Europe ?"
	note sec3_30: "Parmi ces 100 personnes, combien d'entre elles vont arriver en Europe ?"

	label variable sec3_31 "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours "
	note sec3_31: "Maintenant, imagine 100 personnes guinéennes exactement comme toi qui, au cours de l’année prochaine, rentrent à Ceuta ou Melilla. Combien d'entre elles vont être renvoyées en Guinée moins d'1 an après leur arrivée ?"

	label variable sec3_31_bis "Quel trajet choisirait cette personne pour arriver en \${sec3_21} entre ces troi"
	note sec3_31_bis: "Quel trajet choisirait cette personne pour arriver en \${sec3_21} entre ces trois routes ?"
	label define sec3_31_bis 1 "Cette personne atteindrait la rive d’Afrique du Nord en premier et ensuite prend" 2 "Cette personne atteindrait la rive d’Afrique du Nord en premier et ensuite prend" 3 "Cette personne atteindrait la rive d’Afrique du Nord en premier et ensuite escal"
	label values sec3_31_bis sec3_31_bis

	label variable sec3_32 "Parmi ces 100 personnes comme toi, combien d'entre elles vont trouver un emploi "
	note sec3_32: "Parmi ces 100 personnes comme toi, combien d'entre elles vont trouver un emploi en \${sec3_21}, si c’est ce qu’elles désirent ?"

	label variable sec3_34 "Combien gagne en moyenne chacune de ces \${sec3_32} personnes par mois grâce à l"
	note sec3_34: "Combien gagne en moyenne chacune de ces \${sec3_32} personnes par mois grâce à leur travail en \${sec3_21} ? Ecris le montant en équivalent de Francs Guinéens."

	label variable sec3_34_error_millions_2 "Tu veux dire qu'en moyenne le salaire de ces personnes qui travaillent en \${sec"
	note sec3_34_error_millions_2: "Tu veux dire qu'en moyenne le salaire de ces personnes qui travaillent en \${sec3_21} sera de \${sec3_34_error_millions} Francs Guinéens par mois ?"
	label define sec3_34_error_millions_2 1 "Oui, c'est ça." 2 "Non, je voulais écrire une autre somme d'argent."
	label values sec3_34_error_millions_2 sec3_34_error_millions_2

	label variable sec3_34_error_thousands_2 "Tu veux dire qu'en moyenne le salaire de ces personnes qui travaillent en \${sec"
	note sec3_34_error_thousands_2: "Tu veux dire qu'en moyenne le salaire de ces personnes qui travaillent en \${sec3_21} sera de \${sec3_34_error_thousands} Francs Guinéens par mois ?"
	label define sec3_34_error_thousands_2 1 "Oui, c'est ça." 2 "Non, je voulais écrire une autre somme d'argent."
	label values sec3_34_error_thousands_2 sec3_34_error_thousands_2

	label variable sec3_34_bis "Peux-tu réécrire s'il te plait, quel sera en moyenne le salaire par MOIS de ces "
	note sec3_34_bis: "Peux-tu réécrire s'il te plait, quel sera en moyenne le salaire par MOIS de ces \${sec3_32} personnes qui travaillent en \${sec3_21} ?"

	label variable sec3_35 "Maintenant, imagine 100 personnes exactement comme toi qui sont arrivées en \${s"
	note sec3_35: "Maintenant, imagine 100 personnes exactement comme toi qui sont arrivées en \${sec3_21}, combien d'entre elles vont continuer leurs études une fois en \${sec3_21} ?"

	label variable sec3_36 "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, combien vont devenir c"
	note sec3_36: "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, combien vont devenir citoyens de \${sec3_21} ?"

	label variable sec3_37 "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, combien vont retourner"
	note sec3_37: "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, combien vont retourner en Guinée pour toujours dans les 5 ans après leur arrivée en \${sec3_21} ?"

	label variable sec3_38 "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, à combien d'entre elle"
	note sec3_38: "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, à combien d'entre elles le gouvernement de le/la \${sec3_21} donnera un lit dans un centre d’accueil à leur arrivée ?"

	label variable sec3_39 "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, combien d'entre elles "
	note sec3_39: "Parmi ces 100 personnes qui sont arrivées en \${sec3_21}, combien d'entre elles vont recevoir de l'argent de la part de l'ETAT de \${sec3_21} dans la première année après leur arrivée ?"

	label variable sec3_40 "Imagine que 100 personnes exactement comme toi venant de la Guinée demandent l’a"
	note sec3_40: "Imagine que 100 personnes exactement comme toi venant de la Guinée demandent l’asile en \${sec3_21} pour la première fois. Combien d’entre elles obtiendront une réponse positive selon toi ?"

	label variable sec3_41 "Maintenant, considère 100 habitants de le/la \${sec3_21}. D'après toi, parmi ces"
	note sec3_41: "Maintenant, considère 100 habitants de le/la \${sec3_21}. D'après toi, parmi ces 100 habitants de le/la \${sec3_21}, combien d'entre eux sont favorables à l'immigration ?"

	label variable sec3_42 "Considère une personne qui vit seul à Conakry. Elle dépense 1 000 000 de FG PAR "
	note sec3_42: "Considère une personne qui vit seul à Conakry. Elle dépense 1 000 000 de FG PAR MOIS pour couvrir toutes ses dépenses (loyer, nourriture, transport, etc.). Combien devrait dépenser cette personne pour vivre DE LA MEME FAÇON en \${sec3_21} en équivalent FRANCS GUINEENS ? On suppose que le type de ses consommations (loyer, nourriture, transport, etc.) ne changent pas."

	label variable sec4_q1 "1 kg d'oignons"
	note sec4_q1: "1 kg d'oignons"

	label variable sec4_q2 "Poulet entier de 1kg"
	note sec4_q2: "Poulet entier de 1kg"

	label variable sec4_q3 "1 litre d'essence"
	note sec4_q3: "1 litre d'essence"

	label variable sec4_q4 "1 boîte de 10 comprimés de Doliprane (1000mg paracétamol)"
	note sec4_q4: "1 boîte de 10 comprimés de Doliprane (1000mg paracétamol)"

	label variable sec5_q1 "Imagine qu’un habitant de la Guinée entre en ITALIE illégalement. Il demande l’a"
	note sec5_q1: "Imagine qu’un habitant de la Guinée entre en ITALIE illégalement. Il demande l’asile et va en France pour chercher un emploi. Les autorités françaises peuvent l’expulser en Italie, avant qu’elle ne reçoive la décision concernant sa demande d’asile."
	label define sec5_q1 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values sec5_q1 sec5_q1

	label variable sec5_q2 "Un habitant de la Guinée qui est pauvre a le droit d’asile en Italie."
	note sec5_q2: "Un habitant de la Guinée qui est pauvre a le droit d’asile en Italie."
	label define sec5_q2 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values sec5_q2 sec5_q2

	label variable sec5_q3 "Supposons qu'un homme et une femme guinéens résident en Italie illégalement. Ens"
	note sec5_q3: "Supposons qu'un homme et une femme guinéens résident en Italie illégalement. Ensemble, ils attendent un enfant alors qu'ils résident en Italie. Leur enfant devient italien au moment où il nait."
	label define sec5_q3 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values sec5_q3 sec5_q3

	label variable sec5_q4 "Considère un homme guinéen qui réside en Italie LEGALEMENT. Supposons qu’il mari"
	note sec5_q4: "Considère un homme guinéen qui réside en Italie LEGALEMENT. Supposons qu’il marie une femme italienne. Après 2 ans, il peut devenir citoyen italien."
	label define sec5_q4 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values sec5_q4 sec5_q4

	label variable sec5_q5 "Un migrant qui dépose une demande d’asile en Italie doit obtenir une réponse pos"
	note sec5_q5: "Un migrant qui dépose une demande d’asile en Italie doit obtenir une réponse positive ou négative dans les 6 mois."
	label define sec5_q5 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values sec5_q5 sec5_q5

	label variable sec5_q6 "Un migrant qui dépose une demande d’asile en Italie peut commencer à travailler "
	note sec5_q6: "Un migrant qui dépose une demande d’asile en Italie peut commencer à travailler légalement avant de recevoir une réponse."
	label define sec5_q6 1 "Vrai" 2 "Faux" 3 "Je ne sais pas"
	label values sec5_q6 sec5_q6

	label variable sec6_lottery15 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery15: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery15 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 100 FG pour sûr."
	label values sec6_lottery15 sec6_lottery15

	label variable sec6_lottery16 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery16: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery16 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 10 000 FG pour sûr."
	label values sec6_lottery16 sec6_lottery16

	label variable sec6_lottery17 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery17: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery17 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 20 000 FG pour sûr."
	label values sec6_lottery17 sec6_lottery17

	label variable sec6_lottery18 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery18: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery18 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 30 000 FG pour sûr."
	label values sec6_lottery18 sec6_lottery18

	label variable sec6_lottery19 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery19: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery19 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 40 000 FG pour sûr."
	label values sec6_lottery19 sec6_lottery19

	label variable sec6_lottery20 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery20: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery20 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 50 000 FG pour sûr."
	label values sec6_lottery20 sec6_lottery20

	label variable sec6_lottery21 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery21: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery21 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 60 000 FG pour sûr."
	label values sec6_lottery21 sec6_lottery21

	label variable sec6_lottery22 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery22: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery22 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 70 000 FG pour sûr."
	label values sec6_lottery22 sec6_lottery22

	label variable sec6_lottery23 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery23: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery23 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 80 000 FG pour sûr."
	label values sec6_lottery23 sec6_lottery23

	label variable sec6_lottery24 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery24: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery24 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 90 000 FG pour sûr."
	label values sec6_lottery24 sec6_lottery24

	label variable sec6_lottery25 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery25: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery25 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 100 000 FG pour sûr."
	label values sec6_lottery25 sec6_lottery25

	label variable sec6_lottery26 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery26: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery26 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 110 000 FG pour sûr."
	label values sec6_lottery26 sec6_lottery26

	label variable sec6_lottery27 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery27: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery27 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 120 000 FG pour sûr."
	label values sec6_lottery27 sec6_lottery27

	label variable sec6_lottery28 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery28: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery28 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 130 000 FG pour sûr."
	label values sec6_lottery28 sec6_lottery28

	label variable sec6_lottery29 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery29: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery29 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 140 000 FG pour sûr."
	label values sec6_lottery29 sec6_lottery29

	label variable sec6_lottery30 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery30: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery30 1 "Avoir 1 chance sur 2 d'obtenir 200 000 FG et 1 chance sur 2 d'obtenir 0 FG." 2 "Obtenir 150 000 FG pour sûr."
	label values sec6_lottery30 sec6_lottery30

	label variable sec6_lottery1 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery1: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery1 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 200 100 FG DANS 2 MOIS."
	label values sec6_lottery1 sec6_lottery1

	label variable sec6_lottery2 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery2: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery2 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 240 000 FG DANS 2 MOIS."
	label values sec6_lottery2 sec6_lottery2

	label variable sec6_lottery3 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery3: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery3 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 280 000 FG DANS 2 MOIS."
	label values sec6_lottery3 sec6_lottery3

	label variable sec6_lottery4 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery4: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery4 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 320 000 FG DANS 2 MOIS."
	label values sec6_lottery4 sec6_lottery4

	label variable sec6_lottery5 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery5: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery5 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 360 000 FG DANS 2 MOIS."
	label values sec6_lottery5 sec6_lottery5

	label variable sec6_lottery6 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery6: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery6 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 400 000 FG DANS 2 MOIS."
	label values sec6_lottery6 sec6_lottery6

	label variable sec6_lottery7 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery7: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery7 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 440 000 FG DANS 2 MOIS."
	label values sec6_lottery7 sec6_lottery7

	label variable sec6_lottery8 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery8: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery8 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 480 000 FG DANS 2 MOIS."
	label values sec6_lottery8 sec6_lottery8

	label variable sec6_lottery9 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery9: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery9 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 520 000 FG DANS 2 MOIS."
	label values sec6_lottery9 sec6_lottery9

	label variable sec6_lottery10 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery10: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery10 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 560 000 FG DANS 2 MOIS."
	label values sec6_lottery10 sec6_lottery10

	label variable sec6_lottery11 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery11: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery11 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 600 000 FG DANS 2 MOIS."
	label values sec6_lottery11 sec6_lottery11

	label variable sec6_lottery12 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery12: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery12 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 640 000 FG DANS 2 MOIS."
	label values sec6_lottery12 sec6_lottery12

	label variable sec6_lottery13 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery13: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery13 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 680 000 FG DANS 2 MOIS."
	label values sec6_lottery13 sec6_lottery13

	label variable sec6_lottery14 "Quelle alternative choisirais-tu entre :"
	note sec6_lottery14: "Quelle alternative choisirais-tu entre :"
	label define sec6_lottery14 1 "Obtenir 200 000 FG AUJOURD'HUI." 2 "Obtenir 720 000 FG DANS 2 MOIS."
	label values sec6_lottery14 sec6_lottery14

	label variable sec7_q4 "D'où provient principalement l'eau que boivent les membres de ton ménage ?"
	note sec7_q4: "D'où provient principalement l'eau que boivent les membres de ton ménage ?"
	label define sec7_q4 1 "Robinet dans le logement" 2 "Robinet dans cour/parcelle" 3 "Robinet public / Borne Fontaine" 4 "Robinet chez le voisin" 5 "Forage" 6 "Puit" 7 "Eau en bouteille" 8 "Eau en sachet" 9 "Eau de pluie" 10 "Camion Citerne" 11 "Charrette avec petite citerne/tonneau/bidon" 12 "Eau de surface (rivière, ruisseau, barrage, lacs, mares, fleuves, canaux d’irrig" 13 "Eau de source" 14 "Autre"
	label values sec7_q4 sec7_q4

	label variable sec7_q5 "Quel type de toilettes les membres de ton ménage utilisent ?"
	note sec7_q5: "Quel type de toilettes les membres de ton ménage utilisent ?"
	label define sec7_q5 1 "Douche avec pot à la maison" 2 "Douche avec pot dans la latrine" 3 "Douche avec pot dans le WC" 4 "Fosse d’aisance sans dalle/trou ouvert à la maison" 5 "Fosse d’aisance sans dalle/trou ouvert dans la latrine" 6 "Fosse d’aisance sans dalle/trou ouvert dans le WC" 7 "Pas de toilette, Brousse, Plage, Forêt, Champs"
	label values sec7_q5 sec7_q5

	label variable sec7_q6_a "Electricité"
	note sec7_q6_a: "Electricité"
	label define sec7_q6_a 1 "Oui" 2 "Non"
	label values sec7_q6_a sec7_q6_a

	label variable sec7_q6_b "Radio"
	note sec7_q6_b: "Radio"
	label define sec7_q6_b 1 "Oui" 2 "Non"
	label values sec7_q6_b sec7_q6_b

	label variable sec7_q6_c "Télévision"
	note sec7_q6_c: "Télévision"
	label define sec7_q6_c 1 "Oui" 2 "Non"
	label values sec7_q6_c sec7_q6_c

	label variable sec7_q6_d "Téléphone portable"
	note sec7_q6_d: "Téléphone portable"
	label define sec7_q6_d 1 "Oui" 2 "Non"
	label values sec7_q6_d sec7_q6_d

	label variable sec7_q6_f "Montre"
	note sec7_q6_f: "Montre"
	label define sec7_q6_f 1 "Oui" 2 "Non"
	label values sec7_q6_f sec7_q6_f

	label variable sec7_q6_g "Voiture"
	note sec7_q6_g: "Voiture"
	label define sec7_q6_g 1 "Oui" 2 "Non"
	label values sec7_q6_g sec7_q6_g

	label variable sec7_q6_h "Vélo/Bicyclette"
	note sec7_q6_h: "Vélo/Bicyclette"
	label define sec7_q6_h 1 "Oui" 2 "Non"
	label values sec7_q6_h sec7_q6_h

	label variable sec7_q6_i "Réfrégirateur"
	note sec7_q6_i: "Réfrégirateur"
	label define sec7_q6_i 1 "Oui" 2 "Non"
	label values sec7_q6_i sec7_q6_i

	label variable sec7_q6_j "Ventilateur"
	note sec7_q6_j: "Ventilateur"
	label define sec7_q6_j 1 "Oui" 2 "Non"
	label values sec7_q6_j sec7_q6_j

	label variable sec7_q6_k "Climatiseur"
	note sec7_q6_k: "Climatiseur"
	label define sec7_q6_k 1 "Oui" 2 "Non"
	label values sec7_q6_k sec7_q6_k

	label variable sec7_q6_l "Moto/Motocyclette"
	note sec7_q6_l: "Moto/Motocyclette"
	label define sec7_q6_l 1 "Oui" 2 "Non"
	label values sec7_q6_l sec7_q6_l

	label variable sec7_q6_m "Compte en banque"
	note sec7_q6_m: "Compte en banque"
	label define sec7_q6_m 1 "Oui" 2 "Non"
	label values sec7_q6_m sec7_q6_m

	label variable sec7_q7 "À quelle fréquence écoutes-tu la radio ?"
	note sec7_q7: "À quelle fréquence écoutes-tu la radio ?"
	label define sec7_q7 1 "Chaque jour" 2 "2-3 fois par semaine" 3 "Une fois par semaine" 4 "Une fois par mois" 5 "Moins d’une fois par mois" 6 "Jamais"
	label values sec7_q7 sec7_q7

	label variable sec7_q8 "À quelle fréquence regardes-tu la télévision ?"
	note sec7_q8: "À quelle fréquence regardes-tu la télévision ?"
	label define sec7_q8 1 "Chaque jour" 2 "2-3 fois par semaine" 3 "Une fois par semaine" 4 "Une fois par mois" 5 "Moins d’une fois par mois" 6 "Jamais"
	label values sec7_q8 sec7_q8

	label variable sec7_q9 "À quelle fréquence regardes-tu la télévision française ?"
	note sec7_q9: "À quelle fréquence regardes-tu la télévision française ?"
	label define sec7_q9 1 "Chaque jour" 2 "2-3 fois par semaine" 3 "Une fois par semaine" 4 "Une fois par mois" 5 "Moins d’une fois par mois" 6 "Jamais"
	label values sec7_q9 sec7_q9

	label variable sec7_q10 "À quelle fréquence utilises-tu internet ?"
	note sec7_q10: "À quelle fréquence utilises-tu internet ?"
	label define sec7_q10 1 "Chaque jour" 2 "2-3 fois par semaine" 3 "Une fois par semaine" 4 "Une fois par mois" 5 "Moins d’une fois par mois" 6 "Jamais"
	label values sec7_q10 sec7_q10

	label variable sec8_q1 "Au cours de la semaine dernière, combien d'argent as-tu dépensé au total pour t'"
	note sec8_q1: "Au cours de la semaine dernière, combien d'argent as-tu dépensé au total pour t'acheter de la nourriture pour toi même ?"
	label define sec8_q1 1 "Je n'ai pas dépensé d'argent" 2 "Moins de 10 000 FG" 3 "Entre 10 000 et 50 000 FG" 4 "Entre 50 000 et 100 000 FG" 5 "Entre 100 000 et 200 000 FG" 6 "Plus de 200 000 FG"
	label values sec8_q1 sec8_q1

	label variable sec8_q2 "Au cours de la semaine dernière, combien d'argent as-tu dépensé au total pour ac"
	note sec8_q2: "Au cours de la semaine dernière, combien d'argent as-tu dépensé au total pour acheter d’autres choses que de la nourriture pour toi même ? (ex: vêtement, chaussures, portable)"
	label define sec8_q2 1 "Je n'ai pas dépensé d'argent" 2 "Moins de 10 000 FG" 3 "Entre 10 000 et 50 000 FG" 4 "Entre 50 000 et 100 000 FG" 5 "Entre 100 000 et 200 000 FG" 6 "Plus de 200 000 FG"
	label values sec8_q2 sec8_q2

	label variable sec8_q3 "Au cours du MOIS DERNIER, as-tu eu un emploi payé EN DEHORS de l’école ?"
	note sec8_q3: "Au cours du MOIS DERNIER, as-tu eu un emploi payé EN DEHORS de l’école ?"
	label define sec8_q3 1 "Oui" 2 "Non"
	label values sec8_q3 sec8_q3

	label variable sec8_q4 "Au cours du MOIS DERNIER, quel était ton emploi principal ? (à part étudier)"
	note sec8_q4: "Au cours du MOIS DERNIER, quel était ton emploi principal ? (à part étudier)"
	label define sec8_q4 1 "Ventes et Services (ex : vendeur/entrepreneur)" 2 "Agriculture (incluant pêche, élevage et chasse)" 3 "Travailleur manuel qualifié (ex : machiniste/charpentier)" 4 "Travailleur manuel non qualifié (ex : constructeur de route/assembleur)" 5 "Administratif (ex : secrétaire)" 6 "Service domestique pour quelqu'un d'autre (ex : employé de maison)" 7 "Autres (A spécifier)"
	label values sec8_q4 sec8_q4

	label variable sec8_q4_other_occup "Spécifie l'emploi que tu occupais s'il te plait."
	note sec8_q4_other_occup: "Spécifie l'emploi que tu occupais s'il te plait."

	label variable sec8_q5 "Combien gagnes-tu d’argent pour toi-même PAR MOIS grâce à ton travail ? (En Fran"
	note sec8_q5: "Combien gagnes-tu d’argent pour toi-même PAR MOIS grâce à ton travail ? (En Francs Guinéens)"

	label variable sec8_q6 "En incluant toutes les activités générant des revenus (élevage, commerce, travai"
	note sec8_q6: "En incluant toutes les activités générant des revenus (élevage, commerce, travail salarié et autres) et en considérant toutes les personnes qui vivent dans ta maison, combien le ménage gagne-t-il au total au cours d'UN MOIS type ?"

	label variable sec9_q1 "Est-ce qu’un de tes frères,sœurs ou amis a quitté la Guinée au cours des 6 derni"
	note sec9_q1: "Est-ce qu’un de tes frères,sœurs ou amis a quitté la Guinée au cours des 6 derniers mois ?"
	label define sec9_q1 1 "Oui" 2 "Non"
	label values sec9_q1 sec9_q1

	label variable sec9_q2 "Combien de tes camarades de classe ont quitté la Guinée au cours des 6 derniers "
	note sec9_q2: "Combien de tes camarades de classe ont quitté la Guinée au cours des 6 derniers mois ? (inscris 0 si aucun)"

	label variable outside_contact_no "Au total, combien connais-tu de membres de ta famille ou amis qui vivent dans un"
	note outside_contact_no: "Au total, combien connais-tu de membres de ta famille ou amis qui vivent dans un pays AUTRE QUE LA GUINEE et avec qui tu es en contact ?"

	label variable sec10_q1_1 "Prénom ou surnom du premier contact :"
	note sec10_q1_1: "Prénom ou surnom du premier contact :"

	label variable sec10_q5_1 "Dans quel pays vit ton premier contact ?"
	note sec10_q5_1: "Dans quel pays vit ton premier contact ?"

	label variable sec10_q1_2 "Prénom ou surnom du second contact :"
	note sec10_q1_2: "Prénom ou surnom du second contact :"

	label variable sec10_q5_2 "Dans quel pays vit ton second contact actuellement ?"
	note sec10_q5_2: "Dans quel pays vit ton second contact actuellement ?"

	label variable sec10_q2_1 "Quelle est ta relation avec \${sec10_q1_1} ?"
	note sec10_q2_1: "Quelle est ta relation avec \${sec10_q1_1} ?"
	label define sec10_q2_1 1 "Époux(se)/Fiancé(e)" 2 "Mère/Père ou beaux parents" 3 "Frère ou sœur, Beaux-frères/Belles-sœurs" 4 "Autre membre de la famille" 5 "Enfant" 6 "Ami" 7 "Autre relation"
	label values sec10_q2_1 sec10_q2_1

	label variable sec10_q3_1 "De quel sexe est \${sec10_q1_1} ?"
	note sec10_q3_1: "De quel sexe est \${sec10_q1_1} ?"
	label define sec10_q3_1 1 "Homme" 2 "Femme"
	label values sec10_q3_1 sec10_q3_1

	label variable sec10_q4_1 "Quel âge a \${sec10_q1_1} ?"
	note sec10_q4_1: "Quel âge a \${sec10_q1_1} ?"

	label variable sec10_q6_1 "Quel est le plus haut niveau d’étude que \${sec10_q1_1} a complété ?"
	note sec10_q6_1: "Quel est le plus haut niveau d’étude que \${sec10_q1_1} a complété ?"
	label define sec10_q6_1 0 "Aucune scolarité formelle" 1 "Maternelle" 2 "Ecole Primaire" 3 "Ecole Secondaire (Collège, Lycée)" 4 "Etudes supérieures (Université)" 99 "Je ne sais pas"
	label values sec10_q6_1 sec10_q6_1

	label variable sec10_q7_1 "Connais-tu la profession actuelle de \${sec10_q1_1} ?"
	note sec10_q7_1: "Connais-tu la profession actuelle de \${sec10_q1_1} ?"
	label define sec10_q7_1 1 "Etudiant" 2 "Ventes et Services (ex : Vendeur)" 3 "Agriculture (incluant pêche, élevage et chasse)" 4 "Travailleur manuel qualifié (ex : machiniste/charpentier)" 5 "Travailleur manuel non qualifié (ex : constructeur de route/assembleur)" 6 "Professionnel/technique/managérial (ex : ingénieur/assistant informatique/infirm" 7 "Administratif (ex : secrétaire)" 8 "Militaire/Paramilitaire" 9 "Service domestique pour quelqu'un d'autre (ex : employé de maison)" 10 "Mère ou père au foyer" 11 "Sans emploi" 99 "Je ne sais pas"
	label values sec10_q7_1 sec10_q7_1

	label variable sec10_q8_1 "Sais-tu combien d’argent \${sec10_q1_1} gagne par mois en équivalent FRANCS GUIN"
	note sec10_q8_1: "Sais-tu combien d’argent \${sec10_q1_1} gagne par mois en équivalent FRANCS GUINEENS ?"
	label define sec10_q8_1 1 "Entre 0 et 1 000 000 FG" 2 "Entre 1 000 000 et 2 500 000 FG" 3 "Entre 2 500 000 et 5 000 000 FG" 4 "Entre 5 000 000 et 10 000 000 FG" 5 "Entre 10 000 000 et 20 000 000 FG" 6 "Plus de 20 000 000 FG" 99 "Je ne sais pas"
	label values sec10_q8_1 sec10_q8_1

	label variable sec10_q9_1 "À quelle fréquence contactes-tu \${sec10_q1_1} ?"
	note sec10_q9_1: "À quelle fréquence contactes-tu \${sec10_q1_1} ?"
	label define sec10_q9_1 1 "Au moins une fois par jour" 2 "Au moins une fois par semaine" 3 "Au moins une fois par mois" 4 "Au moins une fois tous les 3 mois" 5 "Au moins une fois tous les 6 mois" 6 "Au moins une fois par an"
	label values sec10_q9_1 sec10_q9_1

	label variable sec10_q10_1 "Quel est le principal moyen de communication que tu utilises pour contacter \${s"
	note sec10_q10_1: "Quel est le principal moyen de communication que tu utilises pour contacter \${sec10_q1_1} ?"
	label define sec10_q10_1 1 "Réseaux sociaux (ex: Facebook, Twitter)" 2 "Messagerie instantanée (ex: Whatsapp, Messenger)" 3 "Téléphone mobile" 4 "Skype" 5 "Email" 6 "Téléphone fixe" 99 "Autre"
	label values sec10_q10_1 sec10_q10_1

	label variable sec10_q11_1 "En général, discutes-tu avec \${sec10_q1_1} du niveau des salaires du pays dans "
	note sec10_q11_1: "En général, discutes-tu avec \${sec10_q1_1} du niveau des salaires du pays dans lequel il/elle habite ?"
	label define sec10_q11_1 1 "Oui" 2 "Non"
	label values sec10_q11_1 sec10_q11_1

	label variable sec10_q12_1 "En général, discutes-tu avec \${sec10_q1_1} des opportunités d’emplois du pays d"
	note sec10_q12_1: "En général, discutes-tu avec \${sec10_q1_1} des opportunités d’emplois du pays dans lequel il/elle habite ?"
	label define sec10_q12_1 1 "Oui" 2 "Non"
	label values sec10_q12_1 sec10_q12_1

	label variable sec10_q13_1 "En général, discutes-tu avec \${sec10_q1_1} des allocations chômage proposées pa"
	note sec10_q13_1: "En général, discutes-tu avec \${sec10_q1_1} des allocations chômage proposées par le pays dans lequel il/elle habite ?"
	label define sec10_q13_1 1 "Oui" 2 "Non"
	label values sec10_q13_1 sec10_q13_1

	label variable sec10_q14_1 "As-tu discuté avec \${sec10_q1_1} du trajet qu’il/elle a traversé pour arriver d"
	note sec10_q14_1: "As-tu discuté avec \${sec10_q1_1} du trajet qu’il/elle a traversé pour arriver dans le pays dans lequel il/elle vit actuellement ?"
	label define sec10_q14_1 1 "Oui" 2 "Non"
	label values sec10_q14_1 sec10_q14_1

	label variable sec10_q15_1 "En général, discutes-tu avec \${sec10_q1_1} de sa situation financière ?"
	note sec10_q15_1: "En général, discutes-tu avec \${sec10_q1_1} de sa situation financière ?"
	label define sec10_q15_1 1 "Oui" 2 "Non"
	label values sec10_q15_1 sec10_q15_1

	label variable sec10_q16_1 "L’an dernier, à quelle fréquence, \${sec10_q1_1} a-t-il/elle envoyé ou apporté d"
	note sec10_q16_1: "L’an dernier, à quelle fréquence, \${sec10_q1_1} a-t-il/elle envoyé ou apporté de l''argent à ton foyer depuis le pays où il/elle vit actuellement ?"
	label define sec10_q16_1 1 "Chaque semaine" 2 "Chaque mois" 3 "Tous les 3 mois" 4 "Tous les 6 mois" 5 "Une fois par an" 6 "Rarement (moins d’une fois par an)" 7 "Jamais" 99 "Je ne sais pas"
	label values sec10_q16_1 sec10_q16_1

	label variable sec10_q17_1 "Au cours de l'an dernier, quel est le montant total d'argent que \${sec10_q1_1} "
	note sec10_q17_1: "Au cours de l'an dernier, quel est le montant total d'argent que \${sec10_q1_1} a envoyé ou apporté à ton foyer depuis le pays où il/elle vit actuellement ?"
	label define sec10_q17_1 1 "Entre 0 et 1 000 000 FG" 2 "Entre 1 000 000 et 2 500 000 FG" 3 "Entre 2 500 000 et 5 000 000 FG" 4 "Entre 5 000 000 et 10 000 000 FG" 5 "Entre 10 000 000 et 20 000 000 FG" 6 "Plus de 20 000 000 FG" 99 "Je ne sais pas"
	label values sec10_q17_1 sec10_q17_1

	label variable sec10_q18_1 "Imagine maintenant un migrant qui ne va PAS très bien dans le pays où il a immig"
	note sec10_q18_1: "Imagine maintenant un migrant qui ne va PAS très bien dans le pays où il a immigré, mais a honte de le dire à sa famille et exagère positivement les nouvelles (en disant, par exemple, qu’il gagne beaucoup d’argent en ce moment). \${sec10_q1_1} lui ressemble-t-il ?"
	label define sec10_q18_1 1 "Pas du tout comme lui/elle" 2 "Un petit peu comme lui/elle" 3 "Un peu comme lui/elle" 4 "Vraiment comme lui/elle"
	label values sec10_q18_1 sec10_q18_1

	label variable sec10_q19_1 "Imagine maintenant un migrant qui va très bien mais a peur que sa famille lui ré"
	note sec10_q19_1: "Imagine maintenant un migrant qui va très bien mais a peur que sa famille lui réclame de l’argent s’il leur dit, et sous-estime donc ses revenus quand il parle avec eux. \${sec10_q1_1} lui ressemble-t-il ?"
	label define sec10_q19_1 1 "Pas du tout comme lui/elle" 2 "Un petit peu comme lui/elle" 3 "Un peu comme lui/elle" 4 "Vraiment comme lui/elle"
	label values sec10_q19_1 sec10_q19_1

	label variable sec10_q2_2 "Quelle est ta relation avec \${sec10_q1_2} ?"
	note sec10_q2_2: "Quelle est ta relation avec \${sec10_q1_2} ?"
	label define sec10_q2_2 1 "Époux(se)/Fiancé(e)" 2 "Mère/Père ou beaux parents" 3 "Frère ou sœur, Beaux-frères/Belles-sœurs" 4 "Autre membre de la famille" 5 "Enfant" 6 "Ami" 7 "Autre relation"
	label values sec10_q2_2 sec10_q2_2

	label variable sec10_q3_2 "De quel sexe est \${sec10_q1_2} ?"
	note sec10_q3_2: "De quel sexe est \${sec10_q1_2} ?"
	label define sec10_q3_2 1 "Homme" 2 "Femme"
	label values sec10_q3_2 sec10_q3_2

	label variable sec10_q4_2 "Quel âge a \${sec10_q1_2} ?"
	note sec10_q4_2: "Quel âge a \${sec10_q1_2} ?"

	label variable sec10_q6_2 "Quel est le plus haut niveau d’étude que \${sec10_q1_2} a complété ?"
	note sec10_q6_2: "Quel est le plus haut niveau d’étude que \${sec10_q1_2} a complété ?"
	label define sec10_q6_2 0 "Aucune scolarité formelle" 1 "Maternelle" 2 "Ecole Primaire" 3 "Ecole Secondaire (Collège, Lycée)" 4 "Etudes supérieures (Université)" 99 "Je ne sais pas"
	label values sec10_q6_2 sec10_q6_2

	label variable sec10_q7_2 "Connais-tu la profession actuelle de \${sec10_q1_2} ?"
	note sec10_q7_2: "Connais-tu la profession actuelle de \${sec10_q1_2} ?"
	label define sec10_q7_2 1 "Etudiant" 2 "Ventes et Services (ex : Vendeur)" 3 "Agriculture (incluant pêche, élevage et chasse)" 4 "Travailleur manuel qualifié (ex : machiniste/charpentier)" 5 "Travailleur manuel non qualifié (ex : constructeur de route/assembleur)" 6 "Professionnel/technique/managérial (ex : ingénieur/assistant informatique/infirm" 7 "Administratif (ex : secrétaire)" 8 "Militaire/Paramilitaire" 9 "Service domestique pour quelqu'un d'autre (ex : employé de maison)" 10 "Mère ou père au foyer" 11 "Sans emploi" 99 "Je ne sais pas"
	label values sec10_q7_2 sec10_q7_2

	label variable sec10_q8_2 "Sais-tu combien d’argent \${sec10_q1_2} gagne par mois en équivalent FRANCS GUIN"
	note sec10_q8_2: "Sais-tu combien d’argent \${sec10_q1_2} gagne par mois en équivalent FRANCS GUINEENS ?"
	label define sec10_q8_2 1 "Entre 0 et 1 000 000 FG" 2 "Entre 1 000 000 et 2 500 000 FG" 3 "Entre 2 500 000 et 5 000 000 FG" 4 "Entre 5 000 000 et 10 000 000 FG" 5 "Entre 10 000 000 et 20 000 000 FG" 6 "Plus de 20 000 000 FG" 99 "Je ne sais pas"
	label values sec10_q8_2 sec10_q8_2

	label variable sec10_q9_2 "À quelle fréquence contactes-tu \${sec10_q1_2} ?"
	note sec10_q9_2: "À quelle fréquence contactes-tu \${sec10_q1_2} ?"
	label define sec10_q9_2 1 "Au moins une fois par jour" 2 "Au moins une fois par semaine" 3 "Au moins une fois par mois" 4 "Au moins une fois tous les 3 mois" 5 "Au moins une fois tous les 6 mois" 6 "Au moins une fois par an"
	label values sec10_q9_2 sec10_q9_2

	label variable sec10_q10_2 "Quel est le principal moyen de communication que tu utilises pour contacter \${s"
	note sec10_q10_2: "Quel est le principal moyen de communication que tu utilises pour contacter \${sec10_q1_2} ?"
	label define sec10_q10_2 1 "Réseaux sociaux (ex: Facebook, Twitter)" 2 "Messagerie instantanée (ex: Whatsapp, Messenger)" 3 "Téléphone mobile" 4 "Skype" 5 "Email" 6 "Téléphone fixe" 99 "Autre"
	label values sec10_q10_2 sec10_q10_2

	label variable sec10_q11_2 "En général, discutes-tu avec \${sec10_q1_2} du niveau des salaires du pays dans "
	note sec10_q11_2: "En général, discutes-tu avec \${sec10_q1_2} du niveau des salaires du pays dans lequel il/elle habite ?"
	label define sec10_q11_2 1 "Oui" 2 "Non"
	label values sec10_q11_2 sec10_q11_2

	label variable sec10_q12_2 "En général, discutes-tu avec \${sec10_q1_2} des opportunités d’emplois du pays d"
	note sec10_q12_2: "En général, discutes-tu avec \${sec10_q1_2} des opportunités d’emplois du pays dans lequel il/elle habite ?"
	label define sec10_q12_2 1 "Oui" 2 "Non"
	label values sec10_q12_2 sec10_q12_2

	label variable sec10_q13_2 "En général, discutes-tu avec \${sec10_q1_2} des allocations chômage proposées pa"
	note sec10_q13_2: "En général, discutes-tu avec \${sec10_q1_2} des allocations chômage proposées par le pays dans lequel il/elle habite ?"
	label define sec10_q13_2 1 "Oui" 2 "Non"
	label values sec10_q13_2 sec10_q13_2

	label variable sec10_q14_2 "As-tu discuté avec \${sec10_q1_2} du trajet qu’il/elle a traversé pour arriver d"
	note sec10_q14_2: "As-tu discuté avec \${sec10_q1_2} du trajet qu’il/elle a traversé pour arriver dans le pays dans lequel il/elle vit actuellement ?"
	label define sec10_q14_2 1 "Oui" 2 "Non"
	label values sec10_q14_2 sec10_q14_2

	label variable sec10_q15_2 "En général, discutes-tu avec \${sec10_q1_2} de sa situation financière ?"
	note sec10_q15_2: "En général, discutes-tu avec \${sec10_q1_2} de sa situation financière ?"
	label define sec10_q15_2 1 "Oui" 2 "Non"
	label values sec10_q15_2 sec10_q15_2

	label variable sec10_q16_2 "L’an dernier, à quelle fréquence, \${sec10_q1_2} a-t-il/elle envoyé ou apporté d"
	note sec10_q16_2: "L’an dernier, à quelle fréquence, \${sec10_q1_2} a-t-il/elle envoyé ou apporté de l''argent à ton foyer depuis le pays où il/elle vit actuellement ?"
	label define sec10_q16_2 1 "Chaque semaine" 2 "Chaque mois" 3 "Tous les 3 mois" 4 "Tous les 6 mois" 5 "Une fois par an" 6 "Rarement (moins d’une fois par an)" 7 "Jamais" 99 "Je ne sais pas"
	label values sec10_q16_2 sec10_q16_2

	label variable sec10_q17_2 "Au cours de l'an dernier, quel est le montant total d'argent que \${sec10_q1_2} "
	note sec10_q17_2: "Au cours de l'an dernier, quel est le montant total d'argent que \${sec10_q1_2} a envoyé ou apporté à ton foyer depuis le pays où il/elle vit actuellement ?"
	label define sec10_q17_2 1 "Entre 0 et 1 000 000 FG" 2 "Entre 1 000 000 et 2 500 000 FG" 3 "Entre 2 500 000 et 5 000 000 FG" 4 "Entre 5 000 000 et 10 000 000 FG" 5 "Entre 10 000 000 et 20 000 000 FG" 6 "Plus de 20 000 000 FG" 99 "Je ne sais pas"
	label values sec10_q17_2 sec10_q17_2

	label variable sec10_q18_2 "Imagine maintenant un migrant qui ne va PAS très bien dans le pays où il a immig"
	note sec10_q18_2: "Imagine maintenant un migrant qui ne va PAS très bien dans le pays où il a immigré, mais a honte de le dire à sa famille et exagère positivement les nouvelles (en disant, par exemple, qu’il gagne beaucoup d’argent en ce moment). \${sec10_q1_2} lui ressemble-t-il ?"
	label define sec10_q18_2 1 "Pas du tout comme lui/elle" 2 "Un petit peu comme lui/elle" 3 "Un peu comme lui/elle" 4 "Vraiment comme lui/elle"
	label values sec10_q18_2 sec10_q18_2

	label variable sec10_q19_2 "Imagine maintenant un migrant qui va très bien mais a peur que sa famille lui ré"
	note sec10_q19_2: "Imagine maintenant un migrant qui va très bien mais a peur que sa famille lui réclame de l’argent s’il leur dit, et sous-estime donc ses revenus quand il parle avec eux. \${sec10_q1_2} lui ressemble-t-il ?"
	label define sec10_q19_2 1 "Pas du tout comme lui/elle" 2 "Un petit peu comme lui/elle" 3 "Un peu comme lui/elle" 4 "Vraiment comme lui/elle"
	label values sec10_q19_2 sec10_q19_2

	label variable finished "À quelle question s'est arrêté l'élève?"
	note finished: "À quelle question s'est arrêté l'élève?"






	* append old, previously-imported data (if any)
	cap confirm file "`dtafile'"
	if _rc == 0 {
		* mark all new data before merging with old data
		gen new_data_row=1
		
		* pull in old data
		append using "`dtafile'"
		
		* drop duplicates in favor of old, previously-imported data if overwrite_old_data is 0
		* (alternatively drop in favor of new data if overwrite_old_data is 1)
		sort key
		by key: gen num_for_key = _N
		drop if num_for_key > 1 & ((`overwrite_old_data' == 0 & new_data_row == 1) | (`overwrite_old_data' == 1 & new_data_row ~= 1))
		drop num_for_key

		* drop new-data flag
		drop new_data_row
	}
	
	* save data to Stata format
	save "`dtafile'", replace

	* show codebook and notes
	codebook
	notes list
}

disp
disp "Finished import of: `csvfile'"
disp

* apply corrections (if any)
capture confirm file "`corrfile'"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile'"
	disp

	* save primary data in memory
	preserve

	* load corrections
	insheet using "`corrfile'", names clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		drop notes
		
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
		save "`dtafile'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile'"
	disp
}
