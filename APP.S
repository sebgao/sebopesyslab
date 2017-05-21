
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <sys_thread>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_thread(void* entry, uint32_t esp){
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_THREAD), "b"(entry), "c"(esp)); //SYSCALL HERE!
 8048098:	b8 e6 05 00 00       	mov    $0x5e6,%eax
 804809d:	8b 55 08             	mov    0x8(%ebp),%edx
 80480a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80480a3:	89 d3                	mov    %edx,%ebx
 80480a5:	cd 80                	int    $0x80
}
 80480a7:	5b                   	pop    %ebx
 80480a8:	5d                   	pop    %ebp
 80480a9:	c3                   	ret    

080480aa <sys_handout>:

static inline void sys_handout(){
 80480aa:	55                   	push   %ebp
 80480ab:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
 80480ad:	b8 dc 05 00 00       	mov    $0x5dc,%eax
 80480b2:	cd 80                	int    $0x80
}
 80480b4:	5d                   	pop    %ebp
 80480b5:	c3                   	ret    

080480b6 <sys_fork>:
static inline void sys_exit(){
	asm volatile("int $0x80": : "a"(SYS_EXIT)); //SYSCALL HERE!
}
static inline uint32_t sys_fork(){
 80480b6:	55                   	push   %ebp
 80480b7:	89 e5                	mov    %esp,%ebp
 80480b9:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 80480bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
 80480c3:	b8 e0 05 00 00       	mov    $0x5e0,%eax
 80480c8:	cd 80                	int    $0x80
 80480ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return r_eax;
 80480cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80480d0:	c9                   	leave  
 80480d1:	c3                   	ret    

080480d2 <sys_pid>:
static inline uint32_t sys_pid(){
 80480d2:	55                   	push   %ebp
 80480d3:	89 e5                	mov    %esp,%ebp
 80480d5:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 80480d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
 80480df:	b8 dd 05 00 00       	mov    $0x5dd,%eax
 80480e4:	cd 80                	int    $0x80
 80480e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80480e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80480ec:	c9                   	leave  
 80480ed:	c3                   	ret    

080480ee <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 80480ee:	55                   	push   %ebp
 80480ef:	89 e5                	mov    %esp,%ebp
 80480f1:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 80480f2:	b8 de 05 00 00       	mov    $0x5de,%eax
 80480f7:	8b 55 08             	mov    0x8(%ebp),%edx
 80480fa:	89 d3                	mov    %edx,%ebx
 80480fc:	cd 80                	int    $0x80
}
 80480fe:	5b                   	pop    %ebx
 80480ff:	5d                   	pop    %ebp
 8048100:	c3                   	ret    

08048101 <fun>:
#include "common.h"
#include "lib/syscall.h"

int share = 0;

void fun(){
 8048101:	55                   	push   %ebp
 8048102:	89 e5                	mov    %esp,%ebp
 8048104:	53                   	push   %ebx
 8048105:	83 ec 14             	sub    $0x14,%esp
	while(1){
		sleep(1);
 8048108:	6a 01                	push   $0x1
 804810a:	e8 df ff ff ff       	call   80480ee <sys_sleep>
 804810f:	83 c4 04             	add    $0x4,%esp
		share ++;
 8048112:	a1 8c 96 04 08       	mov    0x804968c,%eax
 8048117:	83 c0 01             	add    $0x1,%eax
 804811a:	a3 8c 96 04 08       	mov    %eax,0x804968c
		int esp;
		printf("Hello this is thread#%d! %d! %x\n", getpid(), share, &esp);
 804811f:	8b 1d 8c 96 04 08    	mov    0x804968c,%ebx
 8048125:	e8 a8 ff ff ff       	call   80480d2 <sys_pid>
 804812a:	89 c2                	mov    %eax,%edx
 804812c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 804812f:	50                   	push   %eax
 8048130:	53                   	push   %ebx
 8048131:	52                   	push   %edx
 8048132:	68 b4 84 04 08       	push   $0x80484b4
 8048137:	e8 51 03 00 00       	call   804848d <printf>
 804813c:	83 c4 10             	add    $0x10,%esp
	}
 804813f:	eb c7                	jmp    8048108 <fun+0x7>

08048141 <main>:
}

int main(){
 8048141:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048145:	83 e4 f0             	and    $0xfffffff0,%esp
 8048148:	ff 71 fc             	pushl  -0x4(%ecx)
 804814b:	55                   	push   %ebp
 804814c:	89 e5                	mov    %esp,%ebp
 804814e:	53                   	push   %ebx
 804814f:	51                   	push   %ecx
 8048150:	83 ec 10             	sub    $0x10,%esp
	fork();
 8048153:	e8 5e ff ff ff       	call   80480b6 <sys_fork>
	fork();
 8048158:	e8 59 ff ff ff       	call   80480b6 <sys_fork>
	thread(fun, 0xeebfd000-0x1000);
 804815d:	68 00 c0 bf ee       	push   $0xeebfc000
 8048162:	68 01 81 04 08       	push   $0x8048101
 8048167:	e8 28 ff ff ff       	call   8048094 <sys_thread>
 804816c:	83 c4 08             	add    $0x8,%esp
	while(1){
		sleep(2);
 804816f:	6a 02                	push   $0x2
 8048171:	e8 78 ff ff ff       	call   80480ee <sys_sleep>
 8048176:	83 c4 04             	add    $0x4,%esp
		int esp;
		printf("Hello, this is APP#%d! %d! %x\n", getpid(), share, &esp);
 8048179:	8b 1d 8c 96 04 08    	mov    0x804968c,%ebx
 804817f:	e8 4e ff ff ff       	call   80480d2 <sys_pid>
 8048184:	89 c2                	mov    %eax,%edx
 8048186:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8048189:	50                   	push   %eax
 804818a:	53                   	push   %ebx
 804818b:	52                   	push   %edx
 804818c:	68 d8 84 04 08       	push   $0x80484d8
 8048191:	e8 f7 02 00 00       	call   804848d <printf>
 8048196:	83 c4 10             	add    $0x10,%esp
		yield();
 8048199:	e8 0c ff ff ff       	call   80480aa <sys_handout>
	}
 804819e:	eb cf                	jmp    804816f <main+0x2e>

080481a0 <sys_printch>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 80481a0:	55                   	push   %ebp
 80481a1:	89 e5                	mov    %esp,%ebp
 80481a3:	53                   	push   %ebx
 80481a4:	83 ec 04             	sub    $0x4,%esp
 80481a7:	8b 45 08             	mov    0x8(%ebp),%eax
 80481aa:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 80481ad:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 80481b2:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 80481b6:	89 d3                	mov    %edx,%ebx
 80481b8:	cd 80                	int    $0x80
}
 80481ba:	83 c4 04             	add    $0x4,%esp
 80481bd:	5b                   	pop    %ebx
 80481be:	5d                   	pop    %ebp
 80481bf:	c3                   	ret    

080481c0 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 80481c0:	55                   	push   %ebp
 80481c1:	89 e5                	mov    %esp,%ebp
 80481c3:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 80481c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 80481c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 80481cc:	eb 19                	jmp    80481e7 <printp+0x27>
		printer(cur);
 80481ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80481d1:	0f b6 00             	movzbl (%eax),%eax
 80481d4:	0f be c0             	movsbl %al,%eax
 80481d7:	83 ec 0c             	sub    $0xc,%esp
 80481da:	50                   	push   %eax
 80481db:	8b 45 08             	mov    0x8(%ebp),%eax
 80481de:	ff d0                	call   *%eax
 80481e0:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80481e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80481e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80481ea:	0f b6 00             	movzbl (%eax),%eax
 80481ed:	84 c0                	test   %al,%al
 80481ef:	75 dd                	jne    80481ce <printp+0xe>
		printer(cur);
	}
}
 80481f1:	c9                   	leave  
 80481f2:	c3                   	ret    

