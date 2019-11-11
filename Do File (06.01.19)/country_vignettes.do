
** DO FILE TO DO GRAPHS FOR STANDARD COUNTRY VIGNETTES
	* AUTHOR: Vanessa Cheng (vcheng.m@gmail.com)


*** Input Data
	* Wage Bill: wagebill_imf.dta
	* Public Employment & Public-Private comparisons (I2D2): i2d2_long_income_$year.dta
	* Relative Wages: icp2011_final.dta


*********************** PART 0:  Set standard settings *************************
	
	
	* Clear all stored values in memory from previous projects
	clear all
	
	* Set advanced memory limits 												
	set min_memory	0
	set max_memory	.
	set segmentsize	32m
	set niceness	5

	* Set default options
	set more 		off, perm
	pause 			on
	set varabbrev 	off
	
	
********************** PART 1:  Define globals and programs ********************								


	*  User globals
	* -------------
		
	* User Number:
		* Vanessa 			1
		* Other				2
			
		global user_number  1 	// indicate the person that will be running the dofile.

	* Dropbox/Box globals
	* --------------------
		
	if $user_number == 1 {
		global route "C:\Users\wb495160\Box Sync\Strengthening Research on the Civil Service\Analysis\WWBI" // here, write the route of the folder where you will store all files
	}		
			
	if $user_number == 2 {
		global route ""
	}
	
		
	* Subfolder globals
	* -----------------
	
	global data			"$route/data"
	global do_files		"$route/dofiles"
	global outputs		"C:\Users\wb495160\Box Sync\Strengthening Research on the Civil Service\Analysis\Country Profiles\Argentina"	// change route to specific country
	
	* Country globals
	* --------------------
	
	global iso3 ARG
	global country "Argentina"
	global year 2015
	
	
***************************** PART 2: Graphs ***********************************

* USING THE WAGE BILL DATASET (wagebill_imf.dta)

** Wage as a % of GDP

use "$data/wagebill_imf.dta", clear

*** For all
twoway 	(scatter wage_gdp lngdppc if year==$year & region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_gdp lngdppc if year==$year & region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter wage_gdp lngdppc if year==$year & region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="Middle East & North Africa" & iso3!="LBY" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit wage_gdp lngdppc if year==$year), ///
		ytitle("Wage Bill as % of GDP") ///
		xtitle("Ln of GDPPC, $year") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\wage_gdp_all.png", as(png) replace
		
		
*** For countries
twoway 	(scatter wage_gdp lngdppc if year==$year & iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_gdp lngdppc if year==$year & region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_gdp lngdppc if year==$year & region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter wage_gdp lngdppc if year==$year & region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="Middle East & North Africa" & iso3!="LBY" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit wage_gdp lngdppc if year==$year), ///
		ytitle("Wage Bill as % of GDP") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\wage_gdp_$country.png", width(2000) height(1500) as(png) replace
		
** Wage as a % of Expenditures

*** For all
twoway 	(scatter wage_x lngdppc if year==$year & region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_x lngdppc if year==$year & region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter wage_x lngdppc if year==$year & region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="Middle East & North Africa" & iso3!="LBY" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit wage_x lngdppc if year==$year), ///
		ytitle("Wage Bill as % of Expenditures") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\wage_x_all.png", as(png) replace


*** For a country
twoway 	(scatter wage_x lngdppc if year==$year & iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_x lngdppc if year==$year & region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_x lngdppc if year==$year & region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter wage_x lngdppc if year==$year & region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="Middle East & North Africa" & iso3!="LBY" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter wage_x lngdppc if year==$year & region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit wage_x lngdppc if year==$year), ///
		ytitle("Wage Bill as % of Expenditures") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\wage_x_$country.png", width(2000) height(1500) as(png) replace


* USING THE i2d2 DATASET (i2d2_long_income_may8.dta)

clear 
use "$data/i2d2_long_inc$year.dta", clear

** PUBLIC EMPLOYMENT: Wage Employment

*** All
twoway 	(scatter share_public_paid1 lngdppc2014 if region=="East Asia & Pacific" ,  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_public_paid1 lngdppc2014 if region=="Europe & Central Asia" ,  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_public_paid1 lngdppc2014 if region=="Latin America & Caribbean" ,  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc2014 if region=="Middle East & North Africa" & iso3!="LBY" ,  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc2014 if region=="North America" ,  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc2014 if region=="South Asia" ,  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc2014 if region=="Sub-Saharan Africa" ,  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_paid1 lngdppc2014), ///
		ytitle("Public Employment as" "% of Paid Employment") ///
		xtitle("Ln of GDPPC, 2014") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\publicemploymentpaid_all.png", as(png) replace
		
