
#ifndef _PRINTK_H
#define _PRINTK_H

#include "common.h"
#include <stdarg.h>
//#include "serial.h"
#include "syscall.h"

void __attribute__((__noinline__))  printf(const char *ctl, ...);
void vfprintf(void (*printer)(char), const char *ctl, void **args);
//void __attribute__((__noinline__))  printk(const char *ctl, ...);

#endif