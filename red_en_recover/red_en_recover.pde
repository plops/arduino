// takes the lcos signal (train of 24 pulses, followed by a pause)
// and generates a trigger signal for the mma at the end of each train
// so for every DVI image (consisting of 24 bit planes) a different 
// mma image can be shown. 
// I used to trigger the mma more often but then I could only use 11 of
// the 24 bit planes, loosing substantial intensity

volatile unsigned int Ticks; // holds the pulse count as .5 us ticks
// pin 8 takes signal from lcos
char icpPin=8; // this interrupt handler must use pin 8
volatile char bit_plane_change=0; // incremented whenever a different bitplane is displayed
char mma=13; // output towards mma
 
ISR(TIMER1_CAPT_vect){
  if( !bit_is_set(TCCR1B ,ICES1)) // was rising edge detected ?
    TCNT1 = 0;			  // reset the counter
  else {			  // falling edge was detected
    Ticks = ICR1;
    if(Ticks>1000){
      bit_plane_change=0;
    }
  }
  TCCR1B ^= _BV(ICES1);		  // toggle bit value to trigger on the other edge
  if(bit_plane_change==47){
    digitalWrite(mma,HIGH);
  }else if (bit_plane_change==0){
    digitalWrite(mma,LOW);
  } 
  bit_plane_change++;
}
 
void setup()			  // run once, when the sketch starts
{
  //Serial.begin(115200);
  pinMode(icpPin,INPUT);
  pinMode(mma,OUTPUT);
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
 
char get_plane_change()
{
  int aka;
  cli();
  aka=bit_plane_change;
  sei();
  return aka;
}
 
void loop() // run over and over again
{ 
}
