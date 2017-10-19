library(Rduino)

delay <- 0.05
rduino_connect(baud="38400",mode="n,8,1",upload=FALSE)

for (i in 0:9) {
	set_dpin(8, 1)
	Sys.sleep(delay)
	set_dpin(8,0)
	Sys.sleep(delay)
}

rduino_close()
