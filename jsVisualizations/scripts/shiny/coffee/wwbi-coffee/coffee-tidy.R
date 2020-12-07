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


# misc: create date variable for year 
wwbi_geo$year_dt <-
  as.Date(as.character(wwbi_geo$year),
                            format="%Y")



save(
  # final wwbi files
  wwbi_geo,
  wwbi,
  names_all,
  # world geo polygon files
  world_geo,
  world_sf,
  world_sf_raw,
  file = file.path(cafe, "data.Rdata")
)



# inside server ----

## define color pallette 
pal <- colorBin("YlOrRd", domain = wwbi_geo$gdp_pc2017,
                bins = c(0, 5000, 10000, 20000, 30000, 40000, Inf))

## build map base
m <- wwbi_geo %>%
  filter(year == 2017) %>%
  leaflet() %>%
  addTiles() %>%
## add fill
  addPolygons(
    fillColor = ~pal(gdp_pc2017),
    weight = 2,
    opacity = 1,
    color =  "white",
    dashArray = 1,
    fillOpacity = 0.8,
    label = ~ctyname
  ) %>%
## add legend 
  addLegend(
    pal = pal,
    position = "bottomright",
    na.label = "No Info",
    values = ~gdp_pc2017,
    title = paste("GDP Per Capita,",
                  "<br>(2017 USD)")
  )
m

colorNumeric(
  palette = "YlOrRd",
  domain = wwbi_geo$BI.WAG.PRVS.FM.SM # data()$mapfill()
)



"CartoDB.Positron"   "CartoDB.DarkMatter" "OpenStreetMap"     
[4] "Esri.WorldImagery"  "OpenTopoMap"

## try using mapview (sf)
wwbi_geo17 <- wwbi_geo %>%
  filter(year == 2017)

st_crs(wwbi_geo17)

mapview(
  wwbi_geo17,
  zcol = "gdp_pc2017")


mapviewOptions()


mapview(franconia)
