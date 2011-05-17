void setup() {
  Serial.begin(9600);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
}
float LDR[3];
void loop()  {
  
  LDR[1] = analogRead(5)/2; 
  if (LDR[1] > 0 && LDR[1] < 1023)
 { 
    //Serial.print("PIN3:");
    //Serial.println(LDR[1], DEC);
    
 }
 LDR[2] = analogRead(4);
 if (LDR[2] > 0 && LDR[2] < 1023)
 { 
    //Serial.print("PIN2:");
   // Serial.println(LDR[2], DEC);
 }
 Serial.print("<<");
 Serial.print(LDR[1]);
 Serial.print("<< --");
 Serial.print(((LDR[1] / LDR[2]) > 1 ? (LDR[2] / LDR[1]) : (LDR[1] / LDR[2])),DEC);
 Serial.print("-- >>");
 Serial.print(LDR[2]);
 Serial.println(">>");
 if (((LDR[1] / LDR[2]) > 1 ? (LDR[2] / LDR[1]) : (LDR[1] / LDR[2])) > 0.1)
 {
   digitalWrite(5,0);
   if (LDR[1] > LDR[2])
   {
      digitalWrite(6,255);   
      digitalWrite(7,0);
   }else{
      digitalWrite(7,255);   
      digitalWrite(6,0);
   }
 }else{
    digitalWrite(6,0);
    digitalWrite(7,0);
    digitalWrite(5,255);
 }  
}
