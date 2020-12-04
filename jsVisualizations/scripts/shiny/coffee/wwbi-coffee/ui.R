#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage( "Coffee Table",
    tabPanel("Map",

      plotlyOutput('map', height = 'auto', width = '100%')
      
             
             
    
             
             
             
    ) # end Map panel
  )) # end navbarPage / UI
