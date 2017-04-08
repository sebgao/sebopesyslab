
game.bin:     file format elf32-i386


Disassembly of section .text:

00200000 <UKISS>:
                   y = 362436000,  
                   z = 521288629,  
                   c = 7654321; /* Seed variables */   

unsigned int UKISS()  
{    
  200000:	55                   	push   %ebp
  200001:	89 e5                	mov    %esp,%ebp
  200003:	53                   	push   %ebx
  200004:	83 ec 14             	sub    $0x14,%esp
    unsigned long long t, A = 698769069ULL;    
  200007:	c7 45 f0 ad 5e a6 29 	movl   $0x29a65ead,-0x10(%ebp)
  20000e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
    x = 69069*x+12345;    
  200015:	a1 00 30 20 00       	mov    0x203000,%eax
  20001a:	69 c0 cd 0d 01 00    	imul   $0x10dcd,%eax,%eax
  200020:	05 39 30 00 00       	add    $0x3039,%eax
  200025:	a3 00 30 20 00       	mov    %eax,0x203000
    y ^= (y<<13);   
  20002a:	a1 04 30 20 00       	mov    0x203004,%eax
  20002f:	c1 e0 0d             	shl    $0xd,%eax
  200032:	89 c2                	mov    %eax,%edx
  200034:	a1 04 30 20 00       	mov    0x203004,%eax
  200039:	31 d0                	xor    %edx,%eax
  20003b:	a3 04 30 20 00       	mov    %eax,0x203004
    y ^= (y>>17);   
  200040:	a1 04 30 20 00       	mov    0x203004,%eax
  200045:	c1 e8 11             	shr    $0x11,%eax
  200048:	89 c2                	mov    %eax,%edx
  20004a:	a1 04 30 20 00       	mov    0x203004,%eax
  20004f:	31 d0                	xor    %edx,%eax
  200051:	a3 04 30 20 00       	mov    %eax,0x203004
    y ^= (y<<5);    
  200056:	a1 04 30 20 00       	mov    0x203004,%eax
  20005b:	c1 e0 05             	shl    $0x5,%eax
  20005e:	89 c2                	mov    %eax,%edx
  200060:	a1 04 30 20 00       	mov    0x203004,%eax
  200065:	31 d0                	xor    %edx,%eax
  200067:	a3 04 30 20 00       	mov    %eax,0x203004
      
    t = (A*z + c);  
  20006c:	a1 08 30 20 00       	mov    0x203008,%eax
  200071:	ba 00 00 00 00       	mov    $0x0,%edx
  200076:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  200079:	89 cb                	mov    %ecx,%ebx
  20007b:	0f af da             	imul   %edx,%ebx
  20007e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  200081:	0f af c8             	imul   %eax,%ecx
  200084:	01 d9                	add    %ebx,%ecx
  200086:	f7 65 f0             	mull   -0x10(%ebp)
  200089:	01 d1                	add    %edx,%ecx
  20008b:	89 ca                	mov    %ecx,%edx
  20008d:	8b 0d 0c 30 20 00    	mov    0x20300c,%ecx
  200093:	bb 00 00 00 00       	mov    $0x0,%ebx
  200098:	01 c8                	add    %ecx,%eax
  20009a:	11 da                	adc    %ebx,%edx
  20009c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  20009f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    c = (t >> 32);  
  2000a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2000a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  2000a8:	89 d0                	mov    %edx,%eax
  2000aa:	31 d2                	xor    %edx,%edx
  2000ac:	a3 0c 30 20 00       	mov    %eax,0x20300c
    z = t;  
  2000b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2000b4:	a3 08 30 20 00       	mov    %eax,0x203008
       
    return x+y+z;    
  2000b9:	8b 15 00 30 20 00    	mov    0x203000,%edx
  2000bf:	a1 04 30 20 00       	mov    0x203004,%eax
  2000c4:	01 c2                	add    %eax,%edx
  2000c6:	a1 08 30 20 00       	mov    0x203008,%eax
  2000cb:	01 d0                	add    %edx,%eax
  2000cd:	83 c4 14             	add    $0x14,%esp
  2000d0:	5b                   	pop    %ebx
  2000d1:	5d                   	pop    %ebp
  2000d2:	c3                   	ret    

002000d3 <sys_init_vcache>:

static inline void sys_printch(char c){
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
}

static inline void sys_init_vcache(){
  2000d3:	55                   	push   %ebp
  2000d4:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_INIT_CACHE)); //SYSCALL HERE!
  2000d6:	b8 4c 04 00 00       	mov    $0x44c,%eax
  2000db:	cd 80                	int    $0x80
}
  2000dd:	5d                   	pop    %ebp
  2000de:	c3                   	ret    

002000df <sys_flush_vcache>:

static inline void sys_clear_vram(){
	asm volatile("int $0x80": : "a"(SYS_CLEAR_VRAM)); //SYSCALL HERE!
}
static inline void sys_flush_vcache(){
  2000df:	55                   	push   %ebp
  2000e0:	89 e5                	mov    %esp,%ebp
	asm volatile("int $0x80": : "a"(SYS_FLUSH_VCACHE)); //SYSCALL HERE!
  2000e2:	b8 4e 04 00 00       	mov    $0x44e,%eax
  2000e7:	cd 80                	int    $0x80
}
  2000e9:	5d                   	pop    %ebp
  2000ea:	c3                   	ret    

002000eb <sys_set_pixel>:
static inline void sys_set_pixel(int x, int y, int color){
  2000eb:	55                   	push   %ebp
  2000ec:	89 e5                	mov    %esp,%ebp
  2000ee:	53                   	push   %ebx
	asm volatile("int $0x80": : "a"(SYS_SET_PIXEL), "b"(x), "c"(y), "d"(color)); //SYSCALL HERE!
  2000ef:	b8 4f 04 00 00       	mov    $0x44f,%eax
  2000f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  2000f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  2000fa:	8b 55 10             	mov    0x10(%ebp),%edx
  2000fd:	cd 80                	int    $0x80
}
  2000ff:	5b                   	pop    %ebx
  200100:	5d                   	pop    %ebp
  200101:	c3                   	ret    

