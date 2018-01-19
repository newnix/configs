NAME = dwmstatus
VERSION = 1.2

# Customize below to fit your system

# paths
PREFIX = /home/mvoight
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# includes and libs
INCS = -I. -I/usr/local/include -I${X11INC}
LIBS = -L/usr/local/lib -lc -L${X11LIB} -lX11

# flags
CPPFLAGS = -DVERSION=\"${VERSION}\" -Oz -fPIC -pie -fstack-protector-all -fstack-protector-strong -ftrapv -ffreestanding -static
CFLAGS = -g -std=c99 -pedantic -Wall -Oz ${INCS} ${CPPFLAGS} -fPIC -pie -fpic -fstack-protector-all -fstack-protector-strong -ftrapv -ffreestanding -static
#CFLAGS = -std=c99 -pedantic -Wall -Os ${INCS} ${CPPFLAGS}
LDFLAGS = -g ${LIBS} -z relro -z now -z combreloc
#LDFLAGS = -s ${LIBS}

# Solaris
#CFLAGS = -fast ${INCS} -DVERSION=\"${VERSION}\"
#LDFLAGS = ${LIBS}

# compiler and linker
CC = clang-devel

