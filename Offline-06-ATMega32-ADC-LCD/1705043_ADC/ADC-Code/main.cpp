
#ifndef F_CPU
#define F_CPU 1000000
#endif


#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7

#include <avr/io.h>
#include <util/delay.h>
#include "lcd.h"
#include <stdlib.h>

#include <avr/io.h>

int main(void)
{
	DDRD = 0xFF;
	DDRC = 0xFF;
	
	ADMUX = 0b00100011;
	ADCSRA = 0b10000011;
	
	Lcd4_Init();
	Lcd4_Set_Cursor(1,1);
	
	char vol[10] = "Voltage: ";
	Lcd4_Write_String(vol);
	
	while(1)
	{
		ADCSRA |= (1 << ADSC);
		while(ADCSRA & (1 << ADSC)){
			;
		}
		
		int adcl = ADCL;
		adcl = adcl>>6;
		int adch = ADCH;
		adch = adch<<2;
		
		float voltage = (adch + adcl) * 4.0 / 1024;
		char result[8];
		dtostrf(voltage, 1, 2, result);
		
		Lcd4_Set_Cursor(1,10);
		Lcd4_Write_String(result);
		
		_delay_ms(5);
		//Lcd4_Clear();
	}
}