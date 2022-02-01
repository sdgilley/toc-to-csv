# toc-to-csv R script

Turn a TOC.YML file into a .CSV file for further work in Excel. Also add metadata from the files, such as `ms.author` and `ms.reviewer`.

The script is set up to read from the toc file in your local docs repository.  But there is is also a sample file included, which you could use to see how it works before you turn it loose on your own TOC.

## TOC-csv.R

This R script will read in a toc.yml file and create a .csv file.  The resulting .csv file will look like this: 

![Excel spreadsheet for example toc](media/excel.png "Excel display of CSV")

In the spreadsheet, the last non-blank column contains the title of the article, previous columns shows the parents for that item.  This preserves the hierarchy for each item.   You can then sort without losing context, also sort back to the original order from the first column.

The input file must contain these entries:
* `name` 
* `href`
* `items`

Optionally, the following entries may exist.  They will be ignored, and not present in the spreadsheet.
* `displayName` (optional)
* `expanded` (optional)

If your yaml file contains anything other than the above, the code as is would not work.  New handling of these entries, in `expandItems` (see below) would first be needed. 

## Functions

Each function is in its own file.  The functions are:

* `expandItems` takes a data.table that contains a list column, named `items`.  It 
  * expands the list into new columns
  * deletes all columns except for the ones corresponding to name, href, and items
  * merges these columns back to the data.table
  * returns the data.table

* `getMetadata` 
  * loops through the .md files in your local docs repository directory
  * extracts metadata from each file (currently, `ms.author` and `ms.reviewer`.  It would be simple to modify this to add others if you wish)
  * returns a data.table that contains each filename and its metadata.  
