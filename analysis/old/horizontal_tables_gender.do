clear all

set more off

use "$main\Data\output\analysis\guinea_final_dataset.dta", replace

cd "$main/latex"

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

global controls = `" "i.treatment_status##female" "' ///
				+ `" "i.treatment_status##female i.strata" "' ///
				+ `" "i.treatment_status##female 	y" "' ///
				+ `" "i.treatment_status##female i.strata y" "'
	
global controls_names = `" "with no controls" "' ///
				+ `" "controlling for stratification dummy" "' ///
				+ `" "controlling for outcome at baseline" "' ///
				+ `" "controlling for outcome at baseline and stratification dummy" "'
					
				
******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				
global intention_table_legend = `" "(1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3)" "' ///
	+ `" "is \emph{preparing}. Errors are clustered at school level." "'

global migration_outcomes "desire planning prepare"


global migration_plot_list " "

local j = 0

foreach control_vl in $controls {

	global regression_list " "
	
	local j = `j' + 1

	local w_c : word `j' of $controls_names
		
	local n = 0
	
	foreach name in $intention_names {

		local n = `n' + 1
			
		local y : word `n' of $migration_outcomes

		gen y = `y'
		reg f.y `control_vl', cluster(schoolid_str)
		est sto reg_`n'_`j'
		global regression_list $regression_list  reg_`n'_`j'
		if `j' == 4 {
		global migration_plot_list $migration_plot_list  (reg_`n'_`j', label(`name')) 
		}
		drop y
		
	}
	
	esttab $regression_list using ///
	"horizontal_migration_gender_`j'.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" 2.strata "Big school" ///
	2.treatment_status#1.female "Risk Treatment * Female" ///
	3.treatment_status#1.female "Economic Treatment * Female" ///
	4.treatment_status#1.female "Double Treatment * Female" ///
	1.female "Female" y "Outcome at baseline") ///
	nonumbers title(Migration intentions and gender `w_c') /// 
	mtitles("(1)" "(2)"  "(3)"  "(4)") nobaselevels ///
	addnotes($intention_table_legend)

}



coefplot  $migration_plot_list, drop(_cons 2.strata 1.female  /// 
	2.treatment_status#1.female 3.treatment_status#1.female ///
	4.treatment_status#1.female y) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment") 

graph export migration_males.png, replace


global migration_plot_list " "

local n = 0

foreach name in $intention_names {

	local n = `n' + 1
		
	local y : word `n' of $migration_outcomes
	
	gen y = `y'
	
	reg f.y i.treatment_status##male i.strata  y  , cluster(schoolid_str)
	est sto reg_`n'
	global migration_plot_list $migration_plot_list   (reg_`n', label(`name')) 
	
	drop y
}


