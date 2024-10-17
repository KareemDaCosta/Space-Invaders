/*
  LILYGO LED & Pushbutton Example
  Pushbutton on 2
  LED on 15 with 220Ω resistor
*/

#define BUTTON_PIN 13
#define POTENTIOMETER_PIN 2
int xyzPins[] = {39, 32, 33};   //x, y, z(switch) pins
void setup() {
  Serial.begin(9600);
  pinMode(BUTTON_PIN, INPUT_PULLUP); // use internal pullup resistor
  pinMode(xyzPins[2], INPUT_PULLUP);  // pullup resistor for switch
}

void loop() {
  int buttonState = digitalRead(BUTTON_PIN);
  int potentiometerState = analogRead(POTENTIOMETER_PIN);
  int xJoystick = analogRead(xyzPins[0]);
  int yJoystick = analogRead(xyzPins[1]);
  int zJoystick = digitalRead(xyzPins[2]);

  /* Formatted print (to test values are being input properly)
  Serial.print("Button: ");
  Serial.println(buttonState);

  Serial.print("Potentiometer: ");
  Serial.println(potentiometerState);

  Serial.print("Joystick: ");
  Serial.printf("%d,%d,%d", xVal, yVal, zVal);
  
  */

  //Unformatted print (to be read by processing)
  Serial.printf("%d,%d,%d,%d,%d", buttonState, potentiometerState, xJoystick, yJoystick, zJoystick);
  Serial.println();
  delay(1000);
}