#open required Libraries
library(ggplot2)
library(gridExtra)
library(extrafont)
library(extrafontdb)
library(scales)

print("Now plotting sites with one sandbar w/o bathmetry")

#Set working directry
setwd("C:/workspace/sandbar_process/plotting_out/")

#get list of folders in the Script_Out directory
foldernames <- list.files(path="C:/workspace/sandbar_process/csv_output/No_Bath_CSVS")

#Import LU_Table
LU_Table <- read.csv("C:/workspace/sandbar_process/Two_Graph_Y_Limit.csv",header=TRUE)

#Convert LU_Table to numbers
LU_Table$Eddy_Area <- as.numeric(as.character(LU_Table$Eddy_Area))
LU_Table$Eddy_Volume <- as.numeric(as.character(LU_Table$Eddy_Volume))
LU_Table$Site <- as.character(LU_Table$Site)
for(i in foldernames){
  
  filepath <- file.path("C:/workspace/sandbar_process/csv_output/No_Bath_CSVS",paste(i))
  EddyFlucZoneFilePath <- file.path(filepath, "Eddy_Fluctuating_Zone.csv")
  EddyHighEleZoneFilePath <- file.path(filepath, "Eddy_High_Elevation_Zone.csv")
 
  #Imort data into data frames
  Eddy_Fluc  <- read.csv(EddyFlucZoneFilePath)
  Eddy_High  <- read.csv(EddyHighEleZoneFilePath)
  
  #convert Dates to native format in R
  Eddy_Fluc$Date <- as.Date(Eddy_Fluc$Date,"%m/%d/%Y")
  Eddy_High$Date <- as.Date(Eddy_High$Date,"%m/%d/%Y")
  
  #Convert Areas to numbers
  Eddy_High$Area_2D <- as.numeric(Eddy_High$Area_2D)
  Eddy_High$Area_3D <- as.numeric(Eddy_High$Area_3D)
  Eddy_High$Volume <- as.numeric(Eddy_High$Volume)
  Eddy_High$Errors <- as.numeric(Eddy_High$Errors)
  Eddy_Fluc$Area_2D <- as.numeric(Eddy_Fluc$Area_2D)
  Eddy_Fluc$Area_3D <- as.numeric(Eddy_Fluc$Area_3D)
  Eddy_Fluc$Volume <- as.numeric(Eddy_Fluc$Volume)
  Eddy_Fluc$Errors <- as.numeric(Eddy_Fluc$Errors)
      
  #Create subset of eddy fluc area and eddy high area for plotting
  FlucArea <- subset(Eddy_Fluc,select=c(Date,Area_2D))
  HighArea <- subset(Eddy_High,select=c(Date,Area_2D))
  
  #Create Directroy for the output Table CSV's
  Table_Out <- paste("C:/workspace/sandbar_process/plotting_out/",i,sep="")
  dir.create(Table_Out)
  CSV_Merge <- paste(Table_Out,"/",i,"_Merge_Site_Table.csv",sep="")
  
  #Create CSV for Site Eddy Table\
  High <- Eddy_High[,c("Date","Area_2D","Volume","Errors")]
  High$Area_2D <- formatC(round(High$Area_2D,digits=0),big.mark = ",")
  High$Volume <- as.character(paste(round(High$Volume,digits=0), " ± ",round(High$Errors,digits=0)))
  High <- High[,c("Date","Area_2D","Volume")]
  names(High) <- c("Date","Area.High","Volume.High")
  
  Fluc <- subset(Eddy_Fluc, select = c(Date,Area_2D,Volume,Errors))
  Fluc$Area_2D <- formatC(round(Fluc$Area_2D,digits=0),big.mark = ",")
  Fluc$Volume <- as.character(paste(round(Fluc$Volume,digits=0), " ± ",round(Fluc$Errors,digits=0)))
  Fluc <- Fluc[,c("Date","Area_2D","Volume")]
  names(Fluc) <- c("Date","Area.Fluc","Volume.Fluc")

  Eddy_Table <- merge(High,Fluc,by='Date',all.x=TRUE)
  write.table(Eddy_Table,file=CSV_Merge,sep=":",row.names=F, na="", quote=F)
  
  #Add ID to each Area subset for plotting
  FlucArea$ID = 'Fluctuating Zone'
  HighArea$ID = 'High Elevation'
  
  #Merge area data frames for plotting
  Area_Merge <- rbind(FlucArea, HighArea)
  
  #Determine the y extent of the plots
  t=1
  v=1
  
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
  
  
#Create outputfile path
fileExt <- ".pdf"
outfilename <- paste(i,fileExt,sep="")
outpicname <- paste(i,".png",sep="")

png(filename = outpicname , res=1200, width=8, height=10, unit="in")  
grid.arrange(p1,p2,ncol=1,nrow=3) 
dev.off()

pdf(file=outfilename, paper="letter", width=8, height=10)    
grid.arrange(p1,p2,ncol=1,nrow=3) 
dev.off()

print(i)

}
