# -*- coding: utf-8 -*-
"""
NAU Sandbar Database Compiler
Created by: Daniel Hamill
Description:  This script was developed to compile the sandbar database into a single CSV file.

Inputs:
max_vol = Microsoft excel file contining the tabulated maximim volumes and areas
bar_compile = Compile binvol files from the bar_data_compile.py script
bar_trip = Lookup table contining river segments (i.e. UMC,LMC,EGC,...), and time series length (i.e. short or long term montioring site)
trip_dates = Look up table to assoicate survey dates with trip dates
ts_length = Look up table for time sereis analysis
outFileName = Specified output file name
bar_type = Look up table to predict sand bar type (i.e. sep, reatt, undiff)

Output Columns:
Site- Site Location padded to 3 digits (i.e. 003L)
SurveyDate	- Date of survey
Plane_Height - Elevation bin
Area_2D - 
Area_3D -	
Volume -
Errors -	
SitePart - Channel or eddy	
Processed_File - Input file
TripDate - Begininng date of survey trip
SiteRange - Short or long term monitoring site
Segment - Canyon Section
MaxVol - Maximum Volume
Bar_type - Sand bar type
Max_Area - Maximum area
Time_Series - Complete or partial trip
    -'long' = complete trips, can use for marble canyon and grand canyon time series.
    -'na'= incomplete trip, exclude from time series analysis
    -'mc' = only include in marble canyon time series
Period - time series period
    - 'Sediment_Deficit' = (01\01\1990 - 11\01\2003)
    - 'Sediment Enrichment' = (11\01\2003 - present)

"""

import pandas as pd
import platform


def assign_period(row):
    if row['TripDate'] > pd.to_datetime('2003-11-01'):
        return 'Sediment_Enrichment'
    elif row['TripDate'] < pd.to_datetime('2003-11-01'):
        return 'Sediment_Deficit'
    else:
        pass
    
    
if platform.system() == 'Windows':
    max_vol = r'C:\workspace\Sandbar_Process\LU_Max_Vol.xlsx'
    bar_compile = r'C:\workspace\Sandbar_Process\Sandbar_data.csv'
    bar_trip = r'C:\workspace\Sandbar_Process\LU_Site_location_time_Series.csv' 
    trip_dates = r'C:\workspace\Sandbar_Process\Date_Error_lookup.xlsx'
    ts_length = r'C:\workspace\sandbar_process\LU_Time_Series.xlsx'
    outFileName = r'C:\workspace\Sandbar_Process\Merged_Sandbar_data.csv'
    bar_type = r'C:\workspace\sandbar_process\LU_Bar_type.csv'
elif platform.system() == 'Darwin':
    max_vol = '/Users/danielhamill/git_clones/sandbar_process/LU_Max_Vol.xlsx'
    bar_compile = '/Users/danielhamill/git_clones/sandbar_process/Sandbar_data.csv'
    bar_trip = '/Users/danielhamill/git_clones/sandbar_process/LU_Site_location_time_Series.csv' 
    trip_dates = '/Users/danielhamill/git_clones/sandbar_process/Date_Error_lookup.xlsx'
    ts_length = '/Users/danielhamill/git_clones/sandbar_process/LU_Time_Series.xlsx'
    outFileName = '/Users/danielhamill/git_clones/sandbar_process/Merged_Sandbar_data.csv'
    bar_type = '/Users/danielhamill/git_clones/sandbar_process/LU_Bar_type.csv'
    
#Load in bar compile
data = pd.read_csv(bar_compile, sep=',')
data = data.drop(data.columns[[0]],axis=1)
data['Date'] = pd.to_datetime(data['Date'], format='%m/%d/%Y')
data = data.rename(columns={'Date':'SurveyDate'})

#Format plane Height for trip date merge
data1 = data[data.SitePart=='Eddy']
data1 = data1[data1['Plane_Height'].str.contains("minto")]
data1 = data1.assign(Plane_Height='eddyminto8k')
data2 = data[(data.SitePart=='Eddy') & (data.Plane_Height == '8kto25k')]
data2 = data2.assign(Plane_Height='eddy8kto25k')
data3 = data[(data.SitePart=='Eddy') & (data.Plane_Height == 'above25k')]
data3 = data3.assign(Plane_Height='eddyabove25k')
data4 = data[data.SitePart=='Channel']
data4 = data4.assign(Plane_Height='chanminto8k')
frames = [data1,data2,data3,data4]
data = pd.concat(frames)
del frames
del data1, data2, data3, data4


#Load trip date lookup table
lu_3 = pd.read_excel(trip_dates)
lu_3['SurveyDate']= pd.to_datetime(lu_3['SurveyDate'], format='%m/%d/%Y')
lu_3['TripDate']= pd.to_datetime(lu_3['TripDate'], format='%m/%d/%Y')
lu_3 = lu_3[['Site','SurveyDate','Bin','TripDate']]
lu_3 = lu_3.rename(columns={'Bin':'Plane_Height'})

