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

## Current limitations

* Use this when your TOC is in the same directory as the files  
* The script is not set up to handle includes in the TOC
* The current version may not work well with 1000s of entries 

## Installation

### New to R? Installation instructions (for Windows)

[Skip to next section](#for-r-users) if you already have R installed.

1. [Download and install R](https://cran.r-project.org/)
   * During install, copy the path where R will be installed
   * When install is complete, edit your PATH system variable and add what you just copied, appending "\bin" to the end.  For example, "C:\Program Files\R\R-4.1.2\bin" if your installation directory is C:\Program Files\R\R-4.1.2""
  
1. Clone this repo 
  
   ```
   git clone https://github.com/sdgilley/toc-to-csv.git
   ```
1. Open a windows terminal as Admin
1. `cd` to the cloned repo
1. Run the `installs.R` program (You only need to do this once). 
  
    ```
    rscript.exe installs.r
    ```
    
1. Edit the file `TOC-csv.R` in any text editor
1. Change the path to your toc file in the `## SPECIFY INPUTS` section
1. Change the name of the file to be written if you wish
1. Save the file
1. In the terminal window, run the script:
  
    ```
    rscript.exe TOC-csv.R
    ```
    
 1. The filename specified in the INPUTS section (mytoc.csv unless you changed it) will be created in your current directory.

### For R users 

If you already have R installed, here's the steps to use the script in your IDE.

1. Clone this repo 
  
   ```
   git clone https://github.com/sdgilley/toc-to-csv.git
   ```
1. Open it in your R IDE, such as RStudio
1. Open the file `installs.R` and run it to install packages
1. Open the file `TOC-csv.R`
1. Change the path to your toc file in the `## SPECIFY INPUTS` section
1. Change the name of the file to be written if you wish
1. Run the entire file
1. The filename specified in the INPUTS section (mytoc.csv unless you changed it) will be created in your current directory.


## If you want to know more

The main script is TOC-csv.R.  This is where you specify the path to your TOC file, and can change the name of the .csv file that is produced.

TOC-csv.R reads in the yml file and creates a data.table.  The initial version of this object contains three columns: `name`, `href`, and `items`.  

The function `expandItems` is used to expand an `items` list and merge in columns for the next level of the hierarchy.  This continues until there are no more levels to expand.

Finally, the function `getMetadata` is used to obtain metadata for each file in the directory.  This is then merged with the data from the toc.

Some cleanup is performed and the file data is written to a .csv file.

## Functions

The script uses two functions. Each function is in its own file.  The functions are:

* `expandItems(dt)` - `dt` is a data.table that contains a list column, named `items`. This function:
  * expands the list into new columns
  * deletes all columns except for the ones corresponding to name, href, and items
  * merges these columns back to the data.table
  * returns the data.table

* `getMetadata(path)` - `path` is the path to the directory that contains your TOC.  This function:
  * loops through the .md files in the input directory. (It does not traverse subdirectories.)
  * extracts metadata from each file (currently, `ms.author` and `ms.reviewer`.  It would be simple to modify this to add others if you wish)
  * returns a data.table that contains each filename and its metadata.  


