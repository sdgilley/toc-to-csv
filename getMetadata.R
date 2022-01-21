# Append metadta to TOC info
# Run this after TOC-csv.R if you want to append metadata info to the file

getMetadata <- function(myrepo, writefile){
                        
library(data.table)

# get all the markdown files in the directory
files <- list.files(path=myrepo, pattern=".md$", all.files=FALSE,
           full.names=FALSE)

metadata <- data.table()
# loop through files to get metadata and append to data.table
for (i in 1:length(files)) {
  fn <- paste(myrepo, files[i], sep="/") # get the filename
  yml_metadata <- rmarkdown::yaml_front_matter(fn) # read the metadata for this file
  # I'm appending the ms.author and ms.reviewer here - customize as you see fit!
  newrow <- data.table(filename =files[i], 
                       ms.author=yml_metadata[["ms.author"]], 
                       ms.reviewer=yml_metadata[["ms.reviewer"]])
  metadata <- rbind(metadata, newrow, fill=T)
  }

return (metadata)
}

