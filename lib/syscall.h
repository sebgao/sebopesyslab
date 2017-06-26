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
#define SYS_JOIN		1506

#define SYS_THREAD		1510

#define SYS_SEM_INIT	1600
#define SYS_SEM_OPEN	1601
#define SYS_SEM_POST	1602
#define SYS_SEM_WAIT	1603
#define SYS_SEM_CLOSE	1604
#define SYS_SEM_GET		1605
#define SYS_SEM_TRYWAIT	1606

#define SYS_FS_OPEN 	1700
#define SYS_FS_READ 	1701
#define SYS_FS_WRITE	1702
#define SYS_FS_LSEEK 	1703
#define SYS_FS_CLOSE 	1704
#define SYS_FS_LS 		1705

#define SYS_READLINE	1800

#define SYS_EXEC 		1900
//alias begin

#define sleep sys_sleep
#define exit sys_exit
#define fork sys_fork
#define getpid sys_pid
#define yield sys_handout
#define getppid sys_ppid
#define sleep sys_sleep
#define thread sys_thread
#define sem_init sys_sem_init
#define sem_open sys_sem_open
#define sem_post sys_sem_post
#define sem_wait sys_sem_wait
#define sem_trywait sys_sem_trywait
#define sem_get sys_sem_get
#define sem_close sys_sem_close
#define thread_join sys_join
#define process_join sys_join

#define fs_open sys_fs_open
#define fs_read sys_fs_read
#define fs_write sys_fs_write
#define fs_lseek sys_fs_lseek
#define fs_close sys_fs_close

#define open sys_fs_open
#define read sys_fs_read
#define write sys_fs_write
#define lseek sys_fs_lseek
#define close sys_fs_close

#define exec sys_exec

#define creadline sys_readline

#define FS_RW	0
#define FS_RWC	1
#define FS_RWD	2
#define SEEK_SET	0
#define SEEK_CUR	1
#define	SEEK_END	2

#define TIMER_HANDLERS_MAX 100
typedef struct timer_handler{
	void (*ptr)(void);
	int used;

}timer_handler;

// static inline int fs_open(const char *pathname, int flags);
// static inline int fs_read(int fd, void *buf, int len);
// static inline int fs_write(int fd, void *buf, int len);
// static inline int fs_lseek(int fd, int offset, int whence);
// static inline int fs_close(int fd);
static inline void sys_exec(char* fn){
	asm volatile("int $0x80": : "a"(SYS_EXEC), "b"(fn));
}

static inline void sys_readline(char* dest){
	asm volatile("int $0x80": : "a"(SYS_READLINE), "b"(dest));
}
static inline void sys_fs_ls(uint32_t mask){
	asm volatile("int $0x80": : "a"(SYS_FS_LS), "b"(mask));
}
static inline int sys_fs_open(char *pathname, int flags){
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_OPEN), "b"(pathname), "c"(flags)); //SYSCALL HERE!
	return ret;
}
static inline int sys_fs_read(int fd, void *buf, int len){
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_READ), "b"(fd), "c"(buf), "d"(len)); //SYSCALL HERE!
	return ret;
}
static inline int sys_fs_write(int fd, void *buf, int len){
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_WRITE), "b"(fd), "c"(buf), "d"(len)); //SYSCALL HERE!
	return ret;
}
static inline int sys_fs_lseek(int fd, int offset, int whence){
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_LSEEK), "b"(fd), "c"(offset), "d"(whence)); //SYSCALL HERE!
	return ret;
}
static inline int sys_fs_close(int fd){
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_CLOSE), "b"(fd)); //SYSCALL HERE!
	return ret;
}

static inline void sys_sem_init(semaphore *sem, int count){
	asm volatile("int $0x80": : "a"(SYS_SEM_INIT), "b"(sem), "c"(count)); //SYSCALL HERE!
}

static inline semaphore* sys_sem_open(int index, int count){
	semaphore *sem;
	asm volatile("int $0x80": "=a"(sem) : "a"(SYS_SEM_OPEN), "b"(index), "c"(count)); //SYSCALL HERE!
	return sem;
}

static inline void sys_sem_post(semaphore *sem){
	asm volatile("int $0x80": : "a"(SYS_SEM_POST), "b"(sem)); //SYSCALL HERE!
}

static inline void sys_sem_wait(semaphore *sem){
	asm volatile("int $0x80": : "a"(SYS_SEM_WAIT), "b"(sem)); //SYSCALL HERE!
}

static inline int sys_sem_trywait(semaphore *sem){
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_SEM_TRYWAIT), "b"(sem)); //SYSCALL HERE!
	return ret;
}

static inline void sys_sem_close(semaphore *sem){
	asm volatile("int $0x80": : "a"(SYS_SEM_CLOSE), "b"(sem)); //SYSCALL HERE!
}

static inline int sys_sem_get(semaphore *sem){
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
}


static inline int sys_thread(void* entry, void* arg){
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
	return pid;
}

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
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

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
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