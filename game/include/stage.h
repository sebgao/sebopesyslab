#ifndef _STAGE_H
#define _STAGE_H
#include "common.h"

#include "lib/syscall.h"

uint32_t hash=0;
uint32_t lhash=0;
  


uint32_t memoriza[600]={0};
const uint16_t squares[] = {
    0, 1, 4, 9,
    16, 25, 36, 49,
    64, 81, 100, 121,
    144, 169, 196, 225,
    256, 289, 324, 361,
    400, 441, 484, 529,
    576, 625, 676, 729,
    784, 841, 900, 961,
    1024, 1089, 1156, 1225,
    1296, 1369, 1444, 1521,
    1600, 1681, 1764, 1849,
    1936, 2025, 2116, 2209,
    2304, 2401, 2500, 2601,
    2704, 2809, 2916, 3025,
    3136, 3249, 3364, 3481,
    3600, 3721, 3844, 3969,
    4096, 4225, 4356, 4489,
    4624, 4761, 4900, 5041,
    5184, 5329, 5476, 5625,
    5776, 5929, 6084, 6241,
    6400, 6561, 6724, 6889,
    7056, 7225, 7396, 7569,
    7744, 7921, 8100, 8281,
    8464, 8649, 8836, 9025,
    9216, 9409, 9604, 9801,
    10000, 10201, 10404, 10609,
    10816, 11025, 11236, 11449,
    11664, 11881, 12100, 12321,
    12544, 12769, 12996, 13225,
    13456, 13689, 13924, 14161,
    14400, 14641, 14884, 15129,
    15376, 15625, 15876, 16129,
    16384, 16641, 16900, 17161,
    17424, 17689, 17956, 18225,
    18496, 18769, 19044, 19321,
    19600, 19881, 20164, 20449,
    20736, 21025, 21316, 21609,
    21904, 22201, 22500, 22801,
    23104, 23409, 23716, 24025,
    24336, 24649, 24964, 25281,
    25600, 25921, 26244, 26569,
    26896, 27225, 27556, 27889,
    28224, 28561, 28900, 29241,
    29584, 29929, 30276, 30625,
    30976, 31329, 31684, 32041,
    32400, 32761, 33124, 33489,
    33856, 34225, 34596, 34969,
    35344, 35721, 36100, 36481,
    36864, 37249, 37636, 38025,
    38416, 38809, 39204, 39601,
    40000, 40401, 40804, 41209,
    41616, 42025, 42436, 42849,
    43264, 43681, 44100, 44521,
    44944, 45369, 45796, 46225,
    46656, 47089, 47524, 47961,
    48400, 48841, 49284, 49729,
    50176, 50625, 51076, 51529,
    51984, 52441, 52900, 53361,
    53824, 54289, 54756, 55225,
    55696, 56169, 56644, 57121,
    57600, 58081, 58564, 59049,
    59536, 60025, 60516, 61009,
    61504, 62001, 62500, 63001,
    63504, 64009, 64516, 65025
};

const char text1[52*20]={1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,0,1,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,1,0,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,1,0,1,0,1,0,0,1,0,0,1,0,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,0,0,0,0,0,1,1,1,0,0,0,0,1,1,0,1,0,0,1,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,1,1,1,1,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,1,0,0,0,1,0,0,0,1,1,1,1,1,0};
const char num0[5*7]={
    1,1,1,1,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,1,1,1,1
};
const char num1[5*7]={
    0,0,1,1,0,
    0,0,0,1,0,
    0,0,0,1,0,
    0,0,0,1,0,
    0,0,0,1,0,
    0,0,0,1,0,
    0,1,1,1,1
};
const char num2[5*7]={
    1,1,1,1,1,
    0,0,0,0,1,
    0,0,0,0,1,
    1,1,1,1,1,
    1,0,0,0,0,
    1,0,0,0,0,
    1,1,1,1,1
};
const char num3[5*7]={
    1,1,1,1,1,
    0,0,0,0,1,
    0,0,0,0,1,
    1,1,1,1,1,
    0,0,0,0,1,
    0,0,0,0,1,
    1,1,1,1,1
};
const char num4[5*7]={
    1,0,0,0,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,1,1,1,1,
    0,0,0,0,1,
    0,0,0,0,1,
    0,0,0,0,1
};
const char num5[5*7]={
    1,1,1,1,1,
    1,0,0,0,0,
    1,0,0,0,0,
    1,1,1,1,1,
    0,0,0,0,1,
    0,0,0,0,1,
    1,1,1,1,1
};
const char num6[5*7]={
    1,1,1,1,1,
    1,0,0,0,0,
    1,0,0,0,0,
    1,1,1,1,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,1,1,1,1
};
const char num7[5*7]={
    1,1,1,1,1,
    0,0,0,0,1,
    0,0,0,0,1,
    0,0,0,0,1,
    0,0,0,0,1,
    0,0,0,0,1,
    0,0,0,0,1
};
const char num8[5*7]={
    1,1,1,1,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,1,1,1,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,1,1,1,1
};
const char num9[5*7]={
    1,1,1,1,1,
    1,0,0,0,1,
    1,0,0,0,1,
    1,1,1,1,1,
    0,0,0,0,1,
    0,0,0,0,1,
    1,1,1,1,1
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
    if(memoriza[x] > 0) return memoriza[x];
    const uint16_t *p = squares;
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
    if (p[ 16] <= x) p +=  16;
    if (p[  8] <= x) p +=   8;
    if (p[  4] <= x) p +=   4;
    if (p[  2] <= x) p +=   2;
    if (p[  1] <= x) p +=   1;
    memoriza[x] = p - squares;
    return p - squares;
}


static inline void clearStage(){
	hash = 0;
	sys_init_vcache();
}
static inline void drawPoint(int x, int y, uint8_t color){
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
			drawPoint(x+i, y+j, color);
		}
	}
}


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
		}
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
        }
    }
}

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
    char temp[11];
    int di=0;
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
            temp[di] = '0'+(num%10);
            num/=10;
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
    }
}

static inline void drawStage(){
	if(lhash == hash)return;
	//clear_vram();
	sys_flush_vcache();
	lhash = hash;
}
#endif