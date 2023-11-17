***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - Parameters                                               
***_____________________________________________________________________________


global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data"
local lycee "$main/raw/lycee_conakry.xlsx"
local component "sec7_q4_n1 sec7_q4_n2 sec7_q4_n4 sec7_q4_n5 sec7_q4_n6 sec7_q4_n7 sec7_q4_n8 sec7_q4_n9 sec7_q4_n10 sec7_q4_n11 sec7_q4_n12 sec7_q4_n13 sec7_q4_n14 sec7_q5_n1 sec7_q5_n2 sec7_q5_n3 sec7_q5_n4 sec7_q5_n5 sec7_q5_n6 sec7_q5_n7 sec7_q6_a sec7_q6_b sec7_q6_c sec7_q6_d sec7_q6_f sec7_q6_g sec7_q6_h sec7_q6_i sec7_q6_j sec7_q6_k sec7_q6_l sec7_q6_m"


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
***   2 - covariates    cleaning                          
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
rename sec3_40 asylum
rename sec3_41 fav_mig
replace fav_mig=. if fav_mig>100
gen log_wage=log(expectation_wage)


//DHS Index
*generating the  dummy variables for categorical
tab sec7_q4 , gen(sec7_q4_n)
tab sec7_q5 , gen(sec7_q5_n)

* deleting variable without no variation    
foreach var of local component {
sum `var'
}
///>>> ok 

**substitution of mean for missing values
foreach var of local component {
qui sum `var',detail
replace `var'=`r(mean)' if `var'==.
}

*normalize
foreach var of local component {
qui sum `var'
replace `var'=(`var'-`r(mean)')/`r(sd)'
}


pca `component', factor(1)
predict wealth_index





***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  3 PREPARING TREATMENT ALLOCATION                        
***_____________________________________________________________________________

		xtile quart_wealth = wealth_index, nq(3)
		bys libelle_dsee : egen wealth_ind_zone=mean(wealth_index)
		xtile quart_wealth_zone = wealth_ind_zone, nq(3)
		
		
* variable for balance 
global bc_var = "mig_desire age gender pular_language sousou_language malinke_language outside_contact_no mig_classmates italy_duration italy_beaten spain_duration spain_beaten it_favorite_road expectation_wage employed asylum"


** Collapse at cluster level
collapse (mean) $bc_var size wealth_index, by(schoolid)




***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  4 TREATMENT ALLOCATION                        
***_____________________________________________________________________________
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                        
***______________SIMPLE STRATIFICATION__________________________________________

sort schoolid
set seed 3022019
gen random=runiform()

*STRATA : SCHOOL SIZE / DHS INDEX
xtile quart_size=size, nq(2)
xtile quart_wealth = wealth_index, nq(2)

sort quart_size quart_wealth random
by quart_size quart_wealth : gen strata_size = _N
by quart_size quart_wealth : gen strata_index = _n

egen strata=group(quart_size quart_wealth)
label var strata "Strata"
tab strata, gen(strata_n)


*treatment allocation
gen treatment=0
replace treatment = 1 if strata_index <= strata_size/4
replace treatment = 2 if strata_index > strata_size/4 & strata_index <= strata_size/2
replace treatment = 3 if strata_index > strata_size/2 & strata_index<= strata_size*3/4

drop strata_size strata_index random





// BALANCE TEST
orth_out $bc_var using "$main/bc_var_strata.xls", by(treatment) se test compare stars replace covariates(strata_n*) count vcount title(Balance checks)


*>>> TREATMENT IS NOT EQUALLY DISTRIBUTED


