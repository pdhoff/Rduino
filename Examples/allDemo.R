# Examples showcasing basic functionality of the Rduino package
# wiring: see "LED" schematic in /Examples/Schematics

library(Rduino)
rduinoConnect(baud="19200",mode="n,8,1",upload=TRUE)

# setDpin
# flash LED rapidly
for (i in 0:9) {
	setDpin(8,1)
	Sys.sleep(0.05)
	setDpin(8,0)
	Sys.sleep(0.05)
}

# getDpin
# LED remains on until pushbutton is pressed
isPressed<-getDpin(4)
setDpin(5,1)
while (!isPressed) {
	isPressed<-getDpin(4)
}
setDpin(5,0)

# setApin
# gradually increases intensity of LED
for (i in seq(from=1,to=256,by=5)) {
	setApin(11,i)
	Sys.sleep(0.05)
}

# getApin and servo
# set position of servo to position of potentiometer
off<-getDpin(4)
while (!off) {
	angle<-getApin(5)
	angle<- 1.68 * angle + 575
	set_servo(9,angle)
	off<-getDpin(4)
}
offServo()

# upload capabilities 
# change baud rate and then flash LED
rduinoClose()
rduinoConnect(baud="38400",mode="n,8,1",upload=TRUE)
for (i in 0:9) {
	setDpin(8,1)
	Sys.sleep(0.05)
	setDpin(8,0)
	Sys.sleep(0.05)
}

rduinoClose()

# change baud rate to default

