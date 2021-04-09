***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 2.0, 2000-2020
*2h_SummaryH
*Called by 0_master.do
*Created by: Turkan Mukhtarova
*Last Edit by: Faisal Baig
*First version: December 2020
*Latest version: February 2021
********************************************************************************

cap log close
set more 1

/**********************************************************************************
Wage Premiums for employees in education, health and public administration industries
**********************************************************************************/

*Creates wage premium indicators by running wage regressions in sequence and storing main coefficients and other summary statistics of interest.

*(1) public sector wage premium (without controls), by industry				(compared to private paid employees)	[not included in WWBI]
*(2) public sector wage premium (with controls), by industry				(compared to private paid employees)
*(3) public sector wage premium (with controls), by industry				(compared to private formal employees)
*(4) public sector wage premium for females (with controls), by industry	(compared to private paid employees)
*(5) public sector wage premium for males (with controls), by industry		(compared to private paid employees)
*(6) public sector wage premium by gender (with controls), by industry		(compared to male public paid employees)
*(7) private sector wage premium by gender (with controls), by industry		(compared to male public paid employees)	[not included in WWBI]


/**********************************************************************************
Wage related indicator
**********************************************************************************/


*Exclude top 0.1%  wage per week in local currenycy (wpw_lcu) by sample from our analysis
*Keep only surveys that passed all filter when calculating wage premium

foreach var of global bases {

	use "${Temp}Industry_`var'.dta", clear

*--------- KEEPING RELEVANT VARIABLE TO REDUCE FILE SIZE -----------------------*

keep ccode year gender age urb ocusec wage unitwage whours lstatus empstat occup contract educy edulevel1 edulevel2 edulevel3 wgt sample healthins socialsec union sample1 filter pemp wpm_lcu wpw_lcu wph_lcu ps1 ps2 fe ps3 hlt edu pub_adm

*--------- WINSORIZING OUTLIERS FROM THE SAMPLE -------------------------------*

// Mark observations if wpe_lcu is less than 99.9% in wage distribution within each sample, 
	winsor2 wpw_lcu, cuts(0 99.9)suffix(_win) by(sample1) /*winsorizing wpw_lcu at top 0.1% by sample*/

// exclude top 0.1% wage from our analysis to eliminate possible biase caused by extreme outliers 
	gen wpw_lcu_touse=wpw_lcu==wpw_lcu_win  

*--------- EXCLUDING SAMPLES THAT DO NOT HAVE ALL NECESSARY VARIABLES ---------*

// Keep only surveys that passed all filter when constructing wage related indicators
	drop if filter!=0

// Keep only surveys where industry dummies were created
	egen no_hlt = max(hlt), by(sample1) 
	egen no_edu = max(edu), by(sample1) 
	egen no_adm = max(pub_adm), by(sample1) 
	
	gen no_industry = 1 if no_adm == . // & no_hlt== . & no_edu == .
		drop if no_industry==1

*--------- CONSTRUCTING INDICATORS NEEDED FOR REGRESSIONS ---------------------*

// Creating a Female Dummy
	gen female = 1 if gender == 2
		replace female = 0 if gender ==1

	rename pub_adm adm

// Industrial Decomposition

	foreach var2 of varlist edu hlt adm{

	// Public paid workers, by industry (compared to private sector workers)
		gen `var2'_paid = 1 if ps1 == 1 & `var2'==1
			replace `var2'_paid = 0 if ps1 == 0 & `var2'==1
			label var `var2'_paid "Public sector paid `var2' workers (share of all paid `var2' workers)"

	// Public formal workers, by industry (compared private sector workers)
		gen `var2'_formal = 1 if ps3 == 1 & `var2'==1
			replace `var2'_formal = 0 if ps3 == 0 & `var2'==1
			label var `var2'_formal "Public sector formal `var2' workers (share of all formal `var2' workers)"

	// Public female paid workers, by industry (compared to private sector workers)
		gen `var2'_fem = 1 if `var2'_paid == 1 & female==1
			replace `var2'_fem = 0 if female == 1 & `var2'_paid == 0
			label var `var2'_fem "Female `var2' workers in the public sector (share of all female `var2' workers)"		

	// Public male paid workers, by industry (compared to private sector workers)
		gen `var2'_mal = 1 if `var2'_paid == 1 & female==0
			replace `var2'_mal = 0 if female == 0 & `var2'_paid == 0
			label var `var2'_mal "Male `var2' workers in the public sector (share of all male `var2' workers)"

	// Public paid workers, by industry (compared to public paid workers in other industries)
		gen paid_`var2' = 1 if `var2' == 1 & ps1==1
			replace paid_`var2' = 0 if `var2' == 0 & ps1 ==1
			label var paid_`var2' "`var2' workers in public sector (share of paid public sector employees)"
				
	// Public female paid workers, by industry (compared to public male paid workers)
		gen fem_`var2' = 1 if female == 1 & paid_`var2'==1
			replace fem_`var2' = 0 if female == 0 & paid_`var2' == 1
			label var fem_`var2' "Female `var2' workers (share of public sector `var2' workers)"

	// Private paid workers, by industry (compared to private paid workers in other industries)
		gen private_`var2' = 1 if `var2' == 1 & ps1==0
			replace private_`var2' = 0 if `var2' == 0 & ps1 ==0
			label var private_`var2' "`var2' workers in private sector (share of paid private sector employees)"

	// Private female paid workers, by industry (compared to private male paid workers)
		gen private_fem_`var2' = 1 if female == 1 & private_`var2'==1
			replace private_fem_`var2' = 0 if female == 0 & private_`var2'==1
			label var private_fem_`var2' "Female `var2' workers (share of private sector `var2' workers)"

	}

