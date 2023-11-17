clear all

set more off

*global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"
global main "/home/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"

*use ${main}/Data/output/followup2/BME_final.dta
use "/home/giacomobattiston/Downloads/BME_final.dta"

global logs ${main}/logfiles/
global dta ${main}/Data/dta/

cd "${main}/Draft/tables"

tsset id_number time

global mainvars  "i.treatment_status i.strata" 
local demographics "grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win"
local school_char  "fees50 ratio_female_lycee rstudteach rstudclass" 

							
local n_rep 1

/*
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



/*

*MIGRATION (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
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
			qui reg f2.migration_guinea x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_any
			qui ivreg2 f2.migration_guinea (x = treated) ///
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

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
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
			qui reg f2.migration_guinea i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x = i.treatment_status) ///
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
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table3b.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  N meandep, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

	
*MIGRATION WITHOUT VISA (restricted sample)

eststo clear

qui sum migration_novisa if l2.treatment_status == 1  &  source_info_guinea < 6
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
			qui reg f2.migration_novisa i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_novisa (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		estadd scalar meandep = `meandep'
			
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

qui sum migration_visa if l2.treatment_status == 1  &  source_info_guinea < 6
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
			qui reg f2.migration_visa i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_visa (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		estadd scalar meandep = `meandep'
			
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

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {

		if `i_inter' == 1 {
			gen inter = durables50
		}
		
		if `i_inter' == 2 {
			gen inter = bank_account
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea i.x i.x#i.inter i.inter  strata  `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) ///
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
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_inter'_`i_est'
		
		drop inter

		
	}
}

esttab reg* using table5.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.inter "\(T1\) - Risk \(*\) High SES" 3.x#1.inter "\(T2\) - Econ \(*\) SES" 4.x#1.inter "\(T3\) - Double \(*\) SES" ///
	1.inter "High SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) High SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) High SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) High SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \shortstack{Socioeconomic status \\ measured by durables index}   }&\multicolumn{2}{c}{\shortstack{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers
	
	
	
	
*INTERNAL MIGRATION (restricted sample)

eststo clear

qui sum migration_internal if l2.treatment_status == 1  &  source_info_guinea < 6 & source_info_conakry < 6
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
			qui reg f2.migration_internal i.x strata `controls' ///
				if f2.source_info_guinea < 6 & f2.source_info_conakry < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_internal (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		estadd scalar meandep = `meandep'
			
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


	
*MIGRATION BY PESSIMISTIC BELIEFS (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
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
			qui reg f2.migration_guinea i.x i.x#i.pessimistic i.italy_pessimistic i.econ_pessimistic  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x i.x#i.pessimistic = i.treatment_status i.treatment_status#i.pessimistic) ///
				i.italy_pessimistic i.econ_pessimistic strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.pessimistic
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.pessimistic
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.pessimistic
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table8.tex, replace keep(2.x 3.x 4.x 2.x#1.pessimistic 3.x#1.pessimistic 4.x#1.pessimistic 1.italy_pessimistic 1.econ_pessimistic) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.pessimistic "\(T1\) - Risk \(*\) Pessimistic beliefs" 3.x#1.pessimistic "\(T2\) - Econ \(*\) Pessimistic beliefs" 4.x#1.pessimistic "\(T3\) - Double \(*\) Pessimistic beliefs" ///
	1.italy_pessimistic "Pessimistic risk beliefs" 1.econ_pessimistic "Pessimistic econ beliefs" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Pessimistic beliefs = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Pessimistic beliefs = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Pessimistic beliefs = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")
	

	
*MIGRATION

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
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
	qui reg f2.migration_guinea i.x strata `controls' ///
		if f2.source_info_guinea < 6, cluster(schoolid)
	drop x

	
	estadd local individual = "`individual'"
	estadd local school = "`school'"
	
	estadd scalar meandep = `meandep'
		
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

	
	
*MIGRATION INTENTIONS FU2 (restricted sample)



eststo clear
		
local outcomes "desire planning prepare"
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
		qui reg f2.y x strata `controls'  y ///
			if  attended_tr != ., cluster(schoolid)
		
		drop x
		drop y
					
		eststo reg`var'_`i_con'

		
	}
}

esttab reg* using apptable8a.tex, replace keep(x) ///
	coeflabels(x "Any treatment")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
	mgroups("Wishing to migrate" "Planning to migrate" "Preparing to migrate", pattern(1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers   noobs /// 
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  & & & &  \\ [1em]") prefoot("\hline") postfoot(" ") ///
	nonumbers 
	

eststo clear


local outcomes "desire planning prepare"
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
		qui reg f2.y i.x strata `controls'  y ///
			if  attended_tr != ., cluster(schoolid)
		
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
				
		estadd scalar meandep = `meandep'
			
		eststo reg`var'_`i_con'

		
	}
}

esttab reg* using apptable8b.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	y "Intends to migrate" strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  N meandep, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

	
		
*MIGRATION INTENTIONS FU1 (restricted sample)


eststo clear
		
local outcomes "desire planning prepare"
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
	prehead("{ \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{9}{c}} \hline\hline  &\multicolumn{9}{c}{y = intending to migrate from Guinea} \\            &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}&\multicolumn{1}{c}{(8)}&\multicolumn{1}{c}{(9)} \\ \cmidrule(lr){2-10} &    \multicolumn{3}{c}{  \shortstack{Wishing to migrate}}&\multicolumn{3}{c}{\shortstack{Planning to migrate}}&\multicolumn{3}{c}{\shortstack{Preparing to migrate}}  \\  \cmidrule(lr){2-4} \cmidrule(lr){5-7} \cmidrule(lr){8-10}")  ///
	nonumbers   noobs /// 
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  & & & &  \\ [1em]") prefoot("\hline") postfoot(" ")  


eststo clear


local outcomes "desire planning prepare"
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
				
		estadd scalar meandep = `meandep'
			
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
		
		estadd scalar meandep = `meandep'
			
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
	
	
	
*MIGRATION BY PESSIMISTIC BELIEFS (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
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
			qui reg f2.migration_guinea i.x i.x#i.pessimistic_weak i.italy_pessimistic i.econ_pessimistic  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x i.x#i.pessimistic_weak = i.treatment_status i.treatment_status#i.pessimistic_weak) ///
				i.italy_pessimistic i.econ_pessimistic strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.pessimistic_weak
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.pessimistic_weak
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.pessimistic_weak
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using apptable12.tex, replace keep(2.x 3.x 4.x 2.x#1.pessimistic_weak 3.x#1.pessimistic_weak 4.x#1.pessimistic_weak 1.italy_pessimistic 1.econ_pessimistic) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" ///
	2.x#1.pessimistic_weak "\(T1\) - Risk \(*\) Pessimistic beliefs" 3.x#1.pessimistic_weak "\(T2\) - Econ \(*\) Pessimistic beliefs" 4.x#1.pessimistic_weak "\(T3\) - Double \(*\) Pessimistic beliefs" ///
	1.italy_pessimistic "Pessimistic risk beliefs" 1.econ_pessimistic "Pessimistic econ beliefs" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Pessimistic beliefs = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Pessimistic beliefs = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Pessimistic beliefs = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")
	

*MIGRATION (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & !missing(l1.time) 
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
			qui reg f2.migration_guinea i.x strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & !missing(f1.time) , cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & !missing(f1.time) , cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		estadd scalar meandep = `meandep'
			
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

*/
	
