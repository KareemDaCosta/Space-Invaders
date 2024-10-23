# Space Invaders

This project is an implementation of the classic arcade game Space Invaders on the ESP32. The movement is controlled via the joystick (left and right), and the button is used to fire the blasters. On top of the base game, I added an overheat mechanic: if the blasters are fired too frequently, then the player has to rotate the potentiometer to reset the heat back to 0. The goal of this project was to create a hardware/software interactive version of space invaders that mimics old-school arcades.

## Project GIF
![](./media/demo.gif)

## Recreation
To recreate this project, you will need the following:
- A LilyGo TTGO T-display ESP32 device and a cable with one end for connecting to your computer (usb or usb-c) and the other end for connecting to the LilyGo (usb-c)
- A breadboard
- A pushbutton
- A potentiometer
- A thumb joystick
- 7 M-M jumper cables
- 5 M-F jumper cables

If you want to create the enclosure, you will need the following:
- 5 additional M-F jumper cables
- 2 shorter screws with corresponding nuts
- 2 longer screws with corresponding nuts
- Hot glue
- 1/8 inch plywood
- Access to a laser cutter

### Setup
1. Download the Arduino IDE [here](https://www.arduino.cc/en/software)
2. Install the TTGO T-Display driver [here](https://github.com/Xinyuan-LilyGO/TTGO-T-Display)
3. In Arduino, open up the Arduino Library Manger and install `tft_espi` by Bodmer 
    1. Go to Tools > Library Manager
    2. Search for `tft_espi` and hit the install button
4. Navigate to the library, e.g. `Documents/Arduino/libraries/tft_espi`
5. Open up the file `Arduino/libraries/TFT_eSPI/User_Setup_Select.h`
6. Comment out the line `#include <User_setup.h>`
7. Uncomment the line `include <User_Setups/Setup25_TTGO_T_Display.h>`
8. Follow the instructions [here](https://docs.espressif.com/projects/arduino-esp32/en/latest/installing.html) to install the ESP 32 library under *Installing using Arduino IDE*
9. Download Processing3 [here](https://processing.org/download)

### Recreation
1. Clone the github repository
2. Recreate the following breadboarding schematic
![](https://i.ibb.co/KbKzFrM/Fritzing-Project-2-bb.png)
3. Open the `arduino/arduino.ino` file in your Arduino IDE and upload the sketch to your ESP32. When using serial monitor, you should see the input values from the various hardware components being printed to the console.
4. Open the `Space_Invaders/Space_Invaders.pde` file in Processing
6. Press the play button in Processing to launch Space Invaders and start playing!

### Enclosure
Using the included dxf files, you can create the following enclosure
![](https://i.ibb.co/5nCnwMF/enclosure1.jpg)
![](https://i.ibb.co/ZNQzxrM/enclosure2jpg.jpg)

To create the enclosure, follow these steps:
1. Download the dxf files included in this Github repository
2. Using a laser printer, cut the following:
  1x enclosure_bottom_1.dxf
  1x enclosure_bottom_2.dxf
  2x middle_layer.dxf
  2x enclosure_top.dxf
3. Stack the two bottom enclosure on top of each other (enclosure_bottom_1 should be underneath enclosure_bottom_2)
4. Place the joystick in the joystick slot in the enclosure and insert the two shorter screws into the holes, securing the joystick to the enclosure. Secure the screws using two of the nuts
5. Place the 2x middle_layer on top of the bottom layers. The open side should be facing towards the direction in which the M-F jumper cables must be connected
6. Connect the M-F jumper cables to the joystick
7. Place the 2x enclosure_top on top of the middle layers. Secure the middle and top layers to the base layers by inserting the longer screws into the corresponding holes. Secure the screws using the other two nuts
8. Place a dab of hot glue in the button slot (the larger slot with a rail on the bottom)
9. Secure the button to the button rail (the rail should pass in between the two groups of legs)
10. Place a dab of hot glue in the corner of the potentiometer slot
11. Secure the potentiometer to the potentiometer slot using the hot glue. Make sure the potentiometer legs go out through the hole in the bottom of the potentiometer slot.
12. Wait for the hot glue to dry
13. Connect the button and potentiometer to the breadboard using the M-F jumper cables as seen in the breadboard schematic above

After completing your enclosure and connections, your breadboard-enclosure pair should look like this:
![](https://i.ibb.co/g3vYfRx/circuit1.jpg)
![](https://i.ibb.co/kgvbN2B/circuit2.jpg)
