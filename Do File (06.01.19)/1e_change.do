*************************************************************
*PUBLIC SECTOR EMPLOYMENT
*1e -change 
*Called by 1_Sample.do
*Rong Shi 
*First version: September 2018
*Last version: June 2019
*************************************************************
*Additional changes on original survey
*************************************************************



/*1. Drop age information in Sri Lanka 2013 survey because the mean_age is over 71 (highly unlikely) */
use "${Data}\LatestI2D2_SAR", clear
replace age=. if sample=="lka_2013_i2d2_lfs.dta"
save "${Data}\LatestI2D2_SAR", replace


/*2. Mozambique: 13 obs are marked as year==2013 when sample=="moz_2012_i2d2_incaf.dta"
*Seems these changes have been made in the newest i2d2 data version*/

use "${Data}\LatestI2D2_SSA", clear
replace year = 2012 if sample == "moz_2012_i2d2_incaf.dta" & year == 2013
save "${Data}\LatestI2D2_SSA", replace












