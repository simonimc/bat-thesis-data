#IMPORTANT: Files saved as "1Hocking..." or "2Hocking..." MUST BE RENAMED
###I have renamed a "Hocking...a" or "Hocking...b" respectively
#IMPORTANT: Files MUST be saved in the proper format (e.i. .txt or .csv)

# Get all file names with path including the directories below the wd that have csv in them
file.list <- list.files(full.names = T, recursive = T, pattern = "csv")

# Get file names without path for naming the objects and strip .csv
object.names <- sub(".csv", "", list.files(recursive = T, include.dirs = FALSE, pattern = "csv"))

#Sub selection from file.list for 2014
sub.file.list <- file.list[grep("2014", file.list)]

# loop for reading in files
for (i in 1:length(file.list)){
 datafile <- read.csv(file.list[i])
 assign(paste(file, i, sep = ""), datafile)  
}

#vector for lines unneeded in txt files
noneed.txt<- c("H R", "M E               WGS 84 100 +0.000000e+00+0.000000e+00   +0   +0   +0", "FLatitude   Longitude   Alt(m)   Date       Time     S")
#vector for lines unneeded in csv files "Excel compatible text file from GPS.ABG file stored in PDA", "Datum = WGS84", "DateTimeFormat = yyyy-mm-dd hh:mm:ss", "Latitude = degrees North, Longitude = degrees East", "Altitude = metres ASL", "PDOP, HDOP, VDOP in metres", "Timezone = 10"
noneed.csv<- c("Excel compatible text file from GPS.ABG file stored in PDA", "Datum = WGS84", "DateTimeFormat = yyyy-mm-dd hh:mm:ss", "Latitude = degrees North, Longitude = degrees East", "Altitude = metres ASL", "PDOP, HDOP, VDOP in metres", "Timezone = 10")

For read.table: 
    Header defaults FALSE
    na.strings--> character vector of strings to be interpreted as NA values; includes blank fields
read.table("./DOW bat GPS Files/GPS Files/GPS- 2012/Lawrence062712.csv", na.strings= noneed)

-START HERE--------------------------------------------------------------------------------------------------------

# Get all file names with path including the directories below the wd that have csv in them
file.list.txt <- list.files(full.names = T, recursive = T, pattern = "txt")
file.list.txt<- file.list.txt[grep("GPS", file.list.txt)]
file.list.csv <- list.files(full.names = T, recursive = T, pattern = "csv")
file.list.csv<- file.list.csv[grep("GPS", file.list.csv)]
file.list<- c(file.list.txt, file.list.csv)

# Get file names without path (function basename()) for naming the objects and strip .csv
object.names.csv<- sub(".csv", "", basename(file.list.csv))
object.names.txt<- sub(".txt", "", basename(file.list.txt))
object.names<- c(object.names.csv, object.names.txt)

#Sub selection from file.list for 2014
sub.file.list <- file.list[grep("2014", file.list)]
#Do this for csv and txt******************
sub.file.list.2011 <- file.list[grep("2011", file.list)]
sub.file.list.2012 <- file.list[grep("2012", file.list)]
sub.file.list.2013 <- file.list[grep("2013", file.list)]
sub.file.list.2015 <- file.list[grep("2015", file.list)]
sub.file.list.2016 <- file.list[grep("2016", file.list)]
sub.file.list.2014 <- file.list[grep("2014", file.list)]

# Column names - I buffered with some extra variables to accommodate the weird long WGS lines
var.names.txt <- c("F", "Latitude", "Longitude", "Alt", "Date", "Time", "S", "v8", "v9", "v10")
var.names.csv<- c("Date Time", "Latitude", "Longitude", "Alt", "Valid", "Nsats", "PDOP", "HDOP", "VDOP")

