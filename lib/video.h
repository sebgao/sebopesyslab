#ifndef H_VIDEO
#define H_VIDEO

#include "common.h"

#define VRAMP (unsigned char*)(0xA0000)

#define VWIDTH 320
#define VHEIGHT 200
#define VSIZE (VWIDTH*VHEIGHT)

uint8_t* VRAM = VRAMP;
uint8_t VCACHE[VSIZE];
uint8_t VEMPTY[VSIZE]={0};
uint8_t VDIRTY[VHEIGHT];
uint8_t VCDIRTY[VHEIGHT];
uint8_t even = 0;
static uint8_t stamp;
static inline void initVCache(){
	int x;

	memcpy(VCACHE, VEMPTY, VSIZE/4);
	for(x=0; x<VHEIGHT; x++){
		VDIRTY[x] = 0;
	}

	/*for(x=0; x<VSIZE; x++){
		VEMPTY[x] = 0;
		VCACHE[x] = 0;
	}*/
}
static inline void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
		VDIRTY[x] = 0;
	};
}
static inline void flushVCache(){
	//even = even?0:1;
	int x;
	for(x=0; x<VHEIGHT; x++){
		//if(x%2 == even)continue;
		if(VDIRTY[x]){
			//printk("flush");
			memcpy(VRAM+VWIDTH*x, VCACHE+VWIDTH*x, VWIDTH/4);
		}
	}

}
static inline void setPixelAt(int x, int y, uint8_t color){
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
	VDIRTY[x] = 1;
	VCDIRTY[x] = 1;
	VCACHE[VWIDTH*x+y]=color;
}
static inline void forceClearVRAM(){
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
static inline void clearVRAM(){
	int x;
	
	for(x=0; x<VHEIGHT; x++){
		if(VCDIRTY[x] & ~VDIRTY[x]){
			//VCDIRTY[x] = 0;
			//printk("%d", stamp);
			memcpy(VRAM+VWIDTH*x, VEMPTY, VWIDTH/4);
		}
	}

	stamp++;
	if(stamp==30){
		stamp=0;
	}
	if(stamp==0){
		memcpy(VCDIRTY, VEMPTY, sizeof(VCDIRTY));
	}
	if(stamp==2){
		forceClearVRAM();
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}

#endif