
clear all

set more off

use "$main\Data\output\analysis\guinea_final_dataset.dta", replace

cd "$main/latex"

destring schoolid_str, gen(schoolid)

merge m:1 schoolid using "$main/Data/output/analysis/stratum_by_school.dta"

tsset id_number time

gen female = sec0_q2 - 1
gen male = female == 0

******************************MIGRATION*INTENTIONS*****************************

gen 	desire = sec2_q1
replace desire = 0 if desire == 2

gen 	planning = sec2_q4
replace planning = 0 if planning == 2
replace planning = 0 if desire == 0

gen 	prepare = sec2_q7
replace prepare = 0 if prepare == 2
replace prepare = 0 if planning == 0

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'

global migration_outcomes "desire planning prepare"

global migration_plot_list " "

local n = 0

foreach name in $intention_names {

	local n = `n' + 1
		
	local y : word `n' of $migration_outcomes

	reg f.`y' i.treatment_status		     , cluster(schoolid_str)
	est sto reg1
	reg f.`y' i.treatment_status i.strata    , cluster(schoolid_str)
	est sto reg2_`n'
	global migration_plot_list $migration_plot_list   (reg2_`n', label(`name')) 
	reg f.`y' i.treatment_status 		  `y', cluster(schoolid_str)
	est sto reg3
	reg f.`y' i.treatment_status i.strata `y', cluster(schoolid_str)
	est sto reg4
	
	esttab reg1 reg2_`n' reg3 reg4 using ///
		"`y'_regressions.tex", replace ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treatment" 3.treatment_status "Economic Treatment" ///
		4.treatment_status "Double Treatment" 2.strata "Big school") ///
		nonumbers title("`name'") /// 
		mtitles("(1)" "(2)"  "(3)"  "(4)") nobaselevels
}


coefplot  $migration_plot_list, drop(_cons 2.strata ) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment") ///
	title(Migration intentions)

graph export migration.png, replace

*reg f.prepare i.treatment_status##sec0_q2 i.strata, cluster(schoolid)

***BY*GENDER***

global migration_plot_list " "

local n = 0

foreach name in $intention_names {

	local n = `n' + 1
		
	local y : word `n' of $migration_outcomes

	reg f.`y' i.treatment_status##female	  , cluster(schoolid_str)
	est sto reg1
	reg f.`y' i.treatment_status##female i.strata    , cluster(schoolid_str)
	est sto reg2_`n'
	global migration_plot_list $migration_plot_list   (reg2_`n', label(`name')) 
	reg f.`y' i.treatment_status##female 		  `y', cluster(schoolid_str)
	est sto reg3
	reg f.`y' i.treatment_status##female i.strata `y', cluster(schoolid_str)
	est sto reg4
	
	esttab reg1 reg2_`n' reg3 reg4 using ///
		"`y'_gender_regressions.tex", replace ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treatment" 3.treatment_status "Economic Treatment" ///
		4.treatment_status "Double Treatment" 2.strata "Big school") ///
		nonumbers title("`name'" and gender) /// 
		mtitles("(1)" "(2)"  "(3)"  "(4)") nobaselevels
}


