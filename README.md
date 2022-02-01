# toc-to-csv R script

Turn a TOC.YML file into a .CSV file for further work in Excel. Also add metadata from the files, such as `ms.author` and `ms.reviewer`.

The script reads from the toc file in your local docs repository.  

## TOC-csv.R

This R script will read your toc.yml file and creates a .csv file.  The resulting .csv file will look like this: 

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

* `expandItems(dt)` - `dt` is a data.table that contains a list column, named `items`.
  * expands the list into new columns
  * deletes all columns except for the ones corresponding to name, href, and items
  * merges these columns back to the data.table
  * returns the data.table

* `getMetadata(path)` - `path` is the path to the directory that contains your TOC
  * loops through the .md files in the input directory. (Does not traverse subdirectories.)
  * extracts metadata from each file (currently, `ms.author` and `ms.reviewer`.  It would be simple to modify this to add others if you wish)
  * returns a data.table that contains each filename and its metadata.  

## Installation

### For R users 

1. Clone this repo 
  
   ```
   git clone https://github.com/sdgilley/toc-to-csv.git
   ```
1. Open it in your R IDE, such as RStudio
1. Open the file `installs.R` and run it to install packages
1. Open the file `TOC-csv.R`
1. Add your path to your toc file in the `## SPECIFY INPUTS` section
1. Run the entire file
  
### New to R? Full installation instructions

1. [Download and install R](https://cran.r-project.org/)
   * During install, copy the path where R will be installed
   * When install is complete, edit your PATH system variable and add what you just copied, appending "\bin" to the end.  For example, "C:\Program Files\R\R-4.1.2\bin" if your installation directory is C:\Program Files\R\R-4.1.2""
  
1. Clone this repo 
  
   ```
   git clone https://github.com/sdgilley/toc-to-csv.git
   ```
1. In a terminal window, `cd` to the cloned repo
1. Run the `installs.R` program (You only need to do this once)
  
    ```
    rscript.exe installs.r
    ```
    
1. Edit the file `TOC-csv.R` in any text editor
1. Add your path to your toc file in the `## SPECIFY INPUTS` section
1. Save the file
1. In the terminal window, run the script:
  
    ```
    rscript.exe TOC-csv.R
    ```
  
