clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"


use ${main}/Data/output/analysis/guinea_final_dataset.dta

cd "$main/Draft/tables"


*******************************DATASET PREPARATION******************************

tsset id_number time 

duplicates tag id_number, generate(duplic)

destring schoolid_str, gen(schoolid)

gen lost = duplic == 0

gen sensibilized = participation != 0

local change 10400

*keeping the baseline data
keep if time==0

//SOCIO ECONOMIC CONTROLS/

*contacts_winsor
		gen contacts_winsor = outside_contact_no
		qui sum contacts_winsor, detail
		replace contacts_winsor = `r(p95)' if contacts_winsor > `r(p95)' &	!missing(contacts_winsor)						
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

		
		rename sec3_36 becoming_citizen
rename sec3_37 return_5yr
		
rename sec3_35 studies
replace studies=. if studies>100

rename sec3_39 government_financial_help

rename sec3_40 asylum
rename sec3_41 fav_mig
replace fav_mig=. if fav_mig>100

replace outside_contact_no=. if outside_contact_no>1000

replace expectation_wage=expectation_wage/`change'

gen sec3_42_corrected = sec3_42
replace sec3_42_corrected = sec3_42_corrected*1000000 if sec3_42_corrected < 999
replace sec3_42_corrected = sec3_42_corrected*1000 if sec3_42_corrected < 999999

gen expected_living_cost = sec3_42_corrected/`change'
global winsor = "expectation_wage expected_living_cost"

foreach y in $winsor {
	gen `y'_winsor = `y'
	qui sum `y', detail
	replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)'
	replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)'
	gen asinh`y'_winsor = asinh(`y'_winsor)
}

rename asinhexpected_living_cost_winsor asinhexp_liv_cost_winsor

*family revenue
rename sec8_q6 family_revenue


global winsor = "`route'_duration `route'_journey_cost"

global routes_list = "Italy Spain"

foreach route_u in $routes_list {

	local route = lower("`route_u'")

	global winsor = "`route'_duration `route'_journey_cost"

	foreach y in $winsor {
		gen `y'_winsor = `y'
		qui sum `y', detail
		replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)'
		replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)'
		gen asinh`y'_winsor = asinh(`y'_winsor)
	}

}


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



*******************************build indeces
global economic_outcomes = " employed asinhexpectation_wage_winsor " ///
						+ " studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " fav_mig " ///
						+ " asinhexp_liv_cost_winsor "

						
*kling and pca
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










*strata
xtile xtile_size=school_size, nq(2)
local strata "xtile_size"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)


*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index " ///
				+ " outside_contact_no mig_classmates mig_des mig_plan mig_prep " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage employed asylum studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " fav_mig government_financial_help"

** Collapse at cluster level
*collapse (mean) $bc_var treatment, by(schoolid)


						
** labeling
label var wealth_index "Wealth index"
label var strata_n2 "Big school"
label var school_size "School size"
label var mig_plan "Planning to migr."
label var mig_prep "Preparing to migr."
label var mig_des "Wishing to migrate"
label var outside_contact_no "\# acquaint. abroad"
label var age "Student's age"
label var gender "Male student"
label var mig_classmates "\# classmates who migr."

label var asinhexpectation_wage_winsor "\(sin^{-1}\) expected wage at dest."
label var employed "Prob. of finding a job"
label var asylum "Asylum prob., if requested"
label var studies "Prob. of continuing studies"
label var becoming_citizen "Prob. of becoming citizen"
label var return_5yr "Prob. of having ret. 5yrs"
label var asinhexp_liv_cost_winsor "\(sin^{-1}\) expected liv. cost at dest."
label var fav_mig "Perc. in favor of migr. at destination"
label var government_financial_help "Prob. receiving fin. help"

label var italy_forced_work "Probab. of being forced to work Ita"
label var spain_forced_work "Probab. of being forced to work Spa"

label var italy_kidnapped "Probab. of being held Ita"
label var spain_kidnapped "Probab. of being held Spa"

label var italy_sent_back "Probab. of being sent back Ita"
label var spain_sent_back "Probab. of being sent back Spa"

label var italy_beaten "Probability to be beaten Ita"
label var spain_beaten "Probability to be beaten Spa"

label var asinhitaly_duration "\(sin^{-1}\) duration of the journey Ita"
label var asinhspain_duration "\(sin^{-1}\) duration of the journey Spa"

label var asinhitaly_journey_cost "\(sin^{-1}\) cost of the journey Ita"
label var asinhspain_journey_cost "\(sin^{-1}\) cost of the journey Spa"

label var italy_beaten "Probability to be beaten Ita"
label var spain_beaten "Probability to be beaten Spa"

label var italy_die_boat "Death prob. in boat Ita"
label var spain_die_boat "Death prob. in boat Spa"

label var italy_die_bef_boat "Death prob. bef. boat Ita"
label var spain_die_bef_boat "Death prob. bef. boat Spa"

label var moth_school "Mother attended school"
label var fath_school "Father attended school"



********************************BALANCE TABLE***********************************

preserve
iebaltab $bc_var, grpvar(treatment_status) control(1) browse normdiff vce(cluster schoolid) rowvarlabels


forval i = 1/15 {
	rename v`i' w`i'
}

keep w1 w13-w15
keep if _n >3
drop if _n >72
gen check = mod(_n, 2)
keep if check == 1
drop check
destring w13-w15, replace

dataout , tex replace save(normalized)

restore
