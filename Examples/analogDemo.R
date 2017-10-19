library(Rduino)
rduino_connect(baud=38400,mode="n,8,1",upload=FALSE)

off <- get_dpin(4)
while (!off) {
	intensity <- floor(get_apin(5) / 4)
	set_apin(11, intensity)
	set_apin(5, intensity)
	off <- get_dpin(4)
}
set_dpin(11, 0)
set_dpin(5, 0)
rduino_close()
