library(ggmap)
library(raster)
library(data.table)

shinydata <- fread("shiny/data/final.csv")
register_google(key = 'AIzaSyARb8qVUDApEefnwmxTlq5RTYY5lxEu5_Y')

p <- get_googlemap("seoul", zoom = 11, maptype = 'roadmap') %>% ggmap()

map <- shapefile('TL_SCCO_SIG.shp')


save.image(file="shiny/data/lotto.RData")

