/*
 Serial Button Example
 Do something when the ESP32 L and R buttons are pressed
 */

import processing.serial.*;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port

void setup()
{
  size(500, 500);
  printArray(Serial.list());
  String portName = Serial.list()[2];
  println(portName);
  myPort = new Serial(this, portName, 9600); // ensure baudrate is consistent with arduino sketch
}

void draw()
{
  background(0);
  textSize(16);
  
  if (myPort.available() > 0) {  
    val = myPort.readStringUntil('\n').trim();  
  }
  if (val != null){
    int[] inputs = int(val.split(","));
    int buttonState = inputs[0];
    int potentiometerState = inputs[1]; 
    int joystickX = inputs[2];
    int joystickY = inputs[3];
    int joystickZ = inputs[4];
    
    println("Button: %d", buttonState);
    println("Potentiometer: %d", potentiometerState);
    println("Joystick: %d, %d, %d", joystickX, joystickY, joystickZ);
    textAlign(CENTER);
    text(val, width/2, height/2);
  }    
}
