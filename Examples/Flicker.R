library(serial)

delay <- 0.05
con <- serialConnection(name="test", port="cu.usbmodem1421", mode="19200,n,8,1", buffering="none", newline=1, translation="lf")

open(con)
Sys.sleep(2)

for (i in 0:9) {
	write.serialConnection(con, "digWrite,2,1")
	Sys.sleep(delay)
	write.serialConnection(con, "digWrite,2,0")
	Sys.sleep(delay)
}

close(con)
