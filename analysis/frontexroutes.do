clear all

set more off

global main "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"
*global main "/home/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo"


global logs ${main}/logfiles/
global dta ${main}/Data/dta/

cd "${main}/Draft/tables"

import delimited ${main}/Data/raw/frontex/Monthly_detections_of_IBC_2021_11_04.csv

forval year = 2009(1)2018 {
	gen migrants`year' = jan`year' + feb`year' + mar`year' + apr`year' ///
		+ may`year' + jun`year' + jul`year' + aug`year' + sep`year' ///
		+ oct`year' + nov`year' + dec`year'
}

drop jan* feb* mar* apr* may* jun* jul* aug* sep* oct* nov* dec*


collapse (sum) migrants2009 (sum) migrants2010 (sum) migrants2011 (sum) migrants2012 /// 
		 (sum) migrants2013 (sum) migrants2014 (sum) migrants2015 (sum) migrants2016 ///
		 (sum) migrants2017 (sum) migrants2018, by(route)
		 
reshape long migrants, i(route) j(year)

encode route, gen(routeind)

drop route
rename routeind route

save  ${dta}frontexroutes.dta, replace
