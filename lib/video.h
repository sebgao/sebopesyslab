#ifndef _H_VIDEO
#define _H_VIDEO

#include "common.h"

#define VRAMP (unsigned char*)(0xA0000)

#define VWIDTH 320
#define VHEIGHT 200
#define VSIZE (VWIDTH*VHEIGHT)

uint8_t* VRAM = VRAMP;
uint8_t VCACHE[VSIZE];
uint8_t VEMPTY[VSIZE]={0};
uint8_t VDIRTY[VHEIGHT];
static inline void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0;x<VHEIGHT;x++){
		VDIRTY[x] = 0;
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
static inline void setPixelAt(int y, int x, uint8_t color){

	VDIRTY[x] = 1;
	VCACHE[VWIDTH*x+y]=color;
}
static inline void clearVRAM(){

	memcpy(VRAM, VEMPTY, VSIZE/4);
}
#endif