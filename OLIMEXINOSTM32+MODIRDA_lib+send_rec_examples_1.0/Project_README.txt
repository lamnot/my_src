|----------------------------------------------------------------------|
|	 README for the MODIRDA for the MAPLE IDE   		   			   |
|----------------------------------------------------------------------|
      
	MAPLE IDE version 0.0.12
	
	Project version 1.0
						   
	The library works with the OLIMEXINOSTM32 board + MODIRDA
	
		* MOD-IRDA   - a board with an IR Transmitter/Receiver
	
	How to install the library:
	1) Make sure that the Maple IDE is not running
	2) Copy the Iremote folder /libraries folder of
	   your Maple IDE installation folder
	3) Start the IDE. The "Iremote" examples should now
		appear under File/examples.
		
	Send/Receive examples were tested between two OLIMEXINO-STM32 boards
	with two MOD-IRDAs + a SONY and a NEC remote.
	
	Each example has useful notes at the beginning of the file.

	For the library to have the correct defs, we added to IremoteInt.h
	
	#define __OLIMEXINOSTM32__

#if defined(__OLIMEXINOSTM32__)
	// maple timers
	#define RECV_TIMER 3
	// maple pwm pin/timer/channel predefined and vary by processor
	//  maple RET6
	#define PWM_PIN 7
	#define PWM_TIMER 1
	#define PWM_TIMER_CH TIMER_CH2
	#define PWM_DUTY 2    //2 50%   4 25% hi
#else

	// maple timers
	#define RECV_TIMER 2
	// maple pwm pin/timer/channel predefined and vary by processor
	//  maple RET6
	#define PWM_PIN 24
	#define PWM_TIMER 4
	#define PWM_TIMER_CH TIMER_CH4
	#define PWM_DUTY 2    //2 50%   4 25% hi

#endif

	comment out #define __OLIMEXINOSTM32__ if tou want the oringinal defs.
	(Some examples define the RECV pin at the beginning, you should look at
	 those and change them accordingly if you'd like to use a different board)
		
	If you have any questions, email
	support@olimex.com
	
	OLIMEX, July 2012
	https://www.olimex.com


	