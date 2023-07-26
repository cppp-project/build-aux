/**
 * @file nls-util.cpp
 * @author ChenPi11
 * @brief C++ Plus NLS util.
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

#if _MSC_VER >= 1600 
#pragma execution_character_set("utf-8") 
#endif

#include "langmap.hpp"

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>

/**
 * @brief NLS Util main domain's name.
*/
constexpr auto MAIN_DOMAIN = "main";

/**
 * @brief Read all data in a file to a string.
 * @param file_path Input file path.
 * @return Data in the file.
 * @throw Call `abort()` when file open error.
*/
std::string readall(const std::string& file_path)
{
    std::ifstream file(file_path);
    std::stringstream buffer;
    
    if (file)
    {
        buffer << file.rdbuf();
    }
    else
    {
        perror(file_path.c_str());
        abort();
    }
    
    std::string result = buffer.str();
    file.close();
    return result;
}

/**
 * @brief Truncate output file and write data in it.
 * @param file_path Output file path.
 * @param data The data you want to write in it.
 * @throw Call `abort()` when open file error.
*/
void writeall(const std::string& file_path, const std::string& data)
{
    std::ofstream output_file(file_path, std::ios::trunc);
    if(output_file)
    {
        output_file.write(data.data(), data.size());
        output_file.flush();
        output_file.close();
    }
    else
    {
        perror(file_path.c_str());
        abort();
    }
}

/**
 * @brief Replace A to B in a string.
 * @param src Source string.
 * @param from Substring A.
 * @param to Substring B.
*/
void replace(std::string& src, const std::string& from, const std::string& to)
{
    std::string::size_type pos = 0;
    while((pos = src.find(from, pos)) != std::string::npos)
    {
        src.replace(pos, from.size(), to);
        pos += to.size();
    }
}

/**
 * @brief Input file path.
*/
std::string input_file_path;

/**
 * @brief Output file path.
*/
std::string output_file_path;

/**
 * @brief Language map file path.
*/
std::string lang_map_file_path;

// Usage: nls-util input-file output-file language-map-file
int main(int argc, char* argv[])
{
    if(argc < 4)
    {
        std::cerr << "Usage: " << argv[0] << " input-file output-file language-map-file\n";
        return 1;
    }

    input_file_path = argv[1];
    output_file_path = argv[2];
    lang_map_file_path = argv[3];

    try
    {
        load_file(lang_map_file_path, MAIN_DOMAIN);
        auto msgs = list_messages(MAIN_DOMAIN);
        
        std::string data;
        data = readall(input_file_path);
        size_t replaced_count = 0;
        for(auto& msg : msgs)
        {
            replace(data, msg, get_message(msg, MAIN_DOMAIN, msg));
            replaced_count++;
        }
        writeall(output_file_path, data);
        std::cerr << output_file_path << ": Successfully replaced " << replaced_count << " positions.\n";
        return 0;
    }
    catch(const std::exception& e)
    {
        std::cerr << e.what() << "\n";
        return 1;
    }
}
