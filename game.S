
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
static inline uint32_t sys_fork(){
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_FORK)); //SYSCALL HERE!
	return r_eax;
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

08048183 <sys_sleep>:
	uint32_t r_eax = 0;
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_PPID)); //SYSCALL HERE!
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
}
static inline void sys_sleep(uint32_t c){
 8048183:	55                   	push   %ebp
 8048184:	89 e5                	mov    %esp,%ebp
 8048186:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SLEEP), "b"(c)); //SYSCALL HERE!
 8048187:	b8 de 05 00 00       	mov    $0x5de,%eax
 804818c:	8b 55 08             	mov    0x8(%ebp),%edx
 804818f:	89 d3                	mov    %edx,%ebx
 8048191:	cd 80                	int    $0x80
}
 8048193:	5b                   	pop    %ebx
 8048194:	5d                   	pop    %ebp
 8048195:	c3                   	ret    

08048196 <sys_init_vcache>:

static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
 8048196:	55                   	push   %ebp
 8048197:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
 8048199:	b8 4c 04 00 00       	mov    $0x44c,%eax
 804819e:	cd 80                	int    $0x80
}
 80481a0:	5d                   	pop    %ebp
 80481a1:	c3                   	ret    

080481a2 <sys_flush_vcache>:

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
 80481a2:	55                   	push   %ebp
 80481a3:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
 80481a5:	b8 4e 04 00 00       	mov    $0x44e,%eax
 80481aa:	cd 80                	int    $0x80
}
 80481ac:	5d                   	pop    %ebp
 80481ad:	c3                   	ret    

080481ae <sys_set_pixel>:
static inline void sys_set_pixel(int x, int y, int color){
 80481ae:	55                   	push   %ebp
 80481af:	89 e5                	mov    %esp,%ebp
 80481b1:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
 80481b2:	b8 4f 04 00 00       	mov    $0x44f,%eax
 80481b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
 80481ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 80481bd:	8b 55 10             	mov    0x10(%ebp),%edx
 80481c0:	cd 80                	int    $0x80
}
 80481c2:	5b                   	pop    %ebx
 80481c3:	5d                   	pop    %ebp
 80481c4:	c3                   	ret    

080481c5 <sys_key_down>:
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
 80481c5:	55                   	push   %ebp
 80481c6:	89 e5                	mov    %esp,%ebp
 80481c8:	53                   	push   %ebx
 80481c9:	83 ec 14             	sub    $0x14,%esp
 80481cc:	8b 45 08             	mov    0x8(%ebp),%eax
 80481cf:	88 45 e8             	mov    %al,-0x18(%ebp)
	char r_eax = 0;
 80481d2:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
 80481d6:	b8 b0 04 00 00       	mov    $0x4b0,%eax
 80481db:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 80481df:	89 d3                	mov    %edx,%ebx
 80481e1:	cd 80                	int    $0x80
 80481e3:	88 45 fb             	mov    %al,-0x5(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 80481e6:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
 80481ea:	83 c4 14             	add    $0x14,%esp
 80481ed:	5b                   	pop    %ebx
 80481ee:	5d                   	pop    %ebp
 80481ef:	c3                   	ret    

080481f0 <sys_get_tick>:
static inline uint32_t sys_get_tick(){
 80481f0:	55                   	push   %ebp
 80481f1:	89 e5                	mov    %esp,%ebp
 80481f3:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
 80481f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
 80481fd:	b8 15 05 00 00       	mov    $0x515,%eax
 8048202:	cd 80                	int    $0x80
 8048204:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
 8048207:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 804820a:	c9                   	leave  
 804820b:	c3                   	ret    

0804820c <isqrt>:
    1,1,1,1,1
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
 804820c:	55                   	push   %ebp
 804820d:	89 e5                	mov    %esp,%ebp
 804820f:	83 ec 10             	sub    $0x10,%esp
    if(memoriza[x] > 0) return memoriza[x];
 8048212:	8b 45 08             	mov    0x8(%ebp),%eax
 8048215:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 804821c:	85 c0                	test   %eax,%eax
 804821e:	74 0f                	je     804822f <isqrt+0x23>
 8048220:	8b 45 08             	mov    0x8(%ebp),%eax
 8048223:	8b 04 85 c0 b0 04 08 	mov    0x804b0c0(,%eax,4),%eax
 804822a:	e9 a9 00 00 00       	jmp    80482d8 <isqrt+0xcc>
    const uint16_t *p = squares;
 804822f:	c7 45 fc 00 98 04 08 	movl   $0x8049800,-0x4(%ebp)
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
 8048236:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048239:	83 c0 40             	add    $0x40,%eax
 804823c:	0f b7 00             	movzwl (%eax),%eax
 804823f:	0f b7 c0             	movzwl %ax,%eax
 8048242:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048245:	77 04                	ja     804824b <isqrt+0x3f>
 8048247:	83 45 fc 40          	addl   $0x40,-0x4(%ebp)
    if (p[ 16] <= x) p +=  16;
 804824b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804824e:	83 c0 20             	add    $0x20,%eax
 8048251:	0f b7 00             	movzwl (%eax),%eax
 8048254:	0f b7 c0             	movzwl %ax,%eax
 8048257:	3b 45 08             	cmp    0x8(%ebp),%eax
 804825a:	77 04                	ja     8048260 <isqrt+0x54>
 804825c:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
    if (p[  8] <= x) p +=   8;
 8048260:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048263:	83 c0 10             	add    $0x10,%eax
 8048266:	0f b7 00             	movzwl (%eax),%eax
 8048269:	0f b7 c0             	movzwl %ax,%eax
 804826c:	3b 45 08             	cmp    0x8(%ebp),%eax
 804826f:	77 04                	ja     8048275 <isqrt+0x69>
 8048271:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    if (p[  4] <= x) p +=   4;
 8048275:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048278:	83 c0 08             	add    $0x8,%eax
 804827b:	0f b7 00             	movzwl (%eax),%eax
 804827e:	0f b7 c0             	movzwl %ax,%eax
 8048281:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048284:	77 04                	ja     804828a <isqrt+0x7e>
 8048286:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
    if (p[  2] <= x) p +=   2;
 804828a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804828d:	83 c0 04             	add    $0x4,%eax
 8048290:	0f b7 00             	movzwl (%eax),%eax
 8048293:	0f b7 c0             	movzwl %ax,%eax
 8048296:	3b 45 08             	cmp    0x8(%ebp),%eax
 8048299:	77 04                	ja     804829f <isqrt+0x93>
 804829b:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
    if (p[  1] <= x) p +=   1;
 804829f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482a2:	83 c0 02             	add    $0x2,%eax
 80482a5:	0f b7 00             	movzwl (%eax),%eax
 80482a8:	0f b7 c0             	movzwl %ax,%eax
 80482ab:	3b 45 08             	cmp    0x8(%ebp),%eax
 80482ae:	77 04                	ja     80482b4 <isqrt+0xa8>
 80482b0:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    memoriza[x] = p - squares;
 80482b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482b7:	ba 00 98 04 08       	mov    $0x8049800,%edx
 80482bc:	29 d0                	sub    %edx,%eax
 80482be:	d1 f8                	sar    %eax
 80482c0:	89 c2                	mov    %eax,%edx
 80482c2:	8b 45 08             	mov    0x8(%ebp),%eax
 80482c5:	89 14 85 c0 b0 04 08 	mov    %edx,0x804b0c0(,%eax,4)
    return p - squares;
 80482cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80482cf:	ba 00 98 04 08       	mov    $0x8049800,%edx
 80482d4:	29 d0                	sub    %edx,%eax
 80482d6:	d1 f8                	sar    %eax
}
 80482d8:	c9                   	leave  
 80482d9:	c3                   	ret    

080482da <clearStage>:


static inline void clearStage(){
 80482da:	55                   	push   %ebp
 80482db:	89 e5                	mov    %esp,%ebp
	hash = 0;
 80482dd:	c7 05 80 b0 04 08 00 	movl   $0x0,0x804b080
 80482e4:	00 00 00 
	sys_init_vcache();
 80482e7:	e8 aa fe ff ff       	call   8048196 <sys_init_vcache>
}
 80482ec:	5d                   	pop    %ebp
 80482ed:	c3                   	ret    

080482ee <drawPoint>:
static inline void drawPoint(int x, int y, uint8_t color){
 80482ee:	55                   	push   %ebp
 80482ef:	89 e5                	mov    %esp,%ebp
 80482f1:	83 ec 04             	sub    $0x4,%esp
 80482f4:	8b 45 10             	mov    0x10(%ebp),%eax
 80482f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	sys_set_pixel(y, x, color);
 80482fa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
 80482fe:	50                   	push   %eax
 80482ff:	ff 75 08             	pushl  0x8(%ebp)
 8048302:	ff 75 0c             	pushl  0xc(%ebp)
 8048305:	e8 a4 fe ff ff       	call   80481ae <sys_set_pixel>
 804830a:	83 c4 0c             	add    $0xc,%esp
}
 804830d:	c9                   	leave  
 804830e:	c3                   	ret    

0804830f <drawRect>:
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
 804830f:	55                   	push   %ebp
 8048310:	89 e5                	mov    %esp,%ebp
 8048312:	53                   	push   %ebx
 8048313:	83 ec 14             	sub    $0x14,%esp
 8048316:	8b 45 18             	mov    0x18(%ebp),%eax
 8048319:	88 45 e8             	mov    %al,-0x18(%ebp)
	hash += 29*x+57*y+13*color;
 804831c:	8b 45 08             	mov    0x8(%ebp),%eax
 804831f:	6b d0 1d             	imul   $0x1d,%eax,%edx
 8048322:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048325:	6b c0 39             	imul   $0x39,%eax,%eax
 8048328:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804832b:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
 804832f:	89 d0                	mov    %edx,%eax
 8048331:	01 c0                	add    %eax,%eax
 8048333:	01 d0                	add    %edx,%eax
 8048335:	c1 e0 02             	shl    $0x2,%eax
 8048338:	01 d0                	add    %edx,%eax
 804833a:	01 c8                	add    %ecx,%eax
 804833c:	89 c2                	mov    %eax,%edx
 804833e:	a1 80 b0 04 08       	mov    0x804b080,%eax
 8048343:	01 d0                	add    %edx,%eax
 8048345:	a3 80 b0 04 08       	mov    %eax,0x804b080
	int i=0, j=0;
 804834a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 8048351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<w;i++){
 8048358:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804835f:	eb 38                	jmp    8048399 <drawRect+0x8a>
		for(j=0;j<h;j++){
 8048361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048368:	eb 23                	jmp    804838d <drawRect+0x7e>
			drawPoint(x+i, y+j, color);
 804836a:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 804836e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 8048371:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048374:	01 d1                	add    %edx,%ecx
 8048376:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048379:	8b 55 f8             	mov    -0x8(%ebp),%edx
 804837c:	01 da                	add    %ebx,%edx
 804837e:	50                   	push   %eax
 804837f:	51                   	push   %ecx
 8048380:	52                   	push   %edx
 8048381:	e8 68 ff ff ff       	call   80482ee <drawPoint>
 8048386:	83 c4 0c             	add    $0xc,%esp
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
 8048389:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804838d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048390:	3b 45 14             	cmp    0x14(%ebp),%eax
 8048393:	7c d5                	jl     804836a <drawRect+0x5b>
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
 8048395:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 8048399:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804839c:	3b 45 10             	cmp    0x10(%ebp),%eax
 804839f:	7c c0                	jl     8048361 <drawRect+0x52>
		for(j=0;j<h;j++){
			drawPoint(x+i, y+j, color);
		}
	}
}
 80483a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 80483a4:	c9                   	leave  
 80483a5:	c3                   	ret    

080483a6 <drawCirc>:


