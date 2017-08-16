source("../BoardControl/functions.R")
rduino_connect()
Sys.sleep(2)

Time <- 0:24
Data <- rep(NA, 25)
off <- get_dpin(4)
while (!off) {
	plot(Data ~ Time, main="Arduino Data", ylim=c(0,1023))
	for (i in 0:24) {
		obs <- get_apin(5)
		points(i, obs)
		Sys.sleep(0.05)
	}
	off <- get_dpin(4)
}
rduino_close()
