#include "tetris_util.h"

uint16_t get_blocks(tetromino_t tetromino, rotation_t rotation) {
	switch (tetromino) {
		case TETROMINO_T:
			switch (rotation) {
				case ROT_0:   return 0x4e00;
				case ROT_90:  return 0x4640;
				case ROT_180: return 0x0e40;
				case ROT_270: return 0x4c40;
			}
			break;

		case TETROMINO_I:
			return (rotation == ROT_0 || rotation == ROT_180) ? 0x4444 : 0x0f00;

		case TETROMINO_O:
			return 0x0660;

		case TETROMINO_S:
			return (rotation == ROT_0 || rotation == ROT_180) ? 0x6c00 : 0x8c40;

		case TETROMINO_Z:
			return (rotation == ROT_0 || rotation == ROT_180) ? 0xc600 : 0x4c80;

		case TETROMINO_J:
			switch (rotation) {
				case ROT_0:   return 0x44c0;
				case ROT_90:  return 0x8e00;
				case ROT_180: return 0xc880;
				case ROT_270: return 0xe200;
			}
			break;

		case TETROMINO_L:
			switch (rotation) {
				case ROT_0:   return 0x4460;
				case ROT_90:  return 0xe800;
				case ROT_180: return 0xc440;
				case ROT_270: return 0x2e00;
			}
			break;
	}
	return 0x0000; // Default/fallback
}

// Checks if a tetromino has a solid block at (x, y) in its 4x4 grid
int is_tetromino_solid_at(tetromino_t tetromino, rotation_t rotation, uint8_t x, uint8_t y) {
	if (x > 3 || y > 3) return 0;

	// Invert x and y (2-bit NOT): 3 - x and 3 - y
	uint8_t index = ((3 - y) << 2) | (3 - x);  // Equivalent to (not y) & (not x) in VHDL
	uint16_t blocks = get_blocks(tetromino, rotation);

	return (blocks >> index) & 1;
}

tetromino_t get_random_tetromino()
{
	static uint16_t lfsr = 0x1234;
	do {
		lfsr = (lfsr >> 1) ^ ((-(lfsr & 1)) & 0xB400);
	} while ((lfsr & 0x7) == 7);
	
	return (tetromino_t)(lfsr % 7);
}
