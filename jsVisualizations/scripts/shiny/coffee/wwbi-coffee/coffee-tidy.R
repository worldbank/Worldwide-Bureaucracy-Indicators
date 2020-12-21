# coffee-tidy.R
# prepares data for app

library(sf)
library(rjson)
library(leaflet)
library(RColorBrewer)
library(htmltools)
library(mapview)
library(leaflet)
library(leafpop)


                  # Import World Bank Admin0 Files ----


# import world json ----
#world <- rjson::fromJSON(file = worldjson)
## define key variables (keep only English Names for now) 
worldVars <- c("FID",       "OBJECTID",  "featurecla","LEVEL",     "TYPE",      "FORMAL_EN",
              "FORMAL_FR", "POP_EST",   "POP_RANK",  "GDP_MD_EST","POP_YEAR",  "LASTCENSUS",
              "GDP_YEAR",  "ECONOMY",   "INCOME_GRP","FIPS_10_",  "ISO_A2",    "ISO_A3",   
              "ISO_A3_EH", "ISO_N3",    "UN_A3",     "WB_A2",     "WB_A3",     "CONTINENT",
              "REGION_UN", "SUBREGION", "REGION_WB", "NAME_EN",  
              "WB_NAME",   "WB_RULES",  "WB_REGION", "Shape_Leng","Shape_Area","geometry")

keepvars <- c("ctycode", "ctyname", "year",
              "iso2c", "country", "gdp_pc2017",
              "iso3c", "region", "income",
              "lending", "ln_gdp", "lnTotEmp")

## make map dataframes
world_sf_raw <- st_read(worldjson)

world_sf     <-   # working version 
  world_sf_raw %>%
  select(worldVars)  

world_geo    <- world_sf %>%
  select("ISO_A3", "geometry")




                    # Merge with WWBI ----
                    
# import wwbi files from earlier code 
load(file = file.path(wwbi_dat, "wwbi-tbls.Rdata"))


# join using iso code 
wwbi_geo <-
  left_join(wwbi,
            world_geo,
            by = c('ctycode' = 'ISO_A3')) %>%
  st_as_sf()





                    # Additional Data manipulation ----


# create date variable for year 
wwbi_geo$year_dt <-
  as.Date(as.character(wwbi_geo$year),
                            format="%Y")


# add averages for world by indicator:
# strategry is to create tibbles of data for each world, region, lending, income
# catetory and append at end. 

## count the number of rows to avoid including newly created averages in following averages
wwbirows <- nrow(wwbi)

## World Averate
wwbi_worldav <- wwbi %>%
  dplyr::group_by(year) %>%
  summarize(.,
            across(where(is.numeric), ~mean(.x, na.rm = TRUE)),
            across(where(is.character), ~"World Average")) %>%
  mutate(avtype = "World Average", ctycode = "World Average")


## Region Average 
wwbi_regionav <- wwbi %>%
  dplyr::group_by(year, region) %>%
  summarize(.,
            across(where(is.numeric), ~mean(.x, na.rm = TRUE)),
            across(where(is.character), ~"Region Average"))%>%
  mutate(avtype = "Region Average")

## Lending Category AVerage 
wwbi_lendingav <- wwbi %>%
  dplyr::group_by(year, lending) %>%
  summarize(.,
            across(where(is.numeric), ~mean(.x, na.rm = TRUE)),
            across(where(is.character), ~"Lending Average"))%>%
  mutate(avtype = "Lending Group Average")


## income group average 
wwbi_incomeav <- wwbi %>%
  dplyr::group_by(year, income) %>%
  summarize(.,
            across(where(is.numeric), ~mean(.x, na.rm = TRUE)),
            across(where(is.character), ~"Income Average")) %>%
  mutate(avtype = "Income Group Average")

## append 
wwbi_av <- bind_rows(
  wwbi_worldav, wwbi_regionav, wwbi_lendingav, wwbi_incomeav
) %>%
  select(avtype, region, lending, income, everything())






# create min and max year values 
wwbiMinYr <- min(wwbi_geo$year)
wwbiMaxYr <- max(wwbi_geo$year)

# create country/economy name list 
ctynames <- unique(wwbi_geo$ctyname)




save(
  # final wwbi files
  wwbi_geo,
  wwbi_av,
  names_all,
  # world geo polygon files
  world_geo,
  world_sf,
  world_sf_raw,
  file = file.path(cafe, "data/data.Rdata")
)

save(names_all,
     ctynames,
     wwbiMinYr, wwbiMaxYr,
     file = file.path(cafe, "data/ui-data.Rdata"))


cols <- c("wage", "employment")
test <- names_all %>%
  filter(across(all_of(cols), ~ .x == FALSE))
