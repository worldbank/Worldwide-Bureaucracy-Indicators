require(shinydashboard)
require(shiny)
require(plotly)

wwbi <- read.csv("data.csv", header = T,stringsAsFactors = F)


ui <- dashboardPage(
  dashboardHeader(
    title = "Worldwide Bureaucracy Indicators",
    titleWidth = 350),
  
  dashboardSidebar(
    width = 350,
    sidebarMenu(
      menuItem("Wage bill",
               tabName = "wagebill"),
      menuItem("Public employment",
               tabName = "publicemp"),
      menuItem("Wage premium",
               tabName = "wage"),
      selectInput("selected_country",
                  "Select country:",
                  choices = c("", as.character(wwbi$countryname))),
      fluidRow(align = "center",
               conditionalPanel(
                 condition = "output.display_report",
                 downloadButton("report",
                                "Download report")
               )
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "wagebill",
              fluidRow(
                box(title = "Wage bill as share of GDP",
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput("wagebill1")),
                box(title = "Wage bill as share of expenditures",
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput("wagebill2"))
              )
      ),
      
      # Second tab content
      tabItem(tabName = "publicemp",
              fluidRow(
                box(title = "Public employment as share of wage employment (%)",
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput("publicemp1")),
                box(title = "Mean age of employees",
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput("publicemp2"))
              ),
              fluidRow(
                box(title = "Share of female employees (%)",
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput("publicemp3")),
                box(title = "Share of employees of tertiary education (%)",
                    status = "primary",
                    solidHeader = TRUE,
                    plotlyOutput("publicemp4"))
              )
      ),
    
      # Third tab content
      tabItem(tabName = "wage",
              box(title = "Public sector wage premium",
                  status = "primary",
                  solidHeader = TRUE,
                  width = "50%", 
                  align = "center",
                  plotlyOutput("wage", 
                               width = "70%"))
      )
    )
  )
)