PROJ_SRC_DIR = .

PROG = ks
OBJS = KS-2.o KS-1.o 
C3_OBJS = conv/KS-2.o conv/KS-1.o 

RUN_OPTIONS += $(PROJ_SRC_DIR)/KL-4.in
OUTPUT = ks.reference_output

C3 = ../../../_build/default/src/main.exe
CFLAGS = -I..

ifdef DOC3
$(PROG): $(C3_OBJS)
	$(CC) -o $@ $(C3_OBJS) 
else
$(PROG): $(OBJS)
	$(CC) -o $@ $(OBJS) 
endif

conv/%.c: %.c
	$(C3) -f $^ > $@

conv/%.h: %.h
	$(C3) -f $^ > $@

.c.o:
	$(CC) -c $*.c $(CFLAGS) $(IFLAGS) -o $@

$(C3_OBJS): conv/KS.h

clean:
	$(RM) $(OBJS) $(C3_OBJS) $(PROG) 

test:
	$(PROG) $(RUN_OPTIONS) > FOO 2>&1
	diff -w $(OUTPUT) FOO
	$(RM) FOO
