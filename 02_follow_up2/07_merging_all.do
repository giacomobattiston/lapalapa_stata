/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE    :    	07 - MERGING BASELINE MIDLINE AND ENDLINE
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/
/*07_merging_all.do
Date Created:  May 29, 2020
Date Last Modified: June 5, 2020
Created by: Laïla SOUALI
Last modified by: Giacomo Battiston
*	Inputs: .dta file
	"Data\output\analysis\guinea_final_dataset.dta"
	"Data\output\followup2\questionnaire_endline_clean.dta"
*	Outputs: "Data\output\followup2\BME_final"

*Outline :
- 1 - Merging Baseline, Midline, Endline
- 2 - Cleaning Midline and Baseline
	2.1 - Cleaning text variables
	2.2 - Labelling
	2.3 - Cleaning country variables
- 3 - Creating migration variables	
	3.1 - LEFT CONAKRY 
	3.2 -  LEFT GUINEA 
	3.3 - IRREGULAR MIGRATION TO EUROPE
	3.4 - PLANNING TO MIGRATE/HAVING MIGRATED IRREGULARLY TO EUROPE
	3.5 - ON THE WAY/ARRIVED IN EUROPE
	3.6 - PLANNING/WISHING TO MIGRATE IRREGULARLY TO EUROPE 
- 4 - Saving final dataset
*/ 


* initialize Stata
clear all
set more off

*Laïla user
*global main "C:\Users\Khalad\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
*Giacomo
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"
global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   1 - MERGING BASELINE MIDLINE ENDLINE                             
***_____________________________________________________________________________

use "$main/Data/output/analysis/guinea_final_dataset.dta"
rename sec0_q1_a prenom_baseline 
rename sec0_q1_b nom_baseline

rename sec0_q4 classe_baseline
rename sec0_q5_a option_baseline

rename starttime_new_date starttime_date
rename starttime_new_hour starttime_hour
rename submissiondate_new_date submissiondate_date
rename submissiondate_new_hour submissiondate_hour
rename endtime_new_date endtime_date
rename endtime_new_hour endtime_hour

append using ${main}/Data/output/followup2/questionnaire_endline_clean, force

xtset id_number time
order time id_number id_number_str schoolid schoolid_str lycee_name lycee_name_str

replace lycee_name=L2.lycee_name if time==2 
replace schoolid=L2.schoolid if time==2 
replace commune=L2.commune if time==2 
replace treatment_status=L2.treatment_status if time==2 
replace classe_baseline=L2.classe_baseline if time==2 
replace option_baseline=L2.option_baseline if time==2 
replace partb_participation = F2.partb_participation if time == 0

drop id_number_str 
tostring id_number, gen(id_number_str)
drop schoolid
destring schoolid_str, gen(schoolid)

sort id_number time

label variable time "Baseline, midline or endline survey"
label define time 0 "Baseline" 1 "Midline" 2 "Endline"
label values time time



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   2 - CLEANING MIDLINE BASELINE                             
***_____________________________________________________________________________


/////////////////////////////////////////////////////////////////////////////
/////////    		2.1- CLEANING TEXT VARIABLES			/////////////////
/////////////////////////////////////////////////////////////////////////////

/////////    OTHER: SUBJECT OF THE INFORMATION SESSION		/////////////////

replace partb_q0=3 if partb_q0_other=="Immigration" | partb_q0_other=="Immigration clandestine en libye" | partb_q0_other=="La migration" | partb_q0_other=="La situation misérable  que vit les africains une fois en Europe" | partb_q0_other=="L'immigration clandestine"  
replace partb_q0_other="Irregular migration" if partb_q0_other=="L'immigration clandestine" | partb_q0_other=="Immigration clandestine en libye"  
replace partb_q0_other="The miserable situation that Africans live when they arrive in Europe" if partb_q0_other=="La situation misérable  que vit les africains une fois en Europe" 

replace partb_q0=5 if partb_q0_other=="99"
replace partb_q0_other="" if partb_q0_other=="99" | partb_q0_other=="I don't remember"


replace partb_q0_other="" if partb_q0_other=="0" | partb_q0_other=="1" | partb_q0_other=="17" | partb_q0_other=="Bien" | partb_q0_other=="F" | partb_q0_other=="France" | partb_q0_other=="H3" | partb_q0_other=="Internete" | partb_q0_other=="Philosophie" | partb_q0_other=="Radio" | partb_q0_other=="Rien" | partb_q0_other=="Rvdg" | partb_q0_other=="Se"  | partb_q0_other=="Sese" | partb_q0_other=="Journal"



/////////    OTHER: FIRST ACTIVITY OF THE INFORMATION SESSION	/////////////


replace partb_q1=4 if partb_q1_other=="Des chiffres sur la migration" | partb_q1_other=="Des chiffres sur la migration ont été montré" | partb_q1_other=="Des chiffres sur la migration ont été montres  " | partb_q1_other=="Des chiffres sur les  migration ont été montrés" | partb_q1_other=="Deschiffresurlamigartionnotetemomtret" | partb_q1_other=="Les chiffres" 
replace partb_q1=3 if partb_q1_other=="Vidéo"

replace partb_q1_other="I don't remember" if partb_q1_other=="Je ne pas" | partb_q1_other=="Je ne sais pas" | partb_q1_other=="Je n'en sais  rien"
replace partb_q1_other="We had to fill a questionnaire" if partb_q1_other=="C'était de remplirez la formalités dans les téléphones portables" | partb_q1_other=="Ils sont venus nous donner les mêmes tablettes pour répondre aux questionnaires" | partb_q1_other=="Répondre à quelques questions" | partb_q1_other=="Travailler sur les tablettes" | partb_q1_other=="Donner mon avis sur des questions de la tablette" 
replace partb_q1_other="We had to fill a questionnaire about migration" if partb_q1_other=="Ils nous ont justes parlés de la tablette que nous auront a affronter á des questions liées á la migration clandestine" | partb_q1_other=="La première activité était de répondre à des questionnaires sur l'immigration." | partb_q1_other=="On nous donner des tablettes et on nous on demandé de répondre aux questions qui nous ont été  posées selon nous" | partb_q1_other=="Remplissage des données personnelles sur les immigrations sur tablette" 
replace partb_q1_other="Study" if partb_q1_other=="Etude" | partb_q1_other=="Étudié" 
replace partb_q1_other="Migration" if partb_q1_other=="La migration" | partb_q1_other=="C'est était  la  migration" | partb_q1_other=="C'est un migrant de la Guinée vers europe" | partb_q1_other=="Migrants" 

replace partb_q1_other="Sensibilisation" if partb_q1_other=="La senssibilisation" 
replace partb_q1_other="The difficulties of the journey" if partb_q1_other=="Les difficultés  du  voyage" 
replace partb_q1_other="Work" if partb_q1_other=="Travail" 
replace partb_q1_other="Read" if partb_q1_other=="lire" 


replace partb_q1_other="" if partb_q1_other=="0" | partb_q1_other=="2" | partb_q1_other=="7" | partb_q1_other=="9" | partb_q1_other=="17" | partb_q1_other=="100" | partb_q1_other=="2018" | partb_q1_other=="2o1o" | partb_q1_other=="chauffeur" | partb_q1_other=="Des chiffres sur la migration" | partb_q1_other=="Des chiffres sur la migration ont été montré" | partb_q1_other=="Des chiffres sur la migration ont été montres  " | partb_q1_other=="Des chiffres sur les  migration ont été montrés" | partb_q1_other=="Deschiffresurlamigartionnotetemomtret" | partb_q1_other=="Les chiffres"  | partb_q1_other=="France" | partb_q1_other=="Economise" | partb_q1_other=="Football" | partb_q1_other=="Google" | partb_q1_other=="Iz" 
replace partb_q1_other="" if partb_q1_other=="Maçonnerie" | partb_q1_other=="Manager" | partb_q1_other=="Masson" | partb_q1_other=="Médecin" | partb_q1_other=="Ministre" | partb_q1_other=="Notaire" | partb_q1_other=="Oui" | partb_q1_other=="Ramatoulaye" | partb_q1_other=="Santé" | partb_q1_other=="Se" | partb_q1_other=="Sèche" | partb_q1_other=="Vidéo"


//// OTHER EXPERIENCE OF INDIVIDUALS THAT WERE DEPICTED IN THE VIDEOS	/////

replace partb_q3="99" if partb_q3_other=="99"  
replace partb_q3_99=1 if partb_q3_other=="99" 
replace partb_q3_other="" if partb_q3_other=="99"  

replace partb_q3="1" if partb_q3_other=="Leur trajet pour aller en Europe"  
replace partb_q3_1=1 if partb_q3_other=="Leur trajet pour aller en Europe" 
replace partb_q3_other="" if partb_q3_other=="Leur trajet pour aller en Europe"  
 
replace partb_q3_other="How free they felt in their country before leaving" if partb_q3_other=="Comment ils se sentait libres dans leur pays avant qu'ils ne pat en aventure" 
replace partb_q3_other="They said not to put their life in danger like they did by doing this illegal journey" if partb_q3_other=="Ils sensiblissaient les personnes à ne pas mettre leurs vie en danger comme eux en faisant ce voyage illégal" 
replace partb_q3_other="Torture" if partb_q3_other=="Tortur" 

replace partb_q3_other="" if partb_q3_other=="0" | partb_q3_other=="1" | partb_q3_other=="3" | partb_q3_other=="5" | partb_q3_other=="6" | partb_q3_other=="12" | partb_q3_other=="30" | partb_q3_other=="Bien" | partb_q3_other=="De" | partb_q3_other=="F" 
replace partb_q3_other="" if partb_q3_other=="G" | partb_q3_other=="Mamadou" | partb_q3_other=="Mamadou barry de mali yen Bere" | partb_q3_other=="Non" | partb_q3_other=="Novelas" | partb_q3_other=="Oui" | partb_q3_other=="Putier" 
replace partb_q3_other="" if partb_q3_other==" Mn"

/////////////////////////////////////////////////////////////////////////////
///////////////////   		2.2 - LABELLING				/////////////////////
/////////////////////////////////////////////////////////////////////////////

*label variable treatment_status "Treatment status of the baseline school of the student"
label variable sec2_q13 "Name of the 1st high school."
label variable sec2_q14 "Name of the 1st high school."
label variable sec2_q15 "Name of the 1st high school."

label variable quartier "Neighbourhood"

label variable enqueteur_1 "Enumerator 1 - Baseline"
label variable enqueteur_2 "Enumerator 2 - Baseline"

label variable educ_1 "Enumerator 1 - Sensibilisation"
label variable educ_2 "Enumerator 2 - Sensibilisation"

label variable surveyor_1 "Enumerator 1 - Midline"
label variable surveyor_2 "Enumerator 2 - Midline"

label variable randomization_date "Date of the randomization"

label variable date_baseline1 "Date of the baseline 1"
label variable heure_baseline_1 "Time of the baseline 1"

label variable date_baseline2 "Date of the baseline 2"
label variable heure_baseline_2 "Time of the baseline 2"

label variable sensi_date "Date of the sensibilisation"
label variable sensi_hour "Time of the sensibilisation"

label variable mid_date "Date of the midline"
label variable mid_hour "Time of the midline"

*time_sensi_midline
*time_base_mid

label variable finished "At which variable did the student stop answering?"
note finished : "At which variable did the student stop answering?"

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

label variable submissiondate_date "Date submitted"
note submissiondate_date : "Date submitted"

label variable submissiondate_hour "Time submitted"
note submissiondate_hour : "Time submitted"

label variable submissiondate_date_p "Date submitted"
note submissiondate_date_p : "Date submitted"

label variable submissiondate_hour_p "Time submitted"
note submissiondate_hour_p : "Time submitted"

label variable sec3_34_error_millions "Value entered by the student at {sec3_34} multiplied by 1 000 000"
note sec3_34_error_millions : "Value entered by the student at {sec3_34} multiplied by 1 000 000"

label variable sec3_34_error_thousands "Value entered by the student at {sec3_34} multiplied by 1 000"
note sec3_34_error_thousands : "Value entered by the student at {sec3_34} multiplied by 1 000"


*finished starttime_new_date starttime_new_hour submissiondate_new_date submissiondate_new_hour endtime_new_date endtime_new_hour

tab treatment_status, gen(treated_dummy)
rename treated_dummy2 T1
la var T1 "Risk Treatment"
rename treated_dummy3 T2
la var T2 "Economic Treatment"
rename treated_dummy4 T3
la var T3 "Risk + Econ. Treat."

gen treated = -(treatment_status == 1) + 1
la var treated "Treated"

/////////////////////////////////////////////////////////////////////////////
//////////////   		2.3 - CLEANING COUNTRY VARIABLES		/////////////
/////////////////////////////////////////////////////////////////////////////

*country: sec2_q2

