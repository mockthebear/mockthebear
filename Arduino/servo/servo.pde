#include <Servo.h>
 
Servo myservo; 
Servo myservo2;

void setup()
{
  myservo.attach(9);
  myservo2.attach(10);
}
 
 int ang = 180;
void loop()
{ 
    myservo.write(ang);          
    delay(1000);                
    myservo.write(0);
    delay(1000);  

}
