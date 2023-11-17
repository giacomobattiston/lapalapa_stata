clear all
*use "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data\output\questionnaire_baseline_clean.dta"
*use "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo/logistics/03_data/04_final_data/output/questionnaire_baseline_clean.dta"
use "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data\output/questionnaire_baseline_clean.dta"

mata: MA_TABLE = J(40, 10, .)


	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  0- Construction of the variables
***_____________________________________________________________________________
*exchange rate FG for Euro
	local er 10400

*planning
	gen planning=1 if sec2_q1==1
	replace planning=0 if sec2_q1==2

*cleaning sec3_42
	gen price_belief=sec3_42
	replace price_belief=. if price_belief <100 | price_belief==999


*cleaning expectation_wage
	gen expected_wage=expectation_wage
	replace expected_wage=. if expectation_wage <100 | expectation_wage==999

*wage in euro winsorized 99
	gen wage_eu_wins99=expected_wage/`er'
	qui sum wage_eu_wins99, detail
	replace wage_eu_wins99=`r(p99)' if wage_eu_wins99 >`r(p99)' & wage_eu_wins99!=.
	replace wage_eu_wins99=`r(p1)' if wage_eu_wins99 <`r(p1)' & wage_eu_wins99!=.

*wage in euro winsorized 95
	gen wage_eu_wins95=expected_wage/`er'
	qui sum wage_eu_wins95, detail
	replace wage_eu_wins95=`r(p95)' if wage_eu_wins95 >`r(p95)' & wage_eu_wins95!=.
	replace wage_eu_wins95=`r(p5)' if wage_eu_wins95 <`r(p5)' & wage_eu_wins95!=.


//computing real wage//
	merge m:1 sec3_21 using "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\price_levels\price_ratios_cs.dta"
	drop _merge

	gen wage_adj_ppp=expected_wage*[ratio_gdp2017/(price_belief/1000000)]
	gen wage_adj_ppp_eu=wage_adj_ppp/`er'

*real_wage in euro winsorized 99
gen wage_adj_ppp_eu_wins99=wage_adj_ppp_eu
qui sum wage_adj_ppp_eu_wins99, detail
replace wage_adj_ppp_eu_wins99=`r(p99)' if wage_adj_ppp_eu_wins99 >`r(p99)' & wage_adj_ppp_eu_wins99!=.
replace wage_adj_ppp_eu_wins99=`r(p1)' if wage_adj_ppp_eu_wins99 <`r(p1)' & wage_adj_ppp_eu_wins99!=.

*real_wage in euro winsorized 95
gen wage_adj_ppp_eu_wins95=wage_adj_ppp_eu
qui sum wage_adj_ppp_eu_wins95, detail
replace wage_adj_ppp_eu_wins95=`r(p95)' if wage_adj_ppp_eu_wins95 >`r(p95)' & wage_adj_ppp_eu_wins95!=.
replace wage_adj_ppp_eu_wins95=`r(p5)' if wage_adj_ppp_eu_wins95 <`r(p5)' & wage_adj_ppp_eu_wins95!=.



//computing converting italy_cost,spain_cost,ceuta_cost//
//cleaning italy
gen italy_cost_eu = italy_journey_cost
replace italy_cost_eu = . if italy_cost_eu <= 0
replace italy_cost_eu = . if italy_cost_eu <100
replace italy_cost_eu = . if italy_cost_eu == 999


replace italy_cost_eu=italy_cost/`er'
*winsorising
gen it_cost_eu_win99=italy_cost_eu
qui sum it_cost_eu_win99, detail
replace it_cost_eu_win99=`r(p99)' if italy_cost_eu >`r(p99)' & italy_cost_eu!=.
replace it_cost_eu_win99=`r(p1)' if italy_cost_eu <`r(p1)' & italy_cost_eu!=.