static inline void drawCirc(int x, int y, int r, uint8_t color){
 80483a6:	55                   	push   %ebp
 80483a7:	89 e5                	mov    %esp,%ebp
 80483a9:	53                   	push   %ebx
 80483aa:	83 ec 14             	sub    $0x14,%esp
 80483ad:	8b 45 14             	mov    0x14(%ebp),%eax
 80483b0:	88 45 e8             	mov    %al,-0x18(%ebp)
	int i, j;
	hash += 329*x+157*y+713*r;
 80483b3:	8b 45 08             	mov    0x8(%ebp),%eax
 80483b6:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
 80483bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 80483bf:	69 c0 9d 00 00 00    	imul   $0x9d,%eax,%eax
 80483c5:	01 c2                	add    %eax,%edx
 80483c7:	8b 45 10             	mov    0x10(%ebp),%eax
 80483ca:	69 c0 c9 02 00 00    	imul   $0x2c9,%eax,%eax
 80483d0:	01 d0                	add    %edx,%eax
 80483d2:	89 c2                	mov    %eax,%edx
 80483d4:	a1 80 b0 04 08       	mov    0x804b080,%eax
 80483d9:	01 d0                	add    %edx,%eax
 80483db:	a3 80 b0 04 08       	mov    %eax,0x804b080
	for(i=-r; i<=r; i++){
 80483e0:	8b 45 10             	mov    0x10(%ebp),%eax
 80483e3:	f7 d8                	neg    %eax
 80483e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 80483e8:	eb 5c                	jmp    8048446 <drawCirc+0xa0>
		int delta = isqrt(r*r-i*i)+1;
 80483ea:	8b 45 10             	mov    0x10(%ebp),%eax
 80483ed:	0f af 45 10          	imul   0x10(%ebp),%eax
 80483f1:	89 c2                	mov    %eax,%edx
 80483f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80483f6:	0f af 45 f8          	imul   -0x8(%ebp),%eax
 80483fa:	29 c2                	sub    %eax,%edx
 80483fc:	89 d0                	mov    %edx,%eax
 80483fe:	50                   	push   %eax
 80483ff:	e8 08 fe ff ff       	call   804820c <isqrt>
 8048404:	83 c4 04             	add    $0x4,%esp
 8048407:	83 c0 01             	add    $0x1,%eax
 804840a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 804840d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048410:	f7 d8                	neg    %eax
 8048412:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048415:	eb 23                	jmp    804843a <drawCirc+0x94>
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
 8048417:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
 804841b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 804841e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048421:	01 d1                	add    %edx,%ecx
 8048423:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8048426:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8048429:	01 da                	add    %ebx,%edx
 804842b:	50                   	push   %eax
 804842c:	51                   	push   %ecx
 804842d:	52                   	push   %edx
 804842e:	e8 bb fe ff ff       	call   80482ee <drawPoint>
 8048433:	83 c4 0c             	add    $0xc,%esp
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
 8048436:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804843a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804843d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 8048440:	7e d5                	jle    8048417 <drawCirc+0x71>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
 8048442:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 8048446:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048449:	3b 45 10             	cmp    0x10(%ebp),%eax
 804844c:	7e 9c                	jle    80483ea <drawCirc+0x44>
		for(j=-delta; j<=delta; j++){
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
		}
	}
}
 804844e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048451:	c9                   	leave  
 8048452:	c3                   	ret    

08048453 <drawText1>:

static inline void drawText1(){
 8048453:	55                   	push   %ebp
 8048454:	89 e5                	mov    %esp,%ebp
 8048456:	83 ec 10             	sub    $0x10,%esp
    int i=0, j=0;
 8048459:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048460:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(j=0;j<20;j++){
 8048467:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 804846e:	eb 53                	jmp    80484c3 <drawText1+0x70>
        for(i=0;i<52;i++){
 8048470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 8048477:	eb 40                	jmp    80484b9 <drawText1+0x66>
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
 8048479:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804847c:	6b d0 34             	imul   $0x34,%eax,%edx
 804847f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048482:	01 d0                	add    %edx,%eax
 8048484:	0f b6 80 00 9a 04 08 	movzbl 0x8049a00(%eax),%eax
 804848b:	84 c0                	test   %al,%al
 804848d:	74 26                	je     80484b5 <drawText1+0x62>
 804848f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8048492:	89 d0                	mov    %edx,%eax
 8048494:	c1 e0 02             	shl    $0x2,%eax
 8048497:	01 d0                	add    %edx,%eax
 8048499:	8d 50 14             	lea    0x14(%eax),%edx
 804849c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804849f:	c1 e0 02             	shl    $0x2,%eax
 80484a2:	83 c0 32             	add    $0x32,%eax
 80484a5:	6a 0e                	push   $0xe
 80484a7:	6a 05                	push   $0x5
 80484a9:	6a 04                	push   $0x4
 80484ab:	52                   	push   %edx
 80484ac:	50                   	push   %eax
 80484ad:	e8 5d fe ff ff       	call   804830f <drawRect>
 80484b2:	83 c4 14             	add    $0x14,%esp
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
 80484b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 80484b9:	83 7d fc 33          	cmpl   $0x33,-0x4(%ebp)
 80484bd:	7e ba                	jle    8048479 <drawText1+0x26>
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
 80484bf:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 80484c3:	83 7d f8 13          	cmpl   $0x13,-0x8(%ebp)
 80484c7:	7e a7                	jle    8048470 <drawText1+0x1d>
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
        }
    }
}
 80484c9:	c9                   	leave  
 80484ca:	c3                   	ret    

