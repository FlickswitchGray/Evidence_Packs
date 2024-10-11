# WIMS Transform Script

    WIMS <-  read.csv("/dbfs/FileStore/WSX_HGray/ETL_Exports/Wessex_WIMS_AllDeters_091024.csv")
    
    WIMS %<>% st_as_sf(coords, c("sample.samplingPoint.easting", "sample.samplingPoint.northing"), crs=27700) %>% 
      st_transform(4326)
    
    
    
