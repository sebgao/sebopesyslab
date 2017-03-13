#include "lib/common.h"

#include "lib/irq.h"
#include "lib/video.h"
#include "lib/stage.h"
static int letter[] = {
	30, 48, 46, 32, 18, 33, 34, 35, 23, 36,
	37, 38, 50, 49, 24, 25, 16, 19, 31, 20,
	22, 47, 17, 45, 21, 44
};
static int keydown[26];

//static int px = 50;
//static int py = 50;
//static int pw = 2;
static int timestamp = 0;
static inline void clear_key(){
	int i = 0;
	for(i=0; i<26; i++){
		keydown[i] = 0;
	}
}
static inline int8_t key(char s){
	return keydown[s-'a'];
}
void press(int code){
	int i=0;
	if((code & 0x80) == 0){
		for(;i<26;i++){
			if(letter[i]==code){
				keydown[i] = 1;
				return;
			}
		}
	}else{
		code &= 0x7F;
		for(;i<26;i++){
			if(letter[i]==code){
				keydown[i] = 0;
				return;
			}
		}
	}
}
int x=0, y=0;
void timer(){
	disable_interrupt();
	timestamp++;
	if(timestamp%10==1){

		if(key('a'))x--;
		if(key('d'))x++;
		if(key('w'))y--;
		if(key('s'))y++;

		clearStage();
		drawRect(x, y, 6, 3, 3);
		drawStage();
	}
	
	enable_interrupt();
}



void game_logic(){


	set_keyboard_intr_handler(press);
	set_timer_intr_handler(timer);
	enable_interrupt();
	initVCache();
	clear_key();
	while(1){
		//printk("We wait\n");
		wait_for_interrupt();
		

		
	}
};