
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <sys_readline>:
// static inline int fs_open(const char *pathname, int flags);
// static inline int fs_read(int fd, void *buf, int len);
// static inline int fs_write(int fd, void *buf, int len);
// static inline int fs_lseek(int fd, int offset, int whence);
// static inline int fs_close(int fd);
static inline void sys_readline(char* dest){
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_READLINE), "b"(dest));
 8048098:	b8 08 07 00 00       	mov    $0x708,%eax
 804809d:	8b 55 08             	mov    0x8(%ebp),%edx
 80480a0:	89 d3                	mov    %edx,%ebx
 80480a2:	cd 80                	int    $0x80
}
 80480a4:	5b                   	pop    %ebx
 80480a5:	5d                   	pop    %ebp
 80480a6:	c3                   	ret    

080480a7 <main>:
#include "common.h"
#include "lib/syscall.h"
#include "rnd.h"

int main(){
 80480a7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 80480ab:	83 e4 f0             	and    $0xfffffff0,%esp
 80480ae:	ff 71 fc             	pushl  -0x4(%ecx)
 80480b1:	55                   	push   %ebp
 80480b2:	89 e5                	mov    %esp,%ebp
 80480b4:	51                   	push   %ecx
 80480b5:	83 ec 44             	sub    $0x44,%esp

	char c[64];

	while(1){
		creadline(c);
 80480b8:	8d 45 b8             	lea    -0x48(%ebp),%eax
 80480bb:	50                   	push   %eax
 80480bc:	e8 d3 ff ff ff       	call   8048094 <sys_readline>
 80480c1:	83 c4 04             	add    $0x4,%esp
		printf("%s\n", c);
 80480c4:	83 ec 08             	sub    $0x8,%esp
 80480c7:	8d 45 b8             	lea    -0x48(%ebp),%eax
 80480ca:	50                   	push   %eax
 80480cb:	68 bf 84 04 08       	push   $0x80484bf
 80480d0:	e8 c5 03 00 00       	call   804849a <printf>
 80480d5:	83 c4 10             	add    $0x10,%esp
	}
 80480d8:	eb de                	jmp    80480b8 <main+0x11>

080480da <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 80480da:	55                   	push   %ebp
 80480db:	89 e5                	mov    %esp,%ebp
 80480dd:	53                   	push   %ebx
 80480de:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 80480e1:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 80480e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 80480ef:	a1 d8 95 04 08       	mov    0x80495d8,%eax
 80480f4:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 80480fa:	05 39 30 00 00       	add    $0x3039,%eax
 80480ff:	a3 d8 95 04 08       	mov    %eax,0x80495d8
    y ^= (y<<13);   
 8048104:	a1 dc 95 04 08       	mov    0x80495dc,%eax
 8048109:	c1 e0 0d             	shl    $0xd,%eax
 804810c:	89 c2                	mov    %eax,%edx
 804810e:	a1 dc 95 04 08       	mov    0x80495dc,%eax
 8048113:	31 d0                	xor    %edx,%eax
 8048115:	a3 dc 95 04 08       	mov    %eax,0x80495dc
    y ^= (y>>17);   
 804811a:	a1 dc 95 04 08       	mov    0x80495dc,%eax
 804811f:	c1 e8 11             	shr    $0x11,%eax
 8048122:	89 c2                	mov    %eax,%edx
 8048124:	a1 dc 95 04 08       	mov    0x80495dc,%eax
 8048129:	31 d0                	xor    %edx,%eax
 804812b:	a3 dc 95 04 08       	mov    %eax,0x80495dc
    y ^= (y<<5);    
 8048130:	a1 dc 95 04 08       	mov    0x80495dc,%eax
 8048135:	c1 e0 05             	shl    $0x5,%eax
 8048138:	89 c2                	mov    %eax,%edx
 804813a:	a1 dc 95 04 08       	mov    0x80495dc,%eax
 804813f:	31 d0                	xor    %edx,%eax
 8048141:	a3 dc 95 04 08       	mov    %eax,0x80495dc
      
    t = (A*z + c);  
 8048146:	a1 e0 95 04 08       	mov    0x80495e0,%eax
 804814b:	ba 00 00 00 00       	mov    $0x0,%edx
 8048150:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 8048153:	89 cb                	mov    %ecx,%ebx
 8048155:	0f af da             	imul   %edx,%ebx
 8048158:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 804815b:	0f af c8             	imul   %eax,%ecx
 804815e:	01 d9                	add    %ebx,%ecx
 8048160:	f7 65 f0             	mull   -0x10(%ebp)
 8048163:	01 d1                	add    %edx,%ecx
 8048165:	89 ca                	mov    %ecx,%edx
 8048167:	8b 0d e4 95 04 08    	mov    0x80495e4,%ecx
 804816d:	bb 00 00 00 00       	mov    $0x0,%ebx
 8048172:	01 c8                	add    %ecx,%eax
 8048174:	11 da                	adc    %ebx,%edx
 8048176:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048179:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 804817c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804817f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8048182:	89 d0                	mov    %edx,%eax
 8048184:	31 d2                	xor    %edx,%edx
 8048186:	a3 e4 95 04 08       	mov    %eax,0x80495e4
    z = t;  
 804818b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804818e:	a3 e0 95 04 08       	mov    %eax,0x80495e0
       
    return x+y+z;    
 8048193:	8b 15 d8 95 04 08    	mov    0x80495d8,%edx
 8048199:	a1 dc 95 04 08       	mov    0x80495dc,%eax
 804819e:	01 c2                	add    %eax,%edx
 80481a0:	a1 e0 95 04 08       	mov    0x80495e0,%eax
 80481a5:	01 d0                	add    %edx,%eax
 80481a7:	83 c4 14             	add    $0x14,%esp
 80481aa:	5b                   	pop    %ebx
 80481ab:	5d                   	pop    %ebp
 80481ac:	c3                   	ret    

080481ad <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 80481ad:	55                   	push   %ebp
 80481ae:	89 e5                	mov    %esp,%ebp
 80481b0:	53                   	push   %ebx
 80481b1:	83 ec 04             	sub    $0x4,%esp
 80481b4:	8b 45 08             	mov    0x8(%ebp),%eax
 80481b7:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 80481ba:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 80481bf:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 80481c3:	89 d3                	mov    %edx,%ebx
 80481c5:	cd 80                	int    $0x80
}
 80481c7:	83 c4 04             	add    $0x4,%esp
 80481ca:	5b                   	pop    %ebx
 80481cb:	5d                   	pop    %ebp
 80481cc:	c3                   	ret    

