#ifndef Board_h
#define Board_h
#include "Arduino.h"

class Board {
  public: 
    Board(int baud);
    void communicate();
  private:
    int baudRate;
    String parseArgs(String args, int arr[]);
    void digWrite(int pin, int value);
    int digRead(int pin);
    void anWrite(int pin, int value);
    int anRead(int pin);
};

#endif
