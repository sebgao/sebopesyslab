#include "lib/common.h"

#include "lib/serial.h"
#include "lib/i8259.h"
#include "lib/timer.h"
#include "lib/irq.h"

extern void game_logic();

int main(){
	init_serial();
	init_timer();
	init_idt();
	init_intr();

	game_logic();

	return 1;
};
