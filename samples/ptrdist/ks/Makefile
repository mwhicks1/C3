PROJ_SRC_DIR = .

PROG = ks
OBJS = KS-1.o KS-2.o

RUN_OPTIONS += $(PROJ_SRC_DIR)/KL-4.in
OUTPUT = ks.reference_output

CFLAGS = -I..

$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS)

clean:
	$(RM) $(OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
