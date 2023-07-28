/**
 * @file win32_getlocale.cpp
 * @author ChenPi11
 * @brief Get Win32 loclae.
 * @version 0.0.1
 * @date 2023-7-24
 * @copyright Copyright (C) 2023 The C++ Plus Project
 */
/* Copyright (C) 2023 The C++ Plus Project.
   This file is part of the build-aux library.

   The build-aux library is free software; you can redistribute it
   and/or modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either version 3
   of the License, or (at your option) any later version.

   The build-aux library is distributed in the hope that it will be
   useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with the build-aux library; see the file COPYING.
   If not, see <https://www.gnu.org/licenses/>.  */

#if defined(_WIN16) || defined(_WIN32) || defined(_WIN64) || defined(__WIN32__) || defined(__TOS_WIN__) || defined(__WINDOWS__)
#define __has_windows__ 1
#else
#define __has_windows__ 0
#endif
#if __has_windows__
#include <Windows.h>
#endif

#include <iostream>
#include <locale.h>
#include <locale>
#include <string.h>

int main()
{
    setlocale(LC_ALL, "en_US.UTF-8");
    std::wcout.imbue(std::locale("en_US.UTF-8"));
#if __has_windows__
    WCHAR locale_name[LOCALE_NAME_MAX_LENGTH] {};
    if (GetUserDefaultLocaleName(locale_name, LOCALE_NAME_MAX_LENGTH) != 0)
    {
        locale_name[2] = L'_';
        std::wcout << locale_name;
    }
    else
    {
        std::wcout << "en_US";
    }
#else
    char* locale_name = getenv("LANG");
    if(locale_name == NULL)
    {
        locale_name = getenv("LANGUAGE");
    }
    if(locale_name == NULL)
    {
        locale_name = getenv("LC_ALL");
    }
    if(locale_name == NULL)
    {
        locale_name = getenv("LC_CTYPE");
    }
    if(locale_name == NULL)
    {
        locale_name = getenv("LC_MESSAGES");
    }
    if(locale_name == NULL)
    {
        locale_name = const_cast<char*>("en_US.UTF-8");
    }
    for(size_t i = 0; i < strlen(locale_name); i++)
    {
        if(locale_name[i] == '.')
        {
            locale_name[i] = '\0';
            break;
        }
    }
    std::cout << locale_name;
#endif

    return 0;
}