*risk outcomes at fu2

global economic_titles = `" " \shortstack{(1)\\ Finding \\ Job \\ \vphantom{foo}} " "' ///
			+ `" "\shortstack{(2)\\ Wage \\ abroad \\ \vphantom{foo}}" "' ///
			+ `" "\shortstack{(3)\\ Contin. \\ studies \\ abroad}" "' ///
			+ `" "\shortstack{(4) \\ Getting \\ asylum \\ \vphantom{foo}}" "' ///
			+ `" "\shortstack{(5)\\ Becom. \\ Citiz. \\ \vphantom{foo}}" "' ///
			+ `" "\shortstack{(6)\\ Return \\ before \\ 5 yrs}" "' ///
			+ `" "\shortstack{(7)\\ Getting \\ public \\ transf. }""' ///
			+ `" "\shortstack{(8) \\  Cost of \\ living \\ abroad}" "' ///
			+ `" "\shortstack{(9) \\ Host \\ country \\ attit.}" "' ///
			+ `" "\shortstack{(10) \\ PCA \\ Econ \\ Index}" "' 
											
								
global appendix_table_titles =  `" "\shortstack{(1) \\ Kling \\ Cost- \\ Ita }" "'  ///
								+ `" "\shortstack{(2) \\ Kling \\ Cost+ \\ Ita }" "' ///
								+ `" "\shortstack{(3) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\shortstack{(4) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\shortstack{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				
			

global risks_table_titles = `" " \shortstack{(1) \\ Journey \\ Duration \\ \vphantom{foo}}" "' ///
				+ `" " \shortstack{(2)\\ Being \\ Beaten \\ \vphantom{foo}}" "' ///
				+ `" "\shortstack{(3)\\ Forced \\  to \\ Work}" "' /// 
				+ `" " \shortstack{(4) \\ Journey\\ Cost \\ \vphantom{foo}}" "' ///
				+ `" "\shortstack{(5) \\ Being \\ Kidnap- \\ ped}" "' ///
				+ `" "\shortstack{(6)\\ Death \\ before \\ boat}" "' ///
				+ `" "\shortstack{(7)\\ Death \\ in \\ boat}" "' /// 
				+ `" "\shortstack{(8)\\ Sent \\ Back \\ \vphantom{foo}}" "' ///
				+ `" "\shortstack{(9) \\ PCA \\ Risk \\ Index}" "' 


				
