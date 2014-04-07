OLIMEXINO STM32 GPS project README
	
	This example program communicates with a MOD-GPS module using an
	OLIMEXINO-STM32 board.	
	
	|------------------------------------
	| v. 1.0 - initial version
	|------------------------------------
	
	----------------------------------------------------------------------------
	-- The example program reads data sent from the GPS module; 
	   The module continuously sends three/four different
	   strings with info on coordinates, satellites etc. The program catches every
	   string but prints only the one with geographic info.
	   (The function print_data() can always be customized)
	   
	-- After the call to the print...() function, there is a line with "WAIT;"
		Comment it out if you want a continuous print of info in the terminal.
				
	-- GENERAL INFORMATION:
	
	 This project compiles and works with Maple IDE 0012 Windows
	 
	 Download the latest pinguino for your OS from:
	 http://leaflabs.com/docs/maple-ide-install.html#download
	 
	 If you have any questions, email support@olimex.com
	
	 If you have any questions, email
	 support@olimex.com
		
	 --------
	 JULY, 2012
	 http://www.olimex.com/dev