#Drop Duplicates
lu_3 = lu_3.groupby(['Site','SurveyDate','Plane_Height']).first().reset_index()
lu_3['Site']=lu_3['Site'].str.lower()
lu_3 = lu_3.reset_index()
data = data.merge(lu_3,left_on = ['Site','SurveyDate','Plane_Height'],right_on = ['Site','SurveyDate','Plane_Height'],how='left')
data = data.drop(data.columns[[-2]],axis=1)

#Add Dates for sep and reatt bars
data1 = data[data.TripDate.isnull()]
data1 = data1.set_index(['Site'])
data1.index = data1.index.str.lower()
data1 = data1.reset_index()
data1['tmpsite'] = data1['Site'].str[:4]
data1 = data1.merge(lu_3,left_on = ['tmpsite','SurveyDate','Plane_Height'],right_on = ['Site','SurveyDate','Plane_Height'],how='left')
data1 = data1.drop(data1.columns[-5:-1],axis=1)
#data1 = data1.drop(data1.columns[0],axis=1)
data1 = data1.rename(columns = {'TripDate_y': 'TripDate'})
data1 = data1.rename(columns = {'Site_x': 'Site'})
data2 = data[data.TripDate.notnull()]
data = pd.concat([data1,data2])

del lu_3, data1, data2

#Merge bar_compile with bar_trip
data = data.set_index(['Site'])
lu_1 = pd.read_csv(bar_trip, sep=',',index_col=[0])
lu_1 = lu_1.rename(columns={'Range':'SiteRange'})
data = pd.merge(data,lu_1,left_index=True,right_index=True,how='left')

#Load max_vol
lu_2 = pd.read_excel(max_vol, index_col=[0])

#Format max_vol for merging
chan_MaxVol = lu_2[['MaxVol_ChMinTo8k']].dropna(axis=0)
chan_MaxVol=chan_MaxVol.rename(columns={'MaxVol_ChMinTo8k':'MaxVol'})
eddy_low_MaxVol = lu_2[['MaxVol_EdMinTo8k']].dropna(axis=0)
eddy_low_MaxVol = eddy_low_MaxVol.rename(columns = {'MaxVol_EdMinTo8k':'MaxVol'})
eddy_fz_MaxVol = lu_2[['MaxVol_Ed8kto25k']].dropna(axis=0)
eddy_fz_MaxVol = eddy_fz_MaxVol.rename(columns = {'MaxVol_Ed8kto25k':'MaxVol'})
eddy_he_MaxVol = lu_2[['MaxVol_EdAbv25k']].dropna(axis=0)
eddy_he_MaxVol = eddy_he_MaxVol.rename(columns = {'MaxVol_EdAbv25k':'MaxVol'})
eddy_max_area = lu_2[['Max_Area_Eddy']].dropna(axis=0)
eddy_max_area = eddy_max_area.rename(columns={'Max_Area_Eddy':'Max_Area'})
chan_max_area = lu_2[['Max_Area_Channel']].dropna(axis=0)
chan_max_area = chan_max_area.rename(columns={'Max_Area_Channel':'Max_Area'})
del lu_1, lu_2

data.index = data.index.str.lower()

#Append maxiumum volumes in subsets
data1= data[data.SitePart == 'Channel'].merge(chan_MaxVol,left_index=True,right_index=True,how='left')
data2= data[(data.SitePart == 'Eddy') & (data.Plane_Height == 'eddy8kto25k')].merge(eddy_fz_MaxVol,left_index=True,right_index=True,how='left')
data3= data[(data.SitePart == 'Eddy')] 
data3 = data3[data3['Plane_Height'].str.contains("minto")]
data3 = data3.merge(eddy_low_MaxVol,left_index=True,right_index=True,how='left')
data4= data[(data.SitePart == 'Eddy') & (data.Plane_Height == 'eddyabove25k')].merge(eddy_he_MaxVol,left_index=True,right_index=True,how='left')

del chan_MaxVol, eddy_fz_MaxVol, eddy_he_MaxVol, eddy_low_MaxVol

#Merge Appended data sets
frames = [data1,data2,data3,data4]
data = pd.concat(frames)

del data1, data2, data3, data4, frames


#Merge Bar type
LU_bar_type = pd.read_csv(bar_type,sep=',',index_col=[0])
LU_bar_type.index = LU_bar_type.index.str.lower()
data = pd.merge(data,LU_bar_type,left_index=True,right_index=True,how='left')


#Get rid of total eddy records
#data = data[np.isfinite(data['MaxVol'])]

#Merge max areas
data1 = data[(data.SitePart == 'Eddy')] 
data1 = data1.merge(eddy_max_area,left_index=True,right_index=True,how='left')
data2 = data[(data.SitePart == 'Channel')] 
data2 = data2.merge(chan_max_area,left_index=True,right_index=True,how='left')
data = pd.concat([data1,data2])

del data1,data2,chan_max_area,eddy_max_area

lu_4 = pd.read_excel(ts_length)
lu_4 = lu_4[['Trip_Date','Time_Series']]
lu_4 = lu_4.rename(columns={'Trip_Date':'TripDate'})
data = data.reset_index()
data= data.merge(lu_4, on=['TripDate'], how='left' )
data = data.set_index(['Site'])
data['Period'] = data.apply(lambda row: assign_period(row), axis=1)

del lu_4

data.to_csv(outFileName)