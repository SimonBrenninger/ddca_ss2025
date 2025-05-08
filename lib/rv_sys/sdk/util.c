#include "util.h"

#define UART_STATUS (*((volatile char*)(-8)))
#define UART_DATA (*((volatile char*)(-4)))

#define COUNTER (*((volatile unsigned int*)0xFFFF8000))
#define GPIO_BASE_ADDR 0xFFFF4000
#define GCI_BASE_ADDR 0xFFFFC000

int getchar() {
	while ((UART_STATUS & 0x02) == 0) {
		/* wait for UART */
	}
	/* read from UART */
	return UART_DATA;
}

int putchar(int c) {
	while ((UART_STATUS & 0x01) == 0) {
		/* wait for UART */
	}
	/* write to UART */
	UART_DATA = c;
	return c;
}

unsigned int time() {
	return COUNTER;
}

void putnumber(unsigned int num)
{
	char s[12];
	int cnt = 11;
	s[cnt] = '\0';
	do {
		s[--cnt] = '0' + (num % 10);
	} while(num /= 10);
	puts(&(s[cnt]));
}

int putstring(const char *s) {
	while (*s != '\0') {
		putchar(*s++);
	}
	return 0;
}

int puts(const char *s) {
	putstring(s);
	putchar('\n');
	return 0;
}

void *memcpy(void *dest, const void *src, unsigned n) {
	while (n-- > 0) {
		*(char*)dest++ = *(char*)src++;
	}
	return dest;
}

unsigned strlen(const char *s) {
	unsigned i = 0;
	while (*s++ != '\0') {
		i++;
	}
	return i;
}

int strcmp(const char *s1, const char *s2) {
	for (;;) {
		char a = *s1++;
		char b = *s2++;
		if (a == '\0' && b == '\0') {
			return 0;
		}
		int d = a - b;
		if (d != 0) {
			return d;
		}
	}
}

void gpio_write(unsigned int addr, int value){
	(*((volatile unsigned int*)(GPIO_BASE_ADDR+(addr<<2)))) = value;
}


int gpio_read(unsigned int addr){
	return (*((volatile unsigned int*)(GPIO_BASE_ADDR+(addr<<2))));
}

void gci_write(uint16_t data) {
	// Wait for GCI to be ready
	while ((*(volatile uint32_t*)(GCI_BASE_ADDR))) {
		/* wait for GCI */
	}
	(*((volatile uint32_t*)(GCI_BASE_ADDR))) = data;
}

#define OPCODE_NOP 0x0
#define OPCODE_MOVE_GP 0x1
#define OPCODE_INC_GP 0x2
#define OPCODE_CLEAR 0x4
#define OPCODE_SET_PIXEL 0x5
#define OPCODE_DRAW_HLINE 0x6
#define OPCODE_DRAW_VLINE 0x7
#define OPCODE_DRAW_CIRCLE 0x8
#define OPCODE_GET_PIXEL 0xb
#define OPCODE_VRAM_READ 0xc
#define OPCODE_VRAM_WRITE 0xd
#define OPCODE_VRAM_WRITE_SEQ 0xe
#define OPCODE_VRAM_WRITE_INIT 0xf
#define OPCODE_SET_COLOR 0x10
#define OPCODE_SET_BB_EFFECT 0x11
#define OPCODE_DEFINE_BMP 0x12
#define OPCODE_ACTIVATE_BMP 0x13
#define OPCODE_DISPLAY_BMP 0x14
#define OPCODE_BB_CLIP 0x18
#define OPCODE_BB_FULL 0x19
#define OPCODE_BB_CHAR 0x1a
#define OPCODE_DBG 0x1f

#define INDEX_OPCODE 11
#define WIDTH_OPCODE 5
#define INDEX_MX 4
#define INDEX_MY 5
#define INDEX_MXS 3
#define WIDTH_MXS 2
#define INDEX_MYS 5
#define WIDTH_MYS 2
#define INDEX_CS 10
#define INDEX_REL 2
#define INDEX_M 0
#define INDEX_BMPIDX 0
#define WIDTH_BMPIDX 3
#define INDEX_DIR 10
#define INDEX_ROT 8
#define WIDTH_ROT 2
#define INDEX_FS 10
#define INDEX_COLOR 0
#define WIDTH_COLOR 8
#define INDEX_MASKOP 8
#define WIDTH_MASKOP 2
#define INDEX_AM 10
#define INDEX_INCVALUE 0
#define WIDTH_INCVALUE 10
#define INDEX_MASK 0
#define WIDTH_MASK 8
#define INDEX_XOFFSET 6
#define WIDTH_XOFFSET 10
#define INDEX_CHARWIDTH 0
#define WIDTH_CHARWIDTH 6


