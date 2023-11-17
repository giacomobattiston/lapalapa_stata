clear all

set more off

*global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/followup2/BME_final.dta

global logs ${main}/logfiles/
global dta ${main}/Data/dta/

cd "${main}/Draft/tables"

tsset id_number time

global mainvars  "i.treatment_status i.strata" 
local demographics "i.classe_baseline i.where_born female"
local parents_char  "fath_alive moth_alive i.fath_educ i.moth_educ fath_working moth_working sister_no_win brother_no_win"

local n_rep 1000

/*
*MIGRATION (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
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
		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table3.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}") 

	
*MIGRATION WITHOUT VISA (restricted sample)

eststo clear

qui sum migration_novisa if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
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
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table4a.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
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
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table4b.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	prehead("") posthead("  \\ \textbf{\textit{(b): Migration with visa}}  & & &  &  &  &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") ///
	nonumbers nomtitles
	


*MIGRATION BY DURABLES (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea i.x i.x#i.durables50 i.durables50  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x i.x#i.durables50 = i.treatment_status i.treatment_status#i.durables50) ///
				i.durables50 strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		lincom 2.x + 2.x#1.durables50
		local brint_aux = string(`r(estimate)', "%9.5f") 
		local brint `brint_aux'
		if `r(p)' < 0.1 {
			local brint `brint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local brint `brint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local brint `brint_aux'\sym{***}
		} 
		estadd local brint = `"`brint'"'
		
		local serint_aux = string(`r(se)', "%9.5f")
		local serint (`serint_aux')
		estadd local serint = `"`serint'"'
		
		lincom 3.x + 3.x#1.durables50
		local beint_aux = string(`r(estimate)', "%9.5f") 
		local beint `beint_aux'
		if `r(p)' < 0.1 {
			local beint `beint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local beint `beint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local beint `beint_aux'\sym{***}
		} 
		estadd local beint = `"`beint'"'
		
		local seeint_aux = string(`r(se)', "%9.5f")
		local seeint (`seeint_aux')
		estadd local seeint = `"`seeint'"'
		
		
		lincom 4.x + 4.x#1.durables50
		local bdint_aux = string(`r(estimate)', "%9.5f") 
		local bdint `bdint_aux'
		if `r(p)' < 0.1 {
			local bdint `bdint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local bdint `bdint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local bdint `bdint_aux'\sym{***}
		} 
		estadd local bdint = `"`bdint'"'
		
		local sedint_aux = string(`r(se)', "%9.5f")
		local sedint (`sedint_aux')
		estadd local sedint = `"`sedint'"'
		
		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table5.tex, replace keep(2.x 3.x 4.x 2.x#1.durables50 3.x#1.durables50 4.x#1.durables50 1.durables50) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" ///
	2.x#1.durables50 "\(T_1\) - Risk X High Durables" 3.x#1.durables50 "\(T_2\) - Econ X High Durables" 4.x#1.durables50 "\(T_3\) - Double X High Durables" ///
	1.durables50 "High Durables" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(space brint serint space beint seeint space bdint sedint space individual family N meandep, fmt(s s s s s s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{\(T_1\) + \(T_1\) X High Durables}"' `" "' `" "' `"\emph{\(T_2\) + \(T_2\) X High Durables}"' `" "' `" "' `"\emph{\(T_3\) + \(T_3\) X High Durables}"' `" "' `" "' `"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")


	
*INTERNAL MIGRATION (restricted sample)

eststo clear

qui sum migration_internal if l2.treatment_status == 1  &  source_info_guinea < 6 & source_info_conakry < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
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
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table7.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = internal migration", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	


*MIGRATION BY BANK ACCOUNT OWNERSHIP (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea i.x i.x#i.bank_account i.bank_account  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x i.x#i.bank_account = i.treatment_status i.treatment_status#i.bank_account) ///
				i.bank_account strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.bank_account
		local brint_aux = string(`r(estimate)', "%9.5f") 
		local brint `brint_aux'
		if `r(p)' < 0.1 {
			local brint `brint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local brint `brint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local brint `brint_aux'\sym{***}
		} 
		estadd local brint = `"`brint'"'
		
		local serint_aux = string(`r(se)', "%9.5f")
		local serint (`serint_aux')
		estadd local serint = `"`serint'"'
		
		lincom 3.x + 3.x#1.bank_account
		local beint_aux = string(`r(estimate)', "%9.5f") 
		local beint `beint_aux'
		if `r(p)' < 0.1 {
			local beint `beint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local beint `beint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local beint `beint_aux'\sym{***}
		} 
		estadd local beint = `"`beint'"'
		
		local seeint_aux = string(`r(se)', "%9.5f")
		local seeint (`seeint_aux')
		estadd local seeint = `"`seeint'"'
		
		
		lincom 4.x + 4.x#1.bank_account
		local bdint_aux = string(`r(estimate)', "%9.5f") 
		local bdint `bdint_aux'
		if `r(p)' < 0.1 {
			local bdint `bdint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local bdint `bdint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local bdint `bdint_aux'\sym{***}
		} 
		estadd local bdint = `"`bdint'"'
		
		local sedint_aux = string(`r(se)', "%9.5f")
		local sedint (`sedint_aux')
		estadd local sedint = `"`sedint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table6.tex, replace keep(2.x 3.x 4.x 2.x#1.bank_account 3.x#1.bank_account 4.x#1.bank_account 1.bank_account) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" ///
	2.x#1.bank_account "\(T_1\) - Risk X Owns bank account" 3.x#1.bank_account "\(T_2\) - Econ X Owns bank account" 4.x#1.bank_account "\(T_3\) - Double X Owns bank account" ///
	1.bank_account "Owns bank account" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(space brint serint space beint seeint space bdint sedint space individual family N meandep, fmt(s s s s s s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{\(T_1\) + \(T_1\) X Owns Bank Account}"' `" "' `" "' `"\emph{\(T_2\) + \(T_2\) X Owns Bank Account}"' `" "' `" "' `"\emph{\(T_3\) + \(T_3\) X Owns Bank Account}"' `" "' `" "' `"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
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
		local brint_aux = string(`r(estimate)', "%9.5f") 
		local brint `brint_aux'
		if `r(p)' < 0.1 {
			local brint `brint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local brint `brint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local brint `brint_aux'\sym{***}
		} 
		estadd local brint = `"`brint'"'
		
		local serint_aux = string(`r(se)', "%9.5f")
		local serint (`serint_aux')
		estadd local serint = `"`serint'"'
		
		lincom 3.x + 3.x#1.pessimistic
		local beint_aux = string(`r(estimate)', "%9.5f") 
		local beint `beint_aux'
		if `r(p)' < 0.1 {
			local beint `beint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local beint `beint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local beint `beint_aux'\sym{***}
		} 
		estadd local beint = `"`beint'"'
		
		local seeint_aux = string(`r(se)', "%9.5f")
		local seeint (`seeint_aux')
		estadd local seeint = `"`seeint'"'
		
		
		lincom 4.x + 4.x#1.pessimistic
		local bdint_aux = string(`r(estimate)', "%9.5f") 
		local bdint `bdint_aux'
		if `r(p)' < 0.1 {
			local bdint `bdint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local bdint `bdint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local bdint `bdint_aux'\sym{***}
		} 
		estadd local bdint = `"`bdint'"'
		
		local sedint_aux = string(`r(se)', "%9.5f")
		local sedint (`sedint_aux')
		estadd local sedint = `"`sedint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table8.tex, replace keep(2.x 3.x 4.x 2.x#1.pessimistic 3.x#1.pessimistic 4.x#1.pessimistic 1.italy_pessimistic 1.econ_pessimistic) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" ///
	2.x#1.pessimistic "\(T_1\) - Risk X Pessimistic beliefs" 3.x#1.pessimistic "\(T_2\) - Econ X Pessimistic beliefs" 4.x#1.pessimistic "\(T_3\) - Double X Pessimistic beliefs" ///
	1.italy_pessimistic "Pessimistic risk beliefs" 1.econ_pessimistic "Pessimistic econ beliefs" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(space brint serint space beint seeint space bdint sedint space individual family N meandep, fmt(s s s s s s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{\(T_1\) + \(T_1\) X Pessimistic beliefs}"' `" "' `" "' `"\emph{\(T_2\) + \(T_2\) X Pessimistic beliefs}"' `" "' `" "' `"\emph{\(T_3\) + \(T_3\) X Pessimistic beliefs}"' `" "' `" "' `"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
		local family "No"
	}
	
	if `i_con' == 2 {
		local controls  `demographics'
		local individual "Yes"
		local family "No"
	}
	if `i_con' == 3 {
		local controls `demographics' `parents_char'
		local individual "Yes"
		local family "Yes"
	}
	

	gen x = treatment_status
	qui reg f2.migration_guinea i.x strata `controls' ///
		if f2.source_info_guinea < 6, cluster(schoolid)
	drop x

	
	estadd local individual = "`individual'"
	estadd local family = "`family'"
	
	estadd scalar meandep = `meandep'
		
	eststo reg`i_est'_`i_con'

	
}


esttab reg* using apptable7.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT") ///
	mgroups("y = migration from Guinea", pattern(1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	
	
*MIGRATION INTENTIONS FU2 (restricted sample)

eststo clear


local outcomes "desire planning prepare"
foreach var of varlist `outcomes' {
	qui sum `var' if treatment_status == 1  & time == 0
	local meandep = `r(mean)'
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
		}
		
		gen x = treatment_status
		gen y = `var'
		qui reg f2.y i.x strata `controls'  y ///
			if  attended_tr != ., cluster(schoolid)
		
		drop x
		drop y
		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`var'_`i_con'

		
	}
}

esttab reg* using apptable8.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	y "Intends to migrate" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
	mgroups("Wishing to migrate" "Planning to migrate" "Preparing to migrate", pattern(1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	
		
*MIGRATION INTENTIONS FU1 (restricted sample)

eststo clear


local outcomes "desire planning prepare"
foreach var of varlist `outcomes' {
	qui sum `var' if treatment_status == 1  & time == 0
	local meandep = `r(mean)'
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
		}
		
		gen x = treatment_status
		gen y = `var'
		qui reg f1.y i.x strata `controls'  y ///
			if time == 0 & attended_tr != ., cluster(schoolid)
		
		drop x
		drop y
		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`var'_`i_con'

		
	}
}

esttab reg* using apptable9.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	y "Intends to migrate" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
	mgroups("Wishing to migrate" "Planning to migrate" "Preparing to migrate", pattern(1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")


	


*MIGRATION BY BANK ACCOUNT OWNERSHIP (restricted sample)

eststo clear

qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
		}
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea i.x i.x#i.fees50 i.fees50  strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea (i.x i.x#i.fees50 = i.treatment_status i.treatment_status#i.fees50) ///
				i.fees50 strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.fees50
		local brint_aux = string(`r(estimate)', "%9.5f") 
		local brint `brint_aux'
		if `r(p)' < 0.1 {
			local brint `brint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local brint `brint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local brint `brint_aux'\sym{***}
		} 
		estadd local brint = `"`brint'"'
		
		local serint_aux = string(`r(se)', "%9.5f")
		local serint (`serint_aux')
		estadd local serint = `"`serint'"'
		
		lincom 3.x + 3.x#1.fees50
		local beint_aux = string(`r(estimate)', "%9.5f") 
		local beint `beint_aux'
		if `r(p)' < 0.1 {
			local beint `beint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local beint `beint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local beint `beint_aux'\sym{***}
		} 
		estadd local beint = `"`beint'"'
		
		local seeint_aux = string(`r(se)', "%9.5f")
		local seeint (`seeint_aux')
		estadd local seeint = `"`seeint'"'
		
		
		lincom 4.x + 4.x#1.fees50
		local bdint_aux = string(`r(estimate)', "%9.5f") 
		local bdint `bdint_aux'
		if `r(p)' < 0.1 {
			local bdint `bdint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local bdint `bdint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local bdint `bdint_aux'\sym{***}
		} 
		estadd local bdint = `"`bdint'"'
		
		local sedint_aux = string(`r(se)', "%9.5f")
		local sedint (`sedint_aux')
		estadd local sedint = `"`sedint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using apptable10.tex, replace keep(2.x 3.x 4.x 2.x#1.fees50 3.x#1.fees50 4.x#1.fees50 1.fees50) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" ///
	2.x#1.fees50 "\(T_1\) - Risk X High school fees" 3.x#1.fees50 "\(T_2\) - Econ X High school fees" 4.x#1.fees50 "\(T_3\) - Double X High school fees" ///
	1.fees50 "High school fees" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(space brint serint space beint seeint space bdint sedint space individual family N meandep, fmt(s s s s s s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{\(T_1\) + \(T_1\) X High school fees}"' `" "' `" "' `"\emph{\(T_2\) + \(T_2\) X High school fees}"' `" "' `" "' `"\emph{\(T_3\) + \(T_3\) X High school fees}"' `" "' `" "' `"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")
	
	
	

	

*LYBIAN ROUTE CHOSEN (restricted sample)

eststo clear

forval i_time = 1/2 {
	qui sum route_chosen if l`i_time'.treatment_status == 1 & time == `i_time'
	local meandep = `r(mean)'
	forval i_con = 1/3 {
		
		if `i_con' == 1 {
			local controls ""
			local individual "No"
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
		}
		
		gen x = treatment_status
		qui reg f`i_time'.route_chosen i.x  strata `controls' ///
			if attended_tr != . & time == 0, cluster(schoolid)
		drop x

		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_time'_`i_con'

		
	}
}

esttab reg* using apptable11.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" ///
	strata "Big school")   se substitute(\_ _) ///
	mtitles("\(1^{st}\) F.U." "\(1^{st}\) F.U." "\(1^{st}\) F.U." "\(2^{nd}\) F.U." "\(2^{nd}\) F.U." "\(2^{nd}\) F.U.") ///
	mgroups("y = Lybian Route Chosen", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
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
		local brint_aux = string(`r(estimate)', "%9.5f") 
		local brint `brint_aux'
		if `r(p)' < 0.1 {
			local brint `brint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local brint `brint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local brint `brint_aux'\sym{***}
		} 
		estadd local brint = `"`brint'"'
		
		local serint_aux = string(`r(se)', "%9.5f")
		local serint (`serint_aux')
		estadd local serint = `"`serint'"'
		
		lincom 3.x + 3.x#1.pessimistic_weak
		local beint_aux = string(`r(estimate)', "%9.5f") 
		local beint `beint_aux'
		if `r(p)' < 0.1 {
			local beint `beint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local beint `beint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local beint `beint_aux'\sym{***}
		} 
		estadd local beint = `"`beint'"'
		
		local seeint_aux = string(`r(se)', "%9.5f")
		local seeint (`seeint_aux')
		estadd local seeint = `"`seeint'"'
		
		
		lincom 4.x + 4.x#1.pessimistic_weak
		local bdint_aux = string(`r(estimate)', "%9.5f") 
		local bdint `bdint_aux'
		if `r(p)' < 0.1 {
			local bdint `bdint_aux'\sym{*}
		}
		if `r(p)' < 0.05 {
			local bdint `bdint_aux'\sym{**}
		}
		if `r(p)' < 0.01 {
			local bdint `bdint_aux'\sym{***}
		} 
		estadd local bdint = `"`bdint'"'
		
		local sedint_aux = string(`r(se)', "%9.5f")
		local sedint (`sedint_aux')
		estadd local sedint = `"`sedint'"'
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using apptable12.tex, replace keep(2.x 3.x 4.x 2.x#1.pessimistic_weak 3.x#1.pessimistic_weak 4.x#1.pessimistic_weak 1.italy_pessimistic 1.econ_pessimistic) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" ///
	2.x#1.pessimistic_weak "\(T_1\) - Risk X Pessimistic beliefs" 3.x#1.pessimistic_weak "\(T_2\) - Econ X Pessimistic beliefs" 4.x#1.pessimistic_weak "\(T_3\) - Double X Pessimistic beliefs" ///
	1.italy_pessimistic "Pessimistic risk beliefs" 1.econ_pessimistic "Pessimistic econ beliefs" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(space brint serint space beint seeint space bdint sedint space individual family N meandep, fmt(s s s s s s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{\(T_1\) + \(T_1\) X Pessimistic beliefs}"' `" "' `" "' `"\emph{\(T_2\) + \(T_2\) X Pessimistic beliefs}"' `" "' `" "' `"\emph{\(T_3\) + \(T_3\) X Pessimistic beliefs}"' `" "' `" "' `"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
			local family "No"
		}
		
		if `i_con' == 2 {
			local controls  `demographics'
			local individual "Yes"
			local family "No"
		}
		if `i_con' == 3 {
			local controls `demographics' `parents_char'
			local individual "Yes"
			local family "Yes"
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
		estadd local family = "`family'"
		
		estadd scalar meandep = `meandep'
			
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using apptable13.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual family N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"Family controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

*/
	
