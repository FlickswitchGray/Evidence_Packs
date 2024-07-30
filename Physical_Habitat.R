---
  title: "Physical_Habitat"
output:
  html_document:
  toc: true
toc_float: true
collapsed: false
number_sections: false
toc_depth: 1
#code_folding: hide
---
  
```{r setup, include=FALSE}
knitr::opts_chunk$set(message=FALSE,warning=FALSE, cache=TRUE)
```


The third pillar in the trinity of ecological health is Physical Habitat, also known as "the silent killer". 

For morphology scores of a catchment see WFD morphology graph below

```{r}
#WFD morphology status
```

For access to more granular data, see individual River Habitat Survey data below.

```{r, echo=FALSE, warnings=FALSE}


#Script which plots River Habitat Survey data.

RW <- read_sf("C:/Users/hg000051/OneDrive - Defra/Projects/01_SPP_Projects/Evidence Pack/RHS/RHS_w_MCATs.shp")

#RW <- RW[CAT,]

names(RW)
RW <-   RW %>% 
  mutate(
    Date = dmy(SURVEY_D),
    Year = year(Date)
  ) %>% 
  
  group_by(Year) %>% 
  mutate(
    Year_Mean = mean(HQA)
  ) %>% #Seperate geometry into Lat, Long columns
  extract(geometry, into = c('Lat', 'Long'), '\\((.*),(.*)\\)', conv = T)

pal2 <- colorBin(palette = "viridis", domain=RW$HQA)

leaflet(RW) %>% 
  addProviderTiles(providers$Esri) %>% 
  addCircleMarkers(lng = ~Lat, 
                   lat = ~Long, 
                   col = ~pal2(RW$HQA), 
                   radius = 5,
                   popup = paste0("Mean HQA Score: ", RW$HQA, "<br>",
                                  "WFD WB: ", RW$WB_NAME)
  ) %>% 
  addLegend(pal = pal2, values = ~Year_Mean, opacity = 0.7,
            title= paste0("Yearly mean of Habitat<br> Quality Assessment<br> (Habitat diversity)"))#


```