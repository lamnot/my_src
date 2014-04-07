|----------------------------------------------------------------------|
|	 README for the MOD-MAG project for the MAPLE IDE   		   			   |
|----------------------------------------------------------------------|
      
	MAPLE IDE version 0.0.12
						   
	The library works with the OLIMEXINO STM32 board + MOD-MAG
	
		* MOD-SMB380 - a board with a MAG3110 magnetometer
	
	The MAG3110 reference manual is included in this project.
	It conatins useful information about operation modes and
	value calibration.
	
	How to install the library:
	1) Make sure that the Maple IDE is not running
	2) Copy the MODMAG folder to the /libraries folder of
	   your Maple IDE installation folder
	3) Start the IDE. The "MODMAG" examples should now
		appear under File/examples.
	4) Include the libraries in your projects as such:
		#include "MODMAG.h"
		
	The library provides one example that utilizes the MODSMB380
	class interface:
	
	- RawRead - Read the register data upon prompt by the user.
				Uses the "Trigger Measurement method".Refer to 
				page 17 of the MAG3110 manual for detailed information

	If you have any questions, email
	support@olimex.com
	
	OLIMEX, January 2013
	https://www.olimex.com