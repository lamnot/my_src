/*
	OLIMEXINO STM32 Example
	
	Attach a function to a timer channel
	to be executed when an interrupt occurs.
	
	Written for MAPLE IDE v0.0.12
	
*/

// Define the two LEDS on the OLIMEXINO Board
#define GLED 13			// Green Led
#define YLED 3			// Yellow Led

/*
	Define a Timer object
	Passing 1 to the constructor means
	that this object affects Timer1
*/
	HardwareTimer ledTimer(1);

/*
	The function we are going to attach
	to the timer overflow	
*/
	void blink_led()
	{
		//toggle the LEDS
		togglePin(GLED);
		togglePin(YLED);
		
	}

	
void setup()
{
  // Init the LEDs and turn them off
  pinMode(GLED, OUTPUT);
  pinMode(YLED, OUTPUT);
  digitalWrite(GLED, LOW);
  digitalWrite(YLED, LOW);
  
  // Making sure the Timer isn't counting... 
  ledTimer.pause();
  
  // Set the period - this determines
  // how often an interrupt will occur
  ledTimer.setPeriod(500000);
  
  // Attach the function to the timer's 1st channel
  ledTimer.attachInterrupt(1, blink_led);
  
  // Update all the properties we set above
  ledTimer.refresh();
  
  //Turn the timer ON - to turn it off, use .pause();
  ledTimer.resume();
}

void loop()
{
	// nothing to do here
	// the interrupt routine handles everything
}
