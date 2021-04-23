PROJ_SRC_DIR = .
PROG = anagram
OBJS = anagram.o
C3_OBJS = anagram_c3.o
RUN_OPTIONS = $(PROJ_SRC_DIR)/words 2
STDIN_FILENAME = $(PROJ_SRC_DIR)/input.OUT
LEVEL = ../../..
CHKCTOOLS = ~/checkedc/checkedc-clang/clang/tools/3c

CFLAGS = -I..

ifdef C3
$(PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 
else
$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 
endif

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS)

%_c3.c: %.c
	(P=$$PWD; \
	cd $(LEVEL); \
	./C3 $$P $^ $(CC) $(CHKCTOOLS) $(CFLAGS) > $$P/$@)

clean:
	$(RM) $(OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w anagram.reference_output FOO
	$(RM) FOO
