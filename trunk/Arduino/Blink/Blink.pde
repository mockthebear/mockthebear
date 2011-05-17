#include "pitches.h"
void tocar(int nota,int durat){
   tone(13, nota,1000/durat);
   delay((1000/durat) * 1.30);
   noTone(13);
}
void setup() {
  Serial.begin(9600);
  for(int pin=0;pin>=13;pin+=1)
  {
      pinMode(pin, OUTPUT); 
  }
  tocar(NOTE_A7,3);
  delay(500);
  tocar(NOTE_D6,10);
  tocar(NOTE_A7,8);
  tocar(NOTE_D8,8);
}
void turnOff(int strat,int finish){
  analogWrite(strat, LOW);
  for(int pin = strat ; pin >= finish; pin -=1) {
    analogWrite(pin, LOW);                        
  }
}
void checkSensor(){
    int photocellReading = analogRead(0);
    int calor = analogRead(5);    
    Serial.println(calor, DEC);
    analogWrite(9,calor);
    analogWrite(10,255-calor);
    if (photocellReading > 30)
    {
      analogWrite(1, 255);
      if (photocellReading > 90)
      {
          analogWrite(2, 255);
         if (photocellReading > 140)
          {
            analogWrite(3, 255);
            if (photocellReading > 230)
            {
              analogWrite(4, 255);
              if (photocellReading > 290)
              {
                analogWrite(5, 255);
                if (photocellReading > 400)
                {
                  analogWrite(6, 255);
                  tocar(NOTE_A7,20);
                }else{
                  turnOff(6,6);
                }
              }else{
               turnOff(6,5);
              }
            }else{
             turnOff(6,4);
            }
          }else{
           turnOff(6,3);
          }
      }else{
       turnOff(6,2);
      }
    }else{
     turnOff(6,1);
    }
}
void loop()  {
 for(int fadeValue = 0 ; fadeValue <= 255; fadeValue +=1) {
    analogWrite(11, fadeValue);
    analogWrite(12, 255-fadeValue);  
    
    checkSensor();   
    delay(10);                            
  }
  for(int fadeValue = 255 ; fadeValue >= 0; fadeValue -=1) {
    analogWrite(11, fadeValue);
    analogWrite(12, 255-fadeValue);   

    checkSensor(); 
    delay(10);                            
  }
  
  
}
