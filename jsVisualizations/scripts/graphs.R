# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# graphs.R
# sample graphs for wwbi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

library(RColorBrewer)
library(listviewer)

# load data 
load(file = file.path(wwbi_dat, "wwbi-tbls.Rdata"))

# create plotly objects ----


## settings 
s_alpha = 0.25 # alpha for lots of dots



## buttons for graph 1 
emp_type <- list(
  list(
    active = -1,
    type = 'buttons',
    direction = 'down',
    xanchor = 'auto',
    yanchor = 'middle',
    # y = 0.6,
    buttons = list(
      
      list(
        label = "Total Employment",
        method = 'update',
        args = list(list('visible' = c(TRUE, TRUE, FALSE, FALSE, FALSE, FALSE)),
                    list(title = "Shares of Public Sector Employment (Total Employment)", # update main title
                         yaxis = list(title = "Public sector employment as a share of Total Employment")))), # y
      
      list(
        label = "Paid Employment",
        method = 'update',
        args = list(list('visible', c(FALSE, FALSE, TRUE, TRUE, FALSE, FALSE)),
                    list(title = "Share of Public Sector Employment (Paid Employment)",
                         yaxis = list(title = "Public sector employment as a share of Paid Employment")))),
      
      list(
        label = "Formal Employment",
        method = 'update',
        args = list(list('visible', c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE)),
                    list(title = "Share of Public Sector Employment (Formal Employment)",
                         yaxis = list(title = "Public sector employment as a share of Formal Employment"))))
      
    )))



emp_legend <- list(
  type = 'buttons',
  direction = 'down',
  xanchor = 'auto',
  yanchor = 'top',
  # y = 0.6,
  buttons = list(
    
    list(method = 'restyle',
         args = list('showlegend', list(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE)),
         label = "Total Employment"),
    
    list(method = 'restyle',
         args = list('showlegend', list(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)),
         label = "Paid Employment"),
    
    list(method = 'restyle',
         args = list('showlegend', list(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE)),
         label = "Formal Employment")
  ))

agg_toggle <- list(
  type = 'buttons',
  direction = 'down',
  xanchor = 'auto',
  yanchor = 'top',
  y = 0.5,
  buttons = list(
  
  list(method = 'restyle',
       args = list('visible', list(TRUE, FALSE, TRUE, FALSE, TRUE, FALSE)),
       label = "Aggregate off"),
  
  list(method = 'restyle',
       args = list('visible', list(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)),
       label = "Aggregate on")
  
))

## Section 1: total, paid, or formal employment vs gdp per cap (log) ----

## trendline
p1.min <- min(wwbi$gdp_pc2017, na.rm = TRUE)
p1.max <- max(wwbi$gdp_pc2017, na.rm = TRUE)


tt = seq(from= p1.min, to = p1.max, by = 100)

lo <- loess(BI.EMP.TOTL.PB.ZS ~ gdp_pc2017, data = wwbi, span = 0.75)

p1 <- 
  plot_ly(
  data = wwbi,
  text = ~ctyname,
  hoverinfo = "text+x+y"
) %>%
  # Total Employment: Animation
  add_markers(
    x = ~gdp_pc2017, # raw gdp per cap (axis settings will change to log)
    y = ~BI.EMP.TOTL.PB.ZS, # public sector employment as share of total employment
    showlegend = FALSE,
    visible = TRUE,
    color = ~region,
    size = 10,
    sizemode = 'area',
    frame = ~year,
    ids = ~ctyname
  ) %>%
  # add_trace(type = "scatter",
  #           mode = 'lines',
  #           x = ~gdp_pc2017, y = predict(lo), name = "World Average") %>%
