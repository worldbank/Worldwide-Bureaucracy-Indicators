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
library(stringr)
library(scales)
library(sjmisc)


                              #     Load Data     # ----
                              

# load cross-country comparison data
wwbi_x <- read_xlsx(
  path = crxcountry,
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
wdi_meta <- WDI::WDI_data
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

# here we'll insert "<br>" to properly render long labels in legends, etc. 
# But the number of breaks will be dependent on the length of the string, 
# which we will also generate in the mutate. The number line breaks will 
# go as follows:
#   0-40 char: 1 break 
#   41-80char: 2 breaks
#   81 >=char: 3 breaks

## create table of indicator names/codes 
names_all <- wwbi_raw %>%
  dplyr::distinct(indname, indcode) %>%
  mutate(
    length = str_length(indname),
        # conditional splitting of lines based on length
    nameHtml = case_when(
      length <= 18 ~ indname,
      length >18 & length <=30 ~ gsub('^(.{10,20})(\\b)(.+)$',
                                      '\\1<br>\\3', 
                                      indname), # 1 break
      length >30 & length <= 60 ~ gsub('^(.{10,20})(\\b)(.{10,20})(\\b)(.+)$',
                                       '\\1<br>\\3<br>\\5', 
                                       indname), # 2 breaks,
      length >60 & length <= 80 ~ gsub('^(.{15,20})(\\b)(.{15,20})(\\b)(.{15,20})(\\b)(.+)$',
                                               '\\1<br>\\3<br>\\5<br>\\7',
                                               indname), # 3 breaks
      length >80 ~ gsub('^(.{10,20})(\\b)(.{15,20})(\\b)(.{15,20})(\\b)(.{15,20})(\\b)(.+)$',
                                       '\\1<br>\\3<br>\\5<br>\\7<br>\\9',
                                       indname) # 4 breaks
      ),
    
    # nameHtml = if_else(length <= 40,
    #                    true = gsub('^(.{5,20})(\\b)(.+)$',
    #                                '\\1<br>\\3', 
    #                                indname), # 1 break
    #                    false = if_else( length >= 41 & length <= 70,
    #                                     true = gsub('^(.{5,20})(\\b)(.{10,20})(\\b)(.+)$',
    #                                                 '\\1<br>\\3<br>\\5', 
    #                                                 indname), # 2 breaks
    #                                     false = gsub('^(.{5,20})(\\b)(.{15,25})(\\b)(.{15,25})(\\b)(.+)$',
    #                                                  '\\1<br>\\3<br>\\5<br>\\7',
    #                                                  indname) # 3 breaks 
    #                                     ) #end 2nd ifelse
    #                               ), #end 1st ifelse 
    namegg = gsub( '<br>', '\\\n', nameHtml) #end 1st ifelse 
        ) %>% # end mutate
  separate(.,
    col = indcode, 
    into = c("cat1", "cat2", "cat3", "cat4", "cat5"),
    sep = "\\.",
    remove = FALSE
  ) %>%
  mutate( # add a manual column for indicator initials that are dif but mean same
    cat6 =
      case_when(cat4 == "PV"  ~ "PRVS", # privcate sector tag
                cat5 == "PV"  ~ "PRVS",
                cat3 == "PWK" ~ "PWRK"), # duplicate tag
    cat7 = # education 
      case_when(cat4 == "TT"  ~ "EDU", # education tag
                cat4 == "SG"  ~ "EDU",
                cat4 == "PN"  ~ "EDU",
                cat4 == "NN"  ~ "EDU",
                cat5 == "TT"  ~ "EDU",
                cat5 == "SG"  ~ "EDU",
                cat5 == "PN"  ~ "EDU",
                cat5 == "NN"  ~ "EDU",
                cat5 == "ED"  ~ "EDU"),
    cat8 = #gender 
      case_when(cat4 == "MA"  ~ "GEN",
                cat4 == "FE"  ~ "GEN",
                cat4 == "FM"  ~ "GEN",
                cat5 == "MA"  ~ "GEN",
                cat5 == "FE"  ~ "GEN",
                cat5 == "FM"  ~ "GEN"),
    cat9 = #rurality
      case_when(cat4 == "RU"  ~ "RUUR",
                cat5 == "RU"  ~ "RUUR",
                cat4 == "UR"  ~ "RUUR",
                cat5 == "UR"  ~ "RUUR")
                
  ) %>%
  arrange(indcode) %>% # alpha sort by indcode 
  mutate(id = row_number()) %>%
  select(id, everything()) # put id column first 
  

# generate a tag and filter tables


filter_tags <- 
  names_all %>%
  select(indname, indcode, cat2, cat3, cat4, cat5, cat6, cat7, cat8, cat9) %>%
  pivot_longer(cols = c(cat2, cat3, cat4, cat5, cat6, cat7, cat8, cat9),
               names_to  = "tagno",
               values_to = "tag1")


# all tags in use and description (14 x 2)
filter_table <- as.tibble(unique(filter_tags$tag1)) %>%
  rename(tag1 = value) %>%
  mutate(
    desc = 
      case_when(tag1 == "EMP"  ~ "Employment", # add abitger column
                tag1 == "PWK" ~ "Paid Work",
                tag1 == "WAG" ~ "Wages",
                # misc 
                #tag1 == "POP" ~ "Sample Size",
                #tag1 == "FRML" ~ "Formal Employment",
                #tag1 == "TOTL" ~ "Total Employment",
                #tag1 == "PW" ~ "Paid Employment",
                
                tag1 == "PB"   ~ "Public Sector",
                tag1 == "PRVS"  ~ "Private Sector",
                
                tag1 == "GEN"  ~ "Gender",
                tag1 == "RUUR" ~ "Rurality",
                # tag1 == "RU"   ~ "Rural",
                # tag1 == "UR"   ~ "Urban",
                
                tag1 == "AGES"   ~ "Age",
                
                tag1 == "HS"   ~ "Health",
                tag1 == "EDU"  ~ "Education",
                
               # tag1 == "SN"  ~ "Senior Officials",
                tag1 == "PREM" ~ "Wage Premium",
                
                tag1 == "GD"   ~ "GDP"
      )
  ) %>%
  filter_all(all_vars(!is.na(.)))

# expanded grid (many obs x 3)

tag_grid <-
  filter_tags %>% 
  filter(!is.na(tag1)) %>%
  filter(tag1 %in% filter_table$tag1) %>%  # keep only the tags we want
  mutate(tag2 = tag1) %>%
  group_by(indcode) %>%
  expand(nesting(indname, indcode, tag1), tag2) %>% # generate all iterations
  add_count() %>% # add count of n in each group as col
  mutate(same = if_else((tag1 == tag2) & (n > 1), # if tag is same in tag1 and tag2 and more than 1 pergroup
                        true = TRUE, false = FALSE)) %>%  #generate same variable
  filter(same == FALSE) %>%  # remove duplicate tags in tag1 and tag2
  left_join(filter_table, by = "tag1", na_matches = "never") %>% # merge to names for tag1
  rename(tag1_name = desc) %>% # rename desc col
  left_join(filter_table, by = c("tag2"="tag1"), na_matches = "never") %>% # for tag2
  rename(tag2_name = desc) %>% # rename desc col
  select(-c(n, same)) # remove n and same cols
  
# check to make sure we didn't lose indicators 
assert_that(n_distinct(tag_grid$indcode) + 1
            == n_distinct(names_all$indcode)) # All but 1 indicator kept (TOTL)
  



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

# rescale 'value' to have 1 as midpoint (1 indicates global average)
  wwbi_hmp <- wwbi_hmp %>%
  mutate(
    value_scl = rescale_mid(wwbi_hmp$value, to = c(0,2), mid = 1)
    
  )





                                #    Export     # ----


save.image(file = file.path(wwbi_dat, "wwbi-tbls.Rdata"))
