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
 # browser()
  # reactive values ----
  year <- reactive({input$in.year})
  
  mapfill <- reactive({ input$in.mapfill })
  
  
  # filter dataset by year 
  data <- reactive({
    wwbi_geo %>% filter(year == year() )
  }) 
  
  
  # color palette 
  colorpal <- reactive({
    colorNumeric("YlOrRd", NULL)
  })
  


  
   
  
  # output$text1 <- renderText( mapfill()  )
  # output$text2 <- renderPrint( mapfill() )
  # output$text3 <- renderPrint( pal() )
                  
   
  output$map <- renderLeaflet({
    
    ## build base map base
      leaflet(data = data()) %>%
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
  
  
})