/*
global routes_list = "Italy Spain"

global appendix_reg " "

foreach route_u in $routes_list {
	
	*est clear
	
	local route = lower("`route_u'")
	
	di "`route'"
	
	global winsor = "`route'_duration `route'_journey_cost"
		
	global main_reg " "
		
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	

	global `route'_outcomes_bl " "
	foreach var in $`route'_outcomes {
		gen l2`var' = l2.`var'
		global `route'_outcomes_bl $`route'_outcomes_bl " l2`var'"
	}

	local n_outcomes `: word count $`route'_outcomes'

	* run all regressions and store results 
	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}

	
	preserve
	drop if time == 2 & l2.attended_tr == .
	drop if time == 0 & attended_tr == .
	
	wyoung $`route'_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($`route'_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	matrix define results = r(table)
	esttab matrix(results) using table9`route'.xls, nomtitles replace

	matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
	matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
	matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	restore
	
	***********************************KLING***********************************
	
								
	global `route'_outcomes $`route'_outcomes  `" `route'_index "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_poscost "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_negcost "'

	local n_outcomes `: word count $`route'_outcomes'
	
	global risks_plot_list " "
	global risks_plot_noasinh_list " "

	local n_rows = (`n_outcomes' - 5)*3
	mat R=J(`n_rows',5,.)

	local n = 0
	local ng = 0

	foreach y in $`route'_outcomes {

		local n = `n' + 1
		
		if (`n' < 9) {
		matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
		matrix colnames pfwer = 2.x 3.x 4.x
		}
		
		gen y = `y'
		gen x = treatment_status
		reg f2.y i.x strata y if attended_tr != ., cluster(schoolid)
		drop x
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1
		estadd scalar cont = r(mean)
		if (`n' < 9) {
		estadd matrix pfwer = pfwer
		}
		drop y
		
		if (`n' < 10) {
			global main_reg $main_reg reg_`route'_`n'
		}
		else {
			global appendix_reg $appendix_reg reg_`route'_`n'
		}
		
	if (`n' < 9)&(`n' > 2) {
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

	}
	
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
	
	*no fwer
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
		(rcap R3 R2 R4, lc(gs5))	, ///
		legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
		xline(6.5, lpattern(-) lcolor(black)) 	///
		xline(12.5, lpattern(-) lcolor(black)) 	///
		graphregion(color(white)) ///
		ylabel(0(3)18) ///
		text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/figure10`route_u'.gph, replace
	graph export ${main}/Draft/figures/figure10`route_u'.png, replace
	
	*fwer
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/figure11`route_u'.gph, replace
	graph export ${main}/Draft/figures/figure11`route_u'.png , replace
	
	restore
	
	
	esttab $main_reg using ///
		"table9`route_u'.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
		drop(strata y _cons) collabels(,none) substitute(\_ _) ///
		replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. control" "\(N\)")) ///
		coeflabels(1.x "Control" 2.x ///
		"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
		4.x "\(T3\) - Double" strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
		postfoot("\hline\hline \end{tabular}}")

	estimates drop $main_reg 

	eststo clear
	
}

	
	

*economic outcomes at fu2

global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " 
			
**************************************FWER**************************************

*est clear


local n_outcomes `: word count $economic_outcomes'
	
global economic_outcomes_bl " "
foreach var in $economic_outcomes {
	gen l2`var' = l2.`var'
	global economic_outcomes_bl $economic_outcomes_bl  " l2`var'"
}


* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $economic_outcomes {
	di "  - `var'"
}


preserve
drop if time == 2 & l2.attended_tr == .
drop if time == 0 & attended_tr == .
	
wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
controls($economic_outcomes_bl) ///
bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

matrix define results = r(table)
esttab matrix(results) using table10.xls, nomtitles replace

	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
***********************************KLING***********************************


global economic_outcomes $economic_outcomes  economic_index  

global economic_plot_list " "
global economic_plot_list_noasinh " "

local n_outcomes `: word count $economic_outcomes'	
local n_rows = (`n_outcomes' - 3)*3
mat R=J(`n_rows',5,.)

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
	qui reg f2.y i.x strata y if attended_tr != ., cluster(schoolid_str)
	drop x
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1
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
	if (`n' < 8){
	local n_treat=1
	local ++ng

	foreach X in i2.x i3.x i4.x  {
		local row = (`n_outcomes'-3)*(`n_treat'-1) + `ng'
		di `ng' " " `n_treat'  " " `row'
		
		local k = 1
		if `ng' == 4 {
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
	
}


preserve
clear
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Finding Job" 2 "Contin. Studies" 3 "Becom. Citiz." ///
	4 "Not Sent Back" 5 "Financial help" 6 "Getting Asylum" ///
	7 "Favor Migration" ///
	8 "Finding Job" 9 "Contin. Studies" 10 "Becom. Citiz." ///
	11 "Not Sent Back" 12 "Financial help" 13 "Getting Asylum" ///
	14 "Favor Migration" ///
	15 "Finding Job" 16 "Contin. Studies" 17 "Becom. Citiz." ///
	18 "Not Sent Back" 19 "Financial help" 20 "Getting Asylum" ///
	21 "Favor Migration"
label values R4 groups
la var R5 "p_fwer"

set scheme s2mono
	
	
*no fwer
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/figure12.gph, replace
graph export ${main}/Draft/figures/figure12.png , replace

*fwer
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/figure13.gph, replace
graph export ${main}/Draft/figures/figure13.png , replace
	
restore

esttab  $main_reg using ///
	"table10.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	drop(strata y _cons) collabels(,none) substitute(\_ _) ///
	replace stats(cont N,  fmt(a2 a2) label( "Mean dep. var. control" "\(N\)"))  ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")


esttab $appendix_reg using ///
	"table11.tex",  se ///
	 drop(strata y _cons) collabels(,none) substitute(\_ _) ///
	replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. control" "\(N\)")) ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Double" strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	




*risk outcomes at fu1 with controls

local controls_bl " " 
foreach var in `demographics' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
}
foreach var in `school_char' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
}
	

global routes_list = "Italy Spain"

global appendix_reg " "

foreach route_u in $routes_list {
	
	*est clear
	
	local route = lower("`route_u'")
	
	di "`route'"
	
	global winsor = "`route'_duration `route'_journey_cost"
		
	global main_reg " "
		
	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	

	global `route'_outcomes_bl " "
	foreach var in $`route'_outcomes {
		gen l1`var' = l.`var'
		global `route'_outcomes_bl $`route'_outcomes_bl " l1`var'"
	}

	local n_outcomes `: word count $`route'_outcomes'

	* run all regressions and store results 
	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}	

	preserve
	drop if time == 2
	drop if time == 1 & l1.attended_tr == .
	drop if time == 0 & attended_tr == .

	wyoung $`route'_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 `controls_bl' CONTROLVARS  , ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($`route'_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore
	
	matrix define results = r(table)
	esttab matrix(results) using table12`route_u'.xls, nomtitles replace

	matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
	matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
	matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]

	
	***********************************KLING***********************************
	
								
	global `route'_outcomes $`route'_outcomes  `" `route'_index "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_poscost "'
	global `route'_outcomes $`route'_outcomes  `" `route'_kling_negcost "'

	global risks_plot_list " "
	global risks_plot_noasinh_list " "

	local n_outcomes `: word count $`route'_outcomes'
	local n_rows = (`n_outcomes' - 5)*3
	mat R=J(`n_rows',5,.)

	local n = 0
	local ng = 0

	foreach y in $`route'_outcomes {

		local n = `n' + 1
		
		if (`n' < 9) {
		matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
		matrix colnames pfwer = 2.x 3.x 4.x
		}
		
		gen y = `y'
		gen x = treatment_status
		qui reg f.y i.x strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
		drop x
		est sto reg_`route'_`n'
		qui sum y if time == 1 & treatment_status == 1
		estadd scalar cont = r(mean)
		if (`n' < 9) {
		estadd matrix pfwer = pfwer
		}
		drop y
		
		if (`n' < 10) {
			global main_reg $main_reg reg_`route'_`n'
		}
		else {
			global appendix_reg $appendix_reg reg_`route'_`n'
		}
		
	if (`n' < 9)&(`n' > 2) {
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

	}
	
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
		ylabel(0(3)18) ///
		text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/figure14`route_u'.gph, replace
	graph export ${main}/Draft/figures/figure14`route_u'.png, replace
	
	*fwer
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/figure15`route_u'.gph, replace
	graph export ${main}/Draft/figures/figure15`route_u'.png , replace
	
	restore
	
	
	if "`route_u'" == "Italy" {
		esttab $main_reg using ///
			"table12`route_u'.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
			keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
			replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. cont." "\(N\)")) ///
			coeflabels(1.x "Control" 2.x ///
			"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
			4.x "\(T3\) - Double" strata "Big school" ///
			y "Basel. outc." _cons "Constant")  ///
			 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
			nonumbers  /// 
			mtitles($risks_table_titles) ///
			nobaselevels ///
			posthead("\hline  \\ \textbf{\textit{Italian Route:}} & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot("\hline") ///
			nonumbers
	}
	
	if "`route_u'" == "Spain" {
		esttab $main_reg using ///
			"table12`route_u'.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
			keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
			replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. cont." "\(N\)")) ///
			coeflabels(1.x "Control" 2.x ///
			"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
			4.x "\(T3\) - Double" strata "Big school" ///
			y "Basel. outc." _cons "Constant")  ///
			 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
			nonumbers  /// 
			nobaselevels ///
			prehead("") posthead("  \\ \textbf{\textit{Spanish Route:}}  & & &  &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") ///
			nonumbers nomtitles
	}

	estimates drop $main_reg 

	eststo clear
	
}

*/




					
*risk outcomes at fu1 with controls averaging italy and spain

