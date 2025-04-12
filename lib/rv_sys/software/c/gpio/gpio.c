#include "util.h"

int main() {
	puts("GPIO Test\n");
	
	/*
	GPIO Register Map:
	
	gpio_addr | read      | write
	----------------------------------
	  0       | keys      | ledg
	  1       | switches  | ledr
	  2       | 0         | hex3-hex0
	  3       | 0         | hex7-hex4
	  4-7     | loopback  | not used
	*/
	
	int ledg_pattern = 0x55;
	int old_time = time();
	int cur_time;
	gpio_write(0, ledg_pattern);
	
	gpio_write(2, 0x24402419);
	gpio_write(3, 0x21214608);
	
	while (1) {
		gpio_write(1, gpio_read(1));
		cur_time = time();
		if (cur_time-old_time > 500000) {
			old_time = cur_time;
			ledg_pattern ^= 0xff;
		}
		gpio_write(0, ledg_pattern);
	}
	
	return 0;
}
