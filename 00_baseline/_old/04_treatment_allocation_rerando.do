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
		replace `var'=. if `var'==99 | `var'==999 | `var'<=0
		}

*journey_duration
		local duration "italy_duration spain_duration"
		foreach var of local duration {
		replace `var'=. if `var'<=0
		replace `var'=. if `var'==99 | `var'==999
}

*employment
		replace sec3_32=. if sec3_32==999
		rename sec3_32 employed

rename sec3_35 studies
replace studies=. if studies>100

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

/*substitution of mean for missing values
foreach var of local component {
qui sum `var',detail
replace `var'=`r(mean)' if `var'==.
}*/


local component "sec7_q4_n1 sec7_q4_n2 sec7_q4_n3 sec7_q4_n4 sec7_q4_n5 sec7_q4_n6 sec7_q4_n7 sec7_q4_n8 sec7_q4_n9 sec7_q4_n10 sec7_q4_n11 sec7_q4_n12 sec7_q4_n13 sec7_q4_n14 sec7_q5_n1 sec7_q5_n2 sec7_q5_n3 sec7_q5_n4 sec7_q5_n5 sec7_q5_n6 sec7_q5_n7 sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m"

pca `component', factor(1)
predict wealth_index






***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  3 PREPARING TREATMENT ALLOCATION                        
***_____________________________________________________________________________
// CHOOSING THE STRATA
//wealth
gen planning=sec2_q4
replace planning=0 if planning==2

gen prepare=sec2_q7
replace prepare=0 if prepare==2

bys libelle_dsee : egen wealth_ind_zone=mean(wealth_index)
gen wealth_index2=(wealth_index)^2

gen wealth_ind_zone2=(wealth_ind_zone)^2
xtile quart_wealth = wealth_index, nq(3)

xtile quart_wealth_zone = wealth_ind_zone, nq(3)

		reg mig_desire wealth_index gender age, cluster(schoolid)
		reg mig_desire wealth_index gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		
		reg planning wealth_index gender age, cluster(schoolid)
		reg planning wealth_index gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		
		reg prepare wealth_index gender age, cluster(schoolid)
		reg prepare wealth_index gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*>> no correlation
		
// with the square :
		reg mig_desire wealth_index wealth_index2, cluster(schoolid)
		reg mig_desire wealth_index wealth_index2 gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*no correlation 
		
		reg planning wealth_index wealth_index2, cluster(schoolid)
		reg planning wealth_index wealth_index2 gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*only the SQUARE IS SIGNIFICANT
		
		reg prepare wealth_index wealth_index2, cluster(schoolid)
		reg prepare wealth_index wealth_index2 gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*no correlation
		
*wealth by district
		
		reg mig_desire wealth_ind_zone gender age, cluster(schoolid)
		reg mig_desire wealth_ind_zone gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*no correlation
		
		reg planning wealth_ind_zone gender age, cluster(schoolid)
		reg planning wealth_ind_zone gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*no correlation
		
		reg prepare wealth_ind_zone gender age, cluster(schoolid)
		reg prepare wealth_ind_zone gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*no correlation
		
// with the square :
		reg mig_desire wealth_ind_zone wealth_ind_zone2, cluster(schoolid)
		reg mig_desire wealth_ind_zone wealth_ind_zone2 gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*no correlation 
		
		reg planning wealth_ind_zone wealth_ind_zone2, cluster(schoolid)
		reg planning wealth_ind_zone wealth_ind_zone2 gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*no correlation
		
		reg prepare wealth_ind_zone wealth_ind_zone2, cluster(schoolid)
		reg prepare wealth_ind_zone wealth_ind_zone2 gender age italy_beaten italy_duration italy_journey_cost employed fav_mig asylum mig_classmates outside_contact_no, cluster(schoolid)
		*only the square is significant
			
		
//SIZE
		reg mig_desire size, cluster(schoolid)
		*correlated
		
		
	
	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  4 SELECTING THE VARIABLE FOR THE BALANCE                      
***_____________________________________________________________________________
	
//the global must be changed depending on the strategy of stratification because of convergence issues
global bc_var = " age gender  outside_contact_no log_wage employed asylum studies  italy_duration"


** Collapse at cluster level
collapse (mean) $bc_var mig_desire mig_classmates italy_beaten italy_die_boat size pular_language sousou_language malinke_language wealth_index expectation_wage italy_journey_cost italy_die_bef_boat spain_duration spain_journey_cost spain_beaten spain_die_bef_boat spain_die_boat beaten duration journey_cost die_boat die_bef_boat planning prepare, by(schoolid)

// STRATA : SCHOOL SIZE / DHS INDEX
xtile quart_size=size, nq(2)
xtile quart_wealth = wealth_index, nq(3)

local strata "quart_size quart_wealth"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)






***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  5 TREATMENT ALLOCATION                        
***_____________________________________________________________________________

randomize, groups(4) block(`strata') balance($bc_var) jointp(0.5) seed(12345) minruns(10000) replace

*>> not working if we balance with all the set of covariates $bc_var



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  6 BALANCE CHECKS                    
***_____________________________________________________________________________


orth_out age gender pular_language sousou_language malinke_language wealth_index outside_contact_no mig_classmates log_wage expectation_wage  employed asylum studies italy_duration italy_journey_cost italy_beaten italy_die_bef_boat italy_die_boat spain_duration spain_journey_cost spain_beaten spain_die_bef_boat spain_die_boat beaten duration journey_cost die_boat die_bef_boat planning prepare mig_desire using "$main/bc_var_rerando.xls", by(_assignment) se test compare stars replace covariates(strata_n*) count vcount title(Balance checks)  armlabel("Control group" "Treatment risk" "Treatment condition in UE" "Double Treatment")