# Total Employment: all dots
  add_markers(
    x = ~gdp_pc2017, # raw gdp per cap (axis settings will change to log)
    y = ~BI.EMP.TOTL.PB.ZS, # public sector employment as share of total employment
    showlegend = FALSE,
    visible = TRUE,
    color = ~region,
    size = 10,
    sizemode = 'area',
    showlegend = FALSE,
    alpha = s_alpha, 
    alpha_stroke = s_alpha
  ) %>%
  # Paid Employment: animation
  add_markers(
    x = ~gdp_pc2017,
    y = ~BI.EMP.PWRK.PB.ZS, # as share of paid employment
    showlegend = FALSE,
    color = ~region,
    size = 10,
    frame = ~year,
    ids = ~ctyname,
    visible = FALSE
    ) %>%
  # Paid Employment: all dots
  add_markers(
    x = ~gdp_pc2017,
    y = ~BI.EMP.PWRK.PB.ZS, # as share of paid employment
    showlegend = FALSE,
    visible = FALSE,
    color = ~region,
    size = 10,
    alpha = s_alpha, 
    alpha_stroke = s_alpha
  ) %>%
  # Formal Employment: animation
  add_markers(
    x = ~gdp_pc2017,
    y = ~BI.EMP.FRML.PB.ZS, # as share of formal employment
    showlegend = FALSE,
    color = ~region,
    size = 10,
    frame = ~year,
    ids = ~ctyname,
    visible = FALSE
  ) %>%
  # Formal Employment: all dots
  add_markers(
    x = ~gdp_pc2017,
    y = ~BI.EMP.FRML.PB.ZS, # as share of formal employment
    color = ~region,
    size = 10,
    showlegend = FALSE,
    alpha = s_alpha, 
    alpha_stroke = s_alpha,
    visible = FALSE
  ) %>%
  layout(
    title = list(
      text = "Shares of Public Sector Employment and Log Total Number of Workers",
      size = 20
    ),
    xaxis = list(
      type = 'log',
      title = list(
        text = 'Log GDP per capita (2017 Constant USD)'
        )
      ),
    yaxis = list(
      title = list(
        text = "Public sector employment as a share of Selected Variable"
      )
    ),
    updatemenus = emp_type
  ) %>%
  animation_opts(
    frame = 1000,
    transition = 500,
    easing = 'linear',
    mode = 'immediate'
  ) 

p1

# 2. public employment as a share of total, male, femail employees over time----
# x = year 
# y = select one of three variables 

p2 <-
  ggplot(wwbi, aes(year, BI.EMP.TOTL.PB.ZS, color = region)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = 'loess', na.rm = TRUE, span = 1, alpha = 0.15) +
  theme_minimal() +
  labs(title = "Public Employment Over Time", y = "Public Employment", x = "Year") + 
  theme(legend.position = 'bottom')



p2_1 <-
plot_ly(
  data = wwbi,
  x = ~BI.EMP.TOTL.PB.MA.ZS, # males
  y = ~BI.EMP.TOTL.PB.FE.ZS, # females
  text = ~ctyname,
  hoverinfo = "text+x+y"
) %>%
  add_markers(
    showlegend = FALSE,
    color = ~region,
    size = ~incomegroupNum,
    #sizeref = 10,
    sizemode = 'area',
    frame = ~year,
    ids = ~ctyname
  ) %>%
  add_markers(
    color = ~region,
    size = ~incomegroupNum,
    #sizeref = 10,
    sizemode = 'area',
    showlegend = TRUE,
    alpha = s_alpha, 
    alpha_stroke = s_alpha
  ) %>%
  layout(
    title = list(
      text = "Public Sector Employment as a share of total employment by gender over time",
      size = 20
    ),
    xaxis = list(
      range = c(0,0.7),
      title = list(
        text = '(Male) Percent of Total Employment'
      )
    ),
    yaxis = list(
      range = c(0,0.7),
      title = list(
        text = "(Female) Percent of Total Employment"
      )
    ),
    shapes = list(
      type = 'line',
      layer = 'below',
      x0 = 0,
      x1 = 1,
      y0 = 0,
      y1 = 1,
      opacity = 0.3
    )
  ) %>%
  animation_opts(
    frame = 1200,
    transition = 600,
    easing = 'linear',
    mode = 'immediate'
  ) 




#3. Public secotr employment as a share of all, urban, rural residents over time ----


