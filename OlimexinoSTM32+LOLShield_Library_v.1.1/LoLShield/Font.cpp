/*
  Font drawing library

  Copyright 2009/2010 Benjamin Sonntag <benjamin@sonntag.fr> http://benjamin.sonntag.fr/
  
  History:
  	2010-01-01 - V0.0 Initial code at Berlin after 26C3

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330,
  Boston, MA 02111-1307, USA.
  
  |---------------------------------------------|
  |-- July 2012 Modified by Olimex to work with |
			   the Olimexino STM32				|
  |---------------------------------------------|  
  
*/

#include "Font.h"
#include "Charliplexing.h"

unsigned char letters_71[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,7, 2,1, 2,4, 2,7, 3,1, 3,2, 3,4, 3,5, 3,6, 3,7, 9,9 };
unsigned char letters_83[] = { 0,2, 0,3, 0,7, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,5, 3,6, 9,9 };
unsigned char letters_67[] = { 0,2, 0,3, 0,4, 0,5, 0,6, 1,1, 1,7, 2,1, 2,7, 3,1, 3,7, 9,9 };
unsigned char letters_76[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,7, 2,7, 3,7, 9,9 };
unsigned char letters_89[] = { 0,1, 0,2, 1,3, 2,4, 2,5, 2,6, 2,7, 3,3, 4,1, 4,2, 9,9 };
unsigned char letters_82[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,4, 2,1, 2,4, 2,5, 3,1, 3,4, 3,6, 4,2, 4,3, 4,7, 9,9 };
unsigned char letters_79[] = { 0,2, 0,3, 0,4, 0,5, 0,6, 1,1, 1,7, 2,1, 2,7, 3,2, 3,3, 3,4, 3,5, 3,6, 9,9 };
unsigned char letters_33[] = { 1,1, 1,2, 1,3, 1,4, 1,5, 1,7, 9,9 };
unsigned char letters_65[] = { 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,4, 2,1, 2,4, 3,2, 3,3, 3,4, 3,5, 3,6, 3,7, 9,9 };
unsigned char letters_87[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,6, 2,5, 3,6, 4,1, 4,2, 4,3, 4,4, 4,5, 4,6, 4,7, 9,9 };
unsigned char letters_69[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,4, 3,7, 9,9 };
unsigned char letters_80[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,4, 2,1, 2,4, 3,2, 3,3, 9,9 };
unsigned char letters_50[] = { 0,2, 0,5, 0,6, 0,7, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,4, 3,7, 4,2, 4,3, 4,7, 9,9 };
unsigned char letters_49[] = { 1,2, 1,7, 2,1, 2,2, 2,3, 2,4, 2,5, 2,6, 2,7, 3,7, 9,9 };
unsigned char letters_74[] = { 0,7, 1,1, 1,7, 2,1, 2,2, 2,3, 2,4, 2,5, 2,6, 3,1, 9,9 };
unsigned char letters_68[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,7, 2,1, 2,7, 3,2, 3,3, 3,4, 3,5, 3,6, 9,9 };
unsigned char letters_90[] = { 0,1, 0,6, 0,7, 1,1, 1,5, 1,7, 2,1, 2,4, 2,7, 3,1, 3,3, 3,7, 4,1, 4,2, 4,7, 9,9 };
unsigned char letters_70[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,4, 2,1, 2,4, 3,1, 3,4, 9,9 };
unsigned char letters_88[] = { 0,1, 0,2, 0,6, 0,7, 1,3, 1,5, 2,4, 3,3, 3,5, 4,1, 4,2, 4,6, 4,7, 9,9 };
unsigned char letters_75[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,4, 2,3, 2,5, 3,1, 3,2, 3,6, 3,7, 9,9 };
unsigned char letters_53[] = { 0,1, 0,2, 0,3, 0,4, 0,7, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,4, 3,7, 4,1, 4,5, 4,6, 9,9 };
unsigned char letters_48[] = { 0,2, 0,3, 0,4, 0,5, 0,6, 1,1, 1,7, 2,1, 2,7, 3,1, 3,7, 4,2, 4,3, 4,4, 4,5, 4,6, 9,9 };
unsigned char letters_77[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,2, 2,3, 3,2, 4,1, 4,2, 4,3, 4,4, 4,5, 4,6, 4,7, 9,9 };
unsigned char letters_54[] = { 0,2, 0,3, 0,4, 0,5, 0,6, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,4, 3,7, 4,2, 4,5, 4,6, 9,9 };
unsigned char letters_39[] = { 1,3, 2,1, 2,2, 9,9 };
unsigned char letters_85[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 1,7, 2,7, 3,1, 3,2, 3,3, 3,4, 3,5, 3,6, 9,9 };
unsigned char letters_57[] = { 0,2, 0,3, 0,7, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,4, 3,7, 4,2, 4,3, 4,4, 4,5, 4,6, 9,9 };
unsigned char letters_78[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,2, 2,3, 3,4, 4,1, 4,2, 4,3, 4,4, 4,5, 4,6, 4,7, 9,9 };
unsigned char letters_84[] = { 0,1, 1,1, 1,2, 1,3, 1,4, 1,5, 1,6, 1,7, 2,1, 9,9 };
unsigned char letters_81[] = { 0,2, 0,3, 0,4, 0,5, 0,6, 1,1, 1,7, 2,1, 2,5, 2,7, 3,1, 3,6, 4,2, 4,3, 4,4, 4,5, 4,7, 9,9 };
unsigned char letters_51[] = { 0,2, 0,6, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,4, 3,7, 4,2, 4,3, 4,5, 4,6, 9,9 };
unsigned char letters_86[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 1,6, 2,7, 3,6, 4,1, 4,2, 4,3, 4,4, 4,5, 9,9 };
unsigned char letters_72[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,4, 2,4, 3,1, 3,2, 3,3, 3,4, 3,5, 3,6, 3,7, 9,9 };
unsigned char letters_73[] = { 0,1, 0,7, 1,1, 1,2, 1,3, 1,4, 1,5, 1,6, 1,7, 2,1, 2,7, 9,9 };
unsigned char letters_44[] = { 1,7, 2,5, 2,6, 9,9 };
unsigned char letters_56[] = { 0,2, 0,3, 0,5, 0,6, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,1, 3,4, 3,7, 4,2, 4,3, 4,5, 4,6, 9,9 };
unsigned char letters_66[] = { 0,1, 0,2, 0,3, 0,4, 0,5, 0,6, 0,7, 1,1, 1,4, 1,7, 2,1, 2,4, 2,7, 3,2, 3,3, 3,5, 3,6, 9,9 };
unsigned char letters_52[] = { 0,4, 0,5, 1,3, 1,5, 2,2, 2,5, 3,1, 3,2, 3,3, 3,4, 3,5, 3,6, 3,7, 4,5, 9,9 };
unsigned char letters_55[] = { 0,1, 1,1, 2,1, 2,5, 2,6, 2,7, 3,1, 3,3, 3,4, 4,1, 4,2, 9,9 };

