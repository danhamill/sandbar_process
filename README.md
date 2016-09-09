[logo]: https://github.com/danhamill/sandbar_process/blob/master/NAU_Logo.png "NAU Logo"

# sandbar_process
This repostiory contains all of the input files, scripts, and instructions required to compile the sandbar database

## Clone Repostiory
To download this repository onto your computer you will need to install Git Bash for windows. The installation file can be found at:
```
https://git-scm.com/download/win
```
After git bash for windows is installed, naviagte to `C:\workspace\` using the git bash unix shell.  If that directory does not exist, create it.  You can clone the repository to your local machine with the command
```
git clone https://github.com/danhamill/sandbar_process.git
```
## Repository Structure
The scripts and macros contained in this repository have hard coded paths and requires a specified directory structure

### Directory Structure for binvol_inputs
Each monitoring sites input data files are organized in `binvol_inputs`.  `binvol_inputs` contains the following subfolders:
* One_Sandbar_With_Bath_Text
* One_Sandbar_WithOut_Bath_Text 
* Two_Bar_With_Bath_Text

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

### Directory Structure for CSVs
The compiled binvol inputs are organized in `csv_output`.  `csv_output` contains the following subfolders:
* CSVs
* No_Bath_CSVs
* Two_Bar_CSVs

### Directory Structure for csv_output

1) Each site folder contained in `csv_output\CSVs` contains the following files:
* Channel_Low_Elevation.csv
* Eddy_Fluctuating_Zone.csv
* Eddy_High_Elevation_Zone.csv
* Eddy_Low_Elevation_Zone.csv
* Total_Eddy.csv
    * This file is the summmation of
       * Eddy_Fluctuating_Zone.csv
       * Eddy_High_Elevation_Zone.csv
       * Eddy_Low_Elevation_Zone.csv

2) Each site folder contained in `csv_output\No_Bath_CSVs` contains the following files:
* Eddy_Fluctuating_Zone.csv
* Eddy_High_Elevation_Zone.csv

3) Each site folder contained in `csv_output\Two_Bar_CSVs` contains the following files:
* Channel_Low_Elevation.csv
* _R_Fluc.csv
* _R_High.csv
* _R_Low.csv
* _S_Fluc.csv
* _S_High.csv
* _S_Low.csv
* Eddy_Fluctuating_Zone.csv
   * This file is the summmation of
       * _R_Fluc.csv
       * _S_Fluc.csv
* Eddy_High_Elevation_Zone.csv
   * This file is the summmation of
       * _R_High.csv
       * _S_High.csv
* Eddy_Low_Elevation_Zone.csv
   * This file is the summmation of
       * _R_Low.csv
       * _S_Low.csv
* Total_Eddy.csv
    * This file is the summmation of
       * Eddy_Fluctuating_Zone.csv
       * Eddy_High_Elevation_Zone.csv
       * Eddy_Low_Elevation_Zone.csv

## Compilation Process Overview
1) Run compilation macros contained in `Sandbar_Process_Run.xlsm` 
```
Press to Run Sandbar Processing Macro
```

2) Run bar_data_compile.py 
```
python bar_data_compile.py
```
3) Open Batch_Run_R_Scripts.R 
```
hit the "Source" button.
```
4) Run Formatted table macros contained in `Sandbar_Process_Run.xlsm` 
```
Press to Run Macro to produce formatted tables
```
**!! Must run Excel VB compilation macros first. Steps 2 and 3 can be completed in any order. However, step 4 requires outputs from step 3.**

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