global risk_outcomes = " _duration_winsor " ///
							+ " _beaten " ///
							+ " _forced_work " ///
							+ " _journey_cost_winsor  " ///
							+ " _kidnapped " ///
							+ " _die_bef_boat " ///
							+ " _die_boat " ///
							+ " _sent_back "

gen asinhmrisk_duration_winsor = (asinhitaly_duration_winsor + asinhspain_duration_winsor)/2
gen asinhmrisk_journey_cost_winsor = (asinhitaly_journey_cost_winsor + asinhspain_journey_cost_winsor)/2
gen mrisk_beaten = (italy_beaten + spain_beaten)/2
gen mrisk_forced_work = (italy_forced_work + spain_forced_work)/2
gen mrisk_kidnapped = (italy_kidnapped + spain_kidnapped)/2
gen mrisk_die_bef_boat = (italy_die_bef_boat + spain_die_bef_boat)/2
gen mrisk_die_boat = (italy_die_boat + spain_die_boat)/2
gen mrisk_sent_back = (italy_sent_back + spain_sent_back)/2
gen mrisk_index = (italy_index + spain_index)/2
gen mrisk_kling_negcost = (italy_kling_negcost + italy_kling_negcost)/2
gen mrisk_kling_poscost = (italy_kling_poscost + spain_kling_poscost)/2
		
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
esttab matrix(results) using table12mean.xls, nomtitles replace

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

}

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
esttab matrix(results) using table12meanany.xls, nomtitles replace

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
stop



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
	
