source("../BoardControl/functions.R")
rduino_connect("19200,n,8,1")
Sys.sleep(2)  # Allow time for the connection to initialize

off <- get_apin(5)
while (off != 1023) {
	switch <- get_dpin(4)
	set_dpin(2, switch)
	set_dpin(5, switch)
	set_dpin(8, switch)
	set_dpin(11, switch)
	off <- get_apin(5)
}	
rduino_close()
