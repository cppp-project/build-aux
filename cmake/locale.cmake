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

if(NOT DEFINED LOCALE_LANGUAGE_NAME)
    try_run(RUN_RESULT COMPILE_RESULT_VAR
        ${output_bindir} "${cmakeaux_dir}/../tools/getlocale.cpp"
        RUN_OUTPUT_VARIABLE LOCALE_LANGUAGE_NAME )
    unset(COMPILE_RESULT_VAR)

    if(NOT RUN_RESULT EQUAL 0)
        set(LOCALE_LANGUAGE_NAME "en_US")
    endif()
    unset(RUN_RESULT)

    message(STATUS "Detected locale language: '${LOCALE_LANGUAGE_NAME}'")
endif()
