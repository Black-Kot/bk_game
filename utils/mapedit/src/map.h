#ifndef MAP_H
#define MAP_H
#include <sqlite3.h>
#include <cstdint>
#include <cstdlib>

struct BlockPos {
	int x;
	int y;
	int z;
};
sqlite3_int64 pythonmodulo(sqlite3_int64 i, sqlite3_int64 mod);
int unsignedToSigned(long i, long max_positive);
uint16_t readU16(const unsigned char *data);
int rgb2int(uint8_t r, uint8_t g, uint8_t b);
int readBlockContent(const unsigned char *mapData, int version, int datapos);
BlockPos decodeBlockPos(sqlite3_int64 blockId);

#endif /* MAP_H */
