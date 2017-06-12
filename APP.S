
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <sys_fs_open>:
// static inline int fs_open(const char *pathname, int flags);
// static inline int fs_read(int fd, void *buf, int len);
// static inline int fs_write(int fd, void *buf, int len);
// static inline int fs_lseek(int fd, int offset, int whence);
// static inline int fs_close(int fd);
static inline int sys_fs_open(char *pathname, int flags){
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	53                   	push   %ebx
 8048098:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_OPEN), "b"(pathname), "c"(flags)); //SYSCALL HERE!
 804809b:	b8 a4 06 00 00       	mov    $0x6a4,%eax
 80480a0:	8b 55 08             	mov    0x8(%ebp),%edx
 80480a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80480a6:	89 d3                	mov    %edx,%ebx
 80480a8:	cd 80                	int    $0x80
 80480aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 80480ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 80480b0:	83 c4 10             	add    $0x10,%esp
 80480b3:	5b                   	pop    %ebx
 80480b4:	5d                   	pop    %ebp
 80480b5:	c3                   	ret    

080480b6 <sys_fs_read>:
static inline int sys_fs_read(int fd, void *buf, int len){
 80480b6:	55                   	push   %ebp
 80480b7:	89 e5                	mov    %esp,%ebp
 80480b9:	53                   	push   %ebx
 80480ba:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_READ), "b"(fd), "c"(buf), "d"(len)); //SYSCALL HERE!
 80480bd:	b8 a5 06 00 00       	mov    $0x6a5,%eax
 80480c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80480c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80480c8:	8b 55 10             	mov    0x10(%ebp),%edx
 80480cb:	cd 80                	int    $0x80
 80480cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 80480d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 80480d3:	83 c4 10             	add    $0x10,%esp
 80480d6:	5b                   	pop    %ebx
 80480d7:	5d                   	pop    %ebp
 80480d8:	c3                   	ret    

080480d9 <sys_fs_write>:
static inline int sys_fs_write(int fd, void *buf, int len){
 80480d9:	55                   	push   %ebp
 80480da:	89 e5                	mov    %esp,%ebp
 80480dc:	53                   	push   %ebx
 80480dd:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_WRITE), "b"(fd), "c"(buf), "d"(len)); //SYSCALL HERE!
 80480e0:	b8 a6 06 00 00       	mov    $0x6a6,%eax
 80480e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80480e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80480eb:	8b 55 10             	mov    0x10(%ebp),%edx
 80480ee:	cd 80                	int    $0x80
 80480f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 80480f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 80480f6:	83 c4 10             	add    $0x10,%esp
 80480f9:	5b                   	pop    %ebx
 80480fa:	5d                   	pop    %ebp
 80480fb:	c3                   	ret    

080480fc <sys_fs_lseek>:
static inline int sys_fs_lseek(int fd, int offset, int whence){
 80480fc:	55                   	push   %ebp
 80480fd:	89 e5                	mov    %esp,%ebp
 80480ff:	53                   	push   %ebx
 8048100:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_LSEEK), "b"(fd), "c"(offset), "d"(whence)); //SYSCALL HERE!
 8048103:	b8 a7 06 00 00       	mov    $0x6a7,%eax
 8048108:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804810b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 804810e:	8b 55 10             	mov    0x10(%ebp),%edx
 8048111:	cd 80                	int    $0x80
 8048113:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 8048116:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 8048119:	83 c4 10             	add    $0x10,%esp
 804811c:	5b                   	pop    %ebx
 804811d:	5d                   	pop    %ebp
 804811e:	c3                   	ret    

0804811f <sys_sem_post>:
	semaphore *sem;
	asm volatile("int $0x80": "=a"(sem) : "a"(SYS_SEM_OPEN), "b"(index), "c"(count)); //SYSCALL HERE!
	return sem;
}

static inline void sys_sem_post(semaphore *sem){
 804811f:	55                   	push   %ebp
 8048120:	89 e5                	mov    %esp,%ebp
 8048122:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_POST), "b"(sem)); //SYSCALL HERE!
 8048123:	b8 42 06 00 00       	mov    $0x642,%eax
 8048128:	8b 55 08             	mov    0x8(%ebp),%edx
 804812b:	89 d3                	mov    %edx,%ebx
 804812d:	cd 80                	int    $0x80
}
 804812f:	5b                   	pop    %ebx
 8048130:	5d                   	pop    %ebp
 8048131:	c3                   	ret    

08048132 <sys_sem_wait>:

static inline void sys_sem_wait(semaphore *sem){
 8048132:	55                   	push   %ebp
 8048133:	89 e5                	mov    %esp,%ebp
 8048135:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SEM_WAIT), "b"(sem)); //SYSCALL HERE!
 8048136:	b8 43 06 00 00       	mov    $0x643,%eax
 804813b:	8b 55 08             	mov    0x8(%ebp),%edx
 804813e:	89 d3                	mov    %edx,%ebx
 8048140:	cd 80                	int    $0x80
}
 8048142:	5b                   	pop    %ebx
 8048143:	5d                   	pop    %ebp
 8048144:	c3                   	ret    

