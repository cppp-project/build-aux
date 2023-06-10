# visibility.cmake
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

# Tests whether the compiler supports the command-line option
# -fvisibility=hidden and the function and variable attributes
# __attribute__((__visibility__("hidden"))) and
# __attribute__((__visibility__("default"))).
# Does *not* test for __visibility__("protected") - which has tricky
# semantics (see the 'vismain' test in glibc) and does not exist e.g. on
# Mac OS X.
# Does *not* test for __visibility__("internal") - which has processor
# dependent semantics.
# Does *not* test for #pragma GCC visibility push(hidden) - which is
# "really only recommended for legacy code".
#

include(CheckCCompilerFlag)

macro(VISIBILITY)
    if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
        # First, check whether -Werror can be added to the command line, or whether it leads to an error because of some other option that the user has put into $CC $CFLAGS $CPPFLAGS.
        check_c_compiler_flag("-Werror" HAVE_WERROR)
        
        # Now check whether visibility declarations are supported.
        check_c_compiler_flag("-fvisibility=hidden" HAVE_VISIBILITY)
        
        if(HAVE_WERROR AND HAVE_VISIBILITY)
            add_compile_options("-fvisibility=hidden")
        endif()
    else()
        set(HAVE_WERROR 0)
        set(HAVE_VISIBILITY 0)
    endif()
endmacro()
