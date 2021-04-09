********************************************************************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 2.0, 2000-2018
*1e_industry
*Called by 0_master.do
*Created by: Turkan Mukhtarova
*Last Edit by: Faisal Baig
*First version: November 2020
*Latest version: February 2021
********************************************************************************

* Industry Dummy Variables
********************************************************************************

* Creates dummies for individuals employed in the public administration, education and health industries that can be used to develop indstrial decompositions of main WWBI variables

*Using Industry classification based on ISIC 2.0, 3.1, and 4.0: 
	*ISIC 2.0: https://unstats.un.org/unsd/classifications/Econ/Download/In%20Text/ISIC_Rev_2_English.pdf
	*ISIC 3.1: https://unstats.un.org/unsd/publication/seriesm/seriesm_4rev3_1e.pdf
	*ISIC 4.0: https://unstats.un.org/unsd/publication/seriesm/seriesm_4rev4e.pdf

set more 1


********************************************************************************
*Brazil (BRA)
********************************************************************************
use "${Data}LatestI2D2_BRA.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Brazil use ISIC Rev 3.1 classification system


*------------------------------ Health -----------------------------------------
gen hlt=.

foreach s of numlist 2/13 {
	replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
	replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

*------------------------------ Education --------------------------------------
gen edu=.

foreach s of numlist 2/13 {
	replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
	replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
}

*------------------------------ Public Administration --------------------------
gen pub_adm=.

foreach s of numlist 2/13 {
	replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
	replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
}

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_BRA.dta", replace



********************************************************************************
* East Asia and the Pacific (EAP)
********************************************************************************


use "${Data}LatestI2D2_EAP.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within EAP use ISIC Rev 2.0, ISIC Rev. 3.1 and ISIC Rev. 4.0 classification systems


*------------------------------ Health -----------------------------------------
gen hlt=.

// Sample 20, 32, 33, 35, 36, 85, 86, 113, 115, 119,and 136/138 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 20 32 33 35 36 85 86 113 115 119 136/138 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="86" & sample1==`s' & industry_orig!=. 
		replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & sample1==`s' & industry_orig!=.
		replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=. 
	}

// Sample 110 and 121-135 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 110 121/135 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s'& industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 19 use ISIC Rev. 3.1 Sections as opposed to Divisions

		replace hlt = 1 if substr(string(industry_orig),1,2)=="14" & sample1==19 & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==19 & industry_orig!=.

		
*------------------------------ Education --------------------------------------
gen edu=.

// Sample 20, 32, 33, 35, 36, 85, 86, 113, 115, 119,and 136/138 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 20 32 33 35 36 85 86 113 115 119 136/138 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=. 
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=. 
	}
	
// Sample 110 and 121-135 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 110 121/135 {
		replace edu =1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=. 
		replace edu =0 if edu==. & sample1==`s' & industry_orig!=. 
	}

// Sample 19 use ISIC Rev. 3.1 Sections as opposed to Divisions

		replace edu = 1 if substr(string(industry_orig),1,2)=="13" & sample1==19 & industry_orig!=.
		replace edu = 0 if edu==. & sample1==19 & industry_orig!=.
		
		
*------------------------------ Public Administration --------------------------
gen pub_adm=.

// Sample 20 32 33 35 36 85 86 113 115 119 136/138 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 20 32 33 35 36 85 86 113 115 119 136/138 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & sample1==`s' & industry_orig!=. 
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=. 
	}

// Sample 110 121/135 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 110 121/135 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=. 
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=. 
	}

// Sample 120 use ISIC Rev. 2.0 Divisions which does not allow for distinguishing health and education workers

		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="91" & sample1==120 & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==120 & industry_orig!=.

// Sample 19 use ISIC Rev. 3.1 Sections as opposed to Divisions

		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="12" & sample1==19 & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==19 & industry_orig!=.

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_EAP.dta", replace



********************************************************************************
* Europe and Central Asia (ECA)
********************************************************************************


use "${Data}LatestI2D2_ECA.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within ECA use ISIC Rev 2.0, ISIC Rev. 3.1 and ISIC Rev. 4.0 classification systems


