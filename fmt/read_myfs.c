#include "file.h"
#include "string.h"
#define SECT_SIZE 512

struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[SECT_SIZE];
FILE *disk;
void readBitmap(){
	int count;
	fseek(disk, LOC_BITMAP(), 0);
	for(count = 0; count < SC_BITMAP; count++){
		fread((uint8_t*)bitmap.mask+(count<<9), 1, SECT_SIZE, disk);
	}
}

void saveBitmap(){
	int count;
	fseek(disk, LOC_BITMAP(), 0);
	for(count = 0; count < SC_BITMAP; count++){
		fwrite((uint8_t*)bitmap.mask+(count<<9), 1, SECT_SIZE, disk);
	}
}
void readDir(int offset){
	fseek(disk, LOC_DIR(offset), 0);
	fread((uint8_t*)dir.entries, 1, SECT_SIZE, disk);
}
void saveDir(int offset){
	fseek(disk, LOC_DIR(offset), 0);
	fwrite((uint8_t*)dir.entries, 1, SECT_SIZE, disk);
}
void readINode(int offset){
	fseek(disk, LOC_INODE(offset), 0);
	fread((uint8_t*)inode.data_block_offsets, 1, SECT_SIZE, disk);
}
void saveINode(int offset){
	fseek(disk, LOC_INODE(offset), 0);
	fwrite((uint8_t*)inode.data_block_offsets,  1, SECT_SIZE,disk);
}
void readData(int offset){
	fseek(disk, LOC_DATA(offset), 0);
	fread(buffer, 1, SECT_SIZE, disk);
}
void writeData(int offset){
	fseek(disk, LOC_DATA(offset), 0);
	fwrite(buffer, 1, SECT_SIZE, disk);
}
int INodeAlloc(){
	int i = 0;
	for(i = 0; i < SC_INODE; i++){
		int sec = LOC_INODE(i)>>9;
		int secN = sec>>3;
		int secR = 1<<(sec&0x7);
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
			bitmap.mask[secN] |= secR;
			return i;
		}
	}
	return -1;
}
int dataAlloc(){
	int i = 0;
	for(i = 0; i < SC_DATA; i++){
		int sec = LOC_DATA(i)>>9;
		int secN = sec>>3;
		int secR = 1<<(sec&0x7);
		//printf("%s\n", );
		if((bitmap.mask[secN]&secR) == 0){
			bitmap.mask[secN] |= secR;
			return i;
		}
	}
	return -1;
}
int main(int argc, char* argv[]){
	if(argc <= 1){
		printf("argument expected\n");
		return 0;
	}
	//printf("%s\n", argv[1]);
	//printf("%s\n", argv[2]);
	char name[30];

	strcpy(name, argv[1]);

	
	disk = fopen("disk.bin", "r+");
	
	int dir_offset = 0, entry_offset = 0;
	while(dir_offset < SC_DIR){
		readDir(dir_offset);

		for(entry_offset = 0; entry_offset < NR_ENTRIES; entry_offset++){
			if(!strcmp(dir.entries[entry_offset].filename, name))
				goto OUT_OF_LOOP;
		}

		dir_offset ++;
	}
	goto FAILURE;
	OUT_OF_LOOP:
	printf("%d %d\n", dir_offset, entry_offset);
	printf("%s\n", dir.entries[entry_offset].filename);
	printf("%d\n", dir.entries[entry_offset].file_size);
	int i=0;
	readINode(dir.entries[entry_offset].inode_offset);
	for(i=0; i<NR_BLOCKS; i++){
		if(inode.data_block_offsets[i] == 0xFFFFFFFF)
			break;
		//printf("%d\n", inode.data_block_offsets[i]);
		readData(inode.data_block_offsets[i]);
		//printf("%s", buffer);
	}
	fclose(disk);
	return 0;
	FAILURE:
	printf("Such a file doesn't exist!\n");
	return 0;
}