*risk outcomes at fu2

global economic_titles = `" " \shortstack{(1)\\ Finding \\ Job \\ vphantom{foo}} " "' ///
			+ `" "\shortstack{(2)\\ Contin. \\ Studies \\ abroad}" "' ///
			+ `" "\shortstack{(3)\\ Becom. \\ Citiz. \\ \vphantom{foo}}" "' ///
			+ `" "\shortstack{(4)\\ Return \\ before \\ 5 yrs}" "' ///
			+ `" "\shortstack{(5)\\ Getting \\ Finan. \\ Help}""' ///
			+ `" "\shortstack{(6) \\ Getting \\ Asyl. \\ \vphantom{foo}}" "' ///
			+ `" "\shortstack{(7) \\ In \\ Favor \\ Migr.}" "' ///
			+ `" "\shortstack{(8) \\  \(sinh^{-1}\) \\ Liv. Cost \\ abroad}" "' ///
			+ `" "\shortstack{(9)\\ \(sinh^{-1}\) \\ Wage \\ \vphantom{foo}}" "' ///
			+ `" "\shortstack{(10) \\ PCA \\ Econ \\ Index}" "' 
											
								
global appendix_table_titles =  `" "\shortstack{(1) \\ Kling \\ Cost+ \\ Ita }" "'  ///
								+ `" "\shortstack{(2) \\ Kling \\ Cost- \\ Ita }" "' ///
								+ `" "\shortstack{(3) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\shortstack{(4) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\shortstack{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				
			

global risks_table_titles = `" " \shortstack{(1) \\  \(sinh^{-1}\)  \\ Journey \\ Duration }" "' ///
				+ `" " \shortstack{(2)\\  \(sinh^{-1}\) \\ Journey\\ Cost}" "' ///
				+ `" " \shortstack{(3)\\ Being \\ Beaten \\ \vphantom{foo}}" "' ///
				+ `" "\shortstack{(4)\\ Forced \\  to \\ Work}" "' /// 
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
		replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. control" "N")) ///
		coeflabels(1.x "Control" 2.x ///
		"\(T_1\) - Risk" 3.x "\(T_2\) - Econ" ///
		4.x "\(T_3\) - Double" strata "Big school" ///
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
	replace stats(cont N,  fmt(a2 a2) label( "Mean dep. var. control" "N"))  ///
	coeflabels(1.x "Control" 2.x ///
	"\(T_1\) - Risk" 3.x "\(T_2\) - Econ" ///
	4.x "\(T_3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")


esttab $appendix_reg using ///
	"table11.tex",  se ///
	 drop(strata y _cons) collabels(,none) substitute(\_ _) ///
	replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. control" "N")) ///
	coeflabels(1.x "Control" 2.x ///
	"\(T_1\) - Risk" 3.x "\(T_2\) - Econ" ///
	4.x "\(T_3\) - Double" strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
*/


*risk outcomes at fu1

	
	/*		
global routes_list = "Spain"

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

	wyoung $`route'_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
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
		qui reg f.y i.x strata y if attended_tr != . & time == 0, cluster(schoolid_str)
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
	
	
	esttab $main_reg using ///
		"table12`route_u'.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
		drop(strata y _cons) collabels(,none) substitute(\_ _) ///
		replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. control" "N")) ///
		coeflabels(1.x "Control" 2.x ///
		"\(T_1\) - Risk" 3.x "\(T_2\) - Econ" ///
		4.x "\(T_3\) - Double" strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers  /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
		postfoot("\hline\hline \end{tabular}}")

	estimates drop $main_reg 

	eststo clear
	
}
*/


