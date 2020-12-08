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










# f1 public employment % vs gdp ----


a.f1 = 0.3
a.f1.li = 0.5

htf1 = paste('Log GDP per cap.: %{x:.1f}',
             '<br>Public Employment: %{y:.2f}%')

f1 <-
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Total Employment
  geom_point(aes(y = BI.EMP.TOTL.PB.ZS, color = '#1B9E77'), alpha = a.f1) +
  stat_smooth(aes(y =BI.EMP.TOTL.PB.ZS, color = '#1B9E77'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
  # Paid Employment
  geom_point(aes(y = BI.EMP.PWRK.PB.ZS, color = '#D95F02'), alpha = a.f1) +
  stat_smooth(aes(y =BI.EMP.PWRK.PB.ZS, color = '#D95F02'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
  # Formal Employment
  geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = '#7570B3'), alpha = a.f1) +
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS, color = '#7570B3'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.f1.li) +
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

f1 <- ggplotly(f1) %>%
  style(hovertemplate = htf1, name ='Total Employment', traces = c(1,2)) %>%
  style(hovertemplate = htf1, name = 'Paid Employment', traces = c(3,4)) %>%
  style(hovertemplate = htf1, name = 'Formal Employment', traces = c(5,6)) %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Measures of Public Employment</b>'))
  ) 





# f2 formal employment vs gdp per capita: ----
# use formal employment vs gdp per capita, by country and best-fit lines for each, overall 

htf2 = paste('%{text}')


# f2.1: breakout by region
f2.1 <- 
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Formal Employment
  geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = region), alpha = a.f1) +
  # overall line 
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS), method = 'loess',
              linetype = 1, size = 1.25, se = F, alpha = a.f1.li, na.rm = T, span = 01) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  theme_minimal() +
  labs(title = "",
       x = "GDP per Capita (in constant 2017 dollars)",
       y = "Public Employment as Share of Formal Employment",
       color = "")

f2.1 <- ggplotly(f2.1) %>%
  style(hovertemplate = htf2, legendgroup = 'East Asia & Pacific', traces = 1) %>%
  style(hovertemplate = htf2, legendgroup = 'Europe & Central Asia', traces = 2) %>%
  style(hovertemplate = htf2, legendgroup = 'Latin America & Caribbean', traces = 3) %>%
  style(hovertemplate = htf2, legendgroup = 'Middle East & North Africa', traces = 4) %>%
  style(hovertemplate = htf2, legendgroup = 'North America', traces = 5) %>%
  style(hovertemplate = htf2, legendgroup = 'South Asia', traces = 6) %>%
  style(hovertemplate = htf2, legendgroup = 'Sub-Saharan Africa', traces = 7) %>%
  style(hovertemplate = htf2, legendgroup = 'Overall Trend', traces = 8,
        showlegend = TRUE, name = 'Overall Trend') %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Formal Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Region</b>'))
  ) 


# 7.2: breakout by income bracket 
f2.2 <- 
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Formal Employment
  geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = income), alpha = a.f1) +
  # overall line 
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS), method = 'loess',
              linetype = 1, size = 1.25, se = F, alpha = a.f1.li, na.rm = T, span = 01) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  theme_minimal() +
  labs(title = "",
       x = "GDP per Capita (in constant 2017 dollars)",
       y = "Public Employment as Share of Formal Employment",
       color = "")

f2.2 <- ggplotly(f2.2) %>%
  style(hovertemplate = htf2, legendgroup = 'High Income', traces = 1) %>%
  style(hovertemplate = htf2, legendgroup = 'Low Income', traces = 2) %>%
  style(hovertemplate = htf2, legendgroup = 'Lower Middle Income', traces = 3) %>%
  style(hovertemplate = htf2, legendgroup = 'Upper Middle Income', traces = 4) %>%
  style(hovertemplate = htf2, legendgroup = 'group2', traces = 5,
        showlegend = TRUE, name = 'Overall Trend') %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Formal Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Income Group</b>'))
  ) 



# 7.3: breakout by lending categories
f2.3 <- 
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Formal Employment
  geom_point(aes(y = BI.EMP.FRML.PB.ZS, color = lending), alpha = a.f1) +
  # overall line 
  stat_smooth(aes(y =BI.EMP.FRML.PB.ZS), method = 'loess',
              linetype = 1, size = 1.25, se = F, alpha = a.f1.li, na.rm = T, span = 01) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  theme_minimal() +
  labs(title = "",
       x = "GDP per Capita (in constant 2017 dollars)",
       y = "Public Employment as Share of Formal Employment",
       color = "")

