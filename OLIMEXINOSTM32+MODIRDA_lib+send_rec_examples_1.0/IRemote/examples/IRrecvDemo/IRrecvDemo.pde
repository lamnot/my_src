/*
 * IRremote: IRrecvDemo - demonstrates receiving IR codes with IRrecv
 * An IR detector/demodulator must be connected to the input RECV_PIN.
 * Version 0.1 July, 2009
 * Copyright 2009 Ken Shirriff
 * http://arcfn.com
 *
 *  Modified by OLIMEX to work with the OLIMEXINO-STM32
 *  IRemote Maple project downloaded from Github on July 24, 2012
 */

#include <IRremote.h>

int RECV_PIN = 8;

IRrecv irrecv(RECV_PIN);

decode_results results;

void setup()
{
  irrecv.enableIRIn(); // Start the receiver
  char ch = SerialUSB.read();
  SerialUSB.println("press any key to start...");
  ch = SerialUSB.read();
}

void loop() {
  if (irrecv.decode(&results)) {
    SerialUSB.println(results.value, BIN);
    irrecv.resume(); // Receive the next value
  }
  
}
