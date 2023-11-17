clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/followup2/BME_final.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

global logs ${main}/logfiles/
global dta ${main}/Data/dta/


cd "${main}/Draft/tables"

tsset id_number time

global controls  "i.treatment_status i.strata" 
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'


local demographics "i.classe_baseline i.where_born female"
local parents_char  "fath_alive moth_alive i.fath_educ i.moth_educ fath_working moth_working sister_no_win brother_no_win"


*reg f2.migration_internal prepare i.classe_baseline i.where_born female fath_alive moth_alive i.fath_educ i.moth_educ fath_working moth_working sister_no_win brother_no_win  if treatment_status == 1
*reg f2.migration_conakry prepare i.classe_baseline i.where_born female fath_alive moth_alive i.fath_educ i.moth_educ fath_working moth_working sister_no_win brother_no_win  if treatment_status == 1


* Tables for Lucia and Eliana: 14 july 2021


* OLS and IV restricted to who has attendance data, heterogeneity on pessimistic beliefs (weak)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic_weak 3.attended_tr#i.pessimistic_weak 4.attended_tr#i.pessimistic_weak =  i.treatment_status 2.treatment_status#i.pessimistic_weak 3.treatment_status#i.pessimistic_weak 4.treatment_status#i.pessimistic_weak) italy_pessimistic econ_pessimistic  i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic_weak 3.attended_tr#i.pessimistic_weak 4.attended_tr#i.pessimistic_weak =  i.treatment_status 2.treatment_status#i.pessimistic_weak 3.treatment_status#i.pessimistic_weak 4.treatment_status#i.pessimistic_weak) italy_pessimistic econ_pessimistic  i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic_weak 3.attended_tr#i.pessimistic_weak 4.attended_tr#i.pessimistic_weak =  i.treatment_status 2.treatment_status#i.pessimistic_weak 3.treatment_status#i.pessimistic_weak 4.treatment_status#i.pessimistic_weak) italy_pessimistic econ_pessimistic  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

stop

* OLS and IV restricted to who has attendance data, heterogeneity on pessimistic beliefs

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic 3.attended_tr#i.pessimistic 4.attended_tr#i.pessimistic =  i.treatment_status 2.treatment_status#i.pessimistic 3.treatment_status#i.pessimistic 4.treatment_status#i.pessimistic) italy_pessimistic econ_pessimistic i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic 3.attended_tr#i.pessimistic 4.attended_tr#i.pessimistic =  i.treatment_status 2.treatment_status#i.pessimistic 3.treatment_status#i.pessimistic 4.treatment_status#i.pessimistic) i.strata italy_pessimistic econ_pessimistic `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic 3.attended_tr#i.pessimistic 4.attended_tr#i.pessimistic =  i.treatment_status 2.treatment_status#i.pessimistic 3.treatment_status#i.pessimistic 4.treatment_status#i.pessimistic) italy_pessimistic econ_pessimistic  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)





stop


* OLS and IV restricted to who has attendance data

