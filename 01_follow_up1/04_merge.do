/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (G.Battiston, L. Corno, E. La Ferrara)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITLE      :    03 - MERGING BASELINE MIDLINE
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/

/*03_merge
Date Created:  May 24, 2019
Date Last Modified: May 24, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: 
*   Outputs : "$main\Data\output\analysis\guinea_final_dataset.dta"

*/



* initialize Stata
clear all
set more off
set mem 100m


*Cloe user
*global user "C:\Users\cloes_000"
*global main "$user\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"




********************************************************************************
//,\\'// 01 -   MERGING ADMIN/BASELINE DATA AND IDENTIFICATION DATABASE  '//,\\'
********************************************************************************


***   a. - merging midline surveys, admin data and identification database                                             
***_____________________________________________________________________________

* merging admin data and identification database
use "$main/Data/output/admin/admin_data.dta", clear
rename CODE schoolid
merge 1:m schoolid using "$main/Data/output/baseline/identification.dta"
/*   Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                             7,399  (_merge==3)
    -----------------------------------------
*/
drop _merge sec0_q1_a_baseline sec0_q1_b_baseline
rename key key_base
tempfile admin
save `admin'



*merging admin_id and participation
import excel "$main/Data/raw/midline/participation_elv.xlsx", firstrow clear
keep participation key tel2
rename key key_base
rename participation participation_elv
tempfile participation
save `participation'
merge 1:1 key_base using "`admin'"
 /*   Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                             7,399  (_merge==3)
    -----------------------------------------
*/

drop _merge
tempfile admin_id
save `admin_id'



*merging midline data and the identification dataset
use "$main/Data/output/midline/questionnaire_midline_clean.dta",clear
rename key key_mid
destring id_number,replace
merge 1:1 id_number using  "`admin_id'"

 /*   Result                           # of obs.
    -----------------------------------------
    not matched                         2,926
        from master                        7  (_merge==1)
        from using                      2,919  (_merge==2)

    matched                             4,480  (_merge==3)
    -----------------------------------------
_merge=2 corresponded to people that did not participate to the midline survey
_merge==1 are the 7 students with an wrong id_number and that do not answer to our calls !!
*/

keep if _merge==3 | _merge==1
drop _merge

gen time=1 // in order to specify that those are MIDLINE data

tempfile admin_midline
save `admin_midline'



***   b. - Appending the baseline questionnaires                                            
***_____________________________________________________________________________
use "$main/Data/output/baseline/questionnaire_baseline_clean_rigourous_cleaning.dta", clear
rename key key_base

merge m:1 key_base using "`admin_id'"


/*
    Result                           # of obs.
    -----------------------------------------
    not matched                            12
        from master                         0  (_merge==1)
        from using                         12  (_merge==2)

    matched                             7,387  (_merge==3)
    -----------------------------------------

_merge==1 the 12 questionnaires that I have deleted in the baseline dataset 
after checking the duplicates in details (see the dofile 03_id_correction)
*/
keep if _merge==3
drop _merge
gen time=0 // in order to specify that those are baseline data


* appending
append using "`admin_midline'"
tempfile base_midline
save `base_midline'




***   c. - merge with the two datasets related to logistics and  coordinates                                           
***_____________________________________________________________________________

import excel "$main/Data/raw/lycee_conakry.xlsx", firstrow clear
drop if N==.
tempfile lycee_conakry
save `lycee_conakry'


import excel "$main/Data/raw/sensi_mid_planning.xlsx", firstrow clear
drop if schoolid==.
drop treatment_status
tempfile planning
save `planning'


use "`base_midline'"
merge m:1 N using "`lycee_conakry'",force
/*
				  Result                           # of obs.
    -----------------------------------------
    not matched                           177
        from master                         7  (_merge==1)
        from using                        170  (_merge==2)

    matched                             11,867  (_merge==3)
    -----------------------------------------

_merge==2 are the non selected schools
_merge==1 are the 7 students with an wrong id_number and that do not answer to our calls !!
*/

keep if _merge==3 | _merge==1
drop _merge


merge m:1 schoolid using "`planning'", force
/*Result                           # of obs.
    -----------------------------------------
    not matched                             7
        from master                         7  (_merge==1)
        from using                          0  (_merge==2)

    matched                            11,910  (_merge==3)
    -----------------------------------------
_merge==1 are the 7 students with an wrong id_number and that do not answer to our calls !!
*/
keep if _merge==3 | _merge==1
drop _merge

tempfile final
save `final'





********************************************************************************
//,\\'//          03 -   CORRECTION FROM THE SENSIBILISATION           //'//,\\'//,\\'
********************************************************************************
/*this corresponds to mistakes in names, familly names, grades that we detected
during the sensibilisation and the midline survey*/

import excel "$main/Data/correction_file/correction_sensi/sensi_error_name.xlsx", clear firstrow
tempfile sensi_error
save `sensi_error'

import excel "$main/Data/correction_file/correction_midline/mid_student_error.xlsx", clear firstrow
tempfile mid_error
save `mid_error'

use "`final'", clear
readreplace using "`sensi_error'", use id(key_base) variable(fieldname) value(values)
readreplace using "`mid_error'", use id(id_number) variable(fieldname) value(values)



********************************************************************************
//,\\'//          04 -   PREPARING THE FINAL DATA SET           //'//,\\'//,\\'
********************************************************************************


***   a. - Dropping useless information                                       
***_____________________________________________________________________________

drop instanceID N etab_quest schoolid id_elv id_elv_str lycee_name consent_agree setofrandom_draws deviceid subscriberid simid devicephonenum formdef_version consent_agree
drop gs NOM_ETABLISSEMENT etab priv fa eng expected_participation_rate living_cost sec6_lottery_risk sec6_lottery_time sec7_index sec7_q9_bis sec8_q4_bis sec8_q5_bis pilot expat_schools college_only



***   b. - labelling somes variables                                     
***_____________________________________________________________________________

label var time "Before or after the sensibilisation"
label var schoolid_str "Identification number of the school"
label var id_number "Student ID"
label var id_number_str "Identification number of the student string"

rename lycee_name_string lycee_name_str
label var lycee_name_str "High school name"

label var sec2_q4_bis "Cleaned sec2_q4"

label var participation_elv "Participation status from the attendance sheet"
label var participation "Participation status from the questionnaire"




