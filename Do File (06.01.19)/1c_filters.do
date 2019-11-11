***********************************
*WORLD WIDE BUREAUCRACY INDICATORS
*1c
*Called by Master.do
*Camilo Bohorquez-Penuela&Rong shi
*First version: December 2016
*Last version: June 2019
**********************************
*Filters 
**********************************
set more 1

**Creating filters based on the collapsed data

foreach var of global bases { 

set more off
log using "${Logs}filters_`var'.log", replace
use "${Datatemp}\weighted_`var'", clear

*f0x: do not ask labor variables
**f01: Does not have lstatus for anyone
gen 	f01=m_lstatus==1

**f02: Does not have empstat for anyone with lstatus==1 (empstat=other is consider missing)
gen 	f02=m_empstat==1 if m_lstatus~=1

**f03: Does not have ocusec for anyone with lstatus==1
gen 	f03=m_ocusec==1 if m_lstatus~=1

*f1x: more than 30% miss ing
*f11: Missing more than 30% of lstatus 
gen 	f11=m_lstatus>0.3 if m_lstatus~=1
*f12: Missing more than 30% empstat if lstatus==1
gen 	f12=m_empstat>0.3 if m_empstat~=.
*f13: Missing more than 30% ocusec if empstat==1
gen 	f13=mpubsec_emp1>0.3 if mpubsec_emp1~=.

*All employed (VNM_2010_vhlss)
gen 	f5b=lstatus1==1
*tab 	sample if f5b==1

*All employee, no self-employed or employer
gen 	empstat1_2=empstat1+empstat2
gen 	empstat3_4=empstat3+empstat4
gen 	f5c=empstat1_2==1

*All paid employees private or all public
gen 	f5d=(pubsec_emp1==1|pubsec_emp1==0) if pubsec_emp1~=.

*Wage - Missing more than 30% of wage for paid employees
gen 	f6=(m_wpm>0.3) if m_wpm<.

*Others variables
*Missing more than 30% of age, gender,urban
gen 	f7=(m_age>0.3|m_gender>0.3|m_urb>0.3)

*Missing more than 30% of education (years or levels)
gen 	f8=(m_edulevel3>0.3) //Use definition of education edulevel3
   

*Label variable names
lab var f01 	"Without lstatus"
lab var f02 	"Without ocusec if employed"
lab var f03 	"Without empstat if employed"
lab var f11 	"Missing 30%+ lstatus"
lab var f12 	"Missing 30%+ empstat if employed"
lab var f13 	"Missing 30%+ ocusec if paid employee"
lab var f5b 	"All in sample are employed"
lab var f5c 	"All employed are employees (paid or unpaid)"
lab var f5d 	"All paid employees work in public sector or all in private"
lab var f6 		"More than 30% of paid employees missing wage"
lab var f6a     "Missing wage unit for all paid employees"
lab var f7 		"More than 30% missing age, gender, urban"
lab var f8 		"More than 30% missing education (years or level)"
lab var empstat1_2 "Paid or unpaid employee %"
lab var empstat3_4 "Employer or self employed %"

*FILTER1 Employment
cap drop F1
gen 	F1 = inlist(1, f01, f02, f03, f11, f12, f13, f5b, f5c, f5d)

*FILTER2 Wage
gen 	F2=F1
replace F2=1 if f6==1|f6a==1


*FILTER3 Age,gender,urban
gen 	F3=F2
replace F3=1 if f7==1

*FILTER4 Education
local F=4
gen 	F4=F3
replace F4=1 if f8==1


lab var F1 "filt. for employment"
lab var F2 "filt. for wage"
lab var F3 "filt. for AgeGender"
lab var F4 "filt. for Education"

*Generating a variable that categorizes when the survey did not pass the filter
gen filter = .
replace filter = 0 if F4 == 0
replace filter = 1 if F1 == 1  							 
replace filter = 2 if F1 == 0 & F2 == 1 
replace filter = 3 if F1 == 0 & F2 == 0 & F3 == 1
replace filter = 4 if F1 == 0 & F2 == 0 & F3 == 0 & F4 == 1


label define filter 0 "Passed all" 1 "Employment" 2 "Wage" 3 "Age, gender" ///
 4 "Education" 
label values filter filter 
 
*save the filter information
save "${Datatemp}filters_data_`var'.dta", replace 
 
 
**********************************
*Applying Filters 
**********************************
 
*Keep all surveys that passed employment filter 
keep if filter ==0|filter==2|filter==3|filter==4
keep ccode year world_region sample sample1 filter countryname
sort ccode year sample
*Save surveyname country name year for surveys that will be used to construct WWBI
save "${Datatemp}has_all_`var'.dta", replace

*Generating final selected samples: Merge "has_all" dataset with original I2D2 file
use "${input}ALL IN ONE REV 6_EAP_s2000.dta", clear
sort ccode year sample
merge m:1 ccode year sample using "${Datatemp}has_all_EAP.dta", assert(1 3) keep (3) nogen
save "${Data}selected_`var'.dta", replace
log close
}
 
