
**************************************************************************
*PUBLIC SECTOR EMPLOYMENT
*PART 3
*Include/Exclude sample& Exclude Outlier & Label
*Created by: Rong Shi
*First version: November 2018
*Latest version: June 2019
**************************************************************************

set more 1 
use"${Out}\summary_I2D2.dta", clear

*****1.Keep only one survey for a country at a given year**********
****Drop surveys when there're more than one survey a country at a given year***** 

*West bank have quaterly survey, juet keep the first quarter
drop if sample=="wbg_2000_i2d2_lfs_3.dta"
drop if sample=="wbg_2000_i2d2_lfs_2.dta"
drop if sample=="wbg_2000_i2d2_lfs_4.dta"

drop if sample=="wbg_2001_i2d2_lfs_3.dta"
drop if sample=="wbg_2001_i2d2_lfs_2.dta"
drop if sample=="wbg_2001_i2d2_lfs_4.dta"

drop if sample=="wbg_2002_i2d2_lfs_3.dta"
drop if sample=="wbg_2002_i2d2_lfs_2.dta"
drop if sample=="wbg_2002_i2d2_lfs_4.dta"

drop if sample=="wbg_2003_i2d2_lfs_3.dta"
drop if sample=="wbg_2003_i2d2_lfs_2.dta"
drop if sample=="wbg_2003_i2d2_lfs_4.dta"

drop if sample=="wbg_2007_i2d2_lfs_3.dta"
drop if sample=="wbg_2007_i2d2_lfs_2.dta"
drop if sample=="wbg_2007_i2d2_lfs_4.dta"

*argentina have bi-annual data*

drop if sample=="arg_2003_i2d2_eph_v01_m_v02_a.dta"
drop if sample=="arg_2004_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2005_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2006_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2007_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2008_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2009_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2010_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2011_i2d2_ephc_s1_v01_m_v03_a.dta"
drop if sample=="arg_2012_i2d2_ephc_s1_v01_m_v01_a.dta"
drop if sample=="arg_2013_i2d2_ephc_s1_v01_m_v01_a.dta"

*if data give similar indicator then just drop data with different data source
drop if sample=="ecu_2006_i2d2_ecv_v01_m_v02_a.dta" 
drop if sample=="ecu_2008_i2d2_enemdu_v01_m_v02_a.dta" 
drop if sample=="ecu_2009_i2d2_enemdu_v01_m_v02_a.dta"
drop if sample=="ecu_2011_i2d2_enemdu_v01_m_v02_a.dta"
drop if sample=="vnm_2010_i2d2_vhlss.dta"
drop if sample=="ner_2011_i2d2_ecvma.dta"
drop if  sample=="lka_2012_i2d2_hies_v01_m_v01_a.dta"
drop if sample=="nga_2009_i2d2_hnlss.dta"
*different results drop based on other years value
drop if sample=="mng_2002_i2d2_lfs.dta"
*** data source is the same then drop less observation**
drop if sample=="zaf_2001_i2d2_lfs_2.dta"
drop if sample=="mwi_2013_i2d2_ihs.dta"
drop if sample=="tza_2011_i2d2_nps.dta"
***drop urban survey****

drop if sample=="ury_2000_i2d2_ech_v01_m_v02_a.dta"
drop if sample=="ury_2001_i2d2_ech_v01_m_v02_a.dta"
drop if sample=="ury_2002_i2d2_ech_v01_m_v02_a.dta"
drop if sample=="ury_2003_i2d2_ech_v01_m_v02_a.dta"
drop if sample=="ury_2004_i2d2_ech_v01_m_v02_a.dta"
drop if sample=="ury_2005_i2d2_ech_v01_m_v02_a.dta"

drop if sample=="eth_2003_i2d2_ueus.dta"
drop if sample=="eth_2004_i2d2_ueus.dta"
drop if sample=="eth_2006_i2d2_ueus.dta"
drop if sample=="eth_2009_i2d2_ueus.dta"
drop if sample=="eth_2010_i2d2_ueus.dta"
drop if sample=="eth_2011_i2d2_ueus.dta"
drop if sample=="eth_2012_i2d2_ueus.dta"
drop if sample=="eth_2014_i2d2_ueus.dta"

*check duplicates*
dups ccode year, key(ccode)

***drop survey that didn't pass filter(if have two more surveys)***
sort ccode year
quietly by ccode year:  gen dup = cond(_N==1,0,_n)
drop if filter!=0&dup!=0
drop dup

