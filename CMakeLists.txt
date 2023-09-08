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
project(build-aux LANGUAGES C CXX
        VERSION 1.0.0
        DESCRIPTION "C++ Plus build-aux package"
        HOMEPAGE_URL "https://github.com/cppp-project/build-aux" )

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/cppp.cmake")

# Build NLS Util
set(NLS_UTIL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/nls-util")
set(NLS_UTIL_BINDIR "${CMAKE_CURRENT_BINARY_DIR}/nls-util-bindir")
set(NLS_UTIL_INSTDIR "${CMAKE_CURRENT_BINARY_DIR}/nls-util")
file(MAKE_DIRECTORY "${NLS_UTIL_BINDIR}")

add_custom_target( build-nls-util ALL
                   COMMAND "${CMAKE_COMMAND}" "${NLS_UTIL_DIR}" "-DCMAKE_INSTALL_PREFIX=\"${NLS_UTIL_INSTDIR}\""
                   COMMAND "${CMAKE_COMMAND}" "--build" "${NLS_UTIL_BINDIR}" "--config=Release"
                   COMMAND "${CMAKE_COMMAND}" "--install" "${NLS_UTIL_BINDIR}" "--config=Release"
                   WORKING_DIRECTORY "${NLS_UTIL_BINDIR}"
                   COMMENT "Building 'nls-util' ...")

# Import NLS Util.
cppp_import_nls_util("${cmakeaux_dir}/../nls-util")
