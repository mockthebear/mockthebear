/*
Code to test comunication speed between Arduino and program.
By Matheus Braga - Matheus.mtb7@gmail.com
*/
void setup() {                
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}
void loop() {
  if (Serial.available() > 0) {
    int rByte = Serial.read();
    if (rByte == 50)
    {
      Serial.print(2);   //byte 50
      digitalWrite(13, HIGH);         
    }else if (rByte == 51){
      Serial.print(3);   //byte 51
      digitalWrite(13, LOW);   // set the LED on 
    }
  }
}
  

