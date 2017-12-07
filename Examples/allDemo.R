# Examples showcasing basic functionality of the Rduino package
# hardware: Arduino Uno
# wiring: LEDs on pins 5, 8, and 11
#		  potentiometer on analog pin 5
#		  pushbutton on pin 4
#		  servo on pin 9
library(Rduino)
rduino_connect(baud="19200",mode="n,8,1",upload=TRUE)

# set_dpin
# flash LED rapidly
for (i in 0:9) {
	set_dpin(8,1)
	Sys.sleep(0.05)
	set_dpin(8,0)
	Sys.sleep(0.05)
}

# get_dpin
# LED remains on until pushbutton is pressed
isPressed<-get_dpin(4)
set_dpin(5,1)
while (!isPressed) {
	isPressed<-get_dpin(4)
}
set_dpin(5,0)

# set_apin
# gradually increases intensity of LED
for (i in seq(from=1,to=256,by=5)) {
	set_apin(11,i)
	Sys.sleep(0.05)
}

# get_apin and servo
# set position of servo to position of potentiometer
off<-get_dpin(4)
while (!off) {
	angle<-get_apin(5)
	angle<- 1.68 * angle + 575
	set_servo(9,angle)
	off<-get_dpin(4)
}
off_servo()

# upload capabilities 
# change baud rate and then flash LED
rduino_close()
rduino_connect(baud="38400",mode="n,8,1",upload=TRUE)
for (i in 0:9) {
	set_dpin(8,1)
	Sys.sleep(0.05)
	set_dpin(8,0)
	Sys.sleep(0.05)
}

rduino_close()

# change baud rate to default

