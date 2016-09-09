# -*- coding: utf-8 -*-
"""
Created on Sat Feb 13 07:50:31 2016

@author: pgrams
"""
import numpy as np
import pandas as pd
inFile = 'Sandbar_data.csv'
inDateList = 'Date_Error_lookup.xlsx'
inSheet = 'Uncertainty_LU'
data = pd.read_csv(inFile, sep=',', header=0)
new_col_names = ['ID','Site','SurveyDate','PlaneHeight','Area2d','Area3d','Volume','Error','SitePart','ProcessedFile']
data.columns = new_col_names
tempDF = pd.read_excel(inDateList, inSheet, header=0)
# get rid of duplicate survey dates (all have same trip date)
dateLU = tempDF.drop_duplicates(['SurveyDate'])