
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <sys_fs_open>:
	asm volatile("int $0x80": : "a"(SYS_READLINE), "b"(dest));
}
static inline void sys_fs_ls(uint32_t mask){
	asm volatile("int $0x80": : "a"(SYS_FS_LS), "b"(mask));
}
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

0804811f <sys_exit>:
	int count;
	asm volatile("int $0x80": "=a"(count) : "a"(SYS_SEM_GET), "b"(sem)); //SYSCALL HERE!
	return count;
}

static inline void sys_exit(){
 804811f:	55                   	push   %ebp
 8048120:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT));
 8048122:	b8 dc 05 00 00       	mov    $0x5dc,%eax
 8048127:	cd 80                	int    $0x80
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
 8048129:	b8 df 05 00 00       	mov    $0x5df,%eax
 804812e:	cd 80                	int    $0x80
}
 8048130:	5d                   	pop    %ebp
 8048131:	c3                   	ret    

08048132 <sys_fork>:
}

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline uint32_t sys_fork(){
 8048132:	55                   	push   %ebp
 8048133:	89 e5                	mov    %esp,%ebp
 8048135:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 8048138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
 804813f:	b8 e0 05 00 00       	mov    $0x5e0,%eax
 8048144:	cd 80                	int    $0x80
 8048146:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
 8048149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 804814c:	c9                   	leave  
 804814d:	c3                   	ret    

0804814e <strcpy>:
    while(*s1 && (*s1==*s2))
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
 804814e:	55                   	push   %ebp
 804814f:	89 e5                	mov    %esp,%ebp
 8048151:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
 8048154:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
 804815b:	eb 04                	jmp    8048161 <strcpy+0x13>
    {
        i++;
 804815d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
 8048161:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8048164:	8b 45 08             	mov    0x8(%ebp),%eax
 8048167:	01 d0                	add    %edx,%eax
 8048169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 804816c:	8b 55 0c             	mov    0xc(%ebp),%edx
 804816f:	01 ca                	add    %ecx,%edx
 8048171:	0f b6 12             	movzbl (%edx),%edx
 8048174:	88 10                	mov    %dl,(%eax)
 8048176:	0f b6 00             	movzbl (%eax),%eax
 8048179:	84 c0                	test   %al,%al
 804817b:	75 e0                	jne    804815d <strcpy+0xf>
    {
        i++;
    } 
}
 804817d:	c9                   	leave  
 804817e:	c3                   	ret    

0804817f <main>:
		printf("CONSUMER: %d received, now I want to consumer it in %ds!\n", item, asleep);
		sleep(asleep); //consume

	}
}*/
int main(){
 804817f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048183:	83 e4 f0             	and    $0xfffffff0,%esp
 8048186:	ff 71 fc             	pushl  -0x4(%ecx)
 8048189:	55                   	push   %ebp
 804818a:	89 e5                	mov    %esp,%ebp
 804818c:	51                   	push   %ecx
 804818d:	81 ec 64 02 00 00    	sub    $0x264,%esp


	int fd = open("singer.txt", FS_RWC);
 8048193:	6a 01                	push   $0x1
 8048195:	68 3c 86 04 08       	push   $0x804863c
 804819a:	e8 f5 fe ff ff       	call   8048094 <sys_fs_open>
 804819f:	83 c4 08             	add    $0x8,%esp
 80481a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char buf[300];
	read(fd, buf, 300);
 80481a5:	68 2c 01 00 00       	push   $0x12c
 80481aa:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
 80481b0:	50                   	push   %eax
 80481b1:	ff 75 f0             	pushl  -0x10(%ebp)
 80481b4:	e8 fd fe ff ff       	call   80480b6 <sys_fs_read>
 80481b9:	83 c4 0c             	add    $0xc,%esp
	printf("APP#READ singer.txt: %s\n", buf);
 80481bc:	83 ec 08             	sub    $0x8,%esp
 80481bf:	8d 85 c4 fe ff ff    	lea    -0x13c(%ebp),%eax
 80481c5:	50                   	push   %eax
 80481c6:	68 47 86 04 08       	push   $0x8048647
 80481cb:	e8 47 04 00 00       	call   8048617 <printf>
 80481d0:	83 c4 10             	add    $0x10,%esp

	lseek(fd, 0, SEEK_SET);
 80481d3:	83 ec 04             	sub    $0x4,%esp
 80481d6:	6a 00                	push   $0x0
 80481d8:	6a 00                	push   $0x0
 80481da:	ff 75 f0             	pushl  -0x10(%ebp)
 80481dd:	e8 1a ff ff ff       	call   80480fc <sys_fs_lseek>
 80481e2:	83 c4 10             	add    $0x10,%esp

	fork();
 80481e5:	e8 48 ff ff ff       	call   8048132 <sys_fork>
	char buf2[300];
	strcpy(buf2, "Hello from the other side!");
 80481ea:	83 ec 08             	sub    $0x8,%esp
 80481ed:	68 60 86 04 08       	push   $0x8048660
 80481f2:	8d 85 98 fd ff ff    	lea    -0x268(%ebp),%eax
 80481f8:	50                   	push   %eax
 80481f9:	e8 50 ff ff ff       	call   804814e <strcpy>
 80481fe:	83 c4 10             	add    $0x10,%esp
	write(fd, buf2, 26);
 8048201:	83 ec 04             	sub    $0x4,%esp
 8048204:	6a 1a                	push   $0x1a
 8048206:	8d 85 98 fd ff ff    	lea    -0x268(%ebp),%eax
 804820c:	50                   	push   %eax
 804820d:	ff 75 f0             	pushl  -0x10(%ebp)
 8048210:	e8 c4 fe ff ff       	call   80480d9 <sys_fs_write>
 8048215:	83 c4 10             	add    $0x10,%esp
	printf("APP#WRITE singer.txt: %s\n", buf2);
 8048218:	83 ec 08             	sub    $0x8,%esp
 804821b:	8d 85 98 fd ff ff    	lea    -0x268(%ebp),%eax
 8048221:	50                   	push   %eax
 8048222:	68 7b 86 04 08       	push   $0x804867b
 8048227:	e8 eb 03 00 00       	call   8048617 <printf>
 804822c:	83 c4 10             	add    $0x10,%esp
	int i=0;
 804822f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(i<(1<<29))i++;
 8048236:	eb 04                	jmp    804823c <main+0xbd>
 8048238:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804823c:	81 7d f4 ff ff ff 1f 	cmpl   $0x1fffffff,-0xc(%ebp)
 8048243:	7e f3                	jle    8048238 <main+0xb9>
	exit();
 8048245:	e8 d5 fe ff ff       	call   804811f <sys_exit>
 804824a:	b8 00 00 00 00       	mov    $0x0,%eax
 804824f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 8048252:	c9                   	leave  
 8048253:	8d 61 fc             	lea    -0x4(%ecx),%esp
 8048256:	c3                   	ret    

08048257 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 8048257:	55                   	push   %ebp
 8048258:	89 e5                	mov    %esp,%ebp
 804825a:	53                   	push   %ebx
 804825b:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 804825e:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 8048265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 804826c:	a1 80 98 04 08       	mov    0x8049880,%eax
 8048271:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 8048277:	05 39 30 00 00       	add    $0x3039,%eax
 804827c:	a3 80 98 04 08       	mov    %eax,0x8049880
    y ^= (y<<13);   
 8048281:	a1 84 98 04 08       	mov    0x8049884,%eax
 8048286:	c1 e0 0d             	shl    $0xd,%eax
 8048289:	89 c2                	mov    %eax,%edx
 804828b:	a1 84 98 04 08       	mov    0x8049884,%eax
 8048290:	31 d0                	xor    %edx,%eax
 8048292:	a3 84 98 04 08       	mov    %eax,0x8049884
    y ^= (y>>17);   
 8048297:	a1 84 98 04 08       	mov    0x8049884,%eax
 804829c:	c1 e8 11             	shr    $0x11,%eax
 804829f:	89 c2                	mov    %eax,%edx
 80482a1:	a1 84 98 04 08       	mov    0x8049884,%eax
 80482a6:	31 d0                	xor    %edx,%eax
 80482a8:	a3 84 98 04 08       	mov    %eax,0x8049884
    y ^= (y<<5);    
 80482ad:	a1 84 98 04 08       	mov    0x8049884,%eax
 80482b2:	c1 e0 05             	shl    $0x5,%eax
 80482b5:	89 c2                	mov    %eax,%edx
 80482b7:	a1 84 98 04 08       	mov    0x8049884,%eax
 80482bc:	31 d0                	xor    %edx,%eax
 80482be:	a3 84 98 04 08       	mov    %eax,0x8049884
      
    t = (A*z + c);  
 80482c3:	a1 88 98 04 08       	mov    0x8049888,%eax
 80482c8:	ba 00 00 00 00       	mov    $0x0,%edx
 80482cd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 80482d0:	89 cb                	mov    %ecx,%ebx
 80482d2:	0f af da             	imul   %edx,%ebx
 80482d5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 80482d8:	0f af c8             	imul   %eax,%ecx
 80482db:	01 d9                	add    %ebx,%ecx
 80482dd:	f7 65 f0             	mull   -0x10(%ebp)
 80482e0:	01 d1                	add    %edx,%ecx
 80482e2:	89 ca                	mov    %ecx,%edx
 80482e4:	8b 0d 8c 98 04 08    	mov    0x804988c,%ecx
 80482ea:	bb 00 00 00 00       	mov    $0x0,%ebx
 80482ef:	01 c8                	add    %ecx,%eax
 80482f1:	11 da                	adc    %ebx,%edx
 80482f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
 80482f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 80482f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80482fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80482ff:	89 d0                	mov    %edx,%eax
 8048301:	31 d2                	xor    %edx,%edx
 8048303:	a3 8c 98 04 08       	mov    %eax,0x804988c
    z = t;  
 8048308:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804830b:	a3 88 98 04 08       	mov    %eax,0x8049888
       
    return x+y+z;    
 8048310:	8b 15 80 98 04 08    	mov    0x8049880,%edx
 8048316:	a1 84 98 04 08       	mov    0x8049884,%eax
 804831b:	01 c2                	add    %eax,%edx
 804831d:	a1 88 98 04 08       	mov    0x8049888,%eax
 8048322:	01 d0                	add    %edx,%eax
 8048324:	83 c4 14             	add    $0x14,%esp
 8048327:	5b                   	pop    %ebx
 8048328:	5d                   	pop    %ebp
 8048329:	c3                   	ret    

0804832a <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 804832a:	55                   	push   %ebp
 804832b:	89 e5                	mov    %esp,%ebp
 804832d:	53                   	push   %ebx
 804832e:	83 ec 04             	sub    $0x4,%esp
 8048331:	8b 45 08             	mov    0x8(%ebp),%eax
 8048334:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 8048337:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 804833c:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 8048340:	89 d3                	mov    %edx,%ebx
 8048342:	cd 80                	int    $0x80
}
 8048344:	83 c4 04             	add    $0x4,%esp
 8048347:	5b                   	pop    %ebx
 8048348:	5d                   	pop    %ebp
 8048349:	c3                   	ret    