foreach x in sec2_q2 sec3_21 sec3_21_nb_other sec2_q5 sec10_q5_1 sec10_q5_2 {

replace `x'="" if `x'=="666571276" |`x'=="2èME éTAGE" | `x'=="À CONACKRY" | `x'=="AïCHA" | `x'=="ALHASSANE BALDé" |`x'=="BROKY" |`x'=="FOSTIN" |`x'=="GGGUI" | `x'=="GUECKEDOU" | `x'=="GUINÉE" | `x'=="GUINèE" | `x'=="ÉTUDIANTS" 
replace `x'="" if `x'=="HADJA" | `x'=="I1II11188282" | `x'=="IBRAHIMA  CAMARA" | `x'=="HODILE" | `x'=="IYA DOUMBOUYA" | `x'=="LA GUINÉE" | `x'=="LA GUINèE" | `x'=="LAURENE" | `x'=="LAVAGE" | `x'=="LE GUIUEE" | `x'=="MéLO MALA" | `x'=="MILéNE" | `x'=="MINTANY BANGOURA" | `x'=="MOHAMED CHERIF" | `x'=="MOUNTAGA" 
replace `x'="" if `x'=="ORANGE" | `x'=="OUMOU BAH" | `x'=="OURY TELLY"  | `x'=="RAMATOULAYE DIALLO"  | `x'=="SAïDOU" | `x'=="SALIOU BOIRO"  | `x'=="Sè" | `x'=="SIGUIRI" | `x'=="TALISDJI FOFANA" | `x'=="TONTON SYLLA" | `x'=="WATTARA" 

replace `x'="CANADA" if `x'=="À CANADA" | `x'=="CANADA FRANCE ESPAGNE" | `x'=="CANADA OU LA FRANCE" |`x'=="CANADA," | `x'=="I'AMéRIQUE PRéCISéMENT à CANADA" | `x'=="OTTAWA" | `x'=="LA CANADA OU LA FRANCE" | `x'=="CANADA OU U.S.A" 

replace `x'="AUSTRALIA" if `x'=="AUSTRALIE" | `x'=="À AUSTRALIE" | `x'=="AUSTRALIR" 

replace `x'="UNITED STATES" if `x'=="AMÉRIQUE" |`x'=="AMERIQUE OU ALLEMAND" |`x'=="AMERIQUE OU EUROPE" |`x'=="AM RIQUE" |`x'=="AUX ÉTATS-UNIS" |`x'=="AUX ÉTATS-UNIS à NEW YORK" | `x'=="AUX ÉTATS-UNIS D'AMéRIQUE"  | `x'=="J'AIMERAIS M'INSTALLER AUX ÉTATS-UNIS" | `x'=="L'AMÉRIQUE" | `x'=="AM�RIQUE"
replace `x'="UNITED STATES" if `x'=="EN AMéRIQUE OU FRANCE" | `x'=="AMERIQUE ET FRANCE" | `x'=="AU ÉTATS-UNIS" | `x'=="BOSTON" |`x'=="EN USA" | `x'=="ÉTAS UNI D'AMéRIQUE" | `x'=="ÉTAS UNIES" | `x'=="ÉTAS UNIS" | `x'=="PHILADELPHIA" | `x'=="USA OU CANADA" | `x'=="U.S.A OU ESPAGNE"
replace `x'="UNITED STATES" if `x'=="ÉTAS UNIS D'AMéRIQUE" | `x'=="ÉTASUNIEN UNIS" | `x'=="ÉTAT UNI" | `x'=="ÉTAT UNIES" | `x'=="ÉTAT UNIS" | `x'=="ÉTAT -UNIS" | `x'=="ÉTAT UNIS AMéRIQUE" | `x'=="ETAT UNIS AMERIQUE ( U S A )" | `x'=="ÉTAT UNIS D'AMERIQUE" 
replace `x'="UNITED STATES" if `x'=="ÉTAT UNIS D'AMÉRIQUE" | `x'=="ÉTAT UNIS D'AMéRIQUE" | `x'=="ÉTATS  UNIS" | `x'=="ETATS UNI" | `x'=="ÉTATS UNIE D'AMéRIQUE" | `x'=="ÉTATS UNIES" | `x'=="ÉTATS UNIS" | `x'=="ÉTATS UNIS  D'AMéRIQUE" | `x'=="ÉTATS UNIS AMERIQUE  (USA)" 
replace `x'="UNITED STATES" if `x'=="ÉTATS UNIS D'AMéRIQUE"  | `x'=="ÉTATS UNIS OU FRANCE"  | `x'=="ÉTATS UNIS PLUS PRéCISéMENT à VIRGINIE" | `x'=="ÉTATS-UNIS"  | `x'=="ÉTATS-UNIS  D'AMéRIQUE" | `x'=="ÉTATS-UNIS AMéRIQUE"  | `x'=="ÉTATS-UNIS D'AMéRIQUE"  | `x'=="ÉTATS-UNIS D'AMéRIQUE," | `x'=="ÉTATS-UNIS D'AMéRIQUE." | `x'=="ÉTATUNIS" 
replace `x'="UNITED STATES" if `x'=="LES ÉTATS UNIE D'AMéRIQUE" | `x'=="LES ÉTATS UNIS" | `x'=="LES ÉTATS UNIS D'AMERIQUE" | `x'=="LES ÉTATS UNIS D'AMéRIQUE" | `x'=="LES ÉTATS-UNIS" | `x'=="LES ÉTATS-UNIS D'AMéRIQUE" | `x'=="LES USA Où LE CANADA" | `x'=="MON PAYS DE RêVE C'EST L'AMéRIQUE" | `x'=="NE Y NORK"  | `x'=="AM RIQUE" | `x'=="ÉTATS UNIES D'AMéRIQUE" | `x'=="ÉTATS UNI" 

replace `x'="AUSTRIA" if `x'=="AUTRICHE OU CROITIE" 

replace `x'="FRANCE" if `x'=="à PARIS" | `x'=="C'EST LE PAYS Là Où IL Y'A LA BONNE GOUVERNANCE COMME LA FRANCE ,L'ANGLETERRE ETC" |`x'=="EN FRANçE" | `x'=="EN FRANÇE" |`x'=="À PARIS" | `x'=="BLOIS" |`x'=="BORDEAUX" | `x'=="EN FRANC" | `x'=="LA FRANCE 620000099" 
replace `x'="FRANCE" if `x'=="EN FRANçE" | `x'=="FAïENCE" | `x'=="FRACE" | `x'=="FRAN3" | `x'=="FRANçAIS" | `x'=="FRANçE" | `x'=="FRANCE  OU ALLEMAG" | `x'=="FRANCE (NANTE)" | `x'=="FRANCE ET ESPAGNE" | `x'=="FRANCE OU ITALIE" | `x'=="ÎLE DE FRANCE" | `x'=="EN FRANCE Où LE CANADA"| `x'=="FRANCE CANADA"
replace `x'="FRANCE" if  `x'=="LA FRANCE,CANADA,LA BELGIQUE" | `x'=="LE PAYS DéVELOPPéS TELLE  QUE LA FRANCE" | `x'=="MUSéE DU LOUVRE" | `x'=="NANCY" | `x'=="NICE" | `x'=="PEAU" | `x'=="SAINT ÉTIENNE" | `x'=="VALENCIENNES" | `x'=="LA FRANçAIS" | `x'=="LA FRANCE OU LE MEXIQUE" | `x'=="FRANçOIS" 

replace `x'="UNITED ARAB EMIRATES" if `x'=="A DUBAï" | `x'=="DUBAï" | `x'=="DOUBAï" | `x'=="DUBAï"

replace `x'="EUROPE" if `x'=="À L'EUROPE" |`x'=="EUROPE  OU USA" |`x'=="EUROPE OU USA"

replace `x'="SPAIN" if `x'=="BARçA" |`x'=="L' ESPAGNE OU LES USA" |`x'=="L'ESPAGNE OU USA" | `x'==" SPAGNE" 

replace `x'="BELGIUM" if `x'=="BELGIQUE" | `x'=="BELGIQUE OU L'ITALIE" |`x'=="BELEGIQUE" |`x'=="BELGIK" | `x'=="BELGIQUE OU ALLEGMANE" |`x'=="BRUXULLE" |`x'=="LA BELEGIQUE"  

replace `x'="IVORY COAST" if `x'=="CôTE DIVOIR" |`x'=="CôTE D'IVOIRE" |`x'=="CôTé D'IVOIRE" |`x'=="EN CôTE D'IVOIRE" |`x'=="EN CôTé D'IVOIRE" | |`x'=="CôTé DIVORE" |`x'=="CôTE IVOIRE" |`x'=="CôTé IVOIRE" |`x'=="CôTE-D'IVOIRE" 
replace `x'="IVORY COAST" if `x'=="CôTE  D'IVOIRE" |`x'=="CôTé D IVOIRE" |`x'=="CôTé D 'IVOIRE" |`x'=="CôTé DE,'IVOIRE" |`x'=="COTE DIVOIR" |`x'=="CôTé DE'IVOIRE" |`x'=="CôTE D'IVOIR" |`x'=="CôTé DIVOIR" |`x'=="CôTé D'IVOIR" 
replace `x'="IVORY COAST" if `x'=="CôTE DIVOIRE"  |`x'=="CôTé DIVOIRE" |`x'=="EN CôTE IVOIRE" |`x'=="SEKOUNA" 

replace `x'="CUBA" if  `x'=="5354597720 CUBA" 

replace `x'="ANGOLA" if  `x'=="À LOUANDA" 

replace `x'="AFRICA" if  `x'=="AFRIGUE" 

replace `x'="GERMANY" if `x'=="ALLEMAGNE  ROMA" |`x'=="ALMANGNE ET  CANADA" 

replace `x'="ENGLAND" if `x'=="ANGLETERRE ET AMéRIQUES" | `x'=="ANGLE-TERRE"|`x'=="EN ANGLETAIR" |`x'=="LONDRE OU L'ITALIE" | `x'=="ANGLETERAIR OU LA FRANCE" | `x'=="ANGLETERRE OU CANDA" | `x'=="ANGLETERRE,ESPAGNE OU ALLEMAGNE" | `x'=="ENGLETERRE, CANADA" | `x'=="ANGLETERRE OU AMERIQUE" 

replace `x'="MOROCCO" if `x'=="AU MAROQUE" | `x'=="OUSMANE GERMAIN SYLLA MAROC" 

replace `x'="SUDAN" if `x'=="AU SOUDAN"

replace `x'="TCHAD" if `x'=="AU TCHAD"

replace `x'="GABON" if `x'=="B GABON"

replace `x'="BAHRAIN" if `x'=="BAHREïN"

replace `x'="AZERBAIJAN" if `x'=="BAKOU"

replace `x'="THAILAND" if `x'=="BANGKOK" | `x'=="BANKOK" | `x'=="THAïLANDE" 

replace `x'="BRAZIL" if `x'=="BRèSIL" 

replace `x'="BURKINA FASO" if `x'=="BURKINA FASSO"

replace `x'="CAMEROUN" if `x'=="CAMEROU" 

replace `x'="CAPE VERDE" if `x'=="CAP-VERT" |`x'=="CAPVER"

replace `x'="CENTRAL AFRICAN REPUBLIC" if `x'=="CENTRE AFRIQUE BANGUI" 

replace `x'="JAPAN" if `x'=="CHAPON" 

replace `x'="CYPRUS" if `x'=="CHIPRE"

replace `x'="NORTH KOREA" if `x'=="CORéE DU NORD"

replace `x'="SOUTH KOREA" if `x'=="CORéEN DU SUD" |`x'=="CORéEN DU SUD"

replace `x'="MALAISIA" if `x'=="DJAKARTA"

replace `x'="EGYPT" if `x'=="ÉGYPTE" | `x'=="TIMA" 

replace `x'="SIERRA LEONE" if `x'=="EN SERA LION"| `x'=="SERRA LEONE" | `x'=="SERRA LIONE" 

replace `x'="ETHIOPIA" if `x'=="ÉTHIOPIE"

replace `x'="GHANA" if `x'=="GAHNA" | `x'=="GHANZ" 

replace `x'="SWITZERLAND" if `x'=="GENèVE" | `x'=="SUISS" | `x'=="SWISS" 

replace `x'="GREECE" if `x'=="GRèCE" 

replace `x'="GAMBIA" if `x'=="GUANBI" 

replace `x'="EQUATORIAL GUINEA" if `x'=="GUINéE éQUATORIALE" 

replace `x'="VIETNAM" if `x'=="HANOï" 

replace `x'="ISRAEL" if `x'=="ISRAëL" 

replace `x'="ITALY" if `x'=="ITALE" | `x'=="ITALIE APRèS LA FRANCE" |  `x'=="ITLE" 

replace `x'="KOWEIT" if `x'=="KOWEïT" 

replace `x'="SOUTH AMERICA" if `x'=="L'AMéRIQUE DU SUD" 

replace `x'="MALI" if `x'=="MALI BAMAKO" 

replace `x'="MOROCCO" if `x'=="MAROC627235137" | `x'=="MAROQUIN" | `x'=="MOROC" 

replace `x'="MOZAMBIQUE" if `x'=="MAUZAMBIQUE" | `x'=="MOJAMBIQ"

replace `x'="MAURITANIA" if `x'=="MORITANI" | `x'=="MORY TA N'Y"

replace `x'="RUSSIA" if `x'=="MOSCOW" | `x'=="MOUSCOU" | `x'=="RUISSI" | `x'=="RUSSI" | `x'=="RUSSIE , CANADA,  RUSSIE" 

replace `x'="NORWAY" if `x'=="NORVèGE"

replace `x'="OCEANIA" if `x'=="OCéANIE"

replace `x'="NETHERLANDS" if `x'=="OLANDE" | `x'=="HOLLANDE OU FRANCE"

replace `x'="URUGUAY" if `x'=="RIVERA"

replace `x'="ROMANIA" if `x'=="ROUMANIE"

replace `x'="SENEGAL" if `x'=="SENEGL"

replace `x'="SWEDEN" if `x'=="SUèDE" |`x'=="SUIDE"  

replace `x'="SYRIA" if `x'=="SYRIE"

replace `x'="TURKEY" if `x'=="TIRQUI" 

replace `x'="TUNISIA" if `x'=="TUNISIE FRANCE" | `x'=="TUNUSIE" | `x'=="TUNISSI"

}


replace sec2_q2="UNITED STATES" if key_base=="uuid:793ef687-1587-463a-bcf5-36deapaper2" & time==0
replace sec2_q2="UNITED STATES" if key_base=="uuid:793ef687-1587-463a-bcf5-36dea403ebpaper1" & time==0

/////////////////////////////////////////////////////////////////////////////
//////////////   	CREATING CONTINENT VARIABLES		/////////////////////
/////////////////////////////////////////////////////////////////////////////

*Country they wish to go to

replace sec2_q2a="EUROPE" if sec2_q2=="FRANCE" | sec2_q2=="GERMANY" | sec2_q2=="ENGLAND" | sec2_q2=="BELGIUM" | sec2_q2=="EUROPE" | sec2_q2=="SPAIN" | sec2_q2=="ITALY" | sec2_q2=="NETHERLANDS"  | sec2_q2=="NORWAY"  | sec2_q2=="CYPRUS"  | sec2_q2=="DENMARK"  | sec2_q2=="HUNGARY"  | sec2_q2=="POLAND"  | sec2_q2=="SWEDEN"  | sec2_q2=="SWITZERLAND"  
replace sec2_q2a="AFRICA" if sec2_q2=="EGYPT" | sec2_q2=="ALGERIA" | sec2_q2=="IVORY COAST" | sec2_q2=="MOROCCO" | sec2_q2=="SENEGAL" | sec2_q2=="BENIN" | sec2_q2=="GUINEA BISSAU" | sec2_q2=="CAPE VERDE" | sec2_q2=="GAMBIA" | sec2_q2=="LIBERIA" | sec2_q2=="LIBYA" | sec2_q2=="NIGERIA" | sec2_q2=="DRC" | sec2_q2=="SIERRA LEONE" | sec2_q2=="TUNISIA" 
replace sec2_q2a="NORTH AMERICA" if sec2_q2=="CANADA" | sec2_q2=="UNITED STATES" | sec2_q2=="JAMAICA" 
replace sec2_q2a="ASIA" if sec2_q2=="ASIA" | sec2_q2=="JAPAN" | sec2_q2=="KOWEIT" | sec2_q2=="MALAISIA" | sec2_q2=="THAILAND" | sec2_q2=="CHINA"   | sec2_q2=="SAUDI ARABIA" | sec2_q2=="RUSSIA" | sec2_q2=="TURKEY" | sec2_q2=="UNITED ARAB EMIRATES"
replace sec2_q2a="SOUTH AMERICA" if sec2_q2=="BRAZIL" 
replace sec2_q2a="OCEANIA" if sec2_q2=="AUSTRALIA" 

label variable sec2_q2a "If you could go anywhere in the world, which continent would you like to live in? "
note sec2_q2a : "If you could go anywhere in the world, which continent would you like to live in? "

*Country they plan to go to

replace sec2_q5a="EUROPE" if sec2_q5=="FRANCE" | sec2_q5=="GERMANY" | sec2_q5=="ENGLAND" | sec2_q5=="BELGIUM" | sec2_q5=="EUROPE" | sec2_q5=="SPAIN" | sec2_q5=="ITALY" | sec2_q5=="NETHERLANDS"  | sec2_q5=="NORWAY"  | sec2_q5=="CYPRUS"  | sec2_q5=="DENMARK"  | sec2_q5=="HUNGARY"  | sec2_q5=="POLAND"  | sec2_q5=="SWEDEN"  | sec2_q5=="SWITZERLAND"  
replace sec2_q5a="AFRICA" if sec2_q5=="EGYPT" | sec2_q5=="ALGERIA" | sec2_q5=="IVORY COAST" | sec2_q5=="MOROCCO" | sec2_q5=="SENEGAL" | sec2_q5=="BENIN" | sec2_q5=="GUINEA BISSAU" | sec2_q5=="CAPE VERDE" | sec2_q5=="GAMBIA" | sec2_q5=="LIBERIA" | sec2_q5=="LIBYA" | sec2_q5=="NIGERIA" | sec2_q5=="DRC" | sec2_q5=="SIERRA LEONE" | sec2_q5=="TUNISIA" 
replace sec2_q5a="NORTH AMERICA" if sec2_q5=="CANADA" | sec2_q5=="UNITED STATES" | sec2_q5=="JAMAICA" 
replace sec2_q5a="ASIA" if sec2_q5=="ASIA" | sec2_q5=="JAPAN" | sec2_q5=="KOWEIT" | sec2_q5=="MALAISIA" | sec2_q5=="THAILAND" | sec2_q5=="CHINA"   | sec2_q5=="SAUDI ARABIA" | sec2_q5=="RUSSIA" | sec2_q5=="TURKEY" | sec2_q5=="UNITED ARAB EMIRATES"
replace sec2_q5a="SOUTH AMERICA" if sec2_q5=="BRAZIL" 
replace sec2_q5a="OCEANIA" if sec2_q5=="AUSTRALIA" 

label variable sec2_q5a "Which continent are you planning to move to?"
note sec2_q5a : "Which continent are you planning to move to?"



***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   3 - CREATING MIGRATION VARIABLES                             
***_____________________________________________________________________________

*Sources of information:
*1 from school, 2 from student phone, 3 from contact phone, 4 short school
label define source_info 0 "Tablet" 1 "Phone (Subject)" 2 "Phone (Contact)" 3 "SSS (Students)" ///
		4 "SSS (Administration)" 5 "Unstructured Call" 6 "Phone Status (On/Off)"



///////////////////////////////////////////////////////////////////////////
///////////      3.3 - IRREGULAR MIGRATION TO EUROPE         //////////////
///////////////////////////////////////////////////////////////////////////

**** in Europe at the moment and did not take a plane ****
gen irregular_mig_eu=.
gen source_info_mig=.
replace irregular_mig_eu=0 if surveycto_lycee==1
replace source_info_mig=1 if surveycto_lycee==1

***					 STUDENT
*in Europe, did not take a plane (student) : 1
replace irregular_mig_eu=1 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(irregular_mig_eu)
replace source_info_mig=2 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(source_info_mig)
*not in Europe (student) : 0
replace irregular_mig_eu=0 if mig_1_p!="EUROPE" & missing(irregular_mig_eu)
replace source_info_mig=2 if mig_1_p!="EUROPE" & missing(source_info_mig)
*in Europe by plane (student): 0
replace irregular_mig_eu=0 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(irregular_mig_eu)
replace source_info_mig=2 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(source_info_mig)

***					 CONTACT
*in Europe, did not take a plane (contact) : 1
replace irregular_mig_eu=1 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(irregular_mig_eu)
replace source_info_mig=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(source_info_mig)
*not in Europe (contact) : 0
replace irregular_mig_eu=0 if mig_1_contact_p!="EUROPE" & missing(irregular_mig_eu)
replace source_info_mig=3 if mig_1_contact_p!="EUROPE"  & missing(source_info_mig)
*in Europe by plane (contact) : 0
replace irregular_mig_eu=0 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(irregular_mig_eu)
replace source_info_mig=2 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(source_info_mig)

***					 COMMENT PHONE FILES
*in Europe, irregularly (comments phone files) : 1
replace irregular_mig_eu=1 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu)
replace source_info_mig=5 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig)
*not in Europe (comments phone files) : 0
replace irregular_mig_eu=0 if continent_pf!="EUROPE" & missing(irregular_mig_eu)
replace source_info_mig=5 if continent_pf!="EUROPE" & missing(source_info_mig)

label variable irregular_mig_eu "In Europe at the moment and did not take a plane"
label values irregular_mig_eu yesno
label variable source_info_mig "How did we get this information?"
label values source_info_mig source_info

tab irregular_mig_eu
tab source_info_mig
*7376


*** in Europe at the moment, did not take a plane and did not receive a visa ***
gen irregular_mig_eu_2=.
gen source_info_mig_2=.
replace irregular_mig_eu_2=0 if surveycto_lycee==1
replace source_info_mig_2=1 if surveycto_lycee==1

***					 STUDENT
*in Europe at the moment, did not take a plane and did not receive a visa (student)
replace irregular_mig_eu_2=1 if mig_1_p=="EUROPE" & mig_6_p!=1 & mig_22_a_p==2 & missing(irregular_mig_eu_2)
replace source_info_mig_2=2 if mig_1_p=="EUROPE" & mig_6_p!=1 & mig_22_a_p==2 & missing(source_info_mig_2)
*not in Europe (student)
replace irregular_mig_eu_2=0 if mig_1_p!="EUROPE" & missing(irregular_mig_eu_2)
replace source_info_mig_2=2 if mig_1_p!="EUROPE" & missing(source_info_mig_2)
*in Europe by plane (student)
replace irregular_mig_eu_2=0 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(irregular_mig_eu_2)
replace source_info_mig_2=2 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(source_info_mig_2)
*in Europe with a visa (student)
replace irregular_mig_eu_2=0 if mig_1_p=="EUROPE" & mig_22_a_p==1 & missing(irregular_mig_eu_2)
replace source_info_mig_2=2 if mig_1_p=="EUROPE" & mig_22_a_p==1 & missing(source_info_mig_2)

***					 CONTACT
*in Europe at the moment, did not take a plane and did not receive a visa (contact)
replace irregular_mig_eu_2=1 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & mig_22_a_contact_p==2 & missing(irregular_mig_eu_2)
replace source_info_mig_2=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & mig_22_a_contact_p==2 & missing(source_info_mig_2)
*not in Europe (contact)
replace irregular_mig_eu_2=0 if mig_1_contact_p!="EUROPE" & missing(irregular_mig_eu_2)
replace source_info_mig_2=3 if mig_1_contact_p!="EUROPE" & missing(source_info_mig_2)
*in Europe by plane (contact)
replace irregular_mig_eu_2=0 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(irregular_mig_eu_2)
replace source_info_mig_2=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(source_info_mig_2)
*in Europe with a visa (contact)
replace irregular_mig_eu_2=0 if mig_1_contact_p=="EUROPE" & mig_22_a_contact_p==1 & missing(irregular_mig_eu_2)
replace source_info_mig_2=3 if mig_1_contact_p=="EUROPE" & mig_22_a_contact_p==1 & missing(source_info_mig_2)

label variable irregular_mig_eu_2 "The student is in Europe at the moment, he did not take a plane and did not receive a visa"
label values irregular_mig_eu_2 yesno
label variable source_info_mig_2 "How did we get this information?"
label values source_info_mig_2 source_info

tab irregular_mig_eu_2
tab source_info_mig_2
*7371

///////////////////////////////////////////////////////////////////////////
//   3.4 - PLANNING TO MIGRATE/HAVING MIGRATED IRREGULARLY TO EUROPE   ////
///////////////////////////////////////////////////////////////////////////

gen irregular_mig_eu_3=.
gen source_info_mig_3=.
replace irregular_mig_eu_3=0 if surveycto_lycee==1
replace source_info_mig_3=1 if surveycto_lycee==1

*** 				SCHOOL SURVEY
*** In Guinea, planning to reach Europe without asking for a visa 
*In Guinea, planning to go to Europe, did not/will not ask for a visa (school survey): 1
replace irregular_mig_eu_3=1 if sec2_q5a=="EUROPE" & sec2_q10_a==2 & sec2_q10_c==2 & missing(irregular_mig_eu_3)
replace source_info_mig_3=1 if sec2_q5a=="EUROPE" & sec2_q10_a==2 & sec2_q10_c==2 & missing(source_info_mig_3)


***					 STUDENT
*** In Europe irregularly at the moment:
*in Europe, did not take a plane (student): 1
replace irregular_mig_eu_3=1 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(source_info_mig_3)
*Not in Europe (student): 0
replace irregular_mig_eu_3=0 if mig_1_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_1_p!="EUROPE"  & missing(source_info_mig_3)
*in Europe by plane (student): 0
replace irregular_mig_eu_3=0 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(source_info_mig_3)

*** Abroad planning to reach Europe irregularly:
*Abroad, planning to reach Europe by boat (student): 1
replace irregular_mig_eu_3=1 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(source_info_mig_3)
*Not abroad on the way to Europe (student): 0
replace irregular_mig_eu_3=0 if mig_14_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_14_p!="EUROPE" & missing(source_info_mig_3)

*** In Guinea, planning to reach Europe without asking for a visa 
*In Guinea, planning to go to Europe, did not/will not ask for a visa (student): 1
replace irregular_mig_eu_3=1 if sec2_q5a_p=="EUROPE" & sec2_q10_a_p==2 & sec2_q10_c_p==2 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if sec2_q5a_p=="EUROPE" & sec2_q10_a_p==2 & sec2_q10_c_p==2 & missing(source_info_mig_3)


***					CONTACT
*** In Europe irregularly at the moment:
*in Europe, did not take a plane (contact): 1
replace irregular_mig_eu_3=1 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(source_info_mig_3)
*Not in Europe (contact): 0
replace irregular_mig_eu_3=0 if mig_1_contact_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_1_contact_p!="EUROPE"  & missing(source_info_mig_3)
*in Europe by plane (contact): 0
replace irregular_mig_eu_3=0 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(source_info_mig_3)

*** Abroad planning to reach Europe irregularly:
*Abroad, planning to reach Europe by boat (contact): 1
replace irregular_mig_eu_3=1 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1& missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1 & missing(source_info_mig_3)
*Not abroad on the way to Europe (contact): 0
replace irregular_mig_eu_3=0 if mig_14_contact_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_14_contact_p!="EUROPE" & missing(source_info_mig_3)

*** In Guinea, planning to reach Europe without asking for a visa : 1
*In Guinea, planning to go to Europe, did not/will not ask for a visa (student)
replace irregular_mig_eu_3=1 if sec2_q5a_contact_p=="EUROPE" & sec2_q10_a_contact_p==2 & sec2_q10_c_contact_p==2 & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if sec2_q5a_contact_p=="EUROPE" & sec2_q10_a_contact_p==2 & sec2_q10_c_contact_p==2 & missing(source_info_mig_3)


***				COMMENT PHONE FILES
*** In Europe irregularly at the moment:
*in Europe irregularly (comment phone files): 1
replace irregular_mig_eu_3=1 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=5 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_3)


*** Abroad planning to reach Europe irregularly:
*Not in Europe but planning to go irregularly (comment phone files): 1
replace irregular_mig_eu_3=1 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=5 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_3)


label variable irregular_mig_eu_3 "Planning to migrate irregularly to Europe or having already migrated towards/reached Europe irregularly"
label values irregular_mig_eu_3 yesno
label variable source_info_mig_3 "How did we get this information?"
label values source_info_mig_3 source_info

tab irregular_mig_eu_3
tab source_info_mig_3
*7371

///////////////////////////////////////////////////////////////////////////
//////// 		3.5 - ON THE WAY/ARRIVED IN EUROPE 			///////////////
//////////////////////////////////////////////////////////////////////////
gen irregular_mig_eu_4=.
gen source_info_mig_4=.
replace irregular_mig_eu_4=0 if surveycto_lycee==1
replace source_info_mig_4=1 if surveycto_lycee==1

***					 STUDENT
*** In Europe irregularly at the moment:
*in Europe, did not take a plane (student): 1
replace irregular_mig_eu_4=1 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(irregular_mig_eu_4)
replace source_info_mig_4=2 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(source_info_mig_4)
*Not in Europe (student): 0
replace irregular_mig_eu_4=0 if mig_1_p!="EUROPE" & missing(irregular_mig_eu_4)
replace source_info_mig_4=2 if mig_1_p!="EUROPE"  & missing(source_info_mig_4)
*in Europe by plane (student): 0
replace irregular_mig_eu_4=0 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(irregular_mig_eu_4)
replace source_info_mig_4=2 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(source_info_mig_4)

*** Abroad planning to reach Europe irregularly:
*Abroad, planning to reach Europe by boat (student): 1
replace irregular_mig_eu_4=1 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(irregular_mig_eu_4)
replace source_info_mig_4=2 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(source_info_mig_4)
*Not abroad on the way to Europe (student): 0
replace irregular_mig_eu_4=0 if mig_14_p!="EUROPE" & missing(irregular_mig_eu_4)
replace source_info_mig_4=2 if mig_14_p!="EUROPE" & missing(source_info_mig_4)



***					CONTACT
*** In Europe irregularly at the moment:
*in Europe, did not take a plane (contact): 1
replace irregular_mig_eu_4=1 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(irregular_mig_eu_4)
replace source_info_mig_4=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(source_info_mig_4)
*Not in Europe (contact): 0
replace irregular_mig_eu_4=0 if mig_1_contact_p!="EUROPE" & missing(irregular_mig_eu_4)
replace source_info_mig_4=3 if mig_1_contact_p!="EUROPE"  & missing(source_info_mig_4)
*in Europe by plane (contact): 0
replace irregular_mig_eu_4=0 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(irregular_mig_eu_4)
replace source_info_mig_4=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(source_info_mig_4)

*** Abroad planning to reach Europe irregularly:
*Abroad, planning to reach Europe by boat (contact): 1
replace irregular_mig_eu_4=1 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1& missing(irregular_mig_eu_4)
replace source_info_mig_4=3 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1 & missing(source_info_mig_4)
*Not abroad on the way to Europe (contact): 0
replace irregular_mig_eu_4=0 if mig_14_contact_p!="EUROPE" & missing(irregular_mig_eu_4)
replace source_info_mig_4=3 if mig_14_contact_p!="EUROPE" & missing(source_info_mig_4)



***				COMMENT PHONE FILES
*** In Europe irregularly at the moment:
*in Europe irregularly (comment phone files): 1
replace irregular_mig_eu_4=1 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_4)
replace source_info_mig_4=5 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_4)

*** Abroad planning to reach Europe irregularly:
*Not in Europe but planning to go irregularly (comment phone files): 1
replace irregular_mig_eu_4=1 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_4)
replace source_info_mig_4=5 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_4)



label variable irregular_mig_eu_4 "On their way to Europe for irregular migration or already arrived in Europe irregularly"
label values irregular_mig_eu_4 yesno
label variable source_info_mig_4 "How did we get this information?"
label values source_info_mig_4 source_info

tab irregular_mig_eu_4
tab source_info_mig_4
*7371


///////////////////////////////////////////////////////////////////////////
//////   3.6 - PLANNING/WISHING TO MIGRATE IRREGULARLY TO EUROPE     //////
///////////////////////////////////////////////////////////////////////////
gen irregular_mig_eu_5=.
gen source_info_mig_5=.

*** 				SCHOOL SURVEY
*** In Guinea, planning to reach Europe without asking for a visa 
*In Guinea, planning to go to Europe, did not/will not ask for a visa (school survey): 1
replace irregular_mig_eu_5=1 if sec2_q2a=="EUROPE" & sec2_q10_a==2 & sec2_q10_c==2 & missing(irregular_mig_eu_5)
replace source_info_mig_5=1 if sec2_q2a=="EUROPE" & sec2_q10_a==2 & sec2_q10_c==2 & missing(source_info_mig_5)

*In Guinea, wanting to go to Europe, will not ask for a visa (school survey): 1
replace irregular_mig_eu_5=1 if sec2_q2a=="EUROPE" & sec2_q10_b==2 & missing(irregular_mig_eu_5)
replace source_info_mig_5=1 if sec2_q2a=="EUROPE" & sec2_q10_b==2 & missing(source_info_mig_5)


***					 STUDENT
*** In Europe irregularly at the moment:
*in Europe, did not take a plane (student): 1
replace irregular_mig_eu_5=1 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(irregular_mig_eu_5)
replace source_info_mig_5=2 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(source_info_mig_5)
*Not in Europe (student): 0
replace irregular_mig_eu_5=0 if mig_1_p!="EUROPE" & missing(irregular_mig_eu_5)
replace source_info_mig_5=2 if mig_1_p!="EUROPE"  & missing(source_info_mig_5)
*in Europe by plane (student): 0
replace irregular_mig_eu_5=0 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(irregular_mig_eu_5)
replace source_info_mig_5=2 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(source_info_mig_5)

*** Abroad planning to reach Europe irregularly:
*Abroad, planning to reach Europe by boat (student): 1
replace irregular_mig_eu_5=1 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(irregular_mig_eu_5)
replace source_info_mig_5=2 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(source_info_mig_5)
*Not abroad on the way to Europe (student): 0
replace irregular_mig_eu_5=0 if mig_14_p!="EUROPE" & missing(irregular_mig_eu_5)
replace source_info_mig_5=2 if mig_14_p!="EUROPE" & missing(source_info_mig_5)

*** In Guinea, planning to reach Europe without asking for a visa 
*In Guinea, planning to go to Europe, did not/will not ask for a visa (student): 1
replace irregular_mig_eu_5=1 if sec2_q5a_p=="EUROPE" & sec2_q10_a_p==2 & sec2_q10_c_p==2 & missing(irregular_mig_eu_5)
replace source_info_mig_5=2 if sec2_q5a_p=="EUROPE" & sec2_q10_a_p==2 & sec2_q10_c_p==2 & missing(source_info_mig_5)
*In Guinea, wanting to go to Europe (not planning), will not ask for a visa (school survey): 1
replace irregular_mig_eu_5=1 if sec2_q5a_p=="EUROPE" & sec2_q10_b_p==2 & missing(irregular_mig_eu_5)
replace source_info_mig_5=1 if sec2_q5a_p=="EUROPE" & sec2_q10_b_p==2 & missing(source_info_mig_5)


***					CONTACT
*** In Europe irregularly at the moment:
*in Europe, did not take a plane (contact): 1
replace irregular_mig_eu_5=1 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(irregular_mig_eu_5)
replace source_info_mig_5=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(source_info_mig_5)
*Not in Europe (contact): 0
replace irregular_mig_eu_5=0 if mig_1_contact_p!="EUROPE" & missing(irregular_mig_eu_5)
replace source_info_mig_5=3 if mig_1_contact_p!="EUROPE"  & missing(source_info_mig_5)
*in Europe by plane (contact): 0
replace irregular_mig_eu_5=0 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(irregular_mig_eu_5)
replace source_info_mig_5=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(source_info_mig_5)

*** Abroad planning to reach Europe irregularly:
*Abroad, planning to reach Europe by boat (contact): 1
replace irregular_mig_eu_5=1 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1& missing(irregular_mig_eu_5)
replace source_info_mig_5=3 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1 & missing(source_info_mig_5)
*Not abroad on the way to Europe (contact): 0
replace irregular_mig_eu_5=0 if mig_14_contact_p!="EUROPE" & missing(irregular_mig_eu_5)
replace source_info_mig_5=3 if mig_14_contact_p!="EUROPE" & missing(source_info_mig_5)

*** In Guinea, planning to reach Europe without asking for a visa : 1
*In Guinea, planning to go to Europe, did not/will not ask for a visa (student)
replace irregular_mig_eu_5=1 if sec2_q5a_contact_p=="EUROPE" & sec2_q10_a_contact_p==2 & sec2_q10_c_contact_p==2 & missing(irregular_mig_eu_5)
replace source_info_mig_5=3 if sec2_q5a_contact_p=="EUROPE" & sec2_q10_a_contact_p==2 & sec2_q10_c_contact_p==2 & missing(source_info_mig_5)


***				COMMENT PHONE FILES
*** In Europe irregularly at the moment:
*in Europe irregularly (comment phone files): 1
replace irregular_mig_eu_5=1 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_5)
replace source_info_mig_5=5 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_5)


*** Abroad planning to reach Europe irregularly:
*Not in Europe but planning to go irregularly (comment phone files): 1
replace irregular_mig_eu_5=1 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_5)
replace source_info_mig_5=5 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_5)


label variable irregular_mig_eu_5 "Planning/wishing to migrate irregularly to Europe or having already migrated towards/reached Europe irregularly"
label values irregular_mig_eu_5 yesno
label variable source_info_mig_5 "How did we get this information?"
label values source_info_mig_5 source_info


gen female = sec0_q2 - 1
gen male = female == 0 & !missing(female)
la var female "Female"




///////////////////////////////////////////////////////////////////////////
///////////////              3.1.1 - LEFT CONAKRY              ////////////
///////////////////////////////////////////////////////////////////////////

*Is the student outside of Conakry?
gen migration_conakry=.
*Where does the info come from?
gen source_info_conakry = .

*Subject found in school.
replace migration_conakry=0 if surveycto_lycee==1
*Info Conakry from Subject Tablet
replace source_info_conakry = 0  if missing(source_info_conakry)&!missing(migration_conakry)
*Subject found by phone.
*NO
replace migration_conakry=0 if where_9_p==1 & missing(migration_conakry)
*YES
replace migration_conakry=1 if where_9_p==2 & missing(migration_conakry)
*Info Conakry from Subject
replace source_info_conakry = 1 if missing(source_info_conakry)&!missing(migration_conakry)
*Second call with contacts.
*NO
replace migration_conakry=0 if where_9_contact_sec_p==1  & missing(migration_conakry)
*YES
replace migration_conakry=1 if where_9_contact_sec_p==2  & missing(migration_conakry)
*First call with contacts.
*NO
replace migration_conakry=0 if where_9_contact_p==1   & missing(migration_conakry)
*YES
replace migration_conakry=1 if where_9_contact_p==2  & missing(migration_conakry)
*Info Conakry from own Contacts
replace source_info_conakry = 2 if missing(source_info_conakry)&!missing(migration_conakry)
*Short School Survey with Students.
*YES
replace migration_conakry=1 if left_conakry_sss==1 & info_source_sss != 3 & missing(migration_conakry)
*NO
replace migration_conakry=0 if left_conakry_sss==0  & info_source_sss != 3 &   missing(migration_conakry)
*YES
replace migration_conakry=1 if left_conakry_3_sss==1 & info_source_3_sss != 3 & missing(migration_conakry)
*NO
replace migration_conakry=0 if left_conakry_3_sss==0  & info_source_3_sss !=  3 & missing(migration_conakry)
*Info Conakry from SSS (Students)
replace source_info_conakry = 3 if missing(source_info_conakry)&!missing(migration_conakry)
*SSS (Administration)
*YES
replace migration_conakry=1 if left_conakry_sss==1 & info_source_sss == 3 & missing(migration_conakry)
*NO
replace migration_conakry=0 if left_conakry_sss==0  & info_source_sss == 3 &   missing(migration_conakry)
*YES
replace migration_conakry=1 if left_conakry_3_sss==1 & info_source_3_sss == 3 & missing(migration_conakry)
*NO
replace migration_conakry=0 if left_conakry_3_sss==0  & info_source_3_sss ==  3 & missing(migration_conakry)
*Info Conakry from SSS (Administration)
replace source_info_conakry = 4 if missing(source_info_conakry)&!missing(migration_conakry)
*Unstructured Surves
*YES
replace migration_conakry=1 if outside_conakry_pf==1 & time == 2  & missing(migration_conakry)
*NO
replace migration_conakry=0 if outside_conakry_pf==0 & time == 2 & missing(migration_conakry)
*Info Conakry from Unstructured Calls.
replace source_info_conakry = 5 if missing(source_info_conakry)&!missing(migration_conakry)
*YES
replace migration_conakry=1 if phone_on_pf==0 & time == 2  & missing(migration_conakry)
*NO
replace migration_conakry=0 if phone_on_pf==1 & time == 2 & missing(migration_conakry)
*Info Conakry from Phone Status.
replace source_info_conakry = 6 if missing(source_info_conakry)&!missing(migration_conakry)

label variable migration_conakry "Did the student leave Conakry?"
label variable source_info_conakry "How did we get this information?"

tab migration_conakry
*7366 -> 5 missing
*replace migration_conakry=0 if migration_conakry==""


label define migration 0 "Not migr." 1 "Migr."
label values migration_conakry migration
label values source_info_conakry source_info

///////////////////////////////////////////////////////////////////////////
///////////////  3.1.2 - LEFT CONAKRY (CONTACTS A.L. 6 MONTHS) ////////////
///////////////////////////////////////////////////////////////////////////

*Is the student outside of Conakry?
gen migration_conakry_6=.
*Where does the info come from?
gen source_info_conakry_6 = .

*Subject found in school.
replace migration_conakry_6=0 if surveycto_lycee==1
*Info Conakry from Subject Tablet
replace source_info_conakry_6 = 0  if missing(source_info_conakry_6)&!missing(migration_conakry_6)
*Subject found by phone.
*NO
replace migration_conakry_6=0 if where_9_p==1 & missing(migration_conakry_6)
*YES
replace migration_conakry_6=1 if where_9_p==2 & missing(migration_conakry_6)
*Info Conakry from Subject
replace source_info_conakry_6 = 1 if missing(source_info_conakry_6)&!missing(migration_conakry_6)
*Second call with contacts.
*NO
replace migration_conakry_6=0 if where_9_contact_sec_p==1 & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2  | ///
	sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4 | ///
	sec0_q1_contact_sec_p==5) & missing(migration_conakry_6)
*YES
replace migration_conakry_6=1 if where_9_contact_sec_p==2 & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2 ///
	| sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4 ///
	| sec0_q1_contact_sec_p==5) & missing(migration_conakry_6)
*First call with contacts.
*NO
replace migration_conakry_6=0 if where_9_contact_p==1 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2 ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4 ///
	| sec0_q1_contact_p==5)  & missing(migration_conakry_6)
*YES
replace migration_conakry_6=1 if where_9_contact_p==2 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2  ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4 ///
	| sec0_q1_contact_p==5) & missing(migration_conakry_6)
*Info Conakry from own Contacts
replace source_info_conakry_6 = 2 if missing(source_info_conakry_6)&!missing(migration_conakry_6)
*Short School Survey with Students.
*YES
replace migration_conakry_6=1 if left_conakry_sss==1 & info_source_sss != 3 & missing(migration_conakry_6)
*NO
replace migration_conakry_6=0 if left_conakry_sss==0  & info_source_sss != 3 &   missing(migration_conakry_6)
*YES
replace migration_conakry_6=1 if left_conakry_3_sss==1 & info_source_3_sss != 3 & missing(migration_conakry_6)
*NO
replace migration_conakry_6=0 if left_conakry_3_sss==0  & info_source_3_sss !=  3 & missing(migration_conakry_6)
*Info Conakry from SSS (Students)
replace source_info_conakry_6 = 3 if missing(source_info_conakry_6)&!missing(migration_conakry_6)
*SSS (Administration)
*YES
replace migration_conakry_6=1 if left_conakry_sss==1 & info_source_sss == 3 & missing(migration_conakry_6)
*NO
replace migration_conakry_6=0 if left_conakry_sss==0  & info_source_sss == 3 &   missing(migration_conakry_6)
*YES
replace migration_conakry_6=1 if left_conakry_3_sss==1 & info_source_3_sss == 3 & missing(migration_conakry_6)
*NO
replace migration_conakry_6=0 if left_conakry_3_sss==0  & info_source_3_sss ==  3 & missing(migration_conakry_6)
*Info Conakry from SSS (Administration)
replace source_info_conakry_6 = 4 if missing(source_info_conakry_6)&!missing(migration_conakry_6)
*Unstructured Surves
*YES
replace migration_conakry_6=1 if outside_conakry_pf==1 & time == 2  & missing(migration_conakry_6)
*NO
replace migration_conakry_6=0 if outside_conakry_pf==0 & time == 2 & missing(migration_conakry_6)
*Info Conakry from Unstructured Calls.
replace source_info_conakry_6 = 5 if missing(source_info_conakry_6)&!missing(migration_conakry_6)
*YES
replace migration_conakry_6=1 if phone_on_pf==0 & time == 2  & missing(migration_conakry_6)
*NO
replace migration_conakry_6=0 if phone_on_pf==1 & time == 2 & missing(migration_conakry_6)
*Info Conakry from Phone Status.
replace source_info_conakry_6 = 6 if missing(source_info_conakry_6)&!missing(migration_conakry_6)


label variable migration_conakry_6 "Did the student leave Conakry?"
label variable source_info_conakry_6 "How did we get this information?"
label values source_info_conakry_6 source_info

tab migration_conakry_6
*7366 -> 5 missing

label values migration_conakry_6 migration


///////////////////////////////////////////////////////////////////////////
///////////////   3.1.3 - LEFT CONAKRY (CONTACTS A.L. 1 MONTH) ////////////
///////////////////////////////////////////////////////////////////////////


*Is the student outside of Conakry?
gen migration_conakry_1=.
*Where does the info come from?
gen source_info_conakry_1 = .

*Subject found in school.
replace migration_conakry_1=0 if surveycto_lycee==1
*Info Conakry from Subject Tablet
replace source_info_conakry_1 = 0  if missing(source_info_conakry_1)&!missing(migration_conakry_1)
*Subject found by phone.
*NO
replace migration_conakry_1=0 if where_9_p==1 & missing(migration_conakry_1)
*YES
replace migration_conakry_1=1 if where_9_p==2 & missing(migration_conakry_1)
*Info Conakry from Subject
replace source_info_conakry_1 = 1 if missing(source_info_conakry_1)&!missing(migration_conakry_1)
*Second call with contacts.
*NO
replace migration_conakry_1=0 if where_9_contact_sec_p==1 & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2  | ///
	sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4 ) ///
	& missing(migration_conakry_1)
*YES
replace migration_conakry_1=1 if where_9_contact_sec_p==2 & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2 ///
	| sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4 ) ///
	& missing(migration_conakry_1)
*First call with contacts.
*NO
replace migration_conakry_1=0 if where_9_contact_p==1 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2 ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4 ) ///
	& missing(migration_conakry_1)
*YES
replace migration_conakry_1=1 if where_9_contact_p==2 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2  ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4 ) ///
	& missing(migration_conakry_1)
*Info Conakry from own Contacts
replace source_info_conakry_1 = 2 if missing(source_info_conakry_1)&!missing(migration_conakry_1)
*Short School Survey with Students.
*YES
replace migration_conakry_1=1 if left_conakry_sss==1 & info_source_sss != 3 & missing(migration_conakry_1)
*NO
replace migration_conakry_1=0 if left_conakry_sss==0  & info_source_sss != 3 &   missing(migration_conakry_1)
*YES
replace migration_conakry_1=1 if left_conakry_3_sss==1 & info_source_3_sss != 3 & missing(migration_conakry_1)
*NO
replace migration_conakry_1=0 if left_conakry_3_sss==0  & info_source_3_sss !=  3 & missing(migration_conakry_1)
*Info Conakry from SSS (Students)
replace source_info_conakry_1 = 3 if missing(source_info_conakry_1)&!missing(migration_conakry_1)
*SSS (Administration)
*YES
replace migration_conakry_1=1 if left_conakry_sss==1 & info_source_sss == 3 & missing(migration_conakry_1)
*NO
replace migration_conakry_1=0 if left_conakry_sss==0  & info_source_sss == 3 &   missing(migration_conakry_1)
*YES
replace migration_conakry_1=1 if left_conakry_3_sss==1 & info_source_3_sss == 3 & missing(migration_conakry_1)
*NO
replace migration_conakry_1=0 if left_conakry_3_sss==0  & info_source_3_sss ==  3 & missing(migration_conakry_1)
*Info Conakry from SSS (Administration)
replace source_info_conakry_1 = 4 if missing(source_info_conakry_1)&!missing(migration_conakry_1)
*Unstructured Surves
*YES
replace migration_conakry_1=1 if outside_conakry_pf==1 & time == 2  & missing(migration_conakry_1)
*NO
replace migration_conakry_1=0 if outside_conakry_pf==0 & time == 2 & missing(migration_conakry_1)
*Info Conakry from Unstructured Calls.
replace source_info_conakry_1 = 5 if missing(source_info_conakry_1)&!missing(migration_conakry_1)
*YES
replace migration_conakry_1=1 if phone_on_pf==0 & time == 2  & missing(migration_conakry_1)
*NO
replace migration_conakry_1=0 if phone_on_pf==1 & time == 2 & missing(migration_conakry_1)
*Info Conakry from Phone Status.
replace source_info_conakry_1 = 6 if missing(source_info_conakry_1)&!missing(migration_conakry_1)

label variable migration_conakry_1 "Did the student leave Conakry?"
label variable source_info_conakry_1 "How did we get this information?"
label values source_info_conakry_1 source_info

tab migration_conakry_1
*7366 -> 5 missing

label values migration_conakry_1 migration

///////////////////////////////////////////////////////////////////////////
///////////////          3.2.1 -  LEFT GUINEA             /////////////////
///////////////////////////////////////////////////////////////////////////


*Is the student outside of Guinea?
gen migration_guinea=.
*Where does the info come from?
gen source_info_guinea = .

replace migration_guinea = 0 if migration_conakry == 0
replace source_info_guinea = source_info_conakry if migration_conakry == 0


*replace 0 for those who live in Conakry
replace migration_guinea=0 if migration_conakry==0 & source_info_conakry<=1
*Info Conakry from Subject Tablet
replace source_info_guinea = source_info_conakry  if source_info_conakry < 2
*NO
replace migration_guinea=0 if where_11_p==1 & missing(migration_guinea)
*YES
replace migration_guinea=1 if where_11_p==2 & missing(migration_guinea)
*Info Guinea from Subject
replace source_info_guinea = 1 if missing(source_info_guinea)&!missing(migration_guinea)
*Second call with contacts.
*NO
replace migration_guinea=0 if where_11_contact_sec_p==1  & missing(migration_guinea)
*YES
replace migration_guinea=1 if where_11_contact_sec_p==2  & missing(migration_guinea)
*First call with contacts.
*NO
replace migration_guinea=0 if where_11_contact_p==1   & missing(migration_guinea)
*YES
replace migration_guinea=1 if where_11_contact_p==2  & missing(migration_guinea)
*Info Guinea from own Contacts
replace source_info_guinea = 2 if missing(source_info_guinea)&!missing(migration_guinea)
*Short School Survey with Students.
*YES
replace migration_guinea=1 if left_guinea_sss==1 & info_source_sss != 3 & missing(migration_guinea)
*NO
replace migration_guinea=0 if left_guinea_sss==0  & info_source_sss != 3 &   missing(migration_guinea)
*YES
replace migration_guinea=1 if left_guinea_3_sss==1 & info_source_3_sss != 3 & missing(migration_guinea)
*NO
replace migration_guinea=0 if left_guinea_3_sss==0  & info_source_3_sss !=  3 & missing(migration_guinea)
*Info Guinea from SSS (Students)
replace source_info_guinea = 3 if missing(source_info_guinea)&!missing(migration_guinea)
*SSS (Administration)
*YES
replace migration_guinea=1 if left_guinea_sss==1 & info_source_sss == 3 & missing(migration_guinea)
*NO
replace migration_guinea=0 if left_guinea_sss==0  & info_source_sss == 3 &   missing(migration_guinea)
*YES
replace migration_guinea=1 if left_guinea_3_sss==1 & info_source_3_sss == 3 & missing(migration_guinea)
*NO
replace migration_guinea=0 if left_guinea_3_sss==0  & info_source_3_sss ==  3 & missing(migration_guinea)
*Info Guinea from SSS (Administration)
replace source_info_guinea = 4 if missing(source_info_guinea)&!missing(migration_guinea)
*Unstructured Surves
*YES
replace migration_guinea=1 if abroad_pf==1 & time == 2  & missing(migration_guinea)
*NO
replace migration_guinea=0 if abroad_pf==0 & time == 2 & missing(migration_guinea)
*Info Conakry from Unstructured Calls.
replace source_info_guinea = 5 if missing(source_info_guinea)&!missing(migration_guinea)
*YES
replace migration_guinea=1 if phone_on_pf==0 & time == 2  & missing(migration_guinea)
*NO
replace migration_guinea=0 if phone_on_pf==1 & time == 2 & missing(migration_guinea)
*Info Conakry from Phone Status.
replace source_info_guinea = 6 if missing(source_info_guinea)&!missing(migration_guinea)

label variable migration_guinea "Did the student leave Guinea?"
label variable source_info_guinea "How did we get this information?"
label values source_info_guinea source_info

tab migration_guinea
*7366 -> 5 missing
*replace migration_guinea=0 if migration_guinea==""

label values migration_guinea migration


///////////////////////////////////////////////////////////////////////////
///////////////  3.2.2 -  LEFT GUINEA  (Contact 6 Months) /////////////////
///////////////////////////////////////////////////////////////////////////

*Is the student outside of Guinea?
gen migration_guinea_6=.
*Where does the info come from?
gen source_info_guinea_6 = .
*replace 0 for those who live in Conakry

replace migration_guinea_6 = 0 if migration_conakry_6 == 0
replace source_info_guinea_6 = source_info_conakry_6 if migration_conakry_6 == 0

replace migration_guinea_6=0 if migration_conakry==0 & source_info_conakry<=1
*Info Conakry from Subject Tablet
replace source_info_guinea_6 = source_info_conakry  if source_info_conakry < 2
*NO
replace migration_guinea_6=0 if where_11_p==1 & missing(migration_guinea_6)
*YES
replace migration_guinea_6=1 if where_11_p==2 & missing(migration_guinea_6)
*Info Guinea from Subject
replace source_info_guinea_6 = 1 if missing(source_info_guinea_6)&!missing(migration_guinea_6)
*Second call with contacts.
*NO
replace migration_guinea_6=0 if where_11_contact_sec_p==1  & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2 ///
	| sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4 ///
	| sec0_q1_contact_sec_p==5) &  missing(migration_guinea_6)
*YES
replace migration_guinea_6=1 if where_11_contact_sec_p==2  & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2 ///
	| sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4 ///
	| sec0_q1_contact_sec_p==5) &  missing(migration_guinea_6)
*First call with contacts.
*NO
replace migration_guinea_6=0 if where_11_contact_p==1 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2  ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4 ///
	| sec0_q1_contact_p==5)  & missing(migration_guinea_6)
*YES
replace migration_guinea_6=1 if where_11_contact_p==2 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2  ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4 ///
	| sec0_q1_contact_p==5) & missing(migration_guinea_6)
*Info Guinea from own Contacts
replace source_info_guinea_6 = 2 if missing(source_info_guinea_6)&!missing(migration_guinea_6)
*Short School Survey with Students.
*YES
replace migration_guinea_6=1 if left_guinea_sss==1 & info_source_sss != 3 & missing(migration_guinea_6)
*NO
replace migration_guinea_6=0 if left_guinea_sss==0  & info_source_sss != 3 &   missing(migration_guinea_6)
*YES
replace migration_guinea_6=1 if left_guinea_3_sss==1 & info_source_3_sss != 3 & missing(migration_guinea_6)
*NO
replace migration_guinea_6=0 if left_guinea_3_sss==0  & info_source_3_sss !=  3 & missing(migration_guinea_6)
*Info Guinea from SSS (Students)
replace source_info_guinea_6 = 3 if missing(source_info_guinea_6)&!missing(migration_guinea_6)
*SSS (Administration)
*YES
replace migration_guinea_6=1 if left_guinea_sss==1 & info_source_sss == 3 & missing(migration_guinea_6)
*NO
replace migration_guinea_6=0 if left_guinea_sss==0  & info_source_sss == 3 &   missing(migration_guinea_6)
*YES
replace migration_guinea_6=1 if left_guinea_3_sss==1 & info_source_3_sss == 3 & missing(migration_guinea_6)
*NO
replace migration_guinea_6=0 if left_guinea_3_sss==0  & info_source_3_sss ==  3 & missing(migration_guinea_6)
*Info Guinea from SSS (Administration)
replace source_info_guinea_6 = 4 if missing(source_info_guinea_6)&!missing(migration_guinea_6)
*Unstructured Surves
*YES
replace migration_guinea_6=1 if abroad_pf==1 & time == 2  & missing(migration_guinea_6)
*NO
replace migration_guinea_6=0 if abroad_pf==0 & time == 2 & missing(migration_guinea_6)
*Info Conakry from Unstructured Calls.
replace source_info_guinea_6 = 5 if missing(source_info_guinea_6)&!missing(migration_guinea_6)
*YES
replace migration_guinea_6=1 if phone_on_pf==0 & time == 2  & missing(migration_guinea_6)
*NO
replace migration_guinea_6=0 if phone_on_pf==1 & time == 2 & missing(migration_guinea_6)
*Info Conakry from Phone Status.
replace source_info_guinea_6 = 6 if missing(source_info_guinea_6)&!missing(migration_guinea_6)

label variable migration_guinea_6 "Did the student leave Guinea?"

label variable source_info_guinea_6 "How did we get this information?"
label values source_info_guinea_6 source_info

tab migration_guinea_6
*7366 -> 5 missing
*replace migration_guinea_6=0 if migration_guinea_6==""

label values migration_guinea_6 migration


///////////////////////////////////////////////////////////////////////////
///////////////  3.2.3 -  LEFT GUINEA  (Contact 1 Months) /////////////////
///////////////////////////////////////////////////////////////////////////

*Is the student outside of Guinea?
gen migration_guinea_1=.
*Where does the info come from?
gen source_info_guinea_1 = .

replace migration_guinea_1 = 0 if migration_conakry_1 == 0
replace source_info_guinea_1 = source_info_conakry_1 if migration_conakry_1 == 0

*replace 0 for those who live in Conakry
replace migration_guinea_1=0 if migration_conakry==0 & source_info_conakry<=1
*Info Conakry from Subject Tablet
replace source_info_guinea_6 = source_info_conakry  if source_info_conakry < 2
*NO
replace migration_guinea_1=0 if where_11_p==1 & missing(migration_guinea_1)
*YES
replace migration_guinea_1=1 if where_11_p==2 & missing(migration_guinea_1)
*Info Guinea from Subject
replace source_info_guinea_1 = 1 if missing(source_info_guinea_1)&!missing(migration_guinea_1)
*Second call with contacts.
*NO
replace migration_guinea_1=0 if where_11_contact_sec_p==1  & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2 ///
	| sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4) ///
	&  missing(migration_guinea_1)
*YES
replace migration_guinea_1=1 if where_11_contact_sec_p==2  & ///
	(sec0_q1_contact_sec_p==1  | sec0_q1_contact_sec_p==2 ///
	| sec0_q1_contact_sec_p==3  | sec0_q1_contact_sec_p==4) ///
	&  missing(migration_guinea_1)
*First call with contacts.
*NO
replace migration_guinea_1=0 if where_11_contact_p==1 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2  ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4) ///
	& missing(migration_guinea_1)
*YES
replace migration_guinea_1=1 if where_11_contact_p==2 & ///
	(sec0_q1_contact_p==1  | sec0_q1_contact_p==2  ///
	| sec0_q1_contact_p==3  | sec0_q1_contact_p==4) ///
	& missing(migration_guinea_1)
*Info Guinea from own Contacts
replace source_info_guinea_1 = 2 if missing(source_info_guinea_1)&!missing(migration_guinea_1)
*Short School Survey with Students.
*YES
replace migration_guinea_1=1 if left_guinea_sss==1 & info_source_sss != 3 & missing(migration_guinea_1)
*NO
replace migration_guinea_1=0 if left_guinea_sss==0  & info_source_sss != 3 &   missing(migration_guinea_1)
*YES
replace migration_guinea_1=1 if left_guinea_3_sss==1 & info_source_3_sss != 3 & missing(migration_guinea_1)
*NO
replace migration_guinea_1=0 if left_guinea_3_sss==0  & info_source_3_sss !=  3 & missing(migration_guinea_1)
*Info Guinea from SSS (Students)
replace source_info_guinea_1 = 3 if missing(source_info_guinea_1)&!missing(migration_guinea_1)
*SSS (Administration)
*YES
replace migration_guinea_1=1 if left_guinea_sss==1 & info_source_sss == 3 & missing(migration_guinea_1)
*NO
replace migration_guinea_1=0 if left_guinea_sss==0  & info_source_sss == 3 &   missing(migration_guinea_1)
*YES
replace migration_guinea_1=1 if left_guinea_3_sss==1 & info_source_3_sss == 3 & missing(migration_guinea_1)
*NO
replace migration_guinea_1=0 if left_guinea_3_sss==0  & info_source_3_sss ==  3 & missing(migration_guinea_1)
*Info Guinea from SSS (Administration)
replace source_info_guinea_1 = 4 if missing(source_info_guinea_1)&!missing(migration_guinea_1)
*Unstructured Surves
*YES
replace migration_guinea_1=1 if abroad_pf==1 & time == 2  & missing(migration_guinea_1)
*NO
replace migration_guinea_1=0 if abroad_pf==0 & time == 2 & missing(migration_guinea_1)
*Info Conakry from Unstructured Calls.
replace source_info_guinea_1 = 5 if missing(source_info_guinea_1)&!missing(migration_guinea_1)
*YES
replace migration_guinea_1=1 if phone_on_pf==0 & time == 2  & missing(migration_guinea_1)
*NO
replace migration_guinea_1=0 if phone_on_pf==1 & time == 2 & missing(migration_guinea_1)
*Info Conakry from Phone Status.
replace source_info_guinea_1 = 6 if missing(source_info_guinea_1)&!missing(migration_guinea_1)

label variable migration_guinea_1 "Did the student leave Guinea?"

label variable source_info_guinea_1 "How did we get this information?"
label values source_info_guinea_1 source_info

tab migration_guinea_1
*7366 -> 5 missing
*replace migration_guinea_1=0 if migration_guinea_1==""

label values migration_guinea_1 migration


gen migration_internal = migration_guinea == 0 & migration_conakry == 1 if migration_guinea != . & migration_conakry != .
la var migration_internal "Internal migration"

///////////////////////////////////////////////////////////////////////////
/////////  3.3 -  COUNTRY/CONTINENT   //////////////
///////////////////////////////////////////////////////////////////////////


* country and continent were person is
gen country = ""
replace country = mig_2_p
replace country = mig_2_contact_sec_p if country ==  ""
replace country = mig_2_contact_p if country ==  ""
replace country = current_country_sss if country ==  ""
replace country = country_pf if country ==  ""
replace country = "" if country ==  "X"
replace country = "SIERRA LEONE" if country ==  "SIERRE LEONE"
replace country = "FRANCE" if country ==  "France"
replace country = "" if country ==  "KANKAN" 
replace country = "" if country ==  "COYAH" 
replace country = "" if migration_guinea == 0

gen continent = ""
replace continent = "AFRICA" if country == "ALGERIA"
replace continent = "AFRICA" if country == "ANGOLA"
replace continent = "AFRICA" if country == "EGYPT"
replace continent = "AFRICA" if country == "EQUATORIAL GUINEA"
replace continent = "AFRICA" if country == "GAMBIA"
replace continent = "AFRICA" if country == "GHANA"
replace continent = "AFRICA" if country == "GUINEA BISSAU"
replace continent = "AFRICA" if country == "LIBERIA"
replace continent = "AFRICA" if country == "LYBIA"
replace continent = "AFRICA" if country == "MALI"
replace continent = "AFRICA" if country == "MAURITANIA"
replace continent = "AFRICA" if country == "MOROCCO"
replace continent = "AFRICA" if country == "NIGERIA"
replace continent = "AFRICA" if country == "SENEGAL"
replace continent = "AFRICA" if country == "SIERRA LEONE"
replace continent = "AFRICA" if country == "TOGO"
replace continent = "EUROPE" if country == "BELGIUM"
replace continent = "EUROPE" if country == "ENGLAND"
replace continent = "EUROPE" if country == "FRANCE"
replace continent = "EUROPE" if country == "GERMANY"
replace continent = "EUROPE" if country == "ITALY"
replace continent = "EUROPE" if country == "PORTUGAL"
replace continent = "EUROPE" if country == "SPAIN"
replace continent = "EUROPE" if country == "UNITED KINGDOM"
replace continent = "AMERICA" if country == "CANADA"
replace continent = "AMERICA" if country == "UNITED STATES"
replace country = "" if migration_guinea == 0

* index for country, to be used for maps
gen country_ind = ""
replace country_ind = "DZA" if country == "ALGERIA"
replace country_ind = "AGO" if country == "ANGOLA"
replace country_ind = "CAN" if country == "CANADA"
replace country_ind = "CIV" if country == "COTE D'IVOIRE"
replace country_ind = "EGY" if country == "EGYPT"
replace country_ind = "GBR" if country == "ENGLAND"
replace country_ind = "FRA" if country == "FRANCE"
replace country_ind = "DEU" if country == "GERMANY"
replace country_ind = "GHA" if country == "GHANA"
replace country_ind = "GNB" if country == "GUINEA BISSAU"
replace country_ind = "GMB" if country == "GAMBIA"
replace country_ind = "ITA" if country == "ITALY"
replace country_ind = "CIV" if country == "IVORY COAST"
replace country_ind = "LBN" if country == "LEBANON"
replace country_ind = "LBR" if country == "LIBERIA"
replace country_ind = "LBY" if country == "LIBYA"
replace country_ind = "MLI" if country == "MALI"
replace country_ind = "MRT" if country == "MAURITANIA"
replace country_ind = "MAR" if country == "MOROCCO"
replace country_ind = "PRT" if country == "PORTUGAL"
replace country_ind = "SEN" if country == "SENEGAL"
replace country_ind = "SLE" if country == "SIERRA LEONE"
replace country_ind = "ESP" if country == "SPAIN"
replace country_ind = "TGO" if country == "TOGO"
replace country_ind = "GBR" if country == "UNITED KINGDOM"
replace country_ind = "USA" if country == "UNITED STATES"

gen country_fin = mig_15_p
replace country_fin = mig_15_contact_sec_p if missing(country_fin)
replace country_fin = mig_15_contact_p if missing(country_fin)
replace country_fin = country if missing(country_fin)

* index for country, to be used for maps
gen country_fin_ind = ""
replace country_fin_ind = "DZA" if country_fin == "ALGERIA"
replace country_fin_ind = "AGO" if country_fin == "ANGOLA"
replace country_fin_ind = "CAN" if country_fin == "CANADA"
replace country_fin_ind = "CIV" if country_fin == "COTE D'IVOIRE"
replace country_fin_ind = "EGY" if country_fin == "EGYPT"
replace country_fin_ind = "GBR" if country_fin == "ENGLAND"
replace country_fin_ind = "FRA" if country_fin == "FRANCE"
replace country_fin_ind = "DEU" if country_fin == "GERMANY"
replace country_fin_ind = "GHA" if country_fin == "GHANA"
replace country_fin_ind = "GNB" if country_fin == "GUINEA BISSAU"
replace country_fin_ind = "ITA" if country_fin == "ITALY"
replace country_fin_ind = "CIV" if country_fin == "IVORY COAST"
replace country_fin_ind = "LBN" if country_fin == "LEBANON"
replace country_fin_ind = "LBR" if country_fin == "LIBERIA"
replace country_fin_ind = "LBY" if country_fin == "LIBYA"
replace country_fin_ind = "MLI" if country_fin == "MALI"
replace country_fin_ind = "MRT" if country_fin == "MAURITANIA"
replace country_fin_ind = "MAR" if country_fin == "MOROCCO"
replace country_fin_ind = "PRT" if country_fin == "PORTUGAL"
replace country_fin_ind = "SEN" if country_fin == "SENEGAL"
replace country_fin_ind = "SLE" if country_fin == "SIERRA LEONE"
replace country_fin_ind = "ESP" if country_fin == "SPAIN"
replace country_fin_ind = "TGO" if country_fin == "TOGO"
replace country_fin_ind = "GBR" if country_fin == "UNITED KINGDOM"
replace country_fin_ind = "USA" if country_fin == "UNITED STATES"


gen visa = .
* visa asked for people remaining in counrty where they are
replace visa =  mig_22_p
* add visa planned for people planning on another final destination
replace visa =  mig_21_p if (visa == .) 
* add visa planned for people planning on another final destination
replace visa =  mig_20_p if (visa == .) 
* visa asked for people remaining in counrty where they are
replace visa = mig_22_contact_sec_p if (visa == .) 
* add visa planned for people planning on another final destination
replace visa = mig_21_contact_sec_p if (visa == .) 
* add visa asked for people planning on another final destination
replace visa = mig_20_contact_sec_p if (visa == .) 
* visa asked for people remaining in counrty where they are
replace visa = mig_22_contact_p if (visa == .) 
* add visa planned for people planning on another final destination
replace visa = mig_21_contact_p if (visa == .)
* add visa asked for people planning on another final destination
replace visa = mig_20_contact_p if (visa == .) 

replace visa = 0 if visa == 2
la var visa "Visa asked/planned for final destination"


gen migration_novisa = (visa == 0) if migration_guinea !=.
replace migration_novisa = . if migration_guinea ==1 & visa == .

gen migration_visa = (visa == 1) if migration_guinea !=.
replace migration_visa = . if migration_guinea ==1 & visa == .

gen migration_europe = (country == "ENGLAND") if migration_guinea !=.
replace migration_europe = (country == "FRANCE") if migration_guinea !=.
replace migration_europe = (country == "GERMANY") if migration_guinea !=.
replace migration_europe = (country == "ITALY") if migration_guinea !=.
replace migration_europe = (country == "PORTUGAL") if migration_guinea !=.
replace migration_europe = (country == "SPAIN") if migration_guinea !=.
replace migration_europe = (country == "UNITED KINGDOM") if migration_guinea !=.
replace migration_europe = . if migration_guinea ==1 & visa == .


      

* auxilliary variable for irregular migration definition
gen airplane = . 
replace airplane = mig_6_p 
replace airplane = mig_6_contact_sec_p if (airplane == .) 
replace airplane = mig_6_contact_p if (airplane == .) 
replace airplane = airplane == 1 if !missing(airplane)
la var airplane "Entered in country with airplane"

gen migration_noair = (airplane == 0) if migration_guinea !=. 
replace migration_noair = . if migration_guinea ==1 & airplane == .
la var migration_noair "Migrated without airplane"

gen migration_air = (airplane == 1) if migration_guinea !=. 
replace migration_air = . if migration_guinea ==1 & airplane == .
la var migration_air "Migrated with airplane"

* adding the two conditions
gen migration_novisaair = migration_noair*migration_novisa
gen migration_visaair = (migration_guinea == 1)*(migration_novisaair == 0)


///////////////////////////////////////////////////////////////////////////
/////////  3.4 -  MIGRATION INTENTIONS   //////////////
///////////////////////////////////////////////////////////////////////////

gen desire = sec2_q1
replace desire =0 if desire == 2
label var desire "Wishing to migrate"

rename sec2_q3_1 migmot_studies
rename sec2_q3_2 migmot_econ
rename sec2_q3_3 migmot_reunif
* bug in original data, one observation assigned to 3
replace migmot_reunif = 0 if migmot_reunif == 3
rename sec2_q3_4 migmot_conflict
rename sec2_q3_5 migmot_pers
rename sec2_q3_6 migmot_climate

gen planning = 2 if desire == 0
replace planning = sec2_q4 if planning == .
replace planning = 0 if planning == 2
label var planning "Planning to migrate"

gen prepare = 2 if planning == 0
replace prepare = sec2_q7 if prepare == .
replace prepare = 0 if prepare == 2
label var prepare "Preparing to migrate"


gen wish_cont_africa = 0 if !missing(desire)
replace wish_cont_africa = 1 if sec2_q2 == "AFRICA"
replace wish_cont_africa = 1 if sec2_q2 == "ALGERIA"
replace wish_cont_africa = 1 if sec2_q2 == "ANGOLA"
replace wish_cont_africa = 1 if sec2_q2 == "BURKINA FASO"
replace wish_cont_africa = 1 if sec2_q2 == "EGYPT"
replace wish_cont_africa = 1 if sec2_q2 == "ETHIOPIA"
replace wish_cont_africa = 1 if sec2_q2 == "GABON"
replace wish_cont_africa = 1 if sec2_q2 == "GHANA"
replace wish_cont_africa = 1 if sec2_q2 == "IVORY COAST"
replace wish_cont_africa = 1 if sec2_q2 == "MALI"
replace wish_cont_africa = 1 if sec2_q2 == "MOROCCO"
replace wish_cont_africa = 1 if sec2_q2 == "IVORY COAST"
replace wish_cont_africa = 1 if sec2_q2 == "NIGERIA"
replace wish_cont_africa = 1 if sec2_q2 == "SENEGAL"


gen wish_cont_europe = 0 if !missing(desire)
replace wish_cont_europe = 1 if sec2_q2 == "AUSTRIA"
replace wish_cont_europe = 1 if sec2_q2 == "BELGIUM"
replace wish_cont_europe = 1 if sec2_q2 == "ENGLAND"
replace wish_cont_europe = 1 if sec2_q2 == "EUROPE"
replace wish_cont_europe = 1 if sec2_q2 == "FRANCE"
replace wish_cont_europe = 1 if sec2_q2 == "GERMANY"
replace wish_cont_europe = 1 if sec2_q2 == "GREECE"
replace wish_cont_europe = 1 if sec2_q2 == "ICELAND"
replace wish_cont_europe = 1 if sec2_q2 == "ITALY"
replace wish_cont_europe = 1 if sec2_q2 == "NETHERLANDS"
replace wish_cont_europe = 1 if sec2_q2 == "NORWAY"
replace wish_cont_europe = 1 if sec2_q2 == "POLAND"
replace wish_cont_europe = 1 if sec2_q2 == "PORTUGAL"
replace wish_cont_europe = 1 if sec2_q2 == "SPAIN"
replace wish_cont_europe = 1 if sec2_q2 == "SWEDEN"
replace wish_cont_europe = 1 if sec2_q2 == "SWITZERLAND"
replace wish_cont_europe = 1 if sec2_q2 == "UNITED KINGDOM"



gen plan_cont_africa = 0 if !missing(planning)		 
replace plan_cont_africa = 1 if sec2_q5 == "AFRICA"
replace plan_cont_africa = 1 if sec2_q5 == "ALGERIA"
replace plan_cont_africa = 1 if sec2_q5 == "ANGOLA"
replace plan_cont_africa = 1 if sec2_q5 == "EGYPT"
replace plan_cont_africa = 1 if sec2_q5 == "ETHIOPIA"
replace plan_cont_africa = 1 if sec2_q5 == "GABON"
replace plan_cont_africa = 1 if sec2_q5 == "GAMBIA"
replace plan_cont_africa = 1 if sec2_q5 == "GHANA"
replace plan_cont_africa = 1 if sec2_q5 == "IVORY COAST"
replace plan_cont_africa = 1 if sec2_q5 == "MOROCCO"
replace plan_cont_africa = 1 if sec2_q5 == "MAURITANIA"
replace plan_cont_africa = 1 if sec2_q5 == "LIBERIA"
replace plan_cont_africa = 1 if sec2_q5 == "LIBYA"
replace plan_cont_africa = 1 if sec2_q5 == "NIGERIA"
replace plan_cont_africa = 1 if sec2_q5 == "SENEGAL"
replace plan_cont_africa = 1 if sec2_q5 == "TUNISIA"
								  
gen plan_cont_europe = 0 if !missing(planning)		 
replace plan_cont_europe = 1 if sec2_q5 == "AUSTRIA"
replace plan_cont_europe = 1 if sec2_q5 == "BELGIUM"
replace plan_cont_europe = 1 if sec2_q5 == "ENGLAND"
replace plan_cont_europe = 1 if sec2_q5 == "EUROPE"
replace plan_cont_europe = 1 if sec2_q5 == "FRANCE"
replace plan_cont_europe = 1 if sec2_q5 == "GERMANY"
replace plan_cont_europe = 1 if sec2_q5 == "GREECE"
replace plan_cont_europe = 1 if sec2_q5 == "ITALY"
replace plan_cont_europe = 1 if sec2_q5 == "NETHERLANDS"
replace plan_cont_europe = 1 if sec2_q5 == "NORWAY"
replace plan_cont_europe = 1 if sec2_q5 == "POLAND"
replace plan_cont_europe = 1 if sec2_q5 == "PORTUGAL"
replace plan_cont_europe = 1 if sec2_q5 == "SPAIN"
replace plan_cont_europe = 1 if sec2_q5 == "SWEDEN"
replace plan_cont_europe = 1 if sec2_q5 == "SWITZERLAND"
replace plan_cont_europe = 1 if sec2_q5 == "UNITED KINGDOM"
replace plan_cont_europe = 1 if sec2_q5 == "UNITED STATES"


gen askedvisa 		=  sec2_q10_a == 1 if !missing(sec2_q10_a)
gen planvisa 		=  sec2_q10_c == 1 if !missing(sec2_q10_c)
replace planvisa 	= 1 if askedvisa == 1
gen desvisa 		=  sec2_q10_b == 1 if !missing(sec2_q10_b)
replace desvisa       = planvisa if missing(desvisa)

replace planvisa = 0 if planning == 0
replace desvisa = 0 if desire == 0
replace askedvisa = 0 if prepare == 0

///////////////////////////////////////////////////////////////////////////
//////////////////////   4 - ATTRITION VARIABLES     //////////////////////
///////////////////////////////////////////////////////////////////////////

tsset id_number time 

duplicates tag id_number, generate(duplic)

xtset id_number time

* first follow up
gen no_1_1 = missing(f1.time) & time == 0

* second follow up
* no tablet
gen no_1_2 = source_info_guinea > 0 | missing(source_info_guinea)
* no phone subject
gen no_2_2 = source_info_guinea > 1 | missing(source_info_guinea)
* np phone contact
gen no_3_2 = source_info_guinea > 2 | missing(source_info_guinea)
* no sss
gen no_4_2 = source_info_guinea > 4 | missing(source_info_guinea)
* no unstructured surveys
gen no_5_2 = source_info_guinea > 5 | missing(source_info_guinea)
* no phone status
gen no_6_2 = source_info_guinea > 6 | missing(source_info_guinea)

* refer to time 0 in panel structure
replace no_1_2 = f2.no_1_2
replace no_2_2 = f2.no_2_2
replace no_3_2 = f2.no_3_2
replace no_4_2 = f2.no_4_2
replace no_5_2 = f2.no_5_2
replace no_6_2 = f2.no_6_2

* record sensibilization
gen sensibilized = participation == 1
local change 10400



///////////////////////////////////////////////////////////////////////////
////////////////////   5 - SOCIO-ECONOMIC CONTROLS     ////////////////////
///////////////////////////////////////////////////////////////////////////


* change coding for parents alive
rename sec1_2 moth_alive
replace moth_alive = 0 if moth_alive == 2
la var moth_alive "Mother alive"
label values moth_alive yesno

rename sec1_9 fath_alive
la var fath_alive "Father alive"
replace fath_alive = 0 if fath_alive == 2
label values fath_alive yesno

* label where are parents
rename sec1_3_bis moth_where
la var moth_where "Where is mother"
la define moth_where 1 "Moth. in Conakry" 2 "Moth. els. in Guinea" ///
	3 "Moth. els. in Africa" 4 "Moth. not in Africa" 5 "Moth. not Alive"
la val moth_where moth_where	

rename sec1_10_bis fath_where
la var fath_where "Where is father"
la define fath_where 1 "Fath. in Conakry" 2 "Fath. els. in Guinea" ///
	3 "Fath. els. in Africa" 4 "Fath. not in Africa" 5 "Fath. not Alive"
la val fath_where fath_where


* define a variable for mother ever attendedschool
gen moth_school = .
replace moth_school = 1 if sec1_5 == 1
replace moth_school = 0 if sec1_5 == 2
label var moth_school "Mother attended school"

* define a variable for father ever attended school
gen fath_school = .
replace fath_school = 1 if sec1_12 == 1
replace fath_school = 0 if sec1_12 == 2
label var fath_school "Father attended school"

* label parents eduction
rename sec1_6 moth_educ
la var moth_educ "Mother's education"
* merge preschool and elementary
replace moth_educ = 1 if moth_educ == 0
la define education_nopres 1 "Primary school" 2 "Secondary school or higher" ///
	99 "Don't know" 999 "No education"
la values moth_educ education_nopres
	
rename sec1_13 fath_educ
la var fath_educ "Father's education"
* merge preschool and elementary
replace fath_educ = 1 if fath_educ == 0
la values fath_educ education_nopres

*generate education dummies for balance
tab moth_educ, gen(moth_educ)
tab fath_educ, gen(fath_educ)

la var fath_educ1 "Father completed primary school"
la var fath_educ2 "Father completed secondary school"
la var fath_educ3 "Father completed higher education"
la var fath_educ4 "Father completed don't know"
la var fath_educ5 "Father no education"

la var moth_educ1 "Mother completed primary school"
la var moth_educ2 "Mother completed secondary school"
la var moth_educ3 "Mother completed higher education"
la var moth_educ4 "Mother completed don't know"
la var moth_educ5 "Mother no education"


gen fath_educ_red = fath_educ
* merge secondary school and higher
replace fath_educ_red = 2 if fath_educ_red == 3

gen moth_educ_red = moth_educ
* merge secondary school and higher
replace moth_educ_red = 2 if moth_educ_red == 3

*generate education dummies for balance
tab moth_educ_red, gen(moth_educ_red)
tab fath_educ_red, gen(fath_educ_red)

la var fath_educ_red1 "Father completed primary school"
la var fath_educ_red2 "Father completed secondary school or higher"
la var fath_educ_red3 "Father completed don't know"
la var fath_educ_red4 "Father no education"

la var moth_educ_red1 "Mother completed primary school"
la var moth_educ_red2 "Mother completed secondary school or higher"
la var moth_educ_red3 "Mother completed don't know"
la var moth_educ_red4 "Mother no education"

* parents working
* bundle values for deceased parents into no occupation
rename sec1_7 moth_working
replace moth_working = 0 if moth_working == 2
la val moth_working yesno
la var moth_working "Mother worked in the last 12 months"

rename sec1_14 fath_working
replace fath_working = 0 if fath_working == 2
la val fath_working yesno
la var fath_working "Father worked in the last 12 months"

* parents' occuptaion
* bundle values for deceased parents into no occupation
rename sec1_8_bis moth_occupation
la var moth_occupation "Mother's occupation"

rename sec1_15 fath_occupation
la var fath_occupation "Father's occupation"

* where the student was born
rename sec0_q7 where_born
la var where_born "Where born"
la define where_born 1 "Born Conakry" 2 "Born Oth . Guinea" ///
	3 "Born Oth . Africa" 4 "Born not Africa"
la val where_born where_born

tab where_born, gen(where_born)

la var where_born1 "Born Conakry"
la var where_born2 "Born Oth . Guinea"
la var where_born3 "Born Oth . Africa"
la var where_born4 "Born not Africa"

* winsorize contact numbers to exclude irrealistic instances
gen contacts_winsor = outside_contact_no
qui sum contacts_winsor if time == 0, detail
replace contacts_winsor = `r(p99)' if contacts_winsor > `r(p99)' &	!missing(contacts_winsor)	
label var contacts_winsor "\# contacts abroad"
gen contacts_abroad = outside_contact_no > 0 if !missing(outside_contact_no)
la var contacts_abroad "Any contacts abroad, dummy"

* label gender variable
la define female 0 "Male St." 1 "Female St."
la val female female

* generate age from birthday
gen age=(starttime_date-sec0_q3)/365.25
label variable age "Student's age (clean)"
* dropping irrealistic age instances (winsorizing doesn't make sense here)
* since it seems the question was simply misinterpreted for low numbers
* (date close to the date of the survey) or avoided for high instnaces
replace age=. if age<=10 | age >30



* family size
gen family_size=no_family_member
* set to missing for instances were students did not want to answer or they
* inserted the phone number of the family
replace family_size=. if family_size >= 999
qui sum no_family_member if time == 0, de
* winsorize to deal with outliers
replace no_family_member=`r(p99)' if no_family_member > `r(p99)' & !missing(no_family_member)
label var no_family_member "Family members (clean)"

*ethnicity
gen ethnicity=.
replace ethnicity=1 if sec0_q11==3
replace ethnicity=2 if sec0_q11==1
replace ethnicity=3 if sec0_q11==2
replace ethnicity=4 if sec0_q11!=1 & sec0_q11!=2 & sec0_q11!=3

* generating 3 dummies for the three mainlanguage
gen pular_language=.
replace pular_language=1 if sec0_q11==3
replace pular_language=0 if sec0_q11!=3 & !missing(sec0_q11==3)

gen sousou_language=.
replace sousou_language=1 if sec0_q11==1
replace sousou_language=0 if sec0_q11!=1 & !missing(sec0_q11==1)

gen malinke_language=.
replace malinke_language=1 if sec0_q11==2
replace malinke_language=0 if sec0_q11!=2 & !missing(sec0_q11==2)

la define languages 1 "Sousou" 2 "Malinke" 3 "Pular" 4 "Kpele" 5 "Kissi" 6 "Loma" 7 "Baga" /// 
	8 "Coniagui" 9 "Other Guinean" 10 "Other" 11 "Only French"
la val sec0_q11 languages
gen language_red = sec0_q11
replace language_red = 4 if language_red > 3
la define languages_red 1 "Sousou" 2 "Malinke" 3 "Pular" 4 "Other Language"
la val language_red languages_red
la var language_red "Language with Family"

* classmates migration
rename sec9_q2 mig_classmates
label var mig_classmates "\# classmates who migrated"

* old age
gen high_age = classe_baseline > 5 & !missing(classe_baseline)
la var high_age "More than 11th Class (Bl.)"

* gen grade dummies for balance
tab classe_baseline, gen(grade)
la var grade6 "Student in \(12^{th}\) grade"
la var grade7 "Student in \(13^{th}\) grade"

gen sister_no_win = sister_no if time == 0
qui sum sister_no_win if !missing(sister_no_win), detail
replace sister_no_win = `r(p99)' if sister_no_win > `r(p99)' & !missing(sister_no_win)
la var sister_no_win "\# sisters"

gen brother_no_win = brother_no if time == 0
qui sum brother_no_win if !missing(brother_no_win), detail
replace brother_no_win = `r(p99)' if brother_no_win > `r(p99)' & !missing(brother_no_win)
la var brother_no_win "\# brothers"



///////////////////////////////////////////////////////////////////////////
///////////////////////   6 - MIGRATION BELIEFS     ///////////////////////
///////////////////////////////////////////////////////////////////////////



* dummy for knowledge about spanish route
gen spain_someknow = .
replace spain_someknow = 1 if spain_awareness != 5 & !missing(spain_awareness)
replace spain_someknow = 0 if spain_awareness == 5 & !missing(spain_awareness)
la var spain_someknow "Some knowledge about Spanish route"
la val spain_someknow yesno

* dummy for knowledge about italian route
gen italy_someknow = .
replace italy_someknow = 1 if italy_awareness != 5 & !missing(italy_awareness)
replace italy_someknow = 0 if italy_awareness == 5 & !missing(italy_awareness)
la var italy_someknow "Some knowledge about Italian route"
la val italy_someknow yesno

*clean variable for route selection (question with 2 possible routes)
rename sec3_22 route_chosen
replace route_chosen = 0 if route_chosen == 2
la var route_chosen "Hypothetical route choice"
label define route_chosen 1 "Route through Italy" 0 "Route through Spain"
label values route_chosen route_chosen

*generating dummy for route selection (question with 3 possible routes)
gen it_route_3=.
replace it_route_3=1 if road_selection==1
replace it_route_3=0 if road_selection!=1 & !missing(road_selection)
la  var it_route_3 "Italian route chosen"

gen sp_route_3=.
replace sp_route_3=1 if road_selection==2
replace sp_route_3=0 if road_selection!=2 & !missing(road_selection)
la  var sp_route_3 "Spanish route chosen"
		
*journey_cost
	local cost "italy_journey_cost spain_journey_cost"
	foreach var of local cost {
	replace `var'=. if `var'<0
	}

*journey_duration
local duration "italy_duration spain_duration"
foreach var of local duration {
replace `var'=. if `var'<0

}

* label risk var
label var italy_forced_work "Being forced to work"
label var spain_forced_work "Being forced to work"

label var italy_kidnapped "Being held"
label var spain_kidnapped "Being held"

label var italy_sent_back "Being sent back"
label var spain_sent_back "Being sent back"

label var italy_beaten "Being beaten"
label var spain_beaten "Being beaten"

label var italy_die_boat "Death in boat"
label var spain_die_boat "Death in boat"

label var italy_die_bef_boat "Death before boat"
label var spain_die_bef_boat "Death before boat"


*employment
* deal with probabiliy questions with answer > 100
replace sec3_32=. if sec3_32 > 100
replace sec3_35 = . if sec3_35 > 100
replace sec3_41 = . if sec3_41 > 100

* rename and label economic perception variables
rename sec3_32 finding_job
label var finding_job "Finding a job"
rename sec3_36 becoming_citizen
label var becoming_citizen "Becoming citizen"
rename sec3_35 continuing_studies
label var continuing_studies " Continuing studies"
rename sec3_37 return_5yr
gen not_return_5yr = 100 - return_5yr
label var return_5yr "Having returned after 5yrs"
label var return_5yr "Not having returned after 5yrs"
rename sec3_39 government_financial_help
label var government_financial_help "Receiving financial help"
rename sec3_40 asylum
label var asylum "Getting asylum, if requested"
rename sec3_41 in_favor_of_migration
label var in_favor_of_migration "\% in favor of migr. at destin."

*replace outside_contact_no=. if outside_contact_no>1000

local euro_fg = 10400

* correct for different ways to express prices in Guinean Francs
gen sec3_42_corrected = sec3_42
replace sec3_42_corrected = sec3_42_corrected*1000000 if sec3_42_corrected < 999
replace sec3_42_corrected = sec3_42_corrected*1000 if sec3_42_corrected < 999999

* transform in Euros
gen expected_wage = expectation_wage/`euro_fg'
gen expected_living_cost = sec3_42_corrected/`euro_fg'

* winsorize and take asinh of perceptions on wage and costs of living
global winsor = "expectation_wage expected_living_cost"

foreach y in $winsor {
	gen `y'_winsor = `y'
	qui sum `y', detail
	replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)' & !missing(`y'_winsor)
	replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)' & !missing(`y'_winsor)
	gen asinh`y'_winsor = asinh(`y'_winsor)
}

