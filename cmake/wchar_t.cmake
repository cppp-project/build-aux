# wchar_t.cmake
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

# Test whether <stddef.h> has the 'wchar_t' type.

include(CheckTypeSize)

macro(TYPE_WCHAR_T)
    check_type_size(wchar_t HAVE_WCHAR_T)
endmacro()
