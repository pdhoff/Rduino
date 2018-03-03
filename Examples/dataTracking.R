# Example demonstrating data tracking from inputs using Rduino package
# wiring: see "LED" schematic in /Examples/Schematics

library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

time <- 0:24
data <- rep(NA, 25)
off <- getDpin(4)
iteration <- 0
plot(data ~ time, main="Arduino Data", ylim=c(0,1023))

while (!off) {
	if (iteration == length(time)) {
		iteration <- 0
		plot(data ~ time, main="Arduino Data", ylim=c(0,1023))
	}
	obs <- getApin(5)
	points(iteration, obs)
	Sys.sleep(0.05)
	off <- getDpin(4)
	iteration <- iteration + 1
}
rduinoClose()