rename asinhexpected_living_cost_winsor asinhexp_liv_cost_winsor

* renme family revenue
rename sec8_q6 family_revenue

* winsorize and take asinh of journey cost and duration
global winsor = "`route'_duration `route'_journey_cost"

global routes_list = "Italy Spain"

foreach route_u in $routes_list {

	local route = lower("`route_u'")

	global winsor = "`route'_duration `route'_journey_cost"

	foreach y in $winsor {
		gen `y'_winsor = `y'
		qui sum `y', detail
		replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)' & !missing(`y'_winsor)
		replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)' & !missing(`y'_winsor)
		gen asinh`y'_winsor = asinh(`y'_winsor)
	}

}

label var asinhexpectation_wage_winsor "Expected wage at dest."
label var asinhexp_liv_cost_winsor "Expected liv. cost at dest."

label var asinhitaly_duration_winsor "Duration of the journey"
label var asinhspain_duration_winsor "Duration of the journey"

label var asinhitaly_journey_cost_winsor "Cost of the journey"
label var asinhspain_journey_cost_winsor "Cost of the journey"

** kling and pca indeces

global routes "italy spain"

foreach route in $routes {
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
						+ " asinh`route'_journey_cost_winsor  " ///
						+ " `route'_beaten " ///
						+ " `route'_forced_work " ///
						+ " `route'_kidnapped " ///
						+ " `route'_die_bef_boat " ///
						+ " `route'_die_boat " ///
						+ " `route'_sent_back "
	
	local n_outcomes `: word count $`route'_outcomes'
	
	gen `route'_kling_poscost = 0
	
	local n_kling = 1
	

	foreach y in $`route'_outcomes {
		qui sum `y' if time == 0, detail
		replace `route'_kling_poscost =  `route'_kling_poscost + (1/`n_outcomes')*(`y' - `r(mean)')/`r(sd)'
		local `n_kling' = `n_kling' + 1
		}
		
	
	*positive to negative
	replace asinh`route'_journey_cost_winsor = -asinh`route'_journey_cost_winsor	
	
	gen `route'_kling_negcost = 0
	
	local n_kling = 1
	
	foreach y in $`route'_outcomes {
			qui sum `y' if time == 0, detail
			replace `route'_kling_negcost =  `route'_kling_negcost + (1/`n_outcomes')*(`y' - `r(mean)')/`r(sd)'
		local `n_kling' = `n_kling' + 1
		}
	
	*negative to positive
	replace asinh`route'_journey_cost_winsor = -asinh`route'_journey_cost_winsor
		
	
	* create pca
	qui pca $`route'_outcomes if time == 0, factor(1)
	predict `route'_index
}
	
	
la var italy_kling_negcost "Risk beliefs index for Italy \citep{kling2007experimental}"
la var spain_kling_negcost "Risk beliefs index for Spain \citep{kling2007experimental}"
la var italy_kling_poscost "Risk index Italy \citep{kling2007experimental}, pos. cost"
la var spain_kling_poscost "Risk index Spain \citep{kling2007experimental}, pos. cost"


