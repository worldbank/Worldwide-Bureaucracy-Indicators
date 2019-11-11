*** DO FILE UPDATED FOR AUTOMATED GENERATION OF COUNTRY VIGNETTES (TWO-PAGERS)
	* AUTHOR: Danny Walker (dwalker2@worldbank.org)
	* AUTHOR (original): Vanessa Cheng (vcheng.m@gmail.com)

*** Input Data
	* Wage Bill: wagebill_imf.dta
	* Public Employment & Public-Private comparisons (I2D2): i2d2_long_income_$year.dta
	* Relative Wages: icp2011_final.dta

*********************** PART 0:  PACKAGES AND IMAGES ***************************

** DW EDIT: The following packages were installed
* "charlist"
* "strip"
* "tabstatmat"

** DW EDIT: All map images downloaded from:
* http://www.operationworld.org/countries-alphabetically
* Using a web-scraping algorithm in R (see: map scraping_v1.R)
* Other maps downloaded from google images

********************** PART 1:  Define globals and programs ********************								

** DW EDIT: I'm going to consolidate to one user/ directory
global route "C:\Users\WB486467\Desktop\TWO_pager_\Analysis\WWBI"

* Subfolders
global data	"$route/data"
* Where the raw data is stored
global do_files "$route/dofiles"
* Where this do file is stored
global outputs "C:\Users\WB486467\Desktop\TWO_pager_\Analysis\Country Profiles_auto"
* Where the do file stores the outputted graphs

** DW EDIT: Keeping year as 2015 for now
global year 2015

***************************** PART 2: Graphs ***********************************

* USING THE WAGE BILL DATASET (wagebill_imf.dta)
** DW EDIT: I'm going to do all the "For all" graphs first and then loop through countries

use "$data/wagebill_imf.dta", clear
* First, a little string cleaning to avoid special/ non-ASCII characters
charlist country
replace country="Ivory Coast" if iso3=="CIV"
replace country="Sao Tome and Principe" if iso3=="STP"
replace country = subinstr(country," The","",.)
strip country, of("',-.") generate(country2)
drop country
rename country2 country
charlist country

** Wage as a % of GDP
** Wage as a % of Expenditures

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

graph export "$outputs\ALL_wage_gdp.png", as(png) replace

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

graph export "$outputs\ALL_wage_x.png", as(png) replace