reg f2.migration_guinea i.treatment_status i.strata if f2.migration_conakry < 6 & !missing(f1.time) & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivwithfu1_14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' if f2.migration_conakry < 6 & !missing(f1.time) & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivwithfu1_14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' `parents_char' if f2.migration_conakry < 6 & !missing(f1.time) & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivwithfu1_14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata if f2.migration_conakry < 6 & !missing(f1.time) & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivwithfu1_14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.migration_conakry < 6 & !missing(f1.time) & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivwithfu1_14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.migration_conakry < 6 & !missing(f1.time) & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivwithfu1_14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)



*gen y = f2.migration_guinea
*gen y = prepare
*gen y = f2.migration_conakry
*gen y = f2.migration_internal
*gen y = planning

gen f2migration_guinea = f2.migration_guinea
gen f2migration_conakry = f2.migration_conakry
gen f2migration_internal = f2.migration_internal

global graph_list = " f2migration_guinea " ///
					+ " f2migration_conakry " /// 
					+ " f2migration_internal " ///
					+ " desire " ///
					+ " planning " ///
					+ " prepare " 

					
foreach var in $graph_list {

	gen y = `var'
	
	mat R=J(16, 7, .)

	sum italy_beaten if y == 0 & treatment_status == 1 & time == 0
	mat R[1,1]= `r(mean)'
	mat R[1,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[1,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[1,7]= 2
	sum italy_beaten if y == 1 & treatment_status == 1 & time == 0
	mat R[2,4]= `r(mean)'
	mat R[2,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[2,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[2,7]= 4
	sum italy_forced_work if y == 0 & treatment_status == 1 & time == 0
	mat R[3,1]= `r(mean)'
	mat R[3,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[3,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[3,7]= 7
	sum italy_forced_work if y == 1 & treatment_status == 1 & time == 0
	mat R[4,4]= `r(mean)'
	mat R[4,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[4,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[4,7]= 9
	sum italy_kidnapped if y == 0 & treatment_status == 1 & time == 0
	mat R[5,1]= `r(mean)'
	mat R[5,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[5,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[5,7]= 12
	sum italy_kidnapped if y == 1 & treatment_status == 1 & time == 0
	mat R[6,4]= `r(mean)'
	mat R[6,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[6,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[6,7]= 14
	sum italy_die_bef_boat if y == 0 & treatment_status == 1 & time == 0
	mat R[7,1]= `r(mean)'
	mat R[7,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[7,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[7,7]= 17
	sum italy_die_bef_boat if y == 1 & treatment_status == 1 & time == 0
	mat R[8,4]= `r(mean)'
	mat R[8,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[8,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[8,7]= 19
	sum italy_die_boat if y == 0 & treatment_status == 1 & time == 0
	mat R[9,1]= `r(mean)'
	mat R[9,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[9,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[9,7]= 22
	sum italy_die_boat if y == 1 & treatment_status == 1 & time == 0
	mat R[10,4]= `r(mean)'
	mat R[10,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[10,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[10,7]= 24
	sum italy_sent_back if y == 0 & treatment_status == 1 & time == 0
	mat R[11,1]= `r(mean)'
	mat R[11,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[11,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[11,7]= 27
	sum italy_sent_back if y == 1 & treatment_status == 1 & time == 0
	mat R[12,4]= `r(mean)'
	mat R[12,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[12,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[12,7]= 29
	gen aux = asinhitaly_journey_cost_winsor
	sum aux  if y == 0 & treatment_status == 1 & time == 0
	mat R[13,1]= `r(mean)'
	mat R[13,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[13,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[13,7]= 32
	sum aux if y == 1 & treatment_status == 1 & time == 0
	mat R[14,4]= `r(mean)'
	mat R[14,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[14,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[14,7]= 34
	drop aux
	gen aux = asinhitaly_duration_winsor*10
	sum aux if y == 0 & treatment_status == 1 & time == 0
	mat R[15,1]= `r(mean)'
	mat R[15,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[15,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[15,7]= 37
	sum aux  if y == 1 & treatment_status == 1 & time == 0
	mat R[16,4]= `r(mean)'
	mat R[16,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[16,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[16,7]= 39
	drop aux

	drop y
		
	preserve

	clear
	svmat R
				
	la var R1 "Non-Migrants"
	la var R4 "Migrants"
	la var R7 "Outcome"
	label define groups 3 "Beaten" 8 "Forced Work"  ///
		13 "Kidnapped" 18 "Death bef. boat" ///
		23 "Death boat" 28 "Sent Back"  ///
		33 "Journey Cost" 38 "Journey Duration"
	label values R7 groups

	set scheme s2mono
		
	twoway (bar R1 R7, color(blue) barw(2) fi(inten50) lc(blue) lw(medium) ) ///
		(bar R4 R7, color(yellow) barw(2) fi(inten50) lc(yellow) lw(medium) ) ///
		(rcap R5 R6 R7, lc(gs5)) ///
		(rcap R2 R3 R7, lc(gs5)), ///
		legend(off) xlabel(3(5)40, valuelabel angle(vertical)) ylabel(0(20)70, ) 	///
		graphregion(color(white)) 

	restore

	graph save Graph ${main}/Draft/figures/italybeliefs_`var'.gph, replace
	graph export ${main}/Draft/figures/italybeliefs_`var'.png, replace

}



foreach var in $graph_list {

	gen y = `var'
	
	mat R=J(18, 7, .)
	
	sum finding_job if y == 0 & treatment_status == 1 & time == 0
	mat R[1,1]= `r(mean)'
	mat R[1,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[1,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[1,7]= 2
	sum finding_job if y == 1 & treatment_status == 1 & time == 0
	mat R[2,4]= `r(mean)'
	mat R[2,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[2,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[2,7]= 4
	sum continuing_studies if y == 0 & treatment_status == 1 & time == 0
	mat R[3,1]= `r(mean)'
	mat R[3,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[3,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[3,7]= 7
	sum continuing_studies if y == 1 & treatment_status == 1 & time == 0
	mat R[4,4]= `r(mean)'
	mat R[4,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[4,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[4,7]= 9
	sum becoming_citizen if y == 0 & treatment_status == 1 & time == 0
	mat R[5,1]= `r(mean)'
	mat R[5,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[5,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[5,7]= 12
	sum becoming_citizen if y == 1 & treatment_status == 1 & time == 0
	mat R[6,4]= `r(mean)'
	mat R[6,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[6,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[6,7]= 14
	sum not_return_5yr if y == 0 & treatment_status == 1 & time == 0
	mat R[7,1]= `r(mean)'
	mat R[7,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[7,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[7,7]= 17
	sum not_return_5yr if y == 1 & treatment_status == 1 & time == 0
	mat R[8,4]= `r(mean)'
	mat R[8,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[8,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[8,7]= 19
	sum government_financial_help if y == 0 & treatment_status == 1 & time == 0
	mat R[9,1]= `r(mean)'
	mat R[9,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[9,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[9,7]= 22
	sum government_financial_help if y == 1 & treatment_status == 1 & time == 0
	mat R[10,4]= `r(mean)'
	mat R[10,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[10,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[10,7]= 24
	sum asylum if y == 0 & treatment_status == 1 & time == 0
	mat R[11,1]= `r(mean)'
	mat R[11,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[11,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[11,7]= 27
	sum asylum if y == 1 & treatment_status == 1 & time == 0
	mat R[12,4]= `r(mean)'
	mat R[12,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[12,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[12,7]= 29
	sum in_favor_of_migration if y == 0 & treatment_status == 1 & time == 0
	mat R[13,1]= `r(mean)'
	mat R[13,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[13,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[13,7]= 32
	sum in_favor_of_migration if y == 1 & treatment_status == 1 & time == 0
	mat R[14,4]= `r(mean)'
	mat R[14,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[14,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[14,7]= 34
	gen aux = asinhexp_liv_cost_winsor
	sum aux  if y == 0 & treatment_status == 1 & time == 0
	mat R[15,1]= `r(mean)'
	mat R[15,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[15,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[15,7]= 37
	sum aux if y == 1 & treatment_status == 1 & time == 0
	mat R[16,4]= `r(mean)'
	mat R[16,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[16,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[16,7]= 39
	drop aux
	gen aux = asinhexpectation_wage_winsor
	sum aux if y == 0 & treatment_status == 1 & time == 0
	mat R[17,1]= `r(mean)'
	mat R[17,2]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[17,3]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[17,7]= 42
	sum aux  if y == 1 & treatment_status == 1 & time == 0
	mat R[18,4]= `r(mean)'
	mat R[18,5]= `r(mean)' - `r(sd)'/sqrt(`r(N)')
	mat R[18,6]= `r(mean)' + `r(sd)'/sqrt(`r(N)')
	mat R[18,7]= 45
	drop aux

	drop y
		
	preserve

	clear
	svmat R
				
	la var R1 "Non-Migrants"
	la var R4 "Migrants"
	la var R7 "Outcome"
	label define groups 3 "Finding Job" 8 "Contin. Studies" 13 "Becom. Citiz." ///
	18 "Not Sent Back" 23 "Financial help" 28 "Getting Asylum" ///
	33 "Favor Migration" 38 "Living Cost" 43 "Wage"
	label values R7 groups

	set scheme s2mono
		
	twoway (bar R1 R7, color(blue) barw(2) fi(inten50) lc(blue) lw(medium) ) ///
		(bar R4 R7, color(yellow) barw(2) fi(inten50) lc(yellow) lw(medium) ) ///
		(rcap R5 R6 R7, lc(gs5)) ///
		(rcap R2 R3 R7, lc(gs5)), ///
		legend(off) xlabel(3(5)45, valuelabel angle(vertical)) ylabel(0(20)60, ) 	///
		graphregion(color(white)) 

	restore

	graph save Graph ${main}/Draft/figures/econbeliefs_`var'.gph, replace
	graph export ${main}/Draft/figures/econbeliefs_`var'.png, replace

}

drop f2migration_guinea
drop f2migration_conakry
drop f2migration_internal 




			
	
	

stop

* OLS and IV restricted to who has attendance data (visa)

reg f2.migration_novisaair i.treatment_status i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_novisaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_novisaair i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_novisaair i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_novisaair (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_novisaair (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_novisaair (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_visaair i.treatment_status i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_visaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_visaair i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_visaair i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_visaair (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_visaair (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_visaair (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visaair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisaair14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

stop




* OLS and IV restricted to who has attendance data (visa)

reg f2.migration_novisa i.treatment_status i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_novisa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_novisa i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_novisa i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_novisa (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_novisa (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_novisa (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_novisa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_visa i.treatment_status i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_visa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_visa i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_visa i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_visa (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_visa (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_visa (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_visa if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrvisa14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)




* OLS and IV restricted to who has attendance data

reg f2.migration_internal i.treatment_status i.strata if f2.source_info_guinea < 6 & f2.source_info_conakry < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_internal if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrint14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_internal i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_internal if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrint14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_internal i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_internal if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrint14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_internal (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_internal if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrint14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_internal (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_internal if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrint14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_internal (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_internal if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrint14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)




* OLS and IV restricted to who has attendance data

reg f2.migration_conakry i.treatment_status i.strata if f2.migration_conakry < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrcon14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_conakry i.treatment_status i.strata `demographics' if f2.migration_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_conakry i.treatment_status i.strata `demographics' `parents_char' if f2.migration_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr = i.treatment_status) i.strata if f2.migration_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.migration_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.migration_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)


stop

/*



* OLS and IV restricted to who has attendance data, heterogeneity on bank account

reg f2.migration_conakry i.treatment_status##i.bank_account i.strata if f2.source_info_conakry < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbankcon14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_conakry i.treatment_status##i.bank_account i.strata `demographics' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbankcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_conakry i.treatment_status##i.bank_account i.strata `demographics' `parents_char' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbankcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr i.attended_tr#i.bank_account = i.treatment_status i.treatment_status#i.bank_account) i.bank_account i.strata if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbankcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr i.attended_tr#i.bank_account =  i.treatment_status i.treatment_status#i.bank_account) i.bank_account  i.strata `demographics' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbankcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr i.attended_tr#i.bank_account =  i.treatment_status i.treatment_status#i.bank_account) i.bank_account  i.strata `demographics' `parents_char' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbankcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)




* OLS and IV restricted to who has attendance data, heterogeneity on durables

reg f2.migration_conakry i.treatment_status##i.durables50 i.strata if f2.source_info_conakry < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivdurcon14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_conakry i.treatment_status##i.durables50 i.strata `demographics' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivdurcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_conakry i.treatment_status##i.durables50 i.strata `demographics' `parents_char' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivdurcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr i.attended_tr#i.durables50 = i.treatment_status i.treatment_status#i.durables50) i.durables50 i.strata if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivdurcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr i.attended_tr#i.durables50 =  i.treatment_status i.treatment_status#i.durables50) i.durables50  i.strata `demographics' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivdurcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_conakry (i.attended_tr i.attended_tr#i.durables50 =  i.treatment_status i.treatment_status#i.durables50) i.durables50  i.strata `demographics' `parents_char' if f2.source_info_conakry < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivdurcon14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)


* OLS and IV restricted to who has attendance data, heterogeneity on bank account

reg f2.migration_guinea i.treatment_status##i.bank_account i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbank14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.bank_account i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbank14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.bank_account i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbank14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.bank_account = i.treatment_status i.treatment_status#i.bank_account) i.bank_account i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbank14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.bank_account =  i.treatment_status i.treatment_status#i.bank_account) i.bank_account  i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbank14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.bank_account =  i.treatment_status i.treatment_status#i.bank_account) i.bank_account  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivbank14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)






* OLS and IV restricted to who has attendance data, heterogeneity on pessimistic beliefs

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic 3.attended_tr#i.pessimistic 4.attended_tr#i.pessimistic =  i.treatment_status 2.treatment_status#i.pessimistic 3.treatment_status#i.pessimistic 4.treatment_status#i.pessimistic) italy_pessimistic econ_pessimistic i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic 3.attended_tr#i.pessimistic 4.attended_tr#i.pessimistic =  i.treatment_status 2.treatment_status#i.pessimistic 3.treatment_status#i.pessimistic 4.treatment_status#i.pessimistic) i.strata italy_pessimistic econ_pessimistic `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic 3.attended_tr#i.pessimistic 4.attended_tr#i.pessimistic =  i.treatment_status 2.treatment_status#i.pessimistic 3.treatment_status#i.pessimistic 4.treatment_status#i.pessimistic) italy_pessimistic econ_pessimistic  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)




* OLS and IV restricted to who has attendance data, heterogeneity on pessimistic beliefs (weak)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.treatment_status#i.pessimistic_weak italy_pessimistic econ_pessimistic i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic_weak 3.attended_tr#i.pessimistic_weak 4.attended_tr#i.pessimistic_weak =  i.treatment_status 2.treatment_status#i.pessimistic_weak 3.treatment_status#i.pessimistic_weak 4.treatment_status#i.pessimistic_weak) italy_pessimistic econ_pessimistic  i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic_weak 3.attended_tr#i.pessimistic_weak 4.attended_tr#i.pessimistic_weak =  i.treatment_status 2.treatment_status#i.pessimistic_weak 3.treatment_status#i.pessimistic_weak 4.treatment_status#i.pessimistic_weak) italy_pessimistic econ_pessimistic  i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr 2.attended_tr#i.pessimistic_weak 3.attended_tr#i.pessimistic_weak 4.attended_tr#i.pessimistic_weak =  i.treatment_status 2.treatment_status#i.pessimistic_weak 3.treatment_status#i.pessimistic_weak 4.treatment_status#i.pessimistic_weak) italy_pessimistic econ_pessimistic  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivpessim_weak14072021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

*/



stop




*Tables for Lucia: 30 june 2021

/*
* OLS and IV restricted to who has attendance data

reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestr30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestr30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestr30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestr30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestr30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestr30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)



* OLS NOT restricted to who has attendance data


reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea < 6, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using ols30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using ols30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using ols30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)



* OLS and IV restricted to who has attendance data

reg f2.migration_noair i.treatment_status i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_noair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_noair i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_noair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_noair i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_noair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_noair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_noair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_noair if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_air i.treatment_status i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_air if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_air i.treatment_status i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_air if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_air i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_air if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_air (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_air if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_air (i.attended_tr = i.treatment_status) i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_air if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_air (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_air if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrair30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)



* OLS and IV restricted to who has attendance data, heterogeneity on durables

reg f2.migration_guinea i.treatment_status##i.durables50 i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrdur30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.durables50 i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrdur30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.durables50 i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrdur30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.durables50 = i.treatment_status i.treatment_status#i.durables50) i.durables50 i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrdur30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.durables50 =  i.treatment_status i.treatment_status#i.durables50) i.durables50  i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrdur30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.durables50 =  i.treatment_status i.treatment_status#i.durables50) i.durables50  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrdur30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)




* OLS on route selection

reg f1.route_chosen i.treatment_status i.strata route_chosen if time == 0, cluster(schoolid)
qui sum route_chosen if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routechosen30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.route_chosen i.treatment_status i.strata route_chosen `demographics' if time == 0, cluster(schoolid)
qui sum route_chosen if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routechosen30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.route_chosen i.treatment_status i.strata route_chosen `demographics' `parents_char' if time == 0, cluster(schoolid)
qui sum route_chosen if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routechosen30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.route_chosen i.treatment_status i.strata route_chosen, cluster(schoolid)
qui sum route_chosen if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routechosen30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.route_chosen i.treatment_status i.strata route_chosen `demographics', cluster(schoolid)
qui sum route_chosen if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routechosen30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.route_chosen i.treatment_status i.strata route_chosen `demographics' `parents_char', cluster(schoolid)
qui sum route_chosen if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routechosen30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)





* OLS on route knowledge

reg f1.italy_someknow i.treatment_status i.strata italy_someknow if time == 0, cluster(schoolid)
qui sum italy_someknow if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.italy_someknow i.treatment_status i.strata italy_someknow `demographics' if time == 0, cluster(schoolid)
qui sum italy_someknow if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.italy_someknow i.treatment_status i.strata italy_someknow `demographics' `parents_char' if time == 0, cluster(schoolid)
qui sum italy_someknow if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.spain_someknow i.treatment_status i.strata spain_someknow if time == 0, cluster(schoolid)
qui sum spain_someknow if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.spain_someknow i.treatment_status i.strata spain_someknow `demographics' if time == 0, cluster(schoolid)
qui sum spain_someknow if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.spain_someknow i.treatment_status i.strata spain_someknow `demographics' `parents_char' if time == 0, cluster(schoolid)
qui sum spain_someknow if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.italy_someknow i.treatment_status i.strata italy_someknow, cluster(schoolid)
qui sum italy_someknow if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.italy_someknow i.treatment_status i.strata italy_someknow `demographics', cluster(schoolid)
qui sum italy_someknow if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.italy_someknow i.treatment_status i.strata italy_someknow `demographics' `parents_char', cluster(schoolid)
qui sum italy_someknow if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.spain_someknow i.treatment_status i.strata spain_someknow, cluster(schoolid)
qui sum spain_someknow if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.spain_someknow i.treatment_status i.strata spain_someknow `demographics', cluster(schoolid)
qui sum spain_someknow if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.spain_someknow i.treatment_status i.strata spain_someknow `demographics' `parents_char', cluster(schoolid)
qui sum spain_someknow if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

stop




* OLS on route selection

preserve
gen route_switch1 = .
replace route_switch1 = 1 if route_chosen == l.route_chosen & time == 1 & !missing(route_chosen) & !missing(l.route_chosen)
replace route_switch1 = 0 if route_chosen != l.route_chosen & time == 1 & !missing(route_chosen) & !missing(l.route_chosen)

reg f1.route_switch1 i.treatment_status i.strata if time == 0, cluster(schoolid)
qui sum route_switch1 if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.route_switch1 i.treatment_status i.strata `demographics' if time == 0, cluster(schoolid)
qui sum route_switch1 if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.route_switch1 i.treatment_status i.strata `demographics' `parents_char' if time == 0, cluster(schoolid)
qui sum route_switch1 if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

gen route_switch2 = .
replace route_switch2 = 1 if route_chosen == l2.route_chosen & time == 2 & !missing(route_chosen) & !missing(l2.route_chosen)
replace route_switch2 = 0 if route_chosen != l2.route_chosen & time == 2 & !missing(route_chosen) & !missing(l2.route_chosen)

reg f2.route_switch2 i.treatment_status i.strata, cluster(schoolid)
qui sum route_switch2 if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.route_switch2 i.treatment_status i.strata `demographics', cluster(schoolid)
qui sum route_switch2 if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.route_switch2 i.treatment_status i.strata `demographics' `parents_char', cluster(schoolid)
qui sum route_switch2 if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using routeknowledge30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)
restore

*/

* OLS migration intentions, second follow up


reg f2.desire i.treatment_status i.strata desire if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.desire i.treatment_status i.strata desire `demographics' if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.desire i.treatment_status i.strata desire `demographics' `parents_char' if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.planning i.treatment_status i.strata planning if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.planning i.treatment_status i.strata planning `demographics' if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.planning i.treatment_status i.strata planning `demographics' `parents_char' if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.prepare i.treatment_status i.strata prepare, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.prepare i.treatment_status i.strata prepare `demographics' if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.prepare i.treatment_status i.strata prepare `demographics' `parents_char' if f2.surveycto_lycee == 1, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions2fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)


* OLS migration intentions, first follow up


reg f1.desire i.treatment_status i.strata desire if time == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.desire i.treatment_status i.strata desire `demographics' if time == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.desire i.treatment_status i.strata desire `demographics' `parents_char' if time == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.planning i.treatment_status i.strata planning if time == 0, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.planning i.treatment_status i.strata planning `demographics' if time == 0, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.planning i.treatment_status i.strata planning `demographics' `parents_char' if time == 0, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.prepare i.treatment_status i.strata prepare, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.prepare i.treatment_status i.strata prepare `demographics' if time == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f1.prepare i.treatment_status i.strata prepare `demographics' `parents_char' if time == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentions1fu30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)


stop

/*


* OLS and IV restricted to who has attendance data, heterogeneity on fees

reg f2.migration_guinea i.treatment_status##i.fees50 i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrfee30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.fees50 i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrfee30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.fees50 i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrfee30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.fees50 = i.treatment_status i.treatment_status#i.fees50) i.fees50 i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrfee30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.fees50 =  i.treatment_status i.treatment_status#i.fees50) i.fees50  i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrfee30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.fees50 =  i.treatment_status i.treatment_status#i.fees50) i.fees50  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrfee30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)




* OLS and IV restricted to who has attendance data, heterogeneity on risk beliefs

reg f2.migration_guinea i.treatment_status##i.italy_index50 i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrrisk30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.italy_index50 i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrrisk30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.italy_index50 i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrrisk30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.italy_index50 = i.treatment_status i.treatment_status#i.italy_index50) i.italy_index50 i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrrisk30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.italy_index50 =  i.treatment_status i.treatment_status#i.italy_index50) i.italy_index50  i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrrisk30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.italy_index50 =  i.treatment_status i.treatment_status#i.italy_index50) i.italy_index50  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrrisk30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)



*/


* OLS and IV restricted to who has attendance data, heterogeneity on econ beliefs

reg f2.migration_guinea i.treatment_status##i.economic_index50 i.strata if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrecon30062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.economic_index50 i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrecon30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status##i.economic_index50 i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrecon30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.economic_index50 = i.treatment_status i.treatment_status#i.economic_index50) i.economic_index50 i.strata if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrecon30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.economic_index50 =  i.treatment_status i.treatment_status#i.economic_index50) i.economic_index50  i.strata `demographics' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrecon30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr i.attended_tr#i.economic_index50 =  i.treatment_status i.treatment_status#i.economic_index50) i.economic_index50  i.strata `demographics' `parents_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using olsivrestrecon30062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)



stop















reg f2.migration_noair i.treatment_status i.strata if f2.source_info_guinea < 5  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_noair i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 5 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 5  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 5 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)










*Tables for Lucia: 15 june 2021

*MIGRATION


reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea < 5 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 5, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 5 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 5, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_noair i.treatment_status i.strata if f2.source_info_guinea < 5 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_noair i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 5, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 5 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 5, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)





*MIGRATION (restricted sample)

reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea < 5  & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_guinea i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 5 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 5 & attended_tr != . , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 5 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_noair i.treatment_status i.strata if f2.source_info_guinea < 5 & attended_tr != . , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

reg f2.migration_noair i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 5 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata if f2.source_info_guinea < 5 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)

ivreg2 f2.migration_noair (i.attended_tr = i.treatment_status) i.strata `demographics' `parents_char' if f2.source_info_guinea < 5 & attended_tr != ., cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration15062021res.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status 2.attended_tr 3.attended_tr 4.attended_tr)




stop







*Tables for Lucia: 08 june 2021

*MIGRATION


reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea < 4 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata `demographics' if f2.source_info_guinea < 4, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 4, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_noair i.treatment_status i.strata if f2.source_info_guinea < 4 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_noair i.treatment_status i.strata `demographics' if f2.source_info_guinea < 4, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_noair i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_guinea < 4, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if f2.source_info_conakry < 4 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata `demographics' if f2.source_info_conakry < 4, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata `demographics' `parents_char' if f2.source_info_conakry < 4, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration08062021.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 










reg f2.mig_novisa i.treatment_status i.strata , cluster(schoolid)





	 



 

mat store=J(160,10,.)
qui levelsof schoolid
local lev `r(levels)' 
local row 0
foreach val in `lev' {
	reg f2.migration_guinea i.treatment_status i.strata if schoolid != `val', cluster(schoolid)
	local n_treat=1
	local ++row
	
	local N e(N)
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {

		mat store[`row',1]=_b[i2.treatment_status]
		mat store[`row',2]=_b[i2.treatment_status]-invttail(`N',0.05) *_se[i2.treatment_status]
		mat store[`row',3]=_b[i2.treatment_status]+invttail(`N',0.05) *_se[i2.treatment_status]

		mat store[`row',4]=_b[i3.treatment_status]
		mat store[`row',5]=_b[i3.treatment_status]-invttail(`N',0.05) *_se[i3.treatment_status]
		mat store[`row',6]=_b[i3.treatment_status]+invttail(`N',0.05) *_se[i3.treatment_status]

		mat store[`row',7]=_b[i4.treatment_status]
		mat store[`row',8]=_b[i4.treatment_status]-invttail(`N',0.05) *_se[i4.treatment_status]
		mat store[`row',9]=_b[i4.treatment_status]+invttail(`N',0.05) *_se[i4.treatment_status]
		
		mat store[`row',10] = `val'
	local ++n_treat
	}
}


preserve
clear
svmat store

hist store1, bin(30)
graph export "${main}/Draft/figures/risk_estimates.png", replace as(png)
graph save "${main}/Draft/figures/risk_estimates.gph", replace

hist store3, bin(30)
graph export "${main}/Draft/figures/risk_higherconf.png", replace as(png)
graph save "${main}/Draft/figures/risk_higherconf.gph", replace

restore


	 
foreach var in $italy_outcomes {
	gen l2`var' = l2.`var'
}
   
   local route italy
wyoung $italy_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 CONTROLVARS, cluster(schoolid) a(strata)) familyp(T1 T2 T3) controls("l2asinh`route'_duration_winsor" "l2asinh`route'_journey_cost_winsor" "l2`route'_beaten" "l2`route'_forced_work" "l2`route'_kidnapped"  "l2`route'_die_bef_boat"  "l2`route'_die_boat" "l2`route'_sent_back") bootstraps(10) seed(123) strata(strata) cluster(schoolid)

	 
****5 June 2021

log using ${logs}log05042021.smcl, replace

ivreg2 f2.migration_guinea (i.attended_tr = i.treatment_status) i.strata, cluster(schoolid)
ivreg2 f2.migration_guinea i.treatment_status i.strata if attended_tr !=., cluster(schoolid)
ivreg2 f2.migration_guinea i.treatment_status i.strata, cluster(schoolid)

ivreg2 f2.migration_irr (i.attended_tr = i.treatment_status) i.strata, cluster(schoolid)
ivreg2 f2.migration_irr i.treatment_status i.strata if attended_tr !=., cluster(schoolid)
ivreg2 f2.migration_irr i.treatment_status i.strata, cluster(schoolid)

log close

translate ${logs}log05042021.smcl  ${logs}log05042021.pdf, translator(smcl2pdf) replace


*aggregare preschool diversamente

/*

*tabu migration_conakry migration_guinea



gen migration_ill = migration_guinea if !missing(migration_guinea)

replace migration_ill = 1 if  (migrated_returned_p == 1 ) |  (migrated_returned_p == . & migrated_returned_contact_sec_p == 1 ) |  (migrated_returned_p == . & migrated_returned_contact_sec_p == . & migrated_returned_contact_p == 1)  



*replace migration_ill = 0 if  (continent != "AFRICA" & mig_6_p == 1) |  (continent != "AFRICA" & mig_6_contact_p == 1) |  (continent != "AFRICA" & mig_6_contact_sec_p == 1)


replace migration_ill = 1 if  (migrated_returned_p == 1 & past_mig7_p ==1) |  (migrated_returned_contact_p == 1& past_mig7_contact_p ==1) |  (migrated_returned_contact_sec_p == 1 & past_mig7_contact_sec_p ==1) 


replace migration_ill = 0 if  (mig_6_p == 1) |  (mig_6_contact_p == 1) |  (mig_6_contact_sec_p == 1)

replace migration_ill = 0 if  (past_mig9_p == 1) |  (past_mig9_contact_p == 1) |  (past_mig9_contact_sec_p == 1)




replace migration_ill = 0 if  (mig_1_p != "AFRICA" & mig_6_p == 1) |  (mig_1_contact_p != "AFRICA" & mig_6_contact_p == 1) |  (mig_1_contact_sec_p != "AFRICA" & mig_6_contact_sec_p == 1)

replace migration_ill = 0 if  (mig_11_p == 2 | mig_14_p == "AFRICA") |  (mig_11_p == 2 | mig_14_contact_p == "AFRICA") |  (mig_11_contact_sec_p == 2 | mig_14_contact_sec_p == "AFRICA" ) 


*/


****26 February 2021


*ssc install spmap
*ssc install shp2dta
*ssc install mif2dta
*ssc install kountry

*use ${dta}worldcoor.dta, clear
*drop if _ID == 44 & _X <-40
*save ${dta}worldcoor_noguyana.dta, replace

/*

****COUNTRY IN (irr. migration)
preserve
rename _merge _merge13
keep if migration_irr == 1
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/tables/spring2021/mapmigration_irregular.png", replace as(png)
graph save "${main}/Draft/tables/spring2021/mapmigration_irregular.gph", replace
restore

****COUNTRY IN 
preserve
rename _merge _merge13
rename country_in ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/tables/spring2021/mapmigration.png", replace as(png)
graph save "${main}/Draft/tables/spring2021/mapmigration.gph", replace
restore

****DESIRED COUNTRY
preserve
rename _merge _merge13
kountry country, from(cowc) to(iso3c)
rename desired_country ISO_A3_EH
gen counting = 1
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
keep if CONTINENT == "Europe"
drop if SOVEREIGNT == "Russia"
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Blues)
graph export "${main}/Draft/tables/spring2021/mapchosencountry.png", replace as(png)
graph save "${main}/Draft/tables/spring2021/mapchosencountry.gph", replace
restore

*/

*Tables for Eliana

*MIGRATION

/*
reg f2.migration_guinea i.treatment_status i.strata, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata, cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline  , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_guinea.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline  , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

*/


*MIGRATION


reg f2.migration_guinea i.treatment_status i.strata if classe_baseline == 7, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.b999.fath_educ i.b999.moth_educ  if classe_baseline == 7, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata  if classe_baseline == 7 , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male if classe_baseline == 7, cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_guinea.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if classe_baseline == 7, cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if classe_baseline == 7, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male  if classe_baseline == 7, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.b999.fath_educ i.b999.moth_educ  if classe_baseline == 7, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_highage.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*



*MIGRATION (ONLY UP TO SSS)


reg f2.migration_guinea i.treatment_status i.strata if f2.source_info_guinea <= 3, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline if f2.source_info_guinea <= 3 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  if f2.source_info_guinea <= 3 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if f2.source_info_guinea <= 3, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata if f2.source_info_guinea <= 3, cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline if f2.source_info_guinea <= 3 , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline  if f2.source_info_guinea <= 3 , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if f2.source_info_guinea <= 3, cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if f2.source_info_conakry <= 3, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline if f2.source_info_conakry <= 3, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline  if f2.source_info_conakry <= 3, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if f2.source_info_conakry <= 3, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & source_info_conakry <= 3
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_alsss.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/



/*

*MIGRATION INTENTIONS AT FU2 (ONLY TABLET)

reg f2.desire i.treatment_status  i.strata desire if f2.source_info_conakry == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

reg f2.desire i.treatment_status i.strata desire i.classe_baseline if f2.source_info_conakry == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

/*
reg f2.desire i.treatment_status i.strata desire  male i.classe_baseline  if f2.source_info_conakry == 0 , cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)
*/

reg f2.desire i.treatment_status i.strata desire  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if f2.source_info_conakry == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)



reg f2.planning i.treatment_status i.strata planning if f2.source_info_conakry == 0, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.planning i.treatment_status i.strata planning i.classe_baseline if f2.source_info_conakry == 0 , cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

/*
reg f2.planning i.treatment_status i.strata planning  male i.classe_baseline  if f2.source_info_conakry == 0 , cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)
*/

reg f2.planning i.treatment_status i.strata planning  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if f2.source_info_conakry == 0, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)


reg f2.prepare i.treatment_status i.strata prepare if f2.source_info_conakry == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

reg f2.prepare i.treatment_status i.strata prepare i.classe_baseline if f2.source_info_conakry == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

/*
reg f2.prepare i.treatment_status i.strata prepare  male i.classe_baseline  if f2.source_info_conakry == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)
*/

reg f2.prepare i.treatment_status i.strata prepare  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if f2.source_info_conakry == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 2 & source_info_conakry == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu2.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)




*MIGRATION INTENTIONS AT FU1

reg f1.desire i.treatment_status  i.strata desire if time == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

reg f1.desire i.treatment_status i.strata desire i.classe_baseline if time == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

/*
reg f1.desire i.treatment_status i.strata desire  male i.classe_baseline  if time == 0 , cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)
*/

reg f1.desire i.treatment_status i.strata desire  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if time == 0, cluster(schoolid)
qui sum desire if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)



reg f1.planning i.treatment_status i.strata planning if time == 0, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f1.planning i.treatment_status i.strata planning i.classe_baseline if time == 0 , cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

/*
reg f1.planning i.treatment_status i.strata planning  male i.classe_baseline  if time == 0 , cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)
*/

reg f1.planning i.treatment_status i.strata planning  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if time == 0, cluster(schoolid)
qui sum planning if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)


reg f1.prepare i.treatment_status i.strata prepare if  time == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

reg f1.prepare i.treatment_status i.strata prepare i.classe_baseline if  time == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

/*
reg f1.prepare i.treatment_status i.strata prepare  male i.classe_baseline  if  time == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)
*/

reg f1.prepare i.treatment_status i.strata prepare  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if  time == 0, cluster(schoolid)
qui sum prepare if treatment_status == 1 & time == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using intentionsfu1.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons sortvar(2.treatment_status 3.treatment_status 4.treatment_status desire planning prepare)

*/


/*

*MIGRATION AND WEALTH


reg f2.migration_guinea i.treatment_status i.strata  if durables50 == 0, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline  if durables50 == 0, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  if durables50 == 0 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if durables50 == 0 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata if durables50 == 0, cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline if durables50 == 0 , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline if durables50 == 0  , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if durables50 == 0 , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if durables50 == 0, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline if durables50 == 0 , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline   if durables50 == 0, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if durables50 == 0, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 0
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50low.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 





reg f2.migration_guinea i.treatment_status i.strata  if durables50 == 1, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline  if durables50 == 1, cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  if durables50 == 1 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if durables50 == 1 , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata if durables50 == 1, cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline if durables50 == 1 , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline if durables50 == 1  , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if durables50 == 1 , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if durables50 == 1, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline if durables50 == 1 , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline   if durables50 == 1, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if durables50 == 1, cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.durables50 == 1
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_durables50high.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 



*/


/*



*MIGRATION AND RISK PERCEPTIONS

qui sum italy_index, detail
local median_italyrisk  `r(p50)'

reg f2.migration_guinea i.treatment_status i.strata  if  italy_index < `median_italyrisk', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline  if  italy_index < `median_italyrisk', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  if  italy_index < `median_italyrisk' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  italy_index < `median_italyrisk' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata if  italy_index < `median_italyrisk', cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline if  italy_index < `median_italyrisk' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline if  italy_index < `median_italyrisk'  , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  italy_index < `median_italyrisk' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if  italy_index < `median_italyrisk', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline if  italy_index < `median_italyrisk' , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline   if  italy_index < `median_italyrisk', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if  italy_index < `median_italyrisk', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index < `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 





reg f2.migration_guinea i.treatment_status i.strata  if  italy_index >= `median_italyrisk', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline  if  italy_index >= `median_italyrisk', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  if  italy_index >= `median_italyrisk' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  italy_index >= `median_italyrisk' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata if  italy_index >= `median_italyrisk', cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline if  italy_index >= `median_italyrisk' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline if  italy_index >= `median_italyrisk'  , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  italy_index >= `median_italyrisk' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if  italy_index >= `median_italyrisk', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline if  italy_index >= `median_italyrisk' , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline   if  italy_index >= `median_italyrisk', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if  italy_index >= `median_italyrisk', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.italy_index >= `median_italyrisk'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_riskpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

*/





*MIGRATION AND ECON PERCEPTIONS

qui sum economic_index, detail
local median_econ  `r(p75)'

reg f2.migration_guinea i.treatment_status i.strata  if  economic_index < `median_econ', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline  if  economic_index < `median_econ', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  if  economic_index < `median_econ' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  economic_index < `median_econ' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata if  economic_index < `median_econ', cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline if  economic_index < `median_econ' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline if  economic_index < `median_econ'  , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  economic_index < `median_econ' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if  economic_index < `median_econ', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline if  economic_index < `median_econ' , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline   if  economic_index < `median_econ', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if  economic_index < `median_econ', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index < `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econpess.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 





reg f2.migration_guinea i.treatment_status i.strata  if  economic_index >= `median_econ', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, replace label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_guinea i.treatment_status i.strata i.classe_baseline  if  economic_index >= `median_econ', cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline  if  economic_index >= `median_econ' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_guinea i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  economic_index >= `median_econ' , cluster(schoolid)
qui sum migration_guinea if l2.treatment_status == 1  &  source_info_guinea < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata if  economic_index >= `median_econ', cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_irr i.treatment_status i.strata i.classe_baseline if  economic_index >= `median_econ' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline if  economic_index >= `median_econ'  , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_irr i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ if  economic_index >= `median_econ' , cluster(schoolid)
qui sum migration_irr if treatment_status == 1 & time == 2 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 


reg f2.migration_conakry i.treatment_status i.strata if  economic_index >= `median_econ', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

reg f2.migration_conakry i.treatment_status i.strata i.classe_baseline if  economic_index >= `median_econ' , cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 

/*
reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline   if  economic_index >= `median_econ', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 
*/

reg f2.migration_conakry i.treatment_status i.strata  male i.classe_baseline i.b999.fath_educ i.b999.moth_educ  if  economic_index >= `median_econ', cluster(schoolid)
qui sum migration_conakry if l2.treatment_status == 1 & time == 2 &  source_info_conakry < 6 & l2.economic_index >= `median_econ'
local cont = string(`r(mean)', "%9.3f")  
outreg2 using migration_econopt.xls, append label ct(" ") addtext(Baseline Mean Contr., `cont') dec(3) nonotes  nocons 




stop



****25 February 2021

***log a

log using ${logs}log25022021_a.smcl, replace

***IMPACT OF THE TREATMENT BY RISK PERCEPTIONS AT BASELINE (PCA)
qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_index < `r(p50)', cluster(schoolid_str) 
qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_index >= `r(p50)', cluster(schoolid_str) 

qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_index < `r(p25)', cluster(schoolid_str) 
qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_index >= `r(p25)', cluster(schoolid_str) 

qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_index < `r(p75)', cluster(schoolid_str) 
qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_index >= `r(p75)', cluster(schoolid_str) 

***IMPACT OF THE TREATMENT BY ECONOMIC PERCEPTIONS AT BASELINE (PCA)
qui sum economic_index, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_index < `r(p50)', cluster(schoolid_str) 
qui sum economic_index, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_index >= `r(p50)', cluster(schoolid_str) 

qui sum economic_index, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_index < `r(p25)', cluster(schoolid_str) 
qui sum economic_index, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_index >= `r(p25)', cluster(schoolid_str) 

qui sum economic_index, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_index < `r(p75)', cluster(schoolid_str) 
qui sum economic_index, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_index >= `r(p75)', cluster(schoolid_str) 

log close

translate ${logs}log25022021_a.smcl  ${logs}log25022021_a.pdf, translator(smcl2pdf) replace


log using ${logs}log25022021_b.smcl, replace

***IMPACT OF THE TREATMENT BY ECONOMIC PERCEPTIONS AT BASELINE (KLING NEG COST)
qui sum italy_kling_negcost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_negcost < `r(p50)', cluster(schoolid_str) 
qui sum italy_kling_negcost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_negcost >= `r(p50)', cluster(schoolid_str) 

qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_negcost < `r(p25)', cluster(schoolid_str) 
qui sum italy_index, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_negcost >= `r(p25)', cluster(schoolid_str) 

qui sum italy_kling_negcost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_negcost < `r(p75)', cluster(schoolid_str) 
qui sum italy_kling_negcost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_negcost >= `r(p75)', cluster(schoolid_str) 

***IMPACT OF THE TREATMENT BY ECONOMIC PERCEPTIONS AT BASELINE (KLING POS COST)
qui sum italy_kling_poscost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_poscost < `r(p50)', cluster(schoolid_str) 
qui sum italy_kling_poscost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_poscost >= `r(p50)', cluster(schoolid_str) 

qui sum italy_kling_poscost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_poscost < `r(p25)', cluster(schoolid_str) 
qui sum italy_kling_poscost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_poscost >= `r(p25)', cluster(schoolid_str) 

qui sum italy_kling_poscost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_poscost < `r(p75)', cluster(schoolid_str) 
qui sum italy_kling_poscost, detail
reg f2.migration_guinea i.treatment_status i.strata if italy_kling_poscost >= `r(p75)', cluster(schoolid_str) 

***IMPACT OF THE TREATMENT BY ECONOMIC PERCEPTIONS AT BASELINE (KLING)
qui sum economic_kling, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_kling < `r(p50)', cluster(schoolid_str) 
qui sum economic_kling, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_kling >= `r(p50)', cluster(schoolid_str) 

qui sum economic_kling, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_kling < `r(p25)', cluster(schoolid_str) 
qui sum economic_kling, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_kling >= `r(p25)', cluster(schoolid_str) 

qui sum economic_kling, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_kling < `r(p75)', cluster(schoolid_str) 
qui sum economic_kling, detail
reg f2.migration_guinea i.treatment_status i.strata if economic_kling >= `r(p75)', cluster(schoolid_str) 

log close

translate ${logs}log25022021_b.smcl  ${logs}log25022021_b.pdf, translator(smcl2pdf) replace



***log c
drop dist_risk dist_beaten dist_forced_work dist_duration_winsor
gen dist_beaten = italy_beaten - 70
qui sum dist_beaten if time == 0
gen dist_risk = (dist_beaten)/`r(sd)'

gen dist_forced_work = italy_forced_work - 90
qui sum dist_forced_work if time == 0
replace dist_risk =  dist_risk + (dist_forced_work)/`r(sd)'

gen dist_duration_winsor = italy_duration_winsor - 6
qui sum dist_duration_winsor if time == 0
replace dist_risk =  dist_risk + (dist_duration_winsor)/`r(sd)'

qui sum dist_risk if time == 0
replace dist_risk = dist_risk/3

replace dist_risk = (dist_risk - `r(mean)')/`r(sd)'

****24 February 2021

***log d
log using ${logs}log24022021_d.smcl, replace


tab migration_guinea
tab country
tab continent
tab migration_irr

reg f2.migration_irr i.treatment_status i.strata, cluster(schoolid_str) 
reg f2.migration_irr i.treatment_status i.strata male, cluster(schoolid_str) 
reg f2.migration_irr i.treatment_status i.strata i.classe_baseline, cluster(schoolid_str) 
reg f2.migration_irr i.treatment_status i.strata fees i.classe_baseline male, cluster(schoolid_str) 

log close

translate ${logs}log24022021_d.smcl  ${logs}log24022021_d.pdf, translator(smcl2pdf) replace

*** log c

***INTENTIONS AND CHOICES, CONAKRY
reg f2.migration_conakry desire  if treatment_status == 1
reg f2.migration_conakry planning  if treatment_status == 1
reg f2.migration_conakry prepare  if treatment_status == 1

***INTENTIONS AND CHOICES, CONAKRY, ONLY FEMALE
reg f2.migration_conakry desire  if treatment_status == 1 & female == 1
reg f2.migration_conakry planning  if treatment_status == 1 & female == 1
reg f2.migration_conakry prepare  if treatment_status == 1 & female == 1

***INTENTIONS AND CHOICES, GUINEA
reg f2.migration_guinea desire  if treatment_status == 1
reg f2.migration_guinea planning  if treatment_status == 1
reg f2.migration_guinea prepare  if treatment_status == 1

***INTENTIONS AND CHOICES, GUINEA, ONLY FEMALE
reg f2.migration_guinea desire  if treatment_status == 1 & female == 1
reg f2.migration_guinea planning  if treatment_status == 1 & female == 1
reg f2.migration_guinea prepare  if treatment_status == 1 & female == 1


***log b

***IMPACT ON INTENTIONS
reg f2.desire i.treatment_status desire i.strata, cluster(schoolid_str)
reg f2.planning i.treatment_status planning i.strata, cluster(schoolid_str)
reg f2.prepare i.treatment_status prepare i.strata, cluster(schoolid_str)

***IMPACT ON INTENTIONS RESTRICTING TO SCHOOL SURVEY
reg f2.desire i.treatment_status desire i.strata if f2.surveycto_lycee == 1, cluster(schoolid_str)
reg f2.planning i.treatment_status planning i.strata if f2.surveycto_lycee == 1, cluster(schoolid_str)
reg f2.prepare i.treatment_status prepare i.strata if f2.surveycto_lycee == 1, cluster(schoolid_str)

***IMPACT ON INTENTIONS INTERACTED WITH GENDER
reg f2.desire i.treatment_status##i.female desire i.strata, cluster(schoolid_str)
reg f2.planning i.treatment_status##i.female planning i.strata, cluster(schoolid_str)
reg f2.prepare i.treatment_status##i.female prepare i.strata, cluster(schoolid_str)

***IMPACT ON INTENTIONS RESTRICTING TO SCHOOL SURVEY , INTERACTED WITH GENDER
reg f2.desire i.treatment_status##i.female desire i.strata if f2.surveycto_lycee == 1, cluster(schoolid_str)
reg f2.planning i.treatment_status##i.female planning i.strata if f2.surveycto_lycee == 1, cluster(schoolid_str)
reg f2.prepare i.treatment_status##i.female prepare i.strata if f2.surveycto_lycee == 1, cluster(schoolid_str)

***IMPACT ON INTENTIONS INTERACTED ONLY FEMALE
reg f2.desire i.treatment_status desire i.strata if female == 1, cluster(schoolid_str)
reg f2.planning i.treatment_status planning i.strata if female == 1, cluster(schoolid_str)
reg f2.prepare i.treatment_status prepare i.strata if female == 1, cluster(schoolid_str)

***IMPACT ON INTENTIONS RESTRICTING TO SCHOOL SURVEY ,  ONLY FEMALE
reg f2.desire i.treatment_status desire i.strata if f2.surveycto_lycee == 1 &  female == 1, cluster(schoolid_str)
reg f2.planning i.treatment_status planning i.strata if f2.surveycto_lycee == 1 & female == 1, cluster(schoolid_str)
reg f2.prepare i.treatment_status prepare i.strata if f2.surveycto_lycee == 1 &  female == 1, cluster(schoolid_str)

***IMPACT ON INTENTIONS INTERACTED  ONLY MALE
reg f2.desire i.treatment_status desire i.strata if female == 0, cluster(schoolid_str)
reg f2.planning i.treatment_status planning i.strata if female == 0 , cluster(schoolid_str)
reg f2.prepare i.treatment_status prepare i.strata if female == 0, cluster(schoolid_str)

***IMPACT ON INTENTIONS RESTRICTING TO SCHOOL SURVEY ,  ONLY MALE
reg f2.desire i.treatment_status desire i.strata if f2.surveycto_lycee == 1 & female == 0, cluster(schoolid_str)
reg f2.planning i.treatment_status planning i.strata if f2.surveycto_lycee == 1 & female == 0, cluster(schoolid_str)
reg f2.prepare i.treatment_status prepare i.strata if f2.surveycto_lycee == 1 & female == 0, cluster(schoolid_str)





***log a

reg f2.migration_guinea i.treatment_status##i.female i.strata, cluster(schoolid_str)
reg f2.migration_conakry i.treatment_status##i.female i.strata, cluster(schoolid_str)

reg f2.migration_guinea i.treatment_status i.strata if female == 0, cluster(schoolid_str)
reg f2.migration_guinea i.treatment_status i.strata if female == 1, cluster(schoolid_str)

reg f2.migration_conakry i.treatment_status i.strata if female == 0, cluster(schoolid_str)
reg f2.migration_conakry i.treatment_status i.strata if female == 1, cluster(schoolid_str)

sum migration_guinea if l2.female == 1
sum migration_guinea  if l2.female == 0
sum migration_conakry if l2.female == 1
sum migration_conakry if l2.female == 0

****23 February 2021

/*
replace migration_guinea = f2.migration_guinea if time == 0
replace migration_ill = f2.migration_ill if time == 0

replace migration_conakry = f2.migration_conakry if time == 0


gen girls_ratio=nb_girls/ nb_students
 
collapse (mean) treatment_status (mean) migration_conakry (mean) prepare (mean) planning (mean) desire (mean) migration_guinea (mean) schoolid (mean) strata (mean) fees50 (mean) wealth_index50 (mean) girls_ratio  (mean) male (mean) high_age (mean) nb_students (mean) migration_ill, by(schoolid_str time)

gen migration_conakry0 = migration_conakry > 0
gen migration_guinea0 = migration_guinea > 0
gen migration_ill0 = migration_ill > 0

*/

***log file
reg f2.migration_guinea i.treatment_status , cluster(schoolid_str)
reg f2.migration_guinea i.treatment_status i.strata, cluster(schoolid_str)
reg f2.migration_conakry i.treatment_status , cluster(schoolid_str)
reg f2.migration_conakry i.treatment_status i.strata, cluster(schoolid_str)

reg f2.migration_guinea i.treatment_status , cluster(schoolid_str)
reg f2.migration_guinea i.treatment_status male, cluster(schoolid_str)
reg f2.migration_conakry i.treatment_status , cluster(schoolid_str)
reg f2.migration_conakry i.treatment_status male, cluster(schoolid_str)
***end log

reg f2.migration_guinea treated_dummy2 i.strata if treated_dummy1 == 1 | treated_dummy2 == 1, cluster(schoolid_str)
reg f2.migration_guinea treated_dummy3 i.strata if treated_dummy1 == 1 | treated_dummy3 == 1, cluster(schoolid_str)
reg f2.migration_guinea treated_dummy4 i.strata if treated_dummy1 == 1 | treated_dummy4 == 1, cluster(schoolid_str)

reg f2.migration_guinea i.risk_info i.strata if treated_dummy3 != 1, cluster(schoolid_str)
reg f2.migration_guinea i.econ_info i.strata if treated_dummy2 != 1, cluster(schoolid_str)



reg f2.migration_conakry treated_dummy2 i.strata if treated_dummy1 == 1 | treated_dummy2 == 1, cluster(schoolid_str)
reg f2.migration_conakry treated_dummy3 i.strata if treated_dummy1 == 1 | treated_dummy3 == 1, cluster(schoolid_str)
reg f2.migration_conakry treated_dummy4 i.strata if treated_dummy1 == 1 | treated_dummy4 == 1, cluster(schoolid_str)

reg f2.migration_conakry i.risk_info i.strata if treated_dummy3 != 1, cluster(schoolid_str)
reg f2.migration_conakry i.econ_info i.strata if treated_dummy2 != 1, cluster(schoolid_str)














*****July 2020


*reg  f2.migration_guinea outside_contact0  male wealth_index50 fees50 impat moth_educ sister_no brother_no italy_kidnapped  , cluster(schoolid_str)

******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				


global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	*why need present at first follow up?
	eststo: reg f2.y $controls y if f1.y != ., cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	
	gen part1 = l.y != .
	qui sum y if time == 2 & treatment_status == 1 & part1 == 1
	estadd scalar cont = r(mean)
	drop y part1
	
	

	
}




esttab using ///
"migrationintentionssel_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant" y "Outcome at Basel.") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Migration intentions at $2^{nd}$ F. U., restricted to non-attrited at $1^{st}$ \label{migrationintentionsselfu2}) /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \multicolumn{4}{p{10cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

eststo clear

stop












/*




***********************MIGRATION*GUINEA******************************



global mig_conkary_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'


global mig_guinea_outcomes "migration_guinea_1 migration_guinea_2 migration_guinea_3 migration_guinea_4 migration_guinea_5"

local n_outcomes `: word count $mig_guinea_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $mig_guinea_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls, cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	

	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	

	
}




esttab using ///
"migrationguinea_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Out of Conakry  at $2^{nd}$ F. U.  \label{migrationguineafu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ SSS (Stud.)  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ SSS (Admin.)  }" ///
	"\shortstack{(5) \\  Previous \\ and \\ Oth. Cont.  }") nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.7cm}}{\footnotesize The dependent variable is being out of Guinea. In (1) we use only surveys with the subject (student)--in school or by phone; in (2) we use add information gathered from contacts (max 2) given by subject itself; in (3) we use add information given by students at school during the $2^{nd}$ F. U. tablet survey ; in (4) we use add information given by administration on the same occasion; (5) adds information from unstructured phone conversations with classmates. Errors are clustered at school  P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\). }\\ \end{tabular} \end{table}")



eststo clear



***********************MIGRATION*GUINEA*less*6*****************************


global mig_conkary_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				

global mig_guinea_outcomes "migration_guinea_1 migration_guinea_2 migration_guinea_3 migration_guinea_4 migration_guinea_5"



local n_outcomes `: word count $mig_guinea_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $mig_guinea_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls, cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	

	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	

	
}




esttab using ///
"migrationguinea_less6_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Out of Guinea at $2^{nd}$ F. U,  (Only Contacts with Last Conv. $<$ 6 Months Ago) \label{migrationguinealess6fu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ SSS (Stud.)  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ SSS (Admin.)  }" ///
	"\shortstack{(5) \\  Previous \\ and \\ Oth. Cont.  }") nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.7cm}}{\footnotesize The dependent variable is being out of Guinea. In (1) we use only surveys with the subject (student)--in school or by phone; in (2) we use add information gathered from contacts (max 2) given by subject itself, excluding contacts that have last communicated with the subject more than 6 month ago; in (3) we use add information given by students at school during the $2^{nd}$ F. U. tablet survey ; in (4) we use add information given by administration on the same occasion; (5) adds information from unstructured phone conversations with classmates. Errors are clustered at school  P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\). }\\ \end{tabular} \end{table}")

eststo clear



***********************MIGRATION*GUINEA*less*1*****************************


global mig_conkary_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				

global mig_guinea_outcomes "migration_guinea_1 migration_guinea_2 migration_guinea_3 migration_guinea_4 migration_guinea_5"

local n_outcomes `: word count $mig_guinea_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $mig_guinea_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls, cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	

	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	

	
}




esttab using ///
"migrationguinea_less1_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Out of Guinea at $2^{nd}$ F. U. (Only Contacts with Last Conv. $<$ 1 Month Ago)  \label{migrationguinealess1fu2}) /// 
mtitles("\shortstack{(1) \\ Only \\ Interviewed \\ Subject  }" ///
	"\shortstack{(2) \\  Previous \\ and \\ Contacts  }" ///
	"\shortstack{(3) \\  Previous \\ and \\ SSS (Stud.)  }" ///
	"\shortstack{(4) \\  Previous \\ and \\ SSS (Admin.)  }" ///
	"\shortstack{(5) \\  Previous \\ and \\ Oth. Cont.  }") nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.7cm}}{\footnotesize The dependent variable is being out of Guinea. In (1) we use only surveys with the subject (student)--in school or by phone; in (2) we use add information gathered from contacts (max 2) given by subject itself, excluding contacts that have last communicated with the subject more than 1 month ago; in (3) we use add information given by students at school during the $2^{nd}$ F. U. tablet survey ; in (4) we use add information given by administration on the same occasion; (5) adds information from unstructured phone conversations with classmates. Errors are clustered at school  P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\). }\\ \end{tabular} \end{table}")

eststo clear





******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				


global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls y, cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	

	qui sum y if time == 2 & treatment_status == 1
	estadd scalar cont = r(mean)
	drop y
	
	

	
}


preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/9, valuelabel) 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore


esttab using ///
"migrationintentions_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant" y "Outcome at Baseline") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Migration intentions at $2^{nd}$ F. U. \label{migrationintentionsfu2}) /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \multicolumn{4}{p{10.5cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

eststo clear


	


**********************************RISK*OUTCOMES*********************************


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
				+ `" "\shortstack{(9) \\ PCA \\ Risk \\ \vphantom{foo}}" "' 
	
global routes_list = "Italy Spain"

global appendix_reg " "

foreach route_u in $routes_list {
	
	*est clear
	
	local route = lower("`route_u'")
	
	global winsor = "`route'_duration `route'_journey_cost"
	

	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	global main_reg " "
	
	
	*est clear

	forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global `route'_outcomes {  
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep'  i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}

	
	preserve

	fwer , dep_vars($`route'_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}\fwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}
	

	
							
	local n_outcomes `: word count $`route'_outcomes'

	
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
		matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}
		
		gen y = `y'
		qui reg f2.y $controls y, cluster(schoolid_str)
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

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
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
	
	/*
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

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.png , replace
	
	restore
	
	*/

	esttab $main_reg using ///
		"`route_u'outcomes_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U. \label{`route_u'outcomes}) /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")
	
	estimates drop $main_reg 
	
	
}
	

				


/*

gen mig_class0 = sec9_q2 > 0

reg f2.desire i.treatment_status##i.mig_class0 desire i.strata , cluster(schoolid)
est sto reg1
reg f2.planning i.treatment_status##i.mig_class0 planning i.strata , cluster(schoolid)
est sto reg2
reg f2.prepare i.treatment_status##i.mig_class0 prepare i.strata , cluster(schoolid)
est sto reg3

esttab reg1 reg2 reg3 using ///
	"classmig_int.tex",   ///
	coeflabels( 2.treatment_status#1.mig_class0 "Risk X Mig. classmates" ///
	 3.treatment_status#1.mig_class0 "Econ X Mig. classmates" ///
	 4.treatment_status#1.mig_class0 "Risk X Mig. classmates" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and classmates who migrated) /// 
	mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
	drop(1.mig_class0 desire 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) 
	

reg f2.italy_index i.treatment_status##i.mig_class0 italy_index i.strata , cluster(schoolid)
est sto reg1
reg f2.spain_index i.treatment_status##i.mig_class0 spain_index i.strata , cluster(schoolid)
est sto reg2
reg f2.economic_index i.treatment_status##i.mig_class0 economic_index i.strata , cluster(schoolid)
est sto reg3


esttab reg1 reg2 reg3 using ///
	"pca_classmig.tex",   ///
	coeflabels( 2.treatment_status#1.mig_class0 "Risk X Discussed mig." ///
	 3.treatment_status#1.mig_class0 "Econ X Discussed mig." ///
	 4.treatment_status#1.mig_class0 "Risk X Discussed mig." ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and classmates who migrated: beliefs) /// 
	mtitles("Ita" "Spain"  "Econ" ) nobaselevels ///
	drop(1.mig_class0 italy_index spain_index  economic_index 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) ///
	replace
	


reg f2.italy_kling_poscost i.treatment_status##i.mig_class0 italy_kling_poscost i.strata , cluster(schoolid)
est sto reg1
reg f2.italy_kling_negcost i.treatment_status##i.mig_class0 italy_kling_negcost i.strata , cluster(schoolid)
est sto reg2
reg f2.spain_kling_poscost i.treatment_status##i.mig_class0 spain_kling_poscost i.strata , cluster(schoolid)
est sto reg3
reg f2.spain_kling_negcost i.treatment_status##i.mig_class0 spain_kling_negcost i.strata , cluster(schoolid)
est sto reg4
reg f2.economic_kling i.treatment_status##i.mig_class0 economic_kling i.strata , cluster(schoolid)
est sto reg5





reg f2.desire i.treatment_status##i.sec2_q11 desire i.strata , cluster(schoolid)
est sto reg1
reg f2.planning i.treatment_status##i.sec2_q11 planning i.strata , cluster(schoolid)
est sto reg2
reg f2.prepare i.treatment_status##i.sec2_q11 prepare i.strata , cluster(schoolid)
est sto reg3

esttab reg1 reg2 reg3 using ///
	"classmig_dis.tex",   ///
	coeflabels( 2.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	 3.treatment_status#2.sec2_q11 "Econ X Discussed mig." ///
	 4.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and having discussed migration) /// 
	mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
	drop(2.sec2_q11 desire 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) ///
	replace
	
	

reg f2.italy_index i.treatment_status##i.sec2_q11 italy_index i.strata , cluster(schoolid)
est sto reg1
reg f2.spain_index i.treatment_status##i.sec2_q11 spain_index i.strata , cluster(schoolid)
est sto reg2
reg f2.economic_index i.treatment_status##i.sec2_q11 economic_index i.strata , cluster(schoolid)
est sto reg3


esttab reg1 reg2 reg3 using ///
	"pca_dis.tex",   ///
	coeflabels( 2.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	 3.treatment_status#2.sec2_q11 "Econ X Discussed mig." ///
	 4.treatment_status#2.sec2_q11 "Risk X Discussed mig." ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Treatment impact and having discussed migration: beliefs) /// 
	mtitles("Ita" "Spain"  "Econ" ) nobaselevels ///
	drop(2.sec2_q11 italy_index spain_index  economic_index 2.strata 2.treatment_status 3.treatment_status 4.treatment_status) ///
	replace
	
	
	
	
reg f2.italy_kling_poscost i.treatment_status##i.sec2_q11 italy_kling_poscost i.strata , cluster(schoolid)
est sto reg1
reg f2.italy_kling_negcost i.treatment_status##i.sec2_q11 italy_kling_negcost i.strata , cluster(schoolid)
est sto reg2
reg f2.spain_kling_poscost i.treatment_status##i.sec2_q11 spain_kling_poscost i.strata , cluster(schoolid)
est sto reg3
reg f2.spain_kling_negcost i.treatment_status##i.sec2_q11 spain_kling_negcost i.strata , cluster(schoolid)
est sto reg4
reg f2.economic_kling i.treatment_status##i.sec2_q11 economic_kling i.strata , cluster(schoolid)
est sto reg5

*/

********************************ECONOMIC*OUTCOMES*******************************


global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " economic_index "

global economic_titles = `" " \shortstack{(1)\\ Finding \\ Job} " "' ///
			+ `" "\shortstack{(2)\\ Contin. \\ Studies}" "' ///
			+ `" "\shortstack{(3)\\ Becom. \\ Citiz.}" "' ///
			+ `" "\shortstack{(4)\\ Return \\ 5 yrs}" "' ///
			+ `" "\shortstack{(5)\\ Finan. \\ Help}""' ///
			+ `" "\shortstack{(6) \\ Getting \\ Asyl.}" "' ///
			+ `" "\shortstack{(7) \\ Favor \\ Migr.}" "' ///
			+ `" "\shortstack{(8) \\  \(sinh^{-1}\) \\ Liv. Cost}" "' ///
			+ `" "\shortstack{(9)\\ \(sinh^{-1}\) \\ Wage}" "' ///
			+ `" "\shortstack{(10) \\ PCA \\ econ}" "' 
			
			
			label define groups 1 "Finding Job" 2 "Contin. Studies" 3 "Becom. Citiz." ///
	4 "Not Sent Back" 5 "Financial help" 6 "Getting Asylum" ///
	7 "Favor Migration" 8 "Living Cost" 9 "Wage"
	
	
**************************************FWER**************************************

*est clear

forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global economic_outcomes {  
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep' i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $economic_outcomes {
		di "  - `var'"
	}
	
	preserve
	
	fwer , dep_vars($economic_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}/Draft/tables/provvisoria_con_lag/provvisoria_con_lagfwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}

***********************************KLING***********************************



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
	matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f2.y $controls y, cluster(schoolid_str)
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

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		local row = (`n_outcomes'-4)*(`n_treat'-1) + `ng'
		
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
/*
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
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.png , replace
	
restore
*/

esttab  $main_reg using ///
	"economicoutcomes_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Perceptions about econ. outcomes at $2^{nd}$ F. U. \label{economicoutcomes}) /// 
	mtitles($economic_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")



esttab $appendix_reg using ///
	"appendixoutcomes_fu2.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers title(Impacts on Kling (2007) at $2^{nd}$ F. U.  Indexes \label{appendixoutcomes}) /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")





*/



*HIGH FEES

clear all

set more off

use ${main}/Data/output/followup2/BME_final.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

cd "$main/Draft/tables/aux"

tsset id_number time

global controls  "i.treatment_status i.strata" 
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'
	 
*Auxiliary variables for fwer.
gen sid = schoolid
drop treated_dummy1
tab treatment_status, gen(treated_dummy)
global treatment_dummies " treated_dummy2 treated_dummy3 treated_dummy4 "
gen trtmnt = .

replace fees50sch = l2.fees50sch if time == 2

keep if fees50sch == 1 | time > 0

******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				


global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls y, cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	

	qui sum y if time == 2 & treatment_status == 1 & fees50sch == 1
	estadd scalar cont = r(mean)
	drop y
	
	

	
}

/*
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/9, valuelabel) 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore
*/

esttab using ///
"migrationintentionshighfees_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Migration intentions at $2^{nd}$ F. U. (Only High Fees) \label{migrationintentionshighfeesfu2}) /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \multicolumn{4}{p{12cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

eststo clear


	


**********************************RISK*OUTCOMES*********************************


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
				+ `" "\shortstack{(9) \\ PCA \\ Risk \\ \vphantom{foo}}" "' 
	
global routes_list = "Italy Spain"

global appendix_reg " "

foreach route_u in $routes_list {
	
	*est clear
	
	local route = lower("`route_u'")
	
	global winsor = "`route'_duration `route'_journey_cost"
	

	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	global main_reg " "
	
	
	*est clear

	forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global `route'_outcomes {  
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep'  i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}

	
	preserve

	fwer , dep_vars($`route'_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}\fwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}
	

	***********************************KLING***********************************
	
							
	local n_outcomes `: word count $`route'_outcomes'
	
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
		matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}
		
		gen y = `y'
		qui reg f2.y $controls y, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1 & fees50sch == 1
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

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
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
	
	/*
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

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.png , replace
	
	restore
	
	*/

	esttab $main_reg using ///
		"`route_u'outcomeshighfees_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U. (Only High Fees) \label{`route_u'outcomeshighfeesfu2}) /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")
	
	estimates drop $main_reg 
	
	
}
	
********************************ECONOMIC*OUTCOMES*******************************


global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " economic_index "

global economic_titles = `" " \shortstack{(1)\\ Finding \\ Job} " "' ///
			+ `" "\shortstack{(2)\\ Contin. \\ Studies}" "' ///
			+ `" "\shortstack{(3)\\ Becom. \\ Citiz.}" "' ///
			+ `" "\shortstack{(4)\\ Return \\ 5 yrs}" "' ///
			+ `" "\shortstack{(5)\\ Finan. \\ Help}""' ///
			+ `" "\shortstack{(6) \\ Getting \\ Asyl.}" "' ///
			+ `" "\shortstack{(7) \\ Favor \\ Migr.}" "' ///
			+ `" "\shortstack{(8) \\  \(sinh^{-1}\) \\ Liv. Cost}" "' ///
			+ `" "\shortstack{(9)\\ \(sinh^{-1}\) \\ Wage}" "' ///
			+ `" "\shortstack{(10) \\ PCA \\ econ}" "' 
			
**************************************FWER**************************************

*est clear

forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global economic_outcomes {  
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep' i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $economic_outcomes {
		di "  - `var'"
	}
	
	preserve
	
	fwer , dep_vars($economic_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}/Draft/tables/provvisoria_con_lag/provvisoria_con_lagfwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}

***********************************KLING***********************************



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
	matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f2.y $controls y, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1 & fees50sch == 1
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

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		local row = (`n_outcomes'-4)*(`n_treat'-1) + `ng'
		
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
/*
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
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.png , replace
	
restore
*/

esttab  $main_reg using ///
	"economicoutcomeshighfees_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Perceptions about econ. outcomes at $2^{nd}$ F. U. (Only High Fees) \label{economicoutcomeshighfees}) /// 
	mtitles($economic_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")



esttab $appendix_reg using ///
	"appendixoutcomeshighfees_fu2.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers title(Impacts on Kling (2007) at $2^{nd}$ F. U. Indexes (Only High Fees) \label{appendixoutcomeshighfees}) /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")







*LOW FEES

clear all

set more off

use ${main}/Data/output/followup2/BME_final.dta

run ${main}/do_files/analysis/__multitest_programs_compact.do

cd "$main/Draft/tables/aux"

tsset id_number time

global controls  "i.treatment_status i.strata" 
	
*global controls_names = `" "controlling for outcome at baseline and stratification dummy" "'
	 
*Auxiliary variables for fwer.
gen sid = schoolid
drop treated_dummy1
tab treatment_status, gen(treated_dummy)
global treatment_dummies " treated_dummy2 treated_dummy3 treated_dummy4 "
gen trtmnt = .

replace fees50sch = l2.fees50sch if time == 2

keep if fees50sch == 0 | time > 0

******************************MIGRATION*INTENTIONS*****************************

global intention_names = `" "Would like to migrate" "' ///
				+ `" "Plans to migrate" "' ///
				+ `" "Prepares to migrate" "'
				


global migration_outcomes "desire planning prepare"

local n_outcomes `: word count $migration_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $migration_outcomes {

	local n = `n' + 1
		
	gen y = `y'
	eststo: reg f2.y $controls y, cluster(schoolid_str)
	
	local n_treat=1
	
	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		
		local row = `n_outcomes'*(`n_treat'-1) + `n'
		di `row'
		mat R[`row',1]=_b[`X']
		mat R[`row',2]=_b[`X']-1.96*_se[`X']
		mat R[`row',3]=_b[`X']+1.96*_se[`X']
		mat R[`row',4]=`row'

	local ++n_treat
	}
	
	

	qui sum y if time == 2 & treatment_status == 1 & fees50sch == 0
	estadd scalar cont = r(mean)
	drop y
	
	

	
}

/*
preserve

clear
svmat R

la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Wish" 2 "Plan" 3 "Prepare" ///
	4 "Wish" 5 "Plan" 6 "Prepare" ///
	7 "Wish" 8 "Plan" 9 "Prepare" 
label values R4 groups


set scheme s2mono
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/9, valuelabel) 	///
	xline(3.5, lpattern(-) lcolor(black)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	ylabel(-0.09(0.02)0.09) ///
	graphregion(color(white)) ///
	text(0.08 2 "Risk") text(0.08 5 "Econ") text(0.08 8 "Double")
	 
graph save Graph ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lagmigrationoutcomes_fu2.png, replace

restore
*/

esttab using ///
"migrationintentionslowfees_fu2.tex", replace stats(cont N, label( "$2^{nd}$ F. U. Cont. Mean" "N")) ///
coeflabels(1.treatment_status "Control" 2.treatment_status ///
"Risk Treatment" 3.treatment_status "Econ Treatment" ///
4.treatment_status "Double Treatment" 2.strata "Big school" ///
 _cons "Constant") se ///
  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
nonumbers title(Migration intentions at $2^{nd}$ F. U. (Only Low Fees) \label{migrationintentionslowfeesfu2}) /// 
mtitles("Wish" "Plan"  "Prepare" ) nobaselevels ///
postfoot("\hline\hline \multicolumn{4}{p{12cm}}{\footnotesize (1) is outcome \emph{wishing to migrate}, (2) is \emph{planning to migrate}, (3) is \emph{preparing}. Errors are clustered at the school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")

eststo clear


	


**********************************RISK*OUTCOMES*********************************


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
				+ `" "\shortstack{(9) \\ PCA \\ Risk \\ \vphantom{foo}}" "' 
	
global routes_list = "Italy Spain"

global appendix_reg " "

foreach route_u in $routes_list {
	
	*est clear
	
	local route = lower("`route_u'")
	
	global winsor = "`route'_duration `route'_journey_cost"
	

	global `route'_outcomes = "asinh`route'_duration_winsor " ///
							+ " asinh`route'_journey_cost_winsor  " ///
							+ " `route'_beaten " ///
							+ " `route'_forced_work " ///
							+ " `route'_kidnapped " ///
							+ " `route'_die_bef_boat " ///
							+ " `route'_die_boat " ///
							+ " `route'_sent_back "
	
	global main_reg " "
	
	
	*est clear

	forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global `route'_outcomes {  
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep'  i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $`route'_outcomes {
		di "  - `var'"
	}

	
	preserve

	fwer , dep_vars($`route'_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}\fwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}
	

	***********************************KLING***********************************
	
							
	local n_outcomes `: word count $`route'_outcomes'
	
	
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
		matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
		matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
		}
		
		gen y = `y'
		qui reg f2.y $controls y, cluster(schoolid_str)
		est sto reg_`route'_`n'
		qui sum y if time == 2 & treatment_status == 1 & fees50sch == 0
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

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
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
	
	/*
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

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_fu2.png, replace
	
	twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/18, valuelabel angle(vertical)) 	///
	xline(6.5, lpattern(-) lcolor(black)) 	///
	xline(12.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(0(3)18) ///
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Double")

	graph save Graph ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.gph, replace
	graph export ${main}/Draft/figures/provvisoria_con_lag/`route_u'outcomes_pfwer_fu2.png , replace
	
	restore
	
	*/

	esttab $main_reg using ///
		"`route_u'outcomeslowfees_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
		pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
		replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N")) ///
		coeflabels(1.treatment_status "Control" 2.treatment_status ///
		"Risk Treat." 3.treatment_status "Econ Treat." ///
		4.treatment_status "Double Treat." 2.strata "Big school" ///
		y "Basel. outc." _cons "Constant")  ///
		 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
		nonumbers title(Risk perceptions for route through `route_u' at $2^{nd}$ F. U. (Only Low Fees) \label{`route_u'outcomeslowfeesfu2}) /// 
		mtitles($risks_table_titles) ///
		nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) duration of journey in \(sinh^{-1}\) months (winsorized at $5^{th}$ perc.), (2) journey cost in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (3) probability of being beaten, (4) probability of being forced to work, (5) probability of being kidnapped, (6) probability of dying before travel by boat, (7) probability of dying during travel by boat, (8) probability of being sent back, (9) PCA aggregator for risk perceptions. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")
	
	estimates drop $main_reg 
	
	
}
	
********************************ECONOMIC*OUTCOMES*******************************


global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " asylum " ///
						+ " in_favor_of_migration " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " economic_index "

global economic_titles = `" " \shortstack{(1)\\ Finding \\ Job} " "' ///
			+ `" "\shortstack{(2)\\ Contin. \\ Studies}" "' ///
			+ `" "\shortstack{(3)\\ Becom. \\ Citiz.}" "' ///
			+ `" "\shortstack{(4)\\ Return \\ 5 yrs}" "' ///
			+ `" "\shortstack{(5)\\ Finan. \\ Help}""' ///
			+ `" "\shortstack{(6) \\ Getting \\ Asyl.}" "' ///
			+ `" "\shortstack{(7) \\ Favor \\ Migr.}" "' ///
			+ `" "\shortstack{(8) \\  \(sinh^{-1}\) \\ Liv. Cost}" "' ///
			+ `" "\shortstack{(9)\\ \(sinh^{-1}\) \\ Wage}" "' ///
			+ `" "\shortstack{(10) \\ PCA \\ econ}" "' 
			
**************************************FWER**************************************

*est clear

forvalues t = 2/4 {

	local other_treatvar " "
	forvalues c = 2/4 {
		if `t' != `c' {
			local other_treatvar `other_treatvar'  treated_dummy`c' 
		}
	}
  
	replace trtmnt = treated_dummy`t'
		
		foreach dep of global economic_outcomes {  
				char define `dep'[_spec] reg f2.`dep' \`treatvar' `other_treatvar' `dep' i.strata,  clus(sid)
	}   

	* run all regressions and store results 

	di "starting the computation of FWER-adjusted p-values"
	di "indexes:"
	foreach var of varlist $economic_outcomes {
		di "  - `var'"
	}
	
	preserve
	
	fwer , dep_vars($economic_outcomes) t(trtmnt) num_rep(`n_rep') fisher  //set 100000 when you're ready. 1000 reps provide good enough approx
	export excel using ${main}/Draft/tables/provvisoria_con_lag/provvisoria_con_lagfwer,  firstrow(var) sheet(labor, replace) 
	putmata *
	restore, preserve

	restore
		
	m: st_matrix(`"coeff`t'"',coeff)
	m: mata drop coeff
	m: st_matrix(`"p_FWER`t'"',p_FWER)
	m: mata drop p_FWER
	m: st_matrix(`"p_Fisher`t'"',p_Fisher)
	m: mata drop p_Fisher
	m: st_matrix(`"p_values`t'"',p_values)
	m: mata drop p_values
	m: st_matrix(`"std_err`t'"',std_err)
	m: mata drop std_err
	m: mata drop variable
	
	
}

***********************************KLING***********************************



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
	matrix pfwer = [p_FWER2[`n',1], p_FWER3[`n',1], p_FWER4[`n',1]]
	matrix colnames pfwer = 2.treatment_status 3.treatment_status 4.treatment_status
	}
	
	gen y = `y'
	qui reg f2.y $controls y, cluster(schoolid_str)
	est sto reg_econ_`n'
	qui sum y if time == 2 & treatment_status == 1 & fees50sch == 0
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

	foreach X in i2.treatment_status i3.treatment_status i4.treatment_status  {
		local row = (`n_outcomes'-4)*(`n_treat'-1) + `ng'
		
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
/*
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
	
twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_fu2.png , replace


twoway (bar R1 R4, barw(0.6) fi(inten30) lc(black) lw(medium) ) ///
	(bar R1 R4 if R5 < 0.05, barw(0.6) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
	legend(off) xlabel(1/21, valuelabel angle(vertical)) 	///
	xline(7.5, lpattern(-) lcolor(black)) 	///
	xline(14.5, lpattern(-) lcolor(black)) 	///
	graphregion(color(white)) ///
	ylabel(-15(5)5) ///
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Double")

graph save Graph ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.gph, replace
graph export ${main}/Draft/figures/provvisoria_con_lag/economicoutcomes_pfwer_fu2.png , replace
	
restore
*/

esttab  $main_reg using ///
	"economicoutcomeslowfees_fu2.tex",  cells(b(fmt(a2)) se(par fmt(a2) star) ///
	pfwer( fmt(2) par([ ]) star pvalue(pfwer) )) collabels(,none) ///
	replace stats(cont N,  fmt(a2 a2) label( "$2^{nd}$ F.U. Cont." "N"))  ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	nonumbers title(Perceptions about econ. outcomes at $2^{nd}$ F. U. (Only Low Fees) \label{economicoutcomeslowfees}) /// 
	mtitles($economic_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{10}{p{20cm}}{\footnotesize Legend: (1) probability of finding job, (2) probability of continuing studies (3)  probability of becoming a citizen, (4) probability of having returned after 5 years,  (5) probability that govt at destination gives financial help, (6) probability of getting asylum, if requested, (7) percentage in favor of migration at destination, (8) expected wage at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (9) expected living cost at destination in \(sinh^{-1}\) euros (winsorized at $5^{th}$ perc.), (10) PCA aggregator for perceptions about economic outcomes. Errors are clustered at school level. $2^{nd}$ F.U. Cont. represents average in control group at midline. Errors are clustered at school level in round brackets. Fwer p-values in square brackets. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")



esttab $appendix_reg using ///
	"appendixoutcomeslowfees_fu2.tex",  se ///
	 collabels(,none) ///
	replace stats(cont N, fmt(a2 a2) label( "$2^{nd}$ F.U. Cont. Mean" "N")) ///
	coeflabels(1.treatment_status "Control" 2.treatment_status ///
	"Risk Treat." 3.treatment_status "Econ Treat." ///
	4.treatment_status "Double Treat." 2.strata "Big school" ///
	y "Basel. outcome" _cons "Constant")  ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers title(Impacts on Kling (2007) at $2^{nd}$ F. U. Indexes (Only Low Fees) \label{appendixoutcomeslowfees}) /// 
	mtitles($appendix_table_titles) ///
	nobaselevels ///
postfoot("\hline\hline \multicolumn{6}{p{15.5cm}}{\footnotesize Dependent variable in (1) is aggregator of Italy risk perceptions based on Kling (2007)  using positive cost, (2) uses negative cost. (3) and (4) are the same, for Spain. (5) is Kling aggregator for perceptions about economic outcomes. $2^{nd}$ F.U. Cont. represents average in control group at midline.Errors are clustered at school level. P-values are denoted as follows: \sym{+} \(p<0.1\), \sym{*} \(p<0.05\), \sym{**} \(p<0.01\), \sym{***} \(p<0.001\).  } \\ \end{tabular} \end{table}")




/*
* index for visa requirement from https://github.com/ilyankou/passport-index-dataset/blob/master/legacy/2019-11-23/passport-index-tidy.csv
gen visa_free = .
replace visa_free = 0 if country == "ALGERIA"
replace visa_free = 0 if country == "ANGOLA"
replace visa_free = 0 if country == "CANADA"
replace visa_free = 3 if country == "COTE D'IVOIRE"
replace visa_free = 2 if country == "EGYPT"
replace visa_free = 0 if country == "ENGLAND"
replace visa_free = 0 if country == "FRANCE"
replace visa_free = 0 if country == "GERMANY"
replace visa_free = 3 if country == "GHANA"
replace visa_free = 3 if country == "GUINEA BISSAU"
replace visa_free = 0 if country == "ITALY"
replace visa_free = 3 if country == "IVORY COAST"
replace visa_free = 0 if country == "LEBANON"
replace visa_free = 3 if country == "LIBERIA"
replace visa_free = 0 if country == "LIBYA"
replace visa_free = 3 if country == "MALI"
replace visa_free = 2 if country == "MAURITANIA"
replace visa_free = 0 if country == "MOROCCO"
replace visa_free = 0 if country == "PORTUGAL"
replace visa_free = 3 if country == "SENEGAL"
replace visa_free = 3 if country == "SIERRA LEONE"
replace visa_free = 0 if country == "SPAIN"
replace visa_free = 3 if country == "TOGO"
replace visa_free = 0 if country == "UNITED KINGDOM"
replace visa_free = 0 if country == "UNITED STATES"
*/

gen visa_free = .
replace visa_free = 0 if country_fin == "ALGERIA"
replace visa_free = 0 if country_fin == "ANGOLA"
replace visa_free = 0 if country_fin == "CANADA"
replace visa_free = 3 if country_fin == "COTE D'IVOIRE"
replace visa_free = 2 if country_fin == "EGYPT"
replace visa_free = 0 if country_fin == "ENGLAND"
replace visa_free = 0 if country_fin == "FRANCE"
replace visa_free = 0 if country_fin == "GERMANY"
replace visa_free = 3 if country_fin == "GHANA"
replace visa_free = 3 if country_fin == "GUINEA BISSAU"
replace visa_free = 0 if country_fin == "ITALY"
replace visa_free = 3 if country_fin == "IVORY COAST"
replace visa_free = 0 if country_fin == "LEBANON"
replace visa_free = 3 if country_fin == "LIBERIA"
replace visa_free = 0 if country_fin == "LIBYA"
replace visa_free = 3 if country_fin == "MALI"
replace visa_free = 2 if country_fin == "MAURITANIA"
replace visa_free = 0 if country_fin == "MOROCCO"
replace visa_free = 0 if country_fin == "PORTUGAL"
replace visa_free = 3 if country_fin == "SENEGAL"
replace visa_free = 3 if country_fin == "SIERRA LEONE"
replace visa_free = 0 if country_fin == "SPAIN"
replace visa_free = 3 if country_fin == "TOGO"
replace visa_free = 0 if country_fin == "UNITED KINGDOM"
replace visa_free = 0 if country_fin == "UNITED STATES"


  * `3` = visa-free travel
  * `2` = eTA is required
  * `1` = visa can be obtained on arrival (which Passport Index considers visa-free)
  * `0` = visa is required
  
  
gen mig_novisabutreq = (visa == 0)&(visa_free==0) if migration_guinea !=.
replace mig_novisabutreq = 0 if country == "UNITED STATES"
replace mig_novisabutreq = 0 if country == "CANADA"

