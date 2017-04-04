#include "video.h"

static uint8_t* VRAM = VRAMP;
static uint8_t VCACHE[VSIZE];
static uint8_t VEMPTY[VSIZE]={0};
static uint8_t VDIRTY[VHEIGHT];
static uint8_t VCDIRTY[VHEIGHT];
//static uint8_t even = 0;
static uint8_t stamp;
void initVCache(){
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
void refreshVCache(){
	int x;

	for(x=0; x<VHEIGHT; x++){
		VDIRTY[x] = 0;
	};
}
void flushVCache(){
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
void setPixelAt(int x, int y, uint8_t color){
	if(x<0||x>=VHEIGHT||y<0||y>=VWIDTH)return;
	VDIRTY[x] = 1;
	VCDIRTY[x] = 1;
	VCACHE[VWIDTH*x+y]=color;
}
void forceClearVRAM(){
	//memcpy(VRAM, VEMPTY, VSIZE/4);

}
void clearVRAM(){
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
		//printk("What matters\n");
		stamp=0;
		//printk("What matters\n");
	}
	if(stamp==0){
		//printk("What hell\n");
		memcpy(VCDIRTY, VEMPTY, VHEIGHT/4);
		//printk("What hell\n");
	}
	//memcpy(VRAM, VEMPTY, VSIZE/4);
}
