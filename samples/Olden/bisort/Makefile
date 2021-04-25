LEVEL = ../../..

OBJS = args.o bitonic.o
C3_OBJS = $(addprefix conv/,$(OBJS))
PROG     = bisort

CFLAGS = -DTORONTO
LDFLAGS  = -lm

ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 40000000
HASH_PROGRAM_OUTPUT = 1
else
RUN_OPTIONS = 700000
OUTPUT = bisort.reference_output
endif

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

$(C3_OBJS): $(addprefix conv/,node.h proc.h)

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



