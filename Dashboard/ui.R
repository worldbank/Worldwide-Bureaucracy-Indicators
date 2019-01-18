
library(markdown)

wwbi <- read.csv("data.csv", header = T,stringsAsFactors = F)

ui <- fluidPage(
  
  # App title ----
  titlePanel("Worldwide Bureaucracy Indicators"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      selectInput("selected_country", "Select country:",
                  choices = c(as.character(wwbi$countryname)))

    ),
    
    downloadButton("report", "Generate report")
  )
)
