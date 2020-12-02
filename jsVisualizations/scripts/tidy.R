# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# tidy.R
# completes all data manipulation for wwbi graphs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #



library(readxl)
library(haven)
library(hablar)
library(lubridate)
library(forcats)
library(WDI)




                              #     Load Data     # ----
                              


# load WDI metadata, main 'micro' data
wdi_meta <- WDI_data
wdi_dny  <- as_tibble(wdi_meta$country)


# create key WDI indicators list 
keywdi <- c( 'gdp_pc2017' = "NY.GDP.PCAP.PP.KD" # GDP, PPP (constant 2017 international $)
            )


# download wdi only for key indicators in list 
wdi <- 
  WDI(
    country = 'all',
    indicator = keywdi,
    start = 1990,
    end = 2020,
    extra = TRUE
  ) %>%
  mutate(
    ln_gdp = log(gdp_pc2017)
  )



# load previously-made wwbi-wdi country dictionary to retreive regions etc 
extra <-
  read_dta(
    file = "C:/Users/WB551206/OneDrive - WBG/Documents/WB_data/WDI/WDI_country_names.dta"
    )


# load wwbi, change names, get rid of "...24"
wwbi_raw <- read_xlsx(
  path = file.path(wwbi_dat, "WWBIEXCEL.xlsx"),
  na = ""
) %>%
  rename(
    ctyname = "Country Name",
    ctycode = "Country Code",
    indname = "Indicator Name",
    indcode = "Indicator Code"
  ) %>%
  select(-"...24") 



# checks
assert_that( sum(is.na(wwbi_raw$ctyname)) == 0)
assert_that( sum(is.na(wwbi_raw$ctycode)) == 0)
assert_that( sum(is.na(wwbi_raw$indname)) == 0)
assert_that( sum(is.na(wwbi_raw$indcode)) == 0) # yay, faisal is awesome!







                                  #    Select Key Indicators    # ----
                                    
                            

# public sector employment as a share of total, paid, formal employment, 
#                                       total, male, female residents, 
#                                       all, rural, urban residents 


## create list of key variablbes we will want to plot                           
codes <- c("BI.EMP.TOTL.PB.ZS", "BI.EMP.PWRK.PB.ZS", "BI.EMP.FRML.PB.ZS",
           "BI.EMP.TOTL.PB.MA.ZS",  "BI.EMP.TOTL.PB.FE.ZS",
           "BI.EMP.TOTL.PB.RU.ZS", "BI.EMP.PWRK.PB.UR.ZS") 

## create table of indicator names/codes 
names_all <- wwbi_raw %>%
  dplyr::distinct(indname, indcode)

names <- names_all[names_all$indcode %in% codes, ]

## filter/subset
wwbi2 <- wwbi_raw[wwbi_raw$indcode %in% codes, ]







                                #    Tidyr Data Manipulation     # ----

# WWBI wrangling.

## gather, make longer, all dates in one column
wwbi3 <- wwbi_raw %>% 
  pivot_longer(
    cols = starts_with("20"),
    names_to = "year",
    values_to = "value", # where the values in the years cols go
    values_drop_na = FALSE # don't drop rows with missing values
  )



## now pivot variables to wide form, create wwbi object (main dataset)
wwbi <- pivot_wider(
  wwbi3, 
  id_cols = c(ctycode, ctyname, year),
  names_from = indcode, 
  values_from = value
)





# WDI wrangling.
# none?




# join WWBI and WDI info
# ## first join to wdi dictionary 
# wwbi <- left_join(wwbi, wdi_dny,
#                   by = c("ctycode" = "iso3c"),
#                   na_matches = 'never',
#                   keep = TRUE) 
# 



# join with WDI microdata 
## first convert year to integer

wwbi <-
  wwbi %>%
  convert(int(year))

wwbi <- left_join(wwbi, wdi, 
                  by = c("ctycode" = "iso3c",
                         "year"    = "year"),
                  na_matches = 'never',
                  keep = TRUE,
                  suffix = c("", "_wdi")) # this means that for 'year', the year from 
                                          # wdi will be 'year_wdi'
                                          

### check 
assert_that(sum(is.na(wwbi$region)) == 0 )
assert_that(sum(is.na(wwbi$income)) == 0 )
assert_that(sum(is.na(wwbi$iso3c)) == 0 )
assert_that(sum(is.na(wwbi$iso2c)) == 0 )



## add numeric income group variable 
# wwbi$incomegroupNum <- NA
# wwbi$incomegroupNum[wwbi$IncomeGroup == "Low income"] <- 12
# wwbi$incomegroupNum[wwbi$IncomeGroup == "Lower middle income"] <- 18
# wwbi$incomegroupNum[wwbi$IncomeGroup == "Upper middle income"] <- 24
# wwbi$incomegroupNum[wwbi$IncomeGroup == "High income"] <- 30
#assert_that(sum(is.na(wwbi$incomegroupNum)) == 0)


# convert data storeage types 

wwbi <-
  wwbi %>%
  convert(
    fct(iso3c, iso2c, country, region, income, lending) # and these vars to factor
)


## resort levels by alpha 
wwbi$region <-
  fct_relevel(wwbi$region, 
              c("East Asia & Pacific",
                "Europe & Central Asia",
                "Latin America & Caribbean",
                "Middle East & North Africa",
                "North America",
                "South Asia", 
                "Sub-Saharan Africa" ))



## create log number of employed person 
wwbi$lnTotEmp <- log(wwbi$BI.EMP.TOTL.NO)








                                #    Export     # ----


save.image(file = file.path(wwbi_dat, "wwbi-tbls.Rdata"))
