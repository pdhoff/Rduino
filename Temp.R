# Collects temperature data from the Arduino, converts it to Celsius
# and then displays summary statistics
library(serial)
con <- serialConnection(name="testCon", port="cu.usbmodem1421", mode="9600,n,8,1", buffering="none", newline=0, translation="cr")
open(con)
Sys.sleep(1)
cat("Data Collection has begun\n")

for (i in 1:3) {
	cat("\n")
	readIn <- strsplit(read.serialConnection(con), "\n")
	readIn <- unlist(readIn)
	tempData <- double(length=length(readIn))
	for (int in 1:length(readIn)) {
		readArduino <- as.double(readIn[int])
		tempData[int] <- ((readArduino / 1024) * 165) - 40
	}
	cat(paste("Number of Measurements: ",length(tempData),"\n", sep=""))
	cat(paste("Standard Deviation: ",sd(tempData, na.rm=TRUE),"\n", sep=""))
	print(summary(tempData))
	Sys.sleep(3)
	remove(readIn)
	remove(readArduino)
	remove(tempData)
}
close(con)
 
