#create the first data.table
library(data.table)
dt<- rbindlist(data, fill=TRUE) # now we have one row for each first level item
dt<- dt[, .(name, href, items)] #only need name, href, items.  discard aything else


dt<- expandItems(dt)  # FIRST TIME (outside loop because no items.y yet, first merge will create it)
level <- 2            # keep track of how many levels
names<- names(dt)
prev <- level-1


n <- names[grep("name", names)] 
newn <- gsub("*.x", as.character(prev), names(dt))
newn <- gsub("*.y", as.character(level), newn)
names(dt[,names(dt) %in% n]) <- newn
h <- names[grep("href", names)]
names <- gsub("*.x",as.character(prev), names)
names <- gsub("*.y",as.character(level), names)
keep <- c("items","name","href")
names %in% keep
keep <- names[grep("name", names)]


unlisted <- rbindlist(dt$items, fill = T, idcol = "id") # unlist nested list with id
dt$id <- seq.int(nrow(dt)) # create same id in remaining data frame
dt <- left_join(dt, unlisted, by = "id") # join data table with unlisted list

changeNames <- function(dt, level){
  prev <- level-1
  setnames(dt, gsub("item*.x", as.character(prev), names(dt)))
  setnames(dt, gsub("*.y", as.character(level), names(dt)))
  keep <- grep("[0-9]$", names(dt1)) 
  dt <- dt[, ..keep]
}


gsub("^[item]*.x", as.character(prev), names(dt))
