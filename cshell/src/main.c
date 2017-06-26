#include "common.h"
#include "lib/syscall.h"
#include "rnd.h"

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

char c[1024];
char b[1024];
int argc;
char *argv[MAXARGS];
char safety[1024]="safety";
int parse_arg(char *buf){

	argc = 0;
	argv[argc] = 0;
	while (1) {
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		if (argc == MAXARGS-1) {
			printf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
	return 1;
}

int exist_arg(char *arg){
	int i = 0;
	for (i = 1; i < argc; ++i)
	{
		if(!strcmp(argv[i], arg)) return i;
	};
	return 0;
}
void ls(){
	uint32_t mask = 0;
	if(exist_arg("-l"))
		mask |= 0x01;
	if(exist_arg("-a"))
		mask |= 0x02;
	if(exist_arg("-h"))
		mask |= 0x04;
	sys_fs_ls(mask);
}
void echo(){
	int red = exist_arg(">");
	int app = exist_arg(">>");
	if(red){
		char* buf = b + 5;
		int len = strfind(buf, '>') - buf - 1;
		char* filename = argv[red + 1];
		int fd = open(filename, FS_RWD);
		write(fd, buf, len);
		close(fd);
		return;
	}
	if(app){
		char* buf = b + 5;
		int len = strfind(buf, '>') - buf - 1;
		char* filename = argv[app + 1];
		int fd = open(filename, FS_RWC);
		lseek(fd, 0, SEEK_END);
		write(fd, buf, len);
		close(fd);
		return;
	}
	int i=0;
	for (i=1; i < argc; ++i)
	{
		printf("%s", argv[i]);
		if(i != argc-1){
			printf(" ");
		}
	}
	printf("\n");

}
void cat(){
	char* filename = argv[1];
	int fd = open(filename, FS_RW);
	if(fd == -1)
		printf("%s doesn't exist\n", filename);
	char buf[1024];
	memset2(buf, 0, 1024);
	int red = exist_arg(">");
	int app = exist_arg(">>");
	if(red){
		char* ofilename = argv[red + 1];
		int out = open(ofilename, FS_RWD);
		int l = 0;
		while((l = read(fd, buf, 1024)) != -1)
			write(out, buf, l);
		close(out);
		close(fd);
		return;
	}
	if(app){
		char* ofilename = argv[app + 1];
		int out = open(ofilename, FS_RWC);
		lseek(out, 0, SEEK_END);
		int l = 0;
		while((l = read(fd, buf, 1024)) != -1)
			write(out, buf, l);
		close(out);
		close(fd);
		return;
	}
	while(read(fd, buf, 1024) != -1)
		printf("%s\n", buf);
	close(fd);
}
void do_shell(){
	char *cmd = argv[0];
	if(!strcmp(cmd, "ls")){
		ls();
		return;
	}
	if(!strcmp(cmd, "echo")){
		echo();
		return;
	}
	if(!strcmp(cmd, "cat")){
		cat();
		return;
	}

	int fd = open(cmd, FS_RW);
	if(fd == -1){
		printf("%s is not an command \n", cmd);
	}
	else{
		int p = fork();
		//printf("ffff %d\n", p);
		if(p == 0){
			sys_exec(cmd);
			//exit();
		}
		process_join(p);
		return;
	}
}
int main(){
	printf("This is shell!\n");
	while(1){
		//printf("1 %s\n", safety);
		creadline(c);
		//printf("2 %s\n", safety);
		strcpy(b, c);
		//printf("3 %s\n", safety);
		parse_arg(c);	
		do_shell();
	}


	exit();
}