080481f3 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 80481f3:	55                   	push   %ebp
 80481f4:	89 e5                	mov    %esp,%ebp
 80481f6:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 80481f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 80481fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 80481ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8048206:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 804820d:	8b 45 10             	mov    0x10(%ebp),%eax
 8048210:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048213:	e9 65 02 00 00       	jmp    804847d <vfprintf+0x28a>

		if(cur == '%'){
 8048218:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804821b:	0f b6 00             	movzbl (%eax),%eax
 804821e:	3c 25                	cmp    $0x25,%al
 8048220:	75 0c                	jne    804822e <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 8048222:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 8048229:	e9 4b 02 00 00       	jmp    8048479 <vfprintf+0x286>
		}
		if(type == READ){
 804822e:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 8048232:	0f 85 26 02 00 00    	jne    804845e <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 8048238:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804823b:	0f b6 00             	movzbl (%eax),%eax
 804823e:	3c 73                	cmp    $0x73,%al
 8048240:	75 35                	jne    8048277 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 8048242:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048245:	8b 00                	mov    (%eax),%eax
 8048247:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 804824a:	eb 19                	jmp    8048265 <vfprintf+0x72>
					printer(*p);
 804824c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804824f:	0f b6 00             	movzbl (%eax),%eax
 8048252:	0f be c0             	movsbl %al,%eax
 8048255:	83 ec 0c             	sub    $0xc,%esp
 8048258:	50                   	push   %eax
 8048259:	8b 45 08             	mov    0x8(%ebp),%eax
 804825c:	ff d0                	call   *%eax
 804825e:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 8048261:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 8048265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048268:	0f b6 00             	movzbl (%eax),%eax
 804826b:	84 c0                	test   %al,%al
 804826d:	75 dd                	jne    804824c <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 804826f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048273:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 8048277:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804827a:	0f b6 00             	movzbl (%eax),%eax
 804827d:	3c 78                	cmp    $0x78,%al
 804827f:	0f 85 99 00 00 00    	jne    804831e <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048285:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048288:	8b 00                	mov    (%eax),%eax
 804828a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 804828d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8048291:	75 1d                	jne    80482b0 <vfprintf+0xbd>
					printer('0');
 8048293:	83 ec 0c             	sub    $0xc,%esp
 8048296:	6a 30                	push   $0x30
 8048298:	8b 45 08             	mov    0x8(%ebp),%eax
 804829b:	ff d0                	call   *%eax
 804829d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80482a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80482a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80482ab:	e9 c9 01 00 00       	jmp    8048479 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 80482b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 80482b7:	eb 2d                	jmp    80482e6 <vfprintf+0xf3>
					int d=(x%16);
 80482b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80482bc:	83 e0 0f             	and    $0xf,%eax
 80482bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 80482c2:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80482c6:	7e 04                	jle    80482cc <vfprintf+0xd9>
						d+='a'-'0'-10;
 80482c8:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 80482cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80482cf:	83 c0 30             	add    $0x30,%eax
 80482d2:	89 c1                	mov    %eax,%ecx
 80482d4:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80482d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80482da:	01 d0                	add    %edx,%eax
 80482dc:	88 08                	mov    %cl,(%eax)
					x>>=4;
 80482de:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 80482e2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80482e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80482ea:	75 cd                	jne    80482b9 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 80482ec:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 80482f0:	eb 1e                	jmp    8048310 <vfprintf+0x11d>
					printer(digits[di]);
 80482f2:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80482f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80482f8:	01 d0                	add    %edx,%eax
 80482fa:	0f b6 00             	movzbl (%eax),%eax
 80482fd:	0f be c0             	movsbl %al,%eax
 8048300:	83 ec 0c             	sub    $0xc,%esp
 8048303:	50                   	push   %eax
 8048304:	8b 45 08             	mov    0x8(%ebp),%eax
 8048307:	ff d0                	call   *%eax
 8048309:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 804830c:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8048310:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8048314:	79 dc                	jns    80482f2 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048316:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804831a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 804831e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048321:	0f b6 00             	movzbl (%eax),%eax
 8048324:	3c 64                	cmp    $0x64,%al
 8048326:	0f 85 02 01 00 00    	jne    804842e <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 804832c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804832f:	8b 00                	mov    (%eax),%eax
 8048331:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 8048334:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 804833b:	75 23                	jne    8048360 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 804833d:	83 ec 08             	sub    $0x8,%esp
 8048340:	68 f7 84 04 08       	push   $0x80484f7
 8048345:	ff 75 08             	pushl  0x8(%ebp)
 8048348:	e8 73 fe ff ff       	call   80481c0 <printp>
 804834d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048350:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048354:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 804835b:	e9 19 01 00 00       	jmp    8048479 <vfprintf+0x286>
				}
				if(x==0){
 8048360:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048364:	75 1e                	jne    8048384 <vfprintf+0x191>
					printer('0');
 8048366:	83 ec 0c             	sub    $0xc,%esp
 8048369:	6a 30                	push   $0x30
 804836b:	8b 45 08             	mov    0x8(%ebp),%eax
 804836e:	ff d0                	call   *%eax
 8048370:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048373:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048377:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 804837e:	90                   	nop
 804837f:	e9 f5 00 00 00       	jmp    8048479 <vfprintf+0x286>
				}
				if(x<0){
 8048384:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048388:	79 10                	jns    804839a <vfprintf+0x1a7>
					printer('-');
 804838a:	83 ec 0c             	sub    $0xc,%esp
 804838d:	6a 2d                	push   $0x2d
 804838f:	8b 45 08             	mov    0x8(%ebp),%eax
 8048392:	ff d0                	call   *%eax
 8048394:	83 c4 10             	add    $0x10,%esp
					x=-x;
 8048397:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 804839a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 80483a1:	eb 53                	jmp    80483f6 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 80483a3:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80483a6:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80483ab:	89 c8                	mov    %ecx,%eax
 80483ad:	f7 ea                	imul   %edx
 80483af:	c1 fa 02             	sar    $0x2,%edx
 80483b2:	89 c8                	mov    %ecx,%eax
 80483b4:	c1 f8 1f             	sar    $0x1f,%eax
 80483b7:	29 c2                	sub    %eax,%edx
 80483b9:	89 d0                	mov    %edx,%eax
 80483bb:	c1 e0 02             	shl    $0x2,%eax
 80483be:	01 d0                	add    %edx,%eax
 80483c0:	01 c0                	add    %eax,%eax
 80483c2:	29 c1                	sub    %eax,%ecx
 80483c4:	89 ca                	mov    %ecx,%edx
 80483c6:	89 d0                	mov    %edx,%eax
 80483c8:	83 c0 30             	add    $0x30,%eax
 80483cb:	89 c1                	mov    %eax,%ecx
 80483cd:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80483d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80483d3:	01 d0                	add    %edx,%eax
 80483d5:	88 08                	mov    %cl,(%eax)
					x/=10;
 80483d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80483da:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80483df:	89 c8                	mov    %ecx,%eax
 80483e1:	f7 ea                	imul   %edx
 80483e3:	c1 fa 02             	sar    $0x2,%edx
 80483e6:	89 c8                	mov    %ecx,%eax
 80483e8:	c1 f8 1f             	sar    $0x1f,%eax
 80483eb:	29 c2                	sub    %eax,%edx
 80483ed:	89 d0                	mov    %edx,%eax
 80483ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 80483f2:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80483f6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80483fa:	7f a7                	jg     80483a3 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 80483fc:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 8048400:	eb 1e                	jmp    8048420 <vfprintf+0x22d>
					printer(digits[di]);
 8048402:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048405:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048408:	01 d0                	add    %edx,%eax
 804840a:	0f b6 00             	movzbl (%eax),%eax
 804840d:	0f be c0             	movsbl %al,%eax
 8048410:	83 ec 0c             	sub    $0xc,%esp
 8048413:	50                   	push   %eax
 8048414:	8b 45 08             	mov    0x8(%ebp),%eax
 8048417:	ff d0                	call   *%eax
 8048419:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 804841c:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 8048420:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8048424:	79 dc                	jns    8048402 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048426:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804842a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 804842e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048431:	0f b6 00             	movzbl (%eax),%eax
 8048434:	3c 63                	cmp    $0x63,%al
 8048436:	75 1d                	jne    8048455 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 8048438:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804843b:	0f b6 00             	movzbl (%eax),%eax
 804843e:	0f be c0             	movsbl %al,%eax
 8048441:	83 ec 0c             	sub    $0xc,%esp
 8048444:	50                   	push   %eax
 8048445:	8b 45 08             	mov    0x8(%ebp),%eax
 8048448:	ff d0                	call   *%eax
 804844a:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 804844d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048451:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 8048455:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 804845c:	eb 1b                	jmp    8048479 <vfprintf+0x286>
		}
		if(type == NONE){
 804845e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8048462:	75 15                	jne    8048479 <vfprintf+0x286>
			printer(cur);
 8048464:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048467:	0f b6 00             	movzbl (%eax),%eax
 804846a:	0f be c0             	movsbl %al,%eax
 804846d:	83 ec 0c             	sub    $0xc,%esp
 8048470:	50                   	push   %eax
 8048471:	8b 45 08             	mov    0x8(%ebp),%eax
 8048474:	ff d0                	call   *%eax
 8048476:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048479:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804847d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048480:	0f b6 00             	movzbl (%eax),%eax
 8048483:	84 c0                	test   %al,%al
 8048485:	0f 85 8d fd ff ff    	jne    8048218 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 804848b:	c9                   	leave  
 804848c:	c3                   	ret    

0804848d <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 804848d:	55                   	push   %ebp
 804848e:	89 e5                	mov    %esp,%ebp
 8048490:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 8048493:	8d 45 0c             	lea    0xc(%ebp),%eax
 8048496:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8048499:	8b 45 08             	mov    0x8(%ebp),%eax
 804849c:	83 ec 04             	sub    $0x4,%esp
 804849f:	ff 75 f4             	pushl  -0xc(%ebp)
 80484a2:	50                   	push   %eax
 80484a3:	68 a0 81 04 08       	push   $0x80481a0
 80484a8:	e8 46 fd ff ff       	call   80481f3 <vfprintf>
 80484ad:	83 c4 10             	add    $0x10,%esp
}
 80484b0:	c9                   	leave  
 80484b1:	c3                   	ret    
