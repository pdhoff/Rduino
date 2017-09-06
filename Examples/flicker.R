source("../BoardControl/functions.R")

delay <- 0.05
rduino_connect("19200,n,8,1")
Sys.sleep(2)  # Allow time for the connection to initialize

for (i in 0:9) {
	set_dpin(2, 1)
	Sys.sleep(delay)
	set_dpin(2,0)
	Sys.sleep(delay)
}

rduino_close()
