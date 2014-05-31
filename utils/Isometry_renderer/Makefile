CC=gcc
CFLAGS=-c -O2
LDFLAGS=-lpng
SOURCES=main.c io.c converters.c render.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=isometry_renderer

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@
