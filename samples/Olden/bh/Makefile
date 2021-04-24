LEVEL = ../../..
PROJ_SRC_DIR = .

OBJS = args.o newbh.o util.o walksub.o
C3_OBJS = $(addprefix conv/,$(OBJS))
PROG     = bh

CFLAGS = -I.. -fcommon -DTORONTO
LDFLAGS  = -lm
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

CHKCTOOLS = ~/checkedc/checkedc-clang/clang/tools/3c

ifdef C3
$(PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) $(LDFLAGS) 
else
$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS) 
endif

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): $(addprefix conv/,code.h defs.h stdinc.h vectmath.h)

conv/%.c: %.c
	(P=$$PWD; \
	cd $(LEVEL); \
	./C3 $$P $^ $(CC) $(CHKCTOOLS) $(CFLAGS) > $$P/$@)

conv/%.h: %.h
	(P=$$PWD; \
	cd $(LEVEL); \
	./C3 $$P $^ $(CC) $(CHKCTOOLS) $(CFLAGS) > $$P/$@)

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO


