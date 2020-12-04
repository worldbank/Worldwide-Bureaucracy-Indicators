# main-coffee.R
# Runs the Coffee Shiny app for WWBI visualziation demos 

library(tidyverse)
library(plotly)
library(shiny)



# Paths

worldjson <-
  "C:/Users/WB551206/OneDrive - WBG/Documents/WB_data/names+boundaries/WB_Boundaries_GeoJSON_lowres/WB_Adm0_boundary_lines_10m_lowres.geojson"



# Run app 
shiny::runApp('jsVisualizations/scripts/shiny/coffee/wwbi-coffee')