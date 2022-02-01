expandItems <- function(dt){
  # Function to expand list into rows and merge back to dt
  # creates a second dt (unlisted) with expanded list, then merges to initial dt
  # from https://datacornering.com/how-to-unlist-a-nested-list-in-r/
  
  # Input: a data.table with a column, items, that contains a list
  # Output: a data.table with each item expanded into its own row, then merged into the input data.table.
  # if any of the items themselves contain items, after the merge, you'll have an items.x and items.y

  
  library(data.table)
  library(dplyr)
  
  unlisted <- rbindlist(dt$items, fill = T, idcol = "id") # unlist nested list with id
  dt$id <- seq.int(nrow(dt)) # create same id in remaining data frame
  dt <- left_join(dt, unlisted, by = "id") # join data table with unlisted list
  
  # delete columns  
  dt$id <- NULL
   if ("displayName" %in% names(dt)) {dt$displayName <- NULL}
  if ("expanded" %in% names(dt)) {dt$expanded <- NULL} # this col isn't used, delete so it doesn't merge in next step
  if ("expanded.x" %in% names(dt)) {dt$expanded.x <- NULL} # this col isn't used, delete so it doesn't merge in next step
  if ("expanded.y" %in% names(dt)) {dt$expanded.y <- NULL} # this col isn't used, delete so it doesn't merge in next step
  if ("items.x" %in% names(dt)) {dt$items.x <- NULL} # after merge, this is the column that was expanded.  items$y is the next one to expand
  return(dt)
}
