/*
	Example code for
	OlimexinoSTM32 + MOD-SMB380
	
	Updates the temperature with an
	interrupt routine and continuously prints
	it on the terminal
	
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


// Uncomment if you want systematic updates of the Temperature data
// with an interrupt routine

//#define USE_TIMER

#if defined(USE_TIMER)
  void init_timer();
  void Update_Temperature();
#endif

void setup(){
  
        #if defined(USE_TIMER)
         init_timer();
        #endif
    // Press a key to start the sketch...
      char ch = SerialUSB.read();
	
        SerialUSB.println("Olimexino-STM32 + MOD-SMB380 Example");
	SerialUSB.println("");
	SerialUSB.println("Current Temperature: ");
}

void loop(){
	
    
  // Print the Temperature, accurate to .5C
      #if !defined(USE_TIMER)
        smb380.updateData();
		SerialUSB.println( smb380.getTemp(), 1);
		delay(500);
      #endif
	
}

#if defined(USE_TIMER)
void init_timer(){
	// Create the Timer object; 
	// It will operate the timer (1 to 4) selected with MyTimer 
	#define MyTimer 2
	
	HardwareTimer TempTimer(MyTimer);
	
	TempTimer.pause();	     	 	   // pause the timer	
	TempTimer.setPeriod(500000);       // 500ms period
  
	// Attach the function to the timer's 1st channel
	TempTimer.attachInterrupt(1, UpdateTemperature);
  
	// Update all the properties we set above
	// And set the counter to 0
	TempTimer.refresh();
  
	//Turn the timer ON
	TempTimer.resume();
}

void UpdateTemperature(){
	
	smb380.updateData();
	SerialUSB.println( smb380.getTemp(), 1);
	
}
#endif