***   c. - cleaning                                 
***_____________________________________________________________________________


foreach x in sec2_q2 sec3_21 sec2_q5 sec10_q5_1 sec10_q5_2{
replace `x'=upper(`x')
replace `x'=trim(`x')
replace `x'="" if `x'=="," |`x'=="NIAN" | `x'=="J'IGNORE" | `x'=="8" | `x'=="UUU" |`x'=="THIERNO MARINA SOW" |`x'=="SDIMA" |`x'=="SANKOUMBA" |`x'=="SANA" |`x'=="S SANTIGUI TOURE" |`x'=="ROI" |`x'=="NDEYE DIALLO" |`x'=="MOUSSA" |`x'=="HAFIA" |`x'=="GAJA" |`x'=="FODE MOUSSA BERETE"
replace `x'="" if `x'=="TTHHJ" |`x'=="EN" |`x'=="CONA" |`x'=="CHEICK" |`x'=="BOUBA" | `x'=="BOH SARAN" |`x'=="BALDE" |`x'=="BADEMBA" |`x'=="YOUNONSSA" |`x'=="YARIE" |`x'=="TY" |`x'=="THIERNO BAH" |`x'=="TONTON PAPA" |`x'=="TAMBOUR MORY KAMANO" |`x'=="TAIBOU BAH" |`x'=="S√®" |`x'=="SYLLA" |`x'=="SOS" |`x'=="SILLO KAMONO" |`x'=="SIGURI" |`x'=="SIDIKI" |`x'=="SA√ØDOU" |`x'=="SARAH TOURE" | `x'=="SANNY CAMARA OU VERRETY" | `x'=="SALIOU"
replace `x'="" if `x'=="MARIAME" |`x'=="MAMADOU LAMINE DIALLO" | `x'=="MAMADOU LAMARANA" |`x'=="KORKA" |`x'=="KALIL CAMARA" |`x'=="KADIZA" |`x'=="JOAO MIGUEL" |`x'=="AIMé SIDIBE" |  `x'=="SABANA" | `x'=="PAR" |`x'=="PAPA" |`x'=="OUSMANE KEITA" | `x'=="OUSMANE" | `x'=="N'ZEREKORE" | `x'=="N'ASSURE BERETE" | `x'=="MOUSTAPHA" |`x'=="MOHAMED SANOUSSI CAMARA" |`x'=="MOHAMED CONDE" |`x'=="MILéN" |`x'=="MARIE LOUISE CAMARA"
replace `x'="" if `x'=="MARIE" |`x'=="MARIE" |`x'=="MARIAMA" |`x'=="MARCEILLE" |`x'=="MAMAN" |`x'=="MAMADOU SOW" |`x'=="MAMADOU DIAN" |`x'=="MAMADOU" |`x'=="MAMADI" |`x'=="MAMADAMA" | `x'=="MADOU TOURE"
replace `x'="" if  `x'=="√âTUDIANTS" | `x'=="MAROMAC" | `x'=="BEN" |`x'=="MA BOSSOIR CAMARA" | `x'=="LIMA KEITA" | `x'=="LERO" |`x'=="KONGUEL" | `x'=="KANABA" | `x'=="KALOU" |`x'=="JOSé DA GAMA" | `x'=="IBRAHIMA  DIALLO" | `x'=="INTERNET" |`x'=="IBRAHIMA KENNEDY BAH" |`x'=="IBRAHIMA DIALLO" | `x'=="IBRAHIMA CAMARA" |`x'=="HABIB BALDE" | `x'=="GOMBO" |`x'=="FODé SYLLA" |`x'=="FATOUMATA MANSARE" | `x'=="GGUI" |`x'=="FANTA" |`x'=="EN GUINéE 625812444" |`x'=="DéDé" 
replace `x'="" if `x'=="DJEDA" |`x'=="DJADA" |`x'=="DABY" |`x'=="CONTé" |`x'=="CONCON" |`x'=="CISSé" |`x'=="CON" |`x'=="CAMARA" |`x'=="BECKAYE NIANE" | `x'=="BARRY" | `x'=="BANKOKE" | `x'=="BANJUL" |`x'=="BAH" | `x'=="A√ØCHA" | `x'=="ANYER"
replace `x'="" if `x'=="JE" | `x'=="VANNE" |`x'=="OUMAR" |`x'=="O" |`x'=="AMINATA TRAORE" |`x'=="AMARA" |`x'=="AMADOU" |`x'=="AMA" |`x'=="ALIOU" |`x'=="ALIMOUDIAWBHE BALDE" |`x'=="ALHASSANE KOUMBASSA" | `x'=="ABJA" | `x'=="ABDOURAHIM" |`x'=="ABDOULAYE CONTE" |`x'=="A CON" |`x'=="NOM" |`x'=="HABA" |`x'=="AMRE" | `x'=="JUIVE" |`x'=="RIEN" |`x'=="99" |`x'=="NON" |`x'=="AUTRE" |`x'=="U.A" | `x'=="SIMONE" |`x'=="POUR PRATIQUE LE SPORT"
replace `x'="" if  `x'=="ILS Y 'A DES PAYS DE  AFRIQUE" | `x'=="CR7" | `x'=="OUI" | `x'=="JUIF" |`x'=="G" |`x'=="1" | `x'=="12 .0000" | `x'=="2HM" | `x'=="AMRAO" | `x'=="MIROITANT" | `x'=="MOHAMED LAMINE"
replace `x'="" if `x'=="ICI" | `x'=="0" | `x'=="√?TUDIANTS" | `x'=="6" |`x'=="622113643" |`x'=="622969364" | `x'=="623456789" | `x'=="62354325" | `x'=="9177743205" | `x'=="999" 
replace `x'="" if `x'=="661548243" |`x'=="654816996" | `x'=="627167573" | `x'=="621975713" | `x'=="620792565" | `x'=="22564548217" | `x'=="00226" |`x'=="0032488021127"| `x'=="999999999" | `x'=="999" |`x'=="669201012" |`x'=="664969637" | `x'=="664784505" |`x'=="664038791" | `x'=="661708083" |`x'=="661202160" | `x'=="656722464"|`x'=="656400987"|`x'=="0077243"|`x'=="333753167816" | `x'=="622029210" | `x'=="622691862"
replace `x'="" if `x'=="666111987" | `x'=="245857" |`x'=="629301883" | `x'=="7" | `x'=="22249845494" |`x'=="00" |`x'=="+22575410670" | `x'=="00244922634337" | `x'=="54" | `x'=="ADJA"| `x'=="ABDOULAYE" | `x'=="21" | `x'=="654276756" | `x'=="661219453" | `x'=="666158165"
replace `x'="" if `x'=="TOLNO" |  `x'=="ALLAIT SOUMAH" | `x'=="NANCI" | `x'=="MA" | `x'=="KOUROUMA" | `x'=="POUR INSTALLER DANS FAUT MA SOIT AU COMPLET." |`x'=="PAS" |`x'=="NAMERIQUI" | `x'=="HADJA KADIATOU" | `x'=="BAR√ßA" | `x'=="SARAN" | `x'=="H" | `x'=="MAMADOU SALIOU BALDé" | `x'=="MORLAYE SYLLA" | `x'=="MODESTE" | `x'=="KSKSDK" | `x'=="IBRAHIMA" | `x'=="HASSANATOU  DIALLO" | `x'=="BORDO"
replace `x'="" if  `x'=="AMINATA DIALLO" | `x'=="AMADOU OURY" | `x'=="ABOUBACAR KALOGA" | `x'=="FRAMORI" | `x'=="MON PAYS NATAL" | `x'=="BOKE" | `x'=="BINTA DIALLO" | `x'=="ALPHA OUMAR BAH DIT RONALDINHO" | `x'=="S√∂PI" | `x'=="LELSLDLDL" | `x'=="KADIATOU" | `x'=="FATOUMATA BINTA BARRY" | `x'=="BEAVOGUI" |  `x'=="DIALLO ALHASSANE" | `x'=="AUEB" | `x'=="CYCAGO" | `x'=="SAIS PAS" |`x'=="FRAN√ßOIS" | `x'=="OU" | `x'=="AICHA" | `x'=="BABIEN" | `x'=="YAMOUSSA" | `x'=="YAYA CAMARA" | `x'=="YAHYA DIALLO" | `x'=="SOUMAH" | `x'=="THIERNO" | `x'=="SWITCH" | `x'=="KEITA" | `x'=="ANG" | `x'=="BANGOURA" | `x'=="CHARABIA" | `x'=="DIALLO" | `x'=="SANDALI" |`x'=="FERLAND" | `x'=="GEANS" | `x'=="GUILAVOGUI" | `x'=="HABIB" | `x'=="HYY8P" | `x'=="IBRAHIMA DIALLO"

replace `x'="TANZANIA" if `x'=="TANZANIE"

replace `x'="YEMEN" if `x'=="YéMEN"

replace `x'="FRANCE" if `x'=="FLA FRANCE" | `x'=="AU FRANCE" | `x'=="LA  FRANCE" | `x'=="KA FRANCE" | `x'=="LA FRAN√ßAIS " |`x'=="√Ä PARIS" |`x'=="MARSEILLE" |`x'=="AVRE" |`x'=="LE HAVRE" | `x'=="FRANCE  LION" | `x'=="FRACNCE" |`x'=="ANGER" | `x'=="JE VOUDRAI HABITER EN FRANCE" | `x'=="MFRANCE" | `x'=="A   PARIS" | `x'=="SKANTE  PARIS" | `x'=="ENFRANCE"|`x'=="NANTES" | `x'=="√† PARIS"
replace `x'="FRANCE" if `x'=="JE VOUDRAIS HABITER EN FRANCE " | `x'=="EN FRAN√áE" | `x'=="A LA FRANCE" | `x'=="IAN FRANCE" |`x'=="FRANCIS" |`x'=="FRANCHE" | `x'=="LYON"| `x'=="FRENCE" | `x'=="FRANCE SAYON CAMARA" | `x'=="FRANCE  002245689" | `x'=="FANCE" |`x'=="SAINT √âTIENNE" | `x'=="TOULOUSE" | `x'=="STRASBOURG" | `x'=="NANTE"| `x'=="MONACO"| `x'=="LION" | `x'=="LILLE" | `x'=="EN FANCE" | `x'=="√éLE DE FRANCE"| `x'=="FRANCE ABACARCONDE" | `x'=="FRANCE 625241415" | `x'=="FRANC" | `x'=="A FRANCE"
/*line17*/
replace `x'="FRANCE" if  `x'=="LA FRAN√ßAIS" | `x'=="JE VOUDRAIS M'INSTALLER EN FRANCE" | `x'=="G VOUDRAIS HABITé EN FRANCE" | `x'=="√?LE DE FRANCE" | `x'=="C'EST A FRANCE" |`x'=="IA  FRANCE" |  `x'=="EN PARIS" | `x'=="√? PARIS" |`x'=="LAFRANCE" | `x'=="FRANCE " |`x'=="FRANCCE" | `x'=="A FANCE" | `x'=="FRAN√ßE" | `x'=="ITALIE APR√®S LA FRANCE" | `x'=="LE PARIE" | `x'=="FRANCS" | `x'=="IA FRANCE" |`x'=="LA FRAN√ßE" | `x'=="FRAN√ßAIS" | `x'=="A PARIS" | `x'=="EN FRANCE" | `x'=="FRAN√ßAIS"| `x'=="LA FRANCE" | `x'=="FRANCE " | `x'==" FRANCE " | `x'=="EN FRANCE, BANQUE" | `x'=="EN FRANCS" | `x'=="EN FRAN√ßE" | `x'=="PARI" | `x'=="PARIS" | `x'=="PARIE"

replace `x'="CANADA" if `x'=="CAANDA" | `x'=="A  CANADA" | `x'=="A CANADA" |`x'=="AUCANADA" | `x'=="M'ONT REAL" | `x'=="CANADAN" |`x'=="CANADAN"| `x'=="L'AMéRIQUE PRéCISéMENT AU CANADA" | `x'=="CANADAT" | `x'=="AU CANADAT" | `x'=="EN AMéRIQUE  (CANADA)" | `x'=="√Ä CANADA" | `x'=="I'AMéRIQUE PRéCISéMENT √† CANADA" | `x'=="A CANADA"| `x'=="AU CANADA" | `x'=="GANADA" | `x'=="AU CANADA " | `x'=="KANADA" | `x'=="LE CANADA" | `x'=="CANADA " | `x'==" CANADA " | `x'=="En Amérique  (Canada)" |`x'=="√? CANADA"

replace `x'="GERMANY" if `x'=="ALLELAGNE" | `x'=="ALEMAGNE"|  `x'=="EN ALMANGNE" |`x'=="ALLEMAND" |`x'=="L ALLEMAGNE" |`x'=="ALLEMANGNE " | `x'=="ALLEMANDE" |`x'=="ALLEMAGNE " |`x'=="ALLEMANG" |`x'=="ALLEMANE" | `x'=="ALEMANGNE" |`x'=="ALMANGNE" | `x'=="ALLEMAGNE 663241415" |`x'=="ALMAGNE" | `x'=="ALLéMAGNE" | `x'=="ALLEMAN3" | `x'=="ALLEAGNE" | `x'=="EN ALLEMAGNE" | `x'=="ALLEMAGNE" | `x'=="ALLEMANGNE" | `x'==" L'ALLEMAGNE" | `x'=="L'ALLEMAGNE"

replace `x'="UNITED STATES" if `x'=="A L'AMéRIQUE" | `x'=="AU NEWS YORK" | `x'=="AMéRIQUE DU NORD" | `x'=="AMéRIQUE  (NEW YORK )" | `x'=="MON PAYS DE R√™VE C'EST L'AMéRIQUE" |`x'=="√âTATS-UNIS  D'AMéRIQUE" |`x'=="L'AM√âRIQUE"|`x'=="U SA"| `x'=="AUX ETATS-UNIS"| `x'=="A PHILADELPHIA" | `x'=="LES √âTATS UNIS D'AMéRIQUE" | `x'=="LES √âTATS UNIS D'AMERIQUE" | `x'=="AUX √âTATS-UNIS" | `x'=="NEW-YORK" | `x'=="U éTAT UNIS" | `x'=="√âTATS UNIS D'AMéRIQUE" | `x'=="√âTAT UNIS" | `x'=="√âTATS-UNIS D'AMéRIQUE" |`x'=="√âTAT UNIS D'AMéRIQUE" | `x'=="USA AMéRIQUE" | `x'=="AU √âTATS-UNIS" | `x'=="A LOS ANGELES" 

replace `x'="UNITED STATES" if `x'=="AMéRIQUES" | `x'=="AMéRIQUE DU NORD " |`x'=="AMéRIQUE " |`x'==" √?TATS  UNIS D'AMéRIQUE" |`x'=="√âTATS-UNIS D'AMéRIQUE, " | `x'=="NEW JERSEY" | `x'=="PENTAGONE" |`x'=="AUX √âTATS-UNIS D'AMéRIQUE" | `x'=="√âTATUNIS" |`x'=="CALIFORNIE" |`x'=="AMRIQUE" |`x'=="AMERICA" |`x'=="√âTAS UNI D'AMéRIQUE" |`x'==" √âTATS-UNIS  D'AMéRIQUE" |`x'=="√âTAT UNIS AMéRIQUE" |`x'=="√âTAT -UNIS" |`x'=="WASHINGTON" |`x'=="U,.S,A" | `x'=="CHICAGO"| `x'=="USA" |  `x'=="AU éTAT UNIS" | `x'==" √âTATS-UNIS" | `x'=="√âTATS-UNIS" | `x'=="√âTATS UNIS" | `x'==" √âTATS UNIS D'AMéRIQUE" | `x'=="√âTAS UNIS D'AMéRIQUE"| `x'=="√âTAT  UNIS D AMéRIQUE" | `x'=="√âTAT UNIS D'AM√âRIQUE" | `x'==" √âTAT UNIS" | `x'=="√âTAS UNIS" | `x'=="LES USA" | `x'=="U S A" 

replace `x'="UNITED STATES" if `x'=="J'AIMERAIS M'INSTALLER AUX √âTATS-UNIS" |`x'=="AMéRIQUE  (NEW YORK)" |`x'=="ETATS UNIS D'AMERIQUE" |`x'=="ETATS UNIS" |`x'=="ETATS UNIES" |`x'=="U . S.A" | `x'=="ETATS-UNIS D'AMéRIQUE" |`x'=="ETAS UNIS" | `x'=="NEYWORK" | `x'=="NEW YORK" | `x'=="ETAS UNIS" |`x'=="ETAT-UNIS" | `x'=="ETAT UNIS" | `x'=="LOS ANGELES" | `x'=="AU USA" | `x'=="√?TATS UNIS D'AMéRIQUE"| `x'=="AUX U .S. A (EN AMéRIQUE )" | `x'==" AUX U .S. A (EN AMéRIQUE ) "
replace `x'="UNITED STATES" if `x'=="AU ETATS UNIES" | `x'=="LES √âTATS-UNIS" | `x'=="ETATS UNIES D'AMERIQUE" | `x'=="√?TATS-UNIS D'AMéRIQUE" | `x'=="√?TATS UNIES D'AMéRIQUE" | `x'=="√?TATS UNIES" |`x'=="√?TATS UNI" | `x'=="MARYLAND" | `x'=="√?TAT UNIES" |  `x'=="MIAMI" | `x'=="MIAMI BITCH" |`x'=="MANATHAM" |`x'=="√?TAS UNIS D'AMéRIQUE" | `x'=="Etats_Unis" | `x'=="Au U.S.A" | `x'=="√?TATS-UNIS" | `x'=="√?TATS UNIS" | `x'==" √?TATS UNIS D'AMéRIQUE" | `x'=="√?TAT UNIS D'AM√?RIQUE" | `x'=="√?TAT UNIS" | `x'=="√?TAT  UNIS D AMéRIQUE"|  `x'=="√?TAS UNIS" |`x'==" √?TAS UNIS D'AMéRIQUE"| `x'=="USA D'AMERIQUE"| `x'=="USA AMERIQUE"| `x'=="U.S.A" | `x'=="ETAT-UNIS UNIS" | `x'=="ETATS UNIS D'AMéRIQUE" | `x'=="ETATS-UNIS" | `x'=="EUAMéRIQUE" | `x'=="L'éTATS UNIES D'AMéRIQUE"
replace `x'="UNITED STATES" if  `x'=="A NEW YORK" | `x'=="NEWS YORK" | `x'=="NE YORK" | `x'=="LES √âTATS UNIE D'AMéRIQUE" | `x'=="LAMERIQUE" | `x'=="C'EST EN AMéRIQUE" | `x'=="AU éTATS UNIS" |`x'=="C'EST EN AMERIQUE" | `x'=="√âTATS-UNIS AMéRIQUE" | `x'=="√âTATS UNIS AMERIQUE  (USA)" | `x'=="√âTATS UNIS  D'AMéRIQUE" | `x'=="√âTATS UNIES D'AMéRIQUE" | `x'=="√âTATS UNIES" |`x'=="√âTATS UNIE D'AMéRIQUE" |`x'=="√âTATS UNI" | `x'=="√âTAT UNIES" | `x'=="L AMERIQUE" | `x'=="ETAS UNIS D'AMéRIQUE" | `x'=="EN AMéRIQUE PRéCISéMENT EN BROOCLYN" | `x'=="EN éTATS UNIS" | `x'=="AUX √âTATS-UNIS √† NEW YORK" | `x'=="AU éTA UNIS D'AMéRIQUE" | `x'=="DALLAS" | `x'=="COLORADO" | `x'=="AUX √?TATS-UNIS" |`x'=="√?TATS-UNIES" | `x'=="√?TATS UNIS D'AMERIQUE," | `x'=="√?TATS UNIS D'AMERIQUE" | `x'=="√?TATS UNIS AMERIQUE" | `x'=="AMERIQUE  (NEW YORK)" | `x'=="QUE AMéRIQUE" | `x'=="AM√®RIQUE" |`x'=="AUX USA" | `x'=="PENTAGON" | `x'=="LES √?TATS UNIS" | `x'=="LES √?TATS UNIS  D'AMéRIQUE" | `x'=="L'USA"
replace `x'="EQUATORIAL GUINEA" if `x'=="GUINéE  EQUATORIAL" | `x'=="GUINéE EQUATORIAL" | `x'=="GUINEE EQUATORIALE"

replace `x'="SPAIN" if `x'=="BARCELO6" |`x'=="ESPANCE" |`x'=="ESPAGUE" | `x'==" ESPAGUE" |`x'=="MADRID" | `x'=="ESPANGNE" |`x'=="SPAGNE"| `x'=="ESPAGN"| `x'=="EN MADRID" | `x'=="ESPAGNE" | `x'=="EN ESPAGNE" | `x'=="ESPANE" | `x'=="L'ESPAGNE"

replace `x'="BELGIUM" if `x'=="LI√®GE" | `x'=="OU BELGIQUE" |`x'=="BRUXELLE" |`x'=="BLEGIQUE" | `x'=="BELGIQU" |`x'=="IA BELGIQUE" | `x'=="BELGIQUE 0032465789089" | `x'=="BERGIQUE"| `x'=="BELGIQUE" | `x'=="EN BELGIQUE" | `x'=="BELSIQUE" | `x'=="LA BELGIQUE"

replace `x'="ENGLAND" if  `x'=="ANGLETERR" | `x'=="ANGELTERRE" | `x'=="ANGLAITERRE" | `x'=="A L'ANGLETERRE" | `x'=="L'ANGLETERRE " |`x'=="ANGLETTE" |`x'=="ANGLETAIS" | `x'=="√? LONDRES" | `x'=="LONDRES" | `x'=="ANGLLETERE" | `x'=="LONDON"| `x'=="BINTA BARRY  ANGLETERRE"| `x'=="EN ENGLETERRE" | `x'=="ANGLERRE" | `x'=="ANGLETERRE" |  `x'=="ENGLETTERE"  | `x'=="ANGLETERE"| `x'=="L'ANGLETERRE" | `x'=="ANGLETAIRE" | `x'=="EN ANGLETERRE" | `x'=="ENGLETERRE" | `x'=="ENGLETTERRE" | `x'=="LONDRE" | `x'=="LONDRE"
replace `x'="ENGLAND" if  `x'=="L'ONDRE" | `x'=="ENGLETAIR" | `x'=="8ENGLETTERE"  | `x'=="L' ANGLETERRE" |`x'=="ENGLETAIRE" |`x'=="ALLETERRE" |`x'=="ENGLETER" |`x'=="ANGLETER" | `x'=="ANGLETRRE"
replace `x'="UNITED STATES" if `x'=="LES √âTATS-UNIS D'AMéRIQUE" | `x'=="LES √âTATS UNIS" | `x'=="LES ETATS UNIS D'AMERIQUE" | `x'=="L'AMéRIQUE DU NORD" | `x'=="AMÈRIQUE" | `x'=="AM√âRIQUE" | `x'=="NEW WORK" | `x'=="AUX éTATS UNIS" |`x'=="CANSAS" |`x'=="√?TATS  UNIS D'AMéRIQUE"  | `x'=="ETAT UNIS D'AMéRIQUE" | `x'=="ETAS UNIS AMERIQUE"| `x'=="LESUSA"| `x'=="ETAT UNIE"| `x'=="AMéRICAIN"| `x'=="AMéRIQUES" | `x'=="AMERQUE" | `x'=="AMERICAINE" | `x'=="AMERIQUE" | `x'=="LA L'AMéRIQUE" |`x'=="L'AMéRIQUE" | `x'=="AMERIC" | `x'=="EN AMERIQUE" | `x'=="AMERIQEU"| `x'=="AMéRIQUE" | `x'==" EN AMERIQUE" | `x'=="EN AMéRIQUE" | `x'=="L' AMERIQUE"| `x'=="L' AMéRIQUE"| `x'=="L'AMERIQUE"| `x'==" L'AMéRIQUE"

replace `x'="ITALY" if `x'=="INTER MILAN" | `x'=="ROME" | `x'=="ITAL" |  `x'=="ITALIEN" | `x'=="LATE ITALI" | `x'=="ITALI 664971432" | `x'=="POUR LE MOMENT C'EST EN ITALIE" | `x'=="L'ITALIE" |`x'=="ITAY" |`x'=="ITALIA" | `x'=="ROME" | `x'=="ITALIE"  | `x'=="EN ITALI" | `x'=="ITALI" | `x'=="ITALY" | `x'=="EN ITALIE"

replace `x'="RUSSIA" if  `x'=="RUISSIE"| `x'=="MOSCOW" | `x'=="LA RUSSIE" | `x'=="RUSSIE" | `x'=="RUSIE"

/*line 33*/
replace `x'="TOGO" if `x'=="AU TOGO"

replace `x'="EUROPE" if `x'=="C'EST  EN EUROPE" | `x'=="J'AI EN EUROPE" |`x'=="EN EUROPE" |  `x'=="EUROPéENNE" | `x'=="√Ä L'EUROPE" | `x'=="L'EUROPE" | `x'=="L√? L'EUROPE" | `x'=="IEUROPE" | `x'=="EROPE"

replace `x'="NETHERLANDS" if `x'=="PAYS  BAS" | `x'=="PAYS BAS" |`x'=="OLENDE" | `x'=="EN HOLLANDE" | `x'=="HOLANDE" | `x'=="HOLLAND"| `x'=="PAYBAS" | `x'=="HOLLANDE" | `x'==" HOLLANDE" | `x'=="LES PAYS BAS" | `x'=="HOLAND"

replace `x'="SAUDI ARABIA" if `x'=="ARABIE" | `x'=="ARABIE SAODIQUE" | `x'=="A LA MECQUE" | `x'=="ARABIE  SAOUDITE" |`x'=="ARABIE SAUDITE" | `x'=="RABIAT0U SAOUDITE" | `x'=="ARABIA SAOUDITE" | `x'=="ARABISAOUDITE" | `x'=="MECQUE" | `x'=="ARABIE SAOUDITE" | `x'=="EN ARABI SAOUDITE" | `x'=="ARABIS SAODI" | `x'=="ARABE SAOUDI" | `x'=="EN ARABE SAOUDITE"  | `x'==" ARABIS SAODI" | `x'=="SAODIA" | `x'=="SAOUDI" | `x'=="SAOUDIA" | `x'=="SAOUDINE"

replace `x'="MOROCCO" if `x'=="MARROC"| `x'=="MACOC"|`x'=="RABAT"|  `x'=="MAROQUE" | `x'=="MARAOC"| `x'=="MARCO" | `x'=="LE MAROC" | `x'=="AU MAROC" | `x'=="MAROC"

replace `x'="AUSTRALIA" if `x'=="√Ä AUSTRALIE" |`x'=="AUSTRLIE" | `x'=="L'AUSTRALIE" | `x'=="HOSTRALIE" | `x'=="AUTRALIE" |`x'=="A LA AUSTRALIE" |`x'=="AUSTRALIE" | `x'=="AUSTRALI" | `x'=="POUR TRAVAILLER SURTOUT EN AUSTRALIE" | `x'=="EN AUSTRALIE"

replace `x'="" if `x'=="JE M'ABITERAIS ICI CHEZ MOI EN GUINéE                  O" | `x'=="LA GUINNE" | `x'=="C0NAKRY" | `x'=="GUINE" |`x'=="LA GUIN√?E" | `x'=="ENGUINEE" |`x'=="IA GUINEE" |`x'=="OUIENGUINE" |`x'=="LA GUINEE" |`x'=="MATOTO"  |`x'=="LA GUINéE CONAKRY"  |`x'=="LANSANAYAH"  |`x'=="LA GUINéE  CONAKRY"  | `x'=="IL VIT EN GUINéE"  | `x'=="GUIN√âE"  |`x'=="LE GUINéE" |`x'=="LA GUIN√âE" | `x'=="FRIA"| `x'=="COONAKRRY" |`x'=="CNAKRY" | `x'=="CANAKRY" | `x'=="MAMOU" | `x'=="KANKAN" | `x'=="√Ä CONACKRY"| `x'=="LA GUIN√®E"| `x'=="LA GUINNEE"| `x'=="IL GUINE"| `x'=="IA GUINéE" | `x'=="GUINéE CONAKRY"| `x'=="GUINNEE" | `x'=="GUINNE" | `x'=="GUINEEE" | `x'=="GUINEA" | `x'=="EN GUINNEE" | `x'=="EN GUINEE"| `x'=="CONACKRY"| `x'=="CON1KRY"| `x'=="COKNARY"| `x'=="A CONAKRY"|`x'=="GUINEE"| `x'=="CONAKRY" | `x'=="A' CONAKRG" | `x'=="SANGOYAH" | `x'=="A CONAKRG" | `x'=="EN GUINéE" | `x'=="GUINéE" | `x'=="GUINéE  CONAKRY" |  `x'=="LA GUINéE"
replace `x'="" if `x'=="LAGUINEE" | `x'=="EN GUINNéE" | `x'=="IAN GUINNEE" |`x'=="GUINN√®E" | `x'=="GUIN√®E"

replace `x'="IVORY COAST" if `x'=="EN C√¥Té D'IVOIRE" |`x'=="EN C√¥TE D'IVOIRE" |`x'=="C√¥Té D 'IVOIRE" |`x'=="COTE D'IVOIRE" |`x'=="ABIDJAN" | `x'=="IVOIRE"| `x'=="C√¥Té DIVOIRE" | `x'=="C√¥Té D'IVOIRE" | `x'=="C√¥Té D'IVOIR" | `x'=="COTE D IVOR" | `x'=="C√¥TE DIVOIR" | `x'=="C√¥TE D'IVOIRE" | `x'==" C√¥TE DIVOIR"

replace `x'="IVORY COAST" if `x'=="C√¥TE  D'IVOIRE" | `x'=="C√?T√? D'IVOIRE" |`x'=="EN C√¥TE IVOIRE" |`x'=="C√¥TE-D'IVOIRE" |`x'=="C√¥TE D'IVOIR" | `x'=="C√¥TE DIVOIRE" | `x'=="C√¥Té D IVOIRE" | `x'=="C√¥Té IVOIRE"
 
replace `x'="UNITED KINGDOM" if `x'=="ROYAUM UNI" | `x'=="ROYAUME-UNI"
*line 44
replace `x'="EGYPT" if `x'=="L'EGYPTE" | `x'=="√?GYPTE" | `x'=="EN √âGYPTE" | `x'=="√âGYPTE" | `x'=="EGYPE" | `x'=="EJIPT" | `x'=="EGYPTE"

replace `x'="BRAZIL" if `x'=="BREZIL" |`x'=="AU BRéSIL" | `x'=="BRASIL" |`x'=="BR√®SIL"| `x'=="BRESIL"| `x'=="BRéSIL" | `x'=="AU BRAZIL"

replace  `x'="GREECE" if `x'=="GR√¢CE" | `x'=="GRECEE" |  `x'=="GRECE" | `x'=="GR√®CE"

replace `x'="QATAR" if `x'=="KATAR" | `x'=="QUATAR"

replace `x'="ALGERIA" if `x'=="ALEGERI" | `x'=="ALGERI"|`x'=="ALGER"| `x'=="ALGéRIE" | `x'=="ALGERI"

replace `x'="NIGERIA" if `x'=="LAGOS" | `x'=="NIGéRIA"

replace `x'="JAMAICA" if `x'=="JAMA√ØQUE" |`x'=="LION DU FOUTA JAMAIK"

replace `x'="UNITED ARAB EMIRATES" if   `x'=="A DUBA√Ø" | `x'=="DOUBA√Ø" |`x'=="DUBA√Ø" | `x'=="DOUBAI" | `x'=="DOUBAYE"
replace `x'="TURKEY" if `x'=="TURQUI" | `x'=="TURQUE" | `x'=="TURKY" | `x'=="TURKI" |`x'=="TURQUIS" | `x'=="TURKIE" | `x'=="TURQUIE" | `x'=="USTANBUL" | `x'=="OUSTANBUL"

replace `x'="INDIA" if `x'=="INDE" |`x'=="INDI"

replace `x'="KOWIET" if `x'=="KOWE√ØT" | `x'=="KOWIET"

replace `x'="JAPAN" if  `x'=="JAPONAIS" | `x'=="JAPON" | `x'=="TOKYO"

replace `x'="ICELAND" if `x'=="ISLANDE"
*line58
replace `x'="VIETNAM" if `x'=="HANO√Ø"

replace `x'="ALGERIA" if `x'=="ALGERIE"

replace `x'="ANGOLA" if `x'=="ANGPLA" | `x'=="ANGOL" | `x'=="ANGOLALA" | `x'=="ENGOLA" |`x'=="LUANDA" | `x'=="√Ä LOUANDA" |`x'=="LWOUANDA"

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

replace `x'="GHANA" if `x'=="ACCRA" | `x'=="GANA" | `x'=="GANAH" |`x'=="ACRA" | `x'=="AU GHANA"

replace `x'="SIERRA LEONE" if `x'=="SIERRA LIONNE" | `x'=="SIERRA  LéON" |`x'=="SEIRALEON" | `x'=="SERA LEONNE" | `x'=="SERRA LEONNE" | `x'=="SIERRA-LEONNE" |`x'=="SIERRA LéON" | `x'=="SERRA LéONE" | `x'=="SIERRA LEONNE"| `x'=="LA SIERRA LéONE"

replace `x'="LIBERIA" if `x'=="LIBéRIA" | `x'=="IIBERIA" | `x'=="LIBERIA 00231888989734" |`x'=="LIBERIA 6662678754"

replace `x'="MALAISIA" if `x'=="MALIAISIE" | `x'=="MALAISIE" | `x'=="MALESIE" | `x'=="MALLESIE"

replace `x'="SWITZERLAND" if `x'=="LA SUISE" | `x'=="SUISE" |`x'=="SUISSE" | `x'=="LA SUISSE" | `x'=="SUSSE"  | `x'=="GEN√®VE" 

replace `x'="SENEGAL" if `x'=="A SENéGAL" |`x'=="DIAKAR" | `x'=="SENGAL" |`x'=="SENEGAL 624341513" | `x'=="SENéGAL" | `x'=="SéNEGALE" |`x'=="SéNEGAL" | `x'=="AU SéNéGAL" | `x'=="SEGALE" | `x'=="SéNéGAL  00221 77 918 45" | `x'=="SéNéGAL"|`x'=="SEGAL" | `x'=="SENEGALE" | `x'=="DAKAR"

replace `x'="TUNISIA" if `x'=="TUNISIE"

replace `x'="CAMEROUN" if `x'=="AU CAMEROUN" | `x'=="CAMEROUM"

replace `x'="THAILAND" if `x'=="TAILAND" | `x'=="TAILLAND" | `x'=="THA√ØLANDE"

*line80
replace `x'="GUINEA BISSAU" if `x'=="GUINEE BISSAU" |`x'=="GUINéE BISEAU" | `x'=="GUINéE  BISSAU" | `x'=="BISSAO" | `x'=="GUINEE-BISSAU" |`x'=="GUINéE-BISSAU" | `x'=="GUINéE BISSAU" | `x'=="BISSAU"

replace `x'="NORWAY" if `x'=="LA NORVEGE" | `x'=="NORWAIL" |`x'=="NORV√®GE" | `x'=="NORVEGE"

replace `x'="MALI" if `x'=="BAMAKO"

replace `x'="SWEDEN" if `x'=="SUEDE" | `x'=="SU√®DE"

replace `x'="MAURITANIA" if `x'=="MAURITANIE Q" | `x'=="A MAURITANIE" | `x'=="MAURITANI" | `x'=="A MORRITANI" |`x'=="MORRITANI" | `x'=="MAURITANIE"

replace `x'="IRELAND" if  `x'=="IRLANDE DU NORD" | `x'=="A IRLANDE" | `x'=="IRLANDE"

replace `x'="SOUTH AFRICA" if `x'=="AFRIQUE DU SUD" | `x'=="SUD AFRIQUE"

replace `x'="CHINA" if `x'=="CHINE" | `x'=="LA CHINE"

replace `x'="SOUTH KOREA" if `x'=="KOREE DU NORD" | `x'=="CORé" | `x'=="CORéE DU SUD" | `x'=="CORéE"| `x'=="CORéE  DU SUD"| `x'=="CORRé DU SUD" | `x'=="CORé DU SUD"

replace `x'="POLAND" if `x'=="POLOGNE"

*line91
replace `x'="COLOMBIA" if `x'=="COLOMBI" | `x'=="COLOMBIE"

replace `x'="DENMARK" if `x'=="DANEMARK"

replace `x'="MOSCOW" if  `x'=="MOSCOU"

replace `x'="PHILIPPINES" if `x'=="PHILIPINES" | `x'=="PHILIPPINE"

replace `x'="PORTUGAL" if `x'=="LE PORTUGAL" | `x'=="AU PORTUGAL"

replace `x'="CZECK REPUBLIC" if `x'=="TCH√®QUE"

replace `x'="KENYA" if `x'=="NAIROBI"

replace `x'="SOMALIA" if `x'=="SOMALIE"

replace `x'="CYPRUS" if `x'=="CHYPRE"

replace `x'="ETHIOPIA" if `x'=="√âTHIOPIE"

replace `x'="ALBANIA" if `x'=="ALBANIE"

replace `x'="AFRICA" if `x'=="AFRIQUE"
}
gen str sec2_q2_bis=substr(sec2_q2,1,30)
replace sec2_q2="UNITED STATES" if sec2_q2_bis=="EN AMéRIQUE PARCE QUE  ACTUEL"
replace sec2_q2="FRANCE" if sec2_q2_bis=="JE VOUDRAIS HABITER EN FRANCE "
replace sec2_q2="UNITED STATES" if sec2_q2_bis=="√âTATS UNIS PLUS PRéCISéMENT"
replace sec2_q2="" if sec2_q2_bis=="C'EST LE PAYS L√† O√π IL Y'A L"
drop sec2_q2_bis

