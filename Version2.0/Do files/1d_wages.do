***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*1d_wages
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: June 2020
********************************************************************************

*Wage Variables 
*************************************************************

* Creates the main measures of public sector employment as a share of (1) Total Employment, (2) Paid Employment, and (3) Formal Employment. Also transforms  wage information from all surveys to the same set of three indicators (wage per month, wages per week and wages per hour) and cr

cap log close
set more 1


foreach var of global bases { 

	log using "${Logs}WageVars_`var'.log", replace
	
	use "${Data}selected_`var'.dta", clear
		
	*Is paid employee
	
	gen pemp = 1 if lstatus == 1 & empstat == 1
	
	*Wage per month
	gen wpm = .
	*daily
	replace wpm = wage *$dailyconversion			if unitwage == $daily
	*weekly
	replace wpm = wage *$weeklyconversion 		    if unitwage == $weekly
	*every two weeks
	replace wpm = wage *$biweeklyconversion 	    if unitwage == $biweekly
	*every two months
	replace wpm = wage *$bimonthlyconversion		if unitwage == $bimonthly
	*monthly
	replace wpm = wage *$monthlyconversion	        if unitwage == $monthly
	*quarterly
	replace wpm = wage *$quaterlyconversion 		if unitwage == $quaterly
	*every six months
	replace wpm = wage *$halfyearconversion		    if unitwage == $halfyear
	*annually
	replace wpm = wage *$annuallyconversion 		if unitwage == $annually
	*hourly
	replace wpm = wage *$hourlyconversion		    if unitwage == $hourly
	*other unitwage, keeps wage as missing
	
	*replace wage=. if not paid employee or if wpm==0
	replace wpm = . if pemp ~= 1
	gen 	pemp_z_wpm = ( wpm == 0) if pemp == 1 
	gen 	pemp_miss_wpm =( wpm == .) if pemp == 1
	replace wpm = . if pemp_z_wpm == 1

	*Wage per week
	gen 	wpw = wpm / 4.345
	*Wage per hour
	gen 	wph = wpw / whours

	foreach var2 of varlist wpm wpw wph {
		gen 	`var2'_lcu = `var2'
		drop 	`var2'
	}

	gen whours_zero = whours == 0 if wage > 0 & wage < . & pemp == 1 & whours ~= .
	gen whours_miss = whours == . if wage > 0 & wage < . & pemp == 1

	label var wpm_lcu "Monthly wage (LCU)"
	label var wpw_lcu "Weekly wage (LCU)"
	label var wph_lcu "Hourly wage (LCU)"
	lab var pemp_z_wpm "Monthly wage is zero (paid employee)"
	lab var pemp_miss_wpm "Monthly wage is missing (paid employee)"

	*Public sector, considering only paid employees (option 3 & 4 is assumed to be public, 5+ missing)
	gen 		ps1 = ocusec
	recode 		ps1 2=0 3 4=1 5/.=.
	replace 	ps1 = . if lstatus ~= 1
	replace 	ps1 = . if empstat > 1
	label var 	ps1 "Paid employee working in public sector"
	lab def lps1 1 "Paid employee/public sector" 0 "Paid employee/private sector"
	lab val ps1 lps1

	*Public sector paid employees, considering all employed (only paid employees are considered as public sector)
	gen 		ps2 = ocusec
	recode 		ps2 2=0 3 4=1 5/.=.
	replace 	ps2 = . if lstatus ~= 1
	replace 	ps2 = 0 if lstatus == 1 & (empstat == 2 | empstat == 3 | empstat == 4|empstat==5)
	label var 	ps2 "Employed as public sector paid employee"
	lab def lps2 1 "Public sector paid employee" 0 "Employed, not public sector paid employee"
	lab val ps2 lps2
	
	*Formal employee
gen fe=.
	cap gen contract = .
	cap gen socialsec =.
	cap gen healthins =.
	cap gen union=.
	
	replace fe=1 if  contract==1|socialsec==1|healthins==1|union==1
	replace fe=0 if  contract==0&socialsec==0&healthins==0&union==0
	
	label variable fe "formal employee"

* Public employee as a share of formal employment 
gen ps3=.
replace ps3=1 if ps1==1&fe==1
replace ps3=0 if ps1==0&fe==1
label variable ps3 "Formal employee work in public sector"
lab def lps3 1 "Public sector formal employee" 0 "Private sector formal employee"
lab val ps3 lps3

	
	save "${Data}LatestI2D2_`var'.dta", replace
	log close
}	


