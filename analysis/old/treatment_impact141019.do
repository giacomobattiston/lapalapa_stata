clear all

set more off

global main "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/analysis/guinea_final_dataset.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

cd "$main/Draft/tables"

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
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'
	 
		
gen sid = schoolid
tab treatment_status, gen(treated_dummy)
global treatment_dummies " treated_dummy2 treated_dummy3 treated_dummy4 "
gen trtmnt = .
local n_rep 1000

/*
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
	 
*graph save Graph ${main}/Draft/figures/migrationoutcomes.gph, replace
*graph export ${main}/Draft/figures/migrationoutcomes.png, replace

restore

/*
esttab using ///
"migrationintentions.tex", replace stats(cont N, label( "Follow-up Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
y "Outcome at baseline" _cons "Constant") se ///
nonumbers title(Migration intentions \label{migrationintentions}) /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
addnotes($intention_table_legend)
*/
 



 global appendix_table_titles =  `" "\shortstack{(1) \\ Kling \\ Cost+ \\ Ita }" "'  ///
								+ `" "\shortstack{(2) \\ Kling \\ Cost- \\ Ita }" "' ///
								+ `" "\shortstack{(3) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\shortstack{(4) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\shortstack{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				


**********************************RISK*OUTCOMES*********************************

				
global risks_table_legend = `" "Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.)," "' ///
				+ `" "(3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying" "' ///
				+ `" "before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions." "' ///
				+ `" "F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets." "' 

global risks_table_titles = `" " \shortstack{(1) \\  \(sinh^{-1}\)  \\ Journey \\ Duration }" "' ///
				+ `" " \shortstack{(2)\\  \(sinh^{-1}\) \\ Journey\\ Cost}" "' ///
				+ `" " \shortstack{(3)\\ Being \\ Beaten \\ \vphantom{foo}}" "' ///
				+ `" "\shortstack{(4)\\ Forced \\  to \\ Work}" "' /// 
				+ `" "\shortstack{(5) \\ Being \\ Kidnap- \\ ped}" "' ///
				+ `" "\shortstack{(6)\\ Death \\ before \\ boat}" "' ///
				+ `" "\shortstack{(7)\\ Death \\ in \\ boat}" "' /// 
				+ `" "\shortstack{(8)\\ Sent \\ Back \\ \vphantom{foo}}" "' ///
				+ `" "\shortstack{(9) \\ PCA \\ Risk \\ \vphantom{foo}}" "' 
	
global routes_list = "Italy Spain"

global appendix_reg " "

