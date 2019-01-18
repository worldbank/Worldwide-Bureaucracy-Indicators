require(shinydashboard)
require(shiny)

wwbi <- read.csv("data.csv", header = T,stringsAsFactors = F)


ui <- navbarPage("Worldwide Bureaucracy Indicators",
                 id = "nav",
                 
# Community level #######################################################################################
  
  tabPanel("Report",
      dashboardPage(
        
        header <- dashboardHeader(disable = T
        ),
        
        # Controls =================================================================================
        
        dashboardSidebar(
          sidebarMenu(
            
            
            selectInput("selected_country", "Select country:",
                        choices = c(as.character(wwbi$countryname)))
            
          )
        ),
        
        # Results ==========================================================================================
        body <- dashboardBody(
          downloadButton("report", "Generate report")
        )
    )
  )
)
