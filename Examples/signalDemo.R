# Example showcasing signal functionality of Rduino package
# wiring: see "Signal" schematics in Examples/Schematics

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
