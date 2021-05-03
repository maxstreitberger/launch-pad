//Principles are clear and basic functionality is implemented but code could not be tested  in real life due to printing problems


const int hall_Sensor=2;
int inputVal = 0;

void setup() 
{                
  pinMode(13, OUTPUT);          // LED on Arduino boards:  
  pinMode(hall_Sensor,INPUT);    //Pin 2 is connected to the output of proximity sensor
  Serial.begin(9600);
}

void loop() 
{
  if(digitalRead(hall_Sensor)==HIGH)      //Check the sensor output
  {
    digitalWrite(13, HIGH);   // set the LED on
  }
  else
  {
    digitalWrite(13, LOW);    // set the LED off
  }
inputVal = digitalRead(hall_Sensor);
Serial.println(inputVal);
delay(1000);              // wait for a second
}
