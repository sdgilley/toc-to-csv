# Create a .csv file from a toc.yml file  

# #### WARNING ####
# The input file should not include anything other than the following yaml entries:
# name, href, displayName, expanded, items
# If your yaml file has anything other than these, the code below won't work properly
# (expanded and displayName are optional, they are discarded when found)


source("createMerged.R")

## CHANGE THIS PATH TO YOUR REPO!
myrepo = "C:/GitPrivate/azure-docs-sdg/articles/machine-learning"

# for my toc with 286 files, this takes about 6-7 seconds
merged <- createMerged(myrepo)
write.csv(merged, file= "all-docs.csv", na="")


