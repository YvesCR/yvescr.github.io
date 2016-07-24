---
layout: post
title: "Furthest point from the subway in London with Voronoi"
categories: [ Data visualisation, Statistic]
tags: [alphahull, data visualisation, geometry, R]
date: 2015-07-16
description: Finding the furthest point from the subway in London with Voronoi
photo_url: London3.png
---

A question was uplifted at the last R coding dojo. What is the location in central London which is the furthest from the subway?

The first bit of code of this question was made at the LondonR coding dojo, here:

https://github.com/London-R-Dojo/Dojo-repo/tree/master/July-2015-Dojo

Two approach was used to reply to this question:

-Mapping the point depending on the distance from the subway

-Using Voronoi diagram to analytically determine the furthest point.

 
The first approach produced a really nice plot of London when the second approach failed to pass the question of the border of an area,

In this blog post, I try to override this issue.

<h1> Method </h1>

In the alphahull package, the ashape function allow to create a close constraint, based on voronoi. It allow to calculate both the constraint and the voronoi vertices.

The function pnt.in.poly of the SDMTools allow to flag the voronoi vertices which are inside the constraint.

Combining both, allow me to create a constraint voronoi diagram in which I could look for the point the furthest from any subway station.

![london gif ]({{ site.baseurl }}/image/London.gif) 

<h1> The code </h1>

<h3> Libraries, data, raw map </h3>

Coordinates of stations could be found on the TFL website.
The function get_map() allows to plot a map in a really efficient way and quite fast.


{% highlight r %}
library(ggmap)
library(alphahull)
library(SDMTools) 
library(devtools)
library(animation) # install.packages("animation")
library(ImageMagick) #install_github("ImageMagick")
# load the libraries:
l <- lapply(c("data.table", "alphahull", "ggmap", "SDMTools", "sp"), require, character.only = T)

  # First, get the data:
coord.station <- fread("tfl.stations.csv")

  # Get the map of London:
london12 <- get_map(location = "London", zoom = 12)
zones.london.plot12 <- ggmap(london12, maprange = F) 

  # only zones 1 & inside the plot:
coord.station[, zone2 := ifelse(type == "dlr", "dlr", zone) ]
coord.station.min <- coord.station[zone == 1, list(lon, lat, zone2)]

  # plot stations
zones.london <- zones.london.plot12 +
          geom_point(data = coord.station.min, aes(x = lon, y = lat, colour = as.factor(zone2)), size = 1.5) +
          scale_colour_discrete(name = "Zone")
{% endhighlight %}





<h3> Voronoi & constraint calculation </h3>

The alpha parameter control the alpha-shape. The smallest the value, the more complicated the constraint.


{% highlight r %}
  # voronoi and constraint:
alphashape <- ashape(coord.station.min$lon, coord.station.min$lat, alpha = 0.021)

  # voronoi summits:
voronoi.full <- data.table(alphashape$delvor.obj$mesh)
polygon.ext <- data.frame(alphashape$edges)

# plot the voronoi diagram without constraint:
plot.no.map.voronoi <- zones.london +
  geom_segment(data = voronoi.full, aes(x = mx1, y = my1, xend = mx2, yend = my2), colour = "red", size=0.25) +
  geom_segment(data = polygon.ext, aes(x = x1, y = y1, xend = x2, yend = y2), colour = "blue", size=0.25)
plot.no.map.voronoi
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/figure/source/2015-07-16-Voronoi_station/unnamed-chunk-3-1.png) 

Now, we have the constraint and the voronoi diagram on all the subways station of the zone 1.

<h3> Keep the voronoi summits inside the constraint </h3>

As I want only the voronoi summit inside the constraint, I use the function pnt.in.poly to flag summit outside the constraint.

The function take only the ordered summit of the constraint as the polygon. The first loop allow to reorder the summits.



{% highlight r %}
 ## problem: voronoi summit are outside the polygon.
  #we are looking for the voronoi summits which are inside the polygon.
  # our issue here is that the function pnt.in.polygon need an ordered table of the summit.
  # And the function alphahull release an unordered set of points.

  # voronoi summits:
voronoi.summit <- unique(rbind(voronoi.full[, list(mx1, my1)], voronoi.full[, list(mx2, my2)], use.names = F))

  # do a channel with the variables ind1 et ind2:
nb.edges <- dim(polygon.ext)[1]
  
  # initialisation of the table:
order <- data.frame(order = rep(2, nb.edges), lon = rep(0, nb.edges), lat = rep(0, nb.edges), stringsAsFactors = F)

  # new table to modify:
polygon.ext2 <- polygon.ext

order[1, ] <- polygon.ext2[1, c("ind1", "x1", "y1")]
polygon.ext2 <- polygon.ext2[-1, ]
  
  # loop through the summits to select each time the next one:
for (i in 2: nb.edges) { # i <- 2
  if(order[i-1, 1] %in% polygon.ext2$ind1) { order[i, ] <- polygon.ext2[which(polygon.ext2$ind1 == order[i-1, 1]), c("ind2", "x2", "y2")]
  polygon.ext2 <- polygon.ext2[-which(polygon.ext2$ind1 == order[i-1, 1]), ]
  } else { order[i, ] <- polygon.ext2[which(polygon.ext2$ind2 == order[i-1, 1]), c("ind1", "x1", "y1")]
  polygon.ext2 <- polygon.ext2[-which(polygon.ext2$ind2 == order[i-1, 1]), ]}
}

  # list of voronoi summits which are in the polygon:
voronoi.constrain <- data.table(pnt.in.poly(voronoi.summit, order[, c("lon", "lat")]))

  # voronoi inside the polygon:
voronoi.part <- merge(voronoi.full, voronoi.constrain, by = c("mx1", "my1"), all.x = T)
setnames(voronoi.constrain, c("mx1", "my1"), c("mx2", "my2"))
voronoi.part <- merge(voronoi.part, voronoi.constrain, by = c("mx2", "my2"), all.x = T)

   # plot the voronoi diagram with constraint & only inside edge of voronoi diagram:
zones.london.vor <- zones.london +
  geom_segment(data = polygon.ext, aes(x = x1, y = y1, xend = x2, yend = y2), colour = "blue", size = 0.25) +
  geom_segment(data = voronoi.part[pip.x == 1 & pip.y == 1, ], aes(x = mx2, y = my2, xend = mx1, yend = my1), colour = "red", size = 0.25) 
zones.london.vor
{% endhighlight %}

![plot of chunk unnamed-chunk-4](/figure/source/2015-07-16-Voronoi_station/unnamed-chunk-4-1.png) 

<h3>  Finding the furthest point from the subway </h3>

I am looking for the voronoi summit the furthest from any subway station.
I use the spDistsN1 function to calculate the distance on a sphere.   


{% highlight r %}
### Finding the furthest point:
  # voronoi summit in the polygon
voronoi.constrain.lim <- voronoi.constrain[pip == 1, list(mx2, my2)]

  # matrix of distance between all the station and the voronoi summits: 
matrix.dist <- apply(voronoi.constrain.lim, 1, function(eachPoint) spDistsN1(as.matrix(coord.station.min[, list(lon, lat)]), eachPoint, longlat = T))

  # for each colum, the lowest distance:
min.dist <- apply(matrix.dist, 2, min)

  # coordonates of the furthest point:
min.coordinates <- voronoi.constrain.lim[which(matrix.dist == max(min.dist), arr.ind = T)[2]]

  # Thirdly, plotting the point:
zones.london.point <- zones.london.vor +
   geom_point(data = min.coordinates, aes(x = mx2, y = my2), color = "green", size = 2) +
  annotate("text", x = min.coordinates$mx2, y = min.coordinates$my2 - 0.003, label = "The albert memorial")
zones.london.point
{% endhighlight %}

![plot of chunk unnamed-chunk-5](/figure/source/2015-07-16-Voronoi_station/unnamed-chunk-5-1.png) 

In the end, it appears that the furthest point from the subway in London is near the Albert memorial. If you already find yourself hanging there and thinking that the next subway station was quite far, be rassured, it's definitely normal. :)


