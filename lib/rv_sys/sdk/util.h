#ifndef __UTIL_H__
#define __UTIL_H__
#include <stdint.h>
int getchar();
int putchar(int c);
int putstring(const char *s);
int puts(const char *s);
void *memcpy(void *dest, const void *src, unsigned n);
unsigned strlen(const char *s);
int strcmp(const char *s1, const char *s2);
unsigned int time();
void putnumber(unsigned int num);

// GPIO functions
void gpio_write(unsigned int addr, int value);
int gpio_read(unsigned int addr);

// GCI functions
#define REL_ABSOLUTE  0x0
#define REL_RELATIVE  0x1

#define CS_PRIMARY    0x0
#define CS_SECONDARY  0x1

#define M_BYTE        0x0
#define M_WORD        0x1

#define DIR_X         0x0
#define DIR_Y         0x1

#define ROT_R0        0x0
#define ROT_R90       0x1
#define ROT_R180      0x2
#define ROT_R270      0x3

#define COLOR_BLACK   0x00
#define COLOR_WHITE   0xff
#define COLOR_BLUE    0x03
#define COLOR_RED     0xe0
#define COLOR_GREEN   0x1c
#define COLOR_CYAN    0x1f
#define COLOR_MAGENTA 0xe3
#define COLOR_YELLOW  0xfc
#define COLOR_GRAY    0x92

#define MASKOP_NOP    0x0
#define MASKOP_AND    0x1
#define MASKOP_OR     0x2
#define MASKOP_XOR    0x3

#define gci_set_primary_color(color) gci_set_color(color, CS_PRIMARY)
#define gci_set_secondary_color(color) gci_set_color(color, CS_SECONDARY)

#define gci_move_gp_relative(x, y) gci_move_gp(x, y, REL_RELATIVE)
#define gci_move_gp_absolute(x, y) gci_move_gp(x, y, REL_ABSOLUTE)

#define gci_inc_gp_x(incvalue) gci_inc_gp(DIR_X, incvalue)
#define gci_inc_gp_y(incvalue) gci_inc_gp(DIR_Y, incvalue)

void gci_write(uint16_t data);

void gci_define_bmp(uint8_t bmpidx, uint32_t b, uint16_t w, uint16_t h);
void gci_activate_bmp(uint8_t bmpidx);
void gci_display_bmp(uint8_t bmpidx, uint8_t fs);
void gci_set_color(uint8_t color, uint8_t cs);

void gci_move_gp(int16_t x, int16_t y, uint8_t rel);
void gci_inc_gp(uint8_t dir, int16_t incvalue);

void gci_clear(uint8_t cs);
void gci_set_pixel(uint8_t cs, uint8_t mx, uint8_t my);
void gci_draw_hline(uint8_t cs, uint8_t mx, uint8_t my, int16_t dx);
void gci_draw_vline(uint8_t cs, uint8_t mx, uint8_t my, int16_t dy);

void gci_bb_clip(uint8_t bmpidx, uint8_t mx, uint8_t my, uint8_t rot, uint8_t am, uint16_t x, uint16_t y, uint16_t width, uint16_t height);
void gci_bb_full(uint8_t bmpidx, uint8_t mx, uint8_t my, uint8_t rot, uint8_t am);
void gci_bb_char(uint8_t bmpidx, uint8_t mx, uint8_t my, uint8_t rot, uint8_t am, uint16_t xoffset, uint8_t charwidth);

#endif
