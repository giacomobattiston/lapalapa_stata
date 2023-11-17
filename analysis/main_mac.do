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
local demographics "grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win durablesnomiss durablesmiss"
local school_char  "fees50 ratio_female_lycee rstudteach rstudclass"
local contacts_char "i.sec10_q2_ i.sec10_q3_ agecontnomiss agecontmiss i.sec10_q6_ i.sec10_q7_  i.sec10_q9_ i.sec10_q10_ i.sec10_q11_ i.sec10_q12_ i.sec10_q13_ i.sec10_q14_ i.sec10_q15_"
local contacts_char "i.sec10_q2_ i.sec10_q3_ agecontnomiss agecontmiss i.sec10_q6_ i.sec10_q7_"
local contacts_char ""



local migcov "desire planning prepare contacts_abroad discuss_risk_contact discuss_econ_contact "

local demographics_red "female fath_school moth_school fath_working moth_working sister_no_win brother_no_win grade6 grade7"



* individual characteristics with attendance (Panel a table 1)
global bc_var_demo = " female grade6 grade7 durables " ///
				+ " moth_working moth_educ5 moth_educ1 moth_educ2 moth_educ3 " ///
				+ " fath_working fath_educ5 fath_educ1 fath_educ2 fath_educ3  " 
* contacts abroad, sisters and brothers are winsorized


* individual characteristics with attendance (Panel a table 1)
global bc_var_demo_red = " female grade6 grade7 durables "

* contacts abroad, sisters and brothers are winsorized

* variables for the balance with attendance (Panel b table 1)			
global bc_var_outcomes = "desire planning prepare italy_index spain_index economic_index" 	


* other individual characteristics (app table 2)
global bc_var_demo_sec = " moth_working moth_educ5 moth_educ1 moth_educ2 moth_educ3 " ///
				+ " fath_working fath_educ5 fath_educ1 fath_educ2 fath_educ3  "  ///
				+ " brother_no_win sister_no_win " ///	
				+ " contacts_winsor mig_classmates " ///
				+ " tele_daily tele_weekless inter_daily inter_weekless " ///
				

* other beliefs (app table 3)
global bc_var_italyrisk = " asinhitaly_duration_winsor italy_beaten italy_forced_work asinhitaly_journey_cost_winsor italy_kidnapped  italy_die_bef_boat italy_die_boat italy_sent_back italy_kling_negcost" 

global bc_var_spainrisk = " asinhspain_duration_winsor spain_beaten spain_forced_work asinhspain_journey_cost_winsor spain_kidnapped  spain_die_bef_boat spain_die_boat spain_sent_back spain_kling_negcost" 

global bc_var_econ =  "  finding_job asinhexpectation_wage_winsor continuing_studies asylum becoming_citizen return_5yr government_financial_help asinhexp_liv_cost_winsor in_favor_of_migration economic_kling" 
								

* school characteristics (app table 4)
global bc_var_school = " strata_n2 fees50 repeaters transfers ratio_female_second rstudteach rstudadmin rstudclass ratio_tmale ratio_tmaster " ///
				+ " schoolinf_index  "

				
local n_rep 1000
local makefwer 0




forval i = 1/10 {
	gen degreenomiss`i' = degree`i'
	sum degree`i' if time == 0
	replace degreenomiss`i' = `r(mean)' if degree`i' == . & time == 0

}

gen degreemiss = degree1 == . if time == 0

gen ratio_tmasternomiss = ratio_tmaster
sum ratio_tmaster if time == 0
replace ratio_tmasternomiss = `r(mean)' if ratio_tmaster == . & time == 0
gen ratio_tmastermiss = ratio_tmaster == . if time == 0
gen rstudadminnomiss = rstudadmin
sum rstudadmin if time == 0
replace rstudadminnomiss = `r(mean)' if rstudadmin == . & time == 0
gen rstudadminmiss = rstudadmin == . if time == 0

gen surf_classnomiss = surf_class
sum surf_class if time == 0
replace surf_classnomiss = `r(mean)' if surf_class == . & time == 0
gen surf_classmiss = surf_class == . if time == 0


gen ratiorepeaters = repeaters/nb_students
gen ratiorepeatersnomiss = ratiorepeaters
sum ratiorepeaters if time == 0
replace ratiorepeatersnomiss = `r(mean)' if ratiorepeaters == . & time == 0
gen ratiorepeatersmiss = ratiorepeaters == . if time == 0

gen ratiotransfers = transfers/nb_students
gen ratiotransfersnomiss = ratiotransfers
sum ratiotransfers if time == 0
replace ratiotransfersnomiss = `r(mean)' if ratiotransfers == . & time == 0
gen ratiotransfersmiss = ratiotransfers == . if time == 0

gen fath_educ_al1 = fath_educ_red1
replace fath_educ_al1 = 1 if fath_educ_red2 == 1

gen moth_educ_al1 = moth_educ_red1
replace moth_educ_al1 = 1 if moth_educ_red2 == 1

/*
foreach var of rroomstud doort1 doort2 doort3 rooft1 rooft2 surf_classnomiss rtoilstud rcompstud rtelestud rprinstud rphotstud ratio_tmasternomiss rstudadminnomiss rstudclass rstudteach {
	qui sum `var', de
	gen `var_w99'
}
*/

replace rcompstud = rcompstud > 0 if !missing(rcompstud)
replace rtelestud = rtelestud > 0 if !missing(rtelestud)
replace rprinstud = rprinstud > 0 if !missing(rprinstud)
replace rphotstud = rphotstud > 0 if !missing(rphotstud)
*library water infirmary rroomstud doort1 doort2 doort3 rooft1 rooft2 surf_classnomiss surf_classmiss separate_toilets rtoilstud rcompstud rtelestud rprinstud rphotstud connexion ratio_tmasternomiss ratio_tmastermiss rstudadminnomiss rstudadminmiss rstudclass rstudteach

* wealth indicators including all dhs variables
pca fees50 status rstudclass ratiorepeatersnomiss ratiorepeatersmiss ratio_female_lycee if time == 0, factor(1)
predict school_index  if time == 0
label var school_index "Wealth index (PCA)"

qui sum school_index if time == 0, detail
gen school_indexavg = school_index > `r(mean)' if !missing(school_index)
label var school_indexavg "Wealthy"

pca library water infirmary rroomstud doort1 doort2  rooft1  surf_classnomiss surf_classmiss separate_toilets rtoilstud rcompstud connexion if time == 0, factor(1)
predict school_index_inf  if time == 0
label var school_index_inf "Wealth index (PCA)"

qui sum school_index_inf if time == 0, detail
gen school_index_infavg = school_index_inf > `r(mean)' if !missing(school_index_inf)
label var school_index_infavg "School infrastracture"

pca rcompstud rtelestud rprinstud rphotstud connexion  if time == 0, factor(1)
predict school_index_tec  if time == 0
label var school_index_tec "Wealth index (PCA)"

qui sum school_index_tec if time == 0, detail
gen school_index_tecavg = school_index_tec > `r(mean)' if !missing(school_index_tec)
label var school_index_tecavg "Wealthy"

*pca ratio_tmasternomiss ratio_tmastermiss rstudadminnomiss rstudadminmiss rstudteach if time == 0, factor(1)
pca degreenomiss1 degreenomiss2 degreenomiss3 degreenomiss4 degreenomiss5 degreenomiss6 degreenomiss7  degreenomiss8 degreenomiss9  degreemiss rstudadminnomiss rstudadminmiss rstudteach if time == 0, factor(1)
predict school_index_pers  if time == 0
label var school_index_pers "Wealth index (PCA)"

qui sum school_index_pers if time == 0, detail
gen school_index_persavg = school_index_pers > `r(mean)' if !missing(school_index_pers)
label var school_index_persavg "Wealthy"


pca library water infirmary rroomstud doort1 doort2  rooft1  surf_classnomiss surf_classmiss separate_toilets rtoilstud rcompstud connexion  degreenomiss1 degreenomiss2 degreenomiss3 degreenomiss4 degreenomiss5 degreenomiss6 degreenomiss7  degreenomiss8 degreenomiss9  degreemiss rstudadminnomiss rstudadminmiss rstudteach     if time == 0, factor(1)
predict school_index_all  if time == 0
label var school_index_all "Wealth index (PCA)"

qui sum school_index_all if time == 0, detail
gen school_index_allavg = school_index_all > `r(mean)' if !missing(school_index_all)
label var school_index_allavg "Wealthy"

/*





preserve

use "${main}/Data/output/followup2/contacts_data", replace


*Contact wage (restricted sample)

eststo clear



local varlist wage_more1m_c wage_more2_5m_c wage_more5m_c wage_more10m_c wage_more20m_c
		
forval i_est = 1/5 {
	
		
		local depvar : word `i_est' of `varlist'
		gen y = `depvar'
		
		qui sum y if l.treatment_status == 1  &  f.source_info_guinea < 6
		local meandep = `r(mean)'

		local controls `demographics' `school_char' `contacts_char'
		
		gen x = treated
			reg f1.y `controls' maxwage_more* maxwage_missing x strata if f2.source_info_guinea < 6  & attended_tr != . & time == 0 & f.contact_eu_c == 1,  cluster(schoolid)  
		drop x y

			
		eststo reg`i_est'_`i_con'

}

esttab reg* using table_wcontacta.tex, replace keep(x) ///
	coeflabels(x "Any treatment")   se substitute(\_ _) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	noobs nonumbers  nomtitles /// 
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &   \\ [1em]") prefoot("\hline") postfoot(" ") ///
	prehead("\begin{tabular}{l*{6}{c}} \hline\hline  &\multicolumn{5}{c}{y = Wage of contact in the EU} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)} \\   \cmidrule(lr){2-6}     &\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 1 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 2.5 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 5 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 10 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 20 Mil. \\ GNF}} \\") 


eststo clear


		
forval i_est = 1/5 {

		


		local depvar : word `i_est' of `varlist'
		gen y = `depvar'

		qui sum y if l.treatment_status == 1  &  f.source_info_guinea < 6
		local meandep = `r(mean)'
		
		local controls `demographics' `school_char' `contacts_char'
			
		gen x = treatment_status
		reg f1.y `controls' i.x  maxwage_more* maxwage_missing strata if f2.source_info_guinea < 6  & attended_tr != . & time == 0 & f.contact_eu_c == 1,  cluster(schoolid)  
		drop x y
			
		test 2.x - 3.x = 0
		local pre  = string(`r(p)', "%9.2f")
		estadd local pre = `"`pre'"'

		test 2.x - 4.x = 0
		local prd = string(`r(p)', "%9.2f") 
		estadd local prd = `"`prd'"'

		test 3.x - 4.x = 0
		local ped = string(`r(p)', "%9.2f")
		estadd local ped = `"`ped'"'
		
		local individual "Yes"
		local school "Yes"

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		estadd local space = "` '"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
			
		eststo reg`i_est'_`i_con'

		

}

esttab reg* using table_wcontactb.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  individual school N meandep, fmt(s s s s s s a2 s) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "' `"Individual controls"'  `"School controls"'   `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}") 


	



*Contact remittances (restricted sample)

eststo clear

local varlist remittances_c remittances_1y_c remittances_6mon_c remittances_3mon_c remittances_1mon_c remittances_1wee_c
		
forval i_est = 1/6 {
	
		
		local depvar : word `i_est' of `varlist'
		gen y = `depvar'
		
		qui sum y if l.treatment_status == 1  &  f.source_info_guinea < 6
		local meandep = `r(mean)'

		local controls `demographics' `school_char' `contacts_char'
		
		gen x = treated
			reg f1.y `controls' x strata maxremittances_c maxremittances_1y_c maxremittances_6mon_c maxremittances_3mon_c maxremittances_1mon_c maxremittances_1wee_c  maxremittances_fmissing if f2.source_info_guinea < 6  & attended_tr != . & time == 0 & f1.contact_eu_c == 1,  cluster(schoolid)  
		drop x y

			
		eststo reg`i_est'_`i_con'

}

esttab reg* using table_rfcontacta.tex, replace keep(x) ///
	coeflabels(x "Any treatment")   se substitute(\_ _) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	noobs nomtitle nonumbers /// 
	nobaselevels ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &    \\ [1em]") prefoot("\hline") postfoot(" ") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = Frequency of remittances from contact in the EU} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}     &\multicolumn{1}{c}{\Shortstack{1em}{Ever \\ sent \\ \vphantom{foo}}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ yearly \\ \vphantom{foo}}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ every \\ 6 months}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ every \\ 3 months}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ every \\ 1 month}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ every \\ week}} \\")

eststo clear


		
forval i_est = 1/6 {

		


		local depvar : word `i_est' of `varlist'
		gen y = `depvar'

		qui sum y if l.treatment_status == 1  &  f.source_info_guinea < 6
		local meandep = `r(mean)'
		
		local controls `demographics' `school_char' `contacts_char'
			
		gen x = treatment_status
		reg f1.y `controls'  i.x maxremittances_c maxremittances_1y_c maxremittances_6mon_c maxremittances_3mon_c maxremittances_1mon_c maxremittances_1wee_c maxremittances_fmissing strata if f2.source_info_guinea < 6  & attended_tr != . & time == 0 & f.contact_eu_c == 1,  cluster(schoolid)  
		drop x y
		
		local individual "Yes"
		local school "Yes"
			
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

esttab reg* using table_rfcontactb.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  individual school N meandep, fmt(s s s s s s a2 s) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "' `"Individual controls"'  `"School controls"'   `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &    \\ [1em]")    postfoot("\hline\hline \end{tabular}") 



	
*Contact remittances (restricted sample)

eststo clear

local varlist remittances_more1m_c remittances_more2_5m_c remittances_more5m_c remittances_more10m_c remittances_more20m_c
		

forval i_est = 1/5 {
	
		
		local depvar : word `i_est' of `varlist'
		gen y = `depvar'
		
		qui sum y if l.treatment_status == 1  &  f.source_info_guinea < 6
		local meandep = `r(mean)'

		local controls `demographics' `school_char' `contacts_char'
		
		gen x = treated
			reg f1.y `controls' x maxremittances_more1m_c maxremittances_more2_5m_c maxremittances_more5m_c maxremittances_more10m_c maxremittances_more20m_c maxremittances_qmissing strata if f2.source_info_guinea < 6  & attended_tr != . & time == 0 & f.contact_eu_c == 1,  cluster(schoolid)  
		drop x y

			
		eststo reg`i_est'_`i_con'

}

esttab reg* using table_rqcontacta.tex, replace keep(x) ///
	coeflabels(x "Any treatment")   se substitute(\_ _) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	noobs /// 
	nobaselevels nomtitles nonumbers ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &    \\ [1em]") prefoot("\hline") postfoot(" ") ///
	 prehead("\begin{tabular}{l*{6}{c}} \hline\hline  &\multicolumn{5}{c}{y = Last year remittances from contact in the EU} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}  \\   \cmidrule(lr){2-6}     &\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 1 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 2.5 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 5 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 10 Mil. \\ GNF}}&\multicolumn{1}{c}{\Shortstack{1em}{More than \\ 20 Mil. \\ GNF}} \\")



eststo clear


		
forval i_est = 1/5 {

		


		local depvar : word `i_est' of `varlist'
		gen y = `depvar'

		qui sum y if l.treatment_status == 1  &  f.source_info_guinea < 6
		local meandep = `r(mean)'
		
		local controls `demographics' `school_char' `contacts_char'
			
		gen x = treatment_status
		reg f1.y `controls' i.x maxremittances_more1m_c maxremittances_more2_5m_c maxremittances_more5m_c maxremittances_more10m_c maxremittances_more20m_c maxremittances_qmissing strata if f2.source_info_guinea < 6  & attended_tr != . & time == 0 & f.contact_eu_c == 1,  cluster(schoolid)  
		drop x y
		
		local individual "Yes"
		local school "Yes"
			
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

esttab reg* using table_rqcontactb.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  individual school N meandep, fmt(s s s s s s a2 s) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "' `"Individual controls"'  `"School controls"'   `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &    \\ [1em]")    postfoot("\hline\hline \end{tabular}") 


	
	
restore







*Multinomial logit

est clear

preserve
gen migregair = 0 if migration_guinea == 0
replace  migregair = 1 if migration_air == 1
replace  migregair = 2 if migration_noair == 1
replace migregair = f2.migregair
replace source_info_guinea = f2.source_info_guinea

gen migregvisa = 0 if migration_guinea == 0
replace  migregvisa = 1 if migration_visa == 1
replace  migregvisa = 2 if migration_novisa == 1
replace migregvisa = f2.migregvisa

drop if time > 0
label define y 0 "No migration" 1 "Regular Migration" 2 "Potentially Irregular Migration"


forval i_dep = 1/2 {
	forval i_con = 1/3 {
		
		if `i_dep' == 1 {
			gen y = migregvisa
		}
		
		if `i_dep' == 2 {
			gen y = migregair
		}
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"

		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		label values y y


		mlogit y i.treatment_status strata `controls'  if source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
		
		*margins, dydx(*) predict(outcome(2))
		
		gen y1 = y == 1 if !missing(y)
		qui sum y1 if source_info_guinea < 6
		local meandepone = `r(mean)'*100
		local meandepone = string(`meandepone', "%9.2f")
		
		gen y2 = y == 2 if !missing(y)
		qui sum y2 if source_info_guinea < 6
		local meandeptwo = `r(mean)'*100
		local meandeptwo = string(`meandeptwo', "%9.2f")
		
		estadd local space = " "
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		estadd local meandepone = `"`meandepone'\%"'
		estadd local meandeptwo = `"`meandeptwo'\%"'
		


		drop y*
		est sto reg`i_dep'_`i_con'
	}
}

restore




esttab reg* using tablemigregml.tex,  replace keep(2.treatment_status 3.treatment_status 4.treatment_status) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) noomitted ///
	coeflabels(2.treatment_status "\(T1\) - Risk" 3.treatment_status "\(T2\) - Econ" 4.treatment_status "\(T3\) - Combined" /// 
	strata "Big school")  nomtitles se   substitute(_ " ")  ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = 0 No migr., 1 Regular Migration, 2 Irregular Migr.} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{3}{c}{   \Shortstack{1em}{Regular status measured \\ by having a visa}   }&\multicolumn{3}{c}{\Shortstack{1em}{Regular status measured \\ by traveling w/ airplane}}  \\  ") nonumbers ///
	stats(space individual school N meandepone meandeptwo, fmt(s s s 0 3 3) ///
	layout( )  labels(`" "' `"Individual controls"' `"School controls"'  `"\(N\)"'  `"Mean reg. mig. control"' `"Mean irreg. mig. control"')) ///
	postfoot("\hline\hline \end{tabular}") 


	
	
preserve
gen migregair = 0 if migration_guinea == 0
replace  migregair = 1 if migration_air == 1
replace  migregair = 2 if migration_noair == 1
replace migregair = f2.migregair
replace source_info_guinea = f2.source_info_guinea

gen migregvisa = 0 if migration_guinea == 0
replace  migregvisa = 1 if migration_visa == 1
replace  migregvisa = 2 if migration_novisa == 1
replace migregvisa = f2.migregvisa

drop if time > 0
label define y 0 "No migration" 1 "Regular Migration" 2 "Potentially Irregular Migration"


forval i_dep = 1/2 {
	forval i_con = 1/3 {
		
		if `i_dep' == 1 {
			gen y = migregvisa
		}
		
		if `i_dep' == 2 {
			gen y = migregair
		}
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"

		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}
		
		label values y y


		mlogit y i.treatment_status##i.contact_eu strata `controls'  if source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
		
		gen y1 = y == 1 if !missing(y)
		qui sum y1 if source_info_guinea < 6
		local meandepone = `r(mean)'*100
		local meandepone = string(`meandepone', "%9.2f")
		
		gen y2 = y == 2 if !missing(y)
		qui sum y2 if source_info_guinea < 6
		local meandeptwo = `r(mean)'*100
		local meandeptwo = string(`meandeptwo', "%9.2f")
		
		estadd local space = " "
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		estadd local meandepone = `"`meandepone'\%"'
		estadd local meandeptwo = `"`meandeptwo'\%"'
		


		drop y*
		est sto reg`i_dep'_`i_con'
	}
}

restore


esttab reg* using tablemigregmleu.tex,  replace keep(2.treatment_status 3.treatment_status 4.treatment_status 2.treatment_status#1.contact_eu 3.treatment_status#1.contact_eu 4.treatment_status#1.contact_eu 1.contact_eu) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) noomitted ///
	coeflabels(2.treatment_status "\(T1\) - Risk" 3.treatment_status "\(T2\) - Econ" 4.treatment_status "\(T3\) - Combined" /// 
	2.treatment_status#1.contact_eu "\(T1\) - Risk \(*\) Contacts in the EU" 3.treatment_status#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU" ///
	4.treatment_status#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU"  1.contact_eu "Contacts in the EU " ///
	strata "Big school")  nomtitles se   substitute(_ " ")  ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = 0 No migr., 1 Regular Migration, 2 Irregular Migr.} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{3}{c}{   \Shortstack{1em}{Irregular status measured \\ by having a visa}   }&\multicolumn{3}{c}{\Shortstack{1em}{Irregular status measured \\ by traveling w/ airplane}}  \\  ") nonumbers ///
	stats(space individual school N meandepone meandeptwo, fmt(s s s 0 3 3) ///
	layout( )  labels(`" "' `"Individual controls"' `"School controls"'  `"\(N\)"'  `"Mean reg. mig. control"' `"Mean irreg. mig. control"')) ///
	postfoot("\hline\hline \end{tabular}") 

	





gen contact_eu_unkn = contact_eu * unknown_occ
replace contact_eu_kn = contact_eu * (1 - unknown_occ)
reg f2.migration_guinea i.treatment_status##i.contact_eu i.treatment_status##i.contact_eu_kn   strata if f2.source_info_guinea < 6  & attended_tr != .  ,  cluster(schoolid)
reg f2.migration_guinea i.treatment_status##i.contact_eu_unkn i.treatment_status##i.contact_eu_kn   strata if f2.source_info_guinea < 6  & attended_tr != .  ,  cluster(schoolid)
reg f2.migration_guinea  i.treatment_status##i.sec10_q7_1   strata if f2.source_info_guinea < 6  & attended_tr != .  ,  cluster(schoolid)


reg f2.migration_novisa i.treatment_status strata grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win durablesnomiss durablesmiss fees50 ratio_female_lycee rstudteach rstudclass if f2.source_info_guinea < 6  & attended_tr != . & f2.migration_visa != 100, 
est sto Y1
reg f2.migration_visa i.treatment_status strata grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win durablesnomiss durablesmiss fees50 ratio_female_lycee rstudteach rstudclass if f2.source_info_guinea < 6  & attended_tr != . & f2.migration_novisa != 100, 
est sto Y2
suest Y1 Y2, cluster(schoolid)
test [Y1_mean = Y2_mean]: 2.treatment_status








gen europe_ind = 0 if country_ind != ""
replace europe_ind = 1 if country_ind == "DEU"
replace europe_ind = 1 if country_ind == "ESP"
replace europe_ind = 1 if country_ind == "FRA"
replace europe_ind = 1 if country_ind == "GBR"
replace europe_ind = 1 if country_ind == "ITA"
replace europe_ind = 1 if country_ind == "PRT"
replace europe_ind = 1 if mig_14_p == "EUROPE"
replace europe_ind = 1 if mig_14_contact_p == "EUROPE"
replace europe_ind = 1 if mig_14_contact_sec_p == "EUROPE"
replace europe_ind = 0 if migration_guinea == 0

gen noafrica_ind = europe_ind
replace noafrica_ind = 1 if country_ind == "USA"
replace noafrica_ind = 1 if country_ind == "CAN"
replace noafrica_ind = 1 if country_ind == "LBN"

gen africa_ind = migration_guinea
replace africa_ind = 0 if noafrica_ind == 1
replace africa_ind = . if migration_guinea == 1 & country_ind == ""

* Covariates of perceptions

reg mrisk_index  `migcov' if time == 0
local individual "No"
local school "No"
estadd local individual = "`individual'"
estadd local school = "`school'"
est sto reg1

reg mrisk_index `migcov' `demographics' if time == 0
local individual "Yes"
local school "No"
estadd local individual = "`individual'"
estadd local school = "`school'"
est sto reg2


reg mrisk_index `migcov' `demographics' `school_char' strata if time == 0
local individual "Yes"
local school "Yes"
estadd local individual = "`individual'"
estadd local school = "`school'"
est sto reg3

reg economic_index `migcov' if time == 0
local individual "No"
local school "No"
estadd local individual = "`individual'"
estadd local school = "`school'"
est sto reg4

reg economic_index `migcov' `demographics' if time == 0
local individual "Yes"
local school "No"
estadd local individual = "`individual'"
estadd local school = "`school'"
est sto reg5

reg economic_index `migcov' `demographics' `school_char' strata if time == 0
local individual "Yes"
local school "Yes"
estadd local individual = "`individual'"
estadd local school = "`school'"
est sto reg6

esttab reg* using table_beliefs_cov.tex, replace label ///
	keep(`migcov') ///
		postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline ") nonumbers  se substitute(\_ _) ///
	stats(individual school N , fmt(s s 0) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"' )) ///
	mtitles("\Shortstack{1em}{(1)\\ PCA \\ Risk \\ Index} " ///
	"\Shortstack{1em}{(1)\\ PCA \\ Risk \\ Index} " ///
	"\Shortstack{1em}{(1)\\ PCA \\ Risk \\ Index} " ///
	"\Shortstack{1em}{(1)\\ PCA \\ Econ \\ Index} " ///
	"\Shortstack{1em}{(1)\\ PCA \\ Econ \\ Index} " ///
	"\Shortstack{1em}{(1)\\ PCA \\ Econ \\ Index} ")








*Libyan route chosen by route characteristics

preserve

expand 2, gen(libyan_route)

global risk_outcomes =  " beaten " ///
							+ " forced_work " ///
							+ " kidnapped " ///
							+ " die_bef_boat " ///
							+ " die_boat " ///
							+ " sent_back "
							
foreach var in $risk_outcomes {
	gen `var' = .
	replace `var' = italy_`var' if libyan_route == 1
	replace `var' = spain_`var' if libyan_route == 0
}

gen asinh_journey_cost_winsor = .
replace asinh_journey_cost_winsor = asinhitaly_journey_cost_winsor if libyan_route == 1
replace asinh_journey_cost_winsor = asinhspain_journey_cost_winsor if libyan_route == 0

gen asinh_duration_winsor = .
replace asinh_duration_winsor = asinhitaly_duration_winsor if libyan_route == 1
replace asinh_duration_winsor = asinhspain_duration_winsor if libyan_route == 0

gen chosen = .
replace chosen = 1 if libyan_route == 0 & route_chosen == 0
replace chosen = 0 if libyan_route == 1 & route_chosen == 0
replace chosen = 0 if libyan_route == 0 & route_chosen == 1
replace chosen = 1 if libyan_route == 1 & route_chosen == 1


* label risk var
label var forced_work "Being forced to work"
label var kidnapped "Being kidnapped"
label var sent_back "Being sent back"
label var beaten "Being beaten"
label var die_boat "Death in boat"
label var die_bef_boat "Death before boat"
label var die_bef_boat "Death before boat"
label var die_bef_boat "Death before boat"
label var asinh_duration "Duration of the journey"
label var asinh_journey_cost "Cost of the journey"
label var chosen "Route"


keep $risk_outcomes chosen libyan_route time id_number treatment_status asinh_journey_cost_winsor asinh_duration_winsor

clogit chosen  asinh_duration_winsor beaten  forced_work asinh_journey_cost_winsor kidnapped die_bef_boat die_boat  sent_back       if time == 0 , group(id_number)
est sto reg1

esttab reg* using table_routechoice.tex, replace label ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) se ///
	postfoot("\hline\hline \end{tabular} }")

restore


Multinomial logit


preserve
gen migreg = 0 if migration_guinea == 0
replace  migreg = 1 if migration_air == 1
replace  migreg = 2 if migration_noair == 1
replace migreg = f2.migreg
drop if time > 0
drop if migreg == .

mlogit migreg i.treatment_status strata grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win fees50 ratio_female_lycee rstudteach rstudclass, cluster(schoolid)


restore



gen migreg = 0 if migration_guinea == 0
replace  migreg = 1 if migration_visa == 1
replace  migreg = 2 if migration_novisa == 1
replace migreg = f2.migreg
drop if time > 0
drop if migreg == .

mlogit migreg i.treatment_status strata, cluster(schoolid)
ologit migreg i.treatment_status strata, cluster(schoolid)






Nested logit

gen migireg = 0 if migration_guinea == 0
replace  migireg = 1 if migration_visa == 1
replace  migireg = 2 if migration_novisa == 1
replace migireg = f2.migireg
drop if time > 0
drop if migireg == .

keep treatment_status schoolid migireg id_number

gen chosen = 1

xtset id_number migireg 
tsfill, full

replace chosen = 0 if chosen == .


nlogitgen ntype = migireg(0, 1 2)
nlogittree migireg ntype 

egen treatment_status_mean = mean(treatment_status), by(id_number)
replace treatment_status = treatment_status_mean

egen schoolid_mean = mean(schoolid), by(id_number)
replace schoolid = schoolid_mean

nlogit chosen  || ntype:  || migireg: i.treatment_status, case(id_number) 




import delimited "/Users/giacomobattiston/Downloads/Guinea Follow Up_WIDE (6).csv", clear
rename id id_number
gen migrated = 0
replace migrated = 1 if q1 == 0
replace migrated = 1 if q7 == 1
*duplicates tag id_number, gen(tagn)
*drop if tag == 1

replace submissiondate = subinstr(submissiondate, "giu", "jun", 1)
replace submissiondate = subinstr(submissiondate, "lug", "jul", 1)

generate datetime = clock(submissiondate, "DMYhms")
egen datemax = max(datetime), by(id_number)
keep if datetime == datemax
*keep if time == 0

merge 1:m id_number using ${main}/Data/output/followup2/BME_final.dta
keep if _merge == 3



*BALANCE

				
preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_demo using "table1a_fu3.tex",  ///
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
	$bc_var_outcomes using "table1b_fu3.tex",  ///
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
	$bc_var_demo_sec using "tablebalothind_fu3.tex",  ///
	ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Combined-Control") replace varlabels vce(cluster schoolid) leftctitle(" ") ///

