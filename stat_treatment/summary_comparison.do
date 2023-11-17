clear all
*use "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data\output\questionnaire_baseline_clean.dta"
*use "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo/logistics/03_data/04_final_data/output/questionnaire_baseline_clean.dta"
use "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data\output/questionnaire_baseline_clean.dta"

mata: MA_TABLE = J(32, 6, .)


	
***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***  0- Construction of the variables
***_____________________________________________________________________________
*exchange rate FG for Euro
local er 10050

*planning
gen planning=1 if sec2_q1==1
replace planning=0 if sec2_q1==2

*winsorizing sec3_42
gen price_belief=sec3_42
replace price_belief=. if price_belief <100 | price_belief==999

/*gen price_belief_99=price_belief
*qui sum price_belief, detail
*replace price_belief_99=`r(p99)' if price_belief>`r(p99)'
*replace price_belief_99=`r(p1)' if price_belief<`r(p1)'

gen price_belief_95=price_belief
qui sum price_belief, detail
replace price_belief_95=`r(p95)' if price_belief>`r(p95)'
replace price_belief_95=`r(p5)' if price_belief<`r(p5)'
*/

*winsorizing expectation_wage
gen expected_wage=expectation_wage
replace expected_wage=. if expectation_wage <100 | expectation_wage==999

/*gen expected_wage_99=expected_wage
qui sum expected_wage_99, detail
replace expected_wage_99=`r(p99)' if expected_wage >`r(p99)'
replace expected_wage_99=`r(p1)' if expected_wage <`r(p1)'

gen expected_wage_95=expectation_wage
qui sum expected_wage_95, detail
replace expected_wage_95=`r(p95)' if expected_wage>`r(p95)'
replace expected_wage_95=`r(p5)' if expected_wage<`r(p5)'
*/

*computing real wage
merge m:1 sec3_21 using "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data\price_levels\price_ratios_cs.dta"
drop _merge

gen wage_real=expected_wage*[ratio_gdp2017/(price_belief/1000000)]

*real_wage winsorizing 99
gen wage_real_wins99=wage_real
qui sum wage_real_wins99, detail
replace wage_real_wins99=`r(p99)' if wage_real_wins99 >`r(p99)' & wage_real_wins99!=.
replace wage_real_wins99=`r(p1)' if wage_real_wins99 <`r(p1)' & wage_real_wins99!=.

*real_wage winsorizing 95
gen wage_real_wins95=wage_real
qui sum wage_real_wins95, detail
replace wage_real_wins95=`r(p99)' if wage_real_wins95 >`r(p95)' & wage_real_wins95!=.
replace wage_real_wins95=`r(p1)' if wage_real_wins95 <`r(p5)' & wage_real_wins95!=.





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

