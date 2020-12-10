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

# if (input$debug) {
#   browser()
# }


# setup ----

## load data
load("data.Rdata")

## define varlist of keyvars to keep 
keepvars <- c("ctycode", "ctyname", "year",
              "iso2c", "country", "gdp_pc2017",
              "iso3c", "region", "income",
              "lending", "ln_gdp", "lnTotEmp")

#       -           -       -     -   -   -   SERVER - - - ---- 
shinyServer(function(input, output) {

    # reactive values ----
  year <- reactive({input$in.year})
  
  mapfill <- reactive({ input$in.mapfill })
  
  
  
  #### Data control ----
  # filter dataset by year 
  data_yr <- reactive({
    yr <- 
      wwbi_geo %>%
      filter(year == 2017 )
  }) 
  
  # most recent dataset yet 
  data_rcnt <- reactive({
      wwbi_geo %>%
      select(keepvars, input$in.mapfill ) %>% 
      filter(is.na(eval(as.symbol(input$in.mapfill))) == FALSE) %>%   # remove missing values for variable 
      arrange(ctycode, -year) %>% # arrnage by country and year descending
      group_by(ctycode) %>%
      filter(row_number() == 1)
  })
  
  
  # data switch
  data <- reactive({
    if (input$recent) {
      data <- data_rcnt()
    } else {
      data <- data_yr()
    }
    
    return(data)
    
  })
  
    
  
  
  # color palette ----
  colorpal <- reactive({
    colorNumeric("YlOrRd", NULL)
  })
  

     
  # map ----
  output$map <- renderLeaflet({
    
    ## build base map base
      leaflet(data = wwbi_geo_shp ) %>% # use the obejct that contains just the boundary files
      setView(zoom = 2, lat = 0, lng = 0) %>%
      addTiles() 
     
  })
  
  
  
  
  
  # for incremental changes to map
  observe({
    pal <- colorpal()
    
    leafletProxy("map", data = data()) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(eval(as.symbol(input$in.mapfill))), fillOpacity = 0.8,
                  weight = 1, 
                  label = ~paste0(ctyname, 
                                  prettyNum(round(eval(as.symbol(input$in.mapfill))),
                                            big.mark = ',')  ))
    
  })
  
  
  # for incremental changes to legend 
  observe({
    proxy <- leafletProxy('map', data = data())
    
    proxy %>% clearControls()
      
     if (input$legend) {
        pal <- colorpal()
        proxy %>% addLegend(position = 'bottomright',
                            pal = pal,
                            values = ~eval(as.symbol(input$in.mapfill)),
                            title = ~as.character(input$in.mapfill)
                            )
        
     }
    
  })
  
  
  # render table
  output$data <- renderDataTable(data() %>% st_drop_geometry() )
  
  
  
})


