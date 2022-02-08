
######### Household travel survey SP 2017 #########

library(foreign)
library(data.table)
library(sf)
library(sfheaders)
library(dplyr)


#### 1. Download data ----------------------------
#> http://www.metro.sp.gov.br/pesquisa-od/


#### 2. Read data base ----------------------------

od <- foreign::read.dbf(file = "OD_2017.dbf")
head(od)
setDT(od)


#### 3. Traveltime matrix between zones ----------------------------

time_matrix <- od[, .(mean_time = mean(DURACAO, na.rm=T)), by= .(ZONA_O, ZONA_D)]


#### 5. Get population data  ----------------------------

pop <- od[ F_PESS ==1, .(ZONA_O, FE_PESS, F_PESS, ID_PESS )]
pop <- pop[, .(pop2017 = sum(FE_PESS, na.rm=T)), by= .(ZONA_O)]
sum(pop$pop2017)



#### 4. Travel count matrix (number of people travelling between zones) ----------------------------


## Variável	Conteúdo
#
# ID_PESS	  Identifica Pessoa
# ZONA	    Zona do Domicílio
# N_VIAG	  Número da Viagem
# FE_VIA	  Fator de Expansão da Viagem
#
# FE_PESS	  Fator de Expansão da Pessoa
# F_PESS	Identifica Primeiro Registro da Pessoa
# ID_DOM	Identifica Domicílio

# ZONA_O	  Zona de Origem
# ZONA_D	  Zona de Destino
# 
# ZONA_T1	  Zona da 1ª Transferência
# ZONA_T2	  Zona da 2ª Transferência
# ZONA_T3	  Zona da 3ª Transferência
#
# DURACAO	  Duração da Viagem (em minutos)
# MODOPRIN	Modo Principal
# MODO1	    Modo 1
# TIPOVG	  Tipo de Viagem (1 - Coletivo, 2 - Individual, 3 - A pé, 4 - Bicicleta )








# Subset who made 0, 1, 2 and 3 transfers
  transfer0 <- subset(od, is.na(ZONA_T1) )
  transfer1 <- subset(od, !is.na(ZONA_T1) & is.na(ZONA_T2))
  transfer2 <- subset(od, !is.na(ZONA_T2) & is.na(ZONA_T3))
  transfer3 <- subset(od, !is.na(ZONA_T3))
  
  # make sure we didn't miss any trip
  (nrow(transfer0)+ nrow(transfer1)+ nrow(transfer2)+ nrow(transfer3)) == nrow(od)

  
  
### TRIP COUNT  
  
# coun matrix 0 transfers
trips_matrix0 <- transfer0[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_D)]

# trips matrix 1 transfers
trips_matrix1_leg1 <- transfer1[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_T1)]
trips_matrix1_leg2 <- transfer1[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T1, ZONA_D)]

# trips matrix 2 transfers
trips_matrix2_leg1 <- transfer2[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_T1)]
trips_matrix2_leg2 <- transfer2[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T1, ZONA_T2)]
trips_matrix2_leg3 <- transfer2[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T2, ZONA_D)]

# trips matrix 3 transfers
trips_matrix3_leg1 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_T1)]
trips_matrix3_leg2 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T1, ZONA_T2)]
trips_matrix3_leg3 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T2, ZONA_T3)]
trips_matrix3_leg4 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T3, ZONA_D)]


# Function harmonize column names so we can pille up all data sets
hamonize_colname <- function(df) { names(df)[1:2] <- c('ZONA_O', 'ZONA_D')
                                   return(df)
                                  }

# list all data sets
all_trips <- list(trips_matrix0 
                 , trips_matrix1_leg1 
                 , trips_matrix1_leg2 
                 , trips_matrix2_leg1 
                 , trips_matrix2_leg2 
                 , trips_matrix2_leg3 
                 , trips_matrix3_leg1 
                 , trips_matrix3_leg2 
                 , trips_matrix3_leg3 
                 , trips_matrix3_leg4
                 )
    
# Pille data sets up
trips_matrix <- lapply(X = all_trips, FUN = hamonize_colname) %>% rbindlist()

# sum final entire travel count matrix
trips_matrix <- trips_matrix[, .(trips_count = sum(trips, na.rm=T)), by= .(ZONA_O, ZONA_D)]
sum(count_matrix$count)


