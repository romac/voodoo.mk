
# voodoo.mk (v0.1.0)

# Copyright © 2013 Romain Ruetschi <romain.ruetschi@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
 #
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Change the following variable, with the desired executable name
# Feel also free to change the .dylib name below.
EXEC_NAME = voodoo
LIB_NAME = $(EXEC_NAME).dylib

# You shouldn't need to modify anything below this line,
# except if you don't want to build a shared library.
# By the way, doing so might become optional in the future.

CC = clang
CFLAGS = -Wall -std=c99
LDFLAGS = 

DIR_BUILD = build
DIR_BUILD_BIN = $(DIR_BUILD)/bin
DIR_BUILD_OBJ = $(DIR_BUILD)/obj
DIR_BUILD_LIB = $(DIR_BUILD)/lib
DIR_BUILD_OBJ_LIB = $(DIR_BUILD_OBJ)/lib

DIR_SRC = src
DIR_SRC_INCLUDE = $(DIR_SRC)/include
DIR_LIB = $(DIR_SRC)/lib
DIR_LIB_INCLUDE = $(DIR_LIB)/include

DIR_TEST = test
DIR_TEST_BIN = $(DIR_TEST)/bin
DIR_TEST_INCLUDE = $(DIR_TEST)/lib

DIRS = $(DIR_BUILD) $(DIR_BUILD_BIN) $(DIR_BUILD_OBJ) $(DIR_BUILD_LIB) $(DIR_BUILD_OBJ_LIB) \
		   $(DIR_SRC) $(DIR_SRC_INCLUDE) \
		   $(DIR_LIB) $(DIR_LIB_INCLUDE) \
		   $(DIR_TEST) $(DIR_TEST_BIN) $(DIR_TEST_INCLUDE)

EXEC = $(DIR_BUILD_BIN)/$(EXEC_NAME)
DYLIB = $(DIR_BUILD_LIB)/$(LIB_NAME)
TEST = $(DIR_TEST_BIN)/test

SOURCES = $(wildcard $(DIR_SRC)/*.c)
OBJECTS = $(subst $(DIR_SRC), $(DIR_BUILD_OBJ), $(SOURCES:.c=.o))

LIB_SOURCES = $(wildcard $(DIR_LIB)/*.c)
LIB_OBJECTS = $(subst $(DIR_LIB), $(DIR_BUILD_OBJ_LIB), $(LIB_SOURCES:.c=.o))

all: $(DYLIB) $(EXEC)

run: $(EXEC)
	./$(EXEC)

$(EXEC): $(DYLIB) $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(DIR_BUILD_LIB)/%.dylib: $(LIB_OBJECTS)
	$(CC) $(CFLAGS) -dynamiclib $^ -o $@ $(LDFLAGS)

$(DIR_BUILD_OBJ)/%.o: $(DIR_SRC)/%.c
	$(CC) -I $(DIR_SRC_INCLUDE) -I $(DIR_LIB_INCLUDE) $(CFLAGS) -c $< -o $@

$(DIR_BUILD_OBJ_LIB)/%.o: $(DIR_LIB)/%.c
	$(CC) -I $(DIR_LIB_INCLUDE) $(CFLAGS) -c $< -o $@

test: $(TEST_BIN)
	./$(TEST_BIN)

$(TEST_BIN): $(DYLIB)
	$(CC) $(CFLAGS) -I $(DIR_SRC_INCLUDE) -I $(DIR_LIB_INCLUDE) -I $(DIR_TEST_INCLUDE) \
			  $(DIR_TEST)/*.c $^ -o $@ $(LDFLAGS)

install:
	@echo "ERROR: Not implemented yet"
	@exit 1

clean:
	rm -rf $(TEST)
	rm -rf $(EXEC)
	rm -rf $(DIR_BUILD_OBJ)/*.o
	rm -rf $(DIR_BUILD_LIB)/*.dylib
	rm -rf $(DIR_BUILD_OBJ_LIB)/*.o

init:
	mkdir -p $(DIRS)
ifneq ($(VOODOO_NOKEEP),1)
	$(foreach dir, $(DIRS), touch $(dir)/.keep;) # TODO: change ; to & when on Windows.
endif

.PHONY: all run test clean install init

# Don't remove .o
.SECONDARY: $(wildcard ./build/obj/**/*.o)
