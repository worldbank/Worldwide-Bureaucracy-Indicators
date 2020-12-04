#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(sf)
library(rjson)
library(leaflet)
library(RColorBrewer)
library(htmltools)
library(tidyverse)
library(lubridate)



# setup ----

## load data
load("data.Rdata")

## define color pallette 
pal <- colorBin("YlOrRd", domain = wwbi_geo$gdp_pc2017,
                bins = c(0, 5000, 10000, 20000, 30000, 40000, Inf))






#       -           -       -     -   -   -   SERVER - - - ---- 
shinyServer(function(input, output) {
  
  # reactive values ----
  year <- reactive({})
  
  
   
  output$map <- renderLeaflet({

    ## build map base
    wwbi_geo %>%
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
    
  })
  
})
