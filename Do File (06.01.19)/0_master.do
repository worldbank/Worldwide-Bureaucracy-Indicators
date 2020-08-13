********************************************************************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*MASTER DO-FILE
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: June 2020
********************************************************************************

clear
set more off

*--------------------------------------------------------------------------------------------
*Part 0
*Prepare globals and define paths

global Path 	"D:/Public sector wages/WWBI"
global Logs 	"${Path}/Logs/"
global Do 		"${Path}/Do/"
global Data  	"${Path}/Data/"
global Input  	"${Data}/Input/"
global Output  	"${Data}/Output/"
global Temp		"${Data}/Temp/"


*Creating globals for file name 
global sA1  "${Temp}/summary1.dta"
global sA2  "${Temp}/summary2.dta"
global sA3  "${Temp}/summary3.dta"

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

*	We have used regional databases in processing the data to ensure managable file size 

global bases "EAP ECA EUSILC GLD HI-NON_OECD HI-OECD IDN LAC MENA SAR SSA"

*--------------------------------------------------------------------------------------------
*Part I
*Sample Selection

*------------------------------------------
*Part 1a
*Coverage - Defines temporal coverage (2000 - 2018), age (15+), WB Country Names 
 
*   REQUIRES: "${Input}ALL IN ONE REV 6_`var'.dta"	
*   CREATES : "${Input}ALL IN ONE REV 6_`var'_s2000.dta"	
	
	do 	"${Do}1a_coverage.do"
	
*------------------------------------------
*Part 1b
*Quality Checks - Summary of key variables for quality checks

*	REQUIRES: "${Input}ALL IN ONE REV 6_`var'_s2000.dta"	
*   CREATES : "${Temp}weighted_`var'.dta"
	
	do "${Do}1b_quality-checks.do"
	
*-------------------------------------------
*Part 1c
*Filters - Identify, tag, and remove surveys with incomplete data

*   REQUIRES:"${Temp}weighted_`var'.dta"
*	        :"${nput}ALL IN ONE REV 6_`var'_s2000.dta"
*	CREATES	:"${Temp}filters_data_`var'.dta"
*			:"${Data}selected_`var'.dta"
	
	do "${Do}1c_filters.do"

*-------------------------------------------
*Part 1d
*Wages - Constructs and harmonizes main wage and public employment variables

*	REQUIRES:"${Data}selected_`var'.dta"
*	CREATES :"${Data}LatestI2D2_`var'.dta"
	
	do "${Do}1d_wages.do"

*-------------------------------------------------------------------------------
*Part II
*Summary Statistics

*-------------------------------------------
*Part  2a
*Summary A - Indicators on public sector employment ratios

*	REQUIRES:"${Data}LatestI2D2_`var'.dta"
*	CREATES	:"${Temp}summaryA_`var'.dta"

    do "${Do}2a_SummaryA.do"
*-------------------------------------------

*-------------------------------------------
*Part  2b
*Summary B - Indicators on wage premium and wage differentials by gender 

*	REQUIRES:"${Data}LatestI2D2_`var'.dta"
*	CREATES: "${Temp}summaryB_`var'.dta"

    do "${Do}2b_SummaryB.do"

*-------------------------------------------
*Part 2c
*Summary C - Indicators on benefits and social protection

*	REQUIRES:"${Data}LatestI2D2_`var'.dta"
*	CREATES:"${Temp}summaryC_`var'.dta"
    
	do "${Do}2c_SummaryC.do"

*-------------------------------------------
*Part 2d
*Summary D - Generate indicators on demographic distribution of public and private workers

*	REQUIRES:"${Data}LatestI2D2_`var'.dta"
*	CREATES:"${Temp}summaryD_`var'.dta"
	
	do "${Do}2d_SummaryD.do"

*-------------------------------------------
*Part 2e
*Summary E - Indicators on employment and gender distribution by occupation/wage quantiles

*	REQUIRES:"${Data}LatestI2D2_`var'.dta"
*	CREATES:"${Temp}summaryE_`var'.dta"
    
	do "${Do}2e_SummaryE.do"

*-------------------------------------------
*Part 2f
*Summary F - Indicators on relative wage and share of tetiary education holder in public sector

*	REQUIRES:"${Data}LatestI2D2_`var'.dta"
*	CREATES:"${Temp}summaryF_`var'.dta"
	
	do "${Do}2f_SummaryF.do"

*-------------------------------------------------------------------------------
*Part III
*Merging, Outlier Analysis, and Exporting

*-------------------------------------------
*Part 3a
*Merging - Merge all summary statistics together from part 2a-2f

*	REQUIRES:"${Temp}summaryA_`var'.dta"
*			 "${Temp}summaryB_`var'.dta"
*			 "${Temp}summaryC_`var'.dta"
*			 "${Temp}summaryD_`var'.dta"
*			 "${Temp}summaryE_`var'.dta"
*			 "${Temp}summaryF_`var'.dta"
*	CREATES	:"${Output}Summary_WWBI.dta"

    do "${Do}3a_merge.do"

*-------------------------------------------
*Part 3b
*Outlier - Identifies and removes outliers and inconsistent observations  

*	REQUIRES:"${Output}Summary_WWBI.dta"
*	CREATES	:"${Output}WWBI_v1.1_clean.dta"

	do "${Do}3b_outlier.do"

*-------------------------------------------
*Part 3c
*Export - Preparing final dataset for exporting to excel  

*	REQUIRES:"${Output}WWBI_v1.1_clean.dta"
*	CREATES	:"${Do}WWBI_V1.1_final.dta"
*			:"${Do}WWBI_v1.1.xls"

	do "${Do}3c_export.do"
	
*-------------------------------------------------------------------------------	