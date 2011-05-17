#include <SoftwareServo.h>
SoftwareServo myservo;
SoftwareServo myservo2;// cria o objeto servo para controlar um servo
int val;    // variavel para ler o valor do pino analógico
void setup()
{
  myservo.attach(11);  // atribui o servo no pino 5 para o objeto servo
  myservo2.attach(10);

 pinMode(12, OUTPUT);
   digitalWrite(13,255);
  delay(1000);
  
   digitalWrite(13,0);
  digitalWrite(12,255);
}
int pos = 0;
void loop()
{
  int valq = analogRead(0); // lê o valor do potenciômetro (valor entre 0 e 1023)
  valq = map(valq, 0, 1023, 0, 179); // escala os valores para serem usado com o servo (valores entre 0 e 180)

    myservo.write(valq); // seta a posição do servo de acordo com o valor da escala
    delay(15);

  if (analogRead(4) > 100)
  {
    pos = pos+2;
    if (pos > 179){ pos = 179;}
    myservo2.write(pos);
    delay(15);
 }else if(analogRead(5) > 100){
    pos = pos-2;
    if (pos < 0){ pos = 0;}
    myservo2.write(pos);
    delay(15);
    //Serial.print(analogRead(2));
 //    Serial.print('-');
 //   Serial.println(pos);
}
  
  

  SoftwareServo::refresh();
}