foreach route_u in $routes_list {
	
	*est clear
	
	local route = lower("`route_u'")
	
	global winsor = "`route'_duration `route'_journey_cost"
	
	
	
	foreach y in $winsor {
		gen `y'_winsor = `y'
		qui sum `y', detail
		replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)'
		replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)'
		gen asinh`y'_winsor = asinh(`y'_winsor)
	}

	
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	global main_reg " "
	
	
	*est clear

	forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global `route'_outcomes {  
				char define `dep'[_spec] reg `dep' \`treatvar' `other_treatvar' l.`dep' i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}

	preserve
	fwer , dep_vars($`route'_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}\fwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}
	

	***********************************KLING***********************************
	local n_outcomes `: word count $`route'_outcomes'
	
	gen `route'_kling_poscost = 0
	
	local n_kling = 1
	

	foreach y in $`route'_outcomes {
		qui sum `y', detail
		replace `route'_kling_poscost =  `route'_kling_poscost + (1/`n_outcomes')*(`y' - `r(mean)')/`r(sd)'
		local `n_kling' = `n_kling' + 1
		}
		

	*positive to negative
	replace asinh`route'_journey_cost_winsor = -asinh`route'_journey_cost_winsor	
	
	gen `route'_kling_negcost = 0
	
	local n_kling = 1
	
	foreach y in $`route'_outcomes {
			qui sum `y', detail
			replace `route'_kling_negcost =  `route'_kling_negcost + (1/`n_outcomes')*(`y' - `r(mean)')/`r(sd)'
		local `n_kling' = `n_kling' + 1
		}
	
	*negative to positive
	replace asinh`route'_journey_cost_winsor = -asinh`route'_journey_cost_winsor
		
	
	***********************************PCA**************************************
	qui pca $`route'_outcomes, factor(1)
	predict `route'_index
	
	global `route'_outcomes $`route'_outcomes  `" `route'_index "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_poscost "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_negcost "'

	global risks_plot_list " "
	global risks_plot_noasinh_list " "

	
	local n_outcomes `: word count $`route'_outcomes'
	local n_rows = (`n_outcomes' - 5)*3
	mat R=J(`n_rows',5,.)

	local n = 0
	local ng = 0
	
	foreach y in $`route'_outcomes {

		local n = `n' + 1
		
		if (`n' < 9) {
		matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}

		gen y = `y'
		qui reg f.y $controls, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 1 & treatment_status == 1
		estadd scalar cont = r(mean)
		if (`n' < 9) {
		estadd matrix pfwer = pfwer
		}
		drop y
		
		if (`n' < 10) {
			global main_reg $main_reg reg_`route'_`n'
		}
		else {
			global appendix_reg $appendix_reg reg_`route'_`n'
		}
		
		if (`n' < 9)&(`n' > 2) {
		local n_treat=1
		local ++ng

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		local row = (`n_outcomes'-5)*(`n_treat'-1) + `ng'
		
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'
		mat R[`row',5]= pfwer[1, `n_treat']
				
	local ++n_treat
	}
	}
		
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
	la var R5 "p_fwer"
	
	set scheme s2mono
		
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
		(rcap R3 R2 R4, lc(gs5))	, ///
		legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
		xline(6.5, lpattern(-) lcolor(black)) 	///
		xline(12.5, lpattern(-) lcolor(black)) 	///
		graphregion(color(white)) ///
		ylabel(0(3)18) ///
		text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/`route_u'outcomes.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_pfwer.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_pfwer.png , replace
	
	restore
	
	
	/*
	esttab $main_reg using ///
		"`route_u'outcomes.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		nonumbers title(Risk perceptions for route through `route_u' \label{`route_u'outcomes}) /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
		addnotes($risks_table_legend)
	*/
	estimates drop $main_reg 
		
	
}


*/


********************************ECONOMIC*OUTCOMES*******************************

local euro_fg = 10400

gen sec3_42_corrected = sec3_42
replace sec3_42_corrected = sec3_42_corrected*1000000 if sec3_42_corrected < 999
replace sec3_42_corrected = sec3_42_corrected*1000 if sec3_42_corrected < 999999

replace sec3_35 = . if sec3_35 > 100
replace sec3_41 = . if sec3_41 > 100

rename sec3_32 finding_job
gen expected_wage = expectation_wage/`euro_fg'
rename sec3_35 continuing_studies
rename sec3_36 becoming_citizen
rename sec3_37 return_5yr
rename sec3_39 government_financial_help
rename sec3_40 asylum
rename sec3_41 in_favor_of_migration
gen expected_living_cost = sec3_42_corrected/`euro_fg'

global winsor = "expected_wage expected_living_cost"

foreach y in $winsor {
	gen `y'_winsor = `y'
	qui sum `y', detail
	replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)'
	replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)'
	gen asinh`y'_winsor = asinh(`y'_winsor)
}

global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexpected_living_cost_winsor " ///
						+ " asinhexpected_wage_winsor " ///

global economic_titles = `" " \shortstack{(1)\\ Finding \\ Job} " "' ///
			+ `" "\shortstack{(2)\\ Contin. \\ Studies}" "' ///
			+ `" "\shortstack{(3)\\ Becom. \\ Citiz.}" "' ///
			+ `" "\shortstack{(4)\\ Return \\ 5 yrs}" "' ///
			+ `" "\shortstack{(5)\\ Finan. \\ Help}""' ///
			+ `" "\shortstack{(6) \\ Getting \\ Asyl.}" "' ///
			+ `" "\shortstack{(7) \\ Favor \\ Migr.}" "' ///
			+ `" "\shortstack{(8) \\  \(sinh^{-1}\) \\ Liv. Cost}" "' ///
			+ `" "\shortstack{(9)\\ \(sinh^{-1}\) \\ Wage}" "' ///
			+ `" "\shortstack{(10) \\ PCA \\ econ}" "' 
			
**************************************FWER**************************************

*est clear

forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global economic_outcomes {  
				char define `dep'[_spec] reg `dep' \`treatvar' `other_treatvar' l.`dep' i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $economic_outcomes {
		di "  - `var'"
	}

	preserve
	fwer , dep_vars($economic_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}/Draft/tables/fwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}

***********************************KLING***********************************
local n_outcomes `: word count $economic_outcomes'

gen economic_kling = 0

local n_kling = 1


replace return_5yr = -return_5yr
foreach y in $economic_outcomes {
	qui sum `y', detail
	replace economic_kling =  economic_kling - (1/`n_outcomes')*(`y' - `r(mean)')/`r(sd)'
	local `n_kling' = `n_kling' + 1
	}
