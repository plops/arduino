volatile unsigned int Ticks; // holds the pulse count as .5 us ticks
char icpPin=8; // this interrupt handler must use pin 8
char outpin=13; 
volatile char newtick=0;
 
ISR(TIMER1_CAPT_vect){
  if( !bit_is_set(TCCR1B ,ICES1)) // was rising edge detected ?
    TCNT1 = 0;			  // reset the counter
  else {			  // falling edge was detected
    Ticks = ICR1;
    if(Ticks>1000){
      newtick=0;
      digitalWrite(outpin,HIGH);  
    }
  }
  TCCR1B ^= _BV(ICES1);		  // toggle bit value to trigger on the other edge
  newtick++;
  if(newtick>=48)
    digitalWrite(outpin,LOW);
}
 
void setup()			  // run once, when the sketch starts
{
  //Serial.begin(115200);
  pinMode(icpPin,INPUT);
  pinMode(outpin,OUTPUT);
  TCCR1A = 0x00; // COM1A1=0, COM1A0=0 => Disconnect Pin OC1 from Timer/Counter 1 -- PWM11=0,PWM10=0 => PWM Operation disabled
  TCCR1B = 0x02; // 16MHz clock with prescaler means TCNT1 increments every .5 uS (cs11 bit set
  Ticks = 0;	 // default value indicating no pulse detected
  TIMSK1 = _BV(ICIE1);  // enable input capture interrupt for timer 1
}
 
int getTick() {
  int akaTick;	   // holds a copy of the tick count so we can return it after re-enabling interrupts
  cli();	   // disable interrupts
  akaTick = Ticks;
  sei();	   // enable interrupts
  return akaTick;
}
 
char getnewtick()
{
  int akatick;
  cli();
  akatick=newtick;
  sei();
  return akatick;
}
 
void loop()			   // run over and over again
{ 
 /* static char oldtick = 0;
  char n=getnewtick();
  if(n!=oldtick) {
    oldtick = n;
    int w=getTick();
 
    Serial.print( w);
    Serial.print(' ');
    Serial.print( (int)n);
    Serial.print('\n');
  }*/
}
