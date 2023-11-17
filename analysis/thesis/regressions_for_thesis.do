clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/followup2/BME_final.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

cd "$main/Draft/tables/jul_2020"

tsset id_number time

global controls  "i.treatment_status i.strata" 
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'
	 
*Auxiliary variables for fwer.
gen sid = schoolid
global treatment_dummies " T1 T2 T3 "
gen trtmnt = .
local n_rep 1000


/*

***MEETING WITH CAMARA


local n_outcomes `: word count $migration_outcomes'
local n_rows = 5*3
mat R=J(`n_rows',6,.)

local n = 0

forval i = 1/4 {
	forval t = 0/2 {
		qui sum prepare if treatment_status == `i' & time == `t'   
			
			local row = 5*(`t') + `i' 
			di `row'
			mat R[`row',1]=`r(mean)'*100
			mat R[`row',2]=`t'
			mat R[`row',3]=`i'
			mat R[`row',4]=`row'
			mat R[`row',5]=(`r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)'))*100
			mat R[`row',6]=(`r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)'))*100
		
		}
	}
	
	
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
*label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
*label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 1, bcolor(black) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 2, bcolor(yellow) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 3, bcolor(blue) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 4, bcolor(red) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(rcap R6 R5 R4, lc(gs5)) , ///
	graphregion(color(white)) ///
	ylabel(0(1)7) ///
	legend(off) ///
	text(-0.4 2.5 "Enquête 0") text(-0.4 7.5 "Enquête 1") text(-0.4 12.5 "Enquête 2") ///
	xlabel(, nolabels) ///
	xtitle("") ///
	ytitle("Pourcentage d'étudiants qui ont preparé leur migration")
	
	/*
		, ///
	 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	
	 */
	graph save Graph ${main}/Draft/figures/differencesprepare.gph, replace
	graph export ${main}/Draft/figures/differencesprepare.png, replace

restore


global intention_names = "Plans to migrate"
				

global migration_outcomes "planning"

local n_outcomes `: word count $migration_outcomes'
local n_rows = 5*3
mat R=J(`n_rows',6,.)

local n = 0

