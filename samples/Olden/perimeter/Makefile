PROG     = perimeter
SOURCES = args.c main.c maketree.c
HDRS = perimeter.h

CFLAGS = -DTORONTO
LDFLAGS  = 
C3 = ../../../_build/default/src/main.exe -c

ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 12
else ifdef SMALL_PROBLEM_SIZE
RUN_OPTIONS = 9
else
RUN_OPTIONS = 10
ifeq ($(ARCH),XCore)
XCORE_TARGET_NEEDS_MEMORY := 64
endif
endif
OUTPUT = perimeter.reference_output

include ../../Makefile.common

