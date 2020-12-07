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
             
            
      textOutput('text1'),
      textOutput('text2'),
      textOutput('text3'),
             
      leafletOutput('map', height = 600),
      
      # panel select
      absolutePanel(
        ## panel settings
        draggable = TRUE,
        
        
        # contents of panel
        sliderInput(
          'in.year',
          "Select Year",
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
        )
        
      ) # end absolute panel
      
             
             
    
             
             
             
    ) # end Map panel
  )) # end navbarPage / UI
