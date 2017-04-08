#include "common.h"
#include "process.h"
#include "inc/memory.h"
#include "inc/mmu.h"

PCB PCBPool[100];
struct TrapFrame tfPool[100];

/*struct TrapFrame {
	//uint32_t esi, ebx, eax, eip, edx, error_code, eflags, ecx, cs, old_esp, edi, ebp;
	uint32_t edi, esi, ebp, old_esp, ebx, edx, ecx, eax;
	//uint32_t gs, fs, es, ds;
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

void init_user_tf(PCB *p, uint32_t entry)
{
	struct TrapFrame *tf = (p->tf);
	//tf->ds = SELECTOR_USER(SEG_USER_DATA);
	//tf->es = SELECTOR_USER(SEG_USER_DATA);
	//tf->ss = SELECTOR_USER(SEG_USER_DATA);
	tf->old_esp = USTACKTOP - 8;
	tf->eip = entry;
	tf->cs = SELECTOR_USER(SEG_USER_CODE);
	tf->eflags = 0x2 | FL_IF;
	p->tf = tf;
}

PCB* pcb_create()
{
	PCB *p = &PCBPool[0];
	p->tf = &tfPool[0];
	return p;
}


