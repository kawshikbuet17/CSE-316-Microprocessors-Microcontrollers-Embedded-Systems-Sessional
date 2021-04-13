/*
 * LED-Matrix-Code.cpp
 *
 * Created: 4/13/2021 1:47:32 AM
 * Author : kawshik1705043
 */ 

#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

volatile unsigned char pattern_P[8] = { 0b11111111, 0b00000000, 0b00000000, 0b00100111, 0b00100111, 0b00000111, 0b00000111, 0b11111111};
volatile unsigned char params= 0b10000000;
volatile unsigned char toggle = 1;

ISR(INT0_vect){
	toggle = ~toggle;
}


void drawPattern_P(){
	PORTA = params;
	for (int i=0; i<8; i++){
		PORTB = pattern_P[i];
		_delay_ms(.5);
		PORTA = PORTA>>1;
		if (!PORTA)
		{
			PORTA = 0b10000000;
		}
	}
}

int main(void)
{
    DDRA = 0xFF;
    DDRB = 0xFF;
	
	GICR = (1<<INT0);
	MCUCR = MCUCR & 0b00000011;
	sei();
	
    while (1) 
    {
		for(int i=0; i<50; i++){
			drawPattern_P();
		}
		
		if((toggle & 0b00000001)){
			_delay_ms(80);	
			params = params >> 1;
			if(!params){
				params = 0b10000000;
			}
		}
    }
}

