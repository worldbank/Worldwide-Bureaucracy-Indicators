
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
  
  output$wagebill1 <- 
      renderPlotly({
        
        wb_gdp_plot <- ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = wage_gdp), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = wage_gdp,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                      "<br> GDP (log): ", round(wwbi$lngdppc,2),
                                      "<br> Wage bill: ", round(wwbi$wage_gdp,2), "%"))) +
          ylab("Wage bill (%)") + xlab("Log of GDP per capita") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        
        if (input$selected_country != "") {
          if (!is.na(wwbi$wage_gdp[wwbi$countryname == input$selected_country])) {
          
          wb_gdp_plot <- ggplot() +
            geom_smooth(data = wwbi,
                        aes(x = lngdppc ,
                            y = wage_gdp), 
                        method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
            geom_point(data = wwbi,
                       aes(x = lngdppc ,
                           y = wage_gdp,
                           color = region,
                           text = paste0(" Country: ", wwbi$countryname,
                                        "<br> GDP (log): ", round(wwbi$lngdppc,2),
                                        "<br> Wage bill: ", round(wwbi$wage_gdp,2), "%"))) +
            geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                       aes(x = lngdppc ,
                           y = wage_gdp),
                       color = "red", size=3) +
            ylab("Wage bill (%)") + xlab("Log of GDP per capita") +
            scale_color_viridis(discrete=TRUE)+
            my_theme
          
          }
        }
        
        ggplotly(wb_gdp_plot,
                 tooltip = "text")
    })

    
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
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> Expenditure (log): ", round(wwbi$wage_x,2),
                                       "<br> Wage bill: ", round(wwbi$lngdppc,2), "%"))) +
          ylab("Wage bill (%)") + xlab("Expenditure (log)") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        
        if (input$selected_country != "") {
          if (!is.na(wwbi$wage_x[wwbi$countryname == input$selected_country])) {
            
            wb_exp_plot <-
              ggplot() +
              geom_smooth(data = wwbi,
                          aes(x = lngdppc ,
                              y = wage_x), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
              geom_point(data = wwbi,
                         aes(x = lngdppc ,
                             y = wage_x,
                             color = region,
                             text = paste0(" Country: ", wwbi$countryname,
                                           "<br> Expenditure (log): ", round(wwbi$wage_x,2),
                                           "<br> Wage bill: ", round(wwbi$lngdppc,2), "%"))) +
              geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                         aes(x = lngdppc,
                             y = wage_x),
                         color = "red", size=3) +
              ylab("Wage bill (%)") + xlab("Expenditure (log)") +
              scale_color_viridis(discrete=TRUE)+
              my_theme
          }
      }
      
      ggplotly(wb_exp_plot,
               tooltip = "text")
      
    })
  
  output$publicemp1 <- 
    renderPlotly({

      
      wb_emp_plot <-
          ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = ps1*100), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = ps1*100,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> GDP per capita (log): ", round(wwbi$lngdppc,2),
                                       "<br> Public employment: ", round(wwbi$ps1*100,2), "%"))) +
          ylab("Public employment (%)") + xlab("Log of GDP per capita") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      
      if (input$selected_country != "") {
        if (!is.na(wwbi$ps1[wwbi$countryname == input$selected_country])) {
          
        wb_emp_plot <- 
          ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = ps1*100), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = ps1*100,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> GDP per capita (log): ", round(wwbi$lngdppc,2),
                                       "<br> Public employment: ", round(wwbi$ps1*100,2), "%"))) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = lngdppc ,
                         y = ps1*100),
                     color = "red", size=3) +
          ylab("Public employment (%)") + xlab("Log of GDP per capita") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        }
      }
      
      ggplotly(wb_emp_plot,
               tooltip = "text")
      
    })

  output$publicemp2 <- 
    renderPlotly({
      
        wb_age_plot <- 
          ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = age_mean_1 ,
                         y = age_mean_0,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> Public sector: ", round(wwbi$age_mean_1,2),
                                       "<br> Private sector: ", round(wwbi$age_mean_0,2)))) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = age_mean_1 ,
                         y = age_mean_0),
                     color = "red", size=3) +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        
        if (input$selected_country != "") {
          if (!is.na(wwbi$age_mean_1[wwbi$countryname == input$selected_country])) {
            
        wb_age_plot <- 
          ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = age_mean_1 ,
                         y = age_mean_0,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> Public sector: ", round(wwbi$age_mean_1,2),
                                       "<br> Private sector: ", round(wwbi$age_mean_0,2)))) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = age_mean_1 ,
                         y = age_mean_0),
                     color = "red", size=3) +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        }
      }
      
      ggplotly(wb_age_plot,
               tooltip = "text")
      
    })
  
  output$publicemp3 <- 
    renderPlotly({
      
        wb_gender_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = female_1*100 ,
                         y = female_0*100,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> Public sector: ", round(wwbi$female_1*100,2), "%",
                                       "<br> Private sector: ", round(wwbi$female_0*100,2), "%"))) +
                   ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
     
        if (input$selected_country != "") {
          if (!is.na(wwbi$female_1[wwbi$countryname == input$selected_country])) {
            
        wb_gender_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = female_1*100 ,
                         y = female_0*100,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> Public sector: ", round(wwbi$female_1*100,2), "%",
                                       "<br> Private sector: ", round(wwbi$female_0*100,2), "%"))) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = female_1*100 ,
                         y = female_0*100),
                     color = "red", size=3) +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        
        }
      }
      
      ggplotly(wb_gender_plot,
               tooltip = "text")
      
    })
  
  output$publicemp4 <- 
    renderPlotly({
      
      wb_edu_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = ed3_1*100 ,
                         y = ed3_0*100,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> Public sector: ", round(wwbi$ed3_1*100,2), "%",
                                       "<br> Private sector: ", round(wwbi$ed3_0*100,2), "%"))) +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      
      
      if (input$selected_country != "") {
        if (!is.na(wwbi$ed3_1[wwbi$countryname == input$selected_country])) {
          
        wb_edu_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = ed3_1*100 ,
                         y = ed3_0*100,
                         color = region,
                         text = paste0(" Country: ", wwbi$countryname,
                                       "<br> Public sector: ", round(wwbi$ed3_1*100,2), "%",
                                       "<br> Private sector: ", round(wwbi$ed3_0*100,2), "%"))) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = ed3_1*100 ,
                         y = ed3_0*100),
                     color = "red", size=3) +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
        }
      }
      
      ggplotly(wb_edu_plot,
               tooltip = "text")
      
    })
  
  output$wage <- 
    renderPlotly({
      data <- wwbi[wwbi$countryname != "Thailand", ]
      
        wb_premium_plot<- ggplot() +
          geom_smooth(data = data,
                      aes(x = lngdppc ,
                          y = coefreg), method='lm', formula=y~x, se=FALSE, color="grey", linetype="dashed") +
          geom_hline(yintercept = 0,
                     linetype ="dotted") +
          geom_point(data = data,
                     aes(x = lngdppc ,
                         y = coefreg,
                         color = region,
                         text = paste0(" Country: ", data$countryname,
                                       "<br> Wage premium: ", round(coefreg,2), "%",
                                       "<br> GDP per capita (log): ", round(data$lngdppc,2)))) +
          ylab("Wage premium (%)") + xlab("Log of GDP per capita") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
     
    
    if (input$selected_country != "") {
      if (!is.na(wwbi$coefreg[wwbi$countryname == input$selected_country])) {
        
        wb_premium_plot<- ggplot() +
          geom_smooth(data = data,
                      aes(x = lngdppc ,
                          y = coefreg), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_hline(yintercept =0) +
          geom_point(data = data,
                     aes(x = lngdppc ,
                         y = coefreg,
                         color = region,
                         text = paste0(" Country: ", data$countryname,
                                       "<br> Wage premium: ", round(coefreg,2), "%",
                                       "<br> GDP per capita (log): ", round(data$lngdppc,2)))) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = lngdppc,
                         y = coefreg),
                     color = "red", size=3) +
          ylab("Wage premium") + xlab("Log of GDP per capita") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      }
      }
      
      ggplotly(wb_premium_plot,
               tooltip = "text")
      
    })
  

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

}