places_world <- read.table("resources/locations_world.txt", sep="\t", stringsAsFactors = F, header=T, encoding="UTF-8")
coord_world <- geocode(places_world$location, force=F)
places_world <- cbind(places_world, coord_world)

poznan <- geocode("poznan")

places$vjust <- ifelse(places$lat > radzikow$lat, -1, 2)
places$hjust <- ifelse(places$lat > radzikow$lat, -0.1, 0.3)
places$vjust[places$lat ==  poznan$lat] <- -3
places$hjust[places$lat ==  poznan$lat] <- 0.2

#places_out <- places_world[(places_world$lon < -10 | places_world$lon > 32),][-2,]
places_out <- places_world[-1,]
places_out$hjust=0.2
places_out$hjust[11] = -0.2


world <- borders("world", xlim = c(-179, 179), ylim = c(-50, 80), colour="gray70", fill="gray90") 
ggplot() + world + theme_void() +
  geom_point(aes(x = lon, y = lat, size = 2), data = poznan, alpha = .3) +
  geom_segment(data=places_out[-11,], aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_segment(data=places_out[11,], aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat, linetype="dotted", alpha=0.5)) +
  geom_point(aes(x = lon, y = lat, size = 3), data = places_out[-11,], alpha = .5) + 
  geom_point(aes(x = lon, y = lat, size = 3), data = places_out[11,], alpha = .2) + 
  geom_text(aes(x=lon, y=lat, label=label), data=places_out[-11,], position="jitter", vjust=2, hjust=places_out[-11,]$hjust) +
  geom_text(aes(x=lon, y=lat, label=label), data=places_out[11,], position="jitter", vjust=1, hjust=places_out[11,]$hjust, alpha=0.5) +
  theme(legend.position="none", plot.title = element_text(size=12)) + 
  ggtitle("Współpraca Instytutu Genetyki Roślin PAN z krajami pozaeuropejskimi w 2015 roku")

ggsave("img/collaboration_world_bw.png", dpi=900)
ggsave("img/collaboration_world_bw.jpg", dpi=580)
