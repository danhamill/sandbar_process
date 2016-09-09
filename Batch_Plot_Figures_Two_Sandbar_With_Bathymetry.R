#Created for Northern Arizona University and USGS Grand Canyon Monitoring and Research Center
#Created by: Daniel Hamill
#Last Update: December 11, 2014
#Notes:This script will produce PDF and PNG plots for sites with one sandbar with batymetry.
#Input File Type: .csv
#Input Files: 
#Bin                        Filename                      Header
#Channel Low ELevatio       Channel_Low_Elevation.csv     Site,Date,Plane_Height,Area_2D,Area_3D,Volume,Errors
#Eddy Fluctuating Zone      Eddy_Fluctuating_Zone.csv     Site,Date,Plane_Height,Area_2D,Area_3D,Volume,Errors
#Eddy High Elevation        Eddy_High_Elevation_Zone.csv  Site,Date,Plane_Height,Area_2D,Area_3D,Volume,Errors
#Eddy Low Elevation         Eddy_Low_Elevation_Zone.csv   Site,Date,Plane_Height,Area_2D,Area_3D,Volume,Errors
#Total Eddy                 Total_Eddy.csv                Date,Volume,Errors
#Known Bugs: Script will fail if there are blank lines at the bottom of the input files

#open required Libraries
library(ggplot2)
library(gridExtra)
library(extrafont)
library(extrafontdb)
library(scales)

print("Now plotting sites with two sandbars with bathymetry")

#Set working directry
setwd("C:/workspace/sandbar_process/plotting_out/")

#get list of folders in the Script_Out directory
foldernames <- list.files(path="C:/workspace/sandbar_process/csv_output/Two_Bar_CSVs")

#Import LU_Table
LU_Table <- read.csv("C:/workspace/sandbar_process/Three_Graph_Y_Limit.csv",header=TRUE)

