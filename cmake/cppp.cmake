# cppp.cmake

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
# along with the build-aux; see the file COPYING.LIB.  If not,
# see <https://www.gnu.org/licenses/>.

# C++ Plus CMake build script.

# Include init.
include("${CMAKE_CURRENT_LIST_DIR}/cppp_init.cmake")

# Other modules.
include("${auxdir}/visibility.cmake")

# Uninstall target define.
if(NOT TARGET uninstall)
    configure_file(
        "${auxdir}/uninstall.cmake.in"
        "${outdir}/uninstall.cmake"
        IMMEDIATE @ONLY )
    add_custom_target(uninstall
        COMMAND ${CMAKE_COMMAND} -P "${outdir}/cmake_uninstall.cmake" )
endif()
