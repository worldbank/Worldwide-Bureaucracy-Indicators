# coffee-tidy.R
# prepares data for app

library(sf)
library(rjson)
library(leaflet)

# import world json ----
#world <- rjson::fromJSON(file = worldjson)
## define key variables (keep only English Names for now) 
worldVars <- c("FID",       "OBJECTID",  "featurecla","LEVEL",     "TYPE",      "FORMAL_EN",
              "FORMAL_FR", "POP_EST",   "POP_RANK",  "GDP_MD_EST","POP_YEAR",  "LASTCENSUS",
              "GDP_YEAR",  "ECONOMY",   "INCOME_GRP","FIPS_10_",  "ISO_A2",    "ISO_A3",   
              "ISO_A3_EH", "ISO_N3",    "UN_A3",     "WB_A2",     "WB_A3",     "CONTINENT",
              "REGION_UN", "SUBREGION", "REGION_WB", "NAME_EN",  
              "WB_NAME",   "WB_RULES",  "WB_REGION", "Shape_Leng","Shape_Area","geometry")

world_sf_raw <- st_read(worldjson)

world_sf     <-
  world_sf_raw %>%
  select(worldVars)  


# inside server ----

m <- leaflet(data = world_sf) %>%
  addTiles() %>%
  addPolygons()

m




plot_ly() %>%
  add_trace(
    type = 'choropleth',
    geojson = world
  )
