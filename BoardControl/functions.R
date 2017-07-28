library(serial)

rduino_connect<-function()
{
  port<-suppressMessages(listPorts())
  port<-port[grep("modem",port)[1]]
  port<-gsub("tty","cu",port)

  rduino_connection<<-serialConnection(name="rdcon",port=port,
	mode="19200,n,8,1",buffering="none",newline=1,translation="lf")

  open(rduino_connection) 
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
}

get_apin<-function(pin)
{
  write.serialConnection(rduino_connection,paste("anRead",pin,sep=",")) 
  val<-NA
  while(is.na(val))
  {
    tmp<-read.serialConnection(rduino_connection) 
   	val<-as.numeric(gsub('\\n','',tmp))
  } 
  val 
}

rduino_close <- function() 
{
	close(rduino_connection)
}






