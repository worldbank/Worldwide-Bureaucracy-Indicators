***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*3b_outlier check
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Faisal Baig
*First version: December 2016
*Latest version: February 2021
********************************************************************************

set more off

use "${Output}Summary_WWBI.dta", clear

*****1.Keep only one survey for a country at a given year**********

***drop survey that didn't pass filter(if have two more surveys)***
sort ccode year
quietly by ccode year:  gen dup = cond(_N==1,0,_n)

format %20s sample

*Albania // Selecting more time consistent LSMS survey
//	br sample year ps1 dup if ccode == "ALB"
		gen preferred = 1 if ccode == "ALB" & strpos(sample, "lsms")
		replace preferred = . if ccode == "ALB" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "ALB"
		drop preferred

*Argentina // Selecting preferred EPHC survey; all other duplicates are identical
//	br sample year ps1 dup if ccode == "ARG"
		gen preferred = . if ccode == "ARG"
		replace preferred = 1 if ccode == "ARG" & strpos(sample, "s2") 
		replace preferred = 1 if ccode == "ARG" & strpos(sample, "EPHC")
		replace preferred = 1 if ccode == "ARG" & strpos(sample, "eph_") & year < 2003
		replace preferred = . if ccode == "ARG" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "ARG"
		drop preferred

*Bulgaria // Selecting  time consistent EU-SILC survey (2007+)
//	br sample year ps1 dup if ccode == "BGR"
		gen preferred = 1 if ccode == "BGR" & strpos(sample, "EU-SILC")
		drop if preferred != 1 & ccode == "BGR" & dup > 0
		drop preferred

*Botswana // Selecting the preferred non-GMD version of the survey
//	br sample year ps1 dup if ccode == "BWA"
		gen preferred = 1 if ccode == "BWA"
		replace preferred = . if ccode == "BWA" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "BWA"
		drop preferred
		
*Cameroon // Selecting the preferred non-GMD version of the survey
//	br sample year ps1 dup if ccode == "CMR"
		gen preferred = 1 if ccode == "CMR"
		replace preferred = . if ccode == "CMR" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "CMR"
		drop preferred

*Chile // Selecting preferred CASEN survey; all other duplicates are identical
//	br sample year ps1 dup if ccode == "CHL"
		gen preferred = 1 if ccode == "CHL" & strpos(sample, "casen")
		replace preferred = . if ccode == "CHL" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "CHL"
		quietly bysort ccode year:  gen dup2 = cond(_N==1,0,_n) if ccode == "CHL"
		drop if dup2 > 1 & ccode == "CHL"
		drop preferred dup2

*China //Selecting the nationally represented CHIP survey
//	br sample year ps1 dup if ccode == "CHN"
		gen preferred = 1 if ccode == "CHN" & strpos(sample, "i2d2_chip")
		drop if preferred != 1 & ccode == "CHN"
		drop preferred

*Colombia //Selecting the nationally represented ECH and GEIH surveys
//	br sample year ps1 dup if ccode == "COL"
		gen preferred = 1 if ccode == "COL" & strpos(sample, "ech")
		replace preferred = 1 if ccode == "COL" & strpos(sample, "geih")
		replace preferred = . if ccode == "COL" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "COL"
		drop preferred
		
*Congo, Dep. Rep. // Selecting the more time consistent E123 survey
//	br sample year ps1 dup if ccode == "ZAR"
		gen preferred = 1 if ccode == "ZAR" & strpos(sample, "e123")
		drop if preferred != 1 & ccode == "ZAR"
		drop preferred
		
*Dominican Republic // Selecting preferred CASEN survey; all other duplicates are identical
//	br sample year ps1 dup if ccode == "DOM"
		gen preferred = 1 if ccode == "DOM"
		replace preferred = . if ccode == "DOM" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "DOM"
		drop preferred

*Ethiopia // Selecting more time consistent UEUS survey
//	br sample year ps1 dup if ccode == "ETH"
		gen preferred = 1 if ccode == "ETH" & strpos(sample, "ueus.")
		drop if preferred != 1 & ccode == "ETH" & dup > 0
		drop preferred

*Georgia  // Selecting more time consistent GMD Module for HIS survey
//	br sample year ps1 dup if ccode == "GEO"
		gen preferred = 0 if ccode == "GEO" & strpos(sample, "gmd")
		drop if preferred == 0 & ccode == "GEO"
		drop preferred
		
*Guinea // Selecting the more time consistent ELEP survey
//	br sample year ps1 dup if ccode == "GIN"
		gen preferred = 0 if ccode == "GIN" & strpos(sample, "gmd")
		drop if preferred == 0 & ccode == "GIN" & dup > 0
		drop preferred

*Honduras // Selecting  time consistent EU-SILC survey (2005+)
//	br sample year ps1 dup if ccode == "HND"
		gen preferred = 1 if ccode == "HND"
		replace preferred = . if ccode == "HND" &strpos(sample,"gmd")
		drop if preferred != 1 & ccode == "HND"
		drop preferred

