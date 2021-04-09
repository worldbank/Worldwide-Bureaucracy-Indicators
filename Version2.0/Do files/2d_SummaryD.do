***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*2d_SummaryD
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: June 2020
********************************************************************************

/************************************************************************
*Demographic distribution of public and private workers
*************************************************************************/

* create indicators for demographic characterists of public and private sector paid employees including (1) age, (2) level of education, and (3) gender and (4) urban/rural split 

set more 1

foreach var of global bases {

use"${Data}LatestI2D2_`var'.dta", clear

****Drop surveys that have more than 30% missing value in age/gender/urban/education
drop if filter==3|filter==4
keep if ps1~=.

***Generate general demographic variable***
gen 	female = gender == 2 				if gender ~= .
gen 	age15_24 = age >= 15 & age <= 24 	if age ~= . 
gen 	age25_64 = age >= 25 & age <= 64 	if age ~= . 
gen 	age65p = age >= 65 & age < . 		if age ~= . 
gen 	ed0 = edulevel3 == 1 				if edulevel3 ~= . 
gen 	ed1 = edulevel3 == 2 				if edulevel3 ~= . 
gen 	ed2 = edulevel3 == 3 				if edulevel3 ~= .
gen 	ed3 = edulevel3 == 4 				if edulevel3 ~= .
gen 	rur = urb == 2 						if urb ~= .


***Generate demographic variable by sector***
local vars "female age age15_24 age25_64 age65p ed0 ed1 ed2 ed3 rur"
foreach n of numlist 0/1 {
	foreach v of local vars {
		gen `v'_`n' = `v' if ps1 == `n'
		gen nm_`v'_`n'=`v'~=. if empstat==1&ps1 == `n'
	}
}


***Collapse demogrphic indicators by sector on sample level*****

collapse (mean) female_0 ///
		 (mean) 	age_mean_0 = age_0  ///
		 (median)	age_med_0 = age_0  ///
		 (mean)		/// 
					age15_24_0 age25_64_0 age65p_0  ///
					ed0_0 ed1_0 ed2_0 ed3_0  ///
					rur_0  /// 
		 (mean) 	female_1 ///
		 (mean) 	age_mean_1 = age_1 ///
		 (median) 	age_med_1 = age_1 ///
		 (mean) 	/// 
					age15_24_1 age25_64_1 age65p_1 ///
					ed0_1 ed1_1 ed2_1 ed3_1 ///
					rur_1 ///
					nm_female_0 nm_age_0 nm_age15_24_0 nm_age25_64_0 nm_age65p_0 ///
					nm_ed0_0 nm_ed1_0 nm_ed2_0 nm_ed3_0 nm_rur_0 ///
					nm_female_1 nm_age_1 nm_age15_24_1 nm_age25_64_1 nm_age65p_1 ///
					nm_ed0_1 nm_ed1_1 nm_ed2_1 nm_ed3_1 nm_rur_1 ///
					///
		(rawsum) obs_female_0=nm_female_0  obs_age_0=nm_age_0 obs_age15_24_0=nm_age15_24_0  ///
					obs_age25_64_0=nm_age25_64_0 obs_age65p_0=nm_age65p_0 obs_ed0_0=nm_ed0_0 obs_ed1_0=nm_ed1_0 ///
					obs_ed2_0=nm_ed2_0 obs_ed3_0=nm_ed3_0 obs_rur_0=nm_rur_0 ///
					obs_female_1=nm_female_1 obs_age_1=nm_age_1 obs_age15_24_1=nm_age15_24_1 obs_age25_64_1=nm_age25_64_1  ///
					obs_age65p_1=nm_age65p_1 obs_ed0_1=nm_ed0_1 obs_ed1_1=nm_ed1_1 obs_ed2_1=nm_ed2_1 ///
					obs_ed3_1=nm_ed3_1 obs_rur_1=nm_rur_1 ///
		 [w=wgt], by(ccode year sample sample1)

 sort sample1
save "${Temp}summaryD_`var'.dta", replace

}
