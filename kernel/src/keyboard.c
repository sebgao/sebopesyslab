#include "keyboard.h"

static int letter[] = {
	30, 48, 46, 32, 18, 33, 34, 35, 23, 36,
	37, 38, 50, 49, 24, 25, 16, 19, 31, 20,
	22, 47, 17, 45, 21, 44
};
static int keydown[26]={0};

static int lastkey;
//static int px = 50;
//static int py = 50;
//static int pw = 2;


int8_t get_key(char s){
	return keydown[s-'a'];
}
int8_t get_lastkey(){
	return lastkey+'a';
}
void press_key(int code){
	int i=0;
	//printk("haha\n");
	if((code & 0x80) == 0){
		for(;i<26;i++){
			if(letter[i]==code){
				keydown[i] = 1;
				lastkey = i;
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