*** For countries
** DW EDIT: I'm using country codes as file prefixes to avoid differences in naming
levelsof iso3, clean local(COUNTRIES)
foreach DISO3 of local COUNTRIES{
levelsof country if iso3=="`DISO3'", clean local(diso4)
twoway 	(scatter wage_x lngdppc if year==$year & iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_x lngdppc if year==$year & region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter wage_x lngdppc if year==$year & region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter wage_x lngdppc if year==$year & region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter wage_x lngdppc if year==$year & region=="Middle East & North Africa" & iso3!="LBY" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter wage_x lngdppc if year==$year & region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter wage_x lngdppc if year==$year & region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter wage_x lngdppc if year==$year & region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(lfit wage_x lngdppc if year==$year), ///
		ytitle("Wage Bill (%)") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_wage_x.png", width(2000) height(1500) as(png) replace

twoway 	(scatter wage_gdp lngdppc if year==$year & iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter wage_gdp lngdppc if year==$year & region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter wage_gdp lngdppc if year==$year & region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter wage_gdp lngdppc if year==$year & region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="Middle East & North Africa" & iso3!="LBY" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter wage_gdp lngdppc if year==$year & region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(lfit wage_gdp lngdppc if year==$year), ///
		ytitle("Wage Bill (%)") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_wage_gdp.png", width(2000) height(1500) as(png) replace
}

* USING THE i2d2 DATASET (i2d2_long_income_may8.dta)

use "$data/i2d2_long_inc$year.dta", clear
charlist country_name
replace country_name = subinstr(country_name," The","",.)
strip country_name, of(",.") generate(country)
drop country_name
charlist country

** PUBLIC EMPLOYMENT: Wage Employment
** PUBLIC EMPLOYMENT: Public Employment as % TOTAL Employment
** PUBLIC WAGE PREMIUM
** (Country only) PUBLIC - PRIVATE BENEFITS: Proportion of Employees with Health Insurance or Social Security in Private vs Public Sector, by Country and Region
** PUBLIC - PRIVATE DESCRIPTIVES: Gender
** PUBLIC - PRIVATE DESCRIPTIVES: Mean Age
** (Country only) PUBLIC - PRIVATE DESCRIPTIVES: Tertiary Education

*** All
twoway 	(scatter share_public_paid1 lngdppc$year if region=="East Asia & Pacific" ,  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_public_paid1 lngdppc$year if region=="Europe & Central Asia" ,  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_public_paid1 lngdppc$year if region=="Latin America & Caribbean" ,  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="Middle East & North Africa" & iso3!="LBY" ,  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="North America" ,  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="South Asia" ,  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="Sub-Saharan Africa" ,  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_paid1 lngdppc$year), ///
		ytitle("Public Employment as" "% of Paid Employment") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\ALL_publicemploymentpaid.png", as(png) replace

twoway 	(scatter share_public_total lngdppc$year if region=="East Asia & Pacific" ,  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_public_total lngdppc$year if region=="Europe & Central Asia" ,  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter share_public_total lngdppc$year if region=="Latin America & Caribbean" ,  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="Middle East & North Africa" & iso3!="LBY" ,  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="North America" ,  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="South Asia" ,  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="Sub-Saharan Africa" ,  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_total lngdppc$year), ///
		ytitle("Public Employment as" "% of Total Employment") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\ALL_publicemploymenttotal_all.png", as(png) replace

twoway 	(scatter coef_premium_ppp_w lngdppc$year if region=="East Asia & Pacific" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter coef_premium_ppp_w lngdppc$year if region=="Europe & Central Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Latin America & Caribbean" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Middle East & North Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="North America" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="South Asia" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Sub-Saharan Africa" & iso3!="$iso3",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit share_public_total lngdppc$year, lp(dash)), ///
		yline(0, lp(dash_dot)) ytitle("Public Sector Wage Premium") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") lab(8 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\ALL_premium.png", as(png) replace

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

graph export "$outputs\ALL_gender.png", as(png) replace

twoway 	(scatter mean_age_priv_paid mean_age_public_paid   if region=="East Asia & Pacific" ,  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Europe & Central Asia" ,  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Latin America & Caribbean" ,  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Middle East & North Africa" ,  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="North America" ,  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="South Asia" ,  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Sub-Saharan Africa" ,  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(function y=x, range(30 50)), ///
		ytitle("PRIVATE sector as a share of wage employees") ///
		xtitle("PUBLIC sector as a share of wage employees") leg(lab(1 "East Asia & Pacific") lab(2 "Europe & Central Asia") lab(3 "Latin America & Caribbean") lab(4 "Middle East & North Africa") lab(5 "North America") lab(6 "South Asia") lab(7 "Sub-Saharan Africa") lab(8 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\ALL_meanage.png", as(png) replace

*** Countries
levelsof iso3, clean local(COUNTRIES)
foreach DISO3 of local COUNTRIES{
levelsof country if iso3=="`DISO3'", clean local(diso4)
twoway 	(scatter share_public_paid1 lngdppc$year if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_paid1 lngdppc$year if region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter share_public_paid1 lngdppc$year if region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter share_public_paid1 lngdppc$year if region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter share_public_paid1 lngdppc$year if region=="Middle East & North Africa" & iso3!="LBY" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter share_public_paid1 lngdppc$year if region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter share_public_paid1 lngdppc$year if region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter share_public_paid1 lngdppc$year if region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(lfit share_public_paid1 lngdppc$year), ///
		ytitle("Public Employment as" "% of Wage Employment") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_wageemploy.png",width(2000) height(1500)  as(png) replace

twoway 	(scatter share_public_total lngdppc$year if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter share_public_total lngdppc$year if region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter share_public_total lngdppc$year if region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter share_public_total lngdppc$year if region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter share_public_total lngdppc$year if region=="Middle East & North Africa" & iso3!="LBY" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter share_public_total lngdppc$year if region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter share_public_total lngdppc$year if region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter share_public_total lngdppc$year if region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(lfit share_public_total lngdppc$year), ///
		ytitle("Public Employment as" "% of Total Employment") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_publicemploymenttotal.png", width(2000) height(1500)  as(png) replace

twoway 	(scatter coef_premium_ppp_w lngdppc$year if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter coef_premium_ppp_w lngdppc$year if region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter coef_premium_ppp_w lngdppc$year if region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Middle East & North Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter coef_premium_ppp_w lngdppc$year if region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(lfit coef_premium_ppp_w lngdppc$year, lp(dash)), ///
		yline(0, lp(dash_dot)) ytitle("Public Sector Wage Premium") ///
		xtitle("Log of GDP per capita, $year") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_premium.png", width(2000) height(1500)  as(png) replace

twoway 	(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Middle East & North Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter share_priv_ins_ssn_w share_public_ins_ssn_w if region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(function y=x), ///
		ytitle("% of PRIVATE employees with health insurance" "or social security") ///
		xtitle("% of PUBLIC employees with health insurance or social security") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_benefits.png", width(2000) height(1500) as(png) replace

twoway 	(scatter share_priv_paid_fem share_public_paid_fem  if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Middle East & North Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter share_priv_paid_fem share_public_paid_fem  if region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(function y=x, range(0 0.8)), ///
		ytitle("% of FEMALE employees in the" "PRIVATE sector") ///
		xtitle("% of FEMALE employees in the PUBLIC sector") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_gender.png", width(2000) height(1500) as(png) replace

twoway 	(scatter mean_age_priv_paid mean_age_public_paid   if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Middle East & North Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter mean_age_priv_paid mean_age_public_paid   if region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(function y=x, range(30 50)), ///
		ytitle("PRIVATE sector as a share of wage employees") ///
		xtitle("PUBLIC sector as a share of wage employees") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_meanage.png", width(2000) height(1500) as(png) replace

twoway 	(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if region=="East Asia & Pacific" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink)) /// 
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if region=="Europe & Central Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon))	///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if region=="Latin America & Caribbean" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if region=="Middle East & North Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if region=="North America" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if region=="South Asia" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green)) ///
		(scatter share_priv_paid_tertiaeduc share_public_paid_tertiaeduc if region=="Sub-Saharan Africa" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold)) ///
		(function y=x), ///
		ytitle("% of PRIVATE wage employees") ///
		xtitle("% of PUBLIC wage employees") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "45 degree line") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_tertiary.png", width(2000) height(1500) as(png) replace
}

* USING THE ICP2011 DATASET (icp2011_final.dta)
** DW EDIT: Note: These loops create all graphs for all countries, but there are a lot of missing values

clear 
use "$data/icp2011_final.dta", clear
charlist country
replace country = subinstr(country," The","",.)
replace country = "Curacao" if iso3=="CUW"
replace country = "Ivory Coast" if iso3=="CIV"
replace country = "Sao Tome and Principe" if iso3=="STP"
strip country, of("'(),-.") generate(country2)
drop country
rename country2 country
charlist country

** Relative Wages
*** Doctor to a Secretary
*** Senior Gov Official to a Secretary
*** Doctor to a Payroll Clerk
*** Senior Gov Official to a Payroll Clerk

levelsof iso3, clean local(COUNTRIES)
foreach DISO3 of local COUNTRIES{
levelsof country if iso3=="`DISO3'", clean local(diso4)
twoway 	(scatter rwdoctor_secre lngdppc2011 if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_secre lngdppc2011 if region=="EAP" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_secre lngdppc2011 if region=="ECA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwdoctor_secre lngdppc2011 if region=="LAC" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="MNA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="NAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="SAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_secre lngdppc2011 if region=="AFR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwdoctor_secre lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a Doctor" "to a Secretary") ///
		xtitle("Log of GDP per capita, 2011") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_doctorsecre.png", width(2000) height(1500) as(png) replace

twoway 	(scatter rwsenior_secre lngdppc2011 if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_secre lngdppc2011 if region=="EAP" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_secre lngdppc2011 if region=="ECA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwsenior_secre lngdppc2011 if region=="LAC" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="MNA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="NAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="SAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_secre lngdppc2011 if region=="AFR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwsenior_secre lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a" "Senior Gov Official" "to a Secretary") ///
		xtitle("Log of GDP per capita, 2011") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_seniorsecre.png", width(2000) height(1500) as(png) replace

twoway 	(scatter rwdoctor_clerk lngdppc2011 if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_clerk lngdppc2011 if region=="EAP" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwdoctor_clerk lngdppc2011 if region=="ECA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwdoctor_clerk lngdppc2011 if region=="LAC" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="MNA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="NAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="SAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwdoctor_clerk lngdppc2011 if region=="AFR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwdoctor_clerk lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a Doctor" "to a Payroll Clerk") ///
		xtitle("Log of GDP per capit, 2011") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_doctorclerk.png", width(2000) height(1500) as(png) replace

twoway 	(scatter rwsenior_clerk lngdppc2011 if iso3=="`DISO3'",  msymbol(square) msize(large) mcolor(blue) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_clerk lngdppc2011 if region=="EAP" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(pink) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) /// 
		(scatter rwsenior_clerk lngdppc2011 if region=="ECA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(maroon) mlabel(iso3) mlabs(vsmall) mlabc(lavender))	///
		(scatter rwsenior_clerk lngdppc2011 if region=="LAC" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(red) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="MNA" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(orange) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="NAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(black) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="SAR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(green) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(scatter rwsenior_clerk lngdppc2011 if region=="AFR" & iso3!="`DISO3'",  msymbol(circle) msize(medium) mcolor(gold) mlabel(iso3) mlabs(vsmall) mlabc(lavender)) ///
		(lfit rwsenior_clerk lngdppc2011, lp(dash)), ///
		ytitle("Relative Wage of a" "Senior Gov Official" "to a Payroll Clerk") ///
		xtitle("Log of GDP per capit, 2011") leg(lab(1 "`diso4'") lab(2 "East Asia & Pacific") lab(3 "Europe & Central Asia") lab(4 "Latin America & Caribbean") lab(5 "Middle East & North Africa") lab(6 "North America") lab(7 "South Asia") lab(8 "Sub-Saharan Africa") lab(9 "Fitted Values") size(vsmall) c(3) pos(6)) graphregion(fcolor(white))

graph export "$outputs\_`DISO3'_seniorclerk.png", width(2000) height(1500) as(png) replace
}

** DW EDIT: I'm going to make the country-specific spreadsheet now

clear
cd "$outputs"
local dTE: dir . files "_*.png", respect
display `"`dTE'"'
local counter = 1
set obs 1
generate data_0 = "blank"
foreach files of local dTE{
generate dataname = `"`files'"'
split dataname, p("_") generate(typedata)
keep typedata2 data_*
rename typedata2 data_`counter'
local counter = `counter'+1
}
generate nrow = _n
reshape long data_, i(nrow) j(country)
keep data_
drop if data_=="blank"

levelsof data_, clean local(COUNTRIES)
foreach DISO3 of local COUNTRIES{
copy "$outputs\excel template\MASTER_bureauc_profile.xlsx" "$outputs\excel template\_`DISO3'_bureauc_profile.xlsx", replace
putexcel set "$outputs\excel template\_`DISO3'_bureauc_profile.xlsx", modify sheet("Sheet1")
putexcel L27 = "`DISO3'"
cd "$outputs\map pngs"
local wobble: dir . files "_`DISO3'_*.png", respect
capture noisily: putexcel I1 = picture("`wobble'")
capture noisily: putexcel S1 = picture("`wobble'")
capture noisily: putexcel G23 = picture("$outputs\_`DISO3'_meanage.png")
if _rc==601{
putexcel G23 = picture("$outputs\__NO DATA5.png")
}

** TABLE OF KEY INDICATORS
use "$data/wagebill_imf.dta", clear

*** Wage Bill as % of GDP
*** Wage Bill as % of Expenditures

** For select country
sum wage_gdp if iso3=="`DISO3'" & year==$year
capture noisily: putexcel O27 = `r(mean)'
if _rc==198{
putexcel O27 = "-"
putexcel B7 = picture("$outputs\__NO DATA5.png")
}
else{
capture noisily: putexcel B7 = picture("$outputs\_`DISO3'_wage_gdp.png")
if _rc==601{
putexcel B7 = picture("$outputs\__NO DATA5.png")
}
}

sum wage_x if iso3=="`DISO3'" & year==$year
capture noisily: putexcel P27 = `r(mean)'
if _rc==198{
putexcel P27 = "-"
putexcel G7 = picture("$outputs\__NO DATA5.png")
}
else{
capture noisily: putexcel G7 = picture("$outputs\_`DISO3'_wage_x.png")
if _rc==601{
putexcel G7 = picture("$outputs\__NO DATA5.png")
}
}

** All else
tabstat wage_gdp if year==$year, s(mean) by(region) save
tabstatmat tot_temp, nototal
putexcel O28 = tot_temp[1,1] O30 = tot_temp[2,1] O31 = tot_temp[3,1] O32 = tot_temp[4,1] O33 = tot_temp[6,1] O35 = tot_temp[7,1]

sum wage_gdp if region=="East Asia & Pacific" & iso3!="CHN" & year==$year
putexcel O29 = `r(mean)'
sum wage_gdp if region=="South Asia" & iso3!="IND" & year==$year
putexcel O34 = `r(mean)'

tabstat wage_gdp if year==$year, s(mean) by(incomegroup) save
tabstatmat tot_temp, nototal
putexcel O36 = tot_temp[1,1] O37 = tot_temp[2,1] O39 = tot_temp[3,1] O41 = tot_temp[4,1]

sum wage_gdp if incomegroup=="Upper middle income" & iso3!="CHN" & year==$year
putexcel O38 = `r(mean)'
sum wage_gdp if incomegroup=="Lower middle income" & iso3!="IND" & year==$year
putexcel O40 = `r(mean)'

tabstat wage_x if year==$year, s(mean) by(region) save
tabstatmat tot_temp, nototal
putexcel P28 = tot_temp[1,1] P30 = tot_temp[2,1] P31 = tot_temp[3,1] P32 = tot_temp[4,1] P33 = tot_temp[6,1] P35 = tot_temp[7,1]

sum wage_x if region=="East Asia & Pacific" & iso3!="CHN" & year==$year
putexcel P29 = `r(mean)'
sum wage_x if region=="South Asia" & iso3!="IND" & year==$year
putexcel P34 = `r(mean)'

tabstat wage_x if year==$year, s(mean) by(incomegroup) save
tabstatmat tot_temp, nototal
putexcel P36 = tot_temp[1,1] P37 = tot_temp[2,1] P39 = tot_temp[3,1] P41 = tot_temp[4,1]

sum wage_x if incomegroup=="Upper middle income" & iso3!="CHN" & year==$year
putexcel P38 = `r(mean)'
sum wage_x if incomegroup=="Lower middle income" & iso3!="IND" & year==$year
putexcel P40 = `r(mean)'

*** Public Employment as % of Wage Employment
*** Public Employment as % of Total Employment
*** Public Wage Premium
*** Benefits
*** Public Paid Employment: Mean Age
*** Public Paid Employment: Gender
*** Public Paid Employment: % with tertiary education

use "$data/i2d2_long_inc$year.dta", clear

** Country
sum share_public_paid1 if iso3=="`DISO3'"
capture noisily: putexcel Q27 = `r(mean)'
if _rc==198{
putexcel Q27 = "-"
putexcel B23 = picture("$outputs\__NO DATA5.png")
}
else{
capture noisily: putexcel B23 = picture("$outputs\_`DISO3'_wageemploy.png")
if _rc==601{
putexcel B23 = picture("$outputs\__NO DATA5.png")
}
}

sum share_public_paid_fem if iso3=="`DISO3'"
capture noisily: putexcel R27 = `r(mean)'
if _rc==198{
putexcel R27 = "-"
putexcel B35 = picture("$outputs\__NO DATA5.png")
}
else{
capture noisily: putexcel B35 = picture("$outputs\_`DISO3'_gender.png")
if _rc==601{
putexcel B35 = picture("$outputs\__NO DATA5.png")
}
}

sum share_public_paid_tertiaeduc if iso3=="`DISO3'"
capture noisily: putexcel S27 = `r(mean)'
if _rc==198{
putexcel S27 = "-"
putexcel G35 = picture("$outputs\__NO DATA5.png")
}
else{
capture noisily: putexcel G35 = picture("$outputs\_`DISO3'_tertiary.png")
if _rc==601{
putexcel G35 = picture("$outputs\__NO DATA5.png")
}
}

sum coef_premium_ppp_w if iso3=="`DISO3'"
capture noisily: putexcel T27 = `r(mean)'
if _rc==198{
putexcel T27 = "-"
putexcel L7 = picture("$outputs\__NO DATA5.png")
}
else{
capture noisily: putexcel L7 = picture("$outputs\_`DISO3'_premium.png")
if _rc==601{
putexcel L7 = picture("$outputs\__NO DATA5.png")
}
}

sum share_public_ins_ssn_w if iso3=="`DISO3'"
capture noisily: putexcel U27 = `r(mean)'
if _rc==198{
putexcel U27 = "-"
putexcel Q7 = picture("$outputs\__NO DATA5.png")
}
else{
capture noisily: putexcel Q7 = picture("$outputs\_`DISO3'_benefits.png")
if _rc==601{
putexcel Q7 = picture("$outputs\__NO DATA5.png")
}
}

** Else
tabstat share_public_paid1, s(mean) by(region) save
tabstatmat tot_temp, nototal
putexcel Q28 = tot_temp[1,1] Q30 = tot_temp[2,1] Q31 = tot_temp[3,1] Q32 = tot_temp[4,1] Q33 = tot_temp[6,1] Q35 = tot_temp[7,1]

sum share_public_paid1 if region=="East Asia & Pacific" & iso3!="CHN"
putexcel Q29 = `r(mean)'
sum share_public_paid1 if region=="South Asia" & iso3!="IND"
putexcel Q34 = `r(mean)'

tabstat share_public_paid1, s(mean) by(income) save
tabstatmat tot_temp, nototal
putexcel Q36 = tot_temp[1,1] Q37 = tot_temp[2,1] Q39 = tot_temp[3,1] Q41 = tot_temp[4,1]

sum share_public_paid1 if income=="Upper middle income" & iso3!="CHN"
putexcel Q38 = `r(mean)'
sum share_public_paid1 if income=="Lower middle income" & iso3!="IND"
putexcel Q40 = `r(mean)'

tabstat coef_premium_ppp_w, s(mean) by(region) save
tabstatmat tot_temp, nototal
putexcel T28 = tot_temp[1,1] T30 = tot_temp[2,1] T31 = tot_temp[3,1] T32 = tot_temp[4,1] T33 = tot_temp[6,1] T35 = tot_temp[7,1]

sum coef_premium_ppp_w if region=="East Asia & Pacific" & iso3!="CHN"
putexcel T29 = `r(mean)'
sum coef_premium_ppp_w if region=="South Asia" & iso3!="IND"
putexcel T34 = `r(mean)'

tabstat coef_premium_ppp_w, s(mean) by(income) save
tabstatmat tot_temp, nototal
putexcel T36 = tot_temp[1,1] T37 = tot_temp[2,1] T39 = tot_temp[3,1] T41 = tot_temp[4,1]

sum coef_premium_ppp_w if income=="Upper middle income" & iso3!="CHN"
putexcel T38 = `r(mean)'
sum coef_premium_ppp_w if income=="Lower middle income" & iso3!="IND"
putexcel T40 = `r(mean)'

tabstat share_public_ins_ssn_w, s(mean) by(region) save
tabstatmat tot_temp, nototal
putexcel U28 = tot_temp[1,1] U30 = tot_temp[2,1] U31 = tot_temp[3,1] U32 = tot_temp[4,1] U33 = tot_temp[6,1] U35 = tot_temp[7,1]

sum share_public_ins_ssn_w if region=="East Asia & Pacific" & iso3!="CHN"
putexcel U29 = `r(mean)'
sum share_public_ins_ssn_w if region=="South Asia" & iso3!="IND"
putexcel U34 = `r(mean)'

tabstat share_public_ins_ssn_w, s(mean) by(income) save
tabstatmat tot_temp, nototal
putexcel U36 = tot_temp[1,1] U37 = tot_temp[2,1] U39 = tot_temp[3,1] U41 = tot_temp[4,1]

sum share_public_ins_ssn_w if income=="Upper middle income" & iso3!="CHN"
putexcel U38 = `r(mean)'
sum share_public_ins_ssn_w if income=="Lower middle income" & iso3!="IND"
putexcel U40 = `r(mean)'

tabstat share_public_paid_fem, s(mean) by(region) save
tabstatmat tot_temp, nototal
putexcel R28 = tot_temp[1,1] R30 = tot_temp[2,1] R31 = tot_temp[3,1] R32 = tot_temp[4,1] R33 = tot_temp[6,1] R35 = tot_temp[7,1]

sum share_public_paid_fem if region=="East Asia & Pacific" & iso3!="CHN"
putexcel R29 = `r(mean)'
sum share_public_paid_fem if region=="South Asia" & iso3!="IND"
putexcel R34 = `r(mean)'

tabstat share_public_paid_fem, s(mean) by(income) save
tabstatmat tot_temp, nototal
putexcel R36 = tot_temp[1,1] R37 = tot_temp[2,1] R39 = tot_temp[3,1] R41 = tot_temp[4,1]

sum share_public_paid_fem if income=="Upper middle income" & iso3!="CHN"
putexcel R38 = `r(mean)'
sum share_public_paid_fem if income=="Lower middle income" & iso3!="IND"
putexcel R40 = `r(mean)'

tabstat share_public_paid_tertiaeduc, s(mean) by(region) save
tabstatmat tot_temp, nototal
putexcel S28 = tot_temp[1,1] S30 = tot_temp[2,1] S31 = tot_temp[3,1] S32 = tot_temp[4,1] S33 = tot_temp[6,1] S35 = tot_temp[7,1]

sum share_public_paid_tertiaeduc if region=="East Asia & Pacific" & iso3!="CHN"
putexcel S29 = `r(mean)'
sum share_public_paid_tertiaeduc if region=="South Asia" & iso3!="IND"
putexcel S34 = `r(mean)'

tabstat share_public_paid_tertiaeduc, s(mean) by(income) save
tabstatmat tot_temp, nototal
putexcel S36 = tot_temp[1,1] S37 = tot_temp[2,1] S39 = tot_temp[3,1] S41 = tot_temp[4,1]

sum share_public_paid_tertiaeduc if income=="Upper middle income" & iso3!="CHN"
putexcel S38 = `r(mean)'
sum share_public_paid_tertiaeduc if income=="Lower middle income" & iso3!="IND"
putexcel S40 = `r(mean)'
}

** DW EDIT: These loops create Excel files; however, you will need to run an Excel macro to resize the images and export as a PDF