/*
*econ outcomes at fu1 with controls


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
esttab matrix(results) using table13.xls, nomtitles replace

	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
***********************************KLING***********************************

global economic_outcomes $economic_outcomes  economic_index  economic_kling


global economic_plot_list " "
global economic_plot_list_noasinh " "

local n_outcomes `: word count $economic_outcomes'
local n_rows = (`n_outcomes' - 3)*3
mat R=J(`n_rows',5,.)

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
	if (`n' != 2)&(`n' != 8){
	local n_treat=1
	local ++ng

	foreach X in i2.x i3.x i4.x  {
		local row = (`n_outcomes'-3)*(`n_treat'-1) + `ng'
		
		local k = 1
		if `ng' == 4 {
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
	
}


preserve
clear
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Finding Job" 2 "Contin. Studies" 3 "Becom. Citiz." ///
	4 "Not Sent Back" 5 "Financial help" 6 "Getting Asylum" ///
	7 "Favor Migration" ///
	8 "Finding Job" 9 "Contin. Studies" 10 "Becom. Citiz." ///
	11 "Not Sent Back" 12 "Financial help" 13 "Getting Asylum" ///
	14 "Favor Migration" ///
	15 "Finding Job" 16 "Contin. Studies" 17 "Becom. Citiz." ///
	18 "Not Sent Back" 19 "Financial help" 20 "Getting Asylum" ///
	21 "Favor Migration"
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
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/figure17.gph, replace
graph export ${main}/Draft/figures/figure17.png , replace
	
restore


esttab  $main_reg using ///
	"table13.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace stats(cont N,  fmt(a2 a2) label( "Mean dep. var. control" "\(N\)"))  ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")


*/

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
esttab matrix(results) using table13comp.xls, nomtitles replace

	
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
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Finding job" 2 "Contin. studies" 3 "Getting asylum" ///
	4 "Becom. citiz." 5 "Return aft. 5yrs" 6 "Public transfers" ///
	7 "Host country attit." ///
	8 "Finding job" 9 "Contin. studies" 10 "Getting asylum" ///
	11 "Becom. citiz." 12 "Return aft. 5yrs" 13 "Public transfers" ///
	14 "Host country attit." ///
	15 "Finding job" 16 "Contin. studies" 17 "Getting asylum" ///
	18 "Becom. citiz." 19 "Return aft. 5yrs" 20 "Public transfers" ///
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
esttab matrix(results) using table13company.xls, nomtitles replace

	
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

