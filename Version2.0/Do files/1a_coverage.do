***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*1a_coverage
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: Nov 2020
********************************************************************************

*****Keep surveys from 2000 onwards and keep observation that are 15 years older 
set more 1

ssc install dups

foreach var of global bases {
	use "${Input}ALL IN ONE_7_`var'.dta", clear
	
cap drop world_region 
	*Keep data after 2000 
	keep if year >= 2000
	
	*droppng observations below the age of 15
	keep if age >= 15

*The survey tto_1970_2011_i2d2_ipums.dta is coded with two seperate years (2000 and 2011) which causes problems with the merge command and both years are an identical match for the two other surveys for 2000 and 2011 respectively

drop if sample == "tto_1970_2011_i2d2_ipums.dta"

*Recreating a sample1 variable since the original is very noisy
cap drop sample1
		encode sample, gen(sample1)
 
	*Merge World Bank preffered country name nomanclature to the dataset using country codes
	 
    *Matched master and using observations and unmatched using observations are allowed, keep only matched data
    *For all country code in the master file, there should be a match in the using file, thus there should not be any unmatched masster observations.
	merge m:1 ccode using "${Input}country_codes.dta", assert(2 3)  keep(3)
	
	*Save regional database since 2000
	save "${Input}ALL IN ONE_7_`var'_s2000.dta", replace
}
