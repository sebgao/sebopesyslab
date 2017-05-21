#include "semaphore.h"

Semaphore sems[NR_SEMS];

void sem_init_kr(Semaphore* sem, int count){
	if(!sem->used){
		sem->count = count;
		sem->used = 1;
	}
	
}

void sem_close_kr(Semaphore* sem){
	if(sem->used){
		sem->used = 0;
	}
}

void sem_post_kr(Semaphore* sem){
	sem->count ++;
	if(sem->count<=0){
		PCB* pcb = ll_pop(&sem->block_list);
		ll_entail(&ready_list, pcb);
	}
}

void sem_wait_kr(Semaphore* sem){
	sem->count --;
	if(sem->count < 0){
		PCB* cur = current;
		ll_entail(&sem->block_list, cur);
		current = NULL;
		do_scheduler();
	}
}

int sem_get_kr(Semaphore* sem){
	return sem->count;
}

Semaphore* sem_open_kr(int index, int count){
	Semaphore* sem = &sems[index];
	sem_init_kr(sem, count);
	return sem;
}
