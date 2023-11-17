clear
set more off

***********************Randomization Mechanics***********************

*We have a number of schools that we want to assign to either treatment or control
*First example: we will do a simple randomization
*Second example: we will stratify by the school's gender composition and language of instruction
*Third example: we will stratify by language, gender and average pre-test score of the school (a continuous variable)

***Important variables
*schoolid 
*language
*gender
*pretest_mean

use balsakhi_data.dta, clear


***Part 1: Simple Randomization***

*Create a random number
sort schoolid
set seed 20131115
gen random = uniform()


*Sort by this random number (because the sorting is random, there is no statistical reason why the frst half of the observations would be any different from the second half)
sort random, stable

*Create a variable “treatment” which equals 1 if treatment and 0 if control
gen treatment = 0
replace treatment = 1 if _n <= _N/2
*OR 
*gen treatment =_n <= _N/2

*Note: we could have decided that treatment = 1 if _n > _N 
*Now we have a variable that defines which schools are treatment and which are control


***Part 2: Stratified Randomization by Langugage and Gender***

*Drop the variables previously created
drop random treatment

*Create a random number
sort schoolid
set seed 20131115
gen random = uniform()

*Within each language and gender, sort randomly
sort language gender random, stable

*Figure out how many schools there are in each stratum
by language gender: gen strata_size = _N

*Assign a value reflecting the current (random) order of these schools in each stratum
by language gender: gen strata_index = _n

*Create a variable “treatment” which equals 1 if treatment and 0 if control, which is based oly on the random order
gen treatment = 0
replace treatment = 1 if strata_index <= (strata_size/2)

*Now we have a variable that defines which schools are treatment and which are control, stratified by language and gender


***Part 3: Stratified Randomization by Gender, Language and Average Pre-test score***
 
*Drop the variables previously created
drop random treatment strata_size strata_index

*Create a random number
sort schoolid
set seed 20131115
gen random = uniform()

*Sort by language, gender and pretest_mean
sort language gender pretest_mean

*Figure out how many schools are in each stratum
by language gender: gen strata_size = _N

*We want to split schools into groups of 4, where each group represents 2 treatment schools and 2 control schools, and have similar pretest_means. So, for example, if there are 40 schools in a stratum, we want to break the stratum into 10 groups: (40/4 = 10)
by language gender: gen group = group(strata_size/4)

*Within each group, sort randomly
sort language group random, stable

*Figure out how many schools are in each group (should be 4, but may be less if the number of schools is not a multiple of 4). 
sort language gender group
by language gender group: gen groupsize = _N

*Assign a value reflecting the current (random) order of these schools in each group (should take on a value of 1, 2, 3 or 4).
by language gender group: gen groupindex = _n

*If the group has less than 4 schools, make the value equal to 0.
replace groupindex = 0 if groupsize != 4

*Create a variable “treatment” which equals 1 if treatment and 0 if control (for the schools that are in groups of 4).
gen treatment = 0
replace treatment = 1 if groupindex == 1 | groupindex == 2

*For the schools in groups of less than 4, we can randomize as if they are all equivalent and part of the same language/gender.
sum school if groupindex == 0
scalar oddSCHOOL = r(N)

sort groupindex random, stable
replace treatment = 1 if _n <= (oddSCHOOL/2) & groupindex == 0

*Now we have a variable that defines which schools are treatment and which are control, stratified by language, gender and pretest_mean.

***Part 4: Multiple Treatments***

*Drop the variables previously created
drop random strata_size group groupsize groupindex treatment

*Create a random number
sort schoolid
set seed 20131115
gen random = uniform()

*Sort by this random number (because the sorting is random, there is no statistical reason why the frst half of the observations would be any different from the second half)
sort random, stable

*Create a variable “treatment” which equals 1 if treatment 1, 2 if treatment 2, 3 if treatment 1&2 and 0 if control
gen treatment = 0
replace treatment = 1 if _n <= _N/4
replace treatment = 2 if _n > _N/4 & _n <= _N/2
replace treatment = 3 if _n > _N/2 & _n<= _N*3/4

