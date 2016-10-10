library(ggmap)
#library(mapproj)

places_poland <- read.table("resources/locations_Poland.txt", sep="\t", stringsAsFactors = F, header=T, encoding="UTF-8")
coord_poland <- geocode(places_poland$location, force=F)
places_poland <- cbind(places_poland, coord_poland)

poznan <- geocode("poznan")
radzikow <- geocode("radzikow")

places_poland$vjust <- ifelse(places_poland$lat > radzikow$lat, -1, 2)
places_poland$hjust <- ifelse(places_poland$lat > radzikow$lat, -0.1, 0.3)
places_poland$vjust[places_poland$lat ==  poznan$lat] <- -3
places_poland$hjust[places_poland$lat ==  poznan$lat] <- 0.2
places_poland$vjust[13] <- 0.6
places_poland$hjust[13] <- -0.1

poland <- borders("world", xlim = c(16, 20), ylim = c(52, 53), colour="gray70", fill="gray90") 
ggplot() + poland + theme_void() + 
  geom_segment(data=places_poland, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat), colour="grey60") +
  geom_point(aes(x = lon, y = lat, size = size+5), data = places_poland, alpha = .5) +
  geom_text(aes(x=lon, y=lat, label=label), size=2, data=places_poland, 
                      hjust=places_poland$hjust, vjust=places_poland$vjust) +
  theme(legend.position="none", plot.title = element_text(size=12)) + 
  ggtitle("Współpraca krajowa Instytutu Genetyki Roślin PAN w 2015 roku")

ggsave("img/collaboration_poland_bw.png", dpi = 600)
ggsave("img/collaboration_poland_bw.jpg", dpi = 600)

