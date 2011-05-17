void setup() {
  Serial.begin(9600);
  pinMode(11, OUTPUT); 
   pinMode(12, OUTPUT); 
}
int dir=1;
void loop()  {  
   int photocellReading = analogRead(0);
   photocellReading = photocellReading > 960 ? 960 : photocellReading;
    Serial.println(photocellReading,DEC);
   if (photocellReading > 959)
   {
     dir=2;     
   }
   if (photocellReading <= 1)
   {
     dir=1;
   }
   if (dir==1)
   {
   digitalWrite(11,255);
   digitalWrite(12,0);
   }else{
   digitalWrite(12,255);
   digitalWrite(11,0);  
   }
   Serial.println(dir,DEC);
 }
