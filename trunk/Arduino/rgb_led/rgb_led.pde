bool r,g,b;
void setup()  { 
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(7, INPUT);
} 
int brilho = 255;
int escuro = 220;
void loop()  { 
   analogWrite(9,  255);
    analogWrite(10, 255);
     analogWrite(11, 255);

  for (int r_=1;r_<=2;r_++)
  {
    for(int g_=1;g_<=2;g_++)
    {
     for(int b_=1;b_<=2;b_++)
       {
        analogWrite(9, b ? brilho : escuro);
         b = b ? false : true;
         delay(800);
       }
      analogWrite(10, g ? brilho : escuro);
      g = g ? false : true;
      delay(800);      
    }    
    analogWrite(11, r ? brilho : escuro);
    r = r ? false : true;
    delay(800);
  }
    analogWrite(13,255);
    delay(1000);
    analogWrite(13,0);
}
