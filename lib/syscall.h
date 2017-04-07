#ifndef _SYSCALL_H
#define _SYSCALL_H

#include "lib/common.h"

#define SYS_PRINT_CHAR	1000

#define SYS_INIT_CACHE	1100
#define SYS_CLEAR_VRAM	1101
#define SYS_FLUSH_VCACHE	1102
#define SYS_SET_PIXEL	1103
#define SYS_DRAW_TEXT1	1104
#define SYS_DRAW_RECT	1105
#define SYS_DRAW_NUMBER	1106
#define SYS_GET_KEY		1200
#define SYS_ADD_TIMER	1300
#define SYS_GET_TICK	1301

#define TIMER_HANDLERS_MAX 100
typedef struct timer_handler{
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
}

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
}
static inline void sys_set_pixel(int x, int y, int color){
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
}
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
	char r_eax = 0;
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline uint32_t sys_get_tick(){
	uint32_t r_eax = 0;
	asm volatile("int $0x80": : "a"(SYS_GET_TICK)); //SYSCALL HERE!
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
#endif