*econ outcomes at fu1


global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " ///


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

wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, ///
	cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
	controls($economic_outcomes_bl) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

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
	qui reg f.y i.x strata y if attended_tr != . & time == 0, cluster(schoolid_str)
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
	if (`n' < 8){
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
	drop(strata y _cons) collabels(,none) substitute(\_ _) ///
	replace stats(cont N,  fmt(a2 a2) label( "Mean dep. var. control" "N"))  ///
	coeflabels(1.x "Control" 2.x ///
	"\(T_1\) - Risk" 3.x "\(T_2\) - Econ" ///
	4.x "\(T_3\) - Double" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers  /// 
	mtitles($economic_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")


esttab $appendix_reg using ///
	"table14.tex",  se ///
	 drop(strata y _cons) collabels(,none) substitute(\_ _) ///
	replace stats(cont N, fmt(a2 a2) label( "Mean dep. var. control" "N")) ///
	coeflabels(1.x "Control" 2.x ///
	"\(T_1\) - Risk" 3.x "\(T_2\) - Econ" ///
	4.x "\(T_3\) - Double" strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers  /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
	postfoot("\hline\hline \end{tabular}}")
	
	

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
matrix rownames obs =  "\textbf{Baseline}: Tablet" "\textbf{Follow Up 1}: Tablet"  "\textbf{Follow Up 2}: Tablet" "\textbf{Follow Up 2}: Respondent" "\textbf{Follow Up 2}: Contact"   "\textbf{Follow Up 2}: SSS"  


esttab matrix(obs, fmt(%9.3g)) using apptable5.tex, style(tex) replace nomtitles postfoot(" \hline \hline \end{tabular}") ///
	prehead(" \begin{tabular}{l*{11}{c}} \hline \hline   & \multicolumn{2}{c}{All}  & \multicolumn{2}{c}{Control}  & \multicolumn{2}{c}{\(T_1\) - Risk}  & \multicolumn{2}{c}{\(T_2\) - Econ} &  \multicolumn{2}{c}{\(T_3\) - Double} \\  ") substitute(\_ _) 

restore



*ATTRITION

preserve

keep if time == 0

eststo clear

		
local outcomes "no_1_1 no_1_2 no_2_2 no_3_2 no_5_2"

foreach var of varlist `outcomes' {
	qui sum `var' if treatment_status == 1
	local meandep = `r(mean)'
	
	gen x = treatment_status
	qui reg `var' i.x strata ///
		if attended_tr != ., cluster(schoolid)
	drop x

	test 2.x - 3.x = 0
	local pre_aux  = string(`r(p)', "%9.2f")
	local pre `pre_aux'
	if `r(p)' < 0.1 {
		local pre `pre_aux'\sym{*}
	}
	if `r(p)' < 0.05 {
		local pre `pre_aux'\sym{**}
	}
	if `r(p)' < 0.01 {
		local pre `pre_aux'\sym{***}
	}
  
	estadd local pre = `"`pre'"'
	
	test 2.x - 4.x = 0
	local prd_aux = string(`r(p)', "%9.2f") 
	local prd `prd_aux'
	if `r(p)' < 0.1 {
		local prd `prd_aux'\sym{*}
	}
	if `r(p)' < 0.05 {
		local prd `prd_aux'\sym{**}
	}
	if `r(p)' < 0.01 {
		local prd `prd_aux'\sym{***}
	} 
	estadd local prd = `"`prd'"'
	
	test 3.x - 4.x = 0
	local ped_aux = string(`r(p)', "%9.2f")
	local ped `ped_aux'
	if `r(p)' < 0.1 {
		local ped `ped_aux'\sym{*}
	}
	if `r(p)' < 0.05 {
		local ped `ped_aux'\sym{**}
	}
	if `r(p)' < 0.01 {
		local ped `ped_aux'\sym{***}
	}
	estadd local ped = `"`ped'"'
	
	estadd scalar meandep = `meandep'
		
	eststo reg`var'
}

