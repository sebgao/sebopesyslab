#ifndef __PROCESS_H__
#define __PROCESS_H__
#include "inc/memlayout.h"
#define NPUSTACKTOP 0x300000
#define NPKSTACKTOP 0x200000
#define NPKSTACKSIZE 4*4096
#define PCBPOOLMAX 100
typedef struct PCB {
	struct{
		uint32_t pid;
		uint32_t used;
		struct TrapFrame *tf;
		pde_t *pgdir;
	};
	//uint8_t kstack_0[NPKSTACKSIZE];
	uint8_t kstack[NPKSTACKSIZE];
	uint8_t kstacktop[8];
	uint8_t kstackprotect[8];
} PCB;

extern PCB *current;

void init_pcb_pool();
void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t privilege);
PCB* pcb_create();
void enter_pcb(PCB* pcb);
void switch_pcb(PCB* pcb);
void loader(PCB* pcb, uint32_t offset);
void empty_loader(PCB* pcb, void (*ptr)(void));
#endif
