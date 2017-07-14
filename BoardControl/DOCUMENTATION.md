# The Board Library

The Board class creates an abstraction of an Arduino so that other languages can interface with it by reading from and writing to the device file associated with the Arduino.

## Usage

There are four commands that can be issed via writing to the serial connection:
1. “digWrite,pin,value”
2. “digRead,pin”
3. “anWrite,pin,value”
4. “anRead,pin”

digWrite identifies a digital pin and then outputs either HIGH or LOW, depending on whether value is 1 or 0.
```R 
# In R using the serial package
con <- serialConnection(name, port, mode, buffering=“none”, newline=0)
open(con)
write.serialConnection(con, "digWrite,2,1")    # sets digital pin 2 to HIGH
```
digRead identifies a digital pin and reads in from that pin, writing 0 or 1 to the serial connection.
```R
write.serialConnection(con, "digRead,4")       # reads in from digital pin 4
read.serialConnection(con)                     # prints results to console
```
anWrite identifies a digital pin (**must have pwm functionality to work properly**) and outputs a range of voltages represented by 0-255, which is the scale on which analogWrite is based on.
```R
write.serialConnection(con "anWrite,11,128")   # writes a value of 128 to pin 11
```
anRead identifies an analog pin and reads in from that pin, writing a value between 0-1023 to the serial connection, which is the scale on which analogRead is based on.
```R
write.serialConnection(con, "anRead,5")        # reads in from analog pin 5
read.serialConnection(con)                     # prints results to console
```
## How it works 

The constructor sets the baud rate for the serial connection; this is the only part of the Arduino code that should ever require the user’s intervention. The call to uno.communicate() begins the serial connection and waits until it receives a command through the serial connection. The command is then parsed, and if it is valid, the appropriate method is called, ultimately reading from or writing to the Arduino.