require(shinydashboard)
require(shiny)
require(plotly)

wwbi <- read.csv("data.csv", header = T,stringsAsFactors = F)


ui <- navbarPage("Worldwide Bureaucracy Indicators",
                 id = "nav",
                 
# Community level #######################################################################################
  
  tabPanel("Country Profile",
      dashboardPage(
        
        header <- dashboardHeader(disable = T
        ),
        
        # Controls =================================================================================
        
        dashboardSidebar(
          sidebarMenu(
            column(12,
                   fluidRow(
                     selectInput("selected_country",
                                 "Select country:",
                                 choices = c("", as.character(wwbi$countryname)))
                   ),
                   fluidRow(align = "center",
                     conditionalPanel(
                       condition = "output.display_report",
                       downloadButton("report",
                                      "Download report"))
                   )
              )
            )
        ),
        
        # Results ==========================================================================================
        body <- dashboardBody(
          conditionalPanel(
            condition = "output.display_report",
            tabsetPanel(type = "tabs",
                        tabPanel("Wage bill",
                                 plotlyOutput("wagebill1"),
                                 plotlyOutput("wagebill2")
                        )
            )
          )
        )
    )
  )
)
