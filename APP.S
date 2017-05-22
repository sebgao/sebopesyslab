
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

080480ef <sys_thread>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline int sys_thread(void* entry, uint32_t esp){
 80480ef:	55                   	push   %ebp
 80480f0:	89 e5                	mov    %esp,%ebp
 80480f2:	53                   	push   %ebx
 80480f3:	83 ec 10             	sub    $0x10,%esp
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
 80480f6:	b8 e6 05 00 00       	mov    $0x5e6,%eax
 80480fb:	8b 55 08             	mov    0x8(%ebp),%edx
 80480fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048101:	89 d3                	mov    %edx,%ebx
 8048103:	cd 80                	int    $0x80
 8048105:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return pid;
 8048108:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 804810b:	83 c4 10             	add    $0x10,%esp
 804810e:	5b                   	pop    %ebx
 804810f:	5d                   	pop    %ebp
 8048110:	c3                   	ret    

08048111 <sys_exit>:

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline void sys_exit(){
 8048111:	55                   	push   %ebp
 8048112:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
 8048114:	b8 dc 05 00 00       	mov    $0x5dc,%eax
 8048119:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 804811b:	b8 df 05 00 00       	mov    $0x5df,%eax
 8048120:	cd 80                	int    $0x80
}
 8048122:	5d                   	pop    %ebp
 8048123:	c3                   	ret    

08048124 <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 8048124:	55                   	push   %ebp
 8048125:	89 e5                	mov    %esp,%ebp
 8048127:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 8048128:	b8 de 05 00 00       	mov    $0x5de,%eax
 804812d:	8b 55 08             	mov    0x8(%ebp),%edx
 8048130:	89 d3                	mov    %edx,%ebx
 8048132:	cd 80                	int    $0x80
}
 8048134:	5b                   	pop    %ebx
 8048135:	5d                   	pop    %ebp
 8048136:	c3                   	ret    

08048137 <sys_join>:

static inline void sys_join(int pid){
 8048137:	55                   	push   %ebp
 8048138:	89 e5                	mov    %esp,%ebp
 804813a:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
 804813b:	b8 e2 05 00 00       	mov    $0x5e2,%eax
 8048140:	8b 55 08             	mov    0x8(%ebp),%edx
 8048143:	89 d3                	mov    %edx,%ebx
 8048145:	cd 80                	int    $0x80
}
 8048147:	5b                   	pop    %ebx
 8048148:	5d                   	pop    %ebp
 8048149:	c3                   	ret    

0804814a <insert_item>:
sem_t empty;
sem_t full;
int index;
int buffer[N];

void insert_item(int item){
 804814a:	55                   	push   %ebp
 804814b:	89 e5                	mov    %esp,%ebp
	buffer[index] = item;
 804814d:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048152:	8b 55 08             	mov    0x8(%ebp),%edx
 8048155:	89 14 85 44 9b 04 08 	mov    %edx,0x8049b44(,%eax,4)
	index ++;
 804815c:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048161:	83 c0 01             	add    $0x1,%eax
 8048164:	a3 4c 9b 04 08       	mov    %eax,0x8049b4c
}
 8048169:	5d                   	pop    %ebp
 804816a:	c3                   	ret    

0804816b <remove_item>:
int remove_item(){
 804816b:	55                   	push   %ebp
 804816c:	89 e5                	mov    %esp,%ebp
	index --;
 804816e:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048173:	83 e8 01             	sub    $0x1,%eax
 8048176:	a3 4c 9b 04 08       	mov    %eax,0x8049b4c
	return buffer[index];
 804817b:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048180:	8b 04 85 44 9b 04 08 	mov    0x8049b44(,%eax,4),%eax
}
 8048187:	5d                   	pop    %ebp
 8048188:	c3                   	ret    

08048189 <producer>:

