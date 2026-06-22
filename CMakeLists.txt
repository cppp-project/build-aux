# Copyright (C) 2023, 2026 The C++ Plus Project.
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
# along with the build-aux Library; see the file LICENSE.
# If not, see <https://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.10)
project(build-aux LANGUAGES C CXX
        VERSION 1.0.0
        DESCRIPTION "C++ Plus build-aux package"
        HOMEPAGE_URL "https://github.com/cppp-project/build-aux" )

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/cppp.cmake")

# Options for building shared and static libraries.
option(ENABLE_SHARED "Enable shared libraries" ON)
option(ENABLE_STATIC "Enable static libraries" ON)

if (NOT ENABLE_SHARED AND NOT ENABLE_STATIC)
    message(FATAL_ERROR "At least one of ENABLE_SHARED and ENABLE_STATIC must be ON.")
endif()

if (BUILD_SHARED_LIBS)
    set(ENABLE_SHARED ON)
else()
    set(ENABLE_STATIC ON)
endif()
