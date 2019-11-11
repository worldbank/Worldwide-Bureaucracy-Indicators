****************************************
*PUBLIC SECTOR EMPLOYMENT
*Summary Table by country
*Created by: Camilo Bohorquez-Penuela&Rong Shi
*First version: December 2016
*Latest version: June 2019
****************************************
*Called from Master.do

/**********************************************************************************
Benefits
**********************************************************************************/

********************************************************************************
*Proportion of individual with contract/health insurance/social secruity/union 

set more 1

foreach var2 of global bases {

log using "${Logs}\Benefits_`var2'log.", replace


set more 1
use "${Data}LatestI2D2_`var2'.dta", clear
levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

*Using svyset to calculate proportion of individuals with benefits and store value for each sample*
 
foreach s of local sels {
	disp "------------------------------`s'------------------------------"
	use sample1 wgt edulevel3 age gender urb ///
		lstatus empstat ocusec ps1  ///
		contract healthins socialsec union if ps1~=. & sample1==`s' ///
		using "${Data}LatestI2D2_`var2'.dta" , clear
	mat A=[.]
	mat A[1,1]=`s'

	quietly {
		lab def lwith 1 "With" 0 "Without"
		
		*Mean contract
		local var "contract"
		local mat "B"
		lab val `var' lwith
		svyset [pw=wgt]
	
   **calcualte missing value for each variable, only store estimates if the missing value is less than 30%
		mdesc `var'
		local mben=r(percent)
		mat `mat'=[.,.,.,.,.]
		if `mben'<30 {
			preserve
				keep if `var'~=.
				svy: prop `var',over(ps1)
				mat T=r(table)
				mat `mat'[1,1]=T[1,4]
				mat `mat'[1,2]=T[1,3]
				mat `mat'[1,5]=T[7,4]
				lincom [With]_subpop_2 - [With]_subpop_1
				mat `mat'[1,3]=r(estimate)
				mat `mat'[1,4]=r(se)
			restore
		}
		
		*Mean healthins
		local var "healthins"
		local mat "C"
		lab val `var' lwith
		svyset [pw=wgt]
		mdesc `var'
		local mben=r(percent)
		mat `mat'=[.,.,.,.,.]
  **calcualte missing value for each variable, only store estimates if the missing value is less than 30%
		if `mben'<30 {
			preserve
				keep if `var'~=.
				svy: prop `var',over(ps1)
				mat T=r(table)
				mat `mat'[1,1]=T[1,4]
				mat `mat'[1,2]=T[1,3]
				mat `mat'[1,5]=T[7,4]
				lincom [With]_subpop_2 - [With]_subpop_1
				mat `mat'[1,3]=r(estimate)
				mat `mat'[1,4]=r(se)
			restore
		}
		
		*Mean socialsec
		local var "socialsec"
		local mat "D"
		lab val `var' lwith
		svyset [pw=wgt]
   **calcualte missing value for each variable, only store estimates if the missing value is less than 30%
		mdesc `var'
		local mben=r(percent)
		mat `mat'=[.,.,.,.,.]
		if `mben'<30 {
			preserve
				keep if `var'~=.
				svy: prop `var',over(ps1)
				mat T=r(table)
				mat `mat'[1,1]=T[1,4]
				mat `mat'[1,2]=T[1,3]
				mat `mat'[1,5]=T[7,4]
				lincom [With]_subpop_2 - [With]_subpop_1
				mat `mat'[1,3]=r(estimate)
				mat `mat'[1,4]=r(se)
			restore
		}	
		
		*Mean union
		local var "union"
		local mat "E"
		lab val `var' lwith
		svyset [pw=wgt]
	**calcualte missing value for each variable, only store estimates if the missing value is less than 30%
		mdesc `var'
		local mben=r(percent)
		mat `mat'=[.,.,.,.,.]
		if `mben'<30 {
			preserve
				keep if `var'~=.
				svy: prop `var',over(ps1)
				mat T=r(table)
				mat `mat'[1,1]=T[1,4]
				mat `mat'[1,2]=T[1,3]
				mat `mat'[1,5]=T[7,4]
				lincom [With]_subpop_2 - [With]_subpop_1
				mat `mat'[1,3]=r(estimate)
				mat `mat'[1,4]=r(se)
			restore
			}	
	*combine all estimates as a new vector for each sample
		matrix BEN=A,B,C,D,E
	}
	if `s'==`min' {
		mat benf=BEN
	}
	   *combine all vectors together as a matrix
	else if `s'~=`min' {
		mat benf=benf\BEN
	}
} 

	mat coln benf=sample1 ///
			cont_pub cont_prv cont_dif cont_se obs_cont ///
			hins_pub hins_prv hins_dif hins_se obs_hins ///
			ssec_pub ssec_prv ssec_dif ssec_se obs_ssec ///
			union_pub union_prv union_dif union_se ons_union
	clear
	svmat benf,names(col) 

	save "${Datatemp}\benf1", replace
