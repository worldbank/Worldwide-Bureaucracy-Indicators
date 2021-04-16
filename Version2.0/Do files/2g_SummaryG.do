***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 2.0, 2000-2018
*2g_SummaryG
*Called by 0_master.do
*Created by: Turkan Mukhtarova
*Last Edit by: Faisal Baig
*First version: December 2020
*Latest version: February 2021
********************************************************************************

/**********************************************************************************
Demographics of public employment in education, health and public administration
**********************************************************************************/

set more 1
cap log close

* Creates indicators for sub classificaitons of public sector employment by industry (as a share of total, paid and formal employment) by genders, urban/rural split

foreach var of global bases {

	log using "${Logs}summaryG_`var'.log", replace

	********************************************************************************

	use  "${Temp}Industry_`var'.dta", clear

	keep ccode year sample sample1 wgt pub_adm hlt edu urb gender age educy lstatus empstat ocusec occup wpw_lcu edulevel3 ps1 ps2 ps3

	// Creating a Female Dummy
		
		gen female = 1 if gender == 2
			replace female = 0 if gender ==1
			
	// Creating a public sector Dummy

		gen public = 1 if ocusec ==1 | ocuse == 3 | ocusec == 4
			replace public = 0 if ocusec == 2 | ocusec > 4
			replace public = . if lstatus != 1

	// Creating a rural Dummy

		gen rural = 1 if urb == 2
			replace rural = 0 if urb == 1

	// Creating a tertiary education Dummy

		gen ed3 = edulevel3 == 4 if edulevel3 ~= .


		rename pub_adm adm

	********************************************************************************
		
	foreach var2 of varlist edu hlt adm {

	*--------------------------EMPLOYMENT SHARE BY INDUSTRY -----------------------*

		** Employment by industry (as a share of Public Sector Employment)

			// Total Employment
				gen total_`var2' = 1 if `var2' == 1 & public==1
					replace total_`var2' = 0 if `var2' == 0 & public ==1
					label var total_`var2' "`var2' workers in public sector (share of total public sector employees)"
	}}				
			// Paid Employment
				gen paid_`var2' = 1 if `var2' == 1 & ps1==1
					replace paid_`var2' = 0 if `var2' == 0 & ps1 ==1
					label var paid_`var2' "`var2' workers in public sector (share of paid public sector employees)"

			// Formal Employment
				gen formal_`var2' = 1 if `var2' == 1 & ps3==1
					replace formal_`var2' = 0 if `var2' == 0 & ps3 ==1
					label var formal_`var2' "`var2' workers in public sector (share of formal public sector employees)"

					
		** Employment in the public sector (as a share of employment in the industry)

			// Total Employment
				gen `var2'_total = 1 if public == 1 & `var2'==1
					replace `var2'_total = 0 if public == 0 & `var2'==1
					label var `var2'_total "Public sector `var2' workers (share of all `var2' workers)"

			// Paid Employment
				gen `var2'_paid = 1 if ps1 == 1 & `var2'==1
					replace `var2'_paid = 0 if ps1 == 0 & `var2'==1
					label var `var2'_paid "Public sector `var2' workers (share of all `var2' workers)"

			// Formal Employment
				gen `var2'_formal = 1 if ps3 == 1 & `var2'==1
					replace `var2'_formal = 0 if ps3 == 0 & `var2'==1
					label var `var2'_formal "Public sector `var2' workers (share of all `var2' workers)"


	*-------------------------- FEMALE SHARE --------------------------------------*

		** Female Share, by industry (in the public sector)
			gen fem_`var2' = 1 if female == 1 & paid_`var2'==1
				replace fem_`var2' = 0 if female == 0 & paid_`var2' == 1
				label var fem_`var2' "Female `var2' workers (share of public sector `var2' workers)"

		** Female Share (in the industry)
			gen `var2'_fem = 1 if `var2'_paid == 1 & female==1
				replace `var2'_fem = 0 if female == 1 & `var2'_paid == 0
				label var `var2'_fem "Female `var2' workers in the public sector (share of all female `var2' workers)"


				
	*-------------------------- RURAL/URBAN SPLIT ---------------------------------*

		** Rural share, by industry (in the public sector)
			gen rur_`var2' = 1 if rural == 1 & paid_`var2'==1
				replace rur_`var2' = 0 if rural == 0 & paid_`var2'==1
				label var rur_`var2' "Rural `var2' workers (share of public sector `var2' workers)"



	*-------------------------- SAMPLE SIZES --------------------------------------*

		** Total Empoyment, by industry
			gen all_emp_`var2' 	= 1 if `var2' == 1 & lstatus == 1
				label var all_emp_`var2' "Number of employed individuals (`var2')"

		** Paid Empoyment, by industry
			gen all_paid_`var2' = 1 if `var2' == 1 & empstat == 1
				label var all_paid_`var2' "Number of Paid individuals (`var2')"

		** Public Sector Paid Empoyment, by industry
			gen all_pub_`var2' = 1 if `var2' == 1 & paid_`var2' == 1
				label var all_pub_`var2' "Number of Public Sector Paid individuals (`var2')"

				
				
	*-------------------------- AGE -----------------------------------------------*

		** Age of paid public and private sector employees, by industry

			// Public Sector
				gen age_public_`var2' = age if ps1==1 & `var2'==1
					label var age_public_`var2' "Public Sector Age (`var2' workers)"

			// Public Sector
				gen age_private_`var2' = age if ps1==0 & `var2'==1
					label var age_private_`var2' "Private Sector Age (`var2' workers)"



	*-------------------------- TERTIARY EDUCATION --------------------------------*

		** Share of tertiary education employees in the public/private sector, by industry

			// Public Sector
				gen ed3_public_`var2' = 1 if `var2' == 1 & ed3 == 1 & ps1 ==1
					replace ed3_public_`var2' = 0 if `var2' == 1 & ed3 == 0 & ps1 == 1
					label var ed3_public_`var2' "Public Sector Age (`var2' workers)"
			
			
			// Public Sector
				gen ed3_private_`var2' = 1 if `var2' == 1 & ed3 == 1 & ps1 ==0
					replace ed3_private_`var2' = 0 if `var2' == 1 & ed3 == 0 & ps1 == 0
					label var ed3_private_`var2' "Public Sector Age (`var2' workers)"


	********************************************************************************
	*-------------------------- COLLAPSING ALL INDICATORS -------------------------*

		preserve
			collapse (mean)	 total_`var2' paid_`var2' formal_`var2'				///
							 `var2'_total `var2'_paid `var2'_formal				///
							 fem_`var2' `var2'_fem								///
							 rur_`var2'											///
							 ed3_public_`var2' ed3_private_`var2'				///
							 mean_age_public_`var2'		=age_public_`var2'		///
							 mean_age_private_`var2'	=age_private_`var2'		///
					(median) median_age_public_`var2'	=age_public_`var2'		///
							 median_age_private_`var2'	=age_private_`var2'		///
					(rawsum) obs_emp_`var2'  = all_emp_`var2'					///
							 obs_paid_`var2' = all_paid_`var2'					///
							 obs_pub_`var2'  = paid_`var2'						///
					[pw=wgt], by(ccode year sample sample1)
								
			save "${Temp}`var2'_industry_`var'.dta", replace

		restore
		}

	********************************************************************************
	*-------------------------- MARGING ALL INDICATORS -------------------------*

	use 					"${Temp}edu_industry_`var'.dta", clear
	merge 1:1 sample1 using "${Temp}hlt_industry_`var'.dta", nogen
	merge 1:1 sample1 using "${Temp}adm_industry_`var'.dta", nogen


		********************************************************************************
	*-------------------------- MARGING FILTERS -------------------------*

	
	merge 1:1 sample1 using "${Temp}filters_data_`var'.dta", keepusing(filter) assert(2 3) keep(3) nogen

	local demographics	fem_edu edu_fem rur_edu mean_age_public_edu mean_age_private_edu median_age_public_edu median_age_private_edu fem_hlt hlt_fem rur_hlt mean_age_public_hlt mean_age_private_hlt median_age_public_hlt median_age_private_hlt fem_adm adm_fem rur_adm mean_age_public_adm mean_age_private_adm median_age_public_adm median_age_private_adm 
	local education	ed3_public_edu ed3_private_edu ed3_public_hlt ed3_private_hlt ed3_public_adm ed3_private_adm

	***replace disaggregated indicator with missing value if they didn't pass age/gender/urban or education filters

	foreach n of local demographics {
		replace `n'=. if filter==3
	}

	foreach n of local education {
		replace `n'=. if filter==4
	}
 
	drop filter

	order sample sample1
		sort sample1

	save "${Temp}summaryG_`var'.dta", replace	

log close

}