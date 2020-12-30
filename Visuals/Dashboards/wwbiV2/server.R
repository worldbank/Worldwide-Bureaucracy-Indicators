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
#choices <- setNames(names_all$indcode, names_all$indname)

#       -           -       -     -   -   -   SERVER - - - ---- 
shinyServer(function(input, output, session) {

    # reactive values ----
  year <- reactive({input$in.year})
  
  mapfill <- reactive({ input$in.mapfill })
  
  
  
  #### Data control ----
  
  
  # filter WWBI variables 
  # wwbiVars <- reactive({
  #   table.filter <-
  #     names_all %>%
  #       filter_at(vars(starts_with("cat")),
  #                 any_vars(. %in% input$filter ))
  #   
  #   name.filter <-setNames(table.filter$indcode, table.filter$indname)
  #   
  #   return(name.filter)
  # })
  # 
  
  # res module
  res_mod <- callModule(
    module = selectizeGroupServer,
    id = "my-filters",
    data = tag_grid,
    vars = c("tag1_name", "tag2_name")
  )
  
  output$table4 <- renderTable({ res_mod() }) 
  
  # observeEvent(, { 
  # 
  #   name.filter <- setNames(res_mod()$indcode, res_mod()$indname)
  # 
  # 
  # 
  #   updatePickerInput(session = session, inputId = 'in.mapfill',
  #                     choices = name.filter)
  # 
  # })
  


  
  
  # filter dataset by year 
  # data_yr <- reactive({
  #   if (input$recent == TRUE) {
  #     return()
  #   } else {
  #     wwbi_geo %>%
  #       filter(year == input$in.year )
  #   }
  # 
  # }) 
  # 
  # # most recent dataset yet 
  # data_rcnt <- reactive({
  #     wwbi_geo %>%
  #     select(keepvars, input$in.mapfill ) %>% 
  #     filter(is.na(eval(as.symbol(input$in.mapfill))) == FALSE) %>%   # remove missing values for variable 
  #     arrange(ctycode, -year) %>% # arrnage by country and year descending
  #     group_by(ctycode) %>%
  #     filter(row_number() == 1)
  # })
  # 
  # 
  # # data switch
  # data <- reactive({
  #   if (input$recent == TRUE) {
  #     data <- data_rcnt()
  #   } else {
  #     data <- data_yr()
  #   }
  #   return(data)
  # })
  # 
  # 
  # 
  # # comparison dataset 
  # data_comp <- reactive({
  #   wwbi_geo %>%
  #     st_drop_geometry() %>% #remove geometry
  #     filter(ctyname %in% input$comp.country) 
  # }) 
  #   
  # 
  # 
  # # aesthetics ----
  # 
  # 
  # # color pallete
  # colorpal <- reactive({
  #   colorNumeric("YlOrRd", NULL)
  # })
  # 
  # # alpha 
  # a.f1.li = 0.6
  # a.f1    = 0.6
  # 
  # 
  # #### map ####
  # 
  # # build a basemap
  # basemap <- reactive({
  #   leaflet(data = world_geo ) %>% # use the obejct that contains just the boundary files
  #     setView(zoom = 2, lat = 0, lng = 0) %>%
  #     addProviderTiles(
  #       'CartoDB.VoyagerNoLabels', # this map is free to use for non-commerical purposes, we must also keep citation
  #       options = tileOptions(minZoom = 2, maxZoom = 6, noWrap = TRUE, detectRetina = TRUE)) %>%
  #     addEasyButton(easyButton(
  #       icon = 'fa-globe', title = "Reset Zoom", onClick = JS('function(btn, map) {map.setZoom(2); }')
  #     ))
  # })
  #   
  # output$map <- renderLeaflet({ basemap() })
  # 
  # 
  # 
  # # for incremental changes to map
  # observe({
  #   pal <- colorpal()
  #   
  #   leafletProxy("map", data = data()) %>%
  #     clearShapes() %>%
  #     addPolygons(data = world_geo, fillColor = "#dcdcdc", weight = 1,
  #                 label = ~paste0(NAME_EN, ": Not in WWBI")) %>% # all countries
  #     addPolygons(fillColor = ~pal(eval(as.symbol(input$in.mapfill))), fillOpacity = 0.8,
  #                 weight = 0.5,
  #                 layerId = ~iso3c,
  #                 label = ~paste0(ctyname,
  #                                 " (", year, ")",
  #                                 ": ",
  #                                 prettyNum(round(eval(as.symbol(input$in.mapfill)), 2),
  #                                                              big.mark = ',' ))
  #     )
  # 
  # })
  # 
  # 
  # # for incremental changes to legend 
  # observe({
  #   proxy <- leafletProxy('map', data = data())
  #   
  #   proxy %>% clearControls()
  #     
  #    if (input$legend) {
  #       pal <- colorpal()
  #       proxy %>% addLegend(position = 'bottomright',
  #                           pal = pal,
  #                           values = ~eval(as.symbol(input$in.mapfill)),
  #                           title = names_all$nameHtml[names_all$indcode %in% as.character(input$in.mapfill)]
  #                           )
  #       
  #    }
  #   
  # })
  # 
  # # dynamic map view as viewed by user ----
  # 
  # # set empty reactive values object
  # user.map <- reactive({
  #   basemap() %>%
  #     setView(zoom = input$map_zoom, # set zoom level to that of current view
  #             lat  = input$map_center$lat, # set the lat to the center lat coord of current view
  #             lng  = input$map_center$lng
  #     ) # set the lng to the center lng coord of current view
  #     
  # })
  # 
  # 
  # output$dl <- downloadHandler(
  #   filename = function() {
  #     paste0(input$in.mapfill, ".png")
  #   },
  #    content = function(file) {
  #      mapshot(basemap(), file, cliprect = "viewport", selfcontained = FALSE, debug = TRUE)
  #                             } )
  # 
  # 
  # #### Map subplots ----
  # 
  # 
  # 
  # ## subset main dataframe with coords from click
  # 
  # # determine country id that was clicked
  # countryclick <- reactive({ 
  #   if (is.null(input$map_shape_click))
  #     return(NULL) # world average plot goes here
  #   input$map_shape_click$id
  # })
  # 
  # 
  # # filter data based on click
  # data_clickplot <- reactive({ 
  #   wwbi_geo %>%
  #     filter(iso3c %in% countryclick() )
  # })
  # 
  # 
  # # generate a little ggplot
  # output$clickplot <- renderPlot({
  #   # generate the base graph 
  #   ggbase <- 
  #     ggplot(data = wwbi_av[wwbi_av$avtype %in% "World Average",],
  #            aes(year, eval(as.symbol(input$in.mapfill)), color = ctyname)) +
  #     geom_point() + # color = '#708090'
  #     stat_smooth(data = wwbi_av[wwbi_av$avtype %in% "World Average",],
  #                 aes(year, eval(as.symbol(input$in.mapfill)),  span = span),
  #                 method = 'loess', # , color = '#000000'
  #                 linetype = 1, size = 0.5, se = F, alpha = a.f1.li) + 
  #     labs(title = "",
  #          y = "", x = "" , color = "") +
  #     theme_classic() +
  #     theme(panel.background = element_rect(fill = 'transparent', color = NA),
  #           plot.background = element_rect(fill = 'transparent', color = NA),
  #           legend.position = 'top',
  #           axis.title.x = element_blank(),
  #           axis.title.y = element_blank()) +
  #     scale_color_manual(values = c("World Average" = "#708090"))
  #     
  #     
  #     
  #     
  #     
  #   # if no click, generate the world average of the default variable
  #   if (is.null(countryclick() ))
  #     return(
  #         ggbase
  #     )
  #   #otherwise return the average with the element selected
  #   ggplot(data = data_clickplot(), aes(year, eval(as.symbol(input$in.mapfill)), color = ctyname)) +
  #     geom_point() + #  color = '#00bfff'
  #     stat_smooth(aes(y = eval(as.symbol(input$in.mapfill)), span = span),
  #                 method = 'loess', # color = '#1e90ff'
  #                 linetype = 1, size = 0.5, se = F, alpha = a.f1.li) + 
  #                   labs(y = "", x = "") +
  #     geom_point(data = wwbi_av[wwbi_av$avtype %in% "World Average",],
  #                aes(year, eval(as.symbol(input$in.mapfill)) )) + # color = '#708090'
  #     stat_smooth(data = wwbi_av[wwbi_av$avtype %in% "World Average",],
  #                 aes(year, eval(as.symbol(input$in.mapfill)),  span = span),
  #                 method = 'loess', # , color = '#000000'
  #                 linetype = 1, size = 0.5, se = F, alpha = a.f1.li) + 
  #     labs(y = "", x = "" , color = "") +
  #     theme_classic() +
  #     theme(panel.background = element_rect(fill = 'transparent', color = NA),
  #           plot.background = element_rect(fill = 'transparent', color = NA),
  #           legend.position = 'top',
  #           axis.title.x = element_blank(),
  #           axis.title.y = element_blank()) +
  #     scale_color_manual(values = c("#00bfff", "World Average" = "#708090"))
  # 
  # })
  
  output$list <- renderPrint({reactiveValuesToList(input)})
  
  
  
  ##### Comparison tab #### 
  # 
  # # graph1: gdp_pc (x) vs formal, paid, all employment (y)
  # output$comp1 <- renderPlotly({
  #   
  #   f1 <-
  #     ggplot(data_comp(), aes(x = gdp_pc2017)) +
  #     # Total Employment
  #     geom_point(aes(y = BI.EMP.TOTL.PB.ZS, color = '#1B9E77',
  #                    text = paste0(ctyname, ', ', year,
  #                                  "<br>GDP pc: ", "$", prettyNum(round(gdp_pc2017), big.mark = ','),
  #                                  "<br>Public Employment Share: ", round(BI.EMP.TOTL.PB.ZS, 2))),
  #                alpha = a.f1) +
  #     stat_smooth(aes(y =BI.EMP.TOTL.PB.ZS, color = '#1B9E77', span = span), method = 'loess',
  #                 linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
  #     # Paid Employment
  #     geom_point(aes(y = BI.EMP.PWRK.PB.ZS, color = '#D95F02',
  #                    text = paste0(ctyname, ', ', year,
  #                                  "<br>GDP pc: ", "$", prettyNum(round(gdp_pc2017), big.mark = ','),
  #                                  "<br>Public Employment Share: ", round(BI.EMP.PWRK.PB.ZS, 2))),
  #                alpha = a.f1) +
  #     stat_smooth(aes(y =BI.EMP.PWRK.PB.ZS, color = '#D95F02', span = span), method = 'loess',
  #                 linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
  #     # Formal Employment
  #     geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = '#7570B3', 
  #                    text = paste0(ctyname, ', ', year,
  #                                  "<br>GDP pc: ", "$", prettyNum(round(gdp_pc2017), big.mark = ','),
  #                                  "<br>Public Employment Share: ", round(BI.EMP.FRML.PB.ZS, 2))),
  #                alpha = a.f1) +
  #     stat_smooth(aes(y =BI.EMP.FRML.PB.ZS, color = '#7570B3', span = span), method = 'loess',
  #                 linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
  #     scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  #     scale_color_manual(name = '',
  #                        labels = c("Total Employment", "Paid Employment", "Formal Employment"),
  #                        values = c("#1B9E77", "#D95F02", "#7570B3")) +
  #     theme_classic() +
  #     theme(legend.position = 'bottom') +
  #     labs(title = "",
  #          x = "GDP per Capita (in constant 2017 dollars)",
  #          y = "Public Employment (Share of Country-wide Employment)",
  #          color = "Measure of Country-wide Employment")
  #   
  #   f1 <- ggplotly(f1, tooltip = c('text')) %>%
  #     style(name ='Total Employment', traces = c(1,2)) %>% # hovertemplate = htf1,
  #     style(name = 'Paid Employment', traces = c(3,4)) %>%
  #     style(name = 'Formal Employment', traces = c(5,6)) %>%
  #     layout(
  #       title = list(
  #         text = "<b>Public Employment as a Share of Country-wide Employment</b>",
  #         y = 0.98
  #       ),
  #       yaxis = list(range = c(0,0.8), tickmode = 'auto'),
  #       legend = list(title = list(text = '<b>Measures of Public Employment</b>')),
  #       modebar = list(orientation = 'v')
  #     ) %>%
  #     config(modeBarButtons = list(list('hoverClosestCartesian'), list('hoverCompareCartesian')))
  # 
  #   
  #   return(f1)
  #   
  # })
  # 
  # 
  # # graph2: year (x) vs 3 types of employment (y)
  # 
  # output$comp2 <- renderPlotly({
  #   
  #   f2 <-
  #     ggplot(data_comp(), aes(x = year)) +
  #     # Total Employment
  #     geom_point(aes(y = eval(as.symbol(input$comp.c2)), color = ctyname,
  #                    text = paste0(ctyname, ', ', year,
  #                                  "<br>GDP pc: ", "$", prettyNum(round(year), big.mark = ','),
  #                                  "<br>Public Employment Share: ", round(BI.EMP.TOTL.PB.ZS, 2))),
  #                alpha = a.f1) +
  #     stat_smooth(aes(y = eval(as.symbol(input$comp.c2)), color = ctyname, span = span), method = 'loess',
  #                 linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
  #     theme_classic() +
  #     theme(legend.position = 'bottom') +
  #     labs(title = "",
  #          x = "Year",
  #          y = paste0("Public Employment:", as.character(input$comp.c2)),
  #          color = "")
  #   
  #   f2 <- ggplotly(f2, tooltip = c('text')) %>%
  #     # style(name ='Total Employment', traces = c(1,2)) %>% # hovertemplate = htf1,
  #     # style(name = 'Paid Employment', traces = c(3,4)) %>%
  #     # style(name = 'Formal Employment', traces = c(5,6)) %>%
  #     layout(
  #       title = list(
  #         text = "<b>Public Employment as a Share of Country-wide Employment</b>",
  #         y = 0.98
  #       ),
  #       yaxis = list(range = c(0,0.8), tickmode = 'auto'),
  #       legend = list(title = list(text = '<b>Countries</b>')),
  #       modebar = list(orientation = 'v')
  #     ) %>%
  #     config(modeBarButtons = list(list('hoverClosestCartesian'), list('hoverCompareCartesian')))
  #   
  #   return(f2)
  #   
  #   
  # })

  
  
  
})


