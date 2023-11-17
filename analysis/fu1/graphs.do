clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/analysis/guinea_final_dataset.dta

cd "$main/Draft/figures"

destring schoolid_str, gen(schoolid)

merge m:1 schoolid using "$main/Data/output/analysis/stratum_by_school.dta"

tsset id_number time

gen female = sec0_q2 - 1
gen male = female == 0

gen 	desire = sec2_q1
replace desire = 0 if desire == 2

gen 	planning = sec2_q4
replace planning = 0 if planning == 2
replace planning = 0 if desire == 0

gen 	prepare = sec2_q7
replace prepare = 0 if prepare == 2
replace prepare = 0 if planning == 0

duplicates tag id_number, generate(duplic)

gen lost = duplic == 0



global controls  "i.treatment_status i.strata y" 

/*
preserve
fwer , dep_vars( sec1_6 sec1_7 ) treatvar( sec1_8 )
restore
*/
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'




				
******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				
global intention_table_legend = `" "(1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3)" "' ///
	+ `" "is \emph{preparing}. Errors are clustered at school level." "'

global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f.y $controls, cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	

	
}


 
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/9, valuelabel) 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	graphregion(color(white)) ///
	text(0.02 2 "Risk") text(0.02 5 "Econ") text(0.02 8 "Double")
	 
*graph save Graph "migrationoutcomes.gph", replace
*graph export "migrationoutcomes.png ", replace

restore

	



**********************************RISK*OUTCOMES*********************************


	
global routes_list = "Italy Spain"

foreach route_u in $routes_list {
	
	est clear
	
	local route = lower("`route_u'")
	
	global winsor = "`route'_duration `route'_journey_cost"
	
	foreach y in $winsor {
		gen `y'_winsor = `y'
		qui sum `y', detail
		replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)'
		replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)'
		gen log`y'_winsor = log(1 + `y'_winsor)
	}

	
	global `route'_outcomes =  " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	

	

	global risks_plot_list " "
	global risks_plot_nolog_list " "

	local n_outcomes `: word count $`route'_outcomes'
	local n_rows = `n_outcomes'*3
	mat R=J(`n_rows',4,.)

	local n = 0
	
	foreach y in $`route'_outcomes {

		local n = `n' + 1

		gen y = `y'
		eststo: reg f.y $controls, cluster(schoolid_str)
		
		local n_treat=1
	
		foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
	
			local row = `n_outcomes'*(`n_treat'-1) + `n'
			mat R[`row',1]=_b[`X']
			mat R[`row',2]=_b[`X']-1.96*_se[`X']
			mat R[`row',3]=_b[`X']+1.96*_se[`X']
			mat R[`row',4]=`row'

		local ++n_treat
		}
		
		qui sum y if time == 1 & treatment_status == 1
		estadd scalar cont = r(mean)
		drop y
		
	
	
		
	}
	
	preserve

	clear
	svmat R
				
	la var R4 Outcome
	la var R1 "Effect"
	label define groups 1 "Beaten" 2 "Forced Work" 3 "Kidnapped" ///
		4 "Death bef. boat" 5 "Death boat" 6 "Sent Back" ///
		7 "Beaten" 8 "Forced Work" 9 "Kidnapped" ///
		10 "Death bef. boat" 11 "Death boat" 12 "Sent Back" ///
		13 "Beaten" 14 "Forced Work" 15 "Kidnapped" ///
		16 "Death bef. boat" 17 "Death boat" 18 "Sent Back" 
	label values R4 groups


	set scheme s2mono
		
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
		(rcap R3 R2 R4, lc(gs5))	, ///
		legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
		xline(6.5, lpattern(-) lcolor(black)) 	///
		xline(12.5, lpattern(-) lcolor(black)) 	///
		graphregion(color(white)) ///
		ylabel(0(3)18) ///
		text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	*graph save Graph "`route_u'outcomes.gph", replace
	*graph export "`route_u'outcomes.png ", replace
	
	restore


	
}



********************************ECONOMIC*OUTCOMES*******************************




replace sec3_35 = . if sec3_35 > 100
replace sec3_41 = . if sec3_41 > 100

rename sec3_32 finding_job
rename sec3_35 continuing_studies
rename sec3_36 becoming_citizen
rename sec3_37 return_5yr
rename sec3_39 government_financial_help
rename sec3_40 asylum
rename sec3_41 in_favor_of_migration

replace  return_5yr = -return_5yr

global economic_outcomes = " finding_job  " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " 
		





	


global economic_plot_list " "
global economic_plot_list_nolog " "




global regression_list " "



local n_outcomes `: word count $economic_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

est clear

local n = 0

foreach y in $economic_outcomes {
	local n = `n' + 1

	gen y = `y'
	eststo: reg f.y $controls, cluster(schoolid_str)

	local n_treat=1

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {

		local row = `n_outcomes'*(`n_treat'-1) + `n'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
		
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	
}

preserve

clear
svmat R

global economic_titles = `" " \shortstack{(1)\\ Finding \\ Job} " "' ///
			+ `" "\shortstack{(3)\\ Contin. \\ Studies}" "' ///
			+ `" "\shortstack{(4)\\ Becom. \\ Citiz.}" "' ///
			+ `" "\shortstack{(5)\\ Return \\ 5 yrs}" "' ///
			+ `" "\shortstack{(6)\\ Finan. \\ help}""' ///
			+ `" "\shortstack{(7) \\ Getting \\ Asyl.}" "' ///
			+ `" "\shortstack{(8) \\ Favor \\ migr.}" "' ///
			+ `" "\shortstack{(9) \\ Cost \\ living}" "' ///
			+ `" "\shortstack{(10) \\ PCA \\ econ.}" "'
			
			
la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Finding Job" 2 "Contin. Studies" 3 "Becom. Citiz." ///
	4 "Not Sent Back" 5 "Financial help" 6 "Getting Asylum" ///
	7 "Favor Migration" ///
	8 "Finding Job" 9 "Contin. Studies" 10 "Becom. Citiz." ///
	11 "Not Sent Back" 12 "Financial help" 13 "Getting Asylum" ///
	14 "Favor Migration" ///
	15 "Finding Job" 16 "Contin. Studies" 17 "Becom. Citiz." ///
	18 "Not Sent Back" 19 "Financial help" 20 "Getting Asylum" ///
	21 "Favor Migration"
label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

*graph save Graph "economicoutcomes.gph", replace
*graph export "economicoutcomes.png ", replace
	
restore



*******************************BASELINE*BELIEFS********************************


/*asylum*/
qui sum asylum
twoway (hist asylum, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Asylum (Prob.)") freq discrete  width(5) leg(off) xline(`r(mean)', lpattern(-) lcolor(black))) (hist asylum if asylum >= 20, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(asylum)
/*21/100 first instance for guineans between 18 and 34 in France, Italy, and Spain (same as final)*/


/*studies*/
qui sum continuing_studies
twoway (hist continuing_studies , graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Cont. education (Prob.)") freq discrete  width(5) leg(off) xline(`r(mean)', lpattern(-) lcolor(black))) (hist continuing_studies if continuing_studies >= 30 , graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(continuing_studies)
/*32/100 people in Spain Italy and France arrived in the last 3 years educstat (same as educ4wn if more than 20 hours)*/

/*job*/
qui sum finding_job
twoway (hist finding_job, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Employment (Prob.)") freq discrete  width(5) leg(off) xline(`r(mean)', lpattern(-) lcolor(black))) (hist finding_job if finding_job >= 30, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(finding_job)
/*22/100 people in Spain Italy and France arrived in the last 3 years ilostat*/


/*beaten*/
qui sum italy_beaten
twoway (hist italy_beaten, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Violence (Prob.)") freq discrete  width(5) leg(off) xline(`r(mean)', lpattern(-) lcolor(black))) (hist italy_beaten if italy_beaten < 71, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(italy_beaten)
/*76/100 male 65 women IOM trafficking -> 70.5 in sample*/

/*forced_work*/
qui sum italy_forced_work
twoway (hist italy_forced_work, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Forced to Work (Prob.)") freq discrete  width(5) leg(off) xline(`r(mean)', lpattern(-) lcolor(black))) (hist italy_forced_work if italy_forced_work <= 90, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)),  name(italy_forced_work)
/*90/100 harrowing figure for all (no disaggregated figure available, but conditions on guinea)*/


/*duration*/
gen italy_duration_winsor_cor = round(italy_duration_winsor)
qui sum italy_duration_winsor_cor
twoway (hist italy_duration_winsor_cor, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Journey Durat. (Mon. wins.)") freq discrete  width(5) leg(off) xline(`r(mean)', lpattern(-) lcolor(black))) (hist italy_duration_winsor_cor if italy_duration_winsor_cor < 6, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)),  name(italy_duration_winsor_cor)
/*46/100 harrowing figure for all (no disaggregated figure available, but conditions on guinea)*/


graph combine   italy_forced_work italy_beaten italy_duration_winsor_cor  asylum   finding_job  continuing_studies

graph export "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo/presentations/f4t_15112019/beliefs.pdf", as(pdf) name("Graph") replace

