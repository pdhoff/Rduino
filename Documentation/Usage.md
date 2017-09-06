# Usage

##### Setup
**Linux Only:** Follow the instructions at [this website] [6] to allow access to the device files associated with the Arduino.
Download the files, open BoardControl.ino in the BoardControl folder, and then upload the code to the Arduino from within the Arduino IDE. In R, run the following:
```R
setwd(“path-to-directory”) 
source(“functions.R”)
rduino_connect(“baudMode”)
```
The baudMode argument is a string that describes the serial connection in the form of *baudRate,parityBit,dataBits,stopBits*. The mode set in R should reflect the mode of the serial connection in the Arduino code as defined in the Serial.begin() function. baudRate should be an integer representing the baudRate of the serial connection. The parityBit can be set to *n*,*o*,*e*,*m*, or *s*, which stand for none, odd, even, mark, or space, respectively. However, the Arduino only supports none, odd, and even parity bit settings. The dataBits should be an integer from 5 to 8, and stopBits should be 1 or 2. It should be noted that although most of the arguments are integers, the baudMode argument is actually a single string that seperates the individual arguments with commas ("19200,n,8,1"). After this, the “set_dpin”, “get_dpin”, “set_apin”, and “get_apin” commands can be used to control the Arduino board as desired.

##### In R
There are four main commands that can be issed via writing to the serial connection:
1. set_dpin(pin, value)
2. get_dpin(pin)
3. set_apin(pin, value)
4. get_apin(pin)

set_dpin identifies a digital pin and then outputs either HIGH or LOW, depending on whether value is 1 or 0.
```R 
# In R using the serial package
set_dpin(2, 1)     # sets digital pin 2 to HIGH
```
get_dpin identifies a digital pin and reads in from that pin, writing 0 or 1 to the serial connection.
```R
get_dpin(4)        # reads in from digital pin 4 and returns results
```
set_apin identifies a digital pin (**must have pwm functionality to work properly**) and outputs a range of voltages represented by 0-255, which is the scale on which analogWrite is based on.
```R
set_apin(11, 128)  # writes a value of 128 to pin 11
```
get_apin identifies an analog pin and reads in from that pin, writing a value between 0-1023 to the serial connection, which is the scale on which analogRead is based on.
```R
get_apin(5)        # reads in from analog pin 5 and returns results
```
After finishing work with Rduino, run the following to close the serial connection:
```R
rduino_close()    
```

[6]: https://www.arduino.cc/en/Guide/Linux