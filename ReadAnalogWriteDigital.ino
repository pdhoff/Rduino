int readPin = 0;
int ledPin = 7;
int read = 0;
char input;
  
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
}
  
void loop() {
  // put your main code here, to run repeatedly:
  read = analogRead(readPin);
  Serial.println(read);
  delay(100);
  if (Serial.available() > 0) {
    input = Serial.read();
    if (input == 'a') {
      digitalWrite(ledPin, HIGH);
      delay(100);
      digitalWrite(ledPin, LOW);
    }
  }
}
