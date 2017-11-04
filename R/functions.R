utils::globalVariables(c("rduinoConnection"))

#' @import serial
NULL


#' BoardControlIno
#' 
#' Board control file for the arduino and similar devices
#' 
#' @name BoardControlIno
#' @docType data
NULL

#' Rduino connect
#' 
#' Make a serial connection to an Arduino or similar device
#'
#' @param baud baud rate
#' @param mode communication mode
#' @param upload if TRUE, upload the ino file to the device
#' @param arduino command used to run arduino as a shell command including 
#' the path
#' 
#' This function does two things - uploads a .ino file to an Arduino, and 
#' acts as a wrapper for the \code{serialConnection}
#' function of the serial package. The options for the communication mode
#' are available via the helpfile for the \code{serialConnection} command.
#'
#' @examples
#' \dontrun{
#' rduinoConnect()
#' rduinoClose()
#' }
#' 
#' @export
rduinoConnect<-function(baud=38400,mode="n,8,1",upload=TRUE,arduino=NULL)
{  
  if (version$os == "linux-gnu") 
  {
    port<-list.files(path="/dev/serial/by-id")
    port<-Sys.readlink(paste("/dev/serial/by-id/",port,sep=""))
    if(is.null(arduino)){ arduino<-"arduino" }
    uport<-port
    port<-gsub("../","",port)
  } 
  else if (grepl("darwin", version$os)) 	
  {
    port<-suppressMessages(listPorts())
    port<-port[grep("modem",port)[1]]
    if(is.null(arduino)){ arduino<-"/Applications/Arduino.app/Contents/MacOS/Arduino" }
    uport<-port 
    port<-gsub("tty","cu",port)
  } 
  else
  {
    stop("Other platforms not supported yet")
  }

  if(upload) 
  {
    bline<-grep("Serial.begin",BoardControlIno)
    BoardControlIno[bline]<-paste0("  Serial.begin(",baud,");") 
    bcfile<-tempfile(fileext = ".ino")
    bcconn<-file(bcfile)
    writeLines(BoardControlIno, bcconn)
    close(bcconn)
    system(paste0(arduino," --upload ",bcfile," --port /dev/",uport))
    system(paste0("rm ",bcfile)) 
  }
  # A bit of a hack here 
  rduinoConnection<-serialConnection(name="rdcon",port=port,
                     mode=paste(baud,mode,sep=","),buffering="none",
                     newline=1,translation="lf")
  rduinoConnection<<-rduinoConnection 

  open(rduinoConnection) 
  Sys.sleep(3)  # Allow time for the connection to initiate
} 



#' Set digital pin
#'
#' Set a digital pin to on or off
#'
#' @param pin the number of the pin to set (integer)
#' @param value the value to which to set the pin (binary)
#'
#' @examples
#' \dontrun{
#' rduinoConnect()
#' # flash LED rapidly
#' for (i in 0:9) 
#' {
#'   setDpin(8,1)
#'   Sys.sleep(0.05)
#'   setDpin(8,0)
#'   Sys.sleep(0.05)
#' }
#' rduinoClose()
#' }
#' 
#' @export
setDpin<-function(pin,value)   
{
  write.serialConnection(rduinoConnection,paste("digWrite",pin,value,sep=","))
}


#' Get digital pin
#'
#' Get the value of a digital pin 
#'
#' @param pin the number of the pin to get (integer)
#'
#' @return the binary value of the pin.
#'
#' @examples
#' \dontrun{
#' rduinoConnect()
#' # LED remains on until button is pressed
#' setDpin(5,1)
#' isPressed<-getDpin(4)
#' while (!isPressed){ isPressed<-getDpin(4) }
#' setDpin(5,0)
#' rduinoClose()
#' }
#' 
#' @export
getDpin<-function(pin)
{ 
  write.serialConnection(rduinoConnection,paste("digRead",pin,sep=","))      
  val<-NA 
  while(is.na(val))
  {
    tmp<-read.serialConnection(rduinoConnection)
    val<-as.numeric(gsub('\\n','',tmp))  
  }
val
}


#' Set analog pin
#'
#' Set a analog pin to on or off
#'
#' @param pin the number of the pin to set (integer)
#' @param value the value to which to set the pin (real)
#'
#' @examples
#' \dontrun{
#' rduinoConnect()
#' # gradually increase intensity of LED
#' for (i in seq(1,256,by=5)) 
#' {
#'   setApin(11,i)
#'   Sys.sleep(0.05)
#' }
#' rduinoClose()
#' }
#' 
#' @export
setApin<-function(pin,value)
{
  write.serialConnection(rduinoConnection,paste("anWrite",pin,value,sep=","))
}


#' Get analog pin
#'
#' Get the value of an analog pin
#'
#' @param pin the number of the pin to get (integer)
#'
#' @return the value of the pin.
#'
#' @examples
#' \dontrun{
#' rduinoConnect()
#' # set position of servo to position of potentiometer
#' off<-getDpin(4)
#' while (!off) 
#' {
#'   angle<-getApin(5)
#'   angle<- 1.68 * angle + 575
#'   setServo(9,angle)
#'   off<-getDpin(4)
#' }
#' offServo()
#' 
#' rduinoClose()
#' }
#'
#' @export
getApin<-function(pin)
{
  write.serialConnection(rduinoConnection,paste("anRead,",pin,sep=""))
  val<-NA
  while(is.na(val))
  {
    tmp<-read.serialConnection(rduinoConnection)
    val<-as.numeric(gsub('\\n','',tmp))
  }
  val
}



#' Set servo
#'
#' Activate a servo and set a value
#'
#' @param pin the number of the pin connected to the servo
#' @param value value to set for the servo
#'
#' @examples
#' \dontrun{
#' rduinoConnect()
#' # set position of servo to position of potentiometer
#' off<-getDpin(4)
#' while (!off) 
#' {
#'   angle<-getApin(5)
#'   angle<- 1.68 * angle + 575
#'   setServo(9,angle)
#'   off<-getDpin(4)
#' }
#' offServo()
#'  
#' rduinoClose()
#' }
#'
#' @export
onServo<-function(pin,value)
{
  write.serialConnection(rduinoConnection,paste("onServo",pin,value,sep=","))
}

#' Off servo
#'
#' deactivate a servo
#'
#' @export
offServo<-function()
{
  write.serialConnection(rduinoConnection,"offServo")
}



#' Rduino disconnect
#'
#' Disconnect a previously connected Arduino or similar device
#'
#' @export
rduinoClose <- function() 
{
  close(rduinoConnection)
}


