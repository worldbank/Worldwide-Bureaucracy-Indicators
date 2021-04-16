***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*3a_merge
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: June 2020
********************************************************************************

*****Keep surveys from 2000 onwards and keep observation that are 15 years older 

set more 1

foreach var of global bases {

	use "${Temp}summaryA_`var'.dta", clear
	order ccode year sample sample1 obs_pub obs_pemp obs_emp obs_sample ps1* ps2*

**Only Matched master or using observations &unmatched master observation are allowed
*because all survey will have data on summaryA but some surveys don't pass certain 
*filter and thus we don't generate summaryB-F for those surveys

	merge 1:1 sample1 using "${Temp}summaryB_`var'.dta", assert (1 3) nogen
	merge 1:1 sample1 using "${Temp}summaryC_`var'.dta", assert (1 3) nogen
	merge 1:1 sample1 using "${Temp}summaryD_`var'.dta", assert (1 3) nogen
	merge 1:1 sample1 using "${Temp}summaryE_`var'.dta", assert (1 3) nogen
	merge 1:1 sample1 using "${Temp}summaryF_`var'.dta", assert (1 3) nogen
	merge 1:1 sample1 using "${Temp}summaryG_`var'.dta", assert (1 3) nogen
	merge 1:1 sample1 using "${Temp}summaryH_`var'.dta", assert (1 3) nogen

	sort ccode
	
save "${Temp}summarytable0_`var'.dta", replace

****Merge countryname world_region incgroup lending from WDI
    
use "${Temp}summarytable0_`var'.dta", clear

//	replace ccode = "ROU" if ccode == "ROM"

//	merge m:1 ccode using "${Input}country_codes.dta", keepusing(countryname ccode world_region incgroup lending eu oecd) assert (2 3) keep(3) nogen

//	order countryname ccode year sample world_region incgroup 
	
	format ps1* ps2* %6.5f
	*format *wg* wage* %10.2f
	format obs* %10.0f

	sort sample1

save "${Output}summary_`var'.dta", replace
}