foreach var3 of varlist edu_paid edu_formal edu_fem edu_mal paid_edu fem_edu private_edu private_fem_edu hlt_paid hlt_formal hlt_fem hlt_mal paid_hlt fem_hlt private_hlt private_fem_hlt adm_paid adm_formal adm_fem adm_mal paid_adm fem_adm private_adm private_fem_adm  {

	bysort sample1: gen `var3'_obs = sum(`var3')
}

	save "${Temp}Industry_outlier_`var'.dta",replace
}
*/
********************************************************************************
*Wage Premium, by industry

set more 1

global industries "edu hlt" 

foreach var of global bases {
	
foreach ind of global industries {

	cap log close
	log using "${Logs}summaryH_`var'.log", replace

********************************************************************************
****Public sector wage premium (without controls) for public paid employees, by industry
//------------------------------ NOT INCLUDED IN WWBI -------------------------------//

set more 1

use "${Temp}Industry_outlier_`var'.dta", clear 

	drop if no_`ind'==.
	drop if `ind'_paid_obs <10
	

levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu ocusec edulevel3 age gender female urb empstat sample1 lstatus wgt `ind'_paid ///
		if empstat==1&sample1==`s'&`ind'_paid~=.  ///
		using "${Temp}Industry_outlier_`var'.dta", clear
	disp "------------------------------`s'------------------------------"
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values for each sample*/

		*Sample

		gen lwagewk=ln(wpw_lcu) 
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0  {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk i.`ind'_paid [pw=wgt], robust	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
            local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))

			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
    /*if lwagewk have only missing value then replace with missing*/
		else if r(mean)==0 {
			sum sample1 
			local sam=r(mean)
			matrix A[1,1]=`sam'
		}
	
	/*combine sector from each sample together as a matrix*/
		if `sam'==`min' {
			disp "`sam'"
			matrix eqs=A
		}
		else if `sam'>`min' {
			disp "`sam'"
			matrix eqs=eqs\A
		}
	}


*Rename all variables
mat coln eqs=sample1 coefreg_nocont_`ind' coefreg_se_nocont_`ind' reg_obs_nocont_`ind' r2_nocont_`ind' p_nocont_`ind'
clear

*Save the matrix
svmat eqs,names(col) 
	drop if sample1 == .
	sort sample1

save "${Temp}ind_nocont_`ind'_`var'.dta", replace


********************************************************************************
******Public sector wage premium (with controls) for public paid employees, by industry

set more 1

