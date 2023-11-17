clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"
*global main "/home/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"

use ${main}/Data/output/followup2/BME_final.dta
*use "/home/giacomobattiston/Downloads/BME_final.dta"

global logs ${main}/logfiles/
global dta ${main}/Data/dta/

cd "${main}/Draft/tables"

tsset id_number time


global mainvars  "i.treatment_status i.strata" 
local demographics "grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win"
local school_char  "fees50 ratio_female_lycee rstudteach rstudclass" 

local demographics_red "female fath_school moth_school fath_working moth_working sister_no_win brother_no_win grade6 grade7"
						
local n_rep 1000
local makefwer 1


* questo molto interessante
*reg f.discuss_mig  strata grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win fees50 ratio_female_lycee rstudteach rstudclass i.treatment_status##c.inter_daily if attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)

/*
local risk_outcomes italy_beaten spain_beaten italy_forced_work spain_forced_work italy_kidnapped spain_kidnapped italy_die_bef_boat spain_die_bef_boat italy_die_boat spain_die_boat italy_sent_back spain_sent_back 
	
	
* DESCRIPTIVE STATS MIGRATION	
sum  discuss_mig mig_classmates contacts_winsor discuss_wage_contact1 discuss_job_contact1 discuss_benef_contact1 discuss_trip_contact1 discuss_fins_contact1 discuss_wage_contact2 discuss_job_contact2 discuss_benef_contact2 discuss_trip_contact2 discuss_fins_contact2 if time == 0

*Table done by Lucia for the presentation
tab sec2_q11 if time==0
tab italy_awareness if time==0
tab spain_awareness if time==0

*Misinformation - alcune delle domande non le so neanche io!!
tab sec5_q2 if time==0



* GRAPH BELIEFS
m: obs = J(12,5,.)
			
local n 1
local k 1

foreach var in `risk_outcomes' {
	sum `var' if attended_tr != . & time == 0

	m: obs[`n',1] = `r(mean)'
	m: obs[`n',2] = `r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)')
	m: obs[`n',3] = `r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)')
	if (mod(`n', 2) == 1) {
		local k = `k' + 1
	}
	m: obs[`n',4] = `n' + `k' -2
	m: obs[`n',5] = mod(`n', 2)
				
	local n = `n' + 1
}


mata: st_matrix("obs", obs)


preserve
svmat obs

* set x-axis name for bar-plot.
*la var obs4 "Week"
* set y-axis name for bar-plot.
*la var obs1 "Estimate"
* set overall look of graph.
set scheme s2mono
* create bar-plot.


label values obs4 groups
		
* replace last bar with 0.001 otherwise it does not plot anything (it's a zero)
* this does not change the visualization
*replace obs1 = 0.001 if obs4 == 9

*label define groups 2 "Illegal" 9 "Forced Work" 12 "any" 

twoway (bar obs1 obs4 if obs5 == 0, ///
	barw(1) fi(inten30) fc(red) lc(red) lw(medium)  ) ///
	(bar obs1 obs4 if obs5 == 1, ///
	barw(1) fi(inten30) fc(blue) lc(blue) lw(medium)  ) ///
	(rcap obs3 obs2 obs4 if obs5 == 0 , lc(gs5)) 	 ///
 	(rcap obs3 obs2 obs4 if obs5 == 1  , lc(gs5)) 	, ///
	aspect(0.35)  xtitle("" ) graphregion(color(white)) ///
	yla(0(10)60, ) ///
	legend(row(1) order(1 "Libyan-Italian route" 2 "Spanish-Moroccan route" )) ///
	xlabel( 1.5 "Beaten" 4.5 "Forced work" 7.5 "Kidnapped" 10.5 "Death bef. boat" 13.5 "Death boat" 16.5 "Sent back", angle(45)) ///
	ytitle(Perceived probability, ) xtitle("" ) 

* Export graphs and latex file so as to adapt font.
graph save ${main}/Draft/figures/beliefsrisk.png, replace
graph export ${main}/Draft/figures/beliefsrisk.png, as(png) replace
* Restore main dataset.

restore


* GRAPH MIGRANTS OVER TIME CENTRAL MEDITERRANEAN
*https://frontex.europa.eu/we-know/migratory-routes/central-mediterranean-route/
preserve
use ${main}/Data/dta/migrantscentralmed.dta, clear

tsset year
replace migrants = migrants/1000

* Plot weighted avg. distance over time.
tsline migrants, graphregion(color(white)) color(black)  ///
	xtitle(Year) ///
	ytitle("Migrants through the Central Med. Route (1000s)") ///
	ylab(, nogrid) xlab(2008(1)2017, )
	
* Export graphs and latex file so as to adapt font.
graph export ${main}/Draft/figures/migrantscm.png, as(png) replace

drop if year == 2018	
tsset year
* Plot weighted avg. distance over time.
tsline migrants if year, graphregion(color(white)) color(black)  ///
	xtitle(Year) ///
	ytitle("Migrants through the Central Med. Route (1000s)") ///
	ylab(, nogrid) xlab(2008(1)2017, )
	
* Export graphs and latex file so as to adapt font.
graph export ${main}/Draft/figures/migrantscm_no2018.png, as(png) replace
restore



* GRAPH MIGRANTS OVER TIME ALL ROUTES
preserve
use ${main}/Data/dta/frontexroutes.dta, clear

replace migrants = migrants/1000
xtset route year 

drop if year == 2018	

* Plot migrants on routes over time excluding other and black sea, WA, EB, CR
twoway (tsline migrants if route == 2,  color(red) graphregion(color(white)) ytitle("Migrants detected by route (1000s)") xtitle(Year) xlab(2009(1)2017, ) lp(solid))  ///
	(tsline migrants if route == 5,  color(green) graphregion(color(white)) lp(solid))  ///
	(tsline migrants if route == 9,  color(black) graphregion(color(white)) lp(solid))  ///
	(tsline migrants if route == 8,  color(blue) graphregion(color(white)) lp(solid)),  ///
	legend(row(2) order(1 "Central Med" 2 "Eastern Med" 3 "Western Med" 4 "Western Balkan" )) 

* Export graphs and latex file so as to adapt font.
graph export ${main}/Draft/figures/migrantsallroutes.png, as(png) replace

collapse (sum) migrants, by(year)

tsline migrants ,  graphregion(color(white)) ytitle("Irregular migrants detected (1000s)") xtitle(Year) xlab(2009(1)2017, ) lp(solid)

* Export graphs and latex file so as to adapt font.
graph export ${main}/Draft/figures/migrantsallroutespooled.png, as(png) replace

restore



*MAPS

*ssc install spmap
*ssc install shp2dta
*ssc install mif2dta
*ssc install kountry

*use ${dta}worldcoor.dta, clear
*drop if _ID == 44 & _X <-40
*save ${dta}worldcoor_noguyana.dta, replace

****COUNTRY IN
preserve
rename _merge _merge13
keep if migration_guinea == 1
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/figures/mapmigration.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration.gph", replace
restore


****COUNTRY IN (irr. migration)
preserve
rename _merge _merge13
keep if migration_novisa == 1
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/figures/mapmigration_novisa.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration_novisa.gph", replace
restore

****COUNTRY IN (control)
preserve
rename _merge _merge13
keep if migration_guinea == 1 & treatment_status ==1 
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/figures/mapmigration_control.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration_control.gph", replace
restore


****COUNTRY IN (treatment)
preserve
rename _merge _merge13
keep if migration_guinea == 1 & (treatment_status == 2  | treatment_status == 3  | treatment_status == 4 )
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/figures/mapmigration_treatment.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration_treatment.gph", replace
restore



****COUNTRY IN (control, weighted)
preserve
rename _merge _merge13
count if treatment_status == 1 & time == 0
local num `r(N)'
keep if migration_guinea == 1 & treatment_status ==1 
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
replace counting = counting/`num'
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/figures/mapmigration_control_weighted.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration_control_weighted.gph", replace
restore


****COUNTRY IN (treatment,weighted)
preserve
rename _merge _merge13
count if (treatment_status == 2  | treatment_status == 3  | treatment_status == 4 ) & time == 0
local num `r(N)'
keep if migration_guinea == 1 & (treatment_status == 2  | treatment_status == 3  | treatment_status == 4 )
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
replace counting = counting/`num'
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/figures/mapmigration_treatment_weighted.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration_treatment_weighted.gph", replace
restore



*
diff_asinh_duration_winsor diff_asinh_journey_cost_winsor diff_beaten diff_forced_work diff_kidnapped  diff_die_bef_boat diff_die_boat diff_sent_back

c.diff_asinh_duration_winsor##i.durables50 c.diff_asinh_journey_cost_winsor##i.durables50 c.diff_beaten##i.durables50 c.diff_forced_work##i.durables50 c.diff_kidnapped##i.durables50  c.diff_die_bef_boat##i.durables50 c.diff_die_boat##i.durables50 c.diff_sent_back##i.durables50

c.diff_asinh_duration_winsor##i.treatment_status c.diff_asinh_journey_cost_winsor##i.treatment_status c.diff_beaten##i.treatment_status c.diff_forced_work##i.treatment_status c.diff_kidnapped##i.treatment_status  c.diff_die_bef_boat##i.treatment_status c.diff_die_boat##i.treatment_status c.diff_sent_back##i.treatment_status


ivreg2 f.d.route_chosen c.d.diff_asinh_duration_winsor##i.treatment_status c.d.diff_asinh_journey_cost_winsor##i.treatment_status c.d.diff_beaten##i.treatment_status c.d.diff_forced_work##i.treatment_status c.d.diff_kidnapped##i.treatment_status  c.d.diff_die_bef_boat##i.treatment_status c.d.diff_die_boat##i.treatment_status c.d.diff_sent_back##i.treatment_status  , cluster(schoolid)


global risk_outcomes = " _duration_winsor " ///
							+ " _journey_cost_winsor  " ///
							+ " _beaten " ///
							+ " _forced_work " ///
							+ " _kidnapped " ///
							+ " _die_bef_boat " ///
							+ " _die_boat " ///
							+ " _sent_back "
							

gen desired_fra = desired_country == 11
gen desired_ita = desired_country == 16
gen desired_spa = desired_country == 10

reg f2.migration_guinea f.sell_asset if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)

reg f.sec10_q15_1  sec10_q15_1 i.treatment_status strata if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)

							
*reg prepare italy_index spain_index economic_index grade6 grade7 where_born2 where_born3 where_born4 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win fees50 ratio_female_lycee rstudteach rstudclass if time == 0

*twoway (lfit f1economic_index economic_index if treatment_status == 1) (lfit f1economic_index economic_index if treatment_status == 2) (lfit f1economic_index economic_index if treatment_status == 3) (lfit f1economic_index economic_index if treatment_status == 4)  

twoway (lfit f1italy_index italy_index if treatment_status == 1) (lfit f1italy_index italy_index if treatment_status == 2) (lfit f1italy_index italy_index if treatment_status == 3) (lfit f1italy_index italy_index if treatment_status == 4)  


ivreg2 f.italy_index_nocost (f.expwage = i.treatment_status) strata if time == 0 & (treatment_status == 1 |treatment_status == 3), cluster(schoolid)

*/

gen migration_guinea100 = migration_guinea*100
gen migration_novisa100 = migration_novisa*100
gen migration_visa100 = migration_visa*100
gen migration_internal100 = migration_internal*100
gen desire100 = desire*100
gen planning100 = planning*100
gen prepare100 = prepare*100


