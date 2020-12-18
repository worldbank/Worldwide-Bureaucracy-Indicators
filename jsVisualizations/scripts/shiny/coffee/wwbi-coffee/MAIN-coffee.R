# main-coffee.R
# Runs the Coffee Shiny app for WWBI visualziation demos 

library(tidyverse)
library(plotly)
library(shiny)



# Paths

cafe <- file.path(repo, "shiny/coffee/wwbi-coffee")

worldjson <-
  file.path(wwbi_dat, "WB_Boundaries_GeoJSON_lowres/WB_countries_Admin0_lowres.geojson")

# prepare the coffee
coffee.tidy = 1 
run         = 1 




if (coffee.tidy == 1 ) {
  source(file.path(cafe, "coffee-tidy.R"))
}

# Run app 
if (run == 1) {
shiny::runApp('jsVisualizations/scripts/shiny/coffee/wwbi-coffee')
}
