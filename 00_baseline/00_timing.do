/*Name: time.do
Date Created:  November 28, 2018
Date Last Modified: March 11, 2018
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
Uses data: guinea_baseline_cleaned
Creates data: 
This do file allows me to monitor data collection and enumerator's work
*/



clear
set more off 
capture  log  close

*cloe user 
*global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

***************************************************************
***********************   REAGIND THE DATA *********************
****************************************************************

import delimited using "$main/Data/raw/baseline/guinea_baseline_questionnaire_WIDE.csv", clear

local datetime_fields1 "submissiondate starttime endtime"


	
//////////////////////////////////////////////////////////////////////////
///////////////////// DELETING Observation of the pilot///////////////////
///// and the questionnaire that I sent during adama's training //////////
//////////////////////////////////////////////////////////////////////////

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

 * the baseline started on November 26. I delete all the observation before this date 
drop if starttime_new_date<date("11262018","MDY")

 * deleting questionnaire that i sent by mistake adama's training 
drop if sec0_q1_a=="Hji"

	


 
***************************************************************
************************* ANALYSIS ****************************
****************************************************************


gen completion=1 if finished==""
replace completion=0 if finished!=""

bys lycee_name : sum completion


*effective_completion
gen effective_completion=0
replace effective_completion= 1 if outside_contact_no==1 & sec10_q19_1!=. & completion==1 | outside_contact_no==0 & completion==1| outside_contact_no>1 & sec10_q19_2!=. & completion==1

tab effective_completion 



*timing
gen time_part0=time0-time_begin
gen time_part1=time1-time0
gen time_part2=time2-time1
gen time_part3a=time3a-time2
gen time_part3b=time3b-time3a
gen time_part3c=time3c-time3b
gen time_part3d=time3d-time3c
gen time_part4=time4-time3d
gen time_part5=time5-time4
gen time_part6a=time6a-time5
gen time_part6b=time6b-time6a
gen time_part7=time7-time6b
gen time_part8=time8-time7
gen time_part9=time9-time8
gen time_part10a=time10a-time9
gen time_part10b=time10b-time10a
gen time_part10c=time10c-time10b
*gen time_part10d=time10d-time10c

sum time_part*

egen time_whole_survey=rowtotal(time_part*)
sum time_whole
bys lycee_name : sum time_whole
sum time_whole if completion==0



/* section where students finished */
*cleaning
replace finished="sec10" if finished=="Sec10"
replace finished="sec9" if finished=="Rela"
replace finished="sec0" if finished=="frie"
replace finished="sec9" if finished=="outs"

gen str4 sec_completion=substr(finished,1,4) 
replace sec_completion="sec10" if completion==1
tab sec_completion




