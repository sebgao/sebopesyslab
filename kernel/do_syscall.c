#include "lib/common.h"
#include "lib/serial.h"
void do_syscall(struct TrapFrame *tf) {
	switch(tf->eax) {
		case SYS_PRINT_CHAR:
			serial_printc(tf->ebx);
			//printk("1\n");
		break;
		/* The `add_irq_handle' system call is artificial. We use it to
		 * let user program register its interrupt handlers. But this is
		 * very dangerous in a real operating system. Therefore such a
		 * system call never exists in GNU/Linux.
		 */

	}
}