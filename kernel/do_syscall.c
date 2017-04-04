#include "lib/common.h"
#include "lib/syscall.h"
#include "lib/serial.h"
#include "lib/video.h"
#include "lib/keyboard.h"

extern timer_handler timer_handlers[TIMER_HANDLERS_MAX];

void do_syscall(struct TrapFrame *tf) {
	int i;
	switch(tf->eax) {
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
			//printk("1\n");
		break;
		case SYS_INIT_CACHE:
			initVCache();
		break;
		case SYS_CLEAR_VRAM:
			clearVRAM();
		break;
		case SYS_FLUSH_VCACHE:
			clearVRAM();
			flushVCache();
		break;
		case SYS_SET_PIXEL:
			setPixelAt(tf->ebx, tf->ecx, (uint8_t)tf->edx);
		break;
		case SYS_GET_KEY:
			tf->eax = get_key(tf->ebx);
		break;
		case SYS_ADD_TIMER:
			for(i=0;i<TIMER_HANDLERS_MAX;i++){
				if(!timer_handlers[i].used){
					timer_handlers[i].ptr = (void*)tf->ebx;
					timer_handlers[i].used = 1;
					break;
				}
			}
		break;
		/* The `add_irq_handle' system call is artificial. We use it to
		 * let user program register its interrupt handlers. But this is
		 * very dangerous in a real operating system. Therefore such a
		 * system call never exists in GNU/Linux.
		 */

	}
}