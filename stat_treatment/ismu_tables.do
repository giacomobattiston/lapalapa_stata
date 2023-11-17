clear all

set more off

cd "/Users/giacomobattiston/Dropbox/ISMU 2001-2013/"
clear

global pathdata "data/"
use "$pathdata/ISMU_2001_2013.dta"

gen unemp = labmkt == 2

gen age_arr = arr_ita - birth_year

drop if age_arr <15

keep if age > 17 & age < 30



keep if ((country == 413) |(country == 422) |(country == 423) |(country == 426) |(country == 430) |(country == 443)| (country == 451) )|((country == 406) |(country == 409) |(country == 404) |(country == 425) |(country == 435) |(country == 437) |(country == 442)|(country == 450) |(country == 458))


mata: table = J(8, 7, .)

**unemployment
local l 2
qui sum unemp if labmkt != 4
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'

**unemployment
local l 4
qui sum unemp if labmkt != 4 & ps == 3
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage if ps == 3, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'

**unemployment
local l 6
qui sum unemp if labmkt != 4 & year > 2008
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage if  year > 2008, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'

**unemployment
local l 8
qui sum unemp if labmkt != 4 & ps == 3 & year > 2008
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage if ps == 3 & year > 2008, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'


keep if ((country == 406) |(country == 409) |(country == 404) |(country == 425) |(country == 435) |(country == 437) |(country == 442)|(country == 450) |(country == 458))


**unemployment
local l 1
qui sum unemp if labmkt != 4
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'

**unemployment
local l 3
qui sum unemp if labmkt != 4 & ps == 3
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage if ps == 3, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'

**unemployment
local l 5
qui sum unemp if labmkt != 4 & year > 2008
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage if  year > 2008, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'

**unemployment
local l 7
qui sum unemp if labmkt != 4 & ps == 3 & year > 2008
mata: table[`l', 1] = `r(mean)'
mata: table[`l', 2] = `r(N)'
**wage
qui sum wage if ps == 3 & year > 2008, detail
mata: table[`l', 3] = `r(mean)'
mata: table[`l', 4] = `r(p25)'
mata: table[`l', 5] = `r(p50)'
mata: table[`l', 6] = `r(p75)'
mata: table[`l', 7] = `r(N)'


mata: st_matrix("ismu_table", table)

matrix colnames ismu_table = u_mean N_u w_mean w_p25 w_p50 w_p75 N_w
matrix rownames ismu_table = fr wa fr_wp wa_wp fr_2009 wa_2009 fr_wp_2009 wa_wp_2009 

esttab matrix(ismu_table) using ismu_table.csv, replace






* benin 406 x
* burkina 409 x
* capo verde 413
* costa d'avorio 404 x
* gambia 422
* ghana 423
* guinea 425 x
* guinea-bissau 426
* liberia 430
* mali 435 x
* mauritania 437 x
* niger 442 x
* nigeria 443
* senegal 450 x
* sierra leone 451
* togo 458 x