qui sum italy_index if time == 0, detail
gen italy_index50 = italy_index >= `r(p50)' if !missing(italy_index)
la var italy_index50 "Pessimistic risk beliefs"
la var italy_index "Risk index Italy"
la var spain_index "Risk index Spain"

foreach route in $routes {
	global `route'_outcomes_nocost = "asinh`route'_duration_winsor " ///
						+ " `route'_beaten " ///
						+ " `route'_forced_work " ///
						+ " `route'_kidnapped " ///
						+ " `route'_die_bef_boat " ///
						+ " `route'_die_boat " ///
						+ " `route'_sent_back "
	
	local n_outcomes_nocost `: word count $`route'_outcomes_nocost'
	
	gen `route'_kling_nocost = 0
	
	local n_kling = 1
	

	foreach y in $`route'_outcomes_nocost {
		qui sum `y' if time == 0, detail
		replace `route'_kling_nocost =  `route'_kling_nocost + (1/`n_outcomes_nocost')*(`y' - `r(mean)')/`r(sd)'
		local `n_kling' = `n_kling' + 1
		}
		
	
	* create pca
	qui pca $`route'_outcomes_nocost if time == 0, factor(1)
	predict `route'_index_nocost
}

la var italy_kling_nocost "Risk beliefs index for Italy \citep{kling2007experimental}, no cost"
la var spain_kling_nocost "Risk beliefs index for Spain \citep{kling2007experimental}, no cost "
la var italy_index_nocost "PCA aggregator of risk outcomes, no cost, Italy"
la var spain_index_nocost "PCA aggregator of risk outcomes, no cost, Spain"

global risk_info_var "italy_beaten italy_forced_work italy_duration"
global risk_info_given "70 90 6"
local counter 0
gen italy_pessimistic = 0
foreach var in $risk_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $risk_info_given'
	replace italy_pessimistic = italy_pessimistic + (`var' > `info') - (`var' < `info')
}
replace italy_pessimistic = italy_pessimistic > 0 
replace italy_pessimistic = . if missing(italy_beaten)|missing(italy_forced_work)|missing(italy_duration)

local counter 0
gen italy_optimistic = 0
foreach var in $risk_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $risk_info_given'
	replace italy_optimistic = italy_optimistic + (`var' <= `info') - (`var' > `info')
}
replace italy_optimistic = italy_optimistic > 0 
replace italy_optimistic = . if missing(italy_beaten)|missing(italy_forced_work)|missing(italy_duration)
la var italy_optimistic "Optimistic risk beliefs"

