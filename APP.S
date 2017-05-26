
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

080480aa <sys_sem_post>:
	semaphore *sem;
	asm volatile("int $0x80": "=a"(sem) : "a"(SYS_SEM_OPEN), "b"(index), "c"(count)); //SYSCALL HERE!
	return sem;
}

static inline void sys_sem_post(semaphore *sem){
 80480aa:	55                   	push   %ebp
 80480ab:	89 e5                	mov    %esp,%ebp
 80480ad:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_POST), "b"(sem)); //SYSCALL HERE!
 80480ae:	b8 42 06 00 00       	mov    $0x642,%eax
 80480b3:	8b 55 08             	mov    0x8(%ebp),%edx
 80480b6:	89 d3                	mov    %edx,%ebx
 80480b8:	cd 80                	int    $0x80
}
 80480ba:	5b                   	pop    %ebx
 80480bb:	5d                   	pop    %ebp
 80480bc:	c3                   	ret    

080480bd <sys_sem_wait>:

static inline void sys_sem_wait(semaphore *sem){
 80480bd:	55                   	push   %ebp
 80480be:	89 e5                	mov    %esp,%ebp
 80480c0:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_WAIT), "b"(sem)); //SYSCALL HERE!
 80480c1:	b8 43 06 00 00       	mov    $0x643,%eax
 80480c6:	8b 55 08             	mov    0x8(%ebp),%edx
 80480c9:	89 d3                	mov    %edx,%ebx
 80480cb:	cd 80                	int    $0x80
}
 80480cd:	5b                   	pop    %ebx
 80480ce:	5d                   	pop    %ebp
 80480cf:	c3                   	ret    

080480d0 <sys_sem_trywait>:

static inline int sys_sem_trywait(semaphore *sem){
 80480d0:	55                   	push   %ebp
 80480d1:	89 e5                	mov    %esp,%ebp
 80480d3:	53                   	push   %ebx
 80480d4:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_SEM_TRYWAIT), "b"(sem)); //SYSCALL HERE!
 80480d7:	b8 46 06 00 00       	mov    $0x646,%eax
 80480dc:	8b 55 08             	mov    0x8(%ebp),%edx
 80480df:	89 d3                	mov    %edx,%ebx
 80480e1:	cd 80                	int    $0x80
 80480e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 80480e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 80480e9:	83 c4 10             	add    $0x10,%esp
 80480ec:	5b                   	pop    %ebx
 80480ed:	5d                   	pop    %ebp
 80480ee:	c3                   	ret    

080480ef <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
 80480ef:	55                   	push   %ebp
 80480f0:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
 80480f2:	b8 dc 05 00 00       	mov    $0x5dc,%eax
 80480f7:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 80480f9:	b8 df 05 00 00       	mov    $0x5df,%eax
 80480fe:	cd 80                	int    $0x80
}
 8048100:	5d                   	pop    %ebp
 8048101:	c3                   	ret    

08048102 <sys_thread>:


static inline int sys_thread(void* entry, void* arg){
 8048102:	55                   	push   %ebp
 8048103:	89 e5                	mov    %esp,%ebp
 8048105:	53                   	push   %ebx
 8048106:	83 ec 10             	sub    $0x10,%esp
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(sys_exit), "d"(arg)); //SYSCALL HERE!
 8048109:	b8 e6 05 00 00       	mov    $0x5e6,%eax
 804810e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048111:	b9 ef 80 04 08       	mov    $0x80480ef,%ecx
 8048116:	8b 55 0c             	mov    0xc(%ebp),%edx
 8048119:	cd 80                	int    $0x80
 804811b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return pid;
 804811e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 8048121:	83 c4 10             	add    $0x10,%esp
 8048124:	5b                   	pop    %ebx
 8048125:	5d                   	pop    %ebp
 8048126:	c3                   	ret    

08048127 <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 8048127:	55                   	push   %ebp
 8048128:	89 e5                	mov    %esp,%ebp
 804812a:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 804812b:	b8 de 05 00 00       	mov    $0x5de,%eax
 8048130:	8b 55 08             	mov    0x8(%ebp),%edx
 8048133:	89 d3                	mov    %edx,%ebx
 8048135:	cd 80                	int    $0x80
}
 8048137:	5b                   	pop    %ebx
 8048138:	5d                   	pop    %ebp
 8048139:	c3                   	ret    

