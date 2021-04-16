***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*1c_filters
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: June 2020
********************************************************************************

*Filters 
**********************************
cap log close
set more 1

**Creating a series of data quality filters that identify surveys that exceed the predteremined levels of missing observations or coding erros based on (1) Employment, (2) Wages, (3) Demographics, and (4) Education variables for removal from further processing.

foreach var of global bases { 

	cap	log using "${Logs}filters_`var'.log", replace

	set more off
	
	use "${Temp}weighted_`var'", clear

*f0x: do not ask labor variables
	**f01: Does not have labor status (lstatus) for anyone [lstatus == 1(Employed), 2(Unemployed), 3(Non-in-labor force)]
	gen 	f01=m_lstatus==1
	**f02: Does not have employment status (empstat) for anyone with lstatus==1 [empstat == 1(Paid Employee ), 2(Non-Paid Employee), 3(Employer), 4(Self-employed)]
	gen 	f02=m_empstat==1 if m_lstatus~=1
	**f03: Does not have sector of ocupations (ocusec) for anyone with lstatus==1 [ocusec = 1(Public sector, Central Government, Army, NGO), 2(Private)
	gen 	f03=m_ocusec==1 if m_lstatus~=1

*f1x: more than 40% miss ing
	*f11: Missing more than 40% of lstatus 
	gen 	f11=m_lstatus>0.4 if m_lstatus~=1
	*f12: Missing more than 40% empstat if lstatus==1
	gen 	f12=m_empstat>0.4 if m_empstat~=.
	*f13: Missing more than 40% ocusec if empstat==1
	gen 	f13=mpubsec_emp1>0.4 if mpubsec_emp1~=.

	*All employed
	gen 	f5b=lstatus1==1
	*tab 	sample if f5b==1

	*All employees, no self-employed or employers
	gen 	empstat1_2=empstat1+empstat2
	gen 	empstat3_4=empstat3+empstat4
	gen 	f5c=empstat1_2==1
	gen     f5d=empstat3_4==1

	*All paid employees private or all public
	gen 	f5e=(pubsec_emp1==1|pubsec_emp1==0) if pubsec_emp1~=.

	*Wage - Missing more than 40% of wage for paid employees
	gen 	f6=1 if m_wpm>0.4 | m_wpm== .
	gen 	f6a =1 if m_unitwage>0.4 | m_unitwage== .


*Others variables
	*Missing more than 40% of age, gender,urban
	gen 	f7=(m_age>0.4|m_gender>0.4|m_urb>0.4)

	*Missing more than 40% of education (years or levels)
	gen 	f8=(m_edulevel3>0.4) //Use definition of education edulevel3
   

*Label variable names
lab var f01 	"Without lstatus"
lab var f02 	"Without ocusec if employed"
lab var f03 	"Without empstat if employed"
lab var f11 	"Missing 40%+ lstatus"
lab var f12 	"Missing 40%+ empstat if employed"
lab var f13 	"Missing 40%+ ocusec if paid employee"
lab var f5b 	"All in sample are employed"
lab var f5c 	"All employed are employees (paid or unpaid)"
lab var f5d 	"All paid employees work in public sector or all in private"
lab var f6 		"More than 40% of paid employees missing wage"
lab var f6a     "Missing wage unit for all paid employees"
lab var f7 		"More than 40% missing age, gender, urban"
lab var f8 		"More than 40% missing education (years or level)"
lab var empstat1_2 "Paid or unpaid employee %"
lab var empstat3_4 "Employer or self employed %"


*FILTER1 Employment
cap drop F1
gen 	F1 = inlist(1, f01, f02, f03, f11, f12, f13, f5b, f5c, f5d,f5e)

*FILTER2 Wage
gen 	F2=1 if f6==1|f6a==1

*FILTER3 Age,gender,urban
gen 	F3=1 if f7==1

*FILTER4 Education
gen 	F4=1 if f8==1


lab var F1 "filt. for employment"
lab var F2 "filt. for wage"
lab var F3 "filt. for AgeGender"
lab var F4 "filt. for Education"

*Generating a variable that categorizes when the survey did not pass the filter
gen filter = .
replace filter = 0 if F4 == 0
replace filter = 1 if F1 == 1  							 
replace filter = 2 if F1 == 0 & F2 == 1 
replace filter = 3 if F1 == 0 & F3 == 1
replace filter = 4 if F1 == 0 & F4 == 1


label define filter 0 "Passed all" 1 "Failed Employment" 2 "Failed Wage" 3 "Failed Demogragraphics" 4 "Failed Education" 
label values filter filter 
 
*save the filter information
save "${Temp}filters_data_`var'.dta", replace 
 

**********************************
*Applying Filters 
**********************************
 
*Keep all surveys that passed employment filter 
keep if filter ==0|filter==2|filter==3|filter==4
keep ccode year world_region sample sample1 filter countryname

sort ccode year sample

*Save surveyname country name year for surveys that will be used to construct WWBI
save "${Temp}has_all_`var'.dta", replace

*Generating final selected samples: Merge "has_all" dataset with original I2D2 file
use "${Input}ALL IN ONE_7_`var'_s2000.dta", clear

sort ccode year sample

merge m:1 ccode year sample using "${Temp}has_all_`var'.dta", assert(1 3) keep (3) nogen

save "${Data}selected_`var'.dta", replace

log close

}
