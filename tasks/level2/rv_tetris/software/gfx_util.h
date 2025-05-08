
#ifndef __GFX_UTIL_H__
#define __GFX_UTIL_H__

#include <stdint.h>
#include "tetris_util.h"

#define BMPIDX_FONT 2
#define BMPIDX_TILES 3

#define BLOCK_SIZE 12
#define FONT_CHAR_WIDTH 8

void gfx_print_s(int16_t x, int16_t y, const char *s);
void gfx_print_u16(int16_t x, int16_t y, uint16_t num);
void gfx_print_u16_hex(int16_t x, int16_t y, uint16_t num);
void gfx_draw_tetromino(int16_t x, int16_t y, tetromino_t t, rotation_t r);
void gfx_init_vram(void);

#endif
