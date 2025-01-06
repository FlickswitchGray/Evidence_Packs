

# For a full list of determinants to which their codes can be matched use the below handle: 

# Determinants library

#library(httr)
#library(jsonlite)

#ural <- "https://environment.data.gov.uk/water-quality/def/determinands"

#theapi <- GET(ural)

#theapi$status_code

#apich <- rawToChar(theapi$content)

#theapi <- fromJSON(apich, flatten=T)
#API <- theapi$items

#str(API)
#options(max.print = 10000)
#print(sort(unique(API$label)))



# WIMS Script

# Opening Params 

Deters = c("0180", "0111", "9901", "0119", "0085", "0068") # Deters required in Water_Quality.qmd page of evidence pack
Years = c(paste0(2022:format(Sys.Date(), "%Y")))

# Set initial skeleton   
build <- data.frame()

# Remove these columns (what can we do with them? )
Remove_cols <-  c("resultQualifier.notation", "resultQualifier.@id", "resultQualifier.notation", "resultQualifier.@id")

for( x in 1: length(Deters)){
  
  for( z in 1: length(Years)){
    
    base_url <- "http://environment.data.gov.uk/water-quality/"
    ending <- paste0("data/measurement?_limit=999999&area=6-28&determinand=", Deters[x],"&year=", Years[z]) #filters all samples of orthophosphate.
    
    url <- paste0(base_url, ending)
    
    
    #Load in the api url using the httr and json packages. 
    A_stations <- GET(url) 
    A_stations$status_code  #if 200 all working
    
    api_char <- rawToChar(A_stations$content)
    api <- fromJSON(api_char, flatten=T)    
    
    api_it <- api$items
    
    # If statement to remove determinants/years with extra columns
    if(any(names(api_it) %in% Remove_cols)){
      
      api_it <- api_it[, !(names(api_it) %in% Remove_cols)]
    }
    
    build <- rbind(build, api_it)
    
    
  }
  
}