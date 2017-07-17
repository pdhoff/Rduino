#include "lib.h"

void setup() {
  pinMode(digPin1, OUTPUT);
  pinMode(digPin2, OUTPUT);
  pinMode(digPin3, OUTPUT);
  pinMode(digPin4, OUTPUT);
  pinMode(digPin5, OUTPUT);
  pinMode(digPin6, OUTPUT);
  pinMode(digPin7, OUTPUT);
  pinMode(digPin8, OUTPUT);
  pinMode(digPin9, OUTPUT);
  pinMode(digPin10, OUTPUT);
  pinMode(digPin11, OUTPUT);
  pinMode(digPin12, OUTPUT);
  pinMode(digPin13, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  // If input has been received via Serial
  if (Serial.available() > 0) {
    String input = Serial.readString();
    int arr[2];  // To be used for holding parameters
    // Parses command to be executed and adds parameters to arr
    String command = parseArgs(input, arr);
    
    // Logic handling
    if (command == "digWrite") {
      digitalWrite(arr[0], arr[1]); 
    } else if (command =="digRead") {
      int read = digitalRead(arr[0]);
      Serial.println(read);
    } else if (command == "anWrite") {
      analogWrite(arr[0], arr[1]);
    } else if (command == "anRead") {
      int read = analogRead(arr[0]);
      Serial.println(read);
    } else {
      Serial.println("Command not recognized");
    } 
  }
}

String parseArgs(String args, int arr[]) {
  String command = "";
  int counter = 0; // How many items have been parsed
  int prev = 0; // Used to split the command
  for (int curr = 0; curr < args.length(); curr++) {
    if (args[curr] == ',') {
      // On the first instance of a comma, reads the command
      if (counter == 0) {
        command = args.substring(prev,curr);
        counter++;
        prev = curr + 1;
      }
      // Otherwise, the integers accompanying the command
      // must be parsed
      else {
        String split = args.substring(prev, curr);
        arr[counter - 1] = split.toInt(); 
        counter++;
        prev = curr + 1;
      }
    }
  }
  // Because there is no comma at the end, the last
  // integer is parsed here
  arr[counter - 1] = args.substring(prev).toInt();
  return command;
}



