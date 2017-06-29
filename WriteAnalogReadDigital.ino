int ledPin = 5;
int buttonPin = 2;

void setup() {
  Serial.begin(19200);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT);
}

void loop() {
  if (digitalRead(buttonPin))
    Serial.println("Not pushed");
  else
    Serial.println("pushed");

  if (Serial.available()) {
    int read = Serial.parseInt();
    //Serial.println(read);
    analogWrite(ledPin, read);
  }
  delay(100);
}
