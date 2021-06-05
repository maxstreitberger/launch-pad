/* Encoder Library - * http://www.pjrc.com/teensy/td_libs_Encoder.html */

#include <Encoder.h>

Encoder rotEncoder(14, 15);

//Rotary "position" (counts up if moved to the right and down if moved to the left, no min and max)
long rotPos, newRotPos;

//Integer containing the actual angle (min 0, max 360)
int rotAngle  = 1;

void setup() {
  Serial.begin(9600);
  Serial.println("Rotary Encoder ready:");
}

void loop() {

  //Read the position of the encoder
  newRotPos = rotEncoder.read();
  
  //Only record full steps (one full step results in a position change of 4 by default) 
  if((newRotPos - rotPos) == 4 || (newRotPos - rotPos) == -4){
    
    //If a full revolution was made or the angle would fall below zero, set it to 0 or 360 respectively
    if(rotAngle >= 360){rotAngle = 0;}
    else if (rotAngle <= 0){rotAngle = 359;}
      
    //Increase or decrease the angle by 18 degrees per full step (20 steps per full revolution)
    if(rotPos < newRotPos){
      rotAngle -= 18;
    }
    else if (rotPos > newRotPos){
      rotAngle += 18;
    }
    //Update the rotary position to make it ready for new comparisons
    rotPos = newRotPos;
    
    Serial.print("Angle = ");
    Serial.print(rotAngle);
    Serial.println();   
  }
}
