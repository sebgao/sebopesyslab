#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;

void do_timer(){
	_tick++;
	current->timeslice ++;

	PCB *sleep = sleep_list, *cur;
	 while(1){
	 	if(sleep == NULL)break;
	 	sleep->timeslice --;
	 	
	 	cur = sleep;

	 	sleep = sleep->next;

	 	if(cur->timeslice > 0) continue;
	 	cur->ts = READY;
		ll_delete(&sleep_list, cur);
		ll_entail(&ready_list, cur);
	}
}
uint32_t tick(){
	return _tick;
}