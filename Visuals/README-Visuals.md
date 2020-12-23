# README-Visuals.md
The `Visuals` folder contains all the javascript-based and shiny-based visualizations for the WWBI. The folder also includes the code necessary for creating these visuals. The generalized code for all post-WWBI processing is under `~/Visuals/Main-Code` and code that is relevant only to specific projects is located in the relevant folder. Note though, that all code can be called from the main script `~/Visuals/Main-Code/main.R`.

## Main Code 
The main code folder includes two scripts in addition to the main script. `tidy.R` merges data from the World Development Indicators (WDI) and the World Bank's World Polygon (Admin level 0) dataset to the WWBI, as well as other tidying. In `graphs.R`, we create all graph objects using ggplot and plotly, which are then used in subsequent scripts throughout the project. 

## Dashboards 
The `~/Visuals/Dashboards` folder contains shiny dashboards for WWBI versions 1.0 and 2.0. 

## WWBI-Profiles-Comparison
This folder contains code to create country profiles for specific countries/economies and comparsions between different groups.