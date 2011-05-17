
 int lmed = 0;
 int rmed = 0;
 int TM = 0;
void setup()
{
 Serial.begin(9600);
 pinMode(9, OUTPUT);
 pinMode(10, OUTPUT);
 pinMode(11, OUTPUT);
   lmed = lmed+analogRead(5);
   rmed = rmed+analogRead(4);
   digitalWrite(13,255);
   delay(100);   
   digitalWrite(13,0);
 delay(800);   
   lmed = lmed+analogRead(5);
   rmed = rmed+analogRead(4);
   digitalWrite(13,255);
   delay(100);   
   digitalWrite(13,0);
 delay(800); 
   lmed = lmed+analogRead(5); 
   rmed = rmed+analogRead(4);
   digitalWrite(13,255);
   delay(100);   
   digitalWrite(13,0);
 delay(800);   
   lmed = lmed+analogRead(5);
   rmed = rmed+analogRead(4);
   digitalWrite(13,255);
   delay(100);   
   digitalWrite(13,0);
   lmed = lmed/4;
   rmed = rmed/4;
    Serial.println("MEDIA");
   Serial.println(lmed);
   Serial.println(rmed);
   TM = lmed-rmed < 0 ? rmed-lmed : lmed-rmed;
   Serial.print("MEDIA");
   
    Serial.println(TM+(TM/2));
}

void loop() {

   int left = analogRead(5);

  int right = analogRead(4);
  int tocheck = left-right < 0 ? right-left : left-right;
  Serial.print("Media: ");
  Serial.println(tocheck);
  Serial.print("Media2: ");
  Serial.println((TM)+(TM/2));
  if (tocheck <= (TM)+(TM/2))
  {
      digitalWrite(11,0);
      digitalWrite(10,0);
      digitalWrite(9,255);
  }else{  
      
      digitalWrite(9,0);
      if (left > right)
      {
          digitalWrite(10,255);
          digitalWrite(11,0);
    
      }else{
        digitalWrite(10,0);
        digitalWrite(11,255);
      }  
  }
}
