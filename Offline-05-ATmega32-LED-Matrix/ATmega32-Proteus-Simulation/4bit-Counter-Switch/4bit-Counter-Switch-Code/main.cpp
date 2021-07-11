/*
 * 4bit-Counter-Switch.cpp
 *
 * Created: 4/6/2021 3:21:18 AM
 * Author : ASUS
 */ 

#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>


int main(void)
{
    DDRD = 0b00001111;
	DDRA = 0b00000000;
	
	unsigned char count = 0;
		
    while (1) 
    {
		unsigned char input = PINA;
		if(input & 0b00000001){
			count++;
			if(count==16){
				count = 0;
			}
			PORTD = count;
			_delay_ms(500);
		}
    }
}

