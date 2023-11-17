clear all
use "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data\output\questionnaire_baseline_clean.dta"

mata: MA_TABLE = J(32, 5, .)

*exchange rate FG for Euro
local er 10050

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

*beaten or physically abused
local l 3
qui sum italy_beaten, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

*forced work
local l 4
qui sum italy_forced_work, detail
mata: MA_TABLE[`l', 1] = `r(mean)'
mata: MA_TABLE[`l', 2] = `r(p25)'
mata: MA_TABLE[`l', 3] = `r(p50)'
mata: MA_TABLE[`l', 4] = `r(p75)'
mata: MA_TABLE[`l', 5] = `r(N)'

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
qui sum spain_duration if italy_duration >= 0 & italy_duration <= 60, detail
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
qui sum ceuta_duration if italy_duration >= 0 & italy_duration <= 60, detail
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

matrix colnames TABLE = mean p25 p50 p75 
matrix rownames TABLE = ita_duration ita_journey_cost ita_beaten ita_forced_work ita_kidnapped ita_die_bef_boat ita_die_boat ita_sent_back spa_duration spa_journey_cost spa_beaten spa_forced_work spa_kidnapped spa_die_bef_boat spa_die_boat spa_sent_back ceu_duration ceu_journey_cost ceu_beaten ceu_forced_work ceu_kidnapped ceu_die ceu_sent_back  unemployed  wage continue_studies  citizen  return_5yr shelter  help_govt asylum  favorable_immigration

esttab matrix(TABLE) using summary.csv
