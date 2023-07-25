# locale.cmake

# Copyright (C) 2023 The C++ Plus Project.
# This file is part of the build-aux library.
#
# The build-aux is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# The build-aux is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with the build-aux; see the file COPYING.  If not,
# see <https://www.gnu.org/licenses/>.

# Get locale infomation.

set(input_string "zh_CN.UTF-8")

string(REGEX MATCH ".*\\." LOCALE_LANGUAGE "$ENV{LANG}")
string(REGEX MATCH "\\..*" LOCALE_CHARSET "$ENV{LANG}")

string(REPLACE "." "" LOCALE_LANGUAGE "${LOCALE_LANGUAGE}")
string(REPLACE "." "" LOCALE_CHARSET "${LOCALE_CHARSET}")

# If locale is invaild, set it to default.
if(NOT LOCALE_LANGUAGE AND NOT LOCALE_CHARSET)
    message(WARNING "Environment $LANG('$ENV{LANG}') is invaild, vaild format is like 'en_US.UTF-8'")    
endif()
if(NOT LOCALE_LANGUAGE)
    set(LOCALE_LANGUAGE "en_US")
endif()
if(NOT LOCALE_CHARSET)
    set(LOCALE_CHARSET "UTF-8")
endif()

message(STATUS "Detected locale language: '${LOCALE_LANGUAGE}', charset: '${LOCALE_CHARSET}'")
