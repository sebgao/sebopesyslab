#ifndef JOS_INC_X86_H
#define JOS_INC_X86_H

#include <inc/types.h>

#include "memory.h"

struct GateDescriptor {
	uint32_t offset_15_0      : 16;
	uint32_t segment          : 16;
	uint32_t pad0             : 8;
	uint32_t type             : 4;
	uint32_t system           : 1;
	uint32_t privilege_level  : 2;
	uint32_t present          : 1;
	uint32_t offset_31_16     : 16;
};

struct TrapFrame {
	uint32_t edi, esi, ebp, old_esp, ebx, edx, ecx, eax;
	uint32_t gs, fs, es, ds;

	int32_t irq;
	uint32_t error_code;

	uint32_t eip;
	uint16_t cs;
	uint16_t padding3;

	uint32_t eflags;

	uint32_t esp;
	uint16_t ss;
	uint16_t padding4;
};

static inline void
wait_for_interrupt() {
	asm volatile("hlt");
}

/* 修改IDRT */
static inline void
save_idt(void *addr, uint32_t size) {
	static volatile uint16_t data[3];
	data[0] = size - 1;
	data[1] = (uint32_t)addr;
	data[2] = ((uint32_t)addr) >> 16;
	asm volatile("lidt (%0)" : : "r"(data));
}

/* 打开外部中断 */
static inline void
enable_interrupt(void) {
	asm volatile("sti");
}

/* 关闭外部中断 */
static inline void
disable_interrupt(void) {
	asm volatile("cli");
}


typedef union CR0 {
	struct {
		uint32_t protect_enable      : 1;
		uint32_t monitor_coprocessor : 1;
		uint32_t emulation           : 1;
		uint32_t task_switched       : 1;
		uint32_t extension_type      : 1;
		uint32_t numeric_error       : 1;
		uint32_t pad0                : 10;
		uint32_t write_protect       : 1; 
		uint32_t pad1                : 1; 
		uint32_t alignment_mask      : 1;
		uint32_t pad2                : 10;
		uint32_t no_write_through    : 1;
		uint32_t cache_disable       : 1;
		uint32_t paging              : 1;
	};
	uint32_t val;
} CR0;

/* the Control Register 3 (physical address of page directory) */
typedef union CR3 {
	struct {
		uint32_t pad0                : 3;
		uint32_t page_write_through  : 1;
		uint32_t page_cache_disable  : 1;
		uint32_t pad1                : 7;
		uint32_t page_directory_base : 20;
	};
	uint32_t val;
} CR3;

/* read CR0 */
static inline uint32_t
read_cr0() {
	uint32_t val;
	asm volatile("movl %%cr0, %0" : "=r"(val));
	return val;
}

/* write CR0 */
static inline void
write_cr0(CR0 *cr0) {
	asm volatile("movl %0, %%cr0" : : "r"(cr0->val));
}

/* write CR3, notice that CR3 are never read in Nanos */
static inline void
write_cr3(CR3 *cr3) {
	asm volatile("movl %0, %%cr3" : : "r"(cr3->val));
}

/* modify the value of GDTR */
static inline void
write_gdtr(void *addr, uint32_t size) {
	static volatile uint16_t data[3];
	data[0] = size - 1;
	data[1] = (uint32_t)addr;
	data[2] = ((uint32_t)addr) >> 16;
	asm volatile("lgdt (%0)" : : "r"(data));
}

/* modify the value of IDTR */
static inline void
write_idtr(void *addr, uint32_t size) {
	static volatile uint16_t data[3];
	data[0] = size - 1;
	data[1] = (uint32_t)addr;
	data[2] = ((uint32_t)addr) >> 16;
	asm volatile("lidt (%0)" : : "r"(data));
}

/* write TR */
static inline void
write_tr(uint16_t selector) {
	asm volatile("ltr %0" : : "r"(selector));
}

/* enable interrupt */
static inline void
sti(void) {
	asm volatile("sti");
}

/* disable interrupt */
static inline void
cli(void) {
	asm volatile("cli");
}

/* put the CPU into idle, waiting for the next interrupt */
static inline void
wait_intr() {
	asm volatile("hlt");
}

#define NR_IRQ    256

