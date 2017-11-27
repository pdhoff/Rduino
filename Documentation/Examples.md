# Examples

### analogDemo.R
``` R
source("../BoardControl/functions.R")
rduino_connect("38400,n,8,1")

off <- get_dpin(4)
while (!off) {
	intensity <- floor(get_apin(5) / 4)
	set_apin(11, intensity)
	set_apin(5, intensity)
	off <- get_dpin(4)
}
set_dpin(11, 0)
set_dpin(5, 0)
rduino_close()

```
This example initiates a connection between R and the Arduino at 38400 baud with no parity bit, 8 data bits, and 1 stop bit. It then varies the voltage at the PWM pins connected to LEDs so that the brightness of the LED can be controlled by the potentiometer (It is divided by 4 to properly scale with the brightness levels of the LED; the potentiometer can vary between 0-1023 while the LED varies between 0-255). The while loop continues until the pushbutton is pressed, which sends "1" to R, which then causes the while loop to be exited. This examples showcases the potential of Rduino to respond to inputs from the Arduino pins.

### dataTracking.R
```R
source("../BoardControl/functions.R")
rduino_connect("38400,n,8,1")

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
```
dataTracking.R connects to the Arduino at 38400 baud with no parity bit, 8 data bits, and 1 stop bit. It then creates a plot, and reads in values from the potentiometer and adds them to the plot every 0.05 seconds. Every 25 points, it refreshes the plot, and continues to loop through this process until the pushbutton is pressed. This simple examples demonstrates the potential for Rduino to provide real time updates while gathering data through the Arduino. 

### digitalDemo.R
```R
source("../BoardControl/functions.R")
rduino_connect("38400,n,8,1")

off <- get_apin(5)
while (off != 1023) {
	switch <- get_dpin(4)
	set_dpin(2, switch)
	set_dpin(5, switch)
	set_dpin(8, switch)
	set_dpin(11, switch)
	off <- get_apin(5)
}	
set_dpin(2, 0)
set_dpin(5, 0)
set_dpin(8, 0)
set_dpin(11, 0)
rduino_close()
```
digitalDemo.R is similar to analogDemo.R, but with an emphasis on the usability and speed of the digital components of Rduino. After initializing a connection at 38400 baud with no parity bit, 8 data bits, and 1 stop bit, if continually reads in from the digital pin so that when the digital pin is pressed, the LEDs are lit. When the potentiometer is set to 1023, the program ends and the connection is terminated. 

### flicker.R
```R
source("../BoardControl/functions.R")

delay <- 0.05
rduino_connect("38400,n,8,1")

for (i in 0:9) {
	set_dpin(8, 1)
	Sys.sleep(delay)
	set_dpin(8,0)
	Sys.sleep(delay)
}

rduino_close()
```
flicker.R simply tests the speed of the Rduino package. It rapidly turns the LEDs on and off, to show that communication between R and Arduino happens quickly.

### servoDemo.R
```R
source("../BoardControl/functions.R")
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
```
servoDemo.R connects to the Arduino at 38400 baud with no parity bit, 8 data bits, and 1 stop bit, and then allows the user to control the angle of the servo by turning the potentiometer. 1.68 was calculating by experimentally determining that the maximum angle of the particular servo used for testing was 2300, and that the minimum was 575. Thus, mapping that relationship to the 0-1023 range of the potentiometer yielded a multiplier of 1.68, and 575 was added so that would be the lowest value. The program ends when the pushbutton is pressed.