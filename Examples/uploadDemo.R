library(Rduino)

rduino_connect(baud=9600,mode="n,8,1",upload=TRUE)
for (i in seq(from=1,to=256,by=5)) {
	set_apin(11, i)
	Sys.sleep(0.05)
}
rduino_close()
rduino_connect(baud=38400,mode="n,8,1",upload=TRUE)
for (i in 0:9) {
	set_dpin(8,1)
	Sys.sleep(0.1)
	set_dpin(8,0)
	Sys.sleep(0.1)
}
rduino_close()
