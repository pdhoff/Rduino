library(Rduino)
rduinoConnect(baud=9600,mode="n,8,1",upload=TRUE)

for (i in seq(from=1,to=256,by=5)) {
	setApin(11, i)
	Sys.sleep(0.05)
}
rduinoClose()
rduinoConnect(baud=38400,mode="n,8,1",upload=TRUE)
for (i in 0:9) {
	setDpin(8,1)
	Sys.sleep(0.1)
	setDpin(8,0)
	Sys.sleep(0.1)
}
rduinoClose()
