
temp.o:     file format elf32-i386


Disassembly of section .text:

08048094 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
 8048094:	55                   	push   %ebp
 8048095:	89 e5                	mov    %esp,%ebp
 8048097:	53                   	push   %ebx
 8048098:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
 804809b:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
 80480a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
 80480a9:	a1 00 b0 04 08       	mov    0x804b000,%eax
 80480ae:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
 80480b4:	05 39 30 00 00       	add    $0x3039,%eax
 80480b9:	a3 00 b0 04 08       	mov    %eax,0x804b000
    y ^= (y<<13);   
 80480be:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480c3:	c1 e0 0d             	shl    $0xd,%eax
 80480c6:	89 c2                	mov    %eax,%edx
 80480c8:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480cd:	31 d0                	xor    %edx,%eax
 80480cf:	a3 04 b0 04 08       	mov    %eax,0x804b004
    y ^= (y>>17);   
 80480d4:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480d9:	c1 e8 11             	shr    $0x11,%eax
 80480dc:	89 c2                	mov    %eax,%edx
 80480de:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480e3:	31 d0                	xor    %edx,%eax
 80480e5:	a3 04 b0 04 08       	mov    %eax,0x804b004
    y ^= (y<<5);    
 80480ea:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480ef:	c1 e0 05             	shl    $0x5,%eax
 80480f2:	89 c2                	mov    %eax,%edx
 80480f4:	a1 04 b0 04 08       	mov    0x804b004,%eax
 80480f9:	31 d0                	xor    %edx,%eax
 80480fb:	a3 04 b0 04 08       	mov    %eax,0x804b004
      
    t = (A*z + c);  
 8048100:	a1 08 b0 04 08       	mov    0x804b008,%eax
 8048105:	ba 00 00 00 00       	mov    $0x0,%edx
 804810a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 804810d:	89 cb                	mov    %ecx,%ebx
 804810f:	0f af da             	imul   %edx,%ebx
 8048112:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8048115:	0f af c8             	imul   %eax,%ecx
 8048118:	01 d9                	add    %ebx,%ecx
 804811a:	f7 65 f0             	mull   -0x10(%ebp)
 804811d:	01 d1                	add    %edx,%ecx
 804811f:	89 ca                	mov    %ecx,%edx
 8048121:	8b 0d 0c b0 04 08    	mov    0x804b00c,%ecx
 8048127:	bb 00 00 00 00       	mov    $0x0,%ebx
 804812c:	01 c8                	add    %ecx,%eax
 804812e:	11 da                	adc    %ebx,%edx
 8048130:	89 45 e8             	mov    %eax,-0x18(%ebp)
 8048133:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
 8048136:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048139:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804813c:	89 d0                	mov    %edx,%eax
 804813e:	31 d2                	xor    %edx,%edx
 8048140:	a3 0c b0 04 08       	mov    %eax,0x804b00c
    z = t;  
 8048145:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8048148:	a3 08 b0 04 08       	mov    %eax,0x804b008
       
    return x+y+z;    
 804814d:	8b 15 00 b0 04 08    	mov    0x804b000,%edx
 8048153:	a1 04 b0 04 08       	mov    0x804b004,%eax
 8048158:	01 c2                	add    %eax,%edx
 804815a:	a1 08 b0 04 08       	mov    0x804b008,%eax
 804815f:	01 d0                	add    %edx,%eax
 8048161:	83 c4 14             	add    $0x14,%esp
 8048164:	5b                   	pop    %ebx
 8048165:	5d                   	pop    %ebp
 8048166:	c3                   	ret    

08048167 <sys_pid>:
}timer_handler;

static inline void sys_handout(){
	asm volatile("int $0x80": : "a"(SYS_HANDOUT)); //SYSCALL HERE!
}
static inline uint32_t sys_pid(){
 8048167:	55                   	push   %ebp
 8048168:	89 e5                	mov    %esp,%ebp
 804816a:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 804816d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PID)); //SYSCALL HERE!
 8048174:	b8 dd 05 00 00       	mov    $0x5dd,%eax
 8048179:	cd 80                	int    $0x80
 804817b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 804817e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8048181:	c9                   	leave  
 8048182:	c3                   	ret    

08048183 <sys_init_vcache>:

static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
 8048183:	55                   	push   %ebp
 8048184:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
 8048186:	b8 4c 04 00 00       	mov    $0x44c,%eax
 804818b:	cd 80                	int    $0x80
}
 804818d:	5d                   	pop    %ebp
 804818e:	c3                   	ret    

0804818f <sys_flush_vcache>:

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
 804818f:	55                   	push   %ebp
 8048190:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
 8048192:	b8 4e 04 00 00       	mov    $0x44e,%eax
 8048197:	cd 80                	int    $0x80
}
 8048199:	5d                   	pop    %ebp
 804819a:	c3                   	ret    

0804819b <sys_set_pixel>:
static inline void sys_set_pixel(int x, int y, int color){
 804819b:	55                   	push   %ebp
 804819c:	89 e5                	mov    %esp,%ebp
 804819e:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
 804819f:	b8 4f 04 00 00       	mov    $0x44f,%eax
 80481a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80481a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80481aa:	8b 55 10             	mov    0x10(%ebp),%edx
 80481ad:	cd 80                	int    $0x80
}
 80481af:	5b                   	pop    %ebx
 80481b0:	5d                   	pop    %ebp
 80481b1:	c3                   	ret    

080481b2 <sys_key_down>:
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
 80481b2:	55                   	push   %ebp
 80481b3:	89 e5                	mov    %esp,%ebp
 80481b5:	53                   	push   %ebx
 80481b6:	83 ec 14             	sub    $0x14,%esp
 80481b9:	8b 45 08             	mov    0x8(%ebp),%eax
 80481bc:	88 45 e8             	mov    %al,-0x18(%ebp)
	char r_eax = 0;
 80481bf:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
 80481c3:	b8 b0 04 00 00       	mov    $0x4b0,%eax
 80481c8:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 80481cc:	89 d3                	mov    %edx,%ebx
 80481ce:	cd 80                	int    $0x80
 80481d0:	88 45 fb             	mov    %al,-0x5(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80481d3:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
 80481d7:	83 c4 14             	add    $0x14,%esp
 80481da:	5b                   	pop    %ebx
 80481db:	5d                   	pop    %ebp
 80481dc:	c3                   	ret    

080481dd <sys_get_tick>:
static inline uint32_t sys_get_tick(){
 80481dd:	55                   	push   %ebp
 80481de:	89 e5                	mov    %esp,%ebp
 80481e0:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 80481e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
 80481ea:	b8 15 05 00 00       	mov    $0x515,%eax
 80481ef:	cd 80                	int    $0x80
 80481f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80481f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80481f7:	c9                   	leave  
 80481f8:	c3                   	ret    

080481f9 <isqrt>:
    1,1,1,1,1
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
 80481f9:	55                   	push   %ebp
 80481fa:	89 e5                	mov    %esp,%ebp
 80481fc:	83 ec 10             	sub    $0x10,%esp
    if(memoriza[x] > 0) return memoriza[x];
 80481ff:	8b 45 08             	mov    0x8(%ebp),%eax
 8048202:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 8048209:	85 c0                	test   %eax,%eax
 804820b:	74 0f                	je     804821c <isqrt+0x23>
 804820d:	8b 45 08             	mov    0x8(%ebp),%eax
 8048210:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 8048217:	e9 a9 00 00 00       	jmp    80482c5 <isqrt+0xcc>
    const uint16_t *p = squares;
 804821c:	c7 45 fc 80 97 04 08 	movl   $0x8049780,-0x4(%ebp)
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
 8048223:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048226:	83 c0 40             	add    $0x40,%eax
 8048229:	0f b7 00             	movzwl (%eax),%eax
 804822c:	0f b7 c0             	movzwl %ax,%eax
 804822f:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048232:	77 04                	ja     8048238 <isqrt+0x3f>
 8048234:	83 45 fc 40          	addl   $0x40,-0x4(%ebp)
    if (p[ 16] <= x) p +=  16;
 8048238:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804823b:	83 c0 20             	add    $0x20,%eax
 804823e:	0f b7 00             	movzwl (%eax),%eax
 8048241:	0f b7 c0             	movzwl %ax,%eax
 8048244:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048247:	77 04                	ja     804824d <isqrt+0x54>
 8048249:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
    if (p[  8] <= x) p +=   8;
 804824d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048250:	83 c0 10             	add    $0x10,%eax
 8048253:	0f b7 00             	movzwl (%eax),%eax
 8048256:	0f b7 c0             	movzwl %ax,%eax
 8048259:	3b 45 08             	cmp    0x8(%ebp),%eax
 804825c:	77 04                	ja     8048262 <isqrt+0x69>
 804825e:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    if (p[  4] <= x) p +=   4;
 8048262:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048265:	83 c0 08             	add    $0x8,%eax
 8048268:	0f b7 00             	movzwl (%eax),%eax
 804826b:	0f b7 c0             	movzwl %ax,%eax
 804826e:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048271:	77 04                	ja     8048277 <isqrt+0x7e>
 8048273:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
    if (p[  2] <= x) p +=   2;
 8048277:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804827a:	83 c0 04             	add    $0x4,%eax
 804827d:	0f b7 00             	movzwl (%eax),%eax
 8048280:	0f b7 c0             	movzwl %ax,%eax
 8048283:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048286:	77 04                	ja     804828c <isqrt+0x93>
 8048288:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
    if (p[  1] <= x) p +=   1;
 804828c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804828f:	83 c0 02             	add    $0x2,%eax
 8048292:	0f b7 00             	movzwl (%eax),%eax
 8048295:	0f b7 c0             	movzwl %ax,%eax
 8048298:	3b 45 08             	cmp    0x8(%ebp),%eax
 804829b:	77 04                	ja     80482a1 <isqrt+0xa8>
 804829d:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    memoriza[x] = p - squares;
 80482a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482a4:	ba 80 97 04 08       	mov    $0x8049780,%edx
 80482a9:	29 d0                	sub    %edx,%eax
 80482ab:	d1 f8                	sar    %eax
 80482ad:	89 c2                	mov    %eax,%edx
 80482af:	8b 45 08             	mov    0x8(%ebp),%eax
 80482b2:	89 14 85 c0 b0 04 08 	mov    %edx,0x804b0c0(,%eax,4)
    return p - squares;
 80482b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482bc:	ba 80 97 04 08       	mov    $0x8049780,%edx
 80482c1:	29 d0                	sub    %edx,%eax
 80482c3:	d1 f8                	sar    %eax
}
 80482c5:	c9                   	leave  
 80482c6:	c3                   	ret    

080482c7 <clearStage>:


static inline void clearStage(){
 80482c7:	55                   	push   %ebp
 80482c8:	89 e5                	mov    %esp,%ebp
	hash = 0;
 80482ca:	c7 05 80 b0 04 08 00 	movl   $0x0,0x804b080
 80482d1:	00 00 00 
	sys_init_vcache();
 80482d4:	e8 aa fe ff ff       	call   8048183 <sys_init_vcache>
}
 80482d9:	5d                   	pop    %ebp
 80482da:	c3                   	ret    

080482db <drawPoint>:
static inline void drawPoint(int x, int y, uint8_t color){
 80482db:	55                   	push   %ebp
 80482dc:	89 e5                	mov    %esp,%ebp
 80482de:	83 ec 04             	sub    $0x4,%esp
 80482e1:	8b 45 10             	mov    0x10(%ebp),%eax
 80482e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	sys_set_pixel(y, x, color);
 80482e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 80482eb:	50                   	push   %eax
 80482ec:	ff 75 08             	pushl  0x8(%ebp)
 80482ef:	ff 75 0c             	pushl  0xc(%ebp)
 80482f2:	e8 a4 fe ff ff       	call   804819b <sys_set_pixel>
 80482f7:	83 c4 0c             	add    $0xc,%esp
}
 80482fa:	c9                   	leave  
 80482fb:	c3                   	ret    

080482fc <drawRect>:
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
 80482fc:	55                   	push   %ebp
 80482fd:	89 e5                	mov    %esp,%ebp
 80482ff:	53                   	push   %ebx
 8048300:	83 ec 14             	sub    $0x14,%esp
 8048303:	8b 45 18             	mov    0x18(%ebp),%eax
 8048306:	88 45 e8             	mov    %al,-0x18(%ebp)
	hash += 29*x+57*y+13*color;
 8048309:	8b 45 08             	mov    0x8(%ebp),%eax
 804830c:	6b d0 1d             	imul   $0x1d,%eax,%edx
 804830f:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048312:	6b c0 39             	imul   $0x39,%eax,%eax
 8048315:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048318:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 804831c:	89 d0                	mov    %edx,%eax
 804831e:	01 c0                	add    %eax,%eax
 8048320:	01 d0                	add    %edx,%eax
 8048322:	c1 e0 02             	shl    $0x2,%eax
 8048325:	01 d0                	add    %edx,%eax
 8048327:	01 c8                	add    %ecx,%eax
 8048329:	89 c2                	mov    %eax,%edx
 804832b:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048330:	01 d0                	add    %edx,%eax
 8048332:	a3 80 b0 04 08       	mov    %eax,0x804b080
	int i=0, j=0;
 8048337:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804833e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<w;i++){
 8048345:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804834c:	eb 38                	jmp    8048386 <drawRect+0x8a>
		for(j=0;j<h;j++){
 804834e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048355:	eb 23                	jmp    804837a <drawRect+0x7e>
			drawPoint(x+i, y+j, color);
 8048357:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 804835b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 804835e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048361:	01 d1                	add    %edx,%ecx
 8048363:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048366:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8048369:	01 da                	add    %ebx,%edx
 804836b:	50                   	push   %eax
 804836c:	51                   	push   %ecx
 804836d:	52                   	push   %edx
 804836e:	e8 68 ff ff ff       	call   80482db <drawPoint>
 8048373:	83 c4 0c             	add    $0xc,%esp
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
 8048376:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804837a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804837d:	3b 45 14             	cmp    0x14(%ebp),%eax
 8048380:	7c d5                	jl     8048357 <drawRect+0x5b>
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
 8048382:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 8048386:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048389:	3b 45 10             	cmp    0x10(%ebp),%eax
 804838c:	7c c0                	jl     804834e <drawRect+0x52>
		for(j=0;j<h;j++){
			drawPoint(x+i, y+j, color);
		}
	}
}
 804838e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048391:	c9                   	leave  
 8048392:	c3                   	ret    

