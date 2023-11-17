clear all

set more off

use "$main\Data\output\analysis\guinea_final_dataset.dta", replace

cd "$main/latex/tables"

tsset id_number time 

duplicates tag id_number, generate(duplic)

destring schoolid_str, gen(schoolid)

gen lost = duplic == 0

gen no_italy = italy_awareness == 5
gen no_spain = spain_awareness == 5
gen no_ceuta = ceuta_awareness == 5

gen sensibilized = participation != 0

local change 10400

********************************************************************************
//,\\'// 	     	A -  CLEANING of the covariates    	 			'//,\\'
********************************************************************************

*keeping the baseline data
keep if time==0


gen sec3_42_corrected = sec3_42
replace sec3_42_corrected = sec3_42_corrected*1000000 if sec3_42_corrected < 999
replace sec3_42_corrected = sec3_42_corrected*1000 if sec3_42_corrected < 999999
replace sec3_42_corrected = sec3_42_corrected/`change'
gen logsec3_42_corrected = log(1 + sec3_42_corrected)

*classmates migration
		rename sec9_q2 mig_classmates

*outside contact no
		*replace outside_contact_no=. if outside_contact_no>100 


// MAIN OUTCOMES
*migration desire
		rename sec2_q1 mig_des
		replace mig_des=0 if mig_des==2

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
replace italy_sent_back=. if italy_sent_back>100



replace outside_contact_no=. if outside_contact_no>1000

replace expectation_wage=expectation_wage/`change'
gen logexpectation_wage = log(1 + expectation_wage)

global winsor = "italy_duration spain_duration italy_journey_cost spain_journey_cost"
	
foreach y in $winsor {
	gen `y'_winsor = `y'
	qui sum `y', detail
	replace `y'_winsor = `r(p5)' if `y'_winsor < `r(p5)'
	replace `y'_winsor = `r(p95)' if `y'_winsor > `r(p95)'
	gen log`y'_winsor = log(1 + `y'_winsor)
}
	
*log wage
gen log_wage=log(expectation_wage+1)

*family revenue
rename sec8_q6 family_revenue

gen 	duration=.
replace duration=(italy_duration+spain_duration)/2

gen 	beaten=.
replace beaten=(italy_beaten+spain_beaten)/2

gen 	journey_cost=.
replace journey_cost=(spain_journey_cost+italy_journey_cost)/(2*`change')

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


** labeling
label var mig_des "Wishing to migrate (\%)"
label var mig_plan "Planning to migrate (\%)"
label var mig_prep "Preparing their migration (\%)"

label var italy_beaten "Prob. of being beaten (Italy)"
label var spain_beaten "Prob. of being beaten (Spain)"
label var logitaly_journey_cost_winsor "Log journey cost (wins. at $5^{th}$ perc.) (Italy)"
label var logspain_journey_cost_winsor "Log journey cost (wins. at $5^{th}$ perc.) (Spain)"
label var logitaly_duration_winsor "Log month duration (wins. at $5^{th}$ perc.) (Italy)"
label var logspain_duration_winsor "Log month duration (wins. at $5^{th}$ perc.) (Spain)"
label var italy_die_boat "Prob. of dying during trip by boat (Italy)"
label var spain_die_boat "Prob. of dying during trip by boat (Spain)"
label var italy_die_bef_boat "Prob. to die before trip by boat (Italy)"
label var spain_die_bef_boat "Prob. to die before trip by boat (Spain)"
label var italy_forced_work "Prob. of being forced to work (Italy)"
label var spain_forced_work "Prob. of being forced to work (Spain)"
label var italy_kidnapped "Prob. of being kidnapped (Italy)"
label var spain_kidnapped "Prob. of being kidnapped (Spain)"
label var italy_sent_back "Prob. of being sent back  (Italy)"
label var spain_sent_back "Prob. of being sent back (Spain)"

label var logexpectation_wage "Log expected wage (winsorized at $5^{th}$ perc.)"
label var employed "Prob. of finding a job"
label var asylum "Prob. of obtaining asylum, if requested"
label var studies "Prob. of continuing studies"
label var fav_mig "Perc. in favor of migration at dest."
label var sec3_39 "Prob. that the governement gives financial help"
label var sec3_36 "Prob. of becoming a citizen"
label var sec3_37 "Prob. of having returned after 5 years"
label var logsec3_42_corrected "Log expected cost of living (winsorized at $5^{th}$ perc.)"


replace mig_des = mig_des*100
replace mig_plan = mig_plan*100
replace mig_prep = mig_prep*100

global av_var = " mig_des " ///
	+ " mig_plan " ///
	+ " mig_prep  " ///
	+ " italy_beaten " ///
	+ " spain_beaten  " ///
	+ " logitaly_journey_cost_winsor " ///
	+ " logspain_journey_cost_winsor " ///
	+ " logitaly_duration_winsor " ///
	+ " logspain_duration_winsor " ///
	+ " italy_die_boat " ///
	+ " spain_die_boat " ///
	+ " italy_die_bef_boat " ///
	+ " spain_die_bef_boat " ///
	+ " italy_forced_work " ///
	+ " spain_forced_work " ///
	+ " italy_kidnapped  " ///
	+ " spain_kidnapped  " ///
	+ " italy_sent_back " ///
	+ " spain_sent_back " ///
	+ " logexpectation_wage " ///
	+ " employed " ///
	+ " asylum " ///
	+ " studies " ///
	+ " fav_mig " ///
	+ " sec3_39 " ///
	+ " sec3_36 " ///
	+ " sec3_37 " ///
	+ " logsec3_42_corrected  "




eststo averages: quietly estpost summarize $av_var, detail

esttab averages using averages.tex, title(Summary statistics for outcomes at baseline \label{summarybaseline}) cells("mean(pattern(1 1 0) fmt(0)) min(pattern(1 1 0) fmt(0)) p50(pattern(1 1 0) fmt(0)) max(pattern(1 1 0) fmt(0)) count(pattern(1 1 0) fmt(0))") label replace nonumbers