void producer(){
 8048189:	55                   	push   %ebp
 804818a:	89 e5                	mov    %esp,%ebp
 804818c:	83 ec 18             	sub    $0x18,%esp
	int item;
	while(1){
		sleep(1+rand()%5);
 804818f:	e8 37 02 00 00       	call   80483cb <UKISS>
 8048194:	89 c1                	mov    %eax,%ecx
 8048196:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 804819b:	89 c8                	mov    %ecx,%eax
 804819d:	f7 e2                	mul    %edx
 804819f:	c1 ea 02             	shr    $0x2,%edx
 80481a2:	89 d0                	mov    %edx,%eax
 80481a4:	c1 e0 02             	shl    $0x2,%eax
 80481a7:	01 d0                	add    %edx,%eax
 80481a9:	29 c1                	sub    %eax,%ecx
 80481ab:	89 ca                	mov    %ecx,%edx
 80481ad:	8d 42 01             	lea    0x1(%edx),%eax
 80481b0:	83 ec 0c             	sub    $0xc,%esp
 80481b3:	50                   	push   %eax
 80481b4:	e8 6b ff ff ff       	call   8048124 <sys_sleep>
 80481b9:	83 c4 10             	add    $0x10,%esp
		item = rand()%10;
 80481bc:	e8 0a 02 00 00       	call   80483cb <UKISS>
 80481c1:	89 c1                	mov    %eax,%ecx
 80481c3:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 80481c8:	89 c8                	mov    %ecx,%eax
 80481ca:	f7 e2                	mul    %edx
 80481cc:	c1 ea 03             	shr    $0x3,%edx
 80481cf:	89 d0                	mov    %edx,%eax
 80481d1:	c1 e0 02             	shl    $0x2,%eax
 80481d4:	01 d0                	add    %edx,%eax
 80481d6:	01 c0                	add    %eax,%eax
 80481d8:	29 c1                	sub    %eax,%ecx
 80481da:	89 ca                	mov    %ecx,%edx
 80481dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
		printf("PRODUCER: %d produced!\n", item);
 80481df:	83 ec 08             	sub    $0x8,%esp
 80481e2:	ff 75 f4             	pushl  -0xc(%ebp)
 80481e5:	68 b0 87 04 08       	push   $0x80487b0
 80481ea:	e8 9c 05 00 00       	call   804878b <printf>
 80481ef:	83 c4 10             	add    $0x10,%esp
		sem_wait(&empty);
 80481f2:	83 ec 0c             	sub    $0xc,%esp
 80481f5:	68 50 9b 04 08       	push   $0x8049b50
 80481fa:	e8 be fe ff ff       	call   80480bd <sys_sem_wait>
 80481ff:	83 c4 10             	add    $0x10,%esp
		sem_wait(&mutex);
 8048202:	83 ec 0c             	sub    $0xc,%esp
 8048205:	68 38 9b 04 08       	push   $0x8049b38
 804820a:	e8 ae fe ff ff       	call   80480bd <sys_sem_wait>
 804820f:	83 c4 10             	add    $0x10,%esp

		insert_item(item);
 8048212:	83 ec 0c             	sub    $0xc,%esp
 8048215:	ff 75 f4             	pushl  -0xc(%ebp)
 8048218:	e8 2d ff ff ff       	call   804814a <insert_item>
 804821d:	83 c4 10             	add    $0x10,%esp

		printf("PRODUCER: %d sent, now %d space left!\n", item, N-index);
 8048220:	a1 4c 9b 04 08       	mov    0x8049b4c,%eax
 8048225:	ba 02 00 00 00       	mov    $0x2,%edx
 804822a:	29 c2                	sub    %eax,%edx
 804822c:	89 d0                	mov    %edx,%eax
 804822e:	83 ec 04             	sub    $0x4,%esp
 8048231:	50                   	push   %eax
 8048232:	ff 75 f4             	pushl  -0xc(%ebp)
 8048235:	68 c8 87 04 08       	push   $0x80487c8
 804823a:	e8 4c 05 00 00       	call   804878b <printf>
 804823f:	83 c4 10             	add    $0x10,%esp

		sem_post(&mutex);
 8048242:	83 ec 0c             	sub    $0xc,%esp
 8048245:	68 38 9b 04 08       	push   $0x8049b38
 804824a:	e8 5b fe ff ff       	call   80480aa <sys_sem_post>
 804824f:	83 c4 10             	add    $0x10,%esp
		sem_post(&full);
 8048252:	83 ec 0c             	sub    $0xc,%esp
 8048255:	68 2c 9b 04 08       	push   $0x8049b2c
 804825a:	e8 4b fe ff ff       	call   80480aa <sys_sem_post>
 804825f:	83 c4 10             	add    $0x10,%esp
	}
 8048262:	e9 28 ff ff ff       	jmp    804818f <producer+0x6>

08048267 <consumer>:
}