restore


preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_italyrisk using "tablebalbela_fu3.tex",  ///
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
	$bc_var_spainrisk using "tablebalbelb_fu3.tex",  ///
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
	$bc_var_econ using "tablebalbelc_fu3.tex",  ///
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
	$bc_var_school using "apptable3_fu3.tex",  ///
	ctitles("Control Mean" "Risk-Control" "Econ-Control" ///
	"Combined-Control") replace varlabels vce(cluster schoolid) 

restore


preserve
keep if n_inclus == 1

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) $bc_var_school using "apptable3_fu3.tex"
	
restore


ivreg2 migrated i.treatment_status strata if time == 0, cluster(schoolid)



gen pess_update_econ2 = f2.economic_index < economic_index if !missing(f2.economic_index)&!missing(economic_index)
gen pess_update_risk2 = f2.mrisk_index > mrisk_index if !missing(f2.mrisk_index)&!missing(mrisk_index)

*reg f2.migration_guinea grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win fees50 ratio_female_lycee rstudteach rstudclass f.desire desire if treatment_status == 1

*reg f2.migration_guinea grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win fees50 ratio_female_lycee rstudteach rstudclass f.planning planning if treatment_status == 1


* questo molto interessante
*reg f.discuss_mig  strata grade6 grade7 female fath_alive moth_alive fath_educ2 fath_educ3 fath_educ4 fath_educ5 moth_educ2 moth_educ3 moth_educ4 moth_educ5 fath_working moth_working sister_no_win brother_no_win fees50 ratio_female_lycee rstudteach rstudclass i.treatment_status##c.inter_daily if attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)


local risk_outcomes italy_beaten spain_beaten italy_forced_work spain_forced_work italy_kidnapped spain_kidnapped italy_die_bef_boat spain_die_bef_boat italy_die_boat spain_die_boat italy_sent_back spain_sent_back 
	
	
* DESCRIPTIVE STATS MIGRATION	
sum  discuss_mig mig_classmates contacts_winsor discuss_wage_contact1 discuss_job_contact1 discuss_benef_contact1 discuss_trip_contact1 discuss_fins_contact1 discuss_wage_contact2 discuss_job_contact2 discuss_benef_contact2 discuss_trip_contact2 discuss_fins_contact2 if time == 0

*Table done by Lucia for the presentation
tab sec2_q11 if time==0
tab italy_awareness if time==0
tab spain_awareness if time==0

*Misinformation 
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


*/









/*






* GRAPH BELIEFS



global risk_outcomes =  " asinhmrisk_duration_winsor " ///
							+ " asinhmrisk_journey_cost_winsor " ///
							+ " mrisk_beaten " ///
							+ " mrisk_forced_work " ///
							+ " mrisk_kidnapped " ///
							+ " mrisk_die_bef_boat " ///
							+ " mrisk_die_boat " ///
							+ " mrisk_sent_back "
							
							
m: obs = J(16,5,.)
			
local n 1
local k 1

foreach var in $risk_outcomes {
	forval i_contact = 0/1 {
		
			sum `var' if attended_tr != . & time == 0 & contact_eu == `i_contact'

			m: obs[`n',1] = `r(mean)'
			m: obs[`n',2] = `r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)')
			m: obs[`n',3] = `r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)')
			
			if (mod(`n', 2) == 1) {
				local k = `k' + 1
			}
			m: obs[`n',4] = `n' + `k' -2
			m: obs[`n',5] = `i_contact'
						
			local n = `n' + 1
	}

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
	legend(row(1) order(1 "No contact in the EU" 2 "Contacts in the EU" )) ///
	xlabel( 1.5 "Duration (asinh)" 4.5 "Cost (asinh)" 7.5 "Beaten" 10.5 "Forced work" 13.5 "Kidnapped" 16.5 "Death bef. boat" 19.5 "Death boat" 22.5 "Sent back" , angle(45)) ///
	ytitle(Perceived probability, ) xtitle("" ) 

* Export graphs and latex file so as to adapt font.
graph save ${main}/Draft/figures/beliefsrisk_coneu.png, replace
graph export ${main}/Draft/figures/beliefsrisk_coneu.png, as(png) replace
* Restore main dataset.

restore





* GRAPH BELIEFS (ITA)



global risk_outcomes =  " asinhitaly_duration_winsor " ///
							+ " asinhitaly_journey_cost_winsor " ///
							+ " italy_beaten " ///
							+ " italy_forced_work " ///
							+ " italy_kidnapped " ///
							+ " italy_die_bef_boat " ///
							+ " italy_die_boat " ///
							+ " italy_sent_back "
							
							
m: obs = J(16,5,.)
			
local n 1
local k 1

foreach var in $risk_outcomes {
	forval i_contact = 0/1 {
		
			sum `var' if attended_tr != . & time == 0 & contact_eu == `i_contact'

			m: obs[`n',1] = `r(mean)'
			m: obs[`n',2] = `r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)')
			m: obs[`n',3] = `r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)')
			
			if (mod(`n', 2) == 1) {
				local k = `k' + 1
			}
			m: obs[`n',4] = `n' + `k' -2
			m: obs[`n',5] = `i_contact'
						
			local n = `n' + 1
	}

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
	legend(row(1) order(1 "No contact in the EU" 2 "Contacts in the EU" )) ///
	xlabel( 1.5 "Duration (asinh)" 4.5 "Cost (asinh)" 7.5 "Beaten" 10.5 "Forced work" 13.5 "Kidnapped" 16.5 "Death bef. boat" 19.5 "Death boat" 22.5 "Sent back" , angle(45)) ///
	ytitle(Perceived probability, ) xtitle("" ) 

* Export graphs and latex file so as to adapt font.
graph save ${main}/Draft/figures/beliefsriskita_coneu.png, replace
graph export ${main}/Draft/figures/beliefsriskita_coneu.png, as(png) replace
* Restore main dataset.

restore







* GRAPH BELIEFS (SPA)



global risk_outcomes =  " asinhspain_duration_winsor " ///
							+ " asinhspain_journey_cost_winsor " ///
							+ " spain_beaten " ///
							+ " spain_forced_work " ///
							+ " spain_kidnapped " ///
							+ " spain_die_bef_boat " ///
							+ " spain_die_boat " ///
							+ " spain_sent_back "
							
							
m: obs = J(16,5,.)
			
local n 1
local k 1

foreach var in $risk_outcomes {
	forval i_contact = 0/1 {
		
			sum `var' if attended_tr != . & time == 0 & contact_eu == `i_contact'

			m: obs[`n',1] = `r(mean)'
			m: obs[`n',2] = `r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)')
			m: obs[`n',3] = `r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)')
			
			if (mod(`n', 2) == 1) {
				local k = `k' + 1
			}
			m: obs[`n',4] = `n' + `k' -2
			m: obs[`n',5] = `i_contact'
						
			local n = `n' + 1
	}

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
	legend(row(1) order(1 "No contact in the EU" 2 "Contacts in the EU" )) ///
	xlabel( 1.5 "Duration (asinh)" 4.5 "Cost (asinh)" 7.5 "Beaten" 10.5 "Forced work" 13.5 "Kidnapped" 16.5 "Death bef. boat" 19.5 "Death boat" 22.5 "Sent back" , angle(45)) ///
	ytitle(Perceived probability, ) xtitle("" ) 

* Export graphs and latex file so as to adapt font.
graph save ${main}/Draft/figures/beliefsriskspa_coneu.png, replace
graph export ${main}/Draft/figures/beliefsriskspa_coneu.png, as(png) replace
* Restore main dataset.

restore



*** ECONOMIC OUTCOMES

global economic_outcomes = " asinhexpectation_wage_winsor " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " finding_job " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " in_favor_of_migration " 



m: obs = J(18,5,.)
			
local n 1
local k 1

foreach var in $economic_outcomes {
	forval i_contact = 0/1 {
		
			sum `var' if attended_tr != . & time == 0 & contact_eu == `i_contact'

			m: obs[`n',1] = `r(mean)'
			m: obs[`n',2] = `r(mean)' - 1.96*`r(sd)'/sqrt(`r(N)')
			m: obs[`n',3] = `r(mean)' + 1.96*`r(sd)'/sqrt(`r(N)')
			
			if (mod(`n', 2) == 1) {
				local k = `k' + 1
			}
			m: obs[`n',4] = `n' + `k' -2
			m: obs[`n',5] = `i_contact'
						
			local n = `n' + 1
	}

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
	legend(row(1) order(1 "No contact in the EU" 2 "Contacts in the EU" )) ///
	xlabel( 1.5 "Wage (asinh)" 4.5 "Liv. Cost (asinh)" 7.5 "Finding Job" 10.5 "Cont. Studies" 13.5 "Obt. Asylum" 16.5 "Becom. Citizen" 19.5 "Returning bef. 5yrs" 22.5 "Gov't transfers" 25.5 "Host Country Att." , angle(45)) ///
	ytitle(Perceived probability, ) xtitle("" ) 

* Export graphs and latex file so as to adapt font.
graph save ${main}/Draft/figures/beliefsecon_coneu.png, replace
graph export ${main}/Draft/figures/beliefsecon_coneu.png, as(png) replace
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

ssc install spmap
ssc install shp2dta
ssc install mif2dta
ssc install kountry

*use ${dta}worldcoor.dta, clear
*drop if _ID == 44 & _X <-40
*save ${dta}worldcoor_noguyana.dta, replace

****DESIRE
preserve
rename _merge _merge13
keep if !missing(sec2_q2) & time == 0
rename sec2_q2 SOVEREIGNT
replace SOVEREIGNT = proper(SOVEREIGNT)
replace SOVEREIGNT = "United Arab Emirates" if SOVEREIGNT == "Dubai"
replace SOVEREIGNT = "United Kingdom" if SOVEREIGNT == "England"
replace SOVEREIGNT = "Malaysia" if SOVEREIGNT == "Malaisia"
replace SOVEREIGNT = "United States of America" if SOVEREIGNT == "United States"
count
gen counting = 1/`r(N)'
collapse (sum) counting, by(SOVEREIGNT)
merge m:m SOVEREIGNT using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Reds)  clmethod(custom) clbreaks(0(0.05)0.45) legend(order( 10 "(0.40 - 0.45]" 9 "(0.35 - 0.40]" 8 "(0.30 - 0.35]" 7 "(0.25 - 0.30]" 6 "(0.20 - 0.25]" 5 "(0.15 - 0.20]" 4 "(0.10 - 0.15]" 3 "(0.05 - 0.10]" 2 "(0 - 0.05]" 1 "0"))
graph export "${main}/Draft/figures/mapmigrationwish.png", replace as(png)
graph save "${main}/Draft/figures/mapmigrationwish.gph", replace
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Reds)graph export "${main}/Draft/figures/mapmigrationwish_ownts.png", replace as(png)
graph save "${main}/Draft/figures/mapmigrationwish_ownts.gph", replace
restore

****PLAN
preserve
rename _merge _merge13
keep if !missing(sec2_q5) & time == 0
rename sec2_q5 SOVEREIGNT
replace SOVEREIGNT = proper(SOVEREIGNT)
replace SOVEREIGNT = "United Arab Emirates" if SOVEREIGNT == "Dubai"
replace SOVEREIGNT = "United Kingdom" if SOVEREIGNT == "England"
replace SOVEREIGNT = "Malaysia" if SOVEREIGNT == "Malaisia"
replace SOVEREIGNT = "United States of America" if SOVEREIGNT == "United States"
count
gen counting = 1/`r(N)'
collapse (sum) counting, by(SOVEREIGNT)
rereplace counting = 0 if counting == .
rge m:m SOVEREIGNT using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Reds)  clmethod(custom) clbreaks(0(0.05)0.45)
graph export "${main}/Draft/figures/mapmigrationplan.png", replace as(png)
graph save "${main}/Draft/figures/mapmigrationplan.gph", replace
restore

****PREPARE
preserve
rename _merge _merge13
keep if !missing(sec2_q5) & time == 0 & prepare == 1
rename sec2_q5 SOVEREIGNT
replace SOVEREIGNT = proper(SOVEREIGNT)
replace SOVEREIGNT = "United Kingdom" if SOVEREIGNT == "England"
replace SOVEREIGNT = "United States of America" if SOVEREIGNT == "United States"
count
gen counting = 1/`r(N)'
collapse (sum) counting, by(SOVEREIGNT)
rereplace counting = 0 if counting == .
rge m:m SOVEREIGNT using  ${dta}worlddata.dta
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Reds)  clmethod(custom) clbreaks(0(0.05)0.45)
graph export "${main}/Draft/figures/mapmigrationprep.png", replace as(png)
graph save "${main}/Draft/figures/mapmigrationprep.gph", replace
restore

****MIGRATION
preserve
rename _merge _merge13
keep if migration_guinea == 1
rename country_ind ISO_A3_EH
count
gen counting = 1/`r(N)'
collapse (sum) counting, by(ISO_A3_EH)
merge m:m ISO_A3_EH using  ${dta}worlddata.dta
*replace counting = 0 if counting == .
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Reds)  clmethod(custom) clbreaks(0(0.03)0.27) legend(order( 10 "(0.24 - 0.27]" 9 "(0.21 - 0.24]" 8 "(0.18 - 0.21]" 7 "(0.15 - 0.18]" 6 "(0.12 - 0.15]" 5 "(0.09 - 0.12]" 4 "(0.06 - 0.09]" 3 "(0.03 - 0.06]" 2 "(0 - 0.03]" 1 "0"))
graph export "${main}/Draft/figures/mapmigration.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration.gph", replace
spmap counting using ${dta}worldcoor_noguyana.dta, id(id)  fcolor(Reds) 
graph export "${main}/Draft/figures/mapmigration_ownts.png", replace as(png)
graph save "${main}/Draft/figures/mapmigration_ownts.gph", replace
restore


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
gen migration_noair100 = migration_noair*100
gen migration_air100 = migration_air*100
gen migration_internal100 = migration_internal*100
gen desire100 = desire*100
gen planning100 = planning*100
gen prepare100 = prepare*100
gen desvisa100 = desvisa*100
gen planvisa100 = planvisa*100
gen askedvisa100 = askedvisa*100
gen contact_eu100 = contact_eu*100


* MIGRATION INTENTIONS AND ACTUAL MIGRATION

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/3 {
	forval i_con = 1/2 {
		
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}

		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"
		}

		if `i_est' == 1 {
			reg f2.migration_guinea100 f.desire  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & treatment_status == 1,
		}
		
		if `i_est' == 2 {
			reg f2.migration_guinea100 f.planning  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & treatment_status == 1,
		}
		
		if `i_est' == 3 {
			reg f2.migration_guinea100 f.prepare   `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & treatment_status == 1,
		}
		
		
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		

		
	}
}


esttab reg* using tablecontacts_migintandmig.tex, replace keep(F.desire F.planning F.prepare) ///
coeflabels(F.desire "Desire to migrate at midline" F.planning "Planning to migrate at midline" F.prepare "Preparing to migrate at midline")   se substitute(\_ _) ///
nomtitles stats(space individual school N meandep, fmt(s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}\\")   nonumbers





* MIGRATION INTENTIONS AND ACTUAL MIGRATION

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

gen inter = contact_eu
		
forval i_est = 1/3 {
	forval i_con = 1/2 {
		
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}

		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"
		}

		if `i_est' == 1 {
			reg f2.migration_guinea100 cF.desire##i.inter  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & treatment_status == 1,
		}
		
		if `i_est' == 2 {
			reg f2.migration_guinea100 cF.planning##i.inter  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & treatment_status == 1,
		}
		
		if `i_est' == 3 {
			reg f2.migration_guinea100 cF.prepare##i.inter   `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & treatment_status == 1,
		}
		
		
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		

		
	}
}

drop inter

esttab reg* using tablecontacts_migintandmig_eu.tex, replace keep(F.desire F.planning F.prepare 1.inter#cF.desire 1.inter#cF.planning 1.inter#cF.prepare 1.inter) ///
coeflabels(F.desire "Desire to migrate at midline" F.planning "Planning to migrate at midline" F.prepare "Preparing to migrate at midline" 1.inter#cF.desire "Desire to migrate at midline \(*\) Contacts in the EU" 1.inter#cF.planning "Planning to migrate at midline \(*\) Contacts in the EU" 1.inter#cF.prepare "Preparing to migrate at midline \(*\) Contacts in the EU" 1.inter "Contacts in the EU")   se substitute(\_ _) ///
nomtitles stats(space individual school N meandep, fmt(s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}\\")   nonumbers






/*
* TYPE OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = school_index_allavg
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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


esttab reg* using tablecontacts_schoolqall.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  High school quality" 3.x#1.inter "\(T2\) - Econ \(*\)  High school quality" 4.x#1.inter "\(T3\) - Combined \(*\)  High school quality" ///
1.inter "High school quality (Pers.)" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) High school quality = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) High school quality = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) High school quality = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers





* HTE BY SCHOOL QUALITY (INFRASTACTURE AND PERSONNEL), RESTRICTED SAMPLE

est clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {
		
					
		if `i_inter' == 1 {
			gen inter = school_index_infavg == 0
		}
		
		if `i_inter' == 2 {
			gen inter = school_index_persavg == 0
		}
		

		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"


		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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
		
		eststo reg`i_est'_`i_inter'
		
		drop inter

		
	}
}


esttab reg* using tablecontacts_schoolqinfteach2.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Low school quality" 3.x#1.inter "\(T2\) - Econ \(*\)  Low school quality" 4.x#1.inter "\(T3\) - Combined \(*\)  Low school quality" ///
1.inter "Low school quality" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Low school quality = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Low school quality = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Low school quality = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{School quality: \\ Infrastracture}   }&\multicolumn{2}{c}{\Shortstack{1em}{School quality: \\ Personnel}}  \\  ") nonumbers






* HTE BY SCHOOL QUALITY (INFRASTACTURE AND PERSONNEL), RESTRICTED SAMPLE

est clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {
		
					
		if `i_inter' == 1 {
			gen inter = school_index_infavg
		}
		
		if `i_inter' == 2 {
			gen inter = school_index_persavg
		}
		

		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"


		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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
		
		eststo reg`i_est'_`i_inter'
		
		drop inter

		
	}
}


esttab reg* using tablecontacts_schoolqinfteach.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  High school quality" 3.x#1.inter "\(T2\) - Econ \(*\)  High school quality" 4.x#1.inter "\(T3\) - Combined \(*\)  High school quality" ///
1.inter "High school quality" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) High school quality = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) High school quality = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) High school quality = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{School quality: \\ Infrastracture}   }&\multicolumn{2}{c}{\Shortstack{1em}{School quality: \\ Personnel}}  \\  ") nonumbers






*Correlates of contacts, mean

est clear

		
		
forval i_var = 1/3 {
	forval i_est = 1/2 {

		if `i_var' == 1 {
			local intent desire
			local visaintent desvisa
		}
		
		if `i_var' == 2 {
			local intent planning
			local visaintent planvisa
		}
		
		if `i_var' == 3 {
			local intent prepare
			local visaintent askedvisa
		}
		
		qui sum l2.contact_eu100 if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'
		
		if `i_est' == 1 {
			reg contact_eu100 `intent' `visaintent'   if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
			
					local individual "No"
		local school "No"
		}
		
		if `i_est' == 2 {
			reg contact_eu100 `intent' `visaintent' `controls' if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, 			cluster(schoolid)
			
					local individual "Yes"
		local school "Yes"
		}		
			
			
		estadd local space " "
	


		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_est'
		
		
	}
}


esttab reg* using contact_cor_reord2.tex, replace keep(desire planning prepare desvisa planvisa askedvisa) ///
	coeflabels(remittances_eu "Any remittances from the EU" desire "Wish to migrate" planning "Plan to migrate"  prepare "Prepare to migrate" desvisa "Wish to migr. w/ visa" planvisa "Plan to migr. w/ visa" askedvisa "Asked for visa")  se substitute(\_ _) ///
	order(desire desvisa planning planvisa prepare askedvisa) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var."')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{4}{c}{y = contacts in the EU} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}   \\  ")

	



*Correlates of contacts, mean

eststo clear

local controls `demographics' `school_char' strata

qui sum l2.contact_eu100 if source_info_guinea < 6
local meandep = `r(mean)'

qui reg contact_eu100 mrisk_index economic_index  `controls'  ///
	if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)

estadd local space " "

estadd local individual "Yes"
estadd local school "Yes"

local meandep = string(`meandep', "%9.2f")
estadd local meandep = `"`meandep'\%"'

eststo reg0_0
		
		

forval i_var = 1/3 {

		if `i_var' == 1 {
			local intent desire
			local visaintent desvisa
		}
		
		if `i_var' == 2 {
			local intent planning
			local visaintent planvisa
		}
		
		if `i_var' == 3 {
			local intent prepare
			local visaintent askedvisa
		}
		
		qui sum l2.contact_eu100 if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'
		
		reg contact_eu100 `intent' `visaintent'  `controls'  if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)		
		
		estadd local space " "
	
		local individual "Yes"
		local school "Yes"

		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'
		
		
}


esttab reg* using contact_cor_reord.tex, replace keep(mrisk_index economic_index desire planning prepare desvisa planvisa askedvisa) ///
	coeflabels(mrisk_index "PCA Risk" economic_index "PCA Econ" desire "Wish to migrate" planning "Plan to migrate"  prepare "Prepare to migrate" desvisa "Wish to migr. w/ visa" planvisa "Plan to migr. w/ visa" askedvisa "Asked for visa")  se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var."')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = contacts in the EU} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}   \\  ")

	


*Correlates of contacts, mean

eststo clear

local controls `demographics' `school_char' strata

qui sum l2.contact_eu100 if source_info_guinea < 6
local meandep = `r(mean)'

qui reg contact_eu100 mrisk_index economic_index  `controls'  ///
	if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)

estadd local space " "

estadd local individual "Yes"
estadd local school "Yes"

local meandep = string(`meandep', "%9.2f")
estadd local meandep = `"`meandep'\%"'

eststo reg0_0
		
		

forval i_var = 1/3 {
	forval i_spec = 1/2 {

		if `i_var' == 1 {
			local intent desire
			local visaintent desvisa
		}
		
		if `i_var' == 2 {
			local intent planning
			local visaintent planvisa
		}
		
		if `i_var' == 3 {
			local intent prepare
			local visaintent askedvisa
		}
		
		qui sum l2.contact_eu100 if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		
		if `i_spec' == 1 {
			reg contact_eu100 mrisk_index economic_index `intent'  `controls'  if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		}
		
		if `i_spec' == 2 {
			reg contact_eu100 mrisk_index economic_index `intent' `visaintent'  `controls'  if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)		
		}
		
		estadd local space " "
	
		local individual "Yes"
		local school "Yes"

		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_spec'
		
		
	}
}


esttab reg* using contact_cor.tex, replace keep(mrisk_index economic_index desire planning prepare desvisa planvisa askedvisa) ///
	coeflabels(mrisk_index "PCA Risk" economic_index "PCA Econ" desire "Wish to migrate" planning "Plan to migrate"  prepare "Prepare to migrate" desvisa "Wish to migr. w/ visa" planvisa "Plan to migr. w/ visa" askedvisa "Asked for visa")  se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var."')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{8}{c}} \hline\hline  &\multicolumn{7}{c}{y = contacts in the EU} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}    \\  ")




*Correlates of contacts, second version, mean

eststo clear

local controls `demographics' `school_char' strata

qui sum l2.contact_eu100 if source_info_guinea < 6
local meandep = `r(mean)'

qui reg contact_eu100 mrisk_index economic_index  `controls'  ///
	if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)

estadd local space " "

estadd local individual = "`individual'"
estadd local school = "`school'"

local meandep = string(`meandep', "%9.2f")
estadd local meandep = `"`meandep'\%"'

eststo reg0_0
		
		

forval i_var = 1/3 {
	forval i_spec = 1/2 {

		if `i_var' == 1 {
			local visaintent desvisa
			local intent desire
			}
		
		if `i_var' == 2 {
			local visaintent planvisa
			local intent planning
		}
		
		if `i_var' == 3 {
			local visaintent askedvisa
			local intent prepare
		}
		
		qui sum l2.contact_eu if source_info_guinea < 6
		local meandep = `r(mean)'

		
		if `i_spec' == 1 {
			reg contact_eu100 mrisk_index economic_index `visaintent'  `controls'  if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		}
		
		if `i_spec' == 2 {
			reg contact_eu100 mrisk_index economic_index `visaintent'  `intent'  `controls'  if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)		
		}
		
		estadd local space " "
		
		local individual "Yes"
		local school "Yes"

		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_spec'
		
		
	}
}


esttab reg* using contact_cor2.tex, replace keep(mrisk_index economic_index desire planning prepare desvisa planvisa askedvisa) ///
	coeflabels(mrisk_index "PCA Risk" economic_index "PCA Econ" desire "Wish to migrate" planning "Plan to migrate"  prepare "Prepare to migrate" desvisa "Wish to migr. w/ visa" planvisa "Plan to migr. w/ visa" askedvisa "Asked for visa")  se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var."')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{8}{c}} \hline\hline  &\multicolumn{7}{c}{y = contacts in the EU} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}    \\  ")

*/

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
		
		test 2.x 3.x 4.x
		local js  = string(`r(p)', "%9.2f")
		estadd local js = `"`js'"'

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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space js space individual school N meandep, fmt(s s s s s s s s a2 s) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"' `" "'  `"\emph{H0: \(T2\) = \(T3\) = \(T4\) = 0 (p-value)}"'  `" "' `"Individual controls"'  `"School controls"'   `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

stop

/*
*MIGRATION WITHOUT VISA OR AIRPLANE (restricted sample)

eststo clear


forval i_var = 1/2 {
	forval i_est = 1/2 {
		
		if `i_var' == 1 {
			gen y = migration_novisa100
		}
		
		if `i_var' == 2 {
			gen y = migration_noair100
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.y i.x strata `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop y x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.y (i.x = i.treatment_status) ///
				strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop y x
		}
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_est'

		
	}
}

esttab reg* using tablevisaaira.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats( N meandep, fmt(0 3) ///
	layout( )  ///
	labels( `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}}  & & &  &  \\  \emph{Irregular Migration (Potential)}  & & &  &  \\  [1em]") prefoot("\hline") postfoot("\hline") ///
	mtitles("ITT" "IV" "ITT" "IV")  ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Regular status measured \\ by having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Regular status measured \\ by traveling w/ airplane}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers
	
*MIGRATION WITH VISA OR AIRPLANE (restricted sample)

eststo clear


		
forval i_var = 1/2 {
	forval i_est = 1/2 {
		
		if `i_var' == 1 {
			gen y = migration_visa100
		}
		
		if `i_var' == 2 {
			gen y = migration_air100
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.y i.x strata `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop y x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.y (i.x = i.treatment_status) ///
				strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop y x
		}
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_est'

		
	}
}

esttab reg* using tablevisaairb.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual school N meandep, fmt(0 3) ///
	layout( )  ///
	labels( `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &   \\ \emph{Regular Migration}  & & &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}") ///
	nonumbers nomtitles



*MIGRATION WITH OR WIHOUTH VISA OR AIRPLANE, NO ZEROS (restricted sample)

eststo clear


forval i_y = 1/2 {	
	forval i_var = 1/2 {
		forval i_est = 1/2 {
			
			if `i_var' == 1 & `i_y' == 1 {
				gen y = migration_novisa100
				gen yalt = migration_visa100
			}
			
			if `i_var' == 2 & `i_y' == 1 {
				gen y = migration_noair100
				gen yalt = migration_air100
			}
			
			if `i_var' == 1 & `i_y' == 2 {
				gen y = migration_visa100
				gen yalt = migration_novisa100
			}
			
			if `i_var' == 2 & `i_y' == 2 {
				gen y = migration_air100
				gen yalt = migration_noair100
			}
			
			qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
			local meandep = `r(mean)'

			if `i_est' == 1 {
				gen x = treatment_status
				qui reg f2.y i.x i.x#i.contact_eu i.contact_eu strata `demographics' `school_char' ///
					if f2.source_info_guinea < 6  & attended_tr != . & f2.yalt != 100, cluster(schoolid)
				drop y yalt x
			}
			
			if `i_est' == 2 {
				gen x = attended_tr
				qui ivreg2 f2.y (i.x i.x#i.contact_eu = i.treatment_status i.treatment_status#i.contact_eu) i.contact_eu ///
					strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != . & f2.yalt != 100, cluster(schoolid)
				drop y yalt x
			}
			
			
			local meandep = string(`meandep', "%9.2f")
			estadd local meandep = `"`meandep'\%"'
			
			eststo reg`i_y'_`i_var'_`i_est'

			
		}
	}
}

esttab reg* using tablevisaair_coneu_mig0.tex, replace keep(2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu 1.contact_eu) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.contact_eu "\(T1\) - Risk \(*\) Contacts in the EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU" 4.x#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU"  1.contact_eu "Contacts in the EU" ///
	strata "Big school")   se substitute(\_ _) ///
	stats(N meandep, fmt( 0 3) ///
	layout( )  ///
	labels( `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{9}{c}} \hline\hline  &\multicolumn{8}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}&\multicolumn{1}{c}{(8)}  \\ \cmidrule(lr){2-9} & \multicolumn{4}{c}{ Potentially irregular migration   }&\multicolumn{4}{c}{Regular  migration}  \\  \cmidrule(lr){2-5}  \cmidrule(lr){6-9} & \multicolumn{2}{c}{   \Shortstack{1em}{Regular status  \\ \(=\) having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Regular status  \\ \(=\)  traveling w/ airpl.}}  & \multicolumn{2}{c}{   \Shortstack{1em}{Regular status  \\ \(=\) having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Regular status  \\ \(=\)  traveling w/ airpl.}}  \\ ") ///
	mtitles("ITT" "IV" "ITT" "IV" "ITT" "IV" "ITT" "IV")



*MIGRATION WITH OR WIHOUTH VISA OR AIRPLANE, NO ZEROS (restricted sample)

eststo clear


forval i_y = 1/2 {	
	forval i_var = 1/2 {
		forval i_est = 1/2 {
			
			if `i_var' == 1 & `i_y' == 1 {
				gen y = migration_novisa100
				gen yalt = migration_visa100
			}
			
			if `i_var' == 2 & `i_y' == 1 {
				gen y = migration_noair100
				gen yalt = migration_air100
			}
			
			if `i_var' == 1 & `i_y' == 2 {
				gen y = migration_visa100
				gen yalt = migration_novisa100
			}
			
			if `i_var' == 2 & `i_y' == 2 {
				gen y = migration_air100
				gen yalt = migration_noair100
			}
			
			qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
			local meandep = `r(mean)'

			if `i_est' == 1 {
				gen x = treatment_status
				qui reg f2.y i.x strata `demographics' `school_char' ///
					if f2.source_info_guinea < 6  & attended_tr != . & f2.yalt != 100, cluster(schoolid)
				drop y yalt x
			}
			
			if `i_est' == 2 {
				gen x = attended_tr
				qui ivreg2 f2.y (i.x = i.treatment_status) ///
					strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != . & f2.yalt != 100, cluster(schoolid)
				drop y yalt x
			}
			
			
			local meandep = string(`meandep', "%9.2f")
			estadd local meandep = `"`meandep'\%"'
			
			eststo reg`i_y'_`i_var'_`i_est'

			
		}
	}
}

esttab reg* using tablevisaair_mig0.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(N meandep, fmt( 0 3) ///
	layout( )  ///
	labels( `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{9}{c}} \hline\hline  &\multicolumn{8}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}&\multicolumn{1}{c}{(8)}  \\ \cmidrule(lr){2-9} & \multicolumn{4}{c}{ Potentially irregular migration   }&\multicolumn{4}{c}{Regular  migration}  \\  \cmidrule(lr){2-5}  \cmidrule(lr){6-9} & \multicolumn{2}{c}{   \Shortstack{1em}{Irregular status  \\ \(=\) having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Irregular status  \\ \(=\)  traveling w/ airpl.}}  & \multicolumn{2}{c}{   \Shortstack{1em}{Irregular status  \\ \(=\) having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Irregular status  \\ \(=\)  traveling w/ airpl.}}  \\ ") ///
	mtitles("ITT" "IV" "ITT" "IV" "ITT" "IV" "ITT" "IV")


	
eststo clear


forval i_var = 1/2 {
	forval i_est = 1/2 {
		
		if `i_var' == 1 {
			gen y = migration_novisa100
			gen yalt = migration_visa100
		}
		
		if `i_var' == 2 {
			gen y = migration_noair100
			gen yalt = migration_air100
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.y i.x strata `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.y (i.x = i.treatment_status) ///
				strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
		}
		

		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_est'

		
	}
}

esttab reg* using tablevisaaira_mig0.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(N meandep, fmt(  0 3) ///
	layout( )  ///
	labels( `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}}  & & &  &  \\  \emph{Irregular Migration (Potential)}  & & &  &  \\  [1em]") prefoot("\hline") postfoot("\hline") ///
	mtitles("ITT" "IV" "ITT" "IV")  ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Regular status measured \\ by having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Regular status measured \\ by traveling w/ airplane}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers



*MIGRATION WITH VISA OR AIRPLANE, NO ZEROS (restricted sample)

eststo clear


		
forval i_var = 1/2 {
	forval i_est = 1/2 {
		
		if `i_var' == 1 {
			gen y = migration_visa100
			gen yalt = migration_novisa100
		}
		
		if `i_var' == 2 {
			gen y = migration_air100
			gen yalt = migration_noair100
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.y i.x strata `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.y (i.x = i.treatment_status) ///
				strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
		}
		
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_est'

		
	}
}

esttab reg* using tablevisaairb_mig0.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(N meandep, fmt( 0 3) ///
	layout( )  ///
	labels( `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &   \\ \emph{Regular Migration}  & & &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}") ///
	nonumbers nomtitles

*MIGRATION BY CONTACTS, NO VISA OR AIRPLANE, NO ZEROS (restricted sample), mean

eststo clear


forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desire100
		}
		
		if `i_var' == 2 {
			gen y = planning100
		}
		
		if `i_var' == 3 {
			gen y = prepare100
		}
		
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg y i.contact_eu i.contact_noeu  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using mig_intentions.tex, replace keep(1.contact_eu 1.contact_noeu) ///
	coeflabels(1.contact_eu "Contacts in the EU" 1.contact_noeu "Contacts abroad (excl. EU)")  se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intention to migrate} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Wishing to \\ migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Planning to \\ migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Preparing for \\ migration}}  \\  ")


	

	
*/

































*VISA INTENTIONS BY CONTACTS (restricted sample), mean

eststo clear

gen x = treatment_status
gen inter = contact_eu

forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desire100
			local ycon desire
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 2 {
			gen y = planning100
			local ycon planning
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 3 {
			gen y = prepare100
			local ycon prepare
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using mig_intentions_coneu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Contact in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Contact in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Contact in the EU" ///
	1.inter "Contact in the EU" strata "Big school")   se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intends to migrate at baseline} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Wishes to \\  migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Plans to \\  migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Prepares to \\ migrate}}  \\  ")

	
