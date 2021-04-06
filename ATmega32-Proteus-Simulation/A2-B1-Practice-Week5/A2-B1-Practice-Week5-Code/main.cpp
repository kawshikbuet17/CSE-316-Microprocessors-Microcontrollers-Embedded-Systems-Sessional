
#define F_CPU 1000000
#include <avr/io.h>
#include <util/delay.h>


int main(void)
{
	DDRC = 0b11010011;
	DDRA = 0b00000000;
	
	unsigned char count = 0;
	PORTC = 0b00010000;
	int up = 1;
	
	while (1)
	{
		unsigned char input = PINA;
		if((input&0b00000001)==0){
			if(up==1){
				count++;
				if(count==16){
					count = 0;
				}
			}
			else{
				count--;
				if (count<0){
					count = 15;
				}
			}
			unsigned char bit_10 = (count&0b00000011);
			unsigned char bit_76 = ((count<<4)&0b11000000);
			unsigned char up_down = ((up<<4)&0b00010000);
			PORTC = bit_10|bit_76|up_down;
			_delay_ms(500);
		}
		if((input & 0b00000010)==0){
			up = up^1;
			count=count^1;
			unsigned char bit_10 = (count&0b00000011);
			unsigned char bit_76 = ((count<<4)&0b11000000);
			unsigned char up_down = ((up<<4)&0b00010000);
			PORTC = bit_10|bit_76|up_down;
			_delay_ms(500);
		}
	}
}
