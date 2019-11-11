***********************************
*WORLD WIDE BUREAUCRACY INDICATORS
*1a
*Called by 1_Sample.do
*First version: December 2016
*Last version: June 2019
*Camilo Bohorquez-Penuela&Rong Shi (working at the World Bank Bureaucracy Lab)
**********************************

*****Keep surveys from 2000 onwards and keep observation that are 15 years older 

foreach var of global bases {
	use "${input}ALL IN ONE REV 6_`var'.dta", clear
	
	*Keep data after 2000 
	keep if year >= 2000
	
	*Keep if age >= 15
	keep if age >= 15
	
	*Merge countryname (WDI name) to the dataset based on country code
	
    *Matched master and using observations and unmatched using observations are allowed, keep only matched data
    *For all country code in the master file, there should be a match in the using file, thus there should not be any unmatched masster observations.
	merge m:1 ccode using "${input}country_code_name.dta", assert(2 3)  keep(3)
	*Save regional database since 2000
	save "${input}ALL IN ONE REV 6_`var'_s2000.dta", replace
}

/************************************************************************************
NOTE: I use the regional databases during the sample selection process in order 
to manage lighter data in comparison to merge all the databases into a bigger one	
*************************************************************************************/

