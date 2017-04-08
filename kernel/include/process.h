#ifndef __PROCESS_H__
#define __PROCESS_H__

#define USTACKTOP 0x300000
#define KSTACKTOP 0x200000

typedef struct PCB {
	uint32_t used;
	void *tf;
} PCB;

extern PCB *current;

void init_user_tf(PCB *p, uint32_t entry);
PCB* pcb_create();
void switch_process(PCB *p);
void enter_user_space(struct TrapFrame *tf);
#endif
