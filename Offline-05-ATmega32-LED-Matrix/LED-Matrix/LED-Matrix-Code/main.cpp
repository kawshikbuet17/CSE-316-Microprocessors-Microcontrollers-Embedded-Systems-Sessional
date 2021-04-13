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


volatile unsigned int pattern_P[8] = { 0b11111111, 0b00000000, 0b00000000, 0b00100111, 0b00100111, 0b00000111, 0b00000111, 0b11111111};

ISR(INT0_vect){
	PORTC = ~PORTC;
}

void baseState(void){
	PORTA = 0b10000000;
	PORTB = 0b11111111;
	_delay_ms(.5);
	
	PORTA = 0b01000000;
	PORTB = 0b00000000;
	_delay_ms(.5);
	
	PORTA = 0b00100000;
	PORTB = 0b00000000;
	_delay_ms(.5);
	
	PORTA = 0b00010000;
	PORTB = 0b00100111;
	_delay_ms(.5);
	
	PORTA = 0b00001000;
	PORTB = 0b00100111;
	_delay_ms(.5);
	
	PORTA = 0b00000100;
	PORTB = 0b00000111;
	_delay_ms(.5);
	
	PORTA = 0b00000010;
	PORTB = 0b00000111;
	_delay_ms(.5);
	
	PORTA = 0b00000001;
	PORTB = 0b11111111;
	_delay_ms(.5);
}

int main(void)
{
    DDRD = 0xFF; //column output
    DDRB = 0xFF; //row output
	PORTC = 0b00000001;
	GICR = (1<<INT0); //STEP3
	MCUCR = MCUCR & 0b11110011;//STEP4
    while (1) 
    {
		baseState();
		//PORTA = PORTA>>1;	
		//_delay_ms(100);	
    }
}

