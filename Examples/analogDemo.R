source("../BoardControl/functions.R")
rduino_connect()
Sys.sleep(2)

off <- get_dpin(4)
while (!off) {
	intensity <- floor(get_apin(5) / 4)
	set_apin(11, intensity)
	set_apin(5, intensity)
	off <- get_dpin(4)
}
rduino_close()