gen it_cost_eu_win95=italy_cost_eu
qui sum it_cost_eu_win95, detail
replace it_cost_eu_win95=`r(p95)' if italy_cost_eu >`r(p95)' & italy_cost_eu!=.
replace it_cost_eu_win95=`r(p5)' if italy_cost_eu <`r(p5)' & italy_cost_eu!=.

//cleaning spain
gen spain_cost_eu = spain_journey_cost
replace spain_cost_eu = . if spain_cost_eu <= 0
replace spain_cost_eu = . if spain_cost_eu < 100
replace spain_cost_eu = . if spain_cost_eu == 999


replace spain_cost_eu=spain_cost/`er'

*winsorising
gen sp_cost_eu_win99=spain_cost_eu
qui sum sp_cost_eu_win99, detail
replace sp_cost_eu_win99=`r(p99)' if spain_cost_eu >`r(p99)' & spain_cost_eu!=.
replace sp_cost_eu_win99=`r(p1)' if spain_cost_eu <`r(p1)' & spain_cost_eu!=.

gen sp_cost_eu_win95=spain_cost_eu
qui sum sp_cost_eu_win95, detail
replace sp_cost_eu_win95=`r(p95)' if spain_cost_eu >`r(p95)' & spain_cost_eu!=.
replace sp_cost_eu_win95=`r(p5)' if spain_cost_eu <`r(p5)' & spain_cost_eu!=.



//cleaning ceuta
gen ceuta_cost_eu = ceuta_journey_cost
replace ceuta_cost_eu = . if ceuta_cost_eu <= 0
replace ceuta_cost_eu= . if ceuta_cost_eu<100
replace ceuta_cost_eu= . if ceuta_cost_eu== 999


replace ceuta_cost_eu=ceuta_cost/`er'


*winsorizing 
gen ceu_cost_eu_win99=ceuta_cost_eu
qui sum ceu_cost_eu_win99, detail
replace ceu_cost_eu_win99=`r(p99)' if ceuta_cost_eu >`r(p99)' & ceuta_cost_eu!=.
replace ceu_cost_eu_win99=`r(p1)' if ceuta_cost_eu <`r(p1)' & ceuta_cost_eu!=.

gen ceu_cost_eu_win95=ceu_cost_eu
qui sum ceu_cost_eu_win95, detail
replace ceu_cost_eu_win95=`r(p95)' if ceuta_cost_eu >`r(p95)' & ceuta_cost_eu!=.
replace ceu_cost_eu_win95=`r(p5)' if ceuta_cost_eu <`r(p5)' & ceuta_cost_eu!=.






/// data on food price ///

gen country_string = sec3_21
merge m:1 country_string using "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\price_levels\consumption_price_cs.dta"

replace sec4_q1 = sec4_q1*1000 if sec4_q1<1000
replace sec4_q2 = sec4_q2*1000 if sec4_q2<1000
replace sec4_q3 = sec4_q3*1000 if sec4_q3<1000
replace sec4_q4 = sec4_q4*1000 if sec4_q4<1000
gen p_ratio1 = onion_1kg/sec4_q1
gen p_ratio2 = chicken_1kg/sec4_q2
gen p_ratio3 = gasoline_1l/sec4_q3
gen p_ratio4 = paracetamol_10tab/sec4_q4
gen p_ratio = (p_ratio1^0.25)* (p_ratio2^0.25)* (p_ratio3^0.25)* (p_ratio4^0.25)
gen wage = expectation_wage
replace wage = . if wage < 100
gen wage_adj_ci_eu= wage*p_ratio/`er'


*real_wage in euro winsorized 99
gen wage_adj_ci_eu_wins99=wage_adj_ci_eu
qui sum wage_adj_ci_eu_wins99, detail
replace wage_adj_ci_eu_wins99=`r(p99)' if wage_adj_ci_eu_wins99 >`r(p99)' & wage_adj_ci_eu_wins99!=.
replace wage_adj_ci_eu_wins99=`r(p1)' if wage_adj_ci_eu_wins99 <`r(p1)' & wage_adj_ci_eu_wins99!=.

