library(ggmap)
#library(mapproj)

# version 1 for "places" file (individual institutions) 
{
places <- read.delim2("places", sep="\t", stringsAsFactors = F)
coord <- geocode(places$name, force=F)
err <- is.na(coord$lon)
coord[err,] <- geocode(places$location[err], force=F)
poznan <- geocode("poznan")

map <- get_map(location = 'Poland', zoom = 6)
ggmap(map)
mapPoints <- ggmap(map) + 
  geom_segment(data=coord, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_point(aes(x = lon, y = lat, size = 1, label=name), data = places, alpha = .5) +
  geom_text(aes(label=name), data=places, position = "jitter") +
  theme(legend.position="none")
mapPoints
}

#version 2 for "locations_Poland.tsv" file with groups per location & labels
places <- read.table("locations_Poland.tsv", sep="\t", stringsAsFactors = F, header=T, encoding="UTF-8")
coord <- geocode(places$location, force=F)
poznan <- geocode("poznan")
radzikow <- geocode("radzikow")
places <- cbind(places, coord)
places$vjust <- ifelse(places$lat > radzikow$lat, -1, 2)
places$hjust <- ifelse(places$lat > radzikow$lat, -0.1, 0.3)
places$vjust[places$lat ==  poznan$lat] <- -3
places$hjust[places$lat ==  poznan$lat] <- 0.2

#map <- get_map(location = "Poland", zoom=6, maptype = "satellite") #color
map <- get_map(location = c(18, 52), maptype = "toner-background", zoom=6, source="stamen")
ggmap(map)
mapPoints <- ggmap(map) + 
  geom_segment(data=places, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat), alpha=.2) +
  geom_point(aes(x = lon, y = lat, size = size+5), data = places, alpha = .5) +
  theme(legend.position="none")
mapPoints + geom_text(aes(label=label), size=1.6, data=places, hjust=places$hjust, vjust=places$vjust) #, position="jitter")
#ggsave("poland_color.png", dpi = 300)
ggsave("poland_bw.png", dpi = 300)

#version 3 with openStreetMaps
omap <- openmap(c(55, 13), c(49,25), zoom=7)
omap <- openproj(omap)
autoplot(omap) + geom_segment(data=places, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_point(aes(x = lon, y = lat, size = size+2), data = places, alpha = .5) +
  theme(legend.position="none") +
  geom_text(aes(label=label), data=places, hjust=0.2, vjust=2)

#version 1 Europe
#map <- get_map(location = "Europe", zoom=4) #color
map <- get_map(location = "Europe", maptype = "toner-background", zoom=4, source="stamen")
ggmap(map)
mapPoints <- ggmap(map) + 
  geom_segment(data=places, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat), alpha=.2) +
  geom_point(aes(x = lon, y = lat, size = size+5), data = places, alpha = .5) +
  theme(legend.position="none")
mapPoints + geom_text(aes(label=label), size=1.6, data=places, hjust=places$hjust, vjust=places$vjust) #, position="jitter")
#ggsave("poland_color.png", dpi = 300)
ggsave("poland_bw.png", dpi = 300)

# version 2 Europe
coord2 <- geocode(c("Rome", "Berlin", "Paris", "Moscow", "Prague"))

mapWorld <- borders("world", "Norway", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld
mp + 
  #geom_point(aes(x = lon, y = lat, size = 3), data = poznan, alpha = .5) +
  geom_segment(data=coord2, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_point(aes(x = lon, y = lat, size = 0.1), data = coord2, alpha = .5) + 
  theme(legend.position="none")
ggsave("europe.png", dpi=900)

map <- get_map(location = "Europe", zoom=4) 

coord2 <- geocode(c("Mexico", "China", "Paris", "Canberra"))
#version 1 world with openStreetMap
install.packages("OpenStreetMap")
library(OpenStreetMap)
library(ggplot2)
map <- openmap(c(70,-179), c(-70,179), zoom=1)
map <- openproj(map)
autoplot(map) + 
  geom_segment(data=coord2, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_point(aes(x = lon, y = lat, size = 1), data = coord2, alpha = .5) + theme(legend.position="none")


{
  #version 1 world with openStreetMap
  install.packages("OpenStreetMap")
  library(OpenStreetMap)
  library(ggplot2)
  map <- openmap(c(70,-179), c(-70,179), zoom=1)
  map <- openproj(map)
  autoplot(map) + 
    geom_segment(data=places, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
    geom_point(aes(x = lon, y = lat, size = 1), data = places, alpha = .5) + theme(legend.position="none")
  }


#version 2 world with ggplot2::borders
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld
mp + 
  geom_point(aes(x = lon, y = lat, size = 10), data = poznan, alpha = .1) +
  geom_segment(data=places_world, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_point(aes(x = lon, y = lat, size = 2), data = places_world, alpha = .5) + 
  theme(legend.position="none")
ggsave("world_bw.png", dpi = 900)

map <- get_map(location = "Europe", maptype = "terrain", zoom=4)#, source="stamen")
ggmap(map)


#map <- get_map(location = "Poland", zoom=6, maptype = "satellite") #color
map <- get_map(location = c(18, 52), maptype = "toner-background", zoom=6, source="stamen")
ggmap(map)
mapPoints <- ggmap(map) + 
  geom_segment(data=places, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat), alpha=.2) +
  geom_point(aes(x = lon, y = lat, size = size+5), data = places, alpha = .5) +
  theme(legend.position="none")
mapPoints + geom_text(aes(label=label), size=1.6, data=places, hjust=places$hjust, vjust=places$vjust) #, position="jitter")
#ggsave("poland_color.png", dpi = 300)
ggsave("poland_bw.png", dpi = 300)


#version 3 with openStreetMaps
omap <- openmap(c(55, 13), c(49,25), zoom=7)
omap <- openproj(omap)
autoplot(omap) + geom_segment(data=places, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_point(aes(x = lon, y = lat, size = size+2), data = places, alpha = .5) +
  theme(legend.position="none") +
  geom_text(aes(label=label), data=places, hjust=0.2, vjust=2)


