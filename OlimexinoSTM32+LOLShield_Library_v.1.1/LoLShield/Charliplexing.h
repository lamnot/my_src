/*
  Charliplexing.h - Library for controlling the charliplexed led board
  from JimmiePRodgers.com
  Created by Alex Wenger, December 30, 2009.
  Modified by Matt Mets, May 28, 2010.
  Released into the public domain.
  
  |---------------------------------------------|
  |-- July 2012 Modified by Olimex to work with |
			   the Olimexino STM32				|
  |---------------------------------------------|
  
*/

#ifndef Charliplexing_h
#define Charliplexing_h

#define SINGLE_BUFFER 0
#define DOUBLE_BUFFER 1

#include "HardwareTimer.h"
#include "wirish.h"
#include "io.h"

namespace LedSign
{
    extern void Init(unsigned char mode = SINGLE_BUFFER);
    extern void Set(unsigned char x, unsigned char y, unsigned char c);
    extern void Flip(bool blocking = false);
    extern void Clear(int set=0);
    extern void Horizontal(int y, int set=0);
    extern void Vertical(int x, int set=0);
};

#endif