coefplot  $migration_plot_list, drop(_cons 2.strata 1.male  /// 
	2.treatment_status#1.male 3.treatment_status#1.male ///
	4.treatment_status#1.male y) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment") ///
	title(Migration intentions for female students)

graph export migration_females.png, replace



**********************************RISK*OUTCOMES*********************************


global risks_names = `" "Log duration in months (winsorized at $5^{th}$ perc.)" "' ///
				+ `" "Log journey cost (winsorized at $5^{th}$ perc.)" "' ///
				+ `" "Probability of being beaten" "' ///
				+ `" "Probability of being forced to work" "' ///
				+ `" "Probability of being kidnapped" "' ///
				+ `" "Probability of dying before travel by boat" "' ///
				+ `" "Probability of dying during travel by boat" "' ///
				+ `" "Probability of being sent back" "'

				
global risks_legend = `" "Duration, wins. at 5" "' ///
				+ `" "Cost, wins. at 5" "' ///
				+ `" "Beaten" "' ///
				+ `" "Forced to work" "' ///
				+ `" "Kidnapped" "' ///
				+ `" "Death before boat" "' ///
				+ `" "Death by boat" "' ///
				+ `" "Sent back" "'
				
global risks_table_legend = `" "Legend: (1) duration of journey in log months (winsorized at $5^{th}$ perc.), (2) journey cost in log euros(winsorized at $5^{th}$ perc.)," "' ///
				+ `" "(3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying" "' ///
				+ `" "before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back." "'  ///
				+ `" "Errors are clustered at school level." "' 
				
global routes_list = "Italy Spain"

foreach route_u in $routes_list {
	
	local route = lower("`route_u'")
	
	global winsor = "`route'_duration `route'_journey_cost"
	
	foreach y in $winsor {
		gen `y'_winsor = `y'
		qui sum `y', detail
		replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)'
		replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)'
		gen log`y'_winsor = log(1 + `y'_winsor)
	}

	global `route'_outcomes = "log`route'_duration_winsor " ///
							+ " log`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
		

	global risks_plot_list " "
	global risks_plot_nolog_list " "

	local j = 0

	foreach control_vl in $controls {

		global regression_list " "
		local j = `j' + 1
		local w_c : word `j' of $controls_names
		local n = 0
		
		foreach name in $risks_names {

			local n = `n' + 1
				
			local y : word `n' of $`route'_outcomes
		
			local l : word `n' of $risks_legend

			gen y = `y'
			
			if `n' > 2 {
			replace y = y/100
			}
			
			reg f.y `control_vl', cluster(schoolid_str)
			est sto reg_`n'_`j'
			global regression_list $regression_list  reg_`n'_`j'
			if `j' == 4 {
			global risks_plot_list $risks_plot_list  (reg_`n'_`j', label(`l')) 
			}
			if (`j' == 4)&(`n' > 2) {
			global risks_plot_nolog_list $risks_plot_nolog_list  (reg_`n'_`j', label(`l')) 
			}
			drop y
			
		}
		
		esttab $regression_list using ///
			"horizontal_risks_gender_`route_u'_`j'.tex", replace ///
			coeflabels(1.treatment_status "Control" 2.treatment_status ///
			"Risk Treatment" 3.treatment_status "Economic Treatment" ///
			4.treatment_status "Double Treatment" 2.strata "Big school" ///
			2.treatment_status#1.female "Risk Treatment * Female" ///
			3.treatment_status#1.female "Economic Treatment * Female" ///
			4.treatment_status#1.female "Double Treatment * Female" ///
			1.female "Female" y "Outcome at baseline") ///
			nonumbers title(Risk perceptions for route through `route_u' `w_c') /// 
			mtitles("(1)" "(2)"  "(3)"  "(4)" "(5)" "(6)" "(7)" "(8)") ///
			nobaselevels ///
			addnotes($risks_table_legend)
	}

	coefplot  $risks_plot_nolog_list, drop(_cons 2.strata 1.female  /// 
		2.treatment_status#1.female 3.treatment_status#1.female ///
		4.treatment_status#1.female y) xline(0) ///
		graphregion(color(white))  ///
		coeflabels(2.treatment_status = "Risk Treatment" ///
		3.treatment_status = "Economic Treatment" ///
		4.treatment_status = "Double Treatment") 

	graph export risks_`route_u'_males.png, replace
	
	coefplot  $risks_plot_list, drop(_cons 2.strata 1.female  /// 
		2.treatment_status#1.female 3.treatment_status#1.female ///
		4.treatment_status#1.female y) xline(0) ///
		graphregion(color(white))  ///
		coeflabels(2.treatment_status = "Risk Treatment" ///
		3.treatment_status = "Economic Treatment" ///
		4.treatment_status = "Double Treatment") 

	graph export risks_`route_u'_males_nolog.png, replace
		
	global risks_plot_list " "
	global risks_plot_nolog_list " "

	local n = 0

	foreach name in $risks_names {

		local n = `n' + 1
		
		local y : word `n' of $`route'_outcomes
		
		local l : word `n' of $risks_legend
		
		gen y = `y'
	
		reg f.y i.treatment_status##male i.strata  y  , cluster(schoolid_str)
		est sto reg_`n'_`j'
		
		global risks_plot_list $risks_plot_list   (reg_`n'_`j', label(`l')) 
		
		if (`n' > 2) {
		global risks_plot_nolog_list $risks_plot_nolog_list  (reg_`n'_`j', label(`l')) 
		}
		
		drop y
		
	}


	coefplot  $risks_plot_list, drop(_cons 2.strata 1.male  /// 
		2.treatment_status#1.male 3.treatment_status#1.male ///
		4.treatment_status#1.male y) xline(0) ///
		graphregion(color(white))  ///
		coeflabels(2.treatment_status = "Risk Treatment" ///
		3.treatment_status = "Economic Treatment" ///
		4.treatment_status = "Double Treatment") ///
		title(Risk perceptions for female students: `route_u')
	
	graph export risks_`route_u'_females.png, replace
	
	coefplot  $risks_plot_nolog_list, drop(_cons 2.strata 1.male  /// 
		2.treatment_status#1.male 3.treatment_status#1.male ///
		4.treatment_status#1.male y) xline(0) ///
		graphregion(color(white))  ///
		coeflabels(2.treatment_status = "Risk Treatment" ///
		3.treatment_status = "Economic Treatment" ///
		4.treatment_status = "Double Treatment") ///
		title(Risk perceptions for female students: `route_u')
	
	graph export risks_`route_u'_females_nolog.png, replace
	
}




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
	gen log`y'_winsor = log(1 + `y'_winsor)
}

global economic_outcomes = " finding_job logexpected_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " logexpected_living_cost_winsor "

global economic_names = `" " Probability of finding a job " "' ///
			+ `" " Log expected wage (winsorized at $5^{th}$ perc.) " "' ///
			+ `" " Probability of continuing studies " "' ///
			+ `" " Probability of becoming a citizen " "' ///
			+ `" " Probability of having returned after 5 years " "' ///
			+ `" " Probability that the governement gives financial help ""' ///
			+ `" " Probability of getting asylum, if requested " "' ///
			+ `" " Percentage in favor of migration at destination " "' ///
			+ `" " Log expected cost of living (winsorized at $5^{th}$ perc.) " "'

global economic_legend = `" " Finding job " "' ///
			+ `" " Expected wage wins. at 5 " "' ///
			+ `" " Continuing studies " "' ///
			+ `" " Citizen " "' ///
			+ `" " Return 5yrs " "' ///
			+ `" " Govt gives fin. help ""' ///
			+ `" " Asylum " "' ///
			+ `" " Favors migration at dest. " "' ///
			+ `" " Cost of living wins. at 5 " "'

			
global economic_table_legend = `" "Legend: (1) probability of finding job, (2) expected wage at destination in log euros (winsorized at $5^{th}$ perc.), (3) probability of continuing studies," "' ///
				+ `" "(4) probability of becoming a citizen, (5) probability of having returned after 5 years, (6) probability that govt at destination gives financial help," "' ///
				+ `" "(7) probability of getting asylum, if requested (8) percentage in favor of migration at destination, (9) expected wage at destination in log euros" "' ///
				+ `" "(winsorized at $5^{th}$ perc.). Errors are clustered at school level." "'
				
global economic_plot_list " "
global economic_plot_list_nolog " "


local j = 0

foreach control_vl in $controls {

	global regression_list " "
	
	local j = `j' + 1

	local w_c : word `j' of $controls_names
		
	local n = 0
	
	foreach name in $economic_names {

		local n = `n' + 1
			
		local y : word `n' of $economic_outcomes
		
		local l : word `n' of $economic_legend

		gen y = `y'
		
		if (`n' != 2)&(`n' != 9) {
			replace y = y/100
		}
			
		reg f.y `control_vl', cluster(schoolid_str)
		est sto reg_`n'_`j'
		global regression_list $regression_list  reg_`n'_`j'
		if `j' == 4 {
		global economic_plot_list $economic_plot_list  (reg_`n'_`j', label(`l')) 
		}
		if (`j' == 4)&(`n' != 2)&(`n' != 9) {
			global economic_plot_list_nolog $economic_plot_list_nolog  (reg_`n'_`j', label(`l'))
		}
		drop y
		
	}
	
	
	esttab $regression_list using ///
		"horizontal_economic_gender_`j'.tex", replace ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treatment" 3.treatment_status "Economic Treatment" ///
		4.treatment_status "Double Treatment" 2.strata "Big school" ///
		2.treatment_status#1.female "Risk Treatment * Female" ///
		3.treatment_status#1.female "Economic Treatment * Female" ///
		4.treatment_status#1.female "Double Treatment * Female" ///
		1.female "Female" y "Outcome at baseline") ///
		nonumbers title(Perceptions about economic outcomes `w_c') /// 
		mtitles("(1)" "(2)"  "(3)"  "(4)" "(5)" "(6)"  "(7)"  "(8)" "(9)") ///
		nobaselevels ///
		addnotes($economic_table_legend)
}


coefplot  $economic_plot_list, drop(_cons 2.strata 1.female  /// 
	2.treatment_status#1.female 3.treatment_status#1.female ///
	4.treatment_status#1.female y) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment")

graph export economic_males.png, replace

coefplot  $economic_plot_list_nolog, drop(_cons 2.strata 1.female  /// 
	2.treatment_status#1.female 3.treatment_status#1.female ///
	4.treatment_status#1.female y) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment")

graph export economic_males_nolog.png, replace




global economic_plot_list " "
global economic_plot_list_nolog " "



local n = 0

	
foreach name in $economic_names {

	local n = `n' + 1
		
	local y : word `n' of $economic_outcomes
	
	local l : word `n' of $economic_legend

	gen y = `y'
	
	if (`n' != 2)&(`n' != 9) {
		replace y = y/100
	}
		
	reg f.y i.treatment_status##male i.strata y, cluster(schoolid_str)
	est sto reg_`n'
	global economic_plot_list $economic_plot_list  (reg_`n', label(`l')) 

	if (`n' != 2)&(`n' != 9) {
		global economic_plot_list_nolog $economic_plot_list_nolog  (reg_`n', label(`l'))
	}
	drop y
	
}
	
	


coefplot  $economic_plot_list, drop(_cons 2.strata 1.male  /// 
	2.treatment_status#1.male 3.treatment_status#1.male ///
	4.treatment_status#1.male y) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment")

graph export economic_females.png, replace

coefplot  $economic_plot_list_nolog, drop(_cons 2.strata 1.male  /// 
	2.treatment_status#1.male 3.treatment_status#1.male ///
	4.treatment_status#1.male y) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment")

graph export economic_females_nolog.png, replace



