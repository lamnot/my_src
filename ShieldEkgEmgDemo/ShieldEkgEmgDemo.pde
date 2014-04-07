//*********************************************************************/
//* Demo program for:                                                 */
//*    Board: SHIELD-EKG/EMG + OLIMEXINO-STM32                        */
//*  Manufacture: OLIMEX                              		      */	
//*  COPYRIGHT (C) 2012                               		      */			       
//*  Designed by:  Penko Todorov Bozhkov              		      */		       
//*   Module Name:  Example                                           */
//*   File   Name:  ShieldEkgEmgDemo.pde                              */
//*   Revision:  Rev.A	                              		      */			         
//*   History:	  Added support for OLIMEXINO-STM32                   */
//*   Date: 04.09.2012                                                */
//*   Built with MAPLE IDE v.0.0.12                                   */      				  						            
//*********************************************************************/
/*************************************************************************************
Purpose of this program is to give you an easy way to 
connect PIC32-PINGUINO-OTG to ElectricGuru(TM), see:
http://www.realization.org/page/topics/electric_guru.htm
where you'll be able to observe yours own EKG or EMG signal.
It is based on:
**************************************************************************************
* ModularEEG firmware for one-way transmission, v0.5.4-p2
* Copyright (c) 2002-2003, Joerg Hansmann, Jim Peters, Andreas Robinson
* License: GNU General Public License (GPL) v2
**************************************************************************************
For proper communication packet format given below have to be supported:
/////////////////////////////////////////////////////
////////// Packet Format Version 2 ////////////
/////////////////////////////////////////////////////
// 17-byte packets are transmitted from PIC32-PINGUINO-OTG at 256Hz,
// using 1 start bit, 8 data bits, 1 stop bit, no parity, 57600 bits per second.

// Minimial transmission speed is 256Hz * sizeof(PIC32-PINGUINO-OTG_packet) * 10 = 43520 bps.

struct PIC32-PINGUINO-OTG_packet
{
  uint8_t	sync0;		// = 0xa5
  uint8_t	sync1;		// = 0x5a
  uint8_t	version;		// = 2 (packet version)
  uint8_t	count;		// packet counter. Increases by 1 each packet.
  uint16_t	data[6];	// 10-bit sample (= 0 - 1023) in big endian (Motorola) format.
  uint8_t	switches;		// State of PD5 to PD2, in bits 3 to 0. -> This is not used in current application. The value is set to 0x01
};
*/
/***************************************************************************************/
// In the source below was used the example given by:
// Jean-Pierre MANDON 2011
// Using interrupt with Pinguino32
// http://blog.pinguino.cc/

#include <timer.h>
#include <usart.h>
#include <usb.h>

HardwareTimer adc_timer(1);

// Definitions for the STM32 board
#define LED2_ON		pinMode(3, OUTPUT); digitalWrite(3, HIGH)
#define LED2_OFF	pinMode(3, OUTPUT); digitalWrite(3, LOW)
#define LED2_TOGG	pinMode(3, OUTPUT); digitalWrite(3, digitalRead(3)^1)

#define LED1 		    13
#define LED2	             3
#define CAL_SIG              9
#define NUMCHANNELS 	     6
#define HEADERLEN 	     4
#define PACKETLEN 	(NUMCHANNELS * 2 + HEADERLEN + 1)

// Global constants and variables
unsigned char TXBuf[PACKETLEN];             //The transmission packet
volatile unsigned char CurrentCh;           //Current channel being sampled.
volatile unsigned char counter = 0;	    //Additional divider used to generate CAL_SIG
volatile unsigned short int  ADC_Value = 0;	    //ADC current value


/****************************************************/
/*  Function name: toggle_LED1                      */
/*  Parameters                                      */
/*    Input   :  No 	                            */
/*    Output  :  No                                 */
/*    Action: Switches-over LED1.                   */
/****************************************************/
void toggle_LED1(void){
 if(digitalRead(LED1) == HIGH){	digitalWrite(LED1, LOW); }
 else{digitalWrite(LED1, HIGH); }
}

/****************************************************/
/*  Function name: toggle_GAL_SIG     */
/*  Parameters                        */
/*    Input   :  No	                   */
/*    Output  :  No                   */
/*    Action: Switches-over GAL_SIG.  */
/****************************************************/
void toggle_GAL_SIG(void){
 if(digitalRead(CAL_SIG) == HIGH){	digitalWrite(CAL_SIG, LOW); }
 else{ digitalWrite(CAL_SIG, HIGH); }
}

