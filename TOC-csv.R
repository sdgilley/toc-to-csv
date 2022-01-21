# Create a .csv file from a toc.yml file  
# WARNING 
# The input file should include the following yaml entries:
# name, href, displayName, expanded, items
# If your yaml file has anything other than these, the code below won't work properly
# (expanded and displayName are optional, they are discarded when found)

# libraries needed
library(yaml)
library(data.table)
library(dplyr)

# specify the filename to read & the name to use for the csv file
# I'm reading from my local repo directory
filename <- "C:/GitPrivate/azure-docs-sdg/articles/machine-learning/toc.yml"
# Or test with this one 
# filename <- 'toc.yml'
writefile <- "ML-toc.csv"


expanditems <- function(dt){
  # Function to expand list into rows and merge back to dt
  # creates a second dt (unlisted) with expanded list, then merges to initial dt
  # from https://datacornering.com/how-to-unlist-a-nested-list-in-r/

  library(data.table)
  library(dplyr)
  
  unlisted <- rbindlist(dt$items, fill = T, idcol = "id") # unlist nested list with id
  dt$id <- seq.int(nrow(dt)) # create same id in remaining data frame
  dt <- left_join(dt, unlisted, by = "id") # join data table with unlisted list
  
  # delete columns  
  dt$id <- NULL
  dt$displayName <- NULL
  if ("expanded.x" %in% names(dt)) {dt$expanded.x <- NULL} # this col isn't used, delete so it doesn't merge in next ste
  if ("expanded.y" %in% names(dt)) {dt$expanded.y <- NULL} # this col isn't used, delete so it doesn't merge in next ste
  if ("items.x" %in% names(dt)) {dt$items.x <- NULL} # this is the column that was expanded.  items$y is the next one to expand
  return(dt)
}

## STEP 1: Read TOC & process it:

require(yaml)
# reading from a file connection

data <- read_yaml(filename) #initial data - big list with one row per heading

#create the first data.table
library(data.table)
dt<- rbindlist(data, fill=TRUE) # now we have one row for each first level item

## Not elegant but IT WORKS!!! Don't mess with success.
## Each time you call the function, you'll get one more level of the TOC.  
## keep going as long as there is still an items.y column.  

dt<- expanditems(dt)  # FIRST TIME 
level <- 2            # keep track of how many levels

while ("items.y" %in% names(dt)){
  #change the name to items before using expanditems.
  names(dt)[names(dt) == "items.y"] <- "items"
  level <- level + 1
  dt<- expanditems(dt)
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


## STEP 3: Write the csv file
write.csv(dt, file= writefile, na="")