08048393 <drawCirc>:


static inline void drawCirc(int x, int y, int r, uint8_t color){
 8048393:	55                   	push   %ebp
 8048394:	89 e5                	mov    %esp,%ebp
 8048396:	53                   	push   %ebx
 8048397:	83 ec 14             	sub    $0x14,%esp
 804839a:	8b 45 14             	mov    0x14(%ebp),%eax
 804839d:	88 45 e8             	mov    %al,-0x18(%ebp)
	int i, j;
	hash += 329*x+157*y+713*r;
 80483a0:	8b 45 08             	mov    0x8(%ebp),%eax
 80483a3:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
 80483a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 80483ac:	69 c0 9d 00 00 00    	imul   $0x9d,%eax,%eax
 80483b2:	01 c2                	add    %eax,%edx
 80483b4:	8b 45 10             	mov    0x10(%ebp),%eax
 80483b7:	69 c0 c9 02 00 00    	imul   $0x2c9,%eax,%eax
 80483bd:	01 d0                	add    %edx,%eax
 80483bf:	89 c2                	mov    %eax,%edx
 80483c1:	a1 80 b0 04 08       	mov    0x804b080,%eax
 80483c6:	01 d0                	add    %edx,%eax
 80483c8:	a3 80 b0 04 08       	mov    %eax,0x804b080
	for(i=-r; i<=r; i++){
 80483cd:	8b 45 10             	mov    0x10(%ebp),%eax
 80483d0:	f7 d8                	neg    %eax
 80483d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
 80483d5:	eb 5c                	jmp    8048433 <drawCirc+0xa0>
		int delta = isqrt(r*r-i*i)+1;
 80483d7:	8b 45 10             	mov    0x10(%ebp),%eax
 80483da:	0f af 45 10          	imul   0x10(%ebp),%eax
 80483de:	89 c2                	mov    %eax,%edx
 80483e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80483e3:	0f af 45 f8          	imul   -0x8(%ebp),%eax
 80483e7:	29 c2                	sub    %eax,%edx
 80483e9:	89 d0                	mov    %edx,%eax
 80483eb:	50                   	push   %eax
 80483ec:	e8 08 fe ff ff       	call   80481f9 <isqrt>
 80483f1:	83 c4 04             	add    $0x4,%esp
 80483f4:	83 c0 01             	add    $0x1,%eax
 80483f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 80483fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80483fd:	f7 d8                	neg    %eax
 80483ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048402:	eb 23                	jmp    8048427 <drawCirc+0x94>
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
 8048404:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 8048408:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 804840b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 804840e:	01 d1                	add    %edx,%ecx
 8048410:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048413:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8048416:	01 da                	add    %ebx,%edx
 8048418:	50                   	push   %eax
 8048419:	51                   	push   %ecx
 804841a:	52                   	push   %edx
 804841b:	e8 bb fe ff ff       	call   80482db <drawPoint>
 8048420:	83 c4 0c             	add    $0xc,%esp
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 8048423:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048427:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804842a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 804842d:	7e d5                	jle    8048404 <drawCirc+0x71>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
 804842f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 8048433:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048436:	3b 45 10             	cmp    0x10(%ebp),%eax
 8048439:	7e 9c                	jle    80483d7 <drawCirc+0x44>
		for(j=-delta; j<=delta; j++){
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
		}
	}
}
 804843b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 804843e:	c9                   	leave  
 804843f:	c3                   	ret    

08048440 <drawText1>:

static inline void drawText1(){
 8048440:	55                   	push   %ebp
 8048441:	89 e5                	mov    %esp,%ebp
 8048443:	83 ec 10             	sub    $0x10,%esp
    int i=0, j=0;
 8048446:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 804844d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(j=0;j<20;j++){
 8048454:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804845b:	eb 53                	jmp    80484b0 <drawText1+0x70>
        for(i=0;i<52;i++){
 804845d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048464:	eb 40                	jmp    80484a6 <drawText1+0x66>
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
 8048466:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048469:	6b d0 34             	imul   $0x34,%eax,%edx
 804846c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804846f:	01 d0                	add    %edx,%eax
 8048471:	0f b6 80 80 99 04 08 	movzbl 0x8049980(%eax),%eax
 8048478:	84 c0                	test   %al,%al
 804847a:	74 26                	je     80484a2 <drawText1+0x62>
 804847c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 804847f:	89 d0                	mov    %edx,%eax
 8048481:	c1 e0 02             	shl    $0x2,%eax
 8048484:	01 d0                	add    %edx,%eax
 8048486:	8d 50 14             	lea    0x14(%eax),%edx
 8048489:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804848c:	c1 e0 02             	shl    $0x2,%eax
 804848f:	83 c0 32             	add    $0x32,%eax
 8048492:	6a 0e                	push   $0xe
 8048494:	6a 05                	push   $0x5
 8048496:	6a 04                	push   $0x4
 8048498:	52                   	push   %edx
 8048499:	50                   	push   %eax
 804849a:	e8 5d fe ff ff       	call   80482fc <drawRect>
 804849f:	83 c4 14             	add    $0x14,%esp
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
 80484a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 80484a6:	83 7d fc 33          	cmpl   $0x33,-0x4(%ebp)
 80484aa:	7e ba                	jle    8048466 <drawText1+0x26>
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
 80484ac:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 80484b0:	83 7d f8 13          	cmpl   $0x13,-0x8(%ebp)
 80484b4:	7e a7                	jle    804845d <drawText1+0x1d>
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
        }
    }
}
 80484b6:	c9                   	leave  
 80484b7:	c3                   	ret    