void consumer(){
 8048267:	55                   	push   %ebp
 8048268:	89 e5                	mov    %esp,%ebp
 804826a:	83 ec 18             	sub    $0x18,%esp
	int item;
	int asleep;
	while(1){
		printf("CONSUMER: ready to receive!\n");
 804826d:	83 ec 0c             	sub    $0xc,%esp
 8048270:	68 ef 87 04 08       	push   $0x80487ef
 8048275:	e8 11 05 00 00       	call   804878b <printf>
 804827a:	83 c4 10             	add    $0x10,%esp
		while(!sem_trywait(&full));
 804827d:	90                   	nop
 804827e:	83 ec 0c             	sub    $0xc,%esp
 8048281:	68 2c 9b 04 08       	push   $0x8049b2c
 8048286:	e8 45 fe ff ff       	call   80480d0 <sys_sem_trywait>
 804828b:	83 c4 10             	add    $0x10,%esp
 804828e:	85 c0                	test   %eax,%eax
 8048290:	74 ec                	je     804827e <consumer+0x17>
		while(!sem_trywait(&mutex));
 8048292:	90                   	nop
 8048293:	83 ec 0c             	sub    $0xc,%esp
 8048296:	68 38 9b 04 08       	push   $0x8049b38
 804829b:	e8 30 fe ff ff       	call   80480d0 <sys_sem_trywait>
 80482a0:	83 c4 10             	add    $0x10,%esp
 80482a3:	85 c0                	test   %eax,%eax
 80482a5:	74 ec                	je     8048293 <consumer+0x2c>

		item = remove_item();
 80482a7:	e8 bf fe ff ff       	call   804816b <remove_item>
 80482ac:	89 45 f4             	mov    %eax,-0xc(%ebp)

		sem_post(&mutex);
 80482af:	83 ec 0c             	sub    $0xc,%esp
 80482b2:	68 38 9b 04 08       	push   $0x8049b38
 80482b7:	e8 ee fd ff ff       	call   80480aa <sys_sem_post>
 80482bc:	83 c4 10             	add    $0x10,%esp
		sem_post(&empty);
 80482bf:	83 ec 0c             	sub    $0xc,%esp
 80482c2:	68 50 9b 04 08       	push   $0x8049b50
 80482c7:	e8 de fd ff ff       	call   80480aa <sys_sem_post>
 80482cc:	83 c4 10             	add    $0x10,%esp

		asleep = 1+rand()%15;
 80482cf:	e8 f7 00 00 00       	call   80483cb <UKISS>
 80482d4:	89 c1                	mov    %eax,%ecx
 80482d6:	ba 89 88 88 88       	mov    $0x88888889,%edx
 80482db:	89 c8                	mov    %ecx,%eax
 80482dd:	f7 e2                	mul    %edx
 80482df:	89 d0                	mov    %edx,%eax
 80482e1:	c1 e8 03             	shr    $0x3,%eax
 80482e4:	89 c2                	mov    %eax,%edx
 80482e6:	c1 e2 04             	shl    $0x4,%edx
 80482e9:	29 c2                	sub    %eax,%edx
 80482eb:	89 c8                	mov    %ecx,%eax
 80482ed:	29 d0                	sub    %edx,%eax
 80482ef:	83 c0 01             	add    $0x1,%eax
 80482f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		printf("CONSUMER: %d received, now I want to consumer it in %ds!\n", item, asleep);
 80482f5:	83 ec 04             	sub    $0x4,%esp
 80482f8:	ff 75 f0             	pushl  -0x10(%ebp)
 80482fb:	ff 75 f4             	pushl  -0xc(%ebp)
 80482fe:	68 0c 88 04 08       	push   $0x804880c
 8048303:	e8 83 04 00 00       	call   804878b <printf>
 8048308:	83 c4 10             	add    $0x10,%esp
		sleep(asleep); //consume
 804830b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804830e:	83 ec 0c             	sub    $0xc,%esp
 8048311:	50                   	push   %eax
 8048312:	e8 0d fe ff ff       	call   8048124 <sys_sleep>
 8048317:	83 c4 10             	add    $0x10,%esp

	}
 804831a:	e9 4e ff ff ff       	jmp    804826d <consumer+0x6>

0804831f <main>:
}
int main(){
 804831f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048323:	83 e4 f0             	and    $0xfffffff0,%esp
 8048326:	ff 71 fc             	pushl  -0x4(%ecx)
 8048329:	55                   	push   %ebp
 804832a:	89 e5                	mov    %esp,%ebp
 804832c:	51                   	push   %ecx
 804832d:	83 ec 14             	sub    $0x14,%esp
	sem_init(&mutex, 1);
 8048330:	6a 01                	push   $0x1
 8048332:	68 38 9b 04 08       	push   $0x8049b38
 8048337:	e8 58 fd ff ff       	call   8048094 <sys_sem_init>
 804833c:	83 c4 08             	add    $0x8,%esp
	sem_init(&empty, N);
 804833f:	6a 02                	push   $0x2
 8048341:	68 50 9b 04 08       	push   $0x8049b50
 8048346:	e8 49 fd ff ff       	call   8048094 <sys_sem_init>
 804834b:	83 c4 08             	add    $0x8,%esp
	sem_init(&full,	0);
 804834e:	6a 00                	push   $0x0
 8048350:	68 2c 9b 04 08       	push   $0x8049b2c
 8048355:	e8 3a fd ff ff       	call   8048094 <sys_sem_init>
 804835a:	83 c4 08             	add    $0x8,%esp
	index = 0;
 804835d:	c7 05 4c 9b 04 08 00 	movl   $0x0,0x8049b4c
 8048364:	00 00 00 
	thread_t prod, cons;
	prod = thread(producer, 0xeebfd000);
 8048367:	68 00 d0 bf ee       	push   $0xeebfd000
 804836c:	68 89 81 04 08       	push   $0x8048189
 8048371:	e8 79 fd ff ff       	call   80480ef <sys_thread>
 8048376:	83 c4 08             	add    $0x8,%esp
 8048379:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cons = thread(consumer, 0xeebfd000);
 804837c:	68 00 d0 bf ee       	push   $0xeebfd000
 8048381:	68 67 82 04 08       	push   $0x8048267
 8048386:	e8 64 fd ff ff       	call   80480ef <sys_thread>
 804838b:	83 c4 08             	add    $0x8,%esp
 804838e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	thread_join(prod);
 8048391:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048394:	50                   	push   %eax
 8048395:	e8 9d fd ff ff       	call   8048137 <sys_join>
 804839a:	83 c4 04             	add    $0x4,%esp
	thread_join(cons);
 804839d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80483a0:	50                   	push   %eax
 80483a1:	e8 91 fd ff ff       	call   8048137 <sys_join>
 80483a6:	83 c4 04             	add    $0x4,%esp

	printf("You should not see this, since the producer and consumer are sisyphean\n");
 80483a9:	83 ec 0c             	sub    $0xc,%esp
 80483ac:	68 48 88 04 08       	push   $0x8048848
 80483b1:	e8 d5 03 00 00       	call   804878b <printf>
 80483b6:	83 c4 10             	add    $0x10,%esp
	exit();
 80483b9:	e8 53 fd ff ff       	call   8048111 <sys_exit>
 80483be:	b8 00 00 00 00       	mov    $0x0,%eax
 80483c3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 80483c6:	c9                   	leave  
 80483c7:	8d 61 fc             	lea    -0x4(%ecx),%esp
 80483ca:	c3                   	ret    

080483cb <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 80483cb:	55                   	push   %ebp
 80483cc:	89 e5                	mov    %esp,%ebp
 80483ce:	53                   	push   %ebx
 80483cf:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 80483d2:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 80483d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 80483e0:	a1 1c 9b 04 08       	mov    0x8049b1c,%eax
 80483e5:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 80483eb:	05 39 30 00 00       	add    $0x3039,%eax
 80483f0:	a3 1c 9b 04 08       	mov    %eax,0x8049b1c
    y ^= (y<<13);   
 80483f5:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 80483fa:	c1 e0 0d             	shl    $0xd,%eax
 80483fd:	89 c2                	mov    %eax,%edx
 80483ff:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 8048404:	31 d0                	xor    %edx,%eax
 8048406:	a3 20 9b 04 08       	mov    %eax,0x8049b20
    y ^= (y>>17);   
 804840b:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 8048410:	c1 e8 11             	shr    $0x11,%eax
 8048413:	89 c2                	mov    %eax,%edx
 8048415:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 804841a:	31 d0                	xor    %edx,%eax
 804841c:	a3 20 9b 04 08       	mov    %eax,0x8049b20
    y ^= (y<<5);    
 8048421:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 8048426:	c1 e0 05             	shl    $0x5,%eax
 8048429:	89 c2                	mov    %eax,%edx
 804842b:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 8048430:	31 d0                	xor    %edx,%eax
 8048432:	a3 20 9b 04 08       	mov    %eax,0x8049b20
      
    t = (A*z + c);  
 8048437:	a1 24 9b 04 08       	mov    0x8049b24,%eax
 804843c:	ba 00 00 00 00       	mov    $0x0,%edx
 8048441:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 8048444:	89 cb                	mov    %ecx,%ebx
 8048446:	0f af da             	imul   %edx,%ebx
 8048449:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 804844c:	0f af c8             	imul   %eax,%ecx
 804844f:	01 d9                	add    %ebx,%ecx
 8048451:	f7 65 f0             	mull   -0x10(%ebp)
 8048454:	01 d1                	add    %edx,%ecx
 8048456:	89 ca                	mov    %ecx,%edx
 8048458:	8b 0d 28 9b 04 08    	mov    0x8049b28,%ecx
 804845e:	bb 00 00 00 00       	mov    $0x0,%ebx
 8048463:	01 c8                	add    %ecx,%eax
 8048465:	11 da                	adc    %ebx,%edx
 8048467:	89 45 e8             	mov    %eax,-0x18(%ebp)
 804846a:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 804846d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048470:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8048473:	89 d0                	mov    %edx,%eax
 8048475:	31 d2                	xor    %edx,%edx
 8048477:	a3 28 9b 04 08       	mov    %eax,0x8049b28
    z = t;  
 804847c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804847f:	a3 24 9b 04 08       	mov    %eax,0x8049b24
       
    return x+y+z;    
 8048484:	8b 15 1c 9b 04 08    	mov    0x8049b1c,%edx
 804848a:	a1 20 9b 04 08       	mov    0x8049b20,%eax
 804848f:	01 c2                	add    %eax,%edx
 8048491:	a1 24 9b 04 08       	mov    0x8049b24,%eax
 8048496:	01 d0                	add    %edx,%eax
 8048498:	83 c4 14             	add    $0x14,%esp
 804849b:	5b                   	pop    %ebx
 804849c:	5d                   	pop    %ebp
 804849d:	c3                   	ret    

0804849e <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 804849e:	55                   	push   %ebp
 804849f:	89 e5                	mov    %esp,%ebp
 80484a1:	53                   	push   %ebx
 80484a2:	83 ec 04             	sub    $0x4,%esp
 80484a5:	8b 45 08             	mov    0x8(%ebp),%eax
 80484a8:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 80484ab:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 80484b0:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 80484b4:	89 d3                	mov    %edx,%ebx
 80484b6:	cd 80                	int    $0x80
}
 80484b8:	83 c4 04             	add    $0x4,%esp
 80484bb:	5b                   	pop    %ebx
 80484bc:	5d                   	pop    %ebp
 80484bd:	c3                   	ret    

