/*
  
  Olimexino STM32 Example for the Maple IDE
  Code from the Leaflabs page:
  http://leaflabs.com/docs/lang/api/waitforbuttonpress.html?highlight=button

  If you have any questions, email
  support@olimex.com
  
*/

// Define the two LEDS on the OLIMEXINO Board
#define GLED 13			// Green Led
#define YLED 3			// Yellow Led

void button_event();

void setup() {
    pinMode(BOARD_BUTTON_PIN, INPUT);
}

void loop() {
    
    // No timeout parameter = the function will wait forever
    waitForButtonPress();
    //SerialUSB.println("You pressed the button!");
    button_event();
}

void button_event()
{
  pinMode(YLED, OUTPUT);
  pinMode(GLED, OUTPUT);
  
  for(int i=0; i<10; i++)
  {
    togglePin(YLED);
    togglePin(GLED);
    
    delay(300);
    
  }
} 
 
    
  
