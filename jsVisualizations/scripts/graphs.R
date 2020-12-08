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
  style( name ='Total Employment', traces = c(1,2)) %>% # hovertemplate = htf1,
  style( name = 'Paid Employment', traces = c(3,4)) %>%
  style( name = 'Formal Employment', traces = c(5,6)) %>%
  layout(
    title = list(
      text = "<b>Public Employment as a Share of Country-wide Employment</b>",
      y = 0.98
    ),
    legend = list(title = list(text = '<b>Measures of Public Employment</b>'))
  ) 


f1
plotly_json(f1)

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
               '<br>Comparison Value: <b>%{z:.2f}</b>',
               '<extra></extra>')


# make heatmap
hmp <- plot_ly(
  data = wwbi_hmp,
  type = 'heatmap',
  x = ~indicator,
  y = ~ctycode,
  z = ~value,
  colorbar = list(tickmode = 'auto', title = "Comparison Value"),
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
  f1, f2.1, f2.2, f2.3, hmp, p9a, p9c, p9c,
wwbi,
file = file.path(wwbi_dat, "wwbi.Rdata")
)
