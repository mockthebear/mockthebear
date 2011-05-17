int pinA = 2;
int pinB = 3;
int pinC = 4;
int steppingDelay = 50;

void setup() {
  pinMode(pinA, OUTPUT);
  pinMode(pinB, OUTPUT);
  pinMode(pinC, OUTPUT);
  
   pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);

  digitalWrite(pinA, HIGH);
  digitalWrite(pinB, HIGH);
  digitalWrite(pinC, HIGH);  
   Serial.begin(9600);
}

void loop() {
  stepping(1);
  delay(steppingDelay);
  stepping(2);
  delay(steppingDelay);  
  stepping(3);
  delay(steppingDelay);
  if(steppingDelay > 1)
  {
    steppingDelay-=1;
    Serial.println(steppingDelay,DEC);
  }
}

void stepping(int stage)
{
  switch(stage)
  {
  case 1:
    digitalWrite(9, HIGH);
    digitalWrite(10, LOW);
    digitalWrite(11, LOW);  
   
    digitalWrite(pinA, LOW);
    digitalWrite(pinB, HIGH);
    digitalWrite(pinC, HIGH);
    break;
  case 2:
    digitalWrite(9, LOW);
    digitalWrite(10, HIGH);
    digitalWrite(11, LOW); 
    
    
    digitalWrite(pinA, HIGH);
    digitalWrite(pinB, LOW);
    digitalWrite(pinC, HIGH);
    break;
  default:
    digitalWrite(9, LOW);
    digitalWrite(10, LOW);
    digitalWrite(11, HIGH);  
    
    digitalWrite(pinA, HIGH);
    digitalWrite(pinB, HIGH);
    digitalWrite(pinC, LOW);
    break;
  } 
}

