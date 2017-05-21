
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

080480f2 <sys_thread>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_thread(void* entry, uint32_t esp){
 80480f2:	55                   	push   %ebp
 80480f3:	89 e5                	mov    %esp,%ebp
 80480f5:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
 80480f6:	b8 e6 05 00 00       	mov    $0x5e6,%eax
 80480fb:	8b 55 08             	mov    0x8(%ebp),%edx
 80480fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048101:	89 d3                	mov    %edx,%ebx
 8048103:	cd 80                	int    $0x80
}
 8048105:	5b                   	pop    %ebx
 8048106:	5d                   	pop    %ebp
 8048107:	c3                   	ret    

08048108 <sys_exit>:

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline void sys_exit(){
 8048108:	55                   	push   %ebp
 8048109:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 804810b:	b8 df 05 00 00       	mov    $0x5df,%eax
 8048110:	cd 80                	int    $0x80
}
 8048112:	5d                   	pop    %ebp
 8048113:	c3                   	ret    

08048114 <sys_fork>:
static inline uint32_t sys_fork(){
 8048114:	55                   	push   %ebp
 8048115:	89 e5                	mov    %esp,%ebp
 8048117:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 804811a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
 8048121:	b8 e0 05 00 00       	mov    $0x5e0,%eax
 8048126:	cd 80                	int    $0x80
 8048128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
 804812b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 804812e:	c9                   	leave  
 804812f:	c3                   	ret    

08048130 <sys_pid>:
static inline uint32_t sys_pid(){
 8048130:	55                   	push   %ebp
 8048131:	89 e5                	mov    %esp,%ebp
 8048133:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048136:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
 804813d:	b8 dd 05 00 00       	mov    $0x5dd,%eax
 8048142:	cd 80                	int    $0x80
 8048144:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 8048147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 804814a:	c9                   	leave  
 804814b:	c3                   	ret    

0804814c <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 804814c:	55                   	push   %ebp
 804814d:	89 e5                	mov    %esp,%ebp
 804814f:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 8048150:	b8 de 05 00 00       	mov    $0x5de,%eax
 8048155:	8b 55 08             	mov    0x8(%ebp),%edx
 8048158:	89 d3                	mov    %edx,%ebx
 804815a:	cd 80                	int    $0x80
}
 804815c:	5b                   	pop    %ebx
 804815d:	5d                   	pop    %ebp
 804815e:	c3                   	ret    

0804815f <test_process_sem>:
#include "common.h"
#include "lib/syscall.h"

void test_process_sem(){
 804815f:	55                   	push   %ebp
 8048160:	89 e5                	mov    %esp,%ebp
 8048162:	83 ec 18             	sub    $0x18,%esp
	fork();
 8048165:	e8 aa ff ff ff       	call   8048114 <sys_fork>
	fork();
 804816a:	e8 a5 ff ff ff       	call   8048114 <sys_fork>
	fork();
 804816f:	e8 a0 ff ff ff       	call   8048114 <sys_fork>

	//现在有8个进程了
	
	semaphore* sem = sys_sem_open(0, 2);//打开内核区的0号信号量	
 8048174:	6a 02                	push   $0x2
 8048176:	6a 00                	push   $0x0
 8048178:	e8 2d ff ff ff       	call   80480aa <sys_sem_open>
 804817d:	83 c4 08             	add    $0x8,%esp
 8048180:	89 45 f0             	mov    %eax,-0x10(%ebp)

	//每次只允许运行2个

	sys_sem_wait(sem);
 8048183:	ff 75 f0             	pushl  -0x10(%ebp)
 8048186:	e8 54 ff ff ff       	call   80480df <sys_sem_wait>
 804818b:	83 c4 04             	add    $0x4,%esp
	int i=0;
 804818e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(; i<3; i++){
 8048195:	eb 24                	jmp    80481bb <test_process_sem+0x5c>
		sleep(1);
 8048197:	6a 01                	push   $0x1
 8048199:	e8 ae ff ff ff       	call   804814c <sys_sleep>
 804819e:	83 c4 04             	add    $0x4,%esp
		printf("TASK#%d!\n", getpid());
 80481a1:	e8 8a ff ff ff       	call   8048130 <sys_pid>
 80481a6:	83 ec 08             	sub    $0x8,%esp
 80481a9:	50                   	push   %eax
 80481aa:	68 96 85 04 08       	push   $0x8048596
 80481af:	e8 bd 03 00 00       	call   8048571 <printf>
 80481b4:	83 c4 10             	add    $0x10,%esp

	//每次只允许运行2个

	sys_sem_wait(sem);
	int i=0;
	for(; i<3; i++){
 80481b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80481bb:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
 80481bf:	7e d6                	jle    8048197 <test_process_sem+0x38>
		sleep(1);
		printf("TASK#%d!\n", getpid());
	}
	sys_sem_post(sem);
 80481c1:	83 ec 0c             	sub    $0xc,%esp
 80481c4:	ff 75 f0             	pushl  -0x10(%ebp)
 80481c7:	e8 00 ff ff ff       	call   80480cc <sys_sem_post>
 80481cc:	83 c4 10             	add    $0x10,%esp
	exit();
 80481cf:	e8 34 ff ff ff       	call   8048108 <sys_exit>
}
 80481d4:	c9                   	leave  
 80481d5:	c3                   	ret    

080481d6 <test_thread_sem>:
semaphore sem;
void test_thread_sem(){
 80481d6:	55                   	push   %ebp
 80481d7:	89 e5                	mov    %esp,%ebp
 80481d9:	83 ec 18             	sub    $0x18,%esp
	sys_sem_wait(&sem);
 80481dc:	68 dc 97 04 08       	push   $0x80497dc
 80481e1:	e8 f9 fe ff ff       	call   80480df <sys_sem_wait>
 80481e6:	83 c4 04             	add    $0x4,%esp
	int i=0;
 80481e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(; i<3; i++){
 80481f0:	eb 24                	jmp    8048216 <test_thread_sem+0x40>
		sleep(1);
 80481f2:	6a 01                	push   $0x1
 80481f4:	e8 53 ff ff ff       	call   804814c <sys_sleep>
 80481f9:	83 c4 04             	add    $0x4,%esp
		printf("TASK#%d!\n", getpid());
 80481fc:	e8 2f ff ff ff       	call   8048130 <sys_pid>
 8048201:	83 ec 08             	sub    $0x8,%esp
 8048204:	50                   	push   %eax
 8048205:	68 96 85 04 08       	push   $0x8048596
 804820a:	e8 62 03 00 00       	call   8048571 <printf>
 804820f:	83 c4 10             	add    $0x10,%esp
}
semaphore sem;
void test_thread_sem(){
	sys_sem_wait(&sem);
	int i=0;
	for(; i<3; i++){
 8048212:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048216:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
 804821a:	7e d6                	jle    80481f2 <test_thread_sem+0x1c>
		sleep(1);
		printf("TASK#%d!\n", getpid());
	}
	sys_sem_post(&sem);
 804821c:	83 ec 0c             	sub    $0xc,%esp
 804821f:	68 dc 97 04 08       	push   $0x80497dc
 8048224:	e8 a3 fe ff ff       	call   80480cc <sys_sem_post>
 8048229:	83 c4 10             	add    $0x10,%esp
	exit();
 804822c:	e8 d7 fe ff ff       	call   8048108 <sys_exit>
}
 8048231:	c9                   	leave  
 8048232:	c3                   	ret    

08048233 <main>:
int main(){
 8048233:	55                   	push   %ebp
 8048234:	89 e5                	mov    %esp,%ebp
 8048236:	83 ec 10             	sub    $0x10,%esp
	sys_sem_init(&sem, 2);
 8048239:	6a 02                	push   $0x2
 804823b:	68 dc 97 04 08       	push   $0x80497dc
 8048240:	e8 4f fe ff ff       	call   8048094 <sys_sem_init>
 8048245:	83 c4 08             	add    $0x8,%esp
	int i=0;
 8048248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (i = 0; i < 8; ++i)
 804824f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048256:	eb 24                	jmp    804827c <main+0x49>
	{
		thread(test_thread_sem, 0xeebfd000-i*0x1000);
 8048258:	8b 55 fc             	mov    -0x4(%ebp),%edx
 804825b:	b8 00 00 00 00       	mov    $0x0,%eax
 8048260:	29 d0                	sub    %edx,%eax
 8048262:	c1 e0 0c             	shl    $0xc,%eax
 8048265:	2d 00 30 40 11       	sub    $0x11403000,%eax
 804826a:	50                   	push   %eax
 804826b:	68 d6 81 04 08       	push   $0x80481d6
 8048270:	e8 7d fe ff ff       	call   80480f2 <sys_thread>
 8048275:	83 c4 08             	add    $0x8,%esp
	exit();
}
int main(){
	sys_sem_init(&sem, 2);
	int i=0;
	for (i = 0; i < 8; ++i)
 8048278:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 804827c:	83 7d fc 07          	cmpl   $0x7,-0x4(%ebp)
 8048280:	7e d6                	jle    8048258 <main+0x25>
	{
		thread(test_thread_sem, 0xeebfd000-i*0x1000);
	}
	while(1);
 8048282:	eb fe                	jmp    8048282 <main+0x4f>

08048284 <sys_printch>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 8048284:	55                   	push   %ebp
 8048285:	89 e5                	mov    %esp,%ebp
 8048287:	53                   	push   %ebx
 8048288:	83 ec 04             	sub    $0x4,%esp
 804828b:	8b 45 08             	mov    0x8(%ebp),%eax
 804828e:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 8048291:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 8048296:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 804829a:	89 d3                	mov    %edx,%ebx
 804829c:	cd 80                	int    $0x80
}
 804829e:	83 c4 04             	add    $0x4,%esp
 80482a1:	5b                   	pop    %ebx
 80482a2:	5d                   	pop    %ebp
 80482a3:	c3                   	ret    

080482a4 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 80482a4:	55                   	push   %ebp
 80482a5:	89 e5                	mov    %esp,%ebp
 80482a7:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 80482aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 80482ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 80482b0:	eb 19                	jmp    80482cb <printp+0x27>
		printer(cur);
 80482b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80482b5:	0f b6 00             	movzbl (%eax),%eax
 80482b8:	0f be c0             	movsbl %al,%eax
 80482bb:	83 ec 0c             	sub    $0xc,%esp
 80482be:	50                   	push   %eax
 80482bf:	8b 45 08             	mov    0x8(%ebp),%eax
 80482c2:	ff d0                	call   *%eax
 80482c4:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80482c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80482cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80482ce:	0f b6 00             	movzbl (%eax),%eax
 80482d1:	84 c0                	test   %al,%al
 80482d3:	75 dd                	jne    80482b2 <printp+0xe>
		printer(cur);
	}
}
 80482d5:	c9                   	leave  
 80482d6:	c3                   	ret    

080482d7 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 80482d7:	55                   	push   %ebp
 80482d8:	89 e5                	mov    %esp,%ebp
 80482da:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 80482dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 80482e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 80482e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 80482ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 80482f1:	8b 45 10             	mov    0x10(%ebp),%eax
 80482f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 80482f7:	e9 65 02 00 00       	jmp    8048561 <vfprintf+0x28a>

		if(cur == '%'){
 80482fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80482ff:	0f b6 00             	movzbl (%eax),%eax
 8048302:	3c 25                	cmp    $0x25,%al
 8048304:	75 0c                	jne    8048312 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 8048306:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 804830d:	e9 4b 02 00 00       	jmp    804855d <vfprintf+0x286>
		}
		if(type == READ){
 8048312:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 8048316:	0f 85 26 02 00 00    	jne    8048542 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 804831c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804831f:	0f b6 00             	movzbl (%eax),%eax
 8048322:	3c 73                	cmp    $0x73,%al
 8048324:	75 35                	jne    804835b <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 8048326:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048329:	8b 00                	mov    (%eax),%eax
 804832b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 804832e:	eb 19                	jmp    8048349 <vfprintf+0x72>
					printer(*p);
 8048330:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048333:	0f b6 00             	movzbl (%eax),%eax
 8048336:	0f be c0             	movsbl %al,%eax
 8048339:	83 ec 0c             	sub    $0xc,%esp
 804833c:	50                   	push   %eax
 804833d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048340:	ff d0                	call   *%eax
 8048342:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 8048345:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 8048349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804834c:	0f b6 00             	movzbl (%eax),%eax
 804834f:	84 c0                	test   %al,%al
 8048351:	75 dd                	jne    8048330 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 8048353:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048357:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 804835b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804835e:	0f b6 00             	movzbl (%eax),%eax
 8048361:	3c 78                	cmp    $0x78,%al
 8048363:	0f 85 99 00 00 00    	jne    8048402 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048369:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804836c:	8b 00                	mov    (%eax),%eax
 804836e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8048371:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048375:	75 1d                	jne    8048394 <vfprintf+0xbd>
					printer('0');
 8048377:	83 ec 0c             	sub    $0xc,%esp
 804837a:	6a 30                	push   $0x30
 804837c:	8b 45 08             	mov    0x8(%ebp),%eax
 804837f:	ff d0                	call   *%eax
 8048381:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048384:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 804838f:	e9 c9 01 00 00       	jmp    804855d <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 8048394:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 804839b:	eb 2d                	jmp    80483ca <vfprintf+0xf3>
					int d=(x%16);
 804839d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80483a0:	83 e0 0f             	and    $0xf,%eax
 80483a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 80483a6:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80483aa:	7e 04                	jle    80483b0 <vfprintf+0xd9>
						d+='a'-'0'-10;
 80483ac:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 80483b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80483b3:	83 c0 30             	add    $0x30,%eax
 80483b6:	89 c1                	mov    %eax,%ecx
 80483b8:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80483bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80483be:	01 d0                	add    %edx,%eax
 80483c0:	88 08                	mov    %cl,(%eax)
					x>>=4;
 80483c2:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 80483c6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80483ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80483ce:	75 cd                	jne    804839d <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 80483d0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 80483d4:	eb 1e                	jmp    80483f4 <vfprintf+0x11d>
					printer(digits[di]);
 80483d6:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80483d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80483dc:	01 d0                	add    %edx,%eax
 80483de:	0f b6 00             	movzbl (%eax),%eax
 80483e1:	0f be c0             	movsbl %al,%eax
 80483e4:	83 ec 0c             	sub    $0xc,%esp
 80483e7:	50                   	push   %eax
 80483e8:	8b 45 08             	mov    0x8(%ebp),%eax
 80483eb:	ff d0                	call   *%eax
 80483ed:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 80483f0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 80483f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 80483f8:	79 dc                	jns    80483d6 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80483fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80483fe:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 8048402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048405:	0f b6 00             	movzbl (%eax),%eax
 8048408:	3c 64                	cmp    $0x64,%al
 804840a:	0f 85 02 01 00 00    	jne    8048512 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 8048410:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048413:	8b 00                	mov    (%eax),%eax
 8048415:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 8048418:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 804841f:	75 23                	jne    8048444 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 8048421:	83 ec 08             	sub    $0x8,%esp
 8048424:	68 a0 85 04 08       	push   $0x80485a0
 8048429:	ff 75 08             	pushl  0x8(%ebp)
 804842c:	e8 73 fe ff ff       	call   80482a4 <printp>
 8048431:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048434:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048438:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 804843f:	e9 19 01 00 00       	jmp    804855d <vfprintf+0x286>
				}
				if(x==0){
 8048444:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048448:	75 1e                	jne    8048468 <vfprintf+0x191>
					printer('0');
 804844a:	83 ec 0c             	sub    $0xc,%esp
 804844d:	6a 30                	push   $0x30
 804844f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048452:	ff d0                	call   *%eax
 8048454:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048457:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804845b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048462:	90                   	nop
 8048463:	e9 f5 00 00 00       	jmp    804855d <vfprintf+0x286>
				}
				if(x<0){
 8048468:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804846c:	79 10                	jns    804847e <vfprintf+0x1a7>
					printer('-');
 804846e:	83 ec 0c             	sub    $0xc,%esp
 8048471:	6a 2d                	push   $0x2d
 8048473:	8b 45 08             	mov    0x8(%ebp),%eax
 8048476:	ff d0                	call   *%eax
 8048478:	83 c4 10             	add    $0x10,%esp
					x=-x;
 804847b:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 804847e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8048485:	eb 53                	jmp    80484da <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 8048487:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804848a:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804848f:	89 c8                	mov    %ecx,%eax
 8048491:	f7 ea                	imul   %edx
 8048493:	c1 fa 02             	sar    $0x2,%edx
 8048496:	89 c8                	mov    %ecx,%eax
 8048498:	c1 f8 1f             	sar    $0x1f,%eax
 804849b:	29 c2                	sub    %eax,%edx
 804849d:	89 d0                	mov    %edx,%eax
 804849f:	c1 e0 02             	shl    $0x2,%eax
 80484a2:	01 d0                	add    %edx,%eax
 80484a4:	01 c0                	add    %eax,%eax
 80484a6:	29 c1                	sub    %eax,%ecx
 80484a8:	89 ca                	mov    %ecx,%edx
 80484aa:	89 d0                	mov    %edx,%eax
 80484ac:	83 c0 30             	add    $0x30,%eax
 80484af:	89 c1                	mov    %eax,%ecx
 80484b1:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80484b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80484b7:	01 d0                	add    %edx,%eax
 80484b9:	88 08                	mov    %cl,(%eax)
					x/=10;
 80484bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80484be:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80484c3:	89 c8                	mov    %ecx,%eax
 80484c5:	f7 ea                	imul   %edx
 80484c7:	c1 fa 02             	sar    $0x2,%edx
 80484ca:	89 c8                	mov    %ecx,%eax
 80484cc:	c1 f8 1f             	sar    $0x1f,%eax
 80484cf:	29 c2                	sub    %eax,%edx
 80484d1:	89 d0                	mov    %edx,%eax
 80484d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 80484d6:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80484da:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80484de:	7f a7                	jg     8048487 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 80484e0:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 80484e4:	eb 1e                	jmp    8048504 <vfprintf+0x22d>
					printer(digits[di]);
 80484e6:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80484e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80484ec:	01 d0                	add    %edx,%eax
 80484ee:	0f b6 00             	movzbl (%eax),%eax
 80484f1:	0f be c0             	movsbl %al,%eax
 80484f4:	83 ec 0c             	sub    $0xc,%esp
 80484f7:	50                   	push   %eax
 80484f8:	8b 45 08             	mov    0x8(%ebp),%eax
 80484fb:	ff d0                	call   *%eax
 80484fd:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 8048500:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 8048504:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8048508:	79 dc                	jns    80484e6 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 804850a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804850e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 8048512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048515:	0f b6 00             	movzbl (%eax),%eax
 8048518:	3c 63                	cmp    $0x63,%al
 804851a:	75 1d                	jne    8048539 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 804851c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804851f:	0f b6 00             	movzbl (%eax),%eax
 8048522:	0f be c0             	movsbl %al,%eax
 8048525:	83 ec 0c             	sub    $0xc,%esp
 8048528:	50                   	push   %eax
 8048529:	8b 45 08             	mov    0x8(%ebp),%eax
 804852c:	ff d0                	call   *%eax
 804852e:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 8048531:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048535:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 8048539:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 8048540:	eb 1b                	jmp    804855d <vfprintf+0x286>
		}
		if(type == NONE){
 8048542:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048546:	75 15                	jne    804855d <vfprintf+0x286>
			printer(cur);
 8048548:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804854b:	0f b6 00             	movzbl (%eax),%eax
 804854e:	0f be c0             	movsbl %al,%eax
 8048551:	83 ec 0c             	sub    $0xc,%esp
 8048554:	50                   	push   %eax
 8048555:	8b 45 08             	mov    0x8(%ebp),%eax
 8048558:	ff d0                	call   *%eax
 804855a:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 804855d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048561:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048564:	0f b6 00             	movzbl (%eax),%eax
 8048567:	84 c0                	test   %al,%al
 8048569:	0f 85 8d fd ff ff    	jne    80482fc <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 804856f:	c9                   	leave  
 8048570:	c3                   	ret    

08048571 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8048571:	55                   	push   %ebp
 8048572:	89 e5                	mov    %esp,%ebp
 8048574:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048577:	8d 45 0c             	lea    0xc(%ebp),%eax
 804857a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 804857d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048580:	83 ec 04             	sub    $0x4,%esp
 8048583:	ff 75 f4             	pushl  -0xc(%ebp)
 8048586:	50                   	push   %eax
 8048587:	68 84 82 04 08       	push   $0x8048284
 804858c:	e8 46 fd ff ff       	call   80482d7 <vfprintf>
 8048591:	83 c4 10             	add    $0x10,%esp
}
 8048594:	c9                   	leave  
 8048595:	c3                   	ret    
