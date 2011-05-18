#include <SoftwareServo.h>
SoftwareServo myservo;
SoftwareServo myservo2;

void setup()
{
  myservo.attach(11); 
  myservo2.attach(10);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  digitalWrite(12,255);
}
float s1pos = 0;
float s2pos = 0;
void move(float ang,int servo)
{
   if (s1pos < ang)
  {
    for(float posicao = s1pos; posicao < ang; posicao +=.5)
      {
         if (servo == 1){myservo.write(posicao);}else{myservo2.write(posicao);}
         delay(15);
         SoftwareServo::refresh();
      } 
  }else{
     for(float posicao = s1pos; posicao > ang; posicao -=.5)
      {
         if (servo == 1){myservo.write(posicao);}else{myservo2.write(posicao);}
         delay(15);
         SoftwareServo::refresh();
      } 
  }
 s1pos = ang; 
}

void loop()
{
   move(10,2);
   move(10,1); 
   delay(1000); 
   move(120,2);
   move(80,1); 
   move(120,2);
   move(80,1); 
   delay(1000);
   move(110,2);
   move(76,1);
   delay(1000);
   move(118,2);
   delay(1000);
   move(70,1);
   delay(1000);
   move(64,1);
   delay(1000);
   move(110,2);
   delay(1000);
   move(120,2);
   move(80,1); 
   delay(60000);
}