local counter 0
gen italy_optimistic1 = 0
foreach var in $econ_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $econ_info_given'
	replace italy_optimistic1 = italy_optimistic1 + (`var' <= `info') - (`var' > `info')
}
replace italy_optimistic1 = italy_optimistic1 > -3
replace italy_optimistic1 = . if missing(finding_job)|missing(continuing_studies)|missing(asylum)
la var italy_optimistic1 "Optimistic econ beliefs (1)"

local counter 0
gen italy_optimistic3 = 0
foreach var in $econ_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $econ_info_given'
	replace italy_optimistic3 = italy_optimistic3 + (`var' <= `info') - (`var' >`info')
}
replace italy_optimistic3 = italy_optimistic3 > 2
replace italy_optimistic3 = . if missing(finding_job)|missing(continuing_studies)|missing(asylum)
la var italy_optimistic3 "Optimistic econ beliefs (3)"







global rinfosession_var "partb_q1 partb_q8 partb_q9 partb_q3"
global risk_info_given "3 7 5"
local counter 0
gen riskinfo_attention = 0
foreach var in $rinfosession_var {
	if "`var'" == "partb_q3" {
		replace riskinfo_attention = riskinfo_attention + (`var' == "1") * (l.treatment_status == 2) + (`var' == "1 2") * (l.treatment_status == 4)
	}
	else {
		local counter = `counter' + 1 
		local info `:word `counter' of $risk_info_given'
		replace riskinfo_attention = riskinfo_attention + (`var' == `info')
	}
}
replace riskinfo_attention = . if missing(partb_q1)|missing(partb_q8)|missing(partb_q9)|missing(partb_q3)



global econinfosession_var "partb_q1 partb_q5 partb_q6 partb_q3"
global econ_info_given "3 8 7"
local counter 0
gen econinfo_attention = 0
foreach var in $econinfosession_var {
	if "`var'" == "partb_q3" {
		replace econinfo_attention = econinfo_attention + (`var' == "2") * (l.treatment_status == 2) + (`var' == "1 2") * (l.treatment_status == 4)
	}
	else {
		local counter = `counter' + 1 
		local info `:word `counter' of $econ_info_given'
		replace econinfo_attention = econinfo_attention + (`var' == `info')
	}
}
replace econinfo_attention = . if missing(partb_q1)|missing(partb_q8)|missing(partb_q9)|missing(partb_q3)






global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " 
						
local n_outcomes `: word count $economic_outcomes'

gen economic_kling = 0

local n_kling = 1

replace return_5yr = -return_5yr
foreach y in $economic_outcomes {
	qui sum `y' if time == 0, detail
	replace economic_kling =  economic_kling - (1/`n_outcomes')*(`y' - `r(mean)')/`r(sd)'
	local `n_kling' = `n_kling' + 1
	}
replace return_5yr =-return_5yr

la var economic_kling "Kling Econ Index"

		
		
qui pca $economic_outcomes if time == 0, factor(1)
predict economic_index
la var economic_index "Economic Index"

qui sum economic_index if time == 0, detail
gen economic_index50 = economic_index < `r(p50)' if !missing(economic_index)
la var economic_index50 "Pessimistic econ beliefs"

global econ_info_var "finding_job continuing_studies asylum"
global econ_info_given "20 30 20"
local counter 0
gen econ_pessimistic = 0
foreach var in $econ_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $econ_info_given'
	replace econ_pessimistic = econ_pessimistic + (`var' < `info') - (`var' > `info')
}
replace econ_pessimistic = econ_pessimistic > 0
replace econ_pessimistic = . if missing(finding_job)|missing(continuing_studies)|missing(asylum)

local counter 0
gen econ_optimistic = 0
foreach var in $econ_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $econ_info_given'
	replace econ_optimistic = econ_optimistic + (`var' >= `info') - (`var' < `info')
}
replace econ_optimistic = econ_optimistic > 0
replace econ_optimistic = . if missing(finding_job)|missing(continuing_studies)|missing(asylum)
la var econ_optimistic "Optimistic econ beliefs"

local counter 0
gen econ_optimistic1 = 0
foreach var in $econ_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $econ_info_given'
	replace econ_optimistic1 = econ_optimistic1 + (`var' >= `info') - (`var' < `info')
}
replace econ_optimistic1 = econ_optimistic1 > -3
replace econ_optimistic1 = . if missing(finding_job)|missing(continuing_studies)|missing(asylum)
la var econ_optimistic1 "Optimistic econ beliefs (1)"

local counter 0
gen econ_optimistic3 = 0
foreach var in $econ_info_var {
	local counter = `counter' + 1 
	local info `:word `counter' of $econ_info_given'
	replace econ_optimistic3 = econ_optimistic3 + (`var' >= `info') - (`var' < `info')
}
replace econ_optimistic3 = econ_optimistic3 > 2
replace econ_optimistic3 = . if missing(finding_job)|missing(continuing_studies)|missing(asylum)
la var econ_optimistic3 "Optimistic econ beliefs (3)"


gen pessimistic = .
replace pessimistic = 0 if treatment_status == 1
replace pessimistic = italy_pessimistic if treatment_status == 2
replace pessimistic = econ_pessimistic if treatment_status == 3
replace pessimistic = (italy_pessimistic == 1)&(econ_pessimistic == 1) if treatment_status == 4 
la var pessimistic "Pessimistic beliefs at baseline"

gen pessimistic_weak = .
replace pessimistic_weak = 0 if treatment_status == 1
replace pessimistic_weak = italy_pessimistic if treatment_status == 2
replace pessimistic_weak = econ_pessimistic if treatment_status == 3
replace pessimistic_weak = (italy_pessimistic == 1)|(econ_pessimistic == 1) if treatment_status == 4 & italy_pessimistic != . & econ_pessimistic != .
la var pessimistic_weak "Pessimistic beliefs at baseline"

gen optimistic = .
replace optimistic = 0 if treatment_status == 1
replace optimistic = italy_optimistic if treatment_status == 2
replace optimistic = econ_optimistic if treatment_status == 3
replace optimistic = (italy_optimistic == 1)|(econ_optimistic == 1) if treatment_status == 4 
la var optimistic "Optimistic beliefs at baseline"

gen optimistic_strong = .
replace optimistic_strong = 0 if treatment_status == 1
replace optimistic_strong = italy_optimistic if treatment_status == 2
replace optimistic_strong = econ_optimistic if treatment_status == 3
replace optimistic_strong = (italy_optimistic == 1)&(econ_optimistic == 1) if treatment_status == 4 & italy_optimistic != . & econ_optimistic != .
la var optimistic_strong "Optimisitic beliefs at baseline"

gen optimistic1 = .
replace optimistic1 = 0 if treatment_status == 1
replace optimistic1 = italy_optimistic1 if treatment_status == 2
replace optimistic1 = econ_optimistic1 if treatment_status == 3
replace optimistic1 = (italy_optimistic1 == 1)|(econ_optimistic1 == 1) if treatment_status == 4 
la var optimistic1 "Optimistic beliefs at baseline"

gen optimistic3 = .
replace optimistic3 = 0 if treatment_status == 1
replace optimistic3 = italy_optimistic3 if treatment_status == 2
replace optimistic3 = econ_optimistic3 if treatment_status == 3
replace optimistic3 = (italy_optimistic3 == 1)|(econ_optimistic3 == 1) if treatment_status == 4 
la var optimistic3 "Optimistic beliefs at baseline"

global economic_outcomes $economic_outcomes  `" economic_index "'
global economic_outcomes $economic_outcomes  `" economic_kling "'

* rename desired countries out of list
gen desired_country = ""
replace desired_country = "DZA" if sec3_21 == "ALGERIA"
replace desired_country = "AUS" if sec3_21 == "AUSTRALIA"
replace desired_country = "AUT" if sec3_21 == "AUSTRIA"
replace desired_country = "BEL" if sec3_21 == "BELGIUM"
replace desired_country = "" if sec3_21 == "DON'T KNOW"
replace desired_country = "EGY" if sec3_21 == "EGYPT"
replace desired_country = "GBR" if sec3_21 == "ENGLAND"
replace desired_country = "" if sec3_21 == "EUROPE"
replace desired_country = "FRA" if sec3_21 == "FRANCE"
replace desired_country = "DEU" if sec3_21 == "GERMANY"
replace desired_country = "ISL" if sec3_21 == "ICELAND"
replace desired_country = "IND" if sec3_21 == "INDIA"
replace desired_country = "IRL" if sec3_21 == "IRELAND"
replace desired_country = "ITA" if sec3_21 == "ITALY"
replace desired_country = "MAR" if sec3_21 == "MOROCCO"
replace desired_country = "NLD" if sec3_21 == "NETHERLANDS"
replace desired_country = "" if sec3_21 == "OCEANIA"
replace desired_country = "POL" if sec3_21 == "POLAND"
replace desired_country = "PRT" if sec3_21 == "PORTUGAL"
replace desired_country = "RUS" if sec3_21 == "RUSSIA"
replace desired_country = "SAU" if sec3_21 == "SAUDI ARABIA"
replace desired_country = "SEN" if sec3_21 == "SENEGAL"
replace desired_country = "ESP" if sec3_21 == "SPAIN"
replace desired_country = "SWE" if sec3_21 == "SWEDEN"
replace desired_country = "CHE" if sec3_21 == "SWITZERLAND"
replace desired_country = "CZE" if sec3_21 == "TCHèQUE"
replace desired_country = "TUR" if sec3_21 == "TURKEY"
replace desired_country = "ARE" if sec3_21 == "UNITED ARAB EMIRATES"
replace desired_country = "USA" if sec3_21 == "UNITED STATES"

rename desired_country desired_country_str
encode desired_country_str, gen(desired_country)



*************CONTACTS AND DISCUSSING MIGRATION***************


gen discuss_mig = sec2_q11 == 1 if !missing(sec2_q11)
replace discuss_mig = 1 if sec2_q11_p == 1
replace discuss_mig = 0 if sec2_q11_p == 2
la var discuss_mig "Discussed migr. over last week w/ friends/siblings"

gen discuss_migoth = sec2_q12 == 1 if !missing(sec2_q12)
la var discuss_migoth "Discussed migr. over last week w/ stud. of other schools"

gen discuss_wage_contact1 = sec10_q11_1 == 1 if !missing(sec10_q11_1)
gen discuss_job_contact1 = sec10_q12_1 == 1 if !missing(sec10_q12_1)
gen discuss_benef_contact1 = sec10_q13_1 == 1 if !missing(sec10_q13_1)
gen discuss_trip_contact1 = sec10_q14_1 == 1 if !missing(sec10_q14_1)
gen discuss_fins_contact1 = sec10_q15_1 == 1 if !missing(sec10_q15_1)

gen discuss_wage_contact2 = sec10_q11_2 == 1 if !missing(sec10_q11_2)
gen discuss_job_contact2 = sec10_q12_2 == 1 if !missing(sec10_q12_2)
gen discuss_benef_contact2 = sec10_q13_2 == 1 if !missing(sec10_q13_2)
gen discuss_trip_contact2 = sec10_q14_2 == 1 if !missing(sec10_q14_2)
gen discuss_fins_contact2 = sec10_q15_2 == 1 if !missing(sec10_q15_2)

gen discuss_wage_contact = discuss_wage_contact1 == 1 if !missing(discuss_wage_contact1)
replace discuss_wage_contact = 1 if discuss_wage_contact2 == 1
gen discuss_job_contact = discuss_job_contact1 == 1 if !missing(discuss_job_contact1)
replace discuss_job_contact = 1 if discuss_job_contact2 == 1
gen discuss_benef_contact = discuss_benef_contact1 == 1 if !missing(discuss_benef_contact1)
replace discuss_benef_contact = 1 if discuss_benef_contact2 == 1
gen discuss_trip_contact = discuss_trip_contact1 == 1 if !missing(discuss_trip_contact1)
replace discuss_trip_contact = 1 if discuss_trip_contact2 == 1
gen discuss_fins_contact = discuss_fins_contact1 == 1 if !missing(discuss_fins_contact1)
replace discuss_fins_contact = 1 if discuss_fins_contact2 == 1

replace discuss_wage_contact = 0 if contacts_abroad == 0
replace discuss_job_contact = 0 if contacts_abroad == 0 
replace discuss_benef_contact = 0 if contacts_abroad == 0 
replace discuss_trip_contact = 0 if contacts_abroad == 0 
replace discuss_fins_contact = 0 if contacts_abroad == 0 

gen discuss_econ_contact = (discuss_wage_contact == 1 | ///
	discuss_job_contact == 1 | discuss_benef_contact == 1 /// 
	| discuss_fins_contact == 1) if !missing(discuss_wage_contact) & ///
	!missing(discuss_job_contact) & !missing(discuss_benef_contact) & ///
	!missing(discuss_fins_contact)

gen discuss_risk_contact = discuss_trip_contact

gen discuss_riskecon_contact = (discuss_risk_contact == 1) & (discuss_econ_contact == 1) if !missing(discuss_risk_contact) & !missing(discuss_econ_contact)

gen discuss_riskorecon_contact = (discuss_risk_contact == 1) | (discuss_econ_contact == 1) if !missing(discuss_risk_contact) & !missing(discuss_econ_contact)

la var discuss_risk_contact "Has contacts abroad \& discusses journey w/ them"
la var discuss_econ_contact "Has contacts abroad \& discusses opportunity abroad w/ them"
la var discuss_riskecon_contact "Has contacts abroad \& discusses jouney \& opportunity abroad w/ them"
la var discuss_riskorecon_contact "Has contacts abroad \& discusses jouney OR opportunity abroad w/ them"


gen daily_contact = sec10_q9_1 == 1 if !missing(sec10_q9_1)
replace daily_contact = 1 if sec10_q9_2 == 1

gen weekly_contact = (sec10_q9_2 == 1 | sec10_q9_2 == 2) if !missing(sec10_q9_1)
replace weekly_contact = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2)

gen monthly_contact = (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3) if !missing(sec10_q9_1)
replace monthly_contact = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3)


gen knowedu = sec10_q6_1 == 1 if !missing(sec10_q9_1)
replace knowedu = 1 if sec10_q6_2 == 1

gen knowocc = sec10_q7_1 == 1 if !missing(sec10_q7_1)
replace knowocc = 1 if sec10_q7_2 == 1

gen knowsal = sec10_q8_1 == 1 if !missing(sec10_q8_1)
replace knowsal = 1 if sec10_q8_2 == 1

gen knowtimerem = sec10_q16_1 == 1 if !missing(sec10_q16_1)
replace knowtimerem = 1 if sec10_q16_2 == 1

gen knowvalrm = sec10_q17_1 == 1 if !missing(sec10_q17_1)
replace knowvalrm = 1 if sec10_q17_2 == 1




* code variable for being in eu or switzerland
gen contact_afr_1 = 0 if sec10_q5_1 != ""
replace contact_afr_1 = 1 if sec10_q5_1 == "AFRICA"
replace contact_afr_1 = 1 if sec10_q5_1 == "ALGERIA"
replace contact_afr_1 = 1 if sec10_q5_1 == "ANGOLA"
replace contact_afr_1 = 1 if sec10_q5_1 == "BENIN"
replace contact_afr_1 = 1 if sec10_q5_1 == "BOTSWANA"
replace contact_afr_1 = 1 if sec10_q5_1 == "BURKINA FASO"
replace contact_afr_1 = 1 if sec10_q5_1 == "CAMEROUN"
replace contact_afr_1 = 1 if sec10_q5_1 == "CAP VERT"
replace contact_afr_1 = 1 if sec10_q5_1 == "CAPE VERDE"
replace contact_afr_1 = 1 if sec10_q5_1 == "CENTRAL AFRICAN REPUBLIC"
replace contact_afr_1 = 1 if sec10_q5_1 == "CÔTÉ D'IVOIRE"
replace contact_afr_1 = 1 if sec10_q5_1 == "DRC"
replace contact_afr_1 = 1 if sec10_q5_1 == "EGYPT"
replace contact_afr_1 = 1 if sec10_q5_1 == "EQUATORIAL GUINEA"
replace contact_afr_1 = 1 if sec10_q5_1 == "GABON"
replace contact_afr_1 = 1 if sec10_q5_1 == "GAMBIA"
replace contact_afr_1 = 1 if sec10_q5_1 == "GHANA"
replace contact_afr_1 = 1 if sec10_q5_1 == "GUINEA BISSAU"
replace contact_afr_1 = 1 if sec10_q5_1 == "IVORY COAST"
replace contact_afr_1 = 1 if sec10_q5_1 == "LA CôTE D'IVOIRE"
replace contact_afr_1 = 1 if sec10_q5_1 == "LIBERIA"
replace contact_afr_1 = 1 if sec10_q5_1 == "LIBYA"
replace contact_afr_1 = 1 if sec10_q5_1 == "MADAGASCAR"
replace contact_afr_1 = 1 if sec10_q5_1 == "MALI"
replace contact_afr_1 = 1 if sec10_q5_1 == "MAURITANIA"
replace contact_afr_1 = 1 if sec10_q5_1 == "MOROCCO"
replace contact_afr_1 = 1 if sec10_q5_1 == "MOZAMBIQUE"
replace contact_afr_1 = 1 if sec10_q5_1 == "NIGER"
replace contact_afr_1 = 1 if sec10_q5_1 == "NIGERIA"
replace contact_afr_1 = 1 if sec10_q5_1 == "SENEGAL"
replace contact_afr_1 = 1 if sec10_q5_1 == "SUDAN"
replace contact_afr_1 = 1 if sec10_q5_1 == "SÃ©NEGAL"
replace contact_afr_1 = 1 if sec10_q5_1 == "TANZANIA"
replace contact_afr_1 = 1 if sec10_q5_1 == "TCHAD"
replace contact_afr_1 = 1 if sec10_q5_1 == "TOGO"
replace contact_afr_1 = 1 if sec10_q5_1 == "TUNIS"
replace contact_afr_1 = 1 if sec10_q5_1 == "TUNISIA"
replace contact_afr_1 = 1 if sec10_q5_1 == "ZAïR"
replace contact_afr_1 = 0 if contacts_abroad == 0


gen contact_afr_2 = 0 if sec10_q5_2 != ""
replace contact_afr_2 = 1 if sec10_q5_2 == "AFRICA"
replace contact_afr_2 = 1 if sec10_q5_2 == "ALGERIA"
replace contact_afr_2 = 1 if sec10_q5_2 == "ANGOLA"
replace contact_afr_2 = 1 if sec10_q5_2 == "BENIN"
replace contact_afr_2 = 1 if sec10_q5_2 == "BURKINA FASO"
replace contact_afr_2 = 1 if sec10_q5_2 == "CAMEROUN"
replace contact_afr_2 = 1 if sec10_q5_2 == "CAP VERT"
replace contact_afr_2 = 1 if sec10_q5_2 == "CENTRAL AFRICAN REPUBLIC"
replace contact_afr_2 = 1 if sec10_q5_2 == "CÔTÉ D'IVOIRE"
replace contact_afr_2 = 1 if sec10_q5_2 == "DRC"
replace contact_afr_2 = 1 if sec10_q5_2 == "EGYPT"
replace contact_afr_2 = 1 if sec10_q5_2 == "GABON"
replace contact_afr_2 = 1 if sec10_q5_2 == "GAMBIA"
replace contact_afr_2 = 1 if sec10_q5_2 == "GANHA"
replace contact_afr_2 = 1 if sec10_q5_2 == "GHANA"
replace contact_afr_2 = 1 if sec10_q5_2 == "GUINEA BISSAU"
replace contact_afr_2 = 1 if sec10_q5_2 == "IVORY COAST"
replace contact_afr_2 = 1 if sec10_q5_2 == "LA CôTE D'IVOIRE"
replace contact_afr_2 = 1 if sec10_q5_2 == "LIBERIA"
replace contact_afr_2 = 1 if sec10_q5_2 == "LIBYA"
replace contact_afr_2 = 1 if sec10_q5_2 == "KENYA"
replace contact_afr_2 = 1 if sec10_q5_2 == "MADAGASCAR"
replace contact_afr_2 = 1 if sec10_q5_2 == "MALI"
replace contact_afr_2 = 1 if sec10_q5_2 == "MAURITANIA"
replace contact_afr_2 = 1 if sec10_q5_2 == "MOROCCO"
replace contact_afr_2 = 1 if sec10_q5_2 == "MOZAMBIQUE"
replace contact_afr_2 = 1 if sec10_q5_2 == "NIGER"
replace contact_afr_2 = 1 if sec10_q5_2 == "NIGERIA"
replace contact_afr_2 = 1 if sec10_q5_2 == "SENEGAL"
replace contact_afr_2 = 1 if sec10_q5_2 == "SUDAN"
replace contact_afr_2 = 1 if sec10_q5_2 == "TANZANIA"
replace contact_afr_2 = 1 if sec10_q5_2 == "TCHAD"
replace contact_afr_2 = 1 if sec10_q5_2 == "TOGO"
replace contact_afr_2 = 1 if sec10_q5_2 == "TUNIS"
replace contact_afr_2 = 1 if sec10_q5_2 == "TUNISIA"
replace contact_afr_2 = 0 if contacts_abroad == 0


gen contact_afr = contact_afr_1
replace contact_afr = 1 if contact_afr_2 == 1


* code variable for being in eu or switzerland
gen contact_eu_1 = 0 if sec10_q5_1 != ""
replace contact_eu_1 = 1 if sec10_q5_1 == "AUSTRIA"
replace contact_eu_1 = 1 if sec10_q5_1 == "BELGIUM"
replace contact_eu_1 = 1 if sec10_q5_1 == "BRUXELLES"
replace contact_eu_1 = 1 if sec10_q5_1 == "DENMARK"
replace contact_eu_1 = 1 if sec10_q5_1 == "ENGLAND"
replace contact_eu_1 = 1 if sec10_q5_1 == "EUROPE"
replace contact_eu_1 = 1 if sec10_q5_1 == "FRANCE"
replace contact_eu_1 = 1 if sec10_q5_1 == "FRANCE  EUROP  ESPACES"
replace contact_eu_1 = 1 if sec10_q5_1 == "GERMANY"
replace contact_eu_1 = 1 if sec10_q5_1 == "GREECE"
replace contact_eu_1 = 1 if sec10_q5_1 == "GRâCE"
replace contact_eu_1 = 1 if sec10_q5_1 == "ITALY"
replace contact_eu_1 = 1 if sec10_q5_1 == "IRELAND"
replace contact_eu_1 = 1 if sec10_q5_1 == "NETHERLANDS"
replace contact_eu_1 = 1 if sec10_q5_1 == "NORWAY"
replace contact_eu_1 = 1 if sec10_q5_1 == "PORTUGAL"
replace contact_eu_1 = 1 if sec10_q5_1 == "POLAND"
replace contact_eu_1 = 1 if sec10_q5_1 == "POTUGUAL"
replace contact_eu_1 = 1 if sec10_q5_1 == "ROMANIA"
replace contact_eu_1 = 1 if sec10_q5_1 == "SPAIN"
replace contact_eu_1 = 1 if sec10_q5_1 == "SWEDEN"
replace contact_eu_1 = 1 if sec10_q5_1 == "SWITZERLAND"
replace contact_eu_1 = 1 if sec10_q5_1 == "À LONDRES"
replace contact_eu_1 = 1 if sec10_q5_1 == "LUXEMBOURG"

gen contact_noeu_1 = contact_eu_1 == 0 if !missing(contact_eu_1)
replace contact_eu_1 = 0 if contacts_abroad == 0
replace contact_noeu_1 = 0 if contacts_abroad == 0

gen contact_eu_2 = 0 if sec10_q5_2 != ""
replace contact_eu_2 = 1 if sec10_q5_2 == "AUSTRIA"
replace contact_eu_2 = 1 if sec10_q5_2 == "BELGIUM"
replace contact_eu_2 = 1 if sec10_q5_2 == "BRUXELLES"
replace contact_eu_2 = 1 if sec10_q5_2 == "DENMARK"
replace contact_eu_2 = 1 if sec10_q5_2 == "ENGLAND"
replace contact_eu_2 = 1 if sec10_q5_2 == "EUROPE"
replace contact_eu_2 = 1 if sec10_q5_2 == "FRANCE"
replace contact_eu_2 = 1 if sec10_q5_2 == "FRANCE EUROP ESPACES"
replace contact_eu_2 = 1 if sec10_q5_2 == "GERMANY"
replace contact_eu_2 = 1 if sec10_q5_2 == "GREECE"
replace contact_eu_2 = 1 if sec10_q5_2 == "ITALY"
replace contact_eu_2 = 1 if sec10_q5_2 == "NETHERLANDS"
replace contact_eu_2 = 1 if sec10_q5_2 == "NORWAY"
replace contact_eu_2 = 1 if sec10_q5_2 == "PORTUGAL"
replace contact_eu_2 = 1 if sec10_q5_2 == "POLAND"
replace contact_eu_2 = 1 if sec10_q5_2 == "POTUGUAL"
replace contact_eu_2 = 1 if sec10_q5_2 == "ROMANIA"
replace contact_eu_2 = 1 if sec10_q5_2 == "SPAIN"
replace contact_eu_2 = 1 if sec10_q5_2 == "SPAGNE"
replace contact_eu_2 = 1 if sec10_q5_2 == "SWEDEN"
replace contact_eu_2 = 1 if sec10_q5_2 == "SWITZERLAND"
replace contact_eu_2 = 1 if sec10_q5_2 == "À LONDRES"
replace contact_eu_2 = 1 if sec10_q5_2 == "ROMA"
replace contact_eu_2 = 1 if sec10_q5_2 == "REMS"
replace contact_eu_2 = 1 if sec10_q5_2 == "LIèGE"
replace contact_eu_2 = 1 if sec10_q5_2 == "HUNGARY"
replace contact_eu_2 = 1 if sec10_q5_2 == "IRELAND"
replace contact_eu_2 = 1 if sec10_q5_2 == "LUXEMBOURG"


gen contact_noeu_2 = contact_eu_2 == 0 if !missing(contact_eu_2)
replace contact_eu_2 = 0 if contacts_abroad == 0
replace contact_noeu_2 = 0 if contacts_abroad == 0


gen contact_eu = contact_eu_1
replace contact_eu = 1 if contact_eu_2 == 1

gen contact_noeu = contact_noeu_1
replace contact_noeu = 1 if contact_noeu_2 == 1

*some contacts in 2 but not in 1 -> need to assign a few missing observations
* people who have contacts in eu but not elsewhere
*tab sec10_q5_1 if !missing(contact_eu) & missing(contact_noeu)
*tab sec10_q5_2 if !missing(contact_eu) & missing(contact_noeu)
replace contact_noeu = 0 if !missing(contact_eu) & missing(contact_noeu)
replace contact_eu = 0 if missing(contact_eu) & !missing(contact_noeu)

gen discuss_wage_contact1_eu = discuss_wage_contact1*contact_eu_1
gen discuss_job_contact1_eu = discuss_job_contact1*contact_eu_1
gen discuss_benef_contact1_eu = discuss_benef_contact1*contact_eu_1
gen discuss_trip_contact1_eu = discuss_trip_contact1*contact_eu_1
gen discuss_fins_contact1_eu = discuss_fins_contact1*contact_eu_1

gen discuss_wage_contact2_eu = discuss_wage_contact2*contact_eu_2
gen discuss_job_contact2_eu = discuss_job_contact2*contact_eu_2
gen discuss_benef_contact2_eu = discuss_benef_contact2*contact_eu_2
gen discuss_trip_contact2_eu = discuss_trip_contact2*contact_eu_2
gen discuss_fins_contact2_eu = discuss_fins_contact2*contact_eu_2

