clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/followup2/BME_final.dta

global logs ${main}/logfiles/
global dta ${main}/Data/dta/

cd "${main}/Draft/"

tsset id_number time

global controls  "i.treatment_status i.strata" 

local n_rep 1000
local seed 1123

stop

* rstudteach rstudadmin rstudclass rstudroom rstudtoil rstudcomp rstudtele connexion library infirmary water separate_toilets ratio_tmale ratio_tmaster

* ground classi cosa fare?
* valori strani students teacher ratio


*net install wyoung, from("https://raw.githubusercontent.com/reifjulian/wyoung/controls-option") replace

 reg f2.visa_free i.treatment_status i.strata if schoolid != 911014,  cluster(schoolid)

		
		
		
jackknife, cluster(schoolid) idcluster(newclus) keep:  reg f2.migration_guinea i.treatment_status i.strata ,  cluster(schoolid)

assert e(N_misreps)==0
local N = e(N_clust)
gen dft2 = (_jk_2 - _b[2.treatment_status])/(`N'-1)

		
*BELSLEY KUH WELSCH 1980	

keep if  source_info_guinea < 4 | time == 0
reg f2.migration_guinea i.treatment_status i.strata , 

predict dft2, dfbeta (2.treatment_status)   
g cutoffdfbeta=abs(dft2)>2/sqrt(e(N))&e(sample)

reg f2.migration_guinea i.treatment_status i.strata if cutoffdfbeta == 0,  cluster(schoolid)

replace cutoffdfbeta = l2.cutoffdfbeta if time == 2

*BELSLEY KUH WELSCH 1980 ON CLUSTERS

preserve

keep if  source_info_guinea < 4 | time == 0
replace schoolid = l2.schoolid if time == 2

collapse (mean) migration_guinea (mean)  treatment_status (mean) strata, by(schoolid time)
tsset schoolid time

reg f2.migration_guinea i.treatment_status i.strata , 

predict dft2, dfbeta (2.treatment_status)   
g cutoffdfbeta=abs(dft2)>2/sqrt(e(N))&e(sample)
reg f2.migration_guinea i.treatment_status i.strata if cutoffdfbeta == 0

  
restore








reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea < 4 , cluster(schoolid)
local se2 = _se[2.treatment_status]
jackknife, cluster(schoolid) idcluster(newclus) keep: reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea < 4 , cluster(schoolid)
assert e(N_misreps)==0

local N = e(N_clust)
gen dfbeta_t2 = (_jk_2 - _b[2.treatment_status])/((`N'-1)*`se2')




		/*
***********************MIGRATION*GUINEA******************************



global mig_conkary_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'


global mig_guinea_outcomes "migration_guinea_1 migration_guinea_2 migration_guinea_3 migration_guinea_4 migration_guinea_5"

local n_outcomes `: word count $mig_guinea_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $mig_guinea_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls, cluster(schoolid_str)
	
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
	
	

	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	
}




esttab using ///
"migrationguinea_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Out of Conakry  at $2^{nd}$ F. U.  \label{migrationguineafu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ SSS (Stud.)  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ SSS (Admin.)  }" ///
	"\shortstack{(5) \\  Previous \\ and \\ Oth. Cont.  }") nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*postfoot("\hline\hline \multicolumn{6}{p{15.7cm}}{\footnotesize The dependent variable is being out of Guinea. In (1) we use only surveys with the subject (student)--in school or by phone; in (2) we use add information gathered from contacts (max 2) given by subject itself; in (3) we use add information given by students at school during the $2^{nd}$ F. U. tablet survey ; in (4) we use add information given by administration on the same occasion; (5) adds information from unstructured phone conversations with classmates. Errors are clustered at school  P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\). }\\ \end{tabular} \end{table}")



eststo clear


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
	
	

	qui sum y if time == 2 & treatment_status == 1
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
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore


esttab using ///
"migrationintentions_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant" y "Outcome at Baseline") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers  /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \end{tabular}}")

*postfoot("\hline\hline \multicolumn{4}{p{10.5cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Migration intentions at $2^{nd}$ F. U. \label{migrationintentionsfu2})

eststo clear

*/
	


