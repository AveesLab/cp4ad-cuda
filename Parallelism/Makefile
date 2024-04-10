CC = g++
CFLAGS = -W -Wall
SRCS = cv-color2gray.cpp
TARGET = cvGray
OPENCV := $(shell pkg-config opencv4 --libs --cflags)
LIBS = $(OPENCV)
$(TARGET):$(SRCS)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS) $(LIBS)

clean:
	rm -f $(OBJECTS) $(TARGET) core
