#include "file.h"
#include "string.h"
#define SECT_SIZE 512

struct bitmap bitmap;
struct inode inode;
struct dir dir;
uint8_t buffer[SECT_SIZE];
int main(){
	FILE *bootloader = fopen("boot.bin", "r");
	fread(buffer, 1, SECT_SIZE, bootloader);
	fclose(bootloader);

	FILE *disk = fopen("disk.bin", "wb");
	fwrite(buffer, 1, SECT_SIZE, disk);

	unsigned int count = 0;
	memset(bitmap.mask, 0, sizeof(bitmap.mask));
	for(count = 0; count < SC_BITMAP; count++){
		fwrite((uint8_t*)bitmap.mask+(count<<9), 1, SECT_SIZE, disk);
	}
	for(count = 0; count < SC_DIR; count++){
		int j=0;
		for(j=0; j<NR_ENTRIES; j++){
			struct dirent* entry = &dir.entries[j];
			entry->inode_offset = -1;
		}
		fwrite((uint8_t*)dir.entries, 1, SECT_SIZE, disk);
	}
	for(count = 0; count < SC_INODE; count++){
		fwrite((uint8_t*)inode.data_block_offsets, 1, SECT_SIZE, disk);
	}
	memset(buffer, 0, SECT_SIZE);
	for(count = 0; count < SC_DATA; count++){
		fwrite(buffer, 1, SECT_SIZE, disk);
	}
	fclose(disk);
	return 0;
}