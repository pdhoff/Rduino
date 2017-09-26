source("../BoardControl/functions.R")

delay <- 0.05
rduino_connect("38400,n,8,1")

for (i in 0:9) {
	set_dpin(8, 1)
	Sys.sleep(delay)
	set_dpin(8,0)
	Sys.sleep(delay)
}

rduino_close()
