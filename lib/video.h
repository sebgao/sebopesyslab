#ifndef _H_VIDEO
#define _H_VIDEO

#include "common.h"

#define VRAMP (unsigned char*)(0xA0000)

#define VWIDTH 320
#define VHEIGHT 200
#define VSIZE (VWIDTH*VHEIGHT)

uint8_t* VRAM = VRAMP;
uint8_t VCACHE[VSIZE];
uint8_t VDIRTY[VHEIGHT];
static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}
static inline void initVCache(){
	int x, y;
	for(x=0;x<VHEIGHT;x++){
		for(y=0; y<VWIDTH; y++){
			VCACHE[VWIDTH*x+y] = 0;
			VRAM[VWIDTH*x+y] = 0;
			VDIRTY[x] = 0;
		}
	}
}
static inline void refreshVCache(){
	int x;
	for(x=0; x<VHEIGHT; x++){
		VDIRTY[x] = 0;
	};
}
static inline void flushVCache(){
	int x;
	for(x=0; x<VHEIGHT; x++){
		if(VDIRTY[x]){
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}
}
static inline void setPixelAt(int x, int y, uint8_t color){
	VDIRTY[x] = 1;
	VCACHE[VWIDTH*x+y]=color;
}

static inline void clearVRAM(){
	int x, y;
	for(x=0;x<VHEIGHT;x++){
		for(y=0; y<VWIDTH; y++){
			VRAM[VWIDTH*x+y] = 0;
			VDIRTY[x] = 0;
		}
	}
}
#endif