***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*2c_SummaryC
*Called by 0_master.do
*Created by: Faisal Baig
*Last Edit by: Faisal Baig
*First version: February 2020
*Latest version: June 2020
********************************************************************************

/**********************************************************************************
Benefits
**********************************************************************************/
capture log close
set more 1

*creates indicators of proportion of public and private sector employyes with (1) formal contracts, (2) health insurance, (3) social secruity, (4) union membership




********************************************************************************
*Proportion of individual with contract/health insurance/social secruity/union 

foreach var of global bases {

use "${Data}LatestI2D2_`var'.dta", clear

log using "${Logs}\Benefits_`var2'log.", replace

collapse	(count) cont_obs	= contract ///
			(count) hins_obs	= healthins ///
			(count) ssec_obs	= socialsec ///
			(count) union_obs	= union ///
			(mean) cont			= contract ///
			(mean) hins			= healthins ///
			(mean) ssec			= socialsec ///
			(mean) union		= union ///
			[pw=wgt], by(sample1 ps1)

gen cont_pub 	= cont	if ps1 ==1
gen cont_prv	= cont 	if ps1 ==0
gen hins_pub 	= hins 	if ps1 ==1
gen hins_prv 	= hins 	if ps1 ==0
gen ssec_pub 	= ssec 	if ps1 ==1
gen ssec_prv 	= ssec 	if ps1 ==0
gen union_pub	= union	if ps1 ==1
gen union_prv	= union	if ps1 ==0
			
collapse (sum) cont_pub cont_prv hins_pub hins_prv ssec_pub ssec_prv union_pub union_prv, by(sample1)

save "${Temp}summaryC_`var'.dta", replace
log close
}