forval i = 1/4 {
	forval t = 0/2 {
		qui sum planning if treatment_status == `i' & time == `t'   
			
			local row = 5*(`t') + `i' 
			di `row'
			mat R[`row',1]=`r(mean)'*100
			mat R[`row',2]=`t'
			mat R[`row',3]=`i'
			mat R[`row',4]=`row'
			mat R[`row',5]=(`r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)'))*100
			mat R[`row',6]=(`r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)'))*100
		
		}
	}
	
	
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
*label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
*label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 1, bcolor(black) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 2, bcolor(yellow) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 3, bcolor(blue) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 4, bcolor(red) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(rcap R6 R5 R4, lc(gs5)) , ///
	graphregion(color(white)) ///
	ylabel(0(5)20) ///
	legend(off) ///
	text(-1.3 2.5 "Enquête 0") text(-1.3 7.5 "Enquête 1") text(-1.3 12.5 "Enquête 2") ///
	xlabel(, nolabels) ///
	xtitle("") ///
	ytitle("Pourcentage d'étudiants prevoyant de migrer")
	
	/*
		, ///
	 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	
	 */
	graph save Graph ${main}/Draft/figures/differencesplanning.gph, replace
	graph export ${main}/Draft/figures/differencesplanning.png, replace

restore



local n = 0

forval i = 1/4 {
	forval t = 0/2 {
		qui sum desire if treatment_status == `i' & time == `t'   
			
			local row = 5*(`t') + `i' 
			di `row'
			mat R[`row',1]=`r(mean)'*100
			mat R[`row',2]=`t'
			mat R[`row',3]=`i'
			mat R[`row',4]=`row'
			mat R[`row',5]=(`r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)'))*100
			mat R[`row',6]=(`r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)'))*100
		
		}
	}
	
	
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
*label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
*label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 1, bcolor(black) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 2, bcolor(yellow) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 3, bcolor(blue) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 4, bcolor(red) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(rcap R6 R5 R4, lc(gs5)) , ///
	graphregion(color(white)) ///
	ylabel(0(10)60) ///
	legend(off) ///
	text(-3 2.5 "Enquête 0") text(-3 7.5 "Enquête 1") text(-3 12.5 "Enquête 2") ///
	xlabel(, nolabels) ///
	xtitle("") ///
	ytitle("Pourcentage d'étudiants qui veulent migrer")
	
	/*
		, ///
	 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	
	 */
	graph save Graph ${main}/Draft/figures/differencesdesire.gph, replace
	graph export ${main}/Draft/figures/differencesdesire.png, replace

restore


local n_rows = 4
mat R=J(`n_rows',6,.)

local n = 0

forval i = 1/4 {
		qui sum migration_conakry if treatment_status == `i' & time == 2  
			
			local row =  `i' 
			di `row'
			mat R[`row',1]=`r(mean)'*100
			mat R[`row',2]= 2
			mat R[`row',3]=`i'
			mat R[`row',4]=`row'
			mat R[`row',5]=(`r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)'))*100
			mat R[`row',6]=(`r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)'))*100
		
		
	}
	
	
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
*label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
*label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 1, bcolor(black) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 2, bcolor(yellow) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 3, bcolor(blue) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 4, bcolor(red) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(rcap R6 R5 R4, lc(gs5)) , ///
	graphregion(color(white)) ///
	ylabel(0(1)8) ///
	legend(off) ///
	text(-0.5 2.5 "Enquête 2")  ///
	xlabel(, nolabels) ///
	xtitle("") ///
	ytitle("Pourcentage d'étudiants qui ont quitté la Conakry")
	
	/*
		, ///
	 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	
	 */
	graph save Graph ${main}/Draft/figures/differencesconakry.gph, replace
	graph export ${main}/Draft/figures/differencesconakry.png, replace

restore



local n_rows = 4
mat R=J(`n_rows',6,.)

local n = 0

forval i = 1/4 {
		qui sum migration_guinea if treatment_status == `i' & time == 2  
			
			local row =  `i' 
			di `row'
			mat R[`row',1]=`r(mean)'*100
			mat R[`row',2]= 2
			mat R[`row',3]=`i'
			mat R[`row',4]=`row'
			mat R[`row',5]=(`r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)'))*100
			mat R[`row',6]=(`r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)'))*100
		
		
	}
	
	
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
*label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
*label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 1, bcolor(black) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 2, bcolor(yellow) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 3, bcolor(blue) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 4, bcolor(red) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(rcap R6 R5 R4, lc(gs5)) , ///
	graphregion(color(white)) ///
	ylabel(0(0.5)3) ///
	legend(off) ///
	text(-0.2 2.5 "Enquête 2")  ///
	xlabel(, nolabels) ///
	xtitle("") ///
	ytitle("Pourcentage d'étudiants qui ont quitté Guinée")
	
	/*
		, ///
	 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	
	 */
	graph save Graph ${main}/Draft/figures/differencesguinea.gph, replace
	graph export ${main}/Draft/figures/differencesguinea.png, replace

restore

*/




local n_outcomes `: word count $migration_outcomes'
local n_rows = 5*3
mat R=J(`n_rows',6,.)

local n = 0

forval i = 1/4 {
	forval t = 0/2 {
		qui sum economic_index if treatment_status == `i' & time == `t'   
			
			local row = 5*(`t') + `i' 
			di `row'
			mat R[`row',1]=`r(mean)'
			mat R[`row',2]=`t'
			mat R[`row',3]=`i'
			mat R[`row',4]=`row'
			mat R[`row',5]=(`r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)'))
			mat R[`row',6]=(`r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)'))
		
		}
	}
	
	
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
*label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
*label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 1, bcolor(black) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 2, bcolor(yellow) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 3, bcolor(blue) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 4, bcolor(red) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(rcap R6 R5 R4, lc(gs5)) , ///
	graphregion(color(white)) ///
	ylabel(-0.4(0.1)0.4) ///
	legend(off) ///
	text(-0.45 2.5 "Enquête 0") text(-0.45 7.5 "Enquête 1") text(-0.45 12.5 "Enquête 2") ///
	xlabel(, nolabels) ///
	xtitle("") ///
	ytitle("Perceptions des opportunitées economiques en Europe")
	
	/*
		, ///
	 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	
	 */
	graph save Graph ${main}/Draft/figures/differenceseconomic.gph, replace
	graph export ${main}/Draft/figures/differenceseconomic.png, replace

restore



local n_outcomes `: word count $migration_outcomes'
local n_rows = 5*3
mat R=J(`n_rows',6,.)

local n = 0

forval i = 1/4 {
	forval t = 0/2 {
		qui sum italy_index if treatment_status == `i' & time == `t'   
			
			local row = 5*(`t') + `i' 
			di `row'
			mat R[`row',1]=`r(mean)'
			mat R[`row',2]=`t'
			mat R[`row',3]=`i'
			mat R[`row',4]=`row'
			mat R[`row',5]=(`r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)'))
			mat R[`row',6]=(`r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)'))
		
		}
	}
	
	
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
*label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
*label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 1, bcolor(black) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 2, bcolor(yellow) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 3, bcolor(blue) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(bar R1 R4 if R3 == 4, bcolor(red) barw(0.6) fi(inten80) lc(black) lw(medium)  ) ///
	(rcap R6 R5 R4, lc(gs5)) , ///
	graphregion(color(white)) ///
	ylabel(-0.4(0.1)0.4) ///
	legend(off) ///
	text(-0.48 2.5 "Enquête 0") text(-0.48 7.5 "Enquête 1") text(-0.48 12.5 "Enquête 2") ///
	xlabel(, nolabels) ///
	xtitle("") ///
	ytitle("Perceptions des risques du voyage")
	
	/*
		, ///
	 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.03) ///
	
	 */
	graph save Graph ${main}/Draft/figures/differencesrisk.gph, replace
	graph export ${main}/Draft/figures/differencesrisk.png, replace

restore

stop


/*

gen treatment_status_1 = treatment_status == 1
gen treatment_status_2 = treatment_status == 2
gen treatment_status_3 = treatment_status == 3
gen treatment_status_4 = treatment_status == 4



********************************BALANCE TABLE BY DURABLES***********************************
preserve
keep if time == 0

*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index durables50 fees50sch " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"
balancetable (mean if durables50==0)  ///
	(diff durables50) ///
	$bc_var using "balancetable_strat_bydurables.tex",  ///
	longtable nonumbers ctitles("Low Durables" "High-Low") ///
	replace varlabels vce(cluster schoolid) cov(strata) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Differences in Observables by Durables \label{balancetabledur}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\multicolumn{4}{l}{\(+\) \(p<0.1\), \(*\) \(p<0.05\), \(**\) \(p<0.01\), \(***\) \(p<0.001\).} \\" "\end{longtable}")
	 
restore

********************************BALANCE TABLE BY FEES50SCH***********************************
preserve
keep if time == 0

*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index durables50 fees50sch " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"
balancetable (mean if fees50sch==0)  ///
	(diff fees50sch) ///
	$bc_var using "balancetable_strat_byfees.tex",  ///
	longtable nonumbers ctitles("Low Fees" "High-Low") ///
	replace varlabels vce(cluster schoolid) cov(strata) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Differences in Observables by Fees \label{balancetablefees}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\multicolumn{4}{l}{\(+\) \(p<0.1\), \(*\) \(p<0.05\), \(**\) \(p<0.01\), \(***\) \(p<0.001\).} \\" "\end{longtable}")
	 
restore





********************************BALANCE TABLE***********************************
preserve
keep if time == 0

*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index durables50 fees50sch " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"
balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if (treatment_status == 1 | treatment_status == 2)) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_strat.tex",  ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) cov(strata) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table \label{balancetable}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\multicolumn{4}{l}{\(+\) \(p<0.1\), \(*\) \(p<0.05\), \(**\) \(p<0.01\), \(***\) \(p<0.001\).} \\" "\end{longtable}")
	 
restore


********************************BALANCE TABLE HIGH FEES***********************************
preserve
keep if time == 0 & fees50sch == 1

*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index durables50 fees50 " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"
balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if (treatment_status == 1 | treatment_status == 2)) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_strat_highfees.tex",  ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) cov(strata) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table (Only High Fees) \label{balancetablehighfees}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\multicolumn{4}{l}{\(+\) \(p<0.1\), \(*\) \(p<0.05\), \(**\) \(p<0.01\), \(***\) \(p<0.001\).} \\" "\end{longtable}")
	 
restore


********************************BALANCE TABLE LOW FEES***********************************
preserve
keep if time == 0 & fees50sch == 0

*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index durables50 fees50 " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"
balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if (treatment_status == 1 | treatment_status == 2)) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_strat_lowfees.tex",  ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) cov(strata) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table (Only Low Fees) \label{balancetablelowfees}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\multicolumn{4}{l}{\(+\) \(p<0.1\), \(*\) \(p<0.05\), \(**\) \(p<0.01\), \(***\) \(p<0.001\).} \\" "\end{longtable}")
	 
restore



********************************BALANCE TABLE HIGH DUABLES***********************************
preserve
keep if time == 0 & durables50 == 1

*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index durables50 fees50 " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"
balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if (treatment_status == 1 | treatment_status == 2)) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_strat_highdurables.tex",  ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) cov(strata) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table (Only High Durables) \label{balancetablehighdurables}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\multicolumn{4}{l}{\(+\) \(p<0.1\), \(*\) \(p<0.05\), \(**\) \(p<0.01\), \(***\) \(p<0.001\).} \\" "\end{longtable}")
	 
restore


********************************BALANCE TABLE LOW DURABLES***********************************
preserve
keep if time == 0 & durables50 == 0

*variable for the balance
global bc_var = " strata_n2 gender age moth_school fath_school wealth_index durables50 fees50 " ///
				+ " outside_contact_no mig_classmates desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help"
balancetable (mean if treatment_status==1)  ///
	(diff treatment_status_2 if (treatment_status == 1 | treatment_status == 2)) ///
	(diff treatment_status_3 if ( treatment_status == 1 | treatment_status == 3)) ///
	(diff treatment_status_4 if (treatment_status == 1 | treatment_status == 4)) ///
	$bc_var using "balancetable_strat_lowdurables.tex",  ///
	longtable nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) cov(strata) ///
	prehead(\begin{longtable}{l*{4}c} \caption{Balance Table (Only Low Durables) \label{balancetablelowdurables}}\\  \hline \hline) ///
	 postfoot("\hline" "\multicolumn{4}{l}{$^{(1)}$ Obtained as average of routes through Italy and Spain.} \\" "\multicolumn{4}{l}{Errors clustered at school level, stratum dummy included as control.} \\"  "\multicolumn{4}{l}{\(+\) \(p<0.1\), \(*\) \(p<0.05\), \(**\) \(p<0.01\), \(***\) \(p<0.001\).} \\" "\end{longtable}")
	 
restore







global outcomes = " desire planning prepare " ///
				+ " asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_die_boat italy_die_bef_boat " ///
				+ " asinhspain_duration asinhspain_journey_cost spain_beaten spain_die_boat spain_die_bef_boat " ///
				+ "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help "
				
global controls = " school_size gender age moth_school fath_school wealth_index wealth_index durables50 fees50sch outside_contact_no mig_classmates"

**************************ATTRITION, INDIVIDUAL DATA****************************
*without interactions

preserve
drop if time == 2
duplicates tag id_number, generate(duplic1)
gen lost1 = duplic1 == 0
keep if time == 0

reg lost1 i.treatment_status i.strata, cluster(schoolid)
est sto reg1

reg lost1 i.treatment_status  i.strata $outcomes, cluster(schoolid)
est sto reg2

reg lost1 i.treatment_status i.strata $outcomes $controls , cluster(schoolid)
est sto reg3

*with interactions


esttab reg1 reg2 reg3 using ///
	"attritionclusterfu1.tex", replace ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treatment" 3.treatment_status "Economic Treatment" ///
	4.treatment_status "Double Treatment" ///
	1.treatment_status#c.planning "Control X Planning" ///
	2.treatment_status#c.planning "Risk X Planning" ///
	3.treatment_status#c.planning "Econ X Planning" ///
	4.treatment_status#c.planning "Double X Planning" ///
	2.strata "Big school") nomtitles ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers title("Attrited at \(1^{st}\) follow-up, treatment and controls \label{attritioncluster}") /// 
	mgroups(" 1 = Attrited at follow-up" , pattern(1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span ) nobaselevels se ///
	postfoot("\hline\hline \multicolumn{4}{p{15cm}}{\footnotesize Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{longtable} }") longtable label


	
restore

stop

********************PARTICIPATION BY STAGE AND TREATMENT ARM********************

*baseline

m: obs = J(17,5,.)

qui count if treatment_status == 1 & time == 0
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 0
local N3 = `r(N)'

qui count if treatment_status == 3 & time == 0
local N4 = `r(N)'

qui count if treatment_status == 4 & time == 0
local N5 = `r(N)'

m: obs[1,2] = strtoreal(st_local("N2"))
m: obs[1,3] = strtoreal(st_local("N3"))
m: obs[1,4] = strtoreal(st_local("N4"))
m: obs[1,5] = strtoreal(st_local("N5"))
m: obs[1,1] = obs[1,2] + obs[1,3] + obs[1,4] + obs[1,5]

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


*fist follow-up


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

m: obs[4,2] = strtoreal(st_local("N2"))
m: obs[4,3] = strtoreal(st_local("N3"))
m: obs[4,4] = strtoreal(st_local("N4"))
m: obs[4,5] = strtoreal(st_local("N5"))
m: obs[4,1] = obs[4,2] + obs[4,3] + obs[4,4] + obs[4,5]

m: obs[5,1] = round(obs[4,1]/obs[1,1], .001)
m: obs[5,2] = round(obs[4,2]/obs[1,2], .001)
m: obs[5,3] = round(obs[4,3]/obs[1,3], .001)
m: obs[5,4] = round(obs[4,4]/obs[1,4], .001)
m: obs[5,5] = round(obs[4,5]/obs[1,5], .001)


* second follow-up


qui count if treatment_status == 1 & time == 2 & migration_guinea != .
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 2 & migration_guinea != .
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 2 & migration_guinea != .
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 2 & migration_guinea != .
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[6,2] = strtoreal(st_local("N2"))
m: obs[6,3] = strtoreal(st_local("N3"))
m: obs[6,4] = strtoreal(st_local("N4"))
m: obs[6,5] = strtoreal(st_local("N5"))
m: obs[6,1] = obs[6,2] + obs[6,3] + obs[6,4] + obs[6,5]

m: obs[7,1] = round(obs[6,1]/obs[1,1], .001)
m: obs[7,2] = round(obs[6,2]/obs[1,2], .001)
m: obs[7,3] = round(obs[6,3]/obs[1,3], .001)
m: obs[7,4] = round(obs[6,4]/obs[1,4], .001)
m: obs[7,5] = round(obs[6,5]/obs[1,5], .001)



* second follow-up tablet


qui count if treatment_status == 1 & time == 2 & surveycto_lycee == 1
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 2 & surveycto_lycee == 1
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 2 & surveycto_lycee == 1
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 2 & surveycto_lycee == 1
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[8,2] = strtoreal(st_local("N2"))
m: obs[8,3] = strtoreal(st_local("N3"))
m: obs[8,4] = strtoreal(st_local("N4"))
m: obs[8,5] = strtoreal(st_local("N5"))
m: obs[8,1] = obs[8,2] + obs[8,3] + obs[8,4] + obs[8,5]

m: obs[9,1] = round(obs[8,1]/obs[1,1], .001)
m: obs[9,2] = round(obs[8,2]/obs[1,2], .001)
m: obs[9,3] = round(obs[8,3]/obs[1,3], .001)
m: obs[9,4] = round(obs[8,4]/obs[1,4], .001)
m: obs[9,5] = round(obs[8,5]/obs[1,5], .001)





* second follow up subject


qui count if treatment_status == 1 & time == 2 & source_info_guinea <= 1
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 2 &  source_info_guinea <= 1
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 2 &  source_info_guinea <= 1
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 2 &  source_info_guinea <= 1
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[10,2] = strtoreal(st_local("N2"))
m: obs[10,3] = strtoreal(st_local("N3"))
m: obs[10,4] = strtoreal(st_local("N4"))
m: obs[10,5] = strtoreal(st_local("N5"))
m: obs[10,1] = obs[10,2] + obs[10,3] + obs[10,4] + obs[10,5]

m: obs[11,1] = round(obs[10,1]/obs[1,1], .001)
m: obs[11,2] = round(obs[10,2]/obs[1,2], .001)
m: obs[11,3] = round(obs[10,3]/obs[1,3], .001)
m: obs[11,4] = round(obs[10,4]/obs[1,4], .001)
m: obs[11,5] = round(obs[10,5]/obs[1,5], .001)





* second follow up contact


qui count if treatment_status == 1 & time == 2 & source_info_guinea <= 2
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 2 &  source_info_guinea <= 2
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 2 &  source_info_guinea <= 2
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 2 &  source_info_guinea <= 2
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[12,2] = strtoreal(st_local("N2"))
m: obs[12,3] = strtoreal(st_local("N3"))
m: obs[12,4] = strtoreal(st_local("N4"))
m: obs[12,5] = strtoreal(st_local("N5"))
m: obs[12,1] = obs[12,2] + obs[12,3] + obs[12,4] + obs[12,5]

m: obs[13,1] = round(obs[12,1]/obs[1,1], .001)
m: obs[13,2] = round(obs[12,2]/obs[1,2], .001)
m: obs[13,3] = round(obs[12,3]/obs[1,3], .001)
m: obs[13,4] = round(obs[12,4]/obs[1,4], .001)
m: obs[13,5] = round(obs[12,5]/obs[1,5], .001)



* second follow up school info


qui count if treatment_status == 1 & time == 2 & source_info_guinea <= 5
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 2 &  source_info_guinea <= 5
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 2 &  source_info_guinea <= 5
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 2 &  source_info_guinea <= 5
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[14,2] = strtoreal(st_local("N2"))
m: obs[14,3] = strtoreal(st_local("N3"))
m: obs[14,4] = strtoreal(st_local("N4"))
m: obs[14,5] = strtoreal(st_local("N5"))
m: obs[14,1] = obs[14,2] + obs[14,3] + obs[14,4] + obs[14,5]

m: obs[15,1] = round(obs[14,1]/obs[1,1], .001)
m: obs[15,2] = round(obs[14,2]/obs[1,2], .001)
m: obs[15,3] = round(obs[14,3]/obs[1,3], .001)
m: obs[15,4] = round(obs[14,4]/obs[1,4], .001)
m: obs[15,5] = round(obs[14,5]/obs[1,5], .001)




* second follow up phone status


qui count if treatment_status == 1 & time == 2 & source_info_guinea <= 5
local N2 = `r(N)'

qui count if treatment_status == 2 & time == 2 &  source_info_guinea <= 5
local N3 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 2) 
local t = _b[treatment_status]/_se[treatment_status]
local p3 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 3 & time == 2 &  source_info_guinea <= 5
local N4 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 3) 
local t = _b[treatment_status]/_se[treatment_status]
local p4 =2*ttail(e(df_r),abs(`t'))

qui count if treatment_status == 4 & time == 2 &  source_info_guinea <= 5
local N5 = `r(N)'

qui reg duplic treatment_status if (treatment_status == 1 | treatment_status == 4) 
local t = _b[treatment_status]/_se[treatment_status]
local p5 =2*ttail(e(df_r),abs(`t'))

m: obs[16,2] = strtoreal(st_local("N2"))
m: obs[16,3] = strtoreal(st_local("N3"))
m: obs[16,4] = strtoreal(st_local("N4"))
m: obs[16,5] = strtoreal(st_local("N5"))
m: obs[16,1] = obs[16,2] + obs[16,3] + obs[16,4] + obs[16,5]

m: obs[17,1] = round(obs[16,1]/obs[1,1], .001)
m: obs[17,2] = round(obs[16,2]/obs[1,2], .001)
m: obs[17,3] = round(obs[16,3]/obs[1,3], .001)
m: obs[17,4] = round(obs[16,4]/obs[1,4], .001)
m: obs[17,5] = round(obs[16,5]/obs[1,5], .001)


m: st_matrix("obs", obs)
matrix colnames obs = `" "All"" Control" "Risk" "Econ" "Double" "'
matrix rownames obs = `" "Basel."   "Treated" "Fract.  Basel."  "FU1 (tablet)" "Fract.  Basel."  "FU2" "Fract. Basel."  "FU2 (tablet)" "Fract.  Basel." "'

outtable  using attrition, mat(obs) nobox replace caption("Table attrition number of observations by treatment arm and round \label{attrition}") format(%9.3g)

stop

*/

**OUT OF GUINEA
forval info = 1/6 {
	qui reg f2.migration_guinea i.treatment_status strata if f2.source_info_guinea <= `info', cluster(schoolid)
	qui sum migration_guinea if source_info_guinea <= `info' & time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`info'
}

esttab reg1 reg2 reg5 reg6 using ///
"outguinea_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Out of Guinea at $2^{nd}$ F. U. \label{outguineafu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ St. + Adm.  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ Phone On  }")  nobaselevels 
eststo clear 


**OUT OF CONAKRY
forval info = 1/6 {
	qui reg f2.migration_conakry i.treatment_status strata if f2.source_info_conakry <= `info', cluster(schoolid)
	qui sum migration_conakry if source_info_conakry <= `info' & time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`info'
}

esttab reg1 reg2 reg5 reg6 using ///
"outconakry_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Out of Conakry at $2^{nd}$ F. U. \label{outconakryfu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ St. + Adm.  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ Phone On  }")  nobaselevels 
eststo clear 




**OUT OF GUINEA INTERACTED WITH FEES
forval info = 1/6 {
	qui reg f2.migration_guinea i.treatment_status##i.fees50sch strata if f2.source_info_guinea <= `info', cluster(schoolid)
	forval i = 2/4 {
		qui lincom `i'.treatment_status + `i'.treatment_status#1.fees50sch
		local p`i' = `r(p)'
		local se`i' = `r(se)'
	}
	matrix selincom = [`se2' , `se3', `se4']
	matrix plincom = [`p2' , `p3', `p4']
	matrix colnames selincom = 2.treatment_status#1.fees50sch 3.treatment_status#1.fees50sch 4.treatment_status#1.fees50sch
	matrix colnames plincom = 2.treatment_status#1.fees50sch 3.treatment_status#1.fees50sch 4.treatment_status#1.fees50sch
	estadd matrix selincom = selincom
	estadd matrix plincom = plincom
	qui sum migration_guinea if source_info_guinea <= `info' & time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`info'
}

esttab reg1 reg2 reg5 reg6 using ///
"outguineafees50_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Out of Guinea at $2^{nd}$ F. U. Interacted with High Fees Dummy \label{outguineafees50fu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ Stud. + Adm.  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ Phone On  }")  nobaselevels 
eststo clear 



**OUT OF CONAKRY INTERACTED WITH FEES
forval info = 1/6 {
	qui reg f2.migration_conakry i.treatment_status##i.fees50sch strata if f2.source_info_conakry <= `info', cluster(schoolid)
	forval i = 2/4 {
		qui lincom `i'.treatment_status + `i'.treatment_status#1.fees50sch
		local p`i' = `r(p)'
		local se`i' = `r(se)'
	}
	matrix selincom = [`se2' , `se3', `se4']
	matrix plincom = [`p2' , `p3', `p4']
	matrix colnames selincom = 2.treatment_status#1.fees50sch 3.treatment_status#1.fees50sch 4.treatment_status#1.fees50sch
	matrix colnames plincom = 2.treatment_status#1.fees50sch 3.treatment_status#1.fees50sch 4.treatment_status#1.fees50sch
	estadd matrix selincom = selincom
	estadd matrix plincom = plincom
	qui sum migration_conakry if source_info_conakry <= `info' & time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`info'
}

esttab reg1 reg2 reg5 reg6 using ///
"outconakryfees50_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Out of Conakry at $2^{nd}$ F. U. Interacted with High Fees Dummy \label{outconakryfees50fu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ Stud. + Adm.  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ Phone On  }")  nobaselevels 
eststo clear





**MIGRATION INTENTIONS INTERACTED WITH FEES
global intentions "desire planning prepare"
local counter = 0
foreach variab in $intentions {
	local counter = `counter' +1
	gen y = `variab'
	qui reg f2.y i.treatment_status##i.fees50sch y strata, cluster(schoolid)
	forval i = 2/4 {
		qui lincom `i'.treatment_status + `i'.treatment_status#1.fees50sch
		local p`i' = `r(p)'
		local se`i' = `r(se)'
	}
	matrix selincom = [`se2' , `se3', `se4']
	matrix plincom = [`p2' , `p3', `p4']
	matrix colnames selincom = 2.treatment_status#1.fees50sch 3.treatment_status#1.fees50sch 4.treatment_status#1.fees50sch
	matrix colnames plincom = 2.treatment_status#1.fees50sch 3.treatment_status#1.fees50sch 4.treatment_status#1.fees50sch
	estadd matrix selincom = selincom
	estadd matrix plincom = plincom
	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`counter'
	drop y
}

esttab reg1 reg2 reg3 using ///
"migrationintentionsfees_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Migration Intentions at $2^{nd}$ F. U. Interacted with High Fees Dummy \label{migrationintentionsfeesfu2}) /// 
coeflabels(y "Outcome at Basel.") ///
mtitles("\shortstack{(1) \\ Wish \\ to \\ Migrate }" ///
	"\shortstack{(2) \\  Planning \\ to \\ Migrate  }" ///
	"\shortstack{(3) \\  Prepare \\ to \\ Migrate }")  nobaselevels 
eststo clear



**OUT OF GUINEA INTERACTED WITH DURABLES
forval info = 1/6 {
	qui reg f2.migration_guinea i.treatment_status##i.durables50 strata if f2.source_info_guinea <= `info', cluster(schoolid)
	forval i = 2/4 {
		qui lincom `i'.treatment_status + `i'.treatment_status#1.durables50
		local p`i' = `r(p)'
		local se`i' = `r(se)'
	}
	matrix selincom = [`se2' , `se3', `se4']
	matrix plincom = [`p2' , `p3', `p4']
	matrix colnames selincom = 2.treatment_status#1.durables50 3.treatment_status#1.durables50 4.treatment_status#1.durables50
	matrix colnames plincom = 2.treatment_status#1.durables50 3.treatment_status#1.durables50 4.treatment_status#1.durables50
	estadd matrix selincom = selincom
	estadd matrix plincom = plincom
	qui sum migration_guinea if source_info_guinea <= `info' & time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`info'
}

esttab reg1 reg2 reg5 reg6 using ///
"outguineadurables50_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Out of Guinea at $2^{nd}$ F. U. Interacted with High Durables Dummy \label{outguineafees50fu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ Stud. + Adm.  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ Phone On  }")  nobaselevels 
eststo clear 



**OUT OF CONAKRY INTERACTED WITH DURABLES
forval info = 1/6 {
	qui reg f2.migration_conakry i.treatment_status##i.durables50 strata if f2.source_info_conakry <= `info', cluster(schoolid)
	forval i = 2/4 {
		qui lincom `i'.treatment_status + `i'.treatment_status#1.durables50
		local p`i' = `r(p)'
		local se`i' = `r(se)'
	}
	matrix selincom = [`se2' , `se3', `se4']
	matrix plincom = [`p2' , `p3', `p4']
	matrix colnames selincom = 2.treatment_status#1.durables50 3.treatment_status#1.durables50 4.treatment_status#1.durables50
	matrix colnames plincom = 2.treatment_status#1.durables50 3.treatment_status#1.durables50 4.treatment_status#1.durables50
	estadd matrix selincom = selincom
	estadd matrix plincom = plincom
	qui sum migration_conakry if source_info_conakry <= `info' & time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`info'
}

esttab reg1 reg2 reg5 reg6 using ///
"outconakrydurables50_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Out of Conakry at $2^{nd}$ F. U. Interacted with High Durables Dummy \label{outconakryfees50fu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ Stud. + Adm.  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ Phone On  }")  nobaselevels 
eststo clear




**MIGRATION INTENTIONS INTERACTED WITH DURABLES
global intentions "desire planning prepare"
local counter = 0
foreach variab in $intentions {
	local counter = `counter' +1
	gen y = `variab'
	qui reg f2.y i.treatment_status##i.durables50 y strata, cluster(schoolid)
	forval i = 2/4 {
		qui lincom `i'.treatment_status + `i'.treatment_status#1.durables50
		local p`i' = `r(p)'
		local se`i' = `r(se)'
	}
	matrix selincom = [`se2' , `se3', `se4']
	matrix plincom = [`p2' , `p3', `p4']
	matrix colnames selincom = 2.treatment_status#1.durables50 3.treatment_status#1.durables50 4.treatment_status#1.durables50
	matrix colnames plincom = 2.treatment_status#1.durables50 3.treatment_status#1.durables50 4.treatment_status#1.durables50
	estadd matrix selincom = selincom
	estadd matrix plincom = plincom
	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	est sto reg`counter'
	drop y
}

esttab reg1 reg2 reg3 using ///
"migrationintentionsdurables_fu2.tex", replace cells(b(fmt(a2) star) ///
 se(par fmt(a2) )  ///
 plincom(fmt(a2) par([ ]) star pvalue(plincom) )) stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
  coeflabels(y "Outcome at Basel.") ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) collabels(,none) label ///
nonumbers title(Migration Intentions at $2^{nd}$ F. U. Interacted with High Durables Dummy \label{migrationintentionsdurablesfu2}) /// 
mtitles("\shortstack{(1) \\ Wish \\ to \\ Migrate }" ///
	"\shortstack{(2) \\  Planning \\ to \\ Migrate  }" ///
	"\shortstack{(3) \\  Prepare \\ to \\ Migrate }")  nobaselevels 
eststo clear