esttab reg* using apptable4.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T_1\) - Risk" 3.x "\(T_2\) - Econ" 4.x "\(T_3\) - Double" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("\shortstack{Tablet \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad}" "\shortstack{Tablet \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad \\ \quad}" "\shortstack{Previous + \\ Phone Survey \\ with Resp.}" "\shortstack{Previous + \\ Phone Survey \\ with Cont.}" "\shortstack{Previous + \\ SSS \\ \quad \\ \quad \\ \quad \\ \quad }") ///
	stats(pre prd ped N meandep, fmt(s s s  0 3) ///
	labels(`"\emph{H0: \(T_1\) = \(T_2\) (p-value)}"' `"\emph{H0: \(T_1\) = \(T_3\) (p-value)}"' `"\emph{H0: \(T_2\) = \(T_3\) (p-value)}"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{5}{c}{y = attrited at survey}   \\ \cmidrule(lr){2-6}  &\multicolumn{1}{c}{\(1^{st}\) F.U.}&\multicolumn{4}{c}{\(2^{nd}\) F.U.}  \\  \cmidrule(lr){2-2} \cmidrule(lr){3-6}")

restore



*BALANCE

*variables for the balance
global bc_var_demo = " female   wealth_index " ///
				+ "   durables50 grade2 grade3 contacts_winsor mig_classmates " ///
				+ " tele_daily tele_weekless inter_daily inter_weekless " ///
				+ " moth_working moth_educ1 moth_educ2 moth_educ3 moth_educ5 " ///
				+ " fath_working fath_educ1 fath_educ2 fath_educ3 fath_educ5 " ///
				+ " brother_no_win sister_no_win " 
				
global bc_var_intentions = "desire planning prepare" 

global bc_var_italyrisk = "asinhitaly_duration asinhitaly_journey_cost italy_beaten italy_forced_work italy_kidnapped italy_sent_back italy_die_boat italy_die_bef_boat " 
				
global bc_var_econ =  "  asinhexpectation_wage finding_job asylum continuing_studies becoming_citizen return_5yr asinhexp_liv_cost_winsor " ///
				+ " in_favor_of_migration government_financial_help" 
				
global bc_var_spainrisk = " asinhspain_duration asinhspain_journey_cost spain_beaten spain_forced_work spain_kidnapped spain_sent_back spain_die_boat spain_die_bef_boat " ///

global bc_var_school = " strata_n2 fees50 repeaters transfers ratio_female_second ratio_female_lycee rstudteach rstudadmin rstudclass ratio_tmale ratio_tmaster " ///
				+ " schoolinf_index  "



*individual characteristics

preserve
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_demo using "apptable1.tex",  ///
	 nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) 


restore

*individual characteristics with attendance

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_demo using "table1.tex",  ///
	 nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) 
	
