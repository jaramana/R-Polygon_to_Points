# Assign Polygons to Points
# 12/17/2019

# Packages
library(lubridate)
library(sf)
library(sp)
library(readr)
library(rgeos)
library(rgdal)

# Set directory
setwd("/PATH/TO/DIRECTORY")

# Load data from CabConnect
data <- read_csv("DOHMH_Farmers_Markets.csv")

# Read boro shapefiles
polygon <- readOGR(dsn = "nycd_19d", layer = "nycd")
polygon <-
  spTransform(polygon,
              CRS(
                "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
              ))


# Create Point Data Frame
LonLat <- 
  sp::SpatialPointsDataFrame(
    coordinates(cbind(data$Longitude, data$Latitude)),
    data,
    proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
  )

# Bind GeoCoded Data to Main Data Frame
data <- cbind(data, over(LonLat, polygon)$BoroCD)

# Change column name
colnames(data)[colnames(data)=="over(LonLat, polygon)$BoroCD"] <- "NYCD"

# Write .csv
write.csv(data,"DOHMH_Farmers_Markets_NYCD.csv", row.names = FALSE)