# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #
# main.R
# runs all disparate scripts for bl-data-vis graphs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #


library(tidyverse)
library(plotly)
library(rmarkdown)
library(assertthat)




    # users #
user <- 1
# 1 = tom 
# 2 = ?




    # file paths #

# for Tom
if (user == 1) {
# scripts
repo <- "C:/Users/WB551206/local/GitHub/placeholder-bl-data-viz"  
# data 
wwbi_dat <- "C:/Users/WB551206/OneDrive - WBG/Documents/WB_data/wwbi"
}

# for ??
if (user == 2) {
  # scripts
  repo <- ""  
  # data 
  wwbi <- ""
}



    # toggles # 

tidy    = 1
graphs  = 1




    # run scripts #
if (tidy == 1) {
  source(file = file.path(repo, "tidy.R"))
}

# run scripts #
if (graphs == 1) {
  source(file = file.path(repo, "graphs.R"))
}

#credits https://www.r-bloggers.com/2018/07/how-to-add-trend-lines-in-r-using-plotly/
# https://stackoverflow.com/questions/56758733/in-r-use-and-k-as-a-y-axis-labels-for-thousands-of-dollars
# https://stackoverflow.com/questions/32098836/ggplotly-r-labeling-trace-names
# 
