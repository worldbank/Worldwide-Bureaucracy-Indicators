***********************************
*WORLD WIDE BUREAUCRACY INDICATORS
*1b
*Called by 1_Sample.do
*First version: December 2016
*Last version: June 2019
*Camilo Bohorquez-Penuela & Rong Shi
***********************************
/*Summary of most important variables by sample for quality check and to creating filters 
Create variables to collapse at a country(&year) level,  this information will be used to filter surveys 
without information or missing information on main labor variables
*/

set more 1

foreach var of global bases {
	
	set more off
	log using "${logs}collapse_`var'.log", replace
	use "${input}ALL IN ONE REV 6_`var'_s2000.dta", clear

********************************************************************************
*For employement variable.
	
	
*Created variable that record the labor module application age 
*Obs in our sample are 15 years above, so replace minimum age for labor module with 15 if they're lower than 15.

gen 	minagelb = lb_mod_age
replace minagelb = 15 if minagelb <= 15

*For phl_2009_i2d2_fies there is no lb_mod_age, although it has lstatus ~= .
* minage_lb = 15 (the lowest age for which lstatus is available in this sample) is assigned for this paticular sample
replace minagelb = 15 if sample == "phl_2009_i2d2_fies" & minagelb == .

*Generate variable to count missing lstatus for those above labor module application age 
gen m_lstatus = lstatus > 3 if age >= minagelb 

*Generate labor status dummy to calculate percentage of obs are employed, unemployed and non-labor force

foreach n of numlist 1(1)3 {
	gen 	lstatus`n' = lstatus ==`n' 	if lstatus <= 3
	replace lstatus`n' = . 				if age < lb_mod_age
}

*Generate variable to count missing empstat for those who are employed
*For empstat==5 (Other),  we consider them as missing

gen m_empstat = empstat > 4 if lstatus == 1

foreach n of numlist 1(1)4 {
	gen 	empstat`n' = empstat ==`n' 	if empstat <= 4
	replace empstat`n' = . 				if lstatus ~= 1
}

**Generate 

gen empstat_miscode1 = empstat > 4 & empstat < .
gen empstat_miscode2 = empstat <= 4 if lstatus ~= 1

*Generate variable to count missing ocusec for those who are employed
*
gen m_ocusec = ocusec > 4 if lstatus == 1

foreach n of numlist 1(1)4 {
	gen 	ocusec`n' = ocusec == `n' 	if ocusec <= 4
	replace ocusec`n' = . 				if lstatus ~= 1
}

*generate public sector dummy 
gen 	pubsec = ocusec
recode 	pubsec 2=0 3 4=1 5/.=.

*ocusec_miscode1: values of ocusec higher than 4 (based on current I2D2 codebook )
gen ocusec_miscode1 = ocusec > 4 & ocusec < . 
*ocusec_miscode2: has ocusec but is not employed
gen ocusec_miscode2 = ocusec <= 4 if lstatus ~= 1 

*Crossing empstat and public sector dummy
foreach n of numlist 1(1)4 {
	gen pubsec_emp`n' = pubsec 		if empstat == `n'
	gen mpubsec_emp`n' = m_ocusec 	if empstat ==`n'
}
***missing empstat but not missing ocusec
gen 	pubsec_m_empstat = m_empstat if pubsec <= 1

********************************************************************************
*For wage-related variable

*Generate dummy for paid employee
gen 	pemp = 1 					if lstatus == 1 & empstat == 1

*Count Missing wage (if lstatus==1)
gen 	m_wage = missing(wage) 	    if lstatus==1
gen 	wage_miscode2 = wage < . 	if lstatus!=1

*Generate dummy for zero wage
gen 	z_wage = wage == 0 			if lstatus==1

*Crossing empstat and missing wage
foreach n of numlist 1(1)4 {
	gen mwage_emp`n'= m_wage 	if empstat == `n'
}

*Crossing empstat and zero wage
foreach n of numlist 1(1)4 {
	gen zwage_emp`n'=z_wage 	if empstat==`n'
}

*Missing wage unit
gen m_unitwage = missing(unitwage) 	    if wage > 0 & wage < .
gen unitwage_miscode3 = unitwage < . 	if wage ==0 | wage == .
tab unitwage 							if wage > 0 & wage < . , gen(uw)

*Missing whours 
gen m_whours = missing(whours) 		 	if lstatus == 1 & empstat == 1
gen whours_miscode1 = whours > 168 	if lstatus == 1 & empstat == 1
gen whours_miscode2 = whours < . 	if lstatus ~= 1
gen whours_zero = whours == 0 		if wage > 0 & wage < . & lstatus == 1 & empstat == 1


*****Construct different wage variable to generate median for weekly/monthly/hourly wage

*Wage per month

gen 	wpm = .
replace wpm = wage *$dailyconversion			if unitwage == $daily
replace wpm = wage *$weeklyconversion 		    if unitwage == $weekly
replace wpm = wage *$biweeklyconversion 	    if unitwage == $biweekly
replace wpm = wage *$bimonthlyconversion		if unitwage == $bimonthly
replace wpm = wage *$monthlyconversion	        if unitwage == $monthly
replace wpm = wage *$quaterlyconversion 		if unitwage == $quaterly
replace wpm = wage *$halfyearconversion		    if unitwage == $halfyear
replace wpm = wage *$annuallyconversion 		if unitwage == $annually
replace wpm = wage *$hourlyconversion		    if unitwage == $hourly
replace wpm = . if pemp ~= 1
replace wpm = . if wpm == 0 & pemp == 1

*Wage per week
gen 	wpw = wpm / 4.345
*Wage per hour
gen 	wph = wpw / whours

*Missing wage for paid employees
gen 	m_wpm = missing(wpm) if pemp == 1
gen 	m_wph = missing(wph) if pemp == 1
gen 	m_wpw = missing(wpw) if pemp == 1

*wage per unit
foreach n of numlist 1(1)9 {
	gen wageperunit`n' = wage if (unitwage == `n' & pemp == 1 & wage ~= 0)
}


********************************************************************************
**For individual characteristics

*Missing education (year or levels)
gen m_educy = missing(educy)

foreach n of numlist 1(1)3 {
	cap gen m_edulevel`n' = missing(edulevel`n')
}

*Missing age
gen m_age = missing(age)

*Missing gender
gen m_gender = gender > 2

*Missing urban/rural
gen m_urb = (urb == 0 | urb > 2)
gen urb1 = urb == 1 if (urb == 1 | urb == 2)
gen urb2 = urb == 2 if (urb == 1 | urb == 2)

*Missing industry
gen m_industry1 = missing(industry) 					if lstatus == 1 & empstat == 1
gen m_industry2 = (industry >10 & industry < .) 	if lstatus == 1 & empstat == 1
gen industry_miscode2 = industry < . 				if lstatus ~= 1

*Missing occupation
gen m_occup1 = missing(occup) 			if lstatus == 1 & empstat == 1
gen m_occup2 = (occup > 9 & occup < .) 	if lstatus == 1 & empstat == 1
gen occup_miscode2 = occup < . 			if lstatus ~= 1


**********
*Collapse for filters
???MORE DETAIL PLEASE INCLUDING ON COLLAPSE BY???
collapse /// 
	m_lstatus 	lstatus1-lstatus3 ///
	m_ocusec 	ocusec1-ocusec4 	ocusec_miscode* ///
	m_empstat 	empstat1-empstat4 	empstat_miscode* ///
	pubsec_emp* /// 
	mpubsec_emp* ///
	pubsec_m_empstat /// 
	m_wage 		wage_miscode2 		mwage_emp* ///
	z_wage               			zwage_emp* ///
	m_unitwage 	unitwage_miscode3 ///
	uw* ///
	m_whours 	whours_miscode1  whours_miscode2 whours_zero /// 
	m_educy 	m_edulevel* ///
	m_age 		m_gender ///
	m_urb 		urb1 				urb2 /// 
	m_industry1 m_industry2 		industry_miscode2 ///
	m_occup1 	m_occup2 			occup_miscode2 ///
	wpm wpw wph ///
	m_wpm m_wph m_wpw ///
	lb_mod_age  minagelb ///	
	(p50) wpm_med=wpm wpw_med=wpw wph_med=wph ///
		wageperunit* ///
	(min) minage=age ///
	[w=wgt] , by(ccode countryname year sample sample1 world_region)
save "${Datatemp}\weighted_`var'.dta", replace	
log close
}


