# visibility.cmake

# Copyright (C) 2023 The C++ Plus Project.
# This file is part of the build-aux library.
#
# The build-aux is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 3 of the
# License, or (at your option) any later version.
#
# The build-aux is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the build-aux; see the file COPYING.  If not,
# see <https://www.gnu.org/licenses/>.

# Tests whether the compiler supports the command-line option
# -fvisibility=default and the function and variable attributes
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
include(CheckCXXCompilerFlag)

macro(check_have_visibility)
    # Checking for -Werror
    check_c_compiler_flag("-Werror" HAVE_WERROR)
    if(HAVE_WERROR)
        set(CHECK_FLAGS "-Werror -fvisibility=default")
    else()
        set(CHECK_FLAGS "-fvisibility=default")
    endif()

    # Step1: Check for -fvisibility=default
    check_c_compiler_flag("${CHECK_FLAGS}" C_HAVE_VISIBILITY)
    check_cxx_compiler_flag("${CHECK_FLAGS}" CXX_HAVE_VISIBILITY)
    if(C_HAVE_VISIBILITY AND CXX_HAVE_VISIBILITY)
        set(HAVE_VISIBILITY 1)
    else()
        set(HAVE_VISIBILITY 0)
    endif()

    # Step2: Check for __attribute__((__visibility__("default")))
    if(HAVE_VISIBILITY)
        check_c_source_compiles("
            __attribute__((__visibility__(\"default\"))) int foo(void) { return 0; }
            int main(void) { return 0; }
        " C_HAVE_ATTRIBUTE_VISIBILITY)

        check_cxx_source_compiles("
            __attribute__((__visibility__(\"default\"))) int foo(void) { return 0; }
            int main(void) { return 0; }
        " CXX_HAVE_ATTRIBUTE_VISIBILITY)

        if(C_HAVE_ATTRIBUTE_VISIBILITY AND CXX_HAVE_ATTRIBUTE_VISIBILITY)
            set(HAVE_VISIBILITY 1)
        else()
            set(HAVE_VISIBILITY 0)
        endif()
    endif()

    unset(HAVE_WERROR)
    unset(CHECK_FLAGS)
    unset(C_HAVE_VISIBILITY)
    unset(CXX_HAVE_VISIBILITY)
    unset(C_HAVE_ATTRIBUTE_VISIBILITY)
    unset(CXX_HAVE_ATTRIBUTE_VISIBILITY)
endmacro()
