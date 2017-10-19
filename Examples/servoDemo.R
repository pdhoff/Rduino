library(Rduino)
rduino_connect(baud="38400",mode="n,8,1",upload=FALSE)

off<-get_dpin(4)
while (!off) {
	angle<-get_apin(5)
	angle<-1.68 * angle + 575	# maps potentiometer to servo, varies slightly	
								# for different servos
	set_servo(9, angle)
	off<-get_dpin(4)
}
off_servo()
rduino_close()
