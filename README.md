[logo]: https://github.com/danhamill/sandbar_process/blob/master/NAU_Logo.png


# sandbar_process
This repostiory contains all of the input files, scripts, and instructions required to compile the sandbar database


## Steps to compile binvol files
Input files go in binvol_inputs organized in correct structure (see below)

* One_Sandbar_With_Bath_Text
* One_Sandbar_WithOut_Bath_Text 
* Two_Bar_With_Bath_Text

1) open Sandbar_Process_Run.xlsm and hit the top button.

2) Run bar_data_compile.py from bash command line. Type: "python bar_data_compile.py"

3) Run the R scripts (open Batch_Run_R_Scripts.R and hit the "Source" button.

4) Back to Sandbar_Process_Run.xlsm and hit the bottom button to produce the formatted tables.

**!! Must run Excel VB script first. Can run R and Python in either order. Then second VB script to produce formatted tables.**

---
## Necessary files and directories and where they need to be:

### Excel file with macros: (in C:\workspace\sandbar_process)
```
Sandbar_Process_Run.xlsm
```
Excel files for output: (in C:\workspace\sandbar_process)
```
One_Sandbar_No_Bathymetry.xlsx
One_Sandbar_Sites_with_Bathymetry.xlsx
Two_Bar_Sites.xlsx
Formatted_Data_Tables.xlsx
```

### Python script: (in C:\workspace\sandbar_process)
```
bar_data_compile.py
```

### R Scripts and reference files: (in C:\workspace\sandbar_process)
```
Batch_Run_R_Scripts.R
Batch_Plot_Figures_One_Sandbar_With_Bathymetry.R
Batch_Plot_Figures_One_Sandbar_WithOut_Bathymetry.R
Batch_Plot_Figures_Two_Sandbar_With_Bathymetry.R
Three_Graph_Y_Limit.csv
Two_Graph_Y_Limit.csv
```
### Folders need for output:
```
C:\workspace\sandbar_process\csv_output\CSVs
C:\workspace\sandbar_process\csv_output\No_Bath_CSVS
C:\workspace\sandbar_process\csv_output\Two_Bar_CSVs
C:\workspace\sandbar_process\plotting_out
```
### Inputs:
```
C:\workspace\sandbar_process\binvol_inputs
```
---
## Directory Structure for binvol_inputs

1) Each site folder contained in `binvol_inputs\One_Sandbar_With_Bath_Text` has the following subfolders:
* chanminto8k
* eddy8kto25k
* eddyabove25k
* eddyminto8k

2) Each site folder contained in `binvol_inputs\One_Sandbar_WithOut_Bath_Text` has the following subfolders:
* eddy8kto25k
* eddyabove25k

3) Each site folder contained in `binvol_inputs\Two_Bar_With_Bath_Text` has the following subfolders:
* Channel
* Eddy reattachment
    * eddy8kto25k
    * eddyabove25k
    * eddyminto8k
* Eddy separation
    * eddy8kto25k
    * eddyabove25k
    * eddyminto8k
---
## Notes:

The VB script deltes all old output files from:
```
C:\workspace\sandbar_process\csv_output\CSVs
C:\workspace\sandbar_process\csv_output\No_Bath_CSVS
C:\workspace\sandbar_process\csv_output\Two_Bar_CSVs
```
and outputs to each of the excel workbooks and to:
```
C:\workspace\sandbar_process\csv_output
```
The python script compiles all the csv output files to:
```
C:\workspace\sandbar_process\Sandbar_data.csv
```
The R script runs:
```
Batch_Plot_Figures_One_Sandbar_With_Bathymetry.R
Batch_Plot_Figures_One_Sandbar_WithOut_Bathymetry.R
Batch_Plot_Figures_Two_Sandbar_With_Bathymetry.R
```
and outputs to:
```
C:\workspace\sandbar_process\plotting_out
```
