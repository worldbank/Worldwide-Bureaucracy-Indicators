********************************************************************************
*WORLD WIDE BUREAUCRACY INDICATORS, 2000-present
*MASTER DO-FILE
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*First version: December 2016
*Latest version: June 2019
********************************************************************************

clear
set more off

*--------------------------------------------------------------------------------------------
*Part 0
*Prepare globals and define paths


*Setting up all necessary global paths

global Path 	"D:\Public sector wages\publicsectoremp\reproduce (excluding outlier)"
global Data  	"${Path}\Data\"
global input  	"${Data}\Input\"
global Out  	"${Data}\Output\"
global Datatemp "${Path}\Data\Temp\"
global Logs 	"${Path}\logs\"
global Do 		"${Path}\Do\"

*Creating globals for file name 
global sA1  "${Datatemp}\summary1.dta"
global sA2  "${Datatemp}\summary2.dta"
global sA3  "${Datatemp}\summary3.dta"

*Creating globals for wage unit conversion

global daily   1
global weekly  2
global biweekly  3
global bimonthly 4
global monthly 5
global quaterly 6
global halfyear 7
global annually 8
global hourly 9

global dailyconversion   (5 * 4.345)
global weeklyconversion   4.345
global biweeklyconversion  (4.345 / 2) 
global bimonthlyconversion  0.5
global monthlyconversion   1
global quaterlyconversion  1/3
global halfyearconversion  1/6
global annuallyconversion  1/12
global hourlyconversion   (whours * 4.345)


*Generating a macro that helps to call all the regional i2d2 databases
global bases "EAP ECA HI-NON_OECD HI-OECD LAC MENA SAR SSA"


*--------------------------------------------------------------------------------------------
*Part I
*Select Sample

*------------------------------------------
*Part 1a
*Keeps surveys on or after 2000 & members aged 15 or older
*Paste countryname and countrycode from WDI
   *REQUIRES: "${input}ALL IN ONE REV 6_`var'.dta"	
   *CREATES: "${input}ALL IN ONE REV 6_`var'_s2000.dta"	
	
	do 	"${Do}\1a_Since 2000.do"
*------------------------------------------

*------------------------------------------
*Part 1b
*Collapse -Summary of most important variables by sample to create filters-- 
	*REQUIRES: "${input}ALL IN ONE REV 6_`var'_s2000.dta"	
    *CREATES: "${Datatemp}\weighted_`var'.dta"
	
	do "${Do}\1b_Collapse.do"
*-------------------------------------------

*-------------------------------------------
*Part 1c
*Create filters to select sample(survey) with most complete data for each country
    *REQUIRES:"${Datatemp}\weighted_`var'.dta"
	*          "${input}ALL IN ONE REV 6_`var'_s2000.dta"
	*CREATES: "${Datatemp}filters_data_`var'.dta", which contain full info about collapsed
	*data from part 1b, filters applied, and which filters each survey failed to pass
	*"${Data}selected_`var'.dta" contains only the surveys that passed employemnt filters
	
	do "${Do}\1c_Filters.do"
*--------------------------------------------

*-------------------------------------------
*Part 1d
	*Construct Wage variables and public employment variables
	*REQUIRES:"${Data}selected_`var'.dta"
	*CREATES: "${Data}LatestI2D2_`var'.dta"
	do "${Do}\1d_WageVars.do"
*-------------------------------------------

*-------------------------------------------
*Part 1e
	*Change value in problemtic sample
	*REQUIRES:"${Data}LatestI2D2_`var'.dta"
	*CREATES: "${Data}LatestI2D2_`var'.dta"
	do "${Do}\1e_change.do"
*-------------------------------------------

*-------------------------------------------------------------------------------
*Part II
*Summary Table

*-------------------------------------------
*Part  2a
*Generate indicators on public sector employment 
	*REQUIRES:"${Data}LatestI2D2_`var'.dta"
	*CREATES:"${Datatemp}\summaryA.dta"
    do "${Do}\2a_SummaryA.do"

*-------------------------------------------
*Part  2b
*Generate indicators on wage premium and wage differentials by gender 
    *REQUIRES:"${Data}LatestI2D2_`var'.dta"
	*CREATES: "${Datatemp}\summaryB.dta"
    do "${Do}\2b_SummaryB.do"

*-------------------------------------------
*Part 2c
*Generate indicators on benefits
    *REQUIRES:"${Data}LatestI2D2_`var'.dta"
	*CREATES:"${Datatemp}\summaryC"
    do "${Do}\2c_SummaryC.do"

*-------------------------------------------
*Part 2d
*Generate indicators on demographic distribution of public and private workers
    *REQUIRES:"${Data}LatestI2D2_`var'.dta"
	*CREATES:"${Datatemp}\summaryD"
     do "${Do}\2d_SummaryD.do"

*-------------------------------------------
*Part 2e
*Generate indicators on employment rates and Gender distribution by ccupation/wage quantile
    *REQUIRES:"${Data}LatestI2D2_`var'.dta"
	*CREATES:"${Datatemp}\summaryE"
    do "${Do}\2e_SummaryE.do"

*-------------------------------------------
*Part 2f
*Generate indicators on relative wage and percentage of tetiary education holder work in public sector
    *REQUIRES:"${Data}LatestI2D2_`var'.dta"
	*CREATES:"${Datatemp}\summaryF"
    do "${Do}\2f_SummaryF.do"

*-------------------------------------------
*Merge all summary statistics together from part 2a-2f
*
set more 1

foreach var of global bases {

use "${Datatemp}\summaryA_`var'.dta", clear
order ccode year sample sample1 obs_pub obs_pemp obs_emp obs_sample ps1* ps2*

**Only Matched master or using observations &unmatched master observation are allowed
*because all survey will have data on summaryA but some surveys don't pass certain 
*filter and thus we don't generate summaryB-F for those surveys
merge 1:1 sample1 using "${Datatemp}\summaryB_`var'.dta" , assert (1 3) nogen
merge 1:1 sample1 using "${Datatemp}\summaryC_`var'.dta", assert (1 3) nogen
merge 1:1 sample1 using "${Datatemp}\summaryD_`var'.dta", assert (1 3) nogen
merge 1:1 sample1 using "${Datatemp}\summaryE_`var'.dta", assert (1 3) nogen
merge 1:1 sample1 using "${Datatemp}\summaryF_`var'.dta", assert (1 3) nogen
sort ccode
save "${Datatemp}\summarytable0_`var'.dta", replace

****Merge countryname region regioncode incgroup developing from WDI
use "${Datatemp}\summarytable0_`var'.dta", clear
merge m:1 ccode using "${input}\country_code_name.dta", keepusing(countryname countrycode) assert (2 3) keep(3) nogen
merge m:1 countrycode using "${input}\countrycodes.dta", keepusing(region regioncode incgroup developing) assert (2 3) keep(3) nogen
order countryname ccode year sample region incgroup 
order sample1, after(developing)
format ps1* ps2* %6.5f
*format *wg* wage* %10.2f
format obs* %10.0f
sort sample1
save "${Out}\summary_`var'.dta", replace

}


****append all summary dataset from different region together

use"${Out}\summary_EAP.dta", clear

foreach var of global bases {
 append using  "${Out}\summary_`var'.dta"
 }
save "${Out}\summary_I2D2.dta",replace

*-------------------------------------------------------------------------------
*Part III
*Outlier Check
do "${Do}\3_Outlier analysis.do"

