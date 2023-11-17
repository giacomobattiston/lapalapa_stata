
clear all

set more off

*global main "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo"
global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"


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

replace expectation_wage=expectation_wage/`change'
gen logexpectation_wage = log(1+expectation_wage)

*log wage
gen log_wage=log(expectation_wage+1)

*family revenue
rename sec8_q6 family_revenue

gen 	duration=.
replace duration=(italy_duration+spain_duration)/2
gen 	logduration=log(1+duration)

gen 	beaten=.
replace beaten=(italy_beaten+spain_beaten)/2

gen 	journey_cost=.
replace journey_cost=(spain_journey_cost+italy_journey_cost)/(2*`change')
gen logjourney_cost = log(1+journey_cost)

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


*strata
xtile xtile_size=school_size, nq(2)
local strata "xtile_size"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)


*variable for the balance
global bc_var = " school_size gender age moth_school fath_school wealth_index outside_contact_no mig_classmates mig_des mig_plan mig_prep logduration logjourney_cost beaten die_boat die_bef_boat logexpectation_wage employed asylum studies"

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
label var logexpectation_wage "Log expected wage at dest."
label var employed "Prob. of finding a job"
label var asylum "Asylum prob., if requested"
label var studies "Prob. of continuing studies"
label var beaten "Probability to be beaten$^{(1)}$"
label var logduration "Log duration of the journey$^{(1)}$"
label var logjourney_cost "Log cost of the journey$^{(1)}$"
label var die_boat "Death prob. in boat$^{(1)}$"
label var die_bef_boat "Death prob. bef. boat$^{(1)}$"
label var moth_school "Mother attended school"
label var fath_school "Father attended school"

gen treatment_status_1 = treatment_status == 1
gen treatment_status_2 = treatment_status == 2
gen treatment_status_3 = treatment_status == 3
gen treatment_status_4 = treatment_status == 4


********************************BALANCE TABLE***********************************

balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if treatment_status == 1 | treatment_status == 2) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable.tex", covariates( strata_n2 ) ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table \label{balancetable}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes throught Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\end{longtable}")

global outcomes = " mig_des mig_plan mig_prep logduration logjourney_cost beaten die_boat die_bef_boat logexpectation_wage employed asylum studies"
global controls = " school_size gender age moth_school fath_school wealth_index outside_contact_no mig_classmates"

**************************ATTRITION, INDIVIDUAL DATA****************************
*without interactions

reg lost i.treatment_status i.strata, cluster(schoolid)
est sto reg1

reg lost i.treatment_status  i.strata $outcomes, cluster(schoolid)
est sto reg2

reg lost i.treatment_status i.strata $outcomes $controls , cluster(schoolid)
est sto reg3

*with interactions

reg lost i.treatment_status##c.mig_plan i.strata, cluster(schoolid)
est sto reg4

reg lost i.treatment_status##c.mig_plan i.strata $controls, cluster(schoolid)
est sto reg5

esttab reg1 reg2 reg3 reg4 reg5 using ///
	"attritioncluster.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.mig_plan "Control X Planning" ///
	2.treatment_status#c.mig_plan "Risk X Planning" ///
	3.treatment_status#c.mig_plan "Econ X Planning" ///
	4.treatment_status#c.mig_plan "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	nonumbers title("Attrited at follow-up, treatment and controls \label{attritioncluster}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	addnotes("Errors are clustered at the school level." ) longtable label

	
foreach v of global outcomes {
	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
  	}
 }
 
 foreach v of global controls {
	local l`v' : variable label `v'
        if `"`l`v''"' == "" {
 		local l`v' "`v'"
  	}
 }

preserve

collapse lost treatment_status strata $outcomes $controls, by(schoolid)


 foreach v of global outcomes {
	label var `v' "`l`v''"
 }
 
 
 foreach v of global controls {
 	label var `v' "`l`v''"
 }
 
*without interactions

reg lost i.treatment_status i.strata
est sto reg1

reg lost i.treatment_status  i.strata $outcomes
est sto reg2

reg lost i.treatment_status i.strata $outcomes $controls
est sto reg3

reg lost i.treatment_status##c.mig_plan i.strata
est sto reg4

reg lost i.treatment_status##c.mig_plan i.strata $controls
est sto reg5

esttab reg1 reg2 reg3 reg4 reg5 using ///
	"attritionschools.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.mig_plan "Control X Planning" ///
	2.treatment_status#c.mig_plan "Risk X Planning" ///
	3.treatment_status#c.mig_plan "Econ X Planning" ///
	4.treatment_status#c.mig_plan "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	nonumbers title("Attrited at follow-up, treatment and controls, school averages \label{attritionschools}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	 longtable label

restore


********************PARTICIPATION BY STAGE AND TREATMENT ARM********************

*baseline

m: obs = J(5,5,.)

qui count if treatment_status == 1
local N2 = `r(N)'

qui count if treatment_status == 2
local N3 = `r(N)'

qui count if treatment_status == 3
local N4 = `r(N)'

qui count if treatment_status == 4
local N5 = `r(N)'

m: obs[1,2] = strtoreal(st_local("N2"))
m: obs[1,3] = strtoreal(st_local("N3"))
m: obs[1,4] = strtoreal(st_local("N4"))
m: obs[1,5] = strtoreal(st_local("N5"))
m: obs[1,1] = obs[1,2] + obs[1,3] + obs[1,4] + obs[1,5]

*sensibilization

qui count if treatment_status == 1 & sensibilized == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & sensibilized == 1
local N3 = `r(N)'


qui count if treatment_status == 3 & sensibilized == 1
local N4 = `r(N)'

qui count if treatment_status == 4 & sensibilized == 1
local N5 = `r(N)'

m: obs[2,2] = 0
m: obs[2,3] = strtoreal(st_local("N3"))
m: obs[2,4] = strtoreal(st_local("N4"))
m: obs[2,5] = strtoreal(st_local("N5"))
m: obs[2,1] = obs[2,2] + obs[2,3] + obs[2,4] + obs[2,5]

m: obs[3,1] = round(obs[2,1]/obs[1,1], .01)
m: obs[3,2] = 0
m: obs[3,3] = round(obs[2,3]/obs[1,3], .01)
m: obs[3,4] = round(obs[2,4]/obs[1,4], .01)
m: obs[3,5] = round(obs[2,5]/obs[1,5], .01)


*follow-up


qui count if treatment_status == 1 & duplic == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & duplic == 1
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & duplic == 1
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & duplic == 1
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[4,2] = strtoreal(st_local("N2"))
m: obs[4,3] = strtoreal(st_local("N3"))
m: obs[4,4] = strtoreal(st_local("N4"))
m: obs[4,5] = strtoreal(st_local("N5"))
m: obs[4,1] = obs[4,2] + obs[4,3] + obs[4,4] + obs[4,5]

m: obs[5,1] = round(obs[4,1]/obs[1,1], .01)
m: obs[5,2] = round(obs[4,2]/obs[1,2], .01)
m: obs[5,3] = round(obs[4,3]/obs[1,3], .01)
m: obs[5,4] = round(obs[4,4]/obs[1,4], .01)
m: obs[5,5] = round(obs[4,5]/obs[1,5], .01)

m: st_matrix("obs", obs)
matrix colnames obs = `" "All"" Control" "Risk" "Econ" "Double" "'
matrix rownames obs = `" "Baseline"   "Participants in the intervention" "Fraction of Basline"  "Follow-up" "Fraction of Basline" "'

outtable  using attrition, mat(obs) nobox replace caption("Tabella attrition number of observations by treatment arm and round \label{attrition}")