/*
*MIGRATION (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		
		if `i_con' == 2 {
			local controls  `demographics'
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
		}
		
		if `i_est' == 1 {
			gen x = treated
			qui reg f2.migration_guinea100 x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_any
			qui ivreg2 f2.migration_guinea100 (x = treated) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table3a.tex, replace keep(x) ///
	coeflabels(x "Any treatment")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	noobs /// 
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot(" ") ///
	 

	
eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		test 2.x - 3.x = 0
		local pre  = string(`r(p)', "%9.2f")
		estadd local pre = `"`pre'"'

		test 2.x - 4.x = 0
		local prd = string(`r(p)', "%9.2f") 
		estadd local prd = `"`prd'"'

		test 3.x - 4.x = 0
		local ped = string(`r(p)', "%9.2f")
		estadd local ped = `"`ped'"'

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		estadd local space = "` '"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table3b.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  individual school N meandep, fmt(s s s s s s a2 s) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "' `"Individual controls"'  `"School controls"'   `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

	
*MIGRATION WITHOUT VISA (restricted sample)

eststo clear

qui sum migration_novisa100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_novisa100 i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_novisa100 (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table4a.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	posthead("\hline  \\ \textbf{\textit{(a): Migration without visa}}  & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot("\hline") ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV")  ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) 



*MIGRATION WITH VISA (restricted sample)

eststo clear

qui sum migration_visa100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_visa100 i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_visa100 (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table4b.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	prehead("") posthead("  \\ \textbf{\textit{(b): Migration with visa}}  & & &  &  &  &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") ///
	nonumbers nomtitles
	

	
*MIGRATION BY DURABLES OR BANK ACCOUNT OWNERSHIP (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {

		if `i_inter' == 1 {
			gen inter = durables50 == 0
		}
		
		if `i_inter' == 2 {
			gen inter = bank_account == 0
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		
		estadd local space " "
		
		local individual "Yes"
		local individual "Yes"		
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_inter'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using table5.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Low SES" 3.x#1.inter "\(T2\) - Econ \(*\) Low SES" 4.x#1.inter "\(T3\) - Double \(*\) Low SES" ///
	1.inter "Low SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Low SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Low SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Low SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Socioeconomic status \\ measured by durables index}   }&\multicolumn{2}{c}{\Shortstack{1em}{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers



	
*MIGRATION BY DURABLES OR BANK ACCOUNT OWNERSHIP (restricted sample), 75 percentile

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {

		if `i_inter' == 1 {
			gen inter = durables75
		}
		
		if `i_inter' == 2 {
			gen inter = bank_account
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		
		estadd local space " "
		
		local individual "Yes"
		local individual "Yes"		
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_inter'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using table5_75.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.inter "\(T1\) - Risk \(*\) High SES" 3.x#1.inter "\(T2\) - Econ \(*\) SES" 4.x#1.inter "\(T3\) - Double \(*\) SES" ///
	1.inter "High SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) High SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) High SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) High SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Socioeconomic status \\ measured by durables index}   }&\multicolumn{2}{c}{\Shortstack{1em}{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers
	
	
*MIGRATION BY DURABLES OR BANK ACCOUNT OWNERSHIP (restricted sample), mean

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {

		if `i_inter' == 1 {
			gen inter = durablesavg == 0
		}
		
		if `i_inter' == 2 {
			gen inter = bank_account == 0
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		
		estadd local space " "
		
		local individual "Yes"
		local school "Yes"		
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_inter'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using table5_mean.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Low SES" 3.x#1.inter "\(T2\) - Econ \(*\) Low SES" 4.x#1.inter "\(T3\) - Double \(*\) Low SES" ///
	1.inter "Low SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Low SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Low SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Low SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Socioeconomic status \\ measured by durables index}   }&\multicolumn{2}{c}{\Shortstack{1em}{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers


*/


/*
* MIGRANT NOT DOING WELL

sum impat, de
gen impat_median = impat > `r(p50)' if !missing(impat)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = impat_median
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tableimpat_median.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) Impatient" 3.x#1.inter "\(T2\) - Econ \(*\) Impatient" 4.x#1.inter "\(T3\) - Double \(*\) Impatient" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Impatient = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Impatient = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Impatient = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers


* TRANSPORTATION

		
forval i_est = 1/3 {
	forval i_con = 1/2 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		

		if `i_con' == 2 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		

		if `i_est' == 1 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.trans_debate i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.trans_video i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		if `i_est' == 3 {
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.ident_video i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		

		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'"'
		
		eststo reg`i_con'_`i_est'
		
		
	}
}

esttab reg* using transident.tex, replace keep(3.x 4.x) ///
coeflabels(3.x "\(T2\) - Econ" 4.x "\(T3\) - Double"  strata "Big school")   se substitute(\_ _) ///
mgroups("Trans. Debate" "Trans. Video" "Ident. Video", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



* INTERNET


qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = inter_daily
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tableinterdaily.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) Uses internet daily" 3.x#1.inter "\(T2\) - Econ \(*\) Uses internet daily" 4.x#1.inter "\(T3\) - Double \(*\) Uses internet daily" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Uses internet daily = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Uses internet daily = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Uses internet daily = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



* WORK OUTSIDE SCHOOL


gen joboutside = sec8_q3 == 1 if !missing(sec8_q3)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = joboutside
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablejob.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) Has a job" 3.x#1.inter "\(T2\) - Econ \(*\) Has a job" 4.x#1.inter "\(T3\) - Double \(*\) Has a job" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Has a job = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Has a job = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Has a job = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

stop


* CONTACT NOT DOING WELL


gen cont_notdoingwell = sec10_q18_1 > 1 if !missing(sec10_q18_1)
replace cont_notdoingwell = 1 if sec10_q18_2 > 1 &  !missing(sec10_q18_2)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = cont_notdoingwell
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecont_notdoingwell.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) Contact Over-reporting" 3.x#1.inter "\(T2\) - Econ \(*\) Contact Over-reporting" 4.x#1.inter "\(T3\) - Double \(*\) Contact Over-reporting" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contact Over-reporting = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contact Over-reporting = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contact Over-reporting = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers





* CONTACT DOING WELL

gen cont_doingwell = sec10_q19_1 > 1 if !missing(sec10_q19_1)
replace cont_doingwell = 1 if sec10_q19_2 > 1 &  !missing(sec10_q19_2)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = cont_doingwell
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecont_doingwell.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) Contact Under-reporting" 3.x#1.inter "\(T2\) - Econ \(*\) Contact Under-reporting" 4.x#1.inter "\(T3\) - Double \(*\) Contact Under-reporting" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contact Under-reporting = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contact Under-reporting = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contact Under-reporting = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers


stop


* IMPATIENCE

sum impat, de
gen impat_median = impat > `r(p50)' if !missing(impat)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = impat_median
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tableimpat_median.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) Impatient" 3.x#1.inter "\(T2\) - Econ \(*\) Impatient" 4.x#1.inter "\(T3\) - Double \(*\) Impatient" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Impatient = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Impatient = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Impatient = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers




* RISKLOVE

sum risklove, de
gen risklove_median = risklove > 0 if !missing(risklove)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = risklove_median
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablerisk_median.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) Risk-loving" 3.x#1.inter "\(T2\) - Econ \(*\) Risk-loving" 4.x#1.inter "\(T3\) - Double \(*\) Risk-loving" ///
1.inter "Risk-loving" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Risk-loving = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Risk-loving = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Risk-loving = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers




*MIGRATION BY NUMBER OF CONTACTS

eststo clear

sum contacts_winsor, detail
gen contacts_winsor_mean = contacts_winsor > `r(mean)' if contacts_winsor != .
sum contacts_winsor, detail
gen contacts_winsor_median = contacts_winsor > `r(p50)' if contacts_winsor != .
sum contacts_winsor, detail
gen contacts_winsor_p75 = contacts_winsor > `r(p75)' if contacts_winsor != .
sum contacts_winsor, detail
gen contacts_winsor_p90 = contacts_winsor > `r(p90)' if contacts_winsor != .

local interactions "contacts_winsor_mean contacts_winsor_median contacts_winsor_p75 contacts_winsor_p90"
local nvar 0



qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor_mean
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_winsor_mean.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ avg." 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ avg." 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ avg." ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ avg. = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ avg. = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ avg. = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



qui sum mrisk_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor_mean
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x i.x#i.inter i.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.mrisk_index (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if  time == 0 & f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_winsor_mean_risk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ avg." 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ avg." 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ avg." ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Risk", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ avg. = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ avg. = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ avg. = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



qui sum economic_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor_mean
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.economic_index i.x i.x#i.inter i.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.economic_index (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if  time == 0 & f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_winsor_mean_econ.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ avg." 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ avg." 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ avg." ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ avg. = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ avg. = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ avg. = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



* ANY CONTACTS ABROAD

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_abroad
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_any.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ 0" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ 0" 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ 0" ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ 0 = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ 0 = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ 0 = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



qui sum mrisk_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_abroad
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x i.x#i.inter i.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.mrisk_index (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if  time == 0 & f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_any_risk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ 0" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ 0" 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ 0" ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Risk", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ 0 = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ 0 = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ 0 = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers


qui sum economic_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_abroad
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.economic_index i.x i.x#i.inter i.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.economic_index (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if time == 0 &  f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_any_econ.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ 0" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ 0" 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ 0" ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ 0 = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ 0 = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ 0 = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



* N CONTACTS ABROAD

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#c.inter c.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#c.inter = i.treatment_status i.treatment_status#c.inter) ///
				c.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
	
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_n.tex, replace keep(2.x 3.x 4.x 2.x#c.inter 3.x#c.inter 4.x#c.inter inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad " 4.x#c.inter "\(T3\) - Double \(*\) \# contacts abroad " ///
inter "\# contacts abroad" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats( space individual school N meandep, fmt( s s s 0 3) ///
layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



qui sum mrisk_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x i.x#c.inter c.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.mrisk_index (i.x i.x#c.inter = i.treatment_status i.treatment_status#c.inter) ///
				c.inter strata `controls' if  time == 0 & f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_n_risk.tex, replace keep(2.x 3.x 4.x 2.x#c.inter 3.x#c.inter 4.x#c.inter inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad " 4.x#c.inter "\(T3\) - Double \(*\) \# contacts abroad " ///
inter "\# contacts abroad" strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Risk", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats( space individual school N meandep, fmt( s s s 0 3) ///
layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers


qui sum economic_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.economic_index i.x i.x#c.inter c.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.economic_index (i.x i.x#c.inter = i.treatment_status i.treatment_status#c.inter) ///
				c.inter strata `controls' if time == 0 &  f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
				
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_n_econ.tex, replace keep(2.x 3.x 4.x 2.x#c.inter 3.x#c.inter 4.x#c.inter inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad " 4.x#c.inter "\(T3\) - Double \(*\) \# contacts abroad " ///
inter "\# contacts abroad" strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats( space individual school N meandep, fmt( s s s 0 3) ///
layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



* CONTACTS ABOVE MEDIAN

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor_median
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_median.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ median" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ median " 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ median" ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ median = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ median = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ median = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers


qui sum mrisk_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor_median
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x i.x#i.inter i.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.mrisk_index (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if  time == 0 & f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_median_risk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ median" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ median " 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ median" ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Risk", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ median = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ median = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ median = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

qui sum economic_index if time == 0  &  f2.source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor_median
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.economic_index i.x i.x#i.inter i.inter  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.economic_index (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
				i.inter strata `controls' if time == 0 &  f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using tablecontacts_median_econ.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ median" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ median " 4.x#1.inter "\(T3\) - Double \(*\) \# contacts abroad $>$ median" ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ median = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ median = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ median = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#c.inter c.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#c.inter = i.treatment_status i.treatment_status#c.inter) ///
				c.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}
	
esttab reg* using tablecontacts.tex, replace keep(2.x 3.x 4.x 2.x#c.inter 3.x#c.inter 4.x#c.inter inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad" 4.x#c.inter "\(T3\) - Double \(*\) \# contacts abroad" ///
	inter "\# contacts abroad" strata "Big school")   se substitute(\_ _) ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	stats(individual school N meandep, fmt( s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" )  ///
	labels(  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular} }") 	nonumbers


	
qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {

		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		
		gen inter = contacts_winsor
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#c.inter c.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#c.inter = i.treatment_status i.treatment_status#c.inter) ///
				c.inter strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter

		
	}
}
	
esttab reg* using tablecontacts.tex, replace keep(2.x 3.x 4.x 2.x#c.inter 3.x#c.inter 4.x#c.inter inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad" 4.x#c.inter "\(T3\) - Double \(*\) \# contacts abroad" ///
	inter "\# contacts abroad" strata "Big school")   se substitute(\_ _) ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	stats(individual school N meandep, fmt( s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" )  ///
	labels(  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular} }") 	nonumbers




*SUM STATS TALKING ABOUT MIGRATION
estpost tabstat contacts_abroad discuss_risk_contact discuss_econ_contact ///
	discuss_riskecon_contact  if time == 0 , stat(mean sd min p50  max n) col(stat) 
*esttab, cells("mean sd p25 p50  p75 count") label
matrix summary = e(mean)', e(count)'

esttab using desstats_discussing.tex, cells("mean(fmt(%9.3g) label(Mean)) count(fmt(%9.0g) label(N))") label noobs nonumber replace 

/*
\multicolumn{7}{l}{} \\
\multicolumn{7}{l}{\emph{\textbf{Main outcomes:}}} \\
[1em]
\multicolumn{7}{l}{} \\
\multicolumn{7}{l}{\emph{\textbf{Individual controls:}}} \\
[1em]
\multicolumn{7}{l}{} \\
\multicolumn{7}{l}{\emph{\textbf{School controls:}}} \\
[1em]
*/

