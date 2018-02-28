# Examples
##### For the following examples, use the wiring schematic below:
![alt-text](https://github.com/pdhoff/Rduino/blob/master/Examples/Schematics/LEDs_bb.png)

### [analogDemo.R](https://github.com/pdhoff/Rduino/blob/master/Examples/analogDemo.R)
``` R
library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

off <- getDpin(4)
while (!off) {
	intensity <- floor(getApin(5) / 4)
	setApin(11, intensity)
	setApin(5, intensity)
	off <- getDpin(4)
}
setDpin(11, 0)
setDpin(5, 0)
rduinoClose()
```
This example initiates a connection between R and the Arduino at 38400 baud with no parity bit, 8 data bits, and 1 stop bit. It then varies the voltage at the PWM pins connected to LEDs so that the brightness of the LED can be controlled by the potentiometer (It is divided by 4 to properly scale with the brightness levels of the LED; the potentiometer can vary between 0-1023 while the LED varies between 0-255). The while loop continues until the pushbutton is pressed, which sends "1" to R, which then causes the while loop to be exited. This examples showcases the potential of Rduino to respond to inputs from the Arduino pins.

### [dataTracking.R](https://github.com/pdhoff/Rduino/blob/master/Examples/dataTracking.R)
```R
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
```
dataTracking.R connects to the Arduino at 38400 baud with no parity bit, 8 data bits, and 1 stop bit. It then creates a plot, and reads in values from the potentiometer and adds them to the plot every 0.05 seconds. Every 25 points, it refreshes the plot, and continues to loop through this process until the pushbutton is pressed. This simple examples demonstrates the potential for Rduino to provide real time updates while gathering data through the Arduino. 

### [digitalDemo.R](https://github.com/pdhoff/Rduino/blob/master/Examples/digitalDemo.R)
```R
library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

off <- getApin(5)
while (off != 1023) {
	switch <- getDpin(4)
	setDpin(2, switch)
	setDpin(5, switch)
	setDpin(8, switch)
	setDpin(11, switch)
	off <- getApin(5)
}	
setDpin(2, 0)
setDpin(5, 0)
setDpin(8, 0)
setDpin(11, 0)
rduinoClose()
```
digitalDemo.R is similar to analogDemo.R, but with an emphasis on the usability and speed of the digital components of Rduino. After initializing a connection at 38400 baud with no parity bit, 8 data bits, and 1 stop bit, if continually reads in from the digital pin so that when the digital pin is pressed, the LEDs are lit. When the potentiometer is set to 1023, the program ends and the connection is terminated. 

### [flicker.R](https://github.com/pdhoff/Rduino/blob/master/Examples/flicker.R)
```R
library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)
delay <- 0.05

for (i in 0:9) {
	setDpin(8, 1)
	Sys.sleep(delay)
	setDpin(8,0)
	Sys.sleep(delay)
}

rduinoClose()
```
flicker.R simply tests the speed of the Rduino package. It rapidly turns the LEDs on and off, to show that communication between R and Arduino happens quickly.

### [servoDemo.R](https://github.com/pdhoff/Rduino/blob/master/Examples/servoDemo.R)
```R
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
```
servoDemo.R connects to the Arduino at 38400 baud with no parity bit, 8 data bits, and 1 stop bit, and then allows the user to control the angle of the servo by turning the potentiometer. 1.68 was calculating by experimentally determining that the maximum angle of the particular servo used for testing was 2300, and that the minimum was 575. Thus, mapping that relationship to the 0-1023 range of the potentiometer yielded a multiplier of 1.68, and 575 was added so that would be the lowest value. The program ends when the pushbutton is pressed.

### [uploadDemo.R](https://github.com/pdhoff/Rduino/blob/master/Examples/uploadDemo.R)
```R
library(Rduino)
rduinoConnect(baud=9600,mode="n,8,1",upload=TRUE)

for (i in seq(from=1,to=256,by=5)) {
	setApin(11, i)
	Sys.sleep(0.05)
}
rduinoClose()
rduinoConnect(baud=38400,mode="n,8,1",upload=TRUE)
for (i in 0:9) {
	setDpin(8,1)
	Sys.sleep(0.1)
	setDpin(8,0)
	Sys.sleep(0.1)
}
rduinoClose()
```
uploadDemo.R connects to the Arduino at two different baud rates. After the first connection, an analog pin is set at levels from 1 to 256 with steps of 5, which increases the intensity of the LED at pin 11 and then turns it off on the last step. After the second connection, pin 8 rapidly flashes on and off. The LED portion of the code proves that the connection established prior uploaded the modified Arduino sketch correctly so that R can continue to interface with the Arduino.

##### For the rest of the examples, use the wiring schematic below:

### sampleDemo.R
```R
library(Rduino)

rduinoConnect(baud=38400,mode="n,8,1")
print("Starting to read in data")
dt<-rduinoSample(0,10000)

plot(dt)
```
sampleDemo demonstrates the sampling abilities of the Rduino package. The rduisnoSample command takes two arguments, the analog pin to read in from, and the time, in milliseconds, for the Arduino to read in for.  This information is returned as a datatable with two columns: time and val. The current implementation of the sample command simply reads in values as fast as possible, so the readings may be somewhat irregular, which is why the time column is included. This example samples for 10 seconds, and then plots the readings against the time column.

### signalDemo.R
```R
library(Rduino)
rduinoConnect(baud=38400,mode="n,8,1",upload=FALSE)

onSignal(1, 0.5, 0.25)
Sys.sleep(3)
onSignal(30, 0.75, 0.1)
Sys.sleep(3)
onSignal(60, 0.25, 0.95)
Sys.sleep(3)
offSignal()

rduinoClose()
```
signalDemo.R sets a signal at pins 9 and 10 at three different frequencies (1Hz, 30Hz, and 60Hz) for three seconds each. At each frequency, the duty cycles of pins 9 and 10 are independently set.