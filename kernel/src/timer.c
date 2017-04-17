#include "common.h"
#include "lib/syscall.h"
#include "process.h"
uint32_t _tick = 0;
uint32_t lislen(PCB* head){
	uint32_t i = 0;
	while(head){
		head = head->next;
		i++;
	}
	return i;
}
uint32_t find_and_wake(){
	if(sleep_list == NULL)return 0;
	PCB *sleep = sleep_list, *pre = NULL;

	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep->timeslice <= 0)
			break;
		pre = sleep;
		sleep = sleep->next;
	}
	sleep->ts = READY;

	PCB* p=ready_list;

	if(p == NULL){
		ready_list = sleep;
	}else{
		while(p->next){
			p=p->next;
		}
		p->next = sleep;
	}


	if(pre == NULL)
		sleep_list = sleep->next;
	else
		pre->next = sleep->next;
	//sleep_list = sleep->next;

	sleep->next = NULL;

	return 1;
}
void do_timer(){
	_tick++;
	current->timeslice ++;

	PCB *sleep = sleep_list;
	//printk("%x\n", sleep);
	 while(1){
	 	if(sleep == NULL)break;
	 	sleep->timeslice --;
	 	//printk("t\n");
			//pre->next = sleep->next;
	 		//printk("h\n");
	// 		PCB* select = sleep;

	// 		if(pre == sleep){
	// 			sleep_list = NULL;
	// 		}else{
	// 			pre->next = sleep->next;
	// 		}
	// 		select->next = NULL;
	// 		select->ts = READY;
	// 		ready_list->tail->next = select;
	// 		ready_list->tail = select;
	 	sleep = sleep->next;
	}
	while(find_and_wake());
	//printk("lislen %d\n", lislen(sleep_list));
	//printk("realen %d\n", lislen(ready_list));
}
uint32_t tick(){
	return _tick;
}