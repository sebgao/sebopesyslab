
#ifndef _PRINTK_H
#define _PRINTK_H

#include "common.h"
#include <stdarg.h>
#include "lib/serial.h"
#define XGET(ptr, TYPE) *((TYPE*)(ptr))
#define XNEXT(ptr) ptr++
extern void serial_printc(char);

enum{
	NONE,
	READ
};
#define cur (*str)
void printp(void (*printer)(char), const char *ctl){
	const char *str = ctl;
	for(;cur!='\0';str++){
		printer(cur);
	}
}
void vfprintf(void (*printer)(char), const char *ctl, void **args) {
	const char *str = ctl;
	int32_t i = 0;
	int32_t type = NONE;
	void** pointer = args;
	//char last='\0';
	for(;*str != '\0'; str ++){
		if(cur == '%'){
			type = READ;
			continue;
		}
		if(type == READ){
			if(cur == 's'){
				char* p= XGET(pointer, char*);
				for(; *p != '\0';p++){
					printer(*p);
				}
				XNEXT(pointer);
				i++;
			}
			if(cur == 'x'){
				uint32_t x = XGET(pointer, int);
				if(x==0){
					printer('0');
					XNEXT(pointer);
					type = NONE;
					continue;
				}
				char digits[100];
				int di=0;
				while(x>=1){
					int d=(x%16);
					if(d>=10){
						d+='a'-'0'-10;
					}
					digits[di] = '0'+d;
					x>>=4;
					di ++;
				};
				di--;
				for(;di>=0;di--){
					printer(digits[di]);
				}
				XNEXT(pointer);
				i++;
			}
			if(cur == 'd'){
				int x = XGET(pointer, int);
				if(x==-2147483648){
					printp(printer, "-2147483648");
					XNEXT(pointer);
					type = NONE;
					continue;
				}
				if(x==0){
					printer('0');
					XNEXT(pointer);
					type = NONE;
					continue;
				}
				if(x<0){
					printer('-');
					x=-x;
				}
				char digits[100];
				int di=0;
				while(x>=1){
					digits[di] = '0'+(x%10);
					x/=10;
					di++;
				};
				di--;
				for(;di>=0;di--){
					printer(digits[di]);
				}
				XNEXT(pointer);
				i++;
			}
			if(cur == 'c'){
				//char* pointer = (char*)args;
				//printer(*pointer);
				printer(XGET(pointer, char));
				XNEXT(pointer);
				i++;
			}
			type = NONE;
			continue;
		}
		if(type == NONE){
			printer(cur);
		}
		//last = cur;
	}
}

void __attribute__((__noinline__)) 
printk(const char *ctl, ...) {
	void **args = (void **)&ctl + 1;
	vfprintf(serial_printc, ctl, args);
}
#undef cur
#undef GETS
#endif
