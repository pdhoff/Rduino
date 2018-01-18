# Usage

### Setup
**Linux Only:** Follow the instructions at [this website] [6] to allow access to the device files associated with the Arduino.
Download the files, open BoardControl.ino in the BoardControl folder, and then upload the code to the Arduino from within the Arduino IDE. In R, run the following:
```R
> install.packages("Rduino")
> library(Rduino)
> rduinoConnect(baud=baudrate, mode="serial-mode", upload=FALSE, arduino="path-to-arduino-executable")
```
The baud parameter is an integer that describes the rate at which serial communication happens. This number should agree with the parameter used in Serial.begin() in the Arduino sketch if the upload parameter is FALSE.
The mode parameter is a string that describes the serial connection in the form of *parityBit,dataBits,stopBits*. The mode set in R should reflect the mode of the serial connection in the Arduino code as defined in the Serial.begin() function. The parityBit can be set to *n*,*o*,*e*,*m*, or *s*, which stand for none, odd, even, mark, or space, respectively. However, the Arduino only supports none, odd, and even parity bit settings. The dataBits should be an integer from 5 to 8, and stopBits should be 1 or 2. It should be noted that although most of the arguments are integers, the mode argument is actually a single string that seperates the individual arguments with commas ("n,8,1"). The upload parameter allows Rduino to edit the Arduino sketch so that a new baud rate can be established. If set to TRUE, R will load the Arduino sketch as an RData object, modify the arguments in Serial.begin(), and then use the command line executable included with the Arduino IDE to upload the modified sketch to the Arduino. Lastly, the arduino parameter allows the user to specify the path to the command line executable, which can vary on Linux. However, on macOS, the executable should always be in the default location, so this should be unused. The rduinoConnect function has a built-in delay for 3 seconds to allow the connection to properly initialize before attempting to read or write from it. After this, the other included functions can be used to control the Arduino board as desired.

### In R
There are eight main commands that can be issed via writing to the serial connection:
1. setDpin(pin, value)
2. getDpin(pin)
3. setApin(pin, value)
4. getApin(pin)
5. onServo(pin, value)
6. offServo()
7. onSignal(freq, dutyCycle1, dutyCycle2)
8. offSignal()

setDpin identifies a digital pin and then outputs either HIGH or LOW, depending on whether value is 1 or 0.
```R 
# In R using the serial package
> setDpin(2, 1)        # sets digital pin 2 to HIGH
```
getDpin identifies a digital pin and reads in from that pin, writing 0 or 1 to the serial connection.
```R
> getDpin(4)           # reads in from digital pin 4 and returns results
```
setApin identifies a digital pin (**must have pwm functionality to work properly**) and outputs a range of voltages represented by 0-255, which is the scale on which analogWrite is based on.
```R
> setApin(11, 128)     # writes a value of 128 to pin 11
```
getApin identifies an analog pin and reads in from that pin, writing a value between 0-1023 to the serial connection, which is the scale on which analogRead is based on.
```R
> getApin(5)           # reads in from analog pin 5 and returns results
```
onServo attaches a servo to the specified pin, and then sends a consistent signal to that pin as determined by the user. On normal servos, this will set the angle of the servo, with 1500 usually representing the neutral angle. On continuous rotation servos, this will set the angular velocity of the servo, with 1500 usually representing an angular velocity of 0. The use of the servo library in the Arduino sketch means that setApin will not work while the servo is being used.
```R
> onServo(9, 1700)     # attaches a servo to digital pin 9 and sets the angle or angular velocity
```
offServo detaches all servos, allowing normal operation of analog pins. Servos also require high levels of current, so this will alleviate the effects of low current to other circuit elements.
```R
> offServo()           # detaches all servos
```
onSignal generates a square wave with the frequency and duty cycle as specified by manipulating the registers that control PWM. Due to the limitations of using a 16-bit timer, the range of possible frequencies is 1Hz-31.25kHz.The second parameter describes the percentage of time that the signal should spend on HIGH on pin 9, and is given by a value between 0-1, while the third parameter is the duty cycle for pin 10, and is also given by a value between 0-1. 
```R
> onSignal(2, 0.5, 0.25)    # generates a square wave with frequency of 2Hz and a duty cycles
                          # of 0.5 and 0.25 on pins 9 and 10, respectively.
```
offSignal resets the PWM registers to the defaults so that setApin works properly on the affected pins.
```R
> offSignal()
```
After finishing work with Rduino, run the following to close the serial connection:
```R
> rduinoClose()    
```

[6]: https://www.arduino.cc/en/Guide/Linux