*real_wage in euro winsorized 95
gen wage_adj_ci_eu_wins95=wage_adj_ci_eu
qui sum wage_adj_ci_eu_wins95, detail
replace wage_adj_ci_eu_wins95=`r(p95)' if wage_adj_ci_eu_wins95 >`r(p95)' & wage_adj_ci_eu_wins95!=.
replace wage_adj_ci_eu_wins95=`r(p5)' if wage_adj_ci_eu_wins95 <`r(p5)' & wage_adj_ci_eu_wins95!=.


	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  1- Table
***_____________________________________________________________________________


**RISK OF THE JOURNEY
** ITALY
*duration
local l 1
qui sum italy_duration if italy_duration >= 0 & italy_duration <= 60, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg italy_duration planning if italy_duration >= 0 & italy_duration <= 60
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 6] =b[1,1]


qui qreg italy_duration planning if italy_duration >= 0 & italy_duration <= 60, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 7] =b[1,1]

qui qreg italy_duration planning if italy_duration >= 0 & italy_duration <= 60, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 8] =b[1,1]

qui qreg italy_duration planning if italy_duration >= 0 & italy_duration <= 60, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 9] =b[1,1]



*journey cost winsorized 99
local l 2

qui sum it_cost_eu_win99, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg it_cost_eu_win99 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg it_cost_eu_win99 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg it_cost_eu_win99 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg it_cost_eu_win99 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]




*journey cost winsorized 95
local l 3

qui sum it_cost_eu_win95, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg it_cost_eu_win95 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg it_cost_eu_win95 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg it_cost_eu_win95 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg it_cost_eu_win95 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*beaten or physically abused
local l 4
qui sum italy_beaten, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg italy_beaten planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg italy_beaten planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg italy_beaten planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg italy_beaten planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*forced work
local l 5
qui sum italy_forced_work, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


reg italy_forced_work planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg italy_forced_work planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg italy_forced_work planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg italy_forced_work planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*kidnapped
local l 6
qui sum italy_kidnapped, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg italy_kidnapped planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg italy_kidnapped planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg italy_kidnapped planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg italy_kidnapped planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*die before boat
local l 7
qui sum italy_die_bef_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg italy_die_bef_boat planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg italy_die_bef_boat planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg italy_die_bef_boat planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg italy_die_bef_boat planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*die in boat
local l 8
qui sum italy_die_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg italy_die_boat planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg italy_die_boat planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg italy_die_boat planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg italy_die_boat planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*sent back
local l 9
qui sum italy_sent_back, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg italy_sent_back planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg italy_sent_back planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg italy_sent_back planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg italy_sent_back planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


** SPAIN
*duration
local l 10
qui sum spain_duration if spain_duration >= 0 & spain_duration <= 60, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg spain_duration planning if spain_duration >= 0 & spain_duration <= 60
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 6] =b[1,1]


qui qreg spain_duration planning if spain_duration >= 0 & spain_duration <= 60, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 7] =b[1,1]

qui qreg spain_duration planning if spain_duration >= 0 & spain_duration <= 60, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 8] =b[1,1]

qui qreg spain_duration planning if spain_duration >= 0 & spain_duration <= 60, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 9] =b[1,1]



*journey cost winsorized 99
local l 11

qui sum sp_cost_eu_win99, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg sp_cost_eu_win99 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg sp_cost_eu_win99 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sp_cost_eu_win99 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sp_cost_eu_win99 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*journey cost winsorized 95
local l 12

