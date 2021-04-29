const int dataPin  = 16; 
const int latchPin = 17;  
const int clockPin = 4;  

const int digit_0 = 21;
const int digit_1 = 13;
const int digit_2 = 12;
const int digit_3 = 25;

byte controlDigits[] = { digit_0, digit_1, digit_2, digit_3 };
byte digits[11] = {
                          B00111111,
                          B00000110,
                          B01011011,
                          B01001111,
                          B01100110,
                          B01101101,
                          B01111101,
                          B00000111,
                          B01111111,
                          B01101111,
                          B00000000
};

byte stand_by_word[4] = {
                      B01101101,
                      B01111000,
                      B01111100,
                      B01101110
};

byte hold_word[4] = {
                      B01110110,
                      B00111111,
                      B00111000,
                      B01011110
};

byte go_word[2] = {
                      B01111101,
                      B00111111
};

byte minus = B01000000;

void display_stand_by() {
  for (int x = 0; x < 4; x++) {
    for (int y = 0; y < 4; y++) {
      digitalWrite(controlDigits[y], LOW); 
    }
    
    digitalWrite(latchPin, 0);
    shiftOut(dataPin, clockPin, MSBFIRST, stand_by_word[x]);
    digitalWrite(latchPin, 1);

    digitalWrite(controlDigits[x], HIGH);  

    delay(1);
  }

  for (int y = 0; y < 4; y++) {
    digitalWrite(controlDigits[y],LOW); 
  }
}

void display_hold() {
  for (int x = 0; x < 4; x++) {
    for (int y = 0; y < 4; y++) {
      digitalWrite(controlDigits[y], LOW); 
    }
    
    digitalWrite(latchPin, 0);
    shiftOut(dataPin, clockPin, MSBFIRST, hold_word[x]);
    digitalWrite(latchPin, 1);

    digitalWrite(controlDigits[x], HIGH);  

    delay(1);
  }

  for (int y = 0; y < 4; y++) {
    digitalWrite(controlDigits[y],LOW); 
  }
}

void display_go() {
  for (int x = 0; x < 2; x++) {
    for (int y = 0; y < 4; y++) {
      digitalWrite(controlDigits[y], LOW); 
    }

    digitalWrite(latchPin, 0);
    shiftOut(dataPin, clockPin, MSBFIRST, go_word[x]);
    digitalWrite(latchPin, 1);

    digitalWrite(controlDigits[x], HIGH);  

    delay(1);
  }

  for (int y = 0; y < 4; y++) {
    digitalWrite(controlDigits[y],LOW); 
  }
}

void display_number_ten() {
  int counter = 0;
  for (int x = 3; x > 0; x--) {
    for (int y = 0; y < 4; y++) {
      digitalWrite(controlDigits[y], LOW); 
    }
    
    if (x == 1) {
      digitalWrite(latchPin, 0);
      shiftOut(dataPin, clockPin, MSBFIRST, minus);
      digitalWrite(latchPin, 1);
  
      digitalWrite(controlDigits[x], HIGH); 
    } else {
      digitalWrite(latchPin, 0);
      shiftOut(dataPin, clockPin, MSBFIRST, digits[counter]);
      digitalWrite(latchPin, 1);
  
      digitalWrite(controlDigits[x], HIGH); 
  
      counter++;  
    }
    
    delay(1);
  }

  for (int y = 0; y < 4; y++) {
    digitalWrite(controlDigits[y],LOW); 
  }
  
  counter = 0;
}

void display_number(int num) {
  for (int x = 3; x > 1; x--) {
    for (int y = 0; y < 4; y++) {
      digitalWrite(controlDigits[y], LOW); 
    }
    
    if (x == 2) {
      digitalWrite(latchPin, 0);
      shiftOut(dataPin, clockPin, MSBFIRST, minus);
      digitalWrite(latchPin, 1);
  
      digitalWrite(controlDigits[x], HIGH); 
    } else {
      digitalWrite(latchPin, 0);
      shiftOut(dataPin, clockPin, MSBFIRST, digits[num]);
      digitalWrite(latchPin, 1);
  
      digitalWrite(controlDigits[x], HIGH); 
     }
    
    delay(1);
  }

  for (int y = 0; y < 4; y++) {
    digitalWrite(controlDigits[y],LOW); 
  }
}

/*void display_number(int num) {  
  for (int y = 0; y < 4; y++) {
    digitalWrite(controlDigits[y], LOW); 
  }
  
  digitalWrite(latchPin, 0);
  shiftOut(dataPin, clockPin, MSBFIRST, digits[num]);
  digitalWrite(latchPin, 1);

  digitalWrite(controlDigits[3], HIGH);
 
  delay(1);

  for (int y = 0; y < 4; y++) {
    digitalWrite(controlDigits[y],LOW); 
  }
}*/
