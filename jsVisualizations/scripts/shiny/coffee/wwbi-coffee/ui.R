#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


# setup 
mapfill.choices <- 
  c("GDP Per Capita" = "gdp_pc2017",
    "Females, as a share of public paid employees" = "BI.PWK.PUBS.FE.ZS"
    )

choices <- setNames(names_all$indcode, names_all$indname)



#       -           -       -     -   -   -   UI - - - ---- 
shinyUI(
  navbarPage( "Coffee Table",
    tabPanel("Map",
             
      #  tags$style(type = 'text/css', 'html, body {width:100%;height:100%}'),
        
      # map   
      leafletOutput('map', height = '800px', width = '100%'),
      
      # panel select
      absolutePanel(
        ## panel settings
        right = 30, top = 80,
        draggable = TRUE,
        
        
        # contents of panel
        checkboxInput('recent', "Use most recent year", TRUE),
        sliderInput(
          'in.year',
          "Select Specific Year",
          min = min(wwbi_geo$year),
          max = max(wwbi_geo$year),
          value = 2017,
          sep = "",
          step = 1),
        
        selectInput(
          'in.mapfill',
          "Fill Variable",
          choices = choices,
          selected = "BI.WAG.TOTL.GD.ZS",
          multiple = FALSE,
          width = '250px'
        ),
        
        checkboxInput("legend", "Show Legend", TRUE)
        
      ) # end absolute panel
      
             
             
    
             
             
             
    ), # end boostrap page / Map panel,
    
    tabPanel("table",
             
             dataTableOutput('data')
             )
    
    
  )) # end navbarPage / UI