p3 <-
  plot_ly(
    data = wwbi,
    x = ~BI.EMP.TOTL.PB.RU.ZS, # rural
    y = ~BI.EMP.PWRK.PB.UR.ZS, # urban
    text = ~ctyname,
    hoverinfo = "text+x+y"
  ) %>%
  add_markers(
    showlegend = FALSE,
    color = ~region,
    size = ~incomegroupNum,
    sizemode = 'area',
    frame = ~year,
    ids = ~ctyname,
    marker = list(
      line = list(
        width = 5
      )
    )
  ) %>%
  add_markers(
    color = ~region,
    size = ~incomegroupNum,
    sizemode = 'area',
    showlegend = TRUE,
    alpha = s_alpha, 
    alpha_stroke = s_alpha
  ) %>%
  layout(
    title = list(
      text = "Public Sector Employment as a share of total employment by location over time",
      size = 20
    ),
    xaxis = list(
      range = c(0,0.7),
      title = list(
        text = '(Rural) Percent of Total Employment'
      )
    ),
    yaxis = list(
      range = c(0,0.7),
      title = list(
        text = "(Urban) Percent of Total Employment"
      )
    ),
    shapes = list(
      type = 'line',
      layer = 'below',
      x0 = 0,
      x1 = 1,
      y0 = 0,
      y1 = 1,
      opacity = 0.3
    )
  ) %>%
  animation_opts(
    frame = 1200,
    transition = 600,
    easing = 'linear',
    mode = 'immediate'
  ) 


p3_1 <-
  plot_ly(
    data = wwbi,
    x = ~BI.EMP.TOTL.PB.RU.ZS, # rural
    y = ~BI.EMP.PWRK.PB.UR.ZS, # urban
    text = ~ctyname,
    hoverinfo = "text+x+y"
  ) %>%
  add_markers(
    showlegend = FALSE,
    color = ~region,
    size = 10,
    sizemode = 'area',
    frame = ~year,
    ids = ~ctyname,
    marker = list(
      line = list(
        width = 5
      )
    )
  ) %>%
  add_markers(
    color = ~region,
    size = 10,
    sizemode = 'area',
    showlegend = TRUE,
    alpha = s_alpha, 
    alpha_stroke = s_alpha
  ) %>%
  layout(
    title = list(
      text = "Public Sector Employment as a share of total employment by location over time",
      size = 20
    ),
    xaxis = list(
      range = c(0,0.7),
      title = list(
        text = '(Rural) Percent of Total Employment'
      )
    ),
    yaxis = list(
      range = c(0,0.7),
      title = list(
        text = "(Urban) Percent of Total Employment"
      )
    ),
    shapes = list(
      type = 'line',
      layer = 'below',
      x0 = 0,
      x1 = 1,
      y0 = 0,
      y1 = 1,
      opacity = 0.3
    )
  ) %>%
  animation_opts(
    frame = 1200,
    transition = 600,
    easing = 'linear',
    mode = 'immediate'
  ) 



# 4. 3d scatter plot ----

p4temp = paste('<b>%{text}</b>',
               '<br>Private Med Age: %{x}',
               '<br>Public Med Age: %{y}',
               '<br>Wage Bill % GDP: %{z: .1f}%',
               '<extra></extra>')


p5temp = paste('<b>%{text}</b>',
               '<br>As share of total employment: %{x: .1f}%',
               '<br>As share of paid employment: %{y: .1f}%',
               '<br>As share of formal employment: %{z: .1f}%',
               '<extra></extra>')
  
#   
# p4 <-  plot_ly(wwbi,
#     x = ~ BI.PWK.AGES.PV.MD, # median age of private paid employess
#     y = ~ BI.PWK.AGES.PB.MD, # median age of public paid employees
#     z = ~BI.WAG.TOTL.GD.ZS, # Wage bill as a percentage of GDP,
#     text = ~ctyname
#   ) %>%
#   add_markers(color = ~BI.WAG.TOTL.GD.ZS, alpha = 0.7, hovertemplate = p4temp) %>%
#     layout(       title = list( text = "Median Age of Public/Private Sector and Wage Bill Spending"),
#       #scene = list(
#       xaxis = list( matches = 'y', title = "Median Age of Private Paid Employees"),
#       yaxis = list(title = "Median Age of Public Paid Employees"),
#       zaxis = list(title = "Wage Bill as Percentage of GDP")
#     #  )
# 
#     ) %>%
#     colorbar(title = "Wage Bill as % of GDP") %>%
#   add_trace (x = 30:50,
#               y = 30:50,
#               z = 10,
#               type = 'scatter3d',
#              mode = 'lines',
#               opacity = 1)
#     

