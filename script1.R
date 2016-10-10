library(ggmap)
library(mapproj)
map <- get_map(location = 'Europe', zoom = 4)
ggmap(map)

library(rworldmap)
newmap <- getMap(resolution = "low")
plot(newmap)

plot(newmap,
     xlim = c(-20, 59),
     ylim = c(35, 71),
     asp = 1
)

library(ggmap)
europe.limits <- geocode(c("CapeFligely,RudolfIsland,Franz Josef Land,Russia",
                           "Gavdos,Greece",
                           "Faja Grande,Azores",
                           "SevernyIsland,Novaya Zemlya,Russia")
)
europe.limits

plot(newmap,
     xlim = range(europe.limits$lon),
     ylim = range(europe.limits$lat),
     asp = 1
)


places <- geocode(c("Poznan",
          "Athens,Greece",
          "Pulawy"))

newmap <- getMap(resolution = "low")
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1.5)
points(places$lon, places$lat, col = "red", cex = .6)


mapPoints <- ggmap(map) + geom_point(aes(x = lon, y = lat, size = 1), data = places, alpha = .5)
mapPoints
#mapPointsLegend <- mapPoints + scale_area(breaks = sqrt(c(1, 5, 10, 50, 100, 500)), labels = c(1, 5, 10, 50, 100, 500), name = "departing routes")