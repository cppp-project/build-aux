# eilseq.cmake
# Copyright (C) 2023 The C++ Plus Project.
# This file is part of the cppp library, it is based on GNU LIBICONV.
#
# The cppp is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# The cppp is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with the cppp; see the file COPYING.LIB.  If not,
# see <https://www.gnu.org/licenses/>.

# The EILSEQ errno value ought to be defined in <errno.h>, according to
# ISO C 99 and POSIX.  But some systems (like SunOS 4) don't define it,
# and some systems (like BSD/OS) define it in <wchar.h> not <errno.h>.

# Define EILSEQ as a C macro and as a substituted macro in such a way that
# 1. on all systems, after inclusion of <errno.h>, EILSEQ is usable,
# 2. on systems where EILSEQ is defined elsewhere, we use the same numeric
#    value.

include(CheckCSourceCompiles)
include(CheckIncludeFile)
include(CheckSymbolExists)

macro(EILSEQ)
    check_include_file("wchar.h" HAVE_WCHAR_H)
    if(HAVE_WCHAR_H)
        set(EXTRA_HEADERS "-I\${CMAKE_CURRENT_SOURCE_DIR}")
    endif()

    check_c_source_compiles("
    #include <errno.h>
    #ifdef EILSEQ
    #error \"EILSEQ is defined by the system.\"
    #else
    #define EILSEQ ENOENT
    #endif
    int main(){}" HAVE_EILSEQ)
    if (NOT HAVE_EILSEQ)
        check_symbol_exists(EILSEQ "errno.h" HAVE_EILSEQ)
        if (NOT HAVE_EILSEQ)
            check_symbol_exists(EILSEQ "wchar.h" HAVE_EILSEQ)
            if (HAVE_EILSEQ)
                check_c_source_compiles("
                #ifdef EILSEQ
                int main(){return EILSEQ;}
                #else
                #error \"EILSEQ not defined\"
                #endif" EILSEQ_VALUE)
                set(EILSEQ ${EILSEQ_VALUE})
            else()
                set(EILSEQ ENOENT)
            endif()
        endif()
    endif()
endmacro()
