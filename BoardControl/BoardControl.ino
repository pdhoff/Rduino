#include<Servo.h>

Servo servo;

void setup() {
  pinMode(0, OUTPUT);
  pinMode(1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  // Otherwise strange bits are written to serial
  delay(500);
  Serial.begin(38400);
  // initialize pulse
  Serial.println(""); // allow first read
}

void loop() {
  // If input has been received via Serial
  if (Serial.available() > 0) {
    String input = Serial.readStringUntil('\n');  
    int arr[2];  // To be used for holding parameters
    // Parses command to be executed and adds parameters to arr
    String command = parseArgs(input, arr);
    
    // Logic handling
    if (command.equals("digWrite")) {
      digitalWrite(arr[0], arr[1]); 
    } else if (command.equals("digRead")) {
      int read = digitalRead(arr[0]);
      Serial.println(read);
    } else if (command.equals("anWrite")) {
      analogWrite(arr[0], arr[1]);
    } else if (command.equals("anRead")) {
      int read = analogRead(arr[0]);
      Serial.println(read);
    } else if (command.equals("onServo")) {
      servo.attach(arr[0]);
      servo.write(arr[1]);
    } else if (command.equals("offServo")) {
      servo.detach();
    } else {
      Serial.println(input);
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