drop x inter




*VISA INTENTIONS BY CONTACTS (restricted sample), mean

eststo clear

gen x = treatment_status
gen inter = strong_tie_eu

forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desire100
			local ycon desire
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 2 {
			gen y = planning100
			local ycon planning
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 3 {
			gen y = prepare100
			local ycon prepare
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using mig_intentions_sconeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Strong tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Strong tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Strong tie in the EU" ///
	1.inter "Strong tie in the EU" strata "Big school")   se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intends to migrate at baseline} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Wishes to \\  migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Plans to \\  migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Prepares to \\ migrate}}  \\  ")

drop x inter
	
	

eststo clear

gen x = treatment_status
gen inter = weak_tie_eu

forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desire100
			local ycon desire
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 2 {
			gen y = planning100
			local ycon planning
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 3 {
			gen y = prepare100
			local ycon prepare
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using mig_intentions_wconeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Weak tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Weak tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Weak tie in the EU" ///
	1.inter "Weak tie in the EU" strata "Big school")   se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intends to migrate at baseline} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Wishes to \\  migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Plans to \\  migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Prepares to \\ migrate}}  \\  ")

drop x inter
	

	

eststo clear

gen x = treatment_status
gen inter = remittances_eu

forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desire100
			local ycon desire
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 2 {
			gen y = planning100
			local ycon planning
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 3 {
			gen y = prepare100
			local ycon prepare
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using mig_intentions_remeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Remittances from the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Remittances from the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Remittances from the EU" ///
	1.inter "Remittances from the EU" strata "Big school")   se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intends to migrate at baseline} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Wishes to \\  migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Plans to \\  migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Prepares to \\ migrate}}  \\  ")

drop x inter


eststo clear

gen x = treatment_status
gen inter = remittances_eu

forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desire100
			local ycon desire
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 2 {
			gen y = planning100
			local ycon planning
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		if `i_var' == 3 {
			gen y = prepare100
			local ycon prepare
			*replace y = 1 if time == 1 & f1.migration_guinea == 1
		}
		
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using mig_intentions_remeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Remittances from the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Remittances from the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Remittances from the EU" ///
	1.inter "Remittances from the EU" strata "Big school")   se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intends to migrate at baseline} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Wishes to \\  migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Plans to \\  migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Prepares to \\ migrate}}  \\  ")

drop x inter










* risk beliefs



	
global mrisk_outcomes = " asinhmrisk_duration_winsor " ///
						+ " mrisk_beaten " ///
						+ " mrisk_forced_work " ///
						+ " asinhmrisk_journey_cost_winsor  " ///
						+ " mrisk_kidnapped " ///
						+ " mrisk_die_bef_boat " ///
						+ " mrisk_die_boat " ///
						+ " mrisk_sent_back " ///
						+ " mrisk_index"


global risks_table_titles = `" " \Shortstack{1em}{(1) \\ Journey \\ Duration \\ \vphantom{foo}}" "' ///
				+ `" " \Shortstack{1em}{(2)\\ Being \\ Beaten \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(3)\\ Forced \\  to \\ Work}" "' /// 
				+ `" " \Shortstack{1em}{(4) \\ Journey\\ Cost \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(5) \\ Being \\ Kidnap- \\ ped}" "' ///
				+ `" "\Shortstack{1em}{(6)\\ Death \\ before \\ boat}" "' ///
				+ `" "\Shortstack{1em}{(7)\\ Death \\ in \\ boat}" "' /// 
				+ `" "\Shortstack{1em}{(8)\\ Sent \\ Back \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(9) \\ PCA \\ Risk \\ Index}" "' 
				

	
	

eststo clear

gen x = treatment_status
gen inter = contact_eu

local counter = 0
foreach var in $mrisk_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using riskbeliefs_coneu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Contact in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Contact in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Contact in the EU" ///
	1.inter "Contact in the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{10}{c}} \hline\hline") ///
	mtitles($risks_table_titles) 
	
drop x inter






eststo clear

gen x = treatment_status
gen inter = strong_tie_eu

local counter = 0
foreach var in $mrisk_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using riskbeliefs_sconeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Strong tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Strong tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Strong tie in the EU" ///
	1.inter "Strong tie in the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{10}{c}} \hline\hline") ///
	mtitles($risks_table_titles) 
	
drop x inter




	

eststo clear

gen x = treatment_status
gen inter = weak_tie_eu

local counter = 0
foreach var in $mrisk_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using riskbeliefs_wconeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Weak tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Weak tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Weak tie in the EU" ///
	1.inter "Weak tie in the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{10}{c}} \hline\hline") ///
	mtitles($risks_table_titles) 
	
drop x inter



	

eststo clear

gen x = treatment_status
gen inter = remittances_eu

local counter = 0
foreach var in $mrisk_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using riskbeliefs_remeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Remittances from the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Remittances from the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Remittances from the EU" ///
	1.inter "Remittances from the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{10}{c}} \hline\hline") ///
	mtitles($risks_table_titles) 
	
drop x inter







global economic_titles = `" "\qquad \Shortstack{1em}{(1) \\ Econ \\ Index \\ \vphantom{foo}} \qquad \qquad" "'   ///
			+ `" " \Shortstack{1em}{(2)\\ Finding \\ Job \\ \vphantom{foo}} " "' ///
			+ `" "\Shortstack{1em}{(3)\\ Contin. \\ studies \\ abroad}" "' ///
			+ `" "\Shortstack{1em}{(4) \\ Getting \\ asylum \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(5)\\ Becom. \\ Citizen \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(6)\\ Return \\ before \\ 5 yrs}" "' ///
			+ `" "\Shortstack{1em}{(7)\\ Getting \\ public \\ transf. }""' ///
			+ `" "\Shortstack{1em}{(8) \\ Host \\ country \\ attit.}" "' ///
			+ `"  "\Shortstack{1em}{(9)\\ Wage \\ abroad \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(10) \\  Cost of \\ living \\ abroad}" "' ///
			+ `" "\Shortstack{1em}{(11) \\ PCA \\ Econ \\ Index}" "' 


global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " in_favor_of_migration " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " asinhexp_liv_cost_winsor " ///
						+ " economic_index " 

						
						
						
						

	

eststo clear

gen x = treatment_status
gen inter = contact_eu

local counter = 0
foreach var in $economic_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using econbeliefs_coneu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Contact in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Contact in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Contact in the EU" ///
	1.inter "Contact in the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{12}{c}} \hline\hline") ///
	mtitles($economic_titles) 
	
drop x inter






eststo clear

gen x = treatment_status
gen inter = strong_tie_eu

local counter = 0
foreach var in $economic_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using econbeliefs_sconeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Strong tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Strong tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Strong tie in the EU" ///
	1.inter "Strong tie in the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{12}{c}} \hline\hline") ///
	mtitles($economic_titles) 
	
drop x inter




	

eststo clear

gen x = treatment_status
gen inter = weak_tie_eu

local counter = 0
foreach var in $economic_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using econbeliefs_wconeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Weak tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Weak tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Weak tie in the EU" ///
	1.inter "Weak tie in the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{12}{c}} \hline\hline") ///
	mtitles($economic_titles) 
	
drop x inter



	

eststo clear

gen x = treatment_status
gen inter = remittances_eu

local counter = 0
foreach var in $economic_outcomes {
		local counter = `counter' + 1

		local controls `demographics' `school_char' strata
		local individual "Yes"
		local school "Yes"		

		gen y = `var'
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg f1.y i.x##i.inter y  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg_`counter'
		
		
	
}

esttab reg* using econbeliefs_remeu.tex, replace 	keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Remittances from the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Remittances from the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Remittances from the EU" ///
	1.inter "Remittances from the EU" strata "Big school")   se substitute(\_ _) ///
	nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{12}{c}} \hline\hline") ///
	mtitles($economic_titles) 
	
drop x inter




* TRANSPORTATION


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
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.trans_debate i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.trans_video i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
			
		}
		
		if `i_est' == 3 {
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.ident_video i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
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
coeflabels(3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined"  strata "Big school")   se substitute(\_ _) ///
mgroups("Trans. Debate" "Trans. Video" "Ident. Video", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers







* TRANSPORTATION


gen inter = contact_eu

		

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
			qui reg f1.trans_debate i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.trans_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
			
		}
		
		if `i_est' == 3 {
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.ident_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
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

esttab reg* using transident_coneu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Contact in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Contact in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Contact in the EU" ///
	1.inter "Contact in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Trans. Debate" "Trans. Video" "Ident. Video", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter







* TRANSPORTATION


gen inter = weak_tie_eu

		

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
			qui reg f1.trans_debate i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.trans_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
			
		}
		
		if `i_est' == 3 {
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.ident_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
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

esttab reg* using transident_wconeu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Weak tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Weak tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Weak tie in the EU" ///
	1.inter "Weak tie in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Trans. Debate" "Trans. Video" "Ident. Video", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter






* TRANSPORTATION


gen inter = strong_tie_eu

		

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
			qui reg f1.trans_debate i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.trans_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
			
		}
		
		if `i_est' == 3 {
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.ident_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
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

esttab reg* using transident_sconeu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Strong tie in the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Strong tie in the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Strong tie in the EU" ///
	1.inter "Strong tie in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Trans. Debate" "Trans. Video" "Ident. Video", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter




* TRANSPORTATION


gen inter = remittances_eu

		

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
			qui reg f1.trans_debate i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.trans_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
			drop x
			
		}
		
		if `i_est' == 3 {
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'

			gen x = treatment_status
			qui reg f1.ident_video i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1, cluster(schoolid)
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

esttab reg* using transident_remeu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Remittances from the EU" 3.x#1.inter "\(T2\) - Econ \(*\) Remittances from the EU" 4.x#1.inter "\(T3\) - Combined \(*\) Remittances from the EU" ///
	1.inter "Remittances from the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Trans. Debate" "Trans. Video" "Ident. Video", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter








* ATTENTION


eststo clear

forval i_est = 1/2 {
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
			qui reg f1.riskinfo_attention i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.econinfo_attention i.x  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
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

esttab reg* using attention.tex, replace keep(4.x) ///
coeflabels(4.x "\(T3\) - Combined"  strata "Big school")   se substitute(\_ _) ///
mgroups("Risk Info Score " "Econ Info Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers





* ATTENTION


gen inter = contact_eu

eststo clear

forval i_est = 1/2 {
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
			qui reg f1.riskinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.econinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
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

esttab reg* using attention_coneu.tex, replace keep(4.x 4.x#1.inter 1.inter) ///
coeflabels(4.x "\(T3\) - Combined"  4.x#1.inter "\(T3\) - Combined \(*\) Contact in the EU" ///
	1.inter "Contact in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Risk Info Score " "Econ Info Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter



* ATTENTION


eststo clear
gen inter = strong_tie_eu

forval i_est = 1/2 {
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
			qui reg f1.riskinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.econinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
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

esttab reg* using attention_sconeu.tex, replace keep(4.x 4.x#1.inter 1.inter) ///
coeflabels(4.x "\(T3\) - Combined" 4.x#1.inter "\(T3\) - Combined \(*\) Strong Tie in the EU" ///
	1.inter "Strong Tie in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Risk Info Score " "Econ Info Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter


* ATTENTION


eststo clear
gen inter = weak_tie_eu


forval i_est = 1/2 {
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
			qui reg f1.riskinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.econinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
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

esttab reg* using attention_wconeu.tex, replace keep(4.x 4.x#1.inter 1.inter) ///
coeflabels(4.x "\(T3\) - Combined"  4.x#1.inter "\(T3\) - Combined \(*\) Weak Tie in the EU" ///
	1.inter "Weak Tie in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Risk Info Score " "Econ Info Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter

* ATTENTION


eststo clear
gen inter = remittances_eu


forval i_est = 1/2 {
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
			qui reg f1.riskinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			
			qui sum trans_debate if   source_info_guinea < 6
			local meandep = `r(mean)'
			
			gen x = treatment_status
			qui reg f1.econinfo_attention i.x##i.inter  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & attended_tr != 1 & treatment_status != 1, cluster(schoolid)
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

