library(dplyr)
library(tidyr)
library(lubridate)

# Create new folder if does not exist
if(!file.exists("./data")){dir.create("./data")}

# Download data if does not exist
if(!file.exists("./data/exdata-data-household_power_consumption.zip")) {
      print("Downloading file")
      fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(fileUrl
                    , destfile = "./data/exdata-data-household_power_consumption.zip")
}

# Unzip downloaded file if not unzipped
if(!file.exists("./data/household_power_consumption.txt")) {
      print("Unzipping")
      unzip("./data/exdata-data-household_power_consumption.zip"
            , exdir = "./data")   
}

# Load source tables
print("Loading Table")
data <- tbl_df(read.table("./data/household_power_consumption.txt"
                          , header = TRUE
                          , sep = ";"
                          , stringsAsFactors = FALSE))

# Clean
data$Date <- dmy(data$Date)
data <- filter(data
               , year(Date) == 2007 & month(Date) == 2 & day(Date) <= 2)
data$Global_active_power <- as.numeric(data$Global_active_power)

# Create Plot
png(filename = "plot1.png", width = 480, height = 480, units = "px")

hist(data$Global_active_power
     , main = "Global Active Power"
     , xlab = "Global Active Power (kilowatts)"
     , col = "red")

dev.off()