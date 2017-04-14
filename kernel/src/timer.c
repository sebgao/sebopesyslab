#include "common.h"
#include "lib/syscall.h"


uint32_t _tick = 0;
void do_timer(){
	_tick++;
	//printk("%x", _tick);
}
uint32_t tick(){
	return _tick;
}