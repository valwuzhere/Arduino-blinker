# Arduino-blinker

This is an assignment done for my computer architecture class for the University of Victoria.

It is written in AVR Assembly Language for Arduino 2560 boards.

This program takes a starting number between 0x00 and 0XFF (inclusive). It then stores the number in DSEG and then displays it on the arduino (making sure to use a mask in order to have the right bits displayed on the machine). The chosen number is the decremented and stored in the next, consecutive location in DSEG.


Here is the psuedo code given in the instructions in C:



number = /* choose a number in (0x00, 0xFF] */ ;

count = 0;

while (number > 0) {

dest[count++] = number;

  Output number on LEDs 
  
  delay 0.5 second 
  
 number --;
