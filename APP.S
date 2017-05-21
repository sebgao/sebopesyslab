
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

080480d0 <sys_thread>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline int sys_thread(void* entry, uint32_t esp){
 80480d0:	55                   	push   %ebp
 80480d1:	89 e5                	mov    %esp,%ebp
 80480d3:	53                   	push   %ebx
 80480d4:	83 ec 10             	sub    $0x10,%esp
	int pid;
	asm volatile("int $0x80": "=a"(pid) : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
 80480d7:	b8 e6 05 00 00       	mov    $0x5e6,%eax
 80480dc:	8b 55 08             	mov    0x8(%ebp),%edx
 80480df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80480e2:	89 d3                	mov    %edx,%ebx
 80480e4:	cd 80                	int    $0x80
 80480e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return pid;
 80480e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 80480ec:	83 c4 10             	add    $0x10,%esp
 80480ef:	5b                   	pop    %ebx
 80480f0:	5d                   	pop    %ebp
 80480f1:	c3                   	ret    

080480f2 <sys_exit>:

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline void sys_exit(){
 80480f2:	55                   	push   %ebp
 80480f3:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
 80480f5:	b8 dc 05 00 00       	mov    $0x5dc,%eax
 80480fa:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 80480fc:	b8 df 05 00 00       	mov    $0x5df,%eax
 8048101:	cd 80                	int    $0x80
}
 8048103:	5d                   	pop    %ebp
 8048104:	c3                   	ret    

08048105 <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 8048105:	55                   	push   %ebp
 8048106:	89 e5                	mov    %esp,%ebp
 8048108:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 8048109:	b8 de 05 00 00       	mov    $0x5de,%eax
 804810e:	8b 55 08             	mov    0x8(%ebp),%edx
 8048111:	89 d3                	mov    %edx,%ebx
 8048113:	cd 80                	int    $0x80
}
 8048115:	5b                   	pop    %ebx
 8048116:	5d                   	pop    %ebp
 8048117:	c3                   	ret    

08048118 <sys_join>:

static inline void sys_join(int pid){
 8048118:	55                   	push   %ebp
 8048119:	89 e5                	mov    %esp,%ebp
 804811b:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
 804811c:	b8 e2 05 00 00       	mov    $0x5e2,%eax
 8048121:	8b 55 08             	mov    0x8(%ebp),%edx
 8048124:	89 d3                	mov    %edx,%ebx
 8048126:	cd 80                	int    $0x80
}
 8048128:	5b                   	pop    %ebx
 8048129:	5d                   	pop    %ebp
 804812a:	c3                   	ret    

0804812b <insert_item>:
semaphore empty;
semaphore full;
int index;
int buffer[N];

void insert_item(int item){
 804812b:	55                   	push   %ebp
 804812c:	89 e5                	mov    %esp,%ebp
	buffer[index] = item;
 804812e:	a1 a0 9a 04 08       	mov    0x8049aa0,%eax
 8048133:	8b 55 08             	mov    0x8(%ebp),%edx
 8048136:	89 14 85 98 9a 04 08 	mov    %edx,0x8049a98(,%eax,4)
	index ++;
 804813d:	a1 a0 9a 04 08       	mov    0x8049aa0,%eax
 8048142:	83 c0 01             	add    $0x1,%eax
 8048145:	a3 a0 9a 04 08       	mov    %eax,0x8049aa0
}
 804814a:	5d                   	pop    %ebp
 804814b:	c3                   	ret    

0804814c <remove_item>:
int remove_item(){
 804814c:	55                   	push   %ebp
 804814d:	89 e5                	mov    %esp,%ebp
	index --;
 804814f:	a1 a0 9a 04 08       	mov    0x8049aa0,%eax
 8048154:	83 e8 01             	sub    $0x1,%eax
 8048157:	a3 a0 9a 04 08       	mov    %eax,0x8049aa0
	return buffer[index];
 804815c:	a1 a0 9a 04 08       	mov    0x8049aa0,%eax
 8048161:	8b 04 85 98 9a 04 08 	mov    0x8049a98(,%eax,4),%eax
}
 8048168:	5d                   	pop    %ebp
 8048169:	c3                   	ret    

0804816a <producer>:

void producer(){
 804816a:	55                   	push   %ebp
 804816b:	89 e5                	mov    %esp,%ebp
 804816d:	83 ec 18             	sub    $0x18,%esp
	int item;
	while(1){
		sleep(1+rand()%5);
 8048170:	e8 fe 01 00 00       	call   8048373 <UKISS>
 8048175:	89 c1                	mov    %eax,%ecx
 8048177:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 804817c:	89 c8                	mov    %ecx,%eax
 804817e:	f7 e2                	mul    %edx
 8048180:	c1 ea 02             	shr    $0x2,%edx
 8048183:	89 d0                	mov    %edx,%eax
 8048185:	c1 e0 02             	shl    $0x2,%eax
 8048188:	01 d0                	add    %edx,%eax
 804818a:	29 c1                	sub    %eax,%ecx
 804818c:	89 ca                	mov    %ecx,%edx
 804818e:	8d 42 01             	lea    0x1(%edx),%eax
 8048191:	83 ec 0c             	sub    $0xc,%esp
 8048194:	50                   	push   %eax
 8048195:	e8 6b ff ff ff       	call   8048105 <sys_sleep>
 804819a:	83 c4 10             	add    $0x10,%esp
		item = rand()%10;
 804819d:	e8 d1 01 00 00       	call   8048373 <UKISS>
 80481a2:	89 c1                	mov    %eax,%ecx
 80481a4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 80481a9:	89 c8                	mov    %ecx,%eax
 80481ab:	f7 e2                	mul    %edx
 80481ad:	c1 ea 03             	shr    $0x3,%edx
 80481b0:	89 d0                	mov    %edx,%eax
 80481b2:	c1 e0 02             	shl    $0x2,%eax
 80481b5:	01 d0                	add    %edx,%eax
 80481b7:	01 c0                	add    %eax,%eax
 80481b9:	29 c1                	sub    %eax,%ecx
 80481bb:	89 ca                	mov    %ecx,%edx
 80481bd:	89 55 f4             	mov    %edx,-0xc(%ebp)

		sem_wait(&empty);
 80481c0:	83 ec 0c             	sub    $0xc,%esp
 80481c3:	68 a4 9a 04 08       	push   $0x8049aa4
 80481c8:	e8 f0 fe ff ff       	call   80480bd <sys_sem_wait>
 80481cd:	83 c4 10             	add    $0x10,%esp
		sem_wait(&mutex);
 80481d0:	83 ec 0c             	sub    $0xc,%esp
 80481d3:	68 8c 9a 04 08       	push   $0x8049a8c
 80481d8:	e8 e0 fe ff ff       	call   80480bd <sys_sem_wait>
 80481dd:	83 c4 10             	add    $0x10,%esp

		insert_item(item);
 80481e0:	83 ec 0c             	sub    $0xc,%esp
 80481e3:	ff 75 f4             	pushl  -0xc(%ebp)
 80481e6:	e8 40 ff ff ff       	call   804812b <insert_item>
 80481eb:	83 c4 10             	add    $0x10,%esp

		printf("PRODUCER: %d sent, now %d space left!\n", item, N-index);
 80481ee:	a1 a0 9a 04 08       	mov    0x8049aa0,%eax
 80481f3:	ba 02 00 00 00       	mov    $0x2,%edx
 80481f8:	29 c2                	sub    %eax,%edx
 80481fa:	89 d0                	mov    %edx,%eax
 80481fc:	83 ec 04             	sub    $0x4,%esp
 80481ff:	50                   	push   %eax
 8048200:	ff 75 f4             	pushl  -0xc(%ebp)
 8048203:	68 58 87 04 08       	push   $0x8048758
 8048208:	e8 26 05 00 00       	call   8048733 <printf>
 804820d:	83 c4 10             	add    $0x10,%esp

		sem_post(&mutex);
 8048210:	83 ec 0c             	sub    $0xc,%esp
 8048213:	68 8c 9a 04 08       	push   $0x8049a8c
 8048218:	e8 8d fe ff ff       	call   80480aa <sys_sem_post>
 804821d:	83 c4 10             	add    $0x10,%esp
		sem_post(&full);
 8048220:	83 ec 0c             	sub    $0xc,%esp
 8048223:	68 80 9a 04 08       	push   $0x8049a80
 8048228:	e8 7d fe ff ff       	call   80480aa <sys_sem_post>
 804822d:	83 c4 10             	add    $0x10,%esp
	}
 8048230:	e9 3b ff ff ff       	jmp    8048170 <producer+0x6>

08048235 <consumer>:
}

void consumer(){
 8048235:	55                   	push   %ebp
 8048236:	89 e5                	mov    %esp,%ebp
 8048238:	83 ec 18             	sub    $0x18,%esp
	int item;
	int asleep;
	while(1){

		sem_wait(&full);
 804823b:	68 80 9a 04 08       	push   $0x8049a80
 8048240:	e8 78 fe ff ff       	call   80480bd <sys_sem_wait>
 8048245:	83 c4 04             	add    $0x4,%esp
		sem_wait(&mutex);
 8048248:	68 8c 9a 04 08       	push   $0x8049a8c
 804824d:	e8 6b fe ff ff       	call   80480bd <sys_sem_wait>
 8048252:	83 c4 04             	add    $0x4,%esp

		item = remove_item();
 8048255:	e8 f2 fe ff ff       	call   804814c <remove_item>
 804825a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		sem_post(&mutex);
 804825d:	68 8c 9a 04 08       	push   $0x8049a8c
 8048262:	e8 43 fe ff ff       	call   80480aa <sys_sem_post>
 8048267:	83 c4 04             	add    $0x4,%esp
		sem_post(&empty);
 804826a:	68 a4 9a 04 08       	push   $0x8049aa4
 804826f:	e8 36 fe ff ff       	call   80480aa <sys_sem_post>
 8048274:	83 c4 04             	add    $0x4,%esp

		asleep = 1+rand()%15;
 8048277:	e8 f7 00 00 00       	call   8048373 <UKISS>
 804827c:	89 c1                	mov    %eax,%ecx
 804827e:	ba 89 88 88 88       	mov    $0x88888889,%edx
 8048283:	89 c8                	mov    %ecx,%eax
 8048285:	f7 e2                	mul    %edx
 8048287:	89 d0                	mov    %edx,%eax
 8048289:	c1 e8 03             	shr    $0x3,%eax
 804828c:	89 c2                	mov    %eax,%edx
 804828e:	c1 e2 04             	shl    $0x4,%edx
 8048291:	29 c2                	sub    %eax,%edx
 8048293:	89 c8                	mov    %ecx,%eax
 8048295:	29 d0                	sub    %edx,%eax
 8048297:	83 c0 01             	add    $0x1,%eax
 804829a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		printf("CONSUMER: %d received, now I want to consumer it in %ds!\n", item, asleep);
 804829d:	83 ec 04             	sub    $0x4,%esp
 80482a0:	ff 75 f0             	pushl  -0x10(%ebp)
 80482a3:	ff 75 f4             	pushl  -0xc(%ebp)
 80482a6:	68 80 87 04 08       	push   $0x8048780
 80482ab:	e8 83 04 00 00       	call   8048733 <printf>
 80482b0:	83 c4 10             	add    $0x10,%esp
		sleep(asleep); //consume
 80482b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80482b6:	83 ec 0c             	sub    $0xc,%esp
 80482b9:	50                   	push   %eax
 80482ba:	e8 46 fe ff ff       	call   8048105 <sys_sleep>
 80482bf:	83 c4 10             	add    $0x10,%esp

	}
 80482c2:	e9 74 ff ff ff       	jmp    804823b <consumer+0x6>

080482c7 <main>:
}
int main(){
 80482c7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 80482cb:	83 e4 f0             	and    $0xfffffff0,%esp
 80482ce:	ff 71 fc             	pushl  -0x4(%ecx)
 80482d1:	55                   	push   %ebp
 80482d2:	89 e5                	mov    %esp,%ebp
 80482d4:	51                   	push   %ecx
 80482d5:	83 ec 14             	sub    $0x14,%esp
	sem_init(&mutex, 1);
 80482d8:	6a 01                	push   $0x1
 80482da:	68 8c 9a 04 08       	push   $0x8049a8c
 80482df:	e8 b0 fd ff ff       	call   8048094 <sys_sem_init>
 80482e4:	83 c4 08             	add    $0x8,%esp
	sem_init(&empty, N);
 80482e7:	6a 02                	push   $0x2
 80482e9:	68 a4 9a 04 08       	push   $0x8049aa4
 80482ee:	e8 a1 fd ff ff       	call   8048094 <sys_sem_init>
 80482f3:	83 c4 08             	add    $0x8,%esp
	sem_init(&full,	0);
 80482f6:	6a 00                	push   $0x0
 80482f8:	68 80 9a 04 08       	push   $0x8049a80
 80482fd:	e8 92 fd ff ff       	call   8048094 <sys_sem_init>
 8048302:	83 c4 08             	add    $0x8,%esp
	index = 0;
 8048305:	c7 05 a0 9a 04 08 00 	movl   $0x0,0x8049aa0
 804830c:	00 00 00 
	thread_t prod, cons;
	prod = thread(producer, 0xeebfd000);
 804830f:	68 00 d0 bf ee       	push   $0xeebfd000
 8048314:	68 6a 81 04 08       	push   $0x804816a
 8048319:	e8 b2 fd ff ff       	call   80480d0 <sys_thread>
 804831e:	83 c4 08             	add    $0x8,%esp
 8048321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cons = thread(consumer, 0xeebfd000);
 8048324:	68 00 d0 bf ee       	push   $0xeebfd000
 8048329:	68 35 82 04 08       	push   $0x8048235
 804832e:	e8 9d fd ff ff       	call   80480d0 <sys_thread>
 8048333:	83 c4 08             	add    $0x8,%esp
 8048336:	89 45 f0             	mov    %eax,-0x10(%ebp)

	thread_join(prod);
 8048339:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804833c:	50                   	push   %eax
 804833d:	e8 d6 fd ff ff       	call   8048118 <sys_join>
 8048342:	83 c4 04             	add    $0x4,%esp
	thread_join(cons);
 8048345:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048348:	50                   	push   %eax
 8048349:	e8 ca fd ff ff       	call   8048118 <sys_join>
 804834e:	83 c4 04             	add    $0x4,%esp

	printf("You should not see this, because the producer and consumer are sisyphean\n");
 8048351:	83 ec 0c             	sub    $0xc,%esp
 8048354:	68 bc 87 04 08       	push   $0x80487bc
 8048359:	e8 d5 03 00 00       	call   8048733 <printf>
 804835e:	83 c4 10             	add    $0x10,%esp
	exit();
 8048361:	e8 8c fd ff ff       	call   80480f2 <sys_exit>
 8048366:	b8 00 00 00 00       	mov    $0x0,%eax
 804836b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 804836e:	c9                   	leave  
 804836f:	8d 61 fc             	lea    -0x4(%ecx),%esp
 8048372:	c3                   	ret    

08048373 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 8048373:	55                   	push   %ebp
 8048374:	89 e5                	mov    %esp,%ebp
 8048376:	53                   	push   %ebx
 8048377:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 804837a:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 8048381:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 8048388:	a1 70 9a 04 08       	mov    0x8049a70,%eax
 804838d:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 8048393:	05 39 30 00 00       	add    $0x3039,%eax
 8048398:	a3 70 9a 04 08       	mov    %eax,0x8049a70
    y ^= (y<<13);   
 804839d:	a1 74 9a 04 08       	mov    0x8049a74,%eax
 80483a2:	c1 e0 0d             	shl    $0xd,%eax
 80483a5:	89 c2                	mov    %eax,%edx
 80483a7:	a1 74 9a 04 08       	mov    0x8049a74,%eax
 80483ac:	31 d0                	xor    %edx,%eax
 80483ae:	a3 74 9a 04 08       	mov    %eax,0x8049a74
    y ^= (y>>17);   
 80483b3:	a1 74 9a 04 08       	mov    0x8049a74,%eax
 80483b8:	c1 e8 11             	shr    $0x11,%eax
 80483bb:	89 c2                	mov    %eax,%edx
 80483bd:	a1 74 9a 04 08       	mov    0x8049a74,%eax
 80483c2:	31 d0                	xor    %edx,%eax
 80483c4:	a3 74 9a 04 08       	mov    %eax,0x8049a74
    y ^= (y<<5);    
 80483c9:	a1 74 9a 04 08       	mov    0x8049a74,%eax
 80483ce:	c1 e0 05             	shl    $0x5,%eax
 80483d1:	89 c2                	mov    %eax,%edx
 80483d3:	a1 74 9a 04 08       	mov    0x8049a74,%eax
 80483d8:	31 d0                	xor    %edx,%eax
 80483da:	a3 74 9a 04 08       	mov    %eax,0x8049a74
      
    t = (A*z + c);  
 80483df:	a1 78 9a 04 08       	mov    0x8049a78,%eax
 80483e4:	ba 00 00 00 00       	mov    $0x0,%edx
 80483e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 80483ec:	89 cb                	mov    %ecx,%ebx
 80483ee:	0f af da             	imul   %edx,%ebx
 80483f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 80483f4:	0f af c8             	imul   %eax,%ecx
 80483f7:	01 d9                	add    %ebx,%ecx
 80483f9:	f7 65 f0             	mull   -0x10(%ebp)
 80483fc:	01 d1                	add    %edx,%ecx
 80483fe:	89 ca                	mov    %ecx,%edx
 8048400:	8b 0d 7c 9a 04 08    	mov    0x8049a7c,%ecx
 8048406:	bb 00 00 00 00       	mov    $0x0,%ebx
 804840b:	01 c8                	add    %ecx,%eax
 804840d:	11 da                	adc    %ebx,%edx
 804840f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048412:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 8048415:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048418:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804841b:	89 d0                	mov    %edx,%eax
 804841d:	31 d2                	xor    %edx,%edx
 804841f:	a3 7c 9a 04 08       	mov    %eax,0x8049a7c
    z = t;  
 8048424:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048427:	a3 78 9a 04 08       	mov    %eax,0x8049a78
       
    return x+y+z;    
 804842c:	8b 15 70 9a 04 08    	mov    0x8049a70,%edx
 8048432:	a1 74 9a 04 08       	mov    0x8049a74,%eax
 8048437:	01 c2                	add    %eax,%edx
 8048439:	a1 78 9a 04 08       	mov    0x8049a78,%eax
 804843e:	01 d0                	add    %edx,%eax
 8048440:	83 c4 14             	add    $0x14,%esp
 8048443:	5b                   	pop    %ebx
 8048444:	5d                   	pop    %ebp
 8048445:	c3                   	ret    

08048446 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 8048446:	55                   	push   %ebp
 8048447:	89 e5                	mov    %esp,%ebp
 8048449:	53                   	push   %ebx
 804844a:	83 ec 04             	sub    $0x4,%esp
 804844d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048450:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 8048453:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 8048458:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 804845c:	89 d3                	mov    %edx,%ebx
 804845e:	cd 80                	int    $0x80
}
 8048460:	83 c4 04             	add    $0x4,%esp
 8048463:	5b                   	pop    %ebx
 8048464:	5d                   	pop    %ebp
 8048465:	c3                   	ret    

08048466 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 8048466:	55                   	push   %ebp
 8048467:	89 e5                	mov    %esp,%ebp
 8048469:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 804846c:	8b 45 0c             	mov    0xc(%ebp),%eax
 804846f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 8048472:	eb 19                	jmp    804848d <printp+0x27>
		printer(cur);
 8048474:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048477:	0f b6 00             	movzbl (%eax),%eax
 804847a:	0f be c0             	movsbl %al,%eax
 804847d:	83 ec 0c             	sub    $0xc,%esp
 8048480:	50                   	push   %eax
 8048481:	8b 45 08             	mov    0x8(%ebp),%eax
 8048484:	ff d0                	call   *%eax
 8048486:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 8048489:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804848d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048490:	0f b6 00             	movzbl (%eax),%eax
 8048493:	84 c0                	test   %al,%al
 8048495:	75 dd                	jne    8048474 <printp+0xe>
		printer(cur);
	}
}
 8048497:	c9                   	leave  
 8048498:	c3                   	ret    

