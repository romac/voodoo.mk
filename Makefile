
# OS X only for now, sorry.

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

all: $(EXEC) $(DYLIB)

run: exec
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
	rm -rf $(TEST_BIN)
	rm -rf $(DIR_BUILD_OBJ)/*.o
	rm -rf $(DIR_BUILD_LIB)/*.dylib
	rm -rf $(DIR_BUILD_OBJ_LIB)/*.o

init:
	mkdir -p $(DIRS)

.PHONY: all run test clean install init

# Don't remove .o
.SECONDARY: $(wildcard ./build/obj/**/*.o)
