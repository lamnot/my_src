/*
  Charliplexing.cpp - Using timer2 with 1ms resolution
  
  |---------------------------------------------|
  |-- July 2012 Modified by Olimex to work with |
			   the Olimexino STM32				|
  |---------------------------------------------|
  
  Alex Wenger <a.wenger@gmx.de> http://arduinobuch.wordpress.com/
  Matt Mets <mahto@cibomahto.com> http://cibomahto.com/
  
  Timer init code from MsTimer2 - Javier Valencia <javiervalencia80@gmail.com>
  Misc functions from Benjamin Sonnatg <benjamin@sonntag.fr>
  
  History:
    2009-12-30 - V0.0 wrote the first version at 26C3/Berlin
    2010-01-01 - V0.1 adding misc utility functions 
      (Clear, Vertical,  Horizontal) comment are Doxygen complaints now
    2010-05-27 - V0.2 add double-buffer mode

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include "WProgram.h"
#include "Charliplexing.h"

/* -----------------------------------------------------------------  */
/** Table for the LED multiplexing cycles, containing 12 cycles made out of two bytes
 */
unsigned char leds[2][24];

/// Determines whether the display is in single or double buffer mode
unsigned char displayMode;

/// Flag indicating that the display page should be flipped as soon as the
/// current frame is displayed
boolean videoFlipPage;

/// Pointer to the buffer that is currently being displayed
unsigned char* displayBuffer;

/// Pointer to the buffer that should currently be drawn to
unsigned char* workBuffer;

/// Function that refreshes the screen every 1ms
void LoLShieldRefresh();


/* -----------------------------------------------------------------  */
/** Table for LED Position in leds[] ram table 
 */
const unsigned short int ledMap[252] = { 
    13, 5,13, 6,13, 7,13, 8,13, 9,13,10,13,11,13,12,13, 4, 4,13,13, 3, 3,13,13, 2, 2,13,
    12, 5,12, 6,12, 7,12, 8,12, 9,12,10,12,11,12,13,12, 4, 4,12,12, 3, 3,12,12, 2, 2,12,
    11, 5,11, 6,11, 7,11, 8,11, 9,11,10,11,12,11,13,11, 4, 4,11,11, 3, 3,11,11, 2, 2,11,
    10, 5,10, 6,10, 7,10, 8,10, 9,10,11,10,12,10,13,10, 4, 4,10,10, 3, 3,10,10, 2, 2,10,
     9, 5, 9, 6, 9, 7, 9, 8, 9,10, 9,11, 9,12, 9,13, 9, 4, 4, 9, 9, 3, 3, 9, 9, 2, 2, 9,
     8, 5, 8, 6, 8, 7, 8, 9, 8,10, 8,11, 8,12, 8,13, 8, 4, 4, 8, 8, 3, 3, 8, 8, 2, 2, 8,
     7, 5, 7, 6, 7, 8, 7, 9, 7,10, 7,11, 7,12, 7,13, 7, 4, 4, 7, 7, 3, 3, 7, 7, 2, 2, 7,
     6, 5, 6, 7, 6, 8, 6, 9, 6,10, 6,11, 6,12, 6,13, 6, 4, 4, 6, 6, 3, 3, 6, 6, 2, 2, 6,
     5, 6, 5, 7, 5, 8, 5, 9, 5,10, 5,11, 5,12, 5,13, 5, 4, 4, 5, 5, 3, 3, 5, 5, 2, 2, 5,
    };


/* -----------------------------------------------------------------  */
/** Constructor : Initialize the interrupt code. 
 * should be called in setup();
 */
  
void LedSign::Init(unsigned char mode)
{

  HardwareTimer lolTimer(2);
  
  lolTimer.pause();		  	 // pause the timer	
  lolTimer.setPeriod(1000);  // 1ms resolution, as stated above
  
  // Attach the function to the timer's 1st channel
  lolTimer.attachInterrupt(1, LoLShieldRefresh);
  
  // Update all the properties we set above
  // And set the counter to 0
  lolTimer.refresh();
  
  //Turn the timer ON
  lolTimer.resume();
	
    // Record whether we are in single or double buffer mode
    displayMode = mode;

    // Point the display buffer to the first physical buffer
    displayBuffer = leds[0];

    // If we are in single buffered mode, point the work buffer
    // at the same physical buffer as the display buffer.  Otherwise,
    // point it at the second physical buffer.
    if( displayMode == SINGLE_BUFFER ) {
        workBuffer = displayBuffer;
    }
    else {
        workBuffer = leds[1];
    }

    // Clear the buffer and display it
    LedSign::Clear(0);
    LedSign::Flip(false);
}


/* -----------------------------------------------------------------  */
/** Clear the screen completely
 * @param blocking if true : wait for flip before returning, if false :
 *                 return immediately.
 */
void LedSign::Flip(bool blocking)
{
    if (displayMode == DOUBLE_BUFFER)
    {
        // Just set the flip flag, the buffer will flip between redraws
        videoFlipPage = true;

        // If we are blocking, sit here until the page flips.
        while (blocking && videoFlipPage) {
            delay(1);
        }
    }
}


/* -----------------------------------------------------------------  */
/** Clear the screen completely
 * @param set if 1 : make all led ON, if not set or 0 : make all led OFF
 */
