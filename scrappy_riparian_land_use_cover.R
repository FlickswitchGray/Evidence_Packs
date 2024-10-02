install.packages(c("ggspatial", "Leaflet.Extras", "elevatr"))

library(sf)
library(magrittr)
library(tidyverse)

DRN <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/DRN/DRN_Merged_MCAT.shp")

WSX <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/Wessex_LC2.shp")

shape <- read_sf("/dbfs/mnt/lab/unrestricted/harry.gray@environment-agency.gov.uk/Interim_WFD_2022.shp")
    

DRN <- st_transform(DRN, st_crs(shape))

    
    DRN_Buf <- st_buffer(DRN, 100)
    
    DRN_Buf_U <- WSX %>% st_union(.)

    # Convert DRN_Buf from sfc to sf
    DRN_Buf_U <- st_sf(geometry = DRN_Buf_U)
    
    
    DRN_Buf_U <- DRN_Buf_U %>% st_transform(st_crs(shape))
    
    WSX_f <- st_transform(WSX, st_crs(27700))
    DRN_Buf_U <- st_transform(DRN_Buf_U, st_crs(WSX_f))
    
   
    ####
    
    #Create a buffer of 150m around DRN   
    Rivs <-   DRN %>% 
      st_intersection(shape) %>% 
      st_make_valid() %>% 
      st_buffer(100) %>% 
      st_union() #So polygons don't overlap and we double-count.
    
    Rivs_100 <- Rivs
      Rivs_100 %<>% st_transform(27700) 
    
    LC_Rivs_100 <- Rivs_100 %>% st_intersection(WSX_f)
    
    ggplot()+geom_sf(data=Rivs[Rivs$wb], aes())
    
    ####
    
  
  oil <- shape[shape$WB_NAME=="St Catherines Bk - source to conf R Avon (Brist)",]
  OO <- LOL[LOL$WB_NAME=="St Catherines Bk - source to conf R Avon (Brist)",]
  OI <- OO %>% st_intersection(shape[shape$WB_NAME=="St Catherines Bk - source to conf R Avon (Brist)",])
  od <- DRN[DRN$WB_NAME=="St Catherines Bk - source to conf R Avon (Brist)",]

  
    ggplot()+geom_sf(data=oil, col="red")+geom_sf(data=OI, aes())+geom_sf(data=od,  aes(),col="steelblue")
      
    i <- st_buffer(od, 100)
    
    ggplot()+geom_sf(data=i, aes())
    
    
    DRN_Buf_Boy <- shape %>% st_join(DRN_Buf, st_crs(4326))
  
  ggplot(DRN_Buf, aes())+geom_sf()
  unique(DRN$WB_NAME)
  