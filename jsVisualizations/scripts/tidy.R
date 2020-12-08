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
library(scales)
library(sjmisc)



                              #     Load Data     # ----
                              

# load cross-country comparison data
wwbi_x <- read_xlsx(
  path = file.path(wwbi_dat, "Cross-country wage comparison data.xlsx"),
  na = ""
) %>%
  rename(
    "ctyname" = `Country Name`,
    "ctycode" = `Country Code`,
    "region"  = Region,
    "IncomeLevel" = "Income Level",
    "SeniorOfficial" = "Senior official",
    "HospitalDoctor" = "Hospital doctor",
    "HospitalNurse"  = "Hospital nurse",
    "GovernmentEconomist" = "Government economist",
    "UniversityTeacher" = "University teacher",
    "SecondarySchoolTeacher" = "Secondary school teacher",
    "PrimarySchoolTeacher" = "Primary school teacher",
    "PoliceOfficer" = "Police officer"
  ) 


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






                                # create graph-specific subsets # ----


# create subset of key variables to handle missing values
subset1 <- wwbi %>%
  select(ctyname, year, gdp_pc2017, BI.EMP.TOTL.PB.ZS, BI.EMP.PWRK.PB.ZS, BI.EMP.FRML.PB.ZS) %>%
  # keep only if year, gdp and one of the three employment vars are non missing
  filter( (is.na(year) == FALSE & is.na(gdp_pc2017) == FALSE) ) %>%
  filter( (is.na(BI.EMP.TOTL.PB.ZS) == FALSE
           | is.na(BI.EMP.PWRK.PB.ZS) == FALSE)
          | is.na(BI.EMP.FRML.PB.ZS) == FALSE )



# create subset for 3d scatter keeping only 3 most recent measures for each country 
  #     size = ~ln_gdp,
  # x = ~ BI.EMP.TOTL.PB.ZS, # share of total employment
  # y = ~ BI.EMP.PWRK.PB.ZS, # share of paid employment
  # z = ~BI.EMP.FRML.PB.ZS,  # share of formal employment

subset2 <- wwbi %>%
  filter(is.na(gdp_pc2017) == FALSE  # obs must have all 4 of these points
         & is.na(BI.EMP.TOTL.PB.ZS) == FALSE
         & is.na(BI.EMP.PWRK.PB.ZS) == FALSE
         & is.na(BI.EMP.FRML.PB.ZS) == FALSE) %>%
  arrange(ctyname, desc(year), .by_group = TRUE) %>% # by country, keep most 3 recent obs only 
  group_by(ctyname) %>%
  filter(row_number() <= 3)









                                # wrangling the cross country comparison # ----
# for the heatmap we have to have in long format 
varlist1 <- c("SeniorOfficial", "Judge", "HospitalDoctor", "HospitalNurse",
              "GovernmentEconomist", "UniversityTeacher", "SecondarySchoolTeacher",
              "PrimarySchoolTeacher", "PoliceOfficer") # abbreviations are wonderful

# create n miss by variable tibble.
n.miss <- as.data.frame(colSums(is.na(wwbi_x))) %>%
  mutate(
    var = rownames(.)
  ) %>%
  rename(nmiss = "colSums(is.na(wwbi_x))") %>%
  as.tibble() %>%
  filter(row_number() >= 5) %>%
  arrange(nmiss)


wwbi_hmp <- wwbi_x %>%
  mutate( # generate total
    total = rowSums(.[5:13], na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = varlist1,
    names_to = "indicator"
  ) %>%
  filter(!is.na(value)) %>% # remove rows with missing values
  arrange(-total)

wwbi_hmp %>%
  group_by(indicator) %>%
  dplyr::summarize(sum(is.na(wwbi_hmp$value)))



                                #    Export     # ----


save.image(file = file.path(wwbi_dat, "wwbi-tbls.Rdata"))
