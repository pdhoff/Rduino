source("../BoardControl/functions.R")
rduino_connect("38400,n,8,1")

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