*******************************RISK*OUTCOMES*FU2********************************


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
	
	di "`route'"
	
	global winsor = "`route'_duration `route'_journey_cost"
		
	global main_reg " "
		
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	

	global `route'_outcomes_bl " "
	foreach var in $`route'_outcomes {
		gen l2`var' = l2.`var'
		global `route'_outcomes_bl $`route'_outcomes_bl " l2`var'"
	}

	local n_outcomes `: word count $`route'_outcomes'

	* run all regressions and store results 
	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}


	wyoung $`route'_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($`route'_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	matrix define results = r(table)
	esttab matrix(results) using tables/fwer_`route'_fu2.xls, nomtitles replace

	matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
	matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
	matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]

	
	***********************************KLING***********************************
	
								
	global `route'_outcomes $`route'_outcomes  `" `route'_index "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_poscost "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_negcost "'

	local n_outcomes `: word count $`route'_outcomes'
	
	global risks_plot_list " "
	global risks_plot_noasinh_list " "

	local n_rows = (`n_outcomes' - 5)*3
	mat R=J(`n_rows',5,.)

	local n = 0
	local ng = 0

	foreach y in $`route'_outcomes {

		local n = `n' + 1
		
		if (`n' < 9) {
		matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}
		
		gen y = `y'
		reg f2.y $controls y, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1
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

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_fu2.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_fu2.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_pfwer_fu2.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_pfwer_fu2.png , replace
	
	restore
	
	
	esttab $main_reg using ///
		"tables/`route_u'outcomes_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers  /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
		postfoot("\hline\hline \end{tabular}}")

	estimates drop $main_reg 

	eststo clear
	
}

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U. \label{`route_u'outcomes_fu2})
	
	

*****************************ECONOMIC*OUTCOMES*FU2******************************


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


local n_outcomes `: word count $economic_outcomes'
	
global economic_outcomes_bl " "
foreach var in $economic_outcomes {
	gen l2`var' = l2.`var'
	global economic_outcomes_bl $economic_outcomes_bl  " l2`var'"
}


* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}


wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
controls($economic_outcomes_bl) ///
bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

matrix define results = r(table)
esttab matrix(results) using tables/fwer_economic_fu2.xls, nomtitles replace

	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
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
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f2.y $controls y, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1
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

graph save Graph ${main}/Draft/figures/economicoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_fu2.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/economicoutcomes_pfwer_fu2.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_pfwer_fu2.png , replace
	
restore


esttab  $main_reg using ///
	"tables/economicoutcomes_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")

*title(Perceptions about econ. outcomes at $2^{nd}$ F. U. \label{economicoutcomes_fu2})

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

esttab $appendix_reg using ///
	"tables/appendixoutcomes_fu2.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Impacts on Kling (2007) at $2^{nd}$ F. U.  Indexes \label{appendixoutcomes_fu2})




*HIGH DURABLES FU2

clear

set more off

use ${main}/Data/output/followup2/BME_final.dta

tsset id_number time

global controls  "i.treatment_status i.strata" 

replace durables50 = l2.durables50 if time == 2

keep if durables50 == 1 | time > 0




/*
***********************MIGRATION*GUINEA******************************



global mig_conkary_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'


global mig_guinea_outcomes "migration_guinea_1 migration_guinea_2 migration_guinea_3 migration_guinea_4 migration_guinea_5"

local n_outcomes `: word count $mig_guinea_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $mig_guinea_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls, cluster(schoolid_str)
	
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
	
	

	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	
}




esttab using ///
"migrationguinea_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Out of Conakry  at $2^{nd}$ F. U.  \label{migrationguineafu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ SSS (Stud.)  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ SSS (Admin.)  }" ///
	"\shortstack{(5) \\  Previous \\ and \\ Oth. Cont.  }") nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*postfoot("\hline\hline \multicolumn{6}{p{15.7cm}}{\footnotesize The dependent variable is being out of Guinea. In (1) we use only surveys with the subject (student)--in school or by phone; in (2) we use add information gathered from contacts (max 2) given by subject itself; in (3) we use add information given by students at school during the $2^{nd}$ F. U. tablet survey ; in (4) we use add information given by administration on the same occasion; (5) adds information from unstructured phone conversations with classmates. Errors are clustered at school  P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\). }\\ \end{tabular} \end{table}")



eststo clear


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
	
	

	qui sum y if time == 2 & treatment_status == 1
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
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore


esttab using ///
"migrationintentions_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant" y "Outcome at Baseline") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers  /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \end{tabular}}")

*postfoot("\hline\hline \multicolumn{4}{p{10.5cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Migration intentions at $2^{nd}$ F. U. \label{migrationintentionsfu2})

eststo clear
*/

	


