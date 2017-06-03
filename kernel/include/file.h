#ifndef _FILE_H_
#define _FILE_H_
#include "common.h"

#define LEN_FILENAME 24
#define BLOCK_SIZE 	512
#define NR_ENTRIES BLOCK_SIZE / sizeof(struct dirent)
#define NR_BLOCKS BLOCK_SIZE / sizeof(uint32_t)
#define SC_BOOTLOADER	1
#define SC_BITMAP	256
#define SC_DIR		256
#define SC_INODE	256
#define SC_DATA		512/4*SC_INODE
#define LOC_BOOTLOADER() 	(0)
#define LOC_BITMAP()		(1)
#define	LOC_DIR(x)			((1+256+(x)))
#define	LOC_INODE(x)		((1+256+SC_DIR+(x)))
#define	LOC_DATA(x)			((1+256+SC_DIR+SC_INODE+(x)))

#pragma pack(0)
/*
+------------+--------+-------+-------+-------+-------+-------+
| bootloader | bitmap |  dir  | inode | data  |  ...  |  ...  |
+------------+--------+-------+-------+-------+-------+-------+
512B		  128KB    
1 SC          256 SC   1SC per 1SC per 1SC  per
5120000/512 = 10000
*/
struct inode {
  uint32_t data_block_offsets[NR_BLOCKS];
};

struct dirent {
  char     filename[LEN_FILENAME];
  uint32_t file_size;
  uint32_t inode_offset;
};  // sizeof(struct dirent) == 32

struct dir {
  struct dirent entries[NR_ENTRIES];
};  // sizeof(dir) == 512, nr_entries == 16

struct bitmap {
  uint8_t mask[512 * 256];  // 512B ~ 2MB
};
#pragma pack()

void init_fs();

typedef struct{
	struct inode inode;
	uint32_t offset;
	uint32_t inode_offset;
	uint32_t file_size;
	char filename[LEN_FILENAME];
	uint8_t buffer[BLOCK_SIZE];
	char used;
} FILE_STREAM;

#define NR_FILE_STREAM 256
#endif