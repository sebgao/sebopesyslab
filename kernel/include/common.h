#ifndef _COMMON_H
#define _COMMON_H

#include "inc/types.h"
#include "inc/x86.h"
#include "lib/printk.h"
#include "serial.h"
#include "file.h"
void printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
static inline void printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}

static inline void memcpy(void* dst, void* src, int len){
	asm volatile ("cld; rep movsl" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosl" : : "c"(len), "a"(src), "D"(dst));
}
static inline void memcpy2(void* dst, void* src, int len){
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
static inline int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
    {
        i++;
    } 
}
#endif