qui sum sp_cost_eu_win95, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg sp_cost_eu_win95 planning
mata: b  = st_matrix("e(b)")	
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg sp_cost_eu_win95 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sp_cost_eu_win95 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sp_cost_eu_win95 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*beaten or physically abused
local l 13
qui sum spain_beaten, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg spain_beaten planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg spain_beaten planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg spain_beaten planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg spain_beaten planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*forced work
local l 14
qui sum spain_forced_work, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg spain_forced_work planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg spain_forced_work planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg spain_forced_work planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg spain_forced_work planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*kidnapped
local l 15
qui sum spain_kidnapped, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg spain_kidnapped planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg spain_kidnapped planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg spain_kidnapped planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg spain_kidnapped planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*die before boat
local l 16
qui sum spain_die_bef_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg spain_die_bef_boat planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg spain_die_bef_boat planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg spain_die_bef_boat planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg spain_die_bef_boat planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*die in boat
local l 17
qui sum spain_die_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg spain_die_boat planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg spain_die_boat planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg spain_die_boat planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg spain_die_boat planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*sent back
local l 18
qui sum spain_sent_back, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg spain_sent_back planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg spain_sent_back planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg spain_sent_back planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg spain_sent_back planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]






** CEUTA

*duration
local l 19
qui sum ceuta_duration if ceuta_duration >= 0 & ceuta_duration <= 60, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg ceuta_duration planning if ceuta_duration >= 0 & ceuta_duration <= 60
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 6] =b[1,1]


qui qreg ceuta_duration planning if ceuta_duration >= 0 & ceuta_duration <= 60, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 7] =b[1,1]

qui qreg ceuta_duration planning if ceuta_duration >= 0 & ceuta_duration <= 60, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 8] =b[1,1]

qui qreg ceuta_duration planning if ceuta_duration >= 0 & ceuta_duration <= 60, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[1, 9] =b[1,1]



*journey cost winsorized99
local l 20

qui sum ceu_cost_eu_win99, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg ceu_cost_eu_win99 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg ceu_cost_eu_win99 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg ceu_cost_eu_win99 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg ceu_cost_eu_win99 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*journey cost winsorized 95
local l 21

qui sum ceu_cost_eu_win95, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg ceu_cost_eu_win95 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg ceu_cost_eu_win95 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg ceu_cost_eu_win95 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg ceu_cost_eu_win95 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]

*beaten or physically abused
local l 22
qui sum ceuta_beaten, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg ceuta_beaten planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]


qui qreg ceuta_beaten planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg ceuta_beaten planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg ceuta_beaten planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*forced work
local l 23
qui sum ceuta_forced_work, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


reg ceuta_forced_work planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg ceuta_forced_work planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg ceuta_forced_work planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg ceuta_forced_work planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*kidnapped
local l 24
qui sum ceuta_kidnapped, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg ceuta_kidnapped planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg ceuta_kidnapped planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg ceuta_kidnapped planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg ceuta_kidnapped planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*die before boat
local l 25
qui sum ceuta_die_bef_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg ceuta_die_bef_boat planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg ceuta_die_bef_boat planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg ceuta_die_bef_boat planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg ceuta_die_bef_boat planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]



*sent back
local l 26
qui sum ceuta_sent_back, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg ceuta_sent_back planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg ceuta_sent_back planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg ceuta_sent_back planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg ceuta_sent_back planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]