# # count matrix total (ignoring transfers)
# count_matrix_ignoretransf <- od[, .(count = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_D)]
# sum(count_matrix_ignoretransf$count)





### TRIP COUNT  

# coun matrix 0 transfers
trips_matrix0 <- transfer0[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_D)]

# trips matrix 1 transfers
trips_matrix1_leg1 <- transfer1[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_T1)]
trips_matrix1_leg2 <- transfer1[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T1, ZONA_D)]

# trips matrix 2 transfers
trips_matrix2_leg1 <- transfer2[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_T1)]
trips_matrix2_leg2 <- transfer2[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T1, ZONA_T2)]
trips_matrix2_leg3 <- transfer2[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T2, ZONA_D)]

# trips matrix 3 transfers
trips_matrix3_leg1 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_T1)]
trips_matrix3_leg2 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T1, ZONA_T2)]
trips_matrix3_leg3 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T2, ZONA_T3)]
trips_matrix3_leg4 <- transfer3[, .(trips = sum(FE_VIA, na.rm=T)), by= .(ZONA_T3, ZONA_D)]


# Function harmonize column names so we can pille up all data sets
hamonize_colname <- function(df) { names(df)[1:2] <- c('ZONA_O', 'ZONA_D')
return(df)
}

# list all data sets
all_trips <- list(trips_matrix0 
                  , trips_matrix1_leg1 
                  , trips_matrix1_leg2 
                  , trips_matrix2_leg1 
                  , trips_matrix2_leg2 
                  , trips_matrix2_leg3 
                  , trips_matrix3_leg1 
                  , trips_matrix3_leg2 
                  , trips_matrix3_leg3 
                  , trips_matrix3_leg4
)

# Pille data sets up
trips_matrix <- lapply(X = all_trips, FUN = hamonize_colname) %>% rbindlist()

# sum final entire travel count matrix
trips_matrix <- trips_matrix[, .(count = sum(trips, na.rm=T)), by= .(ZONA_O, ZONA_D)]
sum(trips_matrix$count)


# # count matrix total (ignoring transfers)
# count_matrix_ignoretransf <- od[, .(count = sum(FE_VIA, na.rm=T)), by= .(ZONA_O, ZONA_D)]
# sum(count_matrix_ignoretransf$count)


#### 5. Get spatial coordinates ----------------------------

# Read shape file of travel zones
zones <- sf::st_read("./data/OD2017/Mapas/Shape/Zonas_2017_region.shp")
st_crs(zones) <- 22523

# get centroids
centroids_sf <- sf::st_centroid(zones)

# convert to lat long
centroids_sf <- st_transform(centroids_sf, 4674)

# convert centroids form sf to data.frame and subset columns
centroids_df <- sfheaders::sf_to_df( centroids_sf, fill = TRUE )
centroids_df <- setDT(centroids_df)[, .(NumeroZona , x, y)]


# bring coodinates info to travel count matrix
count_matrix_coords <- dplyr::left_join(trips_matrix, centroids_df, by = c('ZONA_O'='NumeroZona'))
count_matrix_coords <- dplyr::left_join(count_matrix_coords, centroids_df, by = c('ZONA_D'='NumeroZona'))

# rename columns
names(count_matrix_coords)[4:7] <- c('lon_orig', 'lat_orig', 'lon_dest', 'lat_dest')
head(count_matrix_coords)

# add travel time info
matrix_coords <- dplyr::left_join(count_matrix_coords, time_matrix, by = c("ZONA_O", "ZONA_D"))
head(matrix_coords)


### Add population data  ----------------------------
matrix_coords <- dplyr::left_join(matrix_coords, pop, by = c("ZONA_O" = "ZONA_O"))
matrix_coords <- dplyr::left_join(matrix_coords, pop, by = c("ZONA_D" = "ZONA_O"))
head(matrix_coords)

names(matrix_coords)[9:10] <- c("pop_orig", "pop_dest")

#### 6. Save outputs ----------------------------

data.table::fwrite(matrix_coords, "./output/travel_matrix_spo2017.csv")

sf::st_write(zones, "./output/zones_spo2017.gpkg")

