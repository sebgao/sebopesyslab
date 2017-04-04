#ifndef _COMMON_H
#define _COMMON_H

#include "inc/types.h"
#include "inc/x86.h"

#define SYS_PRINT_CHAR 1000


void printk(const char *ctl, ...);
static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

#endif