# make bestfit line 
mod <- lm(BI.WAG.TOTL.GD.ZS ~ BI.PWK.AGES.PV.MD + BI.PWK.AGES.PB.MD, data = wwbi)
cf.mod <- coef(mod)

# calculate z 
x1.seq <- seq(min(wwbi$BI.PWK.AGES.PV.MD, na.rm = TRUE), max(wwbi$BI.PWK.AGES.PV.MD, na.rm = TRUE), length.out = 25)
x2.seq <- seq(min(wwbi$BI.PWK.AGES.PB.MD, na.rm = TRUE), max(wwbi$BI.PWK.AGES.PB.MD, na.rm = TRUE), length.out = 25)
z1.seq <- t(outer(x1.seq, x2.seq, function(x,y) cf.mod[1] + cf.mod[2]*x +cf.mod[3]*y ))

plane.seq <- t(outer(x1.seq, x2.seq, function(x,y) 0 + x + y))


p4 <- 
  plot_ly(data = wwbi) %>%
  add_trace(
            type = 'scatter3d',
            mode = 'markers',
            x = ~ BI.PWK.AGES.PV.MD, # median age of private paid employess
            y = ~ BI.PWK.AGES.PB.MD, # median age of public paid employees
            z = ~BI.WAG.TOTL.GD.ZS,  # Wage bill as a percentage of GDP 
            text = ~ctyname,
            color = ~lnTotEmp, # no of total employees
            alpha = 0.7,
            hovertemplate = p4temp) %>%
  # y = x plane
  add_trace(x = 20:50,
            y = 20:50,
            z = 0,
            type = 'scatter3d', # scatter3d,
            mode = 'lines',
            surfacecolor = "#dcdcdc",
            opacity = 1,
            showlegend = FALSE) %>%
  layout(
    title = list( text = "Median Age of Public/Private Sector and Wage Bill Spending"),
    scene = list(
      xaxis = list(title = "Median Age of Private Paid Employees", range = c(20,50)),
      yaxis = list(title = "Median Age of Public Paid Employees", range = c(20,50)),
      zaxis = list(title = "Wage Bill as Percentage of GDP")
    
  )) %>%
  colorbar(title = "Log Total Employed Persons") 



# colors 
test <- brewer.pal(n_distinct(wwbi$region), "Set1")

p5 <- 
  plot_ly(data = wwbi) %>%
  add_trace(
    type = 'scatter3d',
    mode = 'markers',
    color = ~region,
    colors = test,
    size = ~ln_gdp,
    x = ~ BI.EMP.TOTL.PB.ZS, # share of total employment
    y = ~ BI.EMP.PWRK.PB.ZS, # share of paid employment
    z = ~BI.EMP.FRML.PB.ZS,  # share of formal employment
    text = ~ctyname,
    alpha = 0.7,
    hovertemplate = p5temp,
    marker = list(sizeref = 0.08, sizemin = 12, line = list(width = 0))
    ) %>%
  # y = x plane
  add_trace(x = 0:1,
            y = 0:1,
            z = 0:1,
            type = 'scatter3d', # scatter3d,
            mode = 'lines',
            surfacecolor = "#dcdcdc",
            opacity = 1,
            showlegend = FALSE) %>%
  layout(
    title = list( text = "<b>Public Sector Employment as Share of Different Measures of All Employment</b>",
                  font = list(size = 16)),
    legend = list(title = list(text='<b>Region</b>', font = list(size = 12))),
   # dragmode = 'FALSE',
    scene = list(
      xaxis = list(title = "As Share of Total Employment", range = c(0,1)),
      yaxis = list(title = "As Share of Paid Employment", range = c(0,1)),
      zaxis = list(title = "As Share of Formal Employment", range = c(0,1))
      
    )) %>%
  config(scrollZoom = FALSE)

plotly_json(p5)

p5






# p6: remake of p1, public employment % vs gdp ----


a.p6 = 0.3
a.p6.li = 0.5

htp6 = paste('Log GDP per cap.: %{x:.1f}',
             '<br>Public Employment: %{y:.2f}%')