*Hungary // Selecting  time consistent EU-SILC survey (2005+)
//	br sample year ps1 dup if ccode == "HUN"
		gen preferred = 1 if ccode == "HUN" & strpos(sample, "EU-SILC")
		drop if preferred != 1 & ccode == "HUN" & year >2005
		drop preferred

*Jordan // Selecting more time consistent LFS survey
//	br sample year ps1 dup if ccode == "JOR"
		gen preferred = 1 if ccode == "JOR" & strpos(sample, "lfs")
		drop if preferred != 1 & ccode == "JOR" & dup != 0
		drop preferred

*Kazakistan // Removing the less time consistent GMD module of the HBS survey
//	br sample year ps1 dup if ccode == "KAZ"
		gen preferred = 0 if ccode == "KAZ" & strpos(sample, "gmd")
		drop if preferred == 0 & ccode == "KAZ" & dup > 0
		drop preferred

*Lesotho // Selecting time consistent HBS survey or the preferred GMD module
//	br sample year ps1 dup if ccode == "LSO"
		gen preferred = 1 if ccode == "LSO" & strpos(sample, "hbs")
		replace preferred = . if ccode == "LSO" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "LSO"
		drop preferred
		
*Malawi // Selecting the more time consistent IHS survey
//	br sample year ps1 dup if ccode == "MWI"
		gen preferred = 1 if ccode == "MWI" & strpos(sample, "ihs")
		drop if preferred != 1 & ccode == "MWI" & dup > 0
		drop preferred		

*Mauritius // Selecting more time consistent CMPHS survey
//	br sample year ps1 dup if ccode == "MUS"
		gen preferred = 1 if ccode == "MUS" & strpos(sample, "cmphs")
		drop if preferred != 1 & ccode == "MUS"
		drop preferred

*Mozambique // Selecting the more time consistent non-GMD module of the IAF survey
//	br sample year ps1 dup if ccode == "MOZ"
		gen preferred = 1 if ccode == "MOZ" & strpos(sample, "iaf.dta")
		drop if preferred != 1 & ccode == "MOZ" & dup > 0
		drop preferred
		
*Mongolia // Selecting time consistent HIES survey or the preferred GMD module
//	br sample year ps1 dup if ccode == "MNG"
		gen preferred = 1 if ccode == "MNG" & strpos(sample, "gmd") | strpos(sample, "hies")
		drop if preferred != 1 & ccode == "MNG" & dup > 1
		drop if dup > 1 & ccode == "MNG"
		drop preferred

*Nicaragua // Selecting the preferred GMD module
//	br sample year ps1 dup if ccode == "NIC"
		gen preferred = 1 if ccode == "NIC" & strpos(sample, "gmd")
		drop if preferred != 1 & dup > 0 & ccode == "NIC"
		drop preferred
		
*Nigeria // Selecting time consistent LSS survey or the preferred GMD module
//	br sample year ps1 dup if ccode == "NGA"
		gen preferred = 1 if ccode == "NGA" & strpos(sample, "lss")
		replace preferred = 0 if ccode == "NGA" & strpos(sample, "gmd")
		replace preferred = 0 if ccode == "NGA" & strpos(sample, "hn")
		drop if preferred == 0 & ccode == "NGA"
		drop preferred

*Panama // Selecting  time consistent non-GMD module of the EH surve
//	br sample year ps1 dup if ccode == "PAN"
		gen preferred = 1 if ccode == "PAN" & strpos(sample, "a.dta")
		drop if preferred != 1 & ccode == "PAN" & dup >0
		drop preferred

*Paraguay // Selecting  time consistent non-GMD module of the EH surve
//	br sample year ps1 dup if ccode == "PRY"
		gen preferred = 1 if ccode == "PRY" & strpos(sample, "a.dta") | strpos(sample, "m.dta") 
		drop if preferred != 1 & ccode == "PRY" & year != 2012
		replace preferred = 1 if ccode == "PRY" & strpos(sample, "h.dta")
		drop if preferred != 1 & ccode == "PRY"
		drop preferred

*Poland // Selecting  time consistent EU-SILC survey (2005+); other dupliate surveys are identical
//	br sample year ps1 dup if ccode == "POL"
		gen preferred = 1 if ccode == "POL" & strpos(sample, "EU-SILC")
		drop if preferred != 1 & ccode == "POL" & year > 2004
		drop if dup > 1 & ccode == "POL" & year < 2005
		drop preferred

*Romania // Selecting  time consistent EU-SILC survey (2007+); other dupliate surveys identical
	replace ccode = "ROM" if ccode == "ROU"
//	br sample year ps1 dup if ccode == "ROM"
		gen preferred = 1 if ccode == "ROM" & strpos(sample, "EU-SILC")
		drop if preferred != 1 & ccode == "ROM" & year > 2006
		drop preferred