mata: MA_TABLE[`l', 6] = _planning

qui qreg  italy_duration planning if italy_duration >= 0 & italy_duration <= 60, quantile(.25)
mata: MA_TABLE[`l', ]7 = _planning

qui qreg italy_duration planning if italy_duration >= 0 & italy_duration <= 60, quantile(.5)
mata: MA_TABLE[`l', 5] = _planning

qui qreg italy_duration planning if italy_duration >= 0 & italy_duration <= 60, quantile(.75)
mata: MA_TABLE[`l', 5] = _planning

*journey cost
local l 2

gen italy_cost = italy_journey_cost
replace italy_cost = . if italy_cost <= 0
replace italy_cost = . if italy_cost == 99
replace italy_cost = . if italy_cost == 999
replace italy_cost = 1000000*italy_cost if italy_cost < 100
replace italy_cost = 1000*italy_cost if italy_cost < 1000000

qui sum italy_cost, detail
mata: MA_TABLE[`l', 1] = `r(mean)'/`er'
mata: MA_TABLE[`l', 2] = `r(p25)'/`er'
mata: MA_TABLE[`l', 3] = `r(p50)'/`er'
mata: MA_TABLE[`l', 4] = `r(p75)'/`er'
mata: MA_TABLE[`l', 5] = `r(N)'

eststo : qui reg italy_cost planning
eststo : qui qreg italy_cost planning, quantile(.25)
eststo : qui qreg italy_cost planning, quantile(.5)
eststo : qui qreg italy_cost planning , quantile(.75)


*beaten or physically abused
local l 3
qui sum italy_beaten, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


eststo : qui reg italy_beaten planning
eststo : qui qreg italy_beaten planning, quantile(.25)
eststo : qui qreg italy_beaten planning, quantile(.5)
eststo : qui qreg italy_beaten planning , quantile(.75)


*forced work
local l 4
qui sum italy_forced_work, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

eststo : qui reg italy_forced_work planning
eststo : qui qreg italy_forced_work planning, quantile(.25)
eststo : qui qreg italy_forced_work planning, quantile(.5)
eststo : qui qreg italy_forced_work planning , quantile(.75)

*kidnapped
local l 5
qui sum italy_kidnapped, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*die before boat
local l 6
qui sum italy_die_bef_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*die in boat
local l 7
qui sum italy_die_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*sent back
local l 8
qui sum italy_sent_back, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


** SPAIN
*duration
local l 9
qui sum spain_duration if spain_duration >= 0 & spain_duration <= 60, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*journey cost
local l 10

gen spain_cost = spain_journey_cost
replace spain_cost = . if italy_cost <= 0
replace spain_cost = . if italy_cost == 99
replace spain_cost = . if italy_cost == 999
replace spain_cost = 1000000*italy_cost if italy_cost < 100
replace spain_cost = 1000*italy_cost if italy_cost < 1000000

qui sum spain_cost, detail
mata: MA_TABLE[`l', 1] = `r(mean)'/`er'
mata: MA_TABLE[`l', 2] = `r(p25)'/`er'
mata: MA_TABLE[`l', 3] = `r(p50)'/`er'
mata: MA_TABLE[`l', 4] = `r(p75)'/`er'
mata: MA_TABLE[`l', 5] = `r(N)'

*beaten or physically abused
local l 11
qui sum spain_beaten, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*forced work
local l 12
qui sum spain_forced_work, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*kidnapped
local l 13
qui sum spain_kidnapped, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*die before boat
local l 14
qui sum spain_die_bef_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*die in boat
local l 15
qui sum spain_die_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*sent back
local l 16
qui sum spain_sent_back, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

** CEUTA
*duration
local l 17
qui sum ceuta_duration if ceuta_duration >= 0 & ceuta_duration <= 60, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*journey cost
local l 18

gen ceuta_cost = ceuta_journey_cost
replace ceuta_cost = . if italy_cost <= 0
replace ceuta_cost = . if italy_cost == 99
replace ceuta_cost = . if italy_cost == 999
replace ceuta_cost = 1000000*italy_cost if italy_cost < 100
replace ceuta_cost = 1000*italy_cost if italy_cost < 1000000

qui sum ceuta_journey_cost, detail
mata: MA_TABLE[`l', 1] = `r(mean)'/`er'
mata: MA_TABLE[`l', 2] = `r(p25)'/`er'
mata: MA_TABLE[`l', 3] = `r(p50)'/`er'
mata: MA_TABLE[`l', 4] = `r(p75)'/`er'
mata: MA_TABLE[`l', 5] = `r(N)'

*beaten or physically abused
local l 19
qui sum ceuta_beaten, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*forced work
local l 20
qui sum ceuta_forced_work, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*kidnapped
local l 21
qui sum ceuta_kidnapped, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*die
local l 22
qui sum ceuta_die_bef_boat, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*sent back
local l 23
qui sum ceuta_sent_back, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'


**ECONOMIC OUTCOMES
*unemployed
local l 24
qui sum sec3_32, detail
mata: MA_TABLE[`l', 1] = 100 - `r(mean)'
mata: MA_TABLE[`l', 2] = 100 - `r(p75)'
mata: MA_TABLE[`l', 3] = 100 - `r(p50)'
mata: MA_TABLE[`l', 4] = 100 - `r(p25)'
mata: MA_TABLE[`l', 5] = `r(N)'

*wage  
local l 25
qui sum expectation_wage, detail
mata: MA_TABLE[`l', 1] = `r(mean)'/`er'
mata: MA_TABLE[`l', 2] = `r(p25)'/`er'
mata: MA_TABLE[`l', 3] = `r(p50)'/`er'
mata: MA_TABLE[`l', 4] = `r(p75)'/`er'
mata: MA_TABLE[`l', 5] = `r(N)'

*continue studies
local l 26
qui sum sec3_35  if sec3_35 >= 0 & sec3_35 <= 100, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*citizen 
local l 27
qui sum sec3_36, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*return 5yr
local l 28
qui sum sec3_37, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*return shelter    
local l 29
qui sum sec3_38, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*return help govt
local l 30
qui sum sec3_39, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*asylum
local l 31
qui sum sec3_40, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*favorable to immigration
local l 32
qui sum sec3_41 if sec3_41 >= 0 & sec3_41<= 100, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

mata: st_matrix("TABLE", MA_TABLE)

matrix colnames TABLE = mean p25 p50 p75 N true
matrix rownames TABLE = ita_duration ita_journey_cost ita_beaten ita_forced_work ita_kidnapped ita_die_bef_boat ita_die_boat ita_sent_back spa_duration spa_journey_cost spa_beaten spa_forced_work spa_kidnapped spa_die_bef_boat spa_die_boat spa_sent_back ceu_duration ceu_journey_cost ceu_beaten ceu_forced_work ceu_kidnapped ceu_die ceu_sent_back  unemployed  wage continue_studies  citizen  return_5yr shelter  help_govt asylum  favorable_immigration

*esttab matrix(TABLE) using summary.csv







