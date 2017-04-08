#ifndef _COMMON_H
#define _COMMON_H

#include "inc/types.h"
#include "inc/x86.h"

void printf(const char *ctl, ...);

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
}

#endif
