***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - Parameters                                               
***_____________________________________________________________________________

** Install packages
*ssc install randomize
*ssc install nearstat
*ssc install listtex
*ssc intall orth_out

global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data"
local lycee "$main/raw/lycee_conakry.xlsx"






***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - Importing the data                                               
***_____________________________________________________________________________


import excel using "`lycee'", firstrow clear
keep N etab nb_student_at_randomiz_date
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
merge 1:m lycee_name_string using "$main/output/questionnaire_baseline_clean.dta"
keep if _merge==3
drop _merge

rename CODE schoolid
label var schoolid "id school number"

drop note*




***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   2 - covariates  cleaning                          
***_____________________________________________________________________________

//SOCIO ECONOMIC CONTROLS/

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
		replace family_size=. if family_size==99 |  family_size==999 


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
		replace outside_contact_no=. if outside_contact_no>1000


// MAIN OUTCOMES
*migration desire
		rename sec2_q1 mig_desire
		replace mig_desire=0 if mig_desire==2


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
		replace `var'=. if `var'==99 | `var'==999 | `var'<=0 | `var'==999999999
		}

*journey_duration
		local duration "italy_duration spain_duration"
		foreach var of local duration {
		replace `var'=. if `var'<=0
		replace `var'=. if `var'>99 | `var'==999 | `var'==999999999


}

*employment
		replace sec3_32=. if sec3_32==999
		rename sec3_32 employed

rename sec3_35 studies
replace studies=. if studies >100

rename sec3_40 asylum
rename sec3_41 fav_mig
replace fav_mig=. if fav_mig>100

*log wage
gen log_wage=log(expectation_wage+1)

*family revenue
rename sec8_q6 family_revenue

gen duration=.
replace duration=(italy_duration+spain_duration)/2

gen beaten=.
replace beaten=(italy_beaten+spain_beaten)/2

gen journey_cost=.
replace journey_cost=(spain_journey_cost+italy_journey_cost)/2

gen die_boat=.
replace die_boat=(spain_die_boat+italy_die_boat)/2

gen die_bef_boat=.
replace die_bef_boat=(spain_die_bef_boat+italy_die_bef_boat)/2



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

/*
*substitution of mean for missing values
foreach var of local component {
qui sum `var',detail
replace `var'=`r(mean)' if `var'==.
}
*/


pca `component', factor(1)
predict wealth_index






***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  3 PREPARING TREATMENT ALLOCATION                        
***_____________________________________________________________________________
gen planning=sec2_q4
replace planning=0 if planning==2

gen prepare=sec2_q7
replace prepare=0 if prepare==2

	
// SELECTING THE VARIABLE FOR THE BALANCE 
global bc_var = " age gender  outside_contact_no log_wage employed asylum studies"


** Collapse at cluster level
collapse (mean) $bc_var italy_duration wealth_index mig_desire mig_classmates italy_die_boat pular_language sousou_language malinke_language italy_beaten beaten duration journey_cost die_boat die_bef_boat italy_die_bef_boat size italy_journey_cost spain_journey_cost planning prepare spain_beaten spain_duration spain_die_boat spain_die_bef_boat expectation_wage fav_mig it_favorite_road sp_favorite_road, by(schoolid)






***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  4 TREATMENT ALLOCATION                    
***_____________________________________________________________________________


// STRATA : SCHOOL SIZE / DHS INDEX
xtile quart_size=size, nq(2)
xtile quart_wealth = wealth_index, nq(3)

local strata "quart_size quart_wealth"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)


sort schoolid
set seed 23455
gen random=runiform()


sort quart_size quart_wealth
by quart_size quart_wealth : gen strata_size= _N


*We want to split schools into groups of 4, where each group represents 10 control, 10 treatment, 10 T2, 10 T3/k the stratum into 10 groups: (40/4 = 10)
by quart_size quart_wealth : gen group = group(strata_size/4)

*Within each group, sort randomly
sort quart_size quart_wealth group random, stable


*Figure out how many schools are in each group (should be 4, but may be less if the number of schools is not a multiple of 4). 
sort quart_size quart_wealth group
by quart_size quart_wealth group: gen groupsize = _N

/* 8 misfits !*/

*Assign a value reflecting the current (random) order of these schools in each group (should take on a value of 1, 2, 3 or 4).
by quart_size quart_wealth group: gen groupindex = _n

*If the group has less than 4 schools, make the value equal to 0.
replace groupindex = 0 if groupsize != 4


preserve
drop if groupindex == 0 
* treatment allocation for group with 4 schools.
 randomize, groups(4) block(quart_size quart_wealth) balance($bc_var) jointp(0.5) seed(2111) minruns(1000) replace
save "treat_misfit.dta", replace
restore


*For the schools in groups of less than 4, we can randomize as if they are all equivalent and part of the same strata
keep if groupindex == 0
sum schoolid if groupindex == 0
scalar oddSCHOOL = r(N)

sort groupindex random, stable
gen _assignment=1 if groupindex == 0
replace _assignment = 2 if _n <= (oddSCHOOL/4) & groupindex == 0
replace _assignment = 3 if _n > (oddSCHOOL/4) & _n <= (oddSCHOOL/2) & groupindex == 0
replace _assignment = 4 if _n > (oddSCHOOL/2) & _n <= (oddSCHOOL)*3/4 & groupindex == 0

append using "treat_misfit.dta"


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  5 BALANCE CHECKS                    
***_____________________________________________________________________________


orth_out age gender pular_language sousou_language malinke_language outside_contact_no mig_classmates  log_wage expectation_wage  employed asylum studies italy_duration italy_journey_cost italy_beaten italy_die_bef_boat italy_die_boat spain_duration spain_journey_cost spain_beaten spain_die_bef_boat spain_die_boat beaten duration journey_cost die_boat die_bef_boat planning prepare mig_desire using "$main/bc_var_rerando.xls", by(_assignment) se test compare stars replace covariates(strata_n*) count vcount title(Balance checks)  armlabel("Control group" "Treatment risk" "Treatment condition in UE" "Double Treatment")