/*********************************************************/
/*  Function name: Tmr1Interrupt                         */
/*  Parameters                                           */
/*    Input   :  No	                                 */
/*    Output  :  No                                      */
/*    Action: All actions are done here.	         */
/*********************************************************/
void Tmr1Interrupt(void)
{
	 toggle_LED1();		// Toggle LED1 with frequency 250/2 = 125Hz. LED1 can be used to monitor Timer1 interrupt frequency!
	 
	 //Read the 6 ADC inputs and store current values in Packet
	 for(char i=0; i<6; i++){
      
	  CurrentCh = 15 + i;
	  ADC_Value = analogRead(CurrentCh); 
	
	  // Map the 12-bit value to a 10-bit one
      ADC_Value = (ADC_Value*1023/4095);
	  
      TXBuf[((2*i) + HEADERLEN)] = ((unsigned char)((ADC_Value & 0xFF00) >> 8));	// Write High Byte
	  TXBuf[((2*i) + HEADERLEN + 1)] = ((unsigned char)(ADC_Value & 0x00FF));		// Write Low Byte
	 }
	 
	 // Send Packet using the simplest byte transfer
	  usbSendBytes((uint8 *)TXBuf, 17);
      
	 TXBuf[3]++;			// increment packet counter
	 
	 counter++;				// increment the divider counter
	 if(counter == 12){	// 250/12/2 = 10.4Hz ->Toggle frequency
		counter = 0;
		toggle_GAL_SIG();	// Generate CAL signal with frequ ~10Hz
		
		LED2_TOGG;			// Show CAL_SIG frequency via LED2 blinking
	 }	
}


/*********************************************************/
/*  Function name: init_timer1        		         */
/*  Parameters                        		         */
/*    Input   :  No	                 		 */
/*    Output  :  No                   		         */
/*    Action: configure timer1 operation.                */
/*********************************************************/
void init_timer1(void)
{
  adc_timer.pause();
  adc_timer.setPeriod(4000); //4ms = 250Hz resolution
  adc_timer.attachInterrupt(1, Tmr1Interrupt);
  adc_timer.refresh();
  adc_timer.resume();	
}

/*********************************************************/
/*  Function name: setup              		         */
/*  Parameters                        		         */
/*    Input   :  No	                 		 */
/*    Output  :  No                   		         */
/*    Action: Initializes all peripherals                */
/*********************************************************/
void setup()
{ 
	 pinMode(LED1, OUTPUT);
	 pinMode(CAL_SIG, OUTPUT);

	// Initialize the analog pins and Analog Inputs
         for(CurrentCh=15; CurrentCh<21; CurrentCh++)
             pinMode(CurrentCh, INPUT_ANALOG);
             
	  //Write init whole packet
	 TXBuf[0] = 0xa5;  	 //Sync 0
	 TXBuf[1] = 0x5a;  	 //Sync 1
	 TXBuf[2] = 0x02;     //Protocol version
	 TXBuf[3] = 0x00;     //Packet counter
	 TXBuf[4] = 0x02;     //CH1 High Byte
	 TXBuf[5] = 0x00;     //CH1 Low Byte
	 TXBuf[6] = 0x02;     //CH2 High Byte
	 TXBuf[7] = 0x00;     //CH2 Low Byte
	 TXBuf[8] = 0x02;     //CH3 High Byte
	 TXBuf[9] = 0x00;     //CH3 Low Byte
	 TXBuf[10] = 0x02;    //CH4 High Byte
	 TXBuf[11] = 0x00;    //CH4 Low Byte
	 TXBuf[12] = 0x02;    //CH5 High Byte
	 TXBuf[13] = 0x00;    //CH5 Low Byte
	 TXBuf[14] = 0x02;    //CH6 High Byte
	 TXBuf[15] = 0x00;    //CH6 Low Byte 
	 TXBuf[2 * NUMCHANNELS + HEADERLEN] =  0x01;	// Switches state
	 
         SerialUSB.print("");  // A dummy action, to ensure the USB 
							   // serial connection starts
	 init_timer1();
}


/*********************************************************/
/*  Function name: loop                                  */
/*  Parameters                                           */
/*    Input   :  No	                                 */
/*    Output  :  No                                      */
/*    Action: Do nothing.				 */
/*********************************************************/
void loop()
{}
