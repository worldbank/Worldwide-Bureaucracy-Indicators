# server.R
# for coffee table

# load data 
load("data/data.Rdata")

## define varlist of keyvars to keep 
keepvars <- c("ctycode", "ctyname", "year",
              "iso2c", "country", "gdp_pc2017",
              "iso3c", "region", "income",
              "lending", "ln_gdp", "lnTotEmp")

# define graph aesthetics
span = 0.8

#       -           -       -     -   -   -   SERVER - - - ---- 
shinyServer(function(input, output) {

    # reactive values ----
  year <- reactive({input$in.year})
  
  mapfill <- reactive({ input$in.mapfill })
  
  
  
  #### Data control ----
  # filter dataset by year 
  data_yr <- reactive({
    if (input$recent == TRUE) {
      return()
    } else {
      wwbi_geo %>%
        filter(year == input$in.year )
    }
  
  }) 
  
  # most recent dataset yet 
  data_rcnt <- reactive({
      wwbi_geo %>%
      select(keepvars, input$in.mapfill ) %>% 
      filter(is.na(eval(as.symbol(input$in.mapfill))) == FALSE) %>%   # remove missing values for variable 
      arrange(ctycode, -year) %>% # arrnage by country and year descending
      group_by(ctycode) %>%
      filter(row_number() == 1)
  })
  
  
  # data switch
  data <- reactive({
    if (input$recent == TRUE) {
      data <- data_rcnt()
    } else {
      data <- data_yr()
    }
    return(data)
  })
  
  
  
  # comparison dataset 
  data_comp <- reactive({
    wwbi_geo %>%
      st_drop_geometry() %>% #remove geometry
      filter(ctyname %in% input$comp.country) 
  }) 
    
  
  
  # aesthetics ----
  
  # color pallete
  colorpal <- reactive({
    colorNumeric("YlOrRd", NULL)
  })
  
  # alpha 
  a.f1.li = 0.6
  a.f1    = 0.6
  

  #### map ####
  output$map <- renderLeaflet({
    
    ## build base map base
      leaflet(data = wwbi_geo_shp ) %>% # use the obejct that contains just the boundary files
      setView(zoom = 3, lat = 0, lng = 0) %>%
      addTiles()
     # tileOptions(minZoom = 4, maxZoom = 12, noWrap = TRUE, detectRetina = TRUE)
     
  })
  

  
  # for incremental changes to map
  observe({
    pal <- colorpal()
    
    leafletProxy("map", data = data()) %>%
      clearShapes() %>%
      addPolygons(fillColor = ~pal(eval(as.symbol(input$in.mapfill))), fillOpacity = 0.8,
                  weight = 0.5, 
                  layerId = ~iso3c,
                  label = ~paste0(ctyname,
                                  " (", year, ")",
                                  ": ", 
                                  prettyNum(round(eval(as.symbol(input$in.mapfill)), 2),
                                                               big.mark = ',' ))
      ) 

  })
  
  
  # for incremental changes to legend 
  observe({
    proxy <- leafletProxy('map', data = data())
    
    proxy %>% clearControls()
      
     if (input$legend) {
        pal <- colorpal()
        proxy %>% addLegend(position = 'bottomright',
                            pal = pal,
                            values = ~eval(as.symbol(input$in.mapfill)),
                            title = ~as.character(input$in.mapfill)
                            )
        
     }
    
  })
  

  
  #### Map subplots ---- 
  #output$clickplot <- renderText({as.character(input$map_shape_click$id) })
  
  
  
  
  ## subset main dataframe with coords from click
  
  # determine country id that was clicked
  countryclick <- reactive({ 
    if (is.null(input$map_shape_click))
      return(NULL) # world average plot goes here
    input$map_shape_click$id
  })
  
  
  # filter data based on click
  data_clickplot <- reactive({ 
    wwbi_geo %>%
      filter(iso3c %in% countryclick() )
  })
  
  
  # generate a little ggplot
  output$clickplot <- renderPlot({
    if (is.null(countryclick() ))
      return(NULL)
    ggplot(data = data_clickplot(), aes(year, eval(as.symbol(input$in.mapfill)), color = ctyname)) +
      geom_point() + #  color = '#00bfff'
      stat_smooth(aes(y = eval(as.symbol(input$in.mapfill)), span = span),
                  method = 'loess', # color = '#1e90ff'
                  linetype = 1, size = 0.5, se = F, alpha = a.f1.li) + 
                    labs(y = "", x = "") +
      geom_point(data = wwbi_av[wwbi_av$avtype %in% "World Average",],
                 aes(year, eval(as.symbol(input$in.mapfill)) )) + # color = '#708090'
      stat_smooth(data = wwbi_av[wwbi_av$avtype %in% "World Average",],
                  aes(year, eval(as.symbol(input$in.mapfill)),  span = span),
                  method = 'loess', # , color = '#000000'
                  linetype = 1, size = 0.5, se = F, alpha = a.f1.li) + 
      labs(y = "", x = "" , color = "") +
      theme_classic() +
      theme(panel.background = element_rect(fill = 'transparent', color = NA),
            plot.background = element_rect(fill = 'transparent', color = NA),
            legend.position = 'top',
            axis.title.x = element_blank(),
            axis.title.y = element_blank()) +
      scale_color_manual(values = c("#00bfff", "World Average" = "#708090"))

  })
  
  
  
  ##### Comparison tab #### 
  
  # graph1: gdp_pc (x) vs formal, paid, all employment (y)
  output$comp1 <- renderPlotly({
    
    f1 <-
      ggplot(data_comp(), aes(x = gdp_pc2017)) +
      # Total Employment
      geom_point(aes(y = BI.EMP.TOTL.PB.ZS, color = '#1B9E77',
                     text = paste0(ctyname, ', ', year,
                                   "<br>GDP pc: ", "$", prettyNum(round(gdp_pc2017), big.mark = ','),
                                   "<br>Public Employment Share: ", round(BI.EMP.TOTL.PB.ZS, 2))),
                 alpha = a.f1) +
      stat_smooth(aes(y =BI.EMP.TOTL.PB.ZS, color = '#1B9E77', span = span), method = 'loess',
                  linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
      # Paid Employment
      geom_point(aes(y = BI.EMP.PWRK.PB.ZS, color = '#D95F02',
                     text = paste0(ctyname, ', ', year,
                                   "<br>GDP pc: ", "$", prettyNum(round(gdp_pc2017), big.mark = ','),
                                   "<br>Public Employment Share: ", round(BI.EMP.PWRK.PB.ZS, 2))),
                 alpha = a.f1) +
      stat_smooth(aes(y =BI.EMP.PWRK.PB.ZS, color = '#D95F02', span = span), method = 'loess',
                  linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
      # Formal Employment
      geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = '#7570B3', 
                     text = paste0(ctyname, ', ', year,
                                   "<br>GDP pc: ", "$", prettyNum(round(gdp_pc2017), big.mark = ','),
                                   "<br>Public Employment Share: ", round(BI.EMP.FRML.PB.ZS, 2))),
                 alpha = a.f1) +
      stat_smooth(aes(y =BI.EMP.FRML.PB.ZS, color = '#7570B3', span = span), method = 'loess',
                  linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
      scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
      scale_color_manual(name = '',
                         labels = c("Total Employment", "Paid Employment", "Formal Employment"),
                         values = c("#1B9E77", "#D95F02", "#7570B3")) +
      theme_classic() +
      theme(legend.position = 'bottom') +
      labs(title = "",
           x = "GDP per Capita (in constant 2017 dollars)",
           y = "Public Employment (Share of Country-wide Employment)",
           color = "Measure of Country-wide Employment")
    
    f1 <- ggplotly(f1, tooltip = c('text')) %>%
      style(name ='Total Employment', traces = c(1,2)) %>% # hovertemplate = htf1,
      style(name = 'Paid Employment', traces = c(3,4)) %>%
      style(name = 'Formal Employment', traces = c(5,6)) %>%
      layout(
        title = list(
          text = "<b>Public Employment as a Share of Country-wide Employment</b>",
          y = 0.98
        ),
        yaxis = list(range = c(0,0.8), tickmode = 'auto'),
        legend = list(title = list(text = '<b>Measures of Public Employment</b>')),
        modebar = list(orientation = 'v')
      ) %>%
      config(modeBarButtons = list(list('hoverClosestCartesian'), list('hoverCompareCartesian')))
  
    
    return(f1)
    
  })
  
  
  # graph2: year (x) vs 3 types of employment (y)
  
  output$comp2 <- renderPlotly({
    
    f2 <-
      ggplot(data_comp(), aes(x = year)) +
      # Total Employment
      geom_point(aes(y = eval(as.symbol(input$comp.c2)), color = ctyname,
                     text = paste0(ctyname, ', ', year,
                                   "<br>GDP pc: ", "$", prettyNum(round(year), big.mark = ','),
                                   "<br>Public Employment Share: ", round(BI.EMP.TOTL.PB.ZS, 2))),
                 alpha = a.f1) +
      stat_smooth(aes(y = eval(as.symbol(input$comp.c2)), color = ctyname, span = span), method = 'loess',
                  linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
      theme_classic() +
      theme(legend.position = 'bottom') +
      labs(title = "",
           x = "Year",
           y = paste0("Public Employment:", as.character(input$comp.c2)),
           color = "")
    
    f2 <- ggplotly(f2, tooltip = c('text')) %>%
      # style(name ='Total Employment', traces = c(1,2)) %>% # hovertemplate = htf1,
      # style(name = 'Paid Employment', traces = c(3,4)) %>%
      # style(name = 'Formal Employment', traces = c(5,6)) %>%
      layout(
        title = list(
          text = "<b>Public Employment as a Share of Country-wide Employment</b>",
          y = 0.98
        ),
        yaxis = list(range = c(0,0.8), tickmode = 'auto'),
        legend = list(title = list(text = '<b>Countries</b>')),
        modebar = list(orientation = 'v')
      ) %>%
      config(modeBarButtons = list(list('hoverClosestCartesian'), list('hoverCompareCartesian')))
    
    return(f2)
    
    
  })

  
  
  
})


