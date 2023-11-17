clear all

*global PATH_in = "/Users/giacomobattiston/Dropbox/eu-lfs/dta/"
*global PATH_in = "C:\Users\BattistonG\Dropbox\eu-lfs\dta\"
global PATH_in = "/Volumes/WD_Giacomo/data/eu-lfs/dta/"

use ${PATH_in}total2015to17.dta

mata: MA_TABLE = J(10, 9, .)

keep if (age >= 17)&(age <= 27)

*columns unemployment neet wantouraged wantwork
*rows total africa age>0 age>15

*unemployment
*duration

gen employed = ilostat == 1

destring yearesid, gen(yearresid) force

local age_min 5

gen unemp = 0 if ilostat == 1
replace unemp = 1 if ilostat == 2

gen neet = 0 if !missing(educ4wn)
replace neet = 1 if ((ilostat == 2)|(ilostat == 3))&(educ4wn == 0)

gen want2w = 0 if (ilostat == 1)
replace want2w = 1 if (ilostat == 2)|((ilostat == 3)&(seekwork == 3)&(wantwork == 1)&(availble == 1))

gen want = 0 if (ilostat == 1)
replace want = 1 if (ilostat == 2)|((ilostat == 3)&(seekwork == 3)&(wantwork == 1))



local sum_mig = 1265 + 1081 + 651 + 2606 + 546 + 423
local sp_rate = 1265/`sum_mig' 
local it_rate = 1081/`sum_mig'
local de_rate = 651/`sum_mig' 
local fr_rate = 2606/`sum_mig'
local uk_rate = 546/`sum_mig'
local be_rate = 423/`sum_mig' 

* we used this for the treatment

sum employed if countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "ES"
local esp_weigthed =  `r(mean)'*`sp_rate'
sum employed if countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "IT"
local eit_weigthed =  `r(mean)'*`it_rate'
sum employed if countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "DE"
local ede_weigthed =  `r(mean)'*`de_rate'
sum employed if countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "FR"
local efr_weigthed =  `r(mean)'*`fr_rate'
sum employed if countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "UK"
local euk_weigthed =  `r(mean)'*`uk_rate'
sum employed if countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "BE"
local ebe_weigthed =  `r(mean)'*`be_rate'

local e_weigthed = `esp_weigthed' + `eit_weigthed'+ `ede_weigthed'+ `efr_weigthed'+ `euk_weigthed'+ `ebe_weigthed'

di "employment:" `e_weigthed'

stop









qui count if ilostat == 1 & !missing(isco1d) & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "ES"
local N `r(N)'
qui count if ilostat == 1 & !missing(isco1d) & isco1d == 900 & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "ES"
local elsp_weigthed =  `r(N)'*`sp_rate'/`N'

qui count if ilostat == 1 & !missing(isco1d) & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "IT"
local N `r(N)'
qui count if ilostat == 1 & !missing(isco1d) & isco1d == 900 & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "IT"
local elit_weigthed =  `r(N)'*`it_rate'/`N'

qui count if ilostat == 1 & !missing(isco1d) & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "DE"
local N `r(N)'
qui count if ilostat == 1 & !missing(isco1d) & isco1d == 900 & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "DE"
local elde_weigthed =  `r(N)'*`de_rate'/`N'

qui count if ilostat == 1 & !missing(isco1d) & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "FR"
local N `r(N)'
qui count if ilostat == 1 & !missing(isco1d) & isco1d == 900 & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "FR"
local elfr_weigthed =  `r(N)'*`fr_rate'/`N'

qui count if ilostat == 1 & !missing(isco1d) & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "UK"
local N `r(N)'
qui count if ilostat == 1 & !missing(isco1d) & isco1d == 900 & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "UK"
local eluk_weigthed =  `r(N)'*`uk_rate'/`N'

qui count if ilostat == 1 & !missing(isco1d) & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "BE"
local N `r(N)'
qui count if ilostat == 1 & !missing(isco1d) & isco1d == 900 & countryb == "010-OTHER AFRICA" & yearresid <= `age_min' & country == "BE"
local elbe_weigthed =  `r(N)'*`be_rate'/`N'


local el_weigthed = `elsp_weigthed' + `elit_weigthed'+ `elde_weigthed'+ `elfr_weigthed'+ `eluk_weigthed'+ `elbe_weigthed'

di "elementary occupations:" `el_weigthed'









