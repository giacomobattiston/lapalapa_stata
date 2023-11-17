
clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"


use ${main}/Data/output/analysis/guinea_final_dataset.dta

cd "$main/Draft/tables"


*******************************DATASET PREPARATION******************************

tsset id_number time 

duplicates tag id_number, generate(duplic)

*keeping the baseline data
keep if time==0

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
				+ " outside_contact_no mig_classmates desire planning prepare " ///
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
label var planning "Planning to migr."
label var prepare "Preparing to migr."
label var desire "Wishing to migrate"
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

gen treatment_status_1 = treatment_status == 1
gen treatment_status_2 = treatment_status == 2
gen treatment_status_3 = treatment_status == 3
gen treatment_status_4 = treatment_status == 4


********************************BALANCE TABLE***********************************

balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if treatment_status == 1 | treatment_status == 2) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_nostrat.tex",  ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table \label{balancetable}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\end{longtable}")

stop	 
	 
global outcomes = " desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage employed asylum studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " fav_mig government_financial_help "
				
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

reg lost i.treatment_status##c.planning i.strata, cluster(schoolid)
est sto reg4

reg lost i.treatment_status##c.planning i.strata $controls, cluster(schoolid)
est sto reg5

esttab reg1 reg2 reg3 reg4 reg5 using ///
	"attritioncluster.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	nonumbers title("Attrited at follow-up, treatment and controls \label{attritioncluster}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	addnotes("Errors are clustered at the school level." ) longtable label

	
foreach v of global outcomes {
	local l`v' : variable label `v'
	di `v'
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

reg lost i.treatment_status##c.planning i.strata
est sto reg4

reg lost i.treatment_status##c.planning i.strata $controls
est sto reg5

esttab reg1 reg2 reg3 reg4 reg5 using ///
	"attritionschools.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
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
matrix rownames obs = `" "Baseline"   "Participants in the intervention" "Fraction of Baseline"  "Follow-up" "Fraction of Baseline" "'

outtable  using attrition, mat(obs) nobox replace caption("Number of observations by treatment arm and round \label{attrition}")

