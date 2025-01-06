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

Catchments <- c("Poole Harbour Rivers TraC", "Poole Harbour Rivers")

#Temporary RNAGs transforms
    RFF <- read.csv("/dbfs/FileStore/WSX_HGray/ETL_Exports/RFF.csv")
    RFF <- RFF[RFF$OPERATIONAL_CATCHMENT %in% Catchments,]

    
    # Temporary Measures Transforms.
# Provenenace: CPS SQL Server, EA Internal, SQL script reads, writes to csv then upload to databricks. 31/12/24
    Measures_Class <- read.csv("/dbfs/FileStore/WSX_HGray/ETL_Exports/Measure_Class.csv")  
    Measures_WBs <- read.csv("/dbfs/FileStore/WSX_HGray/ETL_Exports/wb_connections.csv") %>% 
      filter(AREA_NAME== "Wessex")
    Measures_Cat <- read.csv("/dbfs/FileStore/WSX_HGray/ETL_Exports/MES_CATS.csv")  
    
    
    Mes <- Measures_WBs %>% filter(OPERATIONAL_CATCHMENT %in% Catchments)
    
    
    # Cat                               
    
    CAT_geo <- subset(CAT, select = c(WB_ID, geometry))
    
    CPS_sf <- inner_join(CAT_geo, CPS, by = c("WB_ID" = "WATERBODY_ID"))
    
    
    #Detailed River Network Load in
    DRN <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/DRN/DRN_Merged_MCAT.shp")
    DRN <- DRN[CAT,]
    
    
# Styling #
    
# Define WFD palette
    pal <- colorFactor(
      palette = c("#ADE8F4", "seagreen", "seagreen", "yellow", "#b71105","orange", "red"),
      levels = c("High", "Good", "Supports Good", "Moderate", "Bad", "Poor", "Fail"),
      na.color = "transparent"
    )


# Leaflet layers order javascript: 

        Layers_JS <- "function(el, x) {
                var map = this;
          
                map.on('overlayadd overlayremove', function(e) {
                  // Create an array to hold layers by zIndex
                  var layers = [];
                  
                  // Collect all layers with zIndex
                  map.eachLayer(function(layer) {
                    if (layer.options && layer.options.zIndex !== undefined) {
                      layers.push(layer);
                    }
                  });
          
                  // Sort layers by zIndex in ascending order
                  layers.sort(function(a, b) {
                    return a.options.zIndex - b.options.zIndex;
                  });
          
                  // Re-add layers to the map in sorted order
                  layers.forEach(function(layer) {
                    if (map.hasLayer(layer)) {
                      layer.bringToFront();
                    }
                });
              });
            }"

