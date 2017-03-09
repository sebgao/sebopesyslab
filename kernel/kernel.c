#include "device/serial.h"


int main(){
	int i = 0;
	while(1)serial_printc(('a'+(i++)%26));
	return 1;
};
