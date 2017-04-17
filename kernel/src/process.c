#include "common.h"
#include "process.h"
#include "inc/memory.h"
#include "inc/mmu.h"
#include "inc/types.h"
#include "inc/memlayout.h"
#include "pmap.h"

PCB PCBPool[PCBPOOLMAX];
struct TrapFrame tfPool[PCBPOOLMAX];
uint32_t pid=0;
PCB* current = NULL;

PCB* ready_list = NULL;
PCB* sleep_list = NULL;
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
	// current= &PCBPool[0];
	// current->used = 1;
	// current->tf = &tfPool[0];
}

void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t pri)
{
	struct TrapFrame *tf = (p->tf);
	if(pri == 0){
		tf->ds = GD_KD;
		tf->es = GD_KD;
		tf->ss = GD_KD;
		tf->fs = GD_KD;
		tf->gs = GD_KD;
		tf->cs = GD_KT;
		tf->eflags = 0x2 | FL_IF;
	}else
	if(pri == 3){
		tf->ds = GD_UD | 3;
		tf->es = GD_UD | 3;
		tf->ss = GD_UD | 3;
		tf->fs = GD_UD | 3;
		tf->gs = GD_UD | 3;
		tf->cs = GD_UT | 3;
		tf->eflags = 0x2 | FL_IF;
	}
	
	tf->esp = ustack;

	//printk("%x %x %x\n", p->kstacktop, tf, p);
	tf->eip = entry;
	//lcr3(PADDR(p -> pgdir));
	if(pri == 0){
		uint32_t* ptr1 = (void*)(ustack);
		uint32_t* ptr2 = (void*)tf;
		uint32_t si = sizeof(struct TrapFrame);
		uint32_t i;
		for (i = 0; i < si/4; ++i)
		{
			ptr1[i] = ptr2[i];
		}
		//memcpy((void*)ustack, tf, sizeof(tf));
		p->tf = (void*)ptr1;
	}
	//lcr3(PADDR(kern_pgdir));
}

PCB* pcb_create()
{
	uint32_t i;
	for(i=0; i<PCBPOOLMAX; i++){
		if(!PCBPool[i].used)break;
	}
	PCB *p = &PCBPool[i];
	p->tf = &tfPool[i];
	p->used = 1;
	struct PageInfo *pp = page_alloc(ALLOC_ZERO);
	//printk("0x%x\n", page2kva(pp));
	if (pp == NULL) return NULL;
	p->pgdir = page2kva(pp);
	p->pid = pid;
	p->timeslice = 0;
	//p->ts = READY;
	pid ++;
	//printk("%x %x\n", p->pgdir, pp);
	pp->pp_ref ++;
	memcpy(p->pgdir, kern_pgdir, PGSIZE);
	//PCBPoolByte[0] = 3;
	//printk("This is pcb_create! %x\n", (uint32_t)current);
	return p;
}

void enready_pcb(PCB* pcb){
	if(ready_list == NULL){
		ready_list = pcb;
		ready_list->tail = pcb;
	}else{
		PCB* temp = ready_list;
		ready_list = pcb;
		ready_list->next = temp;
		ready_list->tail = temp->tail;
	}
}

void switch_pcb(PCB* pcb){
	current = pcb;
	lcr3(PADDR(pcb -> pgdir));
	//printk("This is switch_pcb! %x\n", (uint32_t)current->pid);
	//printk("0\n");
	//lcr3(PADDR(pcb -> pgdir));
	//printk("1\n");
	enter_pcb(pcb);
}
