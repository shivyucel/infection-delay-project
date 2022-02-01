library(ggsci)
library(ggmap)
library(tidyverse)
library(ggspatial)
library(sf)
library('sf')


hex_geom <- st_read("/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/paper_data/hex_geom_shp/hex_geom.shp", quiet=TRUE)

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


ggplot(data=hex_geom) + 
  annotation_map_tile('cartolight', zoom=10) +
  geom_sf(mapping = aes(fill=weighted_I), lwd = 0, color='NA') + 
  scale_fill_viridis_c(option='B', direction = -1) +
  theme_minimal() + 
  labs(fill='Weighted Infection Delay') 

  
