# Script to read outputs from "csv_output" folder and 
# compile all data in one csv output file
# February 9, 2016
# Paul Grams
#
# Run from bash command line one directory above csv_output directory
#
# Output filename:
outFileName = 'Sandbar_data.csv'
import glob
import os
import os.path
import pandas as pd
# Make list of directories in current directory (should only contain folders you want to process)
#firstList = ['CSVs','No_Bath_CSVS','Two_Bar_CSVs']
firstList = glob.glob('csv_output/*/')
counter3 = 0
for i in firstList:
    # Make list of subdirectories (these should be the site folders)
    dirList = glob.glob(i + '/*/')
    #print dirList
    #os.listdir(dirList[0])
    counter1 = 0
    for nowFolder in dirList:
        fileList = glob.glob(dirList[counter1]+ '*.csv')
        counter1 = counter1 + 1
        #print fileList
        counter2 = 0
        for nowFile in fileList: 
            currentFile = fileList[counter2]
            #print currentFile
            counter2 = counter2 + 1
            currentFilename = os.path.basename(currentFile)
            #print currentFilename
            #if currentFilename != 'Total_Eddy.csv':
            # do not include contents of "Total" files
            if 'Total' not in currentFilename:
                #print currentFilename
                print currentFile
                counter3 = counter3 + 1
                if 'Two_Bar' in currentFile:
                    if 'Eddy' not in currentFile:
                        data = pd.read_csv(currentFile, sep=',', header=0)
                        if 'Channel' in currentFile:
                            addSitePart = 'Channel'
                            NewSiteNamePart = '_R' #include channel with reattachment bar
                        elif '_R_' in currentFile:
                            addSitePart = 'Eddy'
                            NewSiteNamePart = '_R' #reattachment bar
                        elif '_S_' in currentFile:
                            addSitePart = 'Eddy'
                            NewSiteNamePart = '_S' #separation bar
                        data.Site = data.Site + NewSiteNamePart
                    #
                else:
                    #not a two bar site
                    data = pd.read_csv(currentFile, sep=',', header=0)
                    if 'Channel' in currentFile:
                        addSitePart = 'Channel'
                    else:
                        addSitePart = 'Eddy'
                dataMod1 = data.assign(SitePart = addSitePart)
                dataMod2 = dataMod1.assign(ProcessedFile = currentFilename)
                if counter3 == 1:
                    verticalStack = dataMod2
                else:
                    verticalStack = pd.concat([verticalStack, dataMod2], axis=0)
# Sending to output csv file
verticalStack.to_csv(outFileName) 
print '#####'
print 'done'
print 'Processed ' + str(counter3) + ' files.'
print 'output file: ' + outFileName