08048499 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 8048499:	55                   	push   %ebp
 804849a:	89 e5                	mov    %esp,%ebp
 804849c:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 804849f:	8b 45 0c             	mov    0xc(%ebp),%eax
 80484a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 80484a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 80484ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 80484b3:	8b 45 10             	mov    0x10(%ebp),%eax
 80484b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 80484b9:	e9 65 02 00 00       	jmp    8048723 <vfprintf+0x28a>

		if(cur == '%'){
 80484be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484c1:	0f b6 00             	movzbl (%eax),%eax
 80484c4:	3c 25                	cmp    $0x25,%al
 80484c6:	75 0c                	jne    80484d4 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 80484c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 80484cf:	e9 4b 02 00 00       	jmp    804871f <vfprintf+0x286>
		}
		if(type == READ){
 80484d4:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80484d8:	0f 85 26 02 00 00    	jne    8048704 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 80484de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484e1:	0f b6 00             	movzbl (%eax),%eax
 80484e4:	3c 73                	cmp    $0x73,%al
 80484e6:	75 35                	jne    804851d <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 80484e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80484eb:	8b 00                	mov    (%eax),%eax
 80484ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 80484f0:	eb 19                	jmp    804850b <vfprintf+0x72>
					printer(*p);
 80484f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80484f5:	0f b6 00             	movzbl (%eax),%eax
 80484f8:	0f be c0             	movsbl %al,%eax
 80484fb:	83 ec 0c             	sub    $0xc,%esp
 80484fe:	50                   	push   %eax
 80484ff:	8b 45 08             	mov    0x8(%ebp),%eax
 8048502:	ff d0                	call   *%eax
 8048504:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 8048507:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 804850b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804850e:	0f b6 00             	movzbl (%eax),%eax
 8048511:	84 c0                	test   %al,%al
 8048513:	75 dd                	jne    80484f2 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 8048515:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048519:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 804851d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048520:	0f b6 00             	movzbl (%eax),%eax
 8048523:	3c 78                	cmp    $0x78,%al
 8048525:	0f 85 99 00 00 00    	jne    80485c4 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 804852b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804852e:	8b 00                	mov    (%eax),%eax
 8048530:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8048533:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048537:	75 1d                	jne    8048556 <vfprintf+0xbd>
					printer('0');
 8048539:	83 ec 0c             	sub    $0xc,%esp
 804853c:	6a 30                	push   $0x30
 804853e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048541:	ff d0                	call   *%eax
 8048543:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048546:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804854a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8048551:	e9 c9 01 00 00       	jmp    804871f <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 8048556:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 804855d:	eb 2d                	jmp    804858c <vfprintf+0xf3>
					int d=(x%16);
 804855f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048562:	83 e0 0f             	and    $0xf,%eax
 8048565:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8048568:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 804856c:	7e 04                	jle    8048572 <vfprintf+0xd9>
						d+='a'-'0'-10;
 804856e:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 8048572:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8048575:	83 c0 30             	add    $0x30,%eax
 8048578:	89 c1                	mov    %eax,%ecx
 804857a:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804857d:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048580:	01 d0                	add    %edx,%eax
 8048582:	88 08                	mov    %cl,(%eax)
					x>>=4;
 8048584:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8048588:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 804858c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048590:	75 cd                	jne    804855f <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 8048592:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8048596:	eb 1e                	jmp    80485b6 <vfprintf+0x11d>
					printer(digits[di]);
 8048598:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804859b:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804859e:	01 d0                	add    %edx,%eax
 80485a0:	0f b6 00             	movzbl (%eax),%eax
 80485a3:	0f be c0             	movsbl %al,%eax
 80485a6:	83 ec 0c             	sub    $0xc,%esp
 80485a9:	50                   	push   %eax
 80485aa:	8b 45 08             	mov    0x8(%ebp),%eax
 80485ad:	ff d0                	call   *%eax
 80485af:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 80485b2:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 80485b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 80485ba:	79 dc                	jns    8048598 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80485bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80485c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 80485c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485c7:	0f b6 00             	movzbl (%eax),%eax
 80485ca:	3c 64                	cmp    $0x64,%al
 80485cc:	0f 85 02 01 00 00    	jne    80486d4 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 80485d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485d5:	8b 00                	mov    (%eax),%eax
 80485d7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 80485da:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 80485e1:	75 23                	jne    8048606 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 80485e3:	83 ec 08             	sub    $0x8,%esp
 80485e6:	68 06 88 04 08       	push   $0x8048806
 80485eb:	ff 75 08             	pushl  0x8(%ebp)
 80485ee:	e8 73 fe ff ff       	call   8048466 <printp>
 80485f3:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80485f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80485fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048601:	e9 19 01 00 00       	jmp    804871f <vfprintf+0x286>
				}
				if(x==0){
 8048606:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804860a:	75 1e                	jne    804862a <vfprintf+0x191>
					printer('0');
 804860c:	83 ec 0c             	sub    $0xc,%esp
 804860f:	6a 30                	push   $0x30
 8048611:	8b 45 08             	mov    0x8(%ebp),%eax
 8048614:	ff d0                	call   *%eax
 8048616:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048619:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804861d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048624:	90                   	nop
 8048625:	e9 f5 00 00 00       	jmp    804871f <vfprintf+0x286>
				}
				if(x<0){
 804862a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804862e:	79 10                	jns    8048640 <vfprintf+0x1a7>
					printer('-');
 8048630:	83 ec 0c             	sub    $0xc,%esp
 8048633:	6a 2d                	push   $0x2d
 8048635:	8b 45 08             	mov    0x8(%ebp),%eax
 8048638:	ff d0                	call   *%eax
 804863a:	83 c4 10             	add    $0x10,%esp
					x=-x;
 804863d:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 8048640:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8048647:	eb 53                	jmp    804869c <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 8048649:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804864c:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048651:	89 c8                	mov    %ecx,%eax
 8048653:	f7 ea                	imul   %edx
 8048655:	c1 fa 02             	sar    $0x2,%edx
 8048658:	89 c8                	mov    %ecx,%eax
 804865a:	c1 f8 1f             	sar    $0x1f,%eax
 804865d:	29 c2                	sub    %eax,%edx
 804865f:	89 d0                	mov    %edx,%eax
 8048661:	c1 e0 02             	shl    $0x2,%eax
 8048664:	01 d0                	add    %edx,%eax
 8048666:	01 c0                	add    %eax,%eax
 8048668:	29 c1                	sub    %eax,%ecx
 804866a:	89 ca                	mov    %ecx,%edx
 804866c:	89 d0                	mov    %edx,%eax
 804866e:	83 c0 30             	add    $0x30,%eax
 8048671:	89 c1                	mov    %eax,%ecx
 8048673:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048676:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048679:	01 d0                	add    %edx,%eax
 804867b:	88 08                	mov    %cl,(%eax)
					x/=10;
 804867d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8048680:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048685:	89 c8                	mov    %ecx,%eax
 8048687:	f7 ea                	imul   %edx
 8048689:	c1 fa 02             	sar    $0x2,%edx
 804868c:	89 c8                	mov    %ecx,%eax
 804868e:	c1 f8 1f             	sar    $0x1f,%eax
 8048691:	29 c2                	sub    %eax,%edx
 8048693:	89 d0                	mov    %edx,%eax
 8048695:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 8048698:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 804869c:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80486a0:	7f a7                	jg     8048649 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 80486a2:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 80486a6:	eb 1e                	jmp    80486c6 <vfprintf+0x22d>
					printer(digits[di]);
 80486a8:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80486ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80486ae:	01 d0                	add    %edx,%eax
 80486b0:	0f b6 00             	movzbl (%eax),%eax
 80486b3:	0f be c0             	movsbl %al,%eax
 80486b6:	83 ec 0c             	sub    $0xc,%esp
 80486b9:	50                   	push   %eax
 80486ba:	8b 45 08             	mov    0x8(%ebp),%eax
 80486bd:	ff d0                	call   *%eax
 80486bf:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 80486c2:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 80486c6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 80486ca:	79 dc                	jns    80486a8 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80486cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80486d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 80486d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80486d7:	0f b6 00             	movzbl (%eax),%eax
 80486da:	3c 63                	cmp    $0x63,%al
 80486dc:	75 1d                	jne    80486fb <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 80486de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80486e1:	0f b6 00             	movzbl (%eax),%eax
 80486e4:	0f be c0             	movsbl %al,%eax
 80486e7:	83 ec 0c             	sub    $0xc,%esp
 80486ea:	50                   	push   %eax
 80486eb:	8b 45 08             	mov    0x8(%ebp),%eax
 80486ee:	ff d0                	call   *%eax
 80486f0:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 80486f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80486f7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 80486fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 8048702:	eb 1b                	jmp    804871f <vfprintf+0x286>
		}
		if(type == NONE){
 8048704:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048708:	75 15                	jne    804871f <vfprintf+0x286>
			printer(cur);
 804870a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804870d:	0f b6 00             	movzbl (%eax),%eax
 8048710:	0f be c0             	movsbl %al,%eax
 8048713:	83 ec 0c             	sub    $0xc,%esp
 8048716:	50                   	push   %eax
 8048717:	8b 45 08             	mov    0x8(%ebp),%eax
 804871a:	ff d0                	call   *%eax
 804871c:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 804871f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048723:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048726:	0f b6 00             	movzbl (%eax),%eax
 8048729:	84 c0                	test   %al,%al
 804872b:	0f 85 8d fd ff ff    	jne    80484be <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8048731:	c9                   	leave  
 8048732:	c3                   	ret    

08048733 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8048733:	55                   	push   %ebp
 8048734:	89 e5                	mov    %esp,%ebp
 8048736:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048739:	8d 45 0c             	lea    0xc(%ebp),%eax
 804873c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 804873f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048742:	83 ec 04             	sub    $0x4,%esp
 8048745:	ff 75 f4             	pushl  -0xc(%ebp)
 8048748:	50                   	push   %eax
 8048749:	68 46 84 04 08       	push   $0x8048446
 804874e:	e8 46 fd ff ff       	call   8048499 <vfprintf>
 8048753:	83 c4 10             	add    $0x10,%esp
}
 8048756:	c9                   	leave  
 8048757:	c3                   	ret    
