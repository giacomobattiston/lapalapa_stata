/*******************************************************************************
*
*   PROJECT     :    INFORMING RISK MIGRATION 
*                   (E. La Ferrara, L. Corno, G.Battiston)
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*   TITLE      :    04 - ANALYSIS GLOBAL RESULTS : IN PROGRESS
*                   ____________________________________________________________
*                   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*
********************************************************************************/

/*03_merge
Date Created: June 1rst, 2019
Date Last Modified: June 1rst, 2019
Created by: Cloe SARRABIA
Last modified by: Cloe SARRABIA
*	Inputs: 
*   Outputs : 
OUTLINE :

01- Reading the data and parameters
02- Summary statistics and balance check
03- Basic regression (IN PROGRESS)
		- cleaning
		- ITT without controls
*/



* initialize Stata
clear all
set more off
set mem 100m


*Cloe user
global user "C:\Users\cloes_000"

global main "$user\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
global output "$main\Data\output\analysis"


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 01 -  READING THE DATA AND PARAMETERS              
***_____________________________________________________________________________


use "$main\Data\output\analysis\guinea_final_dataset.dta", clear

global outcomes_mig "sec2_q1 sec2_q4_bis sec2_q7 sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3 sec2_q8 sec2_q10_a sec2_q10_b sec2_q10_c road_selection"

global outcomes_risk "italy_awareness italy_duration italy_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_die_bef_boat italy_die_boat italy_sent_back spain_awareness spain_duration spain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_die_bef_boat spain_die_boat spain_sent_back"

global outcomes_benefit "sec3_32 sec3_34 expectation_wage sec3_35 sec3_36 sec3_37 sec3_39 sec3_40 sec3_41 sec3_42"

global outcomes_knowledge "sec5_q1 sec5_q2 sec5_q3 sec5_q4 sec5_q5 sec5_q6"

global sensi "partb*"





***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 02 -  SUMMARY STATS AND BALANCE CHECK TABLES              
***_____________________________________________________________________________

preserve
********************************************************************************
//,\\'// 	     	A -  CLEANING of the covariates    	 			'//,\\'
********************************************************************************


*keeping the baseline data
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


*variable for the balance
global bc_var = "size gender age moth_school fath_school wealth_index outside_contact_no mig_classmates mig_des mig_plan mig_prep duration journey_cost beaten die_boat die_bef_boat expectation_wage employed asylum studies"

** Collapse at cluster level
collapse (mean) $bc_var treatment, by(schoolid)

** labeling
label var wealth_index "Wealth index"
label var size "School size"
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
xtile xtile_size=size, nq(2)
local strata "xtile_size"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)


*orth_out $bc_var using "$main/Data/output/analysis/balance_check.xlsx", by(treatment) se test pcompare stars covariates(strata_n*) count title(Balance checks) armlabel("Control group" "Treatment risk" "Treatment condition in UE" "Double Treatment")

********************************************************************************
//,\\'// 	     	B- BALANCE CHECK TABLE   	 			'//,\\'
********************************************************************************


// DIFFERENCE IN MEANS

mata : mata clear
local i=1

