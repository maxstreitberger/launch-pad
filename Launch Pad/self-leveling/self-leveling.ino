// This code is based on: https://www.cc.gatech.edu/classes/AY2013/cs3651_summer/projects/self-leveling-platform/index.html

#include <Wire.h>
#include "Kalman.h" // Source: https://github.com/TKJElectronics/KalmanFilter
#include <Adafruit_PWMServoDriver.h>

int SERVOMIN_1 = 74; 
int SERVOMAX_1 = 437;

int SERVOMIN_2 = 77;
int SERVOMAX_2 = 439;

int SERVOMIN_3 = 77;
int SERVOMAX_3 = 445;

double val;
int pos = 0;

Kalman kalmanX; // Create the Kalman instances
Kalman kalmanY;

/* IMU Data */
int16_t accX, accY, accZ;
int16_t tempRaw;
int16_t gyroX, gyroY, gyroZ;

double accXangle, accYangle; // Angle calculate using the accelerometer
double temp; // Temperature
double gyroXangle, gyroYangle; // Angle calculate using the gyro
double compAngleX, compAngleY; // Calculate the angle using a complementary filter
double kalAngleX, kalAngleY; // Calculate the angle using a Kalman filter

uint32_t timer;
uint8_t i2cData[14]; // Buffer for I2C data

Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();

void setup() {  
  Serial.begin(115200);
  Wire.begin();
  
  i2cData[0] = 7; // Set the sample rate to 1000Hz - 8kHz/(7+1) = 1000Hz
  i2cData[1] = 0x00; // Disable FSYNC and set 260 Hz Acc filtering, 256 Hz Gyro filtering, 8 KHz sampling
  i2cData[2] = 0x00; // Set Gyro Full Scale Range to ±250deg/s
  i2cData[3] = 0x00; // Set Accelerometer Full Scale Range to ±2g
  while(i2cWrite(0x19,i2cData,4,false)); // Write to all four registers at once
  while(i2cWrite(0x6B,0x01,true)); // PLL with X axis gyroscope reference and disable sleep mode 
  
  while(i2cRead(0x75,i2cData,1));
  if(i2cData[0] != 0x68) { // Read "WHO_AM_I" register
    Serial.print(F("Error reading sensor"));
    while(1);}
    
  pwm.begin();
  pwm.setPWMFreq(50);
  pwm.setPWM(0, 0, map(0, 0, 180, SERVOMIN_1, SERVOMAX_1));
  pwm.setPWM(1, 0, map(0, 0, 180, SERVOMIN_2, SERVOMAX_2));
  pwm.setPWM(2, 0, map(0, 0, 180, SERVOMIN_3, SERVOMAX_3));
  //pinMode(13, OUTPUT); 
    
 delay(100); // Wait for sensor to stabilize
  
  /* Set kalman and gyro starting angle */
  while(i2cRead(0x3B,i2cData,6));
  accX = ((i2cData[0] << 8) | i2cData[1]);
  accY = ((i2cData[2] << 8) | i2cData[3]);
  accZ = ((i2cData[4] << 8) | i2cData[5]);
  // atan2 outputs the value of -π to π (radians) - see http://en.wikipedia.org/wiki/Atan2
  // We then convert it to 0 to 2π and then from radians to degrees
  accYangle = (atan2(accX,accZ)+PI)*RAD_TO_DEG;
  accXangle = (atan2(accY,accZ)+PI)*RAD_TO_DEG;
  
  kalmanX.setAngle(accXangle); // Set starting angle
  kalmanY.setAngle(accYangle);
  gyroXangle = accXangle;
  gyroYangle = accYangle;
  compAngleX = accXangle;
  compAngleY = accYangle;
  
  timer = micros();
}

void loop() {
  /* Update all the values */  
  while(i2cRead(0x3B,i2cData,14));
  accX = ((i2cData[0] << 8) | i2cData[1]);
  accY = ((i2cData[2] << 8) | i2cData[3]);
  accZ = ((i2cData[4] << 8) | i2cData[5]);
  tempRaw = ((i2cData[6] << 8) | i2cData[7]);  
  gyroX = ((i2cData[8] << 8) | i2cData[9]);
  gyroY = ((i2cData[10] << 8) | i2cData[11]);
  gyroZ = ((i2cData[12] << 8) | i2cData[13]);
  
  // atan2 outputs the value of -π to π (radians) - see http://en.wikipedia.org/wiki/Atan2
  // We then convert it to 0 to 2π and then from radians to degrees
  accXangle = (atan2(accY,accZ)+PI)*RAD_TO_DEG;
  //Serial.println(accXangle);
  accYangle = (atan2(accX,accZ)+PI)*RAD_TO_DEG;
  
  double gyroXrate = (double)gyroX/131.0;
  double gyroYrate = -((double)gyroY/131.0);
  //gyroXangle += gyroXrate*((double)(micros()-timer)/1000000); // Calculate gyro angle without any filter  
  //gyroYangle += gyroYrate*((double)(micros()-timer)/1000000);
  //gyroXangle += kalmanX.getRate()*((double)(micros()-timer)/1000000); // Calculate gyro angle using the unbiased rate
  //gyroYangle += kalmanY.getRate()*((double)(micros()-timer)/1000000);
  
  compAngleX = (0.98*(compAngleX+(gyroXrate*(double)(micros()-timer)/1000000)))+(0.02*accXangle); // Calculate the angle using a Complimentary filter
  compAngleY = (0.98*(compAngleY+(gyroYrate*(double)(micros()-timer)/1000000)))+(0.02*accYangle);
  
  kalAngleX = kalmanX.getAngle(accXangle, gyroXrate, (double)(micros()-timer)/1000000); // Calculate the angle using a Kalman filter
  kalAngleY = kalmanY.getAngle(accYangle, gyroYrate, (double)(micros()-timer)/1000000);
  timer = micros();
 
  pwm.setPWM(0, 0, map(compAngleY-90, 50, 150, SERVOMIN_1, SERVOMAX_1));
  pwm.setPWM(1, 0, map(compAngleX-90, 50, 150, SERVOMIN_2, SERVOMAX_2));
  pwm.setPWM(2, 0, map(compAngleX-90, 50, 150, SERVOMIN_3, SERVOMAX_3));

  Serial.println("Complimentary:");
  Serial.println(compAngleX-90);
  Serial.println(compAngleY-90);
  Serial.print("\r\n");
  delay(1);
}
