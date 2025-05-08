#include "util.h"

#include "gfx_util.h"
#include "tetris_util.h"


#define BLOCKS_X 10
#define BLOCKS_Y 20

#define SNES_BUTTON_B      0
#define SNES_BUTTON_Y      1
#define SNES_BUTTON_SELECT 2
#define SNES_BUTTON_START  3
#define SNES_BUTTON_UP     4
#define SNES_BUTTON_DOWN   5
#define SNES_BUTTON_LEFT   6
#define SNES_BUTTON_RIGHT  7
#define SNES_BUTTON_A      8
#define SNES_BUTTON_X      9
#define SNES_BUTTON_L     10
#define SNES_BUTTON_R     11


int main() {



	// you can use the LEDs and Seven-Segment display to debug your program
	gpio_write(0, 0x55); // green LEDs
	gpio_write(1, 0xaa); // red LEDs
	gpio_write(2, 0x24402412); // 2025
	gpio_write(3, 0x21214608); // ddCA

	gfx_init_vram();


	uint8_t fb = 0;
	int snes = 0;

	tetromino_t tetromino = TETROMINO_Z;

	while (1) {
		gci_display_bmp(fb, 1);
		fb ^= 1;
		gci_activate_bmp(fb);

		snes = gpio_read(4);
		gpio_write(1, snes); // output controller state on red LEDs


		gci_clear(CS_PRIMARY);
		gfx_print_s(8, 10, "print text and numbers to the screen");
		gfx_print_s(8, 20, "contoller state: ");
		gfx_print_u16_hex(144, 20, snes);
		gfx_print_u16(144+40, 20, snes);
		

		gfx_print_s(8, 40, "draw tetrominoes");
		for(int i=0; i<4; i++){
			gfx_draw_tetromino(8+i*48, 50, TETROMINO_T, i);
		}
		
		gfx_print_s(8, 100, "create random tetrominoes <press A>");
		if (snes & (1<<SNES_BUTTON_A)) {
			tetromino = get_random_tetromino();
		}
		gfx_draw_tetromino(8, 110, tetromino, ROT_0);

	}

	return 0;
}

