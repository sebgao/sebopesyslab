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

uint32_t ll_len(PCB** head){
	uint32_t i = 0;
	PCB* p = *head;
	while(p){
		p = p->next;
		i++;
	}
	return i;
}
PCB* ll_pop(PCB** head){
	PCB* p = *head;
	ll_delete(head, p);
	return p;
}
uint32_t ll_push(PCB** head, PCB* p){
	PCB* h = *head;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		*head = p;
		p->next = h;
		return 1;
	}
}
uint32_t ll_entail(PCB** head, PCB* p){
	PCB* h = *head;
	p->next = NULL;
	if(h == NULL){
		*head = p;
		return 0;
	}else{
		while(h->next){
			h = h->next;
		}
		h->next = p;
		return 1;
	}
}
uint32_t ll_delete(PCB** head, PCB* p){
	PCB *sleep = *head, *pre = NULL;
	while(1){
		if(sleep == NULL)
			return 0;
		if(sleep == p)
			break;
		pre = sleep;
		sleep = sleep->next;
	}
	if(pre == NULL)
		*head = sleep->next;
	else
		pre->next = sleep->next;
	sleep->next = NULL;
	return 1;
}

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
	p->tt = pri==0?KERNEL:USER;
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
void free_pcb(PCB* pcb){
	free_pgdir(pcb->pgdir);
	page_decref(pa2page(PADDR(pcb->pgdir)));
	pcb->used = 0;

}

void copy_pcb(PCB *dst, PCB *src)
{
	//lcr3(PADDR(dst->pgdir));
	//src->kstackprotect[0]=99;
	memcpy((void*)dst->kstackbottom, (void*)src->kstackbottom, FORKKSTACKSIZE);
	//printk("FF: %d\n", dst->kstackprotect[0]);
	//printk("KTOP: %d %d\n", dst->kstacktop[-20], src->kstacktop[-20]);
	dst->timeslice = src->timeslice;
	//printk("KSTACK: %d\n", ((void*)src->tf - (void*)src->kstack));
	uint32_t offset = (uint32_t)((void*)dst->kstack - (void*)src->kstack);
	dst->tf = (void*)src->tf + offset;
	//dst->tf->esp = (uint32_t)((void*)dst->kstack + ((void*)src->tf->esp - (void*)src->kstack));
	dst->tt = src->tt;

	if(dst->tt == KERNEL){
		
		dst->tf->ebp += offset;
		uint32_t* ptr = (uint32_t*)dst->tf->ebp;
		while(*(ptr)!=0){
			*(ptr) += offset;
			ptr = (uint32_t*)*(ptr);
		}
	//printk("KTOP: %x %x\n", (dst->tf->cs), (src->tf->cs));
		dst->ts = src->ts;
	}

	copy_pgdir(dst->pgdir, src->pgdir);

	//lcr3(PADDR(kern_pgdir));
}
void empty(){
	while(1){
		//printk("-%x\n", *(uint32_t*)(0xc010141d));
		//sys_handout();
	}
	//while(1){
	//	printk("%x\n", current->tf->cs&0x8);
	//};
	//printk("EMPty %x\n", current->tf->ebp);
}
void switch_proc();
void fork_current(){
	PCB* son = pcb_create();
	son->ppid = current->pid;
	copy_pcb(son, current);
	current->tf->eax = son->pid;
	//printk("X:%d\n", son->pid);
	son->tf->eax = 0;
	//son->tf->eip = (uint32_t)empty;
	ll_push(&ready_list, son);
	//JMP:
	//printk("FORK %x\n", current->tf->ebp);
	//printk("%x \n", current->tf->eip);
	//enter_pcb(son);
	//current->ts = STOP;
	//do_scheduler();
	//exit_current();
	//son->tf->eip = (uint32_t)empty;
	//printk("EIP %x %x\n", son->tf->eip, current->tf->eip);
	//printk("SWI %x\n", switch_proc);
}

void exit_current(){
	free_pcb(current);
	lcr3(PADDR(kern_pgdir));
	current = NULL;
	do_scheduler();
}