source("../BoardControl/functions.r")
rduino_connect("38400,n,8,1")

off<-get_dpin(4)
while (!off) {
	angle<-get_apin(5)
	angle<-1.68 * angle + 575	# maps potentiometer to servo, varies slightly	
					# for different servos
	start_pulse(9,angle)
	off<-get_dpin(4)
}
stop_pulse()
rduino_close()