080484be <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 80484be:	55                   	push   %ebp
 80484bf:	89 e5                	mov    %esp,%ebp
 80484c1:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 80484c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 80484c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 80484ca:	eb 19                	jmp    80484e5 <printp+0x27>
		printer(cur);
 80484cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484cf:	0f b6 00             	movzbl (%eax),%eax
 80484d2:	0f be c0             	movsbl %al,%eax
 80484d5:	83 ec 0c             	sub    $0xc,%esp
 80484d8:	50                   	push   %eax
 80484d9:	8b 45 08             	mov    0x8(%ebp),%eax
 80484dc:	ff d0                	call   *%eax
 80484de:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80484e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80484e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484e8:	0f b6 00             	movzbl (%eax),%eax
 80484eb:	84 c0                	test   %al,%al
 80484ed:	75 dd                	jne    80484cc <printp+0xe>
		printer(cur);
	}
}
 80484ef:	c9                   	leave  
 80484f0:	c3                   	ret    

080484f1 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 80484f1:	55                   	push   %ebp
 80484f2:	89 e5                	mov    %esp,%ebp
 80484f4:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 80484f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 80484fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 80484fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8048504:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 804850b:	8b 45 10             	mov    0x10(%ebp),%eax
 804850e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048511:	e9 65 02 00 00       	jmp    804877b <vfprintf+0x28a>

		if(cur == '%'){
 8048516:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048519:	0f b6 00             	movzbl (%eax),%eax
 804851c:	3c 25                	cmp    $0x25,%al
 804851e:	75 0c                	jne    804852c <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 8048520:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 8048527:	e9 4b 02 00 00       	jmp    8048777 <vfprintf+0x286>
		}
		if(type == READ){
 804852c:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 8048530:	0f 85 26 02 00 00    	jne    804875c <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 8048536:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048539:	0f b6 00             	movzbl (%eax),%eax
 804853c:	3c 73                	cmp    $0x73,%al
 804853e:	75 35                	jne    8048575 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 8048540:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048543:	8b 00                	mov    (%eax),%eax
 8048545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 8048548:	eb 19                	jmp    8048563 <vfprintf+0x72>
					printer(*p);
 804854a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804854d:	0f b6 00             	movzbl (%eax),%eax
 8048550:	0f be c0             	movsbl %al,%eax
 8048553:	83 ec 0c             	sub    $0xc,%esp
 8048556:	50                   	push   %eax
 8048557:	8b 45 08             	mov    0x8(%ebp),%eax
 804855a:	ff d0                	call   *%eax
 804855c:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 804855f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 8048563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048566:	0f b6 00             	movzbl (%eax),%eax
 8048569:	84 c0                	test   %al,%al
 804856b:	75 dd                	jne    804854a <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 804856d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048571:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 8048575:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048578:	0f b6 00             	movzbl (%eax),%eax
 804857b:	3c 78                	cmp    $0x78,%al
 804857d:	0f 85 99 00 00 00    	jne    804861c <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048586:	8b 00                	mov    (%eax),%eax
 8048588:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 804858b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804858f:	75 1d                	jne    80485ae <vfprintf+0xbd>
					printer('0');
 8048591:	83 ec 0c             	sub    $0xc,%esp
 8048594:	6a 30                	push   $0x30
 8048596:	8b 45 08             	mov    0x8(%ebp),%eax
 8048599:	ff d0                	call   *%eax
 804859b:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804859e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80485a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80485a9:	e9 c9 01 00 00       	jmp    8048777 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 80485ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 80485b5:	eb 2d                	jmp    80485e4 <vfprintf+0xf3>
					int d=(x%16);
 80485b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80485ba:	83 e0 0f             	and    $0xf,%eax
 80485bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 80485c0:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80485c4:	7e 04                	jle    80485ca <vfprintf+0xd9>
						d+='a'-'0'-10;
 80485c6:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 80485ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80485cd:	83 c0 30             	add    $0x30,%eax
 80485d0:	89 c1                	mov    %eax,%ecx
 80485d2:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80485d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80485d8:	01 d0                	add    %edx,%eax
 80485da:	88 08                	mov    %cl,(%eax)
					x>>=4;
 80485dc:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 80485e0:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80485e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80485e8:	75 cd                	jne    80485b7 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 80485ea:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 80485ee:	eb 1e                	jmp    804860e <vfprintf+0x11d>
					printer(digits[di]);
 80485f0:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80485f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80485f6:	01 d0                	add    %edx,%eax
 80485f8:	0f b6 00             	movzbl (%eax),%eax
 80485fb:	0f be c0             	movsbl %al,%eax
 80485fe:	83 ec 0c             	sub    $0xc,%esp
 8048601:	50                   	push   %eax
 8048602:	8b 45 08             	mov    0x8(%ebp),%eax
 8048605:	ff d0                	call   *%eax
 8048607:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 804860a:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 804860e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8048612:	79 dc                	jns    80485f0 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048614:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048618:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 804861c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804861f:	0f b6 00             	movzbl (%eax),%eax
 8048622:	3c 64                	cmp    $0x64,%al
 8048624:	0f 85 02 01 00 00    	jne    804872c <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 804862a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804862d:	8b 00                	mov    (%eax),%eax
 804862f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 8048632:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 8048639:	75 23                	jne    804865e <vfprintf+0x16d>
					printp(printer, "-2147483648");
 804863b:	83 ec 08             	sub    $0x8,%esp
 804863e:	68 90 88 04 08       	push   $0x8048890
 8048643:	ff 75 08             	pushl  0x8(%ebp)
 8048646:	e8 73 fe ff ff       	call   80484be <printp>
 804864b:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804864e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048652:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048659:	e9 19 01 00 00       	jmp    8048777 <vfprintf+0x286>
				}
				if(x==0){
 804865e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048662:	75 1e                	jne    8048682 <vfprintf+0x191>
					printer('0');
 8048664:	83 ec 0c             	sub    $0xc,%esp
 8048667:	6a 30                	push   $0x30
 8048669:	8b 45 08             	mov    0x8(%ebp),%eax
 804866c:	ff d0                	call   *%eax
 804866e:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048671:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048675:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 804867c:	90                   	nop
 804867d:	e9 f5 00 00 00       	jmp    8048777 <vfprintf+0x286>
				}
				if(x<0){
 8048682:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048686:	79 10                	jns    8048698 <vfprintf+0x1a7>
					printer('-');
 8048688:	83 ec 0c             	sub    $0xc,%esp
 804868b:	6a 2d                	push   $0x2d
 804868d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048690:	ff d0                	call   *%eax
 8048692:	83 c4 10             	add    $0x10,%esp
					x=-x;
 8048695:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 8048698:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 804869f:	eb 53                	jmp    80486f4 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 80486a1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80486a4:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80486a9:	89 c8                	mov    %ecx,%eax
 80486ab:	f7 ea                	imul   %edx
 80486ad:	c1 fa 02             	sar    $0x2,%edx
 80486b0:	89 c8                	mov    %ecx,%eax
 80486b2:	c1 f8 1f             	sar    $0x1f,%eax
 80486b5:	29 c2                	sub    %eax,%edx
 80486b7:	89 d0                	mov    %edx,%eax
 80486b9:	c1 e0 02             	shl    $0x2,%eax
 80486bc:	01 d0                	add    %edx,%eax
 80486be:	01 c0                	add    %eax,%eax
 80486c0:	29 c1                	sub    %eax,%ecx
 80486c2:	89 ca                	mov    %ecx,%edx
 80486c4:	89 d0                	mov    %edx,%eax
 80486c6:	83 c0 30             	add    $0x30,%eax
 80486c9:	89 c1                	mov    %eax,%ecx
 80486cb:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80486ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80486d1:	01 d0                	add    %edx,%eax
 80486d3:	88 08                	mov    %cl,(%eax)
					x/=10;
 80486d5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80486d8:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80486dd:	89 c8                	mov    %ecx,%eax
 80486df:	f7 ea                	imul   %edx
 80486e1:	c1 fa 02             	sar    $0x2,%edx
 80486e4:	89 c8                	mov    %ecx,%eax
 80486e6:	c1 f8 1f             	sar    $0x1f,%eax
 80486e9:	29 c2                	sub    %eax,%edx
 80486eb:	89 d0                	mov    %edx,%eax
 80486ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 80486f0:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80486f4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80486f8:	7f a7                	jg     80486a1 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 80486fa:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 80486fe:	eb 1e                	jmp    804871e <vfprintf+0x22d>
					printer(digits[di]);
 8048700:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048703:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048706:	01 d0                	add    %edx,%eax
 8048708:	0f b6 00             	movzbl (%eax),%eax
 804870b:	0f be c0             	movsbl %al,%eax
 804870e:	83 ec 0c             	sub    $0xc,%esp
 8048711:	50                   	push   %eax
 8048712:	8b 45 08             	mov    0x8(%ebp),%eax
 8048715:	ff d0                	call   *%eax
 8048717:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 804871a:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 804871e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8048722:	79 dc                	jns    8048700 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048724:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048728:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 804872c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804872f:	0f b6 00             	movzbl (%eax),%eax
 8048732:	3c 63                	cmp    $0x63,%al
 8048734:	75 1d                	jne    8048753 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 8048736:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048739:	0f b6 00             	movzbl (%eax),%eax
 804873c:	0f be c0             	movsbl %al,%eax
 804873f:	83 ec 0c             	sub    $0xc,%esp
 8048742:	50                   	push   %eax
 8048743:	8b 45 08             	mov    0x8(%ebp),%eax
 8048746:	ff d0                	call   *%eax
 8048748:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 804874b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804874f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 8048753:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 804875a:	eb 1b                	jmp    8048777 <vfprintf+0x286>
		}
		if(type == NONE){
 804875c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048760:	75 15                	jne    8048777 <vfprintf+0x286>
			printer(cur);
 8048762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048765:	0f b6 00             	movzbl (%eax),%eax
 8048768:	0f be c0             	movsbl %al,%eax
 804876b:	83 ec 0c             	sub    $0xc,%esp
 804876e:	50                   	push   %eax
 804876f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048772:	ff d0                	call   *%eax
 8048774:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048777:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804877b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804877e:	0f b6 00             	movzbl (%eax),%eax
 8048781:	84 c0                	test   %al,%al
 8048783:	0f 85 8d fd ff ff    	jne    8048516 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8048789:	c9                   	leave  
 804878a:	c3                   	ret    

0804878b <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 804878b:	55                   	push   %ebp
 804878c:	89 e5                	mov    %esp,%ebp
 804878e:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048791:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048794:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8048797:	8b 45 08             	mov    0x8(%ebp),%eax
 804879a:	83 ec 04             	sub    $0x4,%esp
 804879d:	ff 75 f4             	pushl  -0xc(%ebp)
 80487a0:	50                   	push   %eax
 80487a1:	68 9e 84 04 08       	push   $0x804849e
 80487a6:	e8 46 fd ff ff       	call   80484f1 <vfprintf>
 80487ab:	83 c4 10             	add    $0x10,%esp
}
 80487ae:	c9                   	leave  
 80487af:	c3                   	ret    