*Russia // Selecting more time consistent RLMS survey
//	br sample year ps1 dup if ccode == "RUS"
		gen preferred = 1 if ccode == "RUS" & strpos(sample, "rlms") 
		drop if preferred != 1 & ccode == "RUS"
		quietly bysort ccode year:  gen dup2 = cond(_N==1,0,_n) if ccode == "RUS"
		drop if dup2 > 1 & ccode == "RUS"
		drop preferred dup2

*Senegal // Removing the less time consistent GMD module of the ESPS survey
//	br sample year ps1 dup if ccode == "SEN"
		gen preferred = 0 if ccode == "SEN" & strpos(sample, "gmd")
		drop if preferred == 0 & ccode == "SEN" & dup > 0
		drop preferred	

*South Africa // Selecting the more time consistent LFS survey
//	br sample year ps1 dup if ccode == "ZAF"
		gen preferred = 1 if ccode == "ZAF" & strpos(sample, "qlfs.dta")
		replace preferred = 1 if year == 2017 & ccode == "ZAF" & strpos(sample, "qlfs")
		drop if preferred != 1 & ccode == "ZAF" & dup > 0
		drop preferred
		
*Sri Lanka // Selecting the more time consistent LFS survey
//	br sample year ps1 dup if ccode == "LKA"
		gen preferred = 1 if ccode == "LKA" & strpos(sample, "lfs")
		drop if preferred != 1 & ccode == "LKA" & dup > 0
		drop preferred
		
*Tanzania // Selecting preferred LFS or NPS surveys
//	br sample year ps1 dup if ccode == "TZA"
		gen preferred = 1 if ccode == "TZA" & strpos(sample, "lfs") | strpos(sample, "nps")
		replace preferred = . if ccode == "TZA" & strpos(sample, "se")
		drop if preferred != 1 & ccode == "TZA" & dup > 0
		drop preferred

*Tajikistan // Selecting the more time consistent GMD module for the LSMS survey
//	br sample year ps1 dup if ccode == "TJK"
		gen preferred = 1 if ccode == "TJK" & strpos(sample, "gmd")
		drop if preferred != 1 & ccode == "TJK" & dup > 0
		drop preferred

*Tunisia // Selecting the more time consistent ENPE survey
//	br sample year ps1 dup if ccode == "TUN"
		gen preferred = 1 if ccode == "TUN" & strpos(sample, "enpe")
		drop if preferred != 1 & ccode == "TUN" & dup > 0
		drop preferred	

*Uganda // Removing the less time consistent GMD module of the ESPS survey
//	br sample year ps1 dup if ccode == "UGA"
		gen preferred = 0 if ccode == "UGA" & strpos(sample, "gmd")
		drop if preferred == 0 & ccode == "UGA" & dup > 0
		drop preferred	

*Ukraine // Selecting the more time consistent non-GMD module of the HLCS survey
//	br sample year ps1 dup if ccode == "UKR"
		gen preferred = 1 if ccode == "UKR" & strpos(sample, "a.dta")
		drop if preferred != 1 & ccode == "UKR" & dup >0
		drop preferred	

*Vietnam // Selecting the more time consistent ENPE survey
//	br sample year ps1  if ccode == "VNM"
		gen preferred = 1 if ccode == "VNM" & strpos(sample, "_lfs")
		drop if preferred != 1 & ccode == "VNM"
		drop preferred	

* All duplicate Country-Year surveys that yield essentially identical results
	drop if dup > 1 & ccode == "BFA"
	drop if dup > 1 & ccode == "BOL"
	drop if dup > 1 & ccode == "ECU"
	drop if dup > 1 & ccode == "GAB"
	drop if dup > 1 & ccode == "GHA"
	drop if dup > 1 & ccode == "GTM"
	drop if dup > 1 & ccode == "KEN"
	drop if dup > 1 & ccode == "LBR"
	drop if dup > 1 & ccode == "MDV"
	drop if dup > 1 & ccode == "MEX"
	drop if dup > 1 & ccode == "NER"
	drop if dup > 1 & ccode == "PAK"
	drop if dup > 1 & ccode == "PRI"
	drop if dup > 1 & ccode == "SLE"
	drop if dup > 1 & ccode == "SRB"
	drop if dup > 1 & ccode == "STP"
	drop if dup > 1 & ccode == "SVN"
	drop if dup > 1 & ccode == "SWZ"
	drop if dup > 1 & ccode == "TCD"
	drop if dup > 1 & ccode == "TGO"
	drop if dup > 1 & ccode == "TUR"
	drop if dup > 1 & ccode == "URY"
	drop if dup > 1 & ccode == "UZB"
	drop if dup > 1 & ccode == "ZMB"

drop dup

*check duplicates*
	dups ccode year, key(ccode)

	cap rename	coefreg_gen_private__hlt coefreg_gen_private_hlt
	cap rename	coefreg_gen_private__edu coefreg_gen_private_edu
	