*PREDICTORS OF TOPIC COVERED WITH CONTACTS ABROAD

eststo clear
	
forval i_est = 1/3 {
	forval i_con = 1/2 {
		
		
		if `i_con' == 1 {
			local controls prepare mrisk_index economic_index 
		}
		
		if `i_con' == 2 {
			local controls  prepare mrisk_index economic_index  `demographics_red' `school_char' strata
		}
				
		if `i_est' == 1 {
			gen y = discuss_risk_contact
		}
		
		if `i_est' == 2 {
			gen y = discuss_econ_contact
		}
		
		if `i_est' == 3 {
			gen y = discuss_riskecon_contact
		}
		
		qui sum y if time == 0  &  f2.source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg y `controls' ///
			if time == 0 & f2.source_info_guinea < 6  & attended_tr != ., 
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		
		estadd local meandep = `"`meandep'\%"'

		eststo reg`i_est'_`i_con'

		drop y
		
	}
}



esttab reg* using table_topic.tex, replace    se substitute(\_ _) ///
			label nomtitles ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = has contacts abroad \& discussess migration w/ them} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Discusses \\ Risk}   }&\multicolumn{2}{c}{\Shortstack{1em}{Discusses \\ Econ}} &\multicolumn{2}{c}{\Shortstack{1em}{Discuess \\ Both}}  \\ ") nonumbers 
	
	




*MIGRATION BY TOPIC COVERED WITH CONTACTS ABROAD

eststo clear
	
forval i_est = 1/3 {
	forval i_con = 1/2 {
		
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
				
		if `i_est' == 1 {
			gen inter = discuss_risk_contact
		}
		
		if `i_est' == 2 {
			gen inter = discuss_econ_contact
		}
		
		if `i_est' == 3 {
			gen inter = discuss_riskecon_contact
		}
		
		qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		gen x = treatment_status
		qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter  strata `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x
		

		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		
		estadd local meandep = `"`meandep'\%"'

		eststo reg`i_est'_`i_con'

		drop inter
		
	}
}



esttab reg* using table_topic_migr.tex, replace  keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Discusses w/ cont. abroad" 3.x#1.inter "\(T2\) - Econ \(*\) Discusses w/ cont. abroad" 4.x#1.inter "\(T3\) - Double \(*\) Discusses w/ cont. abroad" ///
	1.inter "Discusses w/ cont. abroad" strata "Big school")   se substitute(\_ _) ///
			nomtitles ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Discusses w/ cont. abroad = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Discusses w/ cont. abroad = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Discusses w/ cont. abroad = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = migration from Guinea} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Discusses \\ Risk}   }&\multicolumn{2}{c}{\Shortstack{1em}{Discusses \\ Econ}} &\multicolumn{2}{c}{\Shortstack{1em}{Discuess \\ Both}}  \\ ") nonumbers 
	
	
	
	

*RISK BELIEFS BY TOPIC COVERED WITH CONTACTS ABROAD

eststo clear
	
forval i_est = 1/3 {
	forval i_con = 1/2 {
		
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
				
		if `i_est' == 1 {
			gen inter = discuss_risk_contact
		}
		
		if `i_est' == 2 {
			gen inter = discuss_econ_contact
		}
		
		if `i_est' == 3 {
			gen inter = discuss_riskecon_contact
		}
		
		qui sum mrisk_index if time == 0  &  f2.source_info_guinea < 6  & attended_tr != .
		local meandep = `r(mean)'

		gen x = treatment_status
		qui reg f.mrisk_index i.x i.x#i.inter i.inter  strata `controls' ///
			if time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x
		

		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		
		estadd local meandep = `"`meandep'"'

		eststo reg`i_est'_`i_con'

		drop inter
		
	}
}



esttab reg* using table_topic_risk.tex, replace  keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Discusses w/ cont. abroad" 3.x#1.inter "\(T2\) - Econ \(*\) Discusses w/ cont. abroad" 4.x#1.inter "\(T3\) - Double \(*\) Discusses w/ cont. abroad" ///
	1.inter "Discusses w/ cont. abroad" strata "Big school")   se substitute(\_ _) ///
					nomtitles ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Discusses w/ cont. abroad = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Discusses w/ cont. abroad = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Discusses w/ cont. abroad = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = PCA Risk} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Discusses \\ Risk}   }&\multicolumn{2}{c}{\Shortstack{1em}{Discusses \\ Econ}} &\multicolumn{2}{c}{\Shortstack{1em}{Discuess \\ Both}}  \\ ") nonumbers 
	
	
	
	
*ECON BELIEFS BY TOPIC COVERED WITH CONTACTS ABROAD

eststo clear
	
forval i_est = 1/3 {
	forval i_con = 1/2 {
		
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
				
		if `i_est' == 1 {
			gen inter = discuss_risk_contact
		}
		
		if `i_est' == 2 {
			gen inter = discuss_econ_contact
		}
		
		if `i_est' == 3 {
			gen inter = discuss_riskecon_contact
		}
		
		qui sum economic_index if time == 0  &  f2.source_info_guinea < 6  & attended_tr != .
		local meandep = `r(mean)'

		gen x = treatment_status
		qui reg f.economic_index i.x i.x#i.inter i.inter  strata `controls' ///
			if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x
		

		lincom 2.x + 2.x#1.inter
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.inter
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.inter
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		
		estadd local meandep = `"`meandep'"'

		eststo reg`i_est'_`i_con'

		drop inter
		
	}
}



esttab reg* using table_topic_econ.tex, replace  keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Discusses w/ cont. abroad" 3.x#1.inter "\(T2\) - Econ \(*\) Discusses w/ cont. abroad" 4.x#1.inter "\(T3\) - Double \(*\) Discusses w/ cont. abroad" ///
	1.inter "Discusses w/ cont. abroad" strata "Big school")   se substitute(\_ _) ///
					nomtitles ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Discusses w/ cont. abroad = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Discusses w/ cont. abroad = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Discusses w/ cont. abroad = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = PCA Econ} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Discusses \\ Risk}   }&\multicolumn{2}{c}{\Shortstack{1em}{Discusses \\ Econ}} &\multicolumn{2}{c}{\Shortstack{1em}{Discuess \\ Both}}  \\ ") nonumbers 
	


*INTERNAL MIGRATION (restricted sample)

eststo clear

qui sum migration_internal100 if l2.treatment_status == 1  &  source_info_guinea < 6 & source_info_conakry < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_internal100 i.x strata `controls' ///
				if f2.source_info_guinea < 6 & f2.source_info_conakry < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_internal100 (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table7.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = internal migration", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")


	
*MIGRATION BY OPTIMISTIC BELIEFS (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.optimistic i.italy_optimistic i.econ_optimistic  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.optimistic = i.treatment_status i.treatment_status#i.optimistic) ///
				i.italy_optimistic i.econ_optimistic strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.optimistic
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.optimistic
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.optimistic
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table8.tex, replace  keep(2.x 3.x 4.x 2.x#1.optimistic 3.x#1.optimistic 4.x#1.optimistic 1.italy_optimistic 1.econ_optimistic) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.optimistic "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic "\(T3\) - Double \(*\) Und. risk or over. econ" ///
	1.italy_optimistic "Underestimates risk" 1.econ_optimistic "Overestimates econ" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Underestimates risk = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Overestimates econ = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Und. risk or over. econ = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")
	
	
	

*MIGRATION BY OPTIMISTIC BELIEFS (1) (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.optimistic1 i.italy_optimistic1 i.econ_optimistic1  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.optimistic1 = i.treatment_status i.treatment_status#i.optimistic1) ///
				i.italy_optimistic1 i.econ_optimistic1 strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.optimistic1
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.optimistic1
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.optimistic1
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table8_1.tex, replace  keep(2.x 3.x 4.x 2.x#1.optimistic1 3.x#1.optimistic1 4.x#1.optimistic1 1.italy_optimistic1 1.econ_optimistic1) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.optimistic1 "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic1 "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic1 "\(T3\) - Double \(*\) Und. risk or over. econ" ///
	1.italy_optimistic1 "Underestimates risk" 1.econ_optimistic1 "Overestimates econ" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Underestimates risk = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Overestimates econ = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Und. risk or over. econ = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")
	
	

*MIGRATION BY OPTIMISTIC BELIEFS (3) (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.optimistic3 i.italy_optimistic3 i.econ_optimistic3  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.optimistic3 = i.treatment_status i.treatment_status#i.optimistic3) ///
				i.italy_optimistic3 i.econ_optimistic3 strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.optimistic3
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.optimistic3
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.optimistic3
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table8_3.tex, replace  keep(2.x 3.x 4.x 2.x#1.optimistic3 3.x#1.optimistic3 4.x#1.optimistic3 1.italy_optimistic3 1.econ_optimistic3) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.optimistic3 "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic3 "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic3 "\(T3\) - Double \(*\) Und. risk or over. econ" ///
	1.italy_optimistic3 "Underestimates risk" 1.econ_optimistic3 "Overestimates econ" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Underestimates risk = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Overestimates econ = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Und. risk or over. econ = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	
*MIGRATION

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		

forval i_con = 1/3 {
	
	if `i_con' == 1 {
		local controls ""
		local individual "No"
		local school "No"
	}
	
	if `i_con' == 2 {
		local controls  `demographics'
		local individual "Yes"
		local school "No"
	}
	if `i_con' == 3 {
		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
	}
	

	gen x = treatment_status
	qui reg f2.migration_guinea100 i.x strata `controls' ///
		if f2.source_info_guinea < 6, cluster(schoolid)
	drop x

	
	estadd local individual = "`individual'"
	estadd local school = "`school'"
	
	local meandep = string(`meandep', "%9.2f")
	estadd local meandep = `"`meandep'\%"'
	
	eststo reg`i_est'_`i_con'

	
}


esttab reg* using apptable7.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT") ///
	mgroups("y = migration from Guinea", pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")


	
		
*MIGRATION INTENTIONS FU1 (restricted sample)


eststo clear
		
local outcomes "desire100 planning100 prepare100"
foreach var of varlist `outcomes' {
	forval i_con = 1/3 {
		
		if `i_con' == 2 {
			local controls  `demographics'
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
		}
		
		gen x = treated
		gen y = `var'
		qui reg f1.y x strata `controls'  y ///
			if time == 0 & attended_tr != ., cluster(schoolid)
		
		drop x
		drop y
					
		eststo reg`var'_`i_con'

		
	}
}

esttab reg* using apptable9a.tex, replace keep(x) ///
	coeflabels(x "Any treatment")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	prehead("{ \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{9}{c}} \hline\hline  &\multicolumn{9}{c}{y = intending to migrate from Guinea} \\            &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}&\multicolumn{1}{c}{(8)}&\multicolumn{1}{c}{(9)} \\ \cmidrule(lr){2-10} &    \multicolumn{3}{c}{  \Shortstack{1em}{Wishing to migrate}}&\multicolumn{3}{c}{\Shortstack{1em}{Planning to migrate}}&\multicolumn{3}{c}{\Shortstack{1em}{Preparing to migrate}}  \\  \cmidrule(lr){2-4} \cmidrule(lr){5-7} \cmidrule(lr){8-10}")  ///
	nonumbers   noobs /// 
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  & & & &  \\ [1em]") prefoot("\hline") postfoot(" ")  


