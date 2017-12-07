library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)
delay <- 0.05

for (i in 0:9) {
	setDpin(8, 1)
	Sys.sleep(delay)
	setDpin(8,0)
	Sys.sleep(delay)
}

rduinoClose()
