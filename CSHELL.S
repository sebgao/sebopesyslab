
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <sys_exec>:
// static inline int fs_open(const char *pathname, int flags);
// static inline int fs_read(int fd, void *buf, int len);
// static inline int fs_write(int fd, void *buf, int len);
// static inline int fs_lseek(int fd, int offset, int whence);
// static inline int fs_close(int fd);
static inline void sys_exec(char* fn){
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_EXEC), "b"(fn));
 8048098:	b8 6c 07 00 00       	mov    $0x76c,%eax
 804809d:	8b 55 08             	mov    0x8(%ebp),%edx
 80480a0:	89 d3                	mov    %edx,%ebx
 80480a2:	cd 80                	int    $0x80
}
 80480a4:	5b                   	pop    %ebx
 80480a5:	5d                   	pop    %ebp
 80480a6:	c3                   	ret    

080480a7 <sys_readline>:

static inline void sys_readline(char* dest){
 80480a7:	55                   	push   %ebp
 80480a8:	89 e5                	mov    %esp,%ebp
 80480aa:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_READLINE), "b"(dest));
 80480ab:	b8 08 07 00 00       	mov    $0x708,%eax
 80480b0:	8b 55 08             	mov    0x8(%ebp),%edx
 80480b3:	89 d3                	mov    %edx,%ebx
 80480b5:	cd 80                	int    $0x80
}
 80480b7:	5b                   	pop    %ebx
 80480b8:	5d                   	pop    %ebp
 80480b9:	c3                   	ret    

080480ba <sys_fs_ls>:
static inline void sys_fs_ls(uint32_t mask){
 80480ba:	55                   	push   %ebp
 80480bb:	89 e5                	mov    %esp,%ebp
 80480bd:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_FS_LS), "b"(mask));
 80480be:	b8 a9 06 00 00       	mov    $0x6a9,%eax
 80480c3:	8b 55 08             	mov    0x8(%ebp),%edx
 80480c6:	89 d3                	mov    %edx,%ebx
 80480c8:	cd 80                	int    $0x80
}
 80480ca:	5b                   	pop    %ebx
 80480cb:	5d                   	pop    %ebp
 80480cc:	c3                   	ret    

080480cd <sys_fs_open>:
static inline int sys_fs_open(char *pathname, int flags){
 80480cd:	55                   	push   %ebp
 80480ce:	89 e5                	mov    %esp,%ebp
 80480d0:	53                   	push   %ebx
 80480d1:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_OPEN), "b"(pathname), "c"(flags)); //SYSCALL HERE!
 80480d4:	b8 a4 06 00 00       	mov    $0x6a4,%eax
 80480d9:	8b 55 08             	mov    0x8(%ebp),%edx
 80480dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
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

080480ef <sys_fs_read>:
static inline int sys_fs_read(int fd, void *buf, int len){
 80480ef:	55                   	push   %ebp
 80480f0:	89 e5                	mov    %esp,%ebp
 80480f2:	53                   	push   %ebx
 80480f3:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_READ), "b"(fd), "c"(buf), "d"(len)); //SYSCALL HERE!
 80480f6:	b8 a5 06 00 00       	mov    $0x6a5,%eax
 80480fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80480fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048101:	8b 55 10             	mov    0x10(%ebp),%edx
 8048104:	cd 80                	int    $0x80
 8048106:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 8048109:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 804810c:	83 c4 10             	add    $0x10,%esp
 804810f:	5b                   	pop    %ebx
 8048110:	5d                   	pop    %ebp
 8048111:	c3                   	ret    

08048112 <sys_fs_write>:
static inline int sys_fs_write(int fd, void *buf, int len){
 8048112:	55                   	push   %ebp
 8048113:	89 e5                	mov    %esp,%ebp
 8048115:	53                   	push   %ebx
 8048116:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_WRITE), "b"(fd), "c"(buf), "d"(len)); //SYSCALL HERE!
 8048119:	b8 a6 06 00 00       	mov    $0x6a6,%eax
 804811e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048121:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048124:	8b 55 10             	mov    0x10(%ebp),%edx
 8048127:	cd 80                	int    $0x80
 8048129:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 804812c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 804812f:	83 c4 10             	add    $0x10,%esp
 8048132:	5b                   	pop    %ebx
 8048133:	5d                   	pop    %ebp
 8048134:	c3                   	ret    

08048135 <sys_fs_lseek>:
static inline int sys_fs_lseek(int fd, int offset, int whence){
 8048135:	55                   	push   %ebp
 8048136:	89 e5                	mov    %esp,%ebp
 8048138:	53                   	push   %ebx
 8048139:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_LSEEK), "b"(fd), "c"(offset), "d"(whence)); //SYSCALL HERE!
 804813c:	b8 a7 06 00 00       	mov    $0x6a7,%eax
 8048141:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048144:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048147:	8b 55 10             	mov    0x10(%ebp),%edx
 804814a:	cd 80                	int    $0x80
 804814c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 804814f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 8048152:	83 c4 10             	add    $0x10,%esp
 8048155:	5b                   	pop    %ebx
 8048156:	5d                   	pop    %ebp
 8048157:	c3                   	ret    

08048158 <sys_fs_close>:
static inline int sys_fs_close(int fd){
 8048158:	55                   	push   %ebp
 8048159:	89 e5                	mov    %esp,%ebp
 804815b:	53                   	push   %ebx
 804815c:	83 ec 10             	sub    $0x10,%esp
	int ret;
	asm volatile("int $0x80": "=a"(ret) : "a"(SYS_FS_CLOSE), "b"(fd)); //SYSCALL HERE!
 804815f:	b8 a8 06 00 00       	mov    $0x6a8,%eax
 8048164:	8b 55 08             	mov    0x8(%ebp),%edx
 8048167:	89 d3                	mov    %edx,%ebx
 8048169:	cd 80                	int    $0x80
 804816b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	return ret;
 804816e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 8048171:	83 c4 10             	add    $0x10,%esp
 8048174:	5b                   	pop    %ebx
 8048175:	5d                   	pop    %ebp
 8048176:	c3                   	ret    

08048177 <sys_fork>:
}

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline uint32_t sys_fork(){
 8048177:	55                   	push   %ebp
 8048178:	89 e5                	mov    %esp,%ebp
 804817a:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 804817d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
 8048184:	b8 e0 05 00 00       	mov    $0x5e0,%eax
 8048189:	cd 80                	int    $0x80
 804818b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
 804818e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8048191:	c9                   	leave  
 8048192:	c3                   	ret    

08048193 <sys_join>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_join(int pid){
 8048193:	55                   	push   %ebp
 8048194:	89 e5                	mov    %esp,%ebp
 8048196:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
 8048197:	b8 e2 05 00 00       	mov    $0x5e2,%eax
 804819c:	8b 55 08             	mov    0x8(%ebp),%edx
 804819f:	89 d3                	mov    %edx,%ebx
 80481a1:	cd 80                	int    $0x80
}
 80481a3:	5b                   	pop    %ebx
 80481a4:	5d                   	pop    %ebp
 80481a5:	c3                   	ret    

080481a6 <memset2>:
}
static inline void memcpy2(void* dst, void* src, int len){
	asm volatile ("cld; rep movsb" : : "c"(len), "S"(src), "D"(dst));
}

static inline void memset2(void* dst, uint32_t src, int len){
 80481a6:	55                   	push   %ebp
 80481a7:	89 e5                	mov    %esp,%ebp
 80481a9:	57                   	push   %edi
 80481aa:	53                   	push   %ebx
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
 80481ab:	8b 55 10             	mov    0x10(%ebp),%edx
 80481ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 80481b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80481b4:	89 d1                	mov    %edx,%ecx
 80481b6:	89 df                	mov    %ebx,%edi
 80481b8:	fc                   	cld    
 80481b9:	f3 aa                	rep stos %al,%es:(%edi)
}
 80481bb:	5b                   	pop    %ebx
 80481bc:	5f                   	pop    %edi
 80481bd:	5d                   	pop    %ebp
 80481be:	c3                   	ret    

