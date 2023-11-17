clear all
import delimited "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo/Data/raw/stat_treatment/asylum_eurostat/migr_asydcfstq/migr_asydcfstq_1_Data.csv", encoding(ISO-8859-1) delim(";")
keep if decision == "Total" | decision == "Total positive decisions"
keep if year >= 2015 & year <= 2017
egen tot_pos = sum(value) if decision == "Total positive decisions" & sex == "Total", by(geo)
egen tot = sum(value) if decision == "Total" & sex == "Total", by(geo)
collapse tot tot_pos, by(geo)
gen rates = tot_pos/tot

encode geo, gen(country)




clear all
import delimited "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo/Data/raw/stat_treatment/asylum_eurostat/migr_asydcfsta/migr_asydcfsta_1_Data.csv", encoding(ISO-8859-1) delim(";")
keep if decision == "Total" | decision == "Total positive decisions"
keep if time >= 2015 & time <= 2017
egen tot_pos = sum(value) if decision == "Total positive decisions" & sex == "Total", by(geo)
egen tot = sum(value) if decision == "Total" & sex == "Total", by(geo)
collapse tot tot_pos, by(geo)
gen rates = tot_pos/tot

encode geo, gen(country)

keep if country == 2 | country ==11 | country ==12 | country ==17 | country ==30 | country == 35





clear all
import delimited "/Users/giacomobattiston/Dropbox/ricerca_dropbox/Lapa-Lapa/LuciaElianaGiacomo/Data/raw/stat_treatment/asylum_eurostat/migr_asydcfina/migr_asydcfina_1_Data.csv", encoding(ISO-8859-1) delim(";")
keep if decision == "Total" | decision == "Total positive decisions"
keep if time >= 2015 & time <= 2017
egen tot_pos = sum(value) if decision == "Total positive decisions" & sex == "Total", by(geo)
egen tot = sum(value) if decision == "Total" & sex == "Total", by(geo)
collapse tot tot_pos, by(geo)
gen rates = tot_pos/tot

encode geo, gen(country)

keep if country == 2 | country ==11 | country ==12 | country ==17 | country ==30 | country == 35











**eu
local l 1
qui sum tot if country == 2
mata: asylum_table[`l', 1] = `r(mean)'
qui sum tot_pos if country == 2
mata: asylum_table[`l', 2] = `r(mean)'
qui sum rate if country == 2
mata: asylum_table[`l', 3] = `r(mean)'

**belgium
local l 2
qui sum tot if country == 1
mata: asylum_table[`l', 1] = `r(mean)'
qui sum tot_pos if country == 1
mata: asylum_table[`l', 2] = `r(mean)'
qui sum rate if country == 1
mata: asylum_table[`l', 3] = `r(mean)'

**france
local l 3
qui sum tot if country == 3
mata: asylum_table[`l', 1] = `r(mean)'
qui sum tot_pos if country == 3
mata: asylum_table[`l', 2] = `r(mean)'
qui sum rate if country == 3
mata: asylum_table[`l', 3] = `r(mean)'

**germany
local l 4
qui sum tot if country == 4
mata: asylum_table[`l', 1] = `r(mean)'
qui sum tot_pos if country == 4
mata: asylum_table[`l', 2] = `r(mean)'
qui sum rate if country == 4
mata: asylum_table[`l', 3] = `r(mean)'

**italy
local l 5
qui sum tot if country == 5
mata: asylum_table[`l', 1] = `r(mean)'
qui sum tot_pos if country == 5
mata: asylum_table[`l', 2] = `r(mean)'
qui sum rate if country == 5
mata: asylum_table[`l', 3] = `r(mean)'

**spain
local l 6
qui sum tot if country == 6
mata: asylum_table[`l', 1] = `r(mean)'
qui sum tot_pos if country == 6
mata: asylum_table[`l', 2] = `r(mean)'
qui sum rate if country == 6
mata: asylum_table[`l', 3] = `r(mean)'

**uk
local l 7
qui sum tot if country == 7
mata: asylum_table[`l', 1] = `r(mean)'
qui sum tot_pos if country == 7
mata: asylum_table[`l', 2] = `r(mean)'
qui sum rate if country == 7
mata: asylum_table[`l', 3] = `r(mean)'


mata: st_matrix("asylum_table", asylum_table)

matrix colnames asylum_table = tot tot_pos pos_rate
matrix rownames asylum_table = eu be fr de it sp uk

*esttab matrix(asylum_table) using asylum_table.csv

gen country_string = ""
replace country_string = "Belgium" if country == 1
replace country_string = "France" if country == 3
replace country_string = "Germany" if country == 4
replace country_string = "Italy" if country == 5
replace country_string = "Spain" if country == 6
replace country_string = "England" if country == 7

gen asylum_rate = rate * 100

keep country_string asylum_rate

*save "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo/logistics/03_data/04_final_data/output/asylum.dta"
