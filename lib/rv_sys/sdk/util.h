#ifndef __UTIL_H__
#define __UTIL_H__
int getchar();
int putchar(int c);
int putstring(const char *s);
int puts(const char *s);
void *memcpy(void *dest, const void *src, unsigned n);
unsigned strlen(const char *s);
int strcmp(const char *s1, const char *s2);
unsigned int time();
void putnumber(unsigned int num);
void gpio_write(unsigned int addr, int value);
int gpio_read(unsigned int addr);
#endif
