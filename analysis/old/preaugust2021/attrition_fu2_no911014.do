
clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo/"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"


use ${main}/Data/output/followup2/BME_final.dta

cd "$main/Draft/tables/spring2021/"

tsset id_number time
replace source_info_guinea = f2.source_info_guinea



/*

********************PARTICIPATION BY STAGE AND TREATMENT ARM********************

*baseline

m: obs = J(7,10,.)

qui count if treatment_status == 1 & time == 0
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0
local N3 = `r(N)'

qui count if treatment_status == 3 & time == 0
local N4 = `r(N)'

qui count if treatment_status == 4 & time == 0
local N5 = `r(N)'

m: obs[1,3] = strtoreal(st_local("N2"))
m: obs[1,5] = strtoreal(st_local("N3"))
m: obs[1,7] = strtoreal(st_local("N4"))
m: obs[1,9] = strtoreal(st_local("N5"))
m: obs[1,1] = obs[1,3] + obs[1,5] + obs[1,7] + obs[1,9]

/*
*sensibilization

qui count if treatment_status == 1 & sensibilized == 1 & time == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & sensibilized == 1 & time == 1
local N3 = `r(N)'


qui count if treatment_status == 3 & sensibilized == 1 & time == 1
local N4 = `r(N)'

qui count if treatment_status == 4 & sensibilized == 1 & time == 1
local N5 = `r(N)'

m: obs[2,2] = 0
m: obs[2,3] = strtoreal(st_local("N3"))
m: obs[2,4] = strtoreal(st_local("N4"))
m: obs[2,5] = strtoreal(st_local("N5"))
m: obs[2,1] = obs[2,2] + obs[2,3] + obs[2,4] + obs[2,5]

m: obs[3,1] = round(obs[2,1]/obs[1,1], .001)
m: obs[3,2] = 0
m: obs[3,3] = round(obs[2,3]/obs[1,3], .001)
m: obs[3,4] = round(obs[2,4]/obs[1,4], .001)
m: obs[3,5] = round(obs[2,5]/obs[1,5], .001)
*/

*fist follow-up


qui count if treatment_status == 1 & time == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 1
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 1
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 1
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[2,3] = strtoreal(st_local("N2"))
m: obs[2,5] = strtoreal(st_local("N3"))
m: obs[2,7] = strtoreal(st_local("N4"))
m: obs[2,9] = strtoreal(st_local("N5"))
m: obs[2,1] = obs[2,3] + obs[2,5] + obs[2,7] + obs[2,9]

m: obs[2,2] = round(obs[2,1]/obs[1,1], .001)
m: obs[2,4] = round(obs[2,3]/obs[1,3], .001)
m: obs[2,6] = round(obs[2,5]/obs[1,5], .001)
m: obs[2,8] = round(obs[2,7]/obs[1,7], .001)
m: obs[2,10] = round(obs[2,9]/obs[1,9], .001)


* second follow-up

/*
qui count if treatment_status == 1 & time == 2 & migration_guinea != .
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 2 & migration_guinea != .
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 2 & migration_guinea != .
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 2 & migration_guinea != .
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[6,2] = strtoreal(st_local("N2"))
m: obs[6,3] = strtoreal(st_local("N3"))
m: obs[6,4] = strtoreal(st_local("N4"))
m: obs[6,5] = strtoreal(st_local("N5"))
m: obs[6,1] = obs[6,2] + obs[6,3] + obs[6,4] + obs[6,5]

m: obs[7,1] = round(obs[6,1]/obs[1,1], .001)
m: obs[7,2] = round(obs[6,2]/obs[1,2], .001)
m: obs[7,3] = round(obs[6,3]/obs[1,3], .001)
m: obs[7,4] = round(obs[6,4]/obs[1,4], .001)
m: obs[7,5] = round(obs[6,5]/obs[1,5], .001)
*/


* second follow-up tablet


