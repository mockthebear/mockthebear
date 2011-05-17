bool r,g,b;
int randpin = 12;
int num = 00;
int numero=1 ;
int brilho = 255;
int escuro = 0;
bool parar = true;

void setup()  { 
  for (int pin=4;pin<=11;pin++)
  {
    pinMode(pin, OUTPUT);
  }
  pinMode(1, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  analogWrite(0, 255); 
 analogWrite(1, 255);
 analogWrite(12, 255);
  analogWrite(13, 255);
} 
void showNq(int pin,int pos)
{
    digitalWrite(pos ? 2 : 3,  brilho); 
    digitalWrite(pin, escuro);
    digitalWrite(pos ? 2 : 3,  escuro);
    digitalWrite(pin, brilho);
}

void printN(int n,bool pos)
{
  switch (n){
    case 1:
      showNq(7,pos); 
      showNq(11,pos); 
      break;
    case 2:
      showNq(7,pos); 
      showNq(6,pos); 
      showNq(8,pos); 
      showNq(10,pos); 
      showNq(4,pos);
      break; 
    case 3:
      showNq(6,pos); 
      showNq(7,pos); 
      showNq(11,pos); 
      showNq(4,pos);
      showNq(8,pos);
      break;
    case 4:
      showNq(7,pos); 
      showNq(4,pos);
      showNq(11,pos); 
      showNq(5,pos);
      break;
    case 5:
      showNq(6,pos); 
      showNq(5,pos);
      showNq(4,pos); 
      showNq(11,pos);
      showNq(8,pos);
      break;
    case 6:
      showNq(6,pos); 
      showNq(5,pos);
      showNq(4,pos); 
      showNq(11,pos);
      showNq(8,pos);
      showNq(10,pos);
      break;
    case 7:
      showNq(7,pos); 
      showNq(11,pos);
      showNq(6,pos); 
      break;  
   case 8:
      showNq(6,pos); 
      showNq(5,pos);
      showNq(4,pos); 
      showNq(7,pos); 
      showNq(11,pos);
      showNq(8,pos);
      showNq(10,pos);
      break;   
   case 9:
      showNq(6,pos); 
      showNq(5,pos);
      showNq(4,pos); 
      showNq(7,pos); 
      showNq(11,pos);
      showNq(8,pos);
      break; 
  case 0:
      showNq(6,pos); 
      showNq(5,pos);
      showNq(7,pos); 
      showNq(11,pos);
      showNq(8,pos);
       showNq(10,pos);
      break;     
  }
   

          
     
}

String inString = "";
void loop()  { 
  for (int pin=4;pin<=11;pin++)
  {
     analogWrite(pin,  255);
  } 
 analogWrite(2,  0);
 analogWrite(3,  0);
 
 num = num > 99 ? 00 : num;

  printN(floor(num/10),true);
  printN(floor(num%10),false);
  if (analogRead(5) > 0){
    if (parar) 
      {
      parar = false;
      analogWrite(randpin, 0);  
      num = num+1;
      }
  }else{analogWrite(randpin, 255); 
      if (!parar) 
      {
      switch(numero){    
        case 1:
          randpin = 12;
          numero=2;
          break;
        case 2:
          randpin = 1;
          numero=3;
          break;
        case 3:
          randpin = 13;
          numero=1;
        break;        
      }
      }
      parar = true;

} 
  
}
