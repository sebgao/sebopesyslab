
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <sys_fs_open>:
// static inline int fs_lseek(int fd, int offset, int whence);
// static inline int fs_close(int fd);
static inline void sys_readline(char* dest){
	asm volatile("int $0x80": : "a"(SYS_READLINE), "b"(dest));
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
 8048195:	68 26 86 04 08       	push   $0x8048626
 804819a:	e8 f5 fe ff ff       	call   8048094 <sys_fs_open>
 804819f:	83 c4 08             	add    $0x8,%esp
 80481a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	char buf[300];
	read(fd, buf, 300);
 80481a5:	68 2c 01 00 00       	push   $0x12c
 80481aa:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
 80481b0:	50                   	push   %eax
 80481b1:	ff 75 f4             	pushl  -0xc(%ebp)
 80481b4:	e8 fd fe ff ff       	call   80480b6 <sys_fs_read>
 80481b9:	83 c4 0c             	add    $0xc,%esp
	printf("APP#READ singer.txt: %s\n", buf);
 80481bc:	83 ec 08             	sub    $0x8,%esp
 80481bf:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
 80481c5:	50                   	push   %eax
 80481c6:	68 31 86 04 08       	push   $0x8048631
 80481cb:	e8 31 04 00 00       	call   8048601 <printf>
 80481d0:	83 c4 10             	add    $0x10,%esp

	lseek(fd, 0, SEEK_SET);
 80481d3:	83 ec 04             	sub    $0x4,%esp
 80481d6:	6a 00                	push   $0x0
 80481d8:	6a 00                	push   $0x0
 80481da:	ff 75 f4             	pushl  -0xc(%ebp)
 80481dd:	e8 1a ff ff ff       	call   80480fc <sys_fs_lseek>
 80481e2:	83 c4 10             	add    $0x10,%esp

	fork();
 80481e5:	e8 48 ff ff ff       	call   8048132 <sys_fork>
	char buf2[300];
	strcpy(buf2, "Hello from the other side!");
 80481ea:	83 ec 08             	sub    $0x8,%esp
 80481ed:	68 4a 86 04 08       	push   $0x804864a
 80481f2:	8d 85 9c fd ff ff    	lea    -0x264(%ebp),%eax
 80481f8:	50                   	push   %eax
 80481f9:	e8 50 ff ff ff       	call   804814e <strcpy>
 80481fe:	83 c4 10             	add    $0x10,%esp
	write(fd, buf2, 26);
 8048201:	83 ec 04             	sub    $0x4,%esp
 8048204:	6a 1a                	push   $0x1a
 8048206:	8d 85 9c fd ff ff    	lea    -0x264(%ebp),%eax
 804820c:	50                   	push   %eax
 804820d:	ff 75 f4             	pushl  -0xc(%ebp)
 8048210:	e8 c4 fe ff ff       	call   80480d9 <sys_fs_write>
 8048215:	83 c4 10             	add    $0x10,%esp
	printf("APP#WRITE singer.txt: %s\n", buf2);
 8048218:	83 ec 08             	sub    $0x8,%esp
 804821b:	8d 85 9c fd ff ff    	lea    -0x264(%ebp),%eax
 8048221:	50                   	push   %eax
 8048222:	68 65 86 04 08       	push   $0x8048665
 8048227:	e8 d5 03 00 00       	call   8048601 <printf>
 804822c:	83 c4 10             	add    $0x10,%esp
	exit();
 804822f:	e8 eb fe ff ff       	call   804811f <sys_exit>
 8048234:	b8 00 00 00 00       	mov    $0x0,%eax
 8048239:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 804823c:	c9                   	leave  
 804823d:	8d 61 fc             	lea    -0x4(%ecx),%esp
 8048240:	c3                   	ret    

08048241 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 8048241:	55                   	push   %ebp
 8048242:	89 e5                	mov    %esp,%ebp
 8048244:	53                   	push   %ebx
 8048245:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 8048248:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 804824f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 8048256:	a1 68 98 04 08       	mov    0x8049868,%eax
 804825b:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 8048261:	05 39 30 00 00       	add    $0x3039,%eax
 8048266:	a3 68 98 04 08       	mov    %eax,0x8049868
    y ^= (y<<13);   
 804826b:	a1 6c 98 04 08       	mov    0x804986c,%eax
 8048270:	c1 e0 0d             	shl    $0xd,%eax
 8048273:	89 c2                	mov    %eax,%edx
 8048275:	a1 6c 98 04 08       	mov    0x804986c,%eax
 804827a:	31 d0                	xor    %edx,%eax
 804827c:	a3 6c 98 04 08       	mov    %eax,0x804986c
    y ^= (y>>17);   
 8048281:	a1 6c 98 04 08       	mov    0x804986c,%eax
 8048286:	c1 e8 11             	shr    $0x11,%eax
 8048289:	89 c2                	mov    %eax,%edx
 804828b:	a1 6c 98 04 08       	mov    0x804986c,%eax
 8048290:	31 d0                	xor    %edx,%eax
 8048292:	a3 6c 98 04 08       	mov    %eax,0x804986c
    y ^= (y<<5);    
 8048297:	a1 6c 98 04 08       	mov    0x804986c,%eax
 804829c:	c1 e0 05             	shl    $0x5,%eax
 804829f:	89 c2                	mov    %eax,%edx
 80482a1:	a1 6c 98 04 08       	mov    0x804986c,%eax
 80482a6:	31 d0                	xor    %edx,%eax
 80482a8:	a3 6c 98 04 08       	mov    %eax,0x804986c
      
    t = (A*z + c);  
 80482ad:	a1 70 98 04 08       	mov    0x8049870,%eax
 80482b2:	ba 00 00 00 00       	mov    $0x0,%edx
 80482b7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 80482ba:	89 cb                	mov    %ecx,%ebx
 80482bc:	0f af da             	imul   %edx,%ebx
 80482bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 80482c2:	0f af c8             	imul   %eax,%ecx
 80482c5:	01 d9                	add    %ebx,%ecx
 80482c7:	f7 65 f0             	mull   -0x10(%ebp)
 80482ca:	01 d1                	add    %edx,%ecx
 80482cc:	89 ca                	mov    %ecx,%edx
 80482ce:	8b 0d 74 98 04 08    	mov    0x8049874,%ecx
 80482d4:	bb 00 00 00 00       	mov    $0x0,%ebx
 80482d9:	01 c8                	add    %ecx,%eax
 80482db:	11 da                	adc    %ebx,%edx
 80482dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
 80482e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 80482e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80482e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80482e9:	89 d0                	mov    %edx,%eax
 80482eb:	31 d2                	xor    %edx,%edx
 80482ed:	a3 74 98 04 08       	mov    %eax,0x8049874
    z = t;  
 80482f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80482f5:	a3 70 98 04 08       	mov    %eax,0x8049870
       
    return x+y+z;    
 80482fa:	8b 15 68 98 04 08    	mov    0x8049868,%edx
 8048300:	a1 6c 98 04 08       	mov    0x804986c,%eax
 8048305:	01 c2                	add    %eax,%edx
 8048307:	a1 70 98 04 08       	mov    0x8049870,%eax
 804830c:	01 d0                	add    %edx,%eax
 804830e:	83 c4 14             	add    $0x14,%esp
 8048311:	5b                   	pop    %ebx
 8048312:	5d                   	pop    %ebp
 8048313:	c3                   	ret    

08048314 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 8048314:	55                   	push   %ebp
 8048315:	89 e5                	mov    %esp,%ebp
 8048317:	53                   	push   %ebx
 8048318:	83 ec 04             	sub    $0x4,%esp
 804831b:	8b 45 08             	mov    0x8(%ebp),%eax
 804831e:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 8048321:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 8048326:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 804832a:	89 d3                	mov    %edx,%ebx
 804832c:	cd 80                	int    $0x80
}
 804832e:	83 c4 04             	add    $0x4,%esp
 8048331:	5b                   	pop    %ebx
 8048332:	5d                   	pop    %ebp
 8048333:	c3                   	ret    

