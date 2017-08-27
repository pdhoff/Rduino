source("../BoardControl/functions.R")
rduino_connect()
Sys.sleep(2)

time <- 0:24
data <- rep(NA, 25)
off <- get_dpin(4)
iteration <- 0
plot(data ~ time, main="Arduino Data", ylim=c(0,1023))

while (!off) {
	if (iteration == length(time)) {
		iteration <- 0
		plot(data ~ time, main="Arduino Data", ylim=c(0,1023))
	}
	obs <- get_apin(5)
	points(iteration, obs)
	Sys.sleep(0.05)
	off <- get_dpin(4)
	iteration <- iteration + 1
}
rduino_close()
