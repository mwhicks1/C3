PROG = anagram
SOURCES = anagram.c
HDRS =

RUN_OPTIONS = words 2
STDIN_FILENAME = input.OUT

CFLAGS =
LDFLAGS =

C3 = ../../../_build/default/src/main.exe

NOTEST = yes

include ../../Makefile.common

# overrides common one
test:  $(PROG) $(C3_PROG)
	./$(PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > ACTUAL_OUTPUT 2>&1
	diff -w anagram.reference_output ACTUAL_OUTPUT
	$(RM) ACTUAL_OUTPUT
	./$(C3_PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > ACTUAL_OUTPUT 2>&1
	diff -w anagram.reference_output ACTUAL_OUTPUT
	$(RM) ACTUAL_OUTPUT
