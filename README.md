# Launch Pad
## Description
This project is about creating a self-leveling model-rocket launchpad, which levels itself according to its gyroscope data. We also built our own weather station in order to measure the wind speed and direction as well as other basic information about the weather. This information helps us to position the launch pad correctly to achieve a higher altitude and a better flight path. The launch of the rocket (the ignition of its motors) from the launchpad shall be controllable with a custom-built remote-controller. After the rocket has been launched we receive live-data from the rocket, which is then processed and plotted onto a self-designed flight data dashbaord and stored in a time series database. All the communication between the different microcontrollers (launch pad, rocket, remote controller, and control desk) is based on the LoRa protocol.

## Setup
Hardware Requirements (Alternative parts may also apply):

Launch Pad:
- [ESP-32 with integrated LoRa](https://www.banggood.com/2Pcs-LILYGO-TTGO-LORA32-868Mhz-ESP32-LoRa-OLED-0_96-Inch-Blue-Display-bluetooth-WIFI-ESP-32-Development-Board-Module-With-Antenna-p-1507044.html?cur_warehouse=CN&rmmds=search)
- [3 Servos (We used MG996R)](https://www.amazon.de/Innovateking-EU-Transmission-Digital-Helicopter-Aeroplane/dp/B07JN7F9VY/ref=sr_1_1_sspa?crid=1F0H3ODMIICBQ&dchild=1&keywords=mg996r&qid=1619709898&sprefix=mg996%2Caps%2C169&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUFZWTJQSk8wM1JXTlEmZW5jcnlwdGVkSWQ9QTAwODMyNzIzTTdSWTg4NVFIQ1QxJmVuY3J5cHRlZEFkSWQ9QTAwNzQ1MjgzTklGRkhIVzJOWDRKJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==)
- [MPU6050 (Gryoscope + Accelerometer)](https://www.conrad.de/de/p/joy-it-mpu6050-beschleunigungs-sensor-1-st-passend-fuer-micro-bit-arduino-raspberry-pi-rock-pi-banana-pi-c-contro-2136256.html?hk=SEM&WT.srch=1&WT.mc_id=google_pla&s_kwcid=AL%2521222%25213%2521367270211499%2521%2521%2521g%2521%2521&ef_id=Cj0KCQjwo-aCBhC-ARIsAAkNQiusB49lNVCzrsqvmrv-dKNzPxioAxWXFdyhico_4f4Yvt2M8tDl9ZQaAlD6EALw_wcB%253AG%253As&gclid=Cj0KCQjwo-aCBhC-ARIsAAkNQiusB49lNVCzrsqvmrv-dKNzPxioAxWXFdyhico_4f4Yvt2M8tDl9ZQaAlD6EALw_wcB)
- Optional: [Servo shield](https://www.amazon.de/-/en/PCA9685-Channel-Interface-Arduino-Raspberry/dp/B07V72VBJ4/ref=sr_1_4?dchild=1&keywords=PCA9685&qid=1619610045&sr=8-4)
- Three AA batteries

Remote Controller
- [ESP-32 with integrated LoRa](https://www.banggood.com/2Pcs-LILYGO-TTGO-LORA32-868Mhz-ESP32-LoRa-OLED-0_96-Inch-Blue-Display-bluetooth-WIFI-ESP-32-Development-Board-Module-With-Antenna-p-1507044.html?cur_warehouse=CN&rmmds=search)
- [4 digit 7 segment display](https://www.roboter-bausatz.de/p/7-segment-display-4-bit-rot-common-cathode-0.36?gclid=Cj0KCQjwsqmEBhDiARIsANV8H3ZjFT1WBNwSy5bRYxXno2hlEszbc3IDbLLUHH_9ZXWZMJglZA527XYaAlq9EALw_wcB)
- [Shift register (SN74HC595N)](https://www.reichelt.de/de/de/shift-register-8-bit-2--6-v-dil-16-sn-74hc595n-tex-p217325.html?PROVID=2788&gclid=Cj0KCQjwsqmEBhDiARIsANV8H3YNDYnfIHeven0ALQ13Z9IWChzlGg01CufOiB7iIWOJaNoySs7t_3kaAkKWEALw_wcB&&r=1)
- [Two push buttons](https://www.conrad.de/de/p/tru-components-gq-16f-n-vandalismusgeschuetzter-drucktaster-48-v-dc-2-a-1-x-aus-ein-ip65-tastend-1-st-701274.html)
- Four PN2222 transistors
- Two 10K-ohm resistors
- Four 5K-ohm resistors
- 9V battery

### Software Requirements:
- Arduino IDE

**Setup the ESP-32 board:**
1. In the Arduino IDE open preferences
2. Add https://dl.espressif.com/dl/package_esp32_index.json into the “Additional Board Manager URLs” field
3. Open the Boards Manager and add **ESP32 by Espressif Systems**

**Required Libraries:**
- https://github.com/PaulStoffregen/Encoder
- https://github.com/adafruit/Adafruit-PWM-Servo-Driver-Library
- https://github.com/sandeepmistry/arduino-LoRa


### Dependencies