p6 <-
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Total Employment
  geom_point(aes(y = BI.EMP.TOTL.PB.ZS, color = '#1B9E77'), alpha = a.p6) +
  stat_smooth(aes(y =BI.EMP.TOTL.PB.ZS, color = '#1B9E77'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p6.li) +
  # Paid Employment
  geom_point(aes(y = BI.EMP.PWRK.PB.ZS, color = '#D95F02'), alpha = a.p6) +
  stat_smooth(aes(y =BI.EMP.PWRK.PB.ZS, color = '#D95F02'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p6.li) +
  # Formal Employment
  geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = '#7570B3'), alpha = a.p6) +
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS, color = '#7570B3'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p6.li) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  scale_color_manual(name = '',
                     labels = c("Total Employment", "Paid Employment", "Formal Employment"),
                     values = c("#1B9E77", "#D95F02", "#7570B3")) +
  theme_minimal() +
  theme(legend.position = 'bottom') +
  labs(title = "",
       x = "GDP per Capita (in constant 2017 dollars)",
       y = "Public Employment (Share of Country-wide Employment)",
       color = "Measure of Country-wide Employment")
  
p6.1 <- ggplotly(p6)
p6.1 <- p6.1 %>%
  style(hovertemplate = htp6, name ='Total Employment', traces = c(1,2)) %>%
  style(hovertemplate = htp6, name = 'Paid Employment', traces = c(3,4)) %>%
  style(hovertemplate = htp6, name = 'Formal Employment', traces = c(5,6)) %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Measures of Public Employment</b>'))
  ) 
  

p6.1
# inspect 
plotly_json(p6.1) 
# # do the above entirely in plotly
# p6 <- 
#   plot_ly(
#   data = wwbi,
#   text = ~ctyname,
#   hoverinfo = "text+x+y"
# ) %>%
#   # Total Employment
#   add_markers(
#     name = "Total Employment",
#     x = ~gdp_pc2017, # raw gdp per cap (axis settings will change to log)
#     y = ~BI.EMP.TOTL.PB.ZS, # public sector employment as share of total employment
#     showlegend = TRUE,
#     visible = TRUE,
#     alpha = a.p6, 
#     alpha_stroke = a.p6
#   ) %>%
#   # Paid Employment
#   add_markers(
#     name = "Paid Employment",
#     x = ~gdp_pc2017, # raw gdp per cap (axis settings will change to log)
#     y = ~BI.EMP.PWRK.PB.ZS, # public sector employment as share of total employment
#     showlegend = TRUE,
#     visible = TRUE,
#     alpha = a.p6, 
#     alpha_stroke = a.p6
#   ) %>%
#   # Formal Employment
#   add_markers(
#     name = "Formal Employment", 
#     x = ~gdp_pc2017,
#     y = ~BI.EMP.FRML.PB.ZS, # as share of paid employment
#     showlegend = TRUE,
#     visible = TRUE,
#     alpha = a.p6, 
#     alpha_stroke = a.p6
#   ) %>%
#   layout(
#     colorway = brewer.pal(3, 'Dark2'),
#     title = list(
#       text = "Shares of Public Sector Employment and Log Total Number of Workers",
#       size = 20
#     ),
#     xaxis = list(
#       type = 'log',
#       title = list(
#         text = 'Log GDP per capita (2017 Constant USD)'
#       )
#     ),
#     yaxis = list(
#       title = list(
#         text = "Public sector employment as Share of Employment Type"
#       )
#     )
#   )
#   
# 
#   # add loess lines 
# p6.1 <-  add_lines(
#     x = ~gdp_pc2017,
#     y = tot.pred$fit
#   )




data("EuStockMarkets")
data <- EuStockMarkets[,1]



# 7: remake of graph 2: ----
# use formal employment vs gdp per capita, by country and best-fit lines for each, overall 

htp7 = paste('%{text}')

# 
#              '<br>Log GDP per cap.: %{x:.1f}',
#              '<br>Public Employment: %{y:.2f}%')