*******************************RISK*OUTCOMES*FU2********************************


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
	
	di "`route'"
	
	global winsor = "`route'_duration `route'_journey_cost"
		
	global main_reg " "
		
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	

	global `route'_outcomes_bl " "
	foreach var in $`route'_outcomes {
		gen l2`var' = l2.`var'
		global `route'_outcomes_bl $`route'_outcomes_bl " l2`var'"
	}

	local n_outcomes `: word count $`route'_outcomes'

	* run all regressions and store results 
	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}


	wyoung $`route'_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($`route'_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	matrix define results = r(table)
	esttab matrix(results) using tables/fwer_`route'_fu2hd.xls, nomtitles replace

	matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
	matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
	matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]

	
	***********************************KLING***********************************
	
								
	global `route'_outcomes $`route'_outcomes  `" `route'_index "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_poscost "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_negcost "'
	local n_outcomes `: word count $`route'_outcomes'
		
	global risks_plot_list " "
	global risks_plot_noasinh_list " "

	local n_rows = (`n_outcomes' - 5)*3
	mat R=J(`n_rows',5,.)

	local n = 0
	local ng = 0

	foreach y in $`route'_outcomes {

		local n = `n' + 1
		
		if (`n' < 9) {
		matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}
		
		gen y = `y'
		qui reg f2.y $controls y, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1
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

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_fu2hd.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_fu2hd.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_pfwer_fu2hd.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_pfwer_fu2hd.png , replace
	
	restore
	
	
	esttab $main_reg using ///
		"tables/`route_u'outcomes_fu2hd.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers  /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
		postfoot("\hline\hline \end{tabular}}")

	estimates drop $main_reg 

	eststo clear
	
}

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U., High Durables \label{`route_u'outcomes_fu2hd})
	
	

*****************************ECONOMIC*OUTCOMES*FU2******************************


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


local n_outcomes `: word count $economic_outcomes'
	
global economic_outcomes_bl " "
foreach var in $economic_outcomes {
	gen l2`var' = l2.`var'
	global economic_outcomes_bl $economic_outcomes_bl  " l2`var'"
}


* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}


wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
controls($economic_outcomes_bl) ///
bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

matrix define results = r(table)
esttab matrix(results) using tables/fwer_economic_fu2hd.xls, nomtitles replace

	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
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
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f2.y $controls y, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1
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

graph save Graph ${main}/Draft/figures/economicoutcomes_fu2hd.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_fu2hd.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/economicoutcomes_pfwer_fu2hd.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_pfwer_fu2hd.png , replace
	
restore


esttab  $main_reg using ///
	"tables/economicoutcomes_fu2hd.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")

*title(Perceptions about econ. outcomes at $2^{nd}$ F. U., High Durables \label{economicoutcomes_fu2hd})

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

esttab $appendix_reg using ///
	"tables/appendixoutcomes_fu2hd.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Impacts on Kling (2007) at $2^{nd}$ F. U.  Indexes, High Durables \label{appendixoutcomes_fu2hd})








*LOW DURABLES, FU 2

clear

set more off

use ${main}/Data/output/followup2/BME_final.dta

tsset id_number time

global controls  "i.treatment_status i.strata" 

replace durables50 = l2.durables50 if time == 2

keep if durables50 == 0 | time > 0


