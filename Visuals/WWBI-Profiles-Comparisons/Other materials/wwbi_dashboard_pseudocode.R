# 1 Set Initial configs ===============================================================

```{r, echo = F, include = F}

  # 1.1 Load packages --------------------------------------------------------------
  library(ggplot2)
  library(ggrepel)
  library(viridis)
  library(plotly)
  library(gridExtra)

  # 1.2 Create theme that will be used for graphs -----------------------------------
  my_theme <- theme_classic() +
    theme(legend.position = "bottom",
          legend.title = (element_blank()),
          plot.title = element_text(hjust = .5))

  # 1.3 Load the data ---------------------------------------------------------------
  
  FolderPath <- file.path("C:/Users/WB501238/Downloads")  
  
  # Load full data set
  full_data <- read.csv(file.path(FolderPath,"wwbi1109.csv"), header = T,
                   stringsAsFactors = F)
  
  # If the country selected is not Thailand, we will not consider it for plot 7,
  # It is an outlier and distorts the graph
  plot7_data <- subset(full_data, ccode!="THA")
  
  
# 2 Calculate section switches ======================================================
# Some countries will have missing variables. We need to know what variables we have
# so no empty sections will be displayed, and figures are correctly aligned
# ================================================================================= #
  
  # 2.1 Test if Wage bill section will be displayed and save that in an object ------
  
    # 2.1.1 Is the first plot going to be created? -----------------------------------
    wb_gdp <- !is.na()
    
    # 2.1.2 Is the second plot going to be created? ----------------------------------
    wb_exp <- 
      
    # 2.1.3 If any plots exist, create section ---------------------------------------
    wagebill <- (wb_gdp | wb_exp)
  
  # 2.2 Test if section 2 will be displayed and save that in an object -------
  
  # 2.3 Test if section 2 will be displayed and save that in an object -------
```

# 3 Create actual document ==========================================================
    
  # 3.1 Wage bill section -----------------------------------------------------------
    # 3.1.1 Print title (conditional on section being displayed) --------------------
`r if(wagebill){"# Wage bill"}`
    
    # 3.1.2 Create graphs -----------------------------------------------------------
```{r,echo=FALSE, eval = wagebill, fig.width=10, fig.height=5,fig.show='hold',fig.align='center', warning = F}

    # Create GDP graph (if we have that information)  
    if (wb_gdp) {
      wb_gdp_plot <- 
        ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = wage_gdp), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = wage_gdp,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == "Ethiopia", ],
                     aes(x = lngdppc ,
                         y = wage_gdp),
                     color = "red", size=3) +
          geom_label_repel(data = wwbi[wwbi$countryname == "Ethiopia", ],
                           aes(x = lngdppc ,
                               y = wage_gdp, 
                               label=paste0(countryname,":", round(wage_gdp, 0), "% ")),
                           color = "red") +
          ylab("Wage bill(%)") + xlab("Log of GDP per capita") +
          ggtitle("Wage bill as % of GDP") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
    }
    
    # Create Expenditure graph (if we have that information)  
    if (wb_exp) {
      wb_exp_plot <- 
        ggplot() +
          geom_smooth(data = wwbi,
                      aes(x = lngdppc ,
                          y = wage_x), method='lm', formula=y~x, se=FALSE,color="grey", linetype="dashed") +
          geom_point(data = wwbi,
                     aes(x = lngdppc ,
                         y = wage_x,
                         color = region)) +
          geom_point(data = wwbi[wwbi$countryname == "Ethiopia", ],
                     aes(x = lngdppc ,
                         y = wage_x),
                     color = "red", size=3) +
          geom_label_repel(data = wwbi[wwbi$countryname == "Ethiopia", ],
                           aes(x = lngdppc ,
                               y = wage_x, 
                               label=paste0(countryname,":", round(wage_x, 0), "% ")),
                           color = "red") +
          ylab("Wage bill(%)") + xlab("Log of GDP per capita") +
          ggtitle("Wage bill as % of expenditures") +
          scale_color_viridis(discrete=TRUE)+
          my_theme
    }

  # 3.1.3 Print graphs to report
  # If we have both, display both
  if (wb_gdp & wb_exp) {
    grid.arrange(wb_gdp_plot, wb_exp_plot, ncol=2)
  }
  # If we only have one, display the one we have
  else if (wb_gdp & !wb_exp) {
    wb_gdp_plot
  }
  else if (!wb_gdp & wb_exp) {
    wb_exp_plot
  }
  

```
  