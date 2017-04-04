#ifndef _SYSCALL_H
#define _SYSCALL_H

#define SYS_PRINT_CHAR	1000

#define SYS_INIT_CACHE	1100
#define SYS_CLEAR_VRAM	1101
#define SYS_FLUSH_VCACHE	1102
#define SYS_SET_PIXEL	1103
#define SYS_DRAW_TEXT1	1104
#define SYS_DRAW_RECT	1105
#define SYS_DRAW_NUMBER	1106
#define SYS_GET_KEY		1200
static inline void printch(char c){
  asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void init_cache(){
  asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
}

static inline void clear_vram(){
  asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void flush_vcache(){
  asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
}
static inline void set_pixel(int x, int y, int color){
  asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
}
static inline char key_down(char s){
	char r_eax;
	asm volatile("int $0x80": : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
	asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
#endif