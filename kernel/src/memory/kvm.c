#include "inc/x86.h"

#include "process.h"
#include "memory.h"
#include "common.h"
#include "pmap.h"
//#include "string.h"

/* This source file involves some hardware details. Please refer to 
 *  _ ____   ___    __    __  __                         _ 
 * (_)___ \ / _ \  / /   |  \/  |                       | |
 *  _  __) | (_) |/ /_   | \  / | __ _ _ __  _   _  __ _| |
 * | ||__ < > _ <| '_ \  | |\/| |/ _` | '_ \| | | |/ _` | |
 * | |___) | (_) | (_) | | |  | | (_| | | | | |_| | (_| | |
 * |_|____/ \___/ \___/  |_|  |_|\__,_|_| |_|\__,_|\__,_|_|
 */                                                               

/* These data structures are shared by all kernel threads. */
static CR3 kcr3;											// kernel CR3
static PDE kpdir[NR_PDE] align_to_page;						// kernel page directory
static PTE kptable[PHY_MEM / PAGE_SIZE] align_to_page;		// kernel page tables

/* You may use these interfaces in the future */
CR3* get_kcr3() {
	return &kcr3;
}

PDE* get_kpdir() {
	return kpdir;
}

PTE* get_kptable() {
	return kptable;
}

/* Build a page table for the kernel */
void
init_page(void) {
	page_init();
}

/* One TSS will be enough for all processes in ring 3. It will be used in Lab3. */
static TSS tss; 

static void set_tss(SegDesc *ptr) {
	tss.ss0 = SELECTOR_KERNEL(SEG_KERNEL_DATA);		// only one ring 0 stack segment
	//tss.esp0 = KSTACKTOP;
	uint32_t base = (uint32_t)&tss;
	uint32_t limit = sizeof(TSS) - 1;
	ptr->limit_15_0  = limit & 0xffff;
	ptr->base_15_0   = base & 0xffff;
	ptr->base_23_16  = (base >> 16) & 0xff;
	ptr->type = SEG_TSS_32BIT;
	ptr->segment_type = 0;
	ptr->privilege_level = DPL_USER;
	ptr->present = 1;
	ptr->limit_19_16 = limit >> 16;
	ptr->soft_use = 0;
	ptr->operation_size = 0;
	ptr->pad0 = 1;
	ptr->granularity = 0;
	ptr->base_31_24  = base >> 24;
}

void set_tss_esp0(uint32_t esp) {
	tss.esp0 = esp;
}

/* GDT in the kernel's memory, whose virtual memory is greater than 0xC0000000. */
static SegDesc gdt[NR_SEGMENTS];

static void
set_segment(SegDesc *ptr, uint32_t pl, uint32_t type) {
	ptr->limit_15_0  = 0xFFFF;
	ptr->base_15_0   = 0x0;
	ptr->base_23_16  = 0x0;
	ptr->type = type;
	ptr->segment_type = 1;
	ptr->privilege_level = pl;
	ptr->present = 1;
	ptr->limit_19_16 = 0xF;
	ptr->soft_use = 0;
	ptr->operation_size = 0;
	ptr->pad0 = 1;
	ptr->granularity = 1;
	ptr->base_31_24  = 0x0;
}

/* This is similar with the one in the bootloader. However the
   previous one cannot be accessed in user process, because its virtual
   address below 0xC0000000, and is not in the process' address space. */

void
init_segment(void) {
	memset(gdt, 0, sizeof(gdt));
	set_segment(&gdt[SEG_KERNEL_CODE], DPL_KERNEL, SEG_EXECUTABLE | SEG_READABLE);
	set_segment(&gdt[SEG_KERNEL_DATA], DPL_KERNEL, SEG_WRITABLE );
	set_segment(&gdt[SEG_USER_CODE], DPL_USER, SEG_EXECUTABLE | SEG_READABLE);
	set_segment(&gdt[SEG_USER_DATA], DPL_USER, SEG_WRITABLE );


	//set_segment(&gdt[SEG_TSS], DPL_USER, SEG_EXECUTABLE | SEG_READABLE );

	write_gdtr(gdt, sizeof(gdt));

	set_tss(&gdt[SEG_TSS]);
	write_tr( SELECTOR_USER(SEG_TSS) );
}


void enter_pcb(PCB* pcb)
{
	lcr3(PADDR(pcb->pgdir));
	//printk("2\n");
	set_tss_esp0((uint32_t)(pcb->kstacktop));
	//printk("3\n");
	struct TrapFrame *tf = pcb->tf;
	//disable_interrupt();
	//asm volatile("cli");
	asm volatile("mov %0, %%ds" : : "r"(tf->ds));
	//printk("0\n");
	asm volatile("mov %0, %%es" : : "r"(tf->es));
	//printk("0\n");
	asm volatile("mov %0, %%fs" : : "r"(tf->fs));
	//printk("0\n");
	asm volatile("mov %0, %%gs" : : "r"(tf->gs));
	//printk("0\n");
	asm volatile("pushl %0" : : "r"((uint32_t)tf->ss));
	asm volatile("pushl %0" : : "r"(tf->esp));
	asm volatile("pushl %0" : : "r"(tf->eflags));
	asm volatile("pushl %0" : : "r"((uint32_t)tf->cs));
	asm volatile("pushl %0" : : "r"(tf->eip));
	asm volatile("iret"); 
}
void switch_proc();
extern PCB* current;
void scheduler_switch(PCB* pcb){
	//disable_interrupt();
	current = pcb;
	//printk("A\n");
	lcr3(PADDR(pcb->pgdir));
	//printk("B\n");
	set_tss_esp0((uint32_t)(pcb->kstacktop));
	//printk("--PID %d\n", pcb->pid);
	//printk("--NOW ESP = %x\n", pcb->tf);
	//printk("--TT %x\n", pcb->tt);
	asm volatile("mov %0, %%esp" : : "m"(pcb->tf));
	asm volatile("jmp %0" : : "r"(switch_proc));

}
