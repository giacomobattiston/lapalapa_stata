clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"


use ${main}/Data/output/followup2/BME_final.dta

_pctile age, p(99)
local maxage = `r(r1)'

sum desire if time == 0
local desire_mean = `r(mean)'
local Ndataset = `r(N)'
sum planning if time == 0
local planning_mean = `r(mean)'
sum prepare if time == 0
local prepare_mean = `r(mean)' 

clear all

import delimited ${main}/Data/raw/afrobarometer/afrobarometer7.csv, clear 

cd "$main/Draft/tables/spring2021/"

m: migint = J(7,5,.)

* overall population

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

m: migint[1,5] = strtoreal(st_local("N"))
m: migint[1,1] = round(strtoreal(st_local("N1"))/migint[1,5], .01)
m: migint[1,2] = round(strtoreal(st_local("N2"))/migint[1,5], .01)
m: migint[1,3] = round(strtoreal(st_local("N3"))/migint[1,5], .01)
m: migint[1,4] = round(strtoreal(st_local("N4"))/migint[1,5], .01)

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

m: migint[2,5] = strtoreal(st_local("N"))
m: migint[2,1] = round(strtoreal(st_local("N1"))/migint[2,5], .01)
m: migint[2,2] = round(strtoreal(st_local("N2"))/migint[2,5], .01)
m: migint[2,3] = round(strtoreal(st_local("N3"))/migint[2,5], .01)
m: migint[2,4] = round(strtoreal(st_local("N4"))/migint[2,5], .01)

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

m: migint[3,5] = strtoreal(st_local("N"))
m: migint[3,1] = round(strtoreal(st_local("N1"))/migint[3,5], .01)
m: migint[3,2] = round(strtoreal(st_local("N2"))/migint[3,5], .01)
m: migint[3,3] = round(strtoreal(st_local("N3"))/migint[3,5], .01)
m: migint[3,4] = round(strtoreal(st_local("N4"))/migint[3,5], .01)

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



*only student, max is from our dataset, min is 18 (older)
qui count if country == 11 & q95a == 1 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11 & q95a == 1 & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & q95a == 1 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & q95a == 1 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & q95a == 1 & q68b != -1
local N4 = `r(N)'

m: migint[5,5] = strtoreal(st_local("N"))
m: migint[5,1] = round(strtoreal(st_local("N1"))/migint[5,5], .01)
m: migint[5,2] = round(strtoreal(st_local("N2"))/migint[5,5], .01)
m: migint[5,3] = round(strtoreal(st_local("N3"))/migint[5,5], .01)
m: migint[5,4] = round(strtoreal(st_local("N4"))/migint[5,5], .01)

*only young, max is from our dataset, min is 18 (older) from conakry
qui count if country == 11 & q95a == 1 & region == 1300 & q68a != -1
local N = `r(N)'
*thnking about migration somewhat or a lot
qui count if (q68a == 2 | q68a == 3) & country == 11 & q95a == 1 & region == 1300 & q68a != -1
local N1 = `r(N)'
*thnking about migration a lot
qui count if q68a == 3 & country == 11 & q95a == 1 & region == 1300 & q68a != -1
local N2 = `r(N)'
*plans or preparations
qui count if (q68b == 1 | q68b == 2) & country == 11 & q95a == 1 & region == 1300 & q68b != -1
local N3 = `r(N)'
*preparations
qui count if q68b == 2 & country == 11 & q95a == 1 & region == 1300 & q68b != -1
local N4 = `r(N)'

m: migint[6,5] = strtoreal(st_local("N"))
m: migint[6,1] = round(strtoreal(st_local("N1"))/migint[6,5], .01)
m: migint[6,2] = round(strtoreal(st_local("N2"))/migint[6,5], .01)
m: migint[6,3] = round(strtoreal(st_local("N3"))/migint[6,5], .01)
m: migint[6,4] = round(strtoreal(st_local("N4"))/migint[6,5], .01)



*our dataset
m: migint[7,5] = strtoreal(st_local("Ndataset"))
m: migint[7,1] = round(strtoreal(st_local("desire_mean")), .01)
m: migint[7,3] = round(strtoreal(st_local("planning_mean")), .01)
m: migint[7,4] = round(strtoreal(st_local("prepare_mean")), .01)

m: st_matrix("migint", migint)

*matrix colnames migint =  "Thinks about" "%" "Control"  "%" "Risk"  "%" "Econ"  "%" "Double"  "%"
matrix rownames migint =  "Guinea" "Conakry"  "Guinea, young"   "Conakry, young" "Guinea, student"   "Conakry, student"  "Our sample" 

putexcel set migint, replace
putexcel A1 = matrix(migint), names