use "${Temp}Industry_outlier_`var'.dta", clear 

	drop if no_`ind'==.
	drop if `ind'_paid_obs <10
	
levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'


**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu ocusec edulevel3 age gender female urb empstat sample1 lstatus wgt `ind'_paid ///
		if empstat==1&sample1==`s'&`ind'_paid~=.  ///
		using "${Temp}Industry_outlier_`var'.dta", clear
	disp "------------------------------`s'------------------------------"
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values for each sample*/

		*Sample

		gen lwagewk=ln(wpw_lcu) 
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0  {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk i.`ind'_paid ib3.edulevel3 c.age c.age#c.age i.female i.urb [pw=wgt], robust	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
            local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))

			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
    /*if lwagewk have only missing value then replace with missing*/
		else if r(mean)==0 {
			sum sample1 
			local sam=r(mean)
			matrix A[1,1]=`sam'
		}
	
	/*combine sector from each sample together as a matrix*/
		if `sam'==`min' {
			disp "`sam'"
			matrix eqs=A
		}
		else if `sam'>`min' {
			disp "`sam'"
			matrix eqs=eqs\A
		}
	}

	
*Rename all variables
mat coln eqs=sample1 coefreg_cont_`ind' coefreg_se_cont_`ind' reg_obs_cont_`ind' r2_cont_`ind' p_cont_`ind'
clear

*Save the matrix
svmat eqs,names(col) 
drop if sample1 == .
sort sample1

save "${Temp}ind_cont_`ind'_`var'.dta", replace



********************************************************************************
******Public sector wage premium (with controls) for public formal employees, by industry

set more 1

use "${Temp}Industry_outlier_`var'.dta", clear 

	drop if no_`ind'==.
	drop if `ind'_paid_obs <10
	drop if `ind'_formal_obs <10
	
levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu  ocusec edulevel3 age gender female urb empstat sample1 lstatus wgt `ind'_paid `ind'_formal ///
		if empstat==1&sample1==`s' ///
		using "${Temp}Industry_outlier_`var'.dta", clear
	disp "------------------------------`s'------------------------------"
	*quietly {
		

		mat A=[.,.,.,.,.,.]  /*construct vectore to store 6 values*/

		*Sample
		gen lwagewk=ln(wpw_lcu)
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		local nmwage=r(mean)
		gen nm_`ind'_formal=`ind'_formal~=.
		sum  nm_`ind'_formal
		/*if lwagewk and ps3 have non missing value then store all estimates*/
		if r(mean)~=0&`nmwage'~=0 {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
		
			sum sample1 
			local sam=r(mean)
			noisily: reg lwagewk i.`ind'_formal i.edulevel3 c.age c.age#c.age i.female i.urb [pw=wgt], robust	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
            local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))
			
			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
	/*if lwagewk or ps3 have only missing value then replace with missing*/
		if r(mean)==0|`nmwage'==0 {
			sum sample1 
			local sam=r(mean)
			matrix A[1,1]=`sam'
		}
	
		if `sam'==`min' {
			disp "`sam'"
			matrix eqs=A
		}
		else if `sam'>`min' {
			disp "`sam'"
			matrix eqs=eqs\A
		}
	}

mat coln eqs=sample1 coefreg_f_`ind' coefreg_se_f_`ind' reg_obs_f_`ind' r2_f_`ind' p_f_`ind'
clear
svmat eqs,names(col) 
drop if sample1 == .
sort sample1
save "${Temp}ind_formal_`ind'_`var'.dta", replace


********************************************************************************
**Public sector wage premium (with controls) for female paid employees, by industry

set more 1

use "${Temp}Industry_outlier_`var'.dta", clear 

	drop if no_`ind'==.
	drop if `ind'_paid_obs <10
	drop if `ind'_fem_obs <10


levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu ocusec edulevel3 age gender female urb empstat sample1 lstatus wgt `ind'_paid `ind'_fem ///
		if empstat==1&sample1==`s'&`ind'_paid~=. ///
		using "${Temp}Industry_outlier_`var'.dta", clear
