library(sf)
library(magrittr)
library(tidyverse)
library(leaflet)
library(lubridate)


catch <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/Interim_WFD_2022.shp")# Catchment shapefiles
CAT <- catch[catch$OPCAT_NAME == "Parrett",]


CAT_Union <- st_union(CAT) %>% 
  st_transform(4326)

CAT_27700 <- CAT
CAT <- CAT %>%  st_transform(4326)



CPS <- read.csv("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/ETL_Exports/CPS_101024_wMeasures.csv")


#Temporary RNAGs transforms
    RFF <- read.csv("/dbfs/FileStore/WSX_HGray/RFF.csv")
    RFF <- RFF[RFF$OPERATIONAL_CATCHMENT %in% c("Parrett", "Parrett Canals", "Parrett TraC"),]

    
    # Temporary Measures Transforms
    Measures_Class <- readxl::read_xlsx("/dbfs/FileStore/WSX_HGray/ETL_Imports_Require_Manual/Measures_Extraction_Tool_Extended.xlsx", sheet= "Measure Class Items", skip=2)  
    Measures_WBs <- readxl::read_xlsx("/dbfs/FileStore/WSX_HGray/ETL_Imports_Require_Manual/Measures_Extraction_Tool_Extended.xlsx", sheet= "Connections to Water Bodies", skip=2)  %>% 
      filter(AREA_NAME== "Wessex")
    Measures_Cat <- readxl::read_xlsx("/dbfs/FileStore/WSX_HGray/ETL_Imports_Require_Manual/Measures_Extraction_Tool_Extended.xlsx", sheet= "Measure Categories", skip=2)  
    
    
    Mes <- Measures_WBs %>% filter(OPERATIONAL_CATCHMENT %in% c("Parrett", "Parrett TraC"))
    
    
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