08048334 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 8048334:	55                   	push   %ebp
 8048335:	89 e5                	mov    %esp,%ebp
 8048337:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 804833a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804833d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 8048340:	eb 19                	jmp    804835b <printp+0x27>
		printer(cur);
 8048342:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048345:	0f b6 00             	movzbl (%eax),%eax
 8048348:	0f be c0             	movsbl %al,%eax
 804834b:	83 ec 0c             	sub    $0xc,%esp
 804834e:	50                   	push   %eax
 804834f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048352:	ff d0                	call   *%eax
 8048354:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 8048357:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804835b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804835e:	0f b6 00             	movzbl (%eax),%eax
 8048361:	84 c0                	test   %al,%al
 8048363:	75 dd                	jne    8048342 <printp+0xe>
		printer(cur);
	}
}
 8048365:	c9                   	leave  
 8048366:	c3                   	ret    

08048367 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 8048367:	55                   	push   %ebp
 8048368:	89 e5                	mov    %esp,%ebp
 804836a:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 804836d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048370:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 8048373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 804837a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 8048381:	8b 45 10             	mov    0x10(%ebp),%eax
 8048384:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048387:	e9 65 02 00 00       	jmp    80485f1 <vfprintf+0x28a>

		if(cur == '%'){
 804838c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804838f:	0f b6 00             	movzbl (%eax),%eax
 8048392:	3c 25                	cmp    $0x25,%al
 8048394:	75 0c                	jne    80483a2 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 8048396:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 804839d:	e9 4b 02 00 00       	jmp    80485ed <vfprintf+0x286>
		}
		if(type == READ){
 80483a2:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80483a6:	0f 85 26 02 00 00    	jne    80485d2 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 80483ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483af:	0f b6 00             	movzbl (%eax),%eax
 80483b2:	3c 73                	cmp    $0x73,%al
 80483b4:	75 35                	jne    80483eb <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 80483b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80483b9:	8b 00                	mov    (%eax),%eax
 80483bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 80483be:	eb 19                	jmp    80483d9 <vfprintf+0x72>
					printer(*p);
 80483c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80483c3:	0f b6 00             	movzbl (%eax),%eax
 80483c6:	0f be c0             	movsbl %al,%eax
 80483c9:	83 ec 0c             	sub    $0xc,%esp
 80483cc:	50                   	push   %eax
 80483cd:	8b 45 08             	mov    0x8(%ebp),%eax
 80483d0:	ff d0                	call   *%eax
 80483d2:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 80483d5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 80483d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80483dc:	0f b6 00             	movzbl (%eax),%eax
 80483df:	84 c0                	test   %al,%al
 80483e1:	75 dd                	jne    80483c0 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 80483e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80483e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 80483eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80483ee:	0f b6 00             	movzbl (%eax),%eax
 80483f1:	3c 78                	cmp    $0x78,%al
 80483f3:	0f 85 99 00 00 00    	jne    8048492 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 80483f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80483fc:	8b 00                	mov    (%eax),%eax
 80483fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8048401:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048405:	75 1d                	jne    8048424 <vfprintf+0xbd>
					printer('0');
 8048407:	83 ec 0c             	sub    $0xc,%esp
 804840a:	6a 30                	push   $0x30
 804840c:	8b 45 08             	mov    0x8(%ebp),%eax
 804840f:	ff d0                	call   *%eax
 8048411:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048414:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048418:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 804841f:	e9 c9 01 00 00       	jmp    80485ed <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 8048424:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 804842b:	eb 2d                	jmp    804845a <vfprintf+0xf3>
					int d=(x%16);
 804842d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048430:	83 e0 0f             	and    $0xf,%eax
 8048433:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8048436:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 804843a:	7e 04                	jle    8048440 <vfprintf+0xd9>
						d+='a'-'0'-10;
 804843c:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 8048440:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8048443:	83 c0 30             	add    $0x30,%eax
 8048446:	89 c1                	mov    %eax,%ecx
 8048448:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804844b:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804844e:	01 d0                	add    %edx,%eax
 8048450:	88 08                	mov    %cl,(%eax)
					x>>=4;
 8048452:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8048456:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 804845a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804845e:	75 cd                	jne    804842d <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 8048460:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8048464:	eb 1e                	jmp    8048484 <vfprintf+0x11d>
					printer(digits[di]);
 8048466:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048469:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804846c:	01 d0                	add    %edx,%eax
 804846e:	0f b6 00             	movzbl (%eax),%eax
 8048471:	0f be c0             	movsbl %al,%eax
 8048474:	83 ec 0c             	sub    $0xc,%esp
 8048477:	50                   	push   %eax
 8048478:	8b 45 08             	mov    0x8(%ebp),%eax
 804847b:	ff d0                	call   *%eax
 804847d:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8048480:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8048484:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8048488:	79 dc                	jns    8048466 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 804848a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804848e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 8048492:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048495:	0f b6 00             	movzbl (%eax),%eax
 8048498:	3c 64                	cmp    $0x64,%al
 804849a:	0f 85 02 01 00 00    	jne    80485a2 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 80484a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80484a3:	8b 00                	mov    (%eax),%eax
 80484a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 80484a8:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 80484af:	75 23                	jne    80484d4 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 80484b1:	83 ec 08             	sub    $0x8,%esp
 80484b4:	68 7f 86 04 08       	push   $0x804867f
 80484b9:	ff 75 08             	pushl  0x8(%ebp)
 80484bc:	e8 73 fe ff ff       	call   8048334 <printp>
 80484c1:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80484c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80484c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80484cf:	e9 19 01 00 00       	jmp    80485ed <vfprintf+0x286>
				}
				if(x==0){
 80484d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80484d8:	75 1e                	jne    80484f8 <vfprintf+0x191>
					printer('0');
 80484da:	83 ec 0c             	sub    $0xc,%esp
 80484dd:	6a 30                	push   $0x30
 80484df:	8b 45 08             	mov    0x8(%ebp),%eax
 80484e2:	ff d0                	call   *%eax
 80484e4:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80484e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80484eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80484f2:	90                   	nop
 80484f3:	e9 f5 00 00 00       	jmp    80485ed <vfprintf+0x286>
				}
				if(x<0){
 80484f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80484fc:	79 10                	jns    804850e <vfprintf+0x1a7>
					printer('-');
 80484fe:	83 ec 0c             	sub    $0xc,%esp
 8048501:	6a 2d                	push   $0x2d
 8048503:	8b 45 08             	mov    0x8(%ebp),%eax
 8048506:	ff d0                	call   *%eax
 8048508:	83 c4 10             	add    $0x10,%esp
					x=-x;
 804850b:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 804850e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8048515:	eb 53                	jmp    804856a <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 8048517:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804851a:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804851f:	89 c8                	mov    %ecx,%eax
 8048521:	f7 ea                	imul   %edx
 8048523:	c1 fa 02             	sar    $0x2,%edx
 8048526:	89 c8                	mov    %ecx,%eax
 8048528:	c1 f8 1f             	sar    $0x1f,%eax
 804852b:	29 c2                	sub    %eax,%edx
 804852d:	89 d0                	mov    %edx,%eax
 804852f:	c1 e0 02             	shl    $0x2,%eax
 8048532:	01 d0                	add    %edx,%eax
 8048534:	01 c0                	add    %eax,%eax
 8048536:	29 c1                	sub    %eax,%ecx
 8048538:	89 ca                	mov    %ecx,%edx
 804853a:	89 d0                	mov    %edx,%eax
 804853c:	83 c0 30             	add    $0x30,%eax
 804853f:	89 c1                	mov    %eax,%ecx
 8048541:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048544:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048547:	01 d0                	add    %edx,%eax
 8048549:	88 08                	mov    %cl,(%eax)
					x/=10;
 804854b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804854e:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048553:	89 c8                	mov    %ecx,%eax
 8048555:	f7 ea                	imul   %edx
 8048557:	c1 fa 02             	sar    $0x2,%edx
 804855a:	89 c8                	mov    %ecx,%eax
 804855c:	c1 f8 1f             	sar    $0x1f,%eax
 804855f:	29 c2                	sub    %eax,%edx
 8048561:	89 d0                	mov    %edx,%eax
 8048563:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 8048566:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 804856a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804856e:	7f a7                	jg     8048517 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 8048570:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 8048574:	eb 1e                	jmp    8048594 <vfprintf+0x22d>
					printer(digits[di]);
 8048576:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048579:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804857c:	01 d0                	add    %edx,%eax
 804857e:	0f b6 00             	movzbl (%eax),%eax
 8048581:	0f be c0             	movsbl %al,%eax
 8048584:	83 ec 0c             	sub    $0xc,%esp
 8048587:	50                   	push   %eax
 8048588:	8b 45 08             	mov    0x8(%ebp),%eax
 804858b:	ff d0                	call   *%eax
 804858d:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 8048590:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 8048594:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8048598:	79 dc                	jns    8048576 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 804859a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804859e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 80485a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485a5:	0f b6 00             	movzbl (%eax),%eax
 80485a8:	3c 63                	cmp    $0x63,%al
 80485aa:	75 1d                	jne    80485c9 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 80485ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485af:	0f b6 00             	movzbl (%eax),%eax
 80485b2:	0f be c0             	movsbl %al,%eax
 80485b5:	83 ec 0c             	sub    $0xc,%esp
 80485b8:	50                   	push   %eax
 80485b9:	8b 45 08             	mov    0x8(%ebp),%eax
 80485bc:	ff d0                	call   *%eax
 80485be:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 80485c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80485c5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 80485c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 80485d0:	eb 1b                	jmp    80485ed <vfprintf+0x286>
		}
		if(type == NONE){
 80485d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80485d6:	75 15                	jne    80485ed <vfprintf+0x286>
			printer(cur);
 80485d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485db:	0f b6 00             	movzbl (%eax),%eax
 80485de:	0f be c0             	movsbl %al,%eax
 80485e1:	83 ec 0c             	sub    $0xc,%esp
 80485e4:	50                   	push   %eax
 80485e5:	8b 45 08             	mov    0x8(%ebp),%eax
 80485e8:	ff d0                	call   *%eax
 80485ea:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 80485ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80485f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80485f4:	0f b6 00             	movzbl (%eax),%eax
 80485f7:	84 c0                	test   %al,%al
 80485f9:	0f 85 8d fd ff ff    	jne    804838c <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 80485ff:	c9                   	leave  
 8048600:	c3                   	ret    

08048601 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8048601:	55                   	push   %ebp
 8048602:	89 e5                	mov    %esp,%ebp
 8048604:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048607:	8d 45 0c             	lea    0xc(%ebp),%eax
 804860a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 804860d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048610:	83 ec 04             	sub    $0x4,%esp
 8048613:	ff 75 f4             	pushl  -0xc(%ebp)
 8048616:	50                   	push   %eax
 8048617:	68 14 83 04 08       	push   $0x8048314
 804861c:	e8 46 fd ff ff       	call   8048367 <vfprintf>
 8048621:	83 c4 10             	add    $0x10,%esp
}
 8048624:	c9                   	leave  
 8048625:	c3                   	ret    
