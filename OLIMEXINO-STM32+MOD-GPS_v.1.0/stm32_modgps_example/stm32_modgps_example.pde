/*
	Olimexino-STM32 + MOD-GPS Example Code
	
	|-------------------------------------
	| v. 1.0 - initial version
	|-------------------------------------
	
	Shows the geo positional infrormation that
	the MOD-GPS sends periodically in a readable
	format on the terminal
	
	There is a line of code in "loop()" that makes the
	program wait for a key after each print; Comment that out
	if you'd like a continuous print.
	
	There is more useful info in the README file in the example archive.
	
	This example is also available for the Pinguino
	platform. See https://www.olimex.com/dev
	
	If you have any questions, email
	support@olimex.com
	
	Olimex, July 2012
	http://www.olimex.com/dev
	
*/	
	
	// Serial1 is on the UEXT on the Olimexino-STM32 board
        // Define the name GPS as a reference to the standard Serial1 object
	HardwareSerial & GPS = Serial1;
	
	// Create the timer object as Timer 2.
	// Timers 1 to 4 are usually available to the user.
	// Refer to the Maple Site and the STM32 datasheet for more info
	HardwareTimer GPS_Timer(2);
	
	//Blinks an LED five times - mode is YELLOW, GREEN or BOTH
	void blinkled(unsigned char mode);

	//Catches a string and writes to the buffer
	//The module sends lines in the format <string><CR><LF>
	void GPS_get_response();
 
        //Prints text from a given index in the buffer
	//until it meets the ',' (comma) character
	//returns the new index
	unsigned char print_till_comma(char *buf, volatile char a);
	
	//Prints the data received in the buffer
	//in a user-frinedly style
	void print_data(char *buf);

    unsigned char counter=0;	

	//A macro that waits for a key via SerialUSB
	//Works with all pinguinos that support SerialUSB
	//Syntax:
	//   WAIT;   //-> pauses the program and waits
				 //   until a key is pressed 
		
	//WAIT Macro 
	#define WAIT wait_123()
	char ch123;
	
	void wait_123() __attribute ((noinline));
	
	void wait_123(){ ch123 = SerialUSB.read(); }
	//END Wait Macro
	
	// Sends a single line of text to the terminal via CDC
	void message(char * m){ SerialUSB.println(m);}
	
	
     /*		Global variables			  */

	#define BUFFER_SIZE 64
         char serial_buffer[BUFFER_SIZE] = {0};
	     	
void setup(){
	
    WAIT;
	message("Press a key to init the GPS module");
	WAIT;

        GPS.begin(19200);	
	
	message("Press a key to start printing...");
	WAIT;
}

void loop(){

	if(GPS.available())
	{
		GPS_get_response();
		
		//serial_buffer now has the string
		if( (serial_buffer[4] == 'G') && (serial_buffer[5] == 'A') )
		{
		  print_data(serial_buffer); //if it's the GPGGA string, print the data
		  
		  WAIT;   //Comment this if you don't want to wait after every print
		  
		}
        
	}
}

void GPS_get_response()
{
	char i = 0;
	char c;
	
		  do{
			  while(!GPS.available());
			  c = GPS.read();
			}while(c!='$');   //Only start recording at the beginning of the string
			 
			serial_buffer[i] = c; i++; //record the first character
	     
	do{
		while(!GPS.available());
		c = GPS.read();
			
	    // Stop when you meet the <CR> character
	    if( c != '\r' && c!= '$' )
	    {	
			serial_buffer[i] = c;
			i++;
	    }
		
	}while( c != '\r' && c != '$' ); //Check for end of string. there are rare cases where
									 //the module fails to send '\r' and begins the next string,
								     //so the code checks for that also.
	
	serial_buffer[i] = '\0';
		
    //Catch the <LF> character
	while(!GPS.available());
	c = GPS.read();
}

unsigned char print_till_comma(char *buf, volatile unsigned char a)
{
	if(buf[a] == ',')
	{
	  SerialUSB.println("NA");
	  return a+1; 
	}
	else
	{
	  do{
	     SerialUSB.print(buf[a]);
	     a++;
	    }while( buf[a] != ',' && buf[a] != '\0');
          
          message("");		  
	  return a+1;
	}		
}

void print_data(char * buf)
{
	volatile unsigned char index = 7;

        //DEBUG:
        message(buf);
	
	message("");
	message("*--------------------------------------*");
	message("Printing GPGGA geo data from the module: ");
	SerialUSB.print("            UTC Time: "); if(buf[index]   != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("            Latitude: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("            N/S ind.: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("           Longitude: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("             E/W ind: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("    Position fix ind: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("     Satellites Used: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("                HDOP: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("        MSL Altitude: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("               Units: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("    Geoid Separation: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("               Units: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("   Age of Diff. Corr: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("Diff. reference Corr: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	SerialUSB.print("            Checksum: "); if(buf[index-1] != '\0') index = print_till_comma(buf, index); else SerialUSB.println("NA");
	message("*--------------------------------------*");
	message("");

        for(int i=0; i<BUFFER_SIZE; i++)   //make sure there are no remaining numbers in the buffer
            buf[i] = ',';
}

