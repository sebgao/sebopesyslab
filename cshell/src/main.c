#include "common.h"
#include "lib/syscall.h"
#include "rnd.h"

int main(){

	char c[64];

	while(1){
		creadline(c);
		printf("%s\n", c);
	}


	exit();
}