08048145 <sys_sem_trywait>:

static inline int sys_sem_trywait(semaphore *sem){
 8048145:	55                   	push   %ebp
 8048146:	89 e5                	mov    %esp,%ebp
 8048148:	53                   	push   %ebx
 8048149:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_SEM_TRYWAIT), "b"(sem)); //SYSCALL HERE!
 804814c:	b8 46 06 00 00       	mov    $0x646,%eax
 8048151:	8b 55 08             	mov    0x8(%ebp),%edx
 8048154:	89 d3                	mov    %edx,%ebx
 8048156:	cd 80                	int    $0x80
 8048158:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 804815b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 804815e:	83 c4 10             	add    $0x10,%esp
 8048161:	5b                   	pop    %ebx
 8048162:	5d                   	pop    %ebp
 8048163:	c3                   	ret    

08048164 <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
 8048164:	55                   	push   %ebp
 8048165:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
 8048167:	b8 dc 05 00 00       	mov    $0x5dc,%eax
 804816c:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 804816e:	b8 df 05 00 00       	mov    $0x5df,%eax
 8048173:	cd 80                	int    $0x80
}
 8048175:	5d                   	pop    %ebp
 8048176:	c3                   	ret    

08048177 <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 8048177:	55                   	push   %ebp
 8048178:	89 e5                	mov    %esp,%ebp
 804817a:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 804817b:	b8 de 05 00 00       	mov    $0x5de,%eax
 8048180:	8b 55 08             	mov    0x8(%ebp),%edx
 8048183:	89 d3                	mov    %edx,%ebx
 8048185:	cd 80                	int    $0x80
}
 8048187:	5b                   	pop    %ebx
 8048188:	5d                   	pop    %ebp
 8048189:	c3                   	ret    

0804818a <strcpy>:
    while(*s1 && (*s1==*s2))
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
 804818a:	55                   	push   %ebp
 804818b:	89 e5                	mov    %esp,%ebp
 804818d:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
 8048190:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
 8048197:	eb 04                	jmp    804819d <strcpy+0x13>
    {
        i++;
 8048199:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
 804819d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 80481a0:	8b 45 08             	mov    0x8(%ebp),%eax
 80481a3:	01 d0                	add    %edx,%eax
 80481a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 80481a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 80481ab:	01 ca                	add    %ecx,%edx
 80481ad:	0f b6 12             	movzbl (%edx),%edx
 80481b0:	88 10                	mov    %dl,(%eax)
 80481b2:	0f b6 00             	movzbl (%eax),%eax
 80481b5:	84 c0                	test   %al,%al
 80481b7:	75 e0                	jne    8048199 <strcpy+0xf>
    {
        i++;
    } 
}
 80481b9:	c9                   	leave  
 80481ba:	c3                   	ret    

080481bb <insert_item>:
sem_t empty;
sem_t full;
int index;
int buffer[N];

void insert_item(int item){
 80481bb:	55                   	push   %ebp
 80481bc:	89 e5                	mov    %esp,%ebp
	buffer[index] = item;
 80481be:	a1 40 9c 04 08       	mov    0x8049c40,%eax
 80481c3:	8b 55 08             	mov    0x8(%ebp),%edx
 80481c6:	89 14 85 38 9c 04 08 	mov    %edx,0x8049c38(,%eax,4)
	index ++;
 80481cd:	a1 40 9c 04 08       	mov    0x8049c40,%eax
 80481d2:	83 c0 01             	add    $0x1,%eax
 80481d5:	a3 40 9c 04 08       	mov    %eax,0x8049c40
}
 80481da:	5d                   	pop    %ebp
 80481db:	c3                   	ret    

080481dc <remove_item>:
int remove_item(){
 80481dc:	55                   	push   %ebp
 80481dd:	89 e5                	mov    %esp,%ebp
	index --;
 80481df:	a1 40 9c 04 08       	mov    0x8049c40,%eax
 80481e4:	83 e8 01             	sub    $0x1,%eax
 80481e7:	a3 40 9c 04 08       	mov    %eax,0x8049c40
	return buffer[index];
 80481ec:	a1 40 9c 04 08       	mov    0x8049c40,%eax
 80481f1:	8b 04 85 38 9c 04 08 	mov    0x8049c38(,%eax,4),%eax
}
 80481f8:	5d                   	pop    %ebp
 80481f9:	c3                   	ret    

080481fa <producer>:

void producer(){
 80481fa:	55                   	push   %ebp
 80481fb:	89 e5                	mov    %esp,%ebp
 80481fd:	83 ec 18             	sub    $0x18,%esp
	int item;
	while(1){
		sleep(1+rand()%5);
 8048200:	e8 4b 02 00 00       	call   8048450 <UKISS>
 8048205:	89 c1                	mov    %eax,%ecx
 8048207:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 804820c:	89 c8                	mov    %ecx,%eax
 804820e:	f7 e2                	mul    %edx
 8048210:	c1 ea 02             	shr    $0x2,%edx
 8048213:	89 d0                	mov    %edx,%eax
 8048215:	c1 e0 02             	shl    $0x2,%eax
 8048218:	01 d0                	add    %edx,%eax
 804821a:	29 c1                	sub    %eax,%ecx
 804821c:	89 ca                	mov    %ecx,%edx
 804821e:	8d 42 01             	lea    0x1(%edx),%eax
 8048221:	83 ec 0c             	sub    $0xc,%esp
 8048224:	50                   	push   %eax
 8048225:	e8 4d ff ff ff       	call   8048177 <sys_sleep>
 804822a:	83 c4 10             	add    $0x10,%esp
		item = rand()%10;
 804822d:	e8 1e 02 00 00       	call   8048450 <UKISS>
 8048232:	89 c1                	mov    %eax,%ecx
 8048234:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8048239:	89 c8                	mov    %ecx,%eax
 804823b:	f7 e2                	mul    %edx
 804823d:	c1 ea 03             	shr    $0x3,%edx
 8048240:	89 d0                	mov    %edx,%eax
 8048242:	c1 e0 02             	shl    $0x2,%eax
 8048245:	01 d0                	add    %edx,%eax
 8048247:	01 c0                	add    %eax,%eax
 8048249:	29 c1                	sub    %eax,%ecx
 804824b:	89 ca                	mov    %ecx,%edx
 804824d:	89 55 f4             	mov    %edx,-0xc(%ebp)
		printf("PRODUCER: %d produced!\n", item);
 8048250:	83 ec 08             	sub    $0x8,%esp
 8048253:	ff 75 f4             	pushl  -0xc(%ebp)
 8048256:	68 38 88 04 08       	push   $0x8048838
 804825b:	e8 b0 05 00 00       	call   8048810 <printf>
 8048260:	83 c4 10             	add    $0x10,%esp
		sem_wait(&empty);
 8048263:	83 ec 0c             	sub    $0xc,%esp
 8048266:	68 44 9c 04 08       	push   $0x8049c44
 804826b:	e8 c2 fe ff ff       	call   8048132 <sys_sem_wait>
 8048270:	83 c4 10             	add    $0x10,%esp
		sem_wait(&mutex);
 8048273:	83 ec 0c             	sub    $0xc,%esp
 8048276:	68 2c 9c 04 08       	push   $0x8049c2c
 804827b:	e8 b2 fe ff ff       	call   8048132 <sys_sem_wait>
 8048280:	83 c4 10             	add    $0x10,%esp

		insert_item(item);
 8048283:	83 ec 0c             	sub    $0xc,%esp
 8048286:	ff 75 f4             	pushl  -0xc(%ebp)
 8048289:	e8 2d ff ff ff       	call   80481bb <insert_item>
 804828e:	83 c4 10             	add    $0x10,%esp

		printf("PRODUCER: %d sent, now %d space left!\n", item, N-index);
 8048291:	a1 40 9c 04 08       	mov    0x8049c40,%eax
 8048296:	ba 02 00 00 00       	mov    $0x2,%edx
 804829b:	29 c2                	sub    %eax,%edx
 804829d:	89 d0                	mov    %edx,%eax
 804829f:	83 ec 04             	sub    $0x4,%esp
 80482a2:	50                   	push   %eax
 80482a3:	ff 75 f4             	pushl  -0xc(%ebp)
 80482a6:	68 50 88 04 08       	push   $0x8048850
 80482ab:	e8 60 05 00 00       	call   8048810 <printf>
 80482b0:	83 c4 10             	add    $0x10,%esp

		sem_post(&mutex);
 80482b3:	83 ec 0c             	sub    $0xc,%esp
 80482b6:	68 2c 9c 04 08       	push   $0x8049c2c
 80482bb:	e8 5f fe ff ff       	call   804811f <sys_sem_post>
 80482c0:	83 c4 10             	add    $0x10,%esp
		sem_post(&full);
 80482c3:	83 ec 0c             	sub    $0xc,%esp
 80482c6:	68 20 9c 04 08       	push   $0x8049c20
 80482cb:	e8 4f fe ff ff       	call   804811f <sys_sem_post>
 80482d0:	83 c4 10             	add    $0x10,%esp
	}
 80482d3:	e9 28 ff ff ff       	jmp    8048200 <producer+0x6>

080482d8 <consumer>:
}