qui count if treatment_status == 1 & time == 0 & source_info_guinea <= 0 & !missing(source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & source_info_guinea <= 0 & !missing(source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & source_info_guinea <= 0 & !missing(source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & source_info_guinea <= 0 & !missing(source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[3,3] = strtoreal(st_local("N2"))
m: obs[3,5] = strtoreal(st_local("N3"))
m: obs[3,7] = strtoreal(st_local("N4"))
m: obs[3,9] = strtoreal(st_local("N5"))
m: obs[3,1] = obs[3,3] + obs[3,5] + obs[3,7] + obs[3,9]

m: obs[3,2] = round(obs[3,1]/obs[1,1], .001)
m: obs[3,4] = round(obs[3,3]/obs[1,3], .001)
m: obs[3,6] = round(obs[3,5]/obs[1,5], .001)
m: obs[3,8] = round(obs[3,7]/obs[1,7], .001)
m: obs[3,10] = round(obs[3,9]/obs[1,9], .001)





* second follow up subject


qui count if treatment_status == 1 & time == 0 & source_info_guinea <= 1 & !missing(source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & source_info_guinea <= 1 & !missing(source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & source_info_guinea <= 1 & !missing(source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & source_info_guinea <= 1 & !missing(source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[4,3] = strtoreal(st_local("N2"))
m: obs[4,5] = strtoreal(st_local("N3"))
m: obs[4,7] = strtoreal(st_local("N4"))
m: obs[4,9] = strtoreal(st_local("N5"))
m: obs[4,1] = obs[4,3] + obs[4,5] + obs[4,7] + obs[4,9]

m: obs[4,2] = round(obs[4,1]/obs[1,1], .001)
m: obs[4,4] = round(obs[4,3]/obs[1,3], .001)
m: obs[4,6] = round(obs[4,5]/obs[1,5], .001)
m: obs[4,8] = round(obs[4,7]/obs[1,7], .001)
m: obs[4,10] = round(obs[4,9]/obs[1,9], .001)





* second follow up contact


qui count if treatment_status == 1 & time == 0 & source_info_guinea <= 2 & !missing(source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & source_info_guinea <= 2 & !missing(source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & source_info_guinea <= 2 & !missing(source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & source_info_guinea <= 2 & !missing(source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[5,3] = strtoreal(st_local("N2"))
m: obs[5,5] = strtoreal(st_local("N3"))
m: obs[5,7] = strtoreal(st_local("N4"))
m: obs[5,9] = strtoreal(st_local("N5"))
m: obs[5,1] = obs[5,3] + obs[5,5] + obs[5,7] + obs[5,9]

m: obs[5,2] = round(obs[5,1]/obs[1,1], .001)
m: obs[5,4] = round(obs[5,3]/obs[1,3], .001)
m: obs[5,6] = round(obs[5,5]/obs[1,5], .001)
m: obs[5,8] = round(obs[5,7]/obs[1,7], .001)
m: obs[5,10] = round(obs[5,9]/obs[1,9], .001)



* second follow up school info


qui count if treatment_status == 1 & time == 0 & source_info_guinea <= 5 & !missing(source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & source_info_guinea <= 5 & !missing(source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & source_info_guinea <= 5 & !missing(source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & source_info_guinea <= 5 & !missing(source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[6,3] = strtoreal(st_local("N2"))
m: obs[6,5] = strtoreal(st_local("N3"))
m: obs[6,7] = strtoreal(st_local("N4"))
m: obs[6,9] = strtoreal(st_local("N5"))
m: obs[6,1] = obs[6,3] + obs[6,5] + obs[6,7] + obs[6,9]

m: obs[6,2] = round(obs[6,1]/obs[1,1], .001)
m: obs[6,4] = round(obs[6,3]/obs[1,3], .001)
m: obs[6,6] = round(obs[6,5]/obs[1,5], .001)
m: obs[6,8] = round(obs[6,7]/obs[1,7], .001)
m: obs[6,10] = round(obs[6,9]/obs[1,9], .001)


* second follow up phone status


qui count if treatment_status == 1 & time == 0 & source_info_guinea <= 6 & !missing(source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & source_info_guinea <= 6 & !missing(source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & source_info_guinea <= 6 & !missing(source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & source_info_guinea <= 6 & !missing(source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[7,3] = strtoreal(st_local("N2"))
m: obs[7,5] = strtoreal(st_local("N3"))
m: obs[7,7] = strtoreal(st_local("N4"))
m: obs[7,9] = strtoreal(st_local("N5"))
m: obs[7,1] = obs[7,3] + obs[7,5] + obs[7,7] + obs[7,9]

m: obs[7,2] = round(obs[7,1]/obs[1,1], .001)
m: obs[7,4] = round(obs[7,3]/obs[1,3], .001)
m: obs[7,6] = round(obs[7,5]/obs[1,5], .001)
m: obs[7,8] = round(obs[7,7]/obs[1,7], .001)
m: obs[7,10] = round(obs[7,9]/obs[1,9], .001)

m: st_matrix("obs", obs)


matrix colnames obs =  "All" "%" "Control"  "%" "Risk"  "%" "Econ"  "%" "Double"  "%"
matrix rownames obs =  "Baseline: Tablet" "Follow Up 1: Tablet"  "Follow Up 2: Tablet" "Follow Up 2: Subject" "Follow Up 2: Contact"   "Follow Up 2: SSS"  "Follow Up 2: Phone Status" 

*esttab matrix(obs), nomtitle
putexcel set observationsintime, replace
putexcel A1 = matrix(obs), names
*/











keep if time == 0





*BALANCE SPRING 2021

tab classe_baseline, gen(grade)
la var grade2 "Student in 12th grade"
la var grade3 "Student in 13th grade"


tab moth_educ, gen(moth_educ)
tab fath_educ, gen(fath_educ)


la var fath_educ1 "Father's primary school or Preschool"
la var fath_educ2 "Father's secondary school"
la var fath_educ3 "Father's higher education (University, etc.)"
la var fath_educ4 "Father's don't know"
la var fath_educ5 "Father's no education"

la var moth_educ1 "Mother's primary school or Preschool"
la var moth_educ2 "Mother's secondary school"
la var moth_educ3 "Mother's higher education (University, etc.)"
la var moth_educ4 "Mother's don't know"
la var moth_educ5 "Mother's no education"


*variable for the balance
global bc_var = " strata_n2 female age moth_school fath_school wealth_index " ///
				+ "   durables50 fees50  grade2 grade3 fath_educ1 fath_educ2 fath_educ3 fath_educ4 fath_educ5 " ///
				+ " moth_educ1 moth_educ2 moth_educ3 moth_educ4 moth_educ5 " ///
				+ " brothers_no_win sisters_no_win " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"

** Collapse at cluster level
*collapse (mean) $bc_var treatment, by(schoolid)


gen treatment_status_1 = treatment_status == 1
gen treatment_status_2 = treatment_status == 2
gen treatment_status_3 = treatment_status == 3
gen treatment_status_4 = treatment_status == 4




********************************BALANCE TABLE***********************************

balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if treatment_status == 1 | treatment_status == 2) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_nostrat_fu2.xls",  ///
	 nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) 

	 stop
	
	
	
	
	
	
	
	
	
	
global outcomes = " desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help "
				
global controls = " school_size female i.classe_baseline moth_school fath_school wealth_index wealth_index durables50 fees50sch outside_contact_no mig_classmates"

**************************ATTRITION (School), INDIVIDUAL DATA****************************
*without interactions

reg no_1 i.treatment_status i.strata, cluster(schoolid)
qui sum no_1 if treatment_status == 1
*estadd scalar cont = r(mean)	
*est sto reg1
local cont = string(`r(mean)', "%9.3f")  
*local cont = `r(mean)' 
outreg2 using attrition_1.xls, replace label  dec(3) ct(" ") nonotes addtext(Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

/*
reg no_1 i.treatment_status  i.strata $outcomes, cluster(schoolid)
qui sum no_1 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg2
local cont = string(`r(mean)', "%9.03f")  
outreg2 using attrition_1.xls, append label dec(3) ct(" ") nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., No, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

reg no_1 i.treatment_status i.strata $outcomes $controls , cluster(schoolid)
qui sum no_1 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using attrition_1.xls, append label dec(3) ct(" ") nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., Yes, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)
*/


**************************ATTRITION (School, Phone), INDIVIDUAL DATA****************************
*without interactions

reg no_2 i.treatment_status i.strata, cluster(schoolid)
qui sum no_2 if treatment_status == 1
*estadd scalar cont = r(mean)	
*est sto reg1
local cont = string(`r(mean)', "%9.3f")  
*local cont = `r(mean)'  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

/*
reg no_2 i.treatment_status  i.strata $outcomes, cluster(schoolid)
qui sum no_2 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg2
local cont = string(`r(mean)', "%9.03f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., No, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

reg no_2 i.treatment_status i.strata $outcomes $controls , cluster(schoolid)
qui sum no_2 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., Yes, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)
*/


/*
esttab reg1 reg2 reg3  using ///
	"attritioncluster2_fu2.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
	nonumbers title("No School or Phone Survey at $2^{nd}$ follow-up, treatment and controls \label{attritioncluster2}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	addnotes("Errors are clustered at the school level." ) longtable label
*/
	
**************************ATTRITION (School, Phone, Contact), INDIVIDUAL DATA****************************
*without interactions

reg no_3 i.treatment_status i.strata, cluster(schoolid)
qui sum no_3 if treatment_status == 1
*estadd scalar cont = r(mean)	
*est sto reg1
local cont = string(`r(mean)', "%9.3f")  
*local cont = `r(mean)' 
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

/*
reg no_3 i.treatment_status  i.strata $outcomes, cluster(schoolid)
qui sum no_3 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg2
local cont = string(`r(mean)', "%9.03f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., No, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

reg no_3 i.treatment_status i.strata $outcomes $controls , cluster(schoolid)
qui sum no_3 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., Yes, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)
*/

/*
esttab reg1 reg2 reg3  using ///
	"attritioncluster3_fu2.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
	nonumbers title("No School, Phone, or Contact Survey at $2^{nd}$ follow-up, treatment and controls \label{attritioncluster3}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	addnotes("Errors are clustered at the school level." ) longtable label
*/
	
	
**************************ATTRITION (School, Phone, Contact, SSSS, Unstructured), INDIVIDUAL DATA***************************
*without interactions

reg no_5 i.treatment_status i.strata, cluster(schoolid)
qui sum no_5 if treatment_status == 1
*estadd scalar cont = r(mean)	
*est sto reg1
local cont = string(`r(mean)', "%9.3f")  
*local cont = `r(mean)' 
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

/*
reg no_5 i.treatment_status  i.strata $outcomes, cluster(schoolid)
qui sum no_5 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg2
local cont = string(`r(mean)', "%9.03f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., No, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

reg no_5 i.treatment_status i.strata $outcomes $controls , cluster(schoolid)
qui sum no_5 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., Yes, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)
*/

/*
esttab reg1 reg2 reg3  using ///
	"attritioncluster4_fu2.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
	nonumbers title("No School, Phone, Contact, or Short School Survey at $2^{nd}$ follow-up, treatment and controls \label{attritioncluster4}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	addnotes("Errors are clustered at the school level." ) longtable label
	
*/



**************************ATTRITION (School, Phone, Contact, SSSS, Unstructured, Phone), INDIVIDUAL DATA***************************
*without interactions

reg no_6 i.treatment_status i.strata, cluster(schoolid)
qui sum no_6 if treatment_status == 1
*estadd scalar cont = r(mean)	
*est sto reg1
local cont = string(`r(mean)', "%9.3f")  
*local cont = `r(mean)' 
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

/*
reg no_6 i.treatment_status  i.strata $outcomes, cluster(schoolid)
qui sum no_6 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg2
local cont = string(`r(mean)', "%9.03f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., No, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)

reg no_6 i.treatment_status i.strata $outcomes $controls , cluster(schoolid)
qui sum no_6 if treatment_status == 1
*estadd scalar cont = r(mean)
*est sto reg3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using attrition_1.xls, append label ct(" ") dec(3) nonotes addtext(Mig. Intentions and Beliefs, Yes, Ind. and School Contr., Yes, Baseline Mean Contr., `cont') nocons keep(2.treatment_status 3.treatment_status 4.treatment_status)
*/








stop

outtable  using attrition, mat(obs) nobox replace caption("Table attrition number of observations by treatment arm and round \label{attrition}") format(%9.3g)

stop

/*
*******************************build indeces
global economic_outcomes = " finding_job asinhexpectation_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor "

	


*variable for the balance
global bc_var = " strata_n2 female age moth_school fath_school wealth_index " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"

** Collapse at cluster level
*collapse (mean) $bc_var treatment, by(schoolid)


gen treatment_status_1 = treatment_status == 1
gen treatment_status_2 = treatment_status == 2
gen treatment_status_3 = treatment_status == 3
gen treatment_status_4 = treatment_status == 4




********************************BALANCE TABLE***********************************

balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if treatment_status == 1 | treatment_status == 2) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_nostrat_fu2.tex",  ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table \label{balancetable}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level.} \\"  "\end{longtable}")

**************************BALANCE TABLE (DIFFERENT SURVEY TYPES)***********************************

gen source_info_guinea_n0 = source_info_guinea == 0
gen source_info_guinea_n1 = source_info_guinea == 1
gen source_info_guinea_n2 = source_info_guinea == 2
gen source_info_guinea_n3 = source_info_guinea > 2 & source_info_guinea < 6
gen source_info_guinea_n6 = source_info_guinea == 6

*ctitles("\shortstack{ At \\ Least  \\ SSS }" "\shortstack{ At \\ Least  \\ Contact }" "\shortstack{ At \\ Least  \\ Phone }" "\shortstack{ At \\ Least  \\ School }" )
balancetable (mean if source_info_guinea==0)  ///
	(diff source_info_guinea_n1 if source_info_guinea==0 |  source_info_guinea==1)  ///
	(diff source_info_guinea_n2 if source_info_guinea==0 |  source_info_guinea==2) ///
	(diff source_info_guinea_n3 if source_info_guinea==0 |  (source_info_guinea > 2 & source_info_guinea < 6)) ///
	(diff source_info_guinea_n6 if source_info_guinea==0 |  source_info_guinea == 6) ///
	$bc_var using "balancesurveys_nostrat_fu2.tex",  ///
	longtable nonumbers  replace varlabels vce(cluster schoolid) ///
	prehead(\begin{longtable}{l*{5}c} \caption{Balance Across Survey Types \label{balancesurveys}}\\  \hline \hline) pvalues ///
	ctitles("\shortstack{ Tablet \\ Survey  \\ (Subject) }" "\shortstack{ Phone \\ Survey  \\ (Subject) }" "\shortstack{ Phone \\ Survey  \\ (Contact) }" "\shortstack{ SSS, \\ or  \\  US }" "\shortstack{ Phone \\ Ever  \\ On }" ) ///
	 postfoot("\hline\hline \multicolumn{6}{p{16cm}}{\footnotesize $^{(1)}$ Obtained as average of routes through Italy and Spain. First column reports mean outcomes for those whose migration status is determined from a school survey in the $2^{nd}$ Follow-up. Second reports mean for sample whose migration status comes from a subject phone survey. Third refers to phone contact survey. Fourth refers to Short School Survey (SSS), Unstructured Survey (US). Fifth refers to Phone Status (On/Off). P-values are denoted as follows: \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\). }\\ \end{longtable}")

	 
gen yes_1 = no_1 == 0
gen yes_2 = no_2 == 0
gen yes_3 = no_3 == 0
gen yes_4 = no_4 == 0

balancetable (mean if yes_4==1)  ///
	(diff yes_3 if yes_4 == 1) ///
	(diff yes_2 if yes_4 == 1) ///
	(diff yes_1 if yes_4 == 1) ///
	$bc_var using "balancesurveys_nostrat_fu2.tex",  ///
	longtable nonumbers ctitles("\shortstack{ At \\ Least  \\ SSS }" "\shortstack{ At \\ Least  \\ Contact }" "\shortstack{ At \\ Least  \\ Phone }" "\shortstack{ At \\ Least  \\ School }" ) replace varlabels vce(cluster schoolid) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Across Survey Types \label{balancesurveys}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{5}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain. First column reports } \\" "\multicolumn{5}{l}{mean outcomes for those who have a school, phone, contact, or short school survey.} \\" "\multicolumn{5}{l}{Second column reports difference between previous sample and sample without } \\" "\multicolumn{5}{l}{school, phone or contact survey. Third reports difference with sample only} \\"  "\multicolumn{5}{l}{ without SSS school or phone survey. Fourth reports difference with sample} \\"  "\multicolumn{5}{l}{without school survey. Errors clustered at school level.} \\" "\end{longtable}")
	 
stop
	*/ 
	

*with interactions

/*
reg no_1 i.treatment_status##c.planning i.strata, cluster(schoolid)
qui sum no_1 if treatment_status == 1
estadd scalar cont = r(mean)
est sto reg4

reg no_1 i.treatment_status##c.planning i.strata $controls, cluster(schoolid)
qui sum no_1 if treatment_status == 1
estadd scalar cont = r(mean)
est sto reg5

esttab reg1 reg2 reg3  using ///
	"attritioncluster1_fu2.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
	nonumbers title("No School Survey at $2^{nd}$ follow-up, treatment and controls \label{attritioncluster1}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	addnotes("Errors are clustered at the school level." ) longtable label
*/
	
eststo clear
	

stop
	
	
	
	
	
foreach v of global outcomes {
	local l`v' : variable label `v'
	di `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
  	}
 }
 
 foreach v of global controls {
	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
  	}
 }

preserve

collapse no_1 treatment_status strata $outcomes $controls, by(schoolid)


 foreach v of global outcomes {
	label var `v' "`l`v''"
 }
 
 
 foreach v of global controls {
 	label var `v' "`l`v''"
 }
 
*without interactions

reg no_1 i.treatment_status i.strata
est sto reg1

reg no_1 i.treatment_status  i.strata $outcomes
est sto reg2

reg no_1 i.treatment_status i.strata $outcomes $controls
est sto reg3

reg no_1 i.treatment_status##c.planning i.strata
est sto reg4

reg no_1 i.treatment_status##c.planning i.strata $controls
est sto reg5

esttab reg1 reg2 reg3 reg4 reg5 using ///
	"attritionschools_fu2.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	nonumbers title("Attrited at $2^{nd}$ follow-up, treatment and controls, school averages \label{attritionschools}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	 longtable label

restore

stop

********************PARTICIPATION BY STAGE AND TREATMENT ARM********************

*baseline

m: obs = J(5,5,.)

qui count if treatment_status == 1
local N2 = `r(N)'

qui count if treatment_status == 2
local N3 = `r(N)'

qui count if treatment_status == 3
local N4 = `r(N)'

qui count if treatment_status == 4
local N5 = `r(N)'

m: obs[1,2] = strtoreal(st_local("N2"))
m: obs[1,3] = strtoreal(st_local("N3"))
m: obs[1,4] = strtoreal(st_local("N4"))
m: obs[1,5] = strtoreal(st_local("N5"))
m: obs[1,1] = obs[1,2] + obs[1,3] + obs[1,4] + obs[1,5]

*sensibilization

qui count if treatment_status == 1 & sensibilized == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & sensibilized == 1
local N3 = `r(N)'


qui count if treatment_status == 3 & sensibilized == 1
local N4 = `r(N)'

qui count if treatment_status == 4 & sensibilized == 1
local N5 = `r(N)'

m: obs[2,2] = 0
m: obs[2,3] = strtoreal(st_local("N3"))
m: obs[2,4] = strtoreal(st_local("N4"))
m: obs[2,5] = strtoreal(st_local("N5"))
m: obs[2,1] = obs[2,2] + obs[2,3] + obs[2,4] + obs[2,5]

m: obs[3,1] = round(obs[2,1]/obs[1,1], .01)
m: obs[3,2] = 0
m: obs[3,3] = round(obs[2,3]/obs[1,3], .01)
m: obs[3,4] = round(obs[2,4]/obs[1,4], .01)
m: obs[3,5] = round(obs[2,5]/obs[1,5], .01)


*follow-up


qui count if treatment_status == 1 & duplic == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & duplic == 1
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & duplic == 1
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & duplic == 1
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[4,2] = strtoreal(st_local("N2"))
m: obs[4,3] = strtoreal(st_local("N3"))
m: obs[4,4] = strtoreal(st_local("N4"))
m: obs[4,5] = strtoreal(st_local("N5"))
m: obs[4,1] = obs[4,2] + obs[4,3] + obs[4,4] + obs[4,5]

m: obs[5,1] = round(obs[4,1]/obs[1,1], .01)
m: obs[5,2] = round(obs[4,2]/obs[1,2], .01)
m: obs[5,3] = round(obs[4,3]/obs[1,3], .01)
m: obs[5,4] = round(obs[4,4]/obs[1,4], .01)
m: obs[5,5] = round(obs[4,5]/obs[1,5], .01)

m: st_matrix("obs", obs)
matrix colnames obs = `" "All"" Control" "Risk" "Econ" "Double" "'
matrix rownames obs = `" "Baseline"   "Participants in the intervention" "Fraction of Baseline"  "Follow-up" "Fraction of Baseline" "'

outtable  using attrition, mat(obs) nobox replace caption("Number of observations by treatment arm and round \label{attrition}")

