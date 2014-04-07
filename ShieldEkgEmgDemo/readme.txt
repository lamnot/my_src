	
	ShieldEcgEmg Example for Olimexino-STM32
	
	Note:
		When connected to an Olimexino-STM32, 
		the REF_E jumper should be open.
		
		The voltage jumper should be set to 3.3V (!!)

	The program uses a timer set to overflow every 4ms
	to read samples from the 6 analog pins.
	
	The STM32 ADC outputs 12-bit values, which the program
	maps to 10-bit ones readable by PC software like ElecGuru
	
	