#!/usr/bin/env bash

# Copyright (C) The C++ Plus Project.
# This file is part of the util-i18n Library.
#
# The util-i18n Library is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# The util-i18n Library is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with the util-i18n Library; see the file COPYING.
# If not, see <https://www.gnu.org/licenses/>.

# C++ Plus Getmessage tools for GNU bash.

# Messages areas root.
declare -A messages

# Output a stripped string.
# Usage: str_strip [string]
str_strip() {
  trimmed=$(echo "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  
  # Output result
  echo "$trimmed"
}

# Load messages from language file.
# Usage: load_lang_file [message-area] [file-path]
load_lang_file() {
  state=""
  id=""
  content=""

  while read -r line; do
    # Ignore notes and null line.
    if [[ "$line" =~ ^\s*# ]] || [[ "$line" =~ ^\s*$ ]]; then
      continue
    fi

    # Switch state to 'Reading ID'.
    if [[ "$line" = "'''" ]]; then
      if [[ "$state" == "" ]]; then
        state="id"
      elif [[ "$state" == "id" ]]; then
        state="content"
      elif [[ "$state" == "content" ]]; then
        # Save content and state into messages and clear temp.
        stripped_id=$(str_strip "$id")
        stripped_content=$(str_strip "$content")
        messages["$1","$stripped_id"]="$stripped_content"
        state=""
        content=""
        id=""
      fi
      continue
    fi

    if [[ "$state" == "id" ]]; then
      id+="$line"$'\n'
    elif [[ "$state" == "content" ]]; then
      content+="$line"$'\n'
    fi

    # Check syntax errors.
    if [[ "$state" == "" ]] && [[ "$line" != "" ]]; then
      echo "WARNING: There is content that is not within the message unit：$line" >&2
    fi
  done <"$2"
}

# Print message form Message ID to stdout, if not exists, print Message ID.
# Usage: get_message [message-area] [message-id]
get_message() {
  msg="${messages[$1,$2]}"
  if [ -z "$msg" ]; then
    # Message ID not exists, print it.
    echo "$2"
  else
    # Message ID exists, print Message Contents.
    echo "$msg"
  fi
}

# Print local language name.
# Usage: get_local_language
get_local_language() {
  language=$(locale | grep "LANG=" | cut -d "=" -f 2)
  echo "${language%%.*}"
}
