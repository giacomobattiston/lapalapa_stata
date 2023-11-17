clear all
set more off

*global main "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo"
global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"

global PATH_unhcr "$main/Data/raw/europe_arrivals/unhcr/"
*global PATH_unhcr "$main\Data\raw\europe_arrivals\unhcr\"

global PATH_dta "$main/Data/dta/europe_arrivals/"
*global PATH_dta "$main\Data\dta\europe_arrivals\"

cd  "$main/Draft/figures"

import delimited ${PATH_unhcr}italy2019.csv, delimiter(";") varnames(1) encoding(ISO-8859-1)
gen arrival_country = "Italy"
save ${PATH_dta}italy2019.dta, replace


clear all

import delimited ${PATH_unhcr}spain2019.csv, delimiter(";") varnames(1) encoding(ISO-8859-1)
gen arrival_country = "Spain"
save ${PATH_dta}spain2019.dta, replace

clear all

import delimited ${PATH_unhcr}greece2019.csv, delimiter(";") varnames(1) encoding(ISO-8859-1)
gen arrival_country = "Greece"
save ${PATH_dta}greece2019.dta, replace

clear all

import delimited ${PATH_unhcr}cyprus2019.csv, delimiter(";") varnames(1) encoding(ISO-8859-1)
gen arrival_country = "Cyprus"
save ${PATH_dta}cyprus2019.dta, replace


append using ${PATH_dta}greece2019.dta
append using ${PATH_dta}spain2019.dta
append using ${PATH_dta}italy2019.dta

rename numberofindividualsarrived arrivals
gen origin = countryoforiginname
replace origin = countryoforigin if missing(origin)
replace origin = "Unkown" if missing(origin)
replace origin = "GuineaBissau" if origin == "Guinea-Bissau"
replace origin = "Cote d'Ivoire" if origin == "Cte d'Ivoire"

encode origin, gen(origin_ind)

gen date = mdy(arrivalmonth,15,arrivalyear)

format date %tdmonCCYY
keep if date > d(15mar2016)

preserve

collapse (sum) arrivals, by(origin_ind)

gsort - arrivals
gen ranking = _n
save ${PATH_dta}ranking_countries.dta, replace 

restore


preserve

collapse (sum) arrivals , by(date)
rename arrivals total_arrivals
save ${PATH_dta}total_arrivals.dta, replace 

restore


merge m:1 origin_ind using ${PATH_dta}ranking_countries.dta
keep if ranking <= 5


 levelsof origin_ind, local(origin_ind_levels)            
 foreach val of local origin_ind_levels {      
	   local origin_indvl`val':label(origin_ind) `val'
		}   

collapse (sum) arrivals, by(date origin_ind)
reshape wide arrivals, i(date) j(origin_ind)

merge m:1 date using ${PATH_dta}total_arrivals.dta
drop _merge

tsset date
ds date total_arrivals, not


foreach v in  `r(varlist)' {
	replace `v' = `v'/total_arrivals
}


foreach val of  local origin_ind_levels {
	di "`origin_indvl`val''"
	lab var arrivals`val' "`origin_indvl`val''"
}




ds date total_arrivals, not

ds date total_arrivals, not
tsline `r(varlist)', graphregion(color(white)) xlabel( , noticks) lp(solid solid solid solid solid) lc(blue red black green yellow ) xtitle("")




graph export "arrival_rate_gin.png ", replace

save ${PATH_dta}arrivals2019.dta, replace 
