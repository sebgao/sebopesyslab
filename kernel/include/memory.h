#ifndef __MEMORY_H__
#define __MEMORY_H__

#include "inc/memory.h"

#define KOFFSET 0xC0000000
//#define KOFFSET	0

CR3* get_kcr3();
PDE* get_kpdir();
PTE* get_kptable();

void make_invalid_pde(PDE *);
void make_invalid_pte(PTE *);
void make_pde(PDE *, void *);
void make_pte(PTE *, void *);

#define va_to_pa(addr) \
	((void*)(((uint32_t)(addr)) - KOFFSET))

#define pa_to_va(addr) \
	((void*)(((uint32_t)(addr)) + KOFFSET))

/* the maxinum kernel size is 16MB */
#define KMEM    (16 * 1024 * 1024)

/* Nanos has 128MB physical memory  */
#define PHY_MEM   (128 * 1024 * 1024)

#endif
