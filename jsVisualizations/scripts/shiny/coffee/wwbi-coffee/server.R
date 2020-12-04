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
# pal.old <- colorBin("YlOrRd", domain = wwbi_geo$gdp_pc2017,
#                 bins = c(0, 5000, 10000, 20000, 30000, 40000, Inf))



#       -           -       -     -   -   -   SERVER - - - ---- 
shinyServer(function(input, output) {
  
  # reactive values ----
  year <- reactive({input$in.year})
  
  mapfill <- reactive({input$in.mapfill})
  
  
  
  
  
  # define colorscheme/bins
  pal <- 
    colorBin(
          "YlOrRd",
          domain = wwbi_geo$BI.WAG.TOTL.GD.ZS,
          bins = 5,
          pretty = TRUE
        )
    
   
                  
                  
   
  output$map <- renderLeaflet({

    ## build map base
    wwbi_geo %>%
      filter(year == 2007 ) %>% # error: arguement lat is missing.
      leaflet(date = ) %>%
      addTiles() %>%
      setView(zoom = 3) %>%
      ## add fill
      addPolygons(
        fillColor = ~pal(BI.WAG.TOTL.GD.ZS),
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
        values = ~mapfill(),
        title = paste("GDP Per Capita,",
                      "<br>(2017 USD)")
      )
    
  })
  
})