*****2.Drop problematic survey and surveys that didn't have enough obs**********

***Dropping Samples with public sector employment (as a share of Paid employment): ps1 < 0.05
	drop if ps1<0.05

***Dropping Samples with observations for public sector employment:obs_pub < 200
	drop if obs_pub<200

***Dropping observations comparing public and private sector employment by industry using EU-SILC dataset
	gen EU = 1 if strpos(sample, "SILC")
		replace edu_total = . 					if EU == 1
		replace hlt_total = . 					if EU == 1
		replace edu_paid = . 					if EU == 1
		replace hlt_paid = . 					if EU == 1
		replace edu_formal = . 					if EU == 1
		replace hlt_formal = . 					if EU == 1
		replace edu_fem = . 					if EU == 1
		replace hlt_fem = . 					if EU == 1
		replace mean_age_private_hlt = . 		if EU == 1
		replace mean_age_private_edu = . 		if EU == 1
		replace median_age_private_hlt = . 		if EU == 1
		replace median_age_private_edu = . 		if EU == 1
		replace ed3_private_edu = . 			if EU == 1
		replace ed3_private_hlt = . 			if EU == 1
		replace coefreg_fem_hlt = . 			if EU == 1
		replace p_fem_hlt = . 					if EU == 1
		replace coefreg_fem_edu = . 			if EU == 1
		replace p_fem_edu = . 					if EU == 1
		replace coefreg_mal_hlt = . 			if EU == 1
		replace p_mal_hlt = . 					if EU == 1
		replace coefreg_mal_edu = . 			if EU == 1
		replace p_mal_edu = . 					if EU == 1
		replace coefreg_f_hlt = . 				if EU == 1
		replace p_f_hlt = . 					if EU == 1
		replace coefreg_f_edu = . 				if EU == 1
		replace p_f_edu = . 					if EU == 1
		replace coefreg_cont_hlt = . 			if EU == 1
		replace p_cont_hlt = . 					if EU == 1
		replace coefreg_cont_edu = . 			if EU == 1
		replace p_cont_edu = . 					if EU == 1
		replace coefreg_gen_private_hlt = . 	if EU == 1
		replace p_gen_private_hlt = . 			if EU == 1
		replace coefreg_gen_private_edu = . 	if EU == 1
		replace p_gen_private_edu = . 			if EU == 1
		
****generate new variable and drop some variables to create clean dataset for publish *****

	gen compratio_0=total_p90_0/total_p10_0
	gen compratio_1=total_p90_1/total_p10_1

**** Merge country/region/income group classifications

	replace ccode = "XKX" if ccode == "KSV"
	replace ccode = "COD" if ccode == "ZAR"
	replace ccode = "TLS" if ccode == "TMP"

	merge m:1 ccode using "${Input}country_codes.dta", assert(2 3) keep(3) nogen

****Appending with LIS data***

append using  "${Input}LIS20181010.dta"

	rename obs_pub			pub_obs
	rename obs_pemp			pemp_obs
	rename obs_emp			emp_obs
	rename obs_fullsample	fullsample_obs

	drop wage_x wage_gdp

	*check duplicates*
	dups ccode year, key(ccode)

	quietly bysort ccode year:  gen dup = cond(_N==1,0,_n)
	drop if dup > 0 & sample == "LIS"
	drop dup

****Identify the three main sources of data coming into the final dataset

gen source="I2D2"
	replace source="LIS" if sample=="LIS"
	replace source = "EU-SILC" if substr(sample,strpos(sample,".")- 4,.) == "SILC.dta"
	
*** Listing full source names for publishing purposes

gen source_exp=source
	replace source_exp = "International Income Distribution Database (I2D2)" 						if source=="I2D2"
	replace source_exp = "Luxembourg Income Study Database (LIS) " 									if source=="LIS"
	replace source_exp = "Cross-sectional EU Statistics on Income and Living Conditions (EU-SILC)" 	if substr(sample,strpos(sample,".")- 4,.) == "SILC.dta"


****Merge ICP Compression Ratios Data recieved from Mizuki Yamanaka <myamanaka@worldbank.org>

merge 1:1 ccode year using "${Input}ICP_data.dta", nogen
	
