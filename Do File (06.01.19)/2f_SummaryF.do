***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*2d_SummaryD
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: June 2020
********************************************************************************

**************************************************************************************
*Relative wage and Percentage of tetiary education holder work in public sector
**************************************************************************************


	
**** Percentage of tetiary education holder work in public sector*****
foreach var of global bases {
	set more 1
	
	use "${Data}LatestI2D2_outlier_`var'.dta", clear

	keep if ps2~=.&edulevel3 == 4
	gen psedu3=ps2 if ps2~=.&edulevel3 == 4
	gen nm_psedu3=psedu3~=. if ps2~=.&edulevel3 == 4

	collapse (mean) psedu3 nm_psedu3  (rawsum)obs_psedu3=nm_psedu3 [pw=wgt], by(ccode year sample sample1)
	sort sample1
save "${Temp}ps_`var'.dta", replace
}


*******relative wage*****

foreach var of global bases {
set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear 
recode occup (5/8=6) (10 11 99=6) (9=5), gen(occupnew)
label define occup 1"Senior officials" 2"Professionals" 3"Technicians" 4"Clerks" 5"Elementary occupations" 6 "others"
label value occupnew occup
	forvalues x = 0(1)1 {
	
preserve
keep if wpw_lcu_touse==1
gen wagewk = wpw_lcu if ps1 == `x'

forvalues n=1(1)6 {
gen wage_occup`n' = wagewk if occup == `n'
gen nm_wage_occup`n'=wage_occup`n'~=.  if ps1 == `x'& occup == `n'
}
	
	collapse (mean) mean_`x'_1 = wage_occup1 (mean) mean_`x'_2 = wage_occup2 (mean) mean_`x'_3 = wage_occup3 ///
	(mean) mean_`x'_4 = wage_occup4 (mean) mean_`x'_5 = wage_occup5 (mean) mean_`x'_6 = wage_occup6    ///
	(rawsum) obs_wage`x'_occup1=nm_wage_occup1  obs_wage`x'_occup2=nm_wage_occup2  obs_wage`x'_occup3=nm_wage_occup3 ///
	obs_wage`x'_occup4=nm_wage_occup4  obs_wage`x'_occup5=nm_wage_occup5  obs_wage`x'_occup6=nm_wage_occup6   ///
	 [w=wgt], by(ccode countryname year sample sample1)
		
	forvalues c=1(1)6  {
	
		gen rwoccup_`x'_`c'= mean_`x'_`c'/mean_`x'_4
	}

	keep sample1 rwoccup_`x'_1 rwoccup_`x'_2 rwoccup_`x'_3 rwoccup_`x'_5 rwoccup_`x'_6 ///
	obs_wage`x'_occup1 obs_wage`x'_occup2  obs_wage`x'_occup3 obs_wage`x'_occup4 obs_wage`x'_occup5  obs_wage`x'_occup6
	sort sample1
	save "${Temp}relativewage`x'.dta", replace
restore

}

use "${Temp}relativewage0.dta", clear
    merge 1:1 sample1 using "${Temp}relativewage1.dta"
    tab _m
    drop _m
save "${Temp}relativewage_`var'.dta", replace
}

********Merge file****************************************


foreach var of global bases {
    use "${Temp}ps_`var'.dta", clear
    merge 1:1 sample1 using "${Temp}relativewage_`var'.dta"
    tab _m
    drop _m
    order sample sample1
    sort sample1
    save "${Temp}summaryF_`var'.dta", replace
	}
