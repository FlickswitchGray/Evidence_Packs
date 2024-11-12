library(sf)
library(magrittr)
library(tidyverse)
library(leaflet)
library(lubridate)


catch <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/Interim_WFD_2022.shp")# Catchment shapefiles
CAT <- catch[catch$OPCAT_NAME == "Poole Harbour Rivers",]


CAT_Union <- st_union(CAT) %>% 
  st_transform(4326)

CAT_27700 <- CAT
CAT <- CAT %>%  st_transform(4326)


CPS <- read.csv("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/ETL_Exports/CPS_101024_wMeasures.csv")

RFF <- read.csv("/dbfs/FileStore/WSX_HGray/RFF.csv")
RFF <- RFF[RFF$OPERATIONAL_CATCHMENT %in% c("Poole Harbour Rivers","Poole Harbour Rivers TraC"),]


CAT_geo <- subset(CAT, select = c(WB_ID, geometry))

CPS_sf <- inner_join(CAT_geo, CPS, by = c("WB_ID" = "WATERBODY_ID"))


#Detailed River Network Load in
DRN <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/DRN/DRN_Merged_MCAT.shp")
DRN <- DRN[CAT,]
