# Copyright (c) 2003 Maxim Sobolev <sobomax@FreeBSD.org>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
# $Id: Makefile,v 1.3 2004/07/19 05:19:55 sobomax Exp $
#
# Linux Makefile by Matt Smith <mcs@darkregion.net>, 2011/01/04
# Switch to NetBSD version by 12101111 <w12101111@outlook.com>, 2021/04/15

CC ?= cc
AR ?= ar
EXECINFO_CFLAGS=$(CFLAGS) -std=gnu99 -c '-D__RCSID(a)=' -D_GNU_SOURCE '-D__printflike(a,b)='
EXECINFO_LDFLAGS=$(LDFLAGS)

objects = backtrace.o symtab.o unwind.o

all: static dynamic

backtrace.o: backtrace.c execinfo.h symtab.h
	$(CC) $(EXECINFO_CFLAGS) $(EXECINFO_LDFLAGS) backtrace.c

symtab.o: symtab.c symtab.h
	$(CC) $(EXECINFO_CFLAGS) $(EXECINFO_LDFLAGS) symtab.c

unwind.o: unwind.c execinfo.h
	$(CC) $(EXECINFO_CFLAGS) $(EXECINFO_LDFLAGS) unwind.c

static: $(objects)
	$(AR) rcs libexecinfo.a $(objects)

dynamic: $(objects)
	$(CC) -shared -Wl,-soname,libexecinfo.so.1 -o libexecinfo.so.1 $(objects) -lelf -lunwind

clean:
	rm -rf *.o *.a *.so