*****2.Drop problematic survey and surveys that didn't have enough obs**********

*congo have exactly same data for 2004 and 2005, thus drop 2004 **
drop if sample=="zar_2004_i2d2_e123.dta"

***drop if ps1<0.05****
drop if ps1<0.05
drop if obs_pub<200


/**drop 
 20. |   ARM   2009   arm_2009_i2d2_ilcs_v01_m_v03_a.dta |
 21. |   ARM   2011   arm_2011_i2d2_ilcs_v01_m_v01_a.dta |
 22. |   ARM   2013   arm_2013_i2d2_ilcs_v01_m_v03_a.dta |
 23. |   ARM   2008   arm_2008_i2d2_ilcs_v01_m_v01_a.dta |
 24. |   ARM   2004   arm_2004_i2d2_ilcs_v01_m_v01_a.dta |
     |---------------------------------------------------|
 32. |   BGR   2003   bgr_2003_i2d2_mths_v01_m_v01_a.dta |
292. |   SEN   2011               sen_2011_i2d2_esps.dta |
     +---------------------------------------------------+

     +-------------------+
     | countryn~e   year |
     |-------------------|
243. |       Mali   2010 |
244. | Montenegro   2002 |
245. | Montenegro   2004 |
274. |      Niger   2011 |
430. |     Uganda   2010 |
     +-------------------+

	 */

****generate new variable and drop some variables to create clean dataset for publish *****

gen compratio_0=total_p90_0/total_p10_0
gen compratio_1=total_p90_1/total_p10_1


rename obs_pub  pub_obs
rename obs_pemp  pemp_obs
rename obs_emp   emp_obs
rename obs_fullsample  fullsample_obs


drop obs_* nm_* *_se
drop ps1_1524 ps1_2564 ps1_65p ps2_1524 ps2_2564 ps2_65p
drop coefreg_noc reg_obs_* r2_* reg_obs r2 coefreg10 coefreg25 coefreg50 coefreg75 coefreg90 reg_obs* total_* diff_p*
drop coefreg_se_noc coefreg_se_f coefreg_se10 coefreg_se25 coefreg_se50 coefreg_se75 coefreg_se90  p_* p
drop *_dif  ben1_* ben2_*
drop age15_24_* age25_64_* age65p_*
drop occup_10_* occup_5_* occup_6_* occup_7_* occup_8_* occup_99_*
drop WPocup5 WPocup6 WPocup7 WPocup8 WPocup10 WPocup11
drop lfp_r emp_r paidemp_r lfp_r_* emp_r_* paidemp_r_*
drop diff_mean_0_*  diff_mean_1_*  rwoccup_*_5 rwoccup_*_6
drop quintile_pu quintile_pr






****merge with gdp and wage/gdp age/X data from Daniel's old data file
merge 1:1 ccode year using "${input}\WWBI_merged_v1.dta", keepusing( ifscode region ccode cyear country year lngdppc wage_gdp wage_x)
drop if _merge==2
drop cyear country countrycode _merge
drop ifscode developing regioncode

save"${Out}\summaryI2D2withgdp.dta", replace



???DELETE FROM PUBLIC VERSION BUT SEPARATE DO FILE AND DESCRIPTION OF WHAT THIS IS ETC. FOR BL TEAM???


****append with LIS data***