p7 <- 
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Formal Employment
  geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = region), alpha = a.p6) +
  # by region lines 
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS, color = region), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p6.li, na.rm = T, span = 01) +
  # overall line 
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS), method = 'loess',
              linetype = 1, size = 1.25, se = F, alpha = a.p6.li, na.rm = T, span = 01) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  # scale_color_manual(name = '',
  #                    labels = c("Total Employment", "Paid Employment", "Formal Employment"),
  #                    values = c("#1B9E77", "#D95F02", "#7570B3")) +
  theme_minimal() +
  #theme(legend.position = 'bottom') +
  labs(title = "",
       x = "GDP per Capita (in constant 2017 dollars)",
       y = "Public Employment as Share of Formal Employment",
       color = "")

p7


p7 <- ggplotly(p7)

p7 <- p7 %>%
  style(hovertemplate = htp7, legendgroup = 'group1', traces = 0:13) %>%
  style(hovertemplate = htp7, legendgroup = 'group2', traces = 14,
        showlegend = TRUE, name = 'Overall Trend') %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Region</b>'))
  ) 


p7
plotly_json(p7)
# change line type to dot for region
p7.2 <- p7 %>%
  style(line=list(dash='dot'), traces = 8:13) # chanes the by-region lines traces only
# change overall line to dot
p7.3 <- p7 %>%
  style(line=list(dash='dot', width = 5), traces = 14)
p7.3




# 8: employment vs gdp with animation 

# inspect keyvars of wwbi 
subset1 <- wwbi %>%
  select(ctyname, year, gdp_pc2017, BI.EMP.TOTL.PB.ZS, BI.EMP.PWRK.PB.ZS, BI.EMP.FRML.PB.ZS) %>%
  # keep only if year, gdp and one of the three employment vars are non missing
  filter( (is.na(year) == FALSE & is.na(gdp_pc2017) == FALSE) ) %>%
  filter( (is.na(BI.EMP.TOTL.PB.ZS) == FALSE
          | is.na(BI.EMP.PWRK.PB.ZS) == FALSE)
          | is.na(BI.EMP.FRML.PB.ZS) == FALSE )

p8 <-
  ggplot(subset1, aes(x = gdp_pc2017)) +
  # Total Employment
  geom_point(aes(y = BI.EMP.TOTL.PB.ZS, frame = year, ids = ctyname,
                 color = '#1B9E77'), alpha = a.p6) +
  stat_smooth(aes(y =BI.EMP.TOTL.PB.ZS, color = '#1B9E77'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p6.li) +
  # Paid Employment
  geom_point(aes(y = BI.EMP.PWRK.PB.ZS, frame = year, ids = ctyname,
                color = '#D95F02'), alpha = a.p6) +
  stat_smooth(aes(y =BI.EMP.PWRK.PB.ZS, color = '#D95F02'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p6.li) +
  # Formal Employment
  geom_point(aes(y = BI.EMP.FRML.PB.ZS, frame = year, ids = ctyname,
                color = '#7570B3'), alpha = a.p6) +
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS, color = '#7570B3'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p6.li) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  scale_color_manual(name = '',
                     labels = c("Total Employment", "Paid Employment", "Formal Employment"),
                     values = c("#1B9E77", "#D95F02", "#7570B3")) +
  theme_minimal() +
  theme(legend.position = 'bottom') +
  labs(title = "",
       x = "GDP per Capita (in constant 2017 dollars)",
       y = "Public Employment (Share of Country-wide Employment)",
       color = "Measure of Country-wide Employment")

p8 <- ggplotly(p8) %>%
  style(hovertemplate = htp6, name ='Total Employment', traces = c(1,2)) %>%
  style(hovertemplate = htp6, name = 'Paid Employment', traces = c(3,4)) %>%
  style(hovertemplate = htp6, name = 'Formal Employment', traces = c(5,6)) %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Measures of Public Employment</b>'))
  ) 
  # animation settings
p8 <- p8 %>%
  #animation_opts(frame = 1500, transition = 1000, easing = 'linear', redraw = F) %>%
  animation_slider(currentvalue = list(prefix = "Year ", font = list(color="purple")))


p8
plotly_json(p8)





# Export ----

save(
p1, p2, p2_1, p3, p3_1, p4, p5, p6, p6.1, p7, p7.2, p7.3, p8,
wwbi,
file = file.path(wwbi_dat, "wwbi.Rdata")
)
