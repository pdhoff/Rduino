int potentioPin = 0; // Analog input pin
int ledPin = 7;
  
void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);   // potentiometer input pin
  digitalWrite(ledPin, LOW); // Digital output LED
}
  
void loop() {
  int read = analogRead(potentioPin);
  Serial.println(read);

  if (Serial.available() > 0) {
    char input = Serial.read();
    if (input == 'a') {
      digitalWrite(ledPin, HIGH);
      delay(100);
      digitalWrite(ledPin, LOW);
    }
  }
  delay(100);
}
