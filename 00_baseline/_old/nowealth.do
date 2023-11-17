***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   RANDOMIZATION WITH STRATIFICATION                                     
***_____________________________________________________________________________



clear all

set more off
pause on

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - Parameters                                               
***_____________________________________________________________________________

** Install packages
*ssc install randomize
*ssc install nearstat
*ssc install listtex
*ssc intall orth_out

global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data"
local lycee "$main/raw/lycee_conakry.xlsx"






***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - Importing the data                                               
***_____________________________________________________________________________


import excel using "`lycee'", firstrow clear
keep N etab nb_student_at_randomiz_date latitude longitude
destring latitude, replace
destring longitude, replace
drop if N==.
tempfile lycee
save `lycee', replace


use "$main/output/admin_data", clear
keep N CODE NOM_ETABLISSEMENT etab_quest etab commune libelle_dsee status nature fee_11_a fee_11_b fee_12_a fee_12_b fee_Term_a fee_Term_b nb_GP
merge 1:1 etab N using `lycee'
rename etab_quest lycee_name_string
keep if _merge==3
drop _merge

*merging with student questionnaire
merge 1:m lycee_name_string using "$main/output/questionnaire_baseline_clean_rigourous_cleaning.dta"
keep if _merge==3
drop _merge

*gen code for units of treatment
rename CODE schoolid
label var schoolid "id school number"

drop note*



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - covariates  cleaning                          
***_____________________________________________________________________________

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
		rename nb_student_at_randomiz_date size
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

//DHS Index
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


		
	
	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  4 SELECTING THE VARIABLE FOR THE BALANCE                      
***_____________________________________________________________________________


global bc_var = "wealth_index size mig_plan mig_prep mig_des outside_contact_no age gender mig_classmates log_wage  employed asylum studies beaten duration journey_cost die_boat die_bef_boat moth_school fath_school"
	
//the global must be changed depending on the strategy of stratification because of convergence issues
global cov_var = "mig_classmates size wealth_index mig_plan mig_prep mig_des age gender beaten employed  asylum die_boat"


** Collapse at cluster level
collapse (mean) $bc_var latitude longitude, by(schoolid)



// STRATA : SCHOOL SIZE / DHS INDEX
xtile xtile_size=size, nq(2)

xtile xtile_wealth = wealth_index, nq(3)



local strata "xtile_size"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  5 TREATMENT ALLOCATION   WITH COVARIATES OPTION                   
***_____________________________________________________________________________

randomize, groups(4) block(`strata') seed(11235) replace balance($cov_var) jointp(0.2)  minruns(1000) 


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  6 BALANCE CHECKS                    
***_____________________________________________________________________________



 
 
*orth_out $bc_var using "$main/strat1_nowealth.xls", by(_assignment) se test pcompare stars replace covariates(strata_n*) count vcount title(Balance checks)  armlabel("Control group" "Treatment risk" "Treatment condition in UE" "Double Treatment")

mata: table_tot = J(20, 6, .)
local l 0

*local bc_var  "         


foreach var of global bc_var {

	local l = `l' + 1
	
	
	qui sum `var' if _assignment == 1
	
	local m1 = `r(mean)'
	local v1 = `r(Var)'
	
	qui sum `var' if _assignment == 2
	local m2 = `r(mean)'
	local v2 = `r(Var)'
	
	qui sum `var' if _assignment == 3
	local m3 = `r(mean)'
	local v3 = `r(Var)'
	
	qui sum `var' if _assignment == 4 
	local m4 = `r(mean)'
	local v4 = `r(Var)'
	
	mata: table_tot[`l', 1] = (`m2' - `m1')/(sqrt(`v1'+`v2'))
	mata: table_tot[`l', 2] = (`m3' - `m1')/(sqrt(`v1'+`v3'))
	mata: table_tot[`l', 3] = (`m4' - `m1')/(sqrt(`v1'+`v4'))
	mata: table_tot[`l', 4] = (`m3' - `m2')/(sqrt(`v2'+`v3'))
	mata: table_tot[`l', 5] = (`m4' - `m2')/(sqrt(`v2'+`v4'))
	mata: table_tot[`l', 6] = (`m4' - `m3')/(sqrt(`v3'+`v4'))
}

mata: st_matrix("normalized", table_tot)

matrix colnames normalized = risk_control econ_control double_control risk_econ risk_double econ_double	
matrix rownames normalized = wealth_index size mig_plan mig_prep mig_des outside_contact_no age gender mig_classmates expectation_wage  employed asylum studies beaten duration journey_cost die_boat die_bef_boat moth_school fath_school

matrix list normalized

*esttab matrix(normalized) using index.csv, replace


twoway (scatter latitude longitude if _assignment == 1, mc(black)) (scatter latitude longitude if _assignment == 2, mc(blue)) (scatter latitude longitude if _assignment == 3, mc(red)) (scatter latitude longitude if _assignment == 4, mc(yellow)) ,  legend(label(1 control) label(2 risk) label(3 econ) label(4 double))

