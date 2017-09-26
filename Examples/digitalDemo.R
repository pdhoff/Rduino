source("../BoardControl/functions.R")
rduino_connect("38400,n,8,1")

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
