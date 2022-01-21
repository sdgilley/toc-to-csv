# Append metadta to TOC info
# Run this after TOC-csv.R if you want to append metadata info to the file

library(data.table)

# reading from my local repo.  Change this path to your directory on your local repo.
myrepo <- "C:/GitPrivate/azure-docs-sdg/articles/machine-learning"
writefile <- "with-metadata.csv"

# get all the markdown files in the directory
files <- list.files(path=myrepo, pattern=".md$", all.files=FALSE,
           full.names=FALSE)

filedt <- data.table()
# loop through files to get metadata and append to data.table
for (i in 1:length(files)) {
  fn <- paste(myrepo, files[i], sep="/") # get the filename
  yml_metadata <- rmarkdown::yaml_front_matter(fn) # read the metadata for this file
  # I'm appending the ms.author and ms.reviewer here - customize as you see fit!
  newrow <- data.table(filename =files[i], 
                       ms.author=yml_metadata[["ms.author"]], 
                       ms.reviewer=yml_metadata[["ms.reviewer"]])
  filedt <- rbind(filedt, newrow, fill=T)
}

## Make sure you've run TOC-csv.R first before you try to merge
merged <- left_join(dt, filedt, by = "filename")
