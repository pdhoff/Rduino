if(getRversion() >= "2.15.1")  utils::globalVariables("rduino_connection")

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
#' 
#' This function is basically a wrapper for the \code{serialConnection}
#' function of the serial package. The options for the communication model
#' are available via the helpfile for that command. 
#'
#' @export
rduino_connect<-function(baud=38400,mode="n,8,1",upload=TRUE)
{  
  if (version$os == "linux-gnu") 
  {
    port<-list.files(path="/dev/serial/by-id")
    port<-Sys.readlink(paste("/dev/serial/by-id/",port,sep=""))
    arduino<-"arduino" 
    uport<-port
    port<-gsub("../","",port)
  } 
  else if (grepl("darwin", version$os)) 	
  {
    port<-suppressMessages(listPorts())
    port<-port[grep("modem",port)[1]]
    arduino<-"/Applications/Arduino.app/Contents/MacOS/Arduino" 
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

  rduino_connection<<-serialConnection(name="rdcon",port=port,
                      mode=paste(baud,mode,sep=","),buffering="none",
                      newline=1,translation="lf")

  open(rduino_connection) 
  Sys.sleep(3)  # Allow time for the connection to initiate
} 



#' Set digital pin
#'
#' Set a digital pin to on or off
#'
#' @param pin the number of the pin to set (integer)
#' @param value the value to which to set the pin (binary)
#'
#' @export
set_dpin<-function(pin,value)   
{
  write.serialConnection(rduino_connection,paste("digWrite",pin,value,sep=","))
}


#' Get digital pin
#'
#' Get the value of a digital pin 
#'
#' @param pin the number of the pin to get (integer)
#'
#' @return the binary value of the pin.
#'
#' @export
get_dpin<-function(pin)
{ 
  write.serialConnection(rduino_connection,paste("digRead",pin,sep=","))      
  val<-NA 
  while(is.na(val))
  {
    tmp<-read.serialConnection(rduino_connection)
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
#' @export
set_apin<-function(pin,value)
{
  write.serialConnection(rduino_connection,paste("anWrite",pin,value,sep=","))
}


#' Get analog pin
#'
#' Get the value of an analog pin
#'
#' @param pin the number of the pin to get (integer)
#'
#' @return the value of the pin.
#'
#' @export
get_apin<-function(pin)
{
  write.serialConnection(rduino_connection,paste("anRead,",pin,sep=""))
  val<-NA
  while(is.na(val))
  {
    tmp<-read.serialConnection(rduino_connection)
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
#' @export
set_servo<-function(pin,value)
{
  write.serialConnection(rduino_connection,paste("onServo",pin,value,sep=","))
}

#' Off servo
#'
#' deactivate a servo
#'
#' @export
off_servo<-function()
{
  write.serialConnection(rduino_connection,"offServo")
}



#' Rduino disconnect
#'
#' Disconnect a previously connected Arduino or similar device
#'
#' @export
rduino_close <- function() 
{
  close(rduino_connection)
}