gen discuss_wage_contact_eu = discuss_wage_contact1_eu == 1 if !missing(discuss_wage_contact1_eu)
replace discuss_wage_contact_eu = 1 if discuss_wage_contact2_eu == 1
gen discuss_job_contact_eu = discuss_job_contact1_eu == 1 if !missing(discuss_job_contact1_eu)
replace discuss_job_contact_eu = 1 if discuss_job_contact2_eu == 1
gen discuss_benef_contact_eu = discuss_benef_contact1_eu == 1 if !missing(discuss_benef_contact1_eu)
replace discuss_benef_contact_eu = 1 if discuss_benef_contact2_eu == 1
gen discuss_trip_contact_eu = discuss_trip_contact1_eu == 1 if !missing(discuss_trip_contact1_eu)
replace discuss_trip_contact_eu = 1 if discuss_trip_contact2_eu == 1
gen discuss_fins_contact_eu = discuss_fins_contact1_eu == 1 if !missing(discuss_fins_contact1_eu)
replace discuss_fins_contact_eu = 1 if discuss_fins_contact2_eu == 1

replace discuss_wage_contact_eu = 0 if contact_eu == 0
replace discuss_job_contact_eu = 0 if contact_eu == 0 
replace discuss_benef_contact_eu = 0 if contact_eu == 0 
replace discuss_trip_contact_eu = 0 if contact_eu == 0 
replace discuss_fins_contact_eu = 0 if contact_eu == 0 

gen discuss_econ_contact_eu = (discuss_wage_contact_eu == 1 | ///
	discuss_job_contact_eu == 1 | discuss_benef_contact_eu == 1 /// 
	| discuss_fins_contact_eu == 1) if !missing(discuss_wage_contact_eu) & ///
	!missing(discuss_job_contact_eu) & !missing(discuss_benef_contact_eu) & ///
	!missing(discuss_fins_contact_eu)

gen discuss_risk_contact_eu = discuss_trip_contact_eu

gen discuss_riskecon_contact_eu = (discuss_risk_contact_eu == 1) & (discuss_econ_contact_eu == 1) if !missing(discuss_risk_contact_eu) & !missing(discuss_econ_contact_eu)

gen discuss_riskorecon_contact_eu = (discuss_risk_contact_eu == 1) | (discuss_econ_contact_eu == 1) if !missing(discuss_risk_contact_eu) & !missing(discuss_econ_contact_eu)

gen daily_contact_eu = (sec10_q9_1 == 1)*contact_eu_1 if !missing(sec10_q9_1)
replace daily_contact_eu = 1 if sec10_q9_2 == 1 & contact_eu_2 == 1

gen weekly_contact_eu = (sec10_q9_2 == 1 | sec10_q9_2 == 2)*contact_eu_1 if !missing(sec10_q9_1)
replace weekly_contact_eu = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2) & contact_eu_2 == 1

gen monthly_contact_eu = (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3)*contact_eu_1 if !missing(sec10_q9_1)
replace monthly_contact_eu = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3) & contact_eu_2 == 1


la var discuss_risk_contact_eu "Has contacts abroad \& discusses journey w/ them (EU)"
la var discuss_econ_contact_eu "Has contacts abroad \& discusses opportunity abroad w/ them (EU)"
la var discuss_riskecon_contact_eu "Has contacts abroad \& discusses jouney \& opportunity abroad w/ them (EU)"
la var discuss_riskorecon_contact_eu "Has contacts abroad \& discusses jouney OR opportunity abroad w/ them (EU)"






* type of ties (peers)

gen peer_tie_1 =  (sec10_q2_1 == 1 | sec10_q2_1 == 3 | sec10_q2_1 == 6)  if sec10_q2_1 != . 
replace peer_tie_1 = 0 if contacts_abroad == 0

gen nonpeer_tie_1 = (sec10_q2_1 == 2 | sec10_q2_1 == 4 | sec10_q2_1 == 5 | sec10_q2_1 == 7)  if sec10_q2_1 != .
replace nonpeer_tie_1 = 0 if contacts_abroad == 0

gen peer_tie_2 =  (sec10_q2_1 == 1 | sec10_q2_1 == 3 | sec10_q2_1 == 6)   if sec10_q2_2 != . 
replace peer_tie_2 = 0 if contacts_abroad == 0

gen nonpeer_tie_2 = (sec10_q2_1 == 2 | sec10_q2_1 == 4 | sec10_q2_1 == 5 | sec10_q2_1 == 7)  if sec10_q2_2 != .
replace nonpeer_tie_2 = 0 if contacts_abroad == 0

gen peer_tie = peer_tie_1
replace peer_tie = 1 if peer_tie_2 == 1

gen nonpeer_tie = peer_tie_1
replace nonpeer_tie = 1 if nonpeer_tie_2 == 1


* type of ties in europe (peers)

gen peer_tie_1_eu =  (sec10_q2_1 == 1 | sec10_q2_1 == 3 | sec10_q2_1 == 6)  if sec10_q2_1 != . & contact_eu_1 == 1
replace peer_tie_1_eu = 0 if contact_eu_1 == 0

gen nonpeer_tie_1_eu =  (sec10_q2_1 == 2 | sec10_q2_1 == 4 | sec10_q2_1 == 5 | sec10_q2_1 == 7)  if sec10_q2_1 != . & contact_eu_1 == 1
replace nonpeer_tie_1_eu = 0 if contact_eu_1 == 0

gen peer_tie_2_eu =  (sec10_q2_1 == 1 | sec10_q2_1 == 3 | sec10_q2_1 == 6)  if sec10_q2_2 != . & contact_eu_2 == 1
replace peer_tie_2_eu = 0 if contact_eu_2 == 0

gen nonpeer_tie_2_eu =  (sec10_q2_1 == 2 | sec10_q2_1 == 4 | sec10_q2_1 == 5 | sec10_q2_1 == 7)  if sec10_q2_2 != . & contact_eu_2 == 1
replace nonpeer_tie_2_eu = 0 if contact_eu_2 == 0

gen peer_tie_eu = peer_tie_1_eu
replace peer_tie_eu = 1 if peer_tie_2_eu == 1

gen nonpeer_tie_eu = peer_tie_1_eu
replace nonpeer_tie_eu = 1 if nonpeer_tie_2_eu == 1







* type of ties

gen strong_tie_1 =  (sec10_q2_1 == 1 | sec10_q2_1 == 2 | sec10_q2_1 == 3 | sec10_q2_1 == 4 | sec10_q2_1 == 5)  if sec10_q2_1 != . 
replace strong_tie_1 = 0 if contacts_abroad == 0

gen weak_tie_1 = (sec10_q2_1 == 6 | sec10_q2_1 == 7)  if sec10_q2_1 != .
replace weak_tie_1 = 0 if contacts_abroad == 0

gen strong_tie_2 =  (sec10_q2_2 == 1 | sec10_q2_2 == 2 | sec10_q2_2 == 3 | sec10_q2_2 == 4 | sec10_q2_1 == 5)  if sec10_q2_2 != . 
replace strong_tie_2 = 0 if contacts_abroad == 0

gen weak_tie_2 = (sec10_q2_2 == 6 | sec10_q2_2 == 7)  if sec10_q2_2 != .
replace weak_tie_2 = 0 if contacts_abroad == 0

gen strong_tie = strong_tie_1
replace strong_tie = 1 if strong_tie_2 == 1

gen weak_tie = strong_tie_1
replace weak_tie = 1 if weak_tie_2 == 1


* type of ties in europe

gen strong_tie_1_eu =  (sec10_q2_1 == 1 | sec10_q2_1 == 2 | sec10_q2_1 == 3 | sec10_q2_1 == 4 | sec10_q2_1 == 5)  if sec10_q2_1 != . & contact_eu_1 == 1
replace strong_tie_1_eu = 0 if contact_eu_1 == 0

gen weak_tie_1_eu = (sec10_q2_1 == 6 | sec10_q2_1 == 7)  if sec10_q2_1 != . & contact_eu_1 == 1
replace weak_tie_1_eu = 0 if contact_eu_1 == 0

gen strong_tie_2_eu =  (sec10_q2_2 == 1 | sec10_q2_2 == 2 | sec10_q2_2 == 3 | sec10_q2_2 == 4 | sec10_q2_2 == 5)  if sec10_q2_2 != . & contact_eu_2 == 1
replace strong_tie_2_eu = 0 if contact_eu_2 == 0

gen weak_tie_2_eu = (sec10_q2_2 == 6 | sec10_q2_2 == 7)  if sec10_q2_2 != . & contact_eu_2 == 1
replace weak_tie_2_eu = 0 if contact_eu_2 == 0

gen strong_tie_eu = strong_tie_1_eu
replace strong_tie_eu = 1 if strong_tie_2_eu == 1

gen weak_tie_eu = strong_tie_1_eu
replace weak_tie_eu = 1 if weak_tie_2_eu == 1


* type of ties not in europe

gen strong_tie_1_noeu =  (sec10_q2_1 == 1 | sec10_q2_1 == 2 | sec10_q2_1 == 3 | sec10_q2_1 == 4 | sec10_q2_1 == 5)  if sec10_q2_1 != . & contact_noeu_1 == 1
replace strong_tie_1_noeu = 0 if contact_noeu_1 == 0

gen weak_tie_1_noeu = (sec10_q2_1 == 6 | sec10_q2_1 == 7)  if sec10_q2_1 != . & contact_noeu_1 == 1
replace weak_tie_1_noeu = 0 if contact_noeu_1 == 0

gen strong_tie_2_noeu =  (sec10_q2_2 == 1 | sec10_q2_2 == 2 | sec10_q2_2 == 3 | sec10_q2_2 == 4 | sec10_q2_2 == 5)  if sec10_q2_2 != . & contact_noeu_2 == 1
replace strong_tie_2_noeu = 0 if contact_noeu_2 == 0

gen weak_tie_2_noeu = (sec10_q2_2 == 6 | sec10_q2_2 == 7)  if sec10_q2_2 != . & contact_noeu_2 == 1
replace weak_tie_2_noeu = 0 if contact_noeu_2 == 0

gen strong_tie_noeu = strong_tie_1_noeu
replace strong_tie_noeu = 1 if strong_tie_2_noeu == 1

gen weak_tie_noeu = strong_tie_1_noeu
replace weak_tie_noeu = 1 if weak_tie_2_noeu == 1

la var strong_tie_eu "Family ties or fianc\'e in EU"
la var strong_tie_noeu "Family ties or fianc\'e abroad (excl. EU)"
la var weak_tie_noeu "Non-family contact in EU"
la var weak_tie_eu "Non-family contact abroad (excl. EU)"


*parents
gen parent_1_eu =  sec10_q2_1 == 2 if sec10_q2_1 != . & contact_eu_1 == 1
replace parent_1_eu = 0 if contact_eu_1 == 0

gen nonparent_1_eu = (sec10_q2_1 == 1 | sec10_q2_1 == 3 | sec10_q2_1 == 4 | sec10_q2_1 == 5 | sec10_q2_1 == 6 | sec10_q2_1 == 7)  if sec10_q2_1 != . & contact_eu_1 == 1
replace nonparent_1_eu = 0 if contact_eu_1 == 0

gen parent_2_eu =  sec10_q2_2 == 2 if sec10_q2_2 != . & contact_eu_2 == 1
replace parent_2_eu = 0 if contact_eu_2 == 0

gen nonparent_2_eu = (sec10_q2_2 == 1 | sec10_q2_2 == 3 | sec10_q2_2 == 4 | sec10_q2_2 == 5 | sec10_q2_2 == 6 | sec10_q2_2 == 7)  if sec10_q2_1 != . & contact_eu_1 == 1
replace nonparent_2_eu = 0 if contact_eu_2 == 0

gen parent_eu = parent_1_eu
replace parent_eu = 1 if parent_2_eu == 1

gen nonparent_eu = nonparent_1_eu
replace nonparent_eu = 1 if nonparent_2_eu == 1




* code variable for being in italy, france or spain
gen contact_ifs_1 = 0 if sec10_q5_1 != ""
replace contact_ifs_1 = 1 if sec10_q5_1 == "FRANCE"
replace contact_ifs_1 = 1 if sec10_q5_1 == "FRANCE  EUROP  ESPACES"
replace contact_ifs_1 = 1 if sec10_q5_1 == "ITALY"
replace contact_ifs_1 = 1 if sec10_q5_1 == "SPAIN"
replace contact_ifs_1 = 0 if contacts_abroad == 0

gen contact_ifs_2 = 0 if sec10_q5_2 != ""
replace contact_ifs_2 = 1 if sec10_q5_2 == "FRANCE"
replace contact_ifs_2 = 1 if sec10_q5_2 == "FRANCE EUROP ESPACES"
replace contact_ifs_2 = 1 if sec10_q5_2 == "ITALY"
replace contact_ifs_2 = 1 if sec10_q5_2 == "SPAIN"
replace contact_ifs_2 = 1 if sec10_q5_2 == "SPAGNE"
replace contact_ifs_2 = 0 if contacts_abroad == 0

gen contact_ifs = contact_ifs_1
replace contact_ifs = 1 if contact_ifs_2 == 1



gen discuss_wage_contact1_ifs = discuss_wage_contact1*contact_ifs_1
gen discuss_job_contact1_ifs = discuss_job_contact1*contact_ifs_1
gen discuss_benef_contact1_ifs = discuss_benef_contact1*contact_ifs_1
gen discuss_trip_contact1_ifs = discuss_trip_contact1*contact_ifs_1
gen discuss_fins_contact1_ifs = discuss_fins_contact1*contact_ifs_1

gen discuss_wage_contact2_ifs = discuss_wage_contact2*contact_ifs_2
gen discuss_job_contact2_ifs = discuss_job_contact2*contact_ifs_2
gen discuss_benef_contact2_ifs = discuss_benef_contact2*contact_ifs_2
gen discuss_trip_contact2_ifs = discuss_trip_contact2*contact_ifs_2
gen discuss_fins_contact2_ifs = discuss_fins_contact2*contact_ifs_2

gen discuss_wage_contact_ifs = discuss_wage_contact1_ifs == 1 if !missing(discuss_wage_contact1_ifs)
replace discuss_wage_contact_ifs = 1 if discuss_wage_contact2_ifs == 1
gen discuss_job_contact_ifs = discuss_job_contact1_ifs == 1 if !missing(discuss_job_contact1_ifs)
replace discuss_job_contact_ifs = 1 if discuss_job_contact2_ifs == 1
gen discuss_benef_contact_ifs = discuss_benef_contact1_ifs == 1 if !missing(discuss_benef_contact1_ifs)
replace discuss_benef_contact_ifs = 1 if discuss_benef_contact2_ifs == 1
gen discuss_trip_contact_ifs = discuss_trip_contact1_ifs == 1 if !missing(discuss_trip_contact1_ifs)
replace discuss_trip_contact_ifs = 1 if discuss_trip_contact2_ifs == 1
gen discuss_fins_contact_ifs = discuss_fins_contact1_ifs == 1 if !missing(discuss_fins_contact1_ifs)
replace discuss_fins_contact_ifs = 1 if discuss_fins_contact2_ifs == 1

replace discuss_wage_contact_ifs = 0 if contact_ifs == 0
replace discuss_job_contact_ifs = 0 if contact_ifs == 0 
replace discuss_benef_contact_ifs = 0 if contact_ifs == 0 
replace discuss_trip_contact_ifs = 0 if contact_ifs == 0 
replace discuss_fins_contact_ifs = 0 if contact_ifs == 0 

gen discuss_econ_contact_ifs = (discuss_wage_contact_ifs == 1 | ///
	discuss_job_contact_ifs == 1 | discuss_benef_contact_ifs == 1 /// 
	| discuss_fins_contact_ifs == 1) if !missing(discuss_wage_contact_ifs) & ///
	!missing(discuss_job_contact_ifs) & !missing(discuss_benef_contact_ifs) & ///
	!missing(discuss_fins_contact_ifs)

gen discuss_risk_contact_ifs = discuss_trip_contact_ifs

gen discuss_riskecon_contact_ifs = (discuss_risk_contact_ifs == 1) & (discuss_econ_contact_ifs == 1) if !missing(discuss_risk_contact_ifs) & !missing(discuss_econ_contact_ifs)

gen discuss_riskorecon_contact_ifs = (discuss_risk_contact_ifs == 1) | (discuss_econ_contact_ifs == 1) if !missing(discuss_risk_contact_ifs) & !missing(discuss_econ_contact_ifs)

gen daily_contact_ifs = (sec10_q9_1 == 1)*contact_ifs_1 if !missing(sec10_q9_1)
replace daily_contact_ifs = 1 if sec10_q9_2 == 1 & contact_ifs_2 == 1

gen weekly_contact_ifs = (sec10_q9_2 == 1 | sec10_q9_2 == 2)*contact_ifs_1 if !missing(sec10_q9_1)
replace weekly_contact_ifs = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2) & contact_ifs_2 == 1

gen monthly_contact_ifs = (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3)*contact_ifs_1 if !missing(sec10_q9_1)
replace monthly_contact_ifs = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3) & contact_ifs_2 == 1


la var discuss_risk_contact_ifs "Has contacts abroad \& discusses journey w/ them (Ita/Fra/Spa)"
la var discuss_econ_contact_ifs "Has contacts abroad \& discusses opportunity abroad w/ them (Ita/Fra/Spa)"
la var discuss_riskecon_contact_ifs "Has contacts abroad \& discusses jouney \& opportunity abroad w/ them (Ita/Fra/Spa)"
la var discuss_riskorecon_contact_ifs "Has contacts abroad \& discusses jouney OR opportunity abroad w/ them (Ita/Fra/Spa)"



gen contact_eunoifs = contact_eu == 1 & contact_ifs == 0 if !missing(contact_eu) & !missing(contact_ifs)
gen contact_anynoifs = contacts_abroad == 1 & contact_ifs == 0 if !missing(contacts_abroad) & !missing(contact_ifs)




* code variable for contacts sending remittances

gen remittances_1mon = 0 if contacts_abroad != .
replace remittances_1mon = 1 if (sec10_q16_1 == 1 | sec10_q16_1 == 2)
replace remittances_1mon = 1 if (sec10_q16_2 == 1 | sec10_q16_2 == 2)

gen remittances_3mon = 0 if contacts_abroad != .
replace remittances_3mon = 1 if (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3)
replace remittances_3mon = 1 if (sec10_q16_2 == 1 | sec10_q16_2 == 2 | sec10_q16_2 == 3)

gen remittances_6mon = 0 if contacts_abroad != .
replace remittances_6mon = 1 if (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3 | sec10_q16_1 == 4)
replace remittances_6mon = 1 if (sec10_q16_2 == 1 | sec10_q16_2 == 2 | sec10_q16_2 == 3 | sec10_q16_2 == 4)

gen remittances_1y = 0 if contacts_abroad != .
replace remittances_1y = 1 if (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3 | sec10_q16_1 == 4 | sec10_q16_1 == 5)
replace remittances_1y = 1 if (sec10_q16_2 == 1 | sec10_q16_2 == 2 | sec10_q16_2 == 3 | sec10_q16_2 == 4 | sec10_q16_2 == 5)

gen remittances = 0 if contacts_abroad != .
replace remittances = 1 if (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3 | sec10_q16_1 == 4 | sec10_q16_1 == 5 | sec10_q16_1 == 6)
replace remittances = 1 if (sec10_q16_2 == 1 | sec10_q16_2 == 2 | sec10_q16_2 == 3 | sec10_q16_2 == 4 | sec10_q16_2 == 5 | sec10_q16_2 == 6 )



* code variable for contacts sending remittances from the eu

gen remittances_1wee_eu = 0 if contacts_abroad != .
replace remittances_1wee_eu = 1 if contact_eu_1 == 1 & (sec10_q16_1 == 1)
replace remittances_1wee_eu = 1 if contact_eu_2 == 1 & (sec10_q16_2 == 1)

gen remittances_1mon_eu = 0 if contacts_abroad != .
replace remittances_1mon_eu = 1 if contact_eu_1 == 1 & (sec10_q16_1 == 1 | sec10_q16_1 == 2)
replace remittances_1mon_eu = 1 if contact_eu_2 == 1 & (sec10_q16_2 == 1 | sec10_q16_2 == 2)
*replace remittances_1mon_eu = 2 if sec10_q16_2 == 99

gen remittances_3mon_eu = 0 if contacts_abroad != .
replace remittances_3mon_eu = 1 if contact_eu_1 == 1 & (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3)
replace remittances_3mon_eu = 1 if contact_eu_2 == 1 & (sec10_q16_2 == 1 | sec10_q16_2 == 2 | sec10_q16_2 == 3)
*replace remittances_3mon_eu = 2 if sec10_q16_2 == 99

gen remittances_6mon_eu = 0 if contacts_abroad != .
replace remittances_6mon_eu = 1 if contact_eu_1 == 1 & (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3 | sec10_q16_1 == 4)
replace remittances_6mon_eu = 1 if contact_eu_2 == 1 & (sec10_q16_2 == 1 | sec10_q16_2 == 2 | sec10_q16_2 == 3 | sec10_q16_2 == 4)
*replace remittances_6mon_eu = 2 if sec10_q16_2 == 99

gen remittances_1y_eu = 0 if contacts_abroad != .
replace remittances_1y_eu = 1 if contact_eu_1 == 1 & (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3 | sec10_q16_1 == 4 | sec10_q16_1 == 5)
replace remittances_1y_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 1 | sec10_q17_2 == 2 | sec10_q17_2 == 3 | sec10_q17_2 == 4 | sec10_q17_2 == 5)
*replace remittances_1y_eu = 2 if sec10_q17_2 == 99

gen remittances_eu = 0 if contacts_abroad != .
replace remittances_eu = 1 if contact_eu_1 == 1 & (sec10_q16_1 == 1 | sec10_q16_1 == 2 | sec10_q16_1 == 3 | sec10_q16_1 == 4 | sec10_q16_1 == 5 | sec10_q16_1 == 6)
replace remittances_eu = 1 if contact_eu_2 == 1 & (sec10_q16_2 == 1 | sec10_q16_2 == 2 | sec10_q16_2 == 3 | sec10_q16_2 == 4 | sec10_q16_2 == 5 | sec10_q16_2 == 6 )
*replace remittances_eu = 2 if sec10_q17_2 == 99

gen remittances_dk_eu = 0 if contacts_abroad != .
replace remittances_dk_eu = 1 if contact_eu_1 == 1 & (sec10_q16_1 == 99)
replace remittances_dk_eu = 1 if contact_eu_2 == 1 & (sec10_q16_2 == 99)
*replace remittances_eu = 2 if sec10_q17_2 == 99

* does not know occupation of contact in eu
gen occupation_dk_eu = 0 if contacts_abroad == 1
replace occupation_dk_eu = sec10_q7_1 == 99 & contact_eu_1 == 1
replace occupation_dk_eu = sec10_q7_2 == 99 & contact_eu_2 == 1

* does not know remittances of contact in eu
gen income_dk_eu = 0 if contacts_abroad == 1
replace income_dk_eu = sec10_q8_1 == 99 & contact_eu_1 == 1
replace income_dk_eu = sec10_q8_2 == 99 & contact_eu_2 == 1

* does not know remittances or occupation of contact in the eu
gen occinc_dk_eu = occupation_dk_eu
replace occinc_dk_eu = 1 if income_dk_eu == 1

* code variable for contacts sending remittances from the eu (money)

gen remittances_more0_eu = 0 if contacts_abroad != .
replace remittances_more0_eu = 1 if contact_eu_1 == 1 & (sec10_q17_1 == 1 | sec10_q17_1 == 2 | sec10_q17_1 == 3 | sec10_q17_1 == 4 | sec10_q17_1 == 5 | sec10_q17_1 == 6)
replace remittances_more0_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 1 | sec10_q17_2 == 2 | sec10_q17_2 == 3 | sec10_q17_2 == 4 | sec10_q17_2 == 5 | sec10_q17_2 == 6 )
*replace remittances_1mon_eu = 2 if sec10_q17_2 == 99

gen remittances_more1m_eu = 0 if contacts_abroad != .
replace remittances_more1m_eu = 1 if contact_eu_1 == 1 & (sec10_q17_1 == 2 | sec10_q17_1 == 3 | sec10_q17_1 == 4 | sec10_q17_1 == 5 | sec10_q17_1 == 6)
replace remittances_more1m_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 2 | sec10_q17_2 == 3 | sec10_q17_2 == 4 | sec10_q17_2 == 5 | sec10_q17_2 == 6)
*replace remittances_3mon_eu = 2 if sec10_q17_2 == 99

gen remittances_more2_5m_eu = 0 if contacts_abroad != .
replace remittances_more2_5m_eu = 1 if contact_eu_1 == 1 & (sec10_q17_1 == 3 | sec10_q17_1 == 4 | sec10_q17_1 == 5 | sec10_q17_1 == 6)
replace remittances_more2_5m_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 3 | sec10_q17_2 == 4 | sec10_q17_2 == 5 | sec10_q17_2 == 6)
*replace remittances_6mon_eu = 2 if sec10_q17_2 == 99

gen remittances_more5m_eu = 0 if contacts_abroad != .
replace remittances_more5m_eu = 1 if contact_eu_1 == 1 & (sec10_q17_1 == 4 | sec10_q17_1 == 5 | sec10_q17_1 == 6)
replace remittances_more5m_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 4 | sec10_q17_2 == 5 | sec10_q17_2 == 6)
*replace remittances_1y_eu = 2 if sec10_q17_2 == 99

gen remittances_more10m_eu = 0 if contacts_abroad != .
replace remittances_more10m_eu = 1 if contact_eu_1 == 1 & (sec10_q17_1 == 5 | sec10_q17_1 == 6)
replace remittances_more10m_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 5 | sec10_q17_2 == 6 )
*replace remittances_eu = 2 if sec10_q17_2 == 99

gen remittances_more20m_eu = 0 if contacts_abroad != .
replace remittances_more20m_eu = 1 if contact_eu_1 == 1 & (sec10_q17_1 == 6)
replace remittances_more20m_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 6 )

gen remittances_dk_q_eu = remittances_dk_eu
replace remittances_dk_q_eu = 1 if contact_eu_1 == 1 & (sec10_q17_1 == 99)
replace remittances_dk_q_eu = 1 if contact_eu_2 == 1 & (sec10_q17_2 == 99)
*replace remittances_eu = 2 if sec10_q17_2 == 99





* code variable for wage of contacts in the eu (money)

gen wage_more0_eu = 0 if contacts_abroad != .
replace wage_more0_eu = 1 if contact_eu_1 == 1 & (sec10_q8_1 == 1 | sec10_q8_1 == 2 | sec10_q8_1 == 3 | sec10_q8_1 == 4 | sec10_q8_1 == 5 | sec10_q8_1 == 6)
replace wage_more0_eu = 1 if contact_eu_2 == 1 & (sec10_q8_2 == 1 | sec10_q8_2 == 2 | sec10_q8_2 == 3 | sec10_q8_2 == 4 | sec10_q8_2 == 5 | sec10_q8_2 == 6 )
*replace remittances_1mon_eu = 2 if sec10_q17_2 == 99

gen wage_more1m_eu = 0 if contacts_abroad != .
replace wage_more1m_eu = 1 if contact_eu_1 == 1 & (sec10_q8_1 == 2 | sec10_q8_1 == 3 | sec10_q8_1 == 4 | sec10_q8_1 == 5 | sec10_q8_1 == 6)
replace wage_more1m_eu = 1 if contact_eu_2 == 1 & (sec10_q8_2 == 2 | sec10_q8_2 == 3 | sec10_q8_2 == 4 | sec10_q8_2 == 5 | sec10_q8_2 == 6)
*replace remittances_3mon_eu = 2 if sec10_q17_2 == 99

