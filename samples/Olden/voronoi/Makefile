PROG     = voronoi
SOURCES = args.c newvor.c output.c vector.c
HDRS = defines.h

CFLAGS = -DTORONTO
LDFLAGS  = -lm
C3 = ../../../_build/default/src/main.exe

ifdef LARGE_PROBLEM_SIZE
RUN_OPTIONS = 10000000 20 32 7
else
ifdef SMALL_PROBLEM_SIZE
RUN_OPTIONS = 10000 20 32 7
else
RUN_OPTIONS = 100000 20 32 7
ifeq ($(ARCH),XCore)
XCORE_TARGET_NEEDS_MEMORY := 64
endif
endif
endif
OUTPUT = OUT

include ../../Makefile.common