esttab reg* using attention_remeu.tex, replace keep(4.x 4.x#1.inter 1.inter) ///
coeflabels(4.x "\(T3\) - Combined" 4.x#1.inter "\(T3\) - Combined \(*\) Weak Tie in the EU" ///
	1.inter "Weak Tie in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("Risk Info Score " "Econ Info Score", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

drop inter


	

/*





*VISA INTENTIONS BY CONTACTS (restricted sample), mean

eststo clear


forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desvisa100
			local ycon desire
		}
		
		if `i_var' == 2 {
			gen y = planvisa100
			local ycon planning
		}
		
		if `i_var' == 3 {
			gen y = askedvisa100
			local ycon prepare
		}
		
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg y i.strong_tie_eu i.weak_tie_eu i.strong_tie_noeu i.weak_tie_noeu i.`ycon'  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using visa_intentions_contype.tex, replace keep(1.strong_tie_eu 1.weak_tie_eu 1.strong_tie_noeu 1.weak_tie_noeu 1.desire 1.planning 1.prepare) ///
	coeflabels(1.strong_tie_eu "Family ties or fianc\'e in the EU" 1.weak_tie_eu "Non-family contact in the EU" 1.strong_tie_noeu "Non-family contact abroad (excl. EU)" 1.weak_tie_noeu "Non-family contact abroad (excl. EU)" 1.desire "Wishing to migrate" 1.planning "Planning to migrate" 1.prepare "Preparing for migration")  se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intends to ask/asked visa at baseline} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Visa intention for \\  wishing to migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Visa intention for \\  planning to migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Visa asked for \\ preparing to migrate}}  \\  ")



*VISA INTENTIONS BY CONTACTS (restricted sample), mean

eststo clear


forval i_var = 1/3 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = desvisa100
			local ycon desire
		}
		
		if `i_var' == 2 {
			gen y = planvisa100
			local ycon planning
		}
		
		if `i_var' == 3 {
			gen y = askedvisa100
			local ycon prepare
		}
		
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		 reg y i.contact_eu i.contact_noeu i.`ycon' `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using visa_intentions.tex, replace keep(1.contact_eu 1.contact_noeu 1.desire 1.planning 1.prepare) ///
	coeflabels(1.contact_eu "Contacts in the EU" 1.contact_noeu "Contacts abroad (excl. EU)" 1.desire "Wishing to migrate" 1.planning "Planning to migrate" 1.prepare "Preparing for migration")  se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = intends to ask/asked visa at baseline} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Visa intention for \\  wishing to migrate}   }&\multicolumn{2}{c}{\Shortstack{1em}{Visa intention for \\  planning to migrate}}&\multicolumn{2}{c}{\Shortstack{1em}{Visa asked for \\ preparing to migrate}}  \\  ")


	


*BELIEFS BY CONTACTS (restricted sample), mean

eststo clear


forval i_var = 1/2 {
	forval i_con = 1/2 {

		if `i_var' == 1 {
			gen y = mrisk_index
		}
		
		if `i_var' == 2 {
			gen y = economic_index
		}
		
		
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"	
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char' strata
			local individual "Yes"
			local school "Yes"		
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		qui reg y i.contact_eu i.contact_noeu  `controls'  ///
			if time == 0 & attended_tr != . &  f2.source_info_guinea < 6, cluster(schoolid)
		drop y

		estadd local space " "
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_con'
		
		
	}
}

esttab reg* using beliefseu.tex, replace keep(1.contact_eu 1.contact_noeu) ///
	coeflabels(1.contact_eu "Contacts in the EU" 1.contact_noeu "Contacts abroad (excl. EU)")  se substitute(\_ _) ///
	nomtitles nonumbers ///
	stats(space individual school N meandep, fmt( s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = PCA aggregate of beliefs} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Risk \\  beliefs}   }&\multicolumn{2}{c}{\Shortstack{1em}{Econ \\  beliefs }} \\  ")


	

	



*MIGRATION BY CONTACTS, NO VISA OR AIRPLANE, NO ZEROS (restricted sample), mean

eststo clear


forval i_var = 1/2 {
	forval i_est = 1/2 {

		if `i_var' == 1 {
			gen y = migration_novisa100
			gen yalt = migration_visa100
		}
		
		if `i_var' == 2 {
			gen y = migration_noair100
			gen yalt = migration_air100
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.y i.x i.x#i.contact_eu i.contact_eu  strata  `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.y (i.x i.x#i.contact_eu = i.treatment_status i.treatment_status#i.contact_eu) ///
				i.contact_eu strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
			
		}
		
		lincom 2.x + 2.x#1.contact_eu
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.contact_eu
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.contact_eu
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		
		estadd local space " "
		
		local individual "Yes"
		local school "Yes"		
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_est'
		
		
	}
}

esttab reg* using tablenovisaaircont_nomig0.tex, replace keep(2.x 3.x 4.x  2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu 1.contact_eu) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.contact_eu "\(T1\) - Risk \(*\) Contacts in EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contacts in EU" 4.x#1.contact_eu "\(T3\) - Combined \(*\) Contacts in EU" ///
	2.x#1.inter#1.contact_eu "\(T1\) - Risk \(*\) Contacts in the EU \(*\) Contacts in the EU" 3.x#1.inter#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU \(*\) Contacts in the EU" 4.x#1.inter#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU  \(*\) Contacts in the EU" ///
	1.contact_eu "Contacts in the EU" 1.inter "Contacts in the EU" strata "Big school")  se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space N meandep, fmt(s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"   "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = potentially irreg. migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Regular status measured \\ by having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Regular status measured \\ by traveling w/ airplane}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}")


	




*MIGRATION BY CONTACTS, VISA OR AIRPLANE, NO ZEROS (restricted sample), mean

eststo clear


forval i_var = 1/2 {
	forval i_est = 1/2 {

		if `i_var' == 1 {
			gen y = migration_visa100
			gen yalt = migration_novisa100
		}
		
		if `i_var' == 2 {
			gen y = migration_air100
			gen yalt = migration_noair100
		}
		
		qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
		local meandep = `r(mean)'

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.y i.x i.x#i.contact_eu i.contact_eu  strata  `demographics' `school_char' ///
				if f2.source_info_guinea < 6  & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.y (i.x i.x#i.contact_eu = i.treatment_status i.treatment_status#i.contact_eu) ///
				i.contact_eu strata `demographics' `school_char' if f2.source_info_guinea < 6 & attended_tr != . & f2.yalt != 100, cluster(schoolid)
			drop y yalt x
			
		}
		
		lincom 2.x + 2.x#1.contact_eu
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.contact_eu
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.contact_eu
		local bdint = string(`r(p)', "%9.5f") 
		
		estadd local bdint = `"`bdint'"'
		
		
		estadd local space " "
		
		local individual "Yes"
		local school "Yes"		
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_var'_`i_est'
		
		
	}
}

esttab reg* using tablevisaaircont_nomig0.tex, replace keep(2.x 3.x 4.x  2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu 1.contact_eu) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.contact_eu "\(T1\) - Risk \(*\) Contacts in EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contacts in EU" 4.x#1.contact_eu "\(T3\) - Combined \(*\) Contacts in EU" ///
	2.x#1.inter#1.contact_eu "\(T1\) - Risk \(*\) Contacts in the EU \(*\) Contacts in the EU" 3.x#1.inter#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU \(*\) Contacts in the EU" 4.x#1.inter#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU  \(*\) Contacts in the EU" ///
	1.contact_eu "Contacts in the EU" 1.inter "Contacts in the EU" strata "Big school")  se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space N meandep, fmt(s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'   `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = regular migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Regular status measured \\ by having a visa}   }&\multicolumn{2}{c}{\Shortstack{1em}{Regular status measured \\ by traveling w/ airplane}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}")


	

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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	prehead("") posthead("  \\ \textbf{\textit{(b): Migration with visa}}  & & &  &  &  &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") ///
	nonumbers nomtitles
	
	
*MIGRATION WITHOUT VISA (restricted sample), NO MIGRATING AMONG ONES

eststo clear

qui sum migration_novisa100 if l2.treatment_status == 1  & f2.migration_visa != 1 &  source_info_guinea < 6
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
				if f2.source_info_guinea < 6  & attended_tr != . & f2.migration_visa != 1 , cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_novisa100 (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & f2.migration_visa != 1 , cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table4a_nomig0.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	posthead("\hline  \\ \textbf{\textit{(a): Migration without visa}}  & & &  &  &  &  \\ [1em]") prefoot("\hline") postfoot("\hline") ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV")  ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) 



*MIGRATION WITH VISA (restricted sample), NO MIGRATING AMONG ONES

eststo clear

qui sum migration_visa100 if l2.treatment_status == 1  & f2.migration_novisa != 1 &  source_info_guinea < 6
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
				if f2.source_info_guinea < 6  & attended_tr != . & f2.migration_novisa != 1 , cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_visa100 (i.x = i.treatment_status) ///
				strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & f2.migration_novisa != 1 , cluster(schoolid)
			drop x
		}
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table4b_nomig0.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	prehead("") posthead("  \\ \textbf{\textit{(b): Migration with visa}}  & & &  &  &  &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") ///
	nonumbers nomtitles
	
	

*MIGRATION WITH EXTERNALITIES (3-6km) (restricted sample)

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
			qui reg f2.migration_guinea100  i.x ratio2_0_3 ratio3_0_3 ratio4_0_3 ratio2_3_6 ratio3_3_6 ratio4_3_6 stud_0_3 stud_3_6  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i2.x#c.ratio2_0_3 i3.x#c.ratio3_0_3 i4.x#c.ratio4_0_3 i2.x#c.ratio2_3_6 i3.x#c.ratio3_3_6 i4.x#c.ratio4_3_6   ratio2_0_3 ratio3_0_3 ratio4_0_3 ratio2_3_6 ratio3_3_6 ratio4_3_6 stud_0_3 stud_3_6 strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		
		estadd local space " "	
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		

		
	}
}

esttab reg* using table_spillovers3_6.tex, replace keep(2.x 3.x 4.x 2.x#c.ratio2_0_3 3.x#c.ratio3_0_3 4.x#c.ratio4_0_3 2.x#c.ratio2_3_6 3.x#c.ratio3_3_6 4.x#c.ratio4_3_6   ratio2_0_3 ratio3_0_3 ratio4_0_3 ratio2_3_6 ratio3_3_6 ratio4_3_6 stud_0_3 stud_3_6) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#c.ratio2_0_3 "\(T1\) \(*\) \% students in \(T1\) w/in 0-3km" 3.x#c.ratio3_0_3 "\(T2\) \(*\) \% students in \(T2\) w/in 0-3km" 4.x#c.ratio4_0_3 "\(T3\) \(*\) \% students in \(T3\) w/in 0-3km"  2.x#c.ratio2_3_6 "\(T1\) \(*\) \% students in \(T1\) w/in 3-6km"  3.x#c.ratio3_3_6 "\(T2\) \(*\) \% students in \(T2\) w/in 3-6km" 4.x#c.ratio4_3_6 "\(T3\) \(*\) \% students in \(T3\) w/in 3-6km"  ratio2_0_3 "\% students in \(T1\) w/in 0-3km" ratio3_0_3 "\% students in \(T2\) w/in 0-3km" ratio4_0_3 "\% students in \(T3\) w/in 0-3km" ratio2_3_6 "\% students in \(T1\) w/in 3-6km" ratio3_3_6 "\% students in \(T2\) w/in 3-6km" ratio4_3_6 "\% students in \(T3\) w/in 3-6km" stud_0_3 "\# students w/in 0-3km" stud_3_6 "\# students w/in 3-6km" strata "Big school")   se substitute(\_ _) ///
	stats(space individual school N meandep, fmt(s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{6}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)} \\ ") nonumbers nomtitles

	



*MIGRATION WITH EXTERNALITIES (2-4km) (restricted sample)

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
			qui reg f2.migration_guinea100  i.x ratio2_0_2 ratio3_0_2 ratio4_0_2 ratio2_2_4 ratio3_2_4 ratio4_2_4 stud_0_2 stud_2_4  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i2.x#c.ratio2_0_2 i3.x#c.ratio3_0_2 i4.x#c.ratio4_0_2 i2.x#c.ratio2_2_4 i3.x#c.ratio3_2_4 i4.x#c.ratio4_2_4   ratio2_0_2 ratio3_0_2 ratio4_0_2 ratio2_2_4 ratio3_2_4 ratio4_2_4 stud_0_2 stud_2_4 strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		
		estadd local space " "	
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		

		
	}
}

esttab reg* using table_spillovers2_4.tex, replace keep(2.x 3.x 4.x 2.x#c.ratio2_0_2 3.x#c.ratio3_0_2 4.x#c.ratio4_0_2 2.x#c.ratio2_2_4 3.x#c.ratio3_2_4 4.x#c.ratio4_2_4   ratio2_0_2 ratio3_0_2 ratio4_0_2 ratio2_2_4 ratio3_2_4 ratio4_2_4 stud_0_2 stud_2_4) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#c.ratio2_0_2 "\(T1\) \(*\) \% students in \(T1\) w/in 0-2km" 3.x#c.ratio3_0_2 "\(T2\) \(*\) \% students in \(T2\) w/in 0-2km" 4.x#c.ratio4_0_2 "\(T3\) \(*\) \% students in \(T3\) w/in 0-2km"  2.x#c.ratio2_2_4 "\(T1\) \(*\) \% students in \(T1\) w/in 2-4km"  3.x#c.ratio3_2_4 "\(T2\) \(*\) \% students in \(T2\) w/in 2-4km" 4.x#c.ratio4_2_4 "\(T3\) \(*\) \% students in \(T3\) w/in 2-4km"  ratio2_0_2 "\% students in \(T1\) w/in 0-2km" ratio3_0_2 "\% students in \(T2\) w/in 0-2km" ratio4_0_2 "\% students in \(T3\) w/in 0-2km" ratio2_2_4 "\% students in \(T1\) w/in 2-4km" ratio3_2_4 "\% students in \(T2\) w/in 2-4km" ratio4_2_4 "\% students in \(T3\) w/in 2-4km" stud_0_2 "\# students w/in 0-2km" stud_2_4 "\# students w/in 2-4km" strata "Big school")   se substitute(\_ _) ///
	stats(space individual school N meandep, fmt(s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{6}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)} \\ ") nonumbers nomtitles

	





*MIGRATION WITH EXTERNALITIES (2.5-5km) (restricted sample)

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
			qui reg f2.migration_guinea100  i.x ratio2_0_25 ratio3_0_25 ratio4_0_25 ratio2_25_5 ratio3_25_5 ratio4_25_5 stud_0_25 stud_25_5  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i2.x#c.ratio2_0_25 i3.x#c.ratio3_0_25 i4.x#c.ratio4_0_25 i2.x#c.ratio2_25_5 i3.x#c.ratio3_25_5 i4.x#c.ratio4_25_5   ratio2_0_25 ratio3_0_25 ratio4_0_25 ratio2_25_5 ratio3_25_5 ratio4_25_5 stud_0_25 stud_25_5 strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		
		estadd local space " "	
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		

		
	}
}

esttab reg* using table_spillovers25_5.tex, replace keep(2.x 3.x 4.x 2.x#c.ratio2_0_25 3.x#c.ratio3_0_25 4.x#c.ratio4_0_25 2.x#c.ratio2_25_5 3.x#c.ratio3_25_5 4.x#c.ratio4_25_5   ratio2_0_25 ratio3_0_25 ratio4_0_25 ratio2_25_5 ratio3_25_5 ratio4_25_5 stud_0_25 stud_25_5) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#c.ratio2_0_25 "\(T1\) \(*\) \% students in \(T1\) w/in 0-2.5km" 3.x#c.ratio3_0_25 "\(T2\) \(*\) \% students in \(T2\) w/in 0-2.5km" 4.x#c.ratio4_0_25 "\(T3\) \(*\) \% students in \(T3\) w/in 0-2.5km"  2.x#c.ratio2_25_5 "\(T1\) \(*\) \% students in \(T1\) w/in 2.5-5km"  3.x#c.ratio3_25_5 "\(T2\) \(*\) \% students in \(T2\) w/in 2.5-5km" 4.x#c.ratio4_25_5 "\(T3\) \(*\) \% students in \(T3\) w/in 2.5-5km"  ratio2_0_25 "\% students in \(T2\) w/in 0-2.5km" ratio3_0_25 "\% students in \(T3\) w/in 0-2.5km" ratio4_0_25 "\% students in \(T3\) w/in 0-2.5km" ratio2_25_5 "\% students in \(T1\) w/in 2.5-5km" ratio3_25_5 "\% students in \(T2\) w/in 2.5-5km" ratio4_25_5 "\% students in \(T3\) w/in 2.5-5km" stud_0_25 "\# students w/in 0-2.5km" stud_25_5 "\# students w/in 2.5-5km" strata "Big school")   se substitute(\_ _) ///
	stats(space individual school N meandep, fmt(s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{6}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)} \\ ") nonumbers nomtitles

	
	

*MIGRATION WITH EXTERNALITIES (5-10km) (restricted sample)

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
			qui reg f2.migration_guinea100  i.x ratio2_0_5 ratio3_0_5 ratio4_0_5 ratio2_5_10 ratio3_5_10 ratio4_5_10 stud_0_5 stud_5_10  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i2.x#c.ratio2_0_5 i3.x#c.ratio3_0_5 i4.x#c.ratio4_0_5 i2.x#c.ratio2_5_10 i3.x#c.ratio3_5_10 i4.x#c.ratio4_5_10   ratio2_0_5 ratio3_0_5 ratio4_0_5 ratio2_5_10 ratio3_5_10 ratio4_5_10 stud_0_5 stud_5_10 strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		

		
	}
}

esttab reg* using table_spillovers5_10.tex, replace keep(2.x 3.x 4.x 2.x#c.ratio2_0_5 3.x#c.ratio3_0_5 4.x#c.ratio4_0_5 2.x#c.ratio2_5_10 3.x#c.ratio3_5_10 4.x#c.ratio4_5_10   ratio2_0_5 ratio3_0_5 ratio4_0_5 ratio2_5_10 ratio3_5_10 ratio4_5_10 stud_0_5 stud_5_10) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#c.ratio2_0_5 "\(T1\) \(*\) \% students in \(T1\) w/in 0-5km" 3.x#c.ratio3_0_5 "\(T2\) \(*\) \% students in \(T2\) w/in 0-5km" 4.x#c.ratio4_0_5 "\(T3\) \(*\) \% students in \(T3\) w/in 0-5km"  2.x#c.ratio2_5_10 "\(T1\) \(*\) \% students in \(T1\) w/in 5-10km"  3.x#c.ratio3_5_10 "\(T2\) \(*\) \% students in \(T2\) w/in 5-10km" 4.x#c.ratio4_5_10 "\(T3\) \(*\) \% students in \(T3\) w/in 5-10km"  ratio2_0_5 "\% students in \(T1\) w/in 0-5km" ratio3_0_5 "\% students in \(T2\) w/in 0-5km" ratio4_0_5 "\% students in \(T3\) w/in 0-5km" ratio2_5_10 "\% students in \(T1\) w/in 5-10km" ratio3_5_10 "\% students in \(T2\) w/in 5-10km" ratio4_5_10 "\% students in \(T3\) w/in 5-10km" stud_0_5 "\# students w/in 0-5km" stud_5_10 "\# students w/in 5-10km" strata "Big school")   se substitute(\_ _) ///
	stats(space individual school N meandep, fmt(s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{6}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)} \\ ") nonumbers nomtitles

	

*MIGRATION WITH EXTERNALITIES (7.5-15km) (restricted sample)

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
			qui reg f2.migration_guinea100  i.x ratio2_0_75 ratio3_0_75 ratio4_0_75 ratio2_75_15 ratio3_75_15 ratio4_75_15 stud_0_75 stud_75_15  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i2.x#c.ratio2_0_75 i3.x#c.ratio3_0_75 i4.x#c.ratio4_0_75 i2.x#c.ratio2_75_15 i3.x#c.ratio3_75_15 i4.x#c.ratio4_75_15   ratio2_0_75 ratio3_0_75 ratio4_0_75 ratio2_75_15 ratio3_75_15 ratio4_75_15 stud_0_75 stud_75_15 strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
		
		estadd local space " "
			
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		

		
	}
}

esttab reg* using table_spillovers75_15.tex, replace keep(2.x 3.x 4.x 2.x#c.ratio2_0_75 3.x#c.ratio3_0_75 4.x#c.ratio4_0_75 2.x#c.ratio2_75_15 3.x#c.ratio3_75_15 4.x#c.ratio4_75_15   ratio2_0_75 ratio3_0_75 ratio4_0_75 ratio2_75_15 ratio3_75_15 ratio4_75_15 stud_0_75 stud_75_15) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#c.ratio2_0_75 "\(T1\) \(*\) \% students in \(T1\) w/in 0-7.5km" 3.x#c.ratio3_0_75 "\(T2\) \(*\) \% students in \(T2\) w/in 0-7.5km" 4.x#c.ratio4_0_75 "\(T3\) \(*\) \% students in \(T3\) w/in 0-7.5km"  2.x#c.ratio2_75_15 "\(T1\) \(*\) \% students in \(T1\) w/in 7.5-15km"  3.x#c.ratio3_75_15 "\(T2\) \(*\) \% students in \(T2\) w/in 7.5-15km" 4.x#c.ratio4_75_15 "\(T3\) \(*\) \% students in \(T3\) w/in 7.5-15km"  ratio2_0_75 "\% students in \(T1\) w/in 0-7.5km" ratio3_0_75 "\% students in \(T2\) w/in 0-7.5km" ratio4_0_75 "\% students in \(T3\) w/in 0-7.5km" ratio2_75_15 "\% students in \(T1\) w/in 7.5-15km" ratio3_75_15 "\% students in \(T2\) w/in 7.5-15km" ratio4_75_15 "\% students in \(T3\) w/in 7.5-15km" stud_0_75 "\# students w/in 0-7.5km" stud_75_15 "\# students w/in 7.5-15km" strata "Big school")   se substitute(\_ _) ///
	stats(space individual school N meandep, fmt(s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{6}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)} \\ ") nonumbers nomtitles
	



	
	

*MIGRATION BY REASONS TO MIGRATE (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/3 {
	forval i_est = 1/2 {

		if `i_inter' == 1 {
			gen inter = migmot_studies
			replace inter = 0 if desire == 0
		}
		
		if `i_inter' == 2 {
			gen inter = migmot_econ
			replace inter = 0 if desire == 0
		}
		
		if `i_inter' == 3 {
			gen inter = migmot_reunif
			replace inter = 0 if desire == 0
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

esttab reg* using tablemigmot.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Reason" 3.x#1.inter "\(T2\) - Econ \(*\) Reason" 4.x#1.inter "\(T3\) - Combined \(*\) Reason" ///
	1.inter "Reason" strata "Big school")   se substitute(\_ _) ///
	nomtitles ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Low SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Low SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Low SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Continuing \\ studies}   }&\multicolumn{2}{c}{\Shortstack{1em}{Economic \\ reasons}}&\multicolumn{2}{c}{\Shortstack{1em}{Family \\ reunification}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5} \cmidrule(lr){6-7}") nonumbers


	
	

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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Low SES" 3.x#1.inter "\(T2\) - Econ \(*\) Low SES" 4.x#1.inter "\(T3\) - Combined \(*\) Low SES" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) High SES" 3.x#1.inter "\(T2\) - Econ \(*\) SES" 4.x#1.inter "\(T3\) - Combined \(*\) SES" ///
	1.inter "High SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) High SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) High SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) High SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Socioeconomic status \\ measured by durables index}   }&\multicolumn{2}{c}{\Shortstack{1em}{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers
	



*MIGRATION BY DURABLES OR BANK ACCOUNT OWNERSHIP (restricted sample), mean

eststo clear

gen durablesbank = durablesavg*bank_account

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {

		if `i_inter' == 1 {
			gen inter = durablesavg == 0 if !missing(durablesavg)
		}
		
		if `i_inter' == 2 {
			gen inter = durablesbank == 0 if !missing(durablesbank)
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

esttab reg* using table5durbank_mean.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Low SES" 3.x#1.inter "\(T2\) - Econ \(*\) Low SES" 4.x#1.inter "\(T3\) - Combined \(*\) Low SES" ///
	1.inter "Low SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Low SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Low SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Low SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{SES measured by \\ durables index}   }&\multicolumn{2}{c}{\Shortstack{1em}{SES measured by \\ durables \(+\) bank acc.}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers


	
*MIGRATION BY DURABLES OR BANK ACCOUNT OWNERSHIP (restricted sample), mean

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {

		if `i_inter' == 1 {
			gen inter = durablesavg == 0 if !missing(durablesavg)
		}
		
		if `i_inter' == 2 {
			gen inter = bank_account == 0 if !missing(bank_account)
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Low SES" 3.x#1.inter "\(T2\) - Econ \(*\) Low SES" 4.x#1.inter "\(T3\) - Combined \(*\) Low SES" ///
	1.inter "Low SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV") ///
	stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Low SES = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Low SES = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Low SES = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Socioeconomic status \\ measured by durables index}   }&\multicolumn{2}{c}{\Shortstack{1em}{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}") nonumbers


	


*MIGRATION BY DURABLES OR BANK ACCOUNT OWNERSHIP AND CONTACTS IN EU (restricted sample)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_inter = 1/2 {
	forval i_con = 1/3 {

		if `i_inter' == 1 {
			gen inter = durablesavg == 0
		}
		
		if `i_inter' == 2 {
			gen inter = bank_account == 0
		}
		
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
		qui reg f2.migration_guinea100 i.x##i.inter##i.contact_eu  strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x

		
		estadd local space " "
			
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_inter'
		
		drop inter

		
	}
}

esttab reg* using tablecontdurables_mean.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu  2.x#1.inter#1.contact_eu 3.x#1.inter#1.contact_eu 4.x#1.inter#1.contact_eu 1.contact_eu) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Low SES" 3.x#1.inter "\(T2\) - Econ \(*\) Low SES" 4.x#1.inter "\(T3\) - Combined \(*\) Low SES" ///
	2.x#1.contact_eu "\(T1\) - Risk \(*\) Contact in EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contact in EU" 4.x#1.contact_eu "\(T3\) - Combined \(*\) Contact in EU" ///
	2.x#1.inter#1.contact_eu "\(T1\) - Risk \(*\) Low SES \(*\) Contact in EU" 3.x#1.inter#1.contact_eu "\(T2\) - Econ \(*\) Low SES \(*\) Contact in EU" 4.x#1.inter#1.contact_eu "\(T3\) - Combined \(*\) Low SES  \(*\) Contact in EU" ///
	1.contact_eu "Contact in EU" 1.inter "Low SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
	stats(space individual school N meandep, fmt(s s s 0 3) ///
	labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{3}{c}{   \Shortstack{1em}{Socioeconomic status \\ measured by durables index}   }&\multicolumn{3}{c}{\Shortstack{1em}{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-4} \cmidrule(lr){5-7}") nonumbers
	
	



*MIGRATION BY DURABLES OR BANK ACCOUNT OWNERSHIP AND CONTACTS IN EU (restricted sample) (HIGH SES)

eststo clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_inter = 1/2 {
	forval i_con = 1/3 {

		if `i_inter' == 1 {
			gen inter = durablesavg == 1
		}
		
		if `i_inter' == 2 {
			gen inter = bank_account == 1
		}
		
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
		qui reg f2.migration_guinea100 i.x##i.inter##i.contact_eu  strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x

		
		estadd local space " "
			
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_inter'
		
		drop inter

		
	}
}

esttab reg* using tablecontdurableshighses_mean.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu 2.x#1.inter#1.contact_eu 3.x#1.inter#1.contact_eu 4.x#1.inter#1.contact_eu 1.contact_eu) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) High SES" 3.x#1.inter "\(T2\) - Econ \(*\) High SES" 4.x#1.inter "\(T3\) - Combined \(*\) High SES" ///
	2.x#1.contact_eu "\(T1\) - Risk \(*\) Contact in EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contact in EU" 4.x#1.contact_eu "\(T3\) - Combined \(*\) Contact in EU" ///
	2.x#1.inter#1.contact_eu "\(T1\) - Risk \(*\) High SES \(*\) Contact in EU" 3.x#1.inter#1.contact_eu "\(T2\) - Econ \(*\) High SES \(*\) Contact in EU" 4.x#1.inter#1.contact_eu "\(T3\) - Combined \(*\) High SES  \(*\) Contact in EU" ///
	1.contact_eu "Contact in EU" 1.inter "High SES" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
	stats(space individual school N meandep, fmt(s s s 0 3) ///
	labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{3}{c}{   \Shortstack{1em}{Socioeconomic status \\ measured by durables index}   }&\multicolumn{3}{c}{\Shortstack{1em}{Socioeconomic status \\ measured by owns bank acc.}}  \\  \cmidrule(lr){2-4} \cmidrule(lr){5-7}") nonumbers






*MIGRATION BY DURABLES (restricted sample)

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
			qui reg f2.migration_guinea100 i.x i.x#ib1.durablesavg ib1.durablesavg strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#ib1.durablesavg = i.treatment_status i.treatment_status#ib1.durablesavg) ///
				ib1.durablesavg strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#0.durablesavg
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#0.durablesavg
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#0.durablesavg
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

esttab reg* using table5_onlydur.tex, replace  keep(2.x 3.x 4.x 2.x#0.durablesavg 3.x#0.durablesavg 4.x#0.durablesavg 0.durablesavg) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#0.durablesavg "\(T1\) - Risk \(*\) Low durables" 3.x#0.durablesavg "\(T2\) - Econ \(*\) Low durables" 4.x#0.durablesavg "\(T3\) - Combined \(*\) Low durables" ///
	0.durablesavg "Low durables" strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Low durables = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Low durables = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Low durables = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")
	
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) Impatient" 3.x#1.inter "\(T2\) - Econ \(*\) Impatient" 4.x#1.inter "\(T3\) - Combined \(*\) Impatient" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Impatient = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Impatient = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Impatient = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

*/




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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) Uses internet daily" 3.x#1.inter "\(T2\) - Econ \(*\) Uses internet daily" 4.x#1.inter "\(T3\) - Combined \(*\) Uses internet daily" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) Has a job" 3.x#1.inter "\(T2\) - Econ \(*\) Has a job" 4.x#1.inter "\(T3\) - Combined \(*\) Has a job" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Has a job = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Has a job = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Has a job = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers




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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) Contact Over-reporting" 3.x#1.inter "\(T2\) - Econ \(*\) Contact Over-reporting" 4.x#1.inter "\(T3\) - Combined \(*\) Contact Over-reporting" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) Contact Under-reporting" 3.x#1.inter "\(T2\) - Econ \(*\) Contact Under-reporting" 4.x#1.inter "\(T3\) - Combined \(*\) Contact Under-reporting" ///
1.inter "Impatient" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contact Under-reporting = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contact Under-reporting = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contact Under-reporting = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers





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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) Impatient" 3.x#1.inter "\(T2\) - Econ \(*\) Impatient" 4.x#1.inter "\(T3\) - Combined \(*\) Impatient" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) Risk-loving" 3.x#1.inter "\(T2\) - Econ \(*\) Risk-loving" 4.x#1.inter "\(T3\) - Combined \(*\) Risk-loving" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ avg." 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ avg." 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ avg." ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ avg." 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ avg." 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ avg." ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ avg." 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ avg." 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ avg." ///
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
		
		
		gen inter = contact_eu
		

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

esttab reg* using tablecontacts_any_eu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "\# contacts in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
		
		
		gen inter = contact_eu
		

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter i.x#c.mrisk_index c.mrisk_index  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter i.x#c.mrisk_index = i.treatment_status i.treatment_status#i.inter i.treatment_status#c.mrisk_index) ///
				i.inter  c.mrisk_index  strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
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

esttab reg* using tablecontacts_any_eu_conrisk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter 2.x#c.mrisk_index 3.x#c.mrisk_index 4.x#c.mrisk_index mrisk_index) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
mrisk_index "Risk PCA" ///
2.x#c.mrisk_index "\(T1\) - Risk \(*\)  Risk PCA" 3.x#c.mrisk_index "\(T2\) - Econ \(*\)  Risk PCA" 4.x#c.mrisk_index "\(T3\) - Combined \(*\)  Risk PCA" ///
1.inter "\# contacts in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

est sto clear





* TYPE OF CONTACTS EU




gen n_contacts_eu = contact_eu_1 + contact_eu_2
replace n_contacts_eu = contact_eu_1 if !missing(contact_eu_1) & missing(contact_eu_2)
replace n_contacts_eu = contact_eu_2 if missing(contact_eu_1) & !missing(contact_eu_2)
gen n_contacts_eu1 = n_contacts_eu == 1 if n_contacts_eu != .
gen n_contacts_eu2 = n_contacts_eu == 2 if n_contacts_eu != .


* NUMBER OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.n_contacts_eu1 i.x#i.n_contacts_eu2 i.n_contacts_eu1 i.n_contacts_eu2 strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.n_contacts_eu1 i.x#i.n_contacts_eu2 = i.treatment_status i.treatment_status#i.n_contacts_eu1 i.treatment_status#i.n_contacts_eu2) i.n_contacts_eu1 i.n_contacts_eu2 strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		

		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		
	}
}


esttab reg* using tablecontacts_coneun.tex, replace keep(2.x 3.x 4.x 2.x#1.n_contacts_eu1 3.x#1.n_contacts_eu1 4.x#1.n_contacts_eu1 1.n_contacts_eu1 2.x#1.n_contacts_eu2 3.x#1.n_contacts_eu2 4.x#1.n_contacts_eu2 1.n_contacts_eu2) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.n_contacts_eu1 "\(T1\) - Risk \(*\)  1 contact in the EU" 3.x#1.n_contacts_eu1 "\(T2\) - Econ \(*\)  1 contact in the EU" 4.x#1.n_contacts_eu1 "\(T3\) - Combined \(*\)  1 contact in the EU" ///
1.n_contacts_eu1 "1 contact in the EU"   ///
2.x#1.n_contacts_eu2 "\(T1\) - Risk \(*\)  2 contacts in the EU" 3.x#1.n_contacts_eu2 "\(T2\) - Econ \(*\)  2 contacts in the EU" 4.x#1.n_contacts_eu2 "\(T3\) - Combined \(*\)  2 contacts in the EU" ///
1.n_contacts_eu2 "2 contacts in the EU"  strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space individual school N meandep, fmt( s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" )  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers






* TYPE OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = occinc_dk_eu
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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


esttab reg* using tablecontacts_occincdk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Unkn. occupation or income (EU contacts)" 3.x#1.inter "\(T2\) - Econ \(*\)  Unkn. occupation or income (EU contacts)" 4.x#1.inter "\(T3\) - Combined \(*\)  Unkn. occupation or income (EU contacts)" ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Unkn. occupation or income (EU contacts) = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Unkn. occupation or income (EU contacts) = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Unkn. occupation or income (EU contacts) = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers









* TYPE OF CONTACTS ALL VS EU
est sto clear

gen y = daily_contact_eu

qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}


		gen inter = remittances_dk_eu == 0
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y y i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y y (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
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
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}

drop y


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_daily_contact_eu_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}  & ITT & ITT & ITT & IV & IV & IV \\ ") nonumbers



* TYPE OF CONTACTS ALL VS EU
est sto clear

gen y = weekly_contact_eu

qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}


		gen inter = remittances_dk_eu == 0
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y y i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y y (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
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
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}

drop y


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_weekly_contact_eu_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}  & ITT & ITT & ITT & IV & IV & IV \\ ") nonumbers




* TYPE OF CONTACTS ALL VS EU
est sto clear

gen y = monthly_contact_eu

qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}


		gen inter = remittances_dk_eu == 0
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y y i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y y (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
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
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}

drop y


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_monthly_contact_eu_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}  & ITT & ITT & ITT & IV & IV & IV \\ ") nonumbers



* TYPE OF CONTACTS ALL VS EU
est sto clear

gen y = discuss_econ_contact_eu

qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}


		gen inter = remittances_dk_eu == 0
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y y i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y y (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
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
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}

drop y


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_econ_contact_eu_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}  & ITT & ITT & ITT & IV & IV & IV \\ ") nonumbers







* TYPE OF CONTACTS ALL VS EU
est sto clear

gen y = discuss_wage_contact_eu

qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}


		gen inter = remittances_dk_eu == 0
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y y i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			 ivreg2 f.y y (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
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
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}

drop y


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_wage_contact_eu_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}  & ITT & ITT & ITT & IV & IV & IV \\ ") nonumbers




* TYPE OF CONTACTS ALL VS EU
est sto clear

gen y = discuss_job_contact_eu

qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}


		gen inter = remittances_dk_eu == 0
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y y i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y y (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
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
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}

drop y


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_job_contact_eu_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}  & ITT & ITT & ITT & IV & IV & IV \\ ") nonumbers



* TYPE OF CONTACTS ALL VS EU
est sto clear

gen y = discuss_fins_contact_eu

qui sum y if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}


		gen inter = remittances_dk_eu == 0
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y y i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y y (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & contact_eu == 1, cluster(schoolid)
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
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}

drop y


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_fins_contact_eu_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}  & ITT & ITT & ITT & IV & IV & IV \\ ") nonumbers






stop
* TYPE OF CONTACTS ALL VS EU
est sto clear

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'

forval i_est = 1/2 {
	forval i_con = 1/3 {

							
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
			local individual "Yes"
			local school "No"
		}
		
		if `i_con' == 3 {
			local controls `demographics' `school_char'
			local individual "Yes"
			local school "Yes"
		}

		if `i_est' == 1 {
			gen inter = remittances_dk_eu == 1 & contact_eu == 1 if !missing(remittances_dk_eu) & !missing(contact_eu)
		}
		
		if `i_est' == 2 {
			gen inter = remittances_dk_eu == 0 & contact_eu == 1 if !missing(remittances_dk_eu) & !missing(contact_eu)
		}
		
		gen x = treatment_status
		qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
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
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		
		drop inter

		
	}
}


esttab reg1_1 reg1_2 reg1_3 reg2_1 reg2_2 reg2_3 using tablecontacts_remeudk.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU " 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU " 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU " ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}     &\multicolumn{3}{c}{\Shortstack{1em}{Contacts w/ remittance \\ frequency not known}}&\multicolumn{3}{c}{\Shortstack{1em}{Contacts w/ remittance  \\ frequency known}}\\") nonumbers




* TYPE OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = remittances_dk_q_eu
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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


esttab reg* using tablecontacts_remeudk_q.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Unkn. remittance amount (EU contacts)" 3.x#1.inter "\(T2\) - Econ \(*\)  Unkn. remittance amount (EU contacts)" 4.x#1.inter "\(T3\) - Combined \(*\)  Unkn. remittance amount (EU contacts)" ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Unkn. remittance amount (EU contacts) = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Unkn. remittance amount (EU contacts) = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Unkn. remittance amount (EU contacts) = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers







* TYPE OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = contact_eu
		gen interaux = remittances_dk_eu
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter i.x#i.interaux i.interaux strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter i.x#i.interaux = i.treatment_status i.treatment_status#i.inter i.treatment_status#i.interaux) i.inter i.interaux strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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
		
		drop inter*

		
	}
}


esttab reg* using tablecontacts_remeudk_int.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter 2.x#1.interaux 3.x#1.interaux 4.x#1.interaux 1.interaux) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.interaux "\(T1\) - Risk \(*\)  Unkn. remittance frequency (EU contacts)" 3.x#1.interaux "\(T2\) - Econ \(*\)  Unkn. remittance frequency (EU contacts)" 4.x#1.interaux "\(T3\) - Combined \(*\)  Unkn. remittance frequency (EU contacts)" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.interaux "Unkn. remittance frequency (EU contacts)" 1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers







* TYPE OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = contact_eu
		gen interaux = remittances_dk_q_eu
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter i.x#i.interaux i.interaux strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter i.x#i.interaux = i.treatment_status i.treatment_status#i.inter i.treatment_status#i.interaux) i.inter i.interaux strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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
		
		drop inter*

		
	}
}


esttab reg* using tablecontacts_remeudk_q_int.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter 2.x#1.interaux 3.x#1.interaux 4.x#1.interaux 1.interaux) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.interaux "\(T1\) - Risk \(*\)  Unkn. remittance frequency (EU contacts)" 3.x#1.interaux "\(T2\) - Econ \(*\)  Unkn. remittance frequency (EU contacts)" 4.x#1.interaux "\(T3\) - Combined \(*\)  Unkn. remittance frequency (EU contacts)" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.interaux "Unkn. remittance frequency (EU contacts)" 1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers





* TYPE OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = contact_eu
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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


esttab reg* using tablecontacts_coneu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers







preserve

gen desire_base = desire if time == 0
replace desire_base = l.desire if time == 1
replace desire_base = l2.desire if time == 2
keep if desire_base == 0

* TYPE OF CONTACTS ALL VS EU (PEOPLE NOT WISHING TO MIGRATE)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = contact_eu
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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


esttab reg* using tablecontacts_coneu_wishing0.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers

restore


preserve

* TYPE OF CONTACTS ALL VS EU (PEOPLE WISHING TO MIGRATE)

gen desire_base = desire if time == 0
replace desire_base = l.desire if time == 1
replace desire_base = l2.desire if time == 2
keep if desire_base == 1

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_est = 1/2 {
	forval i_con = 1/3 {
		
		gen inter = contact_eu
					
		if `i_con' == 1 {
			local controls
			local individual "No"
			local school "No"
		}
		
		if `i_con' == 2 {
			local controls `demographics'
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
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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


esttab reg* using tablecontacts_coneu_wishing1.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "Contacts in the EU" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\   \cmidrule(lr){2-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{IV}\\") nonumbers

restore








est sto clear




* TYPE OF CONTACTS ALL VS EU

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {
		
		if `i_inter' == 1 {
			gen inter = contacts_abroad
		}
		
		if `i_inter' == 2 {
			gen inter = contact_eu
		}

		
		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
		
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter = i.treatment_status i.treatment_status#i.inter) i.inter strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
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
		
		eststo reg`i_inter'_`i_est'
		
		drop inter

		
	}
}


esttab reg* using tablecontacts_alleu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts abroad" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts abroad" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts abroad" ///
1.inter "Contacts abroad" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space brint beint bdint space N meandep, fmt(s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"    "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Contacts abroad = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Contacts abroad = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts abroad = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{All contacts \\ abroad}   }&\multicolumn{2}{c}{\Shortstack{1em}{Only contacts \\ in the EU}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}           &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}\\") nonumbers


