|----------------------------------------------------------------------|
|	 README for the LoLShield libraries for the MAPLE IDE   		   |
|----------------------------------------------------------------------|
      
	MAPLE IDE version 0.0.12
	Original LoLShield library version - 0.2 beta,
				       ported to the MAPLE environment
					   
	The libraries work with the OLIMEXINO STM32 board + the LoLShield
	
	How to install the libraries:
	1) Make sure that the Maple IDE is not running
	2) Copy the LoLShield folder to the /libraries folder of
	   your Maple IDE installation folder
	3) Start the IDE. The "LoLShield" examples should now
		appear under File/examples.
	4) Include the libarries in your projects as such:
		#include "Charliplexing.h"
		#include "LOLDraw.h"
		#include "Font.h"
		#include "Draw.h"
	
	The Charliplexing library uses Timer 2 to refresh the LEDs
	If you need timer 2 specifically for something else,
	open Charliplexing.cpp, find the
		
		HardwareTimer lolTimer(2);
		
	definition and change it to
	
		HardwareTimer lolTimer(X);
	
	where X is the number of the Timer you want to use.
	
	Refer to the comments in the LOLDraw files to see how to call
	the drawing functions.
	
	Note: The issue where Font::Draw and ::Draw90 wouldn't draw on the
		  14th row has been fixed
	
|----------------------------------------------------------------------|
|	Notes on porting the refresh code from AVR to ARM				   |
|----------------------------------------------------------------------|

	The original Charliplexing library uses the AVR DDRx and PORTx
	ports to control the pins 2-13 and refresh the screen
	DDRx - Data Direction Register for port X
		   Controls whether the pin is INPUT or OUTPUT
    PORTx - The pin values for port X
		   Controls whether the pin is HIGH or LOW (1 or 0)
		   
	On the Arduino platform,
	port D(bits 2 to 7) = pins 2 to 7
	port B(bits 0 to 5) = pins 8 to 13
	
	So, to port the code we saved the values that should have been
	written to the registers in 4 8-bit chars, read them bit by bit
	and set the corresponding ports on the STM32 to have the same behaviour
	
	The following table shows how:
	|--------------------------------------------------|
	| DDRx | PORTx| | |	On the ARM processor |         |
	|--------------------------------------------------|
	|	0	  0		| Floating Input   + any pin value |
	|	0	  1		| Input Pulldown   + pin to 0      |
	|	1	  0		| Output Push-Pull + pin to 0      |
	|	1	  1		| Output Push-Pull + pin to 1      |
	| -------------	|----------------------------------|
	
	