gen str sec3_21_bis=substr(sec3_21,1,30)
replace sec3_21="" if sec3_21_bis=="J'IRAI PAS SANS PAPIER LA MER "
drop sec3_21_bis

gen str sec10_q5_1_bis=substr(sec10_q5_1,1,30)
replace sec10_q5_1="" if  sec10_q5_1_bis=="AMéRIQUE NEW YORK PRéCISéME"
drop sec10_q5_1_bis

encode lycee_name_str, gen(lycee_name)

rename nb_student_at_randomiz_date school_size
label var school_size "Size of the upper secondary school size at the randomization date"

gen PARTICIPATION=1 if participation_elv=="oui"
	replace PARTICIPATION=0 if participation_elv=="non"
	replace PARTICIPATION=2 if treatment==1
	replace PARTICIPATION=partb_participation if lycee_name_str=="SAINTE MARIE" | lycee_name_str=="MARTIN LUTHER KING" // those correspond to schools for which we had no attendence sheet
	drop participation_elv partb_participation
	rename PARTICIPATION participation
	label var participation "Participation to the information session"
	label define part 0"No" 1"Yes" 2"Control group"
	label values participation part

duplicates tag id_number,gen(mid_participant)
	label var mid_participant "Student who participated to the midline survey"
	label value mid_participant yes_no_bis
	

