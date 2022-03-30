# Get metadta for .md files in a single directory
# Input: the directory path
# Output: a data.table with filename and metadata.  
# Currently, adding only ms.author and ms.reviewer

getMetadata <- function(path){
                        
library(data.table)

# get all the markdown files in the directory
files <- list.files(path=path, pattern=".md$", all.files=FALSE,
           full.names=FALSE)

metadata <- data.table()
# loop through files to get metadata and append to data.table
for (i in 1:length(files)) {
  fn <- paste(myrepo, files[i], sep="/") # get the filename
  yml_metadata <- rmarkdown::yaml_front_matter(fn) # read the metadata for this file
  # I'm appending the ms.author and ms.reviewer here - customize as you see fit!
  newrow <- data.table(filename =files[i], 
                       ms.author=yml_metadata[["ms.author"]], 
                       ms.reviewer=yml_metadata[["ms.reviewer"]],
                       ms.custom=yml_metadata[["ms.custom"]])
  metadata <- rbind(metadata, newrow, fill=T)
  }

return (metadata)
}

