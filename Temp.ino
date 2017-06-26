int tempPin = 10;

void setup() {
  Serial.begin(9600);
  pinMode(tempPin, INPUT);
}

void loop() {
  int temp = analogRead(tempPin);
  Serial.println(temp);
  delay(100);
}
