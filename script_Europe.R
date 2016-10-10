require(ggmap)

places <- read.table("resources/locations_Europe.txt", sep="\t", stringsAsFactors = F, header=T, encoding="UTF-8")
coord <- geocode(places$location, force=F)
places <- cbind(places, coord)

poznan <- geocode("poznan")

europe <- borders("world", xlim = c(-10, 26), ylim = c(40, 60), colour="gray70", fill="gray90") 
ggplot() + europe + theme_void() +
  geom_point(aes(x = lon, y = lat, size = 1), data = poznan, alpha = .2) +
  geom_segment(data=places, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat), colour="gray50") +
  geom_point(aes(x = lon, y = lat, size = 2), data = places, alpha = .3) + 
  geom_text(aes(x=lon, y=lat, label=label, size=1.1), data=places, position="jitter", vjust=1.5+1.8*places$vjust, hjust=5*places$hjust) +
  theme(legend.position="none", plot.title = element_text(size=12)) + 
  ggtitle("Współpraca Instytutu Genetyki Roślin PAN z krajami Europy w 2015 roku")

ggsave("img/collaboration_europe_bw.png", dpi=900)
ggsave("img/collaboration_europe_bw.jpg", dpi=600)