0804813a <sys_join>:

static inline void sys_join(int pid){
 804813a:	55                   	push   %ebp
 804813b:	89 e5                	mov    %esp,%ebp
 804813d:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
 804813e:	b8 e2 05 00 00       	mov    $0x5e2,%eax
 8048143:	8b 55 08             	mov    0x8(%ebp),%edx
 8048146:	89 d3                	mov    %edx,%ebx
 8048148:	cd 80                	int    $0x80
}
 804814a:	5b                   	pop    %ebx
 804814b:	5d                   	pop    %ebp
 804814c:	c3                   	ret    

0804814d <insert_item>:
sem_t empty;
sem_t full;
int index;
int buffer[N];

void insert_item(int item){
 804814d:	55                   	push   %ebp
 804814e:	89 e5                	mov    %esp,%ebp
	buffer[index] = item;
 8048150:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048155:	8b 55 08             	mov    0x8(%ebp),%edx
 8048158:	89 14 85 44 9b 04 08 	mov    %edx,0x8049b44(,%eax,4)
	index ++;
 804815f:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048164:	83 c0 01             	add    $0x1,%eax
 8048167:	a3 4c 9b 04 08       	mov    %eax,0x8049b4c
}
 804816c:	5d                   	pop    %ebp
 804816d:	c3                   	ret    

0804816e <remove_item>:
int remove_item(){
 804816e:	55                   	push   %ebp
 804816f:	89 e5                	mov    %esp,%ebp
	index --;
 8048171:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048176:	83 e8 01             	sub    $0x1,%eax
 8048179:	a3 4c 9b 04 08       	mov    %eax,0x8049b4c
	return buffer[index];
 804817e:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048183:	8b 04 85 44 9b 04 08 	mov    0x8049b44(,%eax,4),%eax
}
 804818a:	5d                   	pop    %ebp
 804818b:	c3                   	ret    

0804818c <producer>:

void producer(){
 804818c:	55                   	push   %ebp
 804818d:	89 e5                	mov    %esp,%ebp
 804818f:	83 ec 18             	sub    $0x18,%esp
	int item;
	while(1){
		sleep(1+rand()%5);
 8048192:	e8 31 02 00 00       	call   80483c8 <UKISS>
 8048197:	89 c1                	mov    %eax,%ecx
 8048199:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 804819e:	89 c8                	mov    %ecx,%eax
 80481a0:	f7 e2                	mul    %edx
 80481a2:	c1 ea 02             	shr    $0x2,%edx
 80481a5:	89 d0                	mov    %edx,%eax
 80481a7:	c1 e0 02             	shl    $0x2,%eax
 80481aa:	01 d0                	add    %edx,%eax
 80481ac:	29 c1                	sub    %eax,%ecx
 80481ae:	89 ca                	mov    %ecx,%edx
 80481b0:	8d 42 01             	lea    0x1(%edx),%eax
 80481b3:	83 ec 0c             	sub    $0xc,%esp
 80481b6:	50                   	push   %eax
 80481b7:	e8 6b ff ff ff       	call   8048127 <sys_sleep>
 80481bc:	83 c4 10             	add    $0x10,%esp
		item = rand()%10;
 80481bf:	e8 04 02 00 00       	call   80483c8 <UKISS>
 80481c4:	89 c1                	mov    %eax,%ecx
 80481c6:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 80481cb:	89 c8                	mov    %ecx,%eax
 80481cd:	f7 e2                	mul    %edx
 80481cf:	c1 ea 03             	shr    $0x3,%edx
 80481d2:	89 d0                	mov    %edx,%eax
 80481d4:	c1 e0 02             	shl    $0x2,%eax
 80481d7:	01 d0                	add    %edx,%eax
 80481d9:	01 c0                	add    %eax,%eax
 80481db:	29 c1                	sub    %eax,%ecx
 80481dd:	89 ca                	mov    %ecx,%edx
 80481df:	89 55 f4             	mov    %edx,-0xc(%ebp)
		printf("PRODUCER: %d produced!\n", item);
 80481e2:	83 ec 08             	sub    $0x8,%esp
 80481e5:	ff 75 f4             	pushl  -0xc(%ebp)
 80481e8:	68 b0 87 04 08       	push   $0x80487b0
 80481ed:	e8 96 05 00 00       	call   8048788 <printf>
 80481f2:	83 c4 10             	add    $0x10,%esp
		sem_wait(&empty);
 80481f5:	83 ec 0c             	sub    $0xc,%esp
 80481f8:	68 50 9b 04 08       	push   $0x8049b50
 80481fd:	e8 bb fe ff ff       	call   80480bd <sys_sem_wait>
 8048202:	83 c4 10             	add    $0x10,%esp
		sem_wait(&mutex);
 8048205:	83 ec 0c             	sub    $0xc,%esp
 8048208:	68 38 9b 04 08       	push   $0x8049b38
 804820d:	e8 ab fe ff ff       	call   80480bd <sys_sem_wait>
 8048212:	83 c4 10             	add    $0x10,%esp

		insert_item(item);
 8048215:	83 ec 0c             	sub    $0xc,%esp
 8048218:	ff 75 f4             	pushl  -0xc(%ebp)
 804821b:	e8 2d ff ff ff       	call   804814d <insert_item>
 8048220:	83 c4 10             	add    $0x10,%esp

		printf("PRODUCER: %d sent, now %d space left!\n", item, N-index);
 8048223:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048228:	ba 02 00 00 00       	mov    $0x2,%edx
 804822d:	29 c2                	sub    %eax,%edx
 804822f:	89 d0                	mov    %edx,%eax
 8048231:	83 ec 04             	sub    $0x4,%esp
 8048234:	50                   	push   %eax
 8048235:	ff 75 f4             	pushl  -0xc(%ebp)
 8048238:	68 c8 87 04 08       	push   $0x80487c8
 804823d:	e8 46 05 00 00       	call   8048788 <printf>
 8048242:	83 c4 10             	add    $0x10,%esp

		sem_post(&mutex);
 8048245:	83 ec 0c             	sub    $0xc,%esp
 8048248:	68 38 9b 04 08       	push   $0x8049b38
 804824d:	e8 58 fe ff ff       	call   80480aa <sys_sem_post>
 8048252:	83 c4 10             	add    $0x10,%esp
		sem_post(&full);
 8048255:	83 ec 0c             	sub    $0xc,%esp
 8048258:	68 2c 9b 04 08       	push   $0x8049b2c
 804825d:	e8 48 fe ff ff       	call   80480aa <sys_sem_post>
 8048262:	83 c4 10             	add    $0x10,%esp
	}
 8048265:	e9 28 ff ff ff       	jmp    8048192 <producer+0x6>

0804826a <consumer>:
}

