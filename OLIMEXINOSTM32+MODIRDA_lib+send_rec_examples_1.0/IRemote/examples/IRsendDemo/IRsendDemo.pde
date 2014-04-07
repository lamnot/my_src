/*
 * IRremote: IRsendDemo - demonstrates sending IR codes with IRsend
 * An IR LED must be connected to Arduino PWM pin 3.
 * Version 0.1 July, 2009
 * Copyright 2009 Ken Shirriff
 * http://arcfn.com
 *
 *
 *  Modified by OLIMEX to work with the OLIMEXINO-STM32
 *  IRemote Maple project downloaded from Github on July 24, 2012
 */
 */
 
#include <IRremote.h>

//WAIT Macro 
#define WAIT wait_123()
	char ch123;
	void wait_123() __attribute ((noinline));
	void wait_123(){ ch123 = SerialUSB.read(); }
//END Wait Macro

// Sends a single line of text to the terminal via CDC
	void message(char * m){ SerialUSB.println(m);}


IRsend irsend;

void setup()
{
	WAIT;
	message("OlimexinoSTM32 Send Demo. Press any key to continue...");
	WAIT;
}

void loop() {
  
	WAIT;
    
	for (int i = 0; i < 3; i++) {
      irsend.sendSony(0xa90, 12); // Sony TV power code
      delay(40);
    }
	message("data sent...");
}