f2.3 <- ggplotly(f2.3) %>%
  style(hovertemplate = htf2, legendgroup = 'Blend', traces = 1) %>%
  style(hovertemplate = htf2, legendgroup = 'IBRD', traces = 2) %>%
  style(hovertemplate = htf2, legendgroup = 'IDA', traces = 3) %>%
  style(hovertemplate = htf2, legendgroup = 'Not Classified', traces = 4) %>%
  style(hovertemplate = htf2, legendgroup = 'group2', traces = 5,
        showlegend = TRUE, name = 'Overall Trend') %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Formal Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Lending Category</b>'))
  ) 



plotly_json(f2.3)



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



# 3d scatter plot ----

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
colorp5 <- brewer.pal(n_distinct(wwbi$region), "Set1")



p5 <- 
  plot_ly(data = wwbi) %>%
  add_trace(
    type = 'scatter3d',
    mode = 'markers',
    color = ~region,
    colors = colorp5,
    size = ~ln_gdp,
    x = ~ BI.EMP.TOTL.PB.ZS, # share of total employment
    y = ~ BI.EMP.PWRK.PB.ZS, # share of paid employment
    z = ~BI.EMP.FRML.PB.ZS,  # share of formal employment
    text = ~ctyname,
    alpha = 0.7,
    hovertemplate = p5temp,
    marker = list(sizeref = 0.5, sizemin = 4, line = list(width = 0))
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

# using only 3 most recent observations
p5.1 <- 
  plot_ly(data = subset2) %>%
  add_trace(
    type = 'scatter3d',
    mode = 'markers',
    color = ~region,
    colors = colorp5,
    size = ~ln_gdp,
    x = ~ BI.EMP.TOTL.PB.ZS, # share of total employment
    y = ~ BI.EMP.PWRK.PB.ZS, # share of paid employment
    z = ~BI.EMP.FRML.PB.ZS,  # share of formal employment
    text = ~ctyname,
    alpha = 0.7,
    hovertemplate = p5temp,
    marker = list(sizeref = 0.5, sizemin = 4, line = list(width = 0))
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
  






# wage bill as percentage of economic measures  ----
# graph a: using y as % of gdp 


a.p9 = 0.3
a.p9.li = 0.5

htp9 = paste('Log GDP per cap.: %{x:.1f}',
             '<br>Wage Bill: %{y:.2f}%')

p9a <-
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Wage bill As % of gdp 
  geom_point(aes(y = BI.WAG.TOTL.GD.ZS, color = region), alpha = a.p9) +
  stat_smooth(aes(y =BI.WAG.TOTL.GD.ZS, color = '#1B9E77'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p9.li) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  # scale_color_manual(name = ''
  #                    labels = c("Total Employment", "Paid Employment", "Formal Employment"),
  #                    values = c("#1B9E77", "#D95F02", "#7570B3")
  #                    ) +
  theme_minimal() +
  theme(legend.position = 'bottom') +
  labs(title = "",
       x = "",
       y = "",
       color = "")

p9a <- ggplotly(p9a) %>%
 style(hovertemplate = htp9, name ='Global Trend', legendgroup = 2, traces = c(8)) %>%
 style(hovertemplate = htp9, legendgroup = 1, traces = c(1:7)) %>%
  layout(
    title = list(
      text = "<b>Wage Bill Expenditure Across GDP per Capita</b>",
      y = 0.98
    ),
    xaxis = list(
      title = list(text = "<b>GDP per Capita (in constant 2017 dollars)</b>")
    ),
    yaxis = list(
      title = list(text = "<b>Wage Bill as Percent of GDP</b>"),
      tickmode = 'array',
      range = c(0,20),
      tickvals = c(0,5,10,15,20),
      ticktext = c(0,5,10,15,20)
    ),
    legend = list(title = list(text = '<b>Region</b>'))
  ) 




# graph b: using y as % pof public expenditure

p9b <-
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # Wage bill As % of public expenditure
  geom_point(aes(y = BI.WAG.TOTL.PB.ZS, color = region), alpha = a.p9) +
  stat_smooth(aes(y= BI.WAG.TOTL.PB.ZS, color = '#1B9E77'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p9.li) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  # scale_color_manual(name = ''
  #                    labels = c("Total Employment", "Paid Employment", "Formal Employment"),
  #                    values = c("#1B9E77", "#D95F02", "#7570B3")
  #                    ) +
  theme_minimal() +
  theme(legend.position = 'bottom') +
  labs(title = "",
       x = "",
       y = "",
       color = "")

p9b <- ggplotly(p9b) %>%
  style(hovertemplate = htp9, name ='Global Trend', legendgroup = 2, traces = c(8)) %>%
  style(hovertemplate = htp9, legendgroup = 1, traces = c(1:7)) %>%
  layout(
    title = list(
      text = "<b>Wage Bill Expenditure Across GDP per Capita</b>",
      y = 0.98
    ),
    xaxis = list(
      title = list(text = "<b>GDP per Capita (in constant 2017 dollars)</b>")
    ),
    yaxis = list(
      title = list(text = "<b>Wage Bill as Percent of Public Expenditure</b>"),
      range = c(0,60),
      tickvals = c(0, 10, 20, 30, 40, 50, 60),
      ticktext = c(0, 10, 20, 30, 40, 50, 60)
    ),
    legend = list(title = list(text = '<b>Region</b>'))
  ) 




# combinding graphs 9a and 9b

colorp9 <- c(RColorBrewer::brewer.pal(8, 'Set2'),
             RColorBrewer::brewer.pal(8, 'Set2'))

p9c <- 
  ggplot(wwbi, aes(x = gdp_pc2017)) +
  # using wage bill as % of gdp
  geom_point(aes(y = BI.WAG.TOTL.GD.ZS, color = region), alpha = a.p9) +
  stat_smooth(aes(y =BI.WAG.TOTL.GD.ZS, color = '#da70d6'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p9.li) +
  # Wage bill As % of public expenditure
  geom_point(aes(y = BI.WAG.TOTL.PB.ZS, color = region), alpha = a.p9) +
  stat_smooth(aes(y= BI.WAG.TOTL.PB.ZS, color = '#1e90ff'), method = 'loess',
              linetype = 1, size = 0.5, se = F, alpha = a.p9.li) +
  scale_x_log10(n.breaks = 6, labels = scales::label_number(accuracy=1,suffix='k',scale=1e-3)) +
  theme_minimal() +
  theme(legend.position = 'bottom') +
  labs(title = "",
       x = "",
       y = "",
       color = "")

p9c <- ggplotly(p9c) %>%
  style(hovertemplate = htp9, name ='Global Trend: Wage Bill as % of GDP', legendgroup = 1, traces = c(8),
        line = list(color = '#ff8c00')) %>%
  style(hovertemplate = htp9, name ='Global Trend: Wage bill as % of Public Expenditure',
        legendgroup = 2, traces = c(16), line=list(color='#1e90ff')) %>%
  style(hovertemplate = htp9, legendgroup = 1, showlegend = T, traces = c(1:7),
        marker=list(symbol='circle-open')
        ) %>%
  style(hovertemplate = htp9, legendgroup = 2, showlegend = T, traces = c(9:15),
        marker=list(symbol='square', opacity=0.6)) %>%
  layout(
    title = list(
      text = "<b>Wage Bill Expenditure Across GDP per Capita</b>",
      y = 0.98
    ),
    xaxis = list(
      title = list(text = "<b>GDP per Capita (in constant 2017 dollars)</b>")
    ),
    yaxis = list(
      title = list(text = "<b>Wage Bill in Percent </b>"),
      range = c(0,60),
      tickvals = c(0, 10, 20, 30, 40, 50, 60),
      ticktext = c(0, 10, 20, 30, 40, 50, 60)
    ),
    legend = list(title = list(text = '<b>Region</b>'), traceorder = 'reversed'),
    colorway = colorp9
  ) 

p9c

plotly_json(p9c)








                        ### Cross-Country Comparison ####
# hover text for heatmap
hmp.ht = paste('Country: <b>%{y}</b>',
               '<br>Indicator: <b>%{x}</b>',
               '<br>Scaled Value: <b>%{z:.2f}</b>',
               '<extra></extra>')


# make heatmap
hmp <- plot_ly(
  data = wwbi_hmp,
  type = 'heatmap',
  x = ~indicator,
  y = ~ctycode,
  z = ~value,
  colorbar = list(tickmode = 'array', tickvals = c(0.0, 0.25, 0.50, 0.75, 1.0), title = "Scaled Value"),
  hovertemplate = hmp.ht
) %>%
  layout(
    plot_bgcolor = "#dcdcdc",
    title = list(text = "<b>Comparing Indicators Across Countries</b>"),
    yaxis = list(
      title = list(text = "Country"),
      categoryorder = 'total ascending',
      tickfont = list(size = 8)
    ),
    xaxis = list(
      title = list(text = "Indicator"),
      showgrid = FALSE,
      categoryorder = 'array', 
      categoryarray = n.miss$var, # arrangement by descending order of missing values
      tickmode = 'array',
      tickvals = n.miss$var, #tickvals must be defined for custom labels to work below
      ticktext = c("Hospital Doctor", "Hospital Nurse",        
                    "Primary School Teacher", "Police Officer",
                    "Secondary School Teacher", "Judge",
                    "University Teacher", "Government Economist",
                    "Senior Official")
    )
  )



# Export ----

save(
p3, p3_1, p4, p5, p5.1, p6, p6.1, p7, p7.2, p7.3, p8, hmp, p9a, p9c, p9c,
wwbi,
file = file.path(wwbi_dat, "wwbi.Rdata")
)