use "${Out}\summaryI2D2withgdp.dta", clear

 ****append with LIS data****( LIS data from old WWBI file thus may be inconsistent"
append using  "${input}\LIS20181010.dta"
*check duplicates*
dups ccode year, key(ccode)
drop cyear-incomegroup
drop ons_union





???SEPARATE DO FILE?????
*****label the dataset


label var pub_obs     "Number of public paid employees"
label var pemp_obs   "Number of paid employees"
label var emp_obs     "Number of employed individuals"
label var fullsample_obs  "Sample size"

label var ps1       "Public sector employment as a share of paid employment"
label var ps1_mal      "Public sector employment as a share of paid employment by gender:male"
label var ps1_fem      "Public sector employment as a share of paid employment by gender:female"
label var ps1_urb      "Public sector employment as a share of paid employment by location:urban"
label var ps1_rur      "Public sector employment as a share of paid employment by location:rural"

label var ps2        "Public sector employment as a share of total employment"
label var ps2_mal      "Public sector employment as a share of total employment by gender:male"
label var ps2_fem      "Public sector employment as a share of total employment by gender:female"
label var ps2_urb      "Public sector employment as a share of total employment by location:urban"
label var ps2_rur      "Public sector employment as a share of total employment by location:rural"
label var ps3  "Public sector employment as a share of formal employment"


label var coefreg  "Public sector wage premium (compared to all private employees)"
label var coefreg_f  "Public sector wage premium (compared to formal wage employees)"
label var  WPedu1 "Public sector wage premium by education level:No education(compared to formal wage employees)"
label var  WPedu2 "Public sector wage premium by education level:Primary education(compared to formal wage employees)"
label var  WPedu3  "Public sector wage premium by education level:Secondary education(compared to formal wage employees)"
label var  WPedu4  "Public sector wage premium by education level:Tertiary education(compared to formal wage employees)"

label var  WPocup1 "Public sector wage premium by occupation:Senior officials(compared to formal wage employees)"
label var WPocup2  "Public sector wage premium by occupation:Professionals(compared to formal wage employees)"
label var  WPocup3  "Public sector wage premium by occupation:Technacians(compared to formal wage employees)"
label var  WPocup4  "Public sector wage premium by occupation:Clerks(compared to formal wage employees)"
label var  WPocup9  "Public sector wage premium by occupation:Elemantry occupation(compared to formal wage employees)"

label var WPmale "Public sector wage premiums by gender:Male"
label var WPfemale "Public sector wage premiums by gender:Female"


label var diff_mean_0  "Female to male wage ratio in the private sector(using mean)"
label var diff_median_0 "Female to male wage ratio in the private sector(using median)"
label var diff_mean_1  "Female to male wage ratio in the public sector (using mean)"
label var diff_median_1 "Female to male wage ratio in the public sector (using median)" 

label var compratio_0 "Pay compression ratio in private sector"
label var compratio_1 "Pay compression ratio in public sector"


label var cont_pub  "Share of public paid employees with a contract" 
label var cont_prv  "Share of private paid employees with a contract" 

label var hins_pub  "Share of public paid employees with health insurance" 
label var hins_prv  "Share of private paid employees with health insurance" 

label var ssec_pub  "Share of public paid employees with social secruity" 
label var ssec_prv  "Share of private paid employees with social secruity" 

label var union_pub  "Share of public paid employees with union membership" 
label var union_prv  "Share of private paid employees with union membership" 



label var  female_0 "Females as a share of private paid employees"
label var  age_mean_0 "Mean age of private paid employees"
label var  age_med_0  "Median age of private paid employees"

label var ed0_0 "Individuals with no education as a share of private paid employees"
label var ed1_0 "Individuals with primary education as a share of private paid employees"
label var ed2_0 "Individuals with secondary education as a share of private paid employees"
label var  ed3_0 "Individuals with tertiary education as a share of private paid employees"
label var  rur_0 "Rural residents as a share of private paid employees"

label var  female_1 "Females,as a share of public paid employees"
label var  age_mean_1 "Mean age of public paid employees"
label var  age_med_1  "Median age of public paid employees"

label var ed0_1 "Individuals with no education as a share of public paid employees"
label var ed1_1 "Individuals with primary education as a share of public paid employees"
label var ed2_1 "Individuals with secondary education as a share of public paid employees"
label var  ed3_1 "Individuals with tertiary education as a share of public paid employees"
label var  rur_1 "Rural resident as a share of public paid employees"

label var psedu3 "Proportion of total employees with tertiary education working in public sector"


label var  occup_1_pu "Females as a share of public paid employees by occupation:Senior officials"
label var occup_2_pu "Females as a share of public paid employees by occupation:Professionals"
label var  occup_3_pu "Females as a share of public paid employees by occupation:Technicians"
label var  occup_4_pu  "Females as a share of public paid employees by occupation:Clerks"

label var  occup_9_pu "Females as a share of public paid employees by occupation:Elementary occupation"

label var  occup_1_pr "Females as a share of private paid employees by occupation:Senior officials"
label var occup_2_pr "Females as a share of private paid employees by occupation:Professionals"
label var  occup_3_pr "Females as a share of private paid employees by occupation:Technicians"
label var  occup_4_pr "Females as a share of private paid employees by occupation:Clerks"

label var  occup_9_pr "Females as a share of private paid employees by occupation:Elementary occupation"

label var  quintile_1_pu "Females,as a share of public paid employee by wage quintile:Quintile 1"
label var quintile_2_pu "Females,as a share of public paid employee by wage quintile:Quintile 2"
label var  quintile_3_pu "Females,as a share of public paid employee by wage quintile:Quintile 3"
label var  quintile_4_pu  "Females,as a share of public paid employee by wage quintile:Quintile 4"
label var  quintile_5_pu "Females,as a share of public paid employee by wage quintile:Quintile 5"

label var  quintile_1_pr "Females,as a share of private paid employee by wage quintile:Quintile 1"
label var quintile_2_pr "Females,as a share of private paid employee by wage quintile:Quintile 2"
label var  quintile_3_pr "Femalesas a share of private paid employee by wage quintile:Quintile 3"
label var  quintile_4_pr  "Females,as a share of private paid employee by wage quintile:Quintile 4"
label var  quintile_5_pr "Females,as a share of private paid employee by wage quintile:Quintile 5"


label var rwoccup_0_1 "Relative wage of Senior officials(using clerk as reference) in private sector"
label var rwoccup_0_2 "Relative wage of Professionals(using clerk as reference) in private sector"
label var rwoccup_0_3 "Relative wage of Technicians(using clerk as reference) in private sector"


label var rwoccup_1_1 "Relative wage of Senior officials(using clerk as reference) in public sector"
label var rwoccup_1_2 "Relative wage of Professionals(using clerk as reference) in public sector"
label var rwoccup_1_3 "Relative wage of Technicians(using clerk as reference) in public sector"

label var wage_gdp  "Wage bill as a percentage of GDP"
label var wage_x    "Wage bill as a percentage of Public Expenditure"


label var incgroup "Income Group"
gen source="I2D2"
replace source="LIS" if sample=="LIS"
order source , after(year)
order fullsample_obs, after (emp_obs)
order coefreg_f WPedu1 WPedu2 WPedu3 WPedu4 WPocup1 WPocup2 WPocup3 WPocup4 WPocup9 WPmale WPfemale, after(coefreg)
order diff_median_0_1 diff_median_0_2 diff_median_0_3 diff_median_0_4, after(diff_median_0)
order diff_median_1_1 diff_median_1_2 diff_median_1_3 diff_median_1_4, after(diff_median_1)
order psedu3, after(rur_1)
order compratio_0 compratio_1, after(diff_median_1_4)

save"${Out}\summaryI2D2liswithgdp.dta",replace


*****3.Identify outliers**********

****A. Employment STATS**********
*** Identify outlier in ps1*****
drop if sample=="bgd_2003_i2d2_lfs.dta"
drop if sample=="kaz_2013_i2d2_hbs_v01_m_v02_a.dta"
drop if sample=="tza_2007_i2d2_hbs.dta"
drop if sample=="eth_2000_i2d2_wms.dta"
drop if sample=="rom_2000_i2d2_ihs_v01_m_v01_a.dta"
drop if sample=="wbg_2000_i2d2_lfs_1.dta"
drop if sample=="alb_2004_i2d2_lsms.dta"
******Recode outlier in ps3*****
replace ps3=. if sample=="dji_2002_i2d2_edam.dta" | sample=="tza_2000_i2d2_ilfs.dta"



****B. Wage STATS**********
global wage  coefreg coefreg_f WPedu1 WPedu2 WPedu3 WPedu4 ///
	WPocup1 WPocup2 WPocup3 WPocup4  WPocup9 compratio_0 compratio_1  WPmale WPfemale ///
       rwoccup_0_1 rwoccup_0_2 rwoccup_0_3  rwoccup_1_1 rwoccup_1_2 rwoccup_1_3 
 global subwage WPedu1 WPedu2 WPedu3 WPedu4 ///
	WPocup1 WPocup2 WPocup3 WPocup4  WPocup9 
 global relativewage    rwoccup_0_1 rwoccup_0_2 rwoccup_0_3  rwoccup_1_1 rwoccup_1_2 rwoccup_1_3
 
 global WPgender WPmale WPfemale
 
*****recode******

replace coefreg_f=. if sample=="tza_2000_i2d2_ilfs.dta"

foreach var of global wage {
 replace `var'=. if sample=="khm_2012_i2d2_clfcls.dta"|sample=="mrt_2014_i2d2_epcv.dta"|sample=="bol_2000_i2d2_ech_v01_m_v03_a.dta"|sample=="lka_2008_i2d2_lfs.dta"
 replace `var'=.  if sample=="zwe_2007_i2d2_ices.dta"
 }
 
 
 ****WPEDU wpocup ***
 
 foreach var of global subwage {
 replace `var'=. if sample=="mex_2012_i2d2_enigh_v02_m_v03_a.dta"|sample=="chl_2009_i2d2_casen_v01_m_v03_a.dta"
 replace `var'=.  if ccode=="BOL"|ccode=="PAN"|ccode=="PRY"|ccode=="TZA"|ccode=="MDA"|ccode=="ARG"|ccode=="ECU"|ccode=="GTM"
  replace `var'=.  if ccode=="MEX"|ccode=="SLV"|ccode=="HND"|ccode=="RUS"
 }
 
 ****RELATIVE WAGE****
 
 foreach var of global relativewage {
 replace `var'=. if sample=="rus_2005_i2d2_rlms.dta"|sample=="mex_2012_i2d2_enigh_v02_m_v03_a.dta"|sample=="chl_2009_i2d2_casen_v01_m_v03_a.dta"|sample=="rus_2000_i2d2_rlms.dta"|sample=="nga_2009_i2d2_lss.dta"|sample=="nic_2001_i2d2_emnv_v01_m_v03_a.dta"|sample=="mng_2006_i2d2_lfs.dta"
 replace `var'=.  if ccode=="BOL"|ccode=="TZA"|ccode=="MDA"|ccode=="KHM"
 }
 
****WPGENDER****
foreach var of global WPgender {
 replace `var'=. if sample=="bol_2000_i2d2_ech_v01_m_v03_a.dta"|sample=="lka_2008_i2d2_lfs.dta"|sample=="jor_2002_i2d2_hies.dta"
 replace `var'=.  if ccode=="BGD"|ccode=="TZA"|ccode=="ZWE"|ccode=="MOZ"|ccode=="WBG"
 }
 

 
 
 ****C Gender pay gap********
 global wagegender  diff_mean_1 diff_median_1  diff_mean_0 diff_median_0  
		 

******recode******


foreach var of global wagegender {
 replace `var'=. if sample=="khm_2012_i2d2_clfcls.dta"|sample=="geo_2009_i2d2_his_v01_m_v01_a.dta"|sample=="zwe_2007_i2d2_ices.dta"|sample=="lka_2008_i2d2_lfs.dta"
 replace `var'=.  if sample=="mng_2006_i2d2_lfs.dta"
 replace `var'=. if ccode=="TZA"|ccode=="BGD"|ccode=="TCD"|ccode=="TGO"|ccode=="UGA"
 }
 

 
 
 
 ******D. BENEFITS********

   global benefits   cont_pub cont_prv  hins_pub hins_prv  ///
		   ssec_pub ssec_prv  union_pub union_prv  


foreach var of global benefits {
 
 replace `var'=. if sample=="pry_2010_i2d2_eph_v01_m_v04_a.dta"|sample=="tcd_2011_i2d2_ecosit.dta"|sample=="cri_2006_i2d2_ehpm_v01_m_v03_a.dta"
 replace `var'=. if ccode=="ARG"|ccode=="BOL"|ccode=="GTM"|ccode=="SLV"|ccode=="PRY"
 replace `var'=. if ccode=="PER"| ccode=="DOM"|ccode=="ECU"|ccode=="COL"
 }
 
 
 
 *****E. Demographic*******
 
 global  demographic female_0 female_1  psedu3  ed0_0 ed0_1 ed1_0 ed1_1 ed2_0 ed2_1 ed3_0 ed3_1 rur_0   rur_1   
 global  education ed0_0 ed0_1 ed1_0 ed1_1 ed2_0 ed2_1 ed3_0 ed3_1
			
 replace female_0=. if sample=="pry_2012_i2d2_eph.dta"|sample=="tcd_2011_i2d2_ecosit.dta"
 replace female_1=. if sample=="gtm_2003_i2d2_enei.dta"|sample=="cri_2000_i2d2_ehpm_v02_m_v03_a.dta"|sample=="khm_2006_i2d2_cses.dta"|sample=="tza_2009_i2d2_nps.dta"
 replace psedu3=. if sample=="lka_2009_i2d2_hies_v01_m_v02_a.dta"|sample=="mus_2001_i2d2_cmphs.dta"|ccode=="RUS"
 
 
 foreach var of global education {
 
 replace `var'=. if sample=="lka_2009_i2d2_hies_v01_m_v02_a.dta"|sample=="alb_2012_i2d2_lsms_v01_m_v05_a.dta"|   ///
 sample=="geo_2008_i2d2_his_v01_m_v02_a.dta"|sample=="geo_2009_i2d2_his_v01_m_v01_a.dta"|sample=="rom_2008_i2d2_hbs_v01_m_v03_a.dta"| ///
 sample=="pry_2001_i2d2_eih_v01_m_v03_a.dta" | sample=="pry_2002_i2d2_eph_v01_m_v03_a.dta"| ///
 sample=="arg_2000_i2d2_eph_v01_m_v02_a.dta" |sample=="arg_2001_i2d2_eph_v01_m_v02_a.dta"|  ///
 sample=="gtm_2000_i2d2_encovi_v01_m_v03_a.dta" | sample=="gtm_2003_i2d2_enei.dta"
 replace `var'=. if ccode=="TZA"|ccode=="BOL"|ccode=="MUS"

 }

 
 replace rur_0=. if sample=="cri_2000_i2d2_ehpm_v02_m_v03_a.dta"|sample=="gtm_2000_i2d2_encovi_v01_m_v03_a.dta" | sample=="gtm_2003_i2d2_enei.dta"|  ///
sample=="hnd_2014_i2d2_ephpm_v01_m_v01_a.dta"|sample=="mda_2009_i2d2_lfs.dta"|sample=="rom_2008_i2d2_hbs_v01_m_v03_a.dta"|  ///
sample=="alb_2005_i2d2_lsms_v01_m_v03_a.dta"| sample=="bol_2003_i2d2_ech.dta"|ccode=="TZA"|ccode=="VEN"
 
 
 replace rur_1=. if sample=="bol_2003_i2d2_ech.dta"|sample=="gtm_2000_i2d2_encovi_v01_m_v03_a.dta" | sample=="gtm_2003_i2d2_enei.dta"|  ///
sample=="rom_2008_i2d2_hbs_v01_m_v03_a.dta"| sample=="khm_2003_i2d2_cses.dta"|sample=="cri_2000_i2d2_ehpm_v02_m_v03_a.dta"| ///
ccode=="TZA"|ccode=="VEN"|ccode=="KAZ"|ccode=="MDV"



*********F Gender Ratio******
global genderratio occup_1_pu occup_2_pu occup_3_pu occup_4_pu occup_9_pu ///
         occup_1_pr occup_2_pr occup_3_pr occup_4_pr occup_9_pr
		 
global quntile quintile_1_pu quintile_2_pu quintile_3_pu quintile_4_pu quintile_5_pu ///
 quintile_1_pr quintile_2_pr quintile_3_pr quintile_4_pr quintile_5_pr
 		 
		 
foreach var of global genderratio {
 
 replace `var'=. if ccode=="ARG"|ccode=="BOL"|ccode=="CHL"|ccode=="ECU"|ccode=="HND"|  ///
 ccode=="JOR"|ccode=="MEX"|ccode=="PER"|ccode=="PRY"|ccode=="SLV"|ccode=="CRI"|ccode=="BRA"|  ///
 ccode=="BGD"|ccode=="GTM"|ccode=="KHM"|ccode=="TZA"|ccode=="MDA"|ccode=="PAN"|ccode=="DOM"|  ///
 sample=="lka_2009_i2d2_hies_v01_m_v02_a.dta"|sample=="rom_2008_i2d2_hbs_v01_m_v03_a.dta"
 }		 
		 
foreach var of global quntile {
 
 replace `var'=. if ccode=="GTM"|ccode=="DOM"|ccode=="PRY"|ccode=="ARG"|ccode=="BOL"|ccode=="SLV"|  ///
 sample=="lka_2008_i2d2_lfs.dta"|sample=="mda_2006_i2d2_lfs.dta"|sample=="tza_2009_i2d2_nps.dta"|sample=="geo_2009_i2d2_his_v01_m_v01_a.dta"| ///
 sample=="mda_2006_i2d2_lfs.dta"|sample=="khm_2006_i2d2_cses.dta"
 }
 
 
 *********4. Cross Country Comparation*******

 foreach var of global wagegender {
 
 replace `var'=. if ccode=="NER"|ccode=="PHL"|ccode=="NGA"|ccode=="MWI"|ccode=="DOM"|ccode=="PNG"|ccode=="BFA"
 }		
 
 
drop diff_median_0_1 diff_median_0_2 diff_median_0_3 diff_median_0_4 diff_median_1_1 diff_median_1_2 diff_median_1_3 diff_median_1_4
 
 
****Save the final dataset****

save"${Out}\WWBI.dta",replace

drop filter lngdppc seq max
export excel using "C:\Users\WB538855\Desktop\WWBI.xls", firstrow(varlabels) replace

