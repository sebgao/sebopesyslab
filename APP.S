
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <sys_sem_init>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_sem_init(semaphore *sem, int count){
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_INIT), "b"(sem), "c"(count)); //SYSCALL HERE!
 8048098:	b8 40 06 00 00       	mov    $0x640,%eax
 804809d:	8b 55 08             	mov    0x8(%ebp),%edx
 80480a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80480a3:	89 d3                	mov    %edx,%ebx
 80480a5:	cd 80                	int    $0x80
}
 80480a7:	5b                   	pop    %ebx
 80480a8:	5d                   	pop    %ebp
 80480a9:	c3                   	ret    

080480aa <sys_sem_open>:

static inline semaphore* sys_sem_open(int index, int count){
 80480aa:	55                   	push   %ebp
 80480ab:	89 e5                	mov    %esp,%ebp
 80480ad:	53                   	push   %ebx
 80480ae:	83 ec 10             	sub    $0x10,%esp
	semaphore *sem;
	asm volatile("int $0x80": "=a"(sem) : "a"(SYS_SEM_OPEN), "b"(index), "c"(count)); //SYSCALL HERE!
 80480b1:	b8 41 06 00 00       	mov    $0x641,%eax
 80480b6:	8b 55 08             	mov    0x8(%ebp),%edx
 80480b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80480bc:	89 d3                	mov    %edx,%ebx
 80480be:	cd 80                	int    $0x80
 80480c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return sem;
 80480c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 80480c6:	83 c4 10             	add    $0x10,%esp
 80480c9:	5b                   	pop    %ebx
 80480ca:	5d                   	pop    %ebp
 80480cb:	c3                   	ret    

080480cc <sys_sem_post>:

static inline void sys_sem_post(semaphore *sem){
 80480cc:	55                   	push   %ebp
 80480cd:	89 e5                	mov    %esp,%ebp
 80480cf:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_POST), "b"(sem)); //SYSCALL HERE!
 80480d0:	b8 42 06 00 00       	mov    $0x642,%eax
 80480d5:	8b 55 08             	mov    0x8(%ebp),%edx
 80480d8:	89 d3                	mov    %edx,%ebx
 80480da:	cd 80                	int    $0x80
}
 80480dc:	5b                   	pop    %ebx
 80480dd:	5d                   	pop    %ebp
 80480de:	c3                   	ret    

080480df <sys_sem_wait>:

static inline void sys_sem_wait(semaphore *sem){
 80480df:	55                   	push   %ebp
 80480e0:	89 e5                	mov    %esp,%ebp
 80480e2:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_WAIT), "b"(sem)); //SYSCALL HERE!
 80480e3:	b8 43 06 00 00       	mov    $0x643,%eax
 80480e8:	8b 55 08             	mov    0x8(%ebp),%edx
 80480eb:	89 d3                	mov    %edx,%ebx
 80480ed:	cd 80                	int    $0x80
}
 80480ef:	5b                   	pop    %ebx
 80480f0:	5d                   	pop    %ebp
 80480f1:	c3                   	ret    

080480f2 <sys_sem_close>:

static inline void sys_sem_close(semaphore *sem){
 80480f2:	55                   	push   %ebp
 80480f3:	89 e5                	mov    %esp,%ebp
 80480f5:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_CLOSE), "b"(sem)); //SYSCALL HERE!
 80480f6:	b8 44 06 00 00       	mov    $0x644,%eax
 80480fb:	8b 55 08             	mov    0x8(%ebp),%edx
 80480fe:	89 d3                	mov    %edx,%ebx
 8048100:	cd 80                	int    $0x80
}
 8048102:	5b                   	pop    %ebx
 8048103:	5d                   	pop    %ebp
 8048104:	c3                   	ret    

