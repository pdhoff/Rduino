library(Rduino)
rduino_connect(baud="38400",mode="n,8,1",upload=FALSE)

off <- get_apin(5)
while (off != 1023) {
	switch <- get_dpin(4)
	set_dpin(2, switch)
	set_dpin(5, switch)
	set_dpin(8, switch)
	set_dpin(11, switch)
	off <- get_apin(5)
}	
set_dpin(2, 0)
set_dpin(5, 0)
set_dpin(8, 0)
set_dpin(11, 0)
rduino_close()