keep countryname ccode year sample sample1 source source_exp world_region incgroup lngdppc age_mean_0 age_mean_1 age_med_0 age_med_1 coefreg coefreg_f compratio_0 compratio_1 cont_prv cont_pub diff_mean_0 diff_mean_1 diff_median_0 diff_median_1 ed0_0 ed0_1 ed1_0 ed1_1 ed2_0 ed2_1 ed3_0 ed3_1 emp_obs female_0 female_1 fullsample_obs hins_prv hins_pub occup_1_pr occup_1_pu occup_2_pr occup_2_pu occup_3_pr occup_3_pu occup_4_pr occup_4_pu occup_9_pr occup_9_pu p p_edu p_f p_gender p_occ pemp_obs ps1 ps1_fem ps1_mal ps1_rur ps1_urb ps2 ps2_fem ps2_mal ps2_rur ps2_urb ps3 psedu3 pub_obs quintile_1_pr quintile_1_pu quintile_2_pr quintile_2_pu quintile_3_pr  quintile_3_pu quintile_4_pr quintile_4_pu quintile_5_pr quintile_5_pu rur_0 rur_1 rwoccup_0_1 rwoccup_0_2 rwoccup_0_3 rwoccup_0_5 rwoccup_0_6 rwoccup_1_1 rwoccup_1_2 rwoccup_1_3 rwoccup_1_5 rwoccup_1_6 ssec_prv ssec_pub union_prv union_pub WPedu1 WPedu2 WPedu3 WPedu4 WPfemale WPmale WPocup1 WPocup2 WPocup3 WPocup4 WPocup9 cross_median_sengov cross_median_judge cross_median_doctor cross_median_nurse cross_median_economist cross_median_university cross_median_second cross_median_primary cross_median_police comp_sengov comp_judge comp_doctor comp_nurse comp_economist comp_university comp_second comp_primary comp_police cross_mean_sengov cross_mean_judge cross_mean_doctor cross_mean_nurse cross_mean_economist cross_mean_university cross_mean_second cross_mean_primary cross_mean_police total_edu total_hlt total_adm paid_edu paid_hlt paid_adm formal_edu formal_hlt formal_adm edu_total hlt_total edu_paid hlt_paid edu_formal hlt_formal edu_fem hlt_fem fem_edu fem_hlt fem_adm rur_hlt rur_edu rur_adm obs_emp_hlt obs_emp_edu obs_emp_adm obs_paid_hlt obs_paid_edu obs_paid_adm obs_pub_hlt obs_pub_edu obs_pub_adm mean_age_public_hlt mean_age_public_edu mean_age_public_adm median_age_public_hlt median_age_public_edu median_age_public_adm mean_age_private_hlt mean_age_private_edu median_age_private_hlt median_age_private_edu ed3_public_edu ed3_public_hlt ed3_public_adm ed3_private_edu ed3_private_hlt coefreg_gen_hlt p_gen_hlt coefreg_gen_edu p_gen_edu coefreg_gen_adm p_gen_adm coefreg_fem_hlt p_fem_hlt coefreg_fem_edu p_fem_edu coefreg_mal_hlt p_mal_hlt coefreg_mal_edu p_mal_edu coefreg_f_hlt p_f_hlt coefreg_f_edu p_f_edu coefreg_cont_hl p_cont_hlt coefreg_cont_edu p_cont_edu coefreg_gen_private_hlt p_gen_private_hlt coefreg_gen_private_edu p_gen_private_edu 


	drop countryname world_region incgroup lngdppc

**** Merge country/region/income group classifications

merge m:1 ccode using "${Input}country_codes.dta", assert(2 3) keep(1 3) nogen


save	"${Output}Summary_WWBI (incl. IMF ICP & LIS).dta", replace


*****3.Identify outliers**********

use 	"${Output}Summary_WWBI (incl. IMF ICP & LIS).dta", clear


sort countryname year

encode ccode, gen(ccode1)
	bysort ccode: gen ccode_obs = _N

	bysort incgroup: gen incgroup_obs = _N

encode world_region, gen(region1)
	bysort world_region: gen region_obs = _N
	