08048105 <sys_thread>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline int sys_thread(void* entry, uint32_t esp){
 8048105:	55                   	push   %ebp
 8048106:	89 e5                	mov    %esp,%ebp
 8048108:	53                   	push   %ebx
 8048109:	83 ec 10             	sub    $0x10,%esp
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
 804810c:	b8 e6 05 00 00       	mov    $0x5e6,%eax
 8048111:	8b 55 08             	mov    0x8(%ebp),%edx
 8048114:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048117:	89 d3                	mov    %edx,%ebx
 8048119:	cd 80                	int    $0x80
 804811b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return pid;
 804811e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 8048121:	83 c4 10             	add    $0x10,%esp
 8048124:	5b                   	pop    %ebx
 8048125:	5d                   	pop    %ebp
 8048126:	c3                   	ret    

08048127 <sys_exit>:

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline void sys_exit(){
 8048127:	55                   	push   %ebp
 8048128:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 804812a:	b8 df 05 00 00       	mov    $0x5df,%eax
 804812f:	cd 80                	int    $0x80
}
 8048131:	5d                   	pop    %ebp
 8048132:	c3                   	ret    

08048133 <sys_fork>:
static inline uint32_t sys_fork(){
 8048133:	55                   	push   %ebp
 8048134:	89 e5                	mov    %esp,%ebp
 8048136:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048139:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
 8048140:	b8 e0 05 00 00       	mov    $0x5e0,%eax
 8048145:	cd 80                	int    $0x80
 8048147:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
 804814a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 804814d:	c9                   	leave  
 804814e:	c3                   	ret    

0804814f <sys_pid>:
static inline uint32_t sys_pid(){
 804814f:	55                   	push   %ebp
 8048150:	89 e5                	mov    %esp,%ebp
 8048152:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048155:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
 804815c:	b8 dd 05 00 00       	mov    $0x5dd,%eax
 8048161:	cd 80                	int    $0x80
 8048163:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 8048166:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8048169:	c9                   	leave  
 804816a:	c3                   	ret    

0804816b <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 804816b:	55                   	push   %ebp
 804816c:	89 e5                	mov    %esp,%ebp
 804816e:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 804816f:	b8 de 05 00 00       	mov    $0x5de,%eax
 8048174:	8b 55 08             	mov    0x8(%ebp),%edx
 8048177:	89 d3                	mov    %edx,%ebx
 8048179:	cd 80                	int    $0x80
}
 804817b:	5b                   	pop    %ebx
 804817c:	5d                   	pop    %ebp
 804817d:	c3                   	ret    

0804817e <sys_join>:

static inline void sys_join(int pid){
 804817e:	55                   	push   %ebp
 804817f:	89 e5                	mov    %esp,%ebp
 8048181:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
 8048182:	b8 e2 05 00 00       	mov    $0x5e2,%eax
 8048187:	8b 55 08             	mov    0x8(%ebp),%edx
 804818a:	89 d3                	mov    %edx,%ebx
 804818c:	cd 80                	int    $0x80
}
 804818e:	5b                   	pop    %ebx
 804818f:	5d                   	pop    %ebp
 8048190:	c3                   	ret    

08048191 <test_process_sem>:
#include "common.h"
#include "lib/syscall.h"

void test_process_sem(){
 8048191:	55                   	push   %ebp
 8048192:	89 e5                	mov    %esp,%ebp
 8048194:	83 ec 18             	sub    $0x18,%esp
	fork();
 8048197:	e8 97 ff ff ff       	call   8048133 <sys_fork>
	fork();
 804819c:	e8 92 ff ff ff       	call   8048133 <sys_fork>
	fork();
 80481a1:	e8 8d ff ff ff       	call   8048133 <sys_fork>

	//现在有8个进程了
	
	semaphore* sem = sys_sem_open(0, 2);//打开内核区的0号信号量	
 80481a6:	6a 02                	push   $0x2
 80481a8:	6a 00                	push   $0x0
 80481aa:	e8 fb fe ff ff       	call   80480aa <sys_sem_open>
 80481af:	83 c4 08             	add    $0x8,%esp
 80481b2:	89 45 f0             	mov    %eax,-0x10(%ebp)

	//每次只允许运行2个

	sys_sem_wait(sem);
 80481b5:	ff 75 f0             	pushl  -0x10(%ebp)
 80481b8:	e8 22 ff ff ff       	call   80480df <sys_sem_wait>
 80481bd:	83 c4 04             	add    $0x4,%esp
	int i=0;
 80481c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(; i<2; i++){
 80481c7:	eb 27                	jmp    80481f0 <test_process_sem+0x5f>
		sleep(1);
 80481c9:	6a 01                	push   $0x1
 80481cb:	e8 9b ff ff ff       	call   804816b <sys_sleep>
 80481d0:	83 c4 04             	add    $0x4,%esp
		printf("TASK#%d, %d!\n", getpid(), i);
 80481d3:	e8 77 ff ff ff       	call   804814f <sys_pid>
 80481d8:	83 ec 04             	sub    $0x4,%esp
 80481db:	ff 75 f4             	pushl  -0xc(%ebp)
 80481de:	50                   	push   %eax
 80481df:	68 32 86 04 08       	push   $0x8048632
 80481e4:	e8 24 04 00 00       	call   804860d <printf>
 80481e9:	83 c4 10             	add    $0x10,%esp

	//每次只允许运行2个

	sys_sem_wait(sem);
	int i=0;
	for(; i<2; i++){
 80481ec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80481f0:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
 80481f4:	7e d3                	jle    80481c9 <test_process_sem+0x38>
		sleep(1);
		printf("TASK#%d, %d!\n", getpid(), i);
	}
	sys_sem_post(sem);
 80481f6:	83 ec 0c             	sub    $0xc,%esp
 80481f9:	ff 75 f0             	pushl  -0x10(%ebp)
 80481fc:	e8 cb fe ff ff       	call   80480cc <sys_sem_post>
 8048201:	83 c4 10             	add    $0x10,%esp
	exit();
 8048204:	e8 1e ff ff ff       	call   8048127 <sys_exit>
}
 8048209:	c9                   	leave  
 804820a:	c3                   	ret    

0804820b <test_thread_sem>:
semaphore sem;
void test_thread_sem(){
 804820b:	55                   	push   %ebp
 804820c:	89 e5                	mov    %esp,%ebp
 804820e:	83 ec 18             	sub    $0x18,%esp
	sys_sem_wait(&sem);
 8048211:	68 fc 98 04 08       	push   $0x80498fc
 8048216:	e8 c4 fe ff ff       	call   80480df <sys_sem_wait>
 804821b:	83 c4 04             	add    $0x4,%esp
	int i=0;
 804821e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(; i<2; i++){
 8048225:	eb 24                	jmp    804824b <test_thread_sem+0x40>
		sleep(1);
 8048227:	6a 01                	push   $0x1
 8048229:	e8 3d ff ff ff       	call   804816b <sys_sleep>
 804822e:	83 c4 04             	add    $0x4,%esp
		printf("TASK#%d!\n", getpid());
 8048231:	e8 19 ff ff ff       	call   804814f <sys_pid>
 8048236:	83 ec 08             	sub    $0x8,%esp
 8048239:	50                   	push   %eax
 804823a:	68 40 86 04 08       	push   $0x8048640
 804823f:	e8 c9 03 00 00       	call   804860d <printf>
 8048244:	83 c4 10             	add    $0x10,%esp
}
semaphore sem;
void test_thread_sem(){
	sys_sem_wait(&sem);
	int i=0;
	for(; i<2; i++){
 8048247:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804824b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
 804824f:	7e d6                	jle    8048227 <test_thread_sem+0x1c>
		sleep(1);
		printf("TASK#%d!\n", getpid());
	}
	sys_sem_post(&sem);
 8048251:	83 ec 0c             	sub    $0xc,%esp
 8048254:	68 fc 98 04 08       	push   $0x80498fc
 8048259:	e8 6e fe ff ff       	call   80480cc <sys_sem_post>
 804825e:	83 c4 10             	add    $0x10,%esp
	exit();
 8048261:	e8 c1 fe ff ff       	call   8048127 <sys_exit>
}
 8048266:	c9                   	leave  
 8048267:	c3                   	ret    

08048268 <main>:
int main(){
 8048268:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 804826c:	83 e4 f0             	and    $0xfffffff0,%esp
 804826f:	ff 71 fc             	pushl  -0x4(%ecx)
 8048272:	55                   	push   %ebp
 8048273:	89 e5                	mov    %esp,%ebp
 8048275:	51                   	push   %ecx
 8048276:	83 ec 14             	sub    $0x14,%esp
	sys_sem_init(&sem, 3);
 8048279:	6a 03                	push   $0x3
 804827b:	68 fc 98 04 08       	push   $0x80498fc
 8048280:	e8 0f fe ff ff       	call   8048094 <sys_sem_init>
 8048285:	83 c4 08             	add    $0x8,%esp
	int i=0;
 8048288:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0; i < 15; ++i)
 804828f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048296:	eb 3a                	jmp    80482d2 <main+0x6a>
	{
		int pid = thread(test_thread_sem, 0xeebfd000-i*0x1000);
 8048298:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804829b:	b8 00 00 00 00       	mov    $0x0,%eax
 80482a0:	29 d0                	sub    %edx,%eax
 80482a2:	c1 e0 0c             	shl    $0xc,%eax
 80482a5:	2d 00 30 40 11       	sub    $0x11403000,%eax
 80482aa:	50                   	push   %eax
 80482ab:	68 0b 82 04 08       	push   $0x804820b
 80482b0:	e8 50 fe ff ff       	call   8048105 <sys_thread>
 80482b5:	83 c4 08             	add    $0x8,%esp
 80482b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		printf("%d created!\n", pid);
 80482bb:	83 ec 08             	sub    $0x8,%esp
 80482be:	ff 75 f0             	pushl  -0x10(%ebp)
 80482c1:	68 4a 86 04 08       	push   $0x804864a
 80482c6:	e8 42 03 00 00       	call   804860d <printf>
 80482cb:	83 c4 10             	add    $0x10,%esp
	exit();
}
int main(){
	sys_sem_init(&sem, 3);
	int i=0;
	for (i = 0; i < 15; ++i)
 80482ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80482d2:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
 80482d6:	7e c0                	jle    8048298 <main+0x30>
	{
		int pid = thread(test_thread_sem, 0xeebfd000-i*0x1000);
		printf("%d created!\n", pid);
	}
	for(i=3; i<18; i++){
 80482d8:	c7 45 f4 03 00 00 00 	movl   $0x3,-0xc(%ebp)
 80482df:	eb 12                	jmp    80482f3 <main+0x8b>
		sys_join(i);
 80482e1:	83 ec 0c             	sub    $0xc,%esp
 80482e4:	ff 75 f4             	pushl  -0xc(%ebp)
 80482e7:	e8 92 fe ff ff       	call   804817e <sys_join>
 80482ec:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < 15; ++i)
	{
		int pid = thread(test_thread_sem, 0xeebfd000-i*0x1000);
		printf("%d created!\n", pid);
	}
	for(i=3; i<18; i++){
 80482ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80482f3:	83 7d f4 11          	cmpl   $0x11,-0xc(%ebp)
 80482f7:	7e e8                	jle    80482e1 <main+0x79>
		sys_join(i);
	}
	//sys_join(3);
	sys_sem_close(&sem);
 80482f9:	83 ec 0c             	sub    $0xc,%esp
 80482fc:	68 fc 98 04 08       	push   $0x80498fc
 8048301:	e8 ec fd ff ff       	call   80480f2 <sys_sem_close>
 8048306:	83 c4 10             	add    $0x10,%esp
	//sleep(40);
	printf("All taskes are done!\n");
 8048309:	83 ec 0c             	sub    $0xc,%esp
 804830c:	68 57 86 04 08       	push   $0x8048657
 8048311:	e8 f7 02 00 00       	call   804860d <printf>
 8048316:	83 c4 10             	add    $0x10,%esp
	exit();
 8048319:	e8 09 fe ff ff       	call   8048127 <sys_exit>
	while(1);
 804831e:	eb fe                	jmp    804831e <main+0xb6>

08048320 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 8048320:	55                   	push   %ebp
 8048321:	89 e5                	mov    %esp,%ebp
 8048323:	53                   	push   %ebx
 8048324:	83 ec 04             	sub    $0x4,%esp
 8048327:	8b 45 08             	mov    0x8(%ebp),%eax
 804832a:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 804832d:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 8048332:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 8048336:	89 d3                	mov    %edx,%ebx
 8048338:	cd 80                	int    $0x80
}
 804833a:	83 c4 04             	add    $0x4,%esp
 804833d:	5b                   	pop    %ebx
 804833e:	5d                   	pop    %ebp
 804833f:	c3                   	ret    

08048340 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 8048340:	55                   	push   %ebp
 8048341:	89 e5                	mov    %esp,%ebp
 8048343:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 8048346:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048349:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 804834c:	eb 19                	jmp    8048367 <printp+0x27>
		printer(cur);
 804834e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048351:	0f b6 00             	movzbl (%eax),%eax
 8048354:	0f be c0             	movsbl %al,%eax
 8048357:	83 ec 0c             	sub    $0xc,%esp
 804835a:	50                   	push   %eax
 804835b:	8b 45 08             	mov    0x8(%ebp),%eax
 804835e:	ff d0                	call   *%eax
 8048360:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 8048363:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048367:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804836a:	0f b6 00             	movzbl (%eax),%eax
 804836d:	84 c0                	test   %al,%al
 804836f:	75 dd                	jne    804834e <printp+0xe>
		printer(cur);
	}
}
 8048371:	c9                   	leave  
 8048372:	c3                   	ret    

08048373 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 8048373:	55                   	push   %ebp
 8048374:	89 e5                	mov    %esp,%ebp
 8048376:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 8048379:	8b 45 0c             	mov    0xc(%ebp),%eax
 804837c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 804837f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8048386:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 804838d:	8b 45 10             	mov    0x10(%ebp),%eax
 8048390:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048393:	e9 65 02 00 00       	jmp    80485fd <vfprintf+0x28a>

		if(cur == '%'){
 8048398:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804839b:	0f b6 00             	movzbl (%eax),%eax
 804839e:	3c 25                	cmp    $0x25,%al
 80483a0:	75 0c                	jne    80483ae <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 80483a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 80483a9:	e9 4b 02 00 00       	jmp    80485f9 <vfprintf+0x286>
		}
		if(type == READ){
 80483ae:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80483b2:	0f 85 26 02 00 00    	jne    80485de <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 80483b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483bb:	0f b6 00             	movzbl (%eax),%eax
 80483be:	3c 73                	cmp    $0x73,%al
 80483c0:	75 35                	jne    80483f7 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 80483c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80483c5:	8b 00                	mov    (%eax),%eax
 80483c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 80483ca:	eb 19                	jmp    80483e5 <vfprintf+0x72>
					printer(*p);
 80483cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80483cf:	0f b6 00             	movzbl (%eax),%eax
 80483d2:	0f be c0             	movsbl %al,%eax
 80483d5:	83 ec 0c             	sub    $0xc,%esp
 80483d8:	50                   	push   %eax
 80483d9:	8b 45 08             	mov    0x8(%ebp),%eax
 80483dc:	ff d0                	call   *%eax
 80483de:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 80483e1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 80483e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80483e8:	0f b6 00             	movzbl (%eax),%eax
 80483eb:	84 c0                	test   %al,%al
 80483ed:	75 dd                	jne    80483cc <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 80483ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80483f3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 80483f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483fa:	0f b6 00             	movzbl (%eax),%eax
 80483fd:	3c 78                	cmp    $0x78,%al
 80483ff:	0f 85 99 00 00 00    	jne    804849e <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048405:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048408:	8b 00                	mov    (%eax),%eax
 804840a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 804840d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048411:	75 1d                	jne    8048430 <vfprintf+0xbd>
					printer('0');
 8048413:	83 ec 0c             	sub    $0xc,%esp
 8048416:	6a 30                	push   $0x30
 8048418:	8b 45 08             	mov    0x8(%ebp),%eax
 804841b:	ff d0                	call   *%eax
 804841d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048420:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048424:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 804842b:	e9 c9 01 00 00       	jmp    80485f9 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 8048430:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 8048437:	eb 2d                	jmp    8048466 <vfprintf+0xf3>
					int d=(x%16);
 8048439:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804843c:	83 e0 0f             	and    $0xf,%eax
 804843f:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8048442:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 8048446:	7e 04                	jle    804844c <vfprintf+0xd9>
						d+='a'-'0'-10;
 8048448:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 804844c:	8b 45 d8             	mov    -0x28(%ebp),%eax
 804844f:	83 c0 30             	add    $0x30,%eax
 8048452:	89 c1                	mov    %eax,%ecx
 8048454:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048457:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804845a:	01 d0                	add    %edx,%eax
 804845c:	88 08                	mov    %cl,(%eax)
					x>>=4;
 804845e:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8048462:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048466:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804846a:	75 cd                	jne    8048439 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 804846c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8048470:	eb 1e                	jmp    8048490 <vfprintf+0x11d>
					printer(digits[di]);
 8048472:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048475:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048478:	01 d0                	add    %edx,%eax
 804847a:	0f b6 00             	movzbl (%eax),%eax
 804847d:	0f be c0             	movsbl %al,%eax
 8048480:	83 ec 0c             	sub    $0xc,%esp
 8048483:	50                   	push   %eax
 8048484:	8b 45 08             	mov    0x8(%ebp),%eax
 8048487:	ff d0                	call   *%eax
 8048489:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 804848c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8048490:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8048494:	79 dc                	jns    8048472 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048496:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804849a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 804849e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484a1:	0f b6 00             	movzbl (%eax),%eax
 80484a4:	3c 64                	cmp    $0x64,%al
 80484a6:	0f 85 02 01 00 00    	jne    80485ae <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 80484ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80484af:	8b 00                	mov    (%eax),%eax
 80484b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 80484b4:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 80484bb:	75 23                	jne    80484e0 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 80484bd:	83 ec 08             	sub    $0x8,%esp
 80484c0:	68 6d 86 04 08       	push   $0x804866d
 80484c5:	ff 75 08             	pushl  0x8(%ebp)
 80484c8:	e8 73 fe ff ff       	call   8048340 <printp>
 80484cd:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80484d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80484d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80484db:	e9 19 01 00 00       	jmp    80485f9 <vfprintf+0x286>
				}
				if(x==0){
 80484e0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80484e4:	75 1e                	jne    8048504 <vfprintf+0x191>
					printer('0');
 80484e6:	83 ec 0c             	sub    $0xc,%esp
 80484e9:	6a 30                	push   $0x30
 80484eb:	8b 45 08             	mov    0x8(%ebp),%eax
 80484ee:	ff d0                	call   *%eax
 80484f0:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80484f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80484f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80484fe:	90                   	nop
 80484ff:	e9 f5 00 00 00       	jmp    80485f9 <vfprintf+0x286>
				}
				if(x<0){
 8048504:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048508:	79 10                	jns    804851a <vfprintf+0x1a7>
					printer('-');
 804850a:	83 ec 0c             	sub    $0xc,%esp
 804850d:	6a 2d                	push   $0x2d
 804850f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048512:	ff d0                	call   *%eax
 8048514:	83 c4 10             	add    $0x10,%esp
					x=-x;
 8048517:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 804851a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8048521:	eb 53                	jmp    8048576 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 8048523:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8048526:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804852b:	89 c8                	mov    %ecx,%eax
 804852d:	f7 ea                	imul   %edx
 804852f:	c1 fa 02             	sar    $0x2,%edx
 8048532:	89 c8                	mov    %ecx,%eax
 8048534:	c1 f8 1f             	sar    $0x1f,%eax
 8048537:	29 c2                	sub    %eax,%edx
 8048539:	89 d0                	mov    %edx,%eax
 804853b:	c1 e0 02             	shl    $0x2,%eax
 804853e:	01 d0                	add    %edx,%eax
 8048540:	01 c0                	add    %eax,%eax
 8048542:	29 c1                	sub    %eax,%ecx
 8048544:	89 ca                	mov    %ecx,%edx
 8048546:	89 d0                	mov    %edx,%eax
 8048548:	83 c0 30             	add    $0x30,%eax
 804854b:	89 c1                	mov    %eax,%ecx
 804854d:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048550:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048553:	01 d0                	add    %edx,%eax
 8048555:	88 08                	mov    %cl,(%eax)
					x/=10;
 8048557:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804855a:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804855f:	89 c8                	mov    %ecx,%eax
 8048561:	f7 ea                	imul   %edx
 8048563:	c1 fa 02             	sar    $0x2,%edx
 8048566:	89 c8                	mov    %ecx,%eax
 8048568:	c1 f8 1f             	sar    $0x1f,%eax
 804856b:	29 c2                	sub    %eax,%edx
 804856d:	89 d0                	mov    %edx,%eax
 804856f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 8048572:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048576:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804857a:	7f a7                	jg     8048523 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 804857c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 8048580:	eb 1e                	jmp    80485a0 <vfprintf+0x22d>
					printer(digits[di]);
 8048582:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048585:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048588:	01 d0                	add    %edx,%eax
 804858a:	0f b6 00             	movzbl (%eax),%eax
 804858d:	0f be c0             	movsbl %al,%eax
 8048590:	83 ec 0c             	sub    $0xc,%esp
 8048593:	50                   	push   %eax
 8048594:	8b 45 08             	mov    0x8(%ebp),%eax
 8048597:	ff d0                	call   *%eax
 8048599:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 804859c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 80485a0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 80485a4:	79 dc                	jns    8048582 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80485a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80485aa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 80485ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485b1:	0f b6 00             	movzbl (%eax),%eax
 80485b4:	3c 63                	cmp    $0x63,%al
 80485b6:	75 1d                	jne    80485d5 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 80485b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485bb:	0f b6 00             	movzbl (%eax),%eax
 80485be:	0f be c0             	movsbl %al,%eax
 80485c1:	83 ec 0c             	sub    $0xc,%esp
 80485c4:	50                   	push   %eax
 80485c5:	8b 45 08             	mov    0x8(%ebp),%eax
 80485c8:	ff d0                	call   *%eax
 80485ca:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 80485cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80485d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 80485d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 80485dc:	eb 1b                	jmp    80485f9 <vfprintf+0x286>
		}
		if(type == NONE){
 80485de:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80485e2:	75 15                	jne    80485f9 <vfprintf+0x286>
			printer(cur);
 80485e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485e7:	0f b6 00             	movzbl (%eax),%eax
 80485ea:	0f be c0             	movsbl %al,%eax
 80485ed:	83 ec 0c             	sub    $0xc,%esp
 80485f0:	50                   	push   %eax
 80485f1:	8b 45 08             	mov    0x8(%ebp),%eax
 80485f4:	ff d0                	call   *%eax
 80485f6:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 80485f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80485fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048600:	0f b6 00             	movzbl (%eax),%eax
 8048603:	84 c0                	test   %al,%al
 8048605:	0f 85 8d fd ff ff    	jne    8048398 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 804860b:	c9                   	leave  
 804860c:	c3                   	ret    

0804860d <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 804860d:	55                   	push   %ebp
 804860e:	89 e5                	mov    %esp,%ebp
 8048610:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048613:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048616:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8048619:	8b 45 08             	mov    0x8(%ebp),%eax
 804861c:	83 ec 04             	sub    $0x4,%esp
 804861f:	ff 75 f4             	pushl  -0xc(%ebp)
 8048622:	50                   	push   %eax
 8048623:	68 20 83 04 08       	push   $0x8048320
 8048628:	e8 46 fd ff ff       	call   8048373 <vfprintf>
 804862d:	83 c4 10             	add    $0x10,%esp
}
 8048630:	c9                   	leave  
 8048631:	c3                   	ret    
