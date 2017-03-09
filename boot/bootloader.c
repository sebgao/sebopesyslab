#include "inc/x86.h"
#include "inc/elf.h"
#include "inc/disk.h"
#include "inc/types.h"

#define elf		((struct ELFHeader *) 0x8000)

void readseg(unsigned char *, int, int);

int bootmain(){
	struct ProgramHeader *ph, *eph;
	unsigned char* pa, *i;

	readseg((unsigned char*)elf, 8*SECTSIZE, 0);

	if (elf->magic != 0x464C457FU)
		goto bad;

	ph = (struct ProgramHeader*)((char *)elf + elf->phoff);
	eph = ph + elf->phnum;
	for(; ph < eph; ph ++) {
		pa = (unsigned char*)ph->paddr; 
		readseg(pa, ph->filesz, ph->off); 
		for (i = pa + ph->filesz; i < pa + ph->memsz; *i ++ = 0);
	}

	((void(*)(void))elf->entry)();
	bad:
	while(1);
	return 1;
};
