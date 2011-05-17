#include <Servo.h>
Servo myservo; 

void setup() {
  myservo.attach(9);

  Serial.begin(9600);
}
int last = 0;
void loop()  {
 int qqq = analogRead(5); 
 int now = map(qqq, 10, 690, 0, 180);
 if (now>last)
 {
   last = last+1;
   myservo.write(last);
 }else if(now<last){
   last = last-1;
   myservo.write(last);
}
delay(1);   

 

}
