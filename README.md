# toc-to-csv R script

Turn a TOC.YML file into a .CSV file for further work in Excel. Also add metadata from the files, such as `ms.author` and `ms.reviewer`.

The script is set up to read from the toc file in your local docs repository.  But there is is also a sample file included, which you could use to see how it works. 

## TOC-csv.R

This R script will read in a toc.yml file and create a .csv file.  The resulting .csv file will look like this: 

![Excel spreadsheet for example toc](media/excel.png "Excel display of CSV")

In the spreadsheet, the final column contains the title of the article, previous columns shows the parents for that item.  This preserves the hierarchy for each item.   You can then sort without losing context, also sort back to the original order from the first column.

The input file must contain these entries:
* `name` 
* `href`
* `items`

Optionally, the following entries may exist.  They will be removed in the code.
* `displayName` (optional)
* `expanded` (optional)

If your yaml file contains anything other than the above, the code will need to be revised to handle them.  

## Functions

Each function is in its own file.  The functions are:

* `expandItems` takes a data.table that contains a list.  It expands the list and merges back to the data.table, then returns the data.table.

* `getMetadata` loops through the *.md files in your local docs repository directory, extracts metadata, and returns a data.table that contains each filename with its metadata.  Currently, the only metadata added is `ms.author` and `ms.reviewer`.  It would be simple to modify this to add other fields as well.
