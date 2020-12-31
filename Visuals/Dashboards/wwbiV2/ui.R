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
library(shiny)
library(sf)
library(rjson)
library(leaflet)
library(RColorBrewer)
library(htmltools)
library(tidyverse)
library(lubridate)
library(mapview)
library(leafpop)


# setup ----


## load indicator names data only
#names <- readRDS("data/names.Rda")

load("data/ui-data.Rdata")

## define dropdown choices
# mapfill.choices <- 
#   c("GDP Per Capita" = "gdp_pc2017",
#     "Females, as a share of public paid employees" = "BI.PWK.PUBS.FE.ZS"
#   )

# filter choices 



choices       <- setNames(names_all$indcode, names_all$indname)
filterChoices <- setNames(filter_table$tag1, filter_table$desc) 


## define wellPanel options





#       -           -       -     -   -   -   UI - - - ---- 
shinyUI(
  navbarPage( "WWBI Data Explorer",
    tabPanel("Map",
             
      #  tags$style(type = 'text/css', 'html, body {width:100%;height:100%}'),
     #   verbatimTextOutput('list'),
      

      # map   
      leafletOutput('map', height = '800px', width = '100%'),
      
      # panel select, inside dropdown button
     
        
      
      absolutePanel(
        
        
        ## panel settings
        left = 20, bottom = 30, draggable = TRUE, 
        wellPanel(
         style = "background: #ffffff; opacity: 0.8",
         
         
         # clickplot
         ## title 
         # make the title render based on input text
         #textOutput('title'),
         conditionalPanel(
           condition = "input.plot == true",
           plotOutput('clickplot', height = 150, width = 180)
         ),
         tags$br(),
         # setup dropdown menu
         dropdown(
           size = 'md',
           icon = icon("gear"),
           label = "Map Settings",
           tooltip = "Adjust Map Settings",
           right = FALSE,
           up = TRUE,
           width = '350px',
           

          
        
        
          
        # contents of panel
        tags$h4(tags$b("Map Fill")),
        helpText("Select an indicator",
                 "or refine by category"),
        
        ## filter
        selectizeGroupUI(
          id = 'my-filters',
          inline = FALSE,
          btn_label = "Reset",
          params = list(
            var_one = list(
              inputId = "tag1_name", title = "", placeholder = "Filter 1"
            ),
            var_two = list(
              inputId = "tag2_name", title = "", placeholder = "Filter 2"
            )
            
          )
        ),
        tags$br(),
        
        pickerInput(
          'in.mapfill', "Map Fill Indicator",
          choices = setNames(names_all$indcode, names_all$indname), # formerly choices
          selected = "BI.WAG.TOTL.GD.ZS",
          multiple = FALSE,
          width = '300px',
          options = list(`live-search` = TRUE, `mobile` = FALSE,
                         `dropupAuto` = TRUE, `size` = 10, `select-On-Tab` = T)
        ),
        tags$br(),
        
        tags$h4(tags$b("Year")),
        switchInput('recent', "", TRUE, offLabel = "Specific Year", onLabel = "Most Recent", size = 'small'),
        
        conditionalPanel(
          condition = "input.recent == false",
          sliderInput(
            'in.year', "Select Year",
            width = '180px',
            min = wwbiMinYr,
            max = wwbiMaxYr,
            value = 2017,
            sep = "",
            step = 1)
        ),
        
        tags$h4(tags$b("Options")),
        
        materialSwitch("plot", "Show Plot",status = 'primary', TRUE, right = T),
        materialSwitch("legend", "Show Legend",status = 'primary', TRUE, right = T),
        
        downloadButton('dl', "Download Current Map")
        
      ))) # end absolute panel; wellpanel; dropdown button
      
             
             
    
             
             
             
    ), # end boostrap page / Map panel,
    
    tabPanel("table"
             
            ), # end data table page 
    
    
    
    tabPanel("Comparison",
      
      sidebarLayout(
        sidebarPanel(
          
          pickerInput('comp.country',
                      label = "Select up to 5 countries or economies",
                      choices = ctynames,
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
