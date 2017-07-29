# Rduino

Rduino allows the R programming language to interface with Arduino via serial connections by reading from and writing to the associated device file.

### Introduction

##### Rduino 
This project attempts to establish a method of communication between the R programming language and Arduino. The ability to read from and write to the Arduino pins was, in particular, deemed esential. This functionality was implemented by taking advantage of the R serial package's ability to read from and write to device files, and programming the Arduino to expect commands of a particular format, as described in the "Usage" section. Depending on the command received, the Arduino would then respond at the hardware level. Because these four commands form the core of general Arduino operation, this project allows the user to do things like collect data through the Arduino, perform calculations on the data in R, and then respond to the data on the Arduino, completely from R.

##### Pins
Arduinos are commonly used to interface with electronics peripherals through the use of "pins", which are electrical connections to the actual microcontroller, and can generally be seperated into digital or analog [1]. Digital pins can be set to output or read in two distinct values, HIGH or LOW, which can be thought of as 1 or 0. Analog pins can only be used to read in values, which can range between 0-1023 [2]. Analog output functionality can also be simulated on the digital pins that have PWM functionality, which stands for Pulse Width Modulation (These pins are denoted by a “~” next to the pin number on the board). Essentially, this technique allows the digital pins to appear to be steadily outputting some voltage between 0 and 5V by quickly switching the pin from LOW to HIGH, simulating analog output. This range is broken down into a scale of 0-255 [3]. The Arduino can be programmed to react to inputs from these pins, and respond to inputs by outputting through these pins.

##### Serial
Serial communication is simply the transmission of information one bit at a time. There are many different implementations of serial communication, but the Arduino employs an asynchronous version, which means that there is no previously established clock by which to anitcipate the sending and receiving of data [4]. The Arduino interfaces with PC's through a USB (Universal Serial Bus) hardware connection, which allows the PC to send and receive data from the Arduino. On Unix based systems, this hardware connection is represented as a "device file", which means that receiving data from the Arduino can be achieved by reading the device file, and sending data to the Arduino is accomplished by writing to the device file [5]. These device files are all located in the directory */dev*, and the exact file can be found in the Arduino IDE under tools > port. However, R cannot natively read from and write to device files, so the serial package must be used to allow for communication between R and Arduino.

##### Serial Package
BoardControl relies upon the serial package, which in turn relies upon R's built in Tcl/Tk engine. Tcl has the ability to interface with serial connections, so this allows R to use Tcl commands to communicate with the Arduino's serial connection. The serial connection is initialized using the "open" and "fconfigure" commands, while reading and writing is achieved with the "puts" and "gets" commands, respectively.

### How it works
The R serial package uses Tcl to allow R to read from and write to the device file. When data is written to the file, the Arduino detects that the buffer is not empty and then parses the string that was sent for the command and the pin/value. The parseArgs function splits the string that was received between commas and returns everything behind the first comma as the command. Everything after the first comma is split and parsed as an integer, which is assigned to the appropriate index of the array that is passed in as the second argument of the function. Because arrays are passed by reference in C/C++, the array that is initialized before the parseArgs command retains the values assigned to it in the function. Depending on which command was sent, the appropriate write or read function is called with the values in the array. Because write functions require two arguments, both values of the array will be used in the case of digWrite or anWrite, while only the value at index 0 will be used if digRead or anRead is called. Write commands print to the serial connection, so the data will not automatically show up in R like in the Arduino IDE Serial monitor unless a read command is explicitly performed in R.

### Usage

##### Setup
Download the files, open BoardControl.ino in the BoardControl folder, and then upload the code to the Arduino from within the Arduino IDE. In R, run the following:
```R
setwd(“path-to-directory”) 
source(“functions.R”)
rduino_connect()
```
After this, the “set_dpin”, “get_dpin”, “set_apin”, and “get_apin” commands can be uesd to control the Arduino board as desired.

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

[1]: https://www.arduino.cc/en/Reference/Board
[2]: https://www.arduino.cc/en/Tutorial/AnalogInputPins
[3]: https://www.arduino.cc/en/Tutorial/PWM
[4]: https://learn.sparkfun.com/tutorials/serial-communication
[5]: http://tldp.org/HOWTO/Text-Terminal-HOWTO-7.html