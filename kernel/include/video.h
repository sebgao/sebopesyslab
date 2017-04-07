#ifndef _H_VIDEO
#define _H_VIDEO

#include "common.h"

#define VRAMP (unsigned char*)(0xA0000)

#define VWIDTH 320
#define VHEIGHT 200
#define VSIZE (VWIDTH*VHEIGHT)


void initVCache();
void refreshVCache();
void flushVCache();
void setPixelAt(int x, int y, uint8_t color);
void forceClearVRAM();
void clearVRAM();

#endif