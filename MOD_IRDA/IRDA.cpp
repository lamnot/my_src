/*
 * IRDA.cpp
 * 
 * Copyright 2013 OLIMEX LTD/Stefan Mavrodiev <support@olimex.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 */
 

#include "IRDA.h"
#include "../Wire/Wire.h"



/*
 * Class variables
 */
 uint8_t IRDA::address = 0x24;

 
 uint8_t IRDA::SIRC = 0x01;
 uint8_t IRDA::RC5 = 0x00;
 uint8_t IRDA::ID = 0x54;


/*
 * Constructors
 */
IRDA::IRDA(){
}

IRDA::IRDA(uint8_t addr){
    address = addr;
}

void IRDA::setAddress(uint8_t newAddress){
    Wire.begin();
    Wire.beginTransmission(address);
    Wire.write(SET_ADDRESS);
    Wire.write(newAddress);
    Wire.endTransmission();
}
uint8_t IRDA::getID(void){
    unsigned char data;  
    Wire.begin();
    Wire.beginTransmission(address);
    Wire.write(GET_ID);
    Wire.endTransmission();
    Wire.requestFrom((int)address, 1);
    data = Wire.read();
    
    return data;    
}
void IRDA::setMode(uint8_t mode){
  Wire.begin();
  Wire.beginTransmission(address);
  Wire.write(SET_MODE);
  Wire.write(mode);
  Wire.endTransmission();
}
void IRDA::sendData(uint8_t device, uint8_t command){
  Wire.begin();
  Wire.beginTransmission(address);
  Wire.write(WRITE);
  Wire.write(device);
  Wire.write(command);
  Wire.endTransmission();
}
uint16_t IRDA::readData(){
  uint8_t data[2];
  Wire.begin();
  Wire.beginTransmission(address);
  Wire.write(READ);
  Wire.endTransmission();
  Wire.requestFrom((int)address, 2);
  data[0] = Wire.read();
  data[1] = Wire.read();
  
  return (data[0] << 8) | data[1];
}