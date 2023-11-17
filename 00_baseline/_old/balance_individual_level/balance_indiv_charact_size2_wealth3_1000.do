***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - Parameters                                               
***_____________________________________________________________________________


global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\logistics\03_data\04_final_data"
local lycee "$main/raw/lycee_conakry.xlsx"


// Creating the righ quartile at the schol level
use "$main/output/data_balance.dta", clear
collapse (mean) size wealth_index, by(schoolid)
xtile quart_size=size, nq(2)
xtile quart_wealth = wealth_index, nq(3)
local strata "quart_size quart_wealth"
egen strata=group(`strata')
label var strata "Strata"
tab strata, gen(strata_n)

tempfile quart
save `quart', replace


// Merging the data, the quartile and the treatment status
use "$main/output/data_balance.dta", clear
merge m:1 schoolid using "`quart'"
drop _merge
merge m:1 schoolid using "$main/definitive\dta\size2_wealth3_1000_treatment.dta"


#delimit ;
orth_out age gender pular_language sousou_language malinke_language wealth_index outside_contact_no mig_classmates
 log_wage expectation_wage  employed asylum studies italy_duration italy_journey_cost italy_beaten italy_die_bef_boat 
 italy_die_boat spain_duration spain_journey_cost spain_beaten spain_die_bef_boat spain_die_boat beaten duration journey_cost 
 die_boat die_bef_boat planning prepare mig_desire using "$main/bc_var_indiv_size2_wealth3_1000_treatment.xls", by(_assignment) 
 se test compare stars replace covariates(strata_n*) count vcount title(Balance checks) vce( cluster schoolid) 
 armlabel("Control group" "Treatment risk" "Treatment condition in UE" "Double Treatment") ;
#delimit cr
