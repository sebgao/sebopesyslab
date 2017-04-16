#include "common.h"
#include "process.h"
extern PCB PCBPool[PCBPOOLMAX];
extern PCB* current; 
extern void scheduler_switch(PCB* pcb);
extern uint32_t _tick;
uint32_t cpid = 0;
uint32_t count = 0;
void do_scheduler(){
	count ++;
	//printk("%x", _tick);
	 if(count % 3 == 2){
	 	cpid++;
	 	scheduler_switch(&PCBPool[cpid%2]);
	 }
	//scheduler_switch(current);
	//printk("This is do_scheduler! %x\n", (uint32_t)current->used);
	//asm volatile("mov %0, %%esp" : : "r"(tf->esp));
	//asm volatile("jmp %0" : : "r"(switch_proc));
	//printk("%x", _tick);
}