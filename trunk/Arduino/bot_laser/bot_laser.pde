#include <SoftwareServo.h>
SoftwareServo myservo;
SoftwareServo myservo2;
void setup()
{
  myservo.attach(11);  // atribui o servo no pino 5 para o objeto servo
  myservo2.attach(10);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  digitalWrite(12,255);
 

}
float s1pos = 0;
float s2pos = 0;
void moveBase(float ang)
{
   if (s1pos < ang)
  {
    for(float posicao = s1pos; posicao < ang; posicao +=.5)
      {
         myservo.write(posicao); // seta a posição do servo de acordo com o valor da escala
         delay(15);
         SoftwareServo::refresh();
      } 
  }else{
     for(float posicao = s1pos; posicao > ang; posicao -=.5)
      {
         myservo.write(posicao); // seta a posição do servo de acordo com o valor da escala
         delay(15);
         SoftwareServo::refresh();
      } 
  }
 s1pos = ang; 
}

void moveLaser(float ang)
{
  
  if (s2pos < ang)
  {
    for(float posicao = s2pos; posicao < ang; posicao +=.5)
      {
         myservo2.write(posicao); // seta a posição do servo de acordo com o valor da escala
         delay(15);
         SoftwareServo::refresh();
      } 
  }else{
     for(float posicao = s2pos; posicao > ang; posicao -=.5)
      {
         myservo2.write(posicao); // seta a posição do servo de acordo com o valor da escala
         delay(15);
         SoftwareServo::refresh();
      } 
  } 
  
  s2pos = ang;
}

void loop()
{
        /*digitalWrite(13,255);
        for(float posicao = 0; posicao < 10; posicao +=1)
        {
        myservo.write(0); // seta a posição do servo de acordo com o valor da escala
        delay(50);
        
        }
        SoftwareServo::refresh();
        delay(2000);
         for(float posicao = 0; posicao < 10; posicao +=.5)
        {
        myservo2.write(0); // seta a posição do servo de acordo com o valor da escala
        delay(50);
        
        }
      SoftwareServo::refresh();
        delay(1000);
        digitalWrite(13,0);    
       delay(1000); */
    moveLaser(10);
    moveBase(10); 
   delay(1000); 
    moveLaser(120);
    moveBase(80); 
    moveLaser(120);
    moveBase(80); 
    delay(1000);
    moveLaser(110);
    moveBase(76);
    delay(1000);
    moveLaser(118);
    delay(1000);
    moveBase(70);
    delay(1000);
    moveBase(64);
    delay(1000);
    moveLaser(110);
    delay(1000);
     moveLaser(120);
    moveBase(80); 
    delay(60000);
}
