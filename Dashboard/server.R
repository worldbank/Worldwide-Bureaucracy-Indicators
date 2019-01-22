
library(markdown)
library(ggplot2)
library(ggrepel)
library(viridis)
library(plotly)
library(gridExtra)
library(knitr)

wwbi <- read.csv("data.csv", header = T,stringsAsFactors = F)
my_theme <- theme_classic() +
  theme(legend.position = "bottom",
        legend.title = (element_blank()),
        plot.title = element_text(hjust = .5))

server = function(input, output, session) {
  
  output$display_report <- reactive({
    input$selected_country != ""
  })
  
  output$display_wagebill <- reactive({
    if (input$selected_country != "") {
      !is.na(wwbi$wage_gdp[wwbi$countryname == input$selected_country]) |
        !is.na(wwbi$wage_x[wwbi$countryname == input$selected_country])  
    }
  })
  
  output$wagebill1 <- 
      renderPlotly({
        wb_gdp_plot <- ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = wage_gdp), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = wage_gdp,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = lngdppc ,
                         y = wage_gdp),
                     color = "red", size=3) +
          ylab("Wage bill(%)") + xlab("Log of GDP per capita") +
          ggtitle("Wage bill as % of GDP") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        
        ggplotly(wb_gdp_plot)
      }
    )
  
  output$wagebill2 <-
    renderPlotly({
      wb_exp_plot <-
        ggplot() +
        geom_smooth(data = wwbi,
                    aes(x = lngdppc ,
                        y = wage_x), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
        geom_point(data = wwbi,
                   aes(x = lngdppc ,
                       y = wage_x,
                       color = region)) +
        geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                   aes(x = lngdppc ,
                       y = wage_x),
                   color = "red", size=3) +
        ylab("Wage bill(%)") + xlab("Log of GDP per capita") +
        ggtitle("Wage bill as % of expenditures") +
        scale_color_viridis(discrete=TRUE)+
        my_theme

      ggplotly(wb_exp_plot)
    }
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
                        knit_root_dir = getwd()
      )
    }
  )
  
  outputOptions(output, "display_report", suspendWhenHidden = FALSE)
  outputOptions(output, "display_wagebill", suspendWhenHidden = FALSE)
}