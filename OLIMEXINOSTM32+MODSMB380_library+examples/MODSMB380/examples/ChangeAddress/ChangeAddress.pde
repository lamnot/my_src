/*
	Example code for
	OlimexinoSTM32 + MOD-SMB380
	
        Changes the value of a single address
        	
        If you have any questions, email
        support@olimex.com
        
        OLIMEX, JULY 2012 
		https://www.olimex.com/dev
*/

#include "MODSMB380.h"

// Definitions for the OlimexinoSTM32 UEXT SPI PORT
// If you have another board, refer to its manual
// for the correct definitions
#define CLOCK 13    // SPI Clock
#define CS    4     // Chip Select
#define MOSI  11    // Master OUT - Slave IN line
#define MISO  12    // Master IN  - Slave OUT line

MODSMB380 smb380(CLOCK, CS, MOSI, MISO);

void setup(){
   // Press a key to start the sketch...
      char ch = SerialUSB.read();
	
        SerialUSB.println("Olimexino-STM32 + MOD-SMB380 Example");
	SerialUSB.println("");
	SerialUSB.println("Write a single Address (press any key to start): ");
        
        ch = SerialUSB.read();
    
    SerialUSB.println("Customer-reserved address 1(0x12)");
    SerialUSB.print(" Before writing: ");
    SerialUSB.println(smb380.ReadOneAddr(0x12), 2);
    SerialUSB.println(" Writing value B10101010...");
    smb380.WriteOneAddr(0x12, B10101010);
    SerialUSB.print(" After writing: ");
    SerialUSB.println(smb380.ReadOneAddr(0x12), 2);
    SerialUSB.print("");
    SerialUSB.print("Done!");     
        
}

void loop()
{
  



}
        
        
