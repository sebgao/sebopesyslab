#ifndef __PROCESS_H__
#define __PROCESS_H__
#include "inc/memlayout.h"
#define NPUSTACKTOP 0x300000
#define NPKSTACKTOP 0x200000
#define NPKSTACKSIZE 0x1000
#define PCBPOOLMAX 1000
typedef enum{
	READY,
	RUNNING,
	STOP,
	SLEEPING,
	HUNGUP
}TASK_STATE;
typedef enum{
	KERNEL,
	USER,
	THREAD
}TASK_TYPE;
typedef struct PCB {
	uint8_t kstackbottom[0x10];
	uint8_t kstack0[NPKSTACKSIZE];
	uint8_t kstack0top[0x10];
	uint8_t kstack[NPKSTACKSIZE];
	uint8_t kstacktop[0x10];
	uint8_t kstackprotect[0x10];
	struct{
		uint32_t used;
		uint32_t pid;
		uint32_t ppid;
		TASK_STATE ts;
		TASK_TYPE tt;
		uint32_t timeslice;
		struct TrapFrame *tf;
		pde_t *pgdir;
	};
	struct PCB *next;
	struct PCB *tail;
	struct PCB *join_list;
} PCB;

#define FORKKSTACKSIZE ((NPKSTACKSIZE>>1)+(0x10))
extern PCB *current;

extern PCB* ready_list;
extern PCB* sleep_list;

void init_pcb_pool();
void init_pcb(PCB *p, uint32_t ustack, uint32_t entry, uint8_t privilege);
PCB* pcb_create();
void enter_pcb(PCB* pcb);
void switch_pcb(PCB* pcb);
void enready_pcb(PCB* pcb);

void do_scheduler();

void loader(PCB* pcb, uint32_t offset);
void empty_loader(PCB* pcb, void (*ptr)(void));

uint32_t ll_len(PCB** head);
PCB* 	 ll_pop(PCB** head);
uint32_t ll_push(PCB** head, PCB* p);
uint32_t ll_entail(PCB** head, PCB* p);
uint32_t ll_delete(PCB** head, PCB* p);
void exit_current();
void fork_current();
void thread_current(uint32_t entry, uint32_t esp);

void join_current(int pid);
#endif