#Convert LU_Table to numbers
LU_Table$Eddy_Area <- as.numeric(as.character(LU_Table$Eddy_Area))
LU_Table$Eddy_Volume <- as.numeric(as.character(LU_Table$Eddy_Volume))
LU_Table$Total_Volume <- as.numeric(as.character(LU_Table$Total_Volume))
LU_Table$Site <- as.character(LU_Table$Site)
for(i in foldernames){
  
  filepath <- file.path("C:/workspace/sandbar_process/csv_output/Two_Bar_CSVs",paste(i)) 
  TotalEddyFilePath <- file.path(filepath, "Total_Eddy.csv")
  EddyFlucZoneFilePath <- file.path(filepath, "Eddy_Fluctuating_Zone.csv")
  EddyHighEleZoneFilePath <- file.path(filepath, "Eddy_High_Elevation_Zone.csv")
  EddyLowEleZoneFilePath <- file.path(filepath, "Eddy_Low_Elevation_Zone.csv")
  ChanLowEleZoneFilePath <- file.path(filepath, "Channel_Low_Elevation.csv")
 
  #Imort data into data frames
  Eddy_Total <- read.csv(TotalEddyFilePath)
  Chan_Min   <- read.csv(ChanLowEleZoneFilePath)
  Eddy_Min   <- read.csv(EddyLowEleZoneFilePath)
  Eddy_Fluc  <- read.csv(EddyFlucZoneFilePath)
  Eddy_High  <- read.csv(EddyHighEleZoneFilePath)
  
  #convert Dates to native format in R
  Eddy_Total$Date <- as.Date(Eddy_Total$Date,"%m/%d/%Y")
  Chan_Min$Date <- as.Date(Chan_Min$Date,"%m/%d/%Y")
  Eddy_Min$Date <- as.Date(Eddy_Min$Date,"%m/%d/%Y")
  Eddy_Fluc$Date <- as.Date(Eddy_Fluc$Date,"%m/%d/%Y")
  Eddy_High$Date <- as.Date(Eddy_High$Date,"%m/%d/%Y")
  
  #Convert Areas to numbers
  Eddy_High$Area_2D <- as.numeric(Eddy_High$Area_2D)
  Eddy_High$Area_3D <- as.numeric(Eddy_High$Area_3D)
  Eddy_High$Volume <- as.numeric(Eddy_High$Volume)
  Eddy_High$Errors <- as.numeric(Eddy_High$Errors)
      
  #Create subset of eddy fluc area and eddy high area for plotting
  FlucArea <- subset(Eddy_Fluc,select=c(Date,Area_2D))
  HighArea <- subset(Eddy_High,select=c(Date,Area_2D))
  
  #Create Directroy for the output Table CSV's
  Table_Out <- paste("C:/workspace/sandbar_process/plotting_out/",i,sep="")
  dir.create(Table_Out)
  CSV_Eddy <- paste(Table_Out,"/",i,"_Eddy_Table.csv",sep="")
  CSV_Site <- paste(Table_Out,"/",i,"_Site_Table.csv",sep="")
  CSV_Merge <- paste(Table_Out,"/",i,"_Merge_Site_Table.csv",sep="")
  
  #Create CSV for Site Eddy Table
  Low_Ele <- subset(Eddy_Min, select=c(Date,Area_2D,Volume,Errors))
  Fluc <- subset(Eddy_Fluc, select = c(Date,Area_2D,Volume,Errors))
  High <- Eddy_High[,c("Date","Area_2D","Volume","Errors")]
  High$Area_2D <- formatC(round(High$Area_2D,digits=0),big.mark = ",")
  High$Volume <- as.character(paste(round(High$Volume,digits=0), " ± ",round(High$Errors,digits=0)))
  High <- High[,c("Date","Area_2D","Volume")]
  names(High) <- c("Date","Area.High","Volume.High")
  t1 <- merge(Fluc,Low_Ele, by='Date',all.x=TRUE)
  t1$Volume.x <- as.character(paste(formatC(round(t1$Volume.x, digits =0),big.mark=',',format="fg",drop0trailing = T), " ± " , 
                                    formatC(round(t1$Errors.x, digits=0),big.mark=',',format="fg",),sep=""))
  t1$Volume.y <- as.character(paste(formatC(round(t1$Volume.y, digits =0),big.mark=',',format="fg",drop0trailing = T), " ± " , 
                                    formatC(round(t1$Errors.y, digits=0),big.mark=',',format="fg",drop0trailing = T),sep=""))
  t1 <- t1[,c("Date","Area_2D.x","Volume.x","Area_2D.y","Volume.y")]
  t1$Area_2D.x <- formatC(round(t1$Area_2D.x,digits=0),big.mark=',',format="f",drop0trailing = T)
  t1$Area_2D.y <- formatC(round(t1$Area_2D.y,digits=0),big.mark=',',format="f",drop0trailing = T)
  names(t1) <- c("Date","Area.Fluc","Volume.Fluc","Area.Low","Volume.Low")
  Eddy_Table <- merge(t1,High,by='Date',all.x=TRUE)
  Eddy_Table <- Eddy_Table[,c("Date","Area.High","Volume.High","Area.Fluc","Volume.Fluc","Area.Low","Volume.Low" )]
  write.table(Eddy_Table,file=CSV_Eddy,sep=":",row.names=F, na="")
  

  
  #Create CSV fpr Site Summary Table
  Total_Eddy_Format <- Eddy_Total[,c("Date","Volume","Errors")]
  Total_Eddy_Format$Volume <- as.character(paste(formatC(round(Total_Eddy_Format$Volume, digits =0),big.mark=',',format="fg",drop0trailing = T)  , " ± " , 
                                                 formatC(round(Total_Eddy_Format$Errors, digits=0),big.mark=',',drop0trailing=T), sep=""))
  Total_Eddy_Format <- Total_Eddy_Format[,c("Date","Volume")]
  Channel_Format <- Chan_Min[,c("Date","Volume","Errors")]
  Channel_Format$Volume <- as.character(paste(formatC(round(Channel_Format$Volume, digits =0),big.mark=',',format="fg",drop0trailing = T)  , " ± " , 
                                              formatC(round(Channel_Format$Errors, digits=0),big.mark=',',format="fg",drop0trailing = T),sep=""))
  Channel_Format <- Channel_Format[,c("Date","Volume")]
  Site_Summary <- merge(Total_Eddy_Format,Channel_Format,by='Date',all.x=T,all.y=T)
  
  #Calculate the total site volume and Errors
  dat1 <- merge(Chan_Min,Eddy_Total,by='Date',all.x=T,all.y=T)
  dat1 <- dat1[ ,c("Date","Volume.x","Errors.x","Volume.y","Errors.y")]
  for(n in 1:nrow(dat1)){
    dat1$Total_Volume[n] <- dat1$Volume.x[n]+ dat1$Volume.y[n]
    dat1$Total_Error[n] <- dat1$Errors.x[n] + dat1$Errors.y[n]
    dat1$Total_Site_Vol[n] <- as.character(paste(formatC(round(dat1$Total_Volume[n], digits=0),big.mark=',',format="fg",drop0trailing = T), " ± ",
                                                 formatC(round(dat1$Total_Error[n],digits=0),big.mark=',',format="fg",drop0trailing = T),sep=""))
  }
  dat1 <- dat1[,c("Date","Total_Site_Vol")]
  Site_Summary <- merge(Site_Summary,dat1,by='Date')
  write.table(Site_Summary,file=CSV_Site,sep=":",row.names=F,na="",quote=F)
  
  #Create merged Table
  t4 <- merge (Eddy_Table,Site_Summary,by='Date', all.x=T)
  write.table(t4,file=CSV_Merge,sep=":",row.names=F,quote=F)
  
  
  #Add ID to each Area subset for plotting
  FlucArea$ID = 'Fluctuating Zone'
  HighArea$ID = 'High Elevation'
  
  #Merge area data frames for plotting
  Area_Merge <- rbind(FlucArea, HighArea)
  
  #Determine the y extent of the plots
  u=1
  t=1
  v=1
  
  for (j in LU_Table$Site){
    (ifelse ((i==j),y3 <- as.numeric(as.character(LU_Table$Total_Volume[u])) ,(u <- u+1)))}
  for (k in LU_Table$Site){
    (ifelse ((i==k),y2 <- as.numeric(as.character(LU_Table$Eddy_Volume[t])) ,(t <- t+1)))}
  for (l in LU_Table$Site){
    (ifelse ((i==l),y1 <- as.numeric(as.character(LU_Table$Eddy_Area[v])),(v <- v+1)))}

  #Create area plot
  p1 <-ggplot(Area_Merge, aes(x = Date, y = Area_2D, color = ID)) + 
    ggtitle(as.character(i))+
    scale_color_manual(values = c("#000000", "#0000BB")) +
    geom_point(size = 2) + 
    geom_line(size = 0.5)+
	  scale_x_date(lim = c(as.Date("1990-1-1"), as.Date("2016-1-1")),labels = date_format("%Y"), breaks = date_breaks("2 year"))+
    xlab("Date")+ylab("Area, in square meters")+ 
    scale_y_continuous(labels = comma,limits=c(0,y1))+
    theme(axis.line = element_line(colour = "black"),
          plot.title=element_text(size=9,family="Arial Narrow",vjust=2),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(),
          axis.text = element_text(colour = "black",family="Arial Narrow",size=8),
          axis.title.x=element_text(size=8, family="Arial Narrow"),
          axis.title.y=element_text(size=8, family="Arial Narrow"),
          axis.ticks.length = unit(-.2,"cm"),
          axis.text.x = element_text(margin=margin(10,5,5,5,"pt")),
          axis.text.y = element_text(margin=margin(5,10,5,5,"pt")),
          legend.background = element_rect(colour = "black"),
          legend.key = element_rect(color=NA, fill="white"),
          legend.text = element_text(size=8, family="Arial Narrow"),
          legend.title = element_blank(),
          legend.position=c(0.9,0.9))
  
  #Create subsets for eddy volume and charts
  FlucVol <- subset(Eddy_Fluc, select = c(Date,Volume,Errors))
  HighVol <- subset(Eddy_High, select = c(Date,Volume,Errors))
  
  #Add ID for plotting eddy volumne chart
  FlucVol$ID = 'Fluctuating Zone'
  HighVol$ID = 'High Elevation'
  
  #Merge volume dataframes for plotting
  Vol_Merge <- rbind(FlucVol,HighVol)
      
  #Create area plot
  p2 <-ggplot(Vol_Merge, aes(x = Date, y = Volume, color = ID)) + 
    scale_color_manual(values = c("#000000", "#0000BB")) +
    geom_errorbar(aes(ymin=Volume-Errors,ymax=Volume+Errors), width=100,size=0.1) +
    geom_point(size = 2) + 
    geom_line(size = 0.5)+
    scale_x_date(lim = c(as.Date("1990-1-1"), as.Date("2016-1-1")),labels = date_format("%Y"), breaks = date_breaks("2 year"))+
    xlab("Date")+
    ylab("Volume, in cubic meters")+ 
    scale_y_continuous(labels = comma,limits=c(0,y2))+
    theme(axis.line = element_line(colour = "black"),
          plot.title=element_text(size=9,family="Arial Narrow",vjust=2),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(),
          axis.text = element_text(colour = "black",family="Arial Narrow",size=8),
          axis.title.x=element_text(size=8, family="Arial Narrow"),
          axis.title.y=element_text(size=8, family="Arial Narrow"),
          axis.ticks.length = unit(-.2,"cm"),
          axis.text.x = element_text(margin=margin(10,5,5,5,"pt")),
          axis.text.y = element_text(margin=margin(5,10,5,5,"pt")),
          legend.background = element_rect(colour = "black"),
          legend.key = element_rect(color=NA, fill="white"),
          legend.text = element_text(size=8, family="Arial Narrow"),
          legend.title = element_blank(),
          legend.position=c(0.9,0.9))
  
  #Create subsets for total eddy/channel chart
  ChanVol <- subset(Chan_Min, select = c(Date,Volume,Errors))
  
  #Add ID for plotting 
  ChanVol$ID = 'Channel'
  Eddy_Total$ID = 'Total Eddy'
  
  #Merge datasets for plotting
  Total_Merge <- rbind(ChanVol,Eddy_Total)
  
  #Create total volume plot
  p3 <-ggplot(Total_Merge, aes(x = Date, y = Volume, color = ID)) + 
    scale_color_manual(values = c("#000000", "#0000BB")) +
    geom_errorbar(aes(ymin=Volume-Errors,ymax=Volume+Errors), width=100,size=0.1) +
    geom_point(size = 2) + 
    geom_line(size = 0.5)+
     scale_x_date(lim = c(as.Date("1990-1-1"), as.Date("2016-1-1")),labels = date_format("%Y"), breaks = date_breaks("2 year"))+
    xlab("Date")+
    ylab("Volume, in cubic meters")+ 
    scale_y_continuous(labels = comma,limits=c(0,y3))+
    theme(axis.line = element_line(colour = "black"),
          plot.title=element_text(size=9,family="Arial Narrow",vjust=2),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank(),
          axis.text = element_text(colour = "black",family="Arial Narrow",size=8),
          axis.title.x=element_text(size=8, family="Arial Narrow"),
          axis.title.y=element_text(size=8, family="Arial Narrow"),
          axis.ticks.length = unit(-.2,"cm"),
          axis.text.x = element_text(margin=margin(10,5,5,5,"pt")),
          axis.text.y = element_text(margin=margin(5,10,5,5,"pt")),
          legend.background = element_rect(colour = "black"),
          legend.key = element_rect(color=NA, fill="white"),
          legend.text = element_text(size=8, family="Arial Narrow"),
          legend.title = element_blank(),
          legend.position=c(0.9,0.9))
  
  #Create outputfile path
  fileExt <- ".pdf"
  outfilename <- paste(i,fileExt,sep="")
  outpicname <- paste(i,".png",sep="")
  
  pdf(file=outfilename, paper="letter", width=8, height=10)    
  grid.arrange(p1,p2,p3,ncol=1,nrow=3) 
  dev.off()
  
png(filename = outpicname , res=1200, width=8, height=10, unit="in")  
grid.arrange(p1,p2,p3,ncol=1,nrow=3) 
dev.off()

print(i)

}