080484cb <drawNumber>:

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
 80484cb:	55                   	push   %ebp
 80484cc:	89 e5                	mov    %esp,%ebp
 80484ce:	53                   	push   %ebx
 80484cf:	83 ec 24             	sub    $0x24,%esp
 80484d2:	8b 45 18             	mov    0x18(%ebp),%eax
 80484d5:	88 45 d8             	mov    %al,-0x28(%ebp)
    char temp[11];
    int di=0;
 80484d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(num == 0){
 80484df:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 80484e3:	75 0d                	jne    80484f2 <drawNumber+0x27>
        temp[0] = '0';
 80484e5:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
        di = 0;
 80484e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 80484f0:	eb 5f                	jmp    8048551 <drawNumber+0x86>

    }else{    
        while(num>=1){
 80484f2:	eb 53                	jmp    8048547 <drawNumber+0x7c>
            temp[di] = '0'+(num%10);
 80484f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
 80484f7:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80484fc:	89 c8                	mov    %ecx,%eax
 80484fe:	f7 ea                	imul   %edx
 8048500:	c1 fa 02             	sar    $0x2,%edx
 8048503:	89 c8                	mov    %ecx,%eax
 8048505:	c1 f8 1f             	sar    $0x1f,%eax
 8048508:	29 c2                	sub    %eax,%edx
 804850a:	89 d0                	mov    %edx,%eax
 804850c:	c1 e0 02             	shl    $0x2,%eax
 804850f:	01 d0                	add    %edx,%eax
 8048511:	01 c0                	add    %eax,%eax
 8048513:	29 c1                	sub    %eax,%ecx
 8048515:	89 ca                	mov    %ecx,%edx
 8048517:	89 d0                	mov    %edx,%eax
 8048519:	83 c0 30             	add    $0x30,%eax
 804851c:	89 c1                	mov    %eax,%ecx
 804851e:	8d 55 dd             	lea    -0x23(%ebp),%edx
 8048521:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048524:	01 d0                	add    %edx,%eax
 8048526:	88 08                	mov    %cl,(%eax)
            num/=10;
 8048528:	8b 4d 08             	mov    0x8(%ebp),%ecx
 804852b:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8048530:	89 c8                	mov    %ecx,%eax
 8048532:	f7 ea                	imul   %edx
 8048534:	c1 fa 02             	sar    $0x2,%edx
 8048537:	89 c8                	mov    %ecx,%eax
 8048539:	c1 f8 1f             	sar    $0x1f,%eax
 804853c:	29 c2                	sub    %eax,%edx
 804853e:	89 d0                	mov    %edx,%eax
 8048540:	89 45 08             	mov    %eax,0x8(%ebp)
            di++;
 8048543:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
 8048547:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 804854b:	7f a7                	jg     80484f4 <drawNumber+0x29>
            temp[di] = '0'+(num%10);
            num/=10;
            di++;
        };
        di--;
 804854d:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
    }
    int i=0, xx=0, yy=0;
 8048551:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8048558:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804855f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(;di>=0;di--){
 8048566:	e9 b2 00 00 00       	jmp    804861d <drawNumber+0x152>
        for(yy=0; yy<7; yy++){
 804856b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 8048572:	e9 94 00 00 00       	jmp    804860b <drawNumber+0x140>
            for(xx=0; xx<5; xx++){
 8048577:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 804857e:	eb 7d                	jmp    80485fd <drawNumber+0x132>
                const char* num = nums[temp[di]-'0'];
 8048580:	8d 55 dd             	lea    -0x23(%ebp),%edx
 8048583:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8048586:	01 d0                	add    %edx,%eax
 8048588:	0f b6 00             	movzbl (%eax),%eax
 804858b:	0f be c0             	movsbl %al,%eax
 804858e:	83 e8 30             	sub    $0x30,%eax
 8048591:	8b 04 85 20 b0 04 08 	mov    0x804b020(,%eax,4),%eax
 8048598:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
 804859b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 804859e:	89 d0                	mov    %edx,%eax
 80485a0:	c1 e0 02             	shl    $0x2,%eax
 80485a3:	01 c2                	add    %eax,%edx
 80485a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80485a8:	01 d0                	add    %edx,%eax
 80485aa:	89 c2                	mov    %eax,%edx
 80485ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80485af:	01 d0                	add    %edx,%eax
 80485b1:	0f b6 00             	movzbl (%eax),%eax
 80485b4:	84 c0                	test   %al,%al
 80485b6:	74 41                	je     80485f9 <drawNumber+0x12e>
 80485b8:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
 80485bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80485bf:	89 d1                	mov    %edx,%ecx
 80485c1:	0f af 4d 14          	imul   0x14(%ebp),%ecx
 80485c5:	8b 55 10             	mov    0x10(%ebp),%edx
 80485c8:	01 d1                	add    %edx,%ecx
 80485ca:	8b 55 14             	mov    0x14(%ebp),%edx
 80485cd:	0f af 55 14          	imul   0x14(%ebp),%edx
 80485d1:	83 c2 0a             	add    $0xa,%edx
 80485d4:	89 d3                	mov    %edx,%ebx
 80485d6:	0f af 5d f4          	imul   -0xc(%ebp),%ebx
 80485da:	8b 55 0c             	mov    0xc(%ebp),%edx
 80485dd:	01 d3                	add    %edx,%ebx
 80485df:	8b 55 f0             	mov    -0x10(%ebp),%edx
 80485e2:	0f af 55 14          	imul   0x14(%ebp),%edx
 80485e6:	01 da                	add    %ebx,%edx
 80485e8:	50                   	push   %eax
 80485e9:	ff 75 14             	pushl  0x14(%ebp)
 80485ec:	ff 75 14             	pushl  0x14(%ebp)
 80485ef:	51                   	push   %ecx
 80485f0:	52                   	push   %edx
 80485f1:	e8 19 fd ff ff       	call   804830f <drawRect>
 80485f6:	83 c4 14             	add    $0x14,%esp
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
 80485f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 80485fd:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
 8048601:	0f 8e 79 ff ff ff    	jle    8048580 <drawNumber+0xb5>
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
 8048607:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 804860b:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
 804860f:	0f 8e 62 ff ff ff    	jle    8048577 <drawNumber+0xac>
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
 8048615:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
 8048619:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
 804861d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 8048621:	0f 89 44 ff ff ff    	jns    804856b <drawNumber+0xa0>
                if(num[yy*5+xx])drawRect(i*(size*size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
    }
}
 8048627:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 804862a:	c9                   	leave  
 804862b:	c3                   	ret    

0804862c <drawStage>:

static inline void drawStage(){
 804862c:	55                   	push   %ebp
 804862d:	89 e5                	mov    %esp,%ebp
	if(lhash == hash)return;
 804862f:	8b 15 84 b0 04 08    	mov    0x804b084,%edx
 8048635:	a1 80 b0 04 08       	mov    0x804b080,%eax
 804863a:	39 c2                	cmp    %eax,%edx
 804863c:	75 02                	jne    8048640 <drawStage+0x14>
 804863e:	eb 0f                	jmp    804864f <drawStage+0x23>
	//clear_vram();
	sys_flush_vcache();
 8048640:	e8 5d fb ff ff       	call   80481a2 <sys_flush_vcache>
	lhash = hash;
 8048645:	a1 80 b0 04 08       	mov    0x804b080,%eax
 804864a:	a3 84 b0 04 08       	mov    %eax,0x804b084
}
 804864f:	5d                   	pop    %ebp
 8048650:	c3                   	ret    

08048651 <key>:
static int timestamp = 1;
static int curtime = 0;
static int score = 0;
void dreamOf100HZ(int);

static inline int8_t key(char s){
 8048651:	55                   	push   %ebp
 8048652:	89 e5                	mov    %esp,%ebp
 8048654:	83 ec 04             	sub    $0x4,%esp
 8048657:	8b 45 08             	mov    0x8(%ebp),%eax
 804865a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return sys_key_down(s);
 804865d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
 8048661:	50                   	push   %eax
 8048662:	e8 5e fb ff ff       	call   80481c5 <sys_key_down>
 8048667:	83 c4 04             	add    $0x4,%esp
}
 804866a:	c9                   	leave  
 804866b:	c3                   	ret    

0804866c <main>:

void game();

int main(){
 804866c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 8048670:	83 e4 f0             	and    $0xfffffff0,%esp
 8048673:	ff 71 fc             	pushl  -0x4(%ecx)
 8048676:	55                   	push   %ebp
 8048677:	89 e5                	mov    %esp,%ebp
 8048679:	51                   	push   %ecx
 804867a:	83 ec 04             	sub    $0x4,%esp
	//initVCache();
	//printk("5\n");
	//clear_key();
	//printk("6\n");
	
	game();
 804867d:	e8 0e 00 00 00       	call   8048690 <game>
	
	return 1;
 8048682:	b8 01 00 00 00       	mov    $0x1,%eax
};
 8048687:	83 c4 04             	add    $0x4,%esp
 804868a:	59                   	pop    %ecx
 804868b:	5d                   	pop    %ebp
 804868c:	8d 61 fc             	lea    -0x4(%ecx),%esp
 804868f:	c3                   	ret    

08048690 <game>:

void game(){
 8048690:	55                   	push   %ebp
 8048691:	89 e5                	mov    %esp,%ebp
 8048693:	83 ec 08             	sub    $0x8,%esp
	printf("Hello this is GAME#%d! WATCH ME!\n", getpid());
 8048696:	e8 cc fa ff ff       	call   8048167 <sys_pid>
 804869b:	83 ec 08             	sub    $0x8,%esp
 804869e:	50                   	push   %eax
 804869f:	68 84 a0 04 08       	push   $0x804a084
 80486a4:	e8 25 11 00 00       	call   80497ce <printf>
 80486a9:	83 c4 10             	add    $0x10,%esp
	while(1){
		timestamp = sys_get_tick();
 80486ac:	e8 3f fb ff ff       	call   80481f0 <sys_get_tick>
 80486b1:	a3 48 b0 04 08       	mov    %eax,0x804b048
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 80486b6:	eb 1e                	jmp    80486d6 <game+0x46>
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
 80486b8:	a1 48 b0 04 08       	mov    0x804b048,%eax
 80486bd:	83 ec 0c             	sub    $0xc,%esp
 80486c0:	50                   	push   %eax
 80486c1:	e8 8c 07 00 00       	call   8048e52 <dreamOf100HZ>
 80486c6:	83 c4 10             	add    $0x10,%esp
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
			curtime+=2;
 80486c9:	a1 20 ba 04 08       	mov    0x804ba20,%eax
 80486ce:	83 c0 02             	add    $0x2,%eax
 80486d1:	a3 20 ba 04 08       	mov    %eax,0x804ba20
	printf("Hello this is GAME#%d! WATCH ME!\n", getpid());
	while(1){
		timestamp = sys_get_tick();
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
 80486d6:	8b 15 20 ba 04 08    	mov    0x804ba20,%edx
 80486dc:	a1 48 b0 04 08       	mov    0x804b048,%eax
 80486e1:	39 c2                	cmp    %eax,%edx
 80486e3:	7c d3                	jl     80486b8 <game+0x28>
		//sys_handout();
		

		//enable_interrupt();
		
	}
 80486e5:	eb c5                	jmp    80486ac <game+0x1c>

080486e7 <hitMonster>:
domain int x, y, size;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
 80486e7:	55                   	push   %ebp
 80486e8:	89 e5                	mov    %esp,%ebp
 80486ea:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 80486ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	REP_MONSTER(){
 80486f4:	e9 9c 01 00 00       	jmp    8048895 <hitMonster+0x1ae>
		int dx = x-mon.x; 
 80486f9:	8b 15 2c ba 04 08    	mov    0x804ba2c,%edx
 80486ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048702:	c1 e0 02             	shl    $0x2,%eax
 8048705:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 804870c:	29 c1                	sub    %eax,%ecx
 804870e:	89 c8                	mov    %ecx,%eax
 8048710:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048715:	8b 40 04             	mov    0x4(%eax),%eax
 8048718:	29 c2                	sub    %eax,%edx
 804871a:	89 d0                	mov    %edx,%eax
 804871c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int dy = y-mon.y;
 804871f:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 8048725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048728:	c1 e0 02             	shl    $0x2,%eax
 804872b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048732:	29 c1                	sub    %eax,%ecx
 8048734:	89 c8                	mov    %ecx,%eax
 8048736:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804873b:	8b 40 08             	mov    0x8(%eax),%eax
 804873e:	29 c2                	sub    %eax,%edx
 8048740:	89 d0                	mov    %edx,%eax
 8048742:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
 8048745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048748:	89 c2                	mov    %eax,%edx
 804874a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048751:	89 c2                	mov    %eax,%edx
 8048753:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804875a:	29 d0                	sub    %edx,%eax
 804875c:	83 c0 10             	add    $0x10,%eax
 804875f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048764:	8b 40 04             	mov    0x4(%eax),%eax
 8048767:	85 c0                	test   %eax,%eax
 8048769:	0f 85 22 01 00 00    	jne    8048891 <hitMonster+0x1aa>
 804876f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048772:	c1 e0 02             	shl    $0x2,%eax
 8048775:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804877c:	29 c2                	sub    %eax,%edx
 804877e:	89 d0                	mov    %edx,%eax
 8048780:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048785:	8b 00                	mov    (%eax),%eax
 8048787:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 804878a:	0f 8c 01 01 00 00    	jl     8048891 <hitMonster+0x1aa>
 8048790:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048793:	c1 e0 02             	shl    $0x2,%eax
 8048796:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804879d:	29 c2                	sub    %eax,%edx
 804879f:	89 d0                	mov    %edx,%eax
 80487a1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487a6:	8b 00                	mov    (%eax),%eax
 80487a8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 80487ab:	0f 8c e0 00 00 00    	jl     8048891 <hitMonster+0x1aa>
 80487b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487b4:	c1 e0 02             	shl    $0x2,%eax
 80487b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80487be:	29 c2                	sub    %eax,%edx
 80487c0:	89 d0                	mov    %edx,%eax
 80487c2:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487c7:	8b 00                	mov    (%eax),%eax
 80487c9:	f7 d8                	neg    %eax
 80487cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80487ce:	0f 8f bd 00 00 00    	jg     8048891 <hitMonster+0x1aa>
 80487d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487d7:	c1 e0 02             	shl    $0x2,%eax
 80487da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80487e1:	29 c2                	sub    %eax,%edx
 80487e3:	89 d0                	mov    %edx,%eax
 80487e5:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80487ea:	8b 00                	mov    (%eax),%eax
 80487ec:	f7 d8                	neg    %eax
 80487ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 80487f1:	0f 8f 9a 00 00 00    	jg     8048891 <hitMonster+0x1aa>
			if(mon.size <= size){
 80487f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80487fa:	c1 e0 02             	shl    $0x2,%eax
 80487fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048804:	29 c2                	sub    %eax,%edx
 8048806:	89 d0                	mov    %edx,%eax
 8048808:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804880d:	8b 10                	mov    (%eax),%edx
 804880f:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048814:	39 c2                	cmp    %eax,%edx
 8048816:	7f 68                	jg     8048880 <hitMonster+0x199>
				mon.status = MONSTER_DEAD;
 8048818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804881b:	89 c2                	mov    %eax,%edx
 804881d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048824:	89 c2                	mov    %eax,%edx
 8048826:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804882d:	29 d0                	sub    %edx,%eax
 804882f:	83 c0 10             	add    $0x10,%eax
 8048832:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048837:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
				if(size<13)size++;
 804883e:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048843:	83 f8 0c             	cmp    $0xc,%eax
 8048846:	7f 0d                	jg     8048855 <hitMonster+0x16e>
 8048848:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 804884d:	83 c0 01             	add    $0x1,%eax
 8048850:	a3 34 ba 04 08       	mov    %eax,0x804ba34
				score += mon.size;
 8048855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8048858:	c1 e0 02             	shl    $0x2,%eax
 804885b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048862:	29 c2                	sub    %eax,%edx
 8048864:	89 d0                	mov    %edx,%eax
 8048866:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804886b:	8b 10                	mov    (%eax),%edx
 804886d:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 8048872:	01 d0                	add    %edx,%eax
 8048874:	a3 24 ba 04 08       	mov    %eax,0x804ba24
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
 8048879:	b8 01 00 00 00       	mov    $0x1,%eax
 804887e:	eb 24                	jmp    80488a4 <hitMonster+0x1bd>
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
 8048880:	c7 05 28 ba 04 08 03 	movl   $0x3,0x804ba28
 8048887:	00 00 00 
				return 0;
 804888a:	b8 00 00 00 00       	mov    $0x0,%eax
 804888f:	eb 13                	jmp    80488a4 <hitMonster+0x1bd>
domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
 8048891:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 8048895:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
 8048899:	0f 8e 5a fe ff ff    	jle    80486f9 <hitMonster+0x12>
				return 0;
			}
			return 1;
		}
	}
	return 0;
 804889f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 80488a4:	c9                   	leave  
 80488a5:	c3                   	ret    

080488a6 <drawMonster>:

void drawMonster(){
 80488a6:	55                   	push   %ebp
 80488a7:	89 e5                	mov    %esp,%ebp
 80488a9:	56                   	push   %esi
 80488aa:	53                   	push   %ebx
 80488ab:	83 ec 10             	sub    $0x10,%esp
	int i=0;
 80488ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 80488b5:	e9 89 03 00 00       	jmp    8048c43 <drawMonster+0x39d>
		if(mon.status == MONSTER_ALIVE){
 80488ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488bd:	89 c2                	mov    %eax,%edx
 80488bf:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80488c6:	89 c2                	mov    %eax,%edx
 80488c8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80488cf:	29 d0                	sub    %edx,%eax
 80488d1:	83 c0 10             	add    $0x10,%eax
 80488d4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488d9:	8b 40 04             	mov    0x4(%eax),%eax
 80488dc:	85 c0                	test   %eax,%eax
 80488de:	0f 85 5b 03 00 00    	jne    8048c3f <drawMonster+0x399>
			mon.x += mon.sx;
 80488e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80488e7:	c1 e0 02             	shl    $0x2,%eax
 80488ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80488f1:	29 c2                	sub    %eax,%edx
 80488f3:	89 d0                	mov    %edx,%eax
 80488f5:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80488fa:	8b 50 04             	mov    0x4(%eax),%edx
 80488fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048900:	c1 e0 02             	shl    $0x2,%eax
 8048903:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 804890a:	29 c1                	sub    %eax,%ecx
 804890c:	89 c8                	mov    %ecx,%eax
 804890e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048913:	8b 40 0c             	mov    0xc(%eax),%eax
 8048916:	01 c2                	add    %eax,%edx
 8048918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804891b:	c1 e0 02             	shl    $0x2,%eax
 804891e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048925:	29 c1                	sub    %eax,%ecx
 8048927:	89 c8                	mov    %ecx,%eax
 8048929:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804892e:	89 50 04             	mov    %edx,0x4(%eax)
			mon.y += mon.sy;
 8048931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048934:	c1 e0 02             	shl    $0x2,%eax
 8048937:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804893e:	29 c2                	sub    %eax,%edx
 8048940:	89 d0                	mov    %edx,%eax
 8048942:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048947:	8b 48 08             	mov    0x8(%eax),%ecx
 804894a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804894d:	89 c2                	mov    %eax,%edx
 804894f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048956:	89 c2                	mov    %eax,%edx
 8048958:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804895f:	29 d0                	sub    %edx,%eax
 8048961:	83 c0 10             	add    $0x10,%eax
 8048964:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048969:	8b 00                	mov    (%eax),%eax
 804896b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
 804896e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048971:	c1 e0 02             	shl    $0x2,%eax
 8048974:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 804897b:	29 c1                	sub    %eax,%ecx
 804897d:	89 c8                	mov    %ecx,%eax
 804897f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048984:	89 50 08             	mov    %edx,0x8(%eax)

			if(mon.x < 10) mon.x++;
 8048987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804898a:	c1 e0 02             	shl    $0x2,%eax
 804898d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048994:	29 c2                	sub    %eax,%edx
 8048996:	89 d0                	mov    %edx,%eax
 8048998:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804899d:	8b 40 04             	mov    0x4(%eax),%eax
 80489a0:	83 f8 09             	cmp    $0x9,%eax
 80489a3:	7f 35                	jg     80489da <drawMonster+0x134>
 80489a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489a8:	c1 e0 02             	shl    $0x2,%eax
 80489ab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489b2:	29 c2                	sub    %eax,%edx
 80489b4:	89 d0                	mov    %edx,%eax
 80489b6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489bb:	8b 40 04             	mov    0x4(%eax),%eax
 80489be:	8d 50 01             	lea    0x1(%eax),%edx
 80489c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489c4:	c1 e0 02             	shl    $0x2,%eax
 80489c7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 80489ce:	29 c1                	sub    %eax,%ecx
 80489d0:	89 c8                	mov    %ecx,%eax
 80489d2:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489d7:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.x > VWIDTH-10) mon.x--;
 80489da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489dd:	c1 e0 02             	shl    $0x2,%eax
 80489e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80489e7:	29 c2                	sub    %eax,%edx
 80489e9:	89 d0                	mov    %edx,%eax
 80489eb:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80489f0:	8b 40 04             	mov    0x4(%eax),%eax
 80489f3:	3d 36 01 00 00       	cmp    $0x136,%eax
 80489f8:	7e 35                	jle    8048a2f <drawMonster+0x189>
 80489fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80489fd:	c1 e0 02             	shl    $0x2,%eax
 8048a00:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a07:	29 c2                	sub    %eax,%edx
 8048a09:	89 d0                	mov    %edx,%eax
 8048a0b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a10:	8b 40 04             	mov    0x4(%eax),%eax
 8048a13:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a19:	c1 e0 02             	shl    $0x2,%eax
 8048a1c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a23:	29 c1                	sub    %eax,%ecx
 8048a25:	89 c8                	mov    %ecx,%eax
 8048a27:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a2c:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.y < 10) mon.y++;
 8048a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a32:	c1 e0 02             	shl    $0x2,%eax
 8048a35:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a3c:	29 c2                	sub    %eax,%edx
 8048a3e:	89 d0                	mov    %edx,%eax
 8048a40:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a45:	8b 40 08             	mov    0x8(%eax),%eax
 8048a48:	83 f8 09             	cmp    $0x9,%eax
 8048a4b:	7f 35                	jg     8048a82 <drawMonster+0x1dc>
 8048a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a50:	c1 e0 02             	shl    $0x2,%eax
 8048a53:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a5a:	29 c2                	sub    %eax,%edx
 8048a5c:	89 d0                	mov    %edx,%eax
 8048a5e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a63:	8b 40 08             	mov    0x8(%eax),%eax
 8048a66:	8d 50 01             	lea    0x1(%eax),%edx
 8048a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a6c:	c1 e0 02             	shl    $0x2,%eax
 8048a6f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048a76:	29 c1                	sub    %eax,%ecx
 8048a78:	89 c8                	mov    %ecx,%eax
 8048a7a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a7f:	89 50 08             	mov    %edx,0x8(%eax)
			if(mon.y > VHEIGHT-10) mon.y--;
 8048a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048a85:	c1 e0 02             	shl    $0x2,%eax
 8048a88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048a8f:	29 c2                	sub    %eax,%edx
 8048a91:	89 d0                	mov    %edx,%eax
 8048a93:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048a98:	8b 40 08             	mov    0x8(%eax),%eax
 8048a9b:	3d be 00 00 00       	cmp    $0xbe,%eax
 8048aa0:	7e 35                	jle    8048ad7 <drawMonster+0x231>
 8048aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048aa5:	c1 e0 02             	shl    $0x2,%eax
 8048aa8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048aaf:	29 c2                	sub    %eax,%edx
 8048ab1:	89 d0                	mov    %edx,%eax
 8048ab3:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ab8:	8b 40 08             	mov    0x8(%eax),%eax
 8048abb:	8d 50 ff             	lea    -0x1(%eax),%edx
 8048abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ac1:	c1 e0 02             	shl    $0x2,%eax
 8048ac4:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048acb:	29 c1                	sub    %eax,%ecx
 8048acd:	89 c8                	mov    %ecx,%eax
 8048acf:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ad4:	89 50 08             	mov    %edx,0x8(%eax)
			int color = size>=mon.size?15:5;
 8048ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ada:	c1 e0 02             	shl    $0x2,%eax
 8048add:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048ae4:	29 c2                	sub    %eax,%edx
 8048ae6:	89 d0                	mov    %edx,%eax
 8048ae8:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048aed:	8b 10                	mov    (%eax),%edx
 8048aef:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 8048af4:	39 c2                	cmp    %eax,%edx
 8048af6:	7f 07                	jg     8048aff <drawMonster+0x259>
 8048af8:	b8 0f 00 00 00       	mov    $0xf,%eax
 8048afd:	eb 05                	jmp    8048b04 <drawMonster+0x25e>
 8048aff:	b8 05 00 00 00       	mov    $0x5,%eax
 8048b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
			drawCirc(mon.x, mon.y, mon.size, color);
 8048b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8048b0a:	0f b6 d8             	movzbl %al,%ebx
 8048b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b10:	c1 e0 02             	shl    $0x2,%eax
 8048b13:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b1a:	29 c2                	sub    %eax,%edx
 8048b1c:	89 d0                	mov    %edx,%eax
 8048b1e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b23:	8b 08                	mov    (%eax),%ecx
 8048b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b28:	c1 e0 02             	shl    $0x2,%eax
 8048b2b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048b32:	29 c2                	sub    %eax,%edx
 8048b34:	89 d0                	mov    %edx,%eax
 8048b36:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b3b:	8b 50 08             	mov    0x8(%eax),%edx
 8048b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048b41:	c1 e0 02             	shl    $0x2,%eax
 8048b44:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
 8048b4b:	29 c6                	sub    %eax,%esi
 8048b4d:	89 f0                	mov    %esi,%eax
 8048b4f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048b54:	8b 40 04             	mov    0x4(%eax),%eax
 8048b57:	53                   	push   %ebx
 8048b58:	51                   	push   %ecx
 8048b59:	52                   	push   %edx
 8048b5a:	50                   	push   %eax
 8048b5b:	e8 46 f8 ff ff       	call   80483a6 <drawCirc>
 8048b60:	83 c4 10             	add    $0x10,%esp
			if(KISS()%60==0){
 8048b63:	e8 2c f5 ff ff       	call   8048094 <UKISS>
 8048b68:	89 c2                	mov    %eax,%edx
 8048b6a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048b6f:	01 c2                	add    %eax,%edx
 8048b71:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048b76:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048b79:	ba 89 88 88 88       	mov    $0x88888889,%edx
 8048b7e:	89 c8                	mov    %ecx,%eax
 8048b80:	f7 e2                	mul    %edx
 8048b82:	89 d0                	mov    %edx,%eax
 8048b84:	c1 e8 05             	shr    $0x5,%eax
 8048b87:	89 c2                	mov    %eax,%edx
 8048b89:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048b90:	89 c2                	mov    %eax,%edx
 8048b92:	89 d0                	mov    %edx,%eax
 8048b94:	c1 e0 04             	shl    $0x4,%eax
 8048b97:	29 d0                	sub    %edx,%eax
 8048b99:	29 c1                	sub    %eax,%ecx
 8048b9b:	89 c8                	mov    %ecx,%eax
 8048b9d:	85 c0                	test   %eax,%eax
 8048b9f:	0f 85 9a 00 00 00    	jne    8048c3f <drawMonster+0x399>
				mon.sx = -1 + KISS()%3;
 8048ba5:	e8 ea f4 ff ff       	call   8048094 <UKISS>
 8048baa:	89 c2                	mov    %eax,%edx
 8048bac:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048bb1:	01 c2                	add    %eax,%edx
 8048bb3:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048bb8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048bbb:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048bc0:	89 c8                	mov    %ecx,%eax
 8048bc2:	f7 e2                	mul    %edx
 8048bc4:	d1 ea                	shr    %edx
 8048bc6:	89 d0                	mov    %edx,%eax
 8048bc8:	01 c0                	add    %eax,%eax
 8048bca:	01 d0                	add    %edx,%eax
 8048bcc:	29 c1                	sub    %eax,%ecx
 8048bce:	89 ca                	mov    %ecx,%edx
 8048bd0:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048bd3:	89 c1                	mov    %eax,%ecx
 8048bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048bd8:	c1 e0 02             	shl    $0x2,%eax
 8048bdb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048be2:	29 c2                	sub    %eax,%edx
 8048be4:	89 d0                	mov    %edx,%eax
 8048be6:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048beb:	89 48 0c             	mov    %ecx,0xc(%eax)
				mon.sy = -1 + KISS()%3;
 8048bee:	e8 a1 f4 ff ff       	call   8048094 <UKISS>
 8048bf3:	89 c2                	mov    %eax,%edx
 8048bf5:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048bfa:	01 c2                	add    %eax,%edx
 8048bfc:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048c01:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048c04:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048c09:	89 c8                	mov    %ecx,%eax
 8048c0b:	f7 e2                	mul    %edx
 8048c0d:	d1 ea                	shr    %edx
 8048c0f:	89 d0                	mov    %edx,%eax
 8048c11:	01 c0                	add    %eax,%eax
 8048c13:	01 d0                	add    %edx,%eax
 8048c15:	29 c1                	sub    %eax,%ecx
 8048c17:	89 ca                	mov    %ecx,%edx
 8048c19:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048c1c:	89 c1                	mov    %eax,%ecx
 8048c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c21:	89 c2                	mov    %eax,%edx
 8048c23:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c2a:	89 c2                	mov    %eax,%edx
 8048c2c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048c33:	29 d0                	sub    %edx,%eax
 8048c35:	83 c0 10             	add    $0x10,%eax
 8048c38:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c3d:	89 08                	mov    %ecx,(%eax)
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
 8048c3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048c43:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048c47:	0f 8e 6d fc ff ff    	jle    80488ba <drawMonster+0x14>
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
 8048c4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8048c50:	5b                   	pop    %ebx
 8048c51:	5e                   	pop    %esi
 8048c52:	5d                   	pop    %ebp
 8048c53:	c3                   	ret    

08048c54 <createMonster>:
void createMonster(){
 8048c54:	55                   	push   %ebp
 8048c55:	89 e5                	mov    %esp,%ebp
 8048c57:	83 ec 18             	sub    $0x18,%esp
	int i=0;
 8048c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
 8048c61:	e9 e0 01 00 00       	jmp    8048e46 <createMonster+0x1f2>
		if(mon.status == MONSTER_ALIVE) continue;
 8048c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048c69:	89 c2                	mov    %eax,%edx
 8048c6b:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048c72:	89 c2                	mov    %eax,%edx
 8048c74:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048c7b:	29 d0                	sub    %edx,%eax
 8048c7d:	83 c0 10             	add    $0x10,%eax
 8048c80:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048c85:	8b 40 04             	mov    0x4(%eax),%eax
 8048c88:	85 c0                	test   %eax,%eax
 8048c8a:	75 05                	jne    8048c91 <createMonster+0x3d>
 8048c8c:	e9 b1 01 00 00       	jmp    8048e42 <createMonster+0x1ee>
		if(KISS()%(250*MONSTER_SIZE) == 0){
 8048c91:	e8 fe f3 ff ff       	call   8048094 <UKISS>
 8048c96:	89 c2                	mov    %eax,%edx
 8048c98:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048c9d:	01 c2                	add    %eax,%edx
 8048c9f:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048ca4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048ca7:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
 8048cac:	89 c8                	mov    %ecx,%eax
 8048cae:	f7 e2                	mul    %edx
 8048cb0:	89 d0                	mov    %edx,%eax
 8048cb2:	c1 e8 0c             	shr    $0xc,%eax
 8048cb5:	69 c0 88 13 00 00    	imul   $0x1388,%eax,%eax
 8048cbb:	29 c1                	sub    %eax,%ecx
 8048cbd:	89 c8                	mov    %ecx,%eax
 8048cbf:	85 c0                	test   %eax,%eax
 8048cc1:	0f 85 7b 01 00 00    	jne    8048e42 <createMonster+0x1ee>
			mon.status = MONSTER_ALIVE;
 8048cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048cca:	89 c2                	mov    %eax,%edx
 8048ccc:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048cd3:	89 c2                	mov    %eax,%edx
 8048cd5:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048cdc:	29 d0                	sub    %edx,%eax
 8048cde:	83 c0 10             	add    $0x10,%eax
 8048ce1:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ce6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			mon.size = 2 + 2*(KISS()%size);
 8048ced:	e8 a2 f3 ff ff       	call   8048094 <UKISS>
 8048cf2:	89 c2                	mov    %eax,%edx
 8048cf4:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048cf9:	01 c2                	add    %eax,%edx
 8048cfb:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048d00:	01 d0                	add    %edx,%eax
 8048d02:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048d08:	89 d1                	mov    %edx,%ecx
 8048d0a:	ba 00 00 00 00       	mov    $0x0,%edx
 8048d0f:	f7 f1                	div    %ecx
 8048d11:	89 d0                	mov    %edx,%eax
 8048d13:	83 c0 01             	add    $0x1,%eax
 8048d16:	01 c0                	add    %eax,%eax
 8048d18:	89 c1                	mov    %eax,%ecx
 8048d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d1d:	c1 e0 02             	shl    $0x2,%eax
 8048d20:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d27:	29 c2                	sub    %eax,%edx
 8048d29:	89 d0                	mov    %edx,%eax
 8048d2b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d30:	89 08                	mov    %ecx,(%eax)
			mon.size = mon.size >14?14:mon.size; 
 8048d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d35:	c1 e0 02             	shl    $0x2,%eax
 8048d38:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d3f:	29 c2                	sub    %eax,%edx
 8048d41:	89 d0                	mov    %edx,%eax
 8048d43:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d48:	8b 00                	mov    (%eax),%eax
 8048d4a:	89 c2                	mov    %eax,%edx
 8048d4c:	83 fa 0e             	cmp    $0xe,%edx
 8048d4f:	7e 05                	jle    8048d56 <createMonster+0x102>
 8048d51:	ba 0e 00 00 00       	mov    $0xe,%edx
 8048d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d59:	c1 e0 02             	shl    $0x2,%eax
 8048d5c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 8048d63:	29 c1                	sub    %eax,%ecx
 8048d65:	89 c8                	mov    %ecx,%eax
 8048d67:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d6c:	89 10                	mov    %edx,(%eax)
			mon.x = VWIDTH/2;
 8048d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d71:	c1 e0 02             	shl    $0x2,%eax
 8048d74:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d7b:	29 c2                	sub    %eax,%edx
 8048d7d:	89 d0                	mov    %edx,%eax
 8048d7f:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048d84:	c7 40 04 a0 00 00 00 	movl   $0xa0,0x4(%eax)
			mon.y = VHEIGHT/2;
 8048d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048d8e:	c1 e0 02             	shl    $0x2,%eax
 8048d91:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048d98:	29 c2                	sub    %eax,%edx
 8048d9a:	89 d0                	mov    %edx,%eax
 8048d9c:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048da1:	c7 40 08 64 00 00 00 	movl   $0x64,0x8(%eax)
			mon.sx = -1 + KISS()%3;
 8048da8:	e8 e7 f2 ff ff       	call   8048094 <UKISS>
 8048dad:	89 c2                	mov    %eax,%edx
 8048daf:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048db4:	01 c2                	add    %eax,%edx
 8048db6:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048dbb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048dbe:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048dc3:	89 c8                	mov    %ecx,%eax
 8048dc5:	f7 e2                	mul    %edx
 8048dc7:	d1 ea                	shr    %edx
 8048dc9:	89 d0                	mov    %edx,%eax
 8048dcb:	01 c0                	add    %eax,%eax
 8048dcd:	01 d0                	add    %edx,%eax
 8048dcf:	29 c1                	sub    %eax,%ecx
 8048dd1:	89 ca                	mov    %ecx,%edx
 8048dd3:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048dd6:	89 c1                	mov    %eax,%ecx
 8048dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ddb:	c1 e0 02             	shl    $0x2,%eax
 8048dde:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048de5:	29 c2                	sub    %eax,%edx
 8048de7:	89 d0                	mov    %edx,%eax
 8048de9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048dee:	89 48 0c             	mov    %ecx,0xc(%eax)
			mon.sy = -1 + KISS()%3;
 8048df1:	e8 9e f2 ff ff       	call   8048094 <UKISS>
 8048df6:	89 c2                	mov    %eax,%edx
 8048df8:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048dfd:	01 c2                	add    %eax,%edx
 8048dff:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048e04:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048e07:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048e0c:	89 c8                	mov    %ecx,%eax
 8048e0e:	f7 e2                	mul    %edx
 8048e10:	d1 ea                	shr    %edx
 8048e12:	89 d0                	mov    %edx,%eax
 8048e14:	01 c0                	add    %eax,%eax
 8048e16:	01 d0                	add    %edx,%eax
 8048e18:	29 c1                	sub    %eax,%ecx
 8048e1a:	89 ca                	mov    %ecx,%edx
 8048e1c:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048e1f:	89 c1                	mov    %eax,%ecx
 8048e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048e24:	89 c2                	mov    %eax,%edx
 8048e26:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048e2d:	89 c2                	mov    %eax,%edx
 8048e2f:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048e36:	29 d0                	sub    %edx,%eax
 8048e38:	83 c0 10             	add    $0x10,%eax
 8048e3b:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048e40:	89 08                	mov    %ecx,(%eax)
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
 8048e42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8048e46:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 8048e4a:	0f 8e 16 fe ff ff    	jle    8048c66 <createMonster+0x12>
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
 8048e50:	c9                   	leave  
 8048e51:	c3                   	ret    

08048e52 <dreamOf100HZ>:

void dreamOf100HZ(int timestamp){
 8048e52:	55                   	push   %ebp
 8048e53:	89 e5                	mov    %esp,%ebp
 8048e55:	83 ec 18             	sub    $0x18,%esp
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(key('l')){
 8048e58:	6a 6c                	push   $0x6c
 8048e5a:	e8 f2 f7 ff ff       	call   8048651 <key>
 8048e5f:	83 c4 04             	add    $0x4,%esp
 8048e62:	84 c0                	test   %al,%al
 8048e64:	74 23                	je     8048e89 <dreamOf100HZ+0x37>
		printf("GAME#%d: Sleep 5s!\n", getpid());
 8048e66:	e8 fc f2 ff ff       	call   8048167 <sys_pid>
 8048e6b:	83 ec 08             	sub    $0x8,%esp
 8048e6e:	50                   	push   %eax
 8048e6f:	68 a6 a0 04 08       	push   $0x804a0a6
 8048e74:	e8 55 09 00 00       	call   80497ce <printf>
 8048e79:	83 c4 10             	add    $0x10,%esp
		sleep(5);
 8048e7c:	83 ec 0c             	sub    $0xc,%esp
 8048e7f:	6a 05                	push   $0x5
 8048e81:	e8 fd f2 ff ff       	call   8048183 <sys_sleep>
 8048e86:	83 c4 10             	add    $0x10,%esp
		clearStage();
		drawStage();
		printf("GAME#%d: Ready to exit! Bye!\n", getpid());
		exit();
	}*/
	if(gameStatus == GAME_START){
 8048e89:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8048e8e:	85 c0                	test   %eax,%eax
 8048e90:	0f 85 2b 04 00 00    	jne    80492c1 <dreamOf100HZ+0x46f>
		//printf("%x\n", st);
		//printf("Score: %d\n", curtime);
		clearStage();
 8048e96:	e8 3f f4 ff ff       	call   80482da <clearStage>
		drawText1();
 8048e9b:	e8 b3 f5 ff ff       	call   8048453 <drawText1>
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();
 8048ea0:	e8 87 f7 ff ff       	call   804862c <drawStage>

		int i=0;
 8048ea5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		x = 30;
 8048eac:	c7 05 2c ba 04 08 1e 	movl   $0x1e,0x804ba2c
 8048eb3:	00 00 00 
		y = 30;
 8048eb6:	c7 05 30 ba 04 08 1e 	movl   $0x1e,0x804ba30
 8048ebd:	00 00 00 
		size = 4;
 8048ec0:	c7 05 34 ba 04 08 04 	movl   $0x4,0x804ba34
 8048ec7:	00 00 00 
		score = 0;
 8048eca:	c7 05 24 ba 04 08 00 	movl   $0x0,0x804ba24
 8048ed1:	00 00 00 
		monsters[i].status = MONSTER_ALIVE;
 8048ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048ed7:	89 c2                	mov    %eax,%edx
 8048ed9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8048ee0:	89 c2                	mov    %eax,%edx
 8048ee2:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8048ee9:	29 d0                	sub    %edx,%eax
 8048eeb:	83 c0 10             	add    $0x10,%eax
 8048eee:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048ef3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		monsters[i].size = 1 + (KISS()%size);
 8048efa:	e8 95 f1 ff ff       	call   8048094 <UKISS>
 8048eff:	89 c2                	mov    %eax,%edx
 8048f01:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f06:	01 c2                	add    %eax,%edx
 8048f08:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f0d:	01 d0                	add    %edx,%eax
 8048f0f:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8048f15:	89 d1                	mov    %edx,%ecx
 8048f17:	ba 00 00 00 00       	mov    $0x0,%edx
 8048f1c:	f7 f1                	div    %ecx
 8048f1e:	89 d0                	mov    %edx,%eax
 8048f20:	83 c0 01             	add    $0x1,%eax
 8048f23:	89 c1                	mov    %eax,%ecx
 8048f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f28:	c1 e0 02             	shl    $0x2,%eax
 8048f2b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f32:	29 c2                	sub    %eax,%edx
 8048f34:	89 d0                	mov    %edx,%eax
 8048f36:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f3b:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
 8048f3d:	e8 52 f1 ff ff       	call   8048094 <UKISS>
 8048f42:	89 c2                	mov    %eax,%edx
 8048f44:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f49:	01 c2                	add    %eax,%edx
 8048f4b:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f50:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f53:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8048f58:	89 c8                	mov    %ecx,%eax
 8048f5a:	f7 e2                	mul    %edx
 8048f5c:	c1 ea 08             	shr    $0x8,%edx
 8048f5f:	89 d0                	mov    %edx,%eax
 8048f61:	c1 e0 02             	shl    $0x2,%eax
 8048f64:	01 d0                	add    %edx,%eax
 8048f66:	c1 e0 06             	shl    $0x6,%eax
 8048f69:	29 c1                	sub    %eax,%ecx
 8048f6b:	89 ca                	mov    %ecx,%edx
 8048f6d:	89 d1                	mov    %edx,%ecx
 8048f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048f72:	c1 e0 02             	shl    $0x2,%eax
 8048f75:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048f7c:	29 c2                	sub    %eax,%edx
 8048f7e:	89 d0                	mov    %edx,%eax
 8048f80:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048f85:	89 48 04             	mov    %ecx,0x4(%eax)
		monsters[i].y = KISS()%VHEIGHT;
 8048f88:	e8 07 f1 ff ff       	call   8048094 <UKISS>
 8048f8d:	89 c2                	mov    %eax,%edx
 8048f8f:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048f94:	01 c2                	add    %eax,%edx
 8048f96:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048f9b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048f9e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 8048fa3:	89 c8                	mov    %ecx,%eax
 8048fa5:	f7 e2                	mul    %edx
 8048fa7:	89 d0                	mov    %edx,%eax
 8048fa9:	c1 e8 06             	shr    $0x6,%eax
 8048fac:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 8048fb2:	29 c1                	sub    %eax,%ecx
 8048fb4:	89 c8                	mov    %ecx,%eax
 8048fb6:	89 c1                	mov    %eax,%ecx
 8048fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8048fbb:	c1 e0 02             	shl    $0x2,%eax
 8048fbe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8048fc5:	29 c2                	sub    %eax,%edx
 8048fc7:	89 d0                	mov    %edx,%eax
 8048fc9:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8048fce:	89 48 08             	mov    %ecx,0x8(%eax)
		monsters[i].sx = -1 + KISS()%3;
 8048fd1:	e8 be f0 ff ff       	call   8048094 <UKISS>
 8048fd6:	89 c2                	mov    %eax,%edx
 8048fd8:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8048fdd:	01 c2                	add    %eax,%edx
 8048fdf:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8048fe4:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8048fe7:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8048fec:	89 c8                	mov    %ecx,%eax
 8048fee:	f7 e2                	mul    %edx
 8048ff0:	d1 ea                	shr    %edx
 8048ff2:	89 d0                	mov    %edx,%eax
 8048ff4:	01 c0                	add    %eax,%eax
 8048ff6:	01 d0                	add    %edx,%eax
 8048ff8:	29 c1                	sub    %eax,%ecx
 8048ffa:	89 ca                	mov    %ecx,%edx
 8048ffc:	8d 42 ff             	lea    -0x1(%edx),%eax
 8048fff:	89 c1                	mov    %eax,%ecx
 8049001:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049004:	c1 e0 02             	shl    $0x2,%eax
 8049007:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804900e:	29 c2                	sub    %eax,%edx
 8049010:	89 d0                	mov    %edx,%eax
 8049012:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049017:	89 48 0c             	mov    %ecx,0xc(%eax)
		monsters[i].sy = -1 + KISS()%3;
 804901a:	e8 75 f0 ff ff       	call   8048094 <UKISS>
 804901f:	89 c2                	mov    %eax,%edx
 8049021:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049026:	01 c2                	add    %eax,%edx
 8049028:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804902d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049030:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8049035:	89 c8                	mov    %ecx,%eax
 8049037:	f7 e2                	mul    %edx
 8049039:	d1 ea                	shr    %edx
 804903b:	89 d0                	mov    %edx,%eax
 804903d:	01 c0                	add    %eax,%eax
 804903f:	01 d0                	add    %edx,%eax
 8049041:	29 c1                	sub    %eax,%ecx
 8049043:	89 ca                	mov    %ecx,%edx
 8049045:	8d 42 ff             	lea    -0x1(%edx),%eax
 8049048:	89 c1                	mov    %eax,%ecx
 804904a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804904d:	89 c2                	mov    %eax,%edx
 804904f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049056:	89 c2                	mov    %eax,%edx
 8049058:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804905f:	29 d0                	sub    %edx,%eax
 8049061:	83 c0 10             	add    $0x10,%eax
 8049064:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049069:	89 08                	mov    %ecx,(%eax)
		i++;
 804906b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		REP_MONSTER(){
 804906f:	e9 29 02 00 00       	jmp    804929d <dreamOf100HZ+0x44b>
			monsters[i].status = MONSTER_SLEEP;
 8049074:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049077:	89 c2                	mov    %eax,%edx
 8049079:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049080:	89 c2                	mov    %eax,%edx
 8049082:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049089:	29 d0                	sub    %edx,%eax
 804908b:	83 c0 10             	add    $0x10,%eax
 804908e:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049093:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
			monsters[i].count = 0;
 804909a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804909d:	89 c2                	mov    %eax,%edx
 804909f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 80490a6:	89 c2                	mov    %eax,%edx
 80490a8:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 80490af:	29 d0                	sub    %edx,%eax
 80490b1:	83 c0 10             	add    $0x10,%eax
 80490b4:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80490b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			if(KISS()%MONSTER_SIZE < size+3){
 80490c0:	e8 cf ef ff ff       	call   8048094 <UKISS>
 80490c5:	89 c2                	mov    %eax,%edx
 80490c7:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80490cc:	01 c2                	add    %eax,%edx
 80490ce:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80490d3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80490d6:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 80490db:	89 c8                	mov    %ecx,%eax
 80490dd:	f7 e2                	mul    %edx
 80490df:	c1 ea 04             	shr    $0x4,%edx
 80490e2:	89 d0                	mov    %edx,%eax
 80490e4:	c1 e0 02             	shl    $0x2,%eax
 80490e7:	01 d0                	add    %edx,%eax
 80490e9:	c1 e0 02             	shl    $0x2,%eax
 80490ec:	29 c1                	sub    %eax,%ecx
 80490ee:	89 ca                	mov    %ecx,%edx
 80490f0:	a1 34 ba 04 08       	mov    0x804ba34,%eax
 80490f5:	83 c0 03             	add    $0x3,%eax
 80490f8:	39 c2                	cmp    %eax,%edx
 80490fa:	0f 83 99 01 00 00    	jae    8049299 <dreamOf100HZ+0x447>
				monsters[i].status = MONSTER_ALIVE;
 8049100:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049103:	89 c2                	mov    %eax,%edx
 8049105:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 804910c:	89 c2                	mov    %eax,%edx
 804910e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 8049115:	29 d0                	sub    %edx,%eax
 8049117:	83 c0 10             	add    $0x10,%eax
 804911a:	05 40 ba 04 08       	add    $0x804ba40,%eax
 804911f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				monsters[i].size = 1 + 2*(KISS()%size);
 8049126:	e8 69 ef ff ff       	call   8048094 <UKISS>
 804912b:	89 c2                	mov    %eax,%edx
 804912d:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049132:	01 c2                	add    %eax,%edx
 8049134:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049139:	01 d0                	add    %edx,%eax
 804913b:	8b 15 34 ba 04 08    	mov    0x804ba34,%edx
 8049141:	89 d1                	mov    %edx,%ecx
 8049143:	ba 00 00 00 00       	mov    $0x0,%edx
 8049148:	f7 f1                	div    %ecx
 804914a:	89 d0                	mov    %edx,%eax
 804914c:	01 c0                	add    %eax,%eax
 804914e:	83 c0 01             	add    $0x1,%eax
 8049151:	89 c1                	mov    %eax,%ecx
 8049153:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049156:	c1 e0 02             	shl    $0x2,%eax
 8049159:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8049160:	29 c2                	sub    %eax,%edx
 8049162:	89 d0                	mov    %edx,%eax
 8049164:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049169:	89 08                	mov    %ecx,(%eax)
				monsters[i].x = KISS()%VWIDTH;
 804916b:	e8 24 ef ff ff       	call   8048094 <UKISS>
 8049170:	89 c2                	mov    %eax,%edx
 8049172:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049177:	01 c2                	add    %eax,%edx
 8049179:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804917e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049181:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 8049186:	89 c8                	mov    %ecx,%eax
 8049188:	f7 e2                	mul    %edx
 804918a:	c1 ea 08             	shr    $0x8,%edx
 804918d:	89 d0                	mov    %edx,%eax
 804918f:	c1 e0 02             	shl    $0x2,%eax
 8049192:	01 d0                	add    %edx,%eax
 8049194:	c1 e0 06             	shl    $0x6,%eax
 8049197:	29 c1                	sub    %eax,%ecx
 8049199:	89 ca                	mov    %ecx,%edx
 804919b:	89 d1                	mov    %edx,%ecx
 804919d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491a0:	c1 e0 02             	shl    $0x2,%eax
 80491a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80491aa:	29 c2                	sub    %eax,%edx
 80491ac:	89 d0                	mov    %edx,%eax
 80491ae:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80491b3:	89 48 04             	mov    %ecx,0x4(%eax)
				monsters[i].y = KISS()%VHEIGHT;
 80491b6:	e8 d9 ee ff ff       	call   8048094 <UKISS>
 80491bb:	89 c2                	mov    %eax,%edx
 80491bd:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80491c2:	01 c2                	add    %eax,%edx
 80491c4:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80491c9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 80491cc:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 80491d1:	89 c8                	mov    %ecx,%eax
 80491d3:	f7 e2                	mul    %edx
 80491d5:	89 d0                	mov    %edx,%eax
 80491d7:	c1 e8 06             	shr    $0x6,%eax
 80491da:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
 80491e0:	29 c1                	sub    %eax,%ecx
 80491e2:	89 c8                	mov    %ecx,%eax
 80491e4:	89 c1                	mov    %eax,%ecx
 80491e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80491e9:	c1 e0 02             	shl    $0x2,%eax
 80491ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 80491f3:	29 c2                	sub    %eax,%edx
 80491f5:	89 d0                	mov    %edx,%eax
 80491f7:	05 40 ba 04 08       	add    $0x804ba40,%eax
 80491fc:	89 48 08             	mov    %ecx,0x8(%eax)
				monsters[i].sx = -1 + KISS()%3;
 80491ff:	e8 90 ee ff ff       	call   8048094 <UKISS>
 8049204:	89 c2                	mov    %eax,%edx
 8049206:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804920b:	01 c2                	add    %eax,%edx
 804920d:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049212:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 8049215:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 804921a:	89 c8                	mov    %ecx,%eax
 804921c:	f7 e2                	mul    %edx
 804921e:	d1 ea                	shr    %edx
 8049220:	89 d0                	mov    %edx,%eax
 8049222:	01 c0                	add    %eax,%eax
 8049224:	01 d0                	add    %edx,%eax
 8049226:	29 c1                	sub    %eax,%ecx
 8049228:	89 ca                	mov    %ecx,%edx
 804922a:	8d 42 ff             	lea    -0x1(%edx),%eax
 804922d:	89 c1                	mov    %eax,%ecx
 804922f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049232:	c1 e0 02             	shl    $0x2,%eax
 8049235:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 804923c:	29 c2                	sub    %eax,%edx
 804923e:	89 d0                	mov    %edx,%eax
 8049240:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049245:	89 48 0c             	mov    %ecx,0xc(%eax)
				monsters[i].sy = -1 + KISS()%3;
 8049248:	e8 47 ee ff ff       	call   8048094 <UKISS>
 804924d:	89 c2                	mov    %eax,%edx
 804924f:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049254:	01 c2                	add    %eax,%edx
 8049256:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804925b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 804925e:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
 8049263:	89 c8                	mov    %ecx,%eax
 8049265:	f7 e2                	mul    %edx
 8049267:	d1 ea                	shr    %edx
 8049269:	89 d0                	mov    %edx,%eax
 804926b:	01 c0                	add    %eax,%eax
 804926d:	01 d0                	add    %edx,%eax
 804926f:	29 c1                	sub    %eax,%ecx
 8049271:	89 ca                	mov    %ecx,%edx
 8049273:	8d 42 ff             	lea    -0x1(%edx),%eax
 8049276:	89 c1                	mov    %eax,%ecx
 8049278:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804927b:	89 c2                	mov    %eax,%edx
 804927d:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 8049284:	89 c2                	mov    %eax,%edx
 8049286:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
 804928d:	29 d0                	sub    %edx,%eax
 804928f:	83 c0 10             	add    $0x10,%eax
 8049292:	05 40 ba 04 08       	add    $0x804ba40,%eax
 8049297:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
 8049299:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 804929d:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 80492a1:	0f 8e cd fd ff ff    	jle    8049074 <dreamOf100HZ+0x222>
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printf("Press Q to start\n");
 80492a7:	83 ec 0c             	sub    $0xc,%esp
 80492aa:	68 ba a0 04 08       	push   $0x804a0ba
 80492af:	e8 1a 05 00 00       	call   80497ce <printf>
 80492b4:	83 c4 10             	add    $0x10,%esp
		gameStatus = GAME_READY;
 80492b7:	c7 05 28 ba 04 08 01 	movl   $0x1,0x804ba28
 80492be:	00 00 00 
	}
	if(gameStatus == GAME_READY){
 80492c1:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 80492c6:	83 f8 01             	cmp    $0x1,%eax
 80492c9:	75 30                	jne    80492fb <dreamOf100HZ+0x4a9>
		//printf("%d\n", key('q'));
		if(key('q')){
 80492cb:	83 ec 0c             	sub    $0xc,%esp
 80492ce:	6a 71                	push   $0x71
 80492d0:	e8 7c f3 ff ff       	call   8048651 <key>
 80492d5:	83 c4 10             	add    $0x10,%esp
 80492d8:	84 c0                	test   %al,%al
 80492da:	74 1f                	je     80492fb <dreamOf100HZ+0x4a9>
			printf("Press W, A, S, D to move\n");
 80492dc:	83 ec 0c             	sub    $0xc,%esp
 80492df:	68 cc a0 04 08       	push   $0x804a0cc
 80492e4:	e8 e5 04 00 00       	call   80497ce <printf>
 80492e9:	83 c4 10             	add    $0x10,%esp
			gameStatus = GAME_ING;
 80492ec:	c7 05 28 ba 04 08 02 	movl   $0x2,0x804ba28
 80492f3:	00 00 00 
			return;
 80492f6:	e9 e4 01 00 00       	jmp    80494df <dreamOf100HZ+0x68d>
		}
		
	}

	if(gameStatus == GAME_ING){
 80492fb:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 8049300:	83 f8 02             	cmp    $0x2,%eax
 8049303:	0f 85 92 01 00 00    	jne    804949b <dreamOf100HZ+0x649>



		//if(x>0 && x<VWIDTH && y>0 && y<VHEIGHT){
		//if(timestamp % 3){
		if(key('a'))x--;
 8049309:	83 ec 0c             	sub    $0xc,%esp
 804930c:	6a 61                	push   $0x61
 804930e:	e8 3e f3 ff ff       	call   8048651 <key>
 8049313:	83 c4 10             	add    $0x10,%esp
 8049316:	84 c0                	test   %al,%al
 8049318:	74 0d                	je     8049327 <dreamOf100HZ+0x4d5>
 804931a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804931f:	83 e8 01             	sub    $0x1,%eax
 8049322:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(key('d'))x++;
 8049327:	83 ec 0c             	sub    $0xc,%esp
 804932a:	6a 64                	push   $0x64
 804932c:	e8 20 f3 ff ff       	call   8048651 <key>
 8049331:	83 c4 10             	add    $0x10,%esp
 8049334:	84 c0                	test   %al,%al
 8049336:	74 0d                	je     8049345 <dreamOf100HZ+0x4f3>
 8049338:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804933d:	83 c0 01             	add    $0x1,%eax
 8049340:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(key('w'))y--;
 8049345:	83 ec 0c             	sub    $0xc,%esp
 8049348:	6a 77                	push   $0x77
 804934a:	e8 02 f3 ff ff       	call   8048651 <key>
 804934f:	83 c4 10             	add    $0x10,%esp
 8049352:	84 c0                	test   %al,%al
 8049354:	74 0d                	je     8049363 <dreamOf100HZ+0x511>
 8049356:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 804935b:	83 e8 01             	sub    $0x1,%eax
 804935e:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(key('s'))y++;
 8049363:	83 ec 0c             	sub    $0xc,%esp
 8049366:	6a 73                	push   $0x73
 8049368:	e8 e4 f2 ff ff       	call   8048651 <key>
 804936d:	83 c4 10             	add    $0x10,%esp
 8049370:	84 c0                	test   %al,%al
 8049372:	74 0d                	je     8049381 <dreamOf100HZ+0x52f>
 8049374:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 8049379:	83 c0 01             	add    $0x1,%eax
 804937c:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		if(x < 0) x++;
 8049381:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049386:	85 c0                	test   %eax,%eax
 8049388:	79 0d                	jns    8049397 <dreamOf100HZ+0x545>
 804938a:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804938f:	83 c0 01             	add    $0x1,%eax
 8049392:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(x > VWIDTH) x--;
 8049397:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 804939c:	3d 40 01 00 00       	cmp    $0x140,%eax
 80493a1:	7e 0d                	jle    80493b0 <dreamOf100HZ+0x55e>
 80493a3:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80493a8:	83 e8 01             	sub    $0x1,%eax
 80493ab:	a3 2c ba 04 08       	mov    %eax,0x804ba2c
		if(y < 0) y++;
 80493b0:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80493b5:	85 c0                	test   %eax,%eax
 80493b7:	79 0d                	jns    80493c6 <dreamOf100HZ+0x574>
 80493b9:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80493be:	83 c0 01             	add    $0x1,%eax
 80493c1:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		if(y > VHEIGHT) y--;
 80493c6:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80493cb:	3d c8 00 00 00       	cmp    $0xc8,%eax
 80493d0:	7e 0d                	jle    80493df <dreamOf100HZ+0x58d>
 80493d2:	a1 30 ba 04 08       	mov    0x804ba30,%eax
 80493d7:	83 e8 01             	sub    $0x1,%eax
 80493da:	a3 30 ba 04 08       	mov    %eax,0x804ba30
		//}
		//else{
		clearStage();
 80493df:	e8 f6 ee ff ff       	call   80482da <clearStage>
		drawCirc(x, y, size, 3);
 80493e4:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 80493ea:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 80493f0:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 80493f5:	6a 03                	push   $0x3
 80493f7:	51                   	push   %ecx
 80493f8:	52                   	push   %edx
 80493f9:	50                   	push   %eax
 80493fa:	e8 a7 ef ff ff       	call   80483a6 <drawCirc>
 80493ff:	83 c4 10             	add    $0x10,%esp
		

		drawMonster();
 8049402:	e8 9f f4 ff ff       	call   80488a6 <drawMonster>
		drawCirc(x, y, size, 3);
 8049407:	8b 0d 34 ba 04 08    	mov    0x804ba34,%ecx
 804940d:	8b 15 30 ba 04 08    	mov    0x804ba30,%edx
 8049413:	a1 2c ba 04 08       	mov    0x804ba2c,%eax
 8049418:	6a 03                	push   $0x3
 804941a:	51                   	push   %ecx
 804941b:	52                   	push   %edx
 804941c:	50                   	push   %eax
 804941d:	e8 84 ef ff ff       	call   80483a6 <drawCirc>
 8049422:	83 c4 10             	add    $0x10,%esp
		drawNumber(score, 10, 180, 1, 7);
 8049425:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 804942a:	83 ec 0c             	sub    $0xc,%esp
 804942d:	6a 07                	push   $0x7
 804942f:	6a 01                	push   $0x1
 8049431:	68 b4 00 00 00       	push   $0xb4
 8049436:	6a 0a                	push   $0xa
 8049438:	50                   	push   %eax
 8049439:	e8 8d f0 ff ff       	call   80484cb <drawNumber>
 804943e:	83 c4 20             	add    $0x20,%esp
		drawNumber(getpid(), 300, 10, 1, 7);
 8049441:	e8 21 ed ff ff       	call   8048167 <sys_pid>
 8049446:	83 ec 0c             	sub    $0xc,%esp
 8049449:	6a 07                	push   $0x7
 804944b:	6a 01                	push   $0x1
 804944d:	6a 0a                	push   $0xa
 804944f:	68 2c 01 00 00       	push   $0x12c
 8049454:	50                   	push   %eax
 8049455:	e8 71 f0 ff ff       	call   80484cb <drawNumber>
 804945a:	83 c4 20             	add    $0x20,%esp
		if(key('p')){
 804945d:	83 ec 0c             	sub    $0xc,%esp
 8049460:	6a 70                	push   $0x70
 8049462:	e8 ea f1 ff ff       	call   8048651 <key>
 8049467:	83 c4 10             	add    $0x10,%esp
 804946a:	84 c0                	test   %al,%al
 804946c:	74 19                	je     8049487 <dreamOf100HZ+0x635>
			drawNumber(getpid(), 100, 100, 5, 7);
 804946e:	e8 f4 ec ff ff       	call   8048167 <sys_pid>
 8049473:	83 ec 0c             	sub    $0xc,%esp
 8049476:	6a 07                	push   $0x7
 8049478:	6a 05                	push   $0x5
 804947a:	6a 64                	push   $0x64
 804947c:	6a 64                	push   $0x64
 804947e:	50                   	push   %eax
 804947f:	e8 47 f0 ff ff       	call   80484cb <drawNumber>
 8049484:	83 c4 20             	add    $0x20,%esp
		}
		drawStage();
 8049487:	e8 a0 f1 ff ff       	call   804862c <drawStage>
		
		
		createMonster();
 804948c:	e8 c3 f7 ff ff       	call   8048c54 <createMonster>
		while(hitMonster());
 8049491:	90                   	nop
 8049492:	e8 50 f2 ff ff       	call   80486e7 <hitMonster>
 8049497:	85 c0                	test   %eax,%eax
 8049499:	75 f7                	jne    8049492 <dreamOf100HZ+0x640>
		//}
	}
	if(gameStatus == GAME_END){
 804949b:	a1 28 ba 04 08       	mov    0x804ba28,%eax
 80494a0:	83 f8 03             	cmp    $0x3,%eax
 80494a3:	75 3a                	jne    80494df <dreamOf100HZ+0x68d>
		printf("You're dead\n");
 80494a5:	83 ec 0c             	sub    $0xc,%esp
 80494a8:	68 e6 a0 04 08       	push   $0x804a0e6
 80494ad:	e8 1c 03 00 00       	call   80497ce <printf>
 80494b2:	83 c4 10             	add    $0x10,%esp
		printf("Score: %d\n", score);
 80494b5:	a1 24 ba 04 08       	mov    0x804ba24,%eax
 80494ba:	83 ec 08             	sub    $0x8,%esp
 80494bd:	50                   	push   %eax
 80494be:	68 f3 a0 04 08       	push   $0x804a0f3
 80494c3:	e8 06 03 00 00       	call   80497ce <printf>
 80494c8:	83 c4 10             	add    $0x10,%esp
		clearStage();
 80494cb:	e8 0a ee ff ff       	call   80482da <clearStage>
		drawStage();
 80494d0:	e8 57 f1 ff ff       	call   804862c <drawStage>
		gameStatus = GAME_START;
 80494d5:	c7 05 28 ba 04 08 00 	movl   $0x0,0x804ba28
 80494dc:	00 00 00 
	}
 80494df:	c9                   	leave  
 80494e0:	c3                   	ret    

080494e1 <sys_printch>:

static inline void sys_join(int pid){
	asm volatile("int $0x80": : "a"(SYS_JOIN), "b"(pid)); //SYSCALL HERE!
}

static inline void sys_printch(char c){
 80494e1:	55                   	push   %ebp
 80494e2:	89 e5                	mov    %esp,%ebp
 80494e4:	53                   	push   %ebx
 80494e5:	83 ec 04             	sub    $0x4,%esp
 80494e8:	8b 45 08             	mov    0x8(%ebp),%eax
 80494eb:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
 80494ee:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 80494f3:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
 80494f7:	89 d3                	mov    %edx,%ebx
 80494f9:	cd 80                	int    $0x80
}
 80494fb:	83 c4 04             	add    $0x4,%esp
 80494fe:	5b                   	pop    %ebx
 80494ff:	5d                   	pop    %ebp
 8049500:	c3                   	ret    

08049501 <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
 8049501:	55                   	push   %ebp
 8049502:	89 e5                	mov    %esp,%ebp
 8049504:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
 8049507:	8b 45 0c             	mov    0xc(%ebp),%eax
 804950a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
 804950d:	eb 19                	jmp    8049528 <printp+0x27>
		printer(cur);
 804950f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049512:	0f b6 00             	movzbl (%eax),%eax
 8049515:	0f be c0             	movsbl %al,%eax
 8049518:	83 ec 0c             	sub    $0xc,%esp
 804951b:	50                   	push   %eax
 804951c:	8b 45 08             	mov    0x8(%ebp),%eax
 804951f:	ff d0                	call   *%eax
 8049521:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
 8049524:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 8049528:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804952b:	0f b6 00             	movzbl (%eax),%eax
 804952e:	84 c0                	test   %al,%al
 8049530:	75 dd                	jne    804950f <printp+0xe>
		printer(cur);
	}
}
 8049532:	c9                   	leave  
 8049533:	c3                   	ret    

08049534 <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
 8049534:	55                   	push   %ebp
 8049535:	89 e5                	mov    %esp,%ebp
 8049537:	83 ec 58             	sub    $0x58,%esp
	const char *str = ctl;
 804953a:	8b 45 0c             	mov    0xc(%ebp),%eax
 804953d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
 8049540:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
 8049547:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
 804954e:	8b 45 10             	mov    0x10(%ebp),%eax
 8049551:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
 8049554:	e9 65 02 00 00       	jmp    80497be <vfprintf+0x28a>

		if(cur == '%'){
 8049559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804955c:	0f b6 00             	movzbl (%eax),%eax
 804955f:	3c 25                	cmp    $0x25,%al
 8049561:	75 0c                	jne    804956f <vfprintf+0x3b>
			//sys_printch('0');
			type = READ;
 8049563:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
 804956a:	e9 4b 02 00 00       	jmp    80497ba <vfprintf+0x286>
		}
		if(type == READ){
 804956f:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
 8049573:	0f 85 26 02 00 00    	jne    804979f <vfprintf+0x26b>
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
 8049579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804957c:	0f b6 00             	movzbl (%eax),%eax
 804957f:	3c 73                	cmp    $0x73,%al
 8049581:	75 35                	jne    80495b8 <vfprintf+0x84>
				char* p= XGET(pointer, char*);
 8049583:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049586:	8b 00                	mov    (%eax),%eax
 8049588:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
 804958b:	eb 19                	jmp    80495a6 <vfprintf+0x72>
					printer(*p);
 804958d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8049590:	0f b6 00             	movzbl (%eax),%eax
 8049593:	0f be c0             	movsbl %al,%eax
 8049596:	83 ec 0c             	sub    $0xc,%esp
 8049599:	50                   	push   %eax
 804959a:	8b 45 08             	mov    0x8(%ebp),%eax
 804959d:	ff d0                	call   *%eax
 804959f:	83 c4 10             	add    $0x10,%esp
		if(type == READ){
			//sys_printch('1');
			//sys_printch(cur);
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
 80495a2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 80495a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80495a9:	0f b6 00             	movzbl (%eax),%eax
 80495ac:	84 c0                	test   %al,%al
 80495ae:	75 dd                	jne    804958d <vfprintf+0x59>
					printer(*p);
				}
				XNEXT(pointer);
 80495b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 80495b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch('2');
			//sys_printch(cur);
			if(cur == 'x'){
 80495b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80495bb:	0f b6 00             	movzbl (%eax),%eax
 80495be:	3c 78                	cmp    $0x78,%al
 80495c0:	0f 85 99 00 00 00    	jne    804965f <vfprintf+0x12b>
				uint32_t x = XGET(pointer, int);
 80495c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 80495c9:	8b 00                	mov    (%eax),%eax
 80495cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
 80495ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 80495d2:	75 1d                	jne    80495f1 <vfprintf+0xbd>
					printer('0');
 80495d4:	83 ec 0c             	sub    $0xc,%esp
 80495d7:	6a 30                	push   $0x30
 80495d9:	8b 45 08             	mov    0x8(%ebp),%eax
 80495dc:	ff d0                	call   *%eax
 80495de:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80495e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80495e5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 80495ec:	e9 c9 01 00 00       	jmp    80497ba <vfprintf+0x286>
					continue;
				}
				char digits[15];
				int di=0;
 80495f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
 80495f8:	eb 2d                	jmp    8049627 <vfprintf+0xf3>
					int d=(x%16);
 80495fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
 80495fd:	83 e0 0f             	and    $0xf,%eax
 8049600:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
 8049603:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
 8049607:	7e 04                	jle    804960d <vfprintf+0xd9>
						d+='a'-'0'-10;
 8049609:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
 804960d:	8b 45 d8             	mov    -0x28(%ebp),%eax
 8049610:	83 c0 30             	add    $0x30,%eax
 8049613:	89 c1                	mov    %eax,%ecx
 8049615:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8049618:	8b 45 dc             	mov    -0x24(%ebp),%eax
 804961b:	01 d0                	add    %edx,%eax
 804961d:	88 08                	mov    %cl,(%eax)
					x>>=4;
 804961f:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
 8049623:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8049627:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
 804962b:	75 cd                	jne    80495fa <vfprintf+0xc6>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
 804962d:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
 8049631:	eb 1e                	jmp    8049651 <vfprintf+0x11d>
					printer(digits[di]);
 8049633:	8d 55 c1             	lea    -0x3f(%ebp),%edx
 8049636:	8b 45 dc             	mov    -0x24(%ebp),%eax
 8049639:	01 d0                	add    %edx,%eax
 804963b:	0f b6 00             	movzbl (%eax),%eax
 804963e:	0f be c0             	movsbl %al,%eax
 8049641:	83 ec 0c             	sub    $0xc,%esp
 8049644:	50                   	push   %eax
 8049645:	8b 45 08             	mov    0x8(%ebp),%eax
 8049648:	ff d0                	call   *%eax
 804964a:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
 804964d:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
 8049651:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 8049655:	79 dc                	jns    8049633 <vfprintf+0xff>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8049657:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804965b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			//sys_printch(cur);
			//sys_printch('3');
			if(cur == 'd'){
 804965f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049662:	0f b6 00             	movzbl (%eax),%eax
 8049665:	3c 64                	cmp    $0x64,%al
 8049667:	0f 85 02 01 00 00    	jne    804976f <vfprintf+0x23b>
				//sys_printch('6');
				//sys_printch('e');
				int x = XGET(pointer, int);
 804966d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8049670:	8b 00                	mov    (%eax),%eax
 8049672:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
 8049675:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
 804967c:	75 23                	jne    80496a1 <vfprintf+0x16d>
					printp(printer, "-2147483648");
 804967e:	83 ec 08             	sub    $0x8,%esp
 8049681:	68 fe a0 04 08       	push   $0x804a0fe
 8049686:	ff 75 08             	pushl  0x8(%ebp)
 8049689:	e8 73 fe ff ff       	call   8049501 <printp>
 804968e:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 8049691:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 8049695:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 804969c:	e9 19 01 00 00       	jmp    80497ba <vfprintf+0x286>
				}
				if(x==0){
 80496a1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80496a5:	75 1e                	jne    80496c5 <vfprintf+0x191>
					printer('0');
 80496a7:	83 ec 0c             	sub    $0xc,%esp
 80496aa:	6a 30                	push   $0x30
 80496ac:	8b 45 08             	mov    0x8(%ebp),%eax
 80496af:	ff d0                	call   *%eax
 80496b1:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
 80496b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
 80496b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
 80496bf:	90                   	nop
 80496c0:	e9 f5 00 00 00       	jmp    80497ba <vfprintf+0x286>
				}
				if(x<0){
 80496c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 80496c9:	79 10                	jns    80496db <vfprintf+0x1a7>
					printer('-');
 80496cb:	83 ec 0c             	sub    $0xc,%esp
 80496ce:	6a 2d                	push   $0x2d
 80496d0:	8b 45 08             	mov    0x8(%ebp),%eax
 80496d3:	ff d0                	call   *%eax
 80496d5:	83 c4 10             	add    $0x10,%esp
					x=-x;
 80496d8:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[15];
				int di=0;
 80496db:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
 80496e2:	eb 53                	jmp    8049737 <vfprintf+0x203>
					digits[di] = '0'+(x%10);
 80496e4:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 80496e7:	ba 67 66 66 66       	mov    $0x66666667,%edx
 80496ec:	89 c8                	mov    %ecx,%eax
 80496ee:	f7 ea                	imul   %edx
 80496f0:	c1 fa 02             	sar    $0x2,%edx
 80496f3:	89 c8                	mov    %ecx,%eax
 80496f5:	c1 f8 1f             	sar    $0x1f,%eax
 80496f8:	29 c2                	sub    %eax,%edx
 80496fa:	89 d0                	mov    %edx,%eax
 80496fc:	c1 e0 02             	shl    $0x2,%eax
 80496ff:	01 d0                	add    %edx,%eax
 8049701:	01 c0                	add    %eax,%eax
 8049703:	29 c1                	sub    %eax,%ecx
 8049705:	89 ca                	mov    %ecx,%edx
 8049707:	89 d0                	mov    %edx,%eax
 8049709:	83 c0 30             	add    $0x30,%eax
 804970c:	89 c1                	mov    %eax,%ecx
 804970e:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8049711:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8049714:	01 d0                	add    %edx,%eax
 8049716:	88 08                	mov    %cl,(%eax)
					x/=10;
 8049718:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 804971b:	ba 67 66 66 66       	mov    $0x66666667,%edx
 8049720:	89 c8                	mov    %ecx,%eax
 8049722:	f7 ea                	imul   %edx
 8049724:	c1 fa 02             	sar    $0x2,%edx
 8049727:	89 c8                	mov    %ecx,%eax
 8049729:	c1 f8 1f             	sar    $0x1f,%eax
 804972c:	29 c2                	sub    %eax,%edx
 804972e:	89 d0                	mov    %edx,%eax
 8049730:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
 8049733:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[15];
				int di=0;
				while(x>=1){
 8049737:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 804973b:	7f a7                	jg     80496e4 <vfprintf+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
 804973d:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
 8049741:	eb 1e                	jmp    8049761 <vfprintf+0x22d>
					printer(digits[di]);
 8049743:	8d 55 b2             	lea    -0x4e(%ebp),%edx
 8049746:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8049749:	01 d0                	add    %edx,%eax
 804974b:	0f b6 00             	movzbl (%eax),%eax
 804974e:	0f be c0             	movsbl %al,%eax
 8049751:	83 ec 0c             	sub    $0xc,%esp
 8049754:	50                   	push   %eax
 8049755:	8b 45 08             	mov    0x8(%ebp),%eax
 8049758:	ff d0                	call   *%eax
 804975a:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
 804975d:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
 8049761:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 8049765:	79 dc                	jns    8049743 <vfprintf+0x20f>
					printer(digits[di]);
				}
				XNEXT(pointer);
 8049767:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 804976b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
 804976f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8049772:	0f b6 00             	movzbl (%eax),%eax
 8049775:	3c 63                	cmp    $0x63,%al
 8049777:	75 1d                	jne    8049796 <vfprintf+0x262>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
 8049779:	8b 45 e8             	mov    -0x18(%ebp),%eax
 804977c:	0f b6 00             	movzbl (%eax),%eax
 804977f:	0f be c0             	movsbl %al,%eax
 8049782:	83 ec 0c             	sub    $0xc,%esp
 8049785:	50                   	push   %eax
 8049786:	8b 45 08             	mov    0x8(%ebp),%eax
 8049789:	ff d0                	call   *%eax
 804978b:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
 804978e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
 8049792:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
 8049796:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
 804979d:	eb 1b                	jmp    80497ba <vfprintf+0x286>
		}
		if(type == NONE){
 804979f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80497a3:	75 15                	jne    80497ba <vfprintf+0x286>
			printer(cur);
 80497a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80497a8:	0f b6 00             	movzbl (%eax),%eax
 80497ab:	0f be c0             	movsbl %al,%eax
 80497ae:	83 ec 0c             	sub    $0xc,%esp
 80497b1:	50                   	push   %eax
 80497b2:	8b 45 08             	mov    0x8(%ebp),%eax
 80497b5:	ff d0                	call   *%eax
 80497b7:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
 80497ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 80497be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80497c1:	0f b6 00             	movzbl (%eax),%eax
 80497c4:	84 c0                	test   %al,%al
 80497c6:	0f 85 8d fd ff ff    	jne    8049559 <vfprintf+0x25>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
 80497cc:	c9                   	leave  
 80497cd:	c3                   	ret    

080497ce <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
 80497ce:	55                   	push   %ebp
 80497cf:	89 e5                	mov    %esp,%ebp
 80497d1:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
 80497d4:	8d 45 0c             	lea    0xc(%ebp),%eax
 80497d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//sys_printch('e');
	vfprintf(sys_printch, ctl, args);
 80497da:	8b 45 08             	mov    0x8(%ebp),%eax
 80497dd:	83 ec 04             	sub    $0x4,%esp
 80497e0:	ff 75 f4             	pushl  -0xc(%ebp)
 80497e3:	50                   	push   %eax
 80497e4:	68 e1 94 04 08       	push   $0x80494e1
 80497e9:	e8 46 fd ff ff       	call   8049534 <vfprintf>
 80497ee:	83 c4 10             	add    $0x10,%esp
}
 80497f1:	c9                   	leave  
 80497f2:	c3                   	ret    