080481cd <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 80481cd:	55                   	push   %ebp
 80481ce:	89 e5                	mov    %esp,%ebp
 80481d0:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 80481d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 80481d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 80481d9:	eb 19                	jmp    80481f4 <printp+0x27>
		printer(cur);
 80481db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80481de:	0f b6 00             	movzbl (%eax),%eax
 80481e1:	0f be c0             	movsbl %al,%eax
 80481e4:	83 ec 0c             	sub    $0xc,%esp
 80481e7:	50                   	push   %eax
 80481e8:	8b 45 08             	mov    0x8(%ebp),%eax
 80481eb:	ff d0                	call   *%eax
 80481ed:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 80481f0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80481f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80481f7:	0f b6 00             	movzbl (%eax),%eax
 80481fa:	84 c0                	test   %al,%al
 80481fc:	75 dd                	jne    80481db <printp+0xe>
		printer(cur);
	}
}
 80481fe:	c9                   	leave  
 80481ff:	c3                   	ret    

08048200 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 8048200:	55                   	push   %ebp
 8048201:	89 e5                	mov    %esp,%ebp
 8048203:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 8048206:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 804820c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8048213:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 804821a:	8b 45 10             	mov    0x10(%ebp),%eax
 804821d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048220:	e9 65 02 00 00       	jmp    804848a <vfprintf+0x28a>

		if(cur == '%'){
 8048225:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048228:	0f b6 00             	movzbl (%eax),%eax
 804822b:	3c 25                	cmp    $0x25,%al
 804822d:	75 0c                	jne    804823b <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 804822f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 8048236:	e9 4b 02 00 00       	jmp    8048486 <vfprintf+0x286>
		}
		if(type == READ){
 804823b:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 804823f:	0f 85 26 02 00 00    	jne    804846b <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 8048245:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048248:	0f b6 00             	movzbl (%eax),%eax
 804824b:	3c 73                	cmp    $0x73,%al
 804824d:	75 35                	jne    8048284 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 804824f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048252:	8b 00                	mov    (%eax),%eax
 8048254:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 8048257:	eb 19                	jmp    8048272 <vfprintf+0x72>
					printer(*p);
 8048259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804825c:	0f b6 00             	movzbl (%eax),%eax
 804825f:	0f be c0             	movsbl %al,%eax
 8048262:	83 ec 0c             	sub    $0xc,%esp
 8048265:	50                   	push   %eax
 8048266:	8b 45 08             	mov    0x8(%ebp),%eax
 8048269:	ff d0                	call   *%eax
 804826b:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 804826e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 8048272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8048275:	0f b6 00             	movzbl (%eax),%eax
 8048278:	84 c0                	test   %al,%al
 804827a:	75 dd                	jne    8048259 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 804827c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048280:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 8048284:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048287:	0f b6 00             	movzbl (%eax),%eax
 804828a:	3c 78                	cmp    $0x78,%al
 804828c:	0f 85 99 00 00 00    	jne    804832b <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 8048292:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048295:	8b 00                	mov    (%eax),%eax
 8048297:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 804829a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804829e:	75 1d                	jne    80482bd <vfprintf+0xbd>
					printer('0');
 80482a0:	83 ec 0c             	sub    $0xc,%esp
 80482a3:	6a 30                	push   $0x30
 80482a5:	8b 45 08             	mov    0x8(%ebp),%eax
 80482a8:	ff d0                	call   *%eax
 80482aa:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80482ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80482b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80482b8:	e9 c9 01 00 00       	jmp    8048486 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 80482bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 80482c4:	eb 2d                	jmp    80482f3 <vfprintf+0xf3>
					int d=(x%16);
 80482c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80482c9:	83 e0 0f             	and    $0xf,%eax
 80482cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 80482cf:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 80482d3:	7e 04                	jle    80482d9 <vfprintf+0xd9>
						d+='a'-'0'-10;
 80482d5:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 80482d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
 80482dc:	83 c0 30             	add    $0x30,%eax
 80482df:	89 c1                	mov    %eax,%ecx
 80482e1:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 80482e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
 80482e7:	01 d0                	add    %edx,%eax
 80482e9:	88 08                	mov    %cl,(%eax)
					x>>=4;
 80482eb:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 80482ef:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 80482f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80482f7:	75 cd                	jne    80482c6 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 80482f9:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 80482fd:	eb 1e                	jmp    804831d <vfprintf+0x11d>
					printer(digits[di]);
 80482ff:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8048302:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8048305:	01 d0                	add    %edx,%eax
 8048307:	0f b6 00             	movzbl (%eax),%eax
 804830a:	0f be c0             	movsbl %al,%eax
 804830d:	83 ec 0c             	sub    $0xc,%esp
 8048310:	50                   	push   %eax
 8048311:	8b 45 08             	mov    0x8(%ebp),%eax
 8048314:	ff d0                	call   *%eax
 8048316:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 8048319:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 804831d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8048321:	79 dc                	jns    80482ff <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048323:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048327:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 804832b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804832e:	0f b6 00             	movzbl (%eax),%eax
 8048331:	3c 64                	cmp    $0x64,%al
 8048333:	0f 85 02 01 00 00    	jne    804843b <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 8048339:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804833c:	8b 00                	mov    (%eax),%eax
 804833e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 8048341:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 8048348:	75 23                	jne    804836d <vfprintf+0x16d>
					printp(printer, "-2147483648");
 804834a:	83 ec 08             	sub    $0x8,%esp
 804834d:	68 c3 84 04 08       	push   $0x80484c3
 8048352:	ff 75 08             	pushl  0x8(%ebp)
 8048355:	e8 73 fe ff ff       	call   80481cd <printp>
 804835a:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804835d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048361:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8048368:	e9 19 01 00 00       	jmp    8048486 <vfprintf+0x286>
				}
				if(x==0){
 804836d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048371:	75 1e                	jne    8048391 <vfprintf+0x191>
					printer('0');
 8048373:	83 ec 0c             	sub    $0xc,%esp
 8048376:	6a 30                	push   $0x30
 8048378:	8b 45 08             	mov    0x8(%ebp),%eax
 804837b:	ff d0                	call   *%eax
 804837d:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8048380:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8048384:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 804838b:	90                   	nop
 804838c:	e9 f5 00 00 00       	jmp    8048486 <vfprintf+0x286>
				}
				if(x<0){
 8048391:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048395:	79 10                	jns    80483a7 <vfprintf+0x1a7>
					printer('-');
 8048397:	83 ec 0c             	sub    $0xc,%esp
 804839a:	6a 2d                	push   $0x2d
 804839c:	8b 45 08             	mov    0x8(%ebp),%eax
 804839f:	ff d0                	call   *%eax
 80483a1:	83 c4 10             	add    $0x10,%esp
					x=-x;
 80483a4:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 80483a7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 80483ae:	eb 53                	jmp    8048403 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 80483b0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80483b3:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80483b8:	89 c8                	mov    %ecx,%eax
 80483ba:	f7 ea                	imul   %edx
 80483bc:	c1 fa 02             	sar    $0x2,%edx
 80483bf:	89 c8                	mov    %ecx,%eax
 80483c1:	c1 f8 1f             	sar    $0x1f,%eax
 80483c4:	29 c2                	sub    %eax,%edx
 80483c6:	89 d0                	mov    %edx,%eax
 80483c8:	c1 e0 02             	shl    $0x2,%eax
 80483cb:	01 d0                	add    %edx,%eax
 80483cd:	01 c0                	add    %eax,%eax
 80483cf:	29 c1                	sub    %eax,%ecx
 80483d1:	89 ca                	mov    %ecx,%edx
 80483d3:	89 d0                	mov    %edx,%eax
 80483d5:	83 c0 30             	add    $0x30,%eax
 80483d8:	89 c1                	mov    %eax,%ecx
 80483da:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 80483dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
 80483e0:	01 d0                	add    %edx,%eax
 80483e2:	88 08                	mov    %cl,(%eax)
					x/=10;
 80483e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80483e7:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80483ec:	89 c8                	mov    %ecx,%eax
 80483ee:	f7 ea                	imul   %edx
 80483f0:	c1 fa 02             	sar    $0x2,%edx
 80483f3:	89 c8                	mov    %ecx,%eax
 80483f5:	c1 f8 1f             	sar    $0x1f,%eax
 80483f8:	29 c2                	sub    %eax,%edx
 80483fa:	89 d0                	mov    %edx,%eax
 80483fc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 80483ff:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8048403:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8048407:	7f a7                	jg     80483b0 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 8048409:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 804840d:	eb 1e                	jmp    804842d <vfprintf+0x22d>
					printer(digits[di]);
 804840f:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8048412:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8048415:	01 d0                	add    %edx,%eax
 8048417:	0f b6 00             	movzbl (%eax),%eax
 804841a:	0f be c0             	movsbl %al,%eax
 804841d:	83 ec 0c             	sub    $0xc,%esp
 8048420:	50                   	push   %eax
 8048421:	8b 45 08             	mov    0x8(%ebp),%eax
 8048424:	ff d0                	call   *%eax
 8048426:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 8048429:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 804842d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8048431:	79 dc                	jns    804840f <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8048433:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8048437:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 804843b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804843e:	0f b6 00             	movzbl (%eax),%eax
 8048441:	3c 63                	cmp    $0x63,%al
 8048443:	75 1d                	jne    8048462 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 8048445:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048448:	0f b6 00             	movzbl (%eax),%eax
 804844b:	0f be c0             	movsbl %al,%eax
 804844e:	83 ec 0c             	sub    $0xc,%esp
 8048451:	50                   	push   %eax
 8048452:	8b 45 08             	mov    0x8(%ebp),%eax
 8048455:	ff d0                	call   *%eax
 8048457:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 804845a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804845e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 8048462:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 8048469:	eb 1b                	jmp    8048486 <vfprintf+0x286>
		}
		if(type == NONE){
 804846b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 804846f:	75 15                	jne    8048486 <vfprintf+0x286>
			printer(cur);
 8048471:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048474:	0f b6 00             	movzbl (%eax),%eax
 8048477:	0f be c0             	movsbl %al,%eax
 804847a:	83 ec 0c             	sub    $0xc,%esp
 804847d:	50                   	push   %eax
 804847e:	8b 45 08             	mov    0x8(%ebp),%eax
 8048481:	ff d0                	call   *%eax
 8048483:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8048486:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804848a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804848d:	0f b6 00             	movzbl (%eax),%eax
 8048490:	84 c0                	test   %al,%al
 8048492:	0f 85 8d fd ff ff    	jne    8048225 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8048498:	c9                   	leave  
 8048499:	c3                   	ret    

0804849a <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 804849a:	55                   	push   %ebp
 804849b:	89 e5                	mov    %esp,%ebp
 804849d:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 80484a0:	8d 45 0c             	lea    0xc(%ebp),%eax
 80484a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 80484a6:	8b 45 08             	mov    0x8(%ebp),%eax
 80484a9:	83 ec 04             	sub    $0x4,%esp
 80484ac:	ff 75 f4             	pushl  -0xc(%ebp)
 80484af:	50                   	push   %eax
 80484b0:	68 ad 81 04 08       	push   $0x80481ad
 80484b5:	e8 46 fd ff ff       	call   8048200 <vfprintf>
 80484ba:	83 c4 10             	add    $0x10,%esp
}
 80484bd:	c9                   	leave  
 80484be:	c3                   	ret    
