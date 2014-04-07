/*
  MOD-MAG example.
  
  Reads the raw data from the
  module's registers.
  
  Values may need calibrating. Please
  refer to the MAG3110 Reference manual
  for detailed information.
  
  If you have any questions, email
  support@olimex.com
  
  https://www.olimex.com
  OLIMEX, 2013
*/

//Definitions for the OLIMEXINO-STM32
//For detailed information on this product,
//visit https://www.olimex.com
#define SDA 30
#define SCL 29

#include "MODMAG.h"

// Declare the MOD-MAG device
// The MOD-MAG has a single MAG3110 chip
// The board connects to the MOD via I2C
// Refer to MODMAG.h or the MAG3110 reference
// manual for detailed information on the protocol used.
MODMAG modmag(SDA, SCL);

/* Utilities */
   //WAIT Macro 
     #define WAIT wait_123()
     char ch123;
     void wait_123(){ ch123 = SerialUSB.read(); }
   //END Wait Macro
/* Utilities */
     
void print_data();

void setup(){
// Press any key to start 
  WAIT;
  SerialUSB.println("MOD-MAG Demo; press any key to continue...");
  WAIT;
}

void loop(){
  
  print_data();      
  SerialUSB.println("");
  WAIT; //Press any key to read again
  
}

void print_data(){
  unsigned char aflag;
  SerialUSB.print("CHIP ID: ");
  SerialUSB.println(modmag.ReadSingleIadr(0x07, aflag), BIN);
  
  //Update values to current data
  //The MODMAG.h library uses the "Trigger Measurement" mode
  //Refer to the MAG3110 manual for detailed information
  //pages 12 and 17
  modmag.updateData();
  
  SerialUSB.println("Raw Data:");
  SerialUSB.print("X: "); SerialUSB.println(modmag.getX(), DEC); 
  SerialUSB.print("Y: "); SerialUSB.println(modmag.getY(), DEC);
  SerialUSB.print("Z: "); SerialUSB.println(modmag.getZ(), DEC); 
  SerialUSB.print("Temperature: "); SerialUSB.println(modmag.getTemperature(), DEC);
}
