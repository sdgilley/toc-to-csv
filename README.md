# toc-to-csv R script

Turn a TOC.YML file into a .CSV file for further work in Excel. This repository contains two R scripts, one to create the initial csv file, and a second if you want to add further metadata from each file into the rows.

The script is set up to read from the toc file in your local docs repository.  But there is is also a sample file included which you could use instead for TOC-csv.R. 

## TOC-csv.R

This R script will read in a toc.yml file and create a .csv file.  The resulting .csv file will look like this: 

![Excel spreadsheet for example toc](media/excel.png "Excel display of CSV")

In the spreadsheet, the final column contains the title of the article, previous columns shows the parents for that item.  This preserves the hierarchy for each item.   You can then sort without losing context, also sort back to the original order from the first column.

The input file must contain these entries:
* name 
* href
* items

Optionally, the following entries may exist.  They will be removed in the code.
* displayName (optional)
* expanded (optional)

If your yaml file contains anything other than the above, the code will need to be revised to handle them.  

## add-metadata.R

Use this script to add metadata for each article in the TOC.  You must first run the TOC-csv.R script to create the initial data (but you can skip writing the final file if you wish).  Then run add-metadata.R to find metadata in the files and merge by filename.