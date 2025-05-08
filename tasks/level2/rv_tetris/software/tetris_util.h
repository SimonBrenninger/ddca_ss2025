#ifndef TETRIS_UTIL_H
#define TETRIS_UTIL_H

#include <stdint.h>
#include "util.h"


typedef enum {
	TETROMINO_T = 0,
	TETROMINO_I = 1,
	TETROMINO_O = 2,
	TETROMINO_S = 3,
	TETROMINO_Z = 4,
	TETROMINO_J = 5,
	TETROMINO_L = 6
} tetromino_t;

typedef enum {
	ROT_0 = 0,
	ROT_90 = 1,
	ROT_180 = 2,
	ROT_270 = 3
} rotation_t;

uint16_t get_blocks(tetromino_t tetromino, rotation_t rotation);
int is_tetromino_solid_at(tetromino_t tetromino, rotation_t rotation, uint8_t x, uint8_t y);
tetromino_t get_random_tetromino();

#endif
