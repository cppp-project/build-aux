# nls-util.cmake

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

# Import C++ Plus NLS Util to CMake Build

macro(cppp_import_nls_util path)
    add_subdirectory("${path}")
endmacro()

if(NOT TARGET build_nls)
    add_custom_target(build_nls ALL DEPENDS nls-util/nls-util)
endif()

function(cppp_nls_translate file langmap)
    if(MSVC)
        set(MSVC_BUILDTYPE_PATH "${CMAKE_BUILD_TYPE}/")
    else()
        set(MSVC_BUILDTYPE_PATH "")
    endif()
    set(NLS_UTIL_EXECUTABLE "${CMAKE_BINARY_DIR}/nls-util/bin/${MSVC_BUILDTYPE_PATH}nls-util")

    add_custom_command(TARGET build_nls POST_BUILD
                       COMMAND "${NLS_UTIL_EXECUTABLE}" "${file}" "${file}" "${langmap}"
                       COMMENT "Translating \"${file}\" with langmap file \"${langmap}\" ..." )
endfunction()

macro(cppp_nls_autotranslate file langmaps_directory)
    set(langmap "${langmaps_directory}/${LOCALE_LANGUAGE_NAME}.langmap")
    if(NOT EXISTS "${langmap}")
        set(langmap "${langmaps_directory}/en_US.langmap")
    endif()
    if(EXISTS "${langmap}")
        cppp_nls_translate("${file}" "${langmap}")
    else()
        # langmap not exist, report a warning
        message(WARNING "Language map file '${langmap}' is not exist, C++ Plus NLS Auto Translate will not take effect.")
    endif()
endmacro()