/*

est sto clear

* TYPE OF CONTACTS

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_est = 1/2 {
		
		if `i_inter' == 1 {
			gen inter1 = strong_tie
			gen inter2 = weak_tie
		}
		
		if `i_inter' == 2 {
			gen inter1 = strong_tie_eu
			gen inter2 = weak_tie_eu
		}
		
		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
		
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.inter1 i.x#i.inter2 i.inter2 strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter1 i.x#i.inter2 = i.treatment_status i.treatment_status#i.inter1 i.treatment_status#i.inter2) i.inter1 i.inter2 strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_inter'_`i_est'
		
		drop inter1 inter2

		
	}
}


esttab reg* using tablecontacts_type.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 1.inter1 1.inter2) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Family contacts abroad" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Family contacts abroad" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Family contacts abroad" ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Other contacts abroad" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Other contacts abroad" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Other contacts abroad" ///
1.inter1 "Family contacts abroad" 1.inter2 "Other contacts abroad" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space individual school N meandep, fmt(s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{4}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{All contacts \\ abroad}   }&\multicolumn{2}{c}{\Shortstack{1em}{Only contacts \\ in the EU}}  \\  \cmidrule(lr){2-3} \cmidrule(lr){4-5}           &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{IV}\\") nonumbers


* TYPE OF CONTACTS (TRIPLE)

qui sum migration_guinea100 if l2.treatment_status == 1  &  source_info_guinea < 6
local meandep = `r(mean)'
		
forval i_inter = 1/2 {
	forval i_con = 1/3 {
		
		if `i_inter' == 1 {
			gen inter1 = strong_tie
			gen inter2 = weak_tie
		}
		
		if `i_inter' == 2 {
			gen inter1 = strong_tie_eu
			gen inter2 = weak_tie_eu
		}
		
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
		qui reg f2.migration_guinea100 i.x##i.inter1##i.inter2   strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x
		
		
	
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_inter'_`i_con'
		
		drop inter1 inter2

		
	}
}


esttab reg* using tablecontacts_typetriple.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 2.x#1.inter1#1.inter2 3.x#1.inter1#1.inter2 4.x#1.inter1#1.inter2 1.inter1 1.inter2 1.inter1#1.inter2) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Strong ties abroad" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Strong ties abroad" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Strong ties abroad" ///
2.x#1.inter1#1.inter2 "\(T1\) - Risk \(*\)  Strong ties abroad \(*\)   Weak ties abroad" 3.x#1.inter1#1.inter2 "\(T2\) - Econ \(*\)  Strong ties abroad \(*\)  Weak ties abroad" 4.x#1.inter1#1.inter2 "\(T3\) - Combined \(*\)  Strong ties abroad \(*\)  Weak ties abroad" ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Weak ties abroad" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Weak ties abroad" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Weak ties abroad" ///
1.inter1 "Having strong ties abroad" 1.inter2 "Having weak ties abroad" 1.inter1#1.inter2 "Strong ties abroad \(*\) Weak ties abroad" strata "Big school")   se substitute(\_ _) ///
nomtitles stats(space individual school N meandep, fmt(s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular}") 	prehead("\begin{tabular}{l*{7}{c}} \hline\hline  &\multicolumn{6}{c}{y = migration from Guinea} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ \cmidrule(lr){2-7} & \multicolumn{3}{c}{   \Shortstack{1em}{All contacts \\ abroad}   }&\multicolumn{3}{c}{\Shortstack{1em}{Only contacts \\ in the EU}}  \\  \cmidrule(lr){2-4} \cmidrule(lr){5-7}         &\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}&\multicolumn{1}{c}{ITT}\\") nonumbers






* ANY CONTACTS IN ITA FRA SPA OR EU

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
		
		
		gen inter1 = contact_ifs
		gen inter2 = contact_eunoifs

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.inter1 i.x#i.inter2 i.inter2  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter1 i.x#i.inter2 = i.treatment_status i.treatment_status#i.inter1 i.treatment_status#i.inter2) ///
				i.inter1 i.inter2 strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
				
		lincom 2.x + 2.x#1.inter2
		local brinttwo = string(`r(p)', "%9.5f") 
		
		estadd local brinttwo = `"`brinttwo'"'
		
		lincom 3.x + 3.x#1.inter2
		local beinttwo = string(`r(p)', "%9.5f") 
		
		estadd local beinttwo = `"`beinttwo'"'
		
		lincom 4.x + 4.x#1.inter2
		local bdinttwo = string(`r(p)', "%9.5f") 
		
		estadd local bdinttwo = `"`bdinttwo'"'
		
		lincom 2.x + 2.x#1.inter1
		local brintone = string(`r(p)', "%9.5f") 
		
		estadd local brintone = `"`brintone'"'
		
		lincom 3.x + 3.x#1.inter1
		local beintone = string(`r(p)', "%9.5f") 
		
		estadd local beintone = `"`beintone'"'
		
		lincom 4.x + 4.x#1.inter1
		local bdintone = string(`r(p)', "%9.5f") 
		
		estadd local bdintone = `"`bdintone'"'

		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter1 inter2

		
	}
}


esttab reg* using tablecontacts_any_euifs.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 1.inter1 1.inter2) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Contacts in ITA, FRA or SPA" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Contacts in ITA, FRA or SPA" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Contacts in ITA, FRA or SPA" ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Contacts in other EU" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Contacts in other EU" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Contacts in other EU" ///
1.inter1 "Having contacts in ITA, FRA, or SPA" 1.inter2 "Having contacts in other EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brintone beintone bdintone space brinttwo beinttwo bdinttwo space individual school N meandep, fmt(s s s s s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in ITA, FRA, or SPA = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in ITA, FRA, or SPA = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in ITA, FRA, or SPA = 0}"' `" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in other EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in other EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in other EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers




est sto clear


* ANY CONTACTS IN ITA FRA SPA OR EU AND DISCUSSING MIGRATION WITH FRIENDS


gen discuss_mig_clean = discuss_mig
replace discuss_mig_clean = 1 if discuss_migoth == 1

		
forval i_est = 1/3 {
	forval i_con = 1/2 {
		
		if `i_est' == 1 {
			gen y = discuss_mig_clean
		}
		
		if `i_est' == 2 {
			gen y = discuss_migoth
		}
		
		if `i_est' == 3 {
			gen y = discuss_riskorecon_contact
		}

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
		
		
		gen inter1 = contact_ifs
		gen inter2 = contact_eunoifs
		gen x = treatment_status

		qui sum y if treatment_status == 1 & f2.source_info_guinea < 6 & time == 0
		local meandep = `r(mean)'
		
		qui reg f.y i.x i.x#i.inter1 i.inter1 i.x#i.inter2 i.inter2 y strata  `controls' ///
			if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)		
				
		lincom 2.x + 2.x#1.inter2
		local brinttwo = string(`r(p)', "%9.5f") 
		
		estadd local brinttwo = `"`brinttwo'"'
		
		lincom 3.x + 3.x#1.inter2
		local beinttwo = string(`r(p)', "%9.5f") 
		
		estadd local beinttwo = `"`beinttwo'"'
		
		lincom 4.x + 4.x#1.inter2
		local bdinttwo = string(`r(p)', "%9.5f") 
		
		estadd local bdinttwo = `"`bdinttwo'"'
		
		lincom 2.x + 2.x#1.inter1
		local brintone = string(`r(p)', "%9.5f") 
		
		estadd local brintone = `"`brintone'"'
		
		lincom 3.x + 3.x#1.inter1
		local beintone = string(`r(p)', "%9.5f") 
		
		estadd local beintone = `"`beintone'"'
		
		lincom 4.x + 4.x#1.inter1
		local bdintone = string(`r(p)', "%9.5f") 
		
		estadd local bdintone = `"`bdintone'"'

		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter1 inter2 x y

		
	}
}


esttab reg1_1 reg2_1 reg1_2 reg2_2 reg1_3 reg2_3 using tablediscuss_bycontact.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 1.inter1 1.inter2) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Contacts in ITA, FRA or SPA" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Contacts in ITA, FRA or SPA" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Contacts in ITA, FRA or SPA" ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Contacts in other EU" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Contacts in other EU" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Contacts in other EU" ///
1.inter1 "Having contacts in ITA, FRA, or SPA" 1.inter2 "Having contacts in other EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(space brintone beintone bdintone space brinttwo beinttwo bdinttwo space individual school N meandep, fmt(s s s s s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in ITA, FRA, or SPA = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in ITA, FRA, or SPA = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in ITA, FRA, or SPA = 0}"' `" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in other EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in other EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in other EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
prehead("{ \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = Discusses migration} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Friends \& \\ siblings}   }&\multicolumn{2}{c}{\Shortstack{1em}{Friends from \\ oth. schools}} &\multicolumn{2}{c}{\Shortstack{1em}{Contacs \\ abroad}}  \\") ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

/*
* ANY CONTACTS IN ITA FRA SPA OR EU BY OPTIMISM

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
		
		
		gen inter1 = contact_ifs
		gen inter2 = contact_eunoifs

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.x#i.inter1#i.contactws i.inter1 i.x#i.contactws i.contactws i.contactws#i.inter1   strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.x#i.inter1#i.contactws i.inter1 i.x#i.inter2 i.inter2 i.x#i.contactws i.contactws i.contactws#i.inter1   strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
				
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter1 inter2

		
	}
}


esttab reg* using tablecontacts_any_euifsworcon.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 2.x#1.contactws 3.x#1.contactws 4.x#1.contactws 2.x#1.inter1#1.contactws 3.x#1.inter1#1.contactws 4.x#1.inter1#1.contactws 1.inter1 1.inter2 1.contactws i.contactws#i.inter1) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Contacts in ITA, FRA or SPA" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Contacts in ITA, FRA or SPA" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Contacts in ITA, FRA or SPA" ///
2.x#1.inter1#1.contactws "\(T1\) - Risk \(*\)  Cont. ITA, FRA or SPA \(*\) Contact work or stud" 3.x#1.inter1#1.contactws "\(T2\) - Econ \(*\)  Cont. ITA, FRA or SPA \(*\) Contact work or stud" 4.x#1.inter1#1.optimistic "\(T3\) - Combined \(*\)  Cont. ITA, FRA or SPA \(*\) Opt. risk or econ bel." ///
2.x#1.contactws "\(T1\) - Risk \(*\) Contact work or stud" 3.x#1.contactws "\(T2\) - Econ \(*\) Contact work or stud" 4.x#1.contactws "\(T3\) - Combined \(*\)  Contact work or stud" ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Contacts in other EU" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Contacts in other EU" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Contacts in other EU" ///
1.inter1 "Having contacts in ITA, FRA, or SPA" 1.contactws "Contact work or stud" 1.inter2 "Having contacts in other EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(space individual school N meandep, fmt(s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers

*/


* ANY CONTACTS IN ITA FRA SPA OR EU BY OPTIMISM

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
		
		
		gen inter1 = contact_ifs
		gen inter2 = contact_eunoifs

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.x#i.inter1#i.optimistic i.inter1 i.x#i.optimistic i.italy_optimistic i.econ_optimistic   strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.x#i.inter1#i.optimistic i.inter1 i.x#i.inter2 i.inter2 i.x#i.optimistic i.italy_optimistic i.econ_optimistic   strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
				
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter1 inter2

		
	}
}


esttab reg* using tablecontacts_any_euifsopt.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 2.x#1.optimistic 3.x#1.optimistic 4.x#1.optimistic 2.x#1.inter1#1.optimistic 3.x#1.inter1#1.optimistic 4.x#1.inter1#1.optimistic 1.inter1 1.inter2 1.italy_optimistic 1.econ_optimistic) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Contacts in ITA, FRA or SPA" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Contacts in ITA, FRA or SPA" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Contacts in ITA, FRA or SPA" ///
2.x#1.inter1#1.optimistic "\(T1\) - Risk \(*\)  Cont. ITA, FRA or SPA \(*\) Opt. risk bel." 3.x#1.inter1#1.optimistic "\(T2\) - Econ \(*\)  Cont. ITA, FRA or SPA \(*\) Opt. econ bel." 4.x#1.inter1#1.optimistic "\(T3\) - Combined \(*\)  Cont. ITA, FRA or SPA \(*\) Opt. risk or econ bel." ///
2.x#1.optimistic "\(T1\) - Risk \(*\) Optimistic risk bel." 3.x#1.optimistic "\(T2\) - Econ \(*\) Optimistic econ bel." 4.x#1.optimistic "\(T3\) - Combined \(*\)  Optimistic risk or econ bel." ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Contacts in other EU" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Contacts in other EU" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Contacts in other EU" ///
1.inter1 "Having contacts in ITA, FRA, or SPA" 1.italy_optimistic "Optimistic risk beliefs" 1.econ_optimistic "Optimistic econ beliefs" 1.inter2 "Having contacts in other EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
nomtitles ///
stats(space individual school N meandep, fmt(s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels( `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers








* ANY CONTACTS IN ITA FRA SPA OR ANY

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
		
		
		gen inter1 = contact_ifs
		gen inter2 = contact_anynoifs

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.inter1 i.x#i.inter2 i.inter2  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter1 i.x#i.inter2 = i.treatment_status i.treatment_status#i.inter1 i.treatment_status#i.inter2) ///
				i.inter1 i.inter2 strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
				
		lincom 2.x + 2.x#1.inter2
		local brinttwo = string(`r(p)', "%9.5f") 
		
		estadd local brinttwo = `"`brinttwo'"'
		
		lincom 3.x + 3.x#1.inter2
		local beinttwo = string(`r(p)', "%9.5f") 
		
		estadd local beinttwo = `"`beinttwo'"'
		
		lincom 4.x + 4.x#1.inter2
		local bdinttwo = string(`r(p)', "%9.5f") 
		
		estadd local bdinttwo = `"`bdinttwo'"'
		
		lincom 2.x + 2.x#1.inter1
		local brintone = string(`r(p)', "%9.5f") 
		
		estadd local brintone = `"`brintone'"'
		
		lincom 3.x + 3.x#1.inter1
		local beintone = string(`r(p)', "%9.5f") 
		
		estadd local beintone = `"`beintone'"'
		
		lincom 4.x + 4.x#1.inter1
		local bdintone = string(`r(p)', "%9.5f") 
		
		estadd local bdintone = `"`bdintone'"'

		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter1 inter2

		
	}
}


esttab reg* using tablecontacts_any_anyifs.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 1.inter1 1.inter2) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Contacts in ITA, FRA or SPA" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Contacts in ITA, FRA or SPA" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Contacts in ITA, FRA or SPA" ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Contacts in any other country" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Contacts in any other country" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Contacts in any other country" ///
1.inter1 "Having contacts in ITA, FRA, or SPA" 1.inter2 "Having contacts in any other country" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brintone beintone bdintone space brinttwo beinttwo bdinttwo space individual school N meandep, fmt(s s s s s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in ITA, FRA, or SPA = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in ITA, FRA, or SPA = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in ITA, FRA, or SPA = 0}"' `" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in any other country = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in any other country = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in any other country = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers






* ANY CONTACTS IN DESIRED EU OR OTHER EU

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
		
		
		gen inter1 = contact_des
		gen inter2 = contact_eunodes

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f2.migration_guinea100 i.x i.x#i.inter1 i.inter1 i.x#i.inter2 i.inter2  strata  `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.inter1 i.x#i.inter2 = i.treatment_status i.treatment_status#i.inter1 i.treatment_status#i.inter2) ///
				i.inter1 i.inter2 strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
			
		}
		
				
		lincom 2.x + 2.x#1.inter2
		local brinttwo = string(`r(p)', "%9.5f") 
		
		estadd local brinttwo = `"`brinttwo'"'
		
		lincom 3.x + 3.x#1.inter2
		local beinttwo = string(`r(p)', "%9.5f") 
		
		estadd local beinttwo = `"`beinttwo'"'
		
		lincom 4.x + 4.x#1.inter2
		local bdinttwo = string(`r(p)', "%9.5f") 
		
		estadd local bdinttwo = `"`bdinttwo'"'
		
		lincom 2.x + 2.x#1.inter1
		local brintone = string(`r(p)', "%9.5f") 
		
		estadd local brintone = `"`brintone'"'
		
		lincom 3.x + 3.x#1.inter1
		local beintone = string(`r(p)', "%9.5f") 
		
		estadd local beintone = `"`beintone'"'
		
		lincom 4.x + 4.x#1.inter1
		local bdintone = string(`r(p)', "%9.5f") 
		
		estadd local bdintone = `"`bdintone'"'

		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'
		
		drop inter1 inter2

		
	}
}


esttab reg* using tablecontacts_any_eudes.tex, replace keep(2.x 3.x 4.x 2.x#1.inter1 3.x#1.inter1 4.x#1.inter1 2.x#1.inter2 3.x#1.inter2 4.x#1.inter2 1.inter1 1.inter2) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter1 "\(T1\) - Risk \(*\)  Contacts in desired country" 3.x#1.inter1 "\(T2\) - Econ \(*\)  Contacts in desired country" 4.x#1.inter1 "\(T3\) - Combined \(*\)  Contacts in desired country" ///
2.x#1.inter2 "\(T1\) - Risk \(*\)  Contacts in other EU" 3.x#1.inter2 "\(T2\) - Econ \(*\)  Contacts in other EU" 4.x#1.inter2 "\(T3\) - Combined \(*\)  Contacts in other EU" ///
1.inter1 "Having contacts in ITA, FRA, or SPA" 1.inter2 "Having contacts in other EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brintone beintone bdintone space brinttwo beinttwo bdinttwo space individual school N meandep, fmt(s s s s s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in desired country = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in desired country = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in desired country = 0}"' `" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in other EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in other EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in other EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
		
		
		gen inter = contact_eu
		

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

esttab reg* using tablecontacts_any_eu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "\# contacts in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



* ANY CONTACTS IN THE EU

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
		
		
		gen inter = contact_eu
		

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

esttab reg* using tablecontacts_any_eu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "\# contacts in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers




* DISCUSSING RISK OR ECON WITH CONTACTS EU

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
		
		
		gen inter = discuss_riskorecon_contact_eu
		

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

esttab reg* using tablecontacts_any_eu_disc.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "\# contacts in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
		
		
		gen inter = discuss_riskorecon_contact_eu
		

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

esttab reg* using tablecontacts_discuss_eu.tex, replace keep(2.x 3.x 4.x 2.x#1.inter 3.x#1.inter 4.x#1.inter 1.inter) ///
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\)  Contacts in the EU" 3.x#1.inter "\(T2\) - Econ \(*\)  Contacts in the EU" 4.x#1.inter "\(T3\) - Combined \(*\)  Contacts in the EU" ///
1.inter "\# contacts in the EU" strata "Big school")   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\)  Contacts in the EU = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\)  Contacts in the EU = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Contacts in the EU = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ 0" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ 0" 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ 0" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ 0" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ 0" 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ 0" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ 0" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ 0" 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ 0" ///
1.inter "\# contacts abroad $>$ avg." strata "Big school")   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) \# contacts abroad $>$ 0 = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) \# contacts abroad $>$ 0 = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) \# contacts abroad $>$ 0 = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers





* HETEROGENEITY BY PREPARING TO MIGRATE AND HAVING CLASSMATES PREPARING TO MIGR.

egen prepare_mean = mean(prepare), by(schoolid classe_baseline option_baseline time)
sum prepare_mean, de
gen prepare_mean50 = prepare_mean > `r(p50)' if !missing(prepare_mean)

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
		
				

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x##i.prepare  mrisk_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x##i.prepare##c.prepare_mean mrisk_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tablerisk_preparepeers.tex, replace keep(2.x 3.x 4.x 2.x#1.prepare ///
	3.x#1.prepare 4.x#1.prepare 1.prepare /// 
	2.x#c.prepare_mean 3.x#c.prepare_mean 4.x#c.prepare_mean prepare_mean ///
	2.x#1.prepare#c.prepare_mean 3.x#1.prepare#c.prepare_mean ///
	4.x#1.prepare#c.prepare_mean 1.prepare#c.prepare_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.prepare "\(T1\) - Risk \(*\) Preparing to migrate" ///
	3.x#1.prepare "\(T2\) - Econ \(*\) Preparing to migrate" ///
	4.x#1.prepare "\(T3\) - Combined \(*\) Preparing to migrate" ///
	2.x#c.prepare_mean "\(T1\) - Risk \(*\) \% preparing to migrate" ///
	3.x#c.prepare_mean "\(T2\) - Econ \(*\) \% preparing to migrate" ///
	4.x#c.prepare_mean "\(T3\) - Combined \(*\) \% preparing to migrate" ///
	2.x#1.prepare#c.prepare_mean "\(T1\) - Risk \(*\) prepar. \(*\) \% prep." ///
	3.x#1.prepare#c.prepare_mean "\(T2\) - Econ \(*\) prepar. \(*\) \% prep." ///
	4.x#1.prepare#c.prepare_mean "\(T3\) - Combined \(*\) prepar. \(*\) \% prep." ///
1.inter "\# contacts abroad $>$ avg." strata "Big school" ///
1.prepare#c.prepare_mean "Preparing to mig. \(*\) \% prep."  ///
1.prepare "Preparing to mig." prepare_mean "\% preparing to mig." )   se substitute(\_ _) ///
mgroups("y = PCA Risk", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
		
				

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.economic_index i.x##i.prepare  economic_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f.economic_index i.x##i.prepare##c.prepare_mean economic_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tableecon_preparepeers.tex, replace keep(2.x 3.x 4.x 2.x#1.prepare ///
	3.x#1.prepare 4.x#1.prepare 1.prepare /// 
	2.x#c.prepare_mean 3.x#c.prepare_mean 4.x#c.prepare_mean prepare_mean ///
	2.x#1.prepare#c.prepare_mean 3.x#1.prepare#c.prepare_mean ///
	4.x#1.prepare#c.prepare_mean 1.prepare#c.prepare_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.prepare "\(T1\) - Risk \(*\) Preparing to migrate" ///
	3.x#1.prepare "\(T2\) - Econ \(*\) Preparing to migrate" ///
	4.x#1.prepare "\(T3\) - Combined \(*\) Preparing to migrate" ///
	2.x#c.prepare_mean "\(T1\) - Risk \(*\) \% preparing to migrate" ///
	3.x#c.prepare_mean "\(T2\) - Econ \(*\) \% preparing to migrate" ///
	4.x#c.prepare_mean "\(T3\) - Combined \(*\) \% preparing to migrate" ///
	2.x#1.prepare#c.prepare_mean "\(T1\) - Risk \(*\) prepar. \(*\) \% prep." ///
	3.x#1.prepare#c.prepare_mean "\(T2\) - Econ \(*\) prepar. \(*\) \% prep." ///
	4.x#1.prepare#c.prepare_mean "\(T3\) - Combined \(*\) prepar. \(*\) \% prep." ///
1.inter "\# contacts abroad $>$ avg." strata "Big school" ///
1.prepare#c.prepare_mean "Preparing to mig. \(*\) \% prep."  ///
1.prepare "Preparing to mig." prepare_mean "\% preparing to mig." )   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers




qui sum migration_guinea if time == 2  & source_info_guinea < 6
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
			qui reg f2.migration_guinea i.x##i.prepare  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea i.x##i.prepare##c.prepare_mean strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tablemig_preparepeers.tex, replace keep(2.x 3.x 4.x 2.x#1.prepare ///
	3.x#1.prepare 4.x#1.prepare 1.prepare /// 
	2.x#c.prepare_mean 3.x#c.prepare_mean 4.x#c.prepare_mean prepare_mean ///
	2.x#1.prepare#c.prepare_mean 3.x#1.prepare#c.prepare_mean ///
	4.x#1.prepare#c.prepare_mean 1.prepare#c.prepare_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.prepare "\(T1\) - Risk \(*\) Preparing to migrate" ///
	3.x#1.prepare "\(T2\) - Econ \(*\) Preparing to migrate" ///
	4.x#1.prepare "\(T3\) - Combined \(*\) Preparing to migrate" ///
	2.x#c.prepare_mean "\(T1\) - Risk \(*\) \% preparing to migrate" ///
	3.x#c.prepare_mean "\(T2\) - Econ \(*\) \% preparing to migrate" ///
	4.x#c.prepare_mean "\(T3\) - Combined \(*\) \% preparing to migrate" ///
	2.x#1.prepare#c.prepare_mean "\(T1\) - Risk \(*\) prepar. \(*\) \% prep." ///
	3.x#1.prepare#c.prepare_mean "\(T2\) - Econ \(*\) prepar. \(*\) \% prep." ///
	4.x#1.prepare#c.prepare_mean "\(T3\) - Combined \(*\) prepar. \(*\) \% prep." ///
1.inter "\# contacts abroad $>$ avg." strata "Big school" ///
1.prepare#c.prepare_mean "Preparing to mig. \(*\) \% prep."  ///
1.prepare "Preparing to mig." prepare_mean "\% preparing to mig." )   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



* HETEROGENEITY BY PLANNING TO MIGRATE AND HAVING CLASSMATES PREPARING TO MIGR.

egen planning_mean = mean(planning), by(schoolid classe_baseline option_baseline time)
sum planning_mean, de
gen planning_mean50 = planning_mean > `r(p50)' if !missing(planning_mean)

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
		
				

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x##i.planning  mrisk_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x##i.planning##c.planning_mean mrisk_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tablerisk_planpeers.tex, replace keep(2.x 3.x 4.x 2.x#1.planning ///
	3.x#1.planning 4.x#1.planning 1.planning /// 
	2.x#c.planning_mean 3.x#c.planning_mean 4.x#c.planning_mean planning_mean ///
	2.x#1.planning#c.planning_mean 3.x#1.planning#c.planning_mean ///
	4.x#1.planning#c.planning_mean 1.planning#c.planning_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.planning "\(T1\) - Risk \(*\) Planning to migrate" ///
	3.x#1.planning "\(T2\) - Econ \(*\) Planning to migrate" ///
	4.x#1.planning "\(T3\) - Combined \(*\) Planning to migrate" ///
	2.x#c.planning_mean "\(T1\) - Risk \(*\) \% planning to migrate" ///
	3.x#c.planning_mean "\(T2\) - Econ \(*\) \% planning to migrate" ///
	4.x#c.planning_mean "\(T3\) - Combined \(*\) \% planning to migrate" ///
	2.x#1.planning#c.planning_mean "\(T1\) - Risk \(*\) planning \(*\) \% plan." ///
	3.x#1.planning#c.planning_mean "\(T2\) - Econ \(*\) planning \(*\) \% plan." ///
	4.x#1.planning#c.planning_mean "\(T3\) - Combined \(*\) planning \(*\) \% plan." ///
	strata "Big school" ///
1.planning#c.planning_mean "Planning to mig. \(*\) \% plan."  ///
1.prepare "Planning to mig." planning_mean "\% planning to mig." )   se substitute(\_ _) ///
mgroups("y = PCA Risk", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
		
				

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.economic_index i.x##i.planning  economic_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f.economic_index i.x##i.planning##c.planning_mean economic_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tableecon_planpeers.tex, replace keep(2.x 3.x 4.x 2.x#1.planning ///
	3.x#1.planning 4.x#1.planning 1.planning /// 
	2.x#c.planning_mean 3.x#c.planning_mean 4.x#c.planning_mean planning_mean ///
	2.x#1.planning#c.planning_mean 3.x#1.planning#c.planning_mean ///
	4.x#1.planning#c.planning_mean 1.planning#c.planning_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.planning "\(T1\) - Risk \(*\) Planning to migrate" ///
	3.x#1.planning "\(T2\) - Econ \(*\) Planning to migrate" ///
	4.x#1.planning "\(T3\) - Combined \(*\) Planning to migrate" ///
	2.x#c.planning_mean "\(T1\) - Risk \(*\) \% planning to migrate" ///
	3.x#c.planning_mean "\(T2\) - Econ \(*\) \% planning to migrate" ///
	4.x#c.planning_mean "\(T3\) - Combined \(*\) \% planning to migrate" ///
	2.x#1.planning#c.planning_mean "\(T1\) - Risk \(*\) planning \(*\) \% plan." ///
	3.x#1.planning#c.planning_mean "\(T2\) - Econ \(*\) planning \(*\) \% plan." ///
	4.x#1.planning#c.planning_mean "\(T3\) - Combined \(*\) planning \(*\) \% plan." ///
	strata "Big school" ///
1.planning#c.planning_mean "Planning to mig. \(*\) \% plan."  ///
1.prepare "Planning to mig." planning_mean "\% planning to mig." )   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers




qui sum migration_guinea if time == 2  & source_info_guinea < 6
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
			qui reg f2.migration_guinea i.x##i.planning  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea i.x##i.planning##c.planning_mean strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tablemig_planpeers.tex, replace keep(2.x 3.x 4.x 2.x#1.planning ///
	3.x#1.planning 4.x#1.planning 1.planning /// 
	2.x#c.planning_mean 3.x#c.planning_mean 4.x#c.planning_mean planning_mean ///
	2.x#1.planning#c.planning_mean 3.x#1.planning#c.planning_mean ///
	4.x#1.planning#c.planning_mean 1.planning#c.planning_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.planning "\(T1\) - Risk \(*\) Planning to migrate" ///
	3.x#1.planning "\(T2\) - Econ \(*\) Planning to migrate" ///
	4.x#1.planning "\(T3\) - Combined \(*\) Planning to migrate" ///
	2.x#c.planning_mean "\(T1\) - Risk \(*\) \% planning to migrate" ///
	3.x#c.planning_mean "\(T2\) - Econ \(*\) \% planning to migrate" ///
	4.x#c.planning_mean "\(T3\) - Combined \(*\) \% planning to migrate" ///
	2.x#1.planning#c.planning_mean "\(T1\) - Risk \(*\) planning \(*\) \% plan." ///
	3.x#1.planning#c.planning_mean "\(T2\) - Econ \(*\) planning \(*\) \% plan." ///
	4.x#1.planning#c.planning_mean "\(T3\) - Combined \(*\) planning \(*\) \% plan." ///
	strata "Big school" ///
1.planning#c.planning_mean "Planning to mig. \(*\) \% plan."  ///
1.prepare "Planning to mig." planning_mean "\% planning to mig." )   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers







* HETEROGENEITY BY WISHING TO MIGRATE AND HAVING CLASSMATES PREPARING TO MIGR.

egen desire_mean = mean(desire), by(schoolid classe_baseline option_baseline time)
sum desire_mean, de
gen desire_mean50 = desire_mean > `r(p50)' if !missing(desire_mean)

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
		
				

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x##i.desire  mrisk_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f.mrisk_index i.x##i.desire##c.desire_mean mrisk_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tablerisk_wishpeers.tex, replace keep(2.x 3.x 4.x 2.x#1.desire ///
	3.x#1.desire 4.x#1.desire 1.desire /// 
	2.x#c.desire_mean 3.x#c.desire_mean 4.x#c.desire_mean desire_mean ///
	2.x#1.desire#c.desire_mean 3.x#1.desire#c.desire_mean ///
	4.x#1.desire#c.desire_mean 1.desire#c.desire_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.desire "\(T1\) - Risk \(*\) Wishing to migrate" ///
	3.x#1.desire "\(T2\) - Econ \(*\) Wishing to migrate" ///
	4.x#1.desire "\(T3\) - Combined \(*\) Wishing to migrate" ///
	2.x#c.desire_mean "\(T1\) - Risk \(*\) \% wishing to migrate" ///
	3.x#c.desire_mean "\(T2\) - Econ \(*\) \% wishing to migrate" ///
	4.x#c.desire_mean "\(T3\) - Combined \(*\) \% wishing to migrate" ///
	2.x#1.desire#c.desire_mean "\(T1\) - Risk \(*\) Wishing \(*\) \% wish." ///
	3.x#1.desire#c.desire_mean "\(T2\) - Econ \(*\) Wishing \(*\) \% wish." ///
	4.x#1.desire#c.desire_mean "\(T3\) - Combined \(*\) Wishing \(*\) \% wish." ///
	strata "Big school" ///
1.desire#c.desire_mean "Wishing to mig. \(*\) \% wish."  ///
1.desire "Wishing to mig." desire_mean "\% wishing to mig." )   se substitute(\_ _) ///
mgroups("y = PCA Risk", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
		
				

		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.economic_index i.x##i.desire  economic_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f.economic_index i.x##i.desire##c.desire_mean economic_index strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tableecon_wishpeers.tex, replace keep(2.x 3.x 4.x 2.x#1.desire ///
	3.x#1.desire 4.x#1.desire 1.desire /// 
	2.x#c.desire_mean 3.x#c.desire_mean 4.x#c.desire_mean desire_mean ///
	2.x#1.desire#c.desire_mean 3.x#1.desire#c.desire_mean ///
	4.x#1.desire#c.desire_mean 1.desire#c.desire_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.desire "\(T1\) - Risk \(*\) Wishing to migrate" ///
	3.x#1.desire "\(T2\) - Econ \(*\) Wishing to migrate" ///
	4.x#1.desire "\(T3\) - Combined \(*\) Wishing to migrate" ///
	2.x#c.desire_mean "\(T1\) - Risk \(*\) \% wishing to migrate" ///
	3.x#c.desire_mean "\(T2\) - Econ \(*\) \% wishing to migrate" ///
	4.x#c.desire_mean "\(T3\) - Combined \(*\) \% wishing to migrate" ///
	2.x#1.desire#c.desire_mean "\(T1\) - Risk \(*\) Wishing \(*\) \% wish." ///
	3.x#1.desire#c.desire_mean "\(T2\) - Econ \(*\) Wishing \(*\) \% wish." ///
	4.x#1.desire#c.desire_mean "\(T3\) - Combined \(*\) Wishing \(*\) \% wish." ///
	strata "Big school" ///
1.desire#c.desire_mean "Wishing to mig. \(*\) \% wish."  ///
1.desire "Wishing to mig." desire_mean "\% wishing to mig." )   se substitute(\_ _) ///
mgroups("y = PCA Econ", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
postfoot("\hline\hline \end{tabular} }") 	nonumbers



qui sum migration_guinea if time == 2  & source_info_guinea < 6
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
			qui reg f2.migration_guinea i.x##i.desire  strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = treatment_status
			qui reg f2.migration_guinea i.x##i.desire##c.desire_mean strata  `controls' ///
				if  time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
				
		estadd local space " "
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_con'_`i_est'

		
	}
}

