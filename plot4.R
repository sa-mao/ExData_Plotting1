library(dplyr)
library(readr)

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (! dir.exists("./data")) dir.create("./data")

download.file(fileUrl, destfile = "./data/raw_dataset.zip", method="curl")
unzip(zipfile = "./data/raw_dataset.zip" , exdir = "./data")

gpc <- read_csv2("./data/household_power_consumption.txt", na = c("?"))
gpc <- drop_na(gpc)

date_range <- c("1/2/2007", "2/2/2007")
# Keep only the observations in date_range.
gpc <- filter(gpc, Date %in% date_range)
# Convert the Date variable from char to Date class.
gpc$Date <- as.Date(gpc$Date, "%d/%m/%Y")
gpc$Global_active_power <- as.numeric(gpc$Global_active_power)
gpc$Sub_metering_1 <- as.numeric(gpc$Sub_metering_1)
gpc$Sub_metering_2 <- as.numeric(gpc$Sub_metering_2)
gpc$Sub_metering_3 <- as.numeric(gpc$Sub_metering_3)
gpc$DateTime <- as.POSIXct(paste(gpc$Date, gpc$Time), format ="%Y-%m-%d %H:%M:%S")

#png("./plot4.png", height = 480, width = 480)
par(mfrow = c(2, 2))
# First plot datetime, Global_active_power
plot(gpc$DateTime,
     gpc$Global_active_power,
     col = "red",
     main = "",
     ylab = "Global Active Power (kilowatts)",
     xlab = "",
     type = "n"
)

lines(gpc$DateTime, gpc$Global_active_power)

# Second plot
plot(gpc$DateTime,
     gpc$Voltage,
     col = "red",
     main = "",
     ylab = "Voltage",
     xlab = "Datetime",
     type = "n"
)
lines(gpc$DateTime, gpc$Voltage)

# Third plot
plot(
  gpc$DateTime,
  gpc$Sub_metering_1,
  ylim = c(
    min(gpc$Sub_metering_1),
    max(gpc$Sub_metering_1)
  ),
  type = "n",
  xlab = "",
  ylab = "",
  col = "black"
)

title(
  main = "",
  ylab = "Energy sub metering"
)
lines(gpc$DateTime, gpc$Sub_metering_1, col = "black")
lines(gpc$DateTime, gpc$Sub_metering_2, col = "red")
lines(gpc$DateTime, gpc$Sub_metering_3, col = "blue")
legend(
  "topright",
  col = c("black", "red", "blue"),
  legend = c(
    "Sub_metering_1",
    "Sub_metering_2",
    "Sub_metering_3"
  ),
  lty = c(1, 1)
)
# Fourth plot
plot(gpc$DateTime,
     gpc$Global_reactive_power,
     col = "red",
     main = "",
     ylab = "Global_reactive_power",
     xlab = "datetime",
     type = "n"
)
lines(gpc$DateTime, gpc$Global_reactive_power)
#dev.off()