# main-coffee.R
# Runs the Coffee Shiny app for WWBI visualziation demos 

library(tidyverse)
library(plotly)
library(shiny)



# Paths

cafe <- file.path(repo, "shiny/coffee/wwbi-coffee")

worldjson <-
  "C:/Users/WB551206/OneDrive - WBG/Documents/WB_data/names+boundaries/WB_Boundaries_GeoJSON_lowres/WB_countries_Admin0_lowres.geojson"

# prepare the coffee
coffee.tidy = 1 
run         = 0 




if (coffee.tidy == 1 ) {
  source(file.path(cafe, "coffee-tidy.R"))
}

# Run app 
if (run == 1) {
shiny::runApp('jsVisualizations/scripts/shiny/coffee/wwbi-coffee')
}