080484b8 <drawNumber>:

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
 80484b8:	55                   	push   %ebp
 80484b9:	89 e5                	mov    %esp,%ebp
 80484bb:	53                   	push   %ebx
 80484bc:	83 ec 24             	sub    $0x24,%esp
 80484bf:	8b 45 18             	mov    0x18(%ebp),%eax
 80484c2:	88 45 d8             	mov    %al,-0x28(%ebp)
    char temp[11];
    int di=0;
 80484c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(num == 0){
 80484cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 80484d0:	75 0d                	jne    80484df <drawNumber+0x27>
        temp[0] = '0';
 80484d2:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
        di = 0;
 80484d6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 80484dd:	eb 5f                	jmp    804853e <drawNumber+0x86>

    }else{    
        while(num>=1){
 80484df:	eb 53                	jmp    8048534 <drawNumber+0x7c>
            temp[di] = '0'+(num%10);
 80484e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 80484e4:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80484e9:	89 c8                	mov    %ecx,%eax
 80484eb:	f7 ea                	imul   %edx
 80484ed:	c1 fa 02             	sar    $0x2,%edx
 80484f0:	89 c8                	mov    %ecx,%eax
 80484f2:	c1 f8 1f             	sar    $0x1f,%eax
 80484f5:	29 c2                	sub    %eax,%edx
 80484f7:	89 d0                	mov    %edx,%eax
 80484f9:	c1 e0 02             	shl    $0x2,%eax
 80484fc:	01 d0                	add    %edx,%eax
 80484fe:	01 c0                	add    %eax,%eax
 8048500:	29 c1                	sub    %eax,%ecx
 8048502:	89 ca                	mov    %ecx,%edx
 8048504:	89 d0                	mov    %edx,%eax
 8048506:	83 c0 30             	add    $0x30,%eax
 8048509:	89 c1                	mov    %eax,%ecx
 804850b:	8d 55 dd             	lea    -0x23(%ebp),%edx
 804850e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048511:	01 d0                	add    %edx,%eax
 8048513:	88 08                	mov    %cl,(%eax)
            num/=10;
 8048515:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8048518:	ba 67 66 66 66       	mov    $0x66666667,%edx
 804851d:	89 c8                	mov    %ecx,%eax
 804851f:	f7 ea                	imul   %edx
 8048521:	c1 fa 02             	sar    $0x2,%edx
 8048524:	89 c8                	mov    %ecx,%eax
 8048526:	c1 f8 1f             	sar    $0x1f,%eax
 8048529:	29 c2                	sub    %eax,%edx
 804852b:	89 d0                	mov    %edx,%eax
 804852d:	89 45 08             	mov    %eax,0x8(%ebp)
            di++;
 8048530:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
 8048534:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 8048538:	7f a7                	jg     80484e1 <drawNumber+0x29>
            temp[di] = '0'+(num%10);
            num/=10;
            di++;
        };
        di--;
 804853a:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
    }
    int i=0, xx=0, yy=0;
 804853e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048545:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804854c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(;di>=0;di--){
 8048553:	e9 aa 00 00 00       	jmp    8048602 <drawNumber+0x14a>
        for(yy=0; yy<7; yy++){
 8048558:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 804855f:	e9 8c 00 00 00       	jmp    80485f0 <drawNumber+0x138>
            for(xx=0; xx<5; xx++){
 8048564:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804856b:	eb 79                	jmp    80485e6 <drawNumber+0x12e>
                const char* num = nums[temp[di]-'0'];
 804856d:	8d 55 dd             	lea    -0x23(%ebp),%edx
 8048570:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048573:	01 d0                	add    %edx,%eax
 8048575:	0f b6 00             	movzbl (%eax),%eax
 8048578:	0f be c0             	movsbl %al,%eax
 804857b:	83 e8 30             	sub    $0x30,%eax
 804857e:	8b 04 85 20 b0 04 08 	mov    0x804b020(,%eax,4),%eax
 8048585:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
 8048588:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804858b:	89 d0                	mov    %edx,%eax
 804858d:	c1 e0 02             	shl    $0x2,%eax
 8048590:	01 c2                	add    %eax,%edx
 8048592:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048595:	01 d0                	add    %edx,%eax
 8048597:	89 c2                	mov    %eax,%edx
 8048599:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804859c:	01 d0                	add    %edx,%eax
 804859e:	0f b6 00             	movzbl (%eax),%eax
 80485a1:	84 c0                	test   %al,%al
 80485a3:	74 3d                	je     80485e2 <drawNumber+0x12a>
 80485a5:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
 80485a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80485ac:	89 d1                	mov    %edx,%ecx
 80485ae:	0f af 4d 14          	imul   0x14(%ebp),%ecx
 80485b2:	8b 55 10             	mov    0x10(%ebp),%edx
 80485b5:	01 d1                	add    %edx,%ecx
 80485b7:	8b 55 14             	mov    0x14(%ebp),%edx
 80485ba:	83 c2 0a             	add    $0xa,%edx
 80485bd:	89 d3                	mov    %edx,%ebx
 80485bf:	0f af 5d f4          	imul   -0xc(%ebp),%ebx
 80485c3:	8b 55 0c             	mov    0xc(%ebp),%edx
 80485c6:	01 d3                	add    %edx,%ebx
 80485c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
 80485cb:	0f af 55 14          	imul   0x14(%ebp),%edx
 80485cf:	01 da                	add    %ebx,%edx
 80485d1:	50                   	push   %eax
 80485d2:	ff 75 14             	pushl  0x14(%ebp)
 80485d5:	ff 75 14             	pushl  0x14(%ebp)
 80485d8:	51                   	push   %ecx
 80485d9:	52                   	push   %edx
 80485da:	e8 1d fd ff ff       	call   80482fc <drawRect>
 80485df:	83 c4 14             	add    $0x14,%esp
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
 80485e2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 80485e6:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
 80485ea:	7e 81                	jle    804856d <drawNumber+0xb5>
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
 80485ec:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 80485f0:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
 80485f4:	0f 8e 6a ff ff ff    	jle    8048564 <drawNumber+0xac>
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
 80485fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
 80485fe:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
 8048602:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 8048606:	0f 89 4c ff ff ff    	jns    8048558 <drawNumber+0xa0>
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
    }
}
 804860c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 804860f:	c9                   	leave  
 8048610:	c3                   	ret    

08048611 <drawStage>:

static inline void drawStage(){
 8048611:	55                   	push   %ebp
 8048612:	89 e5                	mov    %esp,%ebp
	if(lhash == hash)return;
 8048614:	8b 15 84 b0 04 08    	mov    0x804b084,%edx
 804861a:	a1 80 b0 04 08       	mov    0x804b080,%eax
 804861f:	39 c2                	cmp    %eax,%edx
 8048621:	75 02                	jne    8048625 <drawStage+0x14>
 8048623:	eb 0f                	jmp    8048634 <drawStage+0x23>
	//clear_vram();
	sys_flush_vcache();
 8048625:	e8 65 fb ff ff       	call   804818f <sys_flush_vcache>
	lhash = hash;
 804862a:	a1 80 b0 04 08       	mov    0x804b080,%eax
 804862f:	a3 84 b0 04 08       	mov    %eax,0x804b084
}
 8048634:	5d                   	pop    %ebp
 8048635:	c3                   	ret    

08048636 <key>:
static int timestamp = 1;
static int curtime = 0;
static int score = 0;
void dreamOf100HZ(int);

static inline int8_t key(char s){
 8048636:	55                   	push   %ebp
 8048637:	89 e5                	mov    %esp,%ebp
 8048639:	83 ec 04             	sub    $0x4,%esp
 804863c:	8b 45 08             	mov    0x8(%ebp),%eax
 804863f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return sys_key_down(s);
 8048642:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
 8048646:	50                   	push   %eax
 8048647:	e8 66 fb ff ff       	call   80481b2 <sys_key_down>
 804864c:	83 c4 04             	add    $0x4,%esp
}
 804864f:	c9                   	leave  
 8048650:	c3                   	ret    

08048651 <main>:



int main(){
 8048651:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048655:	83 e4 f0             	and    $0xfffffff0,%esp
 8048658:	ff 71 fc             	pushl  -0x4(%ecx)
 804865b:	55                   	push   %ebp
 804865c:	89 e5                	mov    %esp,%ebp
 804865e:	51                   	push   %ecx
 804865f:	83 ec 04             	sub    $0x4,%esp
	//initVCache();
	//printk("5\n");
	//clear_key();
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
 8048662:	e8 76 fb ff ff       	call   80481dd <sys_get_tick>
 8048667:	a3 48 b0 04 08       	mov    %eax,0x804b048
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 804866c:	eb 1e                	jmp    804868c <main+0x3b>
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
 804866e:	a1 48 b0 04 08       	mov    0x804b048,%eax
 8048673:	83 ec 0c             	sub    $0xc,%esp
 8048676:	50                   	push   %eax
 8048677:	e8 8c 07 00 00       	call   8048e08 <dreamOf100HZ>
 804867c:	83 c4 10             	add    $0x10,%esp
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
			curtime+=2;
 804867f:	a1 20 ba 04 08       	mov    0x804ba20,%eax
 8048684:	83 c0 02             	add    $0x2,%eax
 8048687:	a3 20 ba 04 08       	mov    %eax,0x804ba20
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 804868c:	8b 15 20 ba 04 08    	mov    0x804ba20,%edx
 8048692:	a1 48 b0 04 08       	mov    0x804b048,%eax
 8048697:	39 c2                	cmp    %eax,%edx
 8048699:	7c d3                	jl     804866e <main+0x1d>
		//sys_handout();
		

		//enable_interrupt();
		
	}
 804869b:	eb c5                	jmp    8048662 <main+0x11>

0804869d <hitMonster>:
domain int x, y, size;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
 804869d:	55                   	push   %ebp
 804869e:	89 e5                	mov    %esp,%ebp
 80486a0:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 80486a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	REP_MONSTER(){
 80486aa:	e9 9c 01 00 00       	jmp    804884b <hitMonster+0x1ae>
		int dx = x-mon.x; 
 80486af:	8b 15 2c ba 04 08    	mov    0x804ba2c,%edx
 80486b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80486b8:	c1 e0 02             	shl    $0x2,%eax
 80486bb:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80486c2:	29 c1                	sub    %eax,%ecx
 80486c4:	89 c8                	mov    %ecx,%eax
 80486c6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80486cb:	8b 40 04             	mov    0x4(%eax),%eax
 80486ce:	29 c2                	sub    %eax,%edx
 80486d0:	89 d0                	mov    %edx,%eax
 80486d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int dy = y-mon.y;
 80486d5:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80486db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80486de:	c1 e0 02             	shl    $0x2,%eax
 80486e1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80486e8:	29 c1                	sub    %eax,%ecx
 80486ea:	89 c8                	mov    %ecx,%eax
 80486ec:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80486f1:	8b 40 08             	mov    0x8(%eax),%eax
 80486f4:	29 c2                	sub    %eax,%edx
 80486f6:	89 d0                	mov    %edx,%eax
 80486f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
 80486fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80486fe:	89 c2                	mov    %eax,%edx
 8048700:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048707:	89 c2                	mov    %eax,%edx
 8048709:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048710:	29 d0                	sub    %edx,%eax
 8048712:	83 c0 10             	add    $0x10,%eax
 8048715:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804871a:	8b 40 04             	mov    0x4(%eax),%eax
 804871d:	85 c0                	test   %eax,%eax
 804871f:	0f 85 22 01 00 00    	jne    8048847 <hitMonster+0x1aa>
 8048725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048728:	c1 e0 02             	shl    $0x2,%eax
 804872b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048732:	29 c2                	sub    %eax,%edx
 8048734:	89 d0                	mov    %edx,%eax
 8048736:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804873b:	8b 00                	mov    (%eax),%eax
 804873d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8048740:	0f 8c 01 01 00 00    	jl     8048847 <hitMonster+0x1aa>
 8048746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048749:	c1 e0 02             	shl    $0x2,%eax
 804874c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048753:	29 c2                	sub    %eax,%edx
 8048755:	89 d0                	mov    %edx,%eax
 8048757:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804875c:	8b 00                	mov    (%eax),%eax
 804875e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 8048761:	0f 8c e0 00 00 00    	jl     8048847 <hitMonster+0x1aa>
 8048767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804876a:	c1 e0 02             	shl    $0x2,%eax
 804876d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048774:	29 c2                	sub    %eax,%edx
 8048776:	89 d0                	mov    %edx,%eax
 8048778:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804877d:	8b 00                	mov    (%eax),%eax
 804877f:	f7 d8                	neg    %eax
 8048781:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8048784:	0f 8f bd 00 00 00    	jg     8048847 <hitMonster+0x1aa>
 804878a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804878d:	c1 e0 02             	shl    $0x2,%eax
 8048790:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048797:	29 c2                	sub    %eax,%edx
 8048799:	89 d0                	mov    %edx,%eax
 804879b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487a0:	8b 00                	mov    (%eax),%eax
 80487a2:	f7 d8                	neg    %eax
 80487a4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 80487a7:	0f 8f 9a 00 00 00    	jg     8048847 <hitMonster+0x1aa>
			if(mon.size <= size){
 80487ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487b0:	c1 e0 02             	shl    $0x2,%eax
 80487b3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80487ba:	29 c2                	sub    %eax,%edx
 80487bc:	89 d0                	mov    %edx,%eax
 80487be:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487c3:	8b 10                	mov    (%eax),%edx
 80487c5:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80487ca:	39 c2                	cmp    %eax,%edx
 80487cc:	7f 68                	jg     8048836 <hitMonster+0x199>
				mon.status = MONSTER_DEAD;
 80487ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487d1:	89 c2                	mov    %eax,%edx
 80487d3:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80487da:	89 c2                	mov    %eax,%edx
 80487dc:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80487e3:	29 d0                	sub    %edx,%eax
 80487e5:	83 c0 10             	add    $0x10,%eax
 80487e8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487ed:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
				if(size<13)size++;
 80487f4:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80487f9:	83 f8 0c             	cmp    $0xc,%eax
 80487fc:	7f 0d                	jg     804880b <hitMonster+0x16e>
 80487fe:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048803:	83 c0 01             	add    $0x1,%eax
 8048806:	a3 34 ba 04 08       	mov    %eax,0x804ba34
				score += mon.size;
 804880b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804880e:	c1 e0 02             	shl    $0x2,%eax
 8048811:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048818:	29 c2                	sub    %eax,%edx
 804881a:	89 d0                	mov    %edx,%eax
 804881c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048821:	8b 10                	mov    (%eax),%edx
 8048823:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 8048828:	01 d0                	add    %edx,%eax
 804882a:	a3 24 ba 04 08       	mov    %eax,0x804ba24
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
 804882f:	b8 01 00 00 00       	mov    $0x1,%eax
 8048834:	eb 24                	jmp    804885a <hitMonster+0x1bd>
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
 8048836:	c7 05 28 ba 04 08 03 	movl   $0x3,0x804ba28
 804883d:	00 00 00 
				return 0;
 8048840:	b8 00 00 00 00       	mov    $0x0,%eax
 8048845:	eb 13                	jmp    804885a <hitMonster+0x1bd>
domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
 8048847:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 804884b:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
 804884f:	0f 8e 5a fe ff ff    	jle    80486af <hitMonster+0x12>
				return 0;
			}
			return 1;
		}
	}
	return 0;
 8048855:	b8 00 00 00 00       	mov    $0x0,%eax
}
 804885a:	c9                   	leave  
 804885b:	c3                   	ret    

