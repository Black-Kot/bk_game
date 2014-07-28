all:
		mkdir -p ./bin/
		g++ -std=gnu++11 ./src/list.cpp ./src/ZlibDecompressor.cpp -I./src/ -lz -lsqlite3 -g  -O2 -o ./bin/list
		g++ -std=gnu++11 ./src/checker.cpp ./src/ZlibDecompressor.cpp -I./src/ -lz -lsqlite3 -g  -O2 -o ./bin/checker
		g++ -std=gnu++11 ./src/save.cpp ./src/ZlibDecompressor.cpp -I./src/ -lz -lsqlite3 -g -O2 -o ./bin/save

clean:
		rm -rf ./bin/