foreach var in $bc_var {
	reg `var' i.treatment i.strata if treatment==1 | treatment==2, vce(cluster schoolid)
	outreg, keep(2.treatment) rtitle ("`: var label `var''") stats(b) noautosumm  starlevels(10 5 1) starloc(1) store(row`i')
	outreg, replay(diff) append(row`i') store(diff)
	local `i+1'
}


local j=1
foreach var in $bc_var {
	reg `var' i.treatment i.strata if treatment==1 | treatment==3, vce(cluster schoolid)
	outreg, keep(3.treatment) rtitle ("`: var label `var''") stats(b) noautosumm  starlevels(10 5 1) starloc(1) store(row`j')
	outreg, replay(diff2) append(row`j') store(diff2)
	local `j+1'
}

local k=1
foreach var in $bc_var {
	reg `var' i.treatment i.strata if treatment==1 | treatment==4, vce(cluster schoolid)
	outreg, keep(4.treatment) rtitle ("`: var label `var''") stats(b) noautosumm  starlevels(10 5 1) starloc(1) store(row`k')
	outreg, replay(diff3) append(row`k') store(diff3)
	local `k+1'
}


local l=1
foreach var in $bc_var {
	reg `var' i.treatment i.strata if treatment==2 | treatment==3, vce(cluster schoolid)
	outreg, keep(3.treatment) rtitle ("`: var label `var''") stats(b) noautosumm  starlevels(10 5 1) starloc(1) store(row`l')
	outreg, replay(diff4) append(row`l') store(diff4)
	local `l+1'
}

local m=1
foreach var in $bc_var {
	reg `var' i.treatment i.strata if treatment==2 | treatment==4, vce(cluster schoolid)
	outreg, keep(4.treatment) rtitle ("`: var label `var''") stats(b) noautosumm  starlevels(10 5 1) starloc(1) store(row`m')
	outreg, replay(diff5) append(row`m') store(diff5) note("")
	local `m+1'
}


local n=1
foreach var in $bc_var {
	reg `var' i.treatment i.strata if treatment==3 | treatment==4, vce(cluster schoolid)
	outreg, keep(4.treatment) rtitle ("`: var label `var''") stats(b) noautosumm  starlevels(10 5 1) starloc(1) store(row`n')
	outreg, replay(diff6) append(row`n') store(diff6) note("")
	local `n+1'
}


outreg, replay(diff) merge(diff2) store(diff7)
outreg, replay(diff7) merge(diff3) replace store(diff8)
outreg, replay(diff8) merge(diff4) replace store(diff9)
outreg, replay(diff9) merge(diff5) replace store(diff10)
outreg using "$output\tables\balance2", fragment tex replay(diff10) store(diff11) bdec(2) stats(b) tdec(2) merge(diff6) starlevel(10 5 1) nocenter plain replace ctitles("", "Diff Control", "Diff Control", "Diff control", "Diff Treatment 2", "Diff Treatment 2", "Diff Treatment 3", ""\"", "Treatment 2", "Treatment 3", "Treatment 4",  "Treatment 3", "Treatment 4", "Treatment 4")




mat nobs = J(1,6,.)
	quietly : sum treatment if treatment==1 | treatment==2
	mat nobs[1,1]=`r(N)'
	quietly : sum treatment if treatment==1 | treatment==3
	mat nobs[1,2]=`r(N)'
	quietly : sum treatment if treatment==1 | treatment==4
	mat nobs[1,3]=`r(N)'
	quietly : sum treatment if treatment==2 | treatment==3
	mat nobs[1,4]=`r(N)'
	quietly : sum treatment if treatment==2 | treatment==4
	mat nobs[1,5]=`r(N)'
	quietly : sum treatment if treatment==3 | treatment==4
	mat nobs[1,6]=`r(N)'
frmttable, statmat(nobs) store(no) sfmt(g,g,g,g,g,g) rtitle(Total number of schools) 
outreg using "$main\Data\output\analysis\tables\balance2", fragment tex replay(diff11) store(diff12) bdec(2) stats(b) tdec(2) append(no) starlevel(10 5 1) nocenter plain replace ctitles("", "Diff Control", "Diff Control", "Diff control", "Diff Treatment 1", "Diff Treatment 1", "Diff Treatment 2", ""\"", "Treatment 1", "Treatment 2", "Treatment 3",  "Treatment 2", "Treatment 3", "Treatment 3")  hlines(101{0}11)

********************************************************************************
//,\\'// 	             	C- SUMMARY STATISTICS                       '//,\\'
********************************************************************************


local count : word count $bc_var
mat sumstat = J(`count',4,.)
local i=1
foreach var in $bc_var {
	quietly : summarize `var' if treatment==1
	mat sumstat[`i',1]=r(mean)
	quietly : summarize `var' if treatment==2
	mat sumstat[`i',2]=r(mean)
	quietly : summarize `var' if treatment==3
	mat sumstat[`i',3]=r(mean)
	quietly : summarize `var' if treatment==4
	mat sumstat[`i',4]=r(mean)
	local i=`i'+1
	
}
matrix rownames sumstat= $bc_var

frmttable, statmat(sumstat) store(sumstat) sfmt(g,g,g,g) varlabels addrows("Number of Schools", 40, 40, 40,40) 


outreg using "$output\tables\stat_des.tex", varlabels tex fragment replace replay(sumstat)  bdec(2) tdec(2) starlevel(10 5 1) nocenter plain ctitles("", "Control", "Treatment 1", "Treatment 2", "Ttreatment 3	") hlines(11{0}11)
outreg using "$output\tables\balance2", fragment tex replay(diff11) store(part1) bdec(2) stats(b) tdec(2) append(no) starlevel(10 5 1) nocenter plain replace ctitles("", "Diff Control", "Diff Control", "Diff control", "Diff Treatment 1", "Diff Treatment 1", "Diff Treatment 2", ""\"", "Treatment 1", "Treatment 2", "Treatment 3",  "Treatment 2", "Treatment 3", "Treatment 3")
outreg using "$output\tables\stat_des.tex", varlabels tex fragment replace replay(sumstat) store(part2)  bdec(2) tdec(2) starlevel(10 5 1) nocenter plain ctitles("", "Control", "Treatment 1", "Treatment 2", "Ttreatment 3	")





restore



***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*** 03 -  BASIC REGRESSION            
***_____________________________________________________________________________


********************************************************************************
//,\\'// 	      A  -  CLEANING to facilitate the analysis    		    '//,\\'
********************************************************************************

*changing the outcome categorical variable 1/2 to dummy variable to facilitate the analysis"

replace sec2_q1=0 if sec2_q1==2
	label values sec2_q1 yes_no_bis

replace sec2_q4=0 if sec2_q4==2
	label values sec2_q4 yes_no_bis
	
replace sec2_q4_bis=0 if sec2_q4_bis==2
	label values sec2_q4_bis yes_no_bis
	
replace sec2_q7=0 if sec2_q7==2
	label values sec2_q7 yes_no_bis
	
replace sec2_q8=0 if sec2_q8==2
	label values sec2_q8 yes_no_bis
	
replace sec2_q10_a=0 if sec2_q10_a==2
	label values sec2_q10_a yes_no_bis
	
replace sec2_q10_b=0 if sec2_q10_b==2
	label values sec2_q10_a yes_no_bis
	
replace sec2_q10_b=0 if sec2_q10_b==2
	label values sec2_q10_b yes_no_bis
	
replace sec2_q10_c=0 if sec2_q10_c==2
	label values sec2_q10_c yes_no_bis
	
tabulate road_selection, gen(favorite_road)	
	rename favorite_road1 fav_road_it
	rename favorite_road2 fav_road_sp
	rename favorite_road3 fav_road_ce
	label var fav_road_it "Those 100 people like me would take a boat to ITALY"
	label var fav_road_sp "Those 100 people like me would take a boat to SPAIN"
	label var fav_road_ce "Those 100 people like me would climb over the fence of CEUTA or MELILLA"
	
	
	

********************************************************************************
//,\\'//     B   Intention To Treat regression without controls      	 '//,\\'
********************************************************************************

xtset id_number time


*** a. outcome related to migration decision
********************************************************************************

/* Comments:
i) I differenciate the outcomes
ii) cluster by school
*/


global outcomes_mig "sec2_q1 sec2_q4_bis sec2_q7 sec2_q7_example_1 sec2_q7_example_2 sec2_q7_example_3 sec2_q8 sec2_q10_a sec2_q10_b sec2_q10_c"

foreach var in $outcomes_mig {
eststo : reg D.`var' i.treatment, vce(cluster schoolid)
}
esttab using "$output\itt_mig_outcomes.tex", replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001)



global outcomes_risk_it "italy_duration italy_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_die_bef_boat italy_die_boat italy_sent_back"

eststo clear
foreach var in $outcomes_risk_it {
eststo : reg D.`var' i.treatment, vce(cluster schoolid)
}

esttab using "$output\itt_risk_it_outcomes.tex", replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001)



global outcomes_risk_sp "spain_duration spain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_die_bef_boat spain_die_boat spain_sent_back"
eststo clear
foreach var in $outcomes_risk_sp {
eststo : reg D.`var' i.treatment, vce(cluster schoolid)
}

esttab using "$output\itt_risk_sp_outcomes.tex", replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001)




eststo clear
foreach var in $outcomes_benefit {
eststo : reg D.`var' i.treatment, vce(cluster schoolid)
}

esttab using "$output\itt_benefit.tex", replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001)