**ECONOMIC OUTCOMES
*unemployed
local l 27
qui sum sec3_32, detail
mata: MA_TABLE[`l', 1] = 100 - `r(mean)'
mata: MA_TABLE[`l', 2] = 100 - `r(p75)'
mata: MA_TABLE[`l', 3] = 100 - `r(p50)'
mata: MA_TABLE[`l', 4] = 100 - `r(p25)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg sec3_32 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_32 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_32 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_32 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]





*wage in euros winsorized 99  
local l 28
qui sum wage_eu_wins99, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg wage_eu_wins99 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg wage_eu_wins99 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg wage_eu_wins99 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg wage_eu_wins99 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*wage in euros winsorized 95
local l 29
qui sum wage_eu_wins95, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg wage_eu_wins95 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg wage_eu_wins95 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg wage_eu_wins95 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg wage_eu_wins95 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]
*/

*real wage in euro winsorized  99
local l 30
qui sum wage_adj_ppp_eu_wins99, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg wage_adj_ppp_eu_wins99 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg wage_adj_ppp_eu_wins99 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg wage_adj_ppp_eu_wins99 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg wage_adj_ppp_eu_wins99 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*real wage in euro winsorized 95
local l 31
qui sum wage_adj_ppp_eu_wins95, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg wage_adj_ppp_eu_wins95 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg wage_adj_ppp_eu_wins95 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg wage_adj_ppp_eu_wins95 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg wage_adj_ppp_eu_wins95 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]

*real wage in euro winsorized 99
local l 32
qui sum wage_adj_ci_eu_wins99, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg wage_adj_ci_eu_wins99 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg wage_adj_ci_eu_wins99 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg wage_adj_ci_eu_wins99 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg wage_adj_ci_eu_wins99 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*real wage in euro winsorized 95
local l 33
qui sum wage_adj_ci_eu_wins95, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg wage_adj_ci_eu_wins95 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg wage_adj_ci_eu_wins95 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg wage_adj_ci_eu_wins95 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg wage_adj_ci_eu_wins95 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*continue studies
local l 34
qui sum sec3_35  if sec3_35 >= 0 & sec3_35 <= 100, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

qui reg sec3_35 planning if sec3_35 >= 0 & sec3_35 <= 100
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_35 planning if sec3_35 >= 0 & sec3_35 <= 100, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_35 planning if sec3_35 >= 0 & sec3_35 <= 100, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_35 planning if sec3_35 >= 0 & sec3_35 <= 100, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]





*citizen 
local l 35
qui sum sec3_36, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg sec3_36 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_36 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_36 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_36 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*return 5yr
local l 36
qui sum sec3_37, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


qui reg sec3_37 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_37 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_37 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_37 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*return shelter    
local l 37
qui sum sec3_38, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


reg sec3_38 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_38 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_38 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_38 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]


*return help govt
local l 38
qui sum sec3_39, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


reg sec3_39 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_39 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_39 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_39 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]




*asylum
local l 39
qui sum sec3_40, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


reg sec3_40 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_40 planning, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_40 planning, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_40 planning, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]

*favorable to immigration
local l 40
qui sum sec3_41 if sec3_41 >= 0 & sec3_41<= 100, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


reg sec3_41 planning
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 6] =b[1,1]

qui qreg sec3_41 if sec3_41 >= 0 & sec3_41<= 100, quantile(.25)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 7] =b[1,1]

qui qreg sec3_41 if sec3_41 >= 0 & sec3_41<= 100, quantile(.5)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 8] =b[1,1]

qui qreg sec3_41 if sec3_41 >= 0 & sec3_41<= 100, quantile(.75)
mata: b  = st_matrix("e(b)")
mata: MA_TABLE[`l', 9] =b[1,1]





mata: st_matrix("TABLE", MA_TABLE)

matrix colnames TABLE = mean p25 p50 p75 N ols q25 q50 q75 true
matrix rownames TABLE = ita_duration it_journey_cost_eu_win99 it_journey_cost_eu_win95 ita_beaten ita_forced_work ita_kidnapped ita_die_bef_boat ita_die_boat ita_sent_back spa_duration spa_journey_cost_eu_win99 spa_journey_cost_eu_win95 spa_beaten spa_forced_work spa_kidnapped spa_die_bef_boat spa_die_boat spa_sent_back ceu_duration ceu_journey_cost_eu_win99 ceu_journey_cost_eu_win95 ceu_beaten ceu_forced_work ceu_kidnapped ceu_die ceu_sent_back  unemployed  wage_eu_wins99 wage_eu_wins95 wage_adj_ppp_eu_wins99  wage_adj_ppp_eu_wins95 wage_adj_ci_eu_wins99 wage_adj_ci_eu_wins95 continue_studies  citizen  return_5yr shelter  help_govt asylum  favorable_immigration

esttab matrix(TABLE) using summary_cs.csv,replace