void consumer(){
 80482d8:	55                   	push   %ebp
 80482d9:	89 e5                	mov    %esp,%ebp
 80482db:	83 ec 18             	sub    $0x18,%esp
	int item;
	int asleep;
	while(1){
		printf("CONSUMER: ready to receive!\n");
 80482de:	83 ec 0c             	sub    $0xc,%esp
 80482e1:	68 77 88 04 08       	push   $0x8048877
 80482e6:	e8 25 05 00 00       	call   8048810 <printf>
 80482eb:	83 c4 10             	add    $0x10,%esp
		while(!sem_trywait(&full));
 80482ee:	90                   	nop
 80482ef:	83 ec 0c             	sub    $0xc,%esp
 80482f2:	68 20 9c 04 08       	push   $0x8049c20
 80482f7:	e8 49 fe ff ff       	call   8048145 <sys_sem_trywait>
 80482fc:	83 c4 10             	add    $0x10,%esp
 80482ff:	85 c0                	test   %eax,%eax
 8048301:	74 ec                	je     80482ef <consumer+0x17>
		while(!sem_trywait(&mutex));
 8048303:	90                   	nop
 8048304:	83 ec 0c             	sub    $0xc,%esp
 8048307:	68 2c 9c 04 08       	push   $0x8049c2c
 804830c:	e8 34 fe ff ff       	call   8048145 <sys_sem_trywait>
 8048311:	83 c4 10             	add    $0x10,%esp
 8048314:	85 c0                	test   %eax,%eax
 8048316:	74 ec                	je     8048304 <consumer+0x2c>

		item = remove_item();
 8048318:	e8 bf fe ff ff       	call   80481dc <remove_item>
 804831d:	89 45 f4             	mov    %eax,-0xc(%ebp)

		sem_post(&mutex);
 8048320:	83 ec 0c             	sub    $0xc,%esp
 8048323:	68 2c 9c 04 08       	push   $0x8049c2c
 8048328:	e8 f2 fd ff ff       	call   804811f <sys_sem_post>
 804832d:	83 c4 10             	add    $0x10,%esp
		sem_post(&empty);
 8048330:	83 ec 0c             	sub    $0xc,%esp
 8048333:	68 44 9c 04 08       	push   $0x8049c44
 8048338:	e8 e2 fd ff ff       	call   804811f <sys_sem_post>
 804833d:	83 c4 10             	add    $0x10,%esp

		asleep = 1+rand()%15;
 8048340:	e8 0b 01 00 00       	call   8048450 <UKISS>
 8048345:	89 c1                	mov    %eax,%ecx
 8048347:	ba 89 88 88 88       	mov    $0x88888889,%edx
 804834c:	89 c8                	mov    %ecx,%eax
 804834e:	f7 e2                	mul    %edx
 8048350:	89 d0                	mov    %edx,%eax
 8048352:	c1 e8 03             	shr    $0x3,%eax
 8048355:	89 c2                	mov    %eax,%edx
 8048357:	c1 e2 04             	shl    $0x4,%edx
 804835a:	29 c2                	sub    %eax,%edx
 804835c:	89 c8                	mov    %ecx,%eax
 804835e:	29 d0                	sub    %edx,%eax
 8048360:	83 c0 01             	add    $0x1,%eax
 8048363:	89 45 f0             	mov    %eax,-0x10(%ebp)
		printf("CONSUMER: %d received, now I want to consumer it in %ds!\n", item, asleep);
 8048366:	83 ec 04             	sub    $0x4,%esp
 8048369:	ff 75 f0             	pushl  -0x10(%ebp)
 804836c:	ff 75 f4             	pushl  -0xc(%ebp)
 804836f:	68 94 88 04 08       	push   $0x8048894
 8048374:	e8 97 04 00 00       	call   8048810 <printf>
 8048379:	83 c4 10             	add    $0x10,%esp
		sleep(asleep); //consume
 804837c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804837f:	83 ec 0c             	sub    $0xc,%esp
 8048382:	50                   	push   %eax
 8048383:	e8 ef fd ff ff       	call   8048177 <sys_sleep>
 8048388:	83 c4 10             	add    $0x10,%esp

	}
 804838b:	e9 4e ff ff ff       	jmp    80482de <consumer+0x6>

08048390 <main>:
}
int main(){
 8048390:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048394:	83 e4 f0             	and    $0xfffffff0,%esp
 8048397:	ff 71 fc             	pushl  -0x4(%ecx)
 804839a:	55                   	push   %ebp
 804839b:	89 e5                	mov    %esp,%ebp
 804839d:	51                   	push   %ecx
 804839e:	81 ec 64 02 00 00    	sub    $0x264,%esp
	thread_join(prod);
	thread_join(cons);

	printf("You should not see this, since the producer and consumer are sisyphean\n");
	*/
	int fd = fs_open("singer.txt", FS_RWC);
 80483a4:	6a 01                	push   $0x1
 80483a6:	68 ce 88 04 08       	push   $0x80488ce
 80483ab:	e8 e4 fc ff ff       	call   8048094 <sys_fs_open>
 80483b0:	83 c4 08             	add    $0x8,%esp
 80483b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char buf[300];
	fs_read(fd, buf, 300);
 80483b6:	68 2c 01 00 00       	push   $0x12c
 80483bb:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
 80483c1:	50                   	push   %eax
 80483c2:	ff 75 f4             	pushl  -0xc(%ebp)
 80483c5:	e8 ec fc ff ff       	call   80480b6 <sys_fs_read>
 80483ca:	83 c4 0c             	add    $0xc,%esp
	printf("APP#READ singer.txt: %s\n", buf);
 80483cd:	83 ec 08             	sub    $0x8,%esp
 80483d0:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
 80483d6:	50                   	push   %eax
 80483d7:	68 d9 88 04 08       	push   $0x80488d9
 80483dc:	e8 2f 04 00 00       	call   8048810 <printf>
 80483e1:	83 c4 10             	add    $0x10,%esp

	char buf2[300];
	fs_lseek(fd, 0, SEEK_SET);
 80483e4:	83 ec 04             	sub    $0x4,%esp
 80483e7:	6a 00                	push   $0x0
 80483e9:	6a 00                	push   $0x0
 80483eb:	ff 75 f4             	pushl  -0xc(%ebp)
 80483ee:	e8 09 fd ff ff       	call   80480fc <sys_fs_lseek>
 80483f3:	83 c4 10             	add    $0x10,%esp
	strcpy(buf2, "你本来是英雄，直到变的，更加恐惧");
 80483f6:	83 ec 08             	sub    $0x8,%esp
 80483f9:	68 f4 88 04 08       	push   $0x80488f4
 80483fe:	8d 85 9c fd ff ff    	lea    -0x264(%ebp),%eax
 8048404:	50                   	push   %eax
 8048405:	e8 80 fd ff ff       	call   804818a <strcpy>
 804840a:	83 c4 10             	add    $0x10,%esp
	fs_write(fd, buf2, 300);
 804840d:	83 ec 04             	sub    $0x4,%esp
 8048410:	68 2c 01 00 00       	push   $0x12c
 8048415:	8d 85 9c fd ff ff    	lea    -0x264(%ebp),%eax
 804841b:	50                   	push   %eax
 804841c:	ff 75 f4             	pushl  -0xc(%ebp)
 804841f:	e8 b5 fc ff ff       	call   80480d9 <sys_fs_write>
 8048424:	83 c4 10             	add    $0x10,%esp
	printf("APP#WRITE singer.txt: %s\n", buf2);
 8048427:	83 ec 08             	sub    $0x8,%esp
 804842a:	8d 85 9c fd ff ff    	lea    -0x264(%ebp),%eax
 8048430:	50                   	push   %eax
 8048431:	68 25 89 04 08       	push   $0x8048925
 8048436:	e8 d5 03 00 00       	call   8048810 <printf>
 804843b:	83 c4 10             	add    $0x10,%esp

	exit();
 804843e:	e8 21 fd ff ff       	call   8048164 <sys_exit>
 8048443:	b8 00 00 00 00       	mov    $0x0,%eax
 8048448:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 804844b:	c9                   	leave  
 804844c:	8d 61 fc             	lea    -0x4(%ecx),%esp
 804844f:	c3                   	ret    

08048450 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 8048450:	55                   	push   %ebp
 8048451:	89 e5                	mov    %esp,%ebp
 8048453:	53                   	push   %ebx
 8048454:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 8048457:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 804845e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 8048465:	a1 10 9c 04 08       	mov    0x8049c10,%eax
 804846a:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 8048470:	05 39 30 00 00       	add    $0x3039,%eax
 8048475:	a3 10 9c 04 08       	mov    %eax,0x8049c10
    y ^= (y<<13);   
 804847a:	a1 14 9c 04 08       	mov    0x8049c14,%eax
 804847f:	c1 e0 0d             	shl    $0xd,%eax
 8048482:	89 c2                	mov    %eax,%edx
 8048484:	a1 14 9c 04 08       	mov    0x8049c14,%eax
 8048489:	31 d0                	xor    %edx,%eax
 804848b:	a3 14 9c 04 08       	mov    %eax,0x8049c14
    y ^= (y>>17);   
 8048490:	a1 14 9c 04 08       	mov    0x8049c14,%eax
 8048495:	c1 e8 11             	shr    $0x11,%eax
 8048498:	89 c2                	mov    %eax,%edx
 804849a:	a1 14 9c 04 08       	mov    0x8049c14,%eax
 804849f:	31 d0                	xor    %edx,%eax
 80484a1:	a3 14 9c 04 08       	mov    %eax,0x8049c14
    y ^= (y<<5);    
 80484a6:	a1 14 9c 04 08       	mov    0x8049c14,%eax
 80484ab:	c1 e0 05             	shl    $0x5,%eax
 80484ae:	89 c2                	mov    %eax,%edx
 80484b0:	a1 14 9c 04 08       	mov    0x8049c14,%eax
 80484b5:	31 d0                	xor    %edx,%eax
 80484b7:	a3 14 9c 04 08       	mov    %eax,0x8049c14
      
    t = (A*z + c);  
 80484bc:	a1 18 9c 04 08       	mov    0x8049c18,%eax
 80484c1:	ba 00 00 00 00       	mov    $0x0,%edx
 80484c6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 80484c9:	89 cb                	mov    %ecx,%ebx
 80484cb:	0f af da             	imul   %edx,%ebx
 80484ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 80484d1:	0f af c8             	imul   %eax,%ecx
 80484d4:	01 d9                	add    %ebx,%ecx
 80484d6:	f7 65 f0             	mull   -0x10(%ebp)
 80484d9:	01 d1                	add    %edx,%ecx
 80484db:	89 ca                	mov    %ecx,%edx
 80484dd:	8b 0d 1c 9c 04 08    	mov    0x8049c1c,%ecx
 80484e3:	bb 00 00 00 00       	mov    $0x0,%ebx
 80484e8:	01 c8                	add    %ecx,%eax
 80484ea:	11 da                	adc    %ebx,%edx
 80484ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
 80484ef:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 80484f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80484f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80484f8:	89 d0                	mov    %edx,%eax
 80484fa:	31 d2                	xor    %edx,%edx
 80484fc:	a3 1c 9c 04 08       	mov    %eax,0x8049c1c
    z = t;  
 8048501:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048504:	a3 18 9c 04 08       	mov    %eax,0x8049c18
       
    return x+y+z;    
 8048509:	8b 15 10 9c 04 08    	mov    0x8049c10,%edx
 804850f:	a1 14 9c 04 08       	mov    0x8049c14,%eax
 8048514:	01 c2                	add    %eax,%edx
 8048516:	a1 18 9c 04 08       	mov    0x8049c18,%eax
 804851b:	01 d0                	add    %edx,%eax
 804851d:	83 c4 14             	add    $0x14,%esp
 8048520:	5b                   	pop    %ebx
 8048521:	5d                   	pop    %ebp
 8048522:	c3                   	ret    

08048523 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 8048523:	55                   	push   %ebp
 8048524:	89 e5                	mov    %esp,%ebp
 8048526:	53                   	push   %ebx
 8048527:	83 ec 04             	sub    $0x4,%esp
 804852a:	8b 45 08             	mov    0x8(%ebp),%eax
 804852d:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 8048530:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 8048535:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 8048539:	89 d3                	mov    %edx,%ebx
 804853b:	cd 80                	int    $0x80
}
 804853d:	83 c4 04             	add    $0x4,%esp
 8048540:	5b                   	pop    %ebx
 8048541:	5d                   	pop    %ebp
 8048542:	c3                   	ret    

