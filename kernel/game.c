#include "lib/common.h"

#include "lib/irq.h"
#include "lib/video.h"
#include "lib/stage.h"

#define QUICK


static int letter[] = {
	30, 48, 46, 32, 18, 33, 34, 35, 23, 36,
	37, 38, 50, 49, 24, 25, 16, 19, 31, 20,
	22, 47, 17, 45, 21, 44
};
int keydown[26];

//static int px = 50;
//static int py = 50;
//static int pw = 2;
static int timestamp = 1;
static int curtime = 0;
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
static int score;
void dreamOf100HZ(int);

void timer(){
	//printk("7\n");
	timestamp++;
	//printk("8\n");
	if(timestamp % 400 == 0)score++;
	//printk("9\n");
}



void game_logic(){

	//printk("1\n");
	set_keyboard_intr_handler(press);
	//printk("2\n");
	set_timer_intr_handler(timer);
	//printk("3\n");
	enable_interrupt();
	//printk("4\n");
	initVCache();
	//printk("5\n");
	clear_key();
	//printk("6\n");
	while(1){
		
		wait_for_interrupt();
		disable_interrupt();
		while(curtime<timestamp){
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
		curtime++;
		}
		

		enable_interrupt();
		
	}
};




#define domain static

typedef enum{
	GAME_START,
	GAME_READY,
	GAME_ING,
	GAME_END
} GAME_STATUS;

typedef enum{
	MONSTER_ALIVE,
	MONSTER_DEAD,
	MONSTER_READY,
	MONSTER_AWAIT,
	MONSTER_SLEEP
} MONSTER_STATUS;

#define MONSTER_SIZE 20

typedef struct{
	int size;
	int x;
	int y;
	int sx;
	int sy;
	int status;
	int count;
} MONSTER;

extern uint32_t UKISS();
#define REP_MONSTER() for(; i<MONSTER_SIZE; i++)
#define mon monsters[i]
#define abs(x) (x)>0?(x):(-x)
#define KISS() (UKISS()+x+y)


domain GAME_STATUS gameStatus = GAME_START;
domain int x, y, size, score = 0;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
		int dx = x-mon.x; 
		int dy = y-mon.y;
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
		}
	}
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
		if(mon.status == MONSTER_ALIVE){
			mon.x += mon.sx;
			mon.y += mon.sy;

			if(mon.x < 10) mon.x++;
			if(mon.x > VWIDTH-10) mon.x--;
			if(mon.y < 10) mon.y++;
			if(mon.y > VHEIGHT-10) mon.y--;
			int color = size>=mon.size?15:5;
			drawCirc(mon.x, mon.y, mon.size, color);
			if(KISS()%60==0){
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
		if(mon.status == MONSTER_ALIVE) continue;
		if(KISS()%(250*MONSTER_SIZE) == 0){
			mon.status = MONSTER_ALIVE;
			mon.size = 2 + 2*(KISS()%size);
			mon.size = mon.size >14?14:mon.size; 
			mon.x = VWIDTH/2;
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
void dreamOf100HZ(int timestamp){
	/*if(timestamp%6 == 1){
		if(key('a'))x--;
		if(key('d'))x++;
		if(key('w'))y--;
		if(key('s'))y++;
	}
	if(timestamp%5==1){

		clearStage();
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(gameStatus == GAME_START){
		clearStage();
		drawText1();
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();

		int i=0;
		x = 30;
		y = 30;
		size = 4;
		score = 0;
		monsters[i].status = MONSTER_ALIVE;
		monsters[i].size = 1 + (KISS()%size);
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
			monsters[i].status = MONSTER_SLEEP;
			monsters[i].count = 0;
			if(KISS()%MONSTER_SIZE < size+3){
				monsters[i].status = MONSTER_ALIVE;
				monsters[i].size = 1 + 2*(KISS()%size);
				monsters[i].x = KISS()%VWIDTH;
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printk("Press Q to start\n");
		gameStatus = GAME_READY;
	}
	if(gameStatus == GAME_READY){
		if(key('q') ){
			printk("Press W, A, S, D to move\n");
			gameStatus = GAME_ING;
		}
	}

	if(gameStatus == GAME_ING){




		//if(x>0 && x<VWIDTH && y>0 && y<VHEIGHT){
		//if(timestamp % 3){
			if(key('a'))x--;
			if(key('d'))x++;
			if(key('w'))y--;
			if(key('s'))y++;
		//}

		if(x < 0) x++;
		if(x > VWIDTH) x--;
		if(y < 0) y++;
		if(y > VHEIGHT) y--;
		//}
		//else{
		clearStage();
		drawCirc(x, y, size, 3);
		

		drawMonster();
		drawCirc(x, y, size, 3);
		drawNumber(score, 0, 180, 1, 7);
		drawStage();
		
		
		createMonster();
		while(hitMonster());
		//}
	}
	if(gameStatus == GAME_END){
		printk("You're dead\n");
		printk("Score: %d\n", score);
		clearStage();
		drawStage();
		gameStatus = GAME_START;
	}
}