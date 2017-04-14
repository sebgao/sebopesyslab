#ifndef __PROCESS_H__
#define __PROCESS_H__
#include "inc/memlayout.h"
#define NPUSTACKTOP 0x300000
#define NPKSTACKTOP 0x200000
#define NPKSTACKSIZE 4096
#define PCBPOOLMAX 100
typedef struct PCB {
	struct{
		uint32_t used;
		void *tf;
		pde_t *pgdir;
	};
	uint8_t kstack[NPKSTACKSIZE];
} PCB;

extern PCB *current;

void init_pcb_pool();
void init_pcb(PCB *p, uint32_t ustack, uint32_t entry);
PCB* pcb_create();
void enter_pcb(PCB* pcb);
void switch_pcb(PCB* pcb);
#endif
