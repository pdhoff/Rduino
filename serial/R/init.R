#' Sets up the interface parameters.
#' 
#' This is the constructor of the serial interface connection.
#' 
#' Linux and Windows behave a little bit different, when utilizing serial com ports. Still, 
#' by providing the name (like 'COM1' or 'ttyS1') and the appropriate settings, the serial 
#' interface can be used. Even virtual com ports, like the FTDI usb uart chips will work,
#' as long they map to a standard serial interface in the system.
#' 
#' Since the \code{serial} package relies on R's built in Tcl/Tk engine the configuration
#' of the serial port takes place in the Tcl framework. This becomes important 
#' when different buffer sizes are set. For Windows the Tcl "-sysbuffer" parameter 
#' is invoked, whereas on unix-like systems "-buffersize" does the job.
#' 
#' 
#' @param name  optional name for the connection
#' @param port  comport name; also virtual com's are 
#'              supported; maybe USB schould work too
#' @param mode  communication mode '\code{<BAUD>, <PARITY>, <DATABITS>, <STOPBITS>}'
#' \describe{
#'    \item{\code{BAUD}}{sets the baud rate (bits per second)}
#'    \item{\code{PARITY}}{\emph{n, o, e, m, s} stands for 'none', 'odd', 'even', 'mark' and 'space'}
#'    \item{\code{DATABITS}}{integer number of data bits. The value can range from 5 to 8}
#'    \item{\code{STOPBITS}}{integer number of stop bits. This can be '1' or '2'}
#'        }       
#'              
#' @param buffering '\code{none}', for RS232 serial interface, other modes don't work in this case
#' @param newline \code{<BOOL>}, whether a new transmission starts with a newline or not.
#'                \describe{
#'                  \item{\code{TRUE} or 1}{send newline-char according to \code{<translation>} befor transmitting}
#'                  \item{\code{FALSE} or 0}{no newline}
#'                          }
#' @param handshake determines the type of handshaking the communication
#'                  \describe{
#'                    \item{'\code{none}'}{no handshake is done}
#'                    \item{'\code{rtscts}'}{hardware handshake is enabled}
#'                    \item{'\code{xonxoff}'}{software handshake via extra characters is enabled}
#'                    }
#' 
#' @param eof \code{<CHAR>}, termination char of the datastream. It only makes sense
#'        if \code{<translation>} is 'binary' and the stream is a file
#' @param translation  each transmitted string is terminated by the transmission
#'       character. This could be 'lf', 'cr', 'crlf', 'binary'
#' @param buffersize defines the system buffersize. The default value is 4096 bytes (4kB
#'                   ).
#' @return An object of the class '\code{serialConnection}' is returned
#' @export
serialConnection<-function(name, port='com1', mode='115200,n,8,1', buffering='none', newline=0,eof='',translation='lf',handshake='none',buffersize = 4096)
{
  obj<-list()
  obj$name <- name
  obj$port <- port
  obj$mode <- mode
  obj$buffering <- buffering
  obj$newline <- newline
  obj$eof <- eof
  obj$translation <- translation
  obj$handshake <- handshake
  obj$buffersize <- buffersize
  class(obj) <- 'serialConnection'
  return(obj)
}

#' Function to initialize an serial interface.
#' 
#' This function initializes the serial interface and opens it for later usage. 
#' 
#' @method open serialConnection
#' 
#' @param con serial connection
#' @param ... is ignored
#' @seealso \code{\link{serialConnection}}
#' @import tcltk
#' @export
open.serialConnection<-function(con, ...)
{
  if(isOpen(con))
  {
    warning(paste(con$port,'is already open'))
    invisible(return('FAIL!'))
  }
  ## set platform depended path
  os_path <- switch(.Platform$OS.type
                    ,windows = '//./'
                    ,unix = '/dev/'
                    )
  buffer_string <- switch(.Platform$OS.type
                          ,windows = ' -sysbuffer'
                          ,unix = ' -buffersize'
  )
  buffer_string <- paste(buffer_string,con$buffersize)
  
  ## set connection and variables
  tryCatch( .Tcl( paste('set ::sdev_',con$port,' [open {',os_path,con$port,'} r+]',sep=''))
            ,error = function(e) stop(simpleError(e$message))
  )
  ## setup configuration
  eof <- paste(' -eofchar ', con$eof,sep='')
  if(con$eof=='') eof <- ''
  .Tcl( paste('fconfigure ${sdev_',con$port,'}'
              ,' -mode ', con$mode
              ,' -buffering ',con$buffering
              ,' -blocking 0'
              ,eof
              ,' -translation ',con$translation
              ,' -handshake ',con$handshake
              ,buffer_string
              ,sep=''
              )
        )
  invisible('DONE')
  ## it seems that -eofchar doesn't work
  ## 'buffering none' is recommended, other setings doesn't work to send 
}

#' Function to close an serial interface.
#' 
#' This function closes the corresponding connection.
#' 
#' @method close serialConnection
#' 
#' @param con serial connection
#' @param ... is ignored
#' 
#' @seealso \code{\link{serialConnection}}
#' @import tcltk
#' @export
close.serialConnection<-function(con, ...)
{
  if(isOpen(con))
  {
    tryCatch( .Tcl( paste( 'close ${sdev_', con$port,'}', sep = '' ) )
              ,error = function(e) stop(simpleError(e$message))
    )
    .Tcl( paste( 'unset sdev_', con$port, sep = '' ) )
  }
  invisible('DONE')
}

#' Generic function for isOpen
#' 
#' @param con connection Object
#' @param ... not used
#' 
#' @export
isOpen <- function(con, ...) UseMethod('isOpen')

#' Default function from base-package
#' 
#' @param con connection object
#' @param rw defines the mode of operation
#' 
#' @seealso \code{\link[base]{isOpen}}
isOpen.default <- function(con, rw='')
{
  base::isOpen(con,rw)
}
#' Tests whether the connection is open or not
#' 
#' @param con connection of the class \code{serialConnection}
#' @param ... not used
#' 
#' @return returns \code{{F, T}} for 'not open' and 'is open'
#' @export
isOpen.serialConnection <-function(con,...)
{
  e <- 0 # assume that the connection is closed
  
  # read out variable list
  s <- c( tclvalue(.Tcl('info globals')),
          tclvalue(.Tcl('info locals'))
  )
  vars <- unlist(strsplit(s,' '))
  # only if the corresponding variable exists, there is a chance to test
  #if(tclvalue( .Tcl( paste('info exists sdev_',con$port, sep=''))) == 1) 
  if(paste('sdev_',con$port,sep='') %in% vars)
  {
    # get the names of all open channels (connections)
    chan_names <- tclvalue( .Tcl('file channels'))
    
    # get the tcl internal name of the connection
    con_name <- tclvalue(paste('sdev_',con$port, sep='')) 
    
    # test if con_name is in the list of channels
    e <- con_name %in% strsplit(chan_names,' ')[[1]]
  }
  
  return(ifelse(e == 1,T,F))
}