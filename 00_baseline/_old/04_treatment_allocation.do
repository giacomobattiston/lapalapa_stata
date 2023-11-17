
global main "C:\Users\cloes_000\Documents\RA-Guinée\Lapa Lapa\logistics\03_data\04_final_data\output"

use "$main/admin_data", clear

set seed 10201504
rename CODE schoolid
label var schoolid "id school number"
keep schoolid commune status NOM_ETABLISSEMENT


sort schoolid
gen random=runiform()




*stratificaiton
sort commune status random
bys commune status : gen strata_size = _N
bys commune status : gen strata_index = _n

egen strata=group(commune status)
label var strata "Strata"


*treatment allocation
gen treatment=0
replace treatment = 1 if strata_index <= strata_size/4
replace treatment = 2 if strata_index> strata_size/4 & strata_index <= strata_size/2
replace treatment = 3 if strata_index > strata_size/2 & strata_index<= strata_size*3/4

drop strata_size strata_index random

*label
label var treatment "Treatment allocation"
lab def treatment 1 "Treatment 1" 2 "Treatment 2" 3 "Treatment 3" 0 "Control"
lab val treatment treatment

gen control=1 if treatment==0
replace control=0 if treatment!=0
label var control "Control group"
lab def control 1 "Control group" 0 "Treated group"