eststo clear


local outcomes "desire100 planning100 prepare100"
foreach var of varlist `outcomes' {
	qui sum `var' if treatment_status == 1  & time == 2
	local meandep = `r(mean)'
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		gen x = treatment_status
		gen y = `var'
		qui reg f1.y i.x strata `controls'  y ///
			if time == 0 & attended_tr != ., cluster(schoolid)
		
		test 2.x - 3.x = 0
		local pre  = string(`r(p)', "%9.2f")
		estadd local pre = `"`pre'"'

		test 2.x - 4.x = 0
		local prd = string(`r(p)', "%9.2f") 
		estadd local prd = `"`prd'"'

		test 3.x - 4.x = 0
		local ped = string(`r(p)', "%9.2f")
		estadd local ped = `"`ped'"'

		drop x
		drop y
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		estadd local space = "` '"
				
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`var'_`i_con'

		
	}
}

esttab reg* using apptable9b.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	y "Intends to migrate" strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  N meandep, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 


global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
	
	gen x = treatment_status
	gen y = `y'
	eststo: reg f1.y i.x strata `demographics' `school_char'  y ///
			if time == 0 & attended_tr != ., cluster(schoolid)
	
	local n_treat=1
	
	foreach X in i2.x i3.x i4.x  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	

	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop x y
	
	

	
}


preserve

clear
svmat R

replace R1 = R1*100
replace R2 = R2*100
replace R3 = R3*100

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/9, valuelabel) 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
	ylabel(-9(2)3) ///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	text(3 2 "Risk") text(3 5 "Econ") text(3 8 "Double")
	 
graph save Graph ${main}/Draft/figures/figure19.gph, replace
graph export ${main}/Draft/figures/figure19.png, replace

restore

eststo clear



*LYBIAN ROUTE CHOSEN (restricted sample)

eststo clear

forval i_time = 1/2 {
	qui sum route_chosen if l`i_time'.treatment_status == 1 & time == `i_time'
	local meandep = `r(mean)'
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		gen x = treatment_status
		qui reg f`i_time'.route_chosen i.x  strata `controls' ///
			if attended_tr != . & time == 0, cluster(schoolid)
		drop x

		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_time'_`i_con'

		
	}
}

