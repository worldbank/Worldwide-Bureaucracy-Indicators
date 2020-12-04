# main-coffee.R
# Runs the Coffee Shiny app for WWBI visualziation demos 

library(tidyverse)
library(plotly)
library(shiny)

# Run app 
shiny::runApp('jsVisualizations/scripts/shiny/coffee/wwbi-coffee')