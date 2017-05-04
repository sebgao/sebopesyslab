#include "inc/memlayout.h"
#include "inc/x86.h"
#include "inc/types.h"
#include "pmap.h"
#include "memory.h"
#include "common.h"
#include "syscall.h"
			// Amount of physical memory (in pages)
#define false 0
#define true 1
// These variables are set in mem_init()
//pde_t *kern_pgdir;		// Kernel's initial page directory
pde_t *kern_pgdir;		// Kernel's initial page directory
struct PageInfo pages[npages];		// Physical page state array
static struct PageInfo *page_free_list;	// Free list of physical pages

 __attribute__((__aligned__(PGSIZE)))
static pde_t kpgdir[NPDENTRIES];

__attribute__((__aligned__(PGSIZE)))
static pte_t kpgtable[PHY_MEM / PGSIZE];


// --------------------------------------------------------------
// Tracking of physical pages.
// The 'pages' array has one 'struct PageInfo' entry per physical page.
// Pages are reference counted, and free pages are kept on a linked list.
// --------------------------------------------------------------

void mm_alloc(pde_t *pgdir, uint32_t va, size_t len)
{
  struct PageInfo *p;
  uint32_t va_start = ROUNDDOWN(va, PGSIZE);
  uint32_t va_end = ROUNDUP(va+len, PGSIZE);
  int i;

  for (i = va_start; i < va_end; i += PGSIZE) {
    p = page_alloc(0);
    //assert(p != NULL);
    page_insert(pgdir, p, (void*)i, PTE_W | PTE_P | PTE_U);
  }
}

void
boot_map_region(pde_t*, uintptr_t, unsigned long, physaddr_t, int);

void init_kern_pgdir()
{
	int pdx;
	pde_t *pgdir = kpgdir;
	pte_t *pgtable = kpgtable;

	for (pdx = 0; pdx < (npages / NPTENTRIES); ++pdx) {
		// pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_U | PTE_W;
		pgdir[pdx + (KERNBASE >> PDXSHIFT)] = PADDR(pgtable) | PTE_P | PTE_W;
		pgtable += NPTENTRIES;
	}
	int pframe_addr = PHY_MEM - PGSIZE;
	pgtable--;

	for (; pframe_addr >= 0; pframe_addr -= PGSIZE) {
		*pgtable = pframe_addr | PTE_P | PTE_U | PTE_W;
		pgtable --;
	}

	// mm_alloc(pgdir, KSTACKTOP, KSTKSIZE);
	kern_pgdir = pgdir;
	lcr3(PADDR(kern_pgdir));	
}
#define SCR_WIDTH  320
#define SCR_HEIGHT 200
#define SCR_SIZE ((SCR_WIDTH) * (SCR_HEIGHT))
#define VMEM_ADDR  ((uint8_t*)0xA0000)

void
page_init(void)
{
	// The example code here marks all physical pages as free.
	// However this is not truly the case.  What memory is free?
	// 
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	//
	
	init_kern_pgdir();	

	unsigned long i;
	//int base = (EXTPHYSMEM + 4096) / PGSIZE;
	int base = 0x400;
	for (i = 0; i < base; i++) {
		pages[i].pp_ref = 1;
	}
	for (i = npages-1; i >= base; i--) {
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
	//kern_pgdir = entry_pgdir;
	
	//boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W | PTE_P));

	boot_map_region(kern_pgdir, (uintptr_t)VMEM_ADDR, ROUNDUP(SCR_SIZE, PGSIZE), (physaddr_t)VMEM_ADDR, (PTE_W | PTE_P));
}

//
// Allocates a physical page.  If (alloc_flags & ALLOC_ZERO), fills the entire
// returned physical page with '\0' bytes.  Does NOT increment the reference
// count of the page - the caller must do these if necessary (either explicitly
// or via page_insert).
//
// Be sure to set the pp_link field of the allocated page to NULL so
// page_free can check for double-free bugs.
//
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
	// Fill this function in
	struct PageInfo *p = page_free_list;
	if (p == NULL){
		printk("Fatal error: page not available\n");
		return NULL;
	}
	if (alloc_flags & ALLOC_ZERO) {
		memset(page2kva(p), 0, PGSIZE);
	}
	page_free_list = page_free_list -> pp_link;
	p -> pp_link = NULL;
	return p;
}

//
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{

	pp->pp_link = page_free_list;
	page_free_list = pp;
}

//
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
	if (--pp->pp_ref == 0)
		page_free(pp);
}

// Given 'pgdir', a pointer to a page directory, pgdir_walk returns
// a pointer to the page table entry (PTE) for linear address 'va'.
// This requires walking the two-level page table structure.
//
// The relevant page table page might not exist yet.
// If this is true, and create == false, then pgdir_walk returns NULL.
// Otherwise, pgdir_walk allocates a new page table page with page_alloc.
//    - If the allocation fails, pgdir_walk returns NULL.
//    - Otherwise, the new page's reference count is incremented,
//	the page is cleared,
//	and pgdir_walk returns a pointer into the new page table page.
//
// Hint 1: you can turn a Page * into the physical address of the
// page it refers to with page2pa() from pmap.h.
//
// Hint 2: the x86 MMU checks permission bits in both the page directory
// and the page table, so it's safe to leave permissions in the page
// directory more permissive than strictly necessary.
//
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
	// We store pa in pde & pte, but we should use va in mainipulating
	// it, since in protect mode, we can only touch data by va.
	
	pte_t *pgtable;
	int pdx = PDX(va);

	if (pgdir[pdx] & PTE_P) {
		pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
	}
	else {
		if (create == false) return NULL;

		struct PageInfo *p = page_alloc(ALLOC_ZERO);
		if (p == NULL) return NULL;

		pgtable = page2kva(p);
		p -> pp_ref ++;

		pgdir[pdx] = PADDR(pgtable) | PTE_P | PTE_W | PTE_U;
	}
	int ptx = PTX(va);
	return &pgtable[ptx];
}

