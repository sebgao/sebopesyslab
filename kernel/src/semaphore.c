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
		PCB* pcb;
		while(1){
			pcb = ll_pop(&sem->block_list);
			if(pcb == NULL) break;
			ll_entail(&ready_list, pcb);
		}
	}
}

void sem_post_kr(Semaphore* sem){
	if(!sem->used)return;
	sem->count ++;
	if(sem->count<=0){
		PCB* pcb = ll_pop(&sem->block_list);
		ll_entail(&ready_list, pcb);
	}
}

void sem_wait_kr(Semaphore* sem){
	if(!sem->used)return;
	sem->count --;
	if(sem->count < 0){
		PCB* cur = current;
		ll_entail(&sem->block_list, cur);
		current = NULL;
		do_scheduler();
	}
}

int sem_trywait_kr(Semaphore* sem){
	if(!sem->used)return -1;
	if(sem->count <=0){
		return 0;
	}
	else{
		sem->count--;
		return 1;
	}

}

int sem_get_kr(Semaphore* sem){
	if(!sem->used)return 0;
	return sem->count;
}

Semaphore* sem_open_kr(int index, int count){
	Semaphore* sem = &sems[index];
	sem_init_kr(sem, count);
	return sem;
}