void * font[] = {  &letters_33 /*!*/,  0,  0,  0,  0,  0,  &letters_39 /*'*/,  0,  0,  0,  0,  &letters_44 /*,*/,  0,  0,  0,  
&letters_48 /*0*/,  &letters_49 /*1*/,  &letters_50 /*2*/,  &letters_51 /*3*/,  &letters_52 /*4*/,  &letters_53 /*5*/,  
&letters_54 /*6*/,  &letters_55 /*7*/,  &letters_56 /*8*/,  &letters_57 /*9*/,  0,  0,  0,  0,  0,  0,  0,  &letters_65 /*A*/,  
&letters_66 /*B*/,  &letters_67 /*C*/,  &letters_68 /*D*/,  &letters_69 /*E*/,  &letters_70 /*F*/,  &letters_71 /*G*/,  
&letters_72 /*H*/,  &letters_73 /*I*/,  &letters_74 /*J*/,  &letters_75 /*K*/,  &letters_76 /*L*/,  &letters_77 /*M*/,  
&letters_78 /*N*/,  &letters_79 /*O*/,  &letters_80 /*P*/,  &letters_81 /*Q*/,  &letters_82 /*R*/,  &letters_83 /*S*/,  
&letters_84 /*T*/,  &letters_85 /*U*/,  &letters_86 /*V*/,  &letters_87 /*W*/,  &letters_88 /*X*/,  &letters_89 /*Y*/,  
&letters_90 /*Z*/
};


unsigned short int fontMin=33;
unsigned short int fontMax=90;

/* -----------------------------------------------------------------  */
/** Draws a figure (0-9). You should call it with set=1, 
 * wait a little them call it again with set=0
 * @param figure is the figure [0-9]
 * @param x,y coordinates, 
 * @param set is 1 or 0 to draw or clear it
 */
unsigned char Font::Draw(unsigned short int letter,int x,int y,int set) {
  unsigned short int maxx=0;
  unsigned char* character;
  if (letter==' ') return 3+2;
  if (letter<fontMin || letter>fontMax) {
    return 0;
  }

     character = (unsigned char*)font[letter-fontMin];

  int i=0;
  while (character[i]!=9) {
    if (character[i]>maxx) maxx=character[i];
    if (
     character[i  ]+ x <=13 && 
     character[i  ]+ x >=0 && 
     character[i+1]+ y <=8 && 
     character[i+1]+ y >=0
    ) {
        LedSign::Set(character[i]+x, character[i+1]+y, set);
    } 
    i+=2;
  }
  return maxx+2;
}


/* -----------------------------------------------------------------  */
/** Draw a figure in the other direction (rotated 90°)
 * You should call it with set=1, 
 * wait a little them call it again with set=0
 * @param figure is the figure [0-9]
 * @param x,y coordinates, 
 * @param set is 1 or 0 to draw or clear it
*/
unsigned char Font::Draw90(unsigned short int letter,int x,int y,int set) {
  if (letter<fontMin || letter>fontMax) {
    return 0;
  }
  unsigned char* character = (unsigned char*)font[letter-fontMin];

  int i=0;
  while (character[i]!=9) {
    if (
     character[i  ]+ x <=13 && 
     character[i  ]+ x >=0 && 
     character[i+1]+ y <=8 && 
     character[i+1]+ y >=0
    ) {
        LedSign::Set(character[i]+x, character[i+1]+y, set);
    } 
    i+=2;
  }

}