disp "------------------------------`s'------------------------------"
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values for each sample*/
		
		*Sample
		cap gen lwagewk=ln(wpw_lcu) 
		cap gen nm_lwagewk=lwagewk~=.
		cap sum nm_lwagewk
				
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0  {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk i.`ind'_fem i.edulevel3 c.age c.age#c.age i.urb [pw=wgt], robust	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
            local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))

			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
    /*if lwagewk have only missing value then replace with missing*/
		else if r(mean)==0 {
			sum sample1 
			local sam=r(mean)
			matrix A[1,1]=`sam'
		}
	
	/*combine sector from each sample together as a matrix*/
		if `sam'==`min' {
			disp "`sam'"
			matrix eqs=A
		}
		else if `sam'>`min' {
			disp "`sam'"
			matrix eqs=eqs\A
		}
	}

*Rename all variables
mat coln eqs=sample1 coefreg_fem_`ind' coefreg_se_fem_`ind' reg_obs_fem_`ind' r2_fem_`ind' p_fem_`ind'
clear

*Save the matrix
svmat eqs,names(col) 
drop if sample1 == .
sort sample1

save "${Temp}ind_female_`ind'_`var'.dta", replace


********************************************************************************
**Public sector wage premium (with controls) for male paid employees, by industry

set more 1

use "${Temp}Industry_outlier_`var'.dta", clear 

	drop if no_`ind'==.
	drop if `ind'_paid_obs <10
	drop if `ind'_mal_obs <10

levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu ocusec edulevel3 age gender female urb empstat sample1 lstatus wgt `ind'_paid `ind'_mal ///
		if empstat==1&sample1==`s'&`ind'_paid~=. ///
		using "${Temp}Industry_outlier_`var'.dta", clear
disp "------------------------------`s'------------------------------"
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values for each sample*/
		
		*Sample
		cap gen lwagewk=ln(wpw_lcu) 
		cap gen nm_lwagewk=lwagewk~=.
		cap sum nm_lwagewk
				
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0  {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk i.`ind'_mal i.edulevel3 c.age c.age#c.age i.urb [pw=wgt], robust	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
            local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))

			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
    /*if lwagewk have only missing value then replace with missing*/
		else if r(mean)==0 {
			sum sample1 
			local sam=r(mean)
			matrix A[1,1]=`sam'
		}
	
	/*combine sector from each sample together as a matrix*/
		if `sam'==`min' {
			disp "`sam'"
			matrix eqs=A
		}
		else if `sam'>`min' {
			disp "`sam'"
			matrix eqs=eqs\A
		}
	}

*Rename all variables
mat coln eqs=sample1 coefreg_mal_`ind' coefreg_se_mal_`ind' reg_obs_mal_`ind' r2_mal_`ind' p_mal_`ind'
clear

*Save the matrix
svmat eqs,names(col) 
drop if sample1 == .
sort sample1

save "${Temp}ind_male_`ind'_`var'.dta", replace


********************************************************************************
**Gender wage premium in the private sector (with controls) for female paid employees, by industry

set more 1

use "${Temp}Industry_outlier_`var'.dta", clear 

	drop if no_`ind'==.
	drop if private_`ind'_obs <10
	drop if private_fem_`ind'_obs <10
	
levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu ocusec edulevel3 age gender female urb empstat sample1 lstatus wgt private_`ind' private_fem_`ind' ///
		if empstat==1&sample1==`s'&private_`ind'~=. ///
		using "${Temp}Industry_outlier_`var'.dta", clear
disp "------------------------------`s'------------------------------"
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values for each sample*/
		
		*Sample
		cap gen lwagewk=ln(wpw_lcu) 
		cap gen nm_lwagewk=lwagewk~=.
		cap sum nm_lwagewk
				
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0  {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk i.private_fem_`ind' i.edulevel3 c.age c.age#c.age i.urb [pw=wgt], robust	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
            local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))

			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
    /*if lwagewk have only missing value then replace with missing*/
		else if r(mean)==0 {
			sum sample1 
			local sam=r(mean)
			matrix A[1,1]=`sam'
		}
	
	/*combine sector from each sample together as a matrix*/
		if `sam'==`min' {
			disp "`sam'"
			matrix eqs=A
		}
		else if `sam'>`min' {
			disp "`sam'"
			matrix eqs=eqs\A
		}
	}

*Rename all variables
mat coln eqs=sample1 coefreg_gen_private__`ind' coefreg_se_gen_private_`ind' reg_obs_gen_private_`ind' r2_gen_private_`ind' p_gen_private_`ind'
clear

*Save the matrix
svmat eqs,names(col) 
drop if sample1 == .
sort sample1

save "${Temp}ind_gender_private_`ind'_`var'.dta", replace

}
}



global industries "edu hlt adm" 

foreach var of global bases {
	
foreach ind of global industries {

	cap log close
	log using "${Logs}summaryH_`var'.log", replace


********************************************************************************
**Gender wage premium in the public sector (with controls) for female paid employees, by industry

set more 1

use "${Temp}Industry_outlier_`var'.dta", clear 

	drop if no_`ind'==.
	drop if paid_`ind'_obs <10
	drop if fem_`ind'_obs <10		
	
levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu ocusec edulevel3 age gender female urb empstat sample1 lstatus wgt paid_`ind' fem_`ind' ///
		if empstat==1&sample1==`s'&paid_`ind'~=. ///
		using "${Temp}Industry_outlier_`var'.dta", clear
disp "------------------------------`s'------------------------------"
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values for each sample*/
		
		*Sample
		cap gen lwagewk=ln(wpw_lcu) 
		cap gen nm_lwagewk=lwagewk~=.
		cap sum nm_lwagewk
				
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0  {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk i.fem_`ind' i.edulevel3 c.age c.age#c.age i.urb [pw=wgt], robust	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
            local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))

			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
    /*if lwagewk have only missing value then replace with missing*/
		else if r(mean)==0 {
			sum sample1 
			local sam=r(mean)
			matrix A[1,1]=`sam'
		}
	
	/*combine sector from each sample together as a matrix*/
		if `sam'==`min' {
			disp "`sam'"
			matrix eqs=A
		}
		else if `sam'>`min' {
			disp "`sam'"
			matrix eqs=eqs\A
		}
	}

*Rename all variables
mat coln eqs=sample1 coefreg_gen_`ind' coefreg_se_gen_`ind' reg_obs_gen_`ind' r2_gen_`ind' p_gen_`ind'
clear

*Save the matrix
svmat eqs,names(col) 
drop if sample1 == .
sort sample1

save "${Temp}ind_gender_`ind'_`var'.dta", replace

}
*******************************************
**Merge all data file into one*************
*******************************************

	use						"${Temp}ind_nocont_edu_`var'.dta"			, clear
	merge 1:1 sample1 using "${Temp}ind_nocont_hlt_`var'.dta"			, nogen
	merge 1:1 sample1 using "${Temp}ind_cont_edu_`var'.dta"				, nogen
	merge 1:1 sample1 using "${Temp}ind_cont_hlt_`var'.dta"				, nogen
	merge 1:1 sample1 using "${Temp}ind_formal_edu_`var'.dta"			, nogen
	merge 1:1 sample1 using "${Temp}ind_formal_hlt_`var'.dta"			, nogen
	merge 1:1 sample1 using "${Temp}ind_female_edu_`var'.dta"			, nogen
	merge 1:1 sample1 using "${Temp}ind_female_hlt_`var'.dta"			, nogen
	merge 1:1 sample1 using "${Temp}ind_male_edu_`var'.dta"				, nogen
	merge 1:1 sample1 using "${Temp}ind_male_hlt_`var'.dta"				, nogen
	merge 1:1 sample1 using "${Temp}ind_gender_private_edu_`var'.dta"	, nogen
	merge 1:1 sample1 using "${Temp}ind_gender_private_hlt_`var'.dta"	, nogen
	merge 1:1 sample1 using "${Temp}ind_gender_edu_`var'.dta"			, nogen
	merge 1:1 sample1 using "${Temp}ind_gender_hlt_`var'.dta"			, nogen
	merge 1:1 sample1 using "${Temp}ind_gender_adm_`var'.dta"			, nogen
	
 save "${Temp}summaryH_`var'.dta", replace
}

