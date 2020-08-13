***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*2a_SummaryA
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: June 2020
********************************************************************************

/**********************************************************************************
Share of public sector over paid and total employees, total and by age, sex, and location 
**********************************************************************************/

set more 1
cap log close

* Creates indicators for sub slassificaitons of public sector employment (as a sahre of total, paid and formal employment) by genders, urban/rural split

foreach var of global bases {
	use "${Data}LatestI2D2_`var'.dta", clear

*construct share of public sector over paid and total employees, by age, sex, and location
foreach n of numlist 1/2 {
	gen 	ps`n'_1524=ps`n' if age>=15&age<25
	gen 	ps`n'_2564=ps`n' if age>=25&age<65
	gen 	ps`n'_65p=ps`n' if age>=65&age<120

	gen 	ps`n'_mal=ps`n' if gender==1
	gen 	ps`n'_fem=ps`n' if gender==2
	
	gen 	ps`n'_urb=ps`n' if urb==1
	gen 	ps`n'_rur=ps`n' if urb==2
}

***Generate proportion of non-missing observation in constructing public employement indictaors and its sub-indicators**
preserve
local n=1
gen one=empstat==1
gen nm_ps1=ps1<2 if empstat==1
gen nm_ps1_1524=ps1_1524<2 if empstat==1&age>=15&age<25
gen nm_ps1_2564=ps1_2564<2 if empstat==1&age>=25&age<65
gen nm_ps1_65p=ps1_65p<2 if empstat==1&age>=65&age<120
gen nm_ps1_mal=ps1_mal<2 if empstat==1&gender==1
gen nm_ps1_fem=ps1_fem<2 if empstat==1&gender==2	
gen nm_ps1_urb=ps1_urb<2 if empstat==1&urb==1
gen nm_ps1_rur=ps1_rur<2 if empstat==1&urb==2

***Collapse public sector as a share of paid employment and sub indicators on sample level*****

collapse (mean) ps`n' nm_ps`n' ///
	ps`n'_1524 nm_ps`n'_1524  ps`n'_2564 nm_ps`n'_2564  ps`n'_65p nm_ps`n'_65p  ///
	ps`n'_mal nm_ps`n'_mal ps`n'_fem nm_ps`n'_fem ///
	ps`n'_urb nm_ps`n'_urb  ps`n'_rur  nm_ps`n'_rur ///
	(sem) ps`n'_se=ps`n' ///
	ps`n'_1524_se=ps`n'_1524  ps`n'_2564_se=ps`n'_2564  ps`n'_65p_se=ps`n'_65p  ///
	ps`n'_mal_se=ps`n'_mal  ps`n'_fem_se=ps`n'_fem  ///
	ps`n'_urb_se=ps`n'_urb  ps`n'_rur_se=ps`n'_rur  ///
	(rawsum) obs_ps`n'=nm_ps`n'  obs_ps`n'_1524=nm_ps`n'_1524 obs_ps`n'_2564=ps`n'_2564 obs_ps`n'_65p=nm_ps`n'_65p ///
	obs_ps`n'_mal=nm_ps`n'_mal obs_ps`n'_fem=ps`n'_fem obs_ps`n'_urb=nm_ps`n'_urb obs_ps`n'_rur=nm_ps`n'_rur ///
	obs_pub=ps`n' obs_pemp=one ///
	[w=wgt], by(ccode year sample sample1)
save "${sA1}", replace
restore

***Generate proportion of non-missing observation in constructing public sector as a share of total empoyment and its sub-indicators**
preserve
local n=2
gen one=lstatus==1
gen winfo=lstatus~=. if age>=15
gen x=1
gen nm_ps2=ps2<2 if lstatus==1
gen nm_ps2_1524=ps2_1524<2 if lstatus==1&age>=15&age<25
gen nm_ps2_2564=ps2_2564<2 if lstatus==1&age>=25&age<65
gen nm_ps2_65p=ps2_65p<2 if lstatus==1&age>=65&age<120
gen nm_ps2_mal=ps2_mal<2 if lstatus==1&gender==1
gen nm_ps2_fem=ps2_fem<2 if lstatus==1&gender==2	
gen nm_ps2_urb=ps2_urb<2 if lstatus==1&urb==1
gen nm_ps2_rur=ps2_rur<2 if lstatus==1&urb==2

***Collapse public sector as a share of total empoyment and sub indicators on sample level*****
collapse (mean) ps`n' nm_ps`n' ///
	ps`n'_1524 nm_ps`n'_1524  ps`n'_2564 nm_ps`n'_2564  ps`n'_65p nm_ps`n'_65p  ///
	ps`n'_mal nm_ps`n'_mal ps`n'_fem nm_ps`n'_fem ///
	ps`n'_urb nm_ps`n'_urb  ps`n'_rur  nm_ps`n'_rur ///
	(sem) ps`n'_se=ps`n' ///
	ps`n'_1524_se=ps`n'_1524  ps`n'_2564_se=ps`n'_2564  ps`n'_65p_se=ps`n'_65p  ///
	ps`n'_mal_se=ps`n'_mal  ps`n'_fem_se=ps`n'_fem  ///
	ps`n'_urb_se=ps`n'_urb  ps`n'_rur_se=ps`n'_rur  ///
	(rawsum) obs_ps`n'=nm_ps`n'  obs_ps`n'_1524=nm_ps`n'_1524 obs_ps`n'_2564=ps`n'_2564 obs_ps`n'_65p=nm_ps`n'_65p ///
	obs_ps`n'_mal=nm_ps`n'_mal obs_ps`n'_fem=ps`n'_fem obs_ps`n'_urb=nm_ps`n'_urb obs_ps`n'_rur=nm_ps`n'_rur ///
	obs_emp=one obs_sample=winfo obs_fullsample=x ///
	[w=wgt], by(ccode year sample sample1)
save "${sA2}", replace
restore	

*******Public sector as a share of formal empoyment****	
preserve 
collapse (mean) ps3=ps3[w=wgt], by(ccode year sample sample1)
sort sample1
save "${sA3}", replace
restore	
	

*Merge three data files into one (SummaryA)
use "${sA1}", clear
order sample ccode year ps1 ps1_se ps1_15* ps1_25* ps1_65p* ps1_mal* ps1_fem* ps1_urb* ps1_rur* obs_pub obs_pemp
tempfile sum1
save `sum1', replace
use "${sA2}", clear
order sample ccode year ps2 ps2_se ps2_15* ps2_25* ps2_65p* ps2_mal* ps2_fem* ps2_urb* ps2_rur* obs_emp obs_sample obs_fullsample
tempfile sum2
save `sum2', replace

use `sum1', clear
merge 1:1 sample1 using `sum2', assert(3) nogen
merge 1:1 sample1 using "${sA3}", assert(3) nogen


***merge with filter info*****
***replace disaggregated indicator with missing value if they didn't pass age/gender/urban filter*

 merge 1:1 sample1 using "${Temp}filters_data_`var'.dta", keepusing(filter) assert(2 3) keep(3) nogen
 
 local ps  ps1_1524 ps1_1524_se ps1_2564 ps1_2564_se ps1_65p ps1_65p_se ps1_mal ps1_mal_se ps1_fem ps1_fem_se ps1_urb ps1_urb_se ps1_rur  ///
 ps1_rur_se nm_ps1_1524 nm_ps1_2564 nm_ps1_65p nm_ps1_mal nm_ps1_fem nm_ps1_urb nm_ps1_rur obs_ps1_1524 obs_ps1_2564 obs_ps1_65p obs_ps1_mal ///
 obs_ps1_fem obs_ps1_urb obs_ps1_rur ps2_1524 ps2_1524_se ps2_2564 ps2_2564_se ps2_65p ps2_65p_se ps2_mal ps2_mal_se ps2_fem ps2_fem_se ///
 ps2_urb ps2_urb_se ps2_rur  ps2_rur_se  nm_ps2_1524 nm_ps2_2564 nm_ps2_65p nm_ps2_mal nm_ps2_fem nm_ps2_urb ///
 nm_ps2_rur obs_ps2_1524 obs_ps2_2564 obs_ps2_65p obs_ps2_mal obs_ps2_fem obs_ps2_urb obs_ps2_rur 

 foreach n of local ps {
replace `n'=. if filter==3
 }
 

save "${Temp}summaryA_`var'.dta", replace

}






