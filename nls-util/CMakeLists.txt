# Copyright (C) 2023 The C++ Plus Project.
# This file is part of the build-aux Library.
#
# The build-aux Library is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# The build-aux Library is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the build-aux Library; see the file COPYING.
# If not, see <https://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.5)
project(nls-util LANGUAGES CXX
        VERSION 0.0.1
        DESCRIPTION "C++ Plus NLS util."
        HOMEPAGE_URL "https://github.com/cppp-project/build-aux" )

include_directories("${CMAKE_CURRENT_SOURCE_DIR}/src")
add_executable(nls-util "${CMAKE_CURRENT_SOURCE_DIR}/src/nls-util.cpp" )
set_target_properties(nls-util PROPERTIES
                      RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin" )

install(TARGETS nls-util
        )