0804885c <drawMonster>:

void drawMonster(){
 804885c:	55                   	push   %ebp
 804885d:	89 e5                	mov    %esp,%ebp
 804885f:	56                   	push   %esi
 8048860:	53                   	push   %ebx
 8048861:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 8048864:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 804886b:	e9 89 03 00 00       	jmp    8048bf9 <drawMonster+0x39d>
		if(mon.status == MONSTER_ALIVE){
 8048870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048873:	89 c2                	mov    %eax,%edx
 8048875:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804887c:	89 c2                	mov    %eax,%edx
 804887e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048885:	29 d0                	sub    %edx,%eax
 8048887:	83 c0 10             	add    $0x10,%eax
 804888a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804888f:	8b 40 04             	mov    0x4(%eax),%eax
 8048892:	85 c0                	test   %eax,%eax
 8048894:	0f 85 5b 03 00 00    	jne    8048bf5 <drawMonster+0x399>
			mon.x += mon.sx;
 804889a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804889d:	c1 e0 02             	shl    $0x2,%eax
 80488a0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80488a7:	29 c2                	sub    %eax,%edx
 80488a9:	89 d0                	mov    %edx,%eax
 80488ab:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488b0:	8b 50 04             	mov    0x4(%eax),%edx
 80488b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488b6:	c1 e0 02             	shl    $0x2,%eax
 80488b9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80488c0:	29 c1                	sub    %eax,%ecx
 80488c2:	89 c8                	mov    %ecx,%eax
 80488c4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488c9:	8b 40 0c             	mov    0xc(%eax),%eax
 80488cc:	01 c2                	add    %eax,%edx
 80488ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488d1:	c1 e0 02             	shl    $0x2,%eax
 80488d4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80488db:	29 c1                	sub    %eax,%ecx
 80488dd:	89 c8                	mov    %ecx,%eax
 80488df:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488e4:	89 50 04             	mov    %edx,0x4(%eax)
			mon.y += mon.sy;
 80488e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488ea:	c1 e0 02             	shl    $0x2,%eax
 80488ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80488f4:	29 c2                	sub    %eax,%edx
 80488f6:	89 d0                	mov    %edx,%eax
 80488f8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488fd:	8b 48 08             	mov    0x8(%eax),%ecx
 8048900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048903:	89 c2                	mov    %eax,%edx
 8048905:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804890c:	89 c2                	mov    %eax,%edx
 804890e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048915:	29 d0                	sub    %edx,%eax
 8048917:	83 c0 10             	add    $0x10,%eax
 804891a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804891f:	8b 00                	mov    (%eax),%eax
 8048921:	8d 14 01             	lea    (%ecx,%eax,1),%edx
 8048924:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048927:	c1 e0 02             	shl    $0x2,%eax
 804892a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048931:	29 c1                	sub    %eax,%ecx
 8048933:	89 c8                	mov    %ecx,%eax
 8048935:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804893a:	89 50 08             	mov    %edx,0x8(%eax)

			if(mon.x < 10) mon.x++;
 804893d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048940:	c1 e0 02             	shl    $0x2,%eax
 8048943:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804894a:	29 c2                	sub    %eax,%edx
 804894c:	89 d0                	mov    %edx,%eax
 804894e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048953:	8b 40 04             	mov    0x4(%eax),%eax
 8048956:	83 f8 09             	cmp    $0x9,%eax
 8048959:	7f 35                	jg     8048990 <drawMonster+0x134>
 804895b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804895e:	c1 e0 02             	shl    $0x2,%eax
 8048961:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048968:	29 c2                	sub    %eax,%edx
 804896a:	89 d0                	mov    %edx,%eax
 804896c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048971:	8b 40 04             	mov    0x4(%eax),%eax
 8048974:	8d 50 01             	lea    0x1(%eax),%edx
 8048977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804897a:	c1 e0 02             	shl    $0x2,%eax
 804897d:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048984:	29 c1                	sub    %eax,%ecx
 8048986:	89 c8                	mov    %ecx,%eax
 8048988:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804898d:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.x > VWIDTH-10) mon.x--;
 8048990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048993:	c1 e0 02             	shl    $0x2,%eax
 8048996:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804899d:	29 c2                	sub    %eax,%edx
 804899f:	89 d0                	mov    %edx,%eax
 80489a1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489a6:	8b 40 04             	mov    0x4(%eax),%eax
 80489a9:	3d 36 01 00 00       	cmp    $0x136,%eax
 80489ae:	7e 35                	jle    80489e5 <drawMonster+0x189>
 80489b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489b3:	c1 e0 02             	shl    $0x2,%eax
 80489b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489bd:	29 c2                	sub    %eax,%edx
 80489bf:	89 d0                	mov    %edx,%eax
 80489c1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489c6:	8b 40 04             	mov    0x4(%eax),%eax
 80489c9:	8d 50 ff             	lea    -0x1(%eax),%edx
 80489cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489cf:	c1 e0 02             	shl    $0x2,%eax
 80489d2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80489d9:	29 c1                	sub    %eax,%ecx
 80489db:	89 c8                	mov    %ecx,%eax
 80489dd:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489e2:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.y < 10) mon.y++;
 80489e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489e8:	c1 e0 02             	shl    $0x2,%eax
 80489eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489f2:	29 c2                	sub    %eax,%edx
 80489f4:	89 d0                	mov    %edx,%eax
 80489f6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489fb:	8b 40 08             	mov    0x8(%eax),%eax
 80489fe:	83 f8 09             	cmp    $0x9,%eax
 8048a01:	7f 35                	jg     8048a38 <drawMonster+0x1dc>
 8048a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a06:	c1 e0 02             	shl    $0x2,%eax
 8048a09:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a10:	29 c2                	sub    %eax,%edx
 8048a12:	89 d0                	mov    %edx,%eax
 8048a14:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a19:	8b 40 08             	mov    0x8(%eax),%eax
 8048a1c:	8d 50 01             	lea    0x1(%eax),%edx
 8048a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a22:	c1 e0 02             	shl    $0x2,%eax
 8048a25:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a2c:	29 c1                	sub    %eax,%ecx
 8048a2e:	89 c8                	mov    %ecx,%eax
 8048a30:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a35:	89 50 08             	mov    %edx,0x8(%eax)
			if(mon.y > VHEIGHT-10) mon.y--;
 8048a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a3b:	c1 e0 02             	shl    $0x2,%eax
 8048a3e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a45:	29 c2                	sub    %eax,%edx
 8048a47:	89 d0                	mov    %edx,%eax
 8048a49:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a4e:	8b 40 08             	mov    0x8(%eax),%eax
 8048a51:	3d be 00 00 00       	cmp    $0xbe,%eax
 8048a56:	7e 35                	jle    8048a8d <drawMonster+0x231>
 8048a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a5b:	c1 e0 02             	shl    $0x2,%eax
 8048a5e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a65:	29 c2                	sub    %eax,%edx
 8048a67:	89 d0                	mov    %edx,%eax
 8048a69:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a6e:	8b 40 08             	mov    0x8(%eax),%eax
 8048a71:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a77:	c1 e0 02             	shl    $0x2,%eax
 8048a7a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a81:	29 c1                	sub    %eax,%ecx
 8048a83:	89 c8                	mov    %ecx,%eax
 8048a85:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a8a:	89 50 08             	mov    %edx,0x8(%eax)
			int color = size>=mon.size?15:5;
 8048a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a90:	c1 e0 02             	shl    $0x2,%eax
 8048a93:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a9a:	29 c2                	sub    %eax,%edx
 8048a9c:	89 d0                	mov    %edx,%eax
 8048a9e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048aa3:	8b 10                	mov    (%eax),%edx
 8048aa5:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048aaa:	39 c2                	cmp    %eax,%edx
 8048aac:	7f 07                	jg     8048ab5 <drawMonster+0x259>
 8048aae:	b8 0f 00 00 00       	mov    $0xf,%eax
 8048ab3:	eb 05                	jmp    8048aba <drawMonster+0x25e>
 8048ab5:	b8 05 00 00 00       	mov    $0x5,%eax
 8048aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
			drawCirc(mon.x, mon.y, mon.size, color);
 8048abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048ac0:	0f b6 d8             	movzbl %al,%ebx
 8048ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ac6:	c1 e0 02             	shl    $0x2,%eax
 8048ac9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ad0:	29 c2                	sub    %eax,%edx
 8048ad2:	89 d0                	mov    %edx,%eax
 8048ad4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ad9:	8b 08                	mov    (%eax),%ecx
 8048adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ade:	c1 e0 02             	shl    $0x2,%eax
 8048ae1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ae8:	29 c2                	sub    %eax,%edx
 8048aea:	89 d0                	mov    %edx,%eax
 8048aec:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048af1:	8b 50 08             	mov    0x8(%eax),%edx
 8048af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048af7:	c1 e0 02             	shl    $0x2,%eax
 8048afa:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
 8048b01:	29 c6                	sub    %eax,%esi
 8048b03:	89 f0                	mov    %esi,%eax
 8048b05:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b0a:	8b 40 04             	mov    0x4(%eax),%eax
 8048b0d:	53                   	push   %ebx
 8048b0e:	51                   	push   %ecx
 8048b0f:	52                   	push   %edx
 8048b10:	50                   	push   %eax
 8048b11:	e8 7d f8 ff ff       	call   8048393 <drawCirc>
 8048b16:	83 c4 10             	add    $0x10,%esp
			if(KISS()%60==0){
 8048b19:	e8 76 f5 ff ff       	call   8048094 <UKISS>
 8048b1e:	89 c2                	mov    %eax,%edx
 8048b20:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048b25:	01 c2                	add    %eax,%edx
 8048b27:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048b2c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048b2f:	ba 89 88 88 88       	mov    $0x88888889,%edx
 8048b34:	89 c8                	mov    %ecx,%eax
 8048b36:	f7 e2                	mul    %edx
 8048b38:	89 d0                	mov    %edx,%eax
 8048b3a:	c1 e8 05             	shr    $0x5,%eax
 8048b3d:	89 c2                	mov    %eax,%edx
 8048b3f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048b46:	89 c2                	mov    %eax,%edx
 8048b48:	89 d0                	mov    %edx,%eax
 8048b4a:	c1 e0 04             	shl    $0x4,%eax
 8048b4d:	29 d0                	sub    %edx,%eax
 8048b4f:	29 c1                	sub    %eax,%ecx
 8048b51:	89 c8                	mov    %ecx,%eax
 8048b53:	85 c0                	test   %eax,%eax
 8048b55:	0f 85 9a 00 00 00    	jne    8048bf5 <drawMonster+0x399>
				mon.sx = -1 + KISS()%3;
 8048b5b:	e8 34 f5 ff ff       	call   8048094 <UKISS>
 8048b60:	89 c2                	mov    %eax,%edx
 8048b62:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048b67:	01 c2                	add    %eax,%edx
 8048b69:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048b6e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048b71:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048b76:	89 c8                	mov    %ecx,%eax
 8048b78:	f7 e2                	mul    %edx
 8048b7a:	d1 ea                	shr    %edx
 8048b7c:	89 d0                	mov    %edx,%eax
 8048b7e:	01 c0                	add    %eax,%eax
 8048b80:	01 d0                	add    %edx,%eax
 8048b82:	29 c1                	sub    %eax,%ecx
 8048b84:	89 ca                	mov    %ecx,%edx
 8048b86:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048b89:	89 c1                	mov    %eax,%ecx
 8048b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b8e:	c1 e0 02             	shl    $0x2,%eax
 8048b91:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b98:	29 c2                	sub    %eax,%edx
 8048b9a:	89 d0                	mov    %edx,%eax
 8048b9c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ba1:	89 48 0c             	mov    %ecx,0xc(%eax)
				mon.sy = -1 + KISS()%3;
 8048ba4:	e8 eb f4 ff ff       	call   8048094 <UKISS>
 8048ba9:	89 c2                	mov    %eax,%edx
 8048bab:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048bb0:	01 c2                	add    %eax,%edx
 8048bb2:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048bb7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048bba:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048bbf:	89 c8                	mov    %ecx,%eax
 8048bc1:	f7 e2                	mul    %edx
 8048bc3:	d1 ea                	shr    %edx
 8048bc5:	89 d0                	mov    %edx,%eax
 8048bc7:	01 c0                	add    %eax,%eax
 8048bc9:	01 d0                	add    %edx,%eax
 8048bcb:	29 c1                	sub    %eax,%ecx
 8048bcd:	89 ca                	mov    %ecx,%edx
 8048bcf:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048bd2:	89 c1                	mov    %eax,%ecx
 8048bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048bd7:	89 c2                	mov    %eax,%edx
 8048bd9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048be0:	89 c2                	mov    %eax,%edx
 8048be2:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048be9:	29 d0                	sub    %edx,%eax
 8048beb:	83 c0 10             	add    $0x10,%eax
 8048bee:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048bf3:	89 08                	mov    %ecx,(%eax)
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
 8048bf5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048bf9:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048bfd:	0f 8e 6d fc ff ff    	jle    8048870 <drawMonster+0x14>
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
 8048c03:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8048c06:	5b                   	pop    %ebx
 8048c07:	5e                   	pop    %esi
 8048c08:	5d                   	pop    %ebp
 8048c09:	c3                   	ret    

08048c0a <createMonster>:
void createMonster(){
 8048c0a:	55                   	push   %ebp
 8048c0b:	89 e5                	mov    %esp,%ebp
 8048c0d:	83 ec 18             	sub    $0x18,%esp
	int i=0;
 8048c10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 8048c17:	e9 e0 01 00 00       	jmp    8048dfc <createMonster+0x1f2>
		if(mon.status == MONSTER_ALIVE) continue;
 8048c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c1f:	89 c2                	mov    %eax,%edx
 8048c21:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c28:	89 c2                	mov    %eax,%edx
 8048c2a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048c31:	29 d0                	sub    %edx,%eax
 8048c33:	83 c0 10             	add    $0x10,%eax
 8048c36:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c3b:	8b 40 04             	mov    0x4(%eax),%eax
 8048c3e:	85 c0                	test   %eax,%eax
 8048c40:	75 05                	jne    8048c47 <createMonster+0x3d>
 8048c42:	e9 b1 01 00 00       	jmp    8048df8 <createMonster+0x1ee>
		if(KISS()%(250*MONSTER_SIZE) == 0){
 8048c47:	e8 48 f4 ff ff       	call   8048094 <UKISS>
 8048c4c:	89 c2                	mov    %eax,%edx
 8048c4e:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c53:	01 c2                	add    %eax,%edx
 8048c55:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c5a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c5d:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
 8048c62:	89 c8                	mov    %ecx,%eax
 8048c64:	f7 e2                	mul    %edx
 8048c66:	89 d0                	mov    %edx,%eax
 8048c68:	c1 e8 0c             	shr    $0xc,%eax
 8048c6b:	69 c0 88 13 00 00    	imul   $0x1388,%eax,%eax
 8048c71:	29 c1                	sub    %eax,%ecx
 8048c73:	89 c8                	mov    %ecx,%eax
 8048c75:	85 c0                	test   %eax,%eax
 8048c77:	0f 85 7b 01 00 00    	jne    8048df8 <createMonster+0x1ee>
			mon.status = MONSTER_ALIVE;
 8048c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c80:	89 c2                	mov    %eax,%edx
 8048c82:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c89:	89 c2                	mov    %eax,%edx
 8048c8b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048c92:	29 d0                	sub    %edx,%eax
 8048c94:	83 c0 10             	add    $0x10,%eax
 8048c97:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			mon.size = 2 + 2*(KISS()%size);
 8048ca3:	e8 ec f3 ff ff       	call   8048094 <UKISS>
 8048ca8:	89 c2                	mov    %eax,%edx
 8048caa:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048caf:	01 c2                	add    %eax,%edx
 8048cb1:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048cb6:	01 d0                	add    %edx,%eax
 8048cb8:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048cbe:	89 d1                	mov    %edx,%ecx
 8048cc0:	ba 00 00 00 00       	mov    $0x0,%edx
 8048cc5:	f7 f1                	div    %ecx
 8048cc7:	89 d0                	mov    %edx,%eax
 8048cc9:	83 c0 01             	add    $0x1,%eax
 8048ccc:	01 c0                	add    %eax,%eax
 8048cce:	89 c1                	mov    %eax,%ecx
 8048cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048cd3:	c1 e0 02             	shl    $0x2,%eax
 8048cd6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048cdd:	29 c2                	sub    %eax,%edx
 8048cdf:	89 d0                	mov    %edx,%eax
 8048ce1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ce6:	89 08                	mov    %ecx,(%eax)
			mon.size = mon.size >14?14:mon.size; 
 8048ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ceb:	c1 e0 02             	shl    $0x2,%eax
 8048cee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048cf5:	29 c2                	sub    %eax,%edx
 8048cf7:	89 d0                	mov    %edx,%eax
 8048cf9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048cfe:	8b 00                	mov    (%eax),%eax
 8048d00:	89 c2                	mov    %eax,%edx
 8048d02:	83 fa 0e             	cmp    $0xe,%edx
 8048d05:	7e 05                	jle    8048d0c <createMonster+0x102>
 8048d07:	ba 0e 00 00 00       	mov    $0xe,%edx
 8048d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d0f:	c1 e0 02             	shl    $0x2,%eax
 8048d12:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048d19:	29 c1                	sub    %eax,%ecx
 8048d1b:	89 c8                	mov    %ecx,%eax
 8048d1d:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d22:	89 10                	mov    %edx,(%eax)
			mon.x = VWIDTH/2;
 8048d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d27:	c1 e0 02             	shl    $0x2,%eax
 8048d2a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d31:	29 c2                	sub    %eax,%edx
 8048d33:	89 d0                	mov    %edx,%eax
 8048d35:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d3a:	c7 40 04 a0 00 00 00 	movl   $0xa0,0x4(%eax)
			mon.y = VHEIGHT/2;
 8048d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d44:	c1 e0 02             	shl    $0x2,%eax
 8048d47:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d4e:	29 c2                	sub    %eax,%edx
 8048d50:	89 d0                	mov    %edx,%eax
 8048d52:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d57:	c7 40 08 64 00 00 00 	movl   $0x64,0x8(%eax)
			mon.sx = -1 + KISS()%3;
 8048d5e:	e8 31 f3 ff ff       	call   8048094 <UKISS>
 8048d63:	89 c2                	mov    %eax,%edx
 8048d65:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048d6a:	01 c2                	add    %eax,%edx
 8048d6c:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d71:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048d74:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048d79:	89 c8                	mov    %ecx,%eax
 8048d7b:	f7 e2                	mul    %edx
 8048d7d:	d1 ea                	shr    %edx
 8048d7f:	89 d0                	mov    %edx,%eax
 8048d81:	01 c0                	add    %eax,%eax
 8048d83:	01 d0                	add    %edx,%eax
 8048d85:	29 c1                	sub    %eax,%ecx
 8048d87:	89 ca                	mov    %ecx,%edx
 8048d89:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048d8c:	89 c1                	mov    %eax,%ecx
 8048d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d91:	c1 e0 02             	shl    $0x2,%eax
 8048d94:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d9b:	29 c2                	sub    %eax,%edx
 8048d9d:	89 d0                	mov    %edx,%eax
 8048d9f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048da4:	89 48 0c             	mov    %ecx,0xc(%eax)
			mon.sy = -1 + KISS()%3;
 8048da7:	e8 e8 f2 ff ff       	call   8048094 <UKISS>
 8048dac:	89 c2                	mov    %eax,%edx
 8048dae:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048db3:	01 c2                	add    %eax,%edx
 8048db5:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048dba:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048dbd:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048dc2:	89 c8                	mov    %ecx,%eax
 8048dc4:	f7 e2                	mul    %edx
 8048dc6:	d1 ea                	shr    %edx
 8048dc8:	89 d0                	mov    %edx,%eax
 8048dca:	01 c0                	add    %eax,%eax
 8048dcc:	01 d0                	add    %edx,%eax
 8048dce:	29 c1                	sub    %eax,%ecx
 8048dd0:	89 ca                	mov    %ecx,%edx
 8048dd2:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048dd5:	89 c1                	mov    %eax,%ecx
 8048dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048dda:	89 c2                	mov    %eax,%edx
 8048ddc:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048de3:	89 c2                	mov    %eax,%edx
 8048de5:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048dec:	29 d0                	sub    %edx,%eax
 8048dee:	83 c0 10             	add    $0x10,%eax
 8048df1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048df6:	89 08                	mov    %ecx,(%eax)
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
 8048df8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048dfc:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048e00:	0f 8e 16 fe ff ff    	jle    8048c1c <createMonster+0x12>
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
 8048e06:	c9                   	leave  
 8048e07:	c3                   	ret    

08048e08 <dreamOf100HZ>:

void dreamOf100HZ(int timestamp){
 8048e08:	55                   	push   %ebp
 8048e09:	89 e5                	mov    %esp,%ebp
 8048e0b:	83 ec 18             	sub    $0x18,%esp
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(gameStatus == GAME_START){
 8048e0e:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8048e13:	85 c0                	test   %eax,%eax
 8048e15:	0f 85 2b 04 00 00    	jne    8049246 <dreamOf100HZ+0x43e>
		//printf("%x\n", st);
		//printf("Score: %d\n", curtime);
		clearStage();
 8048e1b:	e8 a7 f4 ff ff       	call   80482c7 <clearStage>
		drawText1();
 8048e20:	e8 1b f6 ff ff       	call   8048440 <drawText1>
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();
 8048e25:	e8 e7 f7 ff ff       	call   8048611 <drawStage>

		int i=0;
 8048e2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		x = 30;
 8048e31:	c7 05 2c ba 04 08 1e 	movl   $0x1e,0x804ba2c
 8048e38:	00 00 00 
		y = 30;
 8048e3b:	c7 05 30 ba 04 08 1e 	movl   $0x1e,0x804ba30
 8048e42:	00 00 00 
		size = 4;
 8048e45:	c7 05 34 ba 04 08 04 	movl   $0x4,0x804ba34
 8048e4c:	00 00 00 
		score = 0;
 8048e4f:	c7 05 24 ba 04 08 00 	movl   $0x0,0x804ba24
 8048e56:	00 00 00 
		monsters[i].status = MONSTER_ALIVE;
 8048e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e5c:	89 c2                	mov    %eax,%edx
 8048e5e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048e65:	89 c2                	mov    %eax,%edx
 8048e67:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048e6e:	29 d0                	sub    %edx,%eax
 8048e70:	83 c0 10             	add    $0x10,%eax
 8048e73:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		monsters[i].size = 1 + (KISS()%size);
 8048e7f:	e8 10 f2 ff ff       	call   8048094 <UKISS>
 8048e84:	89 c2                	mov    %eax,%edx
 8048e86:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048e8b:	01 c2                	add    %eax,%edx
 8048e8d:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048e92:	01 d0                	add    %edx,%eax
 8048e94:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048e9a:	89 d1                	mov    %edx,%ecx
 8048e9c:	ba 00 00 00 00       	mov    $0x0,%edx
 8048ea1:	f7 f1                	div    %ecx
 8048ea3:	89 d0                	mov    %edx,%eax
 8048ea5:	83 c0 01             	add    $0x1,%eax
 8048ea8:	89 c1                	mov    %eax,%ecx
 8048eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ead:	c1 e0 02             	shl    $0x2,%eax
 8048eb0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048eb7:	29 c2                	sub    %eax,%edx
 8048eb9:	89 d0                	mov    %edx,%eax
 8048ebb:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ec0:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
 8048ec2:	e8 cd f1 ff ff       	call   8048094 <UKISS>
 8048ec7:	89 c2                	mov    %eax,%edx
 8048ec9:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048ece:	01 c2                	add    %eax,%edx
 8048ed0:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048ed5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048ed8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8048edd:	89 c8                	mov    %ecx,%eax
 8048edf:	f7 e2                	mul    %edx
 8048ee1:	c1 ea 08             	shr    $0x8,%edx
 8048ee4:	89 d0                	mov    %edx,%eax
 8048ee6:	c1 e0 02             	shl    $0x2,%eax
 8048ee9:	01 d0                	add    %edx,%eax
 8048eeb:	c1 e0 06             	shl    $0x6,%eax
 8048eee:	29 c1                	sub    %eax,%ecx
 8048ef0:	89 ca                	mov    %ecx,%edx
 8048ef2:	89 d1                	mov    %edx,%ecx
 8048ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ef7:	c1 e0 02             	shl    $0x2,%eax
 8048efa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f01:	29 c2                	sub    %eax,%edx
 8048f03:	89 d0                	mov    %edx,%eax
 8048f05:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f0a:	89 48 04             	mov    %ecx,0x4(%eax)
		monsters[i].y = KISS()%VHEIGHT;
 8048f0d:	e8 82 f1 ff ff       	call   8048094 <UKISS>
 8048f12:	89 c2                	mov    %eax,%edx
 8048f14:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f19:	01 c2                	add    %eax,%edx
 8048f1b:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f20:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f23:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8048f28:	89 c8                	mov    %ecx,%eax
 8048f2a:	f7 e2                	mul    %edx
 8048f2c:	89 d0                	mov    %edx,%eax
 8048f2e:	c1 e8 06             	shr    $0x6,%eax
 8048f31:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8048f37:	29 c1                	sub    %eax,%ecx
 8048f39:	89 c8                	mov    %ecx,%eax
 8048f3b:	89 c1                	mov    %eax,%ecx
 8048f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f40:	c1 e0 02             	shl    $0x2,%eax
 8048f43:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f4a:	29 c2                	sub    %eax,%edx
 8048f4c:	89 d0                	mov    %edx,%eax
 8048f4e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f53:	89 48 08             	mov    %ecx,0x8(%eax)
		monsters[i].sx = -1 + KISS()%3;
 8048f56:	e8 39 f1 ff ff       	call   8048094 <UKISS>
 8048f5b:	89 c2                	mov    %eax,%edx
 8048f5d:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f62:	01 c2                	add    %eax,%edx
 8048f64:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f69:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f6c:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048f71:	89 c8                	mov    %ecx,%eax
 8048f73:	f7 e2                	mul    %edx
 8048f75:	d1 ea                	shr    %edx
 8048f77:	89 d0                	mov    %edx,%eax
 8048f79:	01 c0                	add    %eax,%eax
 8048f7b:	01 d0                	add    %edx,%eax
 8048f7d:	29 c1                	sub    %eax,%ecx
 8048f7f:	89 ca                	mov    %ecx,%edx
 8048f81:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048f84:	89 c1                	mov    %eax,%ecx
 8048f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f89:	c1 e0 02             	shl    $0x2,%eax
 8048f8c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f93:	29 c2                	sub    %eax,%edx
 8048f95:	89 d0                	mov    %edx,%eax
 8048f97:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f9c:	89 48 0c             	mov    %ecx,0xc(%eax)
		monsters[i].sy = -1 + KISS()%3;
 8048f9f:	e8 f0 f0 ff ff       	call   8048094 <UKISS>
 8048fa4:	89 c2                	mov    %eax,%edx
 8048fa6:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048fab:	01 c2                	add    %eax,%edx
 8048fad:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048fb2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048fb5:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048fba:	89 c8                	mov    %ecx,%eax
 8048fbc:	f7 e2                	mul    %edx
 8048fbe:	d1 ea                	shr    %edx
 8048fc0:	89 d0                	mov    %edx,%eax
 8048fc2:	01 c0                	add    %eax,%eax
 8048fc4:	01 d0                	add    %edx,%eax
 8048fc6:	29 c1                	sub    %eax,%ecx
 8048fc8:	89 ca                	mov    %ecx,%edx
 8048fca:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048fcd:	89 c1                	mov    %eax,%ecx
 8048fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048fd2:	89 c2                	mov    %eax,%edx
 8048fd4:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048fdb:	89 c2                	mov    %eax,%edx
 8048fdd:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048fe4:	29 d0                	sub    %edx,%eax
 8048fe6:	83 c0 10             	add    $0x10,%eax
 8048fe9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048fee:	89 08                	mov    %ecx,(%eax)
		i++;
 8048ff0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		REP_MONSTER(){
 8048ff4:	e9 29 02 00 00       	jmp    8049222 <dreamOf100HZ+0x41a>
			monsters[i].status = MONSTER_SLEEP;
 8048ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ffc:	89 c2                	mov    %eax,%edx
 8048ffe:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049005:	89 c2                	mov    %eax,%edx
 8049007:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804900e:	29 d0                	sub    %edx,%eax
 8049010:	83 c0 10             	add    $0x10,%eax
 8049013:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049018:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
			monsters[i].count = 0;
 804901f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049022:	89 c2                	mov    %eax,%edx
 8049024:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804902b:	89 c2                	mov    %eax,%edx
 804902d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049034:	29 d0                	sub    %edx,%eax
 8049036:	83 c0 10             	add    $0x10,%eax
 8049039:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804903e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			if(KISS()%MONSTER_SIZE < size+3){
 8049045:	e8 4a f0 ff ff       	call   8048094 <UKISS>
 804904a:	89 c2                	mov    %eax,%edx
 804904c:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049051:	01 c2                	add    %eax,%edx
 8049053:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049058:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804905b:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8049060:	89 c8                	mov    %ecx,%eax
 8049062:	f7 e2                	mul    %edx
 8049064:	c1 ea 04             	shr    $0x4,%edx
 8049067:	89 d0                	mov    %edx,%eax
 8049069:	c1 e0 02             	shl    $0x2,%eax
 804906c:	01 d0                	add    %edx,%eax
 804906e:	c1 e0 02             	shl    $0x2,%eax
 8049071:	29 c1                	sub    %eax,%ecx
 8049073:	89 ca                	mov    %ecx,%edx
 8049075:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 804907a:	83 c0 03             	add    $0x3,%eax
 804907d:	39 c2                	cmp    %eax,%edx
 804907f:	0f 83 99 01 00 00    	jae    804921e <dreamOf100HZ+0x416>
				monsters[i].status = MONSTER_ALIVE;
 8049085:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049088:	89 c2                	mov    %eax,%edx
 804908a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049091:	89 c2                	mov    %eax,%edx
 8049093:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804909a:	29 d0                	sub    %edx,%eax
 804909c:	83 c0 10             	add    $0x10,%eax
 804909f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80490a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				monsters[i].size = 1 + 2*(KISS()%size);
 80490ab:	e8 e4 ef ff ff       	call   8048094 <UKISS>
 80490b0:	89 c2                	mov    %eax,%edx
 80490b2:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80490b7:	01 c2                	add    %eax,%edx
 80490b9:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80490be:	01 d0                	add    %edx,%eax
 80490c0:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 80490c6:	89 d1                	mov    %edx,%ecx
 80490c8:	ba 00 00 00 00       	mov    $0x0,%edx
 80490cd:	f7 f1                	div    %ecx
 80490cf:	89 d0                	mov    %edx,%eax
 80490d1:	01 c0                	add    %eax,%eax
 80490d3:	83 c0 01             	add    $0x1,%eax
 80490d6:	89 c1                	mov    %eax,%ecx
 80490d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80490db:	c1 e0 02             	shl    $0x2,%eax
 80490de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80490e5:	29 c2                	sub    %eax,%edx
 80490e7:	89 d0                	mov    %edx,%eax
 80490e9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80490ee:	89 08                	mov    %ecx,(%eax)
				monsters[i].x = KISS()%VWIDTH;
 80490f0:	e8 9f ef ff ff       	call   8048094 <UKISS>
 80490f5:	89 c2                	mov    %eax,%edx
 80490f7:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80490fc:	01 c2                	add    %eax,%edx
 80490fe:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049103:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049106:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 804910b:	89 c8                	mov    %ecx,%eax
 804910d:	f7 e2                	mul    %edx
 804910f:	c1 ea 08             	shr    $0x8,%edx
 8049112:	89 d0                	mov    %edx,%eax
 8049114:	c1 e0 02             	shl    $0x2,%eax
 8049117:	01 d0                	add    %edx,%eax
 8049119:	c1 e0 06             	shl    $0x6,%eax
 804911c:	29 c1                	sub    %eax,%ecx
 804911e:	89 ca                	mov    %ecx,%edx
 8049120:	89 d1                	mov    %edx,%ecx
 8049122:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049125:	c1 e0 02             	shl    $0x2,%eax
 8049128:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804912f:	29 c2                	sub    %eax,%edx
 8049131:	89 d0                	mov    %edx,%eax
 8049133:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049138:	89 48 04             	mov    %ecx,0x4(%eax)
				monsters[i].y = KISS()%VHEIGHT;
 804913b:	e8 54 ef ff ff       	call   8048094 <UKISS>
 8049140:	89 c2                	mov    %eax,%edx
 8049142:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049147:	01 c2                	add    %eax,%edx
 8049149:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804914e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049151:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8049156:	89 c8                	mov    %ecx,%eax
 8049158:	f7 e2                	mul    %edx
 804915a:	89 d0                	mov    %edx,%eax
 804915c:	c1 e8 06             	shr    $0x6,%eax
 804915f:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8049165:	29 c1                	sub    %eax,%ecx
 8049167:	89 c8                	mov    %ecx,%eax
 8049169:	89 c1                	mov    %eax,%ecx
 804916b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804916e:	c1 e0 02             	shl    $0x2,%eax
 8049171:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049178:	29 c2                	sub    %eax,%edx
 804917a:	89 d0                	mov    %edx,%eax
 804917c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049181:	89 48 08             	mov    %ecx,0x8(%eax)
				monsters[i].sx = -1 + KISS()%3;
 8049184:	e8 0b ef ff ff       	call   8048094 <UKISS>
 8049189:	89 c2                	mov    %eax,%edx
 804918b:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049190:	01 c2                	add    %eax,%edx
 8049192:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049197:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804919a:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 804919f:	89 c8                	mov    %ecx,%eax
 80491a1:	f7 e2                	mul    %edx
 80491a3:	d1 ea                	shr    %edx
 80491a5:	89 d0                	mov    %edx,%eax
 80491a7:	01 c0                	add    %eax,%eax
 80491a9:	01 d0                	add    %edx,%eax
 80491ab:	29 c1                	sub    %eax,%ecx
 80491ad:	89 ca                	mov    %ecx,%edx
 80491af:	8d 42 ff             	lea    -0x1(%edx),%eax
 80491b2:	89 c1                	mov    %eax,%ecx
 80491b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491b7:	c1 e0 02             	shl    $0x2,%eax
 80491ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80491c1:	29 c2                	sub    %eax,%edx
 80491c3:	89 d0                	mov    %edx,%eax
 80491c5:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80491ca:	89 48 0c             	mov    %ecx,0xc(%eax)
				monsters[i].sy = -1 + KISS()%3;
 80491cd:	e8 c2 ee ff ff       	call   8048094 <UKISS>
 80491d2:	89 c2                	mov    %eax,%edx
 80491d4:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80491d9:	01 c2                	add    %eax,%edx
 80491db:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80491e0:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80491e3:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 80491e8:	89 c8                	mov    %ecx,%eax
 80491ea:	f7 e2                	mul    %edx
 80491ec:	d1 ea                	shr    %edx
 80491ee:	89 d0                	mov    %edx,%eax
 80491f0:	01 c0                	add    %eax,%eax
 80491f2:	01 d0                	add    %edx,%eax
 80491f4:	29 c1                	sub    %eax,%ecx
 80491f6:	89 ca                	mov    %ecx,%edx
 80491f8:	8d 42 ff             	lea    -0x1(%edx),%eax
 80491fb:	89 c1                	mov    %eax,%ecx
 80491fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049200:	89 c2                	mov    %eax,%edx
 8049202:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049209:	89 c2                	mov    %eax,%edx
 804920b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049212:	29 d0                	sub    %edx,%eax
 8049214:	83 c0 10             	add    $0x10,%eax
 8049217:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804921c:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
 804921e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049222:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8049226:	0f 8e cd fd ff ff    	jle    8048ff9 <dreamOf100HZ+0x1f1>
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printf("Press Q to start\n");
 804922c:	83 ec 0c             	sub    $0xc,%esp
 804922f:	68 03 a0 04 08       	push   $0x804a003
 8049234:	e8 eb 04 00 00       	call   8049724 <printf>
 8049239:	83 c4 10             	add    $0x10,%esp
		gameStatus = GAME_READY;
 804923c:	c7 05 28 ba 04 08 01 	movl   $0x1,0x804ba28
 8049243:	00 00 00 
	}
	if(gameStatus == GAME_READY){
 8049246:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 804924b:	83 f8 01             	cmp    $0x1,%eax
 804924e:	75 2b                	jne    804927b <dreamOf100HZ+0x473>
		//printf("%d\n", key('q'));
		if(key('q') ){
 8049250:	83 ec 0c             	sub    $0xc,%esp
 8049253:	6a 71                	push   $0x71
 8049255:	e8 dc f3 ff ff       	call   8048636 <key>
 804925a:	83 c4 10             	add    $0x10,%esp
 804925d:	84 c0                	test   %al,%al
 804925f:	74 1a                	je     804927b <dreamOf100HZ+0x473>
			printf("Press W, A, S, D to move\n");
 8049261:	83 ec 0c             	sub    $0xc,%esp
 8049264:	68 15 a0 04 08       	push   $0x804a015
 8049269:	e8 b6 04 00 00       	call   8049724 <printf>
 804926e:	83 c4 10             	add    $0x10,%esp
			gameStatus = GAME_ING;
 8049271:	c7 05 28 ba 04 08 02 	movl   $0x2,0x804ba28
 8049278:	00 00 00 
		}
	}

	if(gameStatus == GAME_ING){
 804927b:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8049280:	83 f8 02             	cmp    $0x2,%eax
 8049283:	0f 85 68 01 00 00    	jne    80493f1 <dreamOf100HZ+0x5e9>



		//if(x>0 && x<VWIDTH && y>0 && y<VHEIGHT){
		//if(timestamp % 3){
			if(key('a'))x--;
 8049289:	83 ec 0c             	sub    $0xc,%esp
 804928c:	6a 61                	push   $0x61
 804928e:	e8 a3 f3 ff ff       	call   8048636 <key>
 8049293:	83 c4 10             	add    $0x10,%esp
 8049296:	84 c0                	test   %al,%al
 8049298:	74 0d                	je     80492a7 <dreamOf100HZ+0x49f>
 804929a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804929f:	83 e8 01             	sub    $0x1,%eax
 80492a2:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
			if(key('d'))x++;
 80492a7:	83 ec 0c             	sub    $0xc,%esp
 80492aa:	6a 64                	push   $0x64
 80492ac:	e8 85 f3 ff ff       	call   8048636 <key>
 80492b1:	83 c4 10             	add    $0x10,%esp
 80492b4:	84 c0                	test   %al,%al
 80492b6:	74 0d                	je     80492c5 <dreamOf100HZ+0x4bd>
 80492b8:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80492bd:	83 c0 01             	add    $0x1,%eax
 80492c0:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
			if(key('w'))y--;
 80492c5:	83 ec 0c             	sub    $0xc,%esp
 80492c8:	6a 77                	push   $0x77
 80492ca:	e8 67 f3 ff ff       	call   8048636 <key>
 80492cf:	83 c4 10             	add    $0x10,%esp
 80492d2:	84 c0                	test   %al,%al
 80492d4:	74 0d                	je     80492e3 <dreamOf100HZ+0x4db>
 80492d6:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80492db:	83 e8 01             	sub    $0x1,%eax
 80492de:	a3 30 ba 04 08       	mov    %eax,0x804ba30
			if(key('s'))y++;
 80492e3:	83 ec 0c             	sub    $0xc,%esp
 80492e6:	6a 73                	push   $0x73
 80492e8:	e8 49 f3 ff ff       	call   8048636 <key>
 80492ed:	83 c4 10             	add    $0x10,%esp
 80492f0:	84 c0                	test   %al,%al
 80492f2:	74 0d                	je     8049301 <dreamOf100HZ+0x4f9>
 80492f4:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80492f9:	83 c0 01             	add    $0x1,%eax
 80492fc:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}

		if(x < 0) x++;
 8049301:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049306:	85 c0                	test   %eax,%eax
 8049308:	79 0d                	jns    8049317 <dreamOf100HZ+0x50f>
 804930a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804930f:	83 c0 01             	add    $0x1,%eax
 8049312:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(x > VWIDTH) x--;
 8049317:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804931c:	3d 40 01 00 00       	cmp    $0x140,%eax
 8049321:	7e 0d                	jle    8049330 <dreamOf100HZ+0x528>
 8049323:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049328:	83 e8 01             	sub    $0x1,%eax
 804932b:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(y < 0) y++;
 8049330:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049335:	85 c0                	test   %eax,%eax
 8049337:	79 0d                	jns    8049346 <dreamOf100HZ+0x53e>
 8049339:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804933e:	83 c0 01             	add    $0x1,%eax
 8049341:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(y > VHEIGHT) y--;
 8049346:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804934b:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049350:	7e 0d                	jle    804935f <dreamOf100HZ+0x557>
 8049352:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049357:	83 e8 01             	sub    $0x1,%eax
 804935a:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		//else{
		clearStage();
 804935f:	e8 63 ef ff ff       	call   80482c7 <clearStage>
		drawCirc(x, y, size, 3);
 8049364:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 804936a:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 8049370:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049375:	6a 03                	push   $0x3
 8049377:	51                   	push   %ecx
 8049378:	52                   	push   %edx
 8049379:	50                   	push   %eax
 804937a:	e8 14 f0 ff ff       	call   8048393 <drawCirc>
 804937f:	83 c4 10             	add    $0x10,%esp
		

		drawMonster();
 8049382:	e8 d5 f4 ff ff       	call   804885c <drawMonster>
		drawCirc(x, y, size, 3);
 8049387:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 804938d:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 8049393:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049398:	6a 03                	push   $0x3
 804939a:	51                   	push   %ecx
 804939b:	52                   	push   %edx
 804939c:	50                   	push   %eax
 804939d:	e8 f1 ef ff ff       	call   8048393 <drawCirc>
 80493a2:	83 c4 10             	add    $0x10,%esp
		drawNumber(score, 0, 180, 1, 7);
 80493a5:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 80493aa:	83 ec 0c             	sub    $0xc,%esp
 80493ad:	6a 07                	push   $0x7
 80493af:	6a 01                	push   $0x1
 80493b1:	68 b4 00 00 00       	push   $0xb4
 80493b6:	6a 00                	push   $0x0
 80493b8:	50                   	push   %eax
 80493b9:	e8 fa f0 ff ff       	call   80484b8 <drawNumber>
 80493be:	83 c4 20             	add    $0x20,%esp
		drawNumber(sys_pid(), 50, 180, 1, 7);
 80493c1:	e8 a1 ed ff ff       	call   8048167 <sys_pid>
 80493c6:	83 ec 0c             	sub    $0xc,%esp
 80493c9:	6a 07                	push   $0x7
 80493cb:	6a 01                	push   $0x1
 80493cd:	68 b4 00 00 00       	push   $0xb4
 80493d2:	6a 32                	push   $0x32
 80493d4:	50                   	push   %eax
 80493d5:	e8 de f0 ff ff       	call   80484b8 <drawNumber>
 80493da:	83 c4 20             	add    $0x20,%esp
		drawStage();
 80493dd:	e8 2f f2 ff ff       	call   8048611 <drawStage>
		
		
		createMonster();
 80493e2:	e8 23 f8 ff ff       	call   8048c0a <createMonster>
		while(hitMonster());
 80493e7:	90                   	nop
 80493e8:	e8 b0 f2 ff ff       	call   804869d <hitMonster>
 80493ed:	85 c0                	test   %eax,%eax
 80493ef:	75 f7                	jne    80493e8 <dreamOf100HZ+0x5e0>
		//}
	}
	if(gameStatus == GAME_END){
 80493f1:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 80493f6:	83 f8 03             	cmp    $0x3,%eax
 80493f9:	75 3a                	jne    8049435 <dreamOf100HZ+0x62d>
		printf("You're dead\n");
 80493fb:	83 ec 0c             	sub    $0xc,%esp
 80493fe:	68 2f a0 04 08       	push   $0x804a02f
 8049403:	e8 1c 03 00 00       	call   8049724 <printf>
 8049408:	83 c4 10             	add    $0x10,%esp
		printf("Score: %d\n", score);
 804940b:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 8049410:	83 ec 08             	sub    $0x8,%esp
 8049413:	50                   	push   %eax
 8049414:	68 3c a0 04 08       	push   $0x804a03c
 8049419:	e8 06 03 00 00       	call   8049724 <printf>
 804941e:	83 c4 10             	add    $0x10,%esp
		clearStage();
 8049421:	e8 a1 ee ff ff       	call   80482c7 <clearStage>
		drawStage();
 8049426:	e8 e6 f1 ff ff       	call   8048611 <drawStage>
		gameStatus = GAME_START;
 804942b:	c7 05 28 ba 04 08 00 	movl   $0x0,0x804ba28
 8049432:	00 00 00 
	}
 8049435:	c9                   	leave  
 8049436:	c3                   	ret    

08049437 <sys_printch>:
}
static inline void sys_sleep(uint32_t c){
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 8049437:	55                   	push   %ebp
 8049438:	89 e5                	mov    %esp,%ebp
 804943a:	53                   	push   %ebx
 804943b:	83 ec 04             	sub    $0x4,%esp
 804943e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049441:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 8049444:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 8049449:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 804944d:	89 d3                	mov    %edx,%ebx
 804944f:	cd 80                	int    $0x80
}
 8049451:	83 c4 04             	add    $0x4,%esp
 8049454:	5b                   	pop    %ebx
 8049455:	5d                   	pop    %ebp
 8049456:	c3                   	ret    

08049457 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 8049457:	55                   	push   %ebp
 8049458:	89 e5                	mov    %esp,%ebp
 804945a:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 804945d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049460:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 8049463:	eb 19                	jmp    804947e <printp+0x27>
		printer(cur);
 8049465:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049468:	0f b6 00             	movzbl (%eax),%eax
 804946b:	0f be c0             	movsbl %al,%eax
 804946e:	83 ec 0c             	sub    $0xc,%esp
 8049471:	50                   	push   %eax
 8049472:	8b 45 08             	mov    0x8(%ebp),%eax
 8049475:	ff d0                	call   *%eax
 8049477:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 804947a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804947e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049481:	0f b6 00             	movzbl (%eax),%eax
 8049484:	84 c0                	test   %al,%al
 8049486:	75 dd                	jne    8049465 <printp+0xe>
		printer(cur);
	}
}
 8049488:	c9                   	leave  
 8049489:	c3                   	ret    

0804948a <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 804948a:	55                   	push   %ebp
 804948b:	89 e5                	mov    %esp,%ebp
 804948d:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 8049490:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049493:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 8049496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 804949d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 80494a4:	8b 45 10             	mov    0x10(%ebp),%eax
 80494a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 80494aa:	e9 65 02 00 00       	jmp    8049714 <vfprintf+0x28a>

		if(cur == '%'){
 80494af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80494b2:	0f b6 00             	movzbl (%eax),%eax
 80494b5:	3c 25                	cmp    $0x25,%al
 80494b7:	75 0c                	jne    80494c5 <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 80494b9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 80494c0:	e9 4b 02 00 00       	jmp    8049710 <vfprintf+0x286>
		}
		if(type == READ){
 80494c5:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 80494c9:	0f 85 26 02 00 00    	jne    80496f5 <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 80494cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80494d2:	0f b6 00             	movzbl (%eax),%eax
 80494d5:	3c 73                	cmp    $0x73,%al
 80494d7:	75 35                	jne    804950e <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 80494d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80494dc:	8b 00                	mov    (%eax),%eax
 80494de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 80494e1:	eb 19                	jmp    80494fc <vfprintf+0x72>
					printer(*p);
 80494e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80494e6:	0f b6 00             	movzbl (%eax),%eax
 80494e9:	0f be c0             	movsbl %al,%eax
 80494ec:	83 ec 0c             	sub    $0xc,%esp
 80494ef:	50                   	push   %eax
 80494f0:	8b 45 08             	mov    0x8(%ebp),%eax
 80494f3:	ff d0                	call   *%eax
 80494f5:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 80494f8:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 80494fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80494ff:	0f b6 00             	movzbl (%eax),%eax
 8049502:	84 c0                	test   %al,%al
 8049504:	75 dd                	jne    80494e3 <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 8049506:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804950a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 804950e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049511:	0f b6 00             	movzbl (%eax),%eax
 8049514:	3c 78                	cmp    $0x78,%al
 8049516:	0f 85 99 00 00 00    	jne    80495b5 <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 804951c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804951f:	8b 00                	mov    (%eax),%eax
 8049521:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 8049524:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8049528:	75 1d                	jne    8049547 <vfprintf+0xbd>
					printer('0');
 804952a:	83 ec 0c             	sub    $0xc,%esp
 804952d:	6a 30                	push   $0x30
 804952f:	8b 45 08             	mov    0x8(%ebp),%eax
 8049532:	ff d0                	call   *%eax
 8049534:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8049537:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804953b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8049542:	e9 c9 01 00 00       	jmp    8049710 <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 8049547:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 804954e:	eb 2d                	jmp    804957d <vfprintf+0xf3>
					int d=(x%16);
 8049550:	8b 45 e0             	mov    -0x20(%ebp),%eax
 8049553:	83 e0 0f             	and    $0xf,%eax
 8049556:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8049559:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 804955d:	7e 04                	jle    8049563 <vfprintf+0xd9>
						d+='a'-'0'-10;
 804955f:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 8049563:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8049566:	83 c0 30             	add    $0x30,%eax
 8049569:	89 c1                	mov    %eax,%ecx
 804956b:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804956e:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8049571:	01 d0                	add    %edx,%eax
 8049573:	88 08                	mov    %cl,(%eax)
					x>>=4;
 8049575:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8049579:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 804957d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 8049581:	75 cd                	jne    8049550 <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 8049583:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8049587:	eb 1e                	jmp    80495a7 <vfprintf+0x11d>
					printer(digits[di]);
 8049589:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 804958c:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804958f:	01 d0                	add    %edx,%eax
 8049591:	0f b6 00             	movzbl (%eax),%eax
 8049594:	0f be c0             	movsbl %al,%eax
 8049597:	83 ec 0c             	sub    $0xc,%esp
 804959a:	50                   	push   %eax
 804959b:	8b 45 08             	mov    0x8(%ebp),%eax
 804959e:	ff d0                	call   *%eax
 80495a0:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 80495a3:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 80495a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 80495ab:	79 dc                	jns    8049589 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80495ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80495b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 80495b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80495b8:	0f b6 00             	movzbl (%eax),%eax
 80495bb:	3c 64                	cmp    $0x64,%al
 80495bd:	0f 85 02 01 00 00    	jne    80496c5 <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 80495c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80495c6:	8b 00                	mov    (%eax),%eax
 80495c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 80495cb:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 80495d2:	75 23                	jne    80495f7 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 80495d4:	83 ec 08             	sub    $0x8,%esp
 80495d7:	68 47 a0 04 08       	push   $0x804a047
 80495dc:	ff 75 08             	pushl  0x8(%ebp)
 80495df:	e8 73 fe ff ff       	call   8049457 <printp>
 80495e4:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80495e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80495eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80495f2:	e9 19 01 00 00       	jmp    8049710 <vfprintf+0x286>
				}
				if(x==0){
 80495f7:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80495fb:	75 1e                	jne    804961b <vfprintf+0x191>
					printer('0');
 80495fd:	83 ec 0c             	sub    $0xc,%esp
 8049600:	6a 30                	push   $0x30
 8049602:	8b 45 08             	mov    0x8(%ebp),%eax
 8049605:	ff d0                	call   *%eax
 8049607:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 804960a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 804960e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 8049615:	90                   	nop
 8049616:	e9 f5 00 00 00       	jmp    8049710 <vfprintf+0x286>
				}
				if(x<0){
 804961b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804961f:	79 10                	jns    8049631 <vfprintf+0x1a7>
					printer('-');
 8049621:	83 ec 0c             	sub    $0xc,%esp
 8049624:	6a 2d                	push   $0x2d
 8049626:	8b 45 08             	mov    0x8(%ebp),%eax
 8049629:	ff d0                	call   *%eax
 804962b:	83 c4 10             	add    $0x10,%esp
					x=-x;
 804962e:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 8049631:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 8049638:	eb 53                	jmp    804968d <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 804963a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804963d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8049642:	89 c8                	mov    %ecx,%eax
 8049644:	f7 ea                	imul   %edx
 8049646:	c1 fa 02             	sar    $0x2,%edx
 8049649:	89 c8                	mov    %ecx,%eax
 804964b:	c1 f8 1f             	sar    $0x1f,%eax
 804964e:	29 c2                	sub    %eax,%edx
 8049650:	89 d0                	mov    %edx,%eax
 8049652:	c1 e0 02             	shl    $0x2,%eax
 8049655:	01 d0                	add    %edx,%eax
 8049657:	01 c0                	add    %eax,%eax
 8049659:	29 c1                	sub    %eax,%ecx
 804965b:	89 ca                	mov    %ecx,%edx
 804965d:	89 d0                	mov    %edx,%eax
 804965f:	83 c0 30             	add    $0x30,%eax
 8049662:	89 c1                	mov    %eax,%ecx
 8049664:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8049667:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804966a:	01 d0                	add    %edx,%eax
 804966c:	88 08                	mov    %cl,(%eax)
					x/=10;
 804966e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 8049671:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8049676:	89 c8                	mov    %ecx,%eax
 8049678:	f7 ea                	imul   %edx
 804967a:	c1 fa 02             	sar    $0x2,%edx
 804967d:	89 c8                	mov    %ecx,%eax
 804967f:	c1 f8 1f             	sar    $0x1f,%eax
 8049682:	29 c2                	sub    %eax,%edx
 8049684:	89 d0                	mov    %edx,%eax
 8049686:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 8049689:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 804968d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 8049691:	7f a7                	jg     804963a <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 8049693:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 8049697:	eb 1e                	jmp    80496b7 <vfprintf+0x22d>
					printer(digits[di]);
 8049699:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 804969c:	8b 45 d0             	mov    -0x30(%ebp),%eax
 804969f:	01 d0                	add    %edx,%eax
 80496a1:	0f b6 00             	movzbl (%eax),%eax
 80496a4:	0f be c0             	movsbl %al,%eax
 80496a7:	83 ec 0c             	sub    $0xc,%esp
 80496aa:	50                   	push   %eax
 80496ab:	8b 45 08             	mov    0x8(%ebp),%eax
 80496ae:	ff d0                	call   *%eax
 80496b0:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 80496b3:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 80496b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 80496bb:	79 dc                	jns    8049699 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 80496bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80496c1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 80496c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496c8:	0f b6 00             	movzbl (%eax),%eax
 80496cb:	3c 63                	cmp    $0x63,%al
 80496cd:	75 1d                	jne    80496ec <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 80496cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80496d2:	0f b6 00             	movzbl (%eax),%eax
 80496d5:	0f be c0             	movsbl %al,%eax
 80496d8:	83 ec 0c             	sub    $0xc,%esp
 80496db:	50                   	push   %eax
 80496dc:	8b 45 08             	mov    0x8(%ebp),%eax
 80496df:	ff d0                	call   *%eax
 80496e1:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 80496e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80496e8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 80496ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 80496f3:	eb 1b                	jmp    8049710 <vfprintf+0x286>
		}
		if(type == NONE){
 80496f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80496f9:	75 15                	jne    8049710 <vfprintf+0x286>
			printer(cur);
 80496fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80496fe:	0f b6 00             	movzbl (%eax),%eax
 8049701:	0f be c0             	movsbl %al,%eax
 8049704:	83 ec 0c             	sub    $0xc,%esp
 8049707:	50                   	push   %eax
 8049708:	8b 45 08             	mov    0x8(%ebp),%eax
 804970b:	ff d0                	call   *%eax
 804970d:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 8049710:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049714:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049717:	0f b6 00             	movzbl (%eax),%eax
 804971a:	84 c0                	test   %al,%al
 804971c:	0f 85 8d fd ff ff    	jne    80494af <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 8049722:	c9                   	leave  
 8049723:	c3                   	ret    

08049724 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 8049724:	55                   	push   %ebp
 8049725:	89 e5                	mov    %esp,%ebp
 8049727:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 804972a:	8d 45 0c             	lea    0xc(%ebp),%eax
 804972d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 8049730:	8b 45 08             	mov    0x8(%ebp),%eax
 8049733:	83 ec 04             	sub    $0x4,%esp
 8049736:	ff 75 f4             	pushl  -0xc(%ebp)
 8049739:	50                   	push   %eax
 804973a:	68 37 94 04 08       	push   $0x8049437
 804973f:	e8 46 fd ff ff       	call   804948a <vfprintf>
 8049744:	83 c4 10             	add    $0x10,%esp
}
 8049747:	c9                   	leave  
 8049748:	c3                   	ret    
