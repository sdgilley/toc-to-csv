# Create a .csv file from a toc.yml file  
# WARNING 
# The input file should include the following yaml entries:
# name, href, displayName, expanded, items
# If your yaml file has anything other than these, the code below won't work properly
# (expanded and displayName are optional, they are discarded when found)


## SPECIFY INPUTS
# I'm reading from my local repo directory
filename <- "C:/GitPrivate/azure-docs-sdg/articles/machine-learning/toc.yml"
# Or test with this one 
# filename <- 'toc.yml'
writefile <- "ML-toc.csv"
myrepo = "C:/GitPrivate/azure-docs-sdg/articles/machine-learning"

# libraries used
library(yaml)
library(data.table)
library(dplyr)

source("expandItems.R")
source("getMetadata.R")

## STEP 1: Read TOC & process it:

require(yaml)
# reading from a file connection

data <- read_yaml(filename) #initial data - big list with one row per heading

#create the first data.table
library(data.table)
dt<- rbindlist(data, fill=TRUE) # now we have one row for each first level item

## Each time you call the function, you'll get one more level of the TOC.  
## keep going as long as there is still an items.y column.  

dt<- expandItems(dt)  # FIRST TIME (outside loop because no items.y yet, first merge will create it)
level <- 2            # keep track of how many levels

while ("items.y" %in% names(dt)){
  #change the name to items before using expandItems.
  names(dt)[names(dt) == "items.y"] <- "items"
  level <- level + 1
  dt<- expandItems(dt)
}

## Done with expanding ##
dt$items <- NULL  # get rid of the remaining items column.

# Make nicer names, based on the level
f <- paste0("f", 1:level) 
n <- paste0("n", 1:level) 
dtnames <- c("n1","f1")

# now put the names in the right order
for (i in 2:level) {
  dtnames <- c(dtnames,n[i],f[i])
}

if (length(names(dt)) == length(dtnames)) {
  names(dt) <- dtnames
} else {
  sprintf("Something's wrong!  You should have %i columns in dt, but you have %i.  Stop and debug",length(dtnames), length(names(dt)))
}


## STEP 2 Clean up and consolidate filename into a single column
dt[is.na(dt)] <- ""  # replace NANs with blanks

# only one of these columns contains the filename, combine into a single variable
dt <- data.frame(dt, stringsAsFactors = FALSE) # change data.table to data.frame for the paste to work 
dt$filename <- do.call(paste, c(dt[f], sep = ""))  

# Now get rid of the multiple filename colums
dt <- dt[, -which(names(dt) %in% f)]


## STEP 3: Write the csv file - uncomment the next line and stop here if you wish
# write.csv(dt, file= writefile, na="")

## CONTINUE ON to add metadata to the file
myrepo = "C:/GitPrivate/azure-docs-sdg/articles/machine-learning"
metadata <- getMetadata(myrepo, writefile)

merged <- left_join(dt, metadata, by = "filename")
write.csv(merged, file= writefile, na="")
