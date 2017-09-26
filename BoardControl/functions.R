library(serial)

rduino_connect<-function(baudMode)
{
	port <- ""
	if (version$os == "linux-gnu") 
	{
		port<-list.files(path="/dev/serial/by-id")
		port<-Sys.readlink(paste("/dev/serial/by-id/",port,sep=""))
		port<-gsub("../","",port)
	}
	else if (grepl("darwin", version$os)) 	
	{
  		port<-suppressMessages(listPorts())
  		port<-port[grep("modem",port)[1]]
  		port<-gsub("tty","cu",port)
	} 
	else
	{
		stop("Other platforms not supported yet")
	}

  	rduino_connection<<-serialConnection(name="rdcon",port=port,
	  mode=baudMode,buffering="none",newline=1,translation="lf")

  	open(rduino_connection) 
	Sys.sleep(3)  # Allow time for the connection to initiate
} 

set_dpin<-function(pin,value)   
{
	write.serialConnection(rduino_connection,paste("digWrite",pin,value,sep=","))
}

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

set_apin<-function(pin,value)
{
  	write.serialConnection(rduino_connection,paste("anWrite",pin,value,sep=","))
	paste("anWrite",pin,value,sep=",")
}

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

start_pulse<-function(pin,value) 
{
	write.serialConnection(rduino_connection,paste("onPulse",pin,value,sep=","))
}

stop_pulse<-function() 
{
	write.serialConnection(rduino_connection,paste("offPulse"))
}

rduino_close <- function() 
{
	close(rduino_connection)
}