08048543 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 8048543:	55                   	push   %ebp
 8048544:	89 e5                	mov    %esp,%ebp
 8048546:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 8048549:	8b 45 0c             	mov    0xc(%ebp),%eax
 804854c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 804854f:	eb 19                	jmp    804856a <printp+0x27>
		printer(cur);
 8048551:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048554:	0f b6 00             	movzbl (%eax),%eax
 8048557:	0f be c0             	movsbl %al,%eax
 804855a:	83 ec 0c             	sub    $0xc,%esp
 804855d:	50                   	push   %eax
 804855e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048561:	ff d0                	call   *%eax
 8048563:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 8048566:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804856a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804856d:	0f b6 00             	movzbl (%eax),%eax
 8048570:	84 c0                	test   %al,%al
 8048572:	75 dd                	jne    8048551 <printp+0xe>
		printer(cur);
	}
}
 8048574:	c9                   	leave  
 8048575:	c3                   	ret    

08048576 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 8048576:	55                   	push   %ebp
 8048577:	89 e5                	mov    %esp,%ebp
 8048579:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 804857c:	8b 45 0c             	mov    0xc(%ebp),%eax
 804857f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 8048582:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8048589:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 8048590:	8b 45 10             	mov    0x10(%ebp),%eax
 8048593:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048596:	e9 65 02 00 00       	jmp    8048800 <vfprintf+0x28a>

		if(cur == '%'){
 804859b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804859e:	0f b6 00             	movzbl (%eax),%eax
 80485a1:	3c 25                	cmp    $0x25,%al
 80485a3:	75 0c                	jne    80485b1 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 80485a5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 80485ac:	e9 4b 02 00 00       	jmp    80487fc <vfprintf+0x286>
		}
		if(type == READ){
 80485b1:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80485b5:	0f 85 26 02 00 00    	jne    80487e1 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 80485bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485be:	0f b6 00             	movzbl (%eax),%eax
 80485c1:	3c 73                	cmp    $0x73,%al
 80485c3:	75 35                	jne    80485fa <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 80485c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485c8:	8b 00                	mov    (%eax),%eax
 80485ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 80485cd:	eb 19                	jmp    80485e8 <vfprintf+0x72>
					printer(*p);
 80485cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80485d2:	0f b6 00             	movzbl (%eax),%eax
 80485d5:	0f be c0             	movsbl %al,%eax
 80485d8:	83 ec 0c             	sub    $0xc,%esp
 80485db:	50                   	push   %eax
 80485dc:	8b 45 08             	mov    0x8(%ebp),%eax
 80485df:	ff d0                	call   *%eax
 80485e1:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 80485e4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 80485e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80485eb:	0f b6 00             	movzbl (%eax),%eax
 80485ee:	84 c0                	test   %al,%al
 80485f0:	75 dd                	jne    80485cf <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 80485f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80485f6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 80485fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485fd:	0f b6 00             	movzbl (%eax),%eax
 8048600:	3c 78                	cmp    $0x78,%al
 8048602:	0f 85 99 00 00 00    	jne    80486a1 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048608:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804860b:	8b 00                	mov    (%eax),%eax
 804860d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8048610:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048614:	75 1d                	jne    8048633 <vfprintf+0xbd>
					printer('0');
 8048616:	83 ec 0c             	sub    $0xc,%esp
 8048619:	6a 30                	push   $0x30
 804861b:	8b 45 08             	mov    0x8(%ebp),%eax
 804861e:	ff d0                	call   *%eax
 8048620:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048623:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048627:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 804862e:	e9 c9 01 00 00       	jmp    80487fc <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 8048633:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 804863a:	eb 2d                	jmp    8048669 <vfprintf+0xf3>
					int d=(x%16);
 804863c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 804863f:	83 e0 0f             	and    $0xf,%eax
 8048642:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8048645:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 8048649:	7e 04                	jle    804864f <vfprintf+0xd9>
						d+='a'-'0'-10;
 804864b:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 804864f:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8048652:	83 c0 30             	add    $0x30,%eax
 8048655:	89 c1                	mov    %eax,%ecx
 8048657:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804865a:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804865d:	01 d0                	add    %edx,%eax
 804865f:	88 08                	mov    %cl,(%eax)
					x>>=4;
 8048661:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8048665:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048669:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804866d:	75 cd                	jne    804863c <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 804866f:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8048673:	eb 1e                	jmp    8048693 <vfprintf+0x11d>
					printer(digits[di]);
 8048675:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048678:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804867b:	01 d0                	add    %edx,%eax
 804867d:	0f b6 00             	movzbl (%eax),%eax
 8048680:	0f be c0             	movsbl %al,%eax
 8048683:	83 ec 0c             	sub    $0xc,%esp
 8048686:	50                   	push   %eax
 8048687:	8b 45 08             	mov    0x8(%ebp),%eax
 804868a:	ff d0                	call   *%eax
 804868c:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 804868f:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8048693:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8048697:	79 dc                	jns    8048675 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804869d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 80486a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80486a4:	0f b6 00             	movzbl (%eax),%eax
 80486a7:	3c 64                	cmp    $0x64,%al
 80486a9:	0f 85 02 01 00 00    	jne    80487b1 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 80486af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80486b2:	8b 00                	mov    (%eax),%eax
 80486b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 80486b7:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 80486be:	75 23                	jne    80486e3 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 80486c0:	83 ec 08             	sub    $0x8,%esp
 80486c3:	68 3f 89 04 08       	push   $0x804893f
 80486c8:	ff 75 08             	pushl  0x8(%ebp)
 80486cb:	e8 73 fe ff ff       	call   8048543 <printp>
 80486d0:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80486d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80486d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80486de:	e9 19 01 00 00       	jmp    80487fc <vfprintf+0x286>
				}
				if(x==0){
 80486e3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80486e7:	75 1e                	jne    8048707 <vfprintf+0x191>
					printer('0');
 80486e9:	83 ec 0c             	sub    $0xc,%esp
 80486ec:	6a 30                	push   $0x30
 80486ee:	8b 45 08             	mov    0x8(%ebp),%eax
 80486f1:	ff d0                	call   *%eax
 80486f3:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80486f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80486fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048701:	90                   	nop
 8048702:	e9 f5 00 00 00       	jmp    80487fc <vfprintf+0x286>
				}
				if(x<0){
 8048707:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804870b:	79 10                	jns    804871d <vfprintf+0x1a7>
					printer('-');
 804870d:	83 ec 0c             	sub    $0xc,%esp
 8048710:	6a 2d                	push   $0x2d
 8048712:	8b 45 08             	mov    0x8(%ebp),%eax
 8048715:	ff d0                	call   *%eax
 8048717:	83 c4 10             	add    $0x10,%esp
					x=-x;
 804871a:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 804871d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8048724:	eb 53                	jmp    8048779 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 8048726:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8048729:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804872e:	89 c8                	mov    %ecx,%eax
 8048730:	f7 ea                	imul   %edx
 8048732:	c1 fa 02             	sar    $0x2,%edx
 8048735:	89 c8                	mov    %ecx,%eax
 8048737:	c1 f8 1f             	sar    $0x1f,%eax
 804873a:	29 c2                	sub    %eax,%edx
 804873c:	89 d0                	mov    %edx,%eax
 804873e:	c1 e0 02             	shl    $0x2,%eax
 8048741:	01 d0                	add    %edx,%eax
 8048743:	01 c0                	add    %eax,%eax
 8048745:	29 c1                	sub    %eax,%ecx
 8048747:	89 ca                	mov    %ecx,%edx
 8048749:	89 d0                	mov    %edx,%eax
 804874b:	83 c0 30             	add    $0x30,%eax
 804874e:	89 c1                	mov    %eax,%ecx
 8048750:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048753:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048756:	01 d0                	add    %edx,%eax
 8048758:	88 08                	mov    %cl,(%eax)
					x/=10;
 804875a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804875d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048762:	89 c8                	mov    %ecx,%eax
 8048764:	f7 ea                	imul   %edx
 8048766:	c1 fa 02             	sar    $0x2,%edx
 8048769:	89 c8                	mov    %ecx,%eax
 804876b:	c1 f8 1f             	sar    $0x1f,%eax
 804876e:	29 c2                	sub    %eax,%edx
 8048770:	89 d0                	mov    %edx,%eax
 8048772:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 8048775:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048779:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804877d:	7f a7                	jg     8048726 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 804877f:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 8048783:	eb 1e                	jmp    80487a3 <vfprintf+0x22d>
					printer(digits[di]);
 8048785:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048788:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804878b:	01 d0                	add    %edx,%eax
 804878d:	0f b6 00             	movzbl (%eax),%eax
 8048790:	0f be c0             	movsbl %al,%eax
 8048793:	83 ec 0c             	sub    $0xc,%esp
 8048796:	50                   	push   %eax
 8048797:	8b 45 08             	mov    0x8(%ebp),%eax
 804879a:	ff d0                	call   *%eax
 804879c:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 804879f:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 80487a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 80487a7:	79 dc                	jns    8048785 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80487a9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80487ad:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 80487b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80487b4:	0f b6 00             	movzbl (%eax),%eax
 80487b7:	3c 63                	cmp    $0x63,%al
 80487b9:	75 1d                	jne    80487d8 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 80487bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80487be:	0f b6 00             	movzbl (%eax),%eax
 80487c1:	0f be c0             	movsbl %al,%eax
 80487c4:	83 ec 0c             	sub    $0xc,%esp
 80487c7:	50                   	push   %eax
 80487c8:	8b 45 08             	mov    0x8(%ebp),%eax
 80487cb:	ff d0                	call   *%eax
 80487cd:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 80487d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80487d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 80487d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 80487df:	eb 1b                	jmp    80487fc <vfprintf+0x286>
		}
		if(type == NONE){
 80487e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80487e5:	75 15                	jne    80487fc <vfprintf+0x286>
			printer(cur);
 80487e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80487ea:	0f b6 00             	movzbl (%eax),%eax
 80487ed:	0f be c0             	movsbl %al,%eax
 80487f0:	83 ec 0c             	sub    $0xc,%esp
 80487f3:	50                   	push   %eax
 80487f4:	8b 45 08             	mov    0x8(%ebp),%eax
 80487f7:	ff d0                	call   *%eax
 80487f9:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 80487fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048803:	0f b6 00             	movzbl (%eax),%eax
 8048806:	84 c0                	test   %al,%al
 8048808:	0f 85 8d fd ff ff    	jne    804859b <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 804880e:	c9                   	leave  
 804880f:	c3                   	ret    

08048810 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8048810:	55                   	push   %ebp
 8048811:	89 e5                	mov    %esp,%ebp
 8048813:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048816:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048819:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 804881c:	8b 45 08             	mov    0x8(%ebp),%eax
 804881f:	83 ec 04             	sub    $0x4,%esp
 8048822:	ff 75 f4             	pushl  -0xc(%ebp)
 8048825:	50                   	push   %eax
 8048826:	68 23 85 04 08       	push   $0x8048523
 804882b:	e8 46 fd ff ff       	call   8048576 <vfprintf>
 8048830:	83 c4 10             	add    $0x10,%esp
}
 8048833:	c9                   	leave  
 8048834:	c3                   	ret    
