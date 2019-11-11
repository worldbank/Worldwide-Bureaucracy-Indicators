***************************************
*PUBLIC SECTOR EMPLOYMENT
*Summary Table by country
*Created by: Rong Shi
*First version: December 2016
*Latest version: June 2019
*************************************
*Called from Master.do

/************************************************************************
Employment stats and gender distribution by occupation and wage quantile
*************************************************************************/

*Employment rates
set more 1


foreach var2 of global bases {

use "${Data}LatestI2D2_outlier_`var2'.dta", clear

*Calcualte employment and labor force participating rate

gen lfp_r = (lstatus == 1 | lstatus == 2) 	if lstatus ~= .
gen emp_r = lstatus == 1 					if lfp_r == 1 & lstatus ~= .
gen paidemp_r = empstat == 1 				if emp_r == 1 & empstat ~= .

gen nm_lfp_r=lfp_r~=.
gen nm_emp_r=emp_r~=. if lfp_r == 1
gen nm_paidemp_r=paidemp_r~=. if emp_r == 1

*Calcualte employment and labor force participating rate by age

foreach var of varlist lfp_r emp_r paidemp_r {
	gen `var'_1524=`var' if age>=15&age<=24
	gen  nm_`var'_1524=nm_`var' if age>=15&age<=24
}


*Gender distribution by ccupation

* Occupation have more than these 11 values in some sample, but they occupy only a small  
local occup 1 2 3 4 5 6 7 8 9 10 99

foreach var of local occup {

   *Proportion of female work in public sector as occupation `var'
	gen occup_`var'_pu = .
	replace occup_`var'_pu = 1 if occup == `var' & gender == 2 & ps1 == 1
	replace occup_`var'_pu = 0 if occup == `var' & gender == 1 & ps1 == 1
	gen nm_occup_`var'_pu=occup_`var'_pu~=. if ps1 ==1 &occup == `var'

    *Proportion of female work in private sector as occupation `var'
	gen occup_`var'_pr = .
	replace occup_`var'_pr = 1 if occup == `var' & gender == 2 & ps1 == 0
	replace occup_`var'_pr = 0 if occup == `var' & gender == 1 & ps1 == 0
	gen nm_occup_`var'_pr=occup_`var'_pr~=. if ps1 ==0 &occup == `var'
}
	
	

**Gender distribution by wage quintile (using weekly wage)

*Calcualte the wage quantile by sample
levelsof sample1, local(sample1)

gen quintile_pu = .
gen quintile_pr = .

forvalues x = 1(1)5 {
	gen quintile_`x'_pu = .
	gen nm_quintile_`x'_pu = .
}

forvalues x = 1(1)5 {
	gen quintile_`x'_pr = .
	gen nm_quintile_`x'_pr = .
}
	gen nm_wagewk=wpw_lcu~=.
	


foreach var of local sample1 {
        sum nm_wagewk if sample1 == `var'
		
		if r(mean)~=0 {
	quietly xtile quintile_pu_`var' = wpw_lcu if ps1 == 1 & sample1 == `var' [w=wgt], nq(5)
	quietly xtile quintile_pr_`var' = wpw_lcu if ps1 == 0 & sample1 == `var' [w=wgt], nq(5)
	
	quietly replace quintile_pu = quintile_pu_`var' if sample1 == `var'
	quietly replace quintile_pr = quintile_pr_`var' if sample1 == `var'
	
	quietly drop quintile_pu_`var' quintile_pr_`var'	

forvalues x = 1(1)5 {
	replace quintile_`x'_pu = 1 if quintile_pu == `x' & gender == 2 & ps1 == 1
	replace quintile_`x'_pu = 0 if quintile_pu == `x' & gender == 1 & ps1 == 1
	replace nm_quintile_`x'_pu=quintile_`x'_pu~=.  if quintile_pu == `x'& ps1 == 1
}

forvalues x = 1(1)5 {
	replace quintile_`x'_pr = 1 if quintile_pr == `x' & gender == 2 & ps1 == 0
	replace quintile_`x'_pr = 0 if quintile_pr == `x' & gender == 1 & ps1 == 0
	replace nm_quintile_`x'_pr=quintile_`x'_pr~=.  if quintile_pr == `x'& ps1 == 0
}
}
}


collapse (mean) lfp_r nm_lfp_r emp_r nm_emp_r paidemp_r nm_paidemp_r lfp_r_1524 nm_lfp_r_1524 emp_r_1524 nm_emp_r_1524 paidemp_r_1524  ///
 nm_paidemp_r_1524 occup_*_pu nm_occup_*_pu occup_*_pr nm_occup_*_pr quintile_pu quintile_pr quintile_*_pu nm_quintile_*_pu quintile_*_pr ///
 nm_quintile_*_pr (rawsum) obs_lfp_r=nm_lfp_r obs_emp_r=nm_emp_r obs_paidemp_r=nm_paidemp_r obs_lfp_r_1524=nm_lfp_r_1524  obs_emp_r_1524=nm_emp_r_1524 ///
 obs_paidemp_r_1524=nm_paidemp_r_1524 obs_occup_1_pu=nm_occup_1_pu obs_occup_2_pu=nm_occup_2_pu obs_occup_3_pu=nm_occup_3_pu obs_occup_4_pu=nm_occup_4_pu  ///
 obs_occup_5_pu=nm_occup_5_pu obs_occup_6_pu=nm_occup_6_pu obs_occup_7_pu=nm_occup_7_pu  obs_occup_8_pu=nm_occup_8_pu obs_occup_9_pu=nm_occup_9_pu ///
 obs_occup_10_pu=nm_occup_10_pu obs_occup_99_pu=nm_occup_99_pu  obs_occup_1_pr=nm_occup_1_pr obs_occup_2_pr=nm_occup_2_pr obs_occup_3_pr=nm_occup_3_pr obs_occup_4_pr=nm_occup_4_pr  ///
 obs_occup_5_pr=nm_occup_5_pr obs_occup_6_pr=nm_occup_6_pr obs_occup_7_pr=nm_occup_7_pr  obs_occup_8_pr=nm_occup_8_pr obs_occup_9_pr=nm_occup_9_pr ///
 obs_occup_10_pr=nm_occup_10_pr obs_occup_99_pr=nm_occup_99_pr obs_quintile_1_pu=nm_quintile_1_pu obs_quintile_2_pu=nm_quintile_2_pu obs_quintile_3_pu=nm_quintile_3_pu ///
 obs_quintile_4_pu=nm_quintile_4_pu obs_quintile_5_pu=nm_quintile_5_pu  obs_quintile_1_pr=nm_quintile_1_pr obs_quintile_2_pr=nm_quintile_2_pr obs_quintile_3_pr=nm_quintile_3_pr ///
 obs_quintile_4_pr=nm_quintile_4_pr obs_quintile_5_pr=nm_quintile_5_pr [w=wgt], by(ccode year sample sample1)


sort sample1
save "${Datatemp}\summaryE_`var2'.dta", replace

}
