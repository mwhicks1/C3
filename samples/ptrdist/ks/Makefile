PROJ_SRC_DIR = .

PROG = ks
OBJS = KS-1.o KS-2.o
C3_OBJS = KS-1_c3.o KS-2_c3.o

RUN_OPTIONS += $(PROJ_SRC_DIR)/KL-4.in
OUTPUT = ks.reference_output

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
	$(RM) $(OBJS) $(C3_OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