gen wage_more2_5m_eu = 0 if contacts_abroad != .
replace wage_more2_5m_eu = 1 if contact_eu_1 == 1 & (sec10_q8_1 == 3 | sec10_q8_1 == 4 | sec10_q8_1 == 5 | sec10_q8_1 == 6)
replace wage_more2_5m_eu = 1 if contact_eu_2 == 1 & (sec10_q8_2 == 3 | sec10_q8_2 == 4 | sec10_q8_2 == 5 | sec10_q8_2 == 6)
*replace remittances_6mon_eu = 2 if sec10_q17_2 == 99

gen wage_more5m_eu = 0 if contacts_abroad != .
replace wage_more5m_eu = 1 if contact_eu_1 == 1 & (sec10_q8_1 == 4 | sec10_q8_1 == 5 | sec10_q8_1 == 6)
replace wage_more5m_eu = 1 if contact_eu_2 == 1 & (sec10_q8_2 == 4 | sec10_q8_2 == 5 | sec10_q8_2 == 6)
*replace remittances_1y_eu = 2 if sec10_q17_2 == 99

gen wage_more10m_eu = 0 if contacts_abroad != .
replace wage_more10m_eu = 1 if contact_eu_1 == 1 & (sec10_q8_1 == 5 | sec10_q8_1 == 6)
replace wage_more10m_eu = 1 if contact_eu_2 == 1 & (sec10_q8_2 == 5 | sec10_q8_2 == 6 )
*replace remittances_eu = 2 if sec10_q17_2 == 99

gen wage_more20m_eu = 0 if contacts_abroad != .
replace wage_more20m_eu = 1 if contact_eu_1 == 1 & (sec10_q8_1 == 6)
replace wage_more20m_eu = 1 if contact_eu_2 == 1 & (sec10_q8_2 == 6 )

gen wage_dk_eu = 0 if !missing(contacts_abroad)
replace wage_dk_eu = 1 if contact_eu_1 == 1 & (sec10_q8_1 == 99)
replace wage_dk_eu = 1 if contact_eu_2 == 1 & (sec10_q8_2 == 99)
*replace remittances_eu = 2 if sec10_q17_2 == 99








* code variable for contact working or studying
gen contactws_1 = 1 if sec10_q7_1 != .
replace contactws_1 = 0 if sec10_q7_1 == 11
replace contactws_1 = 0 if sec10_q7_1 == 99

gen contactws_2 = 1 if sec10_q7_2 != .
replace contactws_2 = 0 if sec10_q7_2 == 11
replace contactws_2 = 0 if sec10_q7_2 == 99

gen contactws = contactws_1
replace contactws = 1 if contactws_2 == 1

la var contactws "Contact in ITA, SPA, or FRA stud or work"

* code contact working
gen contactw_1 = 0 if sec10_q7_1 != .
replace contactw_1 = 1 if sec10_q7_1 == 2
replace contactw_1 = 1 if sec10_q7_1 == 3
replace contactw_1 = 1 if sec10_q7_1 == 4
replace contactw_1 = 1 if sec10_q7_1 == 5
replace contactw_1 = 1 if sec10_q7_1 == 6
replace contactw_1 = 1 if sec10_q7_1 == 7
replace contactw_1 = 1 if sec10_q7_1 == 8
replace contactw_1 = 1 if sec10_q7_1 == 9


gen contactw_2 = 0 if sec10_q7_2 != .
replace contactw_2 = 1 if sec10_q7_2 == 2
replace contactw_2 = 1 if sec10_q7_2 == 3
replace contactw_2 = 1 if sec10_q7_2 == 4
replace contactw_2 = 1 if sec10_q7_2 == 5
replace contactw_2 = 1 if sec10_q7_2 == 6
replace contactw_2 = 1 if sec10_q7_2 == 7
replace contactw_2 = 1 if sec10_q7_2 == 8
replace contactw_2 = 1 if sec10_q7_2 == 9

gen contactw = contactw_1
replace contactw = 1 if contactw_2 == 1



* code variable for having contacts in the desired country (eu or switzerland)
gen contact_des_1 = 0 if sec10_q5_1 != ""
replace contact_des_1 = 1 if sec10_q5_1 == "AUSTRIA" & desired_country_str == "AUT"
replace contact_des_1 = 1 if sec10_q5_1 == "BELGIUM" & desired_country_str == "BEL"
replace contact_des_1 = 1 if sec10_q5_1 == "BRUXELLES" & desired_country_str == "BEL"
replace contact_des_1 = 1 if sec10_q5_1 == "DENMARK"
replace contact_des_1 = 1 if sec10_q5_1 == "ENGLAND" & desired_country_str == "GRB"
replace contact_des_1 = 1 if sec10_q5_1 == "EUROPE"
replace contact_des_1 = 1 if sec10_q5_1 == "FRANCE" & desired_country_str == "FRA"
replace contact_des_1 = 1 if sec10_q5_1 == "FRANCE  EUROP  ESPACES" & desired_country_str == "FRA"
replace contact_des_1 = 1 if sec10_q5_1 == "GERMANY" & desired_country_str == "DEU"
replace contact_des_1 = 1 if sec10_q5_1 == "GREECE"
replace contact_des_1 = 1 if sec10_q5_1 == "ITALY" & desired_country_str == "ITA"
replace contact_des_1 = 1 if sec10_q5_1 == "NETHERLANDS" & desired_country_str == "NLD"
replace contact_des_1 = 1 if sec10_q5_1 == "NORWAY"
replace contact_des_1 = 1 if sec10_q5_1 == "PORTUGAL" & desired_country_str == "PRT"
replace contact_des_1 = 1 if sec10_q5_1 == "POLAND" & desired_country_str == "POL"
replace contact_des_1 = 1 if sec10_q5_1 == "POTUGUAL" & desired_country_str == "PRT"
replace contact_des_1 = 1 if sec10_q5_1 == "ROMANIA" 
replace contact_des_1 = 1 if sec10_q5_1 == "SPAIN" & desired_country_str == "ESP"
replace contact_des_1 = 1 if sec10_q5_1 == "SWEDEN" & desired_country_str == "SWE"
replace contact_des_1 = 1 if sec10_q5_1 == "SWITZERLAND" & desired_country_str == "CHE"
replace contact_des_1 = 1 if sec10_q5_1 == "À LONDRES" & desired_country_str == "GRB"
replace contact_des_1 = 0 if contacts_abroad == 0

gen contact_des_2 = 0 if sec10_q5_2 != ""
replace contact_des_2 = 1 if sec10_q5_2 == "AUSTRIA" & desired_country_str == "AUT"
replace contact_des_2 = 1 if sec10_q5_2 == "BELGIUM" & desired_country_str == "BEL"
replace contact_des_2 = 1 if sec10_q5_2 == "BRUXELLES" & desired_country_str == "BEL"
replace contact_des_2 = 1 if sec10_q5_2 == "DENMARK"
replace contact_des_2 = 1 if sec10_q5_2 == "ENGLAND" & desired_country_str == "GRB"
replace contact_des_2 = 1 if sec10_q5_2 == "EUROPE"
replace contact_des_2 = 1 if sec10_q5_2 == "FRANCE" & desired_country_str == "FRA"
replace contact_des_2 = 1 if sec10_q5_2 == "FRANCE EUROP ESPACES" & desired_country_str == "FRA"
replace contact_des_2 = 1 if sec10_q5_2 == "GERMANY" & desired_country_str == "DEU"
replace contact_des_2 = 1 if sec10_q5_2 == "GREECE"
replace contact_des_2 = 1 if sec10_q5_2 == "ITALY" & desired_country_str == "ITA"
replace contact_des_2 = 1 if sec10_q5_2 == "NETHERLANDS" & desired_country_str == "NLD"
replace contact_des_2 = 1 if sec10_q5_2 == "NORWAY"
replace contact_des_2 = 1 if sec10_q5_2 == "PORTUGAL" & desired_country_str == "PRT"
replace contact_des_2 = 1 if sec10_q5_2 == "POLAND" & desired_country_str == "POL"
replace contact_des_2 = 1 if sec10_q5_2 == "POTUGUAL" & desired_country_str == "PRT"
replace contact_des_2 = 1 if sec10_q5_2 == "ROMANIA"
replace contact_des_2 = 1 if sec10_q5_2 == "SPAIN" & desired_country_str == "ESP"
replace contact_des_2 = 1 if sec10_q5_2 == "SPAGNE" & desired_country_str == "ESP"
replace contact_des_2 = 1 if sec10_q5_2 == "SWEDEN" & desired_country_str == "SWE"
replace contact_des_2 = 1 if sec10_q5_2 == "SWITZERLAND" & desired_country_str == "CHE"
replace contact_des_2 = 1 if sec10_q5_2 == "À LONDRES" & desired_country_str == "GRB"
replace contact_des_2 = 1 if sec10_q5_2 == "ROMA" & desired_country_str == "ITA"
replace contact_des_2 = 1 if sec10_q5_2 == "REMS" & desired_country_str == "FRA"
replace contact_des_2 = 1 if sec10_q5_2 == "LIèGE" & desired_country_str == "BEL"
replace contact_des_2 = 1 if sec10_q5_2 == "HUNGARY"
replace contact_des_2 = 1 if sec10_q5_2 == "IRELAND" & desired_country_str == "IRL"
replace contact_des_2 = 0 if contacts_abroad == 0


gen contact_des = contact_des_1
replace contact_des = 1 if contact_des_2 == 1



gen discuss_wage_contact1_des = discuss_wage_contact1*contact_des_1
gen discuss_job_contact1_des = discuss_job_contact1*contact_des_1
gen discuss_benef_contact1_des = discuss_benef_contact1*contact_des_1
gen discuss_trip_contact1_des = discuss_trip_contact1*contact_des_1
gen discuss_fins_contact1_des = discuss_fins_contact1*contact_des_1

gen discuss_wage_contact2_des = discuss_wage_contact2*contact_des_2
gen discuss_job_contact2_des = discuss_job_contact2*contact_des_2
gen discuss_benef_contact2_des = discuss_benef_contact2*contact_des_2
gen discuss_trip_contact2_des = discuss_trip_contact2*contact_des_2
gen discuss_fins_contact2_des = discuss_fins_contact2*contact_des_2

gen discuss_wage_contact_des = discuss_wage_contact1_des == 1 if !missing(discuss_wage_contact1_des)
replace discuss_wage_contact_des = 1 if discuss_wage_contact2_des == 1
gen discuss_job_contact_des = discuss_job_contact1_des == 1 if !missing(discuss_job_contact1_des)
replace discuss_job_contact_des = 1 if discuss_job_contact2_des == 1
gen discuss_benef_contact_des = discuss_benef_contact1_des == 1 if !missing(discuss_benef_contact1_des)
replace discuss_benef_contact_des = 1 if discuss_benef_contact2_des == 1
gen discuss_trip_contact_des = discuss_trip_contact1_des == 1 if !missing(discuss_trip_contact1_des)
replace discuss_trip_contact_des = 1 if discuss_trip_contact2_des == 1
gen discuss_fins_contact_des = discuss_fins_contact1_des == 1 if !missing(discuss_fins_contact1_des)
replace discuss_fins_contact_des = 1 if discuss_fins_contact2_des == 1

replace discuss_wage_contact_des = 0 if contact_des == 0
replace discuss_job_contact_des = 0 if contact_des == 0 
replace discuss_benef_contact_des = 0 if contact_des == 0 
replace discuss_trip_contact_des = 0 if contact_des == 0 
replace discuss_fins_contact_des = 0 if contact_des == 0 

gen discuss_econ_contact_des = (discuss_wage_contact_des == 1 | ///
	discuss_job_contact_des == 1 | discuss_benef_contact_des == 1 /// 
	| discuss_fins_contact_des == 1) if !missing(discuss_wage_contact_des) & ///
	!missing(discuss_job_contact_des) & !missing(discuss_benef_contact_des) & ///
	!missing(discuss_fins_contact_des)

gen discuss_risk_contact_des = discuss_trip_contact_des

gen discuss_riskecon_contact_des = (discuss_risk_contact_des == 1) & (discuss_econ_contact_des == 1) if !missing(discuss_risk_contact_des) & !missing(discuss_econ_contact_des)

gen discuss_riskorecon_contact_des = (discuss_risk_contact_des == 1) | (discuss_econ_contact_des == 1) if !missing(discuss_risk_contact_des) & !missing(discuss_econ_contact_des)

gen daily_contact_des = (sec10_q9_1 == 1)*contact_des_1 if !missing(sec10_q9_1)
replace daily_contact_des = 1 if sec10_q9_2 == 1 & contact_des_2 == 1

gen weekly_contact_des = (sec10_q9_2 == 1 | sec10_q9_2 == 2)*contact_des_1 if !missing(sec10_q9_1)
replace weekly_contact_des = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2) & contact_des_2 == 1

gen monthly_contact_des = (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3)*contact_des_1 if !missing(sec10_q9_1)
replace monthly_contact_des = 1 if (sec10_q9_2 == 1 | sec10_q9_2 == 2 | sec10_q9_2 == 3) & contact_des_2 == 1


la var discuss_risk_contact_des "Has contacts abroad \& discusses journey w/ them (desired country)"
la var discuss_econ_contact_des "Has contacts abroad \& discusses opportunity abroad w/ them (desired country)"
la var discuss_riskecon_contact_des "Has contacts abroad \& discusses jouney \& opportunity abroad w/ them (desired country)"
la var discuss_riskorecon_contact_des "Has contacts abroad \& discusses jouney OR opportunity abroad w/ them (desired country)"


gen contact_eunodes = contact_eu == 1 & contact_des == 0 if !missing(contact_eu) & !missing(contact_des)




* contact in italy

* code variable for being in italy
gen contact_ita_1 = 0 if sec10_q5_1 != ""
replace contact_ita_1 = 1 if sec10_q5_1 == "ITALY"
replace contact_ita_1 = 0 if contacts_abroad == 0

gen contact_ita_2 = 0 if sec10_q5_2 != ""
replace contact_ita_2 = 1 if sec10_q5_2 == "ITALY"
replace contact_ita_2 = 1 if sec10_q5_2 == "ROMA"
replace contact_ita_2 = 0 if contacts_abroad == 0

gen contact_ita = contact_ita_1
replace contact_ita = 1 if contact_ita_2 == 1


* contact in spain


* code variable for being in eu or switzerland
gen contact_spa_1 = 0 if sec10_q5_1 != ""
replace contact_spa_1 = 1 if sec10_q5_1 == "SPAIN"
replace contact_spa_1 = 0 if contacts_abroad == 0

gen contact_spa_2 = 0 if sec10_q5_2 != ""
replace contact_spa_2 = 1 if sec10_q5_2 == "SPAIN"
replace contact_spa_2 = 1 if sec10_q5_2 == "SPAGNE"
replace contact_spa_2 = 0 if contacts_abroad == 0

gen contact_spa = contact_spa_1
replace contact_spa = 1 if contact_spa_2 == 1


* contact in france

* code variable for being in eu or switzerland
gen contact_fra_1 = 0 if sec10_q5_1 != ""
replace contact_fra_1 = 1 if sec10_q5_1 == "FRANCE"
replace contact_fra_1 = 1 if sec10_q5_1 == "FRANCE  EUROP  ESPACES"
replace contact_fra_1 = 0 if contacts_abroad == 0

gen contact_fra_2 = 0 if sec10_q5_2 != ""
replace contact_fra_2 = 1 if sec10_q5_2 == "FRANCE"
replace contact_fra_2 = 1 if sec10_q5_2 == "FRANCE EUROP ESPACES"
replace contact_fra_2 = 0 if contacts_abroad == 0

gen contact_fra = contact_fra_1
replace contact_fra = 1 if contact_fra_2 == 1

la var contact_ita "Contacts in Italy"
la var contact_spa "Contacts in Spain"
la var contact_fra "Contacts in France"

///////////////////////////////////////////////////////////////////////////
////////////////////   7.1 - WEALTH: DHS DURABLES     ////////////////////
///////////////////////////////////////////////////////////////////////////

gen bank_account = sec7_q6_m == 1 if !missing(sec7_q6_m)
la var bank_account "Bank Account"

gen  radio = sec7_q6_b == 1 if !missing(sec7_q6_b)
la var radio "Radio"

gen  tele = sec7_q6_c == 1 if !missing(sec7_q6_c)
la var tele "Television"

gen  mobile = sec7_q6_d == 1 if !missing(sec7_q6_d)
la var mobile "Mobile"

gen  watch = sec7_q6_f == 1 if !missing(sec7_q6_f)
la var watch "Watch"

gen  car = sec7_q6_g == 1 if !missing(sec7_q6_g)
la var car "Car"

gen  bike = sec7_q6_h == 1 if !missing(sec7_q6_h)
la var bike "Bike"

gen  refrigerator = sec7_q6_i == 1 if !missing(sec7_q6_i)
la var refrigerator "Refrigerator"

gen  fan = sec7_q6_j == 1 if !missing(sec7_q6_j)
la var fan "Fan"

gen  aircond = sec7_q6_k == 1 if !missing(sec7_q6_k)
la var aircond "Air Conditioner"

gen  motorbike = sec7_q6_l == 1 if !missing(sec7_q6_l)
la var motorbike "Motor Bike"

gen tap_in_house = sec7_q4 == 1 if !missing(sec7_q4)
la var tap_in_house "Tap in House"

gen wc_in_house = sec7_q5 == 1 if !missing(sec7_q5)
la var wc_in_house "WC in House"

/*DHS Index*/
*generating the  dummy variables for categorical var (toilet, water)
*notice that it is also possible to split the categories into 3 subgroup : low/medium/high quality
tab sec7_q5 , gen(sec7_q5_n)
tab sec7_q4 , gen(sec7_q4_n)
local component "sec7_q4_n1 sec7_q4_n2 sec7_q4_n3 sec7_q4_n4 sec7_q4_n5 sec7_q4_n6 sec7_q4_n7 sec7_q4_n8 sec7_q4_n9 sec7_q4_n10 sec7_q4_n11 sec7_q4_n12 sec7_q4_n13 sec7_q4_n14 sec7_q5_n1 sec7_q5_n2 sec7_q5_n3 sec7_q5_n4 sec7_q5_n5 sec7_q5_n6 sec7_q5_n7 sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m"

* deleting variable without no variation    
foreach var of local component {
sum `var' if time == 0
}
///>>> ok 

*normalize
foreach var of local component {
qui sum `var'  if time == 0
replace `var'=(`var'-`r(mean)')/`r(sd)'
}

*checking the values of the component
foreach var of local component {
tab `var' if time == 0
}

local component "sec7_q4_n1 sec7_q4_n2 sec7_q4_n3 sec7_q4_n4 sec7_q4_n5 sec7_q4_n6 sec7_q4_n7 sec7_q4_n8 sec7_q4_n9 sec7_q4_n10 sec7_q4_n11 sec7_q4_n12 sec7_q4_n13 sec7_q4_n14 sec7_q5_n1 sec7_q5_n2 sec7_q5_n3 sec7_q5_n4 sec7_q5_n5 sec7_q5_n6 sec7_q5_n7 sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m"

* wealth indicators including all dhs variables
pca `component'  if time == 0, factor(1)
predict wealth_index  if time == 0
label var wealth_index "Wealth index (PCA)"

* wealth indicator only including durables
local durables "sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l"
pca `durables' if time == 0, factor(1)
predict durables  if time == 0
la var durables "Durables index"


///////////////////////////////////////////////////////////////////////////
///////////////////   7.2 - WEALTH: OTHER INDICATORS     ///////////////////
///////////////////////////////////////////////////////////////////////////

* self declared family revenue, construct dummy
qui sum family_revenue, detail
gen family_revenue50 = family_revenue > `r(p50)' if !missing(family_revenue)
* self declared family revenue take asinh
gen asinhfamily_revenue = asinh(family_revenue)

* dhs wealth, construct dummy
qui sum wealth_index, detail
gen wealth_index50 = wealth_index > `r(p50)' if !missing(wealth_index)
label var wealth_index50 "Wealthy"

* dhs durables, construct dummy
qui sum durables, detail
gen durables50 = durables > `r(p50)' if !missing(durables)
la define durables50 0 "Non-Wealthy (Durables)" 1 "Wealthy (Durables)"
la val durables50 durables50
la var durables50 "High Durable Index (PCA)"


qui sum durables, detail
gen durables75 = durables > `r(p75)' if !missing(durables)
la define durables75 0 "Non-Wealthy (Durables)" 1 "Wealthy (Durables)"
la val durables75 durables75
la var durables75 "High Durable Index (PCA)"

qui sum durables, detail
gen durablesavg = durables > `r(mean)' if !missing(durables)
la define durablesavg 0 "Non-Wealthy (Durables)" 1 "Wealthy (Durables)"
la val durablesavg durablesavg
la var durablesavg "High Durable Index (PCA)"

gen durablesnomiss = durables
sum durables if time == 0
replace durablesnomiss = `r(mean)' if durables == . & time == 0
gen durablesmiss = durables == . if time == 0

* define fees indicator taking average of fees to be paid in school
gen fees = (fee_11_a + fee_12_a + fee_Term_a + fee_11_b + fee_12_b + fee_Term_b)/6 if time == 0
* extract median fee value for all schools
preserve
collapse (mean) fees, by(schoolid)
qui sum fees, detail
global feesschoolmedian `r(p50)'
restore
* fees, construct dummy
*gen fees50 = fees > `r(mean)' if !missing(fees)
gen fees50 = fees > $feesschoolmedian if !missing(fees)
la define fees50 0 "Inexpens. Sch." 1 "Expens. Sch."
la val fees50 fees50
la var fees50 "School fees $>$ median"

*gen fees50sch = fees > $feesschoolmedian if !missing(fees)
*la define fees50sch 0 "Inexpens. Sch." 1 "Expens. Sch."
*la val fees50sch fees50sch

* generate nuclear family size to divide family income
gen nucfamily_no = sister_no + brother_no + 1*(moth_alive == 1) + 1*(fath_alive == 1)
la var nucfamily_no "Nuclear family size"
gen familyrev_pc = family_revenue / nucfamily_no
la var familyrev_pc "Revenue per capita in nuclear family"
* generate revenue per capita dummy
qui sum familyrev_pc, detail
gen familyrev_pc50 = familyrev_pc > `r(p50)' if !missing(familyrev_pc)


///////////////////////////////////////////////////////////////////////////
///////////////////   7.3 - INTERNET AND TELEVISION   ///////////////////
///////////////////////////////////////////////////////////////////////////

gen tele_daily =  sec7_q8 == 1
la var tele_daily "Daily television usage"
gen tele_weekless =  sec7_q8 >= 3 & !missing(sec7_q8)
la var tele_weekless "Weekly or less television usage"
gen inter_daily =  sec7_q10 == 1
la var inter_daily "Daily internet usage"
gen inter_weekless =  sec7_q10 >= 3 & !missing(sec7_q10)
la var inter_weekless "Weekly or less internet usage"


///////////////////////////////////////////////////////////////////////////
///////////////////   8 - RISK AND TIME PREFERENCES     ///////////////////
///////////////////////////////////////////////////////////////////////////


gen impat = 0 if !missing(sec6_lottery1)

foreach var of varlist sec6_lottery1-sec6_lottery14 {
	replace impat = impat + (`var' == 1)
}


* leave out question 15: possibly unlcear
gen risklove = 0 if !missing(sec6_lottery16)

foreach var of varlist sec6_lottery16-sec6_lottery30{
	replace risklove = risklove + (`var' == 1)
}


***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   4 - MERGE SCHOOL DATA                       
***_____________________________________________________________________________

* prepare merging with school data
drop dup 
drop _merge
rename key key_end
rename key_p key_end_p
rename sec2_q2_a_p sec2_q2a_p

merge m:1 schoolid using "$main/Data/output/analysis/stratum_by_school.dta"

* label school size
label var school_size "School size"
gen strata_n2 = strata == 1
label var strata_n2 "Big school"

* wrong values for library
replace library = 0 if library == 9

* students' teacher ratio
gen rstudteach_lycee = student_t_lycee/teacher_t_lycee
gen rstudteach = nb_students/nb_teachers
gen rstudteach_win = rstudteach 
qui sum rstudteach if time == 0, de 
replace rstudteach_win = `r(p1)' if rstudteach_win < `r(p1)'
replace rstudteach_win = `r(p99)' if rstudteach_win > `r(p99)'

* students' classes ratio
gen rstudclass_lycee = student_t_lycee/nb_educ_group_lycee
gen rstudclass = nb_students/nb_educ_group
gen rstudclass_win = rstudclass 
qui sum rstudclass if time == 0, de
replace rstudclass_win = `r(p1)' if rstudclass_win < `r(p1)'
replace rstudclass_win = `r(p99)' if rstudclass_win > `r(p99)'

* average classroom size
forval i = 1/51 {
	gen surf_class`i' = surface_room`i' if room`i' == 1 
	gen doort1_`i' = door`i' == 1 if !missing(door`i')
	gen doort2_`i' = door`i' == 2 if !missing(door`i')
	gen doort3_`i' = door`i' == 3 if !missing(door`i')
	gen rooft1_`i' = roof`i' == 1 if !missing(door`i')
	gen rooft2_`i' = roof`i' == 2 if !missing(roof`i')
	gen rooft3_`i' = roof`i' == 3 if !missing(roof`i')
}

ds surf_class*
egen surf_class = rowmean(`r(varlist)') if surf_class1 != .

ds doort1_*
egen doort1 = rowmean(`r(varlist)') if doort1_1 != .
ds doort2_*
egen doort2 = rowmean(`r(varlist)') if doort2_1 != .
ds doort3_*
egen doort3 = rowmean(`r(varlist)') if doort3_1 != .

ds rooft1_*
egen rooft1 = rowmean(`r(varlist)') if rooft1_1 != .
ds rooft2_*
egen rooft2 = rowmean(`r(varlist)') if rooft2_1 != .





* dummy for teacher with master (only for subset of schools)
forval i = 1/115 {
	gen master_t`i' = 1*(degree_t`i' == 2 | degree_t`i' == 3) if degree_t`i' != .
}

* number of teachers with master's degree (only for subset of schools)
ds master_t*
egen nbt_master = rowtotal(`r(varlist)') if master_t1 != .

* ratio of teachers with master's degree (only for subset of schools)
gen ratio_tmaster = nbt_master/nb_teachers

* number of male teachers (only for subset of schools)
gen nbt_male = 0 if gender1 != .
forval i = 1/115 {
	 replace nbt_male = nbt_male + (gender`i' ==  1) if gender`i' != .
	
}

* dummy for teacher with master (only for subset of schools)
forval i = 1/115 {
	gen degree1_`i' = degree_t`i' == 1 if !missing(degree_t`i')
	gen degree2_`i' = degree_t`i' == 2 if !missing(degree_t`i')
	gen degree3_`i' = degree_t`i' == 3 if !missing(degree_t`i')
	gen degree4_`i' = degree_t`i' == 4 if !missing(degree_t`i')
	gen degree5_`i' = degree_t`i' == 5 if !missing(degree_t`i')
	gen degree6_`i' = degree_t`i' == 6 if !missing(degree_t`i')
	gen degree7_`i' = degree_t`i' == 7 if !missing(degree_t`i')
	gen degree8_`i' = degree_t`i' == 8 if !missing(degree_t`i')
	gen degree9_`i' = degree_t`i' == 9 if !missing(degree_t`i')
	gen degree10_`i' = degree_t`i' == 10 if !missing(degree_t`i')

}

ds degree1_*
egen degree1 = rowmean(`r(varlist)') if degree1_1 != .
ds degree2_*
egen degree2 = rowmean(`r(varlist)') if degree2_1 != .
ds degree3_*
egen degree3 = rowmean(`r(varlist)') if degree3_1 != .
ds degree4_*
egen degree4 = rowmean(`r(varlist)') if degree4_1 != .
ds degree5_*
egen degree5 = rowmean(`r(varlist)') if degree5_1 != .
ds degree6_*
egen degree6 = rowmean(`r(varlist)') if degree6_1 != .
ds degree7_*
egen degree7 = rowmean(`r(varlist)') if degree7_1 != .
ds degree8_*
egen degree8 = rowmean(`r(varlist)') if degree8_1 != .
ds degree9_*
egen degree9 = rowmean(`r(varlist)') if degree9_1 != .
ds degree10_*
egen degree10 = rowmean(`r(varlist)') if degree10_1 != .




* female ratio in secondary school
gen ratio_female_second = nb_girls/nb_students

* female ratio in upper secondary school
gen ratio_female_lycee = student_f_lycee/student_t_lycee

* ratio of male teachers (only for subset of schools)
gen ratio_tmale = nbt_male/nb_teachers

* toilettes per student
gen rtoilstud = nb_toilets/nb_students

* computers per student
gen rcompstud = computer/nb_students

* televisions per stu,dent
gen rtelestud = television/nb_students

* rooms per student
gen rroomstud = number_local/nb_students

* printers per student
gen rprinstud = printer/nb_students

* photocopiers per student
gen rphotstud = photocopiers/nb_students

* students per admin staff
gen rstudadmin = nb_students/admin_staff
gen rstudadmin_win = rstudadmin 
qui sum rstudadmin if time == 0, de
replace rstudadmin_win = `r(p1)' if rstudadmin_win < `r(p1)'
replace rstudadmin_win = `r(p99)' if rstudadmin_win > `r(p99)'




la var ratio_female_second "Female students share"
la var ratio_female_lycee "Female students ratio (upper secondary)"
la var rstudteach "Student-teacher ratio"
la var rstudclass "Student-classes ratio"
la var rstudadmin "Student-admin staff ratio"

la var rstudteach_win "Student-teacher ratio (wins.)"
la var rstudclass_win "Student-classes ratio (wins.)"
la var rstudadmin_win "Student-admin staff ratio (wins.)"

la var rtoilstud "Toilets-students ratio"
la var rcompstud "Computers-students ratio"
la var rroomstud "Classrooms-students ratio"
la var rtelestud "Televisions-students ratio"
la var rprinstud "Printers-students ratio"
la var rphotstud "Photocopiers-students ratio"

la var separate_toilets "Separate male/female toilets in sch."
la var library "Library in school"
la var connexion "Internet in school"
la var water "Water in school"
la var infirmary "Infirmary in school"

la var nbt_male "Number of male teachers"
la var ratio_tmale "\% male teachers"
la var nbt_master "Number of teachers w/ master's degree"
la var ratio_tmaster "\% teachers w/ master's degree"

gen aux_n = _n
egen n_inclus = rank(aux_n) if time == 0, by(schoolid) unique
drop aux_n

global schoolinf_list "surf_class rroomstud rtoilstud rtelestud rcompstud rprinstud rphotstud connexion library infirmary water separate_toilets doort1 doort2 doort3 rooft1 rooft2"

qui pca $schoolinf_list if time == 0 & n_inclus == 1, factor(1)
predict schoolinf_index if time == 0 & n_inclus == 1
qui sum schoolinf_index
replace schoolinf_index = (schoolinf_index - `r(mean)')/`r(sd)'
la var schoolinf_index "School Infrastracture Index (PCA)"

* repeaters
destring male_repeaters, force replace
destring female_repeaters, force replace
gen repeaters = female_repeaters + male_repeaters
la var repeaters "Repeating students"

* transfers
destring female_transfers, force replace
destring male_transfers, force replace
gen transfers =  female_transfers + male_transfers
la var transfers "Transfer students"
	

***ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
***   5 - SAVING FINAL DATASET                            
***_____________________________________________________________________________


la define treatment_factor 1 "Control" 2 "Risk T." 3 "Econ. T." 4 "Double T."
la val treatment_status treatment_factor

* bundled treatments
gen risk_info = treatment_status == 2 | treatment_status == 4
gen econ_info = treatment_status > 2

*Auxiliary variables for fwer.
gen sid = schoolid
drop treated_dummy1
tab treatment_status, gen(treated_dummy)
global treatment_dummies " treated_dummy2 treated_dummy3 treated_dummy4 "
gen trtmnt = .
local n_rep 1

*replace participation data with self declared in schools where we had no participation
gen participation_aux = participation
replace participation_aux = partb_participation if participation_aux == . & time == 0


* sensibilization
gen attended_tr = .
replace attended_tr = 1 if attended_tr == . & participation_aux == 0
replace attended_tr = 1 if attended_tr == . & treatment_status == 1
replace attended_tr = 2 if attended_tr == . & participation_aux == 1 & treatment_status == 2
replace attended_tr = 3 if attended_tr == . & participation_aux == 1 & treatment_status == 3
replace attended_tr = 4 if attended_tr == . & participation_aux == 1 & treatment_status == 4
la define attended_tr 1 "Did not attend sensibilization" ///
	2 "Attend. Risk T." ///
	3 "Attend. Economic T." ///
	4 "Attend. Double T."
la val attended_tr attended_tr
la var attended_tr "Attended Treatment"
gen attended_any = -(attended_tr == 1) + 1
la var attended_any "Attended any treatment"

*drops students interviewed below age limit
drop if classe_baseline < 5

gen diff_risk_index = italy_index - spain_index
gen diff_asinh_duration_winsor = asinhitaly_duration_winsor - asinhspain_duration_winsor
gen diff_asinh_journey_cost_winsor = asinhitaly_journey_cost_winsor - asinhspain_journey_cost_winsor
gen diff_beaten = italy_beaten - spain_beaten
gen diff_forced_work = italy_forced_work - spain_forced_work
gen diff_kidnapped = italy_kidnapped - spain_kidnapped
gen diff_die_bef_boat = italy_die_bef_boat - spain_die_bef_boat
gen diff_die_boat = italy_die_boat - spain_die_boat
gen diff_sent_back = italy_sent_back - spain_sent_back
gen diff_risk_index_nocost = italy_index_nocost - spain_index_nocost

gen desired_fra = desired_country == 11
gen desired_ita = desired_country == 16
gen desired_spa = desired_country == 10

gen desired_country_oth = desired_country
replace desired_country_oth = 0 if (desired_country_oth != 4)&(desired_country_oth != 7)&(desired_country_oth != 10)&(desired_country_oth != 11)&(desired_country_oth != 12)&(desired_country_oth != 16)

gen diff_cost_winsor = italy_journey_cost_winsor-spain_journey_cost_winsor
gen expwage = finding_job*asinhexpectation_wage_winsor

replace sell_asset = 0 if sell_asset == 2

*sum italy_journey_cost if time == 0,de
gen sell_asset100 = sell_asset*(money_from_asset > `change'*100) if time == 1
gen sell_asset200 = sell_asset*(money_from_asset > `change'*200) if time == 1
gen sell_asset300 = sell_asset*(money_from_asset > `change'*300) if time == 1
gen sell_asset400 = sell_asset*(money_from_asset > `change'*400) if time == 1
gen sell_asset500 = sell_asset*(money_from_asset > `change'*500) if time == 1

gen mig_asset100 = sell_asset100
replace mig_asset100 = 0 if mig_asset==2 & time == 1
gen mig_asset200 = sell_asset200
replace mig_asset200 = 0 if mig_asset==2 & time == 1
gen mig_asset300 = sell_asset300
replace mig_asset300 = 0 if mig_asset==2 & time == 1
gen mig_asset400 = sell_asset400
replace mig_asset400 = 0 if mig_asset==2 & time == 1
gen mig_asset500 = sell_asset500
replace mig_asset500 = 0 if mig_asset==2 & time == 1


la define desired_country_oth 4 "Belgium" 7 "Germany" 10 "Spain" 11 "France" 12 "UK" 16 "Italy" 0 "Other"
la val desired_country_oth desired_country_oth	


gen asinhmrisk_duration_winsor = (asinhitaly_duration_winsor + asinhspain_duration_winsor)/2
gen asinhmrisk_journey_cost_winsor = (asinhitaly_journey_cost_winsor + asinhspain_journey_cost_winsor)/2
gen mrisk_beaten = (italy_beaten + spain_beaten)/2
gen mrisk_forced_work = (italy_forced_work + spain_forced_work)/2
gen mrisk_kidnapped = (italy_kidnapped + spain_kidnapped)/2
gen mrisk_die_bef_boat = (italy_die_bef_boat + spain_die_bef_boat)/2
gen mrisk_die_boat = (italy_die_boat + spain_die_boat)/2
gen mrisk_sent_back = (italy_sent_back + spain_sent_back)/2
gen mrisk_index = (italy_index + spain_index)/2
gen mrisk_kling_negcost = (italy_kling_negcost + italy_kling_negcost)/2
gen mrisk_kling_poscost = (italy_kling_poscost + spain_kling_poscost)/2

la var mrisk_index "Risk beliefs (PCA)"

*construct risk perceptions for chosen route

gen asinhcrisk_duration_winsor = asinhitaly_duration_winsor*route_chosen + asinhspain_duration_winsor*(1-route_chosen)
gen asinhcrisk_journey_cost_winsor = asinhitaly_journey_cost_winsor*route_chosen + asinhspain_journey_cost_winsor*(1-route_chosen)
gen crisk_beaten = italy_beaten*route_chosen + spain_beaten*(1-route_chosen)
gen crisk_forced_work = italy_forced_work*route_chosen + spain_forced_work*(1-route_chosen)
gen crisk_kidnapped = italy_kidnapped*route_chosen + spain_kidnapped*(1-route_chosen)
gen crisk_die_bef_boat = italy_die_bef_boat*route_chosen + spain_die_bef_boat*(1-route_chosen)
gen crisk_die_boat = italy_die_boat*route_chosen + spain_die_boat*(1-route_chosen)
gen crisk_sent_back = italy_sent_back*route_chosen + spain_sent_back*(1-route_chosen)
gen crisk_kling_negcost = italy_kling_negcost*route_chosen + italy_kling_negcost*(1-route_chosen)
gen crisk_kling_poscost = italy_kling_poscost*route_chosen + spain_kling_poscost*(1-route_chosen)



global crisk_outcomes = " asinhcrisk_duration_winsor" ///
					+ " asinhcrisk_journey_cost_winsor" ///
					+ " crisk_beaten" ///
					+ " crisk_forced_work" ///
					+ " crisk_kidnapped " ///
					+ " crisk_die_bef_boat " ///
					+ " crisk_die_boat " ///
					+ " crisk_sent_back "

qui pca $crisk_outcomes if time == 0, factor(1)
predict crisk_index

la var crisk_index "Risk beliefs (PCA)"



gen partb_q11_a_inv = 6 - partb_q11_a
global trans_debate "partb_q11_a_inv partb_q11_b partb_q11_c"
qui pca $trans_debate if time == 1, factor(1)
predict trans_debate

gen partb_q11_f_inv = 6 - partb_q11_f
global trans_video "partb_q11_f_inv partb_q11_g partb_q11_h"
qui pca $trans_video if time == 1, factor(1)
predict trans_video

global ident_video "partb_q11_j partb_q11_k partb_q11_l partb_q11_m"
qui pca $ident_video if time == 1, factor(1)
predict ident_video

drop _merge


/*
*export file with coordinates

*school distances
keep if time == 0
keep longitude latitude treatment_status lycee_name student_t_lycee
duplicates drop lycee_name, force
drop if lycee_name == .
export delimited using "${main}/Data/output/followup2/coordinates.csv", replace nolabel

*import file with distances
import delimited "${main}/Data/output/followup2/coordinates_spillover.csv", clear 
drop v1 student_t_lycee treatment_status latitude longitude
*export as dta
save "${main}/Data/output/followup2/coordinates_spillover.dta", replace
*/

*merge file with distances
merge m:1 lycee_name using "${main}/Data/output/followup2/coordinates_spillover.dta"

*label distance variables

la var ratio2_0_2 "\% students in T1 within 0-2km"
la var ratio2_0_25 "\% students in T1 within 0-2.5km"
la var ratio2_0_5 "\% students in T1 within 0-5km"
la var ratio2_0_75 "\% students in T1 within 0-7.5km"
la var ratio2_2_4 "\% students in T1 within 2-4km"
la var ratio2_25_5 "\% students in T1 within 2.5-5km"
la var ratio2_5_10 "\% students in T1 within 5-10km"
la var ratio2_75_15 "\% students in T1 within 7.5-15km"
la var ratio3_0_2 "\% students in T2 within 0-2km"
la var ratio3_0_25 "\% students in T2 within 0-2.5km"
la var ratio3_0_5 "\% students in T2 within 0-5km"
la var ratio3_0_75 "\% students in T2 within 0-7.5km"
la var ratio3_2_4 "\% students in T2 within 2-4km"
la var ratio3_25_5 "\% students in T2 within 2.5-5km"
la var ratio3_5_10 "\% students in T2 within 5-10km"
la var ratio3_75_15 "\% students in T2 within 7.5-15km"
la var ratio4_0_2 "\% students in T3 within 0-2km"
la var ratio4_0_25 "\% students in T3 within 0-2.5km"
la var ratio4_0_5 "\% students in T3 within 0-5km"
la var ratio4_0_75 "\% students in T3 within 0-7.5km"
la var ratio3_2_4 "\% students in T2 within 2-4km"
la var ratio4_25_5 "\% students in T3 within 2.5-5km"
la var ratio4_5_10 "\% students in T3 within 5-10km"
la var ratio4_75_15 "\% students in T3 within 7.5-15km"
la var stud_0_2 "\# students within 0-2km"
la var stud_0_25 "\# students within 0-2.5km"
la var stud_0_5 "\# students within 0-5km"
la var stud_0_75 "\# students within 0-7.5km"
la var stud_2_4 "\# students within 2-4km"
la var stud_25_5 "\# students within 2.5-5km"
la var stud_5_10 "\# students within 5-10km"
la var stud_75_15 "\# students within 7.5-15km"

*save "${main}\Data\output\followup2\BME_final", replace
save "${main}/Data/output/followup2/BME_final", replace







gen right1 = sec5_q1 == 1
gen right2 = sec5_q1 == 2
gen right3 = sec5_q1 == 2
gen right4 = sec5_q1 == 1
gen right5 = sec5_q1 == 1
gen right6 = sec5_q1 == 1


global tof_outcomes = "right1 " ///
					+ " right2  " ///
					+ " right3 " ///
					+ " right4 " ///
					+ " right5 " ///
					+ " right6 " ///

local n_outcomes `: word count $tof_outcomes'


gen tof_kling = 0

local n_kling = 1


foreach y in $tof_outcomes {
	qui sum `y' if time == 0, detail
	replace tof_kling =  tof_kling + (1/`n_outcomes')*(`y' - `r(mean)')/`r(sd)'
	local `n_kling' = `n_kling' + 1
	}
	

qui sum tof_kling if time == 0, de
gen tof_kling50 = tof_kling > `r(p50)'

* create pca
qui pca $tof_outcomes if time == 0, factor(1)
predict tof_index
qui sum tof_index if time == 0, de
gen tof_index50 = tof_index > `r(p50)'
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

*

clear

use "${main}/Data/output/followup2/BME_final",

preserve
keep id_number time
duplicates drop id_number time, force
drop if time == 2
expand 2, gen(cont)
save "${main}/Data/output/followup2/contacts_data", replace
restore

forval i=1/19 {
	preserve
	keep sec10_q`i'_* id_number time
	reshape long sec10_q`i'_, i(id_number time) j(cont)
	merge 1:1 id_number time cont using "${main}/Data/output/followup2/contacts_data"
	drop _merge
	save "${main}/Data/output/followup2/contacts_data", replace
	restore
}

preserve
keep contact_eu_* id_number time
reshape long contact_eu_, i(id_number time) j(cont)
merge 1:1 id_number time cont using "${main}/Data/output/followup2/contacts_data"
drop _merge

* assumiamo che i dk per i disoccupati == 0? nel caso aggiungere 
*| (sec10_q7_ != 1 & sec10_q7_ != 10 & sec10_q7_ != . & sec10_q7_ != 99 & sec10_q8_ != 99) | sec10_q7_ == 11

* code variable for wage of contacts in the eu (money)
*(sec10_q8_ != . & sec10_q8_ != 99) | (sec10_q7_ != 1 & sec10_q7_ != 10 & sec10_q7_ != 11 & sec10_q7_ != .)
gen wage_more0_c = 0 if (sec10_q8_ != . & sec10_q8_ != 99) 
replace wage_more0_c = 1 if (sec10_q8_ == 1 | sec10_q8_ == 2 | sec10_q8_ == 3 | sec10_q8_ == 4 | sec10_q8_ == 5 | sec10_q8_ == 6)

gen wage_more1m_c = 0 if (sec10_q8_ != . & sec10_q8_ != 99) 
replace wage_more1m_c = 1 if (sec10_q8_ == 2 | sec10_q8_ == 3 | sec10_q8_ == 4 | sec10_q8_ == 5 | sec10_q8_ == 6)

gen wage_more2_5m_c = 0 if (sec10_q8_ != . & sec10_q8_ != 99)
replace wage_more2_5m_c = 1 if (sec10_q8_ == 3 | sec10_q8_ == 4 | sec10_q8_ == 5 | sec10_q8_ == 6)

gen wage_more5m_c = 0 if (sec10_q8_ != . & sec10_q8_ != 99)
replace wage_more5m_c = 1 if (sec10_q8_ == 4 | sec10_q8_ == 5 | sec10_q8_ == 6)

gen wage_more10m_c = 0 if (sec10_q8_ != . & sec10_q8_ != 99) 
replace wage_more10m_c = 1 if (sec10_q8_ == 5 | sec10_q8_ == 6)

gen wage_more20m_c = 0 if (sec10_q8_ != . & sec10_q8_ != 99) 
replace wage_more20m_c = 1 if (sec10_q8_ == 6)

*RIVEDERE QUESTO
gen wage_dk_c = 0 if (sec10_q8_ != . & sec10_q8_ != 99)
replace wage_dk_c = 1 if (sec10_q8_ == 99)



* code variable for contacts sending remittances from the eu

gen remittances_1wee_c = 0 if sec10_q16_ != . & sec10_q16_ != 99
replace remittances_1wee_c = 1 if (sec10_q16_ == 1)

gen remittances_1mon_c = 0 if sec10_q16_ != . & sec10_q16_ != 99
replace remittances_1mon_c = 1 if (sec10_q16_ == 1 | sec10_q16_ == 2)

gen remittances_3mon_c = 0 if sec10_q16_ != . & sec10_q16_ != 99
replace remittances_3mon_c = 1 if (sec10_q16_ == 1 | sec10_q16_ == 2 | sec10_q16_ == 3)

gen remittances_6mon_c = 0 if sec10_q16_ != . & sec10_q16_ != 99
replace remittances_6mon_c = 1 if (sec10_q16_ == 1 | sec10_q16_ == 2 | sec10_q16_ == 3 | sec10_q16_ == 4)

gen remittances_1y_c = 0 if sec10_q16_ != . & sec10_q16_ != 99
replace remittances_1y_c = 1 if (sec10_q16_ == 1 | sec10_q16_ == 2 | sec10_q16_ == 3 | sec10_q16_ == 4 | sec10_q16_ == 5)

gen remittances_c = 0 if sec10_q16_ != . & sec10_q16_ != 99
replace remittances_c = 1 if (sec10_q16_ == 1 | sec10_q16_ == 2 | sec10_q16_ == 3 | sec10_q16_ == 4 | sec10_q16_ == 5 | sec10_q16_ == 6)

gen remittances_dk_c = 0 if sec10_q16_ != . & sec10_q16_ != 99
replace remittances_dk_c = 1 if (sec10_q16_ == 99)


* code variable for contacts sending remittances from the eu (money)

*sec10_q16_ != . & sec10_q16_ != 99 & sec10_q17_ != 99
gen remittances_more0_c = 0 if sec10_q17_ != . & sec10_q17_ != 99
replace remittances_more0_c = 1 if (sec10_q17_ == 1 | sec10_q17_ == 2 | sec10_q17_ == 3 | sec10_q17_ == 4 | sec10_q17_ == 5 | sec10_q17_ == 6) & sec10_q17_ != 99

gen remittances_more1m_c = 0 if sec10_q17_ != . & sec10_q17_ != 99
replace remittances_more1m_c = 1 if (sec10_q17_ == 2 | sec10_q17_ == 3 | sec10_q17_ == 4 | sec10_q17_ == 5 | sec10_q17_ == 6) & sec10_q17_ != 99

gen remittances_more2_5m_c = 0 if sec10_q17_ != . & sec10_q17_ != 99
replace remittances_more2_5m_c = 1 if (sec10_q17_ == 3 | sec10_q17_ == 4 | sec10_q17_ == 5 | sec10_q17_ == 6) & sec10_q17_ != 99

gen remittances_more5m_c = 0 if sec10_q17_ != . & sec10_q17_ != 99
replace remittances_more5m_c = 1 if (sec10_q17_ == 4 | sec10_q17_ == 5 | sec10_q17_ == 6) & sec10_q17_ != 99

gen remittances_more10m_c = 0 if sec10_q17_ != . & sec10_q17_ != 99
replace remittances_more10m_c = 1 if (sec10_q17_ == 5 | sec10_q17_ == 6) & sec10_q17_ != 99

gen remittances_more20m_c = 0 if sec10_q17_ != . & sec10_q17_ != 99
replace remittances_more20m_c = 1 if (sec10_q17_ == 6) & sec10_q17_ != 99

*gen remittances_dk_q_c = remittances_dk
*replace remittances_dk_q_c = 1 if (sec10_q17_ == 99)

*replace remittances_eu = 2 if sec10_q17_2 == 99


save "${main}/Data/output/followup2/contacts_data", replace
restore

use ${main}/Data/output/followup2/BME_final.dta, clear
drop _merge
merge 1:m id_number time using "${main}/Data/output/followup2/contacts_data"

tostring cont, gen(cont_str)
gen idcont_number_str = id_number_str + "0000" + cont_str
destring idcont_number_str, gen(idcont_number)

* clean age for contacts
gen agecontnomiss = sec10_q4_
replace agecontnomiss = . if agecontnomiss >= 99
sum agecontnomiss if time == 0, de
replace agecontnomiss = `r(mean)' if agecontnomiss == . & sec10_q4_ != .
gen agecontmiss = agecontnomiss >= 99 if sec10_q4_ != .

tsset idcont_number time

rename contact_eu_ contact_eu_c

* control for lagged remittances frequency

egen maxremittances_c = max(remittances_c*contact_eu_c), by(id_number time)
replace maxremittances_c = 0 if missing(maxremittances_c) & !missing(f.remittances_c) & f.contact_eu_c == 1

gen maxremittances_fmissing = 0 if f.remittances_c !=.
replace maxremittances_fmissing = 1 if f.remittances_c !=. & maxremittances_c ==.

egen maxremittances_1y_c = max(remittances_1y_c*contact_eu_c), by(id_number time)
replace maxremittances_1y_c = 0 if missing(maxremittances_1y_c) & !missing(f.remittances_c) & f.contact_eu_c == 1

egen maxremittances_6mon_c = max(remittances_6mon_c*contact_eu_c), by(id_number time)
replace maxremittances_6mon_c = 0 if missing(maxremittances_6mon_c) & !missing(f.remittances_c) & f.contact_eu_c == 1

egen maxremittances_3mon_c = max(remittances_3mon_c*contact_eu_c), by(id_number time)
replace maxremittances_3mon_c = 0 if missing(maxremittances_3mon_c) & !missing(f.remittances_c) & f.contact_eu_c == 1

egen maxremittances_1mon_c = max(remittances_1mon_c*contact_eu_c), by(id_number time)
replace maxremittances_1mon_c = 0 if missing(maxremittances_1mon_c) & !missing(f.remittances_c) & f.contact_eu_c == 1

egen maxremittances_1wee_c = max(remittances_1wee_c*contact_eu_c), by(id_number time)
replace maxremittances_1wee_c = 0 if missing(maxremittances_1wee_c) & !missing(f.remittances_c) & f.contact_eu_c == 1


* control for lagged wages

egen maxwage_more1m_c = max(wage_more1m_c*contact_eu_c), by(id_number time)
replace maxwage_more1m_c = 0 if missing(maxwage_more1m_c) & !missing(f.wage_more1m_c) & f.contact_eu_c == 1

gen maxwage_missing = 0 if f.wage_more1m_c !=.
replace maxwage_missing = 1 if f.wage_more1m_c !=. & maxwage_more1m_c ==.

egen maxwage_more2_5m_c = max(wage_more2_5m_c*contact_eu_c), by(id_number time)
replace maxwage_more2_5m_c = 0 if missing(maxwage_more2_5m_c) & !missing(f.wage_more2_5m_c) & f.contact_eu_c == 1

egen maxwage_more5m_c = max(wage_more5m_c*contact_eu_c), by(id_number time)
replace maxwage_more5m_c = 0 if missing(maxwage_more5m_c) & !missing(f.wage_more5m_c) & f.contact_eu_c == 1

egen maxwage_more10m_c = max(wage_more10m_c*contact_eu_c), by(id_number time)
replace maxwage_more10m_c = 0 if missing(maxwage_more10m_c) & !missing(f.wage_more2_5m_c) & f.contact_eu_c == 1

egen maxwage_more20m_c = max(wage_more20m_c*contact_eu_c), by(id_number time)
replace maxwage_more20m_c = 0 if missing(maxwage_more20m_c) & !missing(f.wage_more2_5m_c) & f.contact_eu_c == 1



replace remittances_more1m_c  = 0 if remittances_c == 0
replace remittances_more2_5m_c  = 0 if remittances_c == 0
replace remittances_more5m_c  = 0 if remittances_c == 0
replace remittances_more10m_c  = 0 if remittances_c == 0
replace remittances_more20m_c  = 0 if remittances_c == 0

egen maxremittances_more1m_c = max(remittances_more1m_c*contact_eu_c), by(id_number time)
replace maxremittances_more1m_c = 0 if missing(maxremittances_more1m_c) & !missing(f.remittances_more1m_c) & f.contact_eu_c == 1

gen maxremittances_qmissing = 0 if f.remittances_more1m_c !=.
replace maxremittances_qmissing = 1 if f.remittances_more1m_c !=. & maxremittances_more1m_c ==.

egen maxremittances_more2_5m_c = max(remittances_more2_5m_c*contact_eu_c), by(id_number time)
replace maxremittances_more2_5m_c = 0 if missing(maxremittances_more2_5m_c) & !missing(f.remittances_more2_5m_c) & f.contact_eu_c == 1

egen maxremittances_more5m_c = max(remittances_more5m_c*contact_eu_c), by(id_number time)
replace maxremittances_more5m_c = 0 if missing(maxremittances_more5m_c) & !missing(f.remittances_more5m_c) & f.contact_eu_c == 1

egen maxremittances_more10m_c = max(remittances_more10m_c*contact_eu_c), by(id_number time)
replace maxremittances_more10m_c = 0 if missing(maxremittances_more10m_c) & !missing(f.remittances_more10m_c) & f.contact_eu_c == 1

egen maxremittances_more20m_c = max(remittances_more20m_c*contact_eu_c), by(id_number time)
replace maxremittances_more20m_c = 0 if missing(maxremittances_more20m_c) & !missing(f.remittances_more20m_c) & f.contact_eu_c == 1


save "${main}/Data/output/followup2/contacts_data", replace