00200102 <sys_key_down>:
static inline void sys_add_timer(void (*ptr)(void)){
	asm volatile("int $0x80": : "a"(SYS_ADD_TIMER), "b"(ptr));
}
static inline char sys_key_down(char s){
  200102:	55                   	push   %ebp
  200103:	89 e5                	mov    %esp,%ebp
  200105:	53                   	push   %ebx
  200106:	83 ec 14             	sub    $0x14,%esp
  200109:	8b 45 08             	mov    0x8(%ebp),%eax
  20010c:	88 45 e8             	mov    %al,-0x18(%ebp)
	char r_eax = 0;
  20010f:	c6 45 fb 00          	movb   $0x0,-0x5(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_KEY), "b"(s)); //SYSCALL HERE!
  200113:	b8 b0 04 00 00       	mov    $0x4b0,%eax
  200118:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
  20011c:	89 d3                	mov    %edx,%ebx
  20011e:	cd 80                	int    $0x80
  200120:	88 45 fb             	mov    %al,-0x5(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
  200123:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
  200127:	83 c4 14             	add    $0x14,%esp
  20012a:	5b                   	pop    %ebx
  20012b:	5d                   	pop    %ebp
  20012c:	c3                   	ret    

0020012d <sys_get_tick>:
static inline uint32_t sys_get_tick(){
  20012d:	55                   	push   %ebp
  20012e:	89 e5                	mov    %esp,%ebp
  200130:	83 ec 10             	sub    $0x10,%esp
	uint32_t r_eax = 0;
  200133:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	asm volatile("int $0x80": "=a"(r_eax) : "a"(SYS_GET_TICK)); //SYSCALL HERE!
  20013a:	b8 15 05 00 00       	mov    $0x515,%eax
  20013f:	cd 80                	int    $0x80
  200141:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//asm volatile("movl %%eax, %0\n" : : "m"(r_eax));
	return r_eax;
  200144:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  200147:	c9                   	leave  
  200148:	c3                   	ret    

00200149 <isqrt>:
    1,1,1,1,1
};
const char* nums[10]={
    num0, num1, num2, num3, num4, num5, num6, num7, num8, num9
};
static inline int isqrt(uint32_t x) {
  200149:	55                   	push   %ebp
  20014a:	89 e5                	mov    %esp,%ebp
  20014c:	83 ec 10             	sub    $0x10,%esp
    if(memoriza[x] > 0) return memoriza[x];
  20014f:	8b 45 08             	mov    0x8(%ebp),%eax
  200152:	8b 04 85 c0 30 20 00 	mov    0x2030c0(,%eax,4),%eax
  200159:	85 c0                	test   %eax,%eax
  20015b:	74 0f                	je     20016c <isqrt+0x23>
  20015d:	8b 45 08             	mov    0x8(%ebp),%eax
  200160:	8b 04 85 c0 30 20 00 	mov    0x2030c0(,%eax,4),%eax
  200167:	e9 a9 00 00 00       	jmp    200215 <isqrt+0xcc>
    const uint16_t *p = squares;
  20016c:	c7 45 fc 40 19 20 00 	movl   $0x201940,-0x4(%ebp)
    //if (p[128] <= x) p += 128;
    //if (p[ 64] <= x) p +=  64;
    if (p[ 32] <= x) p +=  32;
  200173:	8b 45 fc             	mov    -0x4(%ebp),%eax
  200176:	83 c0 40             	add    $0x40,%eax
  200179:	0f b7 00             	movzwl (%eax),%eax
  20017c:	0f b7 c0             	movzwl %ax,%eax
  20017f:	3b 45 08             	cmp    0x8(%ebp),%eax
  200182:	77 04                	ja     200188 <isqrt+0x3f>
  200184:	83 45 fc 40          	addl   $0x40,-0x4(%ebp)
    if (p[ 16] <= x) p +=  16;
  200188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  20018b:	83 c0 20             	add    $0x20,%eax
  20018e:	0f b7 00             	movzwl (%eax),%eax
  200191:	0f b7 c0             	movzwl %ax,%eax
  200194:	3b 45 08             	cmp    0x8(%ebp),%eax
  200197:	77 04                	ja     20019d <isqrt+0x54>
  200199:	83 45 fc 20          	addl   $0x20,-0x4(%ebp)
    if (p[  8] <= x) p +=   8;
  20019d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2001a0:	83 c0 10             	add    $0x10,%eax
  2001a3:	0f b7 00             	movzwl (%eax),%eax
  2001a6:	0f b7 c0             	movzwl %ax,%eax
  2001a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  2001ac:	77 04                	ja     2001b2 <isqrt+0x69>
  2001ae:	83 45 fc 10          	addl   $0x10,-0x4(%ebp)
    if (p[  4] <= x) p +=   4;
  2001b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2001b5:	83 c0 08             	add    $0x8,%eax
  2001b8:	0f b7 00             	movzwl (%eax),%eax
  2001bb:	0f b7 c0             	movzwl %ax,%eax
  2001be:	3b 45 08             	cmp    0x8(%ebp),%eax
  2001c1:	77 04                	ja     2001c7 <isqrt+0x7e>
  2001c3:	83 45 fc 08          	addl   $0x8,-0x4(%ebp)
    if (p[  2] <= x) p +=   2;
  2001c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2001ca:	83 c0 04             	add    $0x4,%eax
  2001cd:	0f b7 00             	movzwl (%eax),%eax
  2001d0:	0f b7 c0             	movzwl %ax,%eax
  2001d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  2001d6:	77 04                	ja     2001dc <isqrt+0x93>
  2001d8:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
    if (p[  1] <= x) p +=   1;
  2001dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2001df:	83 c0 02             	add    $0x2,%eax
  2001e2:	0f b7 00             	movzwl (%eax),%eax
  2001e5:	0f b7 c0             	movzwl %ax,%eax
  2001e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  2001eb:	77 04                	ja     2001f1 <isqrt+0xa8>
  2001ed:	83 45 fc 02          	addl   $0x2,-0x4(%ebp)
    memoriza[x] = p - squares;
  2001f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2001f4:	ba 40 19 20 00       	mov    $0x201940,%edx
  2001f9:	29 d0                	sub    %edx,%eax
  2001fb:	d1 f8                	sar    %eax
  2001fd:	89 c2                	mov    %eax,%edx
  2001ff:	8b 45 08             	mov    0x8(%ebp),%eax
  200202:	89 14 85 c0 30 20 00 	mov    %edx,0x2030c0(,%eax,4)
    return p - squares;
  200209:	8b 45 fc             	mov    -0x4(%ebp),%eax
  20020c:	ba 40 19 20 00       	mov    $0x201940,%edx
  200211:	29 d0                	sub    %edx,%eax
  200213:	d1 f8                	sar    %eax
}
  200215:	c9                   	leave  
  200216:	c3                   	ret    

00200217 <clearStage>:


static inline void clearStage(){
  200217:	55                   	push   %ebp
  200218:	89 e5                	mov    %esp,%ebp
	hash = 0;
  20021a:	c7 05 80 30 20 00 00 	movl   $0x0,0x203080
  200221:	00 00 00 
	sys_init_vcache();
  200224:	e8 aa fe ff ff       	call   2000d3 <sys_init_vcache>
}
  200229:	5d                   	pop    %ebp
  20022a:	c3                   	ret    

0020022b <drawPoint>:
static inline void drawPoint(int x, int y, uint8_t color){
  20022b:	55                   	push   %ebp
  20022c:	89 e5                	mov    %esp,%ebp
  20022e:	83 ec 04             	sub    $0x4,%esp
  200231:	8b 45 10             	mov    0x10(%ebp),%eax
  200234:	88 45 fc             	mov    %al,-0x4(%ebp)
	sys_set_pixel(y, x, color);
  200237:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  20023b:	50                   	push   %eax
  20023c:	ff 75 08             	pushl  0x8(%ebp)
  20023f:	ff 75 0c             	pushl  0xc(%ebp)
  200242:	e8 a4 fe ff ff       	call   2000eb <sys_set_pixel>
  200247:	83 c4 0c             	add    $0xc,%esp
}
  20024a:	c9                   	leave  
  20024b:	c3                   	ret    

0020024c <drawRect>:
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
  20024c:	55                   	push   %ebp
  20024d:	89 e5                	mov    %esp,%ebp
  20024f:	53                   	push   %ebx
  200250:	83 ec 14             	sub    $0x14,%esp
  200253:	8b 45 18             	mov    0x18(%ebp),%eax
  200256:	88 45 e8             	mov    %al,-0x18(%ebp)
	hash += 29*x+57*y+13*color;
  200259:	8b 45 08             	mov    0x8(%ebp),%eax
  20025c:	6b d0 1d             	imul   $0x1d,%eax,%edx
  20025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  200262:	6b c0 39             	imul   $0x39,%eax,%eax
  200265:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200268:	0f b6 55 e8          	movzbl -0x18(%ebp),%edx
  20026c:	89 d0                	mov    %edx,%eax
  20026e:	01 c0                	add    %eax,%eax
  200270:	01 d0                	add    %edx,%eax
  200272:	c1 e0 02             	shl    $0x2,%eax
  200275:	01 d0                	add    %edx,%eax
  200277:	01 c8                	add    %ecx,%eax
  200279:	89 c2                	mov    %eax,%edx
  20027b:	a1 80 30 20 00       	mov    0x203080,%eax
  200280:	01 d0                	add    %edx,%eax
  200282:	a3 80 30 20 00       	mov    %eax,0x203080
	int i=0, j=0;
  200287:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  20028e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(i=0;i<w;i++){
  200295:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  20029c:	eb 38                	jmp    2002d6 <drawRect+0x8a>
		for(j=0;j<h;j++){
  20029e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  2002a5:	eb 23                	jmp    2002ca <drawRect+0x7e>
			drawPoint(x+i, y+j, color);
  2002a7:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  2002ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  2002ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  2002b1:	01 d1                	add    %edx,%ecx
  2002b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  2002b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  2002b9:	01 da                	add    %ebx,%edx
  2002bb:	50                   	push   %eax
  2002bc:	51                   	push   %ecx
  2002bd:	52                   	push   %edx
  2002be:	e8 68 ff ff ff       	call   20022b <drawPoint>
  2002c3:	83 c4 0c             	add    $0xc,%esp
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
		for(j=0;j<h;j++){
  2002c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  2002ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2002cd:	3b 45 14             	cmp    0x14(%ebp),%eax
  2002d0:	7c d5                	jl     2002a7 <drawRect+0x5b>
	sys_set_pixel(y, x, color);
}
static inline void drawRect(int x, int y, int w, int h, uint8_t color){
	hash += 29*x+57*y+13*color;
	int i=0, j=0;
	for(i=0;i<w;i++){
  2002d2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  2002d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2002d9:	3b 45 10             	cmp    0x10(%ebp),%eax
  2002dc:	7c c0                	jl     20029e <drawRect+0x52>
		for(j=0;j<h;j++){
			drawPoint(x+i, y+j, color);
		}
	}
}
  2002de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2002e1:	c9                   	leave  
  2002e2:	c3                   	ret    

002002e3 <drawCirc>:


static inline void drawCirc(int x, int y, int r, uint8_t color){
  2002e3:	55                   	push   %ebp
  2002e4:	89 e5                	mov    %esp,%ebp
  2002e6:	53                   	push   %ebx
  2002e7:	83 ec 14             	sub    $0x14,%esp
  2002ea:	8b 45 14             	mov    0x14(%ebp),%eax
  2002ed:	88 45 e8             	mov    %al,-0x18(%ebp)
	int i, j;
	hash += 329*x+157*y+713*r;
  2002f0:	8b 45 08             	mov    0x8(%ebp),%eax
  2002f3:	69 d0 49 01 00 00    	imul   $0x149,%eax,%edx
  2002f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  2002fc:	69 c0 9d 00 00 00    	imul   $0x9d,%eax,%eax
  200302:	01 c2                	add    %eax,%edx
  200304:	8b 45 10             	mov    0x10(%ebp),%eax
  200307:	69 c0 c9 02 00 00    	imul   $0x2c9,%eax,%eax
  20030d:	01 d0                	add    %edx,%eax
  20030f:	89 c2                	mov    %eax,%edx
  200311:	a1 80 30 20 00       	mov    0x203080,%eax
  200316:	01 d0                	add    %edx,%eax
  200318:	a3 80 30 20 00       	mov    %eax,0x203080
	for(i=-r; i<=r; i++){
  20031d:	8b 45 10             	mov    0x10(%ebp),%eax
  200320:	f7 d8                	neg    %eax
  200322:	89 45 f8             	mov    %eax,-0x8(%ebp)
  200325:	eb 5c                	jmp    200383 <drawCirc+0xa0>
		int delta = isqrt(r*r-i*i)+1;
  200327:	8b 45 10             	mov    0x10(%ebp),%eax
  20032a:	0f af 45 10          	imul   0x10(%ebp),%eax
  20032e:	89 c2                	mov    %eax,%edx
  200330:	8b 45 f8             	mov    -0x8(%ebp),%eax
  200333:	0f af 45 f8          	imul   -0x8(%ebp),%eax
  200337:	29 c2                	sub    %eax,%edx
  200339:	89 d0                	mov    %edx,%eax
  20033b:	50                   	push   %eax
  20033c:	e8 08 fe ff ff       	call   200149 <isqrt>
  200341:	83 c4 04             	add    $0x4,%esp
  200344:	83 c0 01             	add    $0x1,%eax
  200347:	89 45 f0             	mov    %eax,-0x10(%ebp)
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
  20034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  20034d:	f7 d8                	neg    %eax
  20034f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  200352:	eb 23                	jmp    200377 <drawCirc+0x94>
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
  200354:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  200358:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  20035b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  20035e:	01 d1                	add    %edx,%ecx
  200360:	8b 5d 08             	mov    0x8(%ebp),%ebx
  200363:	8b 55 f8             	mov    -0x8(%ebp),%edx
  200366:	01 da                	add    %ebx,%edx
  200368:	50                   	push   %eax
  200369:	51                   	push   %ecx
  20036a:	52                   	push   %edx
  20036b:	e8 bb fe ff ff       	call   20022b <drawPoint>
  200370:	83 c4 0c             	add    $0xc,%esp
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
		int delta = isqrt(r*r-i*i)+1;
		//printk("%d\n", delta);
		for(j=-delta; j<=delta; j++){
  200373:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  200377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20037a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  20037d:	7e d5                	jle    200354 <drawCirc+0x71>


static inline void drawCirc(int x, int y, int r, uint8_t color){
	int i, j;
	hash += 329*x+157*y+713*r;
	for(i=-r; i<=r; i++){
  20037f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  200383:	8b 45 f8             	mov    -0x8(%ebp),%eax
  200386:	3b 45 10             	cmp    0x10(%ebp),%eax
  200389:	7e 9c                	jle    200327 <drawCirc+0x44>
		for(j=-delta; j<=delta; j++){
			//printk("(%d, %d)", x+i, y+j);
			drawPoint(x+i, y+j, color);
		}
	}
}
  20038b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  20038e:	c9                   	leave  
  20038f:	c3                   	ret    

00200390 <drawText1>:

static inline void drawText1(){
  200390:	55                   	push   %ebp
  200391:	89 e5                	mov    %esp,%ebp
  200393:	83 ec 10             	sub    $0x10,%esp
    int i=0, j=0;
  200396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  20039d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    for(j=0;j<20;j++){
  2003a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  2003ab:	eb 53                	jmp    200400 <drawText1+0x70>
        for(i=0;i<52;i++){
  2003ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  2003b4:	eb 40                	jmp    2003f6 <drawText1+0x66>
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
  2003b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2003b9:	6b d0 34             	imul   $0x34,%eax,%edx
  2003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2003bf:	01 d0                	add    %edx,%eax
  2003c1:	0f b6 80 40 1b 20 00 	movzbl 0x201b40(%eax),%eax
  2003c8:	84 c0                	test   %al,%al
  2003ca:	74 26                	je     2003f2 <drawText1+0x62>
  2003cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
  2003cf:	89 d0                	mov    %edx,%eax
  2003d1:	c1 e0 02             	shl    $0x2,%eax
  2003d4:	01 d0                	add    %edx,%eax
  2003d6:	8d 50 14             	lea    0x14(%eax),%edx
  2003d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2003dc:	c1 e0 02             	shl    $0x2,%eax
  2003df:	83 c0 32             	add    $0x32,%eax
  2003e2:	6a 0e                	push   $0xe
  2003e4:	6a 05                	push   $0x5
  2003e6:	6a 04                	push   $0x4
  2003e8:	52                   	push   %edx
  2003e9:	50                   	push   %eax
  2003ea:	e8 5d fe ff ff       	call   20024c <drawRect>
  2003ef:	83 c4 14             	add    $0x14,%esp
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
        for(i=0;i<52;i++){
  2003f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  2003f6:	83 7d fc 33          	cmpl   $0x33,-0x4(%ebp)
  2003fa:	7e ba                	jle    2003b6 <drawText1+0x26>
	}
}

static inline void drawText1(){
    int i=0, j=0;
    for(j=0;j<20;j++){
  2003fc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  200400:	83 7d f8 13          	cmpl   $0x13,-0x8(%ebp)
  200404:	7e a7                	jle    2003ad <drawText1+0x1d>
        for(i=0;i<52;i++){
            if(text1[j*52+i])drawRect(50+i*4, 20+j*5, 4, 5, 14);
        }
    }
}
  200406:	c9                   	leave  
  200407:	c3                   	ret    

00200408 <drawNumber>:

static inline void drawNumber(int num, int x, int y, int size, uint8_t color){
  200408:	55                   	push   %ebp
  200409:	89 e5                	mov    %esp,%ebp
  20040b:	53                   	push   %ebx
  20040c:	83 ec 24             	sub    $0x24,%esp
  20040f:	8b 45 18             	mov    0x18(%ebp),%eax
  200412:	88 45 d8             	mov    %al,-0x28(%ebp)
    char temp[11];
    int di=0;
  200415:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    if(num == 0){
  20041c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  200420:	75 0d                	jne    20042f <drawNumber+0x27>
        temp[0] = '0';
  200422:	c6 45 dd 30          	movb   $0x30,-0x23(%ebp)
        di = 0;
  200426:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  20042d:	eb 5f                	jmp    20048e <drawNumber+0x86>

    }else{    
        while(num>=1){
  20042f:	eb 53                	jmp    200484 <drawNumber+0x7c>
            temp[di] = '0'+(num%10);
  200431:	8b 4d 08             	mov    0x8(%ebp),%ecx
  200434:	ba 67 66 66 66       	mov    $0x66666667,%edx
  200439:	89 c8                	mov    %ecx,%eax
  20043b:	f7 ea                	imul   %edx
  20043d:	c1 fa 02             	sar    $0x2,%edx
  200440:	89 c8                	mov    %ecx,%eax
  200442:	c1 f8 1f             	sar    $0x1f,%eax
  200445:	29 c2                	sub    %eax,%edx
  200447:	89 d0                	mov    %edx,%eax
  200449:	c1 e0 02             	shl    $0x2,%eax
  20044c:	01 d0                	add    %edx,%eax
  20044e:	01 c0                	add    %eax,%eax
  200450:	29 c1                	sub    %eax,%ecx
  200452:	89 ca                	mov    %ecx,%edx
  200454:	89 d0                	mov    %edx,%eax
  200456:	83 c0 30             	add    $0x30,%eax
  200459:	89 c1                	mov    %eax,%ecx
  20045b:	8d 55 dd             	lea    -0x23(%ebp),%edx
  20045e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  200461:	01 d0                	add    %edx,%eax
  200463:	88 08                	mov    %cl,(%eax)
            num/=10;
  200465:	8b 4d 08             	mov    0x8(%ebp),%ecx
  200468:	ba 67 66 66 66       	mov    $0x66666667,%edx
  20046d:	89 c8                	mov    %ecx,%eax
  20046f:	f7 ea                	imul   %edx
  200471:	c1 fa 02             	sar    $0x2,%edx
  200474:	89 c8                	mov    %ecx,%eax
  200476:	c1 f8 1f             	sar    $0x1f,%eax
  200479:	29 c2                	sub    %eax,%edx
  20047b:	89 d0                	mov    %edx,%eax
  20047d:	89 45 08             	mov    %eax,0x8(%ebp)
            di++;
  200480:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    if(num == 0){
        temp[0] = '0';
        di = 0;

    }else{    
        while(num>=1){
  200484:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  200488:	7f a7                	jg     200431 <drawNumber+0x29>
            temp[di] = '0'+(num%10);
            num/=10;
            di++;
        };
        di--;
  20048a:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
    }
    int i=0, xx=0, yy=0;
  20048e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  200495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  20049c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(;di>=0;di--){
  2004a3:	e9 aa 00 00 00       	jmp    200552 <drawNumber+0x14a>
        for(yy=0; yy<7; yy++){
  2004a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  2004af:	e9 8c 00 00 00       	jmp    200540 <drawNumber+0x138>
            for(xx=0; xx<5; xx++){
  2004b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  2004bb:	eb 79                	jmp    200536 <drawNumber+0x12e>
                const char* num = nums[temp[di]-'0'];
  2004bd:	8d 55 dd             	lea    -0x23(%ebp),%edx
  2004c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  2004c3:	01 d0                	add    %edx,%eax
  2004c5:	0f b6 00             	movzbl (%eax),%eax
  2004c8:	0f be c0             	movsbl %al,%eax
  2004cb:	83 e8 30             	sub    $0x30,%eax
  2004ce:	8b 04 85 20 30 20 00 	mov    0x203020(,%eax,4),%eax
  2004d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
  2004d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  2004db:	89 d0                	mov    %edx,%eax
  2004dd:	c1 e0 02             	shl    $0x2,%eax
  2004e0:	01 c2                	add    %eax,%edx
  2004e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2004e5:	01 d0                	add    %edx,%eax
  2004e7:	89 c2                	mov    %eax,%edx
  2004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2004ec:	01 d0                	add    %edx,%eax
  2004ee:	0f b6 00             	movzbl (%eax),%eax
  2004f1:	84 c0                	test   %al,%al
  2004f3:	74 3d                	je     200532 <drawNumber+0x12a>
  2004f5:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  2004f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  2004fc:	89 d1                	mov    %edx,%ecx
  2004fe:	0f af 4d 14          	imul   0x14(%ebp),%ecx
  200502:	8b 55 10             	mov    0x10(%ebp),%edx
  200505:	01 d1                	add    %edx,%ecx
  200507:	8b 55 14             	mov    0x14(%ebp),%edx
  20050a:	83 c2 0a             	add    $0xa,%edx
  20050d:	89 d3                	mov    %edx,%ebx
  20050f:	0f af 5d f4          	imul   -0xc(%ebp),%ebx
  200513:	8b 55 0c             	mov    0xc(%ebp),%edx
  200516:	01 d3                	add    %edx,%ebx
  200518:	8b 55 f0             	mov    -0x10(%ebp),%edx
  20051b:	0f af 55 14          	imul   0x14(%ebp),%edx
  20051f:	01 da                	add    %ebx,%edx
  200521:	50                   	push   %eax
  200522:	ff 75 14             	pushl  0x14(%ebp)
  200525:	ff 75 14             	pushl  0x14(%ebp)
  200528:	51                   	push   %ecx
  200529:	52                   	push   %edx
  20052a:	e8 1d fd ff ff       	call   20024c <drawRect>
  20052f:	83 c4 14             	add    $0x14,%esp
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
            for(xx=0; xx<5; xx++){
  200532:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  200536:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  20053a:	7e 81                	jle    2004bd <drawNumber+0xb5>
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
        for(yy=0; yy<7; yy++){
  20053c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  200540:	83 7d ec 06          	cmpl   $0x6,-0x14(%ebp)
  200544:	0f 8e 6a ff ff ff    	jle    2004b4 <drawNumber+0xac>
            for(xx=0; xx<5; xx++){
                const char* num = nums[temp[di]-'0'];
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
  20054a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            di++;
        };
        di--;
    }
    int i=0, xx=0, yy=0;
    for(;di>=0;di--){
  20054e:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
  200552:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  200556:	0f 89 4c ff ff ff    	jns    2004a8 <drawNumber+0xa0>
                if(num[yy*5+xx])drawRect(i*(size+10)+x+xx*size, y+yy*size, size, size, color);
            }
        }
        i++;
    }
}
  20055c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  20055f:	c9                   	leave  
  200560:	c3                   	ret    

00200561 <drawStage>:

static inline void drawStage(){
  200561:	55                   	push   %ebp
  200562:	89 e5                	mov    %esp,%ebp
	if(lhash == hash)return;
  200564:	8b 15 84 30 20 00    	mov    0x203084,%edx
  20056a:	a1 80 30 20 00       	mov    0x203080,%eax
  20056f:	39 c2                	cmp    %eax,%edx
  200571:	75 02                	jne    200575 <drawStage+0x14>
  200573:	eb 0f                	jmp    200584 <drawStage+0x23>
	//clear_vram();
	sys_flush_vcache();
  200575:	e8 65 fb ff ff       	call   2000df <sys_flush_vcache>
	lhash = hash;
  20057a:	a1 80 30 20 00       	mov    0x203080,%eax
  20057f:	a3 84 30 20 00       	mov    %eax,0x203084
}
  200584:	5d                   	pop    %ebp
  200585:	c3                   	ret    

00200586 <key>:
static int curtime = 0;

static int score;
void dreamOf100HZ(int);

static inline int8_t key(char s){
  200586:	55                   	push   %ebp
  200587:	89 e5                	mov    %esp,%ebp
  200589:	83 ec 04             	sub    $0x4,%esp
  20058c:	8b 45 08             	mov    0x8(%ebp),%eax
  20058f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return sys_key_down(s);
  200592:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  200596:	50                   	push   %eax
  200597:	e8 66 fb ff ff       	call   200102 <sys_key_down>
  20059c:	83 c4 04             	add    $0x4,%esp
}
  20059f:	c9                   	leave  
  2005a0:	c3                   	ret    

002005a1 <main>:



int main(){
  2005a1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  2005a5:	83 e4 f0             	and    $0xfffffff0,%esp
  2005a8:	ff 71 fc             	pushl  -0x4(%ecx)
  2005ab:	55                   	push   %ebp
  2005ac:	89 e5                	mov    %esp,%ebp
  2005ae:	51                   	push   %ecx
  2005af:	83 ec 04             	sub    $0x4,%esp
	//initVCache();
	//printk("5\n");
	//clear_key();
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
  2005b2:	e8 76 fb ff ff       	call   20012d <sys_get_tick>
  2005b7:	a3 48 30 20 00       	mov    %eax,0x203048
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
  2005bc:	eb 1e                	jmp    2005dc <main+0x3b>
			
			#ifdef QUICK
			dreamOf100HZ(timestamp);
  2005be:	a1 48 30 20 00       	mov    0x203048,%eax
  2005c3:	83 ec 0c             	sub    $0xc,%esp
  2005c6:	50                   	push   %eax
  2005c7:	e8 8c 07 00 00       	call   200d58 <dreamOf100HZ>
  2005cc:	83 c4 10             	add    $0x10,%esp
			#else
			if(timestamp%4==0)
				dreamOf100HZ(timestamp>>2);
			#endif
			curtime++;
  2005cf:	a1 20 3a 20 00       	mov    0x203a20,%eax
  2005d4:	83 c0 01             	add    $0x1,%eax
  2005d7:	a3 20 3a 20 00       	mov    %eax,0x203a20
	//printk("6\n");
	while(1){
		timestamp = sys_get_tick();
		//wait_for_interrupt();
		//disable_interrupt();
		while(curtime<timestamp){
  2005dc:	8b 15 20 3a 20 00    	mov    0x203a20,%edx
  2005e2:	a1 48 30 20 00       	mov    0x203048,%eax
  2005e7:	39 c2                	cmp    %eax,%edx
  2005e9:	7c d3                	jl     2005be <main+0x1d>
		}
		

		//enable_interrupt();
		
	}
  2005eb:	eb c5                	jmp    2005b2 <main+0x11>

002005ed <hitMonster>:
domain int x, y, size, score = 0;

domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
  2005ed:	55                   	push   %ebp
  2005ee:	89 e5                	mov    %esp,%ebp
  2005f0:	83 ec 10             	sub    $0x10,%esp
	int i=0;
  2005f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	REP_MONSTER(){
  2005fa:	e9 9c 01 00 00       	jmp    20079b <hitMonster+0x1ae>
		int dx = x-mon.x; 
  2005ff:	8b 15 2c 3a 20 00    	mov    0x203a2c,%edx
  200605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  200608:	c1 e0 02             	shl    $0x2,%eax
  20060b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  200612:	29 c1                	sub    %eax,%ecx
  200614:	89 c8                	mov    %ecx,%eax
  200616:	05 40 3a 20 00       	add    $0x203a40,%eax
  20061b:	8b 40 04             	mov    0x4(%eax),%eax
  20061e:	29 c2                	sub    %eax,%edx
  200620:	89 d0                	mov    %edx,%eax
  200622:	89 45 f8             	mov    %eax,-0x8(%ebp)
		int dy = y-mon.y;
  200625:	8b 15 30 3a 20 00    	mov    0x203a30,%edx
  20062b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  20062e:	c1 e0 02             	shl    $0x2,%eax
  200631:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  200638:	29 c1                	sub    %eax,%ecx
  20063a:	89 c8                	mov    %ecx,%eax
  20063c:	05 40 3a 20 00       	add    $0x203a40,%eax
  200641:	8b 40 08             	mov    0x8(%eax),%eax
  200644:	29 c2                	sub    %eax,%edx
  200646:	89 d0                	mov    %edx,%eax
  200648:	89 45 f4             	mov    %eax,-0xc(%ebp)
		//printk("%d %d", dx, dy);
		if(mon.status == MONSTER_ALIVE && dx <= mon.size && dy <= mon.size && dx >= -mon.size && dy >= -mon.size){
  20064b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  20064e:	89 c2                	mov    %eax,%edx
  200650:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200657:	89 c2                	mov    %eax,%edx
  200659:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200660:	29 d0                	sub    %edx,%eax
  200662:	83 c0 10             	add    $0x10,%eax
  200665:	05 40 3a 20 00       	add    $0x203a40,%eax
  20066a:	8b 40 04             	mov    0x4(%eax),%eax
  20066d:	85 c0                	test   %eax,%eax
  20066f:	0f 85 22 01 00 00    	jne    200797 <hitMonster+0x1aa>
  200675:	8b 45 fc             	mov    -0x4(%ebp),%eax
  200678:	c1 e0 02             	shl    $0x2,%eax
  20067b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200682:	29 c2                	sub    %eax,%edx
  200684:	89 d0                	mov    %edx,%eax
  200686:	05 40 3a 20 00       	add    $0x203a40,%eax
  20068b:	8b 00                	mov    (%eax),%eax
  20068d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  200690:	0f 8c 01 01 00 00    	jl     200797 <hitMonster+0x1aa>
  200696:	8b 45 fc             	mov    -0x4(%ebp),%eax
  200699:	c1 e0 02             	shl    $0x2,%eax
  20069c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2006a3:	29 c2                	sub    %eax,%edx
  2006a5:	89 d0                	mov    %edx,%eax
  2006a7:	05 40 3a 20 00       	add    $0x203a40,%eax
  2006ac:	8b 00                	mov    (%eax),%eax
  2006ae:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  2006b1:	0f 8c e0 00 00 00    	jl     200797 <hitMonster+0x1aa>
  2006b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2006ba:	c1 e0 02             	shl    $0x2,%eax
  2006bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2006c4:	29 c2                	sub    %eax,%edx
  2006c6:	89 d0                	mov    %edx,%eax
  2006c8:	05 40 3a 20 00       	add    $0x203a40,%eax
  2006cd:	8b 00                	mov    (%eax),%eax
  2006cf:	f7 d8                	neg    %eax
  2006d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  2006d4:	0f 8f bd 00 00 00    	jg     200797 <hitMonster+0x1aa>
  2006da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2006dd:	c1 e0 02             	shl    $0x2,%eax
  2006e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2006e7:	29 c2                	sub    %eax,%edx
  2006e9:	89 d0                	mov    %edx,%eax
  2006eb:	05 40 3a 20 00       	add    $0x203a40,%eax
  2006f0:	8b 00                	mov    (%eax),%eax
  2006f2:	f7 d8                	neg    %eax
  2006f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  2006f7:	0f 8f 9a 00 00 00    	jg     200797 <hitMonster+0x1aa>
			if(mon.size <= size){
  2006fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  200700:	c1 e0 02             	shl    $0x2,%eax
  200703:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  20070a:	29 c2                	sub    %eax,%edx
  20070c:	89 d0                	mov    %edx,%eax
  20070e:	05 40 3a 20 00       	add    $0x203a40,%eax
  200713:	8b 10                	mov    (%eax),%edx
  200715:	a1 34 3a 20 00       	mov    0x203a34,%eax
  20071a:	39 c2                	cmp    %eax,%edx
  20071c:	7f 68                	jg     200786 <hitMonster+0x199>
				mon.status = MONSTER_DEAD;
  20071e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  200721:	89 c2                	mov    %eax,%edx
  200723:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  20072a:	89 c2                	mov    %eax,%edx
  20072c:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200733:	29 d0                	sub    %edx,%eax
  200735:	83 c0 10             	add    $0x10,%eax
  200738:	05 40 3a 20 00       	add    $0x203a40,%eax
  20073d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
				if(size<13)size++;
  200744:	a1 34 3a 20 00       	mov    0x203a34,%eax
  200749:	83 f8 0c             	cmp    $0xc,%eax
  20074c:	7f 0d                	jg     20075b <hitMonster+0x16e>
  20074e:	a1 34 3a 20 00       	mov    0x203a34,%eax
  200753:	83 c0 01             	add    $0x1,%eax
  200756:	a3 34 3a 20 00       	mov    %eax,0x203a34
				score += mon.size;
  20075b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  20075e:	c1 e0 02             	shl    $0x2,%eax
  200761:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200768:	29 c2                	sub    %eax,%edx
  20076a:	89 d0                	mov    %edx,%eax
  20076c:	05 40 3a 20 00       	add    $0x203a40,%eax
  200771:	8b 10                	mov    (%eax),%edx
  200773:	a1 24 3a 20 00       	mov    0x203a24,%eax
  200778:	01 d0                	add    %edx,%eax
  20077a:	a3 24 3a 20 00       	mov    %eax,0x203a24
			}else{
				gameStatus = GAME_END;
				return 0;
			}
			return 1;
  20077f:	b8 01 00 00 00       	mov    $0x1,%eax
  200784:	eb 24                	jmp    2007aa <hitMonster+0x1bd>
			if(mon.size <= size){
				mon.status = MONSTER_DEAD;
				if(size<13)size++;
				score += mon.size;
			}else{
				gameStatus = GAME_END;
  200786:	c7 05 28 3a 20 00 03 	movl   $0x3,0x203a28
  20078d:	00 00 00 
				return 0;
  200790:	b8 00 00 00 00       	mov    $0x0,%eax
  200795:	eb 13                	jmp    2007aa <hitMonster+0x1bd>
domain MONSTER monsters[MONSTER_SIZE+20];


int hitMonster(){
	int i=0;
	REP_MONSTER(){
  200797:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  20079b:	83 7d fc 13          	cmpl   $0x13,-0x4(%ebp)
  20079f:	0f 8e 5a fe ff ff    	jle    2005ff <hitMonster+0x12>
				return 0;
			}
			return 1;
		}
	}
	return 0;
  2007a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  2007aa:	c9                   	leave  
  2007ab:	c3                   	ret    

002007ac <drawMonster>:

void drawMonster(){
  2007ac:	55                   	push   %ebp
  2007ad:	89 e5                	mov    %esp,%ebp
  2007af:	56                   	push   %esi
  2007b0:	53                   	push   %ebx
  2007b1:	83 ec 10             	sub    $0x10,%esp
	int i=0;
  2007b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
  2007bb:	e9 89 03 00 00       	jmp    200b49 <drawMonster+0x39d>
		if(mon.status == MONSTER_ALIVE){
  2007c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2007c3:	89 c2                	mov    %eax,%edx
  2007c5:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  2007cc:	89 c2                	mov    %eax,%edx
  2007ce:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  2007d5:	29 d0                	sub    %edx,%eax
  2007d7:	83 c0 10             	add    $0x10,%eax
  2007da:	05 40 3a 20 00       	add    $0x203a40,%eax
  2007df:	8b 40 04             	mov    0x4(%eax),%eax
  2007e2:	85 c0                	test   %eax,%eax
  2007e4:	0f 85 5b 03 00 00    	jne    200b45 <drawMonster+0x399>
			mon.x += mon.sx;
  2007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2007ed:	c1 e0 02             	shl    $0x2,%eax
  2007f0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2007f7:	29 c2                	sub    %eax,%edx
  2007f9:	89 d0                	mov    %edx,%eax
  2007fb:	05 40 3a 20 00       	add    $0x203a40,%eax
  200800:	8b 50 04             	mov    0x4(%eax),%edx
  200803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200806:	c1 e0 02             	shl    $0x2,%eax
  200809:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  200810:	29 c1                	sub    %eax,%ecx
  200812:	89 c8                	mov    %ecx,%eax
  200814:	05 40 3a 20 00       	add    $0x203a40,%eax
  200819:	8b 40 0c             	mov    0xc(%eax),%eax
  20081c:	01 c2                	add    %eax,%edx
  20081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200821:	c1 e0 02             	shl    $0x2,%eax
  200824:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  20082b:	29 c1                	sub    %eax,%ecx
  20082d:	89 c8                	mov    %ecx,%eax
  20082f:	05 40 3a 20 00       	add    $0x203a40,%eax
  200834:	89 50 04             	mov    %edx,0x4(%eax)
			mon.y += mon.sy;
  200837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20083a:	c1 e0 02             	shl    $0x2,%eax
  20083d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200844:	29 c2                	sub    %eax,%edx
  200846:	89 d0                	mov    %edx,%eax
  200848:	05 40 3a 20 00       	add    $0x203a40,%eax
  20084d:	8b 48 08             	mov    0x8(%eax),%ecx
  200850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200853:	89 c2                	mov    %eax,%edx
  200855:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  20085c:	89 c2                	mov    %eax,%edx
  20085e:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200865:	29 d0                	sub    %edx,%eax
  200867:	83 c0 10             	add    $0x10,%eax
  20086a:	05 40 3a 20 00       	add    $0x203a40,%eax
  20086f:	8b 00                	mov    (%eax),%eax
  200871:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  200874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200877:	c1 e0 02             	shl    $0x2,%eax
  20087a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  200881:	29 c1                	sub    %eax,%ecx
  200883:	89 c8                	mov    %ecx,%eax
  200885:	05 40 3a 20 00       	add    $0x203a40,%eax
  20088a:	89 50 08             	mov    %edx,0x8(%eax)

			if(mon.x < 10) mon.x++;
  20088d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200890:	c1 e0 02             	shl    $0x2,%eax
  200893:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  20089a:	29 c2                	sub    %eax,%edx
  20089c:	89 d0                	mov    %edx,%eax
  20089e:	05 40 3a 20 00       	add    $0x203a40,%eax
  2008a3:	8b 40 04             	mov    0x4(%eax),%eax
  2008a6:	83 f8 09             	cmp    $0x9,%eax
  2008a9:	7f 35                	jg     2008e0 <drawMonster+0x134>
  2008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2008ae:	c1 e0 02             	shl    $0x2,%eax
  2008b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2008b8:	29 c2                	sub    %eax,%edx
  2008ba:	89 d0                	mov    %edx,%eax
  2008bc:	05 40 3a 20 00       	add    $0x203a40,%eax
  2008c1:	8b 40 04             	mov    0x4(%eax),%eax
  2008c4:	8d 50 01             	lea    0x1(%eax),%edx
  2008c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2008ca:	c1 e0 02             	shl    $0x2,%eax
  2008cd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  2008d4:	29 c1                	sub    %eax,%ecx
  2008d6:	89 c8                	mov    %ecx,%eax
  2008d8:	05 40 3a 20 00       	add    $0x203a40,%eax
  2008dd:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.x > VWIDTH-10) mon.x--;
  2008e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2008e3:	c1 e0 02             	shl    $0x2,%eax
  2008e6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2008ed:	29 c2                	sub    %eax,%edx
  2008ef:	89 d0                	mov    %edx,%eax
  2008f1:	05 40 3a 20 00       	add    $0x203a40,%eax
  2008f6:	8b 40 04             	mov    0x4(%eax),%eax
  2008f9:	3d 36 01 00 00       	cmp    $0x136,%eax
  2008fe:	7e 35                	jle    200935 <drawMonster+0x189>
  200900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200903:	c1 e0 02             	shl    $0x2,%eax
  200906:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  20090d:	29 c2                	sub    %eax,%edx
  20090f:	89 d0                	mov    %edx,%eax
  200911:	05 40 3a 20 00       	add    $0x203a40,%eax
  200916:	8b 40 04             	mov    0x4(%eax),%eax
  200919:	8d 50 ff             	lea    -0x1(%eax),%edx
  20091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20091f:	c1 e0 02             	shl    $0x2,%eax
  200922:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  200929:	29 c1                	sub    %eax,%ecx
  20092b:	89 c8                	mov    %ecx,%eax
  20092d:	05 40 3a 20 00       	add    $0x203a40,%eax
  200932:	89 50 04             	mov    %edx,0x4(%eax)
			if(mon.y < 10) mon.y++;
  200935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200938:	c1 e0 02             	shl    $0x2,%eax
  20093b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200942:	29 c2                	sub    %eax,%edx
  200944:	89 d0                	mov    %edx,%eax
  200946:	05 40 3a 20 00       	add    $0x203a40,%eax
  20094b:	8b 40 08             	mov    0x8(%eax),%eax
  20094e:	83 f8 09             	cmp    $0x9,%eax
  200951:	7f 35                	jg     200988 <drawMonster+0x1dc>
  200953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200956:	c1 e0 02             	shl    $0x2,%eax
  200959:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200960:	29 c2                	sub    %eax,%edx
  200962:	89 d0                	mov    %edx,%eax
  200964:	05 40 3a 20 00       	add    $0x203a40,%eax
  200969:	8b 40 08             	mov    0x8(%eax),%eax
  20096c:	8d 50 01             	lea    0x1(%eax),%edx
  20096f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200972:	c1 e0 02             	shl    $0x2,%eax
  200975:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  20097c:	29 c1                	sub    %eax,%ecx
  20097e:	89 c8                	mov    %ecx,%eax
  200980:	05 40 3a 20 00       	add    $0x203a40,%eax
  200985:	89 50 08             	mov    %edx,0x8(%eax)
			if(mon.y > VHEIGHT-10) mon.y--;
  200988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20098b:	c1 e0 02             	shl    $0x2,%eax
  20098e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200995:	29 c2                	sub    %eax,%edx
  200997:	89 d0                	mov    %edx,%eax
  200999:	05 40 3a 20 00       	add    $0x203a40,%eax
  20099e:	8b 40 08             	mov    0x8(%eax),%eax
  2009a1:	3d be 00 00 00       	cmp    $0xbe,%eax
  2009a6:	7e 35                	jle    2009dd <drawMonster+0x231>
  2009a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2009ab:	c1 e0 02             	shl    $0x2,%eax
  2009ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2009b5:	29 c2                	sub    %eax,%edx
  2009b7:	89 d0                	mov    %edx,%eax
  2009b9:	05 40 3a 20 00       	add    $0x203a40,%eax
  2009be:	8b 40 08             	mov    0x8(%eax),%eax
  2009c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  2009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2009c7:	c1 e0 02             	shl    $0x2,%eax
  2009ca:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  2009d1:	29 c1                	sub    %eax,%ecx
  2009d3:	89 c8                	mov    %ecx,%eax
  2009d5:	05 40 3a 20 00       	add    $0x203a40,%eax
  2009da:	89 50 08             	mov    %edx,0x8(%eax)
			int color = size>=mon.size?15:5;
  2009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2009e0:	c1 e0 02             	shl    $0x2,%eax
  2009e3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2009ea:	29 c2                	sub    %eax,%edx
  2009ec:	89 d0                	mov    %edx,%eax
  2009ee:	05 40 3a 20 00       	add    $0x203a40,%eax
  2009f3:	8b 10                	mov    (%eax),%edx
  2009f5:	a1 34 3a 20 00       	mov    0x203a34,%eax
  2009fa:	39 c2                	cmp    %eax,%edx
  2009fc:	7f 07                	jg     200a05 <drawMonster+0x259>
  2009fe:	b8 0f 00 00 00       	mov    $0xf,%eax
  200a03:	eb 05                	jmp    200a0a <drawMonster+0x25e>
  200a05:	b8 05 00 00 00       	mov    $0x5,%eax
  200a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			drawCirc(mon.x, mon.y, mon.size, color);
  200a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  200a10:	0f b6 d8             	movzbl %al,%ebx
  200a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200a16:	c1 e0 02             	shl    $0x2,%eax
  200a19:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200a20:	29 c2                	sub    %eax,%edx
  200a22:	89 d0                	mov    %edx,%eax
  200a24:	05 40 3a 20 00       	add    $0x203a40,%eax
  200a29:	8b 08                	mov    (%eax),%ecx
  200a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200a2e:	c1 e0 02             	shl    $0x2,%eax
  200a31:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200a38:	29 c2                	sub    %eax,%edx
  200a3a:	89 d0                	mov    %edx,%eax
  200a3c:	05 40 3a 20 00       	add    $0x203a40,%eax
  200a41:	8b 50 08             	mov    0x8(%eax),%edx
  200a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200a47:	c1 e0 02             	shl    $0x2,%eax
  200a4a:	8d 34 c5 00 00 00 00 	lea    0x0(,%eax,8),%esi
  200a51:	29 c6                	sub    %eax,%esi
  200a53:	89 f0                	mov    %esi,%eax
  200a55:	05 40 3a 20 00       	add    $0x203a40,%eax
  200a5a:	8b 40 04             	mov    0x4(%eax),%eax
  200a5d:	53                   	push   %ebx
  200a5e:	51                   	push   %ecx
  200a5f:	52                   	push   %edx
  200a60:	50                   	push   %eax
  200a61:	e8 7d f8 ff ff       	call   2002e3 <drawCirc>
  200a66:	83 c4 10             	add    $0x10,%esp
			if(KISS()%60==0){
  200a69:	e8 92 f5 ff ff       	call   200000 <UKISS>
  200a6e:	89 c2                	mov    %eax,%edx
  200a70:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200a75:	01 c2                	add    %eax,%edx
  200a77:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200a7c:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200a7f:	ba 89 88 88 88       	mov    $0x88888889,%edx
  200a84:	89 c8                	mov    %ecx,%eax
  200a86:	f7 e2                	mul    %edx
  200a88:	89 d0                	mov    %edx,%eax
  200a8a:	c1 e8 05             	shr    $0x5,%eax
  200a8d:	89 c2                	mov    %eax,%edx
  200a8f:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200a96:	89 c2                	mov    %eax,%edx
  200a98:	89 d0                	mov    %edx,%eax
  200a9a:	c1 e0 04             	shl    $0x4,%eax
  200a9d:	29 d0                	sub    %edx,%eax
  200a9f:	29 c1                	sub    %eax,%ecx
  200aa1:	89 c8                	mov    %ecx,%eax
  200aa3:	85 c0                	test   %eax,%eax
  200aa5:	0f 85 9a 00 00 00    	jne    200b45 <drawMonster+0x399>
				mon.sx = -1 + KISS()%3;
  200aab:	e8 50 f5 ff ff       	call   200000 <UKISS>
  200ab0:	89 c2                	mov    %eax,%edx
  200ab2:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200ab7:	01 c2                	add    %eax,%edx
  200ab9:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200abe:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200ac1:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  200ac6:	89 c8                	mov    %ecx,%eax
  200ac8:	f7 e2                	mul    %edx
  200aca:	d1 ea                	shr    %edx
  200acc:	89 d0                	mov    %edx,%eax
  200ace:	01 c0                	add    %eax,%eax
  200ad0:	01 d0                	add    %edx,%eax
  200ad2:	29 c1                	sub    %eax,%ecx
  200ad4:	89 ca                	mov    %ecx,%edx
  200ad6:	8d 42 ff             	lea    -0x1(%edx),%eax
  200ad9:	89 c1                	mov    %eax,%ecx
  200adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200ade:	c1 e0 02             	shl    $0x2,%eax
  200ae1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200ae8:	29 c2                	sub    %eax,%edx
  200aea:	89 d0                	mov    %edx,%eax
  200aec:	05 40 3a 20 00       	add    $0x203a40,%eax
  200af1:	89 48 0c             	mov    %ecx,0xc(%eax)
				mon.sy = -1 + KISS()%3;
  200af4:	e8 07 f5 ff ff       	call   200000 <UKISS>
  200af9:	89 c2                	mov    %eax,%edx
  200afb:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200b00:	01 c2                	add    %eax,%edx
  200b02:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200b07:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200b0a:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  200b0f:	89 c8                	mov    %ecx,%eax
  200b11:	f7 e2                	mul    %edx
  200b13:	d1 ea                	shr    %edx
  200b15:	89 d0                	mov    %edx,%eax
  200b17:	01 c0                	add    %eax,%eax
  200b19:	01 d0                	add    %edx,%eax
  200b1b:	29 c1                	sub    %eax,%ecx
  200b1d:	89 ca                	mov    %ecx,%edx
  200b1f:	8d 42 ff             	lea    -0x1(%edx),%eax
  200b22:	89 c1                	mov    %eax,%ecx
  200b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200b27:	89 c2                	mov    %eax,%edx
  200b29:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200b30:	89 c2                	mov    %eax,%edx
  200b32:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200b39:	29 d0                	sub    %edx,%eax
  200b3b:	83 c0 10             	add    $0x10,%eax
  200b3e:	05 40 3a 20 00       	add    $0x203a40,%eax
  200b43:	89 08                	mov    %ecx,(%eax)
	return 0;
}

void drawMonster(){
	int i=0;
	REP_MONSTER(){
  200b45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  200b49:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  200b4d:	0f 8e 6d fc ff ff    	jle    2007c0 <drawMonster+0x14>
				mon.sx = -1 + KISS()%3;
				mon.sy = -1 + KISS()%3;
			}
		}
	}
}
  200b53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  200b56:	5b                   	pop    %ebx
  200b57:	5e                   	pop    %esi
  200b58:	5d                   	pop    %ebp
  200b59:	c3                   	ret    

00200b5a <createMonster>:
void createMonster(){
  200b5a:	55                   	push   %ebp
  200b5b:	89 e5                	mov    %esp,%ebp
  200b5d:	83 ec 18             	sub    $0x18,%esp
	int i=0;
  200b60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	REP_MONSTER(){
  200b67:	e9 e0 01 00 00       	jmp    200d4c <createMonster+0x1f2>
		if(mon.status == MONSTER_ALIVE) continue;
  200b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200b6f:	89 c2                	mov    %eax,%edx
  200b71:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200b78:	89 c2                	mov    %eax,%edx
  200b7a:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200b81:	29 d0                	sub    %edx,%eax
  200b83:	83 c0 10             	add    $0x10,%eax
  200b86:	05 40 3a 20 00       	add    $0x203a40,%eax
  200b8b:	8b 40 04             	mov    0x4(%eax),%eax
  200b8e:	85 c0                	test   %eax,%eax
  200b90:	75 05                	jne    200b97 <createMonster+0x3d>
  200b92:	e9 b1 01 00 00       	jmp    200d48 <createMonster+0x1ee>
		if(KISS()%(250*MONSTER_SIZE) == 0){
  200b97:	e8 64 f4 ff ff       	call   200000 <UKISS>
  200b9c:	89 c2                	mov    %eax,%edx
  200b9e:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200ba3:	01 c2                	add    %eax,%edx
  200ba5:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200baa:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200bad:	ba 59 17 b7 d1       	mov    $0xd1b71759,%edx
  200bb2:	89 c8                	mov    %ecx,%eax
  200bb4:	f7 e2                	mul    %edx
  200bb6:	89 d0                	mov    %edx,%eax
  200bb8:	c1 e8 0c             	shr    $0xc,%eax
  200bbb:	69 c0 88 13 00 00    	imul   $0x1388,%eax,%eax
  200bc1:	29 c1                	sub    %eax,%ecx
  200bc3:	89 c8                	mov    %ecx,%eax
  200bc5:	85 c0                	test   %eax,%eax
  200bc7:	0f 85 7b 01 00 00    	jne    200d48 <createMonster+0x1ee>
			mon.status = MONSTER_ALIVE;
  200bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200bd0:	89 c2                	mov    %eax,%edx
  200bd2:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200bd9:	89 c2                	mov    %eax,%edx
  200bdb:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200be2:	29 d0                	sub    %edx,%eax
  200be4:	83 c0 10             	add    $0x10,%eax
  200be7:	05 40 3a 20 00       	add    $0x203a40,%eax
  200bec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			mon.size = 2 + 2*(KISS()%size);
  200bf3:	e8 08 f4 ff ff       	call   200000 <UKISS>
  200bf8:	89 c2                	mov    %eax,%edx
  200bfa:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200bff:	01 c2                	add    %eax,%edx
  200c01:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200c06:	01 d0                	add    %edx,%eax
  200c08:	8b 15 34 3a 20 00    	mov    0x203a34,%edx
  200c0e:	89 d1                	mov    %edx,%ecx
  200c10:	ba 00 00 00 00       	mov    $0x0,%edx
  200c15:	f7 f1                	div    %ecx
  200c17:	89 d0                	mov    %edx,%eax
  200c19:	83 c0 01             	add    $0x1,%eax
  200c1c:	01 c0                	add    %eax,%eax
  200c1e:	89 c1                	mov    %eax,%ecx
  200c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200c23:	c1 e0 02             	shl    $0x2,%eax
  200c26:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200c2d:	29 c2                	sub    %eax,%edx
  200c2f:	89 d0                	mov    %edx,%eax
  200c31:	05 40 3a 20 00       	add    $0x203a40,%eax
  200c36:	89 08                	mov    %ecx,(%eax)
			mon.size = mon.size >14?14:mon.size; 
  200c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200c3b:	c1 e0 02             	shl    $0x2,%eax
  200c3e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200c45:	29 c2                	sub    %eax,%edx
  200c47:	89 d0                	mov    %edx,%eax
  200c49:	05 40 3a 20 00       	add    $0x203a40,%eax
  200c4e:	8b 00                	mov    (%eax),%eax
  200c50:	89 c2                	mov    %eax,%edx
  200c52:	83 fa 0e             	cmp    $0xe,%edx
  200c55:	7e 05                	jle    200c5c <createMonster+0x102>
  200c57:	ba 0e 00 00 00       	mov    $0xe,%edx
  200c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200c5f:	c1 e0 02             	shl    $0x2,%eax
  200c62:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  200c69:	29 c1                	sub    %eax,%ecx
  200c6b:	89 c8                	mov    %ecx,%eax
  200c6d:	05 40 3a 20 00       	add    $0x203a40,%eax
  200c72:	89 10                	mov    %edx,(%eax)
			mon.x = VWIDTH/2;
  200c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200c77:	c1 e0 02             	shl    $0x2,%eax
  200c7a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200c81:	29 c2                	sub    %eax,%edx
  200c83:	89 d0                	mov    %edx,%eax
  200c85:	05 40 3a 20 00       	add    $0x203a40,%eax
  200c8a:	c7 40 04 a0 00 00 00 	movl   $0xa0,0x4(%eax)
			mon.y = VHEIGHT/2;
  200c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200c94:	c1 e0 02             	shl    $0x2,%eax
  200c97:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200c9e:	29 c2                	sub    %eax,%edx
  200ca0:	89 d0                	mov    %edx,%eax
  200ca2:	05 40 3a 20 00       	add    $0x203a40,%eax
  200ca7:	c7 40 08 64 00 00 00 	movl   $0x64,0x8(%eax)
			mon.sx = -1 + KISS()%3;
  200cae:	e8 4d f3 ff ff       	call   200000 <UKISS>
  200cb3:	89 c2                	mov    %eax,%edx
  200cb5:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200cba:	01 c2                	add    %eax,%edx
  200cbc:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200cc1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200cc4:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  200cc9:	89 c8                	mov    %ecx,%eax
  200ccb:	f7 e2                	mul    %edx
  200ccd:	d1 ea                	shr    %edx
  200ccf:	89 d0                	mov    %edx,%eax
  200cd1:	01 c0                	add    %eax,%eax
  200cd3:	01 d0                	add    %edx,%eax
  200cd5:	29 c1                	sub    %eax,%ecx
  200cd7:	89 ca                	mov    %ecx,%edx
  200cd9:	8d 42 ff             	lea    -0x1(%edx),%eax
  200cdc:	89 c1                	mov    %eax,%ecx
  200cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200ce1:	c1 e0 02             	shl    $0x2,%eax
  200ce4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200ceb:	29 c2                	sub    %eax,%edx
  200ced:	89 d0                	mov    %edx,%eax
  200cef:	05 40 3a 20 00       	add    $0x203a40,%eax
  200cf4:	89 48 0c             	mov    %ecx,0xc(%eax)
			mon.sy = -1 + KISS()%3;
  200cf7:	e8 04 f3 ff ff       	call   200000 <UKISS>
  200cfc:	89 c2                	mov    %eax,%edx
  200cfe:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200d03:	01 c2                	add    %eax,%edx
  200d05:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200d0a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200d0d:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  200d12:	89 c8                	mov    %ecx,%eax
  200d14:	f7 e2                	mul    %edx
  200d16:	d1 ea                	shr    %edx
  200d18:	89 d0                	mov    %edx,%eax
  200d1a:	01 c0                	add    %eax,%eax
  200d1c:	01 d0                	add    %edx,%eax
  200d1e:	29 c1                	sub    %eax,%ecx
  200d20:	89 ca                	mov    %ecx,%edx
  200d22:	8d 42 ff             	lea    -0x1(%edx),%eax
  200d25:	89 c1                	mov    %eax,%ecx
  200d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200d2a:	89 c2                	mov    %eax,%edx
  200d2c:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200d33:	89 c2                	mov    %eax,%edx
  200d35:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200d3c:	29 d0                	sub    %edx,%eax
  200d3e:	83 c0 10             	add    $0x10,%eax
  200d41:	05 40 3a 20 00       	add    $0x203a40,%eax
  200d46:	89 08                	mov    %ecx,(%eax)
		}
	}
}
void createMonster(){
	int i=0;
	REP_MONSTER(){
  200d48:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  200d4c:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  200d50:	0f 8e 16 fe ff ff    	jle    200b6c <createMonster+0x12>
			mon.y = VHEIGHT/2;
			mon.sx = -1 + KISS()%3;
			mon.sy = -1 + KISS()%3;
		}
	}
}
  200d56:	c9                   	leave  
  200d57:	c3                   	ret    

00200d58 <dreamOf100HZ>:
void dreamOf100HZ(int timestamp){
  200d58:	55                   	push   %ebp
  200d59:	89 e5                	mov    %esp,%ebp
  200d5b:	83 ec 18             	sub    $0x18,%esp
		//drawRect(60+x, 60+y, 40, 40, 3);
		drawCirc(60+x, 60+y, 15, 3);
		drawCirc(70+x, 60+y, 15, 6);
		drawStage();
	}*/
	if(gameStatus == GAME_START){
  200d5e:	a1 28 3a 20 00       	mov    0x203a28,%eax
  200d63:	85 c0                	test   %eax,%eax
  200d65:	0f 85 2b 04 00 00    	jne    201196 <dreamOf100HZ+0x43e>
		clearStage();
  200d6b:	e8 a7 f4 ff ff       	call   200217 <clearStage>
		drawText1();
  200d70:	e8 1b f6 ff ff       	call   200390 <drawText1>
		//drawNumber(timestamp, 0, 0, 2, 15);
		drawStage();
  200d75:	e8 e7 f7 ff ff       	call   200561 <drawStage>

		int i=0;
  200d7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		x = 30;
  200d81:	c7 05 2c 3a 20 00 1e 	movl   $0x1e,0x203a2c
  200d88:	00 00 00 
		y = 30;
  200d8b:	c7 05 30 3a 20 00 1e 	movl   $0x1e,0x203a30
  200d92:	00 00 00 
		size = 4;
  200d95:	c7 05 34 3a 20 00 04 	movl   $0x4,0x203a34
  200d9c:	00 00 00 
		score = 0;
  200d9f:	c7 05 24 3a 20 00 00 	movl   $0x0,0x203a24
  200da6:	00 00 00 
		monsters[i].status = MONSTER_ALIVE;
  200da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200dac:	89 c2                	mov    %eax,%edx
  200dae:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200db5:	89 c2                	mov    %eax,%edx
  200db7:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200dbe:	29 d0                	sub    %edx,%eax
  200dc0:	83 c0 10             	add    $0x10,%eax
  200dc3:	05 40 3a 20 00       	add    $0x203a40,%eax
  200dc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		monsters[i].size = 1 + (KISS()%size);
  200dcf:	e8 2c f2 ff ff       	call   200000 <UKISS>
  200dd4:	89 c2                	mov    %eax,%edx
  200dd6:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200ddb:	01 c2                	add    %eax,%edx
  200ddd:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200de2:	01 d0                	add    %edx,%eax
  200de4:	8b 15 34 3a 20 00    	mov    0x203a34,%edx
  200dea:	89 d1                	mov    %edx,%ecx
  200dec:	ba 00 00 00 00       	mov    $0x0,%edx
  200df1:	f7 f1                	div    %ecx
  200df3:	89 d0                	mov    %edx,%eax
  200df5:	83 c0 01             	add    $0x1,%eax
  200df8:	89 c1                	mov    %eax,%ecx
  200dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200dfd:	c1 e0 02             	shl    $0x2,%eax
  200e00:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200e07:	29 c2                	sub    %eax,%edx
  200e09:	89 d0                	mov    %edx,%eax
  200e0b:	05 40 3a 20 00       	add    $0x203a40,%eax
  200e10:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
  200e12:	e8 e9 f1 ff ff       	call   200000 <UKISS>
  200e17:	89 c2                	mov    %eax,%edx
  200e19:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200e1e:	01 c2                	add    %eax,%edx
  200e20:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200e25:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200e28:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  200e2d:	89 c8                	mov    %ecx,%eax
  200e2f:	f7 e2                	mul    %edx
  200e31:	c1 ea 08             	shr    $0x8,%edx
  200e34:	89 d0                	mov    %edx,%eax
  200e36:	c1 e0 02             	shl    $0x2,%eax
  200e39:	01 d0                	add    %edx,%eax
  200e3b:	c1 e0 06             	shl    $0x6,%eax
  200e3e:	29 c1                	sub    %eax,%ecx
  200e40:	89 ca                	mov    %ecx,%edx
  200e42:	89 d1                	mov    %edx,%ecx
  200e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200e47:	c1 e0 02             	shl    $0x2,%eax
  200e4a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200e51:	29 c2                	sub    %eax,%edx
  200e53:	89 d0                	mov    %edx,%eax
  200e55:	05 40 3a 20 00       	add    $0x203a40,%eax
  200e5a:	89 48 04             	mov    %ecx,0x4(%eax)
		monsters[i].y = KISS()%VHEIGHT;
  200e5d:	e8 9e f1 ff ff       	call   200000 <UKISS>
  200e62:	89 c2                	mov    %eax,%edx
  200e64:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200e69:	01 c2                	add    %eax,%edx
  200e6b:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200e70:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200e73:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  200e78:	89 c8                	mov    %ecx,%eax
  200e7a:	f7 e2                	mul    %edx
  200e7c:	89 d0                	mov    %edx,%eax
  200e7e:	c1 e8 06             	shr    $0x6,%eax
  200e81:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
  200e87:	29 c1                	sub    %eax,%ecx
  200e89:	89 c8                	mov    %ecx,%eax
  200e8b:	89 c1                	mov    %eax,%ecx
  200e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200e90:	c1 e0 02             	shl    $0x2,%eax
  200e93:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200e9a:	29 c2                	sub    %eax,%edx
  200e9c:	89 d0                	mov    %edx,%eax
  200e9e:	05 40 3a 20 00       	add    $0x203a40,%eax
  200ea3:	89 48 08             	mov    %ecx,0x8(%eax)
		monsters[i].sx = -1 + KISS()%3;
  200ea6:	e8 55 f1 ff ff       	call   200000 <UKISS>
  200eab:	89 c2                	mov    %eax,%edx
  200ead:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200eb2:	01 c2                	add    %eax,%edx
  200eb4:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200eb9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200ebc:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  200ec1:	89 c8                	mov    %ecx,%eax
  200ec3:	f7 e2                	mul    %edx
  200ec5:	d1 ea                	shr    %edx
  200ec7:	89 d0                	mov    %edx,%eax
  200ec9:	01 c0                	add    %eax,%eax
  200ecb:	01 d0                	add    %edx,%eax
  200ecd:	29 c1                	sub    %eax,%ecx
  200ecf:	89 ca                	mov    %ecx,%edx
  200ed1:	8d 42 ff             	lea    -0x1(%edx),%eax
  200ed4:	89 c1                	mov    %eax,%ecx
  200ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200ed9:	c1 e0 02             	shl    $0x2,%eax
  200edc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  200ee3:	29 c2                	sub    %eax,%edx
  200ee5:	89 d0                	mov    %edx,%eax
  200ee7:	05 40 3a 20 00       	add    $0x203a40,%eax
  200eec:	89 48 0c             	mov    %ecx,0xc(%eax)
		monsters[i].sy = -1 + KISS()%3;
  200eef:	e8 0c f1 ff ff       	call   200000 <UKISS>
  200ef4:	89 c2                	mov    %eax,%edx
  200ef6:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200efb:	01 c2                	add    %eax,%edx
  200efd:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200f02:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200f05:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  200f0a:	89 c8                	mov    %ecx,%eax
  200f0c:	f7 e2                	mul    %edx
  200f0e:	d1 ea                	shr    %edx
  200f10:	89 d0                	mov    %edx,%eax
  200f12:	01 c0                	add    %eax,%eax
  200f14:	01 d0                	add    %edx,%eax
  200f16:	29 c1                	sub    %eax,%ecx
  200f18:	89 ca                	mov    %ecx,%edx
  200f1a:	8d 42 ff             	lea    -0x1(%edx),%eax
  200f1d:	89 c1                	mov    %eax,%ecx
  200f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200f22:	89 c2                	mov    %eax,%edx
  200f24:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200f2b:	89 c2                	mov    %eax,%edx
  200f2d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200f34:	29 d0                	sub    %edx,%eax
  200f36:	83 c0 10             	add    $0x10,%eax
  200f39:	05 40 3a 20 00       	add    $0x203a40,%eax
  200f3e:	89 08                	mov    %ecx,(%eax)
		i++;
  200f40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		REP_MONSTER(){
  200f44:	e9 29 02 00 00       	jmp    201172 <dreamOf100HZ+0x41a>
			monsters[i].status = MONSTER_SLEEP;
  200f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200f4c:	89 c2                	mov    %eax,%edx
  200f4e:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200f55:	89 c2                	mov    %eax,%edx
  200f57:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200f5e:	29 d0                	sub    %edx,%eax
  200f60:	83 c0 10             	add    $0x10,%eax
  200f63:	05 40 3a 20 00       	add    $0x203a40,%eax
  200f68:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
			monsters[i].count = 0;
  200f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200f72:	89 c2                	mov    %eax,%edx
  200f74:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200f7b:	89 c2                	mov    %eax,%edx
  200f7d:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200f84:	29 d0                	sub    %edx,%eax
  200f86:	83 c0 10             	add    $0x10,%eax
  200f89:	05 40 3a 20 00       	add    $0x203a40,%eax
  200f8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
			if(KISS()%MONSTER_SIZE < size+3){
  200f95:	e8 66 f0 ff ff       	call   200000 <UKISS>
  200f9a:	89 c2                	mov    %eax,%edx
  200f9c:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  200fa1:	01 c2                	add    %eax,%edx
  200fa3:	a1 30 3a 20 00       	mov    0x203a30,%eax
  200fa8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  200fab:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  200fb0:	89 c8                	mov    %ecx,%eax
  200fb2:	f7 e2                	mul    %edx
  200fb4:	c1 ea 04             	shr    $0x4,%edx
  200fb7:	89 d0                	mov    %edx,%eax
  200fb9:	c1 e0 02             	shl    $0x2,%eax
  200fbc:	01 d0                	add    %edx,%eax
  200fbe:	c1 e0 02             	shl    $0x2,%eax
  200fc1:	29 c1                	sub    %eax,%ecx
  200fc3:	89 ca                	mov    %ecx,%edx
  200fc5:	a1 34 3a 20 00       	mov    0x203a34,%eax
  200fca:	83 c0 03             	add    $0x3,%eax
  200fcd:	39 c2                	cmp    %eax,%edx
  200fcf:	0f 83 99 01 00 00    	jae    20116e <dreamOf100HZ+0x416>
				monsters[i].status = MONSTER_ALIVE;
  200fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  200fd8:	89 c2                	mov    %eax,%edx
  200fda:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  200fe1:	89 c2                	mov    %eax,%edx
  200fe3:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  200fea:	29 d0                	sub    %edx,%eax
  200fec:	83 c0 10             	add    $0x10,%eax
  200fef:	05 40 3a 20 00       	add    $0x203a40,%eax
  200ff4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
				monsters[i].size = 1 + 2*(KISS()%size);
  200ffb:	e8 00 f0 ff ff       	call   200000 <UKISS>
  201000:	89 c2                	mov    %eax,%edx
  201002:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  201007:	01 c2                	add    %eax,%edx
  201009:	a1 30 3a 20 00       	mov    0x203a30,%eax
  20100e:	01 d0                	add    %edx,%eax
  201010:	8b 15 34 3a 20 00    	mov    0x203a34,%edx
  201016:	89 d1                	mov    %edx,%ecx
  201018:	ba 00 00 00 00       	mov    $0x0,%edx
  20101d:	f7 f1                	div    %ecx
  20101f:	89 d0                	mov    %edx,%eax
  201021:	01 c0                	add    %eax,%eax
  201023:	83 c0 01             	add    $0x1,%eax
  201026:	89 c1                	mov    %eax,%ecx
  201028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20102b:	c1 e0 02             	shl    $0x2,%eax
  20102e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  201035:	29 c2                	sub    %eax,%edx
  201037:	89 d0                	mov    %edx,%eax
  201039:	05 40 3a 20 00       	add    $0x203a40,%eax
  20103e:	89 08                	mov    %ecx,(%eax)
				monsters[i].x = KISS()%VWIDTH;
  201040:	e8 bb ef ff ff       	call   200000 <UKISS>
  201045:	89 c2                	mov    %eax,%edx
  201047:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  20104c:	01 c2                	add    %eax,%edx
  20104e:	a1 30 3a 20 00       	mov    0x203a30,%eax
  201053:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  201056:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  20105b:	89 c8                	mov    %ecx,%eax
  20105d:	f7 e2                	mul    %edx
  20105f:	c1 ea 08             	shr    $0x8,%edx
  201062:	89 d0                	mov    %edx,%eax
  201064:	c1 e0 02             	shl    $0x2,%eax
  201067:	01 d0                	add    %edx,%eax
  201069:	c1 e0 06             	shl    $0x6,%eax
  20106c:	29 c1                	sub    %eax,%ecx
  20106e:	89 ca                	mov    %ecx,%edx
  201070:	89 d1                	mov    %edx,%ecx
  201072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201075:	c1 e0 02             	shl    $0x2,%eax
  201078:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  20107f:	29 c2                	sub    %eax,%edx
  201081:	89 d0                	mov    %edx,%eax
  201083:	05 40 3a 20 00       	add    $0x203a40,%eax
  201088:	89 48 04             	mov    %ecx,0x4(%eax)
				monsters[i].y = KISS()%VHEIGHT;
  20108b:	e8 70 ef ff ff       	call   200000 <UKISS>
  201090:	89 c2                	mov    %eax,%edx
  201092:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  201097:	01 c2                	add    %eax,%edx
  201099:	a1 30 3a 20 00       	mov    0x203a30,%eax
  20109e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2010a1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  2010a6:	89 c8                	mov    %ecx,%eax
  2010a8:	f7 e2                	mul    %edx
  2010aa:	89 d0                	mov    %edx,%eax
  2010ac:	c1 e8 06             	shr    $0x6,%eax
  2010af:	69 c0 c8 00 00 00    	imul   $0xc8,%eax,%eax
  2010b5:	29 c1                	sub    %eax,%ecx
  2010b7:	89 c8                	mov    %ecx,%eax
  2010b9:	89 c1                	mov    %eax,%ecx
  2010bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2010be:	c1 e0 02             	shl    $0x2,%eax
  2010c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  2010c8:	29 c2                	sub    %eax,%edx
  2010ca:	89 d0                	mov    %edx,%eax
  2010cc:	05 40 3a 20 00       	add    $0x203a40,%eax
  2010d1:	89 48 08             	mov    %ecx,0x8(%eax)
				monsters[i].sx = -1 + KISS()%3;
  2010d4:	e8 27 ef ff ff       	call   200000 <UKISS>
  2010d9:	89 c2                	mov    %eax,%edx
  2010db:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  2010e0:	01 c2                	add    %eax,%edx
  2010e2:	a1 30 3a 20 00       	mov    0x203a30,%eax
  2010e7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  2010ea:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  2010ef:	89 c8                	mov    %ecx,%eax
  2010f1:	f7 e2                	mul    %edx
  2010f3:	d1 ea                	shr    %edx
  2010f5:	89 d0                	mov    %edx,%eax
  2010f7:	01 c0                	add    %eax,%eax
  2010f9:	01 d0                	add    %edx,%eax
  2010fb:	29 c1                	sub    %eax,%ecx
  2010fd:	89 ca                	mov    %ecx,%edx
  2010ff:	8d 42 ff             	lea    -0x1(%edx),%eax
  201102:	89 c1                	mov    %eax,%ecx
  201104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201107:	c1 e0 02             	shl    $0x2,%eax
  20110a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  201111:	29 c2                	sub    %eax,%edx
  201113:	89 d0                	mov    %edx,%eax
  201115:	05 40 3a 20 00       	add    $0x203a40,%eax
  20111a:	89 48 0c             	mov    %ecx,0xc(%eax)
				monsters[i].sy = -1 + KISS()%3;
  20111d:	e8 de ee ff ff       	call   200000 <UKISS>
  201122:	89 c2                	mov    %eax,%edx
  201124:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  201129:	01 c2                	add    %eax,%edx
  20112b:	a1 30 3a 20 00       	mov    0x203a30,%eax
  201130:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  201133:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
  201138:	89 c8                	mov    %ecx,%eax
  20113a:	f7 e2                	mul    %edx
  20113c:	d1 ea                	shr    %edx
  20113e:	89 d0                	mov    %edx,%eax
  201140:	01 c0                	add    %eax,%eax
  201142:	01 d0                	add    %edx,%eax
  201144:	29 c1                	sub    %eax,%ecx
  201146:	89 ca                	mov    %ecx,%edx
  201148:	8d 42 ff             	lea    -0x1(%edx),%eax
  20114b:	89 c1                	mov    %eax,%ecx
  20114d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201150:	89 c2                	mov    %eax,%edx
  201152:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
  201159:	89 c2                	mov    %eax,%edx
  20115b:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  201162:	29 d0                	sub    %edx,%eax
  201164:	83 c0 10             	add    $0x10,%eax
  201167:	05 40 3a 20 00       	add    $0x203a40,%eax
  20116c:	89 08                	mov    %ecx,(%eax)
		monsters[i].x = KISS()%VWIDTH;
		monsters[i].y = KISS()%VHEIGHT;
		monsters[i].sx = -1 + KISS()%3;
		monsters[i].sy = -1 + KISS()%3;
		i++;
		REP_MONSTER(){
  20116e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  201172:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  201176:	0f 8e cd fd ff ff    	jle    200f49 <dreamOf100HZ+0x1f1>
				monsters[i].y = KISS()%VHEIGHT;
				monsters[i].sx = -1 + KISS()%3;
				monsters[i].sy = -1 + KISS()%3;
			}
		}
		printf("Press Q to start\n");
  20117c:	83 ec 0c             	sub    $0xc,%esp
  20117f:	68 c3 21 20 00       	push   $0x2021c3
  201184:	e8 7e 07 00 00       	call   201907 <printf>
  201189:	83 c4 10             	add    $0x10,%esp
		gameStatus = GAME_READY;
  20118c:	c7 05 28 3a 20 00 01 	movl   $0x1,0x203a28
  201193:	00 00 00 
	}
	if(gameStatus == GAME_READY){
  201196:	a1 28 3a 20 00       	mov    0x203a28,%eax
  20119b:	83 f8 01             	cmp    $0x1,%eax
  20119e:	75 2b                	jne    2011cb <dreamOf100HZ+0x473>
		//printf("%d\n", key('q'));
		if(key('q') ){
  2011a0:	83 ec 0c             	sub    $0xc,%esp
  2011a3:	6a 71                	push   $0x71
  2011a5:	e8 dc f3 ff ff       	call   200586 <key>
  2011aa:	83 c4 10             	add    $0x10,%esp
  2011ad:	84 c0                	test   %al,%al
  2011af:	74 1a                	je     2011cb <dreamOf100HZ+0x473>
			printf("Press W, A, S, D to move\n");
  2011b1:	83 ec 0c             	sub    $0xc,%esp
  2011b4:	68 d5 21 20 00       	push   $0x2021d5
  2011b9:	e8 49 07 00 00       	call   201907 <printf>
  2011be:	83 c4 10             	add    $0x10,%esp
			gameStatus = GAME_ING;
  2011c1:	c7 05 28 3a 20 00 02 	movl   $0x2,0x203a28
  2011c8:	00 00 00 
		}
	}

	if(gameStatus == GAME_ING){
  2011cb:	a1 28 3a 20 00       	mov    0x203a28,%eax
  2011d0:	83 f8 02             	cmp    $0x2,%eax
  2011d3:	0f 85 4c 01 00 00    	jne    201325 <dreamOf100HZ+0x5cd>



		//if(x>0 && x<VWIDTH && y>0 && y<VHEIGHT){
		//if(timestamp % 3){
			if(key('a'))x--;
  2011d9:	83 ec 0c             	sub    $0xc,%esp
  2011dc:	6a 61                	push   $0x61
  2011de:	e8 a3 f3 ff ff       	call   200586 <key>
  2011e3:	83 c4 10             	add    $0x10,%esp
  2011e6:	84 c0                	test   %al,%al
  2011e8:	74 0d                	je     2011f7 <dreamOf100HZ+0x49f>
  2011ea:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  2011ef:	83 e8 01             	sub    $0x1,%eax
  2011f2:	a3 2c 3a 20 00       	mov    %eax,0x203a2c
			if(key('d'))x++;
  2011f7:	83 ec 0c             	sub    $0xc,%esp
  2011fa:	6a 64                	push   $0x64
  2011fc:	e8 85 f3 ff ff       	call   200586 <key>
  201201:	83 c4 10             	add    $0x10,%esp
  201204:	84 c0                	test   %al,%al
  201206:	74 0d                	je     201215 <dreamOf100HZ+0x4bd>
  201208:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  20120d:	83 c0 01             	add    $0x1,%eax
  201210:	a3 2c 3a 20 00       	mov    %eax,0x203a2c
			if(key('w'))y--;
  201215:	83 ec 0c             	sub    $0xc,%esp
  201218:	6a 77                	push   $0x77
  20121a:	e8 67 f3 ff ff       	call   200586 <key>
  20121f:	83 c4 10             	add    $0x10,%esp
  201222:	84 c0                	test   %al,%al
  201224:	74 0d                	je     201233 <dreamOf100HZ+0x4db>
  201226:	a1 30 3a 20 00       	mov    0x203a30,%eax
  20122b:	83 e8 01             	sub    $0x1,%eax
  20122e:	a3 30 3a 20 00       	mov    %eax,0x203a30
			if(key('s'))y++;
  201233:	83 ec 0c             	sub    $0xc,%esp
  201236:	6a 73                	push   $0x73
  201238:	e8 49 f3 ff ff       	call   200586 <key>
  20123d:	83 c4 10             	add    $0x10,%esp
  201240:	84 c0                	test   %al,%al
  201242:	74 0d                	je     201251 <dreamOf100HZ+0x4f9>
  201244:	a1 30 3a 20 00       	mov    0x203a30,%eax
  201249:	83 c0 01             	add    $0x1,%eax
  20124c:	a3 30 3a 20 00       	mov    %eax,0x203a30
		//}

		if(x < 0) x++;
  201251:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  201256:	85 c0                	test   %eax,%eax
  201258:	79 0d                	jns    201267 <dreamOf100HZ+0x50f>
  20125a:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  20125f:	83 c0 01             	add    $0x1,%eax
  201262:	a3 2c 3a 20 00       	mov    %eax,0x203a2c
		if(x > VWIDTH) x--;
  201267:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  20126c:	3d 40 01 00 00       	cmp    $0x140,%eax
  201271:	7e 0d                	jle    201280 <dreamOf100HZ+0x528>
  201273:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  201278:	83 e8 01             	sub    $0x1,%eax
  20127b:	a3 2c 3a 20 00       	mov    %eax,0x203a2c
		if(y < 0) y++;
  201280:	a1 30 3a 20 00       	mov    0x203a30,%eax
  201285:	85 c0                	test   %eax,%eax
  201287:	79 0d                	jns    201296 <dreamOf100HZ+0x53e>
  201289:	a1 30 3a 20 00       	mov    0x203a30,%eax
  20128e:	83 c0 01             	add    $0x1,%eax
  201291:	a3 30 3a 20 00       	mov    %eax,0x203a30
		if(y > VHEIGHT) y--;
  201296:	a1 30 3a 20 00       	mov    0x203a30,%eax
  20129b:	3d c8 00 00 00       	cmp    $0xc8,%eax
  2012a0:	7e 0d                	jle    2012af <dreamOf100HZ+0x557>
  2012a2:	a1 30 3a 20 00       	mov    0x203a30,%eax
  2012a7:	83 e8 01             	sub    $0x1,%eax
  2012aa:	a3 30 3a 20 00       	mov    %eax,0x203a30
		//}
		//else{
		clearStage();
  2012af:	e8 63 ef ff ff       	call   200217 <clearStage>
		drawCirc(x, y, size, 3);
  2012b4:	8b 0d 34 3a 20 00    	mov    0x203a34,%ecx
  2012ba:	8b 15 30 3a 20 00    	mov    0x203a30,%edx
  2012c0:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  2012c5:	6a 03                	push   $0x3
  2012c7:	51                   	push   %ecx
  2012c8:	52                   	push   %edx
  2012c9:	50                   	push   %eax
  2012ca:	e8 14 f0 ff ff       	call   2002e3 <drawCirc>
  2012cf:	83 c4 10             	add    $0x10,%esp
		

		drawMonster();
  2012d2:	e8 d5 f4 ff ff       	call   2007ac <drawMonster>
		drawCirc(x, y, size, 3);
  2012d7:	8b 0d 34 3a 20 00    	mov    0x203a34,%ecx
  2012dd:	8b 15 30 3a 20 00    	mov    0x203a30,%edx
  2012e3:	a1 2c 3a 20 00       	mov    0x203a2c,%eax
  2012e8:	6a 03                	push   $0x3
  2012ea:	51                   	push   %ecx
  2012eb:	52                   	push   %edx
  2012ec:	50                   	push   %eax
  2012ed:	e8 f1 ef ff ff       	call   2002e3 <drawCirc>
  2012f2:	83 c4 10             	add    $0x10,%esp
		drawNumber(score, 0, 180, 1, 7);
  2012f5:	a1 24 3a 20 00       	mov    0x203a24,%eax
  2012fa:	83 ec 0c             	sub    $0xc,%esp
  2012fd:	6a 07                	push   $0x7
  2012ff:	6a 01                	push   $0x1
  201301:	68 b4 00 00 00       	push   $0xb4
  201306:	6a 00                	push   $0x0
  201308:	50                   	push   %eax
  201309:	e8 fa f0 ff ff       	call   200408 <drawNumber>
  20130e:	83 c4 20             	add    $0x20,%esp
		drawStage();
  201311:	e8 4b f2 ff ff       	call   200561 <drawStage>
		
		
		createMonster();
  201316:	e8 3f f8 ff ff       	call   200b5a <createMonster>
		while(hitMonster());
  20131b:	90                   	nop
  20131c:	e8 cc f2 ff ff       	call   2005ed <hitMonster>
  201321:	85 c0                	test   %eax,%eax
  201323:	75 f7                	jne    20131c <dreamOf100HZ+0x5c4>
		//}
	}
	if(gameStatus == GAME_END){
  201325:	a1 28 3a 20 00       	mov    0x203a28,%eax
  20132a:	83 f8 03             	cmp    $0x3,%eax
  20132d:	75 3a                	jne    201369 <dreamOf100HZ+0x611>
		printf("You're dead\n");
  20132f:	83 ec 0c             	sub    $0xc,%esp
  201332:	68 ef 21 20 00       	push   $0x2021ef
  201337:	e8 cb 05 00 00       	call   201907 <printf>
  20133c:	83 c4 10             	add    $0x10,%esp
		printf("Score: %d\n", score);
  20133f:	a1 24 3a 20 00       	mov    0x203a24,%eax
  201344:	83 ec 08             	sub    $0x8,%esp
  201347:	50                   	push   %eax
  201348:	68 fc 21 20 00       	push   $0x2021fc
  20134d:	e8 b5 05 00 00       	call   201907 <printf>
  201352:	83 c4 10             	add    $0x10,%esp
		clearStage();
  201355:	e8 bd ee ff ff       	call   200217 <clearStage>
		drawStage();
  20135a:	e8 02 f2 ff ff       	call   200561 <drawStage>
		gameStatus = GAME_START;
  20135f:	c7 05 28 3a 20 00 00 	movl   $0x0,0x203a28
  201366:	00 00 00 
	}
  201369:	c9                   	leave  
  20136a:	c3                   	ret    

0020136b <sys_printch>:
	void (*ptr)(void);
	int used;

}timer_handler;

static inline void sys_printch(char c){
  20136b:	55                   	push   %ebp
  20136c:	89 e5                	mov    %esp,%ebp
  20136e:	53                   	push   %ebx
  20136f:	83 ec 04             	sub    $0x4,%esp
  201372:	8b 45 08             	mov    0x8(%ebp),%eax
  201375:	88 45 f8             	mov    %al,-0x8(%ebp)
	asm volatile("int $0x80": : "a"(SYS_PRINT_CHAR), "b"(c)); //SYSCALL HERE!
  201378:	b8 e8 03 00 00       	mov    $0x3e8,%eax
  20137d:	0f b6 55 f8          	movzbl -0x8(%ebp),%edx
  201381:	89 d3                	mov    %edx,%ebx
  201383:	cd 80                	int    $0x80
}
  201385:	83 c4 04             	add    $0x4,%esp
  201388:	5b                   	pop    %ebx
  201389:	5d                   	pop    %ebp
  20138a:	c3                   	ret    

0020138b <printp>:
enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
  20138b:	55                   	push   %ebp
  20138c:	89 e5                	mov    %esp,%ebp
  20138e:	83 ec 18             	sub    $0x18,%esp
	const char *str = ctl;
  201391:	8b 45 0c             	mov    0xc(%ebp),%eax
  201394:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for(;cur!='\0';str++){
  201397:	eb 19                	jmp    2013b2 <printp+0x27>
		printer(cur);
  201399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20139c:	0f b6 00             	movzbl (%eax),%eax
  20139f:	0f be c0             	movsbl %al,%eax
  2013a2:	83 ec 0c             	sub    $0xc,%esp
  2013a5:	50                   	push   %eax
  2013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  2013a9:	ff d0                	call   *%eax
  2013ab:	83 c4 10             	add    $0x10,%esp
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
  2013ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  2013b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2013b5:	0f b6 00             	movzbl (%eax),%eax
  2013b8:	84 c0                	test   %al,%al
  2013ba:	75 dd                	jne    201399 <printp+0xe>
		printer(cur);
	}
}
  2013bc:	c9                   	leave  
  2013bd:	c3                   	ret    

002013be <vfprintf>:
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
  2013be:	55                   	push   %ebp
  2013bf:	89 e5                	mov    %esp,%ebp
  2013c1:	81 ec 98 00 00 00    	sub    $0x98,%esp
	const char *str = ctl;
  2013c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  2013ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
  2013cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
  2013d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
  2013db:	8b 45 10             	mov    0x10(%ebp),%eax
  2013de:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
  2013e1:	e9 71 02 00 00       	jmp    201657 <vfprintf+0x299>
		if(cur == '%'){
  2013e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2013e9:	0f b6 00             	movzbl (%eax),%eax
  2013ec:	3c 25                	cmp    $0x25,%al
  2013ee:	75 0c                	jne    2013fc <vfprintf+0x3e>
			type = READ;
  2013f0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
  2013f7:	e9 57 02 00 00       	jmp    201653 <vfprintf+0x295>
		}
		if(type == READ){
  2013fc:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  201400:	0f 85 32 02 00 00    	jne    201638 <vfprintf+0x27a>
			if(cur == 's'){
  201406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201409:	0f b6 00             	movzbl (%eax),%eax
  20140c:	3c 73                	cmp    $0x73,%al
  20140e:	75 35                	jne    201445 <vfprintf+0x87>
				char* p= XGET(pointer, char*);
  201410:	8b 45 e8             	mov    -0x18(%ebp),%eax
  201413:	8b 00                	mov    (%eax),%eax
  201415:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
  201418:	eb 19                	jmp    201433 <vfprintf+0x75>
					printer(*p);
  20141a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  20141d:	0f b6 00             	movzbl (%eax),%eax
  201420:	0f be c0             	movsbl %al,%eax
  201423:	83 ec 0c             	sub    $0xc,%esp
  201426:	50                   	push   %eax
  201427:	8b 45 08             	mov    0x8(%ebp),%eax
  20142a:	ff d0                	call   *%eax
  20142c:	83 c4 10             	add    $0x10,%esp
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
  20142f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  201433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  201436:	0f b6 00             	movzbl (%eax),%eax
  201439:	84 c0                	test   %al,%al
  20143b:	75 dd                	jne    20141a <vfprintf+0x5c>
					printer(*p);
				}
				XNEXT(pointer);
  20143d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  201441:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'x'){
  201445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201448:	0f b6 00             	movzbl (%eax),%eax
  20144b:	3c 78                	cmp    $0x78,%al
  20144d:	0f 85 9f 00 00 00    	jne    2014f2 <vfprintf+0x134>
				uint32_t x = XGET(pointer, int);
  201453:	8b 45 e8             	mov    -0x18(%ebp),%eax
  201456:	8b 00                	mov    (%eax),%eax
  201458:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
  20145b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  20145f:	75 1d                	jne    20147e <vfprintf+0xc0>
					printer('0');
  201461:	83 ec 0c             	sub    $0xc,%esp
  201464:	6a 30                	push   $0x30
  201466:	8b 45 08             	mov    0x8(%ebp),%eax
  201469:	ff d0                	call   *%eax
  20146b:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  20146e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  201472:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  201479:	e9 d5 01 00 00       	jmp    201653 <vfprintf+0x295>
					continue;
				}
				char digits[100];
				int di=0;
  20147e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
  201485:	eb 30                	jmp    2014b7 <vfprintf+0xf9>
					int d=(x%16);
  201487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  20148a:	83 e0 0f             	and    $0xf,%eax
  20148d:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
  201490:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
  201494:	7e 04                	jle    20149a <vfprintf+0xdc>
						d+='a'-'0'-10;
  201496:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
  20149a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  20149d:	83 c0 30             	add    $0x30,%eax
  2014a0:	89 c1                	mov    %eax,%ecx
  2014a2:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  2014a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  2014ab:	01 d0                	add    %edx,%eax
  2014ad:	88 08                	mov    %cl,(%eax)
					x>>=4;
  2014af:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
  2014b3:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  2014b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  2014bb:	75 ca                	jne    201487 <vfprintf+0xc9>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
  2014bd:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
  2014c1:	eb 21                	jmp    2014e4 <vfprintf+0x126>
					printer(digits[di]);
  2014c3:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  2014c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  2014cc:	01 d0                	add    %edx,%eax
  2014ce:	0f b6 00             	movzbl (%eax),%eax
  2014d1:	0f be c0             	movsbl %al,%eax
  2014d4:	83 ec 0c             	sub    $0xc,%esp
  2014d7:	50                   	push   %eax
  2014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  2014db:	ff d0                	call   *%eax
  2014dd:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
  2014e0:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  2014e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  2014e8:	79 d9                	jns    2014c3 <vfprintf+0x105>
					printer(digits[di]);
				}
				XNEXT(pointer);
  2014ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  2014ee:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'd'){
  2014f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2014f5:	0f b6 00             	movzbl (%eax),%eax
  2014f8:	3c 64                	cmp    $0x64,%al
  2014fa:	0f 85 08 01 00 00    	jne    201608 <vfprintf+0x24a>
				int x = XGET(pointer, int);
  201500:	8b 45 e8             	mov    -0x18(%ebp),%eax
  201503:	8b 00                	mov    (%eax),%eax
  201505:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
  201508:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
  20150f:	75 23                	jne    201534 <vfprintf+0x176>
					printp(printer, "-2147483648");
  201511:	83 ec 08             	sub    $0x8,%esp
  201514:	68 07 22 20 00       	push   $0x202207
  201519:	ff 75 08             	pushl  0x8(%ebp)
  20151c:	e8 6a fe ff ff       	call   20138b <printp>
  201521:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  201524:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  201528:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  20152f:	e9 1f 01 00 00       	jmp    201653 <vfprintf+0x295>
				}
				if(x==0){
  201534:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  201538:	75 1e                	jne    201558 <vfprintf+0x19a>
					printer('0');
  20153a:	83 ec 0c             	sub    $0xc,%esp
  20153d:	6a 30                	push   $0x30
  20153f:	8b 45 08             	mov    0x8(%ebp),%eax
  201542:	ff d0                	call   *%eax
  201544:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  201547:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  20154b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  201552:	90                   	nop
  201553:	e9 fb 00 00 00       	jmp    201653 <vfprintf+0x295>
				}
				if(x<0){
  201558:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  20155c:	79 10                	jns    20156e <vfprintf+0x1b0>
					printer('-');
  20155e:	83 ec 0c             	sub    $0xc,%esp
  201561:	6a 2d                	push   $0x2d
  201563:	8b 45 08             	mov    0x8(%ebp),%eax
  201566:	ff d0                	call   *%eax
  201568:	83 c4 10             	add    $0x10,%esp
					x=-x;
  20156b:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[100];
				int di=0;
  20156e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
  201575:	eb 56                	jmp    2015cd <vfprintf+0x20f>
					digits[di] = '0'+(x%10);
  201577:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  20157a:	ba 67 66 66 66       	mov    $0x66666667,%edx
  20157f:	89 c8                	mov    %ecx,%eax
  201581:	f7 ea                	imul   %edx
  201583:	c1 fa 02             	sar    $0x2,%edx
  201586:	89 c8                	mov    %ecx,%eax
  201588:	c1 f8 1f             	sar    $0x1f,%eax
  20158b:	29 c2                	sub    %eax,%edx
  20158d:	89 d0                	mov    %edx,%eax
  20158f:	c1 e0 02             	shl    $0x2,%eax
  201592:	01 d0                	add    %edx,%eax
  201594:	01 c0                	add    %eax,%eax
  201596:	29 c1                	sub    %eax,%ecx
  201598:	89 ca                	mov    %ecx,%edx
  20159a:	89 d0                	mov    %edx,%eax
  20159c:	83 c0 30             	add    $0x30,%eax
  20159f:	89 c1                	mov    %eax,%ecx
  2015a1:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  2015a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  2015aa:	01 d0                	add    %edx,%eax
  2015ac:	88 08                	mov    %cl,(%eax)
					x/=10;
  2015ae:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  2015b1:	ba 67 66 66 66       	mov    $0x66666667,%edx
  2015b6:	89 c8                	mov    %ecx,%eax
  2015b8:	f7 ea                	imul   %edx
  2015ba:	c1 fa 02             	sar    $0x2,%edx
  2015bd:	89 c8                	mov    %ecx,%eax
  2015bf:	c1 f8 1f             	sar    $0x1f,%eax
  2015c2:	29 c2                	sub    %eax,%edx
  2015c4:	89 d0                	mov    %edx,%eax
  2015c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
  2015c9:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					printer('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  2015cd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  2015d1:	7f a4                	jg     201577 <vfprintf+0x1b9>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
  2015d3:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
  2015d7:	eb 21                	jmp    2015fa <vfprintf+0x23c>
					printer(digits[di]);
  2015d9:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  2015df:	8b 45 d0             	mov    -0x30(%ebp),%eax
  2015e2:	01 d0                	add    %edx,%eax
  2015e4:	0f b6 00             	movzbl (%eax),%eax
  2015e7:	0f be c0             	movsbl %al,%eax
  2015ea:	83 ec 0c             	sub    $0xc,%esp
  2015ed:	50                   	push   %eax
  2015ee:	8b 45 08             	mov    0x8(%ebp),%eax
  2015f1:	ff d0                	call   *%eax
  2015f3:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
  2015f6:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  2015fa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  2015fe:	79 d9                	jns    2015d9 <vfprintf+0x21b>
					printer(digits[di]);
				}
				XNEXT(pointer);
  201600:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  201604:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
  201608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20160b:	0f b6 00             	movzbl (%eax),%eax
  20160e:	3c 63                	cmp    $0x63,%al
  201610:	75 1d                	jne    20162f <vfprintf+0x271>
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
  201612:	8b 45 e8             	mov    -0x18(%ebp),%eax
  201615:	0f b6 00             	movzbl (%eax),%eax
  201618:	0f be c0             	movsbl %al,%eax
  20161b:	83 ec 0c             	sub    $0xc,%esp
  20161e:	50                   	push   %eax
  20161f:	8b 45 08             	mov    0x8(%ebp),%eax
  201622:	ff d0                	call   *%eax
  201624:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
  201627:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  20162b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
  20162f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
  201636:	eb 1b                	jmp    201653 <vfprintf+0x295>
		}
		if(type == NONE){
  201638:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  20163c:	75 15                	jne    201653 <vfprintf+0x295>
			printer(cur);
  20163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201641:	0f b6 00             	movzbl (%eax),%eax
  201644:	0f be c0             	movsbl %al,%eax
  201647:	83 ec 0c             	sub    $0xc,%esp
  20164a:	50                   	push   %eax
  20164b:	8b 45 08             	mov    0x8(%ebp),%eax
  20164e:	ff d0                	call   *%eax
  201650:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
  201653:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  201657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20165a:	0f b6 00             	movzbl (%eax),%eax
  20165d:	84 c0                	test   %al,%al
  20165f:	0f 85 81 fd ff ff    	jne    2013e6 <vfprintf+0x28>
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}
  201665:	c9                   	leave  
  201666:	c3                   	ret    

00201667 <vfprintfs>:

void vfprintfs(void (*printer)(char), const char *ctl, void **args) {
  201667:	55                   	push   %ebp
  201668:	89 e5                	mov    %esp,%ebp
  20166a:	81 ec 98 00 00 00    	sub    $0x98,%esp
	const char *str = ctl;
  201670:	8b 45 0c             	mov    0xc(%ebp),%eax
  201673:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int32_t i = 0;
  201676:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	int32_t type = NONE;
  20167d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	void** pointer = args;
  201684:	8b 45 10             	mov    0x10(%ebp),%eax
  201687:	89 45 e8             	mov    %eax,-0x18(%ebp)
	//char last='\0';
	for(;*str != '\0'; str ++){
  20168a:	e9 68 02 00 00       	jmp    2018f7 <vfprintfs+0x290>
		if(cur == '%'){
  20168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201692:	0f b6 00             	movzbl (%eax),%eax
  201695:	3c 25                	cmp    $0x25,%al
  201697:	75 0c                	jne    2016a5 <vfprintfs+0x3e>
			type = READ;
  201699:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
			continue;
  2016a0:	e9 4e 02 00 00       	jmp    2018f3 <vfprintfs+0x28c>
		}
		if(type == READ){
  2016a5:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  2016a9:	0f 85 29 02 00 00    	jne    2018d8 <vfprintfs+0x271>
			if(cur == 's'){
  2016af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2016b2:	0f b6 00             	movzbl (%eax),%eax
  2016b5:	3c 73                	cmp    $0x73,%al
  2016b7:	75 32                	jne    2016eb <vfprintfs+0x84>
				char* p= XGET(pointer, char*);
  2016b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2016bc:	8b 00                	mov    (%eax),%eax
  2016be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				for(; *p != '\0';p++){
  2016c1:	eb 16                	jmp    2016d9 <vfprintfs+0x72>
					sys_printch(*p);
  2016c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  2016c6:	0f b6 00             	movzbl (%eax),%eax
  2016c9:	0f be c0             	movsbl %al,%eax
  2016cc:	50                   	push   %eax
  2016cd:	e8 99 fc ff ff       	call   20136b <sys_printch>
  2016d2:	83 c4 04             	add    $0x4,%esp
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
  2016d5:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  2016d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  2016dc:	0f b6 00             	movzbl (%eax),%eax
  2016df:	84 c0                	test   %al,%al
  2016e1:	75 e0                	jne    2016c3 <vfprintfs+0x5c>
					sys_printch(*p);
				}
				XNEXT(pointer);
  2016e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  2016e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'x'){
  2016eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2016ee:	0f b6 00             	movzbl (%eax),%eax
  2016f1:	3c 78                	cmp    $0x78,%al
  2016f3:	0f 85 99 00 00 00    	jne    201792 <vfprintfs+0x12b>
				uint32_t x = XGET(pointer, int);
  2016f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2016fc:	8b 00                	mov    (%eax),%eax
  2016fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
				if(x==0){
  201701:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  201705:	75 1a                	jne    201721 <vfprintfs+0xba>
					sys_printch('0');
  201707:	6a 30                	push   $0x30
  201709:	e8 5d fc ff ff       	call   20136b <sys_printch>
  20170e:	83 c4 04             	add    $0x4,%esp
					XNEXT(pointer);
  201711:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  201715:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  20171c:	e9 d2 01 00 00       	jmp    2018f3 <vfprintfs+0x28c>
					continue;
				}
				char digits[100];
				int di=0;
  201721:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
				while(x>=1){
  201728:	eb 30                	jmp    20175a <vfprintfs+0xf3>
					int d=(x%16);
  20172a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  20172d:	83 e0 0f             	and    $0xf,%eax
  201730:	89 45 d8             	mov    %eax,-0x28(%ebp)
					if(d>=10){
  201733:	83 7d d8 09          	cmpl   $0x9,-0x28(%ebp)
  201737:	7e 04                	jle    20173d <vfprintfs+0xd6>
						d+='a'-'0'-10;
  201739:	83 45 d8 27          	addl   $0x27,-0x28(%ebp)
					}
					digits[di] = '0'+d;
  20173d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  201740:	83 c0 30             	add    $0x30,%eax
  201743:	89 c1                	mov    %eax,%ecx
  201745:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  20174b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  20174e:	01 d0                	add    %edx,%eax
  201750:	88 08                	mov    %cl,(%eax)
					x>>=4;
  201752:	c1 6d e0 04          	shrl   $0x4,-0x20(%ebp)
					di ++;
  201756:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  20175a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  20175e:	75 ca                	jne    20172a <vfprintfs+0xc3>
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
  201760:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
				for(;di>=0;di--){
  201764:	eb 1e                	jmp    201784 <vfprintfs+0x11d>
					sys_printch(digits[di]);
  201766:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  20176c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  20176f:	01 d0                	add    %edx,%eax
  201771:	0f b6 00             	movzbl (%eax),%eax
  201774:	0f be c0             	movsbl %al,%eax
  201777:	50                   	push   %eax
  201778:	e8 ee fb ff ff       	call   20136b <sys_printch>
  20177d:	83 c4 04             	add    $0x4,%esp
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
  201780:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  201784:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  201788:	79 dc                	jns    201766 <vfprintfs+0xff>
					sys_printch(digits[di]);
				}
				XNEXT(pointer);
  20178a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  20178e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'd'){
  201792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  201795:	0f b6 00             	movzbl (%eax),%eax
  201798:	3c 64                	cmp    $0x64,%al
  20179a:	0f 85 08 01 00 00    	jne    2018a8 <vfprintfs+0x241>
				int x = XGET(pointer, int);
  2017a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2017a3:	8b 00                	mov    (%eax),%eax
  2017a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				if(x==-2147483648){
  2017a8:	81 7d d4 00 00 00 80 	cmpl   $0x80000000,-0x2c(%ebp)
  2017af:	75 23                	jne    2017d4 <vfprintfs+0x16d>
					printp(printer, "-2147483648");
  2017b1:	83 ec 08             	sub    $0x8,%esp
  2017b4:	68 07 22 20 00       	push   $0x202207
  2017b9:	ff 75 08             	pushl  0x8(%ebp)
  2017bc:	e8 ca fb ff ff       	call   20138b <printp>
  2017c1:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  2017c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  2017c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  2017cf:	e9 1f 01 00 00       	jmp    2018f3 <vfprintfs+0x28c>
				}
				if(x==0){
  2017d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  2017d8:	75 1e                	jne    2017f8 <vfprintfs+0x191>
					sys_printch('0');
  2017da:	83 ec 0c             	sub    $0xc,%esp
  2017dd:	6a 30                	push   $0x30
  2017df:	e8 87 fb ff ff       	call   20136b <sys_printch>
  2017e4:	83 c4 10             	add    $0x10,%esp
					XNEXT(pointer);
  2017e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
					type = NONE;
  2017eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
					continue;
  2017f2:	90                   	nop
  2017f3:	e9 fb 00 00 00       	jmp    2018f3 <vfprintfs+0x28c>
				}
				if(x<0){
  2017f8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  2017fc:	79 10                	jns    20180e <vfprintfs+0x1a7>
					sys_printch('-');
  2017fe:	83 ec 0c             	sub    $0xc,%esp
  201801:	6a 2d                	push   $0x2d
  201803:	e8 63 fb ff ff       	call   20136b <sys_printch>
  201808:	83 c4 10             	add    $0x10,%esp
					x=-x;
  20180b:	f7 5d d4             	negl   -0x2c(%ebp)
				}
				char digits[100];
				int di=0;
  20180e:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
				while(x>=1){
  201815:	eb 56                	jmp    20186d <vfprintfs+0x206>
					digits[di] = '0'+(x%10);
  201817:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  20181a:	ba 67 66 66 66       	mov    $0x66666667,%edx
  20181f:	89 c8                	mov    %ecx,%eax
  201821:	f7 ea                	imul   %edx
  201823:	c1 fa 02             	sar    $0x2,%edx
  201826:	89 c8                	mov    %ecx,%eax
  201828:	c1 f8 1f             	sar    $0x1f,%eax
  20182b:	29 c2                	sub    %eax,%edx
  20182d:	89 d0                	mov    %edx,%eax
  20182f:	c1 e0 02             	shl    $0x2,%eax
  201832:	01 d0                	add    %edx,%eax
  201834:	01 c0                	add    %eax,%eax
  201836:	29 c1                	sub    %eax,%ecx
  201838:	89 ca                	mov    %ecx,%edx
  20183a:	89 d0                	mov    %edx,%eax
  20183c:	83 c0 30             	add    $0x30,%eax
  20183f:	89 c1                	mov    %eax,%ecx
  201841:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  201847:	8b 45 d0             	mov    -0x30(%ebp),%eax
  20184a:	01 d0                	add    %edx,%eax
  20184c:	88 08                	mov    %cl,(%eax)
					x/=10;
  20184e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  201851:	ba 67 66 66 66       	mov    $0x66666667,%edx
  201856:	89 c8                	mov    %ecx,%eax
  201858:	f7 ea                	imul   %edx
  20185a:	c1 fa 02             	sar    $0x2,%edx
  20185d:	89 c8                	mov    %ecx,%eax
  20185f:	c1 f8 1f             	sar    $0x1f,%eax
  201862:	29 c2                	sub    %eax,%edx
  201864:	89 d0                	mov    %edx,%eax
  201866:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					di++;
  201869:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
					sys_printch('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
  20186d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  201871:	7f a4                	jg     201817 <vfprintfs+0x1b0>
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
  201873:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
				for(;di>=0;di--){
  201877:	eb 21                	jmp    20189a <vfprintfs+0x233>
					sys_printch(digits[di]);
  201879:	8d 95 6c ff ff ff    	lea    -0x94(%ebp),%edx
  20187f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  201882:	01 d0                	add    %edx,%eax
  201884:	0f b6 00             	movzbl (%eax),%eax
  201887:	0f be c0             	movsbl %al,%eax
  20188a:	83 ec 0c             	sub    $0xc,%esp
  20188d:	50                   	push   %eax
  20188e:	e8 d8 fa ff ff       	call   20136b <sys_printch>
  201893:	83 c4 10             	add    $0x10,%esp
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
  201896:	83 6d d0 01          	subl   $0x1,-0x30(%ebp)
  20189a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  20189e:	79 d9                	jns    201879 <vfprintfs+0x212>
					sys_printch(digits[di]);
				}
				XNEXT(pointer);
  2018a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  2018a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			if(cur == 'c'){
  2018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2018ab:	0f b6 00             	movzbl (%eax),%eax
  2018ae:	3c 63                	cmp    $0x63,%al
  2018b0:	75 1d                	jne    2018cf <vfprintfs+0x268>
				//char* pointer = (char*)args;
				//printer(*pointer);
				sys_printch(XGET(pointer, char));
  2018b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2018b5:	0f b6 00             	movzbl (%eax),%eax
  2018b8:	0f be c0             	movsbl %al,%eax
  2018bb:	83 ec 0c             	sub    $0xc,%esp
  2018be:	50                   	push   %eax
  2018bf:	e8 a7 fa ff ff       	call   20136b <sys_printch>
  2018c4:	83 c4 10             	add    $0x10,%esp
				XNEXT(pointer);
  2018c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
				i++;
  2018cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			}
			type = NONE;
  2018cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
			continue;
  2018d6:	eb 1b                	jmp    2018f3 <vfprintfs+0x28c>
		}
		if(type == NONE){
  2018d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  2018dc:	75 15                	jne    2018f3 <vfprintfs+0x28c>
			sys_printch(cur);
  2018de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2018e1:	0f b6 00             	movzbl (%eax),%eax
  2018e4:	0f be c0             	movsbl %al,%eax
  2018e7:	83 ec 0c             	sub    $0xc,%esp
  2018ea:	50                   	push   %eax
  2018eb:	e8 7b fa ff ff       	call   20136b <sys_printch>
  2018f0:	83 c4 10             	add    $0x10,%esp
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
  2018f3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  2018f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2018fa:	0f b6 00             	movzbl (%eax),%eax
  2018fd:	84 c0                	test   %al,%al
  2018ff:	0f 85 8a fd ff ff    	jne    20168f <vfprintfs+0x28>
		if(type == NONE){
			sys_printch(cur);
		}
		//last = cur;
	}
}
  201905:	c9                   	leave  
  201906:	c3                   	ret    

00201907 <printf>:

void __attribute__((__noinline__)) 
printf(const char *ctl, ...) {
  201907:	55                   	push   %ebp
  201908:	89 e5                	mov    %esp,%ebp
  20190a:	83 ec 18             	sub    $0x18,%esp
	void **args = (void **)&ctl + 1;
  20190d:	8d 45 0c             	lea    0xc(%ebp),%eax
  201910:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vfprintfs(sys_printch, ctl, args);
  201913:	8b 45 08             	mov    0x8(%ebp),%eax
  201916:	83 ec 04             	sub    $0x4,%esp
  201919:	ff 75 f4             	pushl  -0xc(%ebp)
  20191c:	50                   	push   %eax
  20191d:	68 6b 13 20 00       	push   $0x20136b
  201922:	e8 40 fd ff ff       	call   201667 <vfprintfs>
  201927:	83 c4 10             	add    $0x10,%esp
}
  20192a:	c9                   	leave  
  20192b:	c3                   	ret    
