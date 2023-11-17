clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

use ${main}/Data/output/followup2/BME_final.dta

global logs ${main}/logfiles/
global dta ${main}/Data/dta/
cd "${main}/Draft/tables/spring2021"

tsset id_number time
global controls  "i.treatment_status i.strata" 

* compute intraclass correlation
*replace wealth_index = l2.wealth_index if time == 2
*loneway wealth_index schoolid if time == 2
*0.07388