*------------------------------ Health -----------------------------------------
gen hlt=.

// Sample 19 167 168 192 305 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 19 167 168 192 305 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="86" & sample1==`s' & industry_orig!=. 
		replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & sample1==`s' & industry_orig!=.
		replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
}

// Sample 1 4 35 78 80/82 90/91 153 156 158 160 162 164 166 181/182 188 197 199 200 270/272 279 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 1 4 35 78 80/82 90/91 153 156 158 160 162 164 166 181/182 188 197 199 200 270/272 279 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
}
	
// Sample 317 318 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 317 318 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="17" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
}

// Sample 32 36 76 241 246 248/250 280 285 306 308/311 313/316 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 32 36 76 241 246 248/250 280 285 306 308/311 313/316 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="14" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
}

*------------------------------ Education --------------------------------------
gen edu=.

// Sample 19 167 168 192 305 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 19 167 168 192 305 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 1 4 35 78 80/82 90/91 153 156 158 160 162 164 166 181/182 188 197 199 200 270/272 279 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 1 4 35 78 80/82 90/91 153 156 158 160 162 164 166 181/182 188 197 199 200 270/272 279 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 317 318 use ISIC Rev. 4.0 Sections as opposed to Divisions
	foreach s of numlist 317 318 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="16" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 32 36 76 241 246 248/250 280 285 306 308/311 313/316 use ISIC Rev. 3.1 Sections as opposed to Divisions
	foreach s of numlist 32 36 76 241 246 248/250 280 285 306 308/311 313/316 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="13" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
	
*------------------------------ Public Administration --------------------------
gen pub_adm=.

// Sample 19 167 168 192 305 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 19 167 168 192 239 305 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 1 4 35 78 80/82 90/91 153 156 158 160 162 164 166 181/182 188 197 199 200 270/272 279 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 1 4 35 78 80/82 90/91 153 156 158 160 162 164 166 181/182 188 197 199 200 270/272 279 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 317 318 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 317 318 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="15" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 32 36 76 241 246 248/250 280 285 306 308/311 313/316 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 32 36 76 241 246 248/250 280 285 306 308/311 313/316 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="12" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_ECA.dta", replace



********************************************************************************
* European Economic Area (EU-SILC)
********************************************************************************


use "${Data}LatestI2D2_EUSILC.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within EU-SILC database use NACE REV. 2 classification systems


*------------------------------ Health -----------------------------------------
	gen hlt=1 if industry_raw == 11
		replace hlt = 0 if hlt != 1 & industry_raw != . 

		
*------------------------------ Education --------------------------------------

	gen edu=1 if industry_raw == 10
		replace edu = 0 if edu != 1 & industry_raw != . 

		
*------------------------------ Public Administration --------------------------
	gen pub_adm=1 if industry_raw == 9
		replace pub_adm = 0 if pub_adm != 1 & industry_raw != . 

		
//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_EUSILC.dta", replace



********************************************************************************
* Latin America and the Caribbean Equity Lab - Global Labor Database (GLD)
********************************************************************************


use "${Data}LatestI2D2_GLD.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within the GLD database use multiple classification systems which have been harmonized 


*------------------------------ Health -----------------------------------------
		
*------------------------------ Education --------------------------------------
		
*------------------------------ Public Administration --------------------------

	drop pub_adm
	rename b_pub_adm pub_adm

	
//keep ccode year sample sample1 idh idp hlt edu pub_adm


save "${Temp}Industry_GLD.dta", replace



*************************************************************
* High Income Countries - NON OECD (HI-NON_OECD)
*************************************************************


use "${Data}LatestI2D2_HI-NON_OECD.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within HI-NON_OECD use ISIC Rev ISIC Rev. 3.1 and ISIC Rev. 4.0 classification systems

*------------------------------ Health -----------------------------------------
gen hlt=.

// Sample 1284/1285 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 1284/1285 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="86" & sample1==`s' & industry_orig!=. 
		replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & sample1==`s' & industry_orig!=.
		replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 1272/1283 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 1272/1283 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 1077/1087 use ISIC Rev. 3.1 Sections as opposed to Divisions
	
	foreach s of numlist 1077/1087 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="14" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}	
	
*------------------------------ Education --------------------------------------
gen edu=.

// Sample 1284/1285 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 1284/1285 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 1272/1283 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 1272/1283 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 1077/1087 use ISIC Rev. 3.1 Sections as opposed to Divisions
	
	foreach s of numlist 1077/1087 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="13" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}	

*------------------------------ Public Administration --------------------------
gen pub_adm=.

// Sample 1284/1285 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 1284/1285 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 1272/1283 use ISIC Rev. 3.1 Divisions
	
	foreach s of numlist 1272/1283 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 1077/1087 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 1077/1087 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="12" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_HI-NON_OECD.dta", replace



********************************************************************************
* High Income Countries - OECD (HI-OECD)
********************************************************************************


use "${Data}LatestI2D2_HI-OECD.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within HI-OECD use ISIC Rev ISIC Rev. 2.0 and ISIC Rev. 3.1 classification systems

*------------------------------ Health -----------------------------------------
gen hlt=.


// Sample 223/224 999 1001/1002 1140/1142 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 223/224 999 1001/1002 1140/1142 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 219/222 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 219/222 {
		replace hlt = 1 if substr(string(industry_orig),1,3)=="933" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

*------------------------------ Education --------------------------------------
gen edu=.


// Sample 223/224 999 1001/1002 1140/1142 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 223/224 999 1001/1002 1140/1142 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 219/222 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 219/222 {
		replace edu = 1 if substr(string(industry_orig),1,3)=="931" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

*------------------------------ Public Administration --------------------------
gen pub_adm=.


// Sample 223/224 999 1001/1002 1140/1142 use ISIC Rev. 3.1 Divisions
	
	foreach s of numlist 223/224 999 1001/1002 1140/1142 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 219/222 use ISIC Rev. 2.0 Divisions
	
	foreach s of numlist 219/222 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="91" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}


keep sample sample1 ccode year wgt urb gender age educy edulevel1 edulevel2 edulevel3 lstatus empstat ocusec occup whours wage unitwage contract healthins socialsec union industry_orig filter pemp wpm_lcu wpw_lcu wph_lcu ps1 ps2 fe ps3 hlt edu pub_adm

save "${Temp}Industry_HI-OECD.dta", replace



********************************************************************************
* INDONESIA SEKERNAS 2018 (IDN)
********************************************************************************


use "${Data}LatestI2D2_IDN.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// IDN use ISIC Rev. 4.0 classification systems


*------------------------------ Health -----------------------------------------

gen hlt = 1 if substr(string(industry_orig),1,2)=="86" & industry_orig!=. 
	replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & industry_orig!=.
	replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & industry_orig!=.
	replace hlt = 0 if hlt==. & industry_orig!=.
		
*------------------------------ Education --------------------------------------

gen edu = 1 if substr(string(industry_orig),1,2)=="85" & industry_orig!=.
	replace edu = 0 if edu==. & industry_orig!=.

		
*------------------------------ Public Administration --------------------------

gen pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & industry_orig!=.
	replace pub_adm = 0 if pub_adm==. & industry_orig!=.

		
keep sample sample1 ccode year wgt urb gender age educy edulevel1 edulevel2 edulevel3 lstatus empstat ocusec occup whours wage unitwage contract healthins socialsec union industry_orig filter pemp wpm_lcu wpw_lcu wph_lcu ps1 ps2 fe ps3 hlt edu pub_adm

save "${Temp}Industry_IDN.dta", replace



********************************************************************************
* Latin America and the Caribbean (LAC)
********************************************************************************


use "${Data}LatestI2D2_LAC.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within LAC use ISIC Rev 2.0, ISIC Rev. 3.1, ISIC Rev. 4.0 and SCIAN Rev. 2012 classification systems


*------------------------------ Health -----------------------------------------
gen hlt=.

// Sample 38/42 116 149 177/178 266/268 285/288 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 38/42 116 149 177/178 266/268 285/288 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="86" & sample1==`s' & industry_orig!=. 
		replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & sample1==`s' & industry_orig!=.
		replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 15/36 55/56 81/104 106/115 119/133 152/154 157/176 218/233 236/248 257/261 263/265 271/284 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 15/36 55/56 81/104 106/115 119/133 152/154 157/176 218/233 236/248 257/261 263/265 271/284 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 117 217 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 117 217 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="17" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 134/148 151 156 179 192 198 210 215 use ISIC Rev. 3.1 Sections as opposed to Divisions
	
	foreach s of numlist 134/148 151 156 179 192 198 210 215 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="14" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 76/80 105 182/183 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 76/80 105 182/183 {
		replace hlt = 1 if substr(string(industry_orig),1,3)=="933" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 186 193 194 use SCIAN Rev 2012
	
	foreach s of numlist 186 193 194 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="62" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
		}

*------------------------------ Education --------------------------------------
gen edu=.

// Sample 38/42 116 149 177/178 266/268 285/288 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 38/42 116 149 177/178 266/268 285/288 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 15/36 55/56 81/104 106/115 119/133 152/154 157/176 218/233 236/248 257/261 263/265 271/284 use ISIC Rev. 3.1 Divisions
	
	foreach s of numlist 15/36 55/56 81/104 106/115 119/133 152/154 157/176 218/233 236/248 257/261 263/265 271/284 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 117 217 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 117 217 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="16" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 134/148 151 156 179 192 198 210 215 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 134/148 151 156 179 192 198 210 215 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="13" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 76/80 105 182/183 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 76/80 105 182/183 {
		replace edu = 1 if substr(string(industry_orig),1,3)=="931" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 186 193 194 use SCIAN Rev 2012

	foreach s of numlist 186 193 194 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="61" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
	
*------------------------------ Public Administration --------------------------
gen pub_adm=.

// Sample 38/42 116 149 177/178 266/268 285/288 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 38/42 116 149 177/178 266/268 285/288 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 15/36 55/56 81/104 106/115 119/133 152/154 157/176 218/233 236/248 257/261 263/265 271/284 use ISIC Rev. 3.1 Divisions
	
	foreach s of numlist 15/36 55/56 81/104 106/115 119/133 152/154 157/176 218/233 236/248 257/261 263/265 271/284 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 117 217 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 117 217 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="15" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 134/148 151 156 179 192 198 210 215 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 134/148 151 156 179 192 198 210 215 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="12" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 76/80 105 182/183 use ISIC Rev. 2.0 Divisions
	
	foreach s of numlist 76/80 105 182/183 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="91" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 186 193 194 use SCIAN Rev 2012

	foreach s of numlist 186 193 194 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="93" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_LAC.dta", replace



********************************************************************************
* Middle East and North Africa (MNA)
********************************************************************************


use "${Data}LatestI2D2_MNA.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within MNA use ISIC Rev 2.0, ISIC Rev. 3.1 and ISIC Rev. 4.0 classification systems


*------------------------------ Health -----------------------------------------
gen hlt=.

// Sample 5 28/34 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 5 28/34 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="86" & sample1==`s' & industry_orig!=. 
		replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & sample1==`s' & industry_orig!=.
		replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=. 
	}

// Sample 8 19/27 38/42 47 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 8 19/27 38/42 47 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}

// Sample 37 use ISIC Rev. 4.0 Sections as opposed to Divisions
		
		replace hlt = 1 if substr(string(industry_orig),1,2)=="17" & sample1==37 & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==37 & industry_orig!=.

// Sample 9 use ISIC Rev. 3.1 Sections as opposed to Divisions

		replace hlt = 1 if substr(string(industry_orig),1,2)=="14" & sample1==9 & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==9 & industry_orig!=.

		
*------------------------------ Education --------------------------------------
gen edu=.

// Sample 5 28/34 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 5 28/34 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 8 19/27 38/42 47 use ISIC Rev. 3.1 Divisions
	
	foreach s of numlist 8 19/27 38/42 47 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 37 use ISIC Rev. 4.0 Sections as opposed to Divisions
	
		replace edu = 1 if substr(string(industry_orig),1,2)=="16" & sample1==37 & industry_orig!=.
		replace edu = 0 if edu==. & sample1==37 & industry_orig!=.
		
// Sample 9 use ISIC Rev. 3.1 Sections as opposed to Divisions
		
		replace edu = 1 if substr(string(industry_orig),1,2)=="13" & sample1==9 & industry_orig!=.
		replace edu = 0 if edu==. & sample1==9 & industry_orig!=.
	
	
*------------------------------ Public Administration --------------------------
gen pub_adm=.

// Sample 5 28/34 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 5 28/34 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 8 19/27 38/42 47 use ISIC Rev. 3.1 Divisions
	
	foreach s of numlist 8 19/27 38/42 47 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 37 use ISIC Rev. 4.0 Sections as opposed to Divisions
	
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="15" & sample1==37 & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==37 & industry_orig!=.

// Sample 9 use ISIC Rev. 3.1 Sections as opposed to Divisions
	
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="12" & sample1==9 & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==9 & industry_orig!=.

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_MNA.dta", replace



********************************************************************************
* North America (NA)
********************************************************************************


use "${Data}LatestI2D2_NA.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen


*No observations remain after merging. SKIP




********************************************************************************
* I2D2 Revision 6 Countries (REV6)
********************************************************************************
use "${Data}LatestI2D2_REV6.dta", clear

	cap drop _merge
//	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries in the I2D2 Rev. 6 datset use ISIC Rev 3.1 and ISIC Rev. 2.0 classification system


*------------------------------ Health -----------------------------------------
gen hlt=.

foreach s of numlist 4/11 {
	replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
	replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 1 34 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 1 34 {
		replace hlt = 1 if substr(string(industry_orig),1,3)=="933" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}
*------------------------------ Education --------------------------------------
gen edu=.

foreach s of numlist 4/11 {
	replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
	replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
}

// Sample 1 34 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 1 34 {
		replace edu = 1 if substr(string(industry_orig),1,3)=="931" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
*------------------------------ Public Administration --------------------------
gen pub_adm=.

foreach s of numlist 4/11 {
	replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
	replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
}

// Sample 1 34 use ISIC Rev. 2.0 Divisions which does not allow for distinguishing health and education workers

	foreach s of numlist 1 34 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="91" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_REV6.dta", replace



********************************************************************************
* South Asia (SAR)
********************************************************************************


use "${Data}LatestI2D2_SAR.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within SAR use ISIC Rev 2.0, ISIC Rev. 3.1 and ISIC Rev. 4.0 classification systems


*------------------------------ Health -----------------------------------------
gen hlt=.

// Sample 31 46/49 81/84 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 31 46/49 81/84 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="86" & sample1==`s' & industry_orig!=. 
		replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & sample1==`s' & industry_orig!=.
		replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=. 
	}
	 
// Sample 9 11 20 35/45 50 53 73 77 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 9 11 20 35/45 50 53 73 77 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=. 
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=. 
	}

*------------------------------ Education --------------------------------------
gen edu=.

// Sample 31 46/49 81/84 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 31 46/49 81/84 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 9 11 20 35/45 50 53 73 77 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 9 11 20 35/45 50 53 73 77 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}

*------------------------------ Public Administration --------------------------
gen pub_adm=.

// Sample 31 46/49 81/84 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 31 46/49 75/84 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 9 11 20 35/45 50 53 73 77 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 9 11 20 35/45 50 53 73 77 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 59 62 65 75 use ISIC Rev. 2.0 Divisions which does not allow for distinguishing health and education workers

	foreach s of numlist 59 62 65 75 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="91" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_SAR.dta", replace



********************************************************************************
* Sub-Saharan Africa (SSA)
********************************************************************************


use "${Data}LatestI2D2_SSA.dta", clear

	cap drop _merge
	merge m:1 sample ccode year using "${Output}WWBI Version 2.0 Index.dta", keep(3) nogen

// Countries within SSA use ISIC Rev 2.0, ISIC Rev. 3.1 and ISIC Rev. 4.0 classification systems


*------------------------------ Health -----------------------------------------
gen hlt=.

// Sample 16/18 23 29 56 80/84 104 122 138/139 151 175 189 197 222/225 228 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 16/18 23 29 56 80/84 104 122 138/139 151 175 189 197 222/225 228 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="86" & sample1==`s' & industry_orig!=. 
		replace hlt = 1 if substr(string(industry_orig),1,2)=="87" & sample1==`s' & industry_orig!=.
		replace hlt = 1 if substr(string(industry_orig),1,2)=="88" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=. 
	}

// Sample 12/13 21/22 28 33 36 55 57 60 63/78 97 114 123 127/129 132/137 170 188 193 219/220 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 12/13 21/22 28 33 36 55 57 60 63/78 97 114 123 127/129 132/137 170 188 193 219/220 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 9 165 187 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 9 165 187 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="17" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 4 5 30 58 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 4 5 30 58 {
		replace hlt = 1 if substr(string(industry_orig),1,2)=="14" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 141 172 215 218 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 141 172 215 218 {
		replace hlt = 1 if substr(string(industry_orig),1,3)=="933" & sample1==`s' & industry_orig!=.
		replace hlt = 0 if hlt==. & sample1==`s' & industry_orig!=.
	}
*------------------------------ Education --------------------------------------
gen edu=.

// Sample 16/18 23 29 56 80/84 104 122 138/139 151 175 189 197 222/225 228 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 16/18 23 29 56 80/84 104 122 138/139 151 175 189 197 222/225 228 {
		replace edu=1 if substr(string(industry_orig),1,2)=="85" & sample1==`s' & industry_orig!=.
		replace edu=0 if edu==. & sample1==`s' & industry_orig!=.
	}

// Sample 12/13 21/22 28 33 36 55 57 60 63/78 97 114 123 127/129 132/137 170 188 193 219/220 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 12/13 21/22 28 33 36 55 57 60 63/78 97 114 123 127/129 132/137 170 188 193 219/220 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="80" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 9 165 187 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 9 165 187 {

		replace edu = 1 if substr(string(industry_orig),1,2)=="16" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 4 5 30 58 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 4 5 30 58 {
		replace edu = 1 if substr(string(industry_orig),1,2)=="13" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 141 172 215 218 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 141 172 215 218 {
		replace edu = 1 if substr(string(industry_orig),1,3)=="931" & sample1==`s' & industry_orig!=.
		replace edu = 0 if edu==. & sample1==`s' & industry_orig!=.
	}
	
*------------------------------ Public Administration --------------------------
gen pub_adm=.

// Sample 16/18 23 29 56 80/84 104 122 138/139 151 175 189 197 222/225 228 use ISIC Rev. 4.0 Divisions

	foreach s of numlist 16/18 23 29 56 80/84 104 122 138/139 151 175 189 197 222/225 228 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="84" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}

// Sample 12/13 21/22 28 33 36 55 57 60 63/78 97 114 123 127/129 132/137 170 188 193 219/220 use ISIC Rev. 3.1 Divisions

	foreach s of numlist 12/13 21/22 28 33 36 55 57 60 63/78 97 114 123 127/129 132/137 170 188 193 219/220 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="75" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 9 165 187 use ISIC Rev. 4.0 Sections as opposed to Divisions

	foreach s of numlist 9 165 187 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="15" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 4 5 30 58 use ISIC Rev. 3.1 Sections as opposed to Divisions

	foreach s of numlist 4 5 30 58 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="12" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
// Sample 141 144 172 215 218 use ISIC Rev. 2.0 Divisions

	foreach s of numlist 141 144 172 215 218 {
		replace pub_adm = 1 if substr(string(industry_orig),1,2)=="91" & sample1==`s' & industry_orig!=.
		replace pub_adm = 0 if pub_adm==. & sample1==`s' & industry_orig!=.
	}
	
//keep ccode year sample sample1 idh idp hlt edu pub_adm

save "${Temp}Industry_SSA.dta", replace