restore



*intentions with attendance

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_intentions using "table2a.tex",  ///
	 nonumbers ctitles(" " " " " " ///
	" ") leftctitle(" ")replace varlabels vce(cluster schoolid) ///
	prefoot("") postfoot("") prehead("") posthead("")  noobservations
restore

*italy risk with attendance

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_italyrisk using "table2b.tex",  ///
	 nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) ///
	prefoot("") postfoot("") prehead("") posthead("") noobservations leftctitle(" ")
restore

*econ with attendance

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_econ using "table2c.tex",  ///
	 nonumbers ctitles(" " " " " " ///
	" ") replace varlabels vce(cluster schoolid) ///
	prefoot("") postfoot("") prehead("") posthead("")  leftctitle(" ")
restore

*spain risk

preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_spainrisk using "apptable2.tex",  ///
	 nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) 

restore

*school characteristics

preserve
keep if n_inclus == 1

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_school using "apptable3.tex",  ///
	 nonumbers ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Double-Control") replace varlabels vce(cluster schoolid) 

restore




*AFROBAROMETER

clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"


use ${main}/Data/output/followup2/BME_final.dta

_pctile age, p(99)
local maxage = `r(r1)'

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

m: migint = J(7,5,.)

* overall population

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

m: migint[1,5] = strtoreal(st_local("N"))
m: migint[1,1] = round(strtoreal(st_local("N1"))/migint[1,5], .01)
m: migint[1,2] = round(strtoreal(st_local("N2"))/migint[1,5], .01)
m: migint[1,3] = round(strtoreal(st_local("N3"))/migint[1,5], .01)
m: migint[1,4] = round(strtoreal(st_local("N4"))/migint[1,5], .01)

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

*only student, max is from our dataset, min is 18 (older)
qui count if country == 11 & q95a == 1 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11 & q95a == 1 & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & q95a == 1 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & q95a == 1 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & q95a == 1 & q68b != -1
local N4 = `r(N)'