/*
/*
***********************MIGRATION*GUINEA******************************



global mig_conkary_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'


global mig_guinea_outcomes "migration_guinea_1 migration_guinea_2 migration_guinea_3 migration_guinea_4 migration_guinea_5"

local n_outcomes `: word count $mig_guinea_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $mig_guinea_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls, cluster(schoolid_str)
	
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
	
	

	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	
}




esttab using ///
"migrationguinea_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Out of Conakry  at $2^{nd}$ F. U.  \label{migrationguineafu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ SSS (Stud.)  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ SSS (Admin.)  }" ///
	"\shortstack{(5) \\  Previous \\ and \\ Oth. Cont.  }") nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*postfoot("\hline\hline \multicolumn{6}{p{15.7cm}}{\footnotesize The dependent variable is being out of Guinea. In (1) we use only surveys with the subject (student)--in school or by phone; in (2) we use add information gathered from contacts (max 2) given by subject itself; in (3) we use add information given by students at school during the $2^{nd}$ F. U. tablet survey ; in (4) we use add information given by administration on the same occasion; (5) adds information from unstructured phone conversations with classmates. Errors are clustered at school  P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\). }\\ \end{tabular} \end{table}")



eststo clear


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
	
	

	qui sum y if time == 2 & treatment_status == 1
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
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore


esttab using ///
"migrationintentions_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant" y "Outcome at Baseline") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers  /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \end{tabular}}")

*postfoot("\hline\hline \multicolumn{4}{p{10.5cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Migration intentions at $2^{nd}$ F. U. \label{migrationintentionsfu2})

eststo clear

*/
	*/


*******************************RISK*OUTCOMES*FU2********************************


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
	
	di "`route'"
	
	global winsor = "`route'_duration `route'_journey_cost"
		
	global main_reg " "
		
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	

	global `route'_outcomes_bl " "
	foreach var in $`route'_outcomes {
		gen l2`var' = l2.`var'
		global `route'_outcomes_bl $`route'_outcomes_bl " l2`var'"
	}

	local n_outcomes `: word count $`route'_outcomes'

	* run all regressions and store results 
	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}


	wyoung $`route'_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($`route'_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	matrix define results = r(table)
	esttab matrix(results) using tables/fwer_`route'_fu2ld.xls, nomtitles replace

	matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
	matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
	matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]

	
	***********************************KLING***********************************
	
								
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
		matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}
		
		gen y = `y'
		qui reg f2.y $controls y, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1
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

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_fu2ld.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_fu2ld.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_pfwer_fu2ld.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_pfwer_fu2ld.png , replace
	
	restore
	
	
	esttab $main_reg using ///
		"tables/`route_u'outcomes_fu2ld.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers  /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
		postfoot("\hline\hline \end{tabular}}")

	estimates drop $main_reg 

	eststo clear
	
}

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U., High Durables \label{`route_u'outcomes_fu2ld})
	
	

*****************************ECONOMIC*OUTCOMES*FU2******************************


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


local n_outcomes `: word count $economic_outcomes'
	
global economic_outcomes_bl " "
foreach var in $economic_outcomes {
	gen l2`var' = l2.`var'
	global economic_outcomes_bl $economic_outcomes_bl  " l2`var'"
}


* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}


wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
controls($economic_outcomes_bl) ///
bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

matrix define results = r(table)
esttab matrix(results) using tables/fwer_economic_fu2ld.xls, nomtitles replace

	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
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
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f2.y $controls y, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1
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

graph save Graph ${main}/Draft/figures/economicoutcomes_fu2ld.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_fu2ld.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/economicoutcomes_pfwer_fu2ld.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_pfwer_fu2ld.png , replace
	
restore


esttab  $main_reg using ///
	"tables/economicoutcomes_fu2ld.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")

*title(Perceptions about econ. outcomes at $2^{nd}$ F. U., High Durables \label{economicoutcomes_fu2ld})

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

esttab $appendix_reg using ///
	"tables/appendixoutcomes_fu2ld.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Impacts on Kling (2007) at $2^{nd}$ F. U.  Indexes, High Durables \label{appendixoutcomes_fu2ld})






				


