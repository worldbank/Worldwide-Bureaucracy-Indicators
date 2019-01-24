
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
  
  output$display_publicemp <- reactive({
    if (input$selected_country != "") {
      !is.na(wwbi$ps1[wwbi$countryname == input$selected_country]) |
        !is.na(wwbi$age_mean_1[wwbi$countryname == input$selected_country]) |
        !is.na(wwbi$female_1[wwbi$countryname == input$selected_country]) |
        !is.na(wwbi$ed3_1[wwbi$countryname == input$selected_country])  
    }
  })
  
  output$wagebill1 <- 
      renderPlotly({
        if (input$selected_country == "") {
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
        } else {
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
        
        ggplotly(wb_gdp_plot,
                 tooltip = "text")
    })

    
  output$wagebill2 <-
    renderPlotly({
      if (input$selected_country == "") {
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
      } else {
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
      
      ggplotly(wb_exp_plot,
               tooltip = "text")
      
    })
  
  output$publicemp1 <- 
    renderPlotly({

      if (input$selected_country == "") {
        wb_emp_plot <-
          ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = ps1*100), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = ps1*100,
                         color = region)) +
          ylab("Public employment (%)") + xlab("Log of GDP per capita") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      } else {
        wb_emp_plot <- 
          ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = ps1*100), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = ps1*100,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = lngdppc ,
                         y = ps1*100),
                     color = "red", size=3) +
          ylab("Public employment (%)") + xlab("Log of GDP per capita") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      }
      
      ggplotly(wb_emp_plot)
      
    })

  output$publicemp2 <- 
    renderPlotly({
      
      if (input$selected_country == "") {
        wb_age_plot <- 
          ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = age_mean_1 ,
                         y = age_mean_0,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = age_mean_1 ,
                         y = age_mean_0),
                     color = "red", size=3) +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      } else {
        wb_age_plot <- 
          ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = age_mean_1 ,
                         y = age_mean_0,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = age_mean_1 ,
                         y = age_mean_0),
                     color = "red", size=3) +
          geom_label_repel(data = wwbi[wwbi$countryname == input$selected_country, ],
                           aes(x = age_mean_1 ,
                               y = age_mean_0, 
                               label=paste0(countryname, "(",round(age_mean_1, 0), "," ,round(age_mean_0, 0),")")),
                           color = "red") +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      }
      
      ggplotly(wb_age_plot)
      
    })
  
  output$publicemp3 <- 
    renderPlotly({
      
      if (input$selected_country == "") {
        wb_gender_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = female_1*100 ,
                         y = female_0*100,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = female_1*100 ,
                         y = female_0*100),
                     color = "red", size=3) +
                   ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      } else {
        wb_gender_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = female_1*100 ,
                         y = female_0*100,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = female_1*100 ,
                         y = female_0*100),
                     color = "red", size=3) +
          geom_label_repel(data = wwbi[wwbi$countryname == input$selected_country, ],
                           aes(x = female_1*100 ,
                               y = female_0*100, 
                               label=paste0(countryname, "(",round(female_1*100, 0), "," ,round(female_0*100, 0),")")),
                           color = "red") +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme

      }
      
      ggplotly(wb_gender_plot)
      
    })
  
  output$publicemp4 <- 
    renderPlotly({
      
      if (input$selected_country == "") {
        wb_edu_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = ed3_1*100 ,
                         y = ed3_0*100,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = ed3_1*100 ,
                         y = ed3_0*100),
                     color = "red", size=3) +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      } else {
        wb_edu_plot<-ggplot() +
          geom_abline(color="grey", linetype="dashed")  +
          geom_point(data = wwbi,
                     aes(x = ed3_1*100 ,
                         y = ed3_0*100,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = ed3_1*100 ,
                         y = ed3_0*100),
                     color = "red", size=3) +
          geom_label_repel(data = wwbi[wwbi$countryname == input$selected_country, ],
                           aes(x = ed3_1*100 ,
                               y = ed3_0*100, 
                               label=paste0(countryname, "(",round(ed3_1*100, 0), "," ,round(ed3_0*100, 0),")")),
                           color = "red") +
          ylab("Private sector") + xlab("Public sector") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      }
      
      ggplotly(wb_edu_plot)
      
    })
  
  output$wage <- 
    renderPlotly({
      data <- wwbi[wwbi$countryname != "Thailand", ]
      
      if (input$selected_country == "") {
        wb_premium_plot<- ggplot() +
          geom_smooth(data = data,
                      aes(x = lngdppc ,
                          y = coefreg), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_hline(yintercept =0) +
          geom_point(data = data,
                     aes(x = lngdppc ,
                         y = coefreg,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = lngdppc,
                         y = coefreg),
                     color = "red", size=3) +
          ylab("Wage premium (%)") + xlab("Log of GDP per capita") +
          ggtitle("Public sector wage premium") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      } else {
        wb_premium_plot<- ggplot() +
          geom_smooth(data = data,
                      aes(x = lngdppc ,
                          y = coefreg), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_hline(yintercept =0) +
          geom_point(data = data,
                     aes(x = lngdppc ,
                         y = coefreg,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == input$selected_country, ],
                     aes(x = lngdppc,
                         y = coefreg),
                     color = "red", size=3) +
          geom_label_repel(data = wwbi[wwbi$countryname == input$selected_country, ],
                           aes(x = lngdppc ,
                               y = coefreg, 
                               label=paste0(countryname, ":",round(coefreg, 2))),
                           color = "red") +
          ylab("Wage premium") + xlab("Log of GDP per capita") +
          ggtitle("Public sector wage premium") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
      }
      
      ggplotly(wb_premium_plot)
      
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
  outputOptions(output, "display_wagebill", suspendWhenHidden = FALSE)
  outputOptions(output, "display_publicemp", suspendWhenHidden = FALSE)
  
}