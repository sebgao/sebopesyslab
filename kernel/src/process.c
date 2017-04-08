#include "common.h"
#include "process.h"
#include "inc/memory.h"
#include "inc/mmu.h"
#include "inc/types.h"
#include "inc/memlayout.h"

PCB PCBPool[PCBPOOLMAX];
struct TrapFrame tfPool[PCBPOOLMAX];
PCB* current;
/*struct TrapFrame {
	//uint32_t esi, ebx, eax, eip, edx, error_code, eflags, ecx, cs, old_esp, edi, ebp;
	uint32_t edi, esi, ebp, old_esp, ebx, edx, ecx, eax;
	//uint32_t gs, fs, es, ds;
	int32_t irq;
	uint32_t error_code, eip, cs, eflags;
	//uint32_t esp;
};*/

void init_pcb_pool()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
		PCBPool[i].used = 0;
	}
}

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry)
{
	struct TrapFrame *tf = (p->tf);
	tf->ds = GD_UD | 3;
	tf->es = GD_UD | 3;
	tf->ss = GD_UD | 3;
	tf->esp = ustack;
	tf->cs = GD_UT | 3;
	tf->eflags = 0x2 | FL_IF;
	tf->eip = entry;
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
	p->tf = &tfPool[i];
	return p;
}

void switch_pcb(PCB* pcb){
	current = pcb;
	enter_pcb(pcb);
}
