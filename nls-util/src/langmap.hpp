/**
 * @file langmap.hpp
 * @author ChenPi11
 * @brief C++ Plus NLS util language map parser.
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

#include <iostream>
#include <map>
#include <string>
#include <vector>
#include <fstream>
#include <algorithm>

/**
 * @brief Messages translate domain.
 */
typedef std::map<std::string, std::string> Domain;

/**
 * @brief Messages pool.
*/
std::map<std::string, Domain> messages;

/**
 * @brief Load a C++ Plus NLS Util language map file.
 * @param path File path.
 * @param domain The domain that data will be saved.
 * @throw Call exit() when file open error.
*/
void load_file(const std::string& path, const std::string& domain)
{
    size_t line_count = 0;
    size_t loaded_count = 0;
    unsigned char status = 0;// 0 : close, 1 : key, 2 : content
    std::ifstream file;
    std::string line;
    std::string key_buffer;
    std::string content_buffer;
    file.open(path);
    if(file.good())
    {
        // Loading nls file.
        while (std::getline(file, line))
        {
            line_count++;
            if(line.size() || status)
            {
                if(line[0] == '#' && (!status)) // Skip notes when it is not in text area
                {
                    continue;
                }
                else if(line == "'''") // 
                {
                    // status : 0 <= status <= 2.
                    if((++status) == 3)
                    {
                        status = 0; // Reset status to 'close'.
                        // Save buffer and clear it.
                        messages[domain] [key_buffer] = content_buffer;
                        key_buffer = "";
                        content_buffer = "";
                        loaded_count++;
                    }
                }
                else if(status) // contents
                {
                    if(status == 1) // key
                    {
                        key_buffer = key_buffer + ((key_buffer.size()) ? "\n" : "") + line ;
                    }
                    else // content
                    {
                        content_buffer = content_buffer + ((content_buffer.size()) ? "\n" : "") + line;
                    }
                }
                else // Syntax error?
                {
                    std::cerr << "WARNING: " << path << ":" << line_count << " : Syntax error in this line.\n";
                }
            }
        }
        if(status)
        {
            std::cerr << "WARNING: A token never closed.\n";
        }
        std::cerr << path << ": Loaded " << loaded_count << " messages.\n";
    }
    else
    {
        int saved_errno = errno;
        perror(path.c_str());
        exit(saved_errno);
    }
}

/**
 * @brief Get message in a domain.
 * @param key Message key.
 * @param domain Message domain.
 * @param default_value="" Default value when the key not found.
 * @return Message content.
 * @throw std::invalid_argument when domain invalid.
 * @throw std::invalid_argument when key invalid and default_value is null.
*/
std::string get_message(const std::string& key, const std::string& domain, const std::string& default_value="")
{
    auto domain_iterator = messages.find(domain);
    if ( domain_iterator == messages.end())
    {
        throw std::invalid_argument("Invalid domain '" + domain + "'");
    }
    else
    {
        Domain domain_unit = domain_iterator -> second;
        auto unit_iterator = domain_unit.find(key);
        if(unit_iterator == domain_unit.end())
        {
            if(!default_value.size())
            {
                throw std::invalid_argument("Invalid key '" + key + "'");
            }
            return default_value;
        }
        else
        {
            return unit_iterator -> second;
        }
    }
}

/**
 * @brief List message in a domain.
 * @param domain Message domain.
 * @throw std::invalid_argument when domain invalid.
*/
std::vector<std::string> list_messages(const std::string& domain)
{
    auto domain_iterator = messages.find(domain);
    if ( domain_iterator == messages.end())
    {
        return {};
    }
    else
    {
        std::vector<std::string> keys;
        Domain domain_unit = domain_iterator -> second;
        for (auto it = domain_unit.begin(); it != domain_unit.end(); ++it)
        {
            keys.push_back(it->first);
        }
        return keys;
    }
}
