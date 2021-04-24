PROJ_SRC_DIR = .

SOURCES = assign.c hcg.c maze.c vcg.c channel.c main.c option.c
C3_HDRS = $(addprefix conv/,assign.h hcg.h option.h vcg.h channel.h maze.h types.h)
C3_SOURCES = $(addprefix conv/,$(SOURCES))
OBJS = $(SOURCES:.c=.o)
C3_OBJS = $(C3_SOURCES:.c=.o)
PROG = yacr2
C3_PROG = $(PROG)_c3

RUN_OPTIONS += $(PROJ_SRC_DIR)/input2.in
OUTPUT = OUT

.PRECIOUS: conv/%.c

C3 = ../../../_build/default/src/main.exe
CFLAGS = -I.. -DTODD

all: test

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

$(C3_PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 

$(C3_OBJS): $(C3_HDRS)

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

conv/%.c: %.c
	$(C3) -f $^ > $@

conv/%.h: %.h
	$(C3) -f $^ > $@

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(C3_SOURCES) $(C3_PROG) $(C3_HDRS) $(PROG) 

test: $(PROG) $(C3_PROG)
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
	$(C3_PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
