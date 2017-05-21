#ifndef __SEMAPHORE_H__
#define __SEMAPHORE_H__
#include "process.h"

typedef struct Semaphore {
	uint32_t used;
	int count;
	PCB* block_list;
} Semaphore;


#define NR_SEMS 1000

void sem_init_kr(Semaphore* sem, int count);

void sem_close_kr(Semaphore* sem);

void sem_post_kr(Semaphore* sem);

void sem_wait_kr(Semaphore* sem);

Semaphore* sem_open_kr(int index, int count);

int sem_get_kr(Semaphore* sem);
#endif