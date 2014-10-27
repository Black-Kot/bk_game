CC=g++
CFLAGS=-Wall -Wextra -std=c++11
LDFLAGS=-I./src/ -lz -lsqlite3 -g
CHECKER_SOURCES=./src/checker.cpp ./src/ZlibDecompressor.cpp
CHECKER_OBJECTS=$(CHECKER_SOURCES:.c=.o)
CHECKER_EXECUTABLE=./bin/checker

LIST_SOURCES=./src/list.cpp ./src/ZlibDecompressor.cpp
LIST_OBJECTS=$(LIST_SOURCES:.c=.o)
LIST_EXECUTABLE=./bin/list

SAVE_SOURCES=./src/save.cpp ./src/ZlibDecompressor.cpp
SAVE_OBJECTS=$(SAVE_SOURCES:.c=.o)
SAVE_EXECUTABLE=./bin/save
all:
	@mkdir -p ./bin/
	@${MAKE} checker
	@${MAKE} list
	@${MAKE} save
checker:
	@$(CC) $(CFLAGS) $(CHECKER_SOURCES) $(LDFLAGS) -o $(CHECKER_EXECUTABLE)
list:
	@$(CC) $(CFLAGS) $(LIST_SOURCES) $(LDFLAGS) -o $(LIST_EXECUTABLE)
save:
	@$(CC) $(CFLAGS) $(SAVE_SOURCES) $(LDFLAGS) -o $(SAVE_EXECUTABLE)
clean:
	@rm -rf ./bin/

