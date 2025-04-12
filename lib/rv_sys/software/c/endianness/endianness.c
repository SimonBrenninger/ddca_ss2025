#include "util.c"

typedef unsigned char uint8_t;

unsigned int val = 0x05060708;
uint8_t data[] = {1, 2, 3, 4};
uint8_t buf[4];

inline char n2c(uint8_t n) {
	return '0' + n;
}

void print_char(uint8_t n) {
	putchar(n2c(n));
	putchar('\n');
}

void print_word(unsigned int a) {
	putchar(n2c((a >> 3*8) & 0xFF));
	putchar(n2c((a >> 2*8) & 0xFF));
	putchar(n2c((a >> 1*8) & 0xFF));
	putchar(n2c((a >> 0*8) & 0xFF));
	putchar('\n');
}

int main() {
#if 1
	unsigned int *p = data;
	unsigned int a = *p;
	print_word(a);
	print_char(data[0]);
	print_char(data[1]);
	print_char(data[2]);
	print_char(data[3]);

	unsigned int *b = buf;
	*b = 0x01020304;
	print_char(buf[0]);
	print_char(buf[1]);
	print_char(buf[2]);
	print_char(buf[3]);

	print_word(val);
#else
	print_word(0x05);
	*((unsigned short *)4) = 0x0102;
	print_word(0x0102);
	unsigned int a = *((unsigned short *)4);
	print_word(a);
#endif

	return 0;
}
