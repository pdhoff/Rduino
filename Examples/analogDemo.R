library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

off <- getDpin(4)
while (!off) {
	intensity <- floor(getApin(5) / 4)
	setApin(11, intensity)
	setApin(5, intensity)
	off <- getDpin(4)
}
setDpin(11, 0)
setDpin(5, 0)
rduinoClose()