# read in data (works for the tab delimited ones)
foo <- read.table(file.list[1], blank.lines.skip = T, fill = T, col.names = var.names, as.is = T)
# This leaves the extra rows of headers - find them and delete them
foo <- foo[foo[,2] != "Latitude",]
# file.list[2] seems an unproblematic csv file - in all GPS 2015 seems clean and has different column order
# Trying [42] "1Hocking071411"
foo <- read.table(file.list[42], blank.lines.skip = T, fill = T, col.names = var.names, as.is = T)
# This leaves the extra rows of headers - find them and delete them
foo <- foo[foo[,2] != "Latitude",]
# And the "WGS" lines
foo <- foo[foo[,3] != "WGS",]
# And the "H" lines
foo <- foo[foo[,1] != "H",]
str(foo)

#***USE NEXT 2 LOOPS*** 
# loop for reading in txt files
for (i in 1:length(file.list.txt)){
  datafile <- read.table(file.list.txt[i], blank.lines.skip = T, fill = T, col.names = var.names.txt, as.is = T)
  # Remove extra rows of headers
  datafile <- datafile[datafile[,2] != "Latitude",]
  # And the "WGS" lines
  datafile <- datafile[datafile[,3] != "WGS",]
  # And the "H" lines
  datafile <- datafile[datafile[,1] != "H",]
  assign(object.names.txt[i], datafile)
}

# loop for reading in csv files
for (i in 1:length(file.list.csv)){
  datafile <- read.csv(file.list.csv[i], blank.lines.skip = T, fill = T, col.names = var.names.csv, as.is = T)
  assign(object.names.csv[i], datafile)
}

#belmont070914 has time reset at line 44 in excel
#all Ashland 2015 files have weird time resets in excel
#belmont072215 has time change at line 8911 in excel
#line 9669 ceasarscreek72215 time changes in excel
#multiple day/time changes in Wood072115
#wood071915 time reset at line 8640
#wood070615 time reset at line 7820
#issues with sharon071315 through pt5 files
#licking070915 date and time change at line 235 in excel
#Harrison072315 +pt2 very off.  dates and times
#Geauga070815 time change at line 10495
#Darby 070615pt2 time change at line 5010
#ClearCreek072715pt2 time change at line 9495
#ClearCreek072115 +pt2 off
#Cinci072715 time and date change at line 5993
#Harrison 071016 improper time
#Shelby 2016 all mismatched
#ClevelandMP2015.txt starts in 1969
#as.is() --> check classes of columns


#Begin date and time testing
object.names.csv.test<- object.names.csv
object.names.txt.test<- object.names.txt
object.names.test<- object.names
objects.test<- mget(object.names.test)
objects.csv.test<- mget(object.names.csv.test)
objects.txt.test<- mget(object.names.txt.test)

#For text files, must combine the separate x$Date and x$Time columns)
test<- Lawrence062211
test$date.time <- as.POSIXlt(paste(test$Date, test$Time), tz="EST", format= "%Y-%m-%d %H:%M:%S")
class(test$date.time)
test$date.time
test$date.time[1]-test$date.time[2]
test$date.time + 20*60*60

#For csv files, can just loop for as.POSIXlt(x$Date.Time) and paste
test.2<- waldo70716
test.2$date.time <- as.POSIXlt(paste(test.2$Date.Time), tz="EST", format= "%Y-%m-%d %H:%M:%S")

#Try Loops for csv's
object.names.csv.test<- object.names.csv
for (i in 1:length(object.names.csv.test)){
  #Get individual tables from object names vector
  table<- get(object.names.csv.test[i])
  #Add the new column
  table$date.time<- as.POSIXlt(paste(table$Date.Time), tz="EST", format= "%Y-%m-%d %H:%M:%S")
  }
#Check a couple csv tables
head(Shelby072313)
str(Shelby072313)
head(wood070714)
str(wood070714)
#Doesn't work for each individual table.  However, the table vector has the new column... it just didn't apply to the other individual objects.
#removing vector 'table' b/c it is so large
rm(table)

#Try Loops for txt's
object.names.txt.test<- object.names.txt