m: migint[3,5] = strtoreal(st_local("N"))
m: migint[3,1] = round(strtoreal(st_local("N1"))/migint[3,5], .01)
m: migint[3,2] = round(strtoreal(st_local("N2"))/migint[3,5], .01)
m: migint[3,3] = round(strtoreal(st_local("N3"))/migint[3,5], .01)
m: migint[3,4] = round(strtoreal(st_local("N4"))/migint[3,5], .01)

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

m: migint[4,5] = strtoreal(st_local("N"))
m: migint[4,1] = round(strtoreal(st_local("N1"))/migint[4,5], .01)
m: migint[4,2] = round(strtoreal(st_local("N2"))/migint[4,5], .01)
m: migint[4,3] = round(strtoreal(st_local("N3"))/migint[4,5], .01)
m: migint[4,4] = round(strtoreal(st_local("N4"))/migint[4,5], .01)

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

m: migint[5,5] = strtoreal(st_local("N"))
m: migint[5,1] = round(strtoreal(st_local("N1"))/migint[5,5], .01)
m: migint[5,2] = round(strtoreal(st_local("N2"))/migint[5,5], .01)
m: migint[5,3] = round(strtoreal(st_local("N3"))/migint[5,5], .01)
m: migint[5,4] = round(strtoreal(st_local("N4"))/migint[5,5], .01)

