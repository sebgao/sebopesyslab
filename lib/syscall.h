#ifndef _SYSCALL_H
#define _SYSCALL_H

#include "lib/common.h"


#define SYS_PRINT_CHAR	1000

#define SYS_INIT_CACHE	1100
#define SYS_CLEAR_VRAM	1101
#define SYS_FLUSH_VCACHE	1102
#define SYS_SET_PIXEL	1103
#define SYS_GET_KEY		1200
#define SYS_ADD_TIMER	1300
#define SYS_GET_TICK	1301

#define SYS_HANDOUT		1500
#define SYS_PID			1501
#define SYS_SLEEP		1502
#define SYS_EXIT		1503
#define SYS_FORK		1504
#define SYS_PPID		1505

#define SYS_THREAD		1510


//alias begin

#define sleep sys_sleep
#define exit sys_exit
#define fork sys_fork
#define getpid sys_pid
#define yield sys_handout
#define getppid sys_ppid
#define sleep sys_sleep
#define thread sys_thread

#define TIMER_HANDLERS_MAX 100
typedef struct timer_handler{
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_thread(void* entry, uint32_t esp){
	asm volatile("int $0x80": : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
}

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline void sys_exit(){
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
}
static inline uint32_t sys_fork(){
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
	return r_eax;
}
static inline uint32_t sys_pid(){
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline uint32_t sys_ppid(){
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

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
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline uint32_t sys_get_tick(){
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
#endif