080481bf <strcmp>:
static inline int strcmp(const char* s1, const char* s2)
{
 80481bf:	55                   	push   %ebp
 80481c0:	89 e5                	mov    %esp,%ebp
    while(*s1 && (*s1==*s2))
 80481c2:	eb 08                	jmp    80481cc <strcmp+0xd>
        s1++,s2++;
 80481c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 80481c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
static inline void memset2(void* dst, uint32_t src, int len){
	asm volatile ("cld; rep stosb" : : "c"(len), "a"(src), "D"(dst));
}
static inline int strcmp(const char* s1, const char* s2)
{
    while(*s1 && (*s1==*s2))
 80481cc:	8b 45 08             	mov    0x8(%ebp),%eax
 80481cf:	0f b6 00             	movzbl (%eax),%eax
 80481d2:	84 c0                	test   %al,%al
 80481d4:	74 10                	je     80481e6 <strcmp+0x27>
 80481d6:	8b 45 08             	mov    0x8(%ebp),%eax
 80481d9:	0f b6 10             	movzbl (%eax),%edx
 80481dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 80481df:	0f b6 00             	movzbl (%eax),%eax
 80481e2:	38 c2                	cmp    %al,%dl
 80481e4:	74 de                	je     80481c4 <strcmp+0x5>
        s1++,s2++;
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
 80481e6:	8b 45 08             	mov    0x8(%ebp),%eax
 80481e9:	0f b6 00             	movzbl (%eax),%eax
 80481ec:	0f b6 d0             	movzbl %al,%edx
 80481ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 80481f2:	0f b6 00             	movzbl (%eax),%eax
 80481f5:	0f b6 c0             	movzbl %al,%eax
 80481f8:	29 c2                	sub    %eax,%edx
 80481fa:	89 d0                	mov    %edx,%eax
}
 80481fc:	5d                   	pop    %ebp
 80481fd:	c3                   	ret    

080481fe <strcpy>:
static inline void strcpy(char* dest, const char* source) 
{
 80481fe:	55                   	push   %ebp
 80481ff:	89 e5                	mov    %esp,%ebp
 8048201:	83 ec 10             	sub    $0x10,%esp
    int i = 0;
 8048204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while ((dest[i] = source[i]) != '\0')
 804820b:	eb 04                	jmp    8048211 <strcpy+0x13>
    {
        i++;
 804820d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    return *(const unsigned char*)s1-*(const unsigned char*)s2;
}
static inline void strcpy(char* dest, const char* source) 
{
    int i = 0;
    while ((dest[i] = source[i]) != '\0')
 8048211:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8048214:	8b 45 08             	mov    0x8(%ebp),%eax
 8048217:	01 d0                	add    %edx,%eax
 8048219:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 804821c:	8b 55 0c             	mov    0xc(%ebp),%edx
 804821f:	01 ca                	add    %ecx,%edx
 8048221:	0f b6 12             	movzbl (%edx),%edx
 8048224:	88 10                	mov    %dl,(%eax)
 8048226:	0f b6 00             	movzbl (%eax),%eax
 8048229:	84 c0                	test   %al,%al
 804822b:	75 e0                	jne    804820d <strcpy+0xf>
    {
        i++;
    } 
}
 804822d:	c9                   	leave  
 804822e:	c3                   	ret    

0804822f <strfind>:
        i++;
    return i;
}
static inline char *
strfind(const char *s, char c)
{
 804822f:	55                   	push   %ebp
 8048230:	89 e5                	mov    %esp,%ebp
 8048232:	83 ec 04             	sub    $0x4,%esp
 8048235:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048238:	88 45 fc             	mov    %al,-0x4(%ebp)
    for (; *s; s++)
 804823b:	eb 11                	jmp    804824e <strfind+0x1f>
        if (*s == c)
 804823d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048240:	0f b6 00             	movzbl (%eax),%eax
 8048243:	3a 45 fc             	cmp    -0x4(%ebp),%al
 8048246:	75 02                	jne    804824a <strfind+0x1b>
            break;
 8048248:	eb 0e                	jmp    8048258 <strfind+0x29>
    return i;
}
static inline char *
strfind(const char *s, char c)
{
    for (; *s; s++)
 804824a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 804824e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048251:	0f b6 00             	movzbl (%eax),%eax
 8048254:	84 c0                	test   %al,%al
 8048256:	75 e5                	jne    804823d <strfind+0xe>
        if (*s == c)
            break;
    return (char *) s;
 8048258:	8b 45 08             	mov    0x8(%ebp),%eax
}
 804825b:	c9                   	leave  
 804825c:	c3                   	ret    

0804825d <strchr>:
static inline char * strchr(const char *s, char c)
{
 804825d:	55                   	push   %ebp
 804825e:	89 e5                	mov    %esp,%ebp
 8048260:	83 ec 04             	sub    $0x4,%esp
 8048263:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048266:	88 45 fc             	mov    %al,-0x4(%ebp)
    for (; *s; s++)
 8048269:	eb 14                	jmp    804827f <strchr+0x22>
        if (*s == c)
 804826b:	8b 45 08             	mov    0x8(%ebp),%eax
 804826e:	0f b6 00             	movzbl (%eax),%eax
 8048271:	3a 45 fc             	cmp    -0x4(%ebp),%al
 8048274:	75 05                	jne    804827b <strchr+0x1e>
            return (char *) s;
 8048276:	8b 45 08             	mov    0x8(%ebp),%eax
 8048279:	eb 13                	jmp    804828e <strchr+0x31>
            break;
    return (char *) s;
}
static inline char * strchr(const char *s, char c)
{
    for (; *s; s++)
 804827b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 804827f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048282:	0f b6 00             	movzbl (%eax),%eax
 8048285:	84 c0                	test   %al,%al
 8048287:	75 e2                	jne    804826b <strchr+0xe>
        if (*s == c)
            return (char *) s;
    return 0;
 8048289:	b8 00 00 00 00       	mov    $0x0,%eax
}
 804828e:	c9                   	leave  
 804828f:	c3                   	ret    

08048290 <parse_arg>:
char c[1024];
char b[1024];
int argc;
char *argv[MAXARGS];
char safety[1024]="safety";
int parse_arg(char *buf){
 8048290:	55                   	push   %ebp
 8048291:	89 e5                	mov    %esp,%ebp
 8048293:	83 ec 08             	sub    $0x8,%esp

	argc = 0;
 8048296:	c7 05 40 a9 04 08 00 	movl   $0x0,0x804a940
 804829d:	00 00 00 
	argv[argc] = 0;
 80482a0:	a1 40 a9 04 08       	mov    0x804a940,%eax
 80482a5:	c7 04 85 00 a9 04 08 	movl   $0x0,0x804a900(,%eax,4)
 80482ac:	00 00 00 00 
	while (1) {
		while (*buf && strchr(WHITESPACE, *buf))
 80482b0:	eb 0c                	jmp    80482be <parse_arg+0x2e>
			*buf++ = 0;
 80482b2:	8b 45 08             	mov    0x8(%ebp),%eax
 80482b5:	8d 50 01             	lea    0x1(%eax),%edx
 80482b8:	89 55 08             	mov    %edx,0x8(%ebp)
 80482bb:	c6 00 00             	movb   $0x0,(%eax)
int parse_arg(char *buf){

	argc = 0;
	argv[argc] = 0;
	while (1) {
		while (*buf && strchr(WHITESPACE, *buf))
 80482be:	8b 45 08             	mov    0x8(%ebp),%eax
 80482c1:	0f b6 00             	movzbl (%eax),%eax
 80482c4:	84 c0                	test   %al,%al
 80482c6:	74 1b                	je     80482e3 <parse_arg+0x53>
 80482c8:	8b 45 08             	mov    0x8(%ebp),%eax
 80482cb:	0f b6 00             	movzbl (%eax),%eax
 80482ce:	0f be c0             	movsbl %al,%eax
 80482d1:	50                   	push   %eax
 80482d2:	68 7c 8c 04 08       	push   $0x8048c7c
 80482d7:	e8 81 ff ff ff       	call   804825d <strchr>
 80482dc:	83 c4 08             	add    $0x8,%esp
 80482df:	85 c0                	test   %eax,%eax
 80482e1:	75 cf                	jne    80482b2 <parse_arg+0x22>
			*buf++ = 0;
		if (*buf == 0)
 80482e3:	8b 45 08             	mov    0x8(%ebp),%eax
 80482e6:	0f b6 00             	movzbl (%eax),%eax
 80482e9:	84 c0                	test   %al,%al
 80482eb:	75 18                	jne    8048305 <parse_arg+0x75>
			break;
 80482ed:	90                   	nop
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
 80482ee:	a1 40 a9 04 08       	mov    0x804a940,%eax
 80482f3:	c7 04 85 00 a9 04 08 	movl   $0x0,0x804a900(,%eax,4)
 80482fa:	00 00 00 00 
	return 1;
 80482fe:	b8 01 00 00 00       	mov    $0x1,%eax
 8048303:	eb 6e                	jmp    8048373 <parse_arg+0xe3>
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		if (argc == MAXARGS-1) {
 8048305:	a1 40 a9 04 08       	mov    0x804a940,%eax
 804830a:	83 f8 0f             	cmp    $0xf,%eax
 804830d:	75 19                	jne    8048328 <parse_arg+0x98>
			printf("Too many arguments (max %d)\n", MAXARGS);
 804830f:	83 ec 08             	sub    $0x8,%esp
 8048312:	6a 10                	push   $0x10
 8048314:	68 81 8c 04 08       	push   $0x8048c81
 8048319:	e8 39 09 00 00       	call   8048c57 <printf>
 804831e:	83 c4 10             	add    $0x10,%esp
			return 0;
 8048321:	b8 00 00 00 00       	mov    $0x0,%eax
 8048326:	eb 4b                	jmp    8048373 <parse_arg+0xe3>
		}
		argv[argc++] = buf;
 8048328:	a1 40 a9 04 08       	mov    0x804a940,%eax
 804832d:	8d 50 01             	lea    0x1(%eax),%edx
 8048330:	89 15 40 a9 04 08    	mov    %edx,0x804a940
 8048336:	8b 55 08             	mov    0x8(%ebp),%edx
 8048339:	89 14 85 00 a9 04 08 	mov    %edx,0x804a900(,%eax,4)
		while (*buf && !strchr(WHITESPACE, *buf))
 8048340:	eb 04                	jmp    8048346 <parse_arg+0xb6>
			buf++;
 8048342:	83 45 08 01          	addl   $0x1,0x8(%ebp)
		if (argc == MAXARGS-1) {
			printf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
 8048346:	8b 45 08             	mov    0x8(%ebp),%eax
 8048349:	0f b6 00             	movzbl (%eax),%eax
 804834c:	84 c0                	test   %al,%al
 804834e:	74 1e                	je     804836e <parse_arg+0xde>
 8048350:	8b 45 08             	mov    0x8(%ebp),%eax
 8048353:	0f b6 00             	movzbl (%eax),%eax
 8048356:	0f be c0             	movsbl %al,%eax
 8048359:	83 ec 08             	sub    $0x8,%esp
 804835c:	50                   	push   %eax
 804835d:	68 7c 8c 04 08       	push   $0x8048c7c
 8048362:	e8 f6 fe ff ff       	call   804825d <strchr>
 8048367:	83 c4 10             	add    $0x10,%esp
 804836a:	85 c0                	test   %eax,%eax
 804836c:	74 d4                	je     8048342 <parse_arg+0xb2>
			buf++;
	}
 804836e:	e9 3d ff ff ff       	jmp    80482b0 <parse_arg+0x20>
	argv[argc] = 0;
	return 1;
}
 8048373:	c9                   	leave  
 8048374:	c3                   	ret    

08048375 <exist_arg>:

int exist_arg(char *arg){
 8048375:	55                   	push   %ebp
 8048376:	89 e5                	mov    %esp,%ebp
 8048378:	83 ec 10             	sub    $0x10,%esp
	int i = 0;
 804837b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (i = 1; i < argc; ++i)
 8048382:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
 8048389:	eb 23                	jmp    80483ae <exist_arg+0x39>
	{
		if(!strcmp(argv[i], arg)) return i;
 804838b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804838e:	8b 04 85 00 a9 04 08 	mov    0x804a900(,%eax,4),%eax
 8048395:	ff 75 08             	pushl  0x8(%ebp)
 8048398:	50                   	push   %eax
 8048399:	e8 21 fe ff ff       	call   80481bf <strcmp>
 804839e:	83 c4 08             	add    $0x8,%esp
 80483a1:	85 c0                	test   %eax,%eax
 80483a3:	75 05                	jne    80483aa <exist_arg+0x35>
 80483a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80483a8:	eb 13                	jmp    80483bd <exist_arg+0x48>
	return 1;
}

int exist_arg(char *arg){
	int i = 0;
	for (i = 1; i < argc; ++i)
 80483aa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 80483ae:	a1 40 a9 04 08       	mov    0x804a940,%eax
 80483b3:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 80483b6:	7c d3                	jl     804838b <exist_arg+0x16>
	{
		if(!strcmp(argv[i], arg)) return i;
	};
	return 0;
 80483b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80483bd:	c9                   	leave  
 80483be:	c3                   	ret    

080483bf <ls>:
void ls(){
 80483bf:	55                   	push   %ebp
 80483c0:	89 e5                	mov    %esp,%ebp
 80483c2:	83 ec 10             	sub    $0x10,%esp
	uint32_t mask = 0;
 80483c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	if(exist_arg("-l"))
 80483cc:	68 9e 8c 04 08       	push   $0x8048c9e
 80483d1:	e8 9f ff ff ff       	call   8048375 <exist_arg>
 80483d6:	83 c4 04             	add    $0x4,%esp
 80483d9:	85 c0                	test   %eax,%eax
 80483db:	74 04                	je     80483e1 <ls+0x22>
		mask |= 0x01;
 80483dd:	83 4d fc 01          	orl    $0x1,-0x4(%ebp)
	if(exist_arg("-a"))
 80483e1:	68 a1 8c 04 08       	push   $0x8048ca1
 80483e6:	e8 8a ff ff ff       	call   8048375 <exist_arg>
 80483eb:	83 c4 04             	add    $0x4,%esp
 80483ee:	85 c0                	test   %eax,%eax
 80483f0:	74 04                	je     80483f6 <ls+0x37>
		mask |= 0x02;
 80483f2:	83 4d fc 02          	orl    $0x2,-0x4(%ebp)
	if(exist_arg("-h"))
 80483f6:	68 a4 8c 04 08       	push   $0x8048ca4
 80483fb:	e8 75 ff ff ff       	call   8048375 <exist_arg>
 8048400:	83 c4 04             	add    $0x4,%esp
 8048403:	85 c0                	test   %eax,%eax
 8048405:	74 04                	je     804840b <ls+0x4c>
		mask |= 0x04;
 8048407:	83 4d fc 04          	orl    $0x4,-0x4(%ebp)
	sys_fs_ls(mask);
 804840b:	ff 75 fc             	pushl  -0x4(%ebp)
 804840e:	e8 a7 fc ff ff       	call   80480ba <sys_fs_ls>
 8048413:	83 c4 04             	add    $0x4,%esp
}
 8048416:	c9                   	leave  
 8048417:	c3                   	ret    

08048418 <echo>:
void echo(){
 8048418:	55                   	push   %ebp
 8048419:	89 e5                	mov    %esp,%ebp
 804841b:	83 ec 38             	sub    $0x38,%esp
	int red = exist_arg(">");
 804841e:	68 a7 8c 04 08       	push   $0x8048ca7
 8048423:	e8 4d ff ff ff       	call   8048375 <exist_arg>
 8048428:	83 c4 04             	add    $0x4,%esp
 804842b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int app = exist_arg(">>");
 804842e:	68 a9 8c 04 08       	push   $0x8048ca9
 8048433:	e8 3d ff ff ff       	call   8048375 <exist_arg>
 8048438:	83 c4 04             	add    $0x4,%esp
 804843b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(red){
 804843e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8048442:	74 64                	je     80484a8 <echo+0x90>
		char* buf = b + 5;
 8048444:	c7 45 e8 05 a5 04 08 	movl   $0x804a505,-0x18(%ebp)
		int len = strfind(buf, '>') - buf - 1;
 804844b:	6a 3e                	push   $0x3e
 804844d:	ff 75 e8             	pushl  -0x18(%ebp)
 8048450:	e8 da fd ff ff       	call   804822f <strfind>
 8048455:	83 c4 08             	add    $0x8,%esp
 8048458:	89 c2                	mov    %eax,%edx
 804845a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804845d:	29 c2                	sub    %eax,%edx
 804845f:	89 d0                	mov    %edx,%eax
 8048461:	83 e8 01             	sub    $0x1,%eax
 8048464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		char* filename = argv[red + 1];
 8048467:	8b 45 f0             	mov    -0x10(%ebp),%eax
 804846a:	83 c0 01             	add    $0x1,%eax
 804846d:	8b 04 85 00 a9 04 08 	mov    0x804a900(,%eax,4),%eax
 8048474:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int fd = open(filename, FS_RWD);
 8048477:	6a 02                	push   $0x2
 8048479:	ff 75 e0             	pushl  -0x20(%ebp)
 804847c:	e8 4c fc ff ff       	call   80480cd <sys_fs_open>
 8048481:	83 c4 08             	add    $0x8,%esp
 8048484:	89 45 dc             	mov    %eax,-0x24(%ebp)
		write(fd, buf, len);
 8048487:	ff 75 e4             	pushl  -0x1c(%ebp)
 804848a:	ff 75 e8             	pushl  -0x18(%ebp)
 804848d:	ff 75 dc             	pushl  -0x24(%ebp)
 8048490:	e8 7d fc ff ff       	call   8048112 <sys_fs_write>
 8048495:	83 c4 0c             	add    $0xc,%esp
		close(fd);
 8048498:	ff 75 dc             	pushl  -0x24(%ebp)
 804849b:	e8 b8 fc ff ff       	call   8048158 <sys_fs_close>
 80484a0:	83 c4 04             	add    $0x4,%esp
		return;
 80484a3:	e9 dc 00 00 00       	jmp    8048584 <echo+0x16c>
	}
	if(app){
 80484a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80484ac:	74 70                	je     804851e <echo+0x106>
		char* buf = b + 5;
 80484ae:	c7 45 d8 05 a5 04 08 	movl   $0x804a505,-0x28(%ebp)
		int len = strfind(buf, '>') - buf - 1;
 80484b5:	6a 3e                	push   $0x3e
 80484b7:	ff 75 d8             	pushl  -0x28(%ebp)
 80484ba:	e8 70 fd ff ff       	call   804822f <strfind>
 80484bf:	83 c4 08             	add    $0x8,%esp
 80484c2:	89 c2                	mov    %eax,%edx
 80484c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80484c7:	29 c2                	sub    %eax,%edx
 80484c9:	89 d0                	mov    %edx,%eax
 80484cb:	83 e8 01             	sub    $0x1,%eax
 80484ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		char* filename = argv[app + 1];
 80484d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80484d4:	83 c0 01             	add    $0x1,%eax
 80484d7:	8b 04 85 00 a9 04 08 	mov    0x804a900(,%eax,4),%eax
 80484de:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int fd = open(filename, FS_RWC);
 80484e1:	6a 01                	push   $0x1
 80484e3:	ff 75 d0             	pushl  -0x30(%ebp)
 80484e6:	e8 e2 fb ff ff       	call   80480cd <sys_fs_open>
 80484eb:	83 c4 08             	add    $0x8,%esp
 80484ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
		lseek(fd, 0, SEEK_END);
 80484f1:	6a 02                	push   $0x2
 80484f3:	6a 00                	push   $0x0
 80484f5:	ff 75 cc             	pushl  -0x34(%ebp)
 80484f8:	e8 38 fc ff ff       	call   8048135 <sys_fs_lseek>
 80484fd:	83 c4 0c             	add    $0xc,%esp
		write(fd, buf, len);
 8048500:	ff 75 d4             	pushl  -0x2c(%ebp)
 8048503:	ff 75 d8             	pushl  -0x28(%ebp)
 8048506:	ff 75 cc             	pushl  -0x34(%ebp)
 8048509:	e8 04 fc ff ff       	call   8048112 <sys_fs_write>
 804850e:	83 c4 0c             	add    $0xc,%esp
		close(fd);
 8048511:	ff 75 cc             	pushl  -0x34(%ebp)
 8048514:	e8 3f fc ff ff       	call   8048158 <sys_fs_close>
 8048519:	83 c4 04             	add    $0x4,%esp
		return;
 804851c:	eb 66                	jmp    8048584 <echo+0x16c>
	}
	int i=0;
 804851e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i=1; i < argc; ++i)
 8048525:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 804852c:	eb 3c                	jmp    804856a <echo+0x152>
	{
		printf("%s", argv[i]);
 804852e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048531:	8b 04 85 00 a9 04 08 	mov    0x804a900(,%eax,4),%eax
 8048538:	83 ec 08             	sub    $0x8,%esp
 804853b:	50                   	push   %eax
 804853c:	68 ac 8c 04 08       	push   $0x8048cac
 8048541:	e8 11 07 00 00       	call   8048c57 <printf>
 8048546:	83 c4 10             	add    $0x10,%esp
		if(i != argc-1){
 8048549:	a1 40 a9 04 08       	mov    0x804a940,%eax
 804854e:	83 e8 01             	sub    $0x1,%eax
 8048551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8048554:	74 10                	je     8048566 <echo+0x14e>
			printf(" ");
 8048556:	83 ec 0c             	sub    $0xc,%esp
 8048559:	68 af 8c 04 08       	push   $0x8048caf
 804855e:	e8 f4 06 00 00       	call   8048c57 <printf>
 8048563:	83 c4 10             	add    $0x10,%esp
		write(fd, buf, len);
		close(fd);
		return;
	}
	int i=0;
	for (i=1; i < argc; ++i)
 8048566:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804856a:	a1 40 a9 04 08       	mov    0x804a940,%eax
 804856f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8048572:	7c ba                	jl     804852e <echo+0x116>
		printf("%s", argv[i]);
		if(i != argc-1){
			printf(" ");
		}
	}
	printf("\n");
 8048574:	83 ec 0c             	sub    $0xc,%esp
 8048577:	68 b1 8c 04 08       	push   $0x8048cb1
 804857c:	e8 d6 06 00 00       	call   8048c57 <printf>
 8048581:	83 c4 10             	add    $0x10,%esp

}
 8048584:	c9                   	leave  
 8048585:	c3                   	ret    

08048586 <cat>:
void cat(){
 8048586:	55                   	push   %ebp
 8048587:	89 e5                	mov    %esp,%ebp
 8048589:	81 ec 38 04 00 00    	sub    $0x438,%esp
	char* filename = argv[1];
 804858f:	a1 04 a9 04 08       	mov    0x804a904,%eax
 8048594:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int fd = open(filename, FS_RW);
 8048597:	6a 00                	push   $0x0
 8048599:	ff 75 f4             	pushl  -0xc(%ebp)
 804859c:	e8 2c fb ff ff       	call   80480cd <sys_fs_open>
 80485a1:	83 c4 08             	add    $0x8,%esp
 80485a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(fd == -1)
 80485a7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 80485ab:	75 13                	jne    80485c0 <cat+0x3a>
		printf("%s doesn't exist\n", filename);
 80485ad:	83 ec 08             	sub    $0x8,%esp
 80485b0:	ff 75 f4             	pushl  -0xc(%ebp)
 80485b3:	68 b3 8c 04 08       	push   $0x8048cb3
 80485b8:	e8 9a 06 00 00       	call   8048c57 <printf>
 80485bd:	83 c4 10             	add    $0x10,%esp
	char buf[1024];
	memset2(buf, 0, 1024);
 80485c0:	83 ec 04             	sub    $0x4,%esp
 80485c3:	68 00 04 00 00       	push   $0x400
 80485c8:	6a 00                	push   $0x0
 80485ca:	8d 85 d0 fb ff ff    	lea    -0x430(%ebp),%eax
 80485d0:	50                   	push   %eax
 80485d1:	e8 d0 fb ff ff       	call   80481a6 <memset2>
 80485d6:	83 c4 10             	add    $0x10,%esp
	int red = exist_arg(">");
 80485d9:	83 ec 0c             	sub    $0xc,%esp
 80485dc:	68 a7 8c 04 08       	push   $0x8048ca7
 80485e1:	e8 8f fd ff ff       	call   8048375 <exist_arg>
 80485e6:	83 c4 10             	add    $0x10,%esp
 80485e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int app = exist_arg(">>");
 80485ec:	83 ec 0c             	sub    $0xc,%esp
 80485ef:	68 a9 8c 04 08       	push   $0x8048ca9
 80485f4:	e8 7c fd ff ff       	call   8048375 <exist_arg>
 80485f9:	83 c4 10             	add    $0x10,%esp
 80485fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if(red){
 80485ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048603:	0f 84 88 00 00 00    	je     8048691 <cat+0x10b>
		char* ofilename = argv[red + 1];
 8048609:	8b 45 ec             	mov    -0x14(%ebp),%eax
 804860c:	83 c0 01             	add    $0x1,%eax
 804860f:	8b 04 85 00 a9 04 08 	mov    0x804a900(,%eax,4),%eax
 8048616:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int out = open(ofilename, FS_RWD);
 8048619:	83 ec 08             	sub    $0x8,%esp
 804861c:	6a 02                	push   $0x2
 804861e:	ff 75 d8             	pushl  -0x28(%ebp)
 8048621:	e8 a7 fa ff ff       	call   80480cd <sys_fs_open>
 8048626:	83 c4 10             	add    $0x10,%esp
 8048629:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int l = 0;
 804862c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		while((l = read(fd, buf, 1024)) != -1)
 8048633:	eb 18                	jmp    804864d <cat+0xc7>
			write(out, buf, l);
 8048635:	83 ec 04             	sub    $0x4,%esp
 8048638:	ff 75 d0             	pushl  -0x30(%ebp)
 804863b:	8d 85 d0 fb ff ff    	lea    -0x430(%ebp),%eax
 8048641:	50                   	push   %eax
 8048642:	ff 75 d4             	pushl  -0x2c(%ebp)
 8048645:	e8 c8 fa ff ff       	call   8048112 <sys_fs_write>
 804864a:	83 c4 10             	add    $0x10,%esp
	int app = exist_arg(">>");
	if(red){
		char* ofilename = argv[red + 1];
		int out = open(ofilename, FS_RWD);
		int l = 0;
		while((l = read(fd, buf, 1024)) != -1)
 804864d:	83 ec 04             	sub    $0x4,%esp
 8048650:	68 00 04 00 00       	push   $0x400
 8048655:	8d 85 d0 fb ff ff    	lea    -0x430(%ebp),%eax
 804865b:	50                   	push   %eax
 804865c:	ff 75 f0             	pushl  -0x10(%ebp)
 804865f:	e8 8b fa ff ff       	call   80480ef <sys_fs_read>
 8048664:	83 c4 10             	add    $0x10,%esp
 8048667:	89 45 d0             	mov    %eax,-0x30(%ebp)
 804866a:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
 804866e:	75 c5                	jne    8048635 <cat+0xaf>
			write(out, buf, l);
		close(out);
 8048670:	83 ec 0c             	sub    $0xc,%esp
 8048673:	ff 75 d4             	pushl  -0x2c(%ebp)
 8048676:	e8 dd fa ff ff       	call   8048158 <sys_fs_close>
 804867b:	83 c4 10             	add    $0x10,%esp
		close(fd);
 804867e:	83 ec 0c             	sub    $0xc,%esp
 8048681:	ff 75 f0             	pushl  -0x10(%ebp)
 8048684:	e8 cf fa ff ff       	call   8048158 <sys_fs_close>
 8048689:	83 c4 10             	add    $0x10,%esp
		return;
 804868c:	e9 e7 00 00 00       	jmp    8048778 <cat+0x1f2>
	}
	if(app){
 8048691:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 8048695:	0f 84 97 00 00 00    	je     8048732 <cat+0x1ac>
		char* ofilename = argv[app + 1];
 804869b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804869e:	83 c0 01             	add    $0x1,%eax
 80486a1:	8b 04 85 00 a9 04 08 	mov    0x804a900(,%eax,4),%eax
 80486a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int out = open(ofilename, FS_RWC);
 80486ab:	83 ec 08             	sub    $0x8,%esp
 80486ae:	6a 01                	push   $0x1
 80486b0:	ff 75 e4             	pushl  -0x1c(%ebp)
 80486b3:	e8 15 fa ff ff       	call   80480cd <sys_fs_open>
 80486b8:	83 c4 10             	add    $0x10,%esp
 80486bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		lseek(out, 0, SEEK_END);
 80486be:	83 ec 04             	sub    $0x4,%esp
 80486c1:	6a 02                	push   $0x2
 80486c3:	6a 00                	push   $0x0
 80486c5:	ff 75 e0             	pushl  -0x20(%ebp)
 80486c8:	e8 68 fa ff ff       	call   8048135 <sys_fs_lseek>
 80486cd:	83 c4 10             	add    $0x10,%esp
		int l = 0;
 80486d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		while((l = read(fd, buf, 1024)) != -1)
 80486d7:	eb 18                	jmp    80486f1 <cat+0x16b>
			write(out, buf, l);
 80486d9:	83 ec 04             	sub    $0x4,%esp
 80486dc:	ff 75 dc             	pushl  -0x24(%ebp)
 80486df:	8d 85 d0 fb ff ff    	lea    -0x430(%ebp),%eax
 80486e5:	50                   	push   %eax
 80486e6:	ff 75 e0             	pushl  -0x20(%ebp)
 80486e9:	e8 24 fa ff ff       	call   8048112 <sys_fs_write>
 80486ee:	83 c4 10             	add    $0x10,%esp
	if(app){
		char* ofilename = argv[app + 1];
		int out = open(ofilename, FS_RWC);
		lseek(out, 0, SEEK_END);
		int l = 0;
		while((l = read(fd, buf, 1024)) != -1)
 80486f1:	83 ec 04             	sub    $0x4,%esp
 80486f4:	68 00 04 00 00       	push   $0x400
 80486f9:	8d 85 d0 fb ff ff    	lea    -0x430(%ebp),%eax
 80486ff:	50                   	push   %eax
 8048700:	ff 75 f0             	pushl  -0x10(%ebp)
 8048703:	e8 e7 f9 ff ff       	call   80480ef <sys_fs_read>
 8048708:	83 c4 10             	add    $0x10,%esp
 804870b:	89 45 dc             	mov    %eax,-0x24(%ebp)
 804870e:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
 8048712:	75 c5                	jne    80486d9 <cat+0x153>
			write(out, buf, l);
		close(out);
 8048714:	83 ec 0c             	sub    $0xc,%esp
 8048717:	ff 75 e0             	pushl  -0x20(%ebp)
 804871a:	e8 39 fa ff ff       	call   8048158 <sys_fs_close>
 804871f:	83 c4 10             	add    $0x10,%esp
		close(fd);
 8048722:	83 ec 0c             	sub    $0xc,%esp
 8048725:	ff 75 f0             	pushl  -0x10(%ebp)
 8048728:	e8 2b fa ff ff       	call   8048158 <sys_fs_close>
 804872d:	83 c4 10             	add    $0x10,%esp
		return;
 8048730:	eb 46                	jmp    8048778 <cat+0x1f2>
	}
	while(read(fd, buf, 1024) != -1)
 8048732:	eb 17                	jmp    804874b <cat+0x1c5>
		printf("%s\n", buf);
 8048734:	83 ec 08             	sub    $0x8,%esp
 8048737:	8d 85 d0 fb ff ff    	lea    -0x430(%ebp),%eax
 804873d:	50                   	push   %eax
 804873e:	68 c5 8c 04 08       	push   $0x8048cc5
 8048743:	e8 0f 05 00 00       	call   8048c57 <printf>
 8048748:	83 c4 10             	add    $0x10,%esp
			write(out, buf, l);
		close(out);
		close(fd);
		return;
	}
	while(read(fd, buf, 1024) != -1)
 804874b:	83 ec 04             	sub    $0x4,%esp
 804874e:	68 00 04 00 00       	push   $0x400
 8048753:	8d 85 d0 fb ff ff    	lea    -0x430(%ebp),%eax
 8048759:	50                   	push   %eax
 804875a:	ff 75 f0             	pushl  -0x10(%ebp)
 804875d:	e8 8d f9 ff ff       	call   80480ef <sys_fs_read>
 8048762:	83 c4 10             	add    $0x10,%esp
 8048765:	83 f8 ff             	cmp    $0xffffffff,%eax
 8048768:	75 ca                	jne    8048734 <cat+0x1ae>
		printf("%s\n", buf);
	close(fd);
 804876a:	83 ec 0c             	sub    $0xc,%esp
 804876d:	ff 75 f0             	pushl  -0x10(%ebp)
 8048770:	e8 e3 f9 ff ff       	call   8048158 <sys_fs_close>
 8048775:	83 c4 10             	add    $0x10,%esp
}
 8048778:	c9                   	leave  
 8048779:	c3                   	ret    

0804877a <do_shell>:
void do_shell(){
 804877a:	55                   	push   %ebp
 804877b:	89 e5                	mov    %esp,%ebp
 804877d:	83 ec 18             	sub    $0x18,%esp
	char *cmd = argv[0];
 8048780:	a1 00 a9 04 08       	mov    0x804a900,%eax
 8048785:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(!strcmp(cmd, "ls")){
 8048788:	68 c9 8c 04 08       	push   $0x8048cc9
 804878d:	ff 75 f4             	pushl  -0xc(%ebp)
 8048790:	e8 2a fa ff ff       	call   80481bf <strcmp>
 8048795:	83 c4 08             	add    $0x8,%esp
 8048798:	85 c0                	test   %eax,%eax
 804879a:	75 0a                	jne    80487a6 <do_shell+0x2c>
		ls();
 804879c:	e8 1e fc ff ff       	call   80483bf <ls>
		return;
 80487a1:	e9 92 00 00 00       	jmp    8048838 <do_shell+0xbe>
	}
	if(!strcmp(cmd, "echo")){
 80487a6:	68 cc 8c 04 08       	push   $0x8048ccc
 80487ab:	ff 75 f4             	pushl  -0xc(%ebp)
 80487ae:	e8 0c fa ff ff       	call   80481bf <strcmp>
 80487b3:	83 c4 08             	add    $0x8,%esp
 80487b6:	85 c0                	test   %eax,%eax
 80487b8:	75 07                	jne    80487c1 <do_shell+0x47>
		echo();
 80487ba:	e8 59 fc ff ff       	call   8048418 <echo>
		return;
 80487bf:	eb 77                	jmp    8048838 <do_shell+0xbe>
	}
	if(!strcmp(cmd, "cat")){
 80487c1:	83 ec 08             	sub    $0x8,%esp
 80487c4:	68 d1 8c 04 08       	push   $0x8048cd1
 80487c9:	ff 75 f4             	pushl  -0xc(%ebp)
 80487cc:	e8 ee f9 ff ff       	call   80481bf <strcmp>
 80487d1:	83 c4 10             	add    $0x10,%esp
 80487d4:	85 c0                	test   %eax,%eax
 80487d6:	75 07                	jne    80487df <do_shell+0x65>
		cat();
 80487d8:	e8 a9 fd ff ff       	call   8048586 <cat>
		return;
 80487dd:	eb 59                	jmp    8048838 <do_shell+0xbe>
	}

	int fd = open(cmd, FS_RW);
 80487df:	83 ec 08             	sub    $0x8,%esp
 80487e2:	6a 00                	push   $0x0
 80487e4:	ff 75 f4             	pushl  -0xc(%ebp)
 80487e7:	e8 e1 f8 ff ff       	call   80480cd <sys_fs_open>
 80487ec:	83 c4 10             	add    $0x10,%esp
 80487ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(fd == -1){
 80487f2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 80487f6:	75 15                	jne    804880d <do_shell+0x93>
		printf("%s is not an command \n", cmd);
 80487f8:	83 ec 08             	sub    $0x8,%esp
 80487fb:	ff 75 f4             	pushl  -0xc(%ebp)
 80487fe:	68 d5 8c 04 08       	push   $0x8048cd5
 8048803:	e8 4f 04 00 00       	call   8048c57 <printf>
 8048808:	83 c4 10             	add    $0x10,%esp
 804880b:	eb 2b                	jmp    8048838 <do_shell+0xbe>
	}
	else{
		int p = fork();
 804880d:	e8 65 f9 ff ff       	call   8048177 <sys_fork>
 8048812:	89 45 ec             	mov    %eax,-0x14(%ebp)
		//printf("ffff %d\n", p);
		if(p == 0){
 8048815:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048819:	75 0e                	jne    8048829 <do_shell+0xaf>
			sys_exec(cmd);
 804881b:	83 ec 0c             	sub    $0xc,%esp
 804881e:	ff 75 f4             	pushl  -0xc(%ebp)
 8048821:	e8 6e f8 ff ff       	call   8048094 <sys_exec>
 8048826:	83 c4 10             	add    $0x10,%esp
			//exit();
		}
		process_join(p);
 8048829:	83 ec 0c             	sub    $0xc,%esp
 804882c:	ff 75 ec             	pushl  -0x14(%ebp)
 804882f:	e8 5f f9 ff ff       	call   8048193 <sys_join>
 8048834:	83 c4 10             	add    $0x10,%esp
		return;
 8048837:	90                   	nop
	}
}
 8048838:	c9                   	leave  
 8048839:	c3                   	ret    

0804883a <main>:
int main(){
 804883a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 804883e:	83 e4 f0             	and    $0xfffffff0,%esp
 8048841:	ff 71 fc             	pushl  -0x4(%ecx)
 8048844:	55                   	push   %ebp
 8048845:	89 e5                	mov    %esp,%ebp
 8048847:	51                   	push   %ecx
 8048848:	83 ec 04             	sub    $0x4,%esp
	printf("This is shell!\n");
 804884b:	83 ec 0c             	sub    $0xc,%esp
 804884e:	68 ec 8c 04 08       	push   $0x8048cec
 8048853:	e8 ff 03 00 00       	call   8048c57 <printf>
 8048858:	83 c4 10             	add    $0x10,%esp
	while(1){
		//printf("1 %s\n", safety);
		creadline(c);
 804885b:	83 ec 0c             	sub    $0xc,%esp
 804885e:	68 80 a9 04 08       	push   $0x804a980
 8048863:	e8 3f f8 ff ff       	call   80480a7 <sys_readline>
 8048868:	83 c4 10             	add    $0x10,%esp
		//printf("2 %s\n", safety);
		strcpy(b, c);
 804886b:	83 ec 08             	sub    $0x8,%esp
 804886e:	68 80 a9 04 08       	push   $0x804a980
 8048873:	68 00 a5 04 08       	push   $0x804a500
 8048878:	e8 81 f9 ff ff       	call   80481fe <strcpy>
 804887d:	83 c4 10             	add    $0x10,%esp
		//printf("3 %s\n", safety);
		parse_arg(c);	
 8048880:	83 ec 0c             	sub    $0xc,%esp
 8048883:	68 80 a9 04 08       	push   $0x804a980
 8048888:	e8 03 fa ff ff       	call   8048290 <parse_arg>
 804888d:	83 c4 10             	add    $0x10,%esp
		do_shell();
 8048890:	e8 e5 fe ff ff       	call   804877a <do_shell>
	}
 8048895:	eb c4                	jmp    804885b <main+0x21>

08048897 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 8048897:	55                   	push   %ebp
 8048898:	89 e5                	mov    %esp,%ebp
 804889a:	53                   	push   %ebx
 804889b:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 804889e:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 80488a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 80488ac:	a1 c0 a4 04 08       	mov    0x804a4c0,%eax
 80488b1:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 80488b7:	05 39 30 00 00       	add    $0x3039,%eax
 80488bc:	a3 c0 a4 04 08       	mov    %eax,0x804a4c0
    y ^= (y<<13);   
 80488c1:	a1 c4 a4 04 08       	mov    0x804a4c4,%eax
 80488c6:	c1 e0 0d             	shl    $0xd,%eax
 80488c9:	89 c2                	mov    %eax,%edx
 80488cb:	a1 c4 a4 04 08       	mov    0x804a4c4,%eax
 80488d0:	31 d0                	xor    %edx,%eax
 80488d2:	a3 c4 a4 04 08       	mov    %eax,0x804a4c4
    y ^= (y>>17);   
 80488d7:	a1 c4 a4 04 08       	mov    0x804a4c4,%eax
 80488dc:	c1 e8 11             	shr    $0x11,%eax
 80488df:	89 c2                	mov    %eax,%edx
 80488e1:	a1 c4 a4 04 08       	mov    0x804a4c4,%eax
 80488e6:	31 d0                	xor    %edx,%eax
 80488e8:	a3 c4 a4 04 08       	mov    %eax,0x804a4c4
    y ^= (y<<5);    
 80488ed:	a1 c4 a4 04 08       	mov    0x804a4c4,%eax
 80488f2:	c1 e0 05             	shl    $0x5,%eax
 80488f5:	89 c2                	mov    %eax,%edx
 80488f7:	a1 c4 a4 04 08       	mov    0x804a4c4,%eax
 80488fc:	31 d0                	xor    %edx,%eax
 80488fe:	a3 c4 a4 04 08       	mov    %eax,0x804a4c4
      
    t = (A*z + c);  
 8048903:	a1 c8 a4 04 08       	mov    0x804a4c8,%eax
 8048908:	ba 00 00 00 00       	mov    $0x0,%edx
 804890d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 8048910:	89 cb                	mov    %ecx,%ebx
 8048912:	0f af da             	imul   %edx,%ebx
 8048915:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8048918:	0f af c8             	imul   %eax,%ecx
 804891b:	01 d9                	add    %ebx,%ecx
 804891d:	f7 65 f0             	mull   -0x10(%ebp)
 8048920:	01 d1                	add    %edx,%ecx
 8048922:	89 ca                	mov    %ecx,%edx
 8048924:	8b 0d cc a4 04 08    	mov    0x804a4cc,%ecx
 804892a:	bb 00 00 00 00       	mov    $0x0,%ebx
 804892f:	01 c8                	add    %ecx,%eax
 8048931:	11 da                	adc    %ebx,%edx
 8048933:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048936:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 8048939:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804893c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804893f:	89 d0                	mov    %edx,%eax
 8048941:	31 d2                	xor    %edx,%edx
 8048943:	a3 cc a4 04 08       	mov    %eax,0x804a4cc
    z = t;  
 8048948:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804894b:	a3 c8 a4 04 08       	mov    %eax,0x804a4c8
       
    return x+y+z;    
 8048950:	8b 15 c0 a4 04 08    	mov    0x804a4c0,%edx
 8048956:	a1 c4 a4 04 08       	mov    0x804a4c4,%eax
 804895b:	01 c2                	add    %eax,%edx
 804895d:	a1 c8 a4 04 08       	mov    0x804a4c8,%eax
 8048962:	01 d0                	add    %edx,%eax
 8048964:	83 c4 14             	add    $0x14,%esp
 8048967:	5b                   	pop    %ebx
 8048968:	5d                   	pop    %ebp
 8048969:	c3                   	ret    

0804896a <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 804896a:	55                   	push   %ebp
 804896b:	89 e5                	mov    %esp,%ebp
 804896d:	53                   	push   %ebx
 804896e:	83 ec 04             	sub    $0x4,%esp
 8048971:	8b 45 08             	mov    0x8(%ebp),%eax
 8048974:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 8048977:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 804897c:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 8048980:	89 d3                	mov    %edx,%ebx
 8048982:	cd 80                	int    $0x80
}
 8048984:	83 c4 04             	add    $0x4,%esp
 8048987:	5b                   	pop    %ebx
 8048988:	5d                   	pop    %ebp
 8048989:	c3                   	ret    

0804898a <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 804898a:	55                   	push   %ebp
 804898b:	89 e5                	mov    %esp,%ebp
 804898d:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 8048990:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 8048996:	eb 19                	jmp    80489b1 <printp+0x27>
		printer(cur);
 8048998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804899b:	0f b6 00             	movzbl (%eax),%eax
 804899e:	0f be c0             	movsbl %al,%eax
 80489a1:	83 ec 0c             	sub    $0xc,%esp
 80489a4:	50                   	push   %eax
 80489a5:	8b 45 08             	mov    0x8(%ebp),%eax
 80489a8:	ff d0                	call   *%eax
 80489aa:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80489ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80489b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489b4:	0f b6 00             	movzbl (%eax),%eax
 80489b7:	84 c0                	test   %al,%al
 80489b9:	75 dd                	jne    8048998 <printp+0xe>
		printer(cur);
	}
}
 80489bb:	c9                   	leave  
 80489bc:	c3                   	ret    

080489bd <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 80489bd:	55                   	push   %ebp
 80489be:	89 e5                	mov    %esp,%ebp
 80489c0:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 80489c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 80489c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 80489c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 80489d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 80489d7:	8b 45 10             	mov    0x10(%ebp),%eax
 80489da:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 80489dd:	e9 65 02 00 00       	jmp    8048c47 <vfprintf+0x28a>

		if(cur == '%'){
 80489e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489e5:	0f b6 00             	movzbl (%eax),%eax
 80489e8:	3c 25                	cmp    $0x25,%al
 80489ea:	75 0c                	jne    80489f8 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 80489ec:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 80489f3:	e9 4b 02 00 00       	jmp    8048c43 <vfprintf+0x286>
		}
		if(type == READ){
 80489f8:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80489fc:	0f 85 26 02 00 00    	jne    8048c28 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 8048a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a05:	0f b6 00             	movzbl (%eax),%eax
 8048a08:	3c 73                	cmp    $0x73,%al
 8048a0a:	75 35                	jne    8048a41 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 8048a0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048a0f:	8b 00                	mov    (%eax),%eax
 8048a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 8048a14:	eb 19                	jmp    8048a2f <vfprintf+0x72>
					printer(*p);
 8048a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048a19:	0f b6 00             	movzbl (%eax),%eax
 8048a1c:	0f be c0             	movsbl %al,%eax
 8048a1f:	83 ec 0c             	sub    $0xc,%esp
 8048a22:	50                   	push   %eax
 8048a23:	8b 45 08             	mov    0x8(%ebp),%eax
 8048a26:	ff d0                	call   *%eax
 8048a28:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 8048a2b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 8048a2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048a32:	0f b6 00             	movzbl (%eax),%eax
 8048a35:	84 c0                	test   %al,%al
 8048a37:	75 dd                	jne    8048a16 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 8048a39:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048a3d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 8048a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a44:	0f b6 00             	movzbl (%eax),%eax
 8048a47:	3c 78                	cmp    $0x78,%al
 8048a49:	0f 85 99 00 00 00    	jne    8048ae8 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048a4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048a52:	8b 00                	mov    (%eax),%eax
 8048a54:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8048a57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048a5b:	75 1d                	jne    8048a7a <vfprintf+0xbd>
					printer('0');
 8048a5d:	83 ec 0c             	sub    $0xc,%esp
 8048a60:	6a 30                	push   $0x30
 8048a62:	8b 45 08             	mov    0x8(%ebp),%eax
 8048a65:	ff d0                	call   *%eax
 8048a67:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048a6a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048a6e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8048a75:	e9 c9 01 00 00       	jmp    8048c43 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 8048a7a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 8048a81:	eb 2d                	jmp    8048ab0 <vfprintf+0xf3>
					int d=(x%16);
 8048a83:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8048a86:	83 e0 0f             	and    $0xf,%eax
 8048a89:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8048a8c:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 8048a90:	7e 04                	jle    8048a96 <vfprintf+0xd9>
						d+='a'-'0'-10;
 8048a92:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 8048a96:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8048a99:	83 c0 30             	add    $0x30,%eax
 8048a9c:	89 c1                	mov    %eax,%ecx
 8048a9e:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048aa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048aa4:	01 d0                	add    %edx,%eax
 8048aa6:	88 08                	mov    %cl,(%eax)
					x>>=4;
 8048aa8:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8048aac:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048ab0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048ab4:	75 cd                	jne    8048a83 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 8048ab6:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8048aba:	eb 1e                	jmp    8048ada <vfprintf+0x11d>
					printer(digits[di]);
 8048abc:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048abf:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048ac2:	01 d0                	add    %edx,%eax
 8048ac4:	0f b6 00             	movzbl (%eax),%eax
 8048ac7:	0f be c0             	movsbl %al,%eax
 8048aca:	83 ec 0c             	sub    $0xc,%esp
 8048acd:	50                   	push   %eax
 8048ace:	8b 45 08             	mov    0x8(%ebp),%eax
 8048ad1:	ff d0                	call   *%eax
 8048ad3:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8048ad6:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8048ada:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8048ade:	79 dc                	jns    8048abc <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048ae0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048ae4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 8048ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048aeb:	0f b6 00             	movzbl (%eax),%eax
 8048aee:	3c 64                	cmp    $0x64,%al
 8048af0:	0f 85 02 01 00 00    	jne    8048bf8 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 8048af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048af9:	8b 00                	mov    (%eax),%eax
 8048afb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 8048afe:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 8048b05:	75 23                	jne    8048b2a <vfprintf+0x16d>
					printp(printer, "-2147483648");
 8048b07:	83 ec 08             	sub    $0x8,%esp
 8048b0a:	68 fc 8c 04 08       	push   $0x8048cfc
 8048b0f:	ff 75 08             	pushl  0x8(%ebp)
 8048b12:	e8 73 fe ff ff       	call   804898a <printp>
 8048b17:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048b1a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048b1e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048b25:	e9 19 01 00 00       	jmp    8048c43 <vfprintf+0x286>
				}
				if(x==0){
 8048b2a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048b2e:	75 1e                	jne    8048b4e <vfprintf+0x191>
					printer('0');
 8048b30:	83 ec 0c             	sub    $0xc,%esp
 8048b33:	6a 30                	push   $0x30
 8048b35:	8b 45 08             	mov    0x8(%ebp),%eax
 8048b38:	ff d0                	call   *%eax
 8048b3a:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048b3d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048b41:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048b48:	90                   	nop
 8048b49:	e9 f5 00 00 00       	jmp    8048c43 <vfprintf+0x286>
				}
				if(x<0){
 8048b4e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048b52:	79 10                	jns    8048b64 <vfprintf+0x1a7>
					printer('-');
 8048b54:	83 ec 0c             	sub    $0xc,%esp
 8048b57:	6a 2d                	push   $0x2d
 8048b59:	8b 45 08             	mov    0x8(%ebp),%eax
 8048b5c:	ff d0                	call   *%eax
 8048b5e:	83 c4 10             	add    $0x10,%esp
					x=-x;
 8048b61:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 8048b64:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8048b6b:	eb 53                	jmp    8048bc0 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 8048b6d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8048b70:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048b75:	89 c8                	mov    %ecx,%eax
 8048b77:	f7 ea                	imul   %edx
 8048b79:	c1 fa 02             	sar    $0x2,%edx
 8048b7c:	89 c8                	mov    %ecx,%eax
 8048b7e:	c1 f8 1f             	sar    $0x1f,%eax
 8048b81:	29 c2                	sub    %eax,%edx
 8048b83:	89 d0                	mov    %edx,%eax
 8048b85:	c1 e0 02             	shl    $0x2,%eax
 8048b88:	01 d0                	add    %edx,%eax
 8048b8a:	01 c0                	add    %eax,%eax
 8048b8c:	29 c1                	sub    %eax,%ecx
 8048b8e:	89 ca                	mov    %ecx,%edx
 8048b90:	89 d0                	mov    %edx,%eax
 8048b92:	83 c0 30             	add    $0x30,%eax
 8048b95:	89 c1                	mov    %eax,%ecx
 8048b97:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048b9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048b9d:	01 d0                	add    %edx,%eax
 8048b9f:	88 08                	mov    %cl,(%eax)
					x/=10;
 8048ba1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8048ba4:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048ba9:	89 c8                	mov    %ecx,%eax
 8048bab:	f7 ea                	imul   %edx
 8048bad:	c1 fa 02             	sar    $0x2,%edx
 8048bb0:	89 c8                	mov    %ecx,%eax
 8048bb2:	c1 f8 1f             	sar    $0x1f,%eax
 8048bb5:	29 c2                	sub    %eax,%edx
 8048bb7:	89 d0                	mov    %edx,%eax
 8048bb9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 8048bbc:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048bc0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048bc4:	7f a7                	jg     8048b6d <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 8048bc6:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 8048bca:	eb 1e                	jmp    8048bea <vfprintf+0x22d>
					printer(digits[di]);
 8048bcc:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048bcf:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048bd2:	01 d0                	add    %edx,%eax
 8048bd4:	0f b6 00             	movzbl (%eax),%eax
 8048bd7:	0f be c0             	movsbl %al,%eax
 8048bda:	83 ec 0c             	sub    $0xc,%esp
 8048bdd:	50                   	push   %eax
 8048bde:	8b 45 08             	mov    0x8(%ebp),%eax
 8048be1:	ff d0                	call   *%eax
 8048be3:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 8048be6:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 8048bea:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8048bee:	79 dc                	jns    8048bcc <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048bf0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048bf4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 8048bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048bfb:	0f b6 00             	movzbl (%eax),%eax
 8048bfe:	3c 63                	cmp    $0x63,%al
 8048c00:	75 1d                	jne    8048c1f <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 8048c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048c05:	0f b6 00             	movzbl (%eax),%eax
 8048c08:	0f be c0             	movsbl %al,%eax
 8048c0b:	83 ec 0c             	sub    $0xc,%esp
 8048c0e:	50                   	push   %eax
 8048c0f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c12:	ff d0                	call   *%eax
 8048c14:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 8048c17:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048c1b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 8048c1f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 8048c26:	eb 1b                	jmp    8048c43 <vfprintf+0x286>
		}
		if(type == NONE){
 8048c28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048c2c:	75 15                	jne    8048c43 <vfprintf+0x286>
			printer(cur);
 8048c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c31:	0f b6 00             	movzbl (%eax),%eax
 8048c34:	0f be c0             	movsbl %al,%eax
 8048c37:	83 ec 0c             	sub    $0xc,%esp
 8048c3a:	50                   	push   %eax
 8048c3b:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c3e:	ff d0                	call   *%eax
 8048c40:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048c43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c4a:	0f b6 00             	movzbl (%eax),%eax
 8048c4d:	84 c0                	test   %al,%al
 8048c4f:	0f 85 8d fd ff ff    	jne    80489e2 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8048c55:	c9                   	leave  
 8048c56:	c3                   	ret    

08048c57 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8048c57:	55                   	push   %ebp
 8048c58:	89 e5                	mov    %esp,%ebp
 8048c5a:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048c5d:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8048c63:	8b 45 08             	mov    0x8(%ebp),%eax
 8048c66:	83 ec 04             	sub    $0x4,%esp
 8048c69:	ff 75 f4             	pushl  -0xc(%ebp)
 8048c6c:	50                   	push   %eax
 8048c6d:	68 6a 89 04 08       	push   $0x804896a
 8048c72:	e8 46 fd ff ff       	call   80489bd <vfprintf>
 8048c77:	83 c4 10             	add    $0x10,%esp
}
 8048c7a:	c9                   	leave  
 8048c7b:	c3                   	ret    
