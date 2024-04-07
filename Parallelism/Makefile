CC = g++
CFLAGS = -W -Wall
SRCS = color2gray.cpp
TARGET = simple
OPENCV := $(shell pkg-config opencv4 --libs --cflags)
LIBS = $(OPENCV)
$(TARGET):$(SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS) $(LIBS)

clean:
	rm -f $(OBJECTS) $(TARGET) core