/*

gen mig_class0 = sec9_q2 > 0

reg f2.desire i.treatment_status##i.mig_class0 desire i.strata , cluster(schoolid)
est sto reg1
reg f2.planning i.treatment_status##i.mig_class0 planning i.strata , cluster(schoolid)
est sto reg2
reg f2.prepare i.treatment_status##i.mig_class0 prepare i.strata , cluster(schoolid)
est sto reg3

esttab reg1 reg2 reg3 using ///
	"classmig_int.tex",   ///
	coeflabels( 2.treatment_status#1.mig_class0 "Risk X Mig. classmates" ///
	 3.treatment_status#1.mig_class0 "Econ X Mig. classmates" ///
	 4.treatment_status#1.mig_class0 "Risk X Mig. classmates" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and classmates who migrated) /// 
	mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
	drop(1.mig_class0 desire 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) 
	

reg f2.italy_index i.treatment_status##i.mig_class0 italy_index i.strata , cluster(schoolid)
est sto reg1
reg f2.spain_index i.treatment_status##i.mig_class0 spain_index i.strata , cluster(schoolid)
est sto reg2
reg f2.economic_index i.treatment_status##i.mig_class0 economic_index i.strata , cluster(schoolid)
est sto reg3


esttab reg1 reg2 reg3 using ///
	"pca_classmig.tex",   ///
	coeflabels( 2.treatment_status#1.mig_class0 "Risk X Discussed mig." ///
	 3.treatment_status#1.mig_class0 "Econ X Discussed mig." ///
	 4.treatment_status#1.mig_class0 "Risk X Discussed mig." ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and classmates who migrated: beliefs) /// 
	mtitles("Ita" "Spain"  "Econ" ) nobaselevels ///
	drop(1.mig_class0 italy_index spain_index  economic_index 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) ///
	replace
	


reg f2.italy_kling_poscost i.treatment_status##i.mig_class0 italy_kling_poscost i.strata , cluster(schoolid)
est sto reg1
reg f2.italy_kling_negcost i.treatment_status##i.mig_class0 italy_kling_negcost i.strata , cluster(schoolid)
est sto reg2
reg f2.spain_kling_poscost i.treatment_status##i.mig_class0 spain_kling_poscost i.strata , cluster(schoolid)
est sto reg3
reg f2.spain_kling_negcost i.treatment_status##i.mig_class0 spain_kling_negcost i.strata , cluster(schoolid)
est sto reg4
reg f2.economic_kling i.treatment_status##i.mig_class0 economic_kling i.strata , cluster(schoolid)
est sto reg5





reg f2.desire i.treatment_status##i.sec2_q11 desire i.strata , cluster(schoolid)
est sto reg1
reg f2.planning i.treatment_status##i.sec2_q11 planning i.strata , cluster(schoolid)
est sto reg2
reg f2.prepare i.treatment_status##i.sec2_q11 prepare i.strata , cluster(schoolid)
est sto reg3

esttab reg1 reg2 reg3 using ///
	"classmig_dis.tex",   ///
	coeflabels( 2.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	 3.treatment_status#2.sec2_q11 "Econ X Discussed mig." ///
	 4.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and having discussed migration) /// 
	mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
	drop(2.sec2_q11 desire 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) ///
	replace
	
	

reg f2.italy_index i.treatment_status##i.sec2_q11 italy_index i.strata , cluster(schoolid)
est sto reg1
reg f2.spain_index i.treatment_status##i.sec2_q11 spain_index i.strata , cluster(schoolid)
est sto reg2
reg f2.economic_index i.treatment_status##i.sec2_q11 economic_index i.strata , cluster(schoolid)
est sto reg3


esttab reg1 reg2 reg3 using ///
	"pca_dis.tex",   ///
	coeflabels( 2.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	 3.treatment_status#2.sec2_q11 "Econ X Discussed mig." ///
	 4.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and having discussed migration: beliefs) /// 
	mtitles("Ita" "Spain"  "Econ" ) nobaselevels ///
	drop(2.sec2_q11 italy_index spain_index  economic_index 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) ///
	replace
	
	
	
	
reg f2.italy_kling_poscost i.treatment_status##i.sec2_q11 italy_kling_poscost i.strata , cluster(schoolid)
est sto reg1
reg f2.italy_kling_negcost i.treatment_status##i.sec2_q11 italy_kling_negcost i.strata , cluster(schoolid)
est sto reg2
reg f2.spain_kling_poscost i.treatment_status##i.sec2_q11 spain_kling_poscost i.strata , cluster(schoolid)
est sto reg3
reg f2.spain_kling_negcost i.treatment_status##i.sec2_q11 spain_kling_negcost i.strata , cluster(schoolid)
est sto reg4
reg f2.economic_kling i.treatment_status##i.sec2_q11 economic_kling i.strata , cluster(schoolid)
est sto reg5

*/