void gci_define_bmp(uint8_t bmpidx, uint32_t b, uint16_t w, uint16_t h)
{
	gci_write(OPCODE_DEFINE_BMP << INDEX_OPCODE | (bmpidx & 0x7) << INDEX_BMPIDX);
	gci_write(b & 0xffff);
	gci_write(b >> 16);
	gci_write(w & 0x7fff);
	gci_write(h & 0x7fff);
}

void gci_activate_bmp(uint8_t bmpidx)
{
	gci_write(OPCODE_ACTIVATE_BMP << INDEX_OPCODE | (bmpidx & 0x7) << INDEX_BMPIDX);
}

void gci_display_bmp(uint8_t bmpidx, uint8_t fs)
{
	gci_write(OPCODE_DISPLAY_BMP << INDEX_OPCODE | (fs & 0x1) << INDEX_FS | (bmpidx & 0x7) << INDEX_BMPIDX);
	if (fs) {
		while ( (*((volatile uint32_t*)(GCI_BASE_ADDR+4))) & 0x4000000) {
			/* wait for frame sync */
		};
	}
}

void gci_set_color(uint8_t color, uint8_t cs)
{
	gci_write(OPCODE_SET_COLOR << INDEX_OPCODE | (cs & 0x1) << INDEX_CS | (color & 0xff) << INDEX_COLOR);
}

void gci_clear(uint8_t cs)
{
	gci_write(OPCODE_CLEAR << INDEX_OPCODE | (cs & 0x1) << INDEX_CS);
}

void gci_move_gp(int16_t x, int16_t y, uint8_t rel)
{
	gci_write(OPCODE_MOVE_GP << INDEX_OPCODE | (rel & 0x1) << INDEX_REL);
	gci_write(x);
	gci_write(y);
}

void gci_inc_gp(uint8_t dir, int16_t incvalue)
{
	gci_write(OPCODE_INC_GP << INDEX_OPCODE | (dir & 0x1) << INDEX_DIR | (incvalue & 0x3ff) << INDEX_INCVALUE);
}

void gci_set_pixel(uint8_t cs, uint8_t mx, uint8_t my)
{
	gci_write(OPCODE_SET_PIXEL << INDEX_OPCODE | (cs & 0x1) << INDEX_CS | (mx & 0x1) << INDEX_MX | (my & 0x1) << INDEX_MY);
}

void gci_bb_clip(uint8_t bmpidx, uint8_t mx, uint8_t my, uint8_t rot, uint8_t am, uint16_t x, uint16_t y, uint16_t width, uint16_t height)
{
	gci_write(OPCODE_BB_CLIP << INDEX_OPCODE | (bmpidx & 0x7) << INDEX_BMPIDX | (mx & 0x1) << INDEX_MX | (my & 0x1) << INDEX_MY | (rot & 0x3) << INDEX_ROT | (am & 0x1) << INDEX_AM);
	gci_write(x);
	gci_write(y);
	gci_write(width);
	gci_write(height);
}

void gci_bb_full(uint8_t bmpidx, uint8_t mx, uint8_t my, uint8_t rot, uint8_t am)
{
	gci_write(OPCODE_BB_FULL << INDEX_OPCODE | (bmpidx & 0x7) << INDEX_BMPIDX | (mx & 0x1) << INDEX_MX | (my & 0x1) << INDEX_MY | (rot & 0x3) << INDEX_ROT | (am & 0x1) << INDEX_AM);
}

void gci_bb_char(uint8_t bmpidx, uint8_t mx, uint8_t my, uint8_t rot, uint8_t am, uint16_t xoffset, uint8_t charwidth)
{
	gci_write(OPCODE_BB_CHAR << INDEX_OPCODE | (bmpidx & 0x7) << INDEX_BMPIDX | (mx & 0x1) << INDEX_MX | (my & 0x1) << INDEX_MY | (rot & 0x3) << INDEX_ROT | (am & 0x1) << INDEX_AM);
	gci_write(xoffset << INDEX_XOFFSET | charwidth);
}

void gci_draw_hline(uint8_t cs, uint8_t mx, uint8_t my, int16_t dx)
{
	gci_write(OPCODE_DRAW_HLINE << INDEX_OPCODE | (cs & 0x1) << INDEX_CS | (mx & 0x1) << INDEX_MX | (my & 0x1) << INDEX_MY);
	gci_write(dx);
}

void gci_draw_vline(uint8_t cs, uint8_t mx, uint8_t my, int16_t dy)
{
	gci_write(OPCODE_DRAW_VLINE << INDEX_OPCODE | (cs & 0x1) << INDEX_CS | (mx & 0x1) << INDEX_MX | (my & 0x1) << INDEX_MY);
	gci_write(dy);
}