0804834a <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 804834a:	55                   	push   %ebp
 804834b:	89 e5                	mov    %esp,%ebp
 804834d:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 8048350:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048353:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 8048356:	eb 19                	jmp    8048371 <printp+0x27>
		printer(cur);
 8048358:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804835b:	0f b6 00             	movzbl (%eax),%eax
 804835e:	0f be c0             	movsbl %al,%eax
 8048361:	83 ec 0c             	sub    $0xc,%esp
 8048364:	50                   	push   %eax
 8048365:	8b 45 08             	mov    0x8(%ebp),%eax
 8048368:	ff d0                	call   *%eax
 804836a:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 804836d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048371:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048374:	0f b6 00             	movzbl (%eax),%eax
 8048377:	84 c0                	test   %al,%al
 8048379:	75 dd                	jne    8048358 <printp+0xe>
		printer(cur);
	}
}
 804837b:	c9                   	leave  
 804837c:	c3                   	ret    

0804837d <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 804837d:	55                   	push   %ebp
 804837e:	89 e5                	mov    %esp,%ebp
 8048380:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 8048383:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048386:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 8048389:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8048390:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 8048397:	8b 45 10             	mov    0x10(%ebp),%eax
 804839a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 804839d:	e9 65 02 00 00       	jmp    8048607 <vfprintf+0x28a>

		if(cur == '%'){
 80483a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483a5:	0f b6 00             	movzbl (%eax),%eax
 80483a8:	3c 25                	cmp    $0x25,%al
 80483aa:	75 0c                	jne    80483b8 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 80483ac:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 80483b3:	e9 4b 02 00 00       	jmp    8048603 <vfprintf+0x286>
		}
		if(type == READ){
 80483b8:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80483bc:	0f 85 26 02 00 00    	jne    80485e8 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 80483c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483c5:	0f b6 00             	movzbl (%eax),%eax
 80483c8:	3c 73                	cmp    $0x73,%al
 80483ca:	75 35                	jne    8048401 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 80483cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80483cf:	8b 00                	mov    (%eax),%eax
 80483d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 80483d4:	eb 19                	jmp    80483ef <vfprintf+0x72>
					printer(*p);
 80483d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80483d9:	0f b6 00             	movzbl (%eax),%eax
 80483dc:	0f be c0             	movsbl %al,%eax
 80483df:	83 ec 0c             	sub    $0xc,%esp
 80483e2:	50                   	push   %eax
 80483e3:	8b 45 08             	mov    0x8(%ebp),%eax
 80483e6:	ff d0                	call   *%eax
 80483e8:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 80483eb:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 80483ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80483f2:	0f b6 00             	movzbl (%eax),%eax
 80483f5:	84 c0                	test   %al,%al
 80483f7:	75 dd                	jne    80483d6 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 80483f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80483fd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 8048401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048404:	0f b6 00             	movzbl (%eax),%eax
 8048407:	3c 78                	cmp    $0x78,%al
 8048409:	0f 85 99 00 00 00    	jne    80484a8 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 804840f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048412:	8b 00                	mov    (%eax),%eax
 8048414:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8048417:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804841b:	75 1d                	jne    804843a <vfprintf+0xbd>
					printer('0');
 804841d:	83 ec 0c             	sub    $0xc,%esp
 8048420:	6a 30                	push   $0x30
 8048422:	8b 45 08             	mov    0x8(%ebp),%eax
 8048425:	ff d0                	call   *%eax
 8048427:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804842a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804842e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8048435:	e9 c9 01 00 00       	jmp    8048603 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 804843a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 8048441:	eb 2d                	jmp    8048470 <vfprintf+0xf3>
					int d=(x%16);
 8048443:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048446:	83 e0 0f             	and    $0xf,%eax
 8048449:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 804844c:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 8048450:	7e 04                	jle    8048456 <vfprintf+0xd9>
						d+='a'-'0'-10;
 8048452:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 8048456:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8048459:	83 c0 30             	add    $0x30,%eax
 804845c:	89 c1                	mov    %eax,%ecx
 804845e:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048461:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048464:	01 d0                	add    %edx,%eax
 8048466:	88 08                	mov    %cl,(%eax)
					x>>=4;
 8048468:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 804846c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048470:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048474:	75 cd                	jne    8048443 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 8048476:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 804847a:	eb 1e                	jmp    804849a <vfprintf+0x11d>
					printer(digits[di]);
 804847c:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804847f:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048482:	01 d0                	add    %edx,%eax
 8048484:	0f b6 00             	movzbl (%eax),%eax
 8048487:	0f be c0             	movsbl %al,%eax
 804848a:	83 ec 0c             	sub    $0xc,%esp
 804848d:	50                   	push   %eax
 804848e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048491:	ff d0                	call   *%eax
 8048493:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8048496:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 804849a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 804849e:	79 dc                	jns    804847c <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80484a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80484a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 80484a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80484ab:	0f b6 00             	movzbl (%eax),%eax
 80484ae:	3c 64                	cmp    $0x64,%al
 80484b0:	0f 85 02 01 00 00    	jne    80485b8 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 80484b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80484b9:	8b 00                	mov    (%eax),%eax
 80484bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 80484be:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 80484c5:	75 23                	jne    80484ea <vfprintf+0x16d>
					printp(printer, "-2147483648");
 80484c7:	83 ec 08             	sub    $0x8,%esp
 80484ca:	68 95 86 04 08       	push   $0x8048695
 80484cf:	ff 75 08             	pushl  0x8(%ebp)
 80484d2:	e8 73 fe ff ff       	call   804834a <printp>
 80484d7:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80484da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80484de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80484e5:	e9 19 01 00 00       	jmp    8048603 <vfprintf+0x286>
				}
				if(x==0){
 80484ea:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80484ee:	75 1e                	jne    804850e <vfprintf+0x191>
					printer('0');
 80484f0:	83 ec 0c             	sub    $0xc,%esp
 80484f3:	6a 30                	push   $0x30
 80484f5:	8b 45 08             	mov    0x8(%ebp),%eax
 80484f8:	ff d0                	call   *%eax
 80484fa:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80484fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048501:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048508:	90                   	nop
 8048509:	e9 f5 00 00 00       	jmp    8048603 <vfprintf+0x286>
				}
				if(x<0){
 804850e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048512:	79 10                	jns    8048524 <vfprintf+0x1a7>
					printer('-');
 8048514:	83 ec 0c             	sub    $0xc,%esp
 8048517:	6a 2d                	push   $0x2d
 8048519:	8b 45 08             	mov    0x8(%ebp),%eax
 804851c:	ff d0                	call   *%eax
 804851e:	83 c4 10             	add    $0x10,%esp
					x=-x;
 8048521:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 8048524:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 804852b:	eb 53                	jmp    8048580 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 804852d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8048530:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048535:	89 c8                	mov    %ecx,%eax
 8048537:	f7 ea                	imul   %edx
 8048539:	c1 fa 02             	sar    $0x2,%edx
 804853c:	89 c8                	mov    %ecx,%eax
 804853e:	c1 f8 1f             	sar    $0x1f,%eax
 8048541:	29 c2                	sub    %eax,%edx
 8048543:	89 d0                	mov    %edx,%eax
 8048545:	c1 e0 02             	shl    $0x2,%eax
 8048548:	01 d0                	add    %edx,%eax
 804854a:	01 c0                	add    %eax,%eax
 804854c:	29 c1                	sub    %eax,%ecx
 804854e:	89 ca                	mov    %ecx,%edx
 8048550:	89 d0                	mov    %edx,%eax
 8048552:	83 c0 30             	add    $0x30,%eax
 8048555:	89 c1                	mov    %eax,%ecx
 8048557:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 804855a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804855d:	01 d0                	add    %edx,%eax
 804855f:	88 08                	mov    %cl,(%eax)
					x/=10;
 8048561:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8048564:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048569:	89 c8                	mov    %ecx,%eax
 804856b:	f7 ea                	imul   %edx
 804856d:	c1 fa 02             	sar    $0x2,%edx
 8048570:	89 c8                	mov    %ecx,%eax
 8048572:	c1 f8 1f             	sar    $0x1f,%eax
 8048575:	29 c2                	sub    %eax,%edx
 8048577:	89 d0                	mov    %edx,%eax
 8048579:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 804857c:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048580:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048584:	7f a7                	jg     804852d <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 8048586:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 804858a:	eb 1e                	jmp    80485aa <vfprintf+0x22d>
					printer(digits[di]);
 804858c:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 804858f:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048592:	01 d0                	add    %edx,%eax
 8048594:	0f b6 00             	movzbl (%eax),%eax
 8048597:	0f be c0             	movsbl %al,%eax
 804859a:	83 ec 0c             	sub    $0xc,%esp
 804859d:	50                   	push   %eax
 804859e:	8b 45 08             	mov    0x8(%ebp),%eax
 80485a1:	ff d0                	call   *%eax
 80485a3:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 80485a6:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 80485aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 80485ae:	79 dc                	jns    804858c <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80485b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80485b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 80485b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485bb:	0f b6 00             	movzbl (%eax),%eax
 80485be:	3c 63                	cmp    $0x63,%al
 80485c0:	75 1d                	jne    80485df <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 80485c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485c5:	0f b6 00             	movzbl (%eax),%eax
 80485c8:	0f be c0             	movsbl %al,%eax
 80485cb:	83 ec 0c             	sub    $0xc,%esp
 80485ce:	50                   	push   %eax
 80485cf:	8b 45 08             	mov    0x8(%ebp),%eax
 80485d2:	ff d0                	call   *%eax
 80485d4:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 80485d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80485db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 80485df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 80485e6:	eb 1b                	jmp    8048603 <vfprintf+0x286>
		}
		if(type == NONE){
 80485e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80485ec:	75 15                	jne    8048603 <vfprintf+0x286>
			printer(cur);
 80485ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485f1:	0f b6 00             	movzbl (%eax),%eax
 80485f4:	0f be c0             	movsbl %al,%eax
 80485f7:	83 ec 0c             	sub    $0xc,%esp
 80485fa:	50                   	push   %eax
 80485fb:	8b 45 08             	mov    0x8(%ebp),%eax
 80485fe:	ff d0                	call   *%eax
 8048600:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048603:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048607:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804860a:	0f b6 00             	movzbl (%eax),%eax
 804860d:	84 c0                	test   %al,%al
 804860f:	0f 85 8d fd ff ff    	jne    80483a2 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8048615:	c9                   	leave  
 8048616:	c3                   	ret    

08048617 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8048617:	55                   	push   %ebp
 8048618:	89 e5                	mov    %esp,%ebp
 804861a:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 804861d:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048620:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8048623:	8b 45 08             	mov    0x8(%ebp),%eax
 8048626:	83 ec 04             	sub    $0x4,%esp
 8048629:	ff 75 f4             	pushl  -0xc(%ebp)
 804862c:	50                   	push   %eax
 804862d:	68 2a 83 04 08       	push   $0x804832a
 8048632:	e8 46 fd ff ff       	call   804837d <vfprintf>
 8048637:	83 c4 10             	add    $0x10,%esp
}
 804863a:	c9                   	leave  
 804863b:	c3                   	ret    
