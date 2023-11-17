clear all

set more off

*global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/followup2/BME_final.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

cd "$main/Draft/tables/jul_2020"

tsset id_number time

global controls  "i.treatment_status i.strata" 
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'
	 
*Auxiliary variables for fwer.
gen sid = schoolid
drop treated_dummy1
tab treatment_status, gen(treated_dummy)
global treatment_dummies " treated_dummy2 treated_dummy3 treated_dummy4 "
gen trtmnt = .
local n_rep 1000




*HIGH DURABLES

clear all

set more off

use ${main}/Data/output/followup2/BME_final.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

cd "$main/Draft/tables/jul_2020"

tsset id_number time

global controls  "i.treatment_status i.strata" 
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'
	 
*Auxiliary variables for fwer.
gen sid = schoolid
drop treated_dummy1
tab treatment_status, gen(treated_dummy)
global treatment_dummies " treated_dummy2 treated_dummy3 treated_dummy4 "
gen trtmnt = .

replace durables50 = l2.durables50 if time == 2

keep if durables50 == 1 | time > 0

******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				


global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls y, cluster(schoolid_str)
	
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
	
	

	qui sum y if time == 2 & treatment_status == 1 & durables50 == 1
	estadd scalar cont = r(mean)
	drop y
	
	

	
}

/*
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
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore
*/

esttab using ///
"migrationintentionshighdurables_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant" y "Outcome at Basel.") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Migration intentions at $2^{nd}$ F. U. (Only High Durables) \label{migrationintentionshighdurablesfu2}) /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \multicolumn{4}{p{12cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

eststo clear


	


**********************************RISK*OUTCOMES*********************************


 global appendix_table_titles =  `" "\shortstack{(1) \\ Kling \\ Cost+ \\ Ita }" "'  ///
								+ `" "\shortstack{(2) \\ Kling \\ Cost- \\ Ita }" "' ///
								+ `" "\shortstack{(3) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\shortstack{(4) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\shortstack{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				
			

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
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep'  i.strata,  clus(sid)
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
		qui reg f2.y $controls y, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1 & durables50 == 1
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
	
	/*
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

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.png , replace
	
	restore
	
	*/

	esttab $main_reg using ///
		"`route_u'outcomeshighdurables_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U. (Only High Durables) \label{`route_u'outcomeshighdurablesfu2}) /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")
	
	estimates drop $main_reg 
	
	
}
	
********************************ECONOMIC*OUTCOMES*******************************


global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " economic_index "

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
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep' i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $economic_outcomes {
		di "  - `var'"
	}
	
	preserve
	
	fwer , dep_vars($economic_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}/Draft/tables/provvisoria_con_lag/provvisoria_con_lagfwer,  firstrow(var) sheet(labor, replace) 
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
	qui reg f2.y $controls y, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1 & durables50 == 1
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
/*
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

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.png , replace
	
restore
*/

esttab  $main_reg using ///
	"economicoutcomeshighdurables_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Perceptions about econ. outcomes at $2^{nd}$ F. U. (Only High Durables) \label{economicoutcomeshighdurables}) /// 
	mtitles($economic_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")



esttab $appendix_reg using ///
	"appendixoutcomeshighdurables_fu2.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers title(Impacts on Kling (2007) at $2^{nd}$ F. U. Indexes (Only High Durables) \label{appendixoutcomeshighdurables}) /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")







*LOW DURABLES

clear all

set more off

use ${main}/Data/output/followup2/BME_final.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

cd "$main/Draft/tables/jul_2020"

tsset id_number time

global controls  "i.treatment_status i.strata" 
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'
	 
*Auxiliary variables for fwer.
gen sid = schoolid
drop treated_dummy1
tab treatment_status, gen(treated_dummy)
global treatment_dummies " treated_dummy2 treated_dummy3 treated_dummy4 "
gen trtmnt = .

replace durables50 = l2.durables50 if time == 2

keep if durables50 == 0 | time > 0

******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				


global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls y, cluster(schoolid_str)
	
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
	
	

	qui sum y if time == 2 & treatment_status == 1 & durables50 == 0
	estadd scalar cont = r(mean)
	drop y
	
	

	
}

/*
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
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore
*/

esttab using ///
"migrationintentionslowdurables_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Migration intentions at $2^{nd}$ F. U. (Only Low Durables) \label{migrationintentionslowdurablesfu2}) /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \multicolumn{4}{p{12cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

eststo clear


	


**********************************RISK*OUTCOMES*********************************


 global appendix_table_titles =  `" "\shortstack{(1) \\ Kling \\ Cost+ \\ Ita }" "'  ///
								+ `" "\shortstack{(2) \\ Kling \\ Cost- \\ Ita }" "' ///
								+ `" "\shortstack{(3) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\shortstack{(4) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\shortstack{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				
			

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
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep'  i.strata,  clus(sid)
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
		qui reg f2.y $controls y, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1 & durables50 == 0
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
	
	/*
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

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.png , replace
	
	restore
	
	*/

	esttab $main_reg using ///
		"`route_u'outcomeslowdurables_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U. (Only Low Durables) \label{`route_u'outcomeslowdurablesfu2}) /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")
	
	estimates drop $main_reg 
	
	
}
	
********************************ECONOMIC*OUTCOMES*******************************


global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " economic_index "

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
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep' i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $economic_outcomes {
		di "  - `var'"
	}
	
	preserve
	
	fwer , dep_vars($economic_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}/Draft/tables/provvisoria_con_lag/provvisoria_con_lagfwer,  firstrow(var) sheet(labor, replace) 
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
	qui reg f2.y $controls y, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1 & durables50 == 0
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
/*
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

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.png , replace
	
restore
*/

esttab  $main_reg using ///
	"economicoutcomeslowdurables_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Perceptions about econ. outcomes at $2^{nd}$ F. U. (Only Low Durables) \label{economicoutcomeslowdurables}) /// 
	mtitles($economic_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")



esttab $appendix_reg using ///
	"appendixoutcomeslowdurables_fu2.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers title(Impacts on Kling (2007) at $2^{nd}$ F. U. Indexes (Only Low Durables) \label{appendixoutcomeslowdurables}) /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")
