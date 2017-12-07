library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

off<-getDpin(4)
while (!off) {
	angle<-getApin(5)
	angle<-1.68 * angle + 575	# maps potentiometer to servo, varies slightly	
								# for different servos
	onServo(9, angle)
	off<-getDpin(4)
}
offServo()
rduinoClose()