esttab reg* using tablemig_wishpeers.tex, replace keep(2.x 3.x 4.x 2.x#1.desire ///
	3.x#1.desire 4.x#1.desire 1.desire /// 
	2.x#c.desire_mean 3.x#c.desire_mean 4.x#c.desire_mean desire_mean ///
	2.x#1.desire#c.desire_mean 3.x#1.desire#c.desire_mean ///
	4.x#1.desire#c.desire_mean 1.desire#c.desire_mean ) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.desire "\(T1\) - Risk \(*\) Wishing to migrate" ///
	3.x#1.desire "\(T2\) - Econ \(*\) Wishing to migrate" ///
	4.x#1.desire "\(T3\) - Combined \(*\) Wishing to migrate" ///
	2.x#c.desire_mean "\(T1\) - Risk \(*\) \% wishing to migrate" ///
	3.x#c.desire_mean "\(T2\) - Econ \(*\) \% wishing to migrate" ///
	4.x#c.desire_mean "\(T3\) - Combined \(*\) \% wishing to migrate" ///
	2.x#1.desire#c.desire_mean "\(T1\) - Risk \(*\) Wishing \(*\) \% wish." ///
	3.x#1.desire#c.desire_mean "\(T2\) - Econ \(*\) Wishing \(*\) \% wish." ///
	4.x#1.desire#c.desire_mean "\(T3\) - Combined \(*\) Wishing \(*\) \% wish." ///
	strata "Big school" ///
1.desire#c.desire_mean "Wishing to mig. \(*\) \% wish."  ///
1.desire "Wishing to mig." desire_mean "\% wishing to mig." )   se substitute(\_ _) ///
mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
mtitles("ITT" "ITT" "ITT" "ITT" "ITT" "ITT") ///
stats(individual school N meandep, fmt(s s 0 3) ///
layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad " 4.x#c.inter "\(T3\) - Combined \(*\) \# contacts abroad " ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad " 4.x#c.inter "\(T3\) - Combined \(*\) \# contacts abroad " ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad " 4.x#c.inter "\(T3\) - Combined \(*\) \# contacts abroad " ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ median" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ median " 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ median" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ median" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ median " 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ median" ///
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
coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
2.x#1.inter "\(T1\) - Risk \(*\) \# contacts abroad $>$ median" 3.x#1.inter "\(T2\) - Econ \(*\) \# contacts abroad $>$ median " 4.x#1.inter "\(T3\) - Combined \(*\) \# contacts abroad $>$ median" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad" 4.x#c.inter "\(T3\) - Combined \(*\) \# contacts abroad" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#c.inter "\(T1\) - Risk \(*\) \# contacts abroad" 3.x#c.inter "\(T2\) - Econ \(*\) \# contacts abroad" 4.x#c.inter "\(T3\) - Combined \(*\) \# contacts abroad" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Discusses w/ cont. abroad" 3.x#1.inter "\(T2\) - Econ \(*\) Discusses w/ cont. abroad" 4.x#1.inter "\(T3\) - Combined \(*\) Discusses w/ cont. abroad" ///
	1.inter "Discusses w/ cont. abroad" strata "Big school")   se substitute(\_ _) ///
			nomtitles ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Discusses w/ cont. abroad = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Discusses w/ cont. abroad = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Discusses w/ cont. abroad = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = migration from Guinea} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Discusses \\ Risk}   }&\multicolumn{2}{c}{\Shortstack{1em}{Discusses \\ Econ}} &\multicolumn{2}{c}{\Shortstack{1em}{Discuess \\ Both}}  \\ ") nonumbers 


*MIGRATION BY DISCUSS MIG. (restricted sample)

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
			qui reg f2.migration_guinea100 i.x i.x#i.discuss_mig i.discuss_mig strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.discuss_mig = i.treatment_status i.treatment_status#i.discuss_mig) ///
				i.discuss_mig strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.discuss_mig
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.discuss_mig
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.discuss_mig
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

esttab reg* using tablemig_discussmig.tex, replace  keep(2.x 3.x 4.x 2.x#1.discuss_mig 3.x#1.discuss_mig 4.x#1.discuss_mig 1.discuss_mig) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.discuss_mig "\(T1\) - Risk \(*\) Discuss mig." 3.x#1.discuss_mig "\(T2\) - Econ \(*\) Discuss mig." 4.x#1.discuss_mig "\(T3\) - Combined \(*\) Discuss mig." ///
	1.discuss_mig "Discuss mig." strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Discuss mig. = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Discuss mig. = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Discuss mig. = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")



	


*MIGRATION BY DISCUSS MIG. W/ STUDENTS FROM OTHER SCHOOLS (restricted sample)

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
			qui reg f2.migration_guinea100 i.x i.x#i.discuss_migoth i.discuss_migoth strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f2.migration_guinea100 (i.x i.x#i.discuss_migoth = i.treatment_status i.treatment_status#i.discuss_migoth) ///
				i.discuss_migoth strata `controls' if f2.source_info_guinea < 6 & attended_tr != ., cluster(schoolid)
			drop x
		}
		
		lincom 2.x + 2.x#1.discuss_migoth
		local brint = string(`r(p)', "%9.5f") 
		
		estadd local brint = `"`brint'"'
		
		lincom 3.x + 3.x#1.discuss_migoth
		local beint = string(`r(p)', "%9.5f") 
		
		estadd local beint = `"`beint'"'
		
		lincom 4.x + 4.x#1.discuss_migoth
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

esttab reg* using tablemig_discussmigoth.tex, replace  keep(2.x 3.x 4.x 2.x#1.discuss_migoth 3.x#1.discuss_migoth 4.x#1.discuss_migoth 1.discuss_migoth) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.discuss_migoth "\(T1\) - Risk \(*\) Discuss mig. w/ other schools stud." 3.x#1.discuss_migoth "\(T2\) - Econ \(*\) Discuss mig. w/ other schools stud." 4.x#1.discuss_migoth "\(T3\) - Combined \(*\) Discuss mig. w/ other schools stud." ///
	1.discuss_migoth "Discuss mig. w/ other schools stud." strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(space brint beint bdint space individual school N meandep, fmt(s s s s s s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"  "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`" "' `"\emph{H0: \(T1\) + \(T1\) \(*\) Discuss mig. w/ other schools stud. = 0}"' `"\emph{H0: \(T2\) + \(T2\) \(*\) Discuss mig. w/ other schools stud. = 0}"'  `"\emph{H0: \(T3\) + \(T3\) \(*\) Discuss mig. w/ other schools stud. = 0}"' `" "'  `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	



*DISCUSS MIG. W/ STUDENTS FROM OTHER SCHOOLS  AS AN OUTCOME (restricted sample)

eststo clear

qui sum discuss_migoth if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
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
			qui reg f.discuss_migoth i.x i.discuss_migoth strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.discuss_migoth (i.x = i.treatment_status) ///
				i.discuss_migoth strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & time == 0, cluster(schoolid)
			drop x
		}
		
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table_discussmigoth.tex, replace  keep(2.x 3.x 4.x 1.discuss_migoth) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	1.discuss_migoth "Discuss mig. w/ other schools stud." strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = Discuss mig. w/ other schools stud.", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(individual school N meandep, fmt(s s 0 3) ///
	layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	
*TALKED TO CONTACTS ABROAD EU AS AN OUTCOME (restricted sample)

eststo clear


forval i_con = 1/3 {	
	forval i_est = 1/2 {
		
		if `i_con' == 1 {
			gen y = daily_contact_eu
		}
		
		if `i_con' == 2 {
			gen y = weekly_contact_eu
		}
		
		if `i_con' == 3 {
			gen y = monthly_contact_eu
		}
		
		qui sum y if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
		local meandep = `r(mean)'

		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
			
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y i.x i.y strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
			drop x y
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y (i.x = i.treatment_status) ///
				i.y strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & time == 0, cluster(schoolid)
			drop x y
		}
		
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table_talkcontacteu.tex, replace  keep(2.x 3.x 4.x 1.y) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	1.y "Discuss mig." strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV" "ITT" "IV") ///
		stats(individual school N meandep, fmt(s s 0 3) ///
	layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) nonumbers ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = Talks to contacts in the EU + Switzerland} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Daily}   }&\multicolumn{2}{c}{\Shortstack{1em}{Weekly}} &\multicolumn{2}{c}{\Shortstack{1em}{Monthly}}  \\ ") ///
	postfoot("\hline\hline \end{tabular}")

*/
	
*TALKED TO CONTACTS ABROAD EU AS AN OUTCOME (restricted sample)

eststo clear


forval i_con = 1/3 {	
	forval i_est = 1/2 {
		
		if `i_con' == 1 {
			gen y = daily_contact_eu
		}
		
		if `i_con' == 2 {
			gen y = weekly_contact_eu
		}
		
		if `i_con' == 3 {
			gen y = monthly_contact_eu
		}
		
		qui sum y if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
		local meandep = `r(mean)'

		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
			
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y i.x i.y strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
			drop x y
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y (i.x = i.treatment_status) ///
				i.y strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & time == 0, cluster(schoolid)
			drop x y
		}
		
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table_talkcontacteu.tex, replace  keep(2.x 3.x 4.x 1.y) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	1.y "Discuss mig." strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV" "ITT" "IV") ///
		stats(individual school N meandep, fmt(s s 0 3) ///
	layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) nonumbers ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = Talks to contacts in the EU + Switzerland} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Daily}   }&\multicolumn{2}{c}{\Shortstack{1em}{Weekly}} &\multicolumn{2}{c}{\Shortstack{1em}{Monthly}}  \\ ") ///
	postfoot("\hline\hline \end{tabular}")

	/*
	
*TALKED TO CONTACTS ABROAD AS AB IYTCINE (restricted sample)

eststo clear


forval i_con = 1/3 {	
	forval i_est = 1/2 {
		
		if `i_con' == 1 {
			gen y = daily_contact
		}
		
		if `i_con' == 2 {
			gen y = weekly_contact
		}
		
		if `i_con' == 3 {
			gen y = monthly_contact
		}
		
		qui sum y if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
		local meandep = `r(mean)'

		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
			
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y i.x i.y strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
			drop x y
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y (i.x = i.treatment_status) ///
				i.y strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & time == 0, cluster(schoolid)
			drop x y
		}
		
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table_talkcontact.tex, replace  keep(2.x 3.x 4.x 1.y) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	1.y "Discuss mig." strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV" "ITT" "IV") ///
		stats(individual school N meandep, fmt(s s 0 3) ///
	layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) nonumbers ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = Talks to contacts abroad} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Daily}   }&\multicolumn{2}{c}{\Shortstack{1em}{Weekly}} &\multicolumn{2}{c}{\Shortstack{1em}{Monthly}}  \\ ") ///
	postfoot("\hline\hline \end{tabular}")

	
	
	
		
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	y "Intends to migrate" strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  N meandep, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 


	
	
	
	
*DISCUSS MIG. AS AN OUTCOME (restricted sample)

eststo clear

*gen discuss_mig_clean = discuss_mig
*replace discuss_mig_clean = 1 if discuss_migoth == 1




forval i_con = 1/3 {	
	forval i_est = 1/2 {
		
		if `i_con' == 1 {
			gen y = discuss_mig_clean
		}
		
		if `i_con' == 2 {
			gen y = discuss_migoth
		}
		
		if `i_con' == 3 {
			gen y = discuss_riskorecon_contact
		}


		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
			
		if `i_est' == 1 {
			gen x = treated
			qui reg f.y i.x i.y strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
		}
		
		if `i_est' == 2 {
			gen x = attended_any
			qui ivreg2 f.y (i.x = i.treated) ///
				i.y strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & time == 0, cluster(schoolid)
		}
		
				
		eststo reg`i_est'_`i_con'
		
		drop x y


		
	}
}

esttab reg* using table_discussall_a.tex, replace  keep(1.x) ///
	coeflabels(1.x "Any treatment")   se substitute(\_ _) ///
	mtitles("ITT" "IV" "ITT" "IV" "ITT" "IV") ///
		nonumbers   noobs /// 
	nobaselevels ///
	prehead("{ \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi} \begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = Discusses migration} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Friends \& \\ siblings}   }&\multicolumn{2}{c}{\Shortstack{1em}{Friends from \\ oth. schools}} &\multicolumn{2}{c}{\Shortstack{1em}{Contacs \\ abroad}}  \\") ///
	posthead("\hline  \\ \textbf{\textit{Panel (a)}} & & &  &  &  &   \\ [1em]") prefoot("\hline") postfoot(" ")  

	
	

forval i_con = 1/3 {	
	forval i_est = 1/2 {
		
		if `i_con' == 1 {
			gen y = discuss_mig_clean
		}
		
		if `i_con' == 2 {
			gen y = discuss_migoth
		}
		
		if `i_con' == 3 {
			gen y = discuss_riskorecon_contact
		}
		
		qui sum y if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
		local meandep = `r(mean)'

		local controls `demographics' `school_char'
		local individual "Yes"
		local school "Yes"
		local lagoutcome "Yes"
			
		if `i_est' == 1 {
			gen x = treatment_status
			qui reg f.y i.x i.y strata `controls' ///
				if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.y (i.x = i.treatment_status) ///
				i.y strata `controls' if f2.source_info_guinea < 6 & attended_tr != . & time == 0, cluster(schoolid)
		}
		
		
		estadd local space " "
		
		test 2.x - 3.x = 0
		local pre  = string(`r(p)', "%9.2f")
		estadd local pre = `"`pre'"'

		test 2.x - 4.x = 0
		local prd = string(`r(p)', "%9.2f") 
		estadd local prd = `"`prd'"'

		test 3.x - 4.x = 0
		local ped = string(`r(p)', "%9.2f")
		estadd local ped = `"`ped'"'

		estadd local lagoutcome = "`lagoutcome'"
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		estadd local space = "` '"
				
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'
		
		drop x y


		
	}
}

esttab reg* using table_discussall_b.tex, replace  keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	1.y "Discuss mig." strata "Big school")   se substitute(\_ _) ///
	nomtitles ///
	stats(pre prd ped space  N meandep, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) nonumbers ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  & &   \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 


	

*TOPIC COVERED WITH CONTACTS ABROAD AS AN OUTCOME (EU)

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
			gen inter = discuss_risk_contact_eu
		}
		
		if `i_est' == 2 {
			gen inter = discuss_econ_contact_eu
		}
		
		if `i_est' == 3 {
			gen inter = discuss_riskecon_contact_eu
		}
		
		qui sum inter if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
		local meandep = `r(mean)'

		gen x = treatment_status
		qui reg f.inter i.x i.inter  strata `controls' ///
			if time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		
		estadd local meandep = `"`meandep'"'

		eststo reg`i_est'_`i_con'

		drop inter
		
	}
}



esttab reg* using table_disctopic_eu.tex, replace  keep(2.x 3.x 4.x 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	1.inter "Discusses w/ cont. abroad" strata "Big school")   se substitute(\_ _) ///
					nomtitles ///
		stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = Discusses w/ cont. abroad} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Discusses \\ Risk}   }&\multicolumn{2}{c}{\Shortstack{1em}{Discusses \\ Econ}} &\multicolumn{2}{c}{\Shortstack{1em}{Discuess \\ Both}}  \\ ") nonumbers 
	

	


*TOPIC COVERED WITH CONTACTS ABROAD AS AN OUTCOME

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
		
		qui sum inter if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
		local meandep = `r(mean)'

		gen x = treatment_status
		qui reg f.inter i.x i.inter  strata `controls' ///
			if time == 0 & f2.source_info_guinea < 6  & attended_tr != ., cluster(schoolid)
		drop x
		
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		
		estadd local meandep = `"`meandep'"'

		eststo reg`i_est'_`i_con'

		drop inter
		
	}
}



esttab reg* using table_disctopic.tex, replace  keep(2.x 3.x 4.x 1.inter) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	1.inter "Discusses w/ cont. abroad" strata "Big school")   se substitute(\_ _) ///
					nomtitles ///
		stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{7}{c}} \hline\hline           &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}  \\ &\multicolumn{6}{c}{y = Discusses w/ cont. abroad} \\    \cmidrule(lr){2-7} & \multicolumn{2}{c}{   \Shortstack{1em}{Discusses \\ Risk}   }&\multicolumn{2}{c}{\Shortstack{1em}{Discusses \\ Econ}} &\multicolumn{2}{c}{\Shortstack{1em}{Discuess \\ Both}}  \\ ") nonumbers 
	





*SWITCHING ROUTE AS AN OUTCOME (restricted sample)

eststo clear

gen route_same = route_chosen == l.route_chosen if time == 1
gen route_switch = route_same == 0

qui sum route_switch if l1.treatment_status == 1  &  f.source_info_guinea < 6 & time == 1
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
			qui reg f.route_switch i.x strata `controls' i.route_chosen ///
				if f2.source_info_guinea < 6  & attended_tr != . & time == 0, cluster(schoolid)
			drop x
		}
		
		if `i_est' == 2 {
			gen x = attended_tr
			qui ivreg2 f.route_switch (i.x = i.treatment_status) ///
				strata `controls' i.route_chosen if f2.source_info_guinea < 6 & attended_tr != . & time == 0, cluster(schoolid)
			drop x
		}
		
		
		estadd local space " "
		
		estadd local individual = "`individual'"
		estadd local school = "`school'"
		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}

esttab reg* using table_routeswitch.tex, replace  keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = Switching route", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
		stats(individual school N meandep, fmt(s s 0 3) ///
	layout( "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels( `"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")


	

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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Discusses w/ cont. abroad" 3.x#1.inter "\(T2\) - Econ \(*\) Discusses w/ cont. abroad" 4.x#1.inter "\(T3\) - Combined \(*\) Discusses w/ cont. abroad" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.inter "\(T1\) - Risk \(*\) Discusses w/ cont. abroad" 3.x#1.inter "\(T2\) - Econ \(*\) Discusses w/ cont. abroad" 4.x#1.inter "\(T3\) - Combined \(*\) Discusses w/ cont. abroad" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.optimistic "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic "\(T3\) - Combined \(*\) Und. risk or over. econ" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.optimistic1 "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic1 "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic1 "\(T3\) - Combined \(*\) Und. risk or over. econ" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.optimistic3 "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic3 "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic3 "\(T3\) - Combined \(*\) Und. risk or over. econ" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	y "Intends to migrate" strata "Big school")   se substitute(\_ _) ///
	stats(pre prd ped space  N meandep, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 





global perception_outcomes "mrisk_index"

local n_outcomes `: word count $perception_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $perception_outcomes {

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

gen new_R4 = .


replace new_R4 = 3 if R4 == 3
replace new_R4 = 2 if R4 == 2
replace new_R4 = 1 if R4 == 1

replace R4 = new_R4*2
drop new_R4
			
la var R4 Outcome
la var R1 "Effect"
label define groups 2 "Risk" 4 "Econ" 6 "Combined" 
label values R4 groups





set scheme s2mono

*fwer
twoway (bar R1 R4, barw(1.2) fi(inten60) lc(black) color(eltblue) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(2 4 6, valuelabel angle(45)) 	///
graphregion(color(white)) ///
ytitle(Treatment effect) ///
yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
ylabel(-0.2(0.1)1.1) 

graph save Graph ${main}/Draft/figures/figure_pcarisk_byout.gph, replace
graph export ${main}/Draft/figures/figure_pcarisk_byout.png , replace

restore





global perception_outcomes "economic_index"

local n_outcomes `: word count $perception_outcomes'
local n_rows = `n_outcomes'*3
mat R=J(`n_rows',4,.)

local n = 0

foreach y in $perception_outcomes {

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

gen new_R4 = .


replace new_R4 = 3 if R4 == 3
replace new_R4 = 2 if R4 == 2
replace new_R4 = 1 if R4 == 1

replace R4 = new_R4*2
drop new_R4
			
la var R4 Outcome
la var R1 "Effect"
label define groups 2 "Risk" 4 "Econ" 6 "Combined" 
label values R4 groups





set scheme s2mono

*fwer
twoway (bar R1 R4, barw(1.2) fi(inten60) lc(black) color(eltblue) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(2 4 6, valuelabel angle(45)) 	///
graphregion(color(white)) ///
ytitle(Treatment effect) ///
yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
ylabel(-1(0.1)0.2) 

graph save Graph ${main}/Draft/figures/figure_pcaecon_byout.gph, replace
graph export ${main}/Draft/figures/figure_pcaecon_byout.png , replace

restore






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

gen new_R4 = .

replace new_R4 = 10 if R4 == 9
replace new_R4 = 9 if R4 == 6
replace new_R4 = 8 if R4 == 3

replace new_R4 = 6.5 if R4 == 8
replace new_R4 = 5.5 if R4 == 5
replace new_R4 = 4.5 if R4 == 2

replace new_R4 = 3 if R4 == 7
replace new_R4 = 2 if R4 == 4
replace new_R4 = 1 if R4 == 1

replace R4 = new_R4*2
drop new_R4
			
la var R4 Outcome
la var R1 "Effect"
label define groups 2 "Risk" 4 "Econ" 6 "Combined" ///
	 9 "Risk" 11 "Econ" 13 "Combined" ///
	 16 "Risk" 18 "Econ" 20 "Combined" ///
	 23 "Risk" 25 "Econ" 27 "Combined" ///
	 30 "Risk" 32 "Econ" 34 "Combined" ///
	 37 "Risk" 39 "Econ" 41 "Combined" 
label values R4 groups





set scheme s2mono

*fwer
twoway (bar R1 R4, barw(1.2) fi(inten60) lc(black) color(eltblue) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(2 4 6 9 11 13 16 18 20, valuelabel angle(45)) 	///
graphregion(color(white)) ///
xline(7.5, lpattern(-) lcolor(black)) 	///
xline(14.5, lpattern(-) lcolor(black)) 	///
yline(0, lpattern(solid) lcolor(black) lw(vthin)) 	///
ytitle(Treatment effect) ///
ylabel(-9(2)3) ///
text(3 4 "Wishing") text(2.4 4 "to migrate") text(3 11 "Planning") ///
text(2.4 11 "to migrate") text(3 18 "Preparing")  text(2.4 18 "to migrate") 

graph save Graph ${main}/Draft/figures/figure19_byout.gph, replace
graph export ${main}/Draft/figures/figure19_byout.png , replace

restore




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
	text(3 2 "Risk") text(3 5 "Econ") text(3 8 "Combined")
	 
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" ///
	2.x#1.optimistic_strong "\(T1\) - Risk \(*\) Underestimates risk" 3.x#1.optimistic_strong "\(T2\) - Econ \(*\) Overestimates econ" 4.x#1.optimistic_strong "\(T3\) - Combined \(*\) Und. risk \& over. econ" ///
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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("ITT" "ITT" "ITT" "IV" "IV" "IV") ///
	mgroups("y = migration from Guinea", pattern(1 0 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) ///
	stats(individual school N meandep, fmt(s s 0 3) ///
	layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  ///
	labels(`"Individual controls"' `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}}")

	
drop migration_guinea100 migration_visa100 migration_novisa100 desire100 planning100 prepare100



/*
				
*________________________NEW_START


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
* Fa anche regressioni su indici di appendice ma non le salva perché andrebbero con econ

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
	
global crisk_outcomes = " asinhcrisk_duration_winsor " ///
						+ " crisk_beaten " ///
						+ " crisk_forced_work " ///
						+ " asinhcrisk_journey_cost_winsor  " ///
						+ " crisk_kidnapped " ///
						+ " crisk_die_bef_boat " ///
						+ " crisk_die_boat " ///
						+ " crisk_sent_back "



global crisk_outcomes_bl " "
foreach var in $crisk_outcomes {
	gen l1`var' = l.`var'
	global crisk_outcomes_bl $crisk_outcomes_bl " l1`var'"
}

local n_outcomes `: word count $crisk_outcomes'

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"

/*
di "indexes:"
foreach var of varlist $crisk_outcomes {
	di "  - `var'"
}	
*/

if (`makefwer' == 1) {
	
	preserve
	drop if time == 2
	drop if time == 1 & l1.attended_tr == .
	drop if time == 0 & attended_tr == .

	wyoung $crisk_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 `controls_bl' CONTROLVARS  , ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3) ///
		controls($crisk_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	matrix define results = r(table)
	esttab matrix(results) using table12mean_c.csv, nomtitles replace

}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12mean_c.csv, clear 

	*drop if _n == 28
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 26
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"

restore

}

matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

							
global crisk_outcomes $crisk_outcomes  `" crisk_index "'
global crisk_outcomes $crisk_outcomes  `" crisk_kling_poscost "'
global crisk_outcomes $crisk_outcomes  `" crisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $crisk_outcomes'
local n_rows = (`n_outcomes' - 5)*3
mat R=J(`n_rows',5,.)

* matrix to store asinh outcomes for graphs
mat Rasinh=J(6,5,.)

local n = 0
local ng = 0

foreach y in $crisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_crisk_`n'
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
		global main_reg $main_reg reg_crisk_`n'
	}
	else {
		global appendix_reg $appendix_reg reg_crisk_`n'
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
	text(0.5 1.5 "Risk") text(0.5 3.5 "Econ") text(0.5 5.5 "Combined")

graph save Graph ${main}/Draft/figures/figure20mean_c.gph, replace
graph export ${main}/Draft/figures/figure20mean_c.png, replace

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
	text(0.5 1.5 "Risk") text(0.5 3.5 "Econ") text(0.5 5.5 "Combined")
	
graph save Graph ${main}/Draft/figures/figure21mean_c.gph, replace
graph export ${main}/Draft/figures/figure21mean_c.png , replace

restore



preserve

clear
svmat R
			
la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Beaten" 2 "Forced Work" 3 "Kidnapped" ///
	4 "Death aft. boat" 5 "Death boat" 6 "Sent Back" ///
	7 "Beaten" 8 "Forced Work" 9 "Kidnapped" ///
	10 "Death aft. boat" 11 "Death boat" 12 "Sent Back" ///
	13 "Beaten" 14 "Forced Work" 15 "Kidnapped" ///
	16 "Death aft. boat" 17 "Death boat" 18 "Sent Back" 
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
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Combined")

graph save Graph ${main}/Draft/figures/figure14mean_c.gph, replace
graph export ${main}/Draft/figures/figure14mean_c.png, replace

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
text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Combined")

graph save Graph ${main}/Draft/figures/figure15mean_c.gph, replace
graph export ${main}/Draft/figures/figure15mean_c.png , replace

restore


esttab $main_reg using ///
	"table12mean_c.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
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
	
global crisk_outcomes = " asinhcrisk_duration_winsor " ///
						+ " crisk_beaten " ///
						+ " crisk_forced_work " ///
						+ " asinhcrisk_journey_cost_winsor  " ///
						+ " crisk_kidnapped " ///
						+ " crisk_die_bef_boat " ///
						+ " crisk_die_boat " ///
						+ " crisk_sent_back "


local n_outcomes `: word count $crisk_outcomes'

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
/*
di "indexes:"
foreach var of varlist $crisk_outcomes {
	di "  - `var'"
}	
*/

