clear all

set more off

*global PATH_in = "/Users/giacomobattiston/Dropbox/eu-lfs/dta/"
*global PATH_in = "C:\Users\BattistonG\Dropbox\eu-lfs\dta\"
global PATH_in = "/Volumes/WD_Giacomo/data/eu-lfs/dta/"

use ${PATH_in}total2015to17.dta

mata: MA_TABLE = J(450, 6, .)

keep if (age >= 17)&(age <= 27)
keep if  countryb == "010-OTHER AFRICA"


*columns unemployment neet wantouraged wantwork
*rows total africa age>0 age>15

*unemployment
*duration


gen emp = ilostat == 1

gen unemp = 0 if ilostat == 1
replace unemp = 1 if ilostat == 2

gen neet = 0 if !missing(educ4wn)
replace neet = 1 if ((ilostat == 2)|(ilostat == 3))&(educ4wn == 0)

gen want2w = 0 if (ilostat == 1)
replace want2w = 1 if (ilostat == 2)|((ilostat == 3)&(seekwork == 3)&(wantwork == 1)&(availble == 1))

gen want = 0 if (ilostat == 1)
replace want = 1 if (ilostat == 2)|((ilostat == 3)&(seekwork == 3)&(wantwork == 1))

*local vars emp unemp neet want2w want

keep if yearesid == "05" |yearesid == "04" | yearesid == "03" | yearesid == "02" | yearesid == "01" 

encode yearesid, gen(year_residence)
encode country, gen(country_chosen)


forvalues i=0/2 {
	local a = 16 + `i'*5
	local l1 =  `i'*150
	
    forvalues c = 1/6 {
		local l2 =  (`c'-1)*25
		
	    forvalues y = 1/5 {
		local l3 =  (`y'-1)*5
		
		local l =  `l1' + `l2' + `l3'
		
		qui sum emp if country_chosen == `c' & age >= `a' & year_residence <= `y'
		mata: MA_TABLE[`l' + 1, 1] = `r(mean)'
		mata: MA_TABLE[`l' + 1, 2] = `r(N)'
		mata: MA_TABLE[`l' + 1, 3] = `a'
		mata: MA_TABLE[`l' + 1, 4] = `c'
		mata: MA_TABLE[`l' + 1, 5] = `y'
		mata: MA_TABLE[`l' + 1, 6] = 1
		
		sum unemp if country_chosen == `c' & age >= `a' & year_residence <= `y'
		mata: MA_TABLE[`l' + 2, 1] = `r(mean)'
		mata: MA_TABLE[`l' + 2, 2] = `r(N)'
		mata: MA_TABLE[`l' + 2, 3] = `a'
		mata: MA_TABLE[`l' + 2, 4] = `c'
		mata: MA_TABLE[`l' + 2, 5] = `y'
		mata: MA_TABLE[`l' + 2, 6] = 2

		sum neet if country_chosen == `c' & age >= `a' & year_residence <= `y'
		mata: MA_TABLE[`l' + 3, 1] = `r(mean)'
		mata: MA_TABLE[`l' + 3, 2] = `r(N)'
		mata: MA_TABLE[`l' + 3, 3] = `a'
		mata: MA_TABLE[`l' + 3, 4] = `c'
		mata: MA_TABLE[`l' + 3, 5] = `y'
		mata: MA_TABLE[`l' + 3, 6] = 3

		sum want2w if country_chosen == `c' & age >= `a' & year_residence <= `y'
		mata: MA_TABLE[`l' + 4, 1] = `r(mean)'
		mata: MA_TABLE[`l' + 4, 2] = `r(N)'
		mata: MA_TABLE[`l' + 4, 3] = `a'
		mata: MA_TABLE[`l' + 4, 4] = `c'
		mata: MA_TABLE[`l' + 4, 5] = `y'
		mata: MA_TABLE[`l' + 4, 6] = 4
		
		sum want if country_chosen == `c' & age >= `a' & year_residence <= `y'
		mata: MA_TABLE[`l' + 5, 1] = `r(mean)'
		mata: MA_TABLE[`l' + 5, 2] = `r(N)'
		mata: MA_TABLE[`l' + 5, 3] = `a'
		mata: MA_TABLE[`l' + 5, 4] = `c'
		mata: MA_TABLE[`l' + 5, 5] = `y'
		mata: MA_TABLE[`l' + 5, 6] = 5
		
  }
  }
  }
 


*fela1
*(yearesid == "01" |yearesid == "02")








