con <- serialConnection(name="testCon", port="cu.usbmodem1421", mode="9600,n,8,1", buffering="none", newline=0, translation="cr")
open(con)
Sys.sleep(2)
read.serialConnection(con)

Sys.sleep(10)
data <- read.serialConnection(con)
 
