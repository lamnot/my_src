/*
 * IRremote: IRrecvDump - dump details of IR codes with IRrecv
 * An IR detector/demodulator must be connected to the input RECV_PIN.
 * Version 0.1 July, 2009
 * Copyright 2009 Ken Shirriff
 * http://arcfn.com
 */

#define __OLIMEXINOSTM32__
#include <IRremote.h>

int RECV_PIN = 8;

IRrecv irrecv(RECV_PIN);

decode_results results;

void setup()
{
  irrecv.enableIRIn(); // Start the receiver
}

// Dumps out the decode_results structure.
// Call this after IRrecv::decode()
// void * to work around compiler issue
//void dump(void *v) {
//  decode_results *results = (decode_results *)v
void dump(decode_results *results) {
  int count = results->rawlen;
  if (results->decode_type == UNKNOWN) {
    SerialUSB.print("Unknown encoding: ");
  } 
  else if (results->decode_type == NEC) {
    SerialUSB.print("Decoded NEC: ");
  } 
  else if (results->decode_type == SONY) {
    SerialUSB.print("Decoded SONY: ");
  } 
  else if (results->decode_type == RC5) {
    SerialUSB.print("Decoded RC5: ");
  } 
  else if (results->decode_type == RC6) {
    SerialUSB.print("Decoded RC6: ");
  }
  SerialUSB.print(results->value, HEX);
  SerialUSB.print(" (");
  SerialUSB.print(results->bits, DEC);
  SerialUSB.println(" bits)");
  SerialUSB.print("Raw (");
  SerialUSB.print(count, DEC);
  SerialUSB.print("): ");

  for (int i = 0; i < count; i++) {
    if ((i % 2) == 1) {
      SerialUSB.print(results->rawbuf[i]*USECPERTICK, DEC);
    } 
    else {
      SerialUSB.print(-(int)results->rawbuf[i]*USECPERTICK, DEC);
    }
    SerialUSB.print(" ");
  }
  SerialUSB.println("");
}


void loop() {
  if (irrecv.decode(&results)) {
    SerialUSB.println(results.value, HEX);
    dump(&results);
    irrecv.resume(); // Receive the next value
  }
}