replace return_5yr =-return_5yr
		
		
qui pca $economic_outcomes, factor(1)
predict economic_index
	
global economic_outcomes $economic_outcomes  `" economic_index "'
global economic_outcomes $economic_outcomes  `" economic_kling "'


global economic_table_legend = `" "Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, " "' ///
			+ `" "(4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, " "' /// 
			+ `" " if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.)," "' ///
			+ `" "  (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes." "' ///
			+ `" "   Errors are clustered at school level. F.U. Cont. represents average in control group at midline. " "' ///
			+ `" "  Errors are clustered at school level in round brackets. Fwer p-values in square brackets." "' 

global economic_plot_list " "
global economic_plot_list_noasinh " "




local n_outcomes `: word count $economic_outcomes'
local n_rows = (`n_outcomes' - 3)*3
mat R=J(`n_rows',5,.)

global main_reg " "
	
*est clear

local n = 0
local ng = 0

foreach y in $economic_outcomes {

	local n = `n' + 1
	
	if (`n' < 10) {
	matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f.y $controls, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	if (`n' < 10) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 11) {	
		global main_reg $main_reg reg_econ_`n'
		}
	else {
		global appendix_reg $appendix_reg reg_econ_`n'
	}
	
	/* store estimates and CIs for graphs for all probabilistic outcomes */
	if (`n' < 8){
	local n_treat=1
	local ++ng

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		local row = (`n_outcomes'-4)*(`n_treat'-1) + `ng'
		
		local k = 1
		if `ng' == 4 {
		local k = -1
		}
		mat R[`row',1]=`k'*_b[`X']
		mat R[`row',2]=`k'*_b[`X']-1.96*_se[`X']
		mat R[`row',3]=`k'*_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'
		mat R[`row',5]= pfwer[1, `n_treat']
		
	local ++n_treat
	}
	}
	
}

preserve
clear
svmat R

			
			
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
la var R5 "p_fwer"

set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/economicoutcomes.gph, replace
graph export ${main}/Draft/figures/economicoutcomes.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/economicoutcomes_pfwer.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_pfwer.png , replace
	
restore


esttab  $main_reg using ///
	"economicoutcomes.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Perceptions about economic outcomes  \label{economicoutcomes}) /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	addnotes($economic_table_legend)  


global appendix_table_legend = `" "Dependent variable in (1) is aggregator of Italy risk perceptions based on  " "' ///
				+ `" "Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same," "' /// 
				+ `" "for Spain. (5) is Kling aggregator for perceptions about economic outcomes." "' /// 
				+ `" "F.U. Cont. represents average in control group at midline." "'  ///
				+ `" "Errors are clustered at school level."  "'

esttab $appendix_reg using ///
	"appendixoutcomes.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	nonumbers title(Impacts on Kling (2007) Indexes \label{appendixoutcomes}) /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	addnotes($appendix_table_legend)
	
	stop

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
*****SLIDES ONLY
	
global italy_other_risk = " asinhitaly_duration_winsor " ///
						+ " asinhitaly_journey_cost_winsor " ///
						+ " italy_index " 
												
global italy_other_risk_titles = `" " \shortstack{ \(sinh^{-1}\)  \\ Duration }" "' ///
				+ `" " \shortstack{ \(sinh^{-1}\) \\ Cost  }" "' ///
				+ `" " \shortstack{ PCA \\ Risk }" "'

global italy_other_risk_reg = ""
local n = 0
foreach y in $italy_other_risk {
	local ++n
	gen y = `y'
	qui reg f.y $controls, cluster(schoolid_str)
	est sto reg_italy_other_risk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)

	drop y

	global italy_other_risk_reg $italy_other_risk_reg reg_italy_other_risk_`n'
	
}


esttab $italy_other_risk_reg using ///
	"italy_other_risk.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	nonumbers  /// 
	mtitles($italy_other_risk_titles) ///
	nobaselevels
	
				
				
				
				
				
				
global spain_other_risk = " asinhspain_duration_winsor " ///
						+ " asinhspain_journey_cost_winsor " ///
						+ " spain_index " 
												
global spain_other_risk_titles = `" " \shortstack{ \(sinh^{-1}\)  \\ Duration }" "' ///
				+ `" " \shortstack{ \(sinh^{-1}\) \\ Cost  }" "' ///
				+ `" " \shortstack{ PCA \\ Risk }" "'

global spain_other_risk_reg = ""
local n = 0
foreach y in $spain_other_risk {
	local ++n
	gen y = `y'
	qui reg f.y $controls, cluster(schoolid_str)
	est sto reg_spain_other_risk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)

	drop y

	global spain_other_risk_reg $spain_other_risk_reg reg_spain_other_risk_`n'
	
}


esttab $spain_other_risk_reg using ///
	"spain_other_risk.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	nonumbers  /// 
	mtitles($spain_other_risk_titles) ///
	nobaselevels
	
	






		
				
				
				
						
global other_econ =" asinhexpected_wage_winsor " ////
				+ " asinhexpected_living_cost_winsor " ///
					+ " economic_index "
					
global other_econ_titles = `" " \shortstack{ \(sinh^{-1}\)  \\ Wage }" "' ///
				+ `" " \shortstack{ \(sinh^{-1}\) \\ Cost  }" "' ///
				+ `" " \shortstack{ PCA \\ Econ }" "'