coefplot  $migration_plot_list, drop(_cons 2.strata 1.female  /// 
	2.treatment_status#1.female 3.treatment_status#1.female ///
	4.treatment_status#1.female ) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment") ///
	title(Migration intentions for male students)

graph export migration_males.png, replace



global migration_plot_list " "

local n = 0

foreach name in $intention_names {

	local n = `n' + 1
		
	local y : word `n' of $migration_outcomes

	reg f.`y' i.treatment_status##male i.strata    , cluster(schoolid_str)
	est sto reg2_`n'
	global migration_plot_list $migration_plot_list   (reg2_`n', label(`name')) 
	
}


coefplot  $migration_plot_list, drop(_cons 2.strata 1.male  /// 
	2.treatment_status#1.male 3.treatment_status#1.male ///
	4.treatment_status#1.male ) xline(0) ///
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

	local n = 0
	
	foreach name in $risks_names  {
		
		local n = `n' + 1
		
		local y : word `n' of $`route'_outcomes
		
		local l : word `n' of $risks_legend

		reg f.`y' i.treatment_status		     , cluster(schoolid_str)
		est sto reg1
		reg f.`y' i.treatment_status i.strata    , cluster(schoolid_str)
		est sto reg2_`n'
		global risks_plot_list $risks_plot_list (reg2_`n', label(`l')) 
		reg f.`y' i.treatment_status 		  `y', cluster(schoolid_str)
		est sto reg3
		reg f.`y' i.treatment_status i.strata `y', cluster(schoolid_str)
		est sto reg4
		
		esttab reg1 reg2_`n' reg3 reg4 using ///
			"`y'_regressions.tex", ///
			replace coeflabels(1.treatment_status "Control" ///
			2.treatment_status "Risk Treatment" 3.treatment_status /// 
			"Economic Treatment" 4.treatment_status "Double Treatment" ///
			2.strata "Big school") nonumbers title("`name'," "`route_u'") ///
			mtitles("(1)" "(2)"  "(3)"  "(4)") ///
			nobaselevels
		
	}
	
	coefplot  $risks_plot_list, drop(_cons 2.strata ) xline(0) ///
		graphregion(color(white))  ///
		coeflabels(2.treatment_status = "Risk Treatment" ///
		3.treatment_status = "Economic Treatment" ///
		4.treatment_status = "Double Treatment") ///
		title(Risk perceptions: `route_u')
 
	graph export `route_u'_risks.png, replace
	
	global risks_plot_list " "

	local n = 0

	foreach name in $risks_names {

		local n = `n' + 1
		
		local y : word `n' of $`route'_outcomes
		
		local l : word `n' of $risks_legend

		reg f.`y' i.treatment_status##female	  , cluster(schoolid_str)
		est sto reg1
		reg f.`y' i.treatment_status##female i.strata    , cluster(schoolid_str)
		est sto reg2_`n'
		global risks_plot_list $risks_plot_list   (reg2_`n', label(`l')) 
		reg f.`y' i.treatment_status##female 		  `y', cluster(schoolid_str)
		est sto reg3
		reg f.`y' i.treatment_status##female i.strata `y', cluster(schoolid_str)
		est sto reg4
		
		esttab reg1 reg2_`n' reg3 reg4 using ///
			"`y'_gender_regressions.tex", replace ///
			coeflabels(1.treatment_status "Control" 2.treatment_status ///
			"Risk Treatment" 3.treatment_status "Economic Treatment" ///
			4.treatment_status "Double Treatment" 2.strata "Big school") ///
			nonumbers title("`name'" and gender) /// 
			mtitles("(1)" "(2)"  "(3)"  "(4)") nobaselevels
	}


	coefplot  $risks_plot_list, drop(_cons 2.strata 1.female  /// 
		2.treatment_status#1.female 3.treatment_status#1.female ///
		4.treatment_status#1.female ) xline(0) ///
		graphregion(color(white))  ///
		coeflabels(2.treatment_status = "Risk Treatment" ///
		3.treatment_status = "Economic Treatment" ///
		4.treatment_status = "Double Treatment") ///
		title(Risk perceptions for male students: `route_u')
	
	graph export risks_males.png, replace

	
	global risks_plot_list " "

	local n = 0

	foreach name in $risks_names {

		local n = `n' + 1
		
		local y : word `n' of $`route'_outcomes
		
		local l : word `n' of $risks_legend

		reg f.`y' i.treatment_status##male i.strata    , cluster(schoolid_str)
		est sto reg2_`n'
		global risks_plot_list $risks_plot_list   (reg2_`n', label(`l')) 
		
	}


	coefplot  $risks_plot_list, drop(_cons 2.strata 1.male  /// 
		2.treatment_status#1.male 3.treatment_status#1.male ///
		4.treatment_status#1.male ) xline(0) ///
		graphregion(color(white))  ///
		coeflabels(2.treatment_status = "Risk Treatment" ///
		3.treatment_status = "Economic Treatment" ///
		4.treatment_status = "Double Treatment") ///
		title(Risk perceptions for female students: `route_u')
	
	graph export risks_females.png, replace
}

stop

***BY*GENDER***



********************************ECONOMIC*OUTCOMES*******************************

local euro_fg = 10400

gen sec3_42_corrected = sec3_42
replace sec3_42_corrected = sec3_42_corrected*1000000 if sec3_42_corrected < 999
replace sec3_42_corrected = sec3_42_corrected*1000 if sec3_42_corrected < 999999

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
	gen log`y'_winsor = 100*log(1 + `y'_winsor)
}

global economic_outcomes = " finding_job logexpected_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum in_favor_of_migration " ///
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

global economic_plot_list " "
			
local n = 0
			
foreach name in $economic_names {

	local n = `n' + 1
		
	local y : word `n' of $economic_outcomes
	
	local l : word `n' of $economic_legend

	reg f.`y' i.treatment_status		     , cluster(schoolid_str)
	est sto reg1
	reg f.`y' i.treatment_status i.strata    , cluster(schoolid_str)
	est sto reg2_`n'
	global economic_plot_list $economic_plot_list (reg2_`n', label(`l')) 
	reg f.`y' i.treatment_status 		  `y', cluster(schoolid_str)
	est sto reg3
	reg f.`y' i.treatment_status i.strata `y', cluster(schoolid_str)
	est sto reg4
	
	esttab reg1 reg2_`n' reg3 reg4 using ///
		"`y'_regressions.tex", replace ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treatment" 3.treatment_status "Economic Treatment" ///
		4.treatment_status "Double Treatment" 2.strata "Big school") ///
		nonumbers title("`name'") /// 
		mtitles("(1)" "(2)"  "(3)"  "(4)") nobaselevels
}


coefplot  $economic_plot_list, drop(_cons 2.strata ) xline(0) ///
	graphregion(color(white))  ///
	coeflabels(2.treatment_status = "Risk Treatment" ///
	3.treatment_status = "Economic Treatment" ///
	4.treatment_status = "Double Treatment") ///
	title(Economic perceptions)

graph export economic.png, replace


stop

preserve
********************************************************************************
//,\\'// 	     	A -  CLEANING of the covariates    	 			'//,\\'
********************************************************************************

*keeping the baseline data
keep if f.sec2_q1 != .
keep if time==0

//SOCIO ECONOMIC CONTROLS/

*mother ever attended school
		gen moth_school = .
		replace moth_school = 1 if sec1_5 == 1
		replace moth_school = 0 if sec1_5 == 2

*father ever attended school
		gen fath_school = .
		replace fath_school = 1 if sec1_12 == 1
		replace fath_school = 0 if sec1_12 == 2
		
*school size 
		*rename school_size size
*gender
		rename sec0_q2 gender
		replace gender=0 if gender==2

*generating age
		gen age=(starttime_new_date-sec0_q3)/365.25
		label variable age "Age"
		*dealing with aberrant data : 
		replace age=. if age<=10 | age >30


* family size
		gen family_size=no_family_member
		*replace family_size=. if family_size > 100


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


*classmates migration
		rename sec9_q2 mig_classmates

*outside contact no
		*replace outside_contact_no=. if outside_contact_no>100 


// MAIN OUTCOMES
*migration desire
		rename sec2_q1 mig_des
		replace mig_des=0 if mig_des==2


*generating dummy for road selection
		gen it_favorite_road=.
		replace it_favorite_road=1 if road_selection==1
		replace it_favorite_road=0 if road_selection!=1 & !missing(road_selection)

		gen sp_favorite_road=.
		replace sp_favorite_road=1 if road_selection==2
		replace sp_favorite_road=0 if road_selection!=2 & !missing(road_selection)
		
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

*employment
		replace sec3_32=. if sec3_32 > 100
		rename sec3_32 employed

rename sec3_35 studies
replace studies=. if studies>100

rename sec3_40 asylum
rename sec3_41 fav_mig
replace fav_mig=. if fav_mig>100

replace outside_contact_no=. if outside_contact_no>1000

*log wage
gen log_wage=log(expectation_wage+1)

*family revenue
rename sec8_q6 family_revenue

gen 	duration=.
replace duration=(italy_duration+spain_duration)/2

gen 	beaten=.
replace beaten=(italy_beaten+spain_beaten)/2

gen 	journey_cost=.
replace journey_cost=(spain_journey_cost+italy_journey_cost)/2

gen 	die_boat=.
replace die_boat=(spain_die_boat+italy_die_boat)/2

gen 	die_bef_boat=.
replace die_bef_boat=(spain_die_bef_boat+italy_die_bef_boat)/2

gen		forced_work=.
replace forced_work=(spain_forced_work+italy_forced_work)/2

gen 	mig_plan=sec2_q4
replace mig_plan=0 if mig_plan==2 | mig_des==0

gen mig_prep=sec2_q7
replace mig_prep=0 if mig_prep==2 | mig_plan==0

/*DHS Index*/
*generating the  dummy variables for categorical var (toilet, water)
*notice that it is also possible to split the categories into 3 subgroup : low/medium/high quality
tab sec7_q5 , gen(sec7_q5_n)
tab sec7_q4 , gen(sec7_q4_n)
local component "sec7_q4_n1 sec7_q4_n2 sec7_q4_n3 sec7_q4_n4 sec7_q4_n5 sec7_q4_n6 sec7_q4_n7 sec7_q4_n8 sec7_q4_n9 sec7_q4_n10 sec7_q4_n11 sec7_q4_n12 sec7_q4_n13 sec7_q4_n14 sec7_q5_n1 sec7_q5_n2 sec7_q5_n3 sec7_q5_n4 sec7_q5_n5 sec7_q5_n6 sec7_q5_n7 sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m"

* deleting variable without no variation    
foreach var of local component {
sum `var'
}
///>>> ok 

*normalize
foreach var of local component {
qui sum `var'
replace `var'=(`var'-`r(mean)')/`r(sd)'
}

*checking the values of the component
foreach var of local component {
tab `var'
}

/*substitution of mean for missing values
foreach var of local component {
qui sum `var',detail
replace `var'=`r(mean)' if `var'==.
}*/


local component "sec7_q4_n1 sec7_q4_n2 sec7_q4_n3 sec7_q4_n4 sec7_q4_n5 sec7_q4_n6 sec7_q4_n7 sec7_q4_n8 sec7_q4_n9 sec7_q4_n10 sec7_q4_n11 sec7_q4_n12 sec7_q4_n13 sec7_q4_n14 sec7_q5_n1 sec7_q5_n2 sec7_q5_n3 sec7_q5_n4 sec7_q5_n5 sec7_q5_n6 sec7_q5_n7 sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m"

pca `component', factor(1)
predict wealth_index


*variable for the balance
global bc_var = "school_size gender age moth_school fath_school wealth_index outside_contact_no mig_classmates mig_des mig_plan mig_prep duration journey_cost beaten die_boat die_bef_boat expectation_wage employed asylum studies"

** Collapse at cluster level
collapse (mean) $bc_var treatment, by(schoolid)

** labeling
label var wealth_index "Wealth index"
label var school_size "School size"
label var mig_plan "\% of students who plan to migrate"
label var mig_prep "\% of students who have prepared their migration"
label var mig_des "\% of students who would like to migrate"
label var outside_contact_no "# of acquaintance living abroad"
label var age "Student's age"
label var gender "\% of male students in the school"
label var mig_classmates "# of classmates who have left Guinea"
label var expectation_wage "Wage in the destination country"
label var employed "Chance to find a job in the destination country"
label var asylum "Chance to obtain asylum in the destination country"
label var studies "Chance to continue to study  in the destination country"
label var beaten "Probability to be beaten during the journey$^{(1)}$"
label var duration "Duration of the journey$^{(1)}$"
label var journey_cost "Cost of the journey$^{(1)}$"
label var die_boat "Probability to die during the travel by boat$^{(1)}$"
label var die_bef_boat "Probability to die before taking the boat$^{(1)}$"
label var moth_school "Mother education"
label var fath_school "Father education"


*strata
xtile xtile_size=school_size, nq(2)
local strata "xtile_size"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)


orth_out $bc_var using "$main/Data/output/analysis/balance_check13072019_midline.xlsx", by(treatment) se test pcompare stars covariates(strata_n*) count title(Balance checks) armlabel("Control group" "Treatment risk" "Treatment condition in UE" "Double Treatment")
