/*
	Example code for
	OlimexinoSTM32 + MOD-SMB380
	
        Live raw acceleration data on the terminal
        	
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

char ESC = 27;

void init_timer();
void ShowData();

void setup(){
  
    // Press a key to start the sketch...
      char ch = SerialUSB.read();
	
    SerialUSB.println("Olimexino-STM32 + MOD-SMB380 Example");
	SerialUSB.println("");
	SerialUSB.println("Live data (press any key to start): ");
        
    ch = SerialUSB.read();
        
    init_timer();

}

void loop(){}

void init_timer(){
	// Create the Timer object; 
	// It will operate the timer (1 to 4) selected with MyTimer 
	#define MyTimer 2	
	HardwareTimer DataTimer(MyTimer);

	DataTimer.pause();	     // pause the timer	
	DataTimer.setPeriod(500000);  // 500ms period
  
	// Attach the function to the timer's 1st channel
	DataTimer.attachInterrupt(1, ShowData);
  
	// Update all the properties we set above
	// And set the counter to 0
	DataTimer.refresh();
  
	//Turn the timer ON
	DataTimer.resume();
}

void ShowData(){
      
      smb380.updateData();
      
      SerialUSB.print(ESC);
      SerialUSB.print("[2J");
      SerialUSB.print(ESC);
      SerialUSB.print("[H");
      
      SerialUSB.print("X : ");
      SerialUSB.println(smb380.getAccX(), 2);
      SerialUSB.print("Y : ");
      SerialUSB.println(smb380.getAccY(), 2);
      SerialUSB.print("Z : ");
      SerialUSB.println(smb380.getAccZ(), 2);
     
}