if (`makefwer' == 1) {
	
preserve
drop if time == 2
drop if time == 1 & l1.attended_tr == .
drop if time == 0 & attended_tr == .



wyoung $crisk_outcomes, cmd(areg OUTCOMEVAR treated `controls_bl' CONTROLVARS  , ///
	cluster(schoolid) a(strata)) familyp(treated) ///
	controls($crisk_outcomes_bl) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

matrix define results = r(table)
esttab matrix(results) using table12meanany_c.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12meanany_c.csv, clear 

	*drop if _n == 12
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 10
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}


matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
 

***********************************KLING***********************************

							
global crisk_outcomes $crisk_outcomes  `" crisk_index "'
global crisk_outcomes $crisk_outcomes  `" crisk_kling_poscost "'
global crisk_outcomes $crisk_outcomes  `" crisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $crisk_outcomes'
local n_rows = (`n_outcomes' - 5)
mat R=J(`n_rows',5,.)

local n = 0
local ng = 0

foreach y in $crisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = p_FWER[`n',1]
	matrix colnames pfwer = x
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y x strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_crisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
			
	if (`n' < 9) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 10) {
		global main_reg $main_reg reg_crisk_`n'
	}
	else {
		global appendix_reg $appendix_reg reg_crisk_`n'
	}
	

}

preserve


		esttab $main_reg using ///
			"table12meanany_c.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
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


					
*________________________NEW_END


*/
*/




* WITH INTERACTIONS CONTACT_EU



gen T1contact_eu = T1*contact_eu
gen T2contact_eu = T2*contact_eu
gen T3contact_eu = T3*contact_eu
gen treatedcontact_eu = treated*contact_eu


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

	wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu  contact_eu `controls_bl' CONTROLVARS  , ///
		cluster(schoolid) a(strata)) familyp(T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu ) ///
		controls($mrisk_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	matrix define results = r(table)
	esttab matrix(results) using table12meaneu.csv, nomtitles replace

}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12meaneu.csv, clear 

	*drop if _n == 28
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 26
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"

restore

}

matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
matrix define p_FWER1c =  results[(3*`n_outcomes'+1)..4*`n_outcomes',"pwyoung"]
matrix define p_FWER2c =  results[(4*`n_outcomes'+1)..5*`n_outcomes',"pwyoung"]
matrix define p_FWER3c =  results[(5*`n_outcomes'+1)..6*`n_outcomes',"pwyoung"]
	
	
***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)*3

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1], p_FWER1c[`n',1], p_FWER2c[`n',1], p_FWER3c[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x i.x#i.contact_eu i.contact_eu strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_mrisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	
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


	}









esttab $main_reg using ///
	"table12meaneu.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu) collabels(,none) substitute(\_ _) ///
	replace ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
	2.x#1.contact_eu ///
	"\(T1\) - Risk \(*\) Contacts in the EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU" ///
	4.x#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	stats(space  N cont, fmt( s a2 a2) ///
	labels(`" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
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



wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR treated treatedcontact_eu contact_eu `controls_bl' CONTROLVARS  , ///
	cluster(schoolid) a(strata)) familyp(treated treatedcontact_eu) ///
	controls($mrisk_outcomes_bl) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

matrix define results = r(table)
esttab matrix(results) using table12meananyeu.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12meananyeu.csv, clear 

	*drop if _n == 12
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 10
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}


matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWERc =  results[(`n_outcomes' + 1)..2*`n_outcomes',"pwyoung"] 

***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = [p_FWER[`n',1], p_FWERc[`n',1]]
	matrix colnames pfwer = 1.x 1.x#1.contact_eu
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y i.x i.x#i.contact_eu i.contact_eu strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
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
			"table12meananyeu.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
			keep(1.x 1.x#1.contact_eu) collabels(,none) substitute(\_ _) ///
			replace  ///
			coeflabels(1.x "Any treatment" 1.x#1.contact_eu "Any treatment \(*\) Contacts in the EU" strata "Big school" ///
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

wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu  contact_eu `controls_bl' CONTROLVARS, ///
	cluster(schoolid) a(strata)) familyp(T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu  contact_eu) ///
	controls($economic_outcomes_bl) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

restore

* drop auxiliary lag variables

matrix define results = r(table)
esttab matrix(results) using table13compeu.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13compeu.csv, clear 

	*drop if _n == 31
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 29
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}
	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
matrix define p_FWER1c =  results[(3*`n_outcomes'+1)..4*`n_outcomes',"pwyoung"]
matrix define p_FWER2c =  results[(4*`n_outcomes'+1)..5*`n_outcomes',"pwyoung"]
matrix define p_FWER3c =  results[(5*`n_outcomes'+1)..6*`n_outcomes',"pwyoung"]
	
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
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1], p_FWER1c[`n',1], p_FWER2c[`n',1], p_FWER3c[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x##i.contact_eu strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	

	
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

		
	



	


esttab  $main_reg using ///
	"table13compeu.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
	2.x#1.contact_eu "\(T1\) - Risk \(*\) Contacts in the EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU" ///
	4.x#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	stats(space  N cont, fmt(s a2 a2) ///
	labels(`" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
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

	wyoung $economic_outcomes, cmd(areg OUTCOMEVAR treated treatedcontact_eu `controls_bl' CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(treated treatedcontact_eu) ///
		controls($economic_outcomes_bl) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	* drop auxiliary lag variables

	matrix define results = r(table)
	esttab matrix(results) using table13companyeu.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13companyeu.csv, clear 

	*drop if _n == 13
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 11
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}

matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWERc =  results[(`n_outcomes' + 1)..2*`n_outcomes',"pwyoung"] 

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
	matrix pfwer = [p_FWER[`n',1], p_FWERc[`n',1]]
	matrix colnames pfwer = 1.x 1.x#1.contact_eu
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y i.x i.x#i.contact_eu i.contact_eu strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
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
	"table13companyeu.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(1.x 1.x#1.contact_eu) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Any treatment" 1.x#1.contact_eu "Any treatment \(*\) Contacts in the EU")  ///
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
	qui reg f.y i.treated##i.contact_eu strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	est sto reg`n'	
	drop y
}

esttab reg* using ///
	"table14aeu.tex",  se ///
	 keep(1.treated 1.treated#1.contact_eu 1.contact_eu) collabels(,none) substitute(\_ _) ///
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
	qui reg f.y i.treatment_status##i.contact_eu strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)

	estadd local space " "

	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)

	est sto reg`n'
	drop y
}
	
esttab  reg* using ///
	"table14beu.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.treatment_status 3.treatment_status 4.treatment_status 2.treatment_status#1.contact_eu 3.treatment_status#1.contact_eu 4.treatment_status#1.contact_eu) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(2.treatment_status ///
	"\(T1\) - Risk" 3.treatment_status "\(T2\) - Econ" ///
	4.treatment_status "\(T3\) - Combined" ///
	2.treatment_status#1.contact_eu ///
	"\(T1\) - Risk \(*\) Contact in the EU" 3.treatment_status#1.contact_eu "\(T2\) - Econ \(*\) Contact in the EU" ///
	4.treatment_status#1.contact_eu "\(T3\) - Combined \(*\) Contact in the EU")  ///
	stats( space  N cont, fmt( s a2 a2) ///
	labels( `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

	



































* WITH INTERACTIONS CONTACT_EU AND LAGGED DEPENDENT


gen T1contact_eu = T1*contact_eu
gen T2contact_eu = T2*contact_eu
gen T3contact_eu = T3*contact_eu
gen treatedcontact_eu = treated*contact_eu


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

						
						




foreach var in $mrisk_outcomes {
	gen l1`var' = l.`var'
	
	gen tr`var' = treated*l.`var'	
	
	gen T1`var' = T1*l.`var'	
	gen T2`var' = T2*l.`var'
	gen T3`var' = T3*l.`var'
	
	local l`var'  " l1`var' T1`var' T2`var' T3`var'  "
}




global mrisk_outcomes_bl " "
foreach var in $mrisk_outcomes {
	global mrisk_outcomes_bl `$mrisk_outcomes_bl' " l1`var' T1 T2 T3 T1`var' T2`var' T3`var'  "
}


foreach var in $mrisk_outcomes {
	local `var'i  T1 T2 T3 T1`var' T2`var' T3`var' T1contact_eu T2contact_eu T3contact_eu 
}




gen l1contact_eu = l1.contact_eu

local n_outcomes `: word count $mrisk_outcomes'

* run all regressions and store results 
di "starting the computation of FWER-adjusted p-values"
di "indexes:"
foreach var of varlist $mrisk_outcomes {
	di "  - `var'"
}	


foreach var in $mrisk_outcomes {
	local `var's "areg `var' T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu  l1`var' T1`var' T2`var' T3`var' l1contact_eu `controls_bl'  $mrisk_outcomes_bl , cluster(schoolid) a(strata) "
}



if (`makefwer' == 1) {
	
	preserve
	drop if time == 2
	drop if time == 1 & l1.attended_tr == .
	drop if time == 0 & attended_tr == .
	
	wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu  l1contact_eu `controls_bl' CONTROLVARS  , ///
	cluster(schoolid) a(strata)) familyp(T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu ) ///
	controls("l1asinhmrisk_duration_winsor T1asinhmrisk_duration_winsor T2asinhmrisk_duration_winsor T3asinhmrisk_duration_winsor" "l1mrisk_beaten T1mrisk_beaten T2mrisk_beaten T3mrisk_beaten" "l1mrisk_forced_work T1mrisk_forced_work T2mrisk_forced_work T3mrisk_forced_work" "l1asinhmrisk_journey_cost_winsor T1asinhmrisk_journey_cost_winsor T2asinhmrisk_journey_cost_winsor T3asinhmrisk_journey_cost_winsor" "l1mrisk_kidnapped T1mrisk_kidnapped T2mrisk_kidnapped T3mrisk_kidnapped" "l1mrisk_die_bef_boat T1mrisk_die_bef_boat T2mrisk_die_bef_boat T3mrisk_die_bef_boat" "l1mrisk_die_boat T1mrisk_die_boat T2mrisk_die_boat T3mrisk_die_boat" "l1mrisk_sent_back T1mrisk_sent_back T2mrisk_sent_back T3mrisk_sent_back") ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)


	restore

	matrix define results = r(table)
	esttab matrix(results) using table12meaneuintt.csv, nomtitles replace

}



if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12meaneuintt.csv, clear 

	*drop if _n == 28
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 26
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"

restore

}

matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
matrix define p_FWER1c =  results[(3*`n_outcomes'+1)..4*`n_outcomes',"pwyoung"]
matrix define p_FWER2c =  results[(4*`n_outcomes'+1)..5*`n_outcomes',"pwyoung"]
matrix define p_FWER3c =  results[(5*`n_outcomes'+1)..6*`n_outcomes',"pwyoung"]



	
	
***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)*3

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1], p_FWER1c[`n',1], p_FWER2c[`n',1], p_FWER3c[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu 
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x i.x#i.contact_eu i.x#c.y  i.contact_eu strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_mrisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	
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


	}



esttab $main_reg using ///
	"table12meaneuintt.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu 2.x#c.y 3.x#c.y 4.x#c.y) collabels(,none) substitute(\_ _) ///
	replace ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
	2.x#1.contact_eu ///
	"\(T1\) - Risk \(*\) Contacts in the EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU" ///
	4.x#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU" strata "Big school" ///
	2.x#c.y ///
	"\(T1\) - Risk \(*\) Basel. outc." 3.x#c.y "\(T2\) - Econ \(*\) Basel. outc." ///
	4.x#c.y "\(T3\) - Combined \(*\) Basel. outc." ///
	y "Basel. outc." _cons "Constant")  ///
	stats(space  N cont, fmt( s a2 a2) ///
	labels(`" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
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



wyoung $mrisk_outcomes, cmd(areg OUTCOMEVAR treated treatedcontact_eu contact_eu `controls_bl' CONTROLVARS  , ///
	cluster(schoolid) a(strata)) familyp(treated treatedcontact_eu) ///
	controls("l1asinhmrisk_duration_winsor trasinhmrisk_duration_winsor" "l1mrisk_beaten trmrisk_beaten" "l1mrisk_forced_work trmrisk_forced_work " "l1asinhmrisk_journey_cost_winsor trasinhmrisk_journey_cost_winsor" "l1mrisk_kidnapped trmrisk_kidnapped" "l1mrisk_die_bef_boat trmrisk_die_bef_boat" "l1mrisk_die_boat trmrisk_die_boat" "l1mrisk_sent_back trmrisk_sent_back") ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	
restore

matrix define results = r(table)
esttab matrix(results) using table12meananyeuintt.csv, nomtitles replace
}



if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table12meananyeuintt.csv, clear 

	*drop if _n == 12
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 10
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}


matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWERc =  results[(`n_outcomes' + 1)..2*`n_outcomes',"pwyoung"] 
 

***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost "'

global risks_plot_list " "
global risks_plot_noasinh_list " "

local n_outcomes `: word count $mrisk_outcomes'
local n_rows = (`n_outcomes' - 5)

local n = 0
local ng = 0

foreach y in $mrisk_outcomes {

	local n = `n' + 1
	
	if (`n' < 9) {
	matrix pfwer = [p_FWER[`n',1], p_FWERc[`n',1]]
	matrix colnames pfwer = 1.x 1.x#1.contact_eu
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y i.x i.x#i.contact_eu i.x#c.y i.contact_eu strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
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
			"table12meananyeuintt.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
			keep(1.x 1.x#1.contact_eu 1.x#c.y) collabels(,none) substitute(\_ _) ///
			replace  ///
			coeflabels(1.x "Any treatment" 1.x#1.contact_eu "Any treatment \(*\) Contacts in the EU" strata "Big school" ///
			1.x#c.y "Any treatment \(*\) Basel. outc." ///
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
	
	gen tr`var' = treated*l.`var'	
	
	gen T1`var' = T1*l.`var'	
	gen T2`var' = T2*l.`var'
	gen T3`var' = T3*l.`var'
	
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




	wyoung $economic_outcomes, cmd(areg OUTCOMEVAR T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu  l1contact_eu `controls_bl' CONTROLVARS  , ///
	cluster(schoolid) a(strata)) familyp(T1 T2 T3 T1contact_eu T2contact_eu T3contact_eu ) ///
	controls(" l1finding_job trfinding_job" " l1asinhexpectation_wage_winsor trasinhexpectation_wage_winsor" " l1continuing_studies trcontinuing_studies" " l1asylum trasylum" " l1becoming_citizen trbecoming_citizen" " l1return_5yr trreturn_5yr" " l1government_financial_help trgovernment_financial_help" " l1asinhexp_liv_cost_winsor trasinhexp_liv_cost_winsor " " l1in_favor_of_migration trin_favor_of_migration"  ) ///
	bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)


restore

* drop auxiliary lag variables

matrix define results = r(table)
esttab matrix(results) using table13compeuintt.csv, nomtitles replace
}



if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13compeuintt.csv, clear 

	*drop if _n == 31
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 29
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}
	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
matrix define p_FWER1c =  results[(3*`n_outcomes'+1)..4*`n_outcomes',"pwyoung"]
matrix define p_FWER2c =  results[(4*`n_outcomes'+1)..5*`n_outcomes',"pwyoung"]
matrix define p_FWER3c =  results[(5*`n_outcomes'+1)..6*`n_outcomes',"pwyoung"]



	
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
	matrix pfwer = [p_FWER1[`n',1], p_FWER2[`n',1], p_FWER3[`n',1], p_FWER1c[`n',1], p_FWER2c[`n',1], p_FWER3c[`n',1]]
	matrix colnames pfwer = 2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu
	}
	
	gen y = `y'
	gen x = treatment_status
	qui reg f.y i.x##i.contact_eu i.x##c.y strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	

	
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

		

esttab  $main_reg using ///
	"table13compeuintt.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x 2.x#1.contact_eu 3.x#1.contact_eu 4.x#1.contact_eu  2.x#c.y 3.x#c.y 4.x#c.y) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
	2.x#1.contact_eu "\(T1\) - Risk \(*\) Contacts in the EU" 3.x#1.contact_eu "\(T2\) - Econ \(*\) Contacts in the EU" ///
	4.x#1.contact_eu "\(T3\) - Combined \(*\) Contacts in the EU" strata "Big school" ///
	2.x#c.y ///
	"\(T1\) - Risk \(*\) Basel. outc." 3.x#c.y "\(T2\) - Econ \(*\) Basel. outc." ///
	4.x#c.y "\(T3\) - Combined \(*\) Basel. outc." ///
	y "Basel. outc." _cons "Constant")  ///
	stats(space  N cont, fmt(s a2 a2) ///
	labels(`" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
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

	wyoung $economic_outcomes, cmd(areg OUTCOMEVAR treated treatedcontact_eu `controls_bl' CONTROLVARS, ///
		cluster(schoolid) a(strata)) familyp(treated treatedcontact_eu) ///
		controls(" l1finding_job trfinding_job" " l1asinhexpectation_wage_winsor trasinhexpectation_wage_winsor" " l1continuing_studies trcontinuing_studies" " l1asylum trasylum" " l1becoming_citizen trbecoming_citizen" " l1return_5yr trreturn_5yr" " l1government_financial_help trgovernment_financial_help" " l1asinhexp_liv_cost_winsor trasinhexp_liv_cost_winsor " " l1in_favor_of_migration trin_favor_of_migration" ) ///
		bootstraps(`n_rep') seed(`seed') strata(strata) cluster(schoolid)

	restore

	* drop auxiliary lag variables

	matrix define results = r(table)
	esttab matrix(results) using table13companyeuintt.csv, nomtitles replace
}

if (`makefwer' == 0) {
preserve	

	import delimited  ${main}/Draft/tables/table13companyeuintt.csv, clear 

	*drop if _n == 13
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 11
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}

matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWERc =  results[(`n_outcomes' + 1)..2*`n_outcomes',"pwyoung"] 
 

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
	matrix pfwer = [p_FWER[`n',1], p_FWERc[`n',1]]
	matrix colnames pfwer = 1.x 1.x#1.contact_eu
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y i.x i.x#i.contact_eu i.x#c.y i.contact_eu strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
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
	"table13companyeuintt.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(1.x 1.x#1.contact_eu 1.x#c.y) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Any treatment" 1.x#1.contact_eu "Any treatment \(*\) Contacts in the EU" 1.x#c.y "Any treatment \(*\) Basel. outc.")  ///
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
	qui reg f.y i.treated##i.contact_eu i.treated##c.y strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	est sto reg`n'
	drop y
}

esttab reg* using ///
	"table14aeuintt.tex",  se ///
	 keep(1.treated 1.treated#1.contact_eu 1.treated#c.y 1.contact_eu) collabels(,none) substitute(\_ _) ///
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
	qui reg f.y i.treatment_status##i.contact_eu  i.treatment_status##c.y  strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)

	estadd local space " "

	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)

	est sto reg`n'
	drop y
}
	
esttab  reg* using ///
	"table14beuintt.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.treatment_status 3.treatment_status 4.treatment_status 2.treatment_status#1.contact_eu 3.treatment_status#1.contact_eu 4.treatment_status#1.contact_eu 2.treatment_status#c.y 3.treatment_status#c.y 4.treatment_status#c.y) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(2.treatment_status ///
	"\(T1\) - Risk" 3.treatment_status "\(T2\) - Econ" ///
	4.treatment_status "\(T3\) - Combined" ///
	2.treatment_status#1.contact_eu ///
	"\(T1\) - Risk \(*\) Contact in the EU" 3.treatment_status#1.contact_eu "\(T2\) - Econ \(*\) Contact in the EU" ///
	4.treatment_status#1.contact_eu "\(T3\) - Combined \(*\) Contact in the EU"  ///
	"\(T1\) - Risk \(*\) Basel. Outc." 3.treatment_status#c.y "\(T2\) - Econ \(*\) Basel. Outc." ///
	4.treatment_status#c.y "\(T3\) - Combined \(*\) Basel. Outc.") ///
	stats( space  N cont, fmt( s a2 a2) ///
	labels( `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 


	
















*/




global economic_titles = `" "\qquad \Shortstack{1em}{(1) \\ Econ \\ Index \\ \vphantom{foo}} \qquad \qquad" "'   ///
			+ `" " \Shortstack{1em}{(2)\\ Finding \\ Job \\ \vphantom{foo}} " "' ///
			+ `" "\Shortstack{1em}{(3)\\ Contin. \\ studies \\ abroad}" "' ///
			+ `" "\Shortstack{1em}{(4) \\ Getting \\ asylum \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(5)\\ Becom. \\ Citizen \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(6)\\ Return \\ before \\ 5 yrs}" "' ///
			+ `" "\Shortstack{1em}{(7)\\ Getting \\ public \\ transf. }""' ///
			+ `" "\Shortstack{1em}{(8) \\ Host \\ country \\ attit.}" "' ///
			+ `"  "\Shortstack{1em}{(9)\\ Wage \\ abroad \\ \vphantom{foo}}" "' ///
			+ `" "\Shortstack{1em}{(10) \\  Cost of \\ living \\ abroad}" "'

											
								
global appendix_table_titles =  `" "\Shortstack{1em}{(1) \\ Kling \\ Cost- \\ Ita }" "'  ///
								+ `" "\Shortstack{1em}{(2) \\ Kling \\ Cost+ \\ Ita }" "' ///
								+ `" "\Shortstack{1em}{(3) \\ Kling \\ Cost- \\ Spa }" "' ///
								+ `" "\Shortstack{1em}{(4) \\ Kling \\ Cost+ \\ Spa }" "' ///
								+ `" "\Shortstack{1em}{(5) \\ Kling \\ Econ \\ \vphantom{foo}}" "'
				
			

global risks_table_titles = `" "\qquad \Shortstack{1em}{(1) \\ Risk \\ Index \\ \vphantom{foo}}  \qquad \qquad" "'  ///
				+ `" " \Shortstack{1em}{(2)\\ Being \\ Beaten \\ \vphantom{foo}}" "' ///
				+ `" "\Shortstack{1em}{(3)\\ Forced \\  to \\ Work}" "' /// 
				+ `" "\Shortstack{1em}{(4) \\ Being \\ Kidnap- \\ ped}" "' ///
				+ `" "\Shortstack{1em}{(5)\\ Death \\ before \\ Sea}" "' ///
				+ `" "\Shortstack{1em}{(6)\\ Death \\ at \\ Sea}" "' /// 
				+ `" "\Shortstack{1em}{(7)\\ Sent \\ Back \\ \vphantom{foo}}" "' ///
				+ `" " \Shortstack{1em}{(8) \\ Journey\\ Cost \\ \vphantom{foo}}" "' ///
				+  `" " \Shortstack{1em}{(9) \\ Journey \\ Duration \\ \vphantom{foo}}" "'

global mrisk_outcomes =  " mrisk_beaten " ///
						+ " mrisk_forced_work " ///
						+ " mrisk_kidnapped " ///
						+ " mrisk_die_bef_boat " ///
						+ " mrisk_die_boat " ///
						+ " mrisk_sent_back " ///
						+ " asinhmrisk_journey_cost_winsor  " ///
						+ " asinhmrisk_duration_winsor "
						
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
						
global mrisk_outcomes =  " mrisk_beaten " ///
						+ " mrisk_forced_work " ///
						+ " mrisk_kidnapped " ///
						+ " mrisk_die_bef_boat " ///
						+ " mrisk_die_boat " ///
						+ " mrisk_sent_back " ///
						+ " asinhmrisk_journey_cost_winsor  " ///
						+ " asinhmrisk_duration_winsor "
						



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

	import delimited  ${main}/Draft/tables/table12mean.csv, stripquote(yes) clear 

	*drop if _n == 28
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 26

	*destring v15, replace
	*mkmat v15, matrix(results)
	
	*drop if _n == 1
	*rename v5 pwyoung
	*replace pwyoung = subinstr(pwyoung, "=", "", 1)
	*destring pwyoung, replace
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"

restore

}

matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

							
global mrisk_outcomes  mrisk_index  $mrisk_outcomes
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
	
	if (`n' > 1)&(`n' < 10) {
	matrix pfwer = [p_FWER1[`n'-1,1], p_FWER2[`n'-1,1], p_FWER3[`n'-1,1]]
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
	
	local individual "Yes"
	local school "Yes"

	estadd local space " "

	estadd local individual = "`individual'"
	estadd local school = "`school'"
		
		
	if (`n' > 1)&(`n' < 10) {
	estadd matrix pfwer = pfwer
	}
	drop y
	
	if (`n' < 10) {
		global main_reg $main_reg reg_mrisk_`n'
	}
	else {
		global appendix_reg $appendix_reg reg_mrisk_`n'
	}
	
if (`n' > 1)&(`n' <8) {
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
	
	if (`n' == 8)|(`n' == 9) {
	local n_treat=1

	if (`n' == 8) {
		local ngasinh 1
	}
	
	if (`n' == 9) {
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
	text(0.5 1.5 "Risk") text(0.5 3.5 "Econ") text(0.5 5.5 "Combined")

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
	text(0.5 1.5 "Risk") text(0.5 3.5 "Econ") text(0.5 5.5 "Combined")
	
graph save Graph ${main}/Draft/figures/figure21mean.gph, replace
graph export ${main}/Draft/figures/figure21mean.png , replace

restore



preserve

clear
svmat R
			
la var R4 Outcome
la var R1 "Effect"
label define groups 1 "Beaten" 2 "Forced Work" 3 "Kidnapped" ///
	4 "Death aft. boat" 5 "Death boat" 6 "Sent Back" ///
	7 "Beaten" 8 "Forced Work" 9 "Kidnapped" ///
	10 "Death aft. boat" 11 "Death boat" 12 "Sent Back" ///
	13 "Beaten" 14 "Forced Work" 15 "Kidnapped" ///
	16 "Death aft. boat" 17 "Death boat" 18 "Sent Back" 
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
	text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Combined")

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
text(17 3.5 "Risk") text(17 9.5 "Econ") text(17 15.5 "Combined")

graph save Graph ${main}/Draft/figures/figure15mean.gph, replace
graph export ${main}/Draft/figures/figure15mean.png , replace

restore



preserve

clear
svmat R


gen new_R4 = .

replace new_R4 = 20.5 if R4 == 18
replace new_R4 = 19.5 if R4 == 12
replace new_R4 = 18.5 if R4 == 6

replace new_R4 = 17 if R4 == 17
replace new_R4 = 16 if R4 == 11
replace new_R4 = 15 if R4 == 5

replace new_R4 = 13.5 if R4 == 16
replace new_R4 = 12.5 if R4 == 10
replace new_R4 = 11.5 if R4 == 4

replace new_R4 = 10 if R4 == 15
replace new_R4 = 9 if R4 == 9
replace new_R4 = 8 if R4 == 3

replace new_R4 = 6.5 if R4 == 14
replace new_R4 = 5.5 if R4 == 8
replace new_R4 = 4.5 if R4 == 2

replace new_R4 = 3 if R4 == 13
replace new_R4 = 2 if R4 == 7
replace new_R4 = 1 if R4 == 1

replace R4 = new_R4*2
drop new_R4
			
la var R4 Outcome
la var R1 "Effect"
label define groups 2 "Risk" 4 "Econ" 6 "Combined" ///
	 9 "Risk" 11 "Econ" 13 "Combined" ///
	 16 "Risk" 18 "Econ" 20 "Combined" ///
	 23 "Risk" 25 "Econ" 27 "Combined" ///
	 30 "Risk" 32 "Econ" 34 "Combined" ///
	 37 "Risk" 39 "Econ" 41 "Combined" 
label values R4 groups
la var R5 "p_fwer"




set scheme s2mono
	
twoway (bar R1 R4, barw(1.2) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(2 4 6 9 11 13 16 18 20 23 25 27 30 32 34 37 39 41, valuelabel angle(45)) 	///
graphregion(color(white)) ///
xline(7.5, lpattern(-) lcolor(black)) 	///
xline(14.5, lpattern(-) lcolor(black)) 	///
xline(21.5, lpattern(-) lcolor(black)) 	///
xline(28.5, lpattern(-) lcolor(black)) 	///
xline(35.5, lpattern(-) lcolor(black)) 	///
ytitle(Treatment effect) ///
ylabel(0(3)18) ///
text(17 4 "Beaten") text(17.5 11 "Forced") text(16.5 11 "work") /// 
text(17 18 "Kidnapped") text(17.5 25 "Death") text(16.5 25 "bef. boat") ///
text(17.5 32 "Death") text(16.5 32 "in sea") ///
text(17.5 39 "Sent")  text(16.5 39 "back")

graph save Graph ${main}/Draft/figures/figure14mean_byout.gph, replace
graph export ${main}/Draft/figures/figure14mean_byout.png, replace

*fwer
twoway (bar R1 R4, barw(1.2) fi(inten30) lc(black) lw(medium) ) ///
(bar R1 R4 if R5 < 0.05, barw(1.2) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(2 4 6 9 11 13 16 18 20 23 25 27 30 32 34 37 39 41, valuelabel angle(45)) 	///
graphregion(color(white)) ///
xline(7.5, lpattern(-) lcolor(black)) 	///
xline(14.5, lpattern(-) lcolor(black)) 	///
xline(21.5, lpattern(-) lcolor(black)) 	///
xline(28.5, lpattern(-) lcolor(black)) 	///
xline(35.5, lpattern(-) lcolor(black)) 	///
ytitle(Treatment effect) ///
ylabel(0(3)18) ///
text(17 4 "Beaten") text(17.5 11 "Forced") text(16.5 11 "work") /// 
text(17 18 "Kidnapped") text(17.5 25 "Death") text(16.5 25 "bef. boat") ///
text(17.5 32 "Death") text(16.5 32 "in sea") ///
text(17.5 39 "Sent")  text(16.5 39 "back")

graph save Graph ${main}/Draft/figures/figure15mean_byout.gph, replace
graph export ${main}/Draft/figures/figure15mean_byout.png , replace

restore






esttab $main_reg using ///
	"table12mean.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
	stats(pre prd ped space individual school N cont, fmt(s s s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "' `"Individual controls"'  `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 

estimates drop $main_reg 


*any treatment

global main_reg " "
	
global mrisk_outcomes =  " mrisk_beaten " ///
						+ " mrisk_forced_work " ///
						+ " mrisk_kidnapped " ///
						+ " mrisk_die_bef_boat " ///
						+ " mrisk_die_boat " ///
						+ " mrisk_sent_back " ///
						+ " asinhmrisk_journey_cost_winsor  " ///
						+ " asinhmrisk_duration_winsor "


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

	*import delimited  ${main}/Draft/tables/table12meanany.csv, clear 

	*drop if _n == 12
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 10
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	*matrix  colnames results = "pwyoung"
	
	import delimited  ${main}/Draft/tables/table12meanany.csv, stripquote(yes) clear 
	*drop if _n == 1
	*rename v5 pwyoung
	*replace pwyoung = subinstr(pwyoung, "=", "", 1)
	*destring pwyoung, replace
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}


matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
 

***********************************KLING***********************************

							
global mrisk_outcomes mrisk_index $mrisk_outcomes
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
	
	if (`n' > 1)&(`n' < 10) {
	matrix pfwer = p_FWER[`n'-1,1]
	matrix colnames pfwer = x
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y x strata `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_mrisk_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
			
	if (`n' > 1)&(`n' < 10) {
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
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " in_favor_of_migration " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " asinhexp_liv_cost_winsor " 
						
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

	*import delimited  ${main}/Draft/tables/table13comp.csv, clear 
	*drop if _n == 31
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 29
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	*matrix  colnames results = "pwyoung"
	
	import delimited  ${main}/Draft/tables/table13comp.csv, stripquote(yes) clear 
	*drop if _n == 1
	*rename v5 pwyoung
	*replace pwyoung = subinstr(pwyoung, "=", "", 1)
	*destring pwyoung, replace
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}
	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
***********************************KLING***********************************

global economic_outcomes economic_index $economic_outcomes   economic_kling


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
	
	if (`n' > 1)&(`n' < 11) {
	matrix pfwer = [p_FWER1[`n'-1,1], p_FWER2[`n'-1,1], p_FWER3[`n'-1,1]]
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
	
	local individual "Yes"
	local school "Yes"

	estadd local space " "

	estadd local individual = "`individual'"
	estadd local school = "`school'"
		
	drop x
	est sto reg_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	if (`n' < 11) {
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
	if (`n' > 1)&(`n' < 9){
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
	
	if (`n' > 1)&(`n' < 9) {
	local n_treat=1

	if (`n' == 9) {
		local ngasinh 1
	}
	
	if (`n' == 10) {
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
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " in_favor_of_migration " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " asinhexp_liv_cost_winsor " 

		
		
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
	text(0.3 1.5 "Risk") text(0.3 3.5 "Econ") text(0.3 5.5 "Combined")

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
	text(0.3 1.5 "Risk") text(0.3 3.5 "Econ") text(0.3 5.5 "Combined")
	
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
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Combined")

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
	text(3 4 "Risk") text(3 11 "Econ") text(3 18 "Combined")

graph save Graph ${main}/Draft/figures/figure17.gph, replace
graph export ${main}/Draft/figures/figure17.png , replace
	
restore





preserve

clear
svmat R


gen new_R4 = .


replace new_R4 = 24 if R4 == 21
replace new_R4 = 23 if R4 == 14
replace new_R4 = 22 if R4 == 7

replace new_R4 = 20.5 if R4 == 20
replace new_R4 = 19.5 if R4 == 13
replace new_R4 = 18.5 if R4 == 6

replace new_R4 = 17 if R4 == 19
replace new_R4 = 16 if R4 == 12
replace new_R4 = 15 if R4 == 5

replace new_R4 = 13.5 if R4 == 18
replace new_R4 = 12.5 if R4 == 11
replace new_R4 = 11.5 if R4 == 4

replace new_R4 = 10 if R4 == 17
replace new_R4 = 9 if R4 == 10
replace new_R4 = 8 if R4 == 3

replace new_R4 = 6.5 if R4 == 16
replace new_R4 = 5.5 if R4 == 9
replace new_R4 = 4.5 if R4 == 2

replace new_R4 = 3 if R4 == 15
replace new_R4 = 2 if R4 == 8
replace new_R4 = 1 if R4 == 1

replace R4 = new_R4*2
drop new_R4
			
la var R4 Outcome
la var R1 "Effect"
label define groups 2 "Risk" 4 "Econ" 6 "Combined" ///
	 9 "Risk" 11 "Econ" 13 "Combined" ///
	 16 "Risk" 18 "Econ" 20 "Combined" ///
	 23 "Risk" 25 "Econ" 27 "Combined" ///
	 30 "Risk" 32 "Econ" 34 "Combined" ///
	 37 "Risk" 39 "Econ" 41 "Combined" /// 
	 44 "Risk" 46 "Econ" 48 "Combined" 
label values R4 groups
la var R5 "p_fwer"




set scheme s2mono
	
twoway (bar R1 R4, barw(1.2) fi(inten30) lc(black) lw(medium) ) ///
	(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(2 4 6 9 11 13 16 18 20 23 25 27 30 32 34 37 39 41 44 46 48, valuelabel angle(45)) 	///
graphregion(color(white)) ///
xline(7.5, lpattern(-) lcolor(black)) 	///
xline(14.5, lpattern(-) lcolor(black)) 	///
xline(21.5, lpattern(-) lcolor(black)) 	///
xline(28.5, lpattern(-) lcolor(black)) 	///
xline(35.5, lpattern(-) lcolor(black)) 	///
xline(42.5, lpattern(-) lcolor(black)) 	///
ytitle(Treatment effect) ///
ylabel(-15(5)5) ///
text(4.5 4 "Finding") text(3.5 4 "a job") text(4.5 11 "Contin.") text(3.5 11 "studies") /// 
text(4.5 18 "Obtaining")  text(3.5 18 "Asylum")  text(4.5 25 "Becoming") text(3.5 25 "citizen") ///
text(4.5 32 "Returning") text(3.5 32 "aft. 5yrs") ///
text(4.5 39 "Public")  text(3.5 39 "transfers") ///
text(5 46 "Host") text(4 46 "country")  text(3 46 "attitudes") ///

graph save Graph ${main}/Draft/figures/figure16_byout.gph, replace
graph export ${main}/Draft/figures/figure16_byout.png, replace

*fwer
twoway (bar R1 R4, barw(1.2) fi(inten30) lc(black) lw(medium) ) ///
(bar R1 R4 if R5 < 0.05, barw(1.2) fi(inten60) lc(black) color(eltblue) lw(medium)) ///
(rcap R3 R2 R4, lc(gs5))	, ///
legend(off) xlabel(2 4 6 9 11 13 16 18 20 23 25 27 30 32 34 37 39 41 44 46 48, valuelabel angle(45)) 	///
graphregion(color(white)) ///
xline(7.5, lpattern(-) lcolor(black)) 	///
xline(14.5, lpattern(-) lcolor(black)) 	///
xline(21.5, lpattern(-) lcolor(black)) 	///
xline(28.5, lpattern(-) lcolor(black)) 	///
xline(35.5, lpattern(-) lcolor(black)) 	///
xline(42.5, lpattern(-) lcolor(black)) 	///
ytitle(Treatment effect) ///
ylabel(-15(5)5) ///
text(4.5 4 "Finding") text(3.5 4 "a job") text(4.5 11 "Contin.") text(3.5 11 "studies") /// 
text(4.5 18 "Obtaining")  text(3.5 18 "Asylum")  text(4.5 25 "Becoming") text(3.5 25 "citizen") ///
text(4.5 32 "Returning") text(3.5 32 "aft. 5yrs") ///
text(4.5 39 "Public")  text(3.5 39 "transfers") ///
text(5 46 "Host") text(4 46 "country")  text(3 46 "attitudes") ///

graph save Graph ${main}/Draft/figures/figure17_byout.gph, replace
graph export ${main}/Draft/figures/figure17_byout.png , replace

restore







esttab  $main_reg using ///
	"table13comp.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
	y "Basel. outc." _cons "Constant")  ///
stats(pre prd ped space individual school N cont, fmt(s s s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "' `"Individual controls"'  `"School controls"' `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &  & & & &  \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 



*econ outcomes at fu1 with controls testing different treatments
global economic_outcomes = " finding_job " ///
						+ " continuing_studies " /// 
						+ " asylum " ///
						+ " becoming_citizen " ///
						+ " return_5yr " ///
						+ " government_financial_help " ///
						+ " in_favor_of_migration " ///
						+ " asinhexpectation_wage_winsor " ///
						+ " asinhexp_liv_cost_winsor " 

		
		

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

	*import delimited  ${main}/Draft/tables/table13company.csv, stripquote(yes) clear 

	*drop if _n == 13
	*drop if _n == 3
	*drop if _n == 1
	*replace v1 = itrim(v1)
	*replace v1 = trim(v1)
	*replace v1 = "est coef stderr p pwyoung pbonf psidak" if v1 == "coef stderr p pwyoung pbonf psidak"
	*split v1, p(" ")
	*drop if _n == 11
	*drop if _n == 1
	*destring v15, replace
	*mkmat v15, matrix(results)
	*matrix  colnames results = "pwyoung"

	import delimited  ${main}/Draft/tables/table13company.csv, stripquote(yes) clear 
	*drop if _n == 1
	*rename v5 pwyoung
	*replace pwyoung = subinstr(pwyoung, "=", "", 1)
	*destring pwyoung, replace
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}

matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

global economic_outcomes economic_index $economic_outcomes  economic_kling


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
	
	if (`n' > 1)&(`n' < 11) {
	matrix pfwer = p_FWER[`n'-1,1]
	matrix colnames pfwer = x
	}
	
	gen y = `y'
	gen x = treated
	qui reg f.y x strata  `demographics' `school_char' y if attended_tr != . & time == 0, cluster(schoolid_str)
	drop x
	est sto reg_econ_`n'
	qui sum y if time == 1 & treatment_status == 1
	estadd scalar cont = r(mean)
	if(`n' > 1)&(`n' < 11)  {
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
	4.treatment_status "\(T3\) - Combined")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 


stop
	

* EXTENSIVE MARGIN VA RIFATTO DOPO MODIFICA CONTROLLI

* EXTENSIVE MARGIN

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

/*			
local controls_bl " " 
foreach var in `demographics' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
}
foreach var in `school_char' {
	gen l1`var' = l.`var'
	local controls_bl `controls_bl' " l1`var'"
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

foreach var in mrisk_index mrisk_kling_poscost mrisk_kling_negcost {
	gen `var'_i = `var' > l.`var' if  !missing(`var') & !missing(l.`var') & time == 1
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
	esttab matrix(results) using table12mean_inc.csv, nomtitles replace

}

if (`makefwer' == 0) {
preserve	

	* broken into columns by hand
	import delimited  ${main}/Draft/tables/table12mean_inc.csv, clear 

	/*
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
	*mkmat v15, matrix(results)
	*/
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"

restore

}

matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

							
global mrisk_outcomes $mrisk_outcomes  `" mrisk_index_i "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_poscost_i "'
global mrisk_outcomes $mrisk_outcomes  `" mrisk_kling_negcost_i "'

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
	4.x "\(T3\) - Combined" strata "Big school" ///
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

	/*
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
	*mkmat v15, matrix(results)
	*/
	mkmat pwyoung, matrix(results)
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

foreach var in economic_index economic_kling {
	gen `var'_i = `var' > l.`var' if  !missing(`var') & !missing(l.`var') & time == 1
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

	/*
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
	*mkmat v15, matrix(results)
	*/
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}
	
matrix define p_FWER1 =  results[1..`n_outcomes',"pwyoung"]
matrix define p_FWER2 =  results[(`n_outcomes'+1)..2*`n_outcomes',"pwyoung"]
matrix define p_FWER3 =  results[(2*`n_outcomes'+1)..3*`n_outcomes',"pwyoung"]
	
	
***********************************KLING***********************************

global economic_outcomes $economic_outcomes  economic_index_i  economic_kling_i


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






esttab  $main_reg using ///
	"table13comp_inc.tex",  cells(b(fmt(a2) star) se(par fmt(a2)) pfwer( fmt(2) par([ ]))) ///
	keep(2.x 3.x 4.x) collabels(,none) substitute(\_ _) ///
	replace   ///
	coeflabels(1.x "Control" 2.x ///
	"\(T1\) - Risk" 3.x "\(T2\) - Econ" ///
	4.x "\(T3\) - Combined" strata "Big school" ///
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

global economic_outcomes $economic_outcomes_i 

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

	/*
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
	*mkmat v15, matrix(results)
	*/
	mkmat pwyoung, matrix(results)
	matrix  colnames results = "pwyoung"
	
restore

}

matrix define p_FWER =  results[1..`n_outcomes',"pwyoung"]
	
***********************************KLING***********************************

global economic_outcomes $economic_outcomes  economic_index_i  economic_kling_i


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
	qui reg f.y x strata  `demographics' `school_char' if attended_tr != . & time == 0, cluster(schoolid_str)
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
	qui reg f.y treated strata  `demographics' `school_char' if attended_tr != . & time == 0, cluster(schoolid_str)
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
	4.treatment_status "\(T3\) - Combined")  ///
	stats(pre prd ped space  N cont, fmt(s s s s a2 a2) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"'  `" "'  `"\(N\)"'  `"Mean dep. var. control"')) ///
	 starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	nonumbers nomtitles /// 
	nobaselevels ///
	prehead("") posthead("  \\ \textbf{\textit{Panel (b)}}  & & &  &  &   \\ [1em]")    postfoot("\hline\hline \end{tabular}}") 
	



*DISTRIBUTIONS

* average between routes (any treatment)
twoway (kdensity mrisk_index if time == 1 & treatment_status == 1, graphregion(color(white)) lp(solid) lc(black)) ///
	(kdensity mrisk_index if time == 1 & treatment_status != 1, graphregion(color(white)) lp(dash) lc(black)), ///
	leg(off) ///
	xtitle("Risk beliefs (PCA)") ytitle("Density") name(riskdist, replace)
graph save  ${main}/Draft/figures/groupdists_risk_any.gph, replace
graph export ${main}/Draft/figures/groupdists_risk_any.png , replace
graph close

* kolmogorov-smirnov
ksmirnov mrisk_index if time == 1, by(treated)

* average between routes (separated by treatments)
twoway (kdensity mrisk_index if time == 1 & treatment_status == 1, graphregion(color(white)) lp(solid) lc(black)) ///
	(kdensity mrisk_index if time == 1 & treatment_status == 2, graphregion(color(white)) lp(dash) lc(green)) ///
	(kdensity mrisk_index if time == 1 & treatment_status == 3, graphregion(color(white)) lp(dash) lc(blue)) ///
	(kdensity mrisk_index if time == 1 & treatment_status == 4, graphregion(color(white)) lp(dash) lc(red)), ///
	leg(off) ///
	xtitle("Risk beliefs (PCA)") ytitle("Density") name(riskdist, replace)
graph save  ${main}/Draft/figures/groupdists_risk.gph, replace
graph export ${main}/Draft/figures/groupdists_risk.png , replace
graph close

* kolmogorov-smirnov
ksmirnov mrisk_index if time == 1 & (treatment_status == 1 | treatment_status == 2), by(treated)
ksmirnov mrisk_index if time == 1 & (treatment_status == 1 | treatment_status == 3), by(treated)
ksmirnov mrisk_index if time == 1 & (treatment_status == 1 | treatment_status == 4), by(treated)


* chosen route (any treatment)
twoway (kdensity crisk_index if time == 1 & treatment_status == 1, graphregion(color(white)) lp(solid) lc(black)) ///
	(kdensity crisk_index if time == 1 & treatment_status != 1, graphregion(color(white)) lp(dash) lc(black)), ///
	leg(off) ///
	xtitle("Risk beliefs (PCA)") ytitle("Density") name(riskdist, replace)
graph save  ${main}/Draft/figures/groupdists_risk_any_c.gph, replace
graph export ${main}/Draft/figures/groupdists_risk_any_c.png , replace
graph close

* kolmogorov-smirnov
ksmirnov crisk_index if time == 1, by(treated)

* chosen route (separated by treatments)
twoway (kdensity crisk_index if time == 1 & treatment_status == 1, graphregion(color(white)) lp(solid) lc(black)) ///
	(kdensity crisk_index if time == 1 & treatment_status == 2, graphregion(color(white)) lp(dash) lc(green)) ///
	(kdensity crisk_index if time == 1 & treatment_status == 3, graphregion(color(white)) lp(dash) lc(blue)) ///
	(kdensity crisk_index if time == 1 & treatment_status == 4, graphregion(color(white)) lp(dash) lc(red)), ///
	leg(off) ///
	xtitle("Risk beliefs (PCA)") ytitle("Density") name(riskdist, replace)
graph save  ${main}/Draft/figures/groupdists_risk_c.gph, replace
graph export ${main}/Draft/figures/groupdists_risk_c.png , replace
graph close

* kolmogorov-smirnov
ksmirnov crisk_index if time == 1 & (treatment_status == 1 | treatment_status == 2), by(treated)
ksmirnov crisk_index if time == 1 & (treatment_status == 1 | treatment_status == 3), by(treated)
ksmirnov crisk_index if time == 1 & (treatment_status == 1 | treatment_status == 4), by(treated)

* economic perceptions  (any treatment)
twoway (kdensity economic_index if time == 1 & treatment_status == 1, graphregion(color(white)) lp(solid) lc(black)) ///
	(kdensity economic_index if time == 1 & treatment_status != 2, graphregion(color(white)) lp(dash) lc(black)), ///
	leg(off) ///
	xtitle("Economic beliefs (PCA)") ytitle("Density") name(econdist, replace)
graph save  ${main}/Draft/figures/groupdists_econ_any.gph, replace
graph export ${main}/Draft/figures/groupdists_econ_any.png , replace
graph close

* kolmogorov-smirnov
ksmirnov economic_index if time == 1, by(treated)

* economic perceptions (separated by treatments)
twoway (kdensity economic_index if time == 1 & treatment_status == 1, graphregion(color(white)) lp(solid) lc(black)) ///
	(kdensity economic_index if time == 1 & treatment_status == 2, graphregion(color(white)) lp(dash) lc(green)) ///
	(kdensity economic_index if time == 1 & treatment_status == 3, graphregion(color(white)) lp(dash) lc(blue)) ///
	(kdensity economic_index if time == 1 & treatment_status == 4, graphregion(color(white)) lp(dash) lc(red)), ///
	leg(off) ///
	xtitle("Economic beliefs (PCA)") ytitle("Density") name(econdist, replace)
graph save  ${main}/Draft/figures/groupdists_econ.gph, replace
graph export ${main}/Draft/figures/groupdists_econ.png , replace
graph close

* kolmogorov-smirnov
ksmirnov economic_index if time == 1 & (treatment_status == 1 | treatment_status == 2), by(treated)
ksmirnov economic_index if time == 1 & (treatment_status == 1 | treatment_status == 3), by(treated)
ksmirnov economic_index if time == 1 & (treatment_status == 1 | treatment_status == 4), by(treated)






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
matrix rownames obs =  "\textbf{Baseline}: In-Person" "\textbf{Follow Up 1}: In-Person"  "\textbf{Endline}: In-Person" "\textbf{Endline}: Respondent (Phone)" "\textbf{Endline}: Contact (Phone)"   "\textbf{Endline}: School survey"  


esttab matrix(obs, fmt(%9.3g)) using apptable5.tex, style(tex) replace nomtitles postfoot(" \hline \hline \end{tabular}") ///
	prehead(" \begin{tabular}{l*{11}{c}} \hline \hline  &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)} &\multicolumn{1}{c}{(6)}&\multicolumn{1}{c}{(7)}&\multicolumn{1}{c}{(8)}&\multicolumn{1}{c}{(9)}&\multicolumn{1}{c}{(10)} \\ & \multicolumn{2}{c}{All}  & \multicolumn{2}{c}{Control}  & \multicolumn{2}{c}{\(T1\) - Risk}  & \multicolumn{2}{c}{\(T2\) - Econ} &  \multicolumn{2}{c}{\(T3\) - Combined} \\  ") substitute(\_ _) 

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

esttab regno* using apptable4.tex, replace keep(2.x 3.x 4.x) ///
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("\Shortstack{1em}{In-Person \\ Survey \\ \phantom{inv} \\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person \\ Survey \\ \phantom{inv} \\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact + \\ School Surv.}") ///
	stats(pre prd ped N meandep, fmt(s s s  0 3) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"' `"\(N\)"'  `"Mean dep. var. control"')) nonumbers ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{5}{c}{y = attrited at survey}  \\ &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}   \\ \cmidrule(lr){2-6}  &\multicolumn{1}{c}{\(1^{st}\) F.U.}&\multicolumn{4}{c}{Endline}  \\  \cmidrule(lr){2-2} \cmidrule(lr){3-6}")

restore


*/

*BALANCE

				
preserve
keep if attended_tr != .
keep if time == 0

balancetable (mean if treated_dummy1==1)  ///
	(diff treated_dummy2 if treated_dummy1 == 1 | treated_dummy2 == 1) ///
	(diff treated_dummy3 if ( treated_dummy1 == 1 | treated_dummy3 == 1)) ///
	(diff treated_dummy4 if (treated_dummy1 == 1 | treated_dummy4 == 1)) ///
	$bc_var_demo_red using "table1a.tex",  ///
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
	$bc_var_demo_red using "table1aall.tex",  ///
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
	"Combined-Control") replace varlabels vce(cluster schoolid) leftctitle(" ") ///

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
	"Combined-Control") replace varlabels vce(cluster schoolid) 

restore


/*

*ATTRITION PREDICTORS AT FIRST FOLLOW UP


			
preserve

	

eststo clear

		
forval i_con = 1/4 {
	

	qui sum no_1_1 if treatment_status == 1  &  f2.source_info_guinea < 6 & time == 0
	local meandep = `r(mean)'

	
	if `i_con' == 1 {
		local controls i.treatment_status
	}

	if `i_con' == 2 {
		local controls i.treatment_status $bc_var_outcomes
	}
	
	if `i_con' == 3 {
		local controls  i.treatment_status $bc_var_outcomes `demographics_red' durablesavg
	}
	if `i_con' == 4 {
		local controls i.treatment_status $bc_var_outcomes `demographics_red' durablesavg `school_char' strata
	}
	

	reg no_1_1 `controls'  if f2.source_info_guinea < 6 &  attended_tr != ., cluster(schoolid)

	
	local meandep = string(`meandep', "%9.2f")
	estadd local meandep = `"`meandep'\%"'
	
	eststo reg`i_est'_`i_con'

	
}




esttab reg* using attrition_pred.tex, replace label ///
	coeflabels(	strata "Big school")   se substitute(\_ _) long  starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) 
	
	
	
restore




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
	coeflabels(2.x "\(T1\) - Risk" 3.x "\(T2\) - Econ" 4.x "\(T3\) - Combined" /// 
	strata "Big school")   se substitute(\_ _) ///
	mtitles("\Shortstack{1em}{In-Person \\ Survey \\ \phantom{inv} \\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person \\ Survey \\ \phantom{inv} \\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ \phantom{inv} \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact \\ \phantom{inv}}" "\Shortstack{1em}{In-Person + \\ Phone Surv. \\ w/ Respond.\\ or Contact + \\ School Surv.}") ///
	stats(pre prd ped N meandep, fmt(s s s  0 3) ///
	labels(`"\emph{H0: \(T1\) = \(T2\) (p-value)}"' `"\emph{H0: \(T1\) = \(T3\) (p-value)}"' `"\emph{H0: \(T2\) = \(T3\) (p-value)}"' `"\(N\)"'  `"Mean dep. var. control"')) nonumbers ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") ///
	prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{5}{c}{y = attrited at survey}  \\ &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}   \\ \cmidrule(lr){2-6}  &\multicolumn{1}{c}{\(1^{st}\) F.U.}&\multicolumn{4}{c}{Endline}  \\  \cmidrule(lr){2-2} \cmidrule(lr){3-6}")

restore






****CHARACTERSITICS OF PERSONS WITH CONTACTS ABROAD

eststo clear
		
preserve

	



		
forval i_est = 1/2 {
	forval i_con = 1/2 {
		
		if `i_est' == 1 {
			gen y = contact_noeu*100
		}
		
		if `i_est' == 2 {
			gen y = contact_eu*100
		}
		
		qui sum y if treatment_status == 1  &  f2.source_info_guinea < 6 & time == 0
		local meandep = `r(mean)'


		
		if `i_con' == 1 {
			local controls   `demographics_red' durables
		}
		if `i_con' == 2 {
			local controls  `demographics_red' durables `school_char' strata
		}
		

		reg y `controls'  if f2.source_info_guinea < 6 &  attended_tr != ., cluster(schoolid)
		drop y

		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_est'_`i_con'

		
	}
}




esttab reg* using contacteu_chars.tex, replace label ///
	coeflabels(	strata "Big school")   se substitute(\_ _) long nomtitles nonumbers ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	postfoot("\hline\hline \end{tabular}") 		prehead("\begin{tabular}{l*{5}{c}} \hline\hline  &\multicolumn{5}{c}{y = contacts abroad} \\             &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}&\multicolumn{1}{c}{(4)}  \\ \cmidrule(lr){2-5} & \multicolumn{2}{c}{   \Shortstack{1em}{Contacts not \\ in the EU}   }&\multicolumn{2}{c}{\Shortstack{1em}{Contacts in \\ the EU}}&  \\  ")

restore
	
	
	





/*
/*
*/
****CHARACTERSITICS OF PERSONS WITH CONTACTS IN DIFFERENT EU STATES

			
preserve

	

eststo clear

		
forval i_country = 1/3 {
	forval i_con = 1/2 {
		
		if `i_country' == 1 {
			gen y = contact_ita
		}
		
		if `i_country' == 2 {
			gen y = contact_spa
		}
		
		if `i_country' == 3 {
			gen y = contact_fra
		}
				
		qui sum y if treatment_status == 1  &  f2.source_info_guinea < 6 & time == 0
		local meandep = `r(mean)'


		
		if `i_con' == 1 {
			local controls $bc_var_outcomes
		}
		
		if `i_con' == 2 {
			local controls $bc_var_outcomes `demographics_red' durablesavg `school_char' strata
		}
		

		reg y `controls'  if f2.source_info_guinea < 6 &  attended_tr != ., cluster(schoolid)
		drop y

		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_country'_`i_con'

		
	}
}




esttab reg* using contact_charsbycountry.tex, replace label ///
	coeflabels(	strata "Big school")   se substitute(\_ _) long ///
	mgroups("y = contacts in ITA" "y = contacts in SPA" "y = contacts in FRA", pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) nomtitles starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) 


restore




****CORRELATES OF RISK BELIEFS BY ROUTE

			
preserve

	

eststo clear

		
forval i_route = 1/2 {
	forval i_con = 1/3 {
		
		if `i_route' == 1 {
			gen y = italy_index
		}
		
		if `i_route' == 2 {
			gen y = spain_index
		}
		
				
		qui sum y if treatment_status == 1  &  f2.source_info_guinea < 6 & time == 0
		local meandep = `r(mean)'

		
		if `i_con' == 1 {
			local controls 
		}
		
		if `i_con' == 2 {
			local controls  desire planning prepare  `demographics_red' durablesavg
		}
		if `i_con' == 3 {
			local controls desire planning prepare  `demographics_red' durablesavg `school_char' strata
		}
		

		reg y contact_ita contact_spa contact_fra `controls'  if f2.source_info_guinea < 6 &  attended_tr != ., cluster(schoolid)
		drop y

		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_route'_`i_con'

		
	}
}




esttab reg* using riskcorrelates.tex, replace label ///
	coeflabels(	strata "Big school")   se substitute(\_ _) long ///
	mgroups("y = PCA Risk ITA" "y = PCA Risk SPA", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) nomtitles starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) 


restore

*/







****CORRELATES OF OPTIMISTIC BELIEFS

			
preserve

	

eststo clear

		
forval i_route = 1/2 {
	forval i_con = 1/3 {
		
		if `i_route' == 1 {
			gen y = italy_optimistic
		}
		
		if `i_route' == 2 {
			gen y = econ_optimistic
		}
		
				
		qui sum y if treatment_status == 1  &  f2.source_info_guinea < 6 & time == 0
		local meandep = `r(mean)'

		
		if `i_con' == 1 {
			local controls 
		}
		
		if `i_con' == 2 {
			local controls  desire planning prepare  `demographics_red' durablesavg
		}
		if `i_con' == 3 {
			local controls desire planning prepare  `demographics_red' durablesavg `school_char' strata
		}
		

		reg y contact_ita contact_spa contact_fra `controls'  if f2.source_info_guinea < 6 &  attended_tr != ., cluster(schoolid)
		drop y

		
		local meandep = string(`meandep', "%9.2f")
		estadd local meandep = `"`meandep'\%"'
		
		eststo reg`i_route'_`i_con'

		
	}
}




esttab reg* using optcorrelates.tex, replace label ///
	coeflabels(	strata "Big school")   se substitute(\_ _) long ///
	mgroups("y = Optimistic risk beliefs" "y = Optimistic econ beliefs", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span) nomtitles starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) 


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

m: migint = J(3,5,.)


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

/*
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

*/

m: st_matrix("migint", migint)
matrix migint = migint[1..3, 3..5]


matrix colnames migint =  "Plans"  "Prepares" "Obs"
matrix rownames migint =  "\textbf{Panel (a)\(\colon\) Our sample}: All, baseline"  "\textbf{Panel (b)\(\colon\) Afrobarometer, Guinea}: Young (18-21 years old)"   "\textbf{Guinea}: All"      

esttab matrix(migint, fmt(%9.2f)) using apptable6.tex, style(tex) replace nomtitles postfoot(" \hline \hline \end{tabular}")  	prehead(" \begin{tabular}{l*{3}{c}} \hline \hline    &\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)} \\ ") substitute(\_ _) 

	
	
	

