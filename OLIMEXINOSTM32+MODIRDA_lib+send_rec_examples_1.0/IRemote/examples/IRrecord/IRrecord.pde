/*
 * IRrecord: record and play back IR signals as a minimal 
 * An IR detector/demodulator must be connected to the input RECV_PIN.
 * An IR LED must be connected to the output PWM pin 3.
 * A button must be connected to the input BUTTON_PIN; this is the
 * send button.
 * A visible LED can be connected to STATUS_PIN to provide status.
 *
 * The logic is:
 * If the button is pressed, send the IR code.
 * If an IR code is received, record it.
 *
 * Version 0.11 September, 2009
 * Copyright 2009 Ken Shirriff
 * http://arcfn.com
 *  
    (!!) NEW
 *  Modified by OLIMEX to work with the OLIMEXINO-STM32
 *  You need to send a key on the terminal, not press a button to send.
 *  If the IR code is received, record it.
 */

#include <IRremote.h>

int RECV_PIN = 8;
int STATUS_PIN = 13;

IRrecv irrecv(RECV_PIN);
IRsend irsend;

decode_results results;

uint32 time = 0, lastTime = millis();
boolean pressed=0;

// Timeout for enabling the receiver after sending
uint32 TIMEOUT = 1000;    // in milliseconds

void setup()
{
  irrecv.enableIRIn(); // Start the receiver
  pinMode(STATUS_PIN, OUTPUT);
}

// Storage for the recorded code
int codeType = -1; // The type of code
unsigned long codeValue; // The code value if not raw
unsigned int rawCodes[RAWBUF]; // The durations if raw
int codeLen; // The length of the code
int toggle = 0; // The RC5/6 toggle state

// Stores the code for later playback
// Most of this code is just logging
void storeCode(decode_results *results) {
  codeType = results->decode_type;
  int count = results->rawlen;
  if (codeType == UNKNOWN) {
    SerialUSB.println("Received unknown code, saving as raw");
    codeLen = results->rawlen - 1;
    // To store raw codes:
    // Drop first value (gap)
    // Convert from ticks to microseconds
    // Tweak marks shorter, and spaces longer to cancel out IR receiver distortion
    for (int i = 1; i <= codeLen; i++) {
      if (i % 2) {
        // Mark
        rawCodes[i - 1] = results->rawbuf[i]*USECPERTICK - MARK_EXCESS;
        SerialUSB.print(" m");
      } 
      else {
        // Space
        rawCodes[i - 1] = results->rawbuf[i]*USECPERTICK + MARK_EXCESS;
        SerialUSB.print(" s");
      }
      SerialUSB.print(rawCodes[i - 1], DEC);
    }
    SerialUSB.println("");
  }
  else {
    if (codeType == NEC) {
      SerialUSB.print("Received NEC: ");
      if (results->value == REPEAT) {
        // Don't record a NEC repeat value as that's useless.
        SerialUSB.println("repeat; ignoring.");
        return;
      }
    } 
    else if (codeType == SONY) {
      SerialUSB.print("Received SONY: ");
    } 
    else if (codeType == RC5) {
      SerialUSB.print("Received RC5: ");
    } 
    else if (codeType == RC6) {
      SerialUSB.print("Received RC6: ");
    } 
    else {
      SerialUSB.print("Unexpected codeType ");
      SerialUSB.print(codeType, DEC);
      SerialUSB.println("");
    }
    SerialUSB.println(results->value, HEX);
    codeValue = results->value;
    codeLen = results->bits;
  }
}

void sendCode(int repeat) {
  if (codeType == NEC) {
    if (repeat) {
      irsend.sendNEC(REPEAT, codeLen);
      SerialUSB.println("Sent NEC repeat");
    } 
    else {
      irsend.sendNEC(codeValue, codeLen);
      SerialUSB.print("Sent NEC ");
      SerialUSB.println(codeValue, HEX);
    }
  } 
  else if (codeType == SONY) {
    irsend.sendSony(codeValue, codeLen);
    SerialUSB.print("Sent Sony ");
    SerialUSB.println(codeValue, HEX);
  } 
  else if (codeType == RC5 || codeType == RC6) {
    if (!repeat) {
      // Flip the toggle bit for a new button press
      toggle = 1 - toggle;
    }
    // Put the toggle bit into the code to send
    codeValue = codeValue & ~(1 << (codeLen - 1));
    codeValue = codeValue | (toggle << (codeLen - 1));
    if (codeType == RC5) {
      SerialUSB.print("Sent RC5 ");
      SerialUSB.println(codeValue, HEX);
      irsend.sendRC5(codeValue, codeLen);
    } 
    else {
      irsend.sendRC6(codeValue, codeLen);
      SerialUSB.print("Sent RC6 ");
      SerialUSB.println(codeValue, HEX);
    }
  } 
  else if (codeType == UNKNOWN /* i.e. raw */) {
    // Assume 38 KHz
    irsend.sendRaw(rawCodes, codeLen, 38);
    SerialUSB.println("Sent raw");
  }
}

void loop() {
   time = millis();
   
  // If currently there are no keys from the terminal, reenable the receiver
  if ( ((time - lastTime) > TIMEOUT) && pressed){
    pressed = 0;
    SerialUSB.println("Re-enabling IR receiver...");
    irrecv.enableIRIn(); // Re-enable receiver
  }
  
  // If a key has been received from the terminal, send the code
  if (SerialUSB.available()) {
	char ch = SerialUSB.read();
    pressed = 1;
    SerialUSB.println("sending...");
    digitalWrite(STATUS_PIN, HIGH);
    sendCode((millis() - lastTime) < 500);
    lastTime = millis();
    digitalWrite(STATUS_PIN, LOW);
    delay(50); // Wait a bit between retransmissions
  } 
  else if (irrecv.decode(&results)) {
          digitalWrite(STATUS_PIN, HIGH);
          storeCode(&results);
          irrecv.resume(); // resume receiver
          digitalWrite(STATUS_PIN, LOW);
        }
}
