# locale.cmake

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
# along with the build-aux; see the file LICENSE.  If not,
# see <https://www.gnu.org/licenses/>.

if(NOT DEFINED LOCALE_LANGUAGE)
    # Read system environment variable.
    set(LOCALE_LANGUAGE "$ENV{LANG}")
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LANGUAGE}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_ALL}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_CTYPE}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_MESSAGES}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_NAME}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_IDENTIFICATION}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_NUMERIC}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_TIME}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_COLLATE}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_MONETARY}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_PAPER}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_ADDRESS}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_TELEPHONE}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "$ENV:{LC_MEASUREMENT}")
    endif()
    if (NOT LOCALE_LANGUAGE MATCHES "^[a-z]{2}_[A-Z]{2}\..{*}")
        set(LOCALE_LANGUAGE "en_US.UTF-8")
    endif()

    # split language and charset.
    string(REGEX REPLACE "([a-z]{2}_[A-Z]{2})\\..*" "\\1" LOCALE_LANGUAGE "${LOCALE_LANGUAGE}")
    string(REGEX REPLACE "[a-z]{2}_[A-Z]{2}\\.(.*)" "\\1" LOCALE_CHARSET "${LOCALE_LANGUAGE}")

    # set language and charset.
    set(LOCALE_LANGUAGE "${LOCALE_LANGUAGE}" CACHE STRING "Language")
    set(LOCALE_CHARSET "${LOCALE_CHARSET}" CACHE STRING "Charset")

    message(STATUS "Detected locale language: ${LOCALE_LANGUAGE}")
    message(STATUS "Detected locale charset: ${LOCALE_CHARSET}")
endif()
