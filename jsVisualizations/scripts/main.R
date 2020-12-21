# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# main.R
# runs all disparate scripts for bl-data-vis graphs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #


library(tidyverse)
library(plotly)
library(rmarkdown)
library(assertthat)
library(knitr)




    # users #
user <- 1
# 1 = tom 
# 2 = ?




    # file paths #

# for Tom
if (user == 1) {
# scripts
code_top <- "C:/Users/WB551206/local/GitHub/Worldwide-Bureaucracy-Indicators"
repo <- file.path(code_top, "jsVisualizations/scripts")
# data 
wwbi_dat <- "C:/Users/WB551206/OneDrive - WBG/Documents/WB_data/wwbi"
wwbi_out <- file.path(wwbi_dat, "output")
}

# for ??
if (user == 2) {
  # scripts
  code_top <- "C:/Users/WB551206/local/GitHub/Worldwide-Bureaucracy-Indicators"
  repo <- file.path(code_top, "jsVisualizations/scripts")
  # data 
  wwbi_dat <- "C:/Users/WB551206/OneDrive - WBG/Documents/WB_data/wwbi"
  wwbi_out <- file.path(wwbi_dat, "output")
}




    # toggles # 

tidy    = 1
graphs  = 0
knit    = 0

# shiny 
coffee  = 1


    # run scripts #

# tidyr 
if (tidy == 1) {
  source(file = file.path(repo, "tidy.R"))
}

# generate graphs
if (graphs == 1) {
  source(file = file.path(repo, "graphs.R"))
}

# knit rmd document to html 
if (knit == 1) {
  rmarkdown::render(
    input = file.path(repo, "sample-wwbi-v1_1.Rmd"),
    output_format = 'html_document',
    output_file = file.path(wwbi_out, "wwbi-v1-1.html"),
    quiet = FALSE
  )
}

# shiny 
if (coffee == 1) {
  source(file = file.path(repo, "shiny/coffee/wwbi-coffee/MAIN-coffee.R"))
}




#credits https://www.r-bloggers.com/2018/07/how-to-add-trend-lines-in-r-using-plotly/
# https://stackoverflow.com/questions/56758733/in-r-use-and-k-as-a-y-axis-labels-for-thousands-of-dollars
# https://stackoverflow.com/questions/32098836/ggplotly-r-labeling-trace-names
# pal <- colorBin("YlOrRd", domain = wwbi_geo$gdp_pc2017,
# https://stackoverflow.com/questions/48953149/dynamic-color-fill-for-polygon-using-leaflet-in-shiny-not-working
# # https://stackoverflow.com/questions/60058905/addlegend-r-leaflet-based-on-user-input
# https://stackoverflow.com/questions/4946873/add-row-to-a-data-frame-with-total-sum-for-each-column
# http://stackoverflow.com/questions/35090883/ddg#35090981
# https://stackoverflow.com/questions/7455046/how-to-make-graphics-with-transparent-background-in-r-using-ggplot2
# http://stackoverflow.com/questions/49428073/ddg#49434520
# 




