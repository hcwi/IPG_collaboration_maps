places_zbb <- read.delim2("resources/locations_ZBB.txt", sep="\t", stringsAsFactors = F, encoding="UTF-8" )
coord_zbb <- geocode(places_zbb$location, force=F)
places_zbb <- cbind(places_zbb, coord_zbb)

poznan <- geocode("poznan")

europe <- borders("world", xlim = c(-10, 22), ylim = c(42, 55), colour="gray70", fill="gray90") 
ggplot() + europe + theme_void() +
  geom_point(aes(x = lon, y = lat, size = 1), data = poznan, alpha = .2) +
  geom_segment(data=places_zbb, aes(x=lon, y=lat, xend=poznan$lon, yend=poznan$lat)) +
  geom_point(aes(x = lon, y = lat, size = 2), data = places_zbb, alpha = .3) + 
  geom_text(aes(x=lon, y=lat, label=label, size=1.1), data=places_zbb[-6, ], position="jitter", vjust=2) +
  geom_text(aes(x=lon, y=lat, label=label, size=1.1), data=places_zbb[6, ], position="jitter", vjust=-1.2, hjust=0.2) +
  theme(legend.position="none", plot.title = element_text(size=10)) + 
  ggtitle("Współpraca Zakładu Biometrii i Bioinformatyki IGR PAN w ramach programu TransPLANT\n(udostępnianie baz danych)")

ggsave("img/collaboration_zbb_bw.png", dpi=900)
ggsave("img/collaboration_zbb_bw.jpg", dpi=600)