*** Country
twoway 	(scatter share_public_paid1 lngdppc$year if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_public_paid1 lngdppc$year if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_public_paid1 lngdppc$year if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="Middle East & North Africa" & iso3!="LBY" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_paid1 lngdppc$year), ///
		ytitle("Public Employment as" "% of Wage Employment") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\wageemploy_$country.png",width(2000) height(1500)  as(png) replace

** PUBLIC EMPLOYMENT: Public Employment as % TOTAL Employment 

*** All
twoway 	(scatter share_public_total lngdppc2014 if region=="East Asia & Pacific" ,  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_public_total lngdppc2014 if region=="Europe & Central Asia" ,  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_public_total lngdppc2014 if region=="Latin America & Caribbean" ,  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc2014 if region=="Middle East & North Africa" & iso3!="LBY" ,  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc2014 if region=="North America" ,  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc2014 if region=="South Asia" ,  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc2014 if region=="Sub-Saharan Africa" ,  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_total lngdppc2014), ///
		ytitle("Public Employment as" "% of Total Employment") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\publicemploymenttotal_all.png", as(png) replace
		
*** Country
twoway 	(scatter share_public_total lngdppc$year if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_public_total lngdppc$year if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_public_total lngdppc$year if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="Middle East & North Africa" & iso3!="LBY" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_total lngdppc$year), ///
		ytitle("Public Employment as" "% of Total Employment") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\publicemploymenttotal_$country.png", width(2000) height(1500)  as(png) replace


** PUBLIC WAGE PREMIUM:

*** All
twoway 	(scatter coef_premium_ppp_w lngdppc2015 if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter coef_premium_ppp_w lngdppc2015 if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter coef_premium_ppp_w lngdppc2015 if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc2015 if region=="Middle East & North Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc2015 if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc2015 if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc2015 if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_total lngdppc2015, lp(dash)), ///
		yline(0, lp(dash_dot)) ytitle("Public Sector Wage Premium") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") lab(8 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\premium_all.png", as(png) replace
		
*** Country	
twoway 	(scatter coef_premium_ppp_w lngdppc$year if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter coef_premium_ppp_w lngdppc$year if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter coef_premium_ppp_w lngdppc$year if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Middle East & North Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit coef_premium_ppp_w lngdppc$year, lp(dash)), ///
		yline(0, lp(dash_dot)) ytitle("Public Sector Wage Premium") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\premium_$country.png", width(2000) height(1500)  as(png) replace


** PUBLIC - PRIVATE BENEFITS: Proportion of Employees with Health Insurance or Social Security in Private vs Public Sector, by Country and Region

*** Country
twoway 	(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Middle East & North Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(function y=x), ///
		ytitle("% of PRIVATE employees with health insurance" "or social security") ///
		xtitle("% of PUBLIC employees with health insurance or social security") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\benefits_$country.png", width(2000) height(1500) as(png) replace

** PUBLIC - PRIVATE DESCRIPTIVES: Gender

*** All
twoway 	(scatter share_priv_paid_fem share_public_paid_fem  if region=="East Asia & Pacific" ,  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Europe & Central Asia" ,  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Latin America & Caribbean" ,  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Middle East & North Africa" ,  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="North America" ,  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="South Asia" ,  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Sub-Saharan Africa" ,  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(function y=x, range(0 0.8)), ///
		ytitle("% of FEMALE employees in the" "PRIVATE sector") ///
		xtitle("% of FEMALE employees in the PUBLIC sector") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") lab(8 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\gender_all.png", as(png) replace
		
*** Countries
twoway 	(scatter share_priv_paid_fem share_public_paid_fem  if iso3=="$iso3" ,  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Middle East & North Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(function y=x, range(0 0.8)), ///
		ytitle("% of FEMALE employees in the" "PRIVATE sector") ///
		xtitle("% of FEMALE employees in the PUBLIC sector") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\gender_$country.png", width(2000) height(1500) as(png) replace
		

** PUBLIC - PRIVATE DESCRIPTIVES: Mean Age

*** All
twoway 	(scatter mean_age_priv_paid mean_age_public_paid   if region=="East Asia & Pacific" ,  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Europe & Central Asia" ,  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Latin America & Caribbean" ,  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Middle East & North Africa" ,  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="North America" ,  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="South Asia" ,  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Sub-Saharan Africa" ,  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(function y=x, range(30 50)), ///
		ytitle("Mean age of PRIVATE sector paid employees") ///
		xtitle("Mean age of PUBLIC sector paid employees") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") lab(8 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\meanage_all.png", as(png) replace

*** Countries
twoway 	(scatter mean_age_priv_paid mean_age_public_paid   if iso3=="$iso3" ,  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Middle East & North Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(function y=x, range(30 50)), ///
		ytitle("Mean age of PRIVATE sector paid employees") ///
		xtitle("Mean age of PUBLIC sector paid employees") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\meanage_$country.png", width(2000) height(1500) as(png) replace
		

** PUBLIC - PRIVATE DESCRIPTIVES: Tertiary Education

*** Countries
twoway 	(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc   if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc  if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc   if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc   if region=="Middle East & North Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc   if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc   if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc   if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(function y=x), ///
		ytitle("% of PRIVATE paid employees with" "TERTIARY education") ///
		xtitle("% of PUBLIC paid employees with TERTIARY education") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\tertiary_$country.png", width(2000) height(1500) as(png) replace
		

		
* USING THE ICP2011 DATASET (icp2011_final.dta)

clear 
use "$data/icp2011_final.dta", clear
br if iso3=="$iso3"

** Relative Wages

*** Doctor to a Secretary

twoway 	(scatter rwdoctor_secre lngdppc2011 if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_secre lngdppc2011 if region=="EAP" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_secre lngdppc2011 if region=="ECA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwdoctor_secre lngdppc2011 if region=="LAC" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="MNA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="NAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="SAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="AFR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwdoctor_secre lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a Doctor" "to a Secretary") ///
		xtitle("Log of GDP per capita, 2011") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\doctorsecre_$country.png", width(2000) height(1500) as(png) replace
		
*** Senior Gov Official to a Secretary

twoway 	(scatter rwsenior_secre lngdppc2011 if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_secre lngdppc2011 if region=="EAP" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_secre lngdppc2011 if region=="ECA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwsenior_secre lngdppc2011 if region=="LAC" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="MNA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="NAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="SAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="AFR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwsenior_secre lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a" "Senior Gov Official" "to a Secretary") ///
		xtitle("Log of GDP per capita, 2011") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\seniorsecre_$country..png", width(2000) height(1500) as(png) replace

*** Doctor to a Payroll Clerk

twoway 	(scatter rwdoctor_clerk lngdppc2011 if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_clerk lngdppc2011 if region=="EAP" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_clerk lngdppc2011 if region=="ECA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwdoctor_clerk lngdppc2011 if region=="LAC" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="MNA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="NAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="SAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="AFR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwdoctor_clerk lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a Doctor" "to a Payroll Clerk") ///
		xtitle("Log of GDP per capit, 2011") leg(lab(1 "$country") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\doctorclerk_$country.png", width(2000) height(1500) as(png) replace
		
*** Senior Gov Official to a Payroll Clerk

twoway 	(scatter rwsenior_clerk lngdppc2011 if iso3=="$iso3",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_clerk lngdppc2011 if region=="EAP" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_clerk lngdppc2011 if region=="ECA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwsenior_clerk lngdppc2011 if region=="LAC" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="MNA" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="NAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="SAR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="AFR" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwsenior_clerk lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a" "Senior Gov Official" "to a Payroll Clerk") ///
		xtitle("Log of GDP per capit, 2011") leg(lab(1 "$country.") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

		graph export "$outputs\seniorclerk_$country.png", width(2000) height(1500) as(png) replace
		
** TABLE OF KEY INDICATORS

clear

use "$data/wagebill_imf.dta", clear

*** Wage Bill as % of GDP

tabstat wage_gdp if iso3=="$iso3" & year==$year, s(mean)

tabstat wage_gdp if year==$year, s(mean) by(region)
tabstat wage_gdp if region=="East Asia & Pacific" & iso3!="CHN" & year==$year, s(mean)
tabstat wage_gdp if region=="South Asia" & iso3!="IND" & year==$year, s(mean)

tabstat wage_gdp if year==$year, s(mean) by(incomegroup)
tabstat wage_gdp if incomegroup=="Upper middle income" & iso3!="CHN" & year==$year, s(mean)
tabstat wage_gdp if incomegroup=="Lower middle income" & iso3!="IND" & year==$year, s(mean)

*** Wage Bill as % of Expenditures

tabstat wage_x if iso3=="$iso3" & year==$year, s(mean)

tabstat wage_x if year==$year, s(mean) by(region)
tabstat wage_x if region=="East Asia & Pacific" & iso3!="CHN" & year==$year, s(mean)
tabstat wage_x if region=="South Asia" & iso3!="IND" & year==$year, s(mean)

tabstat wage_x if year==$year, s(mean) by(incomegroup)
tabstat wage_x if incomegroup=="Upper middle income" & iso3!="CHN" & year==$year, s(mean)
tabstat wage_x if incomegroup=="Lower middle income" & iso3!="IND" & year==$year, s(mean)


*** Public Employment as % of Wage Employment
clear
use "$data/i2d2_long_inc$year.dta", clear

tabstat share_public_paid1 if iso3=="$iso3", s(mean)

tabstat share_public_paid1, s(mean) by(region)
tabstat share_public_paid1 if region=="East Asia & Pacific" & iso3!="CHN", s(mean)
tabstat share_public_paid1 if region=="South Asia" & iso3!="IND", s(mean)

tabstat share_public_paid1, s(mean) by(income)
tabstat share_public_paid1 if income=="Upper middle income" & iso3!="CHN", s(mean)
tabstat share_public_paid1 if income=="Lower middle income" & iso3!="IND", s(mean)

*** Public Employment as % of Total Employment

tabstat share_public_total if iso3=="$iso3", s(mean)

tabstat share_public_total, s(mean) by(region)
tabstat share_public_total if region=="East Asia & Pacific" & iso3!="CHN", s(mean)
tabstat share_public_total if region=="South Asia" & iso3!="IND", s(mean)

tabstat share_public_total, s(mean) by(income)
tabstat share_public_total if income=="Upper middle income" & iso3!="CHN", s(mean)
tabstat share_public_total if income=="Lower middle income" & iso3!="IND", s(mean)

*** Public Wage Premium

tabstat coef_premium_ppp_w if iso3=="$iso3", s(mean)

tabstat coef_premium_ppp_w, s(mean) by(region)
tabstat coef_premium_ppp_w if region=="East Asia & Pacific" & iso3!="CHN", s(mean)
tabstat coef_premium_ppp_w if region=="South Asia" & iso3!="IND", s(mean)

tabstat coef_premium_ppp_w, s(mean) by(income)
tabstat coef_premium_ppp_w if income=="Upper middle income" & iso3!="CHN", s(mean)
tabstat coef_premium_ppp_w if income=="Lower middle income" & iso3!="IND", s(mean)


*** Benefits

tabstat share_public_ins_ssn_w if iso3=="$iso3", s(mean)

tabstat share_public_ins_ssn_w, s(mean) by(region)
tabstat share_public_ins_ssn_w if region=="East Asia & Pacific" & iso3!="CHN", s(mean)
tabstat share_public_ins_ssn_w if region=="South Asia" & iso3!="IND", s(mean)

tabstat share_public_ins_ssn_w, s(mean) by(income)
tabstat share_public_ins_ssn_w if income=="Upper middle income" & iso3!="CHN", s(mean)
tabstat share_public_ins_ssn_w if income=="Lower middle income" & iso3!="IND", s(mean)


*** Public Paid Employment: Mean Age

tabstat mean_age_public_paid if iso3=="$iso3", s(mean) 

tabstat mean_age_public_paid, s(mean) by(region)
tabstat mean_age_public_paid if region=="East Asia & Pacific" & iso3!="CHN", s(mean)
tabstat mean_age_public_paid if region=="South Asia" & iso3!="IND", s(mean)

tabstat mean_age_public_paid, s(mean) by(income)
tabstat mean_age_public_paid if income=="Upper middle income" & iso3!="CHN", s(mean)
tabstat mean_age_public_paid if income=="Lower middle income" & iso3!="IND", s(mean)

*** Public Paid Employment: Gender

tabstat share_public_paid_fem if iso3=="$iso3", s(mean)

tabstat share_public_paid_fem, s(mean) by(region)
tabstat share_public_paid_fem if region=="East Asia & Pacific" & iso3!="CHN", s(mean)
tabstat share_public_paid_fem if region=="South Asia" & iso3!="IND", s(mean)

tabstat share_public_paid_fem, s(mean) by(income)
tabstat share_public_paid_fem if income=="Upper middle income" & iso3!="CHN", s(mean)
tabstat share_public_paid_fem if income=="Lower middle income" & iso3!="IND", s(mean)

*** Public Paid Employment: % with tertiary education

tabstat share_public_paid_tertiaeduc if iso3=="$iso3", s(mean) 

tabstat share_public_paid_tertiaeduc, s(mean) by(region)
tabstat share_public_paid_tertiaeduc if region=="East Asia & Pacific" & iso3!="CHN", s(mean)
tabstat share_public_paid_tertiaeduc if region=="South Asia" & iso3!="IND", s(mean)

tabstat share_public_paid_tertiaeduc, s(mean) by(income)
tabstat share_public_paid_tertiaeduc if income=="Upper middle income" & iso3!="CHN", s(mean)
tabstat share_public_paid_tertiaeduc if income=="Lower middle income" & iso3!="IND", s(mean)











