*FOLLOW UP 1


clear 


use ${main}/Data/output/followup2/BME_final.dta

tsset id_number time

drop if time == 2

global controls  "i.treatment_status i.strata" 
		


		/*



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
	
	

	qui sum y if time == 2 & treatment_status == 1
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
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore


esttab using ///
"migrationintentions_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant" y "Outcome at Baseline") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers  /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \end{tabular}}")

*postfoot("\hline\hline \multicolumn{4}{p{10.5cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Migration intentions at $2^{nd}$ F. U. \label{migrationintentionsfu2})

eststo clear

*/
	


*******************************RISK*OUTCOMES*FU1********************************


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
	
	di "`route'"
	
	global winsor = "`route'_duration `route'_journey_cost"
		
	global main_reg " "
		
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	

	global `route'_outcomes_bl " "
	foreach var in $`route'_outcomes {
		gen l1`var' = l.`var'
		global `route'_outcomes_bl $`route'_outcomes_bl " l1`var'"
	}

	local n_outcomes `: word count $`route'_outcomes'

	* run all regressions and store results 
	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}


	wyoung $`route'_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($`route'_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	matrix define results = r(table)
	esttab matrix(results) using tables/fwer_`route'_fu1.xls, nomtitles replace

	matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
	matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
	matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]

	
	***********************************KLING***********************************
	
								
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
		matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}
		
		gen y = `y'
		qui reg f.y $controls y, cluster(schoolid_str)
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

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_fu1.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_fu1.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/`route_u'outcomes_pfwer_fu1.gph, replace
	graph export ${main}/Draft/figures/`route_u'outcomes_pfwer_fu1.png , replace
	
	restore
	
	
	esttab $main_reg using ///
		"tables/`route_u'outcomes_fu1.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers  /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
		postfoot("\hline\hline \end{tabular}}")

	estimates drop $main_reg 

	eststo clear
	
}

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Risk perceptions for route through `route_u' at $1^{st}$ F. U. \label{`route_u'outcomes_fu1})
	
	

*****************************ECONOMIC*OUTCOMES*FU2******************************


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


local n_outcomes `: word count $economic_outcomes'
	
global economic_outcomes_bl " "
foreach var in $economic_outcomes {
	gen l1`var' = l.`var'
	global economic_outcomes_bl $economic_outcomes_bl  " l1`var'"
}


* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}


wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
controls($economic_outcomes_bl) ///
bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

matrix define results = r(table)
esttab matrix(results) using tables/fwer_economic_fu1.xls, nomtitles replace

	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
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
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f.y $controls y, cluster(schoolid_str)
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

graph save Graph ${main}/Draft/figures/economicoutcomes_fu1.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_fu1.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/economicoutcomes_pfwer_fu1.gph, replace
graph export ${main}/Draft/figures/economicoutcomes_pfwer_fu1.png , replace
	
restore


esttab  $main_reg using ///
	"tables/economicoutcomes_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")

*title(Perceptions about econ. outcomes at $2^{nd}$ F. U. \label{economicoutcomes_fu1})

*postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

esttab $appendix_reg using ///
	"tables/appendixoutcomes_fu1.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

*title(Impacts on Kling (2007) at $2^{nd}$ F. U.  Indexes \label{appendixoutcomes_fu1})







