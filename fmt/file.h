#ifndef _FILESTRUCT_H_
#define _FILESTRUCT_H_

#include <stdio.h>
#include <stdlib.h>
#define uint32_t unsigned int
#define uint8_t unsigned char
#define LEN_FILENAME 24
#define BLOCK_SIZE 	512

#define NR_ENTRIES BLOCK_SIZE / sizeof(struct dirent)
#define NR_BLOCKS BLOCK_SIZE / sizeof(uint32_t)
#define SC_BOOTLOADER	1
#define SC_BITMAP	256
#define SC_DIR		256
#define SC_INODE	256
#define SC_DATA		512/4*SC_INODE
#define LOC_BOOTLOADER() 	(0<<9)
#define LOC_BITMAP()		(1<<9)
#define	LOC_DIR(x)			((1+256+(x))*BLOCK_SIZE)
#define	LOC_INODE(x)		((1+256+SC_DIR+(x))*BLOCK_SIZE)
#define	LOC_DATA(x)			((1+256+SC_DIR+SC_INODE+(x))*BLOCK_SIZE)

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
#endif