static __inline void breakpoint(void) __attribute__((always_inline));
static __inline uint8_t inb(int port) __attribute__((always_inline));
static __inline void insb(int port, void *addr, int cnt) __attribute__((always_inline));
static __inline uint16_t inw(int port) __attribute__((always_inline));
static __inline void insw(int port, void *addr, int cnt) __attribute__((always_inline));
static __inline uint32_t inl(int port) __attribute__((always_inline));
static __inline void insl(int port, void *addr, int cnt) __attribute__((always_inline));
static __inline void outb(int port, uint8_t data) __attribute__((always_inline));
static __inline void outsb(int port, const void *addr, int cnt) __attribute__((always_inline));
static __inline void outw(int port, uint16_t data) __attribute__((always_inline));
static __inline void outsw(int port, const void *addr, int cnt) __attribute__((always_inline));
static __inline void outsl(int port, const void *addr, int cnt) __attribute__((always_inline));
static __inline void outl(int port, uint32_t data) __attribute__((always_inline));
static __inline void invlpg(void *addr) __attribute__((always_inline));
static __inline void lidt(void *p) __attribute__((always_inline));
static __inline void lldt(uint16_t sel) __attribute__((always_inline));
static __inline void ltr(uint16_t sel) __attribute__((always_inline));
static __inline void lcr0(uint32_t val) __attribute__((always_inline));
static __inline uint32_t rcr0(void) __attribute__((always_inline));
static __inline uint32_t rcr2(void) __attribute__((always_inline));
static __inline void lcr3(uint32_t val) __attribute__((always_inline));
static __inline uint32_t rcr3(void) __attribute__((always_inline));
static __inline void lcr4(uint32_t val) __attribute__((always_inline));
static __inline uint32_t rcr4(void) __attribute__((always_inline));
static __inline void tlbflush(void) __attribute__((always_inline));
static __inline uint32_t read_eflags(void) __attribute__((always_inline));
static __inline void write_eflags(uint32_t eflags) __attribute__((always_inline));
static __inline uint32_t read_ebp(void) __attribute__((always_inline));
static __inline uint32_t read_esp(void) __attribute__((always_inline));
static __inline void cpuid(uint32_t info, uint32_t *eaxp, uint32_t *ebxp, uint32_t *ecxp, uint32_t *edxp);
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
}

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
	return data;
}

static __inline void
insb(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsb"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline uint16_t
inw(int port)
{
	uint16_t data;
	__asm __volatile("inw %w1,%0" : "=a" (data) : "d" (port));
	return data;
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
	return data;
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
}

static __inline void
outsb(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsb"		:
			 "=S" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "cc");
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
}

static __inline void
outsw(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsw"		:
			 "=S" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "cc");
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
			 "=S" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "cc");
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
}

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
	return val;
}

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
	return val;
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
}

static __inline uint32_t
rcr3(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr3,%0" : "=r" (val));
	return val;
}

static __inline void
lcr4(uint32_t val)
{
	__asm __volatile("movl %0,%%cr4" : : "r" (val));
}

static __inline uint32_t
rcr4(void)
{
	uint32_t cr4;
	__asm __volatile("movl %%cr4,%0" : "=r" (cr4));
	return cr4;
}

static __inline void
tlbflush(void)
{
	uint32_t cr3;
	__asm __volatile("movl %%cr3,%0" : "=r" (cr3));
	__asm __volatile("movl %0,%%cr3" : : "r" (cr3));
}

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
	return eflags;
}

static __inline void
write_eflags(uint32_t eflags)
{
	__asm __volatile("pushl %0; popfl" : : "r" (eflags));
}

static __inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	__asm __volatile("movl %%ebp,%0" : "=r" (ebp));
	return ebp;
}

static __inline uint32_t
read_esp(void)
{
	uint32_t esp;
	__asm __volatile("movl %%esp,%0" : "=r" (esp));
	return esp;
}

static __inline void
cpuid(uint32_t info, uint32_t *eaxp, uint32_t *ebxp, uint32_t *ecxp, uint32_t *edxp)
{
	uint32_t eax, ebx, ecx, edx;
	asm volatile("cpuid"
		: "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
		: "a" (info));
	if (eaxp)
		*eaxp = eax;
	if (ebxp)
		*ebxp = ebx;
	if (ecxp)
		*ecxp = ecx;
	if (edxp)
		*edxp = edx;
}

static __inline uint64_t
read_tsc(void)
{
	uint64_t tsc;
	__asm __volatile("rdtsc" : "=A" (tsc));
	return tsc;
}

static inline uint32_t
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
			"+m" (*addr), "=a" (result) :
			"1" (newval) :
			"cc");
	return result;
}

#endif /* !JOS_INC_X86_H */