*only student, max is from our dataset, min is 18 (older) from conakry
qui count if country == 11 & q95a == 1 & region == 1300 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11 & q95a == 1 & region == 1300 & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & q95a == 1 & region == 1300 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & q95a == 1 & region == 1300 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & q95a == 1 & region == 1300 & q68b != -1
local N4 = `r(N)'

m: migint[6,5] = strtoreal(st_local("N"))
m: migint[6,1] = round(strtoreal(st_local("N1"))/migint[6,5], .01)
m: migint[6,2] = round(strtoreal(st_local("N2"))/migint[6,5], .01)
m: migint[6,3] = round(strtoreal(st_local("N3"))/migint[6,5], .01)
m: migint[6,4] = round(strtoreal(st_local("N4"))/migint[6,5], .01)



*our dataset
m: migint[7,5] = strtoreal(st_local("Ndataset"))
m: migint[7,1] = round(strtoreal(st_local("desire_mean")), .01)
m: migint[7,3] = round(strtoreal(st_local("planning_mean")), .01)
m: migint[7,4] = round(strtoreal(st_local("prepare_mean")), .01)

m: st_matrix("migint", migint)

matrix colnames migint =  "Somewhat/a lot" "A lot" "Plans"  "Prepares" "\emph{N}"
matrix rownames migint =  "\textbf{Guinea}: All" "\textbf{Guinea}: Young" "\textbf{Guinea}: Student"  "\textbf{Conakry}: All"     "\textbf{Conakry}: Young"    "\textbf{Conakry}: Student"  "\textbf{Our sample}: All, baseline" 

esttab matrix(migint, fmt(%9.2f)) using apptable6.tex, style(tex) replace nomtitles postfoot(" \hline \hline \end{tabular}") ///
	prehead(" \begin{tabular}{l*{6}{c}} \hline \hline   & \multicolumn{2}{c}{Thinks about migration}  &  \multicolumn{2}{c}{Intends to migrate}  &   \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}  ") 


