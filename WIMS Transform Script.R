# WIMS Transform Script

    WIMS <-  read.csv("/dbfs/FileStore/WSX_HGray/ETL_Exports/Wessex_WIMS_AllDeters_091024.csv")

    WIMS %<>% st_as_sf(coords= c("sample.samplingPoint.easting", "sample.samplingPoint.northing"), crs=27700) %>% 
      filter(!is.na("sample.samplingPoint.easting") &!is.na("sample.samplingPoint.northing")) 
    
    # Transform CAT so can join in planar geoms.  
    CAT_W <-st_transform(CAT, st_crs(27700))
    
    # Spatial join
    joined <- st_join(WIMS, CAT_W)
 
    joined_w <- st_transform(joined, st_crs(4326))
    
    # Crop Wessex wide to be in catchment.
    WIMS_CAT <- joined[CAT_W,]
    
    # 
    WIMS_CAT %<>% st_transform(st_crs(4326))
  

      