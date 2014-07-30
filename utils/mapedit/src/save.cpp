#include <cstdlib>
#include <cstdio>
#include <string>
#include <sqlite3.h>
#include <iostream>
#include <unistd.h>

#define MAP_BLOCKSIZE 16

struct pos {
	pos(int _x, int _y, int _z){
		x = _x;
		y = _y;
		z = _z;
	}
pos operator+(int64_t num)
{
	x = x + num;
	y = y + num;
	x = z + num;
    return *this;
}

pos operator-(int64_t num)
{
	x = x - num;
	y = y - num;
	x = z - num;
    return *this;
}
	int64_t x;
	int64_t y;
	int64_t z;
};

int64_t getBlockAsInteger(pos p)
{
	return (uint64_t) p.z * 0x1000000 +
		(uint64_t) p.y * 0x1000 +
		(uint64_t) p.x;
}

int main(int argc, char** argv) {
	if(argc < 9 || argc > 9) {
		std::cout << "Usage:\n/path/to/folder/map /path/to/save/folder/map first_block(as 127 -125 147) last_block(as 127 128 148) " << std::endl;
		exit(1);
	}
	std::string file = std::string(argv[1]);
	if(file.find("/map.sqlite") == std::string::npos)
		file += "/map.sqlite";
	std::string file2 = std::string(argv[2]);
	if(file2.find("/map.sqlite") == std::string::npos)
		file2 += "/map.sqlite";
	pos start = pos(atoi(argv[3]) / MAP_BLOCKSIZE, atoi(argv[4]) / MAP_BLOCKSIZE, atoi(argv[5]) / MAP_BLOCKSIZE);
	pos end = pos(atoi(argv[6]) / MAP_BLOCKSIZE, atoi(argv[7]) / MAP_BLOCKSIZE, atoi(argv[8]) / MAP_BLOCKSIZE);
	start = start - 10;
	end = end + 10;
	pos temp = start;

	std::cout << "from(" << temp.x << " ," << temp.y << " ," << temp.z << " ) to(" << end.x << " ," << end.y << " ," << end.z << " )" << std::endl;
	
	sqlite3 *db;
	if(sqlite3_open(file.c_str(), &db) != SQLITE_OK) {
		std::cout << sqlite3_errmsg(db) << std::endl;
		return 1;
	}

	sqlite3 *save_db;
	sqlite3_open(file2.c_str(), &save_db);

	sqlite3_exec(save_db, "CREATE TABLE IF NOT EXISTS `blocks` (`pos` INT NOT NULL PRIMARY KEY,`data` BLOB)", NULL, NULL, NULL);
	
	while (temp.x < end.x) {
		while (temp.y < end.y) {
			while (temp.z < end.z) {
				int64_t position = getBlockAsInteger(temp);
				sqlite3_stmt *pst = 0;
				sqlite3_prepare_v2(db, "select data from blocks where pos=?", -1, &pst, NULL);
				sqlite3_bind_int64(pst, 1, position);
				sqlite3_step(pst);
				const void* blob = sqlite3_column_blob(pst, 0);
				size_t size_blob = sqlite3_column_bytes(pst, 0);
				if(size_blob > 1) {
					sqlite3_stmt *pst2 = 0;
					sqlite3_prepare_v2(save_db, "insert or replace into blocks values(?, ?);", -1, &pst2, NULL);
					sqlite3_bind_int64(pst2, 1, position);
					sqlite3_bind_blob(pst2, 2, blob, size_blob, NULL);
					sqlite3_step(pst2);
					sqlite3_finalize(pst2);
				}
					
				sqlite3_finalize(pst);
				temp.z++;
			}
			temp.y++;
			temp.z = start.z;
		}
		temp.x++;
		temp.y = start.y;
	}
	
	sqlite3_close(db);
	sqlite3_close(save_db);
	return 0;
	}
