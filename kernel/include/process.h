#ifndef __PROCESS_H__
#define __PROCESS_H__

#define USTACKTOP 0x300000
#define KSTACKTOP 0x200000
#define KSTACKSIZE 4096
#define PCBPOOLMAX 100
typedef struct PCB {
	uint32_t used;
	void *tf;
	uint8_t kstack[KSTACKSIZE];
} PCB;

extern PCB *current;

void init_pcb_pool();
void init_pcb(PCB *p, uint32_t ustack, uint32_t entry);
PCB* pcb_create();
void enter_pcb(PCB* pcb);
void switch_pcb(PCB* pcb);
#endif