esttab reg* using apptable4.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("\shortstack{In-Person \\ Survey \\ with Resp.}" "\shortstack{In-Person \\ Survey \\ with Resp.}" "\shortstack{Previous + \\ Phone Survey \\ with Resp.}" "\shortstack{Previous + \\ Phone Survey \\ with Cont.}" "\shortstack{Previous + \\ School \\ Survey }") ///
	stats(pre prd ped N meandep, fmt(s s s  0 3) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"' `"\(N\)"'  `"Mean dep. var. control"')) nonumbers ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{5}{c}{y = attrited at survey}  \\ &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}   \\ \cmidrule(lr){2-6}  &\multicolumn{1}{c}{\(1^{st}\) F.U.}&\multicolumn{4}{c}{\(2^{nd}\) F.U.}  \\  \cmidrule(lr){2-2} \cmidrule(lr){3-6}")

restore

stop



*BALANCE

* individual characteristics with attendance (Panel a table 1)
global bc_var_demo = " female grade6 grade7 durables " ///
				+ " moth_working moth_educ5 " ///
				+ " fath_working fath_educ5 " 
* contacts abroad, sisters and brothers are winsorized


* variables for the balance with attendance (Panel b table 1)			
global bc_var_outcomes = "desire planning prepare italy_index spain_index economic_index italy_kling_negcost spain_kling_negcost economic_kling" 	


* other individual characteristics (app table 2)
global bc_var_demo_sec = " wealth_index contacts_winsor mig_classmates " ///
				+ " tele_daily tele_weekless inter_daily inter_weekless " ///
				+ "  moth_educ1 moth_educ2 moth_educ3 moth_educ5 " ///
				+ " fath_working fath_educ1 fath_educ2 fath_educ3 fath_educ5 " ///
				+ " brother_no_win sister_no_win " 	

* other beliefs (app table 3)
global bc_var_italyrisk = "asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat italy_kling_poscost  " 

global bc_var_spainrisk = " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat spain_kling_poscost" 

global bc_var_econ =  "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help" 
								

* school characteristics (app table 4)
global bc_var_school = " strata_n2 fees50 repeaters transfers ratio_female_second ratio_female_lycee rstudteach rstudadmin rstudclass ratio_tmale ratio_tmaster " ///
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

	


