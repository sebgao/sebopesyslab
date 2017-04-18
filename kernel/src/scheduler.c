#include "common.h"
#include "process.h"
extern PCB PCBPool[PCBPOOLMAX];
extern PCB* current; 
extern void scheduler_switch(PCB* pcb);
extern uint32_t _tick;
uint32_t cpid = 0;
uint32_t count = 0;

//PCB* ready;



void do_scheduler(){
	count ++;

	if(current == NULL){
		/*
		current = ready_list;
		ready_list = ready_list -> next;

		//current->tail = current;
		//current->next = NULL;
		*/
		//ll_entail(&ready_list, current);
		current = ll_pop(&ready_list);

		current->ts = RUNNING;
		current->timeslice = 0;

		scheduler_switch(current);
		return;
	}
	if(current->ts == SLEEPING){

		//current->ts = SLEEPING;

		ll_entail(&sleep_list, current);

		current = NULL;
		do_scheduler();
		//current = NULL;
		//do_scheduler();
		return;
		//printk("sleep_list\n");
		//PCB* p = ready_list;
		/*if(sleep_list == NULL){
			sleep_list = current;
			sleep_list->tail = sleep_list;
		}else{
			//sleep_list->tail->next = current;
			//sleep_list->tail = current;
		}

		//current->timeslice = 0;

		PCB* t = ready_list;

		//ready_list = t->next;
		//ready_list->tail

		current = t;
		current->ts = RUNNING;
		//current->next = 0;
		scheduler_switch(current);
		return;*/
	}
	if(current->timeslice > 3 || current->ts == STOP){

		current->ts = READY;

		ll_entail(&ready_list, current);
		

		current = NULL;
		do_scheduler();
		//scheduler_switch(current);
		return;
	}
	//printk("%x", _tick);
	 /*if(count % 3 == 0){
	 	cpid++;
	 	scheduler_switch(&PCBPool[cpid%3+1]);
	 }*/
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
}