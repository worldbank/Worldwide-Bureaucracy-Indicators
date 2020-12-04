# coffee-tidy.R
# prepares data for app

library(sf)
library(rjson)

# import world json 
world <- rjson::fromJSON(file = worldjson)

plot_ly() %>%
  add_trace(
    type = 'choropleth',
    geojson = world
  )
