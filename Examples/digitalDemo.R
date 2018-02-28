# Example showcasing digital output functionality of Rduino package
# wiring: see "LED" schematic in /Examples/Schematics

library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

off <- getApin(5)
while (off != 1023) {
	switch <- getDpin(4)
	setDpin(2, switch)
	setDpin(5, switch)
	setDpin(8, switch)
	setDpin(11, switch)
	off <- getApin(5)
}	
setDpin(2, 0)
setDpin(5, 0)
setDpin(8, 0)
setDpin(11, 0)
rduinoClose()
