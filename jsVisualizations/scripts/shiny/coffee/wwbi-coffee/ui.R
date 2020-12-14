#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(plotly)

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
        left = 20, bottom = 20, draggable = TRUE, 
        wellPanel(
          style = "opacity: 0.80",
        
        
        # contents of panel
        tags$h4(tags$b("Fill Variable")),
        
        pickerInput(
          'in.mapfill',
          choices = choices,
          selected = "BI.WAG.TOTL.GD.ZS",
          multiple = FALSE,
          width = 'fit',
          options = list(`live-search` = TRUE, `mobile` = FALSE)
        ),
        
        tags$h4(tags$b("Year")),
        switchInput('recent', "", TRUE, offLabel = "Specific Year", onLabel = "Most Recent", size = 'small'),
        
        #tags$h5("Select Year"),
        conditionalPanel(
          condition = "input.recent == false",
          sliderInput(
            'in.year', "Select Year",
            width = '180px',
            min = min(wwbi_geo$year),
            max = max(wwbi_geo$year),
            value = 2017,
            sep = "",
            step = 1)
        ),
        
        tags$h4(tags$b("Options")),
        
        materialSwitch("plot", "Show Plot",status = 'primary', TRUE, right = T),
        materialSwitch("legend", "Show Legend",status = 'primary', TRUE, right = T)
        
      )) # end absolute panel; wellpanel
      
             
             
    
             
             
             
    ), # end boostrap page / Map panel,
    
    tabPanel("table",
             tags$h4("Future home of browsable WWBI data table"), tags$br() 
            # dataTableOutput()
             ), # end data table page 
    
    
    
    tabPanel("Comparison",
      
      sidebarLayout(
        sidebarPanel(
          
          pickerInput('comp.country',
                      label = "Select up to 5 countries or economies",
                      choices = wwbi_geo_shp$ctyname,
                      multiple = TRUE,
                      selected = c("Afghanistan", "Albania", "Angola"),
                      options = list(`live-search` = TRUE,
                                     `max-options` = 5,
                                     `mobile` = FALSE, 
                                     `actions-box` = TRUE)),
          
          radioGroupButtons('comp.c2',
                            "Graph 2: type of employment",
                            choices = c("Total Employment" = "BI.EMP.TOTL.PB.ZS",
                                        "Paid Employment" = "BI.EMP.PWRK.PB.ZS",
                                        "Formal Employment" = "BI.EMP.FRML.PB.ZS"))
          
          
        ), # end sidebar panel
        
        mainPanel(
        tags$h1("Public Sector Employment"), tags$br(),
          
          tags$h2("By Different Measures of Employment"),
        plotlyOutput("comp1", height = "500px"), tags$br(), tags$br(),
        tags$h2("By Country/Economy"),
        plotlyOutput("comp2", height = '500px')
        
        
      ))) #end sidebarlayout, main panel, country/economy panel
             

    
    
  )) # end navbarPage / UI
