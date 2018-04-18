# Modified version of dataTracking for PulseSensor
# wiring: see "SD card" scehmatic in /Examples/Schematics, replace the
#         potentiometer with the heartbeat sensor

library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

Sys.sleep(3)
threshold <- 780
time <- 0:29
obs <- rep(NA, length(time))
off <- getDpin(4)
iteration <- 1
plot(obs ~ time, main="Heart Beat", ,ylab="Voltage", xaxt="n", ylim=c(0,1023))

heartbeats <- 0
crossedThresh <- FALSE
startTime <- proc.time()[["elapsed"]]

while (!off) {
  # Refresh plot
	if (iteration == length(time)) {
		iteration <- 1
    obs <- rep(NA, length(time))
		plot(obs ~ time, main="Heart Beat", ylab="Voltage", xaxt="n", ylim=c(0,1023))
	}
	obs[iteration] <- getApin(0)
	lines(time, obs)

  if (obs[iteration] >= threshold) {
    crossedThresh <- TRUE
  }
  if (crossedThresh & obs[iteration] < threshold) {
    crossedThresh <- FALSE
    heartbeats <- heartbeats + 1
    elapsed <- proc.time()[["elapsed"]] - startTime
		print(paste("Heart Rate: ", heartbeats / elapsed * 60, sep=""))
  }
	off <- getDpin(4)
	iteration <- iteration + 1
  Sys.sleep(0.1)
}
rduinoClose()
