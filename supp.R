library(data.table)
library(ggmap)

shinydata <- fread("data/final.csv")
register_google(key = 'AIzaSyARb8qVUDApEefnwmxTlq5RTYY5lxEu5_Y')

p <- get_googlemap("seoul", zoom = 11, maptype = 'roadmap') %>% ggmap()

map <- shapefile('TL_SCCO_SIG.shp')
map <- spTransform(map, CRSobj = CRS('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))
new_map <- fortify(map, region = 'SIG_CD') #데이터프레임화
new_map$id <- as.numeric(new_map$id)
seoul_map <- new_map[new_map$id <= 11740,]

save.image(file="data/lotto.RData")

