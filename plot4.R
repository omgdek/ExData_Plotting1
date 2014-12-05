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
data$Date <- dmy_hms(paste(data$Date, data$Time))
data <- filter(data
               , year(Date) == 2007 & month(Date) == 2 & day(Date) <= 2)

data[3:9] <- lapply(data[3:9], as.numeric)


# # Create Plot
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "transparent")
par(mfcol = c(2, 2))

# Top Left
with(data, plot(Date, Global_active_power
                , type = "l"
                , ylab = "Global Active Power (kilowatts)"
                , xlab = ""))

# Bottom Left
with(data, plot(Date, Sub_metering_1, type = "n", xlab = "", ylab = ""))
with(data, points(Date, Sub_metering_1, col = "black", type = "l"))
with(data, points(Date, Sub_metering_2, col = "red", type = "l"))
with(data, points(Date, Sub_metering_3, col = "blue", type = "l"))
title(ylab = "Energy sub metering")
legend("topright"
       , lty = c(1,1,1)
       , bty = "n"
       , col = c("black", "red", "blue")
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Top Right
with(data, plot(Date, Voltage
     , type = "l"
     , ylab = "Voltage"
     , xlab = "datetime"))

# Bottom Right
with(data, plot(Date, Global_reactive_power
                , type = "l"
                , ylab = "Global_reactive_power"
                , xlab = "datetime"))

dev.off()