void consumer(){
 804826a:	55                   	push   %ebp
 804826b:	89 e5                	mov    %esp,%ebp
 804826d:	83 ec 18             	sub    $0x18,%esp
	int item;
	int asleep;
	while(1){
		printf("CONSUMER: ready to receive!\n");
 8048270:	83 ec 0c             	sub    $0xc,%esp
 8048273:	68 ef 87 04 08       	push   $0x80487ef
 8048278:	e8 0b 05 00 00       	call   8048788 <printf>
 804827d:	83 c4 10             	add    $0x10,%esp
		while(!sem_trywait(&full));
 8048280:	90                   	nop
 8048281:	83 ec 0c             	sub    $0xc,%esp
 8048284:	68 2c 9b 04 08       	push   $0x8049b2c
 8048289:	e8 42 fe ff ff       	call   80480d0 <sys_sem_trywait>
 804828e:	83 c4 10             	add    $0x10,%esp
 8048291:	85 c0                	test   %eax,%eax
 8048293:	74 ec                	je     8048281 <consumer+0x17>
		while(!sem_trywait(&mutex));
 8048295:	90                   	nop
 8048296:	83 ec 0c             	sub    $0xc,%esp
 8048299:	68 38 9b 04 08       	push   $0x8049b38
 804829e:	e8 2d fe ff ff       	call   80480d0 <sys_sem_trywait>
 80482a3:	83 c4 10             	add    $0x10,%esp
 80482a6:	85 c0                	test   %eax,%eax
 80482a8:	74 ec                	je     8048296 <consumer+0x2c>

		item = remove_item();
 80482aa:	e8 bf fe ff ff       	call   804816e <remove_item>
 80482af:	89 45 f4             	mov    %eax,-0xc(%ebp)

		sem_post(&mutex);
 80482b2:	83 ec 0c             	sub    $0xc,%esp
 80482b5:	68 38 9b 04 08       	push   $0x8049b38
 80482ba:	e8 eb fd ff ff       	call   80480aa <sys_sem_post>
 80482bf:	83 c4 10             	add    $0x10,%esp
		sem_post(&empty);
 80482c2:	83 ec 0c             	sub    $0xc,%esp
 80482c5:	68 50 9b 04 08       	push   $0x8049b50
 80482ca:	e8 db fd ff ff       	call   80480aa <sys_sem_post>
 80482cf:	83 c4 10             	add    $0x10,%esp

		asleep = 1+rand()%15;
 80482d2:	e8 f1 00 00 00       	call   80483c8 <UKISS>
 80482d7:	89 c1                	mov    %eax,%ecx
 80482d9:	ba 89 88 88 88       	mov    $0x88888889,%edx
 80482de:	89 c8                	mov    %ecx,%eax
 80482e0:	f7 e2                	mul    %edx
 80482e2:	89 d0                	mov    %edx,%eax
 80482e4:	c1 e8 03             	shr    $0x3,%eax
 80482e7:	89 c2                	mov    %eax,%edx
 80482e9:	c1 e2 04             	shl    $0x4,%edx
 80482ec:	29 c2                	sub    %eax,%edx
 80482ee:	89 c8                	mov    %ecx,%eax
 80482f0:	29 d0                	sub    %edx,%eax
 80482f2:	83 c0 01             	add    $0x1,%eax
 80482f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		printf("CONSUMER: %d received, now I want to consumer it in %ds!\n", item, asleep);
 80482f8:	83 ec 04             	sub    $0x4,%esp
 80482fb:	ff 75 f0             	pushl  -0x10(%ebp)
 80482fe:	ff 75 f4             	pushl  -0xc(%ebp)
 8048301:	68 0c 88 04 08       	push   $0x804880c
 8048306:	e8 7d 04 00 00       	call   8048788 <printf>
 804830b:	83 c4 10             	add    $0x10,%esp
		sleep(asleep); //consume
 804830e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048311:	83 ec 0c             	sub    $0xc,%esp
 8048314:	50                   	push   %eax
 8048315:	e8 0d fe ff ff       	call   8048127 <sys_sleep>
 804831a:	83 c4 10             	add    $0x10,%esp

	}
 804831d:	e9 4e ff ff ff       	jmp    8048270 <consumer+0x6>

08048322 <main>:
}
int main(){
 8048322:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048326:	83 e4 f0             	and    $0xfffffff0,%esp
 8048329:	ff 71 fc             	pushl  -0x4(%ecx)
 804832c:	55                   	push   %ebp
 804832d:	89 e5                	mov    %esp,%ebp
 804832f:	51                   	push   %ecx
 8048330:	83 ec 14             	sub    $0x14,%esp

	sem_init(&mutex, 1);
 8048333:	6a 01                	push   $0x1
 8048335:	68 38 9b 04 08       	push   $0x8049b38
 804833a:	e8 55 fd ff ff       	call   8048094 <sys_sem_init>
 804833f:	83 c4 08             	add    $0x8,%esp
	sem_init(&empty, N);
 8048342:	6a 02                	push   $0x2
 8048344:	68 50 9b 04 08       	push   $0x8049b50
 8048349:	e8 46 fd ff ff       	call   8048094 <sys_sem_init>
 804834e:	83 c4 08             	add    $0x8,%esp
	sem_init(&full,	0);
 8048351:	6a 00                	push   $0x0
 8048353:	68 2c 9b 04 08       	push   $0x8049b2c
 8048358:	e8 37 fd ff ff       	call   8048094 <sys_sem_init>
 804835d:	83 c4 08             	add    $0x8,%esp
	index = 0;
 8048360:	c7 05 4c 9b 04 08 00 	movl   $0x0,0x8049b4c
 8048367:	00 00 00 
	thread_t prod, cons;
	prod = thread(producer, NULL);
 804836a:	6a 00                	push   $0x0
 804836c:	68 8c 81 04 08       	push   $0x804818c
 8048371:	e8 8c fd ff ff       	call   8048102 <sys_thread>
 8048376:	83 c4 08             	add    $0x8,%esp
 8048379:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cons = thread(consumer, NULL);
 804837c:	6a 00                	push   $0x0
 804837e:	68 6a 82 04 08       	push   $0x804826a
 8048383:	e8 7a fd ff ff       	call   8048102 <sys_thread>
 8048388:	83 c4 08             	add    $0x8,%esp
 804838b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	thread_join(prod);
 804838e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048391:	50                   	push   %eax
 8048392:	e8 a3 fd ff ff       	call   804813a <sys_join>
 8048397:	83 c4 04             	add    $0x4,%esp
	thread_join(cons);
 804839a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804839d:	50                   	push   %eax
 804839e:	e8 97 fd ff ff       	call   804813a <sys_join>
 80483a3:	83 c4 04             	add    $0x4,%esp

	printf("You should not see this, since the producer and consumer are sisyphean\n");
 80483a6:	83 ec 0c             	sub    $0xc,%esp
 80483a9:	68 48 88 04 08       	push   $0x8048848
 80483ae:	e8 d5 03 00 00       	call   8048788 <printf>
 80483b3:	83 c4 10             	add    $0x10,%esp

	exit();
 80483b6:	e8 34 fd ff ff       	call   80480ef <sys_exit>
 80483bb:	b8 00 00 00 00       	mov    $0x0,%eax
 80483c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 80483c3:	c9                   	leave  
 80483c4:	8d 61 fc             	lea    -0x4(%ecx),%esp
 80483c7:	c3                   	ret    

080483c8 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 80483c8:	55                   	push   %ebp
 80483c9:	89 e5                	mov    %esp,%ebp
 80483cb:	53                   	push   %ebx
 80483cc:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 80483cf:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 80483d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 80483dd:	a1 1c 9b 04 08       	mov    0x8049b1c,%eax
 80483e2:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 80483e8:	05 39 30 00 00       	add    $0x3039,%eax
 80483ed:	a3 1c 9b 04 08       	mov    %eax,0x8049b1c
    y ^= (y<<13);   
 80483f2:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 80483f7:	c1 e0 0d             	shl    $0xd,%eax
 80483fa:	89 c2                	mov    %eax,%edx
 80483fc:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 8048401:	31 d0                	xor    %edx,%eax
 8048403:	a3 20 9b 04 08       	mov    %eax,0x8049b20
    y ^= (y>>17);   
 8048408:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 804840d:	c1 e8 11             	shr    $0x11,%eax
 8048410:	89 c2                	mov    %eax,%edx
 8048412:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 8048417:	31 d0                	xor    %edx,%eax
 8048419:	a3 20 9b 04 08       	mov    %eax,0x8049b20
    y ^= (y<<5);    
 804841e:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 8048423:	c1 e0 05             	shl    $0x5,%eax
 8048426:	89 c2                	mov    %eax,%edx
 8048428:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 804842d:	31 d0                	xor    %edx,%eax
 804842f:	a3 20 9b 04 08       	mov    %eax,0x8049b20
      
    t = (A*z + c);  
 8048434:	a1 24 9b 04 08       	mov    0x8049b24,%eax
 8048439:	ba 00 00 00 00       	mov    $0x0,%edx
 804843e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 8048441:	89 cb                	mov    %ecx,%ebx
 8048443:	0f af da             	imul   %edx,%ebx
 8048446:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8048449:	0f af c8             	imul   %eax,%ecx
 804844c:	01 d9                	add    %ebx,%ecx
 804844e:	f7 65 f0             	mull   -0x10(%ebp)
 8048451:	01 d1                	add    %edx,%ecx
 8048453:	89 ca                	mov    %ecx,%edx
 8048455:	8b 0d 28 9b 04 08    	mov    0x8049b28,%ecx
 804845b:	bb 00 00 00 00       	mov    $0x0,%ebx
 8048460:	01 c8                	add    %ecx,%eax
 8048462:	11 da                	adc    %ebx,%edx
 8048464:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048467:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 804846a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804846d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8048470:	89 d0                	mov    %edx,%eax
 8048472:	31 d2                	xor    %edx,%edx
 8048474:	a3 28 9b 04 08       	mov    %eax,0x8049b28
    z = t;  
 8048479:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804847c:	a3 24 9b 04 08       	mov    %eax,0x8049b24
       
    return x+y+z;    
 8048481:	8b 15 1c 9b 04 08    	mov    0x8049b1c,%edx
 8048487:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 804848c:	01 c2                	add    %eax,%edx
 804848e:	a1 24 9b 04 08       	mov    0x8049b24,%eax
 8048493:	01 d0                	add    %edx,%eax
 8048495:	83 c4 14             	add    $0x14,%esp
 8048498:	5b                   	pop    %ebx
 8048499:	5d                   	pop    %ebp
 804849a:	c3                   	ret    

0804849b <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 804849b:	55                   	push   %ebp
 804849c:	89 e5                	mov    %esp,%ebp
 804849e:	53                   	push   %ebx
 804849f:	83 ec 04             	sub    $0x4,%esp
 80484a2:	8b 45 08             	mov    0x8(%ebp),%eax
 80484a5:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 80484a8:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 80484ad:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 80484b1:	89 d3                	mov    %edx,%ebx
 80484b3:	cd 80                	int    $0x80
}
 80484b5:	83 c4 04             	add    $0x4,%esp
 80484b8:	5b                   	pop    %ebx
 80484b9:	5d                   	pop    %ebp
 80484ba:	c3                   	ret    

080484bb <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 80484bb:	55                   	push   %ebp
 80484bc:	89 e5                	mov    %esp,%ebp
 80484be:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 80484c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 80484c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 80484c7:	eb 19                	jmp    80484e2 <printp+0x27>
		printer(cur);
 80484c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484cc:	0f b6 00             	movzbl (%eax),%eax
 80484cf:	0f be c0             	movsbl %al,%eax
 80484d2:	83 ec 0c             	sub    $0xc,%esp
 80484d5:	50                   	push   %eax
 80484d6:	8b 45 08             	mov    0x8(%ebp),%eax
 80484d9:	ff d0                	call   *%eax
 80484db:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80484de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80484e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484e5:	0f b6 00             	movzbl (%eax),%eax
 80484e8:	84 c0                	test   %al,%al
 80484ea:	75 dd                	jne    80484c9 <printp+0xe>
		printer(cur);
	}
}
 80484ec:	c9                   	leave  
 80484ed:	c3                   	ret    

080484ee <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 80484ee:	55                   	push   %ebp
 80484ef:	89 e5                	mov    %esp,%ebp
 80484f1:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 80484f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 80484f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 80484fa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8048501:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 8048508:	8b 45 10             	mov    0x10(%ebp),%eax
 804850b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 804850e:	e9 65 02 00 00       	jmp    8048778 <vfprintf+0x28a>

		if(cur == '%'){
 8048513:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048516:	0f b6 00             	movzbl (%eax),%eax
 8048519:	3c 25                	cmp    $0x25,%al
 804851b:	75 0c                	jne    8048529 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 804851d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 8048524:	e9 4b 02 00 00       	jmp    8048774 <vfprintf+0x286>
		}
		if(type == READ){
 8048529:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 804852d:	0f 85 26 02 00 00    	jne    8048759 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 8048533:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048536:	0f b6 00             	movzbl (%eax),%eax
 8048539:	3c 73                	cmp    $0x73,%al
 804853b:	75 35                	jne    8048572 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 804853d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048540:	8b 00                	mov    (%eax),%eax
 8048542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 8048545:	eb 19                	jmp    8048560 <vfprintf+0x72>
					printer(*p);
 8048547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804854a:	0f b6 00             	movzbl (%eax),%eax
 804854d:	0f be c0             	movsbl %al,%eax
 8048550:	83 ec 0c             	sub    $0xc,%esp
 8048553:	50                   	push   %eax
 8048554:	8b 45 08             	mov    0x8(%ebp),%eax
 8048557:	ff d0                	call   *%eax
 8048559:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 804855c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 8048560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048563:	0f b6 00             	movzbl (%eax),%eax
 8048566:	84 c0                	test   %al,%al
 8048568:	75 dd                	jne    8048547 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 804856a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804856e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 8048572:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048575:	0f b6 00             	movzbl (%eax),%eax
 8048578:	3c 78                	cmp    $0x78,%al
 804857a:	0f 85 99 00 00 00    	jne    8048619 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048580:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048583:	8b 00                	mov    (%eax),%eax
 8048585:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8048588:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804858c:	75 1d                	jne    80485ab <vfprintf+0xbd>
					printer('0');
 804858e:	83 ec 0c             	sub    $0xc,%esp
 8048591:	6a 30                	push   $0x30
 8048593:	8b 45 08             	mov    0x8(%ebp),%eax
 8048596:	ff d0                	call   *%eax
 8048598:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804859b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804859f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80485a6:	e9 c9 01 00 00       	jmp    8048774 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 80485ab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 80485b2:	eb 2d                	jmp    80485e1 <vfprintf+0xf3>
					int d=(x%16);
 80485b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80485b7:	83 e0 0f             	and    $0xf,%eax
 80485ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 80485bd:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80485c1:	7e 04                	jle    80485c7 <vfprintf+0xd9>
						d+='a'-'0'-10;
 80485c3:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 80485c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80485ca:	83 c0 30             	add    $0x30,%eax
 80485cd:	89 c1                	mov    %eax,%ecx
 80485cf:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80485d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80485d5:	01 d0                	add    %edx,%eax
 80485d7:	88 08                	mov    %cl,(%eax)
					x>>=4;
 80485d9:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 80485dd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80485e1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80485e5:	75 cd                	jne    80485b4 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 80485e7:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 80485eb:	eb 1e                	jmp    804860b <vfprintf+0x11d>
					printer(digits[di]);
 80485ed:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80485f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80485f3:	01 d0                	add    %edx,%eax
 80485f5:	0f b6 00             	movzbl (%eax),%eax
 80485f8:	0f be c0             	movsbl %al,%eax
 80485fb:	83 ec 0c             	sub    $0xc,%esp
 80485fe:	50                   	push   %eax
 80485ff:	8b 45 08             	mov    0x8(%ebp),%eax
 8048602:	ff d0                	call   *%eax
 8048604:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8048607:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 804860b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 804860f:	79 dc                	jns    80485ed <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048615:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 8048619:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804861c:	0f b6 00             	movzbl (%eax),%eax
 804861f:	3c 64                	cmp    $0x64,%al
 8048621:	0f 85 02 01 00 00    	jne    8048729 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 8048627:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804862a:	8b 00                	mov    (%eax),%eax
 804862c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 804862f:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 8048636:	75 23                	jne    804865b <vfprintf+0x16d>
					printp(printer, "-2147483648");
 8048638:	83 ec 08             	sub    $0x8,%esp
 804863b:	68 90 88 04 08       	push   $0x8048890
 8048640:	ff 75 08             	pushl  0x8(%ebp)
 8048643:	e8 73 fe ff ff       	call   80484bb <printp>
 8048648:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804864b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804864f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048656:	e9 19 01 00 00       	jmp    8048774 <vfprintf+0x286>
				}
				if(x==0){
 804865b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804865f:	75 1e                	jne    804867f <vfprintf+0x191>
					printer('0');
 8048661:	83 ec 0c             	sub    $0xc,%esp
 8048664:	6a 30                	push   $0x30
 8048666:	8b 45 08             	mov    0x8(%ebp),%eax
 8048669:	ff d0                	call   *%eax
 804866b:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804866e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048672:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048679:	90                   	nop
 804867a:	e9 f5 00 00 00       	jmp    8048774 <vfprintf+0x286>
				}
				if(x<0){
 804867f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048683:	79 10                	jns    8048695 <vfprintf+0x1a7>
					printer('-');
 8048685:	83 ec 0c             	sub    $0xc,%esp
 8048688:	6a 2d                	push   $0x2d
 804868a:	8b 45 08             	mov    0x8(%ebp),%eax
 804868d:	ff d0                	call   *%eax
 804868f:	83 c4 10             	add    $0x10,%esp
					x=-x;
 8048692:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 8048695:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 804869c:	eb 53                	jmp    80486f1 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 804869e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80486a1:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80486a6:	89 c8                	mov    %ecx,%eax
 80486a8:	f7 ea                	imul   %edx
 80486aa:	c1 fa 02             	sar    $0x2,%edx
 80486ad:	89 c8                	mov    %ecx,%eax
 80486af:	c1 f8 1f             	sar    $0x1f,%eax
 80486b2:	29 c2                	sub    %eax,%edx
 80486b4:	89 d0                	mov    %edx,%eax
 80486b6:	c1 e0 02             	shl    $0x2,%eax
 80486b9:	01 d0                	add    %edx,%eax
 80486bb:	01 c0                	add    %eax,%eax
 80486bd:	29 c1                	sub    %eax,%ecx
 80486bf:	89 ca                	mov    %ecx,%edx
 80486c1:	89 d0                	mov    %edx,%eax
 80486c3:	83 c0 30             	add    $0x30,%eax
 80486c6:	89 c1                	mov    %eax,%ecx
 80486c8:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80486cb:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80486ce:	01 d0                	add    %edx,%eax
 80486d0:	88 08                	mov    %cl,(%eax)
					x/=10;
 80486d2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80486d5:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80486da:	89 c8                	mov    %ecx,%eax
 80486dc:	f7 ea                	imul   %edx
 80486de:	c1 fa 02             	sar    $0x2,%edx
 80486e1:	89 c8                	mov    %ecx,%eax
 80486e3:	c1 f8 1f             	sar    $0x1f,%eax
 80486e6:	29 c2                	sub    %eax,%edx
 80486e8:	89 d0                	mov    %edx,%eax
 80486ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 80486ed:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80486f1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80486f5:	7f a7                	jg     804869e <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 80486f7:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 80486fb:	eb 1e                	jmp    804871b <vfprintf+0x22d>
					printer(digits[di]);
 80486fd:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048700:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048703:	01 d0                	add    %edx,%eax
 8048705:	0f b6 00             	movzbl (%eax),%eax
 8048708:	0f be c0             	movsbl %al,%eax
 804870b:	83 ec 0c             	sub    $0xc,%esp
 804870e:	50                   	push   %eax
 804870f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048712:	ff d0                	call   *%eax
 8048714:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 8048717:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 804871b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 804871f:	79 dc                	jns    80486fd <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048721:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048725:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 8048729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804872c:	0f b6 00             	movzbl (%eax),%eax
 804872f:	3c 63                	cmp    $0x63,%al
 8048731:	75 1d                	jne    8048750 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 8048733:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048736:	0f b6 00             	movzbl (%eax),%eax
 8048739:	0f be c0             	movsbl %al,%eax
 804873c:	83 ec 0c             	sub    $0xc,%esp
 804873f:	50                   	push   %eax
 8048740:	8b 45 08             	mov    0x8(%ebp),%eax
 8048743:	ff d0                	call   *%eax
 8048745:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 8048748:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804874c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 8048750:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 8048757:	eb 1b                	jmp    8048774 <vfprintf+0x286>
		}
		if(type == NONE){
 8048759:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 804875d:	75 15                	jne    8048774 <vfprintf+0x286>
			printer(cur);
 804875f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048762:	0f b6 00             	movzbl (%eax),%eax
 8048765:	0f be c0             	movsbl %al,%eax
 8048768:	83 ec 0c             	sub    $0xc,%esp
 804876b:	50                   	push   %eax
 804876c:	8b 45 08             	mov    0x8(%ebp),%eax
 804876f:	ff d0                	call   *%eax
 8048771:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048774:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804877b:	0f b6 00             	movzbl (%eax),%eax
 804877e:	84 c0                	test   %al,%al
 8048780:	0f 85 8d fd ff ff    	jne    8048513 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8048786:	c9                   	leave  
 8048787:	c3                   	ret    

08048788 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8048788:	55                   	push   %ebp
 8048789:	89 e5                	mov    %esp,%ebp
 804878b:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 804878e:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048791:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8048794:	8b 45 08             	mov    0x8(%ebp),%eax
 8048797:	83 ec 04             	sub    $0x4,%esp
 804879a:	ff 75 f4             	pushl  -0xc(%ebp)
 804879d:	50                   	push   %eax
 804879e:	68 9b 84 04 08       	push   $0x804849b
 80487a3:	e8 46 fd ff ff       	call   80484ee <vfprintf>
 80487a8:	83 c4 10             	add    $0x10,%esp
}
 80487ab:	c9                   	leave  
 80487ac:	c3                   	ret    
