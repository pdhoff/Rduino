# Example showcasing sampling functionality of Rduino package
# wiring: see "SD card" schematic in /Examples/Schematics

library(Rduino)

rduinoConnect(baud=38400,mode="n,8,1")
print("Starting to read in data")
dt<-rduinoSample(0,10000)

plot(dt)