/*when there were some mistake in identification numbers, some students
answered the questions on the information session while they did not participation
I erase those data. */
count if participation==0 & partb_q0!=. // 2 obs

local partb_str "partb_q0_other partb_q1_other partb_q3_other  partb_q3"
local partb "partb_q0_bis partb_q1 partb_q2 partb_q3_1 partb_q3_2 partb_q3_3 partb_q3_4 partb_q3_99 partb_q3_5 partb_q5 partb_q6 partb_q8 partb_q9 partb_q11_a partb_q11_b partb_q11_c partb_q11_f partb_q11_g partb_q11_h partb_q11_j partb_q11_k partb_q11_l partb_q11_m partb_q12 partb_q13"
foreach var in `partb' {
replace `var'=. if participation==0 & partb_q0!=.
}

foreach var in `partb_str' {
replace `var'="" if participation==0 & partb_q0!=.
}

replace partb_q0=. if participation==0 & partb_q0!=.


*generating number of female teachers
gen nb_teacher_f=0
forvalues i=1/115 {
replace nb_teacher_f=nb_teacher_f+1 if gender`i'==2
}
label var nb_teacher_f "Number of female teachers in secondary high school (lycee+college) ?"


*admin data from the IRE
label var student_t "Total number of students in upper secondary high school (lycee)"
label var student_f "Total number of female students in upper secondary high school (lycee)"
label var teacher_t "Total number of teachers in upper secondary high school (lycee)"
label var teacher_f "Total number of female teachers in upper secondary high school (lycee)"
label var admin_t "Number of administration staff in upper secondary high school (lycee)"
label var admin_f "Number of female administration staff in upper secondary high school (lycee)"
label var entr_t "Number of maintenance staff in upper secondary high school (lycee)"
label var entr_f "Number of female maintenance  staff in upper secondary high school (lycee)"
label var gp "Number of educational groups in upper secondary high school (lycee)"
label var salles "Number of classrooms in upper secondary high school (lycee)"



rename student_t student_t_lycee
rename student_f student_f_lycee
rename teacher_t teacher_t_lycee
rename teacher_f teacher_f_lycee
rename admin_t admin_t_lycee
rename admin_f admin_f_lycee
rename entr_t entr_t_lycee
rename entr_f entr_f_lycee
rename salles nb_classroom_lycee
rename gp nb_educ_group_lycee


label var tel2 "Student's phone number given during the sensibilisation"

label var key_base "Baseline : Unique submission ID"
label var key_mid "Midline : Unique submission ID"

*
***   d. - Ordering                                  
***_____________________________________________________________________________


order time schoolid_str id_number id_number_str lycee_name_str lycee_name commune treatment participation
order submissiondate starttime endtime finished starttime_new_date starttime_new_hour submissiondate_new_date submissiondate_new_hour endtime_new_date endtime_new_hour sec2_q4_bis, last
order sell_asset money_from_asset mig_asset, after(sec2_q15)
order sec3_34_euros sec3_34_pounds sec3_34_local, after(sec3_34)
order sec3_42_euros sec3_42_pounds sec3_42_local, after(sec3_42)
order sec2_q4_bis, after(sec2_q4)
order road_selection, after(ceuta_sent_back)
order expectation_wage, after(sec3_34_bis)
order sec9_q3_1_a sec9_q3_1_b sec9_q3_2_a sec9_q3_2_b sec9_q3_3_a sec9_q3_3_b, after( sec9_q2)
order partb* check*, after(sec10_q19_2)
order key_mid, after(key_base)
order school_size, after(nb_students)
order nb_teacher_f, after(nb_teachers)





********************************
***********  saving ************
********************************
save "$main/Data/output/analysis/guinea_final_dataset.dta", replace


