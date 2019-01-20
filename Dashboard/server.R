
library(markdown)
library(ggplot2)
library(ggrepel)
library(viridis)
library(plotly)
library(gridExtra)
library(knitr)

wwbi <- read.csv("data.csv", header = T,stringsAsFactors = F)

server = function(input, output, session) {
  
  output$display_report <- reactive({
    input$selected_country != ""
  })

  output$display <- renderUI(
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, 
                        output_format = "html_document",
                        params = list(selected_country = input$selected_country),
                        envir = new.env(parent = globalenv()),
                        knit_root_dir = "C:/Users/WB501238/Documents/GitHub/Worldwide-Bureaucracy-Indicators/Dashboard"
      )
  )
  

  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = paste0(input$selected_country,"bureaucracy-profile.pdf"),
    
    content = function(file) {
      # Copy the report file to a temporary directory before processing it, in
      # case we don't have write permissions to the current working dir (which
      # can happen when deployed).
      tempReport <- file.path(tempdir(), "report.Rmd")
      file.copy("report.Rmd", tempReport, overwrite = TRUE)
      
      # Set up parameters to pass to Rmd document
      params <- list(selected_country = input$selected_country)
      
      # Knit the document, passing in the `params` list, and eval it in a
      # child of the global environment (this isolates the code in the document
      # from the code in this app).
      rmarkdown::render(tempReport, output_file = file,
                        params = params,
                        envir = new.env(parent = globalenv()),
                        knit_root_dir = "C:/Users/WB501238/Documents/GitHub/Worldwide-Bureaucracy-Indicators/Dashboard"
      )
    }
  )
  
  outputOptions(output, "display_report", suspendWhenHidden = FALSE)
}