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
	$(PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w anagram.reference_output FOO
	$(RM) FOO
	$(C3_PROG) $(RUN_OPTIONS) < $(STDIN_FILENAME) > FOO 2>&1
	diff -w anagram.reference_output FOO
	$(RM) FOO
