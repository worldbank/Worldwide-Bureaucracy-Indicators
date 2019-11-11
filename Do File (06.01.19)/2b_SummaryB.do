***************************************
*PUBLIC SECTOR EMPLOYMENT
*Summary Table by country
*Created by: Camilo Bohorquez-Penuela &Rong Shi
*First version: December 2016
*Latest version: June 2019
**************************************
*Called from Master.do
capture log close
set more 1

/**********************************************************************************
Wage related indicator
**********************************************************************************/

*Create another dataset when constructing wage related indicators:
*Exclude top 0.1%  wage per week in local currenycy (wpw_lcu) by sample from our analysis
*Keep only surveys that passed all filter when calculating wage premium

foreach var of global bases {

use "${Data}LatestI2D2_`var'.dta", clear
winsor2 wpw_lcu, cuts(0 99.9)suffix(_win) by(sample1) /*winsorizing wpw_lcu at top 0.1% by sample*/
gen wpw_lcu_touse=wpw_lcu==wpw_lcu_win  
* Mark observations if wpe_lcu is less than 99.9% in wage distribution within each sample, 
*exclude top 0.1% wage from our analysis to eliminate possible biase caused by extreme outliers 
drop if filter!=0
*Keep only surveys that passed all filter when constructing wage related indicators
save"${Data}LatestI2D2_outlier_`var'.dta",replace
}


********************************************************************************
*Wage Premium

set more 1

foreach var of global bases {

log using "${Logs}\summaryB_partI_`var'.log", replace


********************************************************************************
***Wage premium without control**
*Coeff from regression (Use weekly wage in lcu without controls)

set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear

levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu wpw_lcu_touse ocusec edulevel3 age gender urb empstat sample1 lstatus wgt ps1 ///
		if empstat==1&sample1==`s'&ps1~=.&wpw_lcu_touse==1 using "${Data}LatestI2D2_outlier_`var'.dta" , clear
	disp "------------------------------`s'------------------------------"
	*quietly {
		lab drop lps1
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values for each sample*/

		*Sample
		gen lwagewk=ln(wpw_lcu) 
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0 {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk i.ps1 [pw=wgt], robust
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
		if r(mean)==0 {
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
*}


*Rename all variables
mat coln eqs=sample1 coefreg_noc coefreg_se_noc reg_obs_noc r2_noc p_noc
clear

*Save the matraix
svmat eqs,names(col) 

drop if sample1 == .

sort sample1

save "${Datatemp}\inc21.dta", replace


********************************************************************************
*Wage premium with controls(Coeff from regression (weekly wage in LCU))

set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear
levelsof sample1, local(sels)
*exclude sri lenka 2013 (becasue age variable is coded to missing)
local exclude 698
local sels: list sels - exclude
sum sample1
local min=r(min)
disp `min'


**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu wpw_lcu_touse ocusec edulevel3 age gender urb empstat sample1 lstatus wgt ps1 ///
		if empstat==1&sample1==`s'&ps1~=.&wpw_lcu_touse==1 using "${Data}LatestI2D2_outlier_`var'.dta", clear
	disp "------------------------------`s'------------------------------"
	*quietly {
		
		lab drop lps1
		mat A=[.,.,.,.,.,.] /*generate vectore that could store 6 values*/

		*Sample
		gen lwagewk=ln(wpw_lcu)
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0 {
			/*store sample Id, ceof,se,obs,r^2,p for each sample*/
			sum sample1 
			local sam=r(mean)
			noisily: reg lwagewk i.ps1 ib3.edulevel3 c.age c.age#c.age i.gender i.urb [pw=wgt], robust	
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
		if r(mean)==0 {
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
*}

mat coln eqs=sample1 coefreg coefreg_se reg_obs r2 p
clear
svmat eqs,names(col) 

drop if sample1 == .

sort sample1

save "${Datatemp}\inc22.dta", replace


********************************************************************************
*Wage Premium by quantile

set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear
levelsof sample1, local(sels)
*exclude sri lenka 2013 (becasue age variable is coded to missing)
local exclude 698
local sels: list sels - exclude
sum sample1
local min=r(min)
disp `min'
local quan 0.1 0.25 0.5 0.75 0.9

**run quantile regression at 5 different percentile for each sample***
foreach x of local quan  {
foreach s of local sels {
	use sample1 wpw_lcu wpw_lcu_touse ocusec edulevel3 age gender urb empstat sample1 lstatus wgt ps1 ///
		if empstat==1&sample1==`s'&ps1~=.&wpw_lcu_touse==1 using "${Data}LatestI2D2_outlier_`var'.dta", clear
	disp "------------------------------`s'------------------------------"
	*quietly {
	
		lab drop lps1
		mat A=[.,.,.,.,.] /*generate vectore to store 5values*/

		*Sample
		gen lwagewk=ln(wpw_lcu)
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0 {
		/*store sample Id, ceof,se,obs,p for each sample*/
			sum sample1 
			local sam=r(mean)
			noisily: qreg lwagewk i.ps1 ib3.edulevel3 c.age c.age#c.age i.gender i.urb [pw=wgt],quantile(`x')	
			matrix C=e(b)
			local c1=C[1,2]
			matrix V=e(V)
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			count if e(sample)
			local o1=r(N)
			local t=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t'))

			disp `c1'
			disp `v1'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=`c1'
			mat A[1,3]=`v1'
			mat A[1,4]=`o1'
			mat A[1,5]=`p'
			mat list A
		}
  /*if lwagewk have only missing value then replace with missing*/
		if r(mean)==0 {
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
*}
local c=`x'*100
mat coln eqs=sample1 coefreg`c' coefreg_se`c' reg_obs`c' p_`c'
clear
svmat eqs,names(col) 

drop if sample1 == .

sort sample1

save "${Datatemp}\quantile`x'.dta", replace
 }


********************************************************************************
*Wage Premium compared to formal employees

set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear
levelsof sample1, local(sels)
**exclude sri lenka 2013 (becasue age variable is coded to missing)
local exclude 698
local sels: list sels - exclude
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu wpw_lcu_touse ocusec edulevel3 age gender urb empstat sample1 lstatus wgt ps1 ps3 ///
		if empstat==1&sample1==`s'&wpw_lcu_touse==1 using "${Data}LatestI2D2_outlier_`var'.dta", clear
	disp "------------------------------`s'------------------------------"
	*quietly {
		
		lab drop lps1
		mat A=[.,.,.,.,.,.]  /*construct vectore to store 6 values*/

		*Sample
		gen lwagewk=ln(wpw_lcu)
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		local nmwage=r(mean)
		gen nm_ps3=ps3~=.
		sum  nm_ps3
		/*if lwagewk and ps3 have non missing value then store all estimates*/
		if r(mean)~=0&`nmwage'~=0 {
		/*store sample Id, ceof,se,obs,r^2,p for each sample*/
		
			sum sample1 
			local sam=r(mean)
			noisily: reg lwagewk i.ps3 i.edulevel3 c.age c.age#c.age i.gender i.urb [pw=wgt], robust	
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
*}

mat coln eqs=sample1 coefreg_f coefreg_se_f reg_obs_f r2_f p_f
clear
svmat eqs,names(col) 

drop if sample1 == .

sort sample1

save "${Datatemp}\inc24.dta", replace

********************************************************************************
*Wage Premium compared to formal employees by oocupation

set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear
levelsof sample1, local(sels)
**exclude sri lenka 2013 (becasue age variable is coded to missing)
local exclude 698
local sels: list sels - exclude
sum sample1
local min=r(min)
disp `min'

**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu wpw_lcu_touse occup ocusec edulevel3 age gender urb empstat sample1 lstatus wgt ps1 ps3 ///
		if empstat==1&sample1==`s'&wpw_lcu_touse==1 using "${Data}LatestI2D2_outlier_`var'.dta" , clear
	disp "------------------------------`s'------------------------------"
	*quietly {
		lab drop lps1
		mat A=[.,.,.,.,.,.,.,.,.,.,.,.,.,.,.] /*construct vectore to store 15 values*/

		*Sample
		gen lwagewk=ln(wpw_lcu)
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		local nmwage=r(mean)
		gen nm_occup=occup~=.
		sum  nm_occup
		local nmocu=r(mean)
		gen nm_ps3=ps3~=.
		sum  nm_ps3
		/*if lwagewk ,ps3, occupation have non missing value then store all estimates*/
		if r(mean)~=0&`nmocu'~=0&`nmwage'~=0 {
		/*store sample Id, ceof for each occupation interaction dummmy,se,obs,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk  i.ps3 ib99.occup#i.ps1 ib99.occup i.edulevel3 c.age c.age#c.age i.gender i.urb  [pw=wgt],robust
			matrix C=e(b)
			matrix V=e(V)
			local c1=C[1,2]
			local c2=C[1,4]
			local c3=C[1,6]
			local c4=C[1,8]
			local c5=C[1,10]
			local c6=C[1,12]
			local c7=C[1,14]
			local c8=C[1,16]
			local c9=C[1,18]
			local c10=C[1,20]
			local c11=C[1,22]
			local c12=C[1,24]
	
	
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			local t1=`c1'/`v1'
			local  p=2*ttail(e(df_r),abs(`t1'))
			
			
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)
			matrix V=e(V)
			local v1=V[2,2]

			disp `c1'
			disp `c2'
			disp `c3'
			disp `c4'
			disp `c5'
			disp `c6'
			disp `c7'
			disp `c8'
			disp `c9'
			disp `c10'
			disp `c11'
			disp `c12'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=C[1,2]+C[1,4]
			mat A[1,3]=C[1,2]+C[1,6]
			mat A[1,4]=C[1,2]+C[1,8]
			mat A[1,5]=C[1,2]+C[1,10]
			mat A[1,6]=C[1,2]+C[1,12]
			mat A[1,7]=C[1,2]+C[1,14]
			mat A[1,8]=C[1,2]+C[1,16]
			mat A[1,9]=C[1,2]+C[1,18]
			mat A[1,10]=C[1,2]+C[1,20]
			mat A[1,11]=C[1,2]+C[1,22]
			mat A[1,12]=C[1,2]+C[1,24]
			mat A[1,13]=`o1'
			mat A[1,14]=`r2'
			mat A[1,15]=`p'
			mat list A
		}
     /*if lwagewk, occupation or ps3 have only missing value then replace with missing*/
		if r(mean)==0|`nmocu'==0|`nmwage'==0 {
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
*}

mat coln eqs=sample1 WPocup1 WPocup2 WPocup3 WPocup4 WPocup5 WPocup6 WPocup7 WPocup8 WPocup9 WPocup10 WPocup11 reg_obs_occ r2_occ p_occ
clear
svmat eqs,names(col) 
drop if sample1 == .

sort sample1

save "${Datatemp}\occupationwp_`var'.dta", replace

********************************************************************************
*Wage Premium compared to formal employees by education
set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear
levelsof sample1, local(sels)
**exclude sri lenka 2013 (becasue age variable is coded to missing)
local exclude 698
local sels: list sels - exclude
sum sample1
local min=r(min)

disp `min'
**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu wpw_lcu_touse ocusec edulevel3 age gender urb empstat sample1 lstatus wgt ps1 ps3 ///
		if empstat==1&sample1==`s'&wpw_lcu_touse==1 using "${Data}LatestI2D2_outlier_`var'.dta" , clear
	disp "------------------------------`s'------------------------------"
	*quietly {
		lab drop lps1
		mat A=[.,.,.,.,.,.,.,.] /*construct vectore to store 8 values*/

		*Sample
		gen lwagewk=ln(wpw_lcu)
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		local nmwage=r(mean)
		gen nm_ps3=ps3~=.
		sum  nm_ps3
		/*if lwagewk ,ps3 have non missing value then store all estimates*/
		if r(mean)~=0&`nmwage'~=0 {
		/*store sample Id, ceof for each education level interaction dummmy,se,obs,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk  i.ps3 i.edulevel3  i.edulevel3#i.ps1 c.age c.age#c.age i.gender i.urb  [pw=wgt],robust
			matrix C=e(b)
			matrix V=e(V)
			local c1=C[1,2]
			local c2=C[1,8]
			local c3=C[1,10]
			local c4=C[1,12]
			local c5=C[1,14]
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			local t1=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t1'))
			
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)

			disp `c1'
			disp `c2'
			disp `c3'
			disp `c4'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=C[1,2]+C[1,8]
			mat A[1,3]=C[1,2]+C[1,10]
			mat A[1,4]=C[1,2]+C[1,12]
			mat A[1,5]=C[1,2]+C[1,14]
			mat A[1,6]=`o1'
			mat A[1,7]=`r2'
			mat A[1,7]=`p'
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
*}

mat coln eqs=sample1 WPedu1 WPedu2 WPedu3 WPedu4 reg_obs_edu r2_edu p_edu
clear
svmat eqs,names(col) 

drop if sample1 == .

sort sample1

save "${Datatemp}\educationwp_`var'.dta", replace


******Wage Premium compared to private employees by gender****

set more 1
use "${Data}LatestI2D2_outlier_`var'.dta", clear
levelsof sample1, local(sels)
**exclude sri lenka 2013 (becasue age variable is coded to missing)
local exclude 698
local sels: list sels - exclude
sum sample1
local min=r(min)

disp `min'
**run OLS for each sample***
foreach s of local sels {
	use sample1 wpw_lcu wpw_lcu_touse ocusec edulevel3 age gender urb empstat sample1 lstatus wgt ps1 ps3 ///
		if empstat==1&sample1==`s'&wpw_lcu_touse==1 using "${Data}LatestI2D2_outlier_`var'.dta" , clear
	disp "------------------------------`s'------------------------------"
	*quietly {
		lab drop lps1
		mat A=[.,.,.,.,.,.]  /*construct vectore to store 6 values*/

		*Sample
		gen lwagewk=ln(wpw_lcu)
		gen nm_lwagewk=lwagewk~=.
		sum nm_lwagewk
		/*if lwagewk have non missing value then store all estimates*/
		if r(mean)~=0 {
		/*store sample Id, ceof for gender interaction dummmy,se,obs,p for each sample*/
			sum sample1 
			local sam=r(mean)
			reg lwagewk  i.ps1 i.gender#i.ps1 i.edulevel3  c.age c.age#c.age i.gender i.urb  [pw=wgt],robust
			matrix C=e(b)
			matrix V=e(V)
			local c1=C[1,2]
			local c2=C[1,4]
			local c3=C[1,6]
			local v1=V[2,2]
			local v1=`v1'^(1/2)
			local t1=`c1'/`v1'
			local p =2*ttail(e(df_r),abs(`t1'))
			
			count if e(sample)
			local o1=r(N)
			local r2=e(r2)

			disp `c1'
			disp `c2'
			disp `c3'
			disp `o1'

			mat A[1,1]=`sam'
			mat A[1,2]=C[1,2]+C[1,4]
			mat A[1,3]=C[1,2]+C[1,6]
			mat A[1,4]=`o1'
			mat A[1,5]=`r2'
			mat A[1,6]=`p'
			mat list A
		}
   /*if lwagewk have only missing value then replace with missing*/
		if r(mean)==0 {
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
*}

mat coln eqs=sample1 WPmale WPfemale  reg_obs_gender r2_gender p_gender
clear
svmat eqs,names(col) 

drop if sample1 == .

sort sample1

save "${Datatemp}\genderwp_`var'.dta", replace


********************************************************************************
*wage Differentials by gender (for public and private sectors)
*ONLY PAID EMPLOYEES



use "${Data}LatestI2D2_outlier_`var'.dta", clear

forvalues x = 0(1)1 {
	
	*1 = Public, 2 = private
	
	preserve
	
	keep if wpw_lcu_touse==1 /*exclude top 0.1% from analysis*/
	
	*generate wage variable by gender in each sector
	gen wagewk = wpw_lcu if ps1 == `x'
	gen wage_m = wagewk if gender == 1
	gen wage_f = wagewk if gender == 2
	
	*generate non-missing proportion in estimating
	gen nm_wagewk_`x'=wagewk~=. if empstat==1&ps1==`x'
    gen nm_wagewkmal_`x'=wage_m~=. if empstat==1&ps1==`x'&gender==1
    gen nm_wagewkfem_`x'=wage_f~=. if empstat==1&ps1==`x'&gender==2


     * Collapse mean for wage vairble by gender in each sector for each sample
	collapse (mean) total_mean_`x' = wagewk (p50) total_median_`x' = wagewk ///
	(p10) total_p10_`x' = wagewk (p25) total_p25_`x' = wagewk (p75) ///
	total_p75_`x' = wagewk (p90) total_p90_`x' = wagewk nm_wagewk_`x' ///
	(mean) mean_m_`x' = wage_m (p50) median_m_`x' = wage_m (p10) p10_m_`x' = wage_m ///
	(p25) p25_m_`x' = wage_m (p75) p75_m_`x' = wage_m (p90) p90_m_`x' = wage_m  nm_wagewkmal_`x' ///
	(mean) mean_f_`x' = wage_f (p50) median_f_`x' = wage_f (p10) p10_f_`x' = wage_f ///
	(p25) p25_f_`x' = wage_f (p75) p75_f_`x' = wage_f (p90) p90_f_`x' = wage_f  nm_wagewkfem_`x' ///
	(rawsum) obs_wagewk_`x'=nm_wagewk_`x'  obs_wagewkmal_`x'=nm_wagewkmal_`x' obs_wagewkfem_`x'=nm_wagewkfem_`x' [w=wgt], ///
	by(ccode countryname year sample sample1)	
	
	*generate wage gender differentials 
	foreach var2 in mean median p10 p25 p75 p90 {
		gen diff_`var2'_`x' = `var2'_f_`x' / `var2'_m_`x'
	}

	keep sample1 total_mean_`x' total_median_`x' total_p10_`x' total_p25_`x' total_p75_`x' total_p90_`x' ///
	diff_mean_`x' diff_median_`x' diff_p10_`x' diff_p25_`x' diff_p75_`x' diff_p90_`x' nm_wagewk_`x'    ///
	nm_wagewkmal_`x' nm_wagewkfem_`x' obs_wagewk_`x'  obs_wagewkmal_`x' obs_wagewkfem_`x'
	sort sample1
	save "${Datatemp}\inc23`x'.dta", replace
	
	restore
}
*******************************************
**Merge all data file into one*************
*******************************************
use "${Datatemp}\inc21.dta", clear
merge 1:1 sample1 using "${Datatemp}\inc22.dta", assert(3) nogen
merge 1:1 sample1 using "${Datatemp}\inc230.dta", assert(3) nogen
merge 1:1 sample1 using "${Datatemp}\inc231.dta", assert(3) nogen
merge 1:1 sample1 using "${Datatemp}\inc24.dta", assert(3) nogen
merge 1:1 sample1 using  "${Datatemp}\educationwp_`var'.dta", assert(3) nogen
merge 1:1 sample1 using "${Datatemp}\occupationwp_`var'.dta", assert(3) nogen
merge 1:1 sample1 using "${Datatemp}\genderwp_`var'.dta", assert(3) nogen

local quan 0.1 0.25 0.5 0.75 0.9
foreach x of local quan  {
merge 1:1 sample1 using "${Datatemp}\quantile`x'.dta", assert(3) nogen

}
order sample sample1
sort sample1
save "${Datatemp}\summaryB_`var'.dta", replace

log close

}
