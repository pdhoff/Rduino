# Rduino - A Microcontroller Interface

Rduino provides functions for connecting to and interfacing with an 'Arduino' or similar device. Functionality includes uploading of sketches, setting and reading digital and analog pins, and rudimentary servo control.

## Getting Started

### Prerequisites

The Rduino package depends on the serial package, which can be downloaded and installed from CRAN.

### Installing

**Linux Only:** Follow the instructions at [this website] [1] to allow access to the device files associated with the Arduino.
In R, run the following:
```R
> install.packages("Rduino")
> library(Rduino)
> rduinoConnect(baud=38400,mode="n,8,1",upload=TRUE,arduino="path-to-arduino-executable")
```
If R says that the default library path is not writable after the first command, simply create a personal library as suggested by the prompt and then proceed as normal. The "arduino" parameter in rduinoConnect can be ommited on macOS systems, as the Arduino exeecutable should be in the same location for all macOS systems, but Linux systems need to specify where the Arduino executable is, as this can vary between systems. On Linux, The Arduino executable should be located in the same directory as the Arduino installer.

If Rduino is installed properly, the following code should return 0 on an Arduino with disconnected pins.
```R
> getDpin(2)
[1] 0
```

## License

This project is licensed under the GNU GPL-3.0 License - see the [LICENSE.md](LICENSE.md) file for details

[1]: https://www.arduino.cc/en/Guide/Linux
