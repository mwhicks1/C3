LEVEL = ../../..
PROJ_SRC_DIR = .

SOURCES = args.c newbh.c util.c walksub.c
C3_HDRS = $(addprefix conv/,code.h defs.h stdinc.h vectmath.h)
C3_SOURCES = $(addprefix conv/,$(SOURCES))
OBJS = $(SOURCES:.c=.o)
C3_OBJS = $(C3_SOURCES:.c=.o)
PROG     = bh
C3_PROG = $(PROG)_c3

CFLAGS = -I.. -fcommon -DTORONTO
LDFLAGS  = -lm
C3 = ../../../_build/default/src/main.exe

ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 40000 30
else
ifdef SMALL_PROBLEM_SIZE
RUN_OPTIONS = 2000 5
else
RUN_OPTIONS = 20000 20
endif
endif
OUTPUT = bh.reference_output

.PRECIOUS: conv/%.c

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

$(C3_PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): $(C3_HDRS)

conv/%.c: %.c
	$(C3) -f $^ > $@

conv/%.h: %.h
	$(C3) -f $^ > $@

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(C3_SOURCES) $(C3_PROG) $(C3_HDRS) $(PROG) 

test:
	$(C3_PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO


