
#include "gfx_util.h"
#include "util.h"
#include <stdint.h>

void gfx_print_s(int16_t x, int16_t y, const char *s)
{
	char c = ' ';
	gci_move_gp_absolute(x, y);
	while (*s != '\0') {
		c = *s;
		if (c== 0x20) {
			gci_inc_gp_x(FONT_CHAR_WIDTH);
		} else {
			if (c >= 'a' && c <= 'z') {
				c -= 0x20; // lowercase not supported -> convert to uppercase
			}
			if (c < '0' || c > 'Z') {
				c = '?';
			}
			gci_bb_char(BMPIDX_FONT, 1, 0, 0, 0, (c-'0')*FONT_CHAR_WIDTH, FONT_CHAR_WIDTH);
		}
		s++;
	}
}

void gfx_print_u16(int16_t x, int16_t y, uint16_t num)
{
	char s[] = "00000";
	int cnt = 5;
	do {
		s[--cnt] = '0' + (num % 10);
	} while(num /= 10);
	gfx_print_s(x, y, s);
}

void gfx_print_u16_hex(int16_t x, int16_t y, uint16_t num)
{
	char s[] = "0000";
	int cnt = 4, n;
	do {
		n = num & 0xf;
		num >>= 4;
		s[--cnt] = (n < 10) ? ('0' + n) : ('A' + (n - 10));
	} while(cnt > 0);
	gfx_print_s(x, y, s);
}

void gfx_init_vram()
{
	int num_cmds = 0;
	uint16_t cmd = 0;

	// read total number of commands stored in the tetris ROM
	gpio_write(5, -1);
	num_cmds = gpio_read(5);

	// read each command and write it to the GCI
	for (int i=0; i<num_cmds; i++) {
		gpio_write(5, i);
		cmd = gpio_read(5);
		gci_write(cmd);
	}
}

void gfx_draw_tetromino(int16_t x, int16_t y, tetromino_t t, rotation_t r)
{
	for (int i=0; i<4; i++) {
		gci_move_gp_absolute(x, y+i*BLOCK_SIZE);
		for (int j=0; j<4; j++) {
			if (is_tetromino_solid_at(t, r, j, i)) {
				gci_bb_char(BMPIDX_TILES, 1, 0, 0, 0, t*BLOCK_SIZE, BLOCK_SIZE);
			} else {
				gci_inc_gp_x(BLOCK_SIZE);
			}
		}
	}
}
