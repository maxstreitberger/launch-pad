#include "display_output.h"

#include <SPI.h>
#include <LoRa.h>

#define SCK 5
#define MISO 19
#define MOSI 27
#define SS 18
#define RST 14
#define DIO0 26

unsigned long currentMillis;
unsigned long previousTime = 0;
const int intervalButton = 50;

//Start Button
int sButton = 35;
int previousSBState = LOW;
unsigned long minSBLongPressDuration = 1000;
unsigned long sBLongPressMillis;
unsigned long previousSBMillis;
bool sBStateLongPress = false;
unsigned long sBPressDuration;

//Hold Button
int hButton = 23;
int previousHBState = LOW;
int hold_count = 0;
int resumeCountdown = 1;
unsigned long previousHBMillis;

//Countdown
int currentSecond = 0;
int previousSecond = 0;
int countdown_time = 10;
boolean countdown_started = false;
boolean countdown_holded = false;

enum state {
  standBy,
  hold,
  countdown,
  go
};

state current_state = standBy;

unsigned int counter = 0;
String activateSleeperCell = "Launch";

void setup() {
  Serial.begin(115200);
  pinMode(sButton, INPUT);
  pinMode(hButton, INPUT);

  pinMode(latchPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  pinMode(clockPin, OUTPUT);

  for (int x=0; x<4; x++){
      pinMode(controlDigits[x],OUTPUT);
      digitalWrite(controlDigits[x],LOW); 
  }

  SPI.begin(SCK, MISO, MOSI, SS);
  LoRa.setPins(SS, RST, DIO0);
  
  if (!LoRa.begin(866E6)) {
    Serial.println("Couldn't start LoRa!");
    while (1);
  }
  LoRa.setSyncWord(0xF3);
}

void ReadStartButton() {
  if (currentMillis - previousSBMillis > intervalButton) {
    int sBState = digitalRead(sButton);

    if (sBState == HIGH && previousSBState == LOW && !sBStateLongPress) {
      sBLongPressMillis = currentMillis;
      previousSBState = HIGH;
    }

    sBPressDuration = currentMillis - sBLongPressMillis;

    if (sBState == HIGH && !sBStateLongPress && sBPressDuration >= minSBLongPressDuration) {
      sBStateLongPress = true;
      countdown_started = false;
      countdown_holded = false;
      currentSecond = 0;
      previousSecond = 0;
      countdown_time = 10;
      Serial.println("Countdown reseted");
      current_state = standBy;
    }

    if (sBState == LOW && previousSBState == HIGH) {
      previousSBState = LOW;
      sBStateLongPress = false;

      if (sBPressDuration < minSBLongPressDuration) {
        if (!countdown_started) {
          previousTime = currentMillis;
          previousSecond = 0;
          currentSecond = 0;
          countdown_started = true;
          Serial.println("Start Countdown");
          current_state = countdown;
        }
      }
    }

    previousSBMillis = currentMillis;
  }
}

void ReadHoldButton() {
  if (currentMillis - previousHBMillis > intervalButton) {
    int hBState = digitalRead(hButton);

    if (hBState != previousHBState) {
      if (hold_count == 1 && hBState == 0) {
        resumeCountdown = 1;
        hold_count = 0;

        Serial.println("Countdown continue");
        previousTime = currentMillis;
        previousSecond = 0;
        currentSecond = 0;  
        countdown_holded = false;
        current_state = countdown;
      } else if (resumeCountdown == 1 && hBState == 0) {
        resumeCountdown = 0;
        hold_count = 1;          
        current_state = hold;
        countdown_holded = true;
      }
    }   
    
    previousHBState = hBState;
    previousHBMillis = currentMillis;
  }
}

void sendLaunchSignal() {
  LoRa.beginPacket();
  LoRa.print("Launch");
  LoRa.endPacket();
}

void loop() {
  currentMillis = millis();
  
  ReadStartButton();  
  ReadHoldButton();

  if (countdown_started && !countdown_holded) {
    currentSecond = (currentMillis - previousTime)/1000;
    if (currentSecond != previousSecond) {      
      previousSecond++;
      countdown_time--;
      Serial.println(countdown_time * (-1));

      if (countdown_time == 0) {
        current_state = go;
        Serial.println("Launch!!!");
        sendLaunchSignal();
      }
    }
  }

  switch (current_state) {
    case standBy:
      display_stand_by();
      break;
    case hold:
      display_hold();
      break;
    case countdown:
      if (countdown_time == 10) {
        display_number_ten();
      } else if (countdown_time >= 0) {
        display_number(countdown_time);
      }
      break;
    case go:
      display_go();
      break;
   }
 }