global other_econ_reg = ""
local n = 0
foreach y in $other_econ {
	local ++n
	gen y = `y'
	qui reg f.y $controls, cluster(schoolid_str)
	est sto reg_other_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)

	drop y

	global other_econ_reg $other_econ_reg reg_other_econ_`n'
	
}


esttab $other_econ_reg using ///
	"other_econ.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	nonumbers  /// 
	mtitles($other_econ_titles) ///
	nobaselevels
	

						
***********************SELLING*AN*ASSET*TO*FINANCE*MIGRATION********************

gen asset = mig_asset == 1 if !missing(mig_asset)
replace asset = 0 if sell_asset == 2

reg asset i.treatment_status i.strata if time == 1, cluster(schoolid)
reg asset i.treatment_status i.strata l.prepare, cluster(schoolid)


**************************CLASSMATES*WHO*HAVE*MIGRATED**************************

gen migclass = sec9_q2
qui sum migclass, detail
replace migclass = `r(p95)' if migclass > `r(p95)'

reg f.migclass i.treatment_status i.strata, cluster(schoolid)
reg f.migclass i.treatment_status i.strata migclass, cluster(schoolid)



*gender
		rename sec0_q2 gender
		replace gender=0 if gender==2

*generating age
		gen age=(starttime_new_date-sec0_q3)/365.25
		label variable age "Age"
		*dealing with aberrant data : 
		replace age=. if age<=10 | age >30
		
								
*contacts_winsor
		gen contacts_winsor = outside_contact_no
		qui sum contacts_winsor, detail
		replace contacts_winsor = `r(p95)' if contacts_winsor > `r(p95)' &	!missing(contacts_winsor)						
							

		
gen italy_unkown = italy_awareness == 5 if  !missing(italy_awareness)
gen spain_unkown = spain_awareness == 5 if  !missing(spain_awareness)
gen italian_route = sec3_22 == 1 if !missing(sec3_21)

gen country_string = sec3_21 if sec3_21 == "FRANCE" | sec3_21 == "ITALY" | sec3_21 == "GERMANY" | sec3_21 == "BELGIUM" | sec3_21 == "SPAIN" | sec3_21 == "ENGLAND"
encode country_string, gen(country)

reg italian_route i.treatment_status i.strata l.italian_route ib5.country, cluster(schoolid)

gen italy_destination = country == 5 & !missing(country)

		
gen diff_sent_back = italy_sent_back - spain_sent_back
gen diff_die_boat = italy_die_boat - spain_die_boat
gen diff_die_bef_boat = italy_die_bef_boat - spain_die_bef_boat
gen diff_kidnapped = italy_kidnapped - spain_kidnapped
gen diff_forced_work = italy_forced_work - spain_forced_work
gen diff_beaten = italy_beaten - spain_beaten
gen diff_asinhjourney_cost = asinhitaly_journey_cost - asinhspain_journey_cost
gen diff_asinhduration = asinhitaly_duration - asinhspain_duration
								


								
*reg italian_route   diff_forced_work   diff_asinhduration  if time == 0, cluster(schoolid)


/*
vediamo se hanno cambiato idea su rotte:
più probabilità ma su ita ma non significativa
effetto viene ridotto da country: trattati più likely italia
*/





