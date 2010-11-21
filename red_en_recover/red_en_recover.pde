volatile unsigned int Ticks; // holds the pulse count as .5 us ticks
char icpPin=8; // this interrupt handler must use pin 8
volatile char bit_plane_change=0; // incremented whenever a different bitplane is displayed
char mma=13,light=12,vsync=11;
 
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
  if(bit_plane_change==0)
    digitalWrite(vsync,HIGH);
  else if (bit_plane_change==24)
    digitalWrite(vsync,LOW);
  #include "/home/martin/0913/arduino/red_en_recover/ifs"
  bit_plane_change++;
}
 
void setup()			  // run once, when the sketch starts
{
  //Serial.begin(115200);
  pinMode(icpPin,INPUT);
  pinMode(mma,OUTPUT);
  pinMode(light,OUTPUT);
  pinMode(vsync,OUTPUT);
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
