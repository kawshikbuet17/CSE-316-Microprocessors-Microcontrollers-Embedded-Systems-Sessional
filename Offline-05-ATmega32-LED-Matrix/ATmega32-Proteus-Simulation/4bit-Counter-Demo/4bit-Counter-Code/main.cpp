/*
 * 4bit-Counter-Code.cpp
 *
 * Created: 4/6/2021 2:39:02 AM
 * Author : ASUS
 */ 

#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    /* Replace with your application code */
	DDRD = 0b00001111;
	
	unsigned int count = 0;
    while (1) 
    {
		count++;
		if (count==16)
		{
			count = 0;
		}
		PORTD = count;
		_delay_ms(1000);
    }
}