foreach var of varlist ps1 ps1_mal ps1_fem ps1_urb ps1_rur ps2 ps2_mal ps2_fem ps2_urb ps2_rur ps3 coefreg diff_mean_0 diff_median_0 diff_mean_1 diff_median_1 coefreg_f WPedu1 WPedu2 WPedu3 WPedu4 WPocup1 WPocup2 WPocup3 WPocup4 WPocup9 WPmale WPfemale cont_pub cont_prv hins_pub hins_prv ssec_pub ssec_prv union_pub union_prv female_0 age_mean_0 age_med_0 ed0_0 ed1_0 ed2_0 ed3_0 rur_0 female_1 age_mean_1 age_med_1 ed0_1 ed1_1 ed2_1 ed3_1 rur_1 occup_1_pu occup_2_pu occup_3_pu occup_4_pu occup_9_pu occup_1_pr occup_2_pr occup_3_pr occup_4_pr occup_9_pr quintile_1_pu quintile_2_pu quintile_3_pu quintile_4_pu quintile_5_pu quintile_1_pr quintile_2_pr quintile_3_pr quintile_4_pr quintile_5_pr psedu3 rwoccup_0_1 rwoccup_0_2 rwoccup_0_3 rwoccup_0_5 rwoccup_0_6 rwoccup_1_1 rwoccup_1_2 rwoccup_1_3 rwoccup_1_5 rwoccup_1_6 compratio_0 compratio_1 total_edu total_hlt total_adm paid_edu paid_hlt paid_adm formal_edu formal_hlt formal_adm edu_total hlt_total edu_paid hlt_paid edu_formal hlt_formal edu_fem hlt_fem fem_edu fem_hlt fem_adm rur_hlt rur_edu rur_adm obs_emp_hlt obs_emp_edu obs_emp_adm obs_paid_hlt obs_paid_edu obs_paid_adm obs_pub_hlt obs_pub_edu obs_pub_adm mean_age_public_hlt mean_age_public_edu mean_age_public_adm median_age_public_hlt median_age_public_edu median_age_public_adm mean_age_private_hlt mean_age_private_edu median_age_private_hlt median_age_private_edu ed3_public_edu ed3_public_hlt ed3_public_adm ed3_private_edu ed3_private_hlt coefreg_gen_hlt coefreg_gen_edu coefreg_gen_adm coefreg_fem_hlt coefreg_fem_edu coefreg_mal_hlt coefreg_mal_edu coefreg_f_hlt coefreg_f_edu coefreg_cont_hlt coefreg_cont_edu coefreg_gen_private_hlt coefreg_gen_private_edu {
    
	sum `var'

	cap gen `var'_dist = (`r(max)'-`r(min)')/5 // calculate the difference between the highest and the lowest observation by indicator
	cap gen `var'_sd   = .
	cap gen `var'_m    = .

	cap gen Z_ccode_`var'    = 0
	cap gen Z_incgroup_`var' = 0
	cap gen Z_region_`var'   = 0

	foreach x of numlist 1/182	{

		sum `var' if ccode1 == `x'

		cap noisily replace `var'_sd = `r(sd)'  if ccode1 == `x' // calculate the standard deviaton from the country mean for each observation by indicator
		cap noisily replace `var'_m = `r(mean)' if ccode1 == `x' // calculate the country specific mean for each observation by indicator

* identify outliers located over 3 sd away from the mean for countries with more than three observations
		
		cap replace Z_ccode_`var' = 1 if `var' < (`var'_m - (3 * `var'_sd) ) & ccode1 == `x' & ccode_obs > 3 // for countries with
		cap replace Z_ccode_`var' = 1 if `var' > (`var'_m + (3 * `var'_sd) ) & ccode1 == `x' & ccode_obs > 3 
		
* identify outliers with over 20 percent variation of the total deviation of the indicator for all countries
		
		cap replace Z_ccode_`var' = 1 if abs(`var'-`var'_m) > `var'_dist & ccode1 == `x'


		// list countryname year `var' Z_ccode_`var' if Z_ccode_`var' == 1
	
	}
	
	foreach y of numlist 1/4	{

		sum `var' if incgroup == `y'

		cap replace `var'_sd = `r(sd)'  if incgroup == `y'
		cap replace `var'_m = `r(mean)' if incgroup == `y'
		
* identify outliers located over 3 sd away from the mean for income group with less than four observations
		
		cap replace Z_incgroup_`var' = 1 if `var' < (`var'_m - (3 * `var'_sd) ) & incgroup == `y' & ccode_obs < 4
		cap replace Z_incgroup_`var' = 1 if `var' > (`var'_m + (3 * `var'_sd) ) & incgroup == `y' & ccode_obs < 4

	//	list countryname year `var' Z_incgroup_`var' if Z_incgroup_`var' == 1
	
	}

	foreach z of numlist 1 2 3 4 6 7 {

		cap sum `var' if region1 == `z'

		cap replace `var'_sd = `r(sd)'  if region1 == `z'
		cap replace `var'_m = `r(mean)' if region1 == `z'

* identify outliers located over 3 sd away from the mean for the region with less than four observations
		cap replace Z_region_`var' = 1 if `var' < (`var'_m - (3 * `var'_sd) ) & region1 == `z' & ccode_obs < 4
		cap replace Z_region_`var' = 1 if `var' > (`var'_m + (3 * `var'_sd) ) & region1 == `z' & ccode_obs < 4

		//list countryname year `var' Z_region_`var' if Z_region_`var' == 1

	}
	cap replace `var' = . if Z_region_`var' == 1 | Z_incgroup_`var' == 1 |  Z_ccode_`var'	== 1

	cap drop `var'_dist `var'_sd `var'_m Z_ccode_`var' Z_incgroup_`var' Z_region_`var'	

}

replace ps1				= . if ccode == "SLE" & year == 2003
replace ps1				= . if ccode == "SLE" & year == 2011
replace diff_mean_0		= . if ccode == "NGA" & year == 2003
replace diff_mean_0		= . if ccode == "NGA" & year == 2009
replace diff_median_0	= . if ccode == "NER" & year == 2007
replace diff_median_0	= . if ccode == "NER" & year == 2011
replace diff_mean_1		= . if ccode == "NER" & year == 2007
replace WPedu1			= . if ccode == "MWI" & year == 2016
replace WPedu1			= . if ccode == "LKA" & year == 2008
replace WPedu1			= . if ccode == "ZMB" & year == 2010
replace WPedu1			= . if ccode == "ZMB" & year == 2008
replace WPedu1			= . if ccode == "ITA" & year == 2014
replace WPedu1			= . if ccode == "ITA" & year == 2017
replace WPedu3			= . if ccode == "PRY" & year == 2014
replace WPedu3			= . if ccode == "PRY" & year == 2016
replace WPedu3			= . if ccode == "ZWE" & year == 2001
replace WPfemale		= . if ccode == "NER" & year == 2007
replace WPfemale		= . if ccode == "NER" & year == 2011
replace rwoccup_1_5		= . if ccode == "MEX" & year == 2012
replace compratio_0		= . if ccode == "BGD" & year == 2010
replace compratio_0		= . if ccode == "COD" & year == 2012
replace compratio_0		= . if ccode == "COD" & year == 2004
replace compratio_0		= . if ccode == "NER" & year == 2011
replace compratio_0		= . if ccode == "NER" & year == 2007
replace compratio_0		= . if ccode == "NGA" & year == 2003
replace compratio_0		= . if ccode == "ZWE" & year == 2007
replace compratio_1		= . if ccode == "BFA" & year == 2014
replace compratio_1		= . if ccode == "ZWE" & year == 2007

foreach var of varlist age_mean_0 age_mean_1 age_med_0 age_med_1 emp_obs fullsample_obs pemp_obs ps1 ps2 ps3 pub_obs total_edu total_hlt total_adm paid_edu paid_hlt paid_adm formal_edu formal_hlt formal_adm edu_total hlt_total edu_paid hlt_paid edu_formal hlt_formal obs_emp_hlt obs_emp_edu obs_emp_adm obs_paid_hlt obs_paid_edu obs_paid_adm obs_pub_hlt obs_pub_edu obs_pub_adm mean_age_public_hlt mean_age_public_edu mean_age_public_adm median_age_public_hlt median_age_public_edu median_age_public_adm mean_age_private_hlt mean_age_private_edu median_age_private_hlt median_age_private_edu {
	
replace `var'= . if `var' == 0


}


****Merge IMF Wage bill data recieved from Mercedes Garcia-Escribano <mgarciaescribano@imf.org>

merge 1:1 ccode year using "${Input}wage_bill (2000-2018).dta", nogen


***** removing the associated p-values for wage premium estimates that have been removed as outliers

replace p 					= . if	coefreg					 == .
replace p_f 				= . if 	coefreg_f				 == .
replace p_edu 				= . if 	WPedu1					 == . & WPedu2 		== . & WPedu3 	== . & WPedu4 	== .
replace p_occ 				= . if 	WPocup1					 == . & WPocup2 	== . & WPocup3 	== . & WPocup4 	== . & WPocup9 == .
replace p_gender			= . if 	WPmale 					 == . & WPfemale 	== .
replace p_cont_edu 			= . if  coefreg_cont_edu  		 == .
replace p_cont_hlt 			= . if  coefreg_cont_hlt  		 == .
replace p_f_edu 			= . if  coefreg_f_edu  			 == .
replace p_f_hlt 			= . if  coefreg_f_hlt 			 == .
replace p_fem_edu 			= . if  coefreg_fem_edu 		 == .
replace p_fem_hlt 			= . if  coefreg_fem_hlt 		 == .
replace p_mal_edu 			= . if  coefreg_mal_edu 		 == .
replace p_mal_hlt 			= . if  coefreg_mal_hlt 		 == .
replace p_gen_private_edu 	= . if  coefreg_gen_private_edu  == .
replace p_gen_private_hlt 	= . if  coefreg_gen_private_hlt  == .
replace p_gen_edu 			= . if  coefreg_gen_edu  		 == .
replace p_gen_hlt 			= . if  coefreg_gen_hlt 		 == .
replace p_gen_adm 			= . if  coefreg_gen_adm			 == .


replace coefreg						= . if p					== .
replace coefreg_f					= . if p_f 					== .
replace WPedu1						= . if p_edu 				== .
replace WPedu2						= . if p_edu 				== .
replace WPedu3						= . if p_edu 				== .
replace WPedu4						= . if p_edu 				== .
replace WPocup1						= . if p_occ 				== .
replace WPocup2						= . if p_occ 				== .
replace WPocup3						= . if p_occ 				== .
replace WPocup4						= . if p_occ 				== .
replace WPocup9						= . if p_occ 				== .
replace WPfemale					= . if p_gender 			== .
replace WPmale						= . if p_gender 			== .
replace coefreg_cont_edu 			= . if  p_cont_edu 			== .
replace coefreg_cont_hlt 			= . if  p_cont_hlt 			== .
replace coefreg_f_edu 				= . if  p_f_edu 			== .
replace coefreg_f_hlt 				= . if  p_f_hlt 			== .
replace coefreg_fem_edu 			= . if  p_fem_edu 			== .
replace coefreg_fem_hlt 			= . if  p_fem_hlt 			== .
replace coefreg_mal_edu 			= . if  p_mal_edu 			== .
replace coefreg_mal_hlt 			= . if  p_mal_hlt 			== .
replace coefreg_gen_private_edu 	= . if  p_gen_private_edu	== .
replace coefreg_gen_private_hlt 	= . if  p_gen_private_hlt	== .
replace coefreg_gen_edu 			= . if  p_gen_edu 			== .
replace coefreg_gen_hlt 			= . if  p_gen_hlt 			== .
replace coefreg_gen_adm 			= . if  p_gen_adm			== .

/*******************************************************************************
Tranform wage premium regresion Betas to e^beta - 1							  */

foreach var of varlist coefreg coefreg_f WPedu1 WPedu2 WPedu3 WPedu4 WPocup1 WPocup2 WPocup3 WPocup4 WPocup9 WPmale WPfemale coefreg_cont_edu coefreg_cont_hlt coefreg_f_edu coefreg_f_hlt coefreg_fem_edu coefreg_fem_hlt coefreg_mal_edu coefreg_mal_hlt coefreg_gen_private_edu coefreg_gen_private_hlt coefreg_gen_edu coefreg_gen_hlt coefreg_gen_adm {
    
replace `var' = exp(`var')-1 if `var' != .

}


keep countryname ccode year sample world_region incgroup sample1 source source_exp age_mean_0 age_mean_1 age_med_0 age_med_1 coefreg coefreg_f compratio_0 compratio_1 cont_prv cont_pub diff_mean_0 diff_mean_1 diff_median_0 diff_median_1 ed0_0 ed0_1 ed1_0 ed1_1 ed2_0 ed2_1 ed3_0 ed3_1 emp_obs female_0 female_1 fullsample_obs hins_prv hins_pub occup_1_pr occup_1_pu occup_2_pr occup_2_pu occup_3_pr occup_3_pu occup_4_pr occup_4_pu occup_9_pr occup_9_pu p p_edu p_f p_gender p_occ pemp_obs ps1 ps1_fem ps1_mal ps1_rur ps1_urb ps2 ps2_fem ps2_mal ps2_rur ps2_urb ps3 psedu3 pub_obs quintile_1_pr quintile_1_pu quintile_2_pr quintile_2_pu quintile_3_pr  quintile_3_pu quintile_4_pr quintile_4_pu quintile_5_pr quintile_5_pu rur_0 rur_1 rwoccup_0_1 rwoccup_0_2 rwoccup_0_3 rwoccup_0_5 rwoccup_0_6 rwoccup_1_1 rwoccup_1_2 rwoccup_1_3 rwoccup_1_5 rwoccup_1_6 ssec_prv ssec_pub union_prv union_pub WPedu1 WPedu2 WPedu3 WPedu4 WPfemale WPmale WPocup1 WPocup2 WPocup3 WPocup4 WPocup9 cross_median_sengov cross_median_judge cross_median_doctor cross_median_nurse cross_median_economist cross_median_university cross_median_second cross_median_primary cross_median_police comp_sengov comp_judge comp_doctor comp_nurse comp_economist comp_university comp_second comp_primary comp_police cross_mean_sengov cross_mean_judge cross_mean_doctor cross_mean_nurse cross_mean_economist cross_mean_university cross_mean_second cross_mean_primary cross_mean_police total_edu total_hlt total_adm paid_edu paid_hlt paid_adm formal_edu formal_hlt formal_adm edu_total hlt_total edu_paid hlt_paid edu_formal hlt_formal edu_fem hlt_fem fem_edu fem_hlt fem_adm rur_hlt rur_edu rur_adm obs_emp_hlt obs_emp_edu obs_emp_adm obs_paid_hlt obs_paid_edu obs_paid_adm obs_pub_hlt obs_pub_edu obs_pub_adm mean_age_public_hlt mean_age_public_edu mean_age_public_adm median_age_public_hlt median_age_public_edu median_age_public_adm mean_age_private_hlt mean_age_private_edu median_age_private_hlt median_age_private_edu ed3_public_edu ed3_public_hlt ed3_public_adm ed3_private_edu ed3_private_hlt coefreg_gen_hlt p_gen_hlt coefreg_gen_edu p_gen_edu coefreg_gen_adm p_gen_adm coefreg_fem_hlt p_fem_hlt coefreg_fem_edu p_fem_edu coefreg_mal_hlt p_mal_hlt coefreg_mal_edu p_mal_edu coefreg_f_hlt p_f_hlt coefreg_f_edu p_f_edu coefreg_cont_hl p_cont_hlt coefreg_cont_edu p_cont_edu coefreg_gen_private_hlt p_gen_private_hlt coefreg_gen_private_edu p_gen_private_edu  wage_gdp wage_x



preserve

	keep ccode year sample
	save "${Output}WWBI Version 2.0 Index.dta", replace

restore

 save"${Output}WWBI_v2.0_clean.dta",replace