esttab reg* using apptable11.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	strata "Big school")   se substitute(\_ _) ///
	mtitles("\(1^{st}\) F.U." "\(1^{st}\) F.U." "\(1^{st}\) F.U." "\(2^{nd}\) F.U." "\(2^{nd}\) F.U." "\(2^{nd}\) F.U.") ///
	mgroups("y = Lybian Route Chosen", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")	
	
	
*MIGRATION BY OPTIMISTIC BELIEFS STRONG (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.optimistic_strong i.italy_optimistic i.econ_optimistic  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.optimistic_strong = i.treatment_status i.treatment_status#i.optimistic_strong) ///
				i.italy_optimistic i.econ_optimistic strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.optimistic_strong
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.optimistic_strong
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.optimistic_strong
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'

		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using apptable12.tex, replace keep(2.x 3.x 4.x 2.x#1.optimistic_strong 3.x#1.optimistic_strong 4.x#1.optimistic_strong 1.italy_optimistic 1.econ_optimistic) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.optimistic_strong "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic_strong "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic_strong "\(T3\) - Double \(*\) Und. risk \& over. econ" ///
	1.italy_optimistic "Underestimates risk" 1.econ_optimistic "Overestimates econ" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Underestimates risk = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Overestimates econ = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Und. risk \& over. econ = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")
	

*MIGRATION (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6 & !missing(l1.time) 
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local school "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & !missing(f1.time) , cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & !missing(f1.time) , cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
			
		eststo reg`i_est'_`i_con'

		
	}
}


esttab reg* using apptable13.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	
drop migration_guinea100 migration_visa100 migration_novisa100 desire100 planning100 prepare100




global economic_titles = `" " \Shortstack{1em}{(1)\\ Finding \\ Job \\ \vphantom{foo}} " "' ///
			+ `" "\Shortstack{1em}{(2)\\ Wage \\ abroad \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(3)\\ Contin. \\ studies \\ abroad}" "' ///
			+ `" "\Shortstack{1em}{(4) \\ Getting \\ asylum \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(5)\\ Becom. \\ Citizen \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(6)\\ Return \\ before \\ 5 yrs}" "' ///
			+ `" "\Shortstack{1em}{(7)\\ Getting \\ public \\ transf. }""' ///
			+ `" "\Shortstack{1em}{(8) \\  Cost of \\ living \\ abroad}" "' ///
			+ `" "\Shortstack{1em}{(9) \\ Host \\ country \\ attit.}" "' ///
			+ `" "\Shortstack{1em}{(10) \\ PCA \\ Econ \\ Index}" "' 
											
								
global appendix_table_titles =  `" "\Shortstack{1em}{(1) \\ Kling \\ Cost- \\ Ita }" "'  ///
								+ `" "\Shortstack{1em}{(2) \\ Kling \\ Cost+ \\ Ita }" "' ///
								+ `" "\Shortstack{1em}{(3) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\Shortstack{1em}{(4) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\Shortstack{1em}{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				
			

global risks_table_titles = `" " \Shortstack{1em}{(1) \\ Journey \\ Duration \\ \vphantom{foo}}" "' ///
				+ `" " \Shortstack{1em}{(2)\\ Being \\ Beaten \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(3)\\ Forced \\  to \\ Work}" "' /// 
				+ `" " \Shortstack{1em}{(4) \\ Journey\\ Cost \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(5) \\ Being \\ Kidnap- \\ ped}" "' ///
				+ `" "\Shortstack{1em}{(6)\\ Death \\ before \\ boat}" "' ///
				+ `" "\Shortstack{1em}{(7)\\ Death \\ in \\ boat}" "' /// 
				+ `" "\Shortstack{1em}{(8)\\ Sent \\ Back \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(9) \\ PCA \\ Risk \\ Index}" "' 
					
*risk outcomes at fu1 with controls averaging italy and spain

global risk_outcomes = " _duration_winsor " ///
							+ " _beaten " ///
							+ " _forced_work " ///
							+ " _journey_cost_winsor  " ///
							+ " _kidnapped " ///
							+ " _die_bef_boat " ///
							+ " _die_boat " ///
							+ " _sent_back "
		
local controls_bl " " 
foreach var in `demographics' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
}
foreach var in `school_char' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
}
	
global appendix_reg " "


*est clear
	
global main_reg " "
	
global mrisk_outcomes = " asinhmrisk_duration_winsor " ///
						+ " mrisk_beaten " ///
						+ " mrisk_forced_work " ///
						+ " asinhmrisk_journey_cost_winsor  " ///
						+ " mrisk_kidnapped " ///
						+ " mrisk_die_bef_boat " ///
						+ " mrisk_die_boat " ///
						+ " mrisk_sent_back "



global mrisk_outcomes_bl " "
foreach var in $mrisk_outcomes {
	gen l1`var' = l.`var'
	global mrisk_outcomes_bl $mrisk_outcomes_bl " l1`var'"
}

local n_outcomes `: word count $mrisk_outcomes'

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $mrisk_outcomes {
	di "  - `var'"
}	


if (`makefwer' == 1) {
	
	preserve
	drop if time == 2
	drop if time == 1 & l1.attended_tr == .
	drop if time == 0 & attended_tr == .

	wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 `controls_bl' CONTROLVARS  , ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($mrisk_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	matrix define results = r(table)
	esttab matrix(results) using table12mean.csv, nomtitles replace

}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12mean.csv, clear 

	drop if _n == 28
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 26
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"

restore

}

matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)*3
mat R=J(`n_rows',5,.)

* matrix to store asinh outcomes for graphs
mat Rasinh=J(6,5,.)

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_mrisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
			
	test 2.x - 3.x = 0
	local pre  = string(`r(p)', "%9.2f")
	estadd local pre = `"`pre'"'
	
	test 2.x - 4.x = 0
	local prd = string(`r(p)', "%9.2f") 
	estadd local prd = `"`prd'"'
	
	test 3.x - 4.x = 0
	local ped = string(`r(p)', "%9.2f")
	estadd local ped = `"`ped'"'
	
	estadd local space " "
		
	if (`n' < 9) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 10) {
		global main_reg $main_reg reg_mrisk_`n'
	}
	else {
		global appendix_reg $appendix_reg reg_mrisk_`n'
	}
	
if (`n' < 9)&(`n' != 1)&(`n' != 4) {
	local n_treat=1
	local ++ng

	foreach X in i2.x i3.x i4.x  {
		local row = (`n_outcomes'-5)*(`n_treat'-1) + `ng'
		
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'
		mat R[`row',5]= pfwer[1, `n_treat']				
		local ++n_treat
		}

	}
	
	if (`n' < 9)&((`n' == 1)|(`n' == 4)) {
	local n_treat=1

	if (`n' == 1) {
		local ngasinh 1
	}
	
	if (`n' == 4) {
		local ngasinh 2
	}
	
	foreach X in i2.x i3.x i4.x  {
		local row = 2*(`n_treat'-1) + `ngasinh'
		
		mat Rasinh[`row',1]=_b[`X']
		mat Rasinh[`row',2]=_b[`X']-1.96*_se[`X']
		mat Rasinh[`row',3]=_b[`X']+1.96*_se[`X']
		mat Rasinh[`row',4]=`row'
		mat Rasinh[`row',5]= pfwer[1, `n_treat']				
		local ++n_treat
		}

	}

}



preserve

clear
svmat Rasinh
			
la var Rasinh4 Outcome
la var Rasinh1 "Effect"
label define groups 1 "Journey Duration" 2 "Journey Cost"  ///
	3 "Journey Duration" 4 "Journey Cost"  ///
	5 "Journey Duration" 6 "Journey Cost" 
label values Rasinh4 groups
la var Rasinh5 "p_fwer"

set scheme s2mono
	
twoway (bar Rasinh1 Rasinh4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap Rasinh3 Rasinh2 Rasinh4, lc(gs5))	, ///
	legend(off) xlabel(1/6, valuelabel angle(vertical)) 	///
	xline(2.5, lpattern(-) lcolor(black)) 	///
	xline(4.5, lpattern(-) lcolor(black)) 	///
	yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	ylabel(-0.6(0.2)0.6) ///
	text(0.5 1.5 "Risk") text(0.5 3.5 "Econ") text(0.5 5.5 "Double")

graph save Graph ${main}/Draft/figures/figure20mean.gph, replace
graph export ${main}/Draft/figures/figure20mean.png, replace

*fwer
twoway (bar Rasinh1 Rasinh4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
(bar Rasinh1 Rasinh4 if Rasinh5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap Rasinh3 Rasinh2 Rasinh4, lc(gs5))	, ///
	legend(off) xlabel(1/6, valuelabel angle(vertical)) 	///
	xline(2.5, lpattern(-) lcolor(black)) 	///
	xline(4.5, lpattern(-) lcolor(black)) 	///
	yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	ylabel(-0.6(0.2)0.6) ///
	text(0.5 1.5 "Risk") text(0.5 3.5 "Econ") text(0.5 5.5 "Double")
	
graph save Graph ${main}/Draft/figures/figure21mean.gph, replace
graph export ${main}/Draft/figures/figure21mean.png , replace

restore



preserve

clear
svmat R
			
la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Beaten" 2 "Forced Work" 3 "Kidnapped" ///
	4 "Death bef. boat" 5 "Death boat" 6 "Sent Back" ///
	7 "Beaten" 8 "Forced Work" 9 "Kidnapped" ///
	10 "Death bef. boat" 11 "Death boat" 12 "Sent Back" ///
	13 "Beaten" 14 "Forced Work" 15 "Kidnapped" ///
	16 "Death bef. boat" 17 "Death boat" 18 "Sent Back" 
label values R4 groups
la var R5 "p_fwer"

set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

graph save Graph ${main}/Draft/figures/figure14mean.gph, replace
graph export ${main}/Draft/figures/figure14mean.png, replace

*fwer
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
xline(6.5, lpattern(-) lcolor(black)) 	///
xline(12.5, lpattern(-) lcolor(black)) 	///
graphregion(color(white)) ///
ytitle(Treatment effect) ///
ylabel(0(3)18) ///
text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

graph save Graph ${main}/Draft/figures/figure15mean.gph, replace
graph export ${main}/Draft/figures/figure15mean.png , replace

restore


esttab $main_reg using ///
	"table12mean.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 
	
	
estimates drop $main_reg 

*any treatment

global main_reg " "
	
global mrisk_outcomes = " asinhmrisk_duration_winsor " ///
						+ " mrisk_beaten " ///
						+ " mrisk_forced_work " ///
						+ " asinhmrisk_journey_cost_winsor  " ///
						+ " mrisk_kidnapped " ///
						+ " mrisk_die_bef_boat " ///
						+ " mrisk_die_boat " ///
						+ " mrisk_sent_back "


local n_outcomes `: word count $mrisk_outcomes'

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $mrisk_outcomes {
	di "  - `var'"
}	

if (`makefwer' == 1) {
	
preserve
drop if time == 2
drop if time == 1 & l1.attended_tr == .
drop if time == 0 & attended_tr == .



wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR treated `controls_bl' CONTROLVARS  , ///
	cluster(schoolid) a(strata)) familyp(treated) ///
	controls($mrisk_outcomes_bl) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

matrix define results = r(table)
esttab matrix(results) using table12meanany.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12meanany.csv, clear 

	drop if _n == 12
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 10
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}


matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
 

***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)
mat R=J(`n_rows',5,.)

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = p_FWER[`n',1]
	matrix colnames pfwer = x
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y x strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_mrisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
			
	if (`n' < 9) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 10) {
		global main_reg $main_reg reg_mrisk_`n'
	}
	else {
		global appendix_reg $appendix_reg reg_mrisk_`n'
	}
	

}

preserve


		esttab $main_reg using ///
			"table12meanany.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
			keep(x) collabels(,none) substitute(\_ _) ///
			replace  ///
			coeflabels(x "Any treatment" strata "Big school" ///
			y "Basel. outc." _cons "Constant")  ///
			 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
			nonumbers   noobs /// 
			nobaselevels ///
			mtitles($risks_table_titles) ///
			posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot(" ") ///
			nonumbers 
	
restore

eststo clear

*econ outcomes at fu1 with controls testing different treatments only treatment

global economic_outcomes = " finding_job " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " in_favor_of_migration " 


**************************************FWER**************************************

local n_outcomes `: word count $economic_outcomes'
	
	
*est clear

global economic_outcomes_bl " "
foreach var in $economic_outcomes {
	gen l1`var' = l.`var'
	global economic_outcomes_bl $economic_outcomes_bl  " l1`var'"
}
	
* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}
	
if (`makefwer' == 1) {
preserve
drop if time == 2
drop if time == 1 & l1.attended_tr == .
drop if time == 0 & attended_tr == .

wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 `controls_bl' CONTROLVARS, ///
	cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
	controls($economic_outcomes_bl) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

* drop auxiliary lag variables

matrix define results = r(table)
esttab matrix(results) using table13comp.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13comp.csv, clear 

	drop if _n == 31
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 29
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}
	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
***********************************KLING***********************************

global economic_outcomes $economic_outcomes  economic_index  economic_kling


global economic_plot_list " "
global economic_plot_list_noasinh " "

local n_outcomes `: word count $economic_outcomes'
local n_rows = (`n_outcomes' - 4)*3
mat R=J(`n_rows',5,.)

* matrix to store asinh outcomes for graphs
mat Rasinh=J(6,5,.)

global main_reg " "
	
*est clear

local n = 0
local ng = 0


foreach y in $economic_outcomes {

	local n = `n' + 1
	
	if (`n' < 10) {
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	
	test 2.x - 3.x = 0
	local pre  = string(`r(p)', "%9.2f")
	estadd local pre = `"`pre'"'
	
	test 2.x - 4.x = 0
	local prd = string(`r(p)', "%9.2f") 
	estadd local prd = `"`prd'"'
	
	test 3.x - 4.x = 0
	local ped = string(`r(p)', "%9.2f")
	estadd local ped = `"`ped'"'
	
	estadd local space " "
	
	drop x
	est sto reg_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	if (`n' < 10) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 11) {	
		global main_reg $main_reg reg_econ_`n'
		}
	else {
		global appendix_reg $appendix_reg reg_econ_`n'
	}
	
	/* store estimates and CIs for graphs for all probabilistic outcomes */
	if (`n' != 2)&(`n' != 8)&(`n' < 10){
	local n_treat=1
	local ++ng

	foreach X in i2.x i3.x i4.x  {
		local row = (`n_outcomes'-4)*(`n_treat'-1) + `ng'
		
		local k = 1
		if `ng' == 5 {
		local k = -1
		}
		mat R[`row',1]=`k'*_b[`X']
		mat R[`row',2]=`k'*_b[`X']-1.96*_se[`X']
		mat R[`row',3]=`k'*_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'
		mat R[`row',5]= pfwer[1, `n_treat']
		
	local ++n_treat
	}
	}
	
	if ((`n' == 2)|(`n' == 8))&(`n' < 10) {
	local n_treat=1

	if (`n' == 2) {
		local ngasinh 1
	}
	
	if (`n' == 8) {
		local ngasinh 2
	}
	
	foreach X in i2.x i3.x i4.x  {
		local row = 2*(`n_treat'-1) + `ngasinh'
		
		mat Rasinh[`row',1]=_b[`X']
		mat Rasinh[`row',2]=_b[`X']-1.96*_se[`X']
		mat Rasinh[`row',3]=_b[`X']+1.96*_se[`X']
		mat Rasinh[`row',4]=`row'
		mat Rasinh[`row',5]= pfwer[1, `n_treat']
		
	local ++n_treat
	}
	}
	
}



global economic_outcomes = " finding_job " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " in_favor_of_migration " 

		
		
preserve

clear
svmat Rasinh
			
la var Rasinh4 Outcome
la var Rasinh1 "Effect"
label define groups 1 "Wage abroad" 2 "Cost of liv. abroad"  ///
	3 "Wage abroad" 4 "Cost of liv. abroad"  ///
	5 "Wage abroad" 6 "Cost of liv. abroad" 
label values Rasinh4 groups
la var Rasinh5 "p_fwer"

set scheme s2mono
	
twoway (bar Rasinh1 Rasinh4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap Rasinh3 Rasinh2 Rasinh4, lc(gs5))	, ///
	legend(off) xlabel(1/6, valuelabel angle(vertical)) 	///
	xline(2.5, lpattern(-) lcolor(black)) 	///
	xline(4.5, lpattern(-) lcolor(black)) 	///
	yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	ylabel(-0.4(0.2)0.4) ///
	text(0.3 1.5 "Risk") text(0.3 3.5 "Econ") text(0.3 5.5 "Double")

graph save Graph ${main}/Draft/figures/figure22.gph, replace
graph export ${main}/Draft/figures/figure22.png, replace

*fwer
twoway (bar Rasinh1 Rasinh4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
(bar Rasinh1 Rasinh4 if Rasinh5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap Rasinh3 Rasinh2 Rasinh4, lc(gs5))	, ///
	legend(off) xlabel(1/6, valuelabel angle(vertical)) 	///
	xline(2.5, lpattern(-) lcolor(black)) 	///
	xline(4.5, lpattern(-) lcolor(black)) 	///
	yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	ylabel(-0.4(0.2)0.4) ///
	text(0.3 1.5 "Risk") text(0.3 3.5 "Econ") text(0.3 5.5 "Double")
	
graph save Graph ${main}/Draft/figures/figure23.gph, replace
graph export ${main}/Draft/figures/figure23.png , replace

restore
			
preserve
clear
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Finding job" 2 "Contin. studies" 3 "Getting asylum" ///
	4 "Becoming citizen" 5 "Return aft. 5yrs" 6 "Public transfers" ///
	7 "Host country attit." ///
	8 "Finding job" 9 "Contin. studies" 10 "Getting asylum" ///
	11 "Becoming citizen" 12 "Return aft. 5yrs" 13 "Public transfers" ///
	14 "Host country attit." ///
	15 "Finding job" 16 "Contin. studies" 17 "Getting asylum" ///
	18 "Becoming citizen" 19 "Return aft. 5yrs" 20 "Public transfers" ///
	21 "Host country attit." ///
	
label values R4 groups
la var R5 "p_fwer"

set scheme s2mono
	
* no fwer
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/figure16.gph, replace
graph export ${main}/Draft/figures/figure16.png , replace

*fwer
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ytitle(Treatment effect) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/figure17.gph, replace
graph export ${main}/Draft/figures/figure17.png , replace
	
restore


esttab  $main_reg using ///
	"table13comp.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 
	
	

*econ outcomes at fu1 with controls testing different treatments

global economic_outcomes = " finding_job " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " in_favor_of_migration " 

**************************************FWER**************************************

*est clear


local n_outcomes `: word count $economic_outcomes'
	

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}

if (`makefwer' == 1) {
preserve
	drop if time == 2
	drop if time == 1 & l1.attended_tr == .
	drop if time == 0 & attended_tr == .

	wyoung $economic_outcomes, cmd(areg OUTCOMEVAR treated `controls_bl' CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(treated) ///
		controls($economic_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	* drop auxiliary lag variables

	matrix define results = r(table)
	esttab matrix(results) using table13company.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13company.csv, clear 

	drop if _n == 13
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 11
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}

matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

global economic_outcomes $economic_outcomes  economic_index  economic_kling


global economic_plot_list " "
global economic_plot_list_noasinh " "

local n_outcomes `: word count $economic_outcomes'
local n_rows = (`n_outcomes' - 3)
mat R=J(`n_rows',5,.)

global main_reg " "
	
*est clear

local n = 0
local ng = 0


foreach y in $economic_outcomes {

	local n = `n' + 1
	
	if (`n' < 10) {
	matrix pfwer = p_FWER[`n',1]
	matrix colnames pfwer = x
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y x strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	if (`n' < 10) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 11) {	
		global main_reg $main_reg reg_econ_`n'
		}
	else {
		global appendix_reg $appendix_reg reg_econ_`n'
	}
	
}


esttab  $main_reg using ///
	"table13company.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(x) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(x "Any treatment" )  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers   noobs /// 
	nobaselevels ///
	mtitles($economic_titles) ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot(" ") ///
	nonumbers 


* appendix regressions beliefs, any treatment


est clear

global appendix_vars "italy_kling_negcost italy_kling_poscost spain_kling_negcost spain_kling_poscost economic_kling"

local n = 0
foreach var in $appendix_vars {
	local n = `n' + 1
	gen y = `var'
	qui reg f.y treated strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	est sto reg`n'	
	drop y
}

esttab reg* using ///
	"table14a.tex",  se ///
	 keep(treated) collabels(,none) substitute(\_ _) ///
	replace  ///
	coeflabels(treated "Any treatment")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  noobs /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &   \\ [1em]") prefoot("\hline") postfoot(" ") ///
	nonumbers 

est clear

local n = 0
foreach var in $appendix_vars {
	local n = `n' + 1
	gen y = `var'
	qui reg f.y i.treatment_status strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	
	test 2.treatment_status - 3.treatment_status = 0
	local pre  = string(`r(p)', "%9.2f")
	estadd local pre = `"`pre'"'

	test 2.treatment_status - 4.treatment_status = 0
	local prd = string(`r(p)', "%9.2f") 
	estadd local prd = `"`prd'"'

	test 3.treatment_status - 4.treatment_status = 0
	local ped = string(`r(p)', "%9.2f")
	estadd local ped = `"`ped'"'

	estadd local space " "

	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)

	est sto reg`n'
	drop y
}
	
esttab  reg* using ///
	"table14b.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.treatment_status 3.treatment_status 4.treatment_status) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(2.treatment_status ///
	"\(T1\) - Risk" 3.treatment_status "\(T2\) - Econ" ///
	4.treatment_status "\(T3\) - Double")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

*/


global economic_titles = `" " \Shortstack{1em}{(1)\\ Finding \\ Job \\ \vphantom{foo}} " "' ///
			+ `" "\Shortstack{1em}{(2)\\ Wage \\ abroad \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(3)\\ Contin. \\ studies \\ abroad}" "' ///
			+ `" "\Shortstack{1em}{(4) \\ Getting \\ asylum \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(5)\\ Becom. \\ Citizen \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(6)\\ Return \\ before \\ 5 yrs}" "' ///
			+ `" "\Shortstack{1em}{(7)\\ Getting \\ public \\ transf. }""' ///
			+ `" "\Shortstack{1em}{(8) \\  Cost of \\ living \\ abroad}" "' ///
			+ `" "\Shortstack{1em}{(9) \\ Host \\ country \\ attit.}" "' ///
			+ `" "\Shortstack{1em}{(10) \\ PCA \\ Econ \\ Index}" "' 
											
								
global appendix_table_titles =  `" "\Shortstack{1em}{(1) \\ Kling \\ Cost- \\ Ita }" "'  ///
								+ `" "\Shortstack{1em}{(2) \\ Kling \\ Cost+ \\ Ita }" "' ///
								+ `" "\Shortstack{1em}{(3) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\Shortstack{1em}{(4) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\Shortstack{1em}{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				
			

global risks_table_titles = `" " \Shortstack{1em}{(1) \\ Journey \\ Duration \\ \vphantom{foo}}" "' ///
				+ `" " \Shortstack{1em}{(2)\\ Being \\ Beaten \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(3)\\ Forced \\  to \\ Work}" "' /// 
				+ `" " \Shortstack{1em}{(4) \\ Journey\\ Cost \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(5) \\ Being \\ Kidnap- \\ ped}" "' ///
				+ `" "\Shortstack{1em}{(6)\\ Death \\ before \\ boat}" "' ///
				+ `" "\Shortstack{1em}{(7)\\ Death \\ in \\ boat}" "' /// 
				+ `" "\Shortstack{1em}{(8)\\ Sent \\ Back \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(9) \\ PCA \\ Risk \\ Index}" "' 

				
local controls_bl " " 
foreach var in `demographics' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
}
foreach var in `school_char' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
}


*risk outcomes at fu1 with controls averaging italy and spain

global risk_outcomes = " _duration_winsor " ///
							+ " _beaten " ///
							+ " _forced_work " ///
							+ " _journey_cost_winsor  " ///
							+ " _kidnapped " ///
							+ " _die_bef_boat " ///
							+ " _die_boat " ///
							+ " _sent_back "

	
global appendix_reg " "


*est clear
	
global main_reg " "
	
global mrisk_outcomes = " asinhmrisk_duration_winsor " ///
						+ " mrisk_beaten " ///
						+ " mrisk_forced_work " ///
						+ " asinhmrisk_journey_cost_winsor  " ///
						+ " mrisk_kidnapped " ///
						+ " mrisk_die_bef_boat " ///
						+ " mrisk_die_boat " ///
						+ " mrisk_sent_back "



* increased from first two second survey
global mrisk_outcomes_i " "
foreach var in $mrisk_outcomes {
	gen `var'_i = `var' > l.`var' if  !missing(`var') & !missing(l.`var') & time == 1
	global mrisk_outcomes_i $mrisk_outcomes_i `var'_i
}

global mrisk_outcomes $mrisk_outcomes_i
						



local n_outcomes `: word count $mrisk_outcomes'


if (`makefwer' == 1) {
	
	preserve
	drop if time == 2
	drop if time == 1 & l1.attended_tr == .
	drop if time == 0 & attended_tr == .

	wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 `controls_bl'  , ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	matrix define results = r(table)
	esttab matrix(results) using table12mean.csv, nomtitles replace

}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12mean_inc.csv, clear 

	drop if _n == 28
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 26
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"

restore

}

matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)*3
mat R=J(`n_rows',5,.)

* matrix to store asinh outcomes for graphs
mat Rasinh=J(6,5,.)

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x strata `demographics' `school_char' if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_mrisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
			
	test 2.x - 3.x = 0
	local pre  = string(`r(p)', "%9.2f")
	estadd local pre = `"`pre'"'
	
	test 2.x - 4.x = 0
	local prd = string(`r(p)', "%9.2f") 
	estadd local prd = `"`prd'"'
	
	test 3.x - 4.x = 0
	local ped = string(`r(p)', "%9.2f")
	estadd local ped = `"`ped'"'
	
	estadd local space " "
		
	if (`n' < 9) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 10) {
		global main_reg $main_reg reg_mrisk_`n'
	}
	else {
		global appendix_reg $appendix_reg reg_mrisk_`n'
	}
	
if (`n' < 9)&(`n' != 1)&(`n' != 4) {
	local n_treat=1
	local ++ng

	foreach X in i2.x i3.x i4.x  {
		local row = (`n_outcomes'-5)*(`n_treat'-1) + `ng'
		
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'
		mat R[`row',5]= pfwer[1, `n_treat']				
		local ++n_treat
		}

	}
	
	if (`n' < 9)&((`n' == 1)|(`n' == 4)) {
	local n_treat=1

	if (`n' == 1) {
		local ngasinh 1
	}
	
	if (`n' == 4) {
		local ngasinh 2
	}
	
	foreach X in i2.x i3.x i4.x  {
		local row = 2*(`n_treat'-1) + `ngasinh'
		
		mat Rasinh[`row',1]=_b[`X']
		mat Rasinh[`row',2]=_b[`X']-1.96*_se[`X']
		mat Rasinh[`row',3]=_b[`X']+1.96*_se[`X']
		mat Rasinh[`row',4]=`row'
		mat Rasinh[`row',5]= pfwer[1, `n_treat']				
		local ++n_treat
		}

	}

}





esttab $main_reg using ///
	"table12mean_inc.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 
	
	
estimates drop $main_reg 

*any treatment

global main_reg " "
	
global mrisk_outcomes $mrisk_outcomes_i

local n_outcomes `: word count $mrisk_outcomes'

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $mrisk_outcomes {
	di "  - `var'"
}	

if (`makefwer' == 1) {
	
preserve
drop if time == 2
drop if time == 1 & l1.attended_tr == .
drop if time == 0 & attended_tr == .



wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR treated `controls_bl'  , ///
	cluster(schoolid) a(strata)) familyp(treated) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

matrix define results = r(table)
esttab matrix(results) using table12meanany_inc.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12meanany_inc.csv, clear 

	drop if _n == 12
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 10
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}


matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
 

***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)
mat R=J(`n_rows',5,.)

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = p_FWER[`n',1]
	matrix colnames pfwer = x
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y x strata `demographics' `school_char' if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_mrisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
			
	if (`n' < 9) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 10) {
		global main_reg $main_reg reg_mrisk_`n'
	}
	else {
		global appendix_reg $appendix_reg reg_mrisk_`n'
	}
	

}

preserve


		esttab $main_reg using ///
			"table12meanany_inc.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
			keep(x) collabels(,none) substitute(\_ _) ///
			replace  ///
			coeflabels(x "Any treatment" strata "Big school" ///
			y "Basel. outc." _cons "Constant")  ///
			 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
			nonumbers   noobs /// 
			nobaselevels ///
			mtitles($risks_table_titles) ///
			posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot(" ") ///
			nonumbers 
	
restore

eststo clear

*econ outcomes at fu1 with controls testing different treatments only treatment

global economic_outcomes = " finding_job " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " in_favor_of_migration " 



* increased from first two second survey
global economic_outcomes_i " "
foreach var in $economic_outcomes {
	gen `var'_i = `var' > l.`var' if  !missing(`var') & !missing(l.`var') & time == 1
	global economic_outcomes_i $economic_outcomes_i `var'_i
}
	
global economic_outcomes $economic_outcomes_i 
	
**************************************FWER**************************************

local n_outcomes `: word count $economic_outcomes'

	
if (`makefwer' == 1) {
preserve
drop if time == 2
drop if time == 1 & l1.attended_tr == .
drop if time == 0 & attended_tr == .

wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 `controls_bl', ///
	cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

* drop auxiliary lag variables

matrix define results = r(table)
esttab matrix(results) using table13comp_inc.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13comp_inc.csv, clear 

	drop if _n == 31
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 29
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}
	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
***********************************KLING***********************************

global economic_outcomes $economic_outcomes  economic_index  economic_kling


global economic_plot_list " "
global economic_plot_list_noasinh " "

local n_outcomes `: word count $economic_outcomes'
local n_rows = (`n_outcomes' - 4)*3
mat R=J(`n_rows',5,.)

* matrix to store asinh outcomes for graphs
mat Rasinh=J(6,5,.)

global main_reg " "
	
*est clear

local n = 0
local ng = 0


foreach y in $economic_outcomes {

	local n = `n' + 1
	
	if (`n' < 10) {
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x strata  `demographics' `school_char' if attended_tr != . & time == 0, cluster(schoolid_str)
	
	test 2.x - 3.x = 0
	local pre  = string(`r(p)', "%9.2f")
	estadd local pre = `"`pre'"'
	
	test 2.x - 4.x = 0
	local prd = string(`r(p)', "%9.2f") 
	estadd local prd = `"`prd'"'
	
	test 3.x - 4.x = 0
	local ped = string(`r(p)', "%9.2f")
	estadd local ped = `"`ped'"'
	
	estadd local space " "
	
	drop x
	est sto reg_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	if (`n' < 10) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 11) {	
		global main_reg $main_reg reg_econ_`n'
		}
	else {
		global appendix_reg $appendix_reg reg_econ_`n'
	}
	
	/* store estimates and CIs for graphs for all probabilistic outcomes */
	if (`n' != 2)&(`n' != 8)&(`n' < 10){
	local n_treat=1
	local ++ng

	foreach X in i2.x i3.x i4.x  {
		local row = (`n_outcomes'-4)*(`n_treat'-1) + `ng'
		
		local k = 1
		if `ng' == 5 {
		local k = -1
		}
		mat R[`row',1]=`k'*_b[`X']
		mat R[`row',2]=`k'*_b[`X']-1.96*_se[`X']
		mat R[`row',3]=`k'*_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'
		mat R[`row',5]= pfwer[1, `n_treat']
		
	local ++n_treat
	}
	}
	
	if ((`n' == 2)|(`n' == 8))&(`n' < 10) {
	local n_treat=1

	if (`n' == 2) {
		local ngasinh 1
	}
	
	if (`n' == 8) {
		local ngasinh 2
	}
	
	foreach X in i2.x i3.x i4.x  {
		local row = 2*(`n_treat'-1) + `ngasinh'
		
		mat Rasinh[`row',1]=_b[`X']
		mat Rasinh[`row',2]=_b[`X']-1.96*_se[`X']
		mat Rasinh[`row',3]=_b[`X']+1.96*_se[`X']
		mat Rasinh[`row',4]=`row'
		mat Rasinh[`row',5]= pfwer[1, `n_treat']
		
	local ++n_treat
	}
	}
	
}




global economic_outcomes $economic_outcomes_i


esttab  $main_reg using ///
	"table13comp_inc.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 
	
	

*econ outcomes at fu1 with controls testing different treatments

global economic_outcomes = " finding_job " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " in_favor_of_migration " 

**************************************FWER**************************************

*est clear


local n_outcomes `: word count $economic_outcomes'
	

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}

if (`makefwer' == 1) {
preserve
	drop if time == 2
	drop if time == 1 & l1.attended_tr == .
	drop if time == 0 & attended_tr == .

	wyoung $economic_outcomes, cmd(areg OUTCOMEVAR treated `controls_bl', ///
		cluster(schoolid) a(strata)) familyp(treated) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	* drop auxiliary lag variables

	matrix define results = r(table)
	esttab matrix(results) using table13company_inc.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13company_inc.csv, clear 

	drop if _n == 13
	drop if _n == 3
	drop if _n == 1
	replace v1 = itrim(v1)
	replace v1 = trim(v1)
	replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	split v1, p(" ")
	drop if _n == 11
	drop if _n == 1
	destring v15, replace
	mkmat v15, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}

matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

global economic_outcomes $economic_outcomes  economic_index  economic_kling


global economic_plot_list " "
global economic_plot_list_noasinh " "

local n_outcomes `: word count $economic_outcomes'
local n_rows = (`n_outcomes' - 3)
mat R=J(`n_rows',5,.)

global main_reg " "
	
*est clear

local n = 0
local ng = 0


foreach y in $economic_outcomes {

	local n = `n' + 1
	
	if (`n' < 10) {
	matrix pfwer = p_FWER[`n',1]
	matrix colnames pfwer = x
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y x strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	if (`n' < 10) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 11) {	
		global main_reg $main_reg reg_econ_`n'
		}
	else {
		global appendix_reg $appendix_reg reg_econ_`n'
	}
	
}


esttab  $main_reg using ///
	"table13company_inc.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(x) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(x "Any treatment" )  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers   noobs /// 
	nobaselevels ///
	mtitles($economic_titles) ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot(" ") ///
	nonumbers 


* appendix regressions beliefs, any treatment


est clear

global appendix_vars "italy_kling_negcost italy_kling_poscost spain_kling_negcost spain_kling_poscost economic_kling"

local n = 0
foreach var in $appendix_vars {
	local n = `n' + 1
	gen y = `var'
	qui reg f.y treated strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	est sto reg`n'	
	drop y
}

esttab reg* using ///
	"table14a_inc.tex",  se ///
	 keep(treated) collabels(,none) substitute(\_ _) ///
	replace  ///
	coeflabels(treated "Any treatment")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  noobs /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &   \\ [1em]") prefoot("\hline") postfoot(" ") ///
	nonumbers 

est clear

local n = 0
foreach var in $appendix_vars {
	local n = `n' + 1
	gen y = `var' > l.`var' if !missing(`var') & !missing(`var') & time == 1
	qui reg f.y i.treatment_status strata  `demographics' `school_char' if attended_tr != . & time == 0, cluster(schoolid_str)
	
	test 2.treatment_status - 3.treatment_status = 0
	local pre  = string(`r(p)', "%9.2f")
	estadd local pre = `"`pre'"'

	test 2.treatment_status - 4.treatment_status = 0
	local prd = string(`r(p)', "%9.2f") 
	estadd local prd = `"`prd'"'

	test 3.treatment_status - 4.treatment_status = 0
	local ped = string(`r(p)', "%9.2f")
	estadd local ped = `"`ped'"'

	estadd local space " "

	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)

	est sto reg`n'
	drop y
}
	
esttab  reg* using ///
	"table14b_inc.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.treatment_status 3.treatment_status 4.treatment_status) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(2.treatment_status ///
	"\(T1\) - Risk" 3.treatment_status "\(T2\) - Econ" ///
	4.treatment_status "\(T3\) - Double")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

stop

	
	
/*
*PARTICIPATION BY STAGE AND TREATMENT ARM

preserve

*baseline

m: obs = J(6,10,.)

qui count if treatment_status == 1 & time == 0
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0
local N3 = `r(N)'

qui count if treatment_status == 3 & time == 0
local N4 = `r(N)'

qui count if treatment_status == 4 & time == 0
local N5 = `r(N)'

m: obs[1,3] = strtoreal(st_local("N2"))
m: obs[1,5] = strtoreal(st_local("N3"))
m: obs[1,7] = strtoreal(st_local("N4"))
m: obs[1,9] = strtoreal(st_local("N5"))
m: obs[1,1] = obs[1,3] + obs[1,5] + obs[1,7] + obs[1,9]

*sensibilization

qui count if treatment_status == 1 & sensibilized == 1 & time == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & sensibilized == 1 & time == 1
local N3 = `r(N)'


qui count if treatment_status == 3 & sensibilized == 1 & time == 1
local N4 = `r(N)'

qui count if treatment_status == 4 & sensibilized == 1 & time == 1
local N5 = `r(N)'

m: obs[2,2] = 0
m: obs[2,3] = strtoreal(st_local("N3"))
m: obs[2,4] = strtoreal(st_local("N4"))
m: obs[2,5] = strtoreal(st_local("N5"))
m: obs[2,1] = obs[2,2] + obs[2,3] + obs[2,4] + obs[2,5]

m: obs[3,1] = round(obs[2,1]/obs[1,1], .001)
m: obs[3,2] = 0
m: obs[3,3] = round(obs[2,3]/obs[1,3], .001)
m: obs[3,4] = round(obs[2,4]/obs[1,4], .001)
m: obs[3,5] = round(obs[2,5]/obs[1,5], .001)


*fist follow-up tablet

qui count if treatment_status == 1 & time == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 1
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 1
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 1
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[2,3] = strtoreal(st_local("N2"))
m: obs[2,5] = strtoreal(st_local("N3"))
m: obs[2,7] = strtoreal(st_local("N4"))
m: obs[2,9] = strtoreal(st_local("N5"))
m: obs[2,1] = obs[2,3] + obs[2,5] + obs[2,7] + obs[2,9]

m: obs[2,2] = round(obs[2,1]/obs[1,1], .001)
m: obs[2,4] = round(obs[2,3]/obs[1,3], .001)
m: obs[2,6] = round(obs[2,5]/obs[1,5], .001)
m: obs[2,8] = round(obs[2,7]/obs[1,7], .001)
m: obs[2,10] = round(obs[2,9]/obs[1,9], .001)


* second follow-up tablet

qui count if treatment_status == 1 & time == 0 & f2.source_info_guinea <= 0 & !missing(f2.source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & f2.source_info_guinea <= 0 & !missing(f2.source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & f2.source_info_guinea <= 0 & !missing(f2.source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & f2.source_info_guinea <= 0 & !missing(f2.source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[3,3] = strtoreal(st_local("N2"))
m: obs[3,5] = strtoreal(st_local("N3"))
m: obs[3,7] = strtoreal(st_local("N4"))
m: obs[3,9] = strtoreal(st_local("N5"))
m: obs[3,1] = obs[3,3] + obs[3,5] + obs[3,7] + obs[3,9]

m: obs[3,2] = round(obs[3,1]/obs[1,1], .001)
m: obs[3,4] = round(obs[3,3]/obs[1,3], .001)
m: obs[3,6] = round(obs[3,5]/obs[1,5], .001)
m: obs[3,8] = round(obs[3,7]/obs[1,7], .001)
m: obs[3,10] = round(obs[3,9]/obs[1,9], .001)


* second follow up respondent

qui count if treatment_status == 1 & time == 0 & f2.source_info_guinea <= 1 & !missing(f2.source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & f2.source_info_guinea <= 1 & !missing(f2.source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & f2.source_info_guinea <= 1 & !missing(f2.source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & f2.source_info_guinea <= 1 & !missing(f2.source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[4,3] = strtoreal(st_local("N2"))
m: obs[4,5] = strtoreal(st_local("N3"))
m: obs[4,7] = strtoreal(st_local("N4"))
m: obs[4,9] = strtoreal(st_local("N5"))
m: obs[4,1] = obs[4,3] + obs[4,5] + obs[4,7] + obs[4,9]

m: obs[4,2] = round(obs[4,1]/obs[1,1], .001)
m: obs[4,4] = round(obs[4,3]/obs[1,3], .001)
m: obs[4,6] = round(obs[4,5]/obs[1,5], .001)
m: obs[4,8] = round(obs[4,7]/obs[1,7], .001)
m: obs[4,10] = round(obs[4,9]/obs[1,9], .001)

* second follow up contact


qui count if treatment_status == 1 & time == 0 & f2.source_info_guinea <= 2 & !missing(f2.source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & f2.source_info_guinea <= 2 & !missing(f2.source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & f2.source_info_guinea <= 2 & !missing(f2.source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & f2.source_info_guinea <= 2 & !missing(f2.source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[5,3] = strtoreal(st_local("N2"))
m: obs[5,5] = strtoreal(st_local("N3"))
m: obs[5,7] = strtoreal(st_local("N4"))
m: obs[5,9] = strtoreal(st_local("N5"))
m: obs[5,1] = obs[5,3] + obs[5,5] + obs[5,7] + obs[5,9]

m: obs[5,2] = round(obs[5,1]/obs[1,1], .001)
m: obs[5,4] = round(obs[5,3]/obs[1,3], .001)
m: obs[5,6] = round(obs[5,5]/obs[1,5], .001)
m: obs[5,8] = round(obs[5,7]/obs[1,7], .001)
m: obs[5,10] = round(obs[5,9]/obs[1,9], .001)

* second follow up school info

qui count if treatment_status == 1 & time == 0 & f2.source_info_guinea <= 5 & !missing(f2.source_info_guinea)
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0 & f2.source_info_guinea <= 5 & !missing(f2.source_info_guinea)
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 0 & f2.source_info_guinea <= 5 & !missing(f2.source_info_guinea)
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 0 & f2.source_info_guinea <= 5 & !missing(f2.source_info_guinea)
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[6,3] = strtoreal(st_local("N2"))
m: obs[6,5] = strtoreal(st_local("N3"))
m: obs[6,7] = strtoreal(st_local("N4"))
m: obs[6,9] = strtoreal(st_local("N5"))
m: obs[6,1] = obs[6,3] + obs[6,5] + obs[6,7] + obs[6,9]

m: obs[6,2] = round(obs[6,1]/obs[1,1], .001)
m: obs[6,4] = round(obs[6,3]/obs[1,3], .001)
m: obs[6,6] = round(obs[6,5]/obs[1,5], .001)
m: obs[6,8] = round(obs[6,7]/obs[1,7], .001)
m: obs[6,10] = round(obs[6,9]/obs[1,9], .001)



m: st_matrix("obs", obs)

matrix colnames obs =  "Obs" "\%" "Obs"  "\%" "Obs"  "\%" "Obs"  "\%" "Obs"  "\%"
matrix rownames obs =  "\textbf{Baseline}: In-Person" "\textbf{Follow Up 1}: In-Person"  "\textbf{Follow Up 2}: In-Person" "\textbf{Follow Up 2}: Respondent (Phone)" "\textbf{Follow Up 2}: Contact (Phone)"   "\textbf{Follow Up 2}: School survey"  


esttab matrix(obs, fmt(%9.3g)) using apptable5.tex, style(tex) replace nomtitles postfoot(" \hline \hline \end{tabular}") ///
	prehead(" \begin{tabular}{l*{11}{c}} \hline \hline  &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)} &\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}&\multicolumn{1}{c}{(8)}&\multicolumn{1}{c}{(9)}&\multicolumn{1}{c}{(10)} \\ & \multicolumn{2}{c}{All}  & \multicolumn{2}{c}{Control}  & \multicolumn{2}{c}{\(T1\) - Risk}  & \multicolumn{2}{c}{\(T2\) - Econ} &  \multicolumn{2}{c}{\(T3\) - Double} \\  ") substitute(\_ _) 

restore

*/



*ATTRITION

eststo clear

preserve

keep if time == 0



		
local outcomes "no_1_1 no_1_2 no_2_2 no_3_2 no_5_2"

foreach var of varlist `outcomes' {
	qui sum `var' if treatment_status == 1
	local meandep = `r(mean)'
	
	gen x = treatment_status
	qui reg `var' i.x strata ///
		if attended_tr != ., cluster(schoolid)
	drop x

	test 2.x - 3.x = 0
	local pre  = string(`r(p)', "%9.2f")
	estadd local pre = `"`pre'"'
	
	test 2.x - 4.x = 0
	local prd = string(`r(p)', "%9.2f") 
	estadd local prd = `"`prd'"'
	
	test 3.x - 4.x = 0
	local ped = string(`r(p)', "%9.2f")
	estadd local ped = `"`ped'"'
	
	estadd scalar meandep = `meandep'
		
	eststo reg`var'
}

esttab regno* using apptable4.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("\Shortstack{1em}{In-Person \\ Survey \\ \phantom{inv} \\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person \\ Survey \\ \phantom{inv} \\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact + \\ School Surv.}") ///
	stats(pre prd ped N meandep, fmt(s s s  0 3) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"' `"\(N\)"'  `"Mean dep. var. control"')) nonumbers ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{5}{c}{y = attrited at survey}  \\ &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}   \\ \cmidrule(lr){2-6}  &\multicolumn{1}{c}{\(1^{st}\) F.U.}&\multicolumn{4}{c}{\(2^{nd}\) F.U.}  \\  \cmidrule(lr){2-2} \cmidrule(lr){3-6}")

restore



\multicolumn{1}{c}{\shortstack{In-Person \\ Survey \\ \phantom{inv} \\ \phantom{inv} \\ \phantom{inv}}}
&\multicolumn{1}{c}{\shortstack{In-Person \\ Survey \\ \phantom{inv}\\ \phantom{inv} \\ \phantom{inv} }}
&\multicolumn{1}{c}{\shortstack{In-Person + \\ Phone Surv. \\ w/ Respond.\\ \phantom{inv} \\ \phantom{inv} }}
&\multicolumn{1}{c}{\shortstack{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact \\ \phantom{inv}}}
&\multicolumn{1}{c}{\shortstack{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact + \\ School Surv. }} \\



*BALANCE

* individual characteristics with attendance (Panel a table 1)
global bc_var_demo = " female grade6 grade7 durables " ///
				+ " moth_working moth_educ5 moth_educ1 moth_educ2 moth_educ3 " ///
				+ " fath_working fath_educ5 fath_educ1 fath_educ2 fath_educ3  " 
* contacts abroad, sisters and brothers are winsorized


* variables for the balance with attendance (Panel b table 1)			
global bc_var_outcomes = "desire planning prepare italy_index spain_index economic_index" 	


* other individual characteristics (app table 2)
global bc_var_demo_sec = " contacts_winsor mig_classmates " ///
				+ " tele_daily tele_weekless inter_daily inter_weekless " ///
				+ " brother_no_win sister_no_win " 	

* other beliefs (app table 3)
global bc_var_italyrisk = " asinhitaly_duration italy_beaten italy_forced_work asinhitaly_journey_cost italy_kidnapped  italy_die_bef_boat italy_die_boat italy_sent_back italy_kling_negcost" 

global bc_var_spainrisk = " asinhspain_duration spain_beaten spain_forced_work asinhspain_journey_cost spain_kidnapped  spain_die_bef_boat spain_die_boat spain_sent_back spain_kling_negcost" 

global bc_var_econ =  "  finding_job asinhexpectation_wage continuing_studies asylum becoming_citizen return_5yr government_financial_help asinhexp_liv_cost_winsor in_favor_of_migration economic_kling" 
								

* school characteristics (app table 4)
global bc_var_school = " strata_n2 fees50 repeaters transfers ratio_female_second rstudteach rstudadmin rstudclass ratio_tmale ratio_tmaster " ///
				+ " schoolinf_index  "

				
preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_demo using "table1a.tex",  ///
	nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) leftctitle(" ") ///
	prefoot("") postfoot("") prehead("") posthead("")  noobservations

restore

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_outcomes using "table1b.tex",  ///
	nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) leftctitle(" ") ///
	postfoot("") prehead("") posthead("")  

restore	


preserve
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_demo using "table1aall.tex",  ///
	nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) leftctitle(" ") ///
	prefoot("") postfoot("") prehead("") posthead("")  noobservations

restore

preserve
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_outcomes using "table1ball.tex",  ///
	nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) leftctitle(" ") ///
	postfoot("") prehead("") posthead("")  

restore	

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_demo_sec using "tablebalothind.tex",  ///
	ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) leftctitle(" ") ///

restore


preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_italyrisk using "tablebalbela.tex",  ///
	nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) leftctitle(" ") ///
	prefoot("") postfoot("") prehead("") posthead("")  noobservations

restore

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_spainrisk using "tablebalbelb.tex",  ///
	nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) leftctitle(" ") ///
	prefoot("") postfoot("") prehead("") posthead("")  noobservations

restore

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_econ using "tablebalbelc.tex",  ///
	nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) leftctitle(" ") ///
	prefoot("") postfoot("") prehead("") posthead("")  noobservations

restore

preserve
keep if n_inclus == 1

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_school using "apptable3.tex",  ///
	ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) 

restore
	




preserve
keep if time == 0

* baseline beliefs

/*asylum*/
qui sum asylum
twoway (hist asylum, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Asylum (Prob.)") freq discrete  width(5) leg(off) xline(20, lpattern(-) lcolor(black))) (hist asylum if asylum >= 20, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(asylum, replace)
/*21/100 first instance for guineans between 18 and 34 in France, Italy, and Spain (same as final)*/


/*studies*/
qui sum continuing_studies
twoway (hist continuing_studies , graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Cont. education (Prob.)") freq discrete  width(5) leg(off) xline(30, lpattern(-) lcolor(black))) (hist continuing_studies if continuing_studies >= 30 , graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(continuing_studies, replace)
/*32/100 people in Spain Italy and France arrived in the last 3 years educstat (same as educ4wn if more than 20 hours)*/

/*job*/
qui sum finding_job
twoway (hist finding_job, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Employment (Prob.)") freq discrete  width(5) leg(off) xline(20, lpattern(-) lcolor(black))) (hist finding_job if finding_job >= 20, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(finding_job, replace)
/*22/100 people in Spain Italy and France arrived in the last 3 years ilostat*/


/*beaten*/
qui sum italy_beaten
twoway (hist italy_beaten, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Violence (Prob.)") freq discrete  width(5) leg(off) xline(70, lpattern(-) lcolor(black))) (hist italy_beaten if italy_beaten <= 70, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)), name(italy_beaten, replace)
/*76/100 male 65 women IOM trafficking -> 70.5 in sample*/

/*forced_work*/
qui sum italy_forced_work
twoway (hist italy_forced_work, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Forced to Work (Prob.)") freq discrete  width(5) leg(off) xline(90, lpattern(-) lcolor(black))) (hist italy_forced_work if italy_forced_work <= 90, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)),  name(italy_forced_work, replace)
/*90/100 harrowing figure for all (no disaggregated figure available, but conditions on guinea)*/


/*duration*/
gen italy_duration_winsor_cor = round(italy_duration_winsor)
qui sum italy_duration_winsor_cor
twoway (hist italy_duration_winsor_cor, graphregion(color(white)) lc(black) fc(midblue) fi(inten10) ytitle("") xtitle("") title("Journey Durat. (Mon. wins.)") freq discrete  width(5) leg(off) xline(6, lpattern(-) lcolor(black))) (hist italy_duration_winsor_cor if italy_duration_winsor_cor <= 6, graphregion(color(white)) lc(black) fc(midblue) fi(inten50)  freq discrete  width(5) leg(off)),  name(italy_duration_winsor_cor, replace)
/*46/100 harrowing figure for all (no disaggregated figure available, but conditions on guinea)*/

graph combine   italy_forced_work italy_beaten italy_duration_winsor_cor  asylum   finding_job  continuing_studies, graphregion(color(white))

graph save Graph ${main}/Draft/figures/figure18.gph, replace
graph export ${main}/Draft/figures/figure18.png , replace

restore

*AFROBAROMETER

clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"


use ${main}/Data/output/followup2/BME_final.dta

_pctile age, p(99)
local maxage = `r(r1)'
local maxage = 21

sum desire if time == 0
local desire_mean = `r(mean)'
local Ndataset = `r(N)'
sum planning if time == 0
local planning_mean = `r(mean)'
sum prepare if time == 0
local prepare_mean = `r(mean)' 

clear all

import delimited ${main}/Data/raw/afrobarometer/afrobarometer7.csv, clear 

cd "$main/Draft/tables"

m: migint = J(5,5,.)


*our dataset
m: migint[1,5] = strtoreal(st_local("Ndataset"))
m: migint[1,1] = round(strtoreal(st_local("desire_mean")), .01)
m: migint[1,3] = round(strtoreal(st_local("planning_mean")), .01)
m: migint[1,4] = round(strtoreal(st_local("prepare_mean")), .01)

* overall population

*only young, max is from our dataset, min is 18 (older)
qui count if country == 11 & q1 <= `maxage' & q1 != -1 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11 & q1 <= `maxage' & q1 != -1 & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & q1 <= `maxage' & q1 != -1 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & q1 <= `maxage' & q1 != -1 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & q1 <= `maxage' & q1 != -1 & q68b != -1
local N4 = `r(N)'

m: migint[2,5] = strtoreal(st_local("N"))
m: migint[2,1] = round(strtoreal(st_local("N1"))/migint[2,5], .01)
m: migint[2,2] = round(strtoreal(st_local("N2"))/migint[2,5], .01)
m: migint[2,3] = round(strtoreal(st_local("N3"))/migint[2,5], .01)
m: migint[2,4] = round(strtoreal(st_local("N4"))/migint[2,5], .01)

*total observations
qui count if country == 11 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11  & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & q68b != -1
local N4 = `r(N)'

m: migint[3,5] = strtoreal(st_local("N"))
m: migint[3,1] = round(strtoreal(st_local("N1"))/migint[3,5], .01)
m: migint[3,2] = round(strtoreal(st_local("N2"))/migint[3,5], .01)
m: migint[3,3] = round(strtoreal(st_local("N3"))/migint[3,5], .01)
m: migint[3,4] = round(strtoreal(st_local("N4"))/migint[3,5], .01)

*only conakry
*only young, max is from our dataset, min is 18 (older) from conakry
qui count if country == 11 & q1 <= `maxage' & q1 != -1 & region == 1300 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11 & q1 <= `maxage' & q1 != -1 & region == 1300 & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & q1 <= `maxage' & q1 != -1 & region == 1300 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & q1 <= `maxage' & q1 != -1 & region == 1300 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & q1 <= `maxage' & q1 != -1 & region == 1300 & q68b != -1
local N4 = `r(N)'

m: migint[4,5] = strtoreal(st_local("N"))
m: migint[4,1] = round(strtoreal(st_local("N1"))/migint[4,5], .01)
m: migint[4,2] = round(strtoreal(st_local("N2"))/migint[4,5], .01)
m: migint[4,3] = round(strtoreal(st_local("N3"))/migint[4,5], .01)
m: migint[4,4] = round(strtoreal(st_local("N4"))/migint[4,5], .01)


*only conakry
qui count if country == 11 & region == 1300 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11 & region == 1300 & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & region == 1300 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & region == 1300 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & region == 1300 & q68b != -1
local N4 = `r(N)'

m: migint[5,5] = strtoreal(st_local("N"))
m: migint[5,1] = round(strtoreal(st_local("N1"))/migint[5,5], .01)
m: migint[5,2] = round(strtoreal(st_local("N2"))/migint[5,5], .01)
m: migint[5,3] = round(strtoreal(st_local("N3"))/migint[5,5], .01)
m: migint[5,4] = round(strtoreal(st_local("N4"))/migint[5,5], .01)


m: st_matrix("migint", migint)
matrix migint = migint[1..5, 3..5]


matrix colnames migint =  "Plans"  "Prepares" "\emph{N}"
matrix rownames migint =  "\textbf{Our sample}: All, baseline"  "\textbf{Guinea}: Young (18-21 years old)"   "\textbf{Guinea}: All"    "\textbf{Conakry}: Young (18-21 years old)"   "\textbf{Conakry}: All"  

esttab matrix(migint, fmt(%9.2f)) using apptable6.tex, style(tex) replace nomtitles postfoot(" \hline \hline \end{tabular}")  	prehead(" \begin{tabular}{l*{3}{c}} \hline \hline    &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)} \\ ") substitute(\_ _) 

	


