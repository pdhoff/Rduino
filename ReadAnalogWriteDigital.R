# Simple R script to demonstrate how to use serialConnection package with 
# analog input and digital output

library(serial)
# port can be determined by using listPorts()
# replace "tty" with "cu", failing to do so will cause R to crash
con <- serialConnection(name="testCon", port="cu.usbmodem1421", mode="9600,n,8,1", buffering="none", newline=1, translation="cr")
# opens serialConnection for communication, 
# pause allows communication to be established
open(con)
Sys.sleep(2)
# read in from buffer
cat(read.serialConnection(con))
write.serialConnection(con, "a")
close(con)
 
