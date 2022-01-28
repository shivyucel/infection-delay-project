library(ggsci)
library(ggmap)
library(tidyverse)
library(ggspatial)
library(sf)
library('sf')


hex_geom <- st_read("hex_geom.shp", quiet=TRUE)


ggplot(data=hex_geom) + 
  annotation_map_tile('cartolight', zoom=10) +
  geom_sf(fill='blue', alpha=0.1, lwd = 0, color='NA') + 
  theme_minimal()


ggplot(data=hex_geom) + 
  annotation_map_tile('cartolight', zoom=10) +
  geom_sf(mapping = aes(fill=pop), lwd = 0, color='NA') + 
  scale_fill_viridis_c() +
  theme_minimal() + 
  labs(fill='Population') 
  