void LedSign::Clear(int set) {
    for(int x=0;x<14;x++)  
        for(int y=0;y<9;y++) 
            Set(x,y,set);
}


/* -----------------------------------------------------------------  */
/** Clear an horizontal line completely
 * @param y is the y coordinate of the line to clear/light [0-8]
 * @param set if 1 : make all led ON, if not set or 0 : make all led OFF
 */
void LedSign::Horizontal(int y, int set) {
    for(int x=0;x<14;x++)  
        Set(x,y,set);
}


/* -----------------------------------------------------------------  */
/** Clear a vertical line completely
 * @param x is the x coordinate of the line to clear/light [0-13]
 * @param set if 1 : make all led ON, if not set or 0 : make all led OFF
 */
void LedSign::Vertical(int x, int set) {
    for(int y=0;y<9;y++)  
        Set(x,y,set);
}


/* -----------------------------------------------------------------  */
/** Set : switch on and off the leds. All the position 
 * calculations are done here, so we don't need to do in the
 * interrupt code
 */
void LedSign::Set(unsigned char x, unsigned char y, unsigned char c)
{
    unsigned char pin_low  = ledMap[x*2+y*28+1];
    unsigned char pin_high = ledMap[x*2+y*28+0];
    // pin_low is directly the address in the led array (minus 2 because the 
    // first two bytes are used for RS232 communication), but
    // as it is a two byte array we need to check pin_high also.
    // If pin_high is bigger than 8 address has to be increased by one
    if (c == 1) {
        // workBuffer[(pin_low-2)*2 + (pin_high / 8)] |=  _BV(pin_high & 0x07);   // ON
        workBuffer[(pin_low-2)*2 + (pin_high / 8)] |=  (1<<(pin_high & 0x07));   // ON
    } 
    else {
        // workBuffer[(pin_low-2)*2 + (pin_high / 8)] &= ~_BV(pin_high & 0x07);   // OFF
        workBuffer[(pin_low-2)*2 + (pin_high / 8)] &= ~(1<<(pin_high & 0x07));   // OFF
    }
}


/* -----------------------------------------------------------------  */
/** The Interrupt code goes here !
	
	For the Maple IDE version:
	Refer to the README file in the LoLShield project directory
	to see how the refresh code was ported from AVR code.
	
 */
void LoLShieldRefresh()
{   
	// 12 Cycles of Matrix
    static unsigned char i = 0;
	unsigned char m;

	unsigned char get_ddrd=0, get_portd=0, get_ddrb=0, get_portb=0;
	unsigned char dd, pd, db, pb;
	
    if (i < 6) 
	{	   
        get_ddrd  = (1<<(i+2)) | displayBuffer[i*2];
		get_portd =            displayBuffer[i*2];
			   
		get_ddrb  =            displayBuffer[i*2+1];
		get_portb =            displayBuffer[i*2+1];
						
    } 
	else 
	{
		get_ddrd  =            displayBuffer[i*2];
		get_portd =            displayBuffer[i*2];
		
		
		get_ddrb  = (1<<(i-6)) | displayBuffer[i*2+1];
		get_portb =              displayBuffer[i*2+1];
	} 

	/* ------ D ---------- */		
		for(m=2; m<8; m++)
		{
		  dd = ((get_ddrd&(1<<m))>>m);
		  pd = ((get_portd&(1<<m))>>m);
		  
		  if(dd == 0)
		  {
			  if(pd == 0) 
			   gpio_set_mode(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, GPIO_INPUT_FLOATING);
			   
			  if(pd == 1) 
			  {
			      gpio_set_mode(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, GPIO_INPUT_PD);
				 gpio_write_bit(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, 0);
			  }			  
		  }
		  
		  if(dd == 1)
		  {
			gpio_set_mode(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, GPIO_OUTPUT_PP);
			gpio_write_bit(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, pd);	  
		  }
		}
	   /* ------- D --------- */
	   
	   /* ------- B --------- */	
		for(m=8; m<=13; m++)
		{
			db = ( get_ddrb & (1<<(m-8)))>>(m-8);
			pb = (get_portb & (1<<(m-8)))>>(m-8);
			
			if(db == 0)
		    {
			  if(pb == 0) 
			   gpio_set_mode(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, GPIO_INPUT_FLOATING);
			   
			  if(pb == 1) 
			  {
			     gpio_set_mode(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, GPIO_INPUT_PD);
				 gpio_write_bit(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit,0);
			  }			  
		    }
		  
		  if(db == 1)
		  {
			gpio_set_mode(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, GPIO_OUTPUT_PP);
			gpio_write_bit(PIN_MAP[m].gpio_device, PIN_MAP[m].gpio_bit, pb);	  
		  }	
		}
		/* ------- B -------- */		
	
    i++;
    
	if (i > 12) 
	{
        i = 0;
	 
        // If the page should be flipped, do it here.
        if (videoFlipPage && displayMode == DOUBLE_BUFFER)
        {
            // TODO: is this an atomic operation?
            videoFlipPage = false;

            unsigned char* temp = displayBuffer;
            displayBuffer = workBuffer;
            workBuffer = temp;
        }
	
    }
}

