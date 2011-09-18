#include <Servo.h>
 
Servo servo1; 

void setup() {                
  Serial.begin(9600);
  servo1.attach(9);
}
int position_ = 160;
void loop() {
  if (Serial.available() > 0) {
    position_ = Serial.read(); 
   Serial.print(position_);
  }
  servo1.write(position_); 
  delay(100);
}
  