********************************************************************************
*Proportion of individual with benefits using redefining variables


set more 1
use "${Data}LatestI2D2_`var2'.dta", clear
levelsof sample1, local(sels)
sum sample1
local min=r(min)
disp `min'

foreach s of local sels {
	disp "------------------------------`s'------------------------------"
	use sample1 wgt edulevel3 age gender urb ///
		lstatus empstat ocusec ps1 ///
		contract healthins socialsec union if ps1~=. & sample1==`s' ///
		using "${Data}LatestI2D2_`var2'.dta" , clear
	mat A=[.]
	mat A[1,1]=`s'
	gen 	ben1=0
	replace ben1=. if contract==.&healthins==.&socialsec==.&union==.
	replace ben1=1 if contract==1|healthins==1|socialsec==1|union==1
	
	gen 	ben2=0 
	replace ben2=. if healthins==.&socialsec==.
	replace ben2=1 if healthins==1|socialsec==1

	quietly {
		lab def lwith 1 "With" 0 "Without"
		
		*Mean ben1
		local var "ben1"
		local mat "B"
		lab val `var' lwith
		svyset [pw=wgt]
		mdesc `var'
		local mben=r(percent)
		mat `mat'=[.,.,.,.]
		if `mben'<30 {
			preserve
				keep if `var'~=.
				sum `var'
				local has=r(mean)
				svy: prop `var',over(ps1)
				mat T=r(table)
				if `has'==1 {
					mat `mat'[1,1]=1
					mat `mat'[1,2]=1
				}
				else if `has'~=1 {
					mat `mat'[1,1]=T[1,4]
					mat `mat'[1,2]=T[1,3]
				}
				lincom [With]_subpop_2 - [With]_subpop_1
				mat `mat'[1,3]=r(estimate)
				mat `mat'[1,4]=r(se)
			restore
		}
pause cinco
		*Mean ben2
		local var "ben2"
		local mat "C"
		lab val `var' lwith
		svyset [pw=wgt]
		mdesc `var'
		local mben=r(percent)
		mat `mat'=[.,.,.,.]
		if `mben'<30 {
			preserve
				keep if `var'~=.
				svy: prop `var',over(ps1)
				mat T=r(table)
				mat `mat'[1,1]=T[1,4]
				mat `mat'[1,2]=T[1,3]
				lincom [With]_subpop_2 - [With]_subpop_1
				mat `mat'[1,3]=r(estimate)
				mat `mat'[1,4]=r(se)
			restore
		}
pause seis
		*combine all estimates as a new vector for each sample
		matrix BEN=A,B,C
	}
	if `s'==`min' {
		mat benf=BEN
	}
	 *combine all vectors together as a matrix
	else if `s'~=`min' {
		mat benf=benf\BEN
	}
}
	mat coln benf=sample1 ///
			ben1_pub ben1_prv ben1_dif ben1_se ///
			ben2_pub ben2_prv ben2_dif ben2_se 
	clear
	svmat benf,names(col) 

	save "${Datatemp}\benf2.dta", replace
	
**Merge data files
*******************************************************************************
use "${Datatemp}\benf1.dta", clear
merge 1:1 sample1 using "${Datatemp}\benf2.dta", assert(3) nogen
sort sample1
save "${Datatemp}\summaryC_`var2'.dta", replace
log close

}	
	