//
// Map [va, va+size) of virtual address space to physical [pa, pa+size)
// in the page table rooted at pgdir.  Size is a multiple of PGSIZE, and
// va and pa are both page-aligned.
// Use permission bits perm|PTE_P for the entries.
//
// This function is only intended to set up the ``static'' mappings
// above UTOP. As such, it should *not* change the pp_ref field on the
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
void
boot_map_region(pde_t *pgdir, uintptr_t va, unsigned long size, physaddr_t pa, int perm)
{
	// Fill this function in
	int i;
	int n = size / PGSIZE;

	for (i = 0; i < n; i ++) {
		pte_t *pte = pgdir_walk(pgdir, (void*)va, true);
		if (pte == NULL) return;

		*pte = pa | perm | PTE_P;

		va += PGSIZE;
		pa += PGSIZE;
	}
}

//
// Map the physical page 'pp' at virtual address 'va'.
// The permissions (the low 12 bits) of the page table entry
// should be set to 'perm|PTE_P'.
//
// Requirements
//   - If there is already a page mapped at 'va', it should be page_remove()d.
//   - If necessary, on demand, a page table should be allocated and inserted
//     into 'pgdir'.
//   - pp->pp_ref should be incremented if the insertion succeeds.
//   - The TLB must be invalidated if a page was formerly present at 'va'.
//
// Corner-case hint: Make sure to consider what happens when the same
// pp is re-inserted at the same virtual address in the same pgdir.
// However, try not to distinguish this case in your code, as this
// frequently leads to subtle bugs; there's an elegant way to handle
// everything in one code path.
//
// RETURNS:
//   0 on success
//   -E_NO_MEM, if page table couldn't be allocated
//
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
	pte_t *pte = pgdir_walk(pgdir, va, true);
	if (pte == NULL) {
		return -1;
	}

	physaddr_t pa = page2pa(pp);
	if (*pte & PTE_P) {
		if (PTE_ADDR(*pte) == pa) {
			*pte = pa | perm | PTE_P;
		}
		else {
			page_remove(pgdir, va);
		}
	}
	*pte = pa | perm | PTE_P;
	pp -> pp_ref ++;
	return 0;
}

//
// Return the page mapped at virtual address 'va'.
// If pte_store is not zero, then we store in it the address
// of the pte for this page.  This is used by page_remove and
// can be used to verify page permissions for syscall arguments,
// but should not be used by most callers.
//
// Return NULL if there is no page mapped at va.
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
void copy_pgdir(pde_t *dst_dir, pde_t *src_dir)
{
	struct PageInfo *pp;
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
		if (src_dir[pdx] & PTE_P) {	
			if (dst_dir[pdx] & PTE_P) continue;
			pte_t *src_table = KADDR(PTE_ADDR(src_dir[pdx]));

			pp = page_alloc(ALLOC_ZERO);
			pp->pp_ref ++;

			dst_dir[pdx] = page2pa(pp) | PTE_ATTR(src_dir[pdx]);

			pte_t *dst_table = KADDR(PTE_ADDR(dst_dir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
				if (src_table[ptx] & PTE_P) {
					pp = page_alloc(0);
					pp->pp_ref ++;

					dst_table[ptx] = page2pa(pp) | PTE_ATTR(src_table[ptx]);
					memcpy(page2kva(pp), KADDR(PTE_ADDR(src_table[ptx])), PGSIZE);
				}
			}
		}
	}
}

struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
	pte_t *pte = pgdir_walk(pgdir, va, false);
	if (pte == NULL) return NULL;
	if (pte_store != NULL) *pte_store = pte;
	return pa2page(PTE_ADDR(*pte));
}

//
// Unmaps the physical page at virtual address 'va'.
// If there is no physical page at that address, silently does nothing.
//
// Details:
//   - The ref count on the physical page should decrement.
//   - The physical page should be freed if the refcount reaches 0.
//   - The pg table entry corresponding to 'va' should be set to 0.
//     (if such a PTE exists)
//   - The TLB must be invalidated if you remove an entry from
//     the page table.
//
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
	pte_t *pte;
	pte_t **pte_store = &pte;
	struct PageInfo *p = page_lookup(pgdir, va, pte_store);

	if (p != NULL) {
		**pte_store = 0;
		page_decref(p);
		tlb_invalidate(pgdir, va);
	}
}

//
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}

void free_pgdir(pde_t *pgdir)
{
	int pdx, ptx;
	for (pdx = 0; pdx < NPDENTRIES; ++pdx) {
		if (pgdir[pdx] & PTE_P) {
			if (kern_pgdir[pdx] & PTE_P) continue;
			pte_t *pgtable = KADDR(PTE_ADDR(pgdir[pdx]));
			for (ptx = 0; ptx < NPTENTRIES; ++ptx) {
				if (pgtable[ptx] & PTE_P) {
					page_decref(pa2page(PTE_ADDR(pgtable[ptx])));
				}
			}
			page_decref(pa2page(PTE_ADDR(pgdir[pdx])));
			pgdir[pdx] = 0;
		}
	}
}

