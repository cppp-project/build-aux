#!/usr/bin/env bash

# Copyright (C) 2023 The C++ Plus Project.
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

# C++ Plus Include Language Tools for GNU bash.

# Usage: ./ilang.sh [--help] [--version] [input-file] [language-file] ...
#
# Options:
#   --help              Show this help message.
#   --version           Show the version.

# Get script located directory.
sld="$(cd "$(dirname "$0")" && pwd)"

# Init version info.
PROGRAM_NAME="C++ Plus Include Language Tools"
VERSION="v0.0.1-rc1"
COPYRIGHT="Copyright (C) 2023 The C++ Plus Project."
LICENSE="GPLv3"

# Include Getmessage.
source "$sld/getmsg.sh"

# Autodetect local language and init Getmessage.
LANGDIR="$sld/lang"
LANGFILE="$LANGDIR/$(get_local_language).ilang.gm"
if test -f "$LANGFILE"; then
  load_lang_file "output" "$LANGFILE"
fi
_() {
  get_message "output" "$1"
}

# Print ILang help messages.
# Usage: print_help [return-value]
print_help() {
  text_usage="$(_ "Usage")"
  text_options="$(_ "Options")"
  text_help="$(_ "Show this help message.")"
  text_version="$(_ "Show the version.")"

  echo "$text_usage: $0 [--help] [--version] [input-file] [language-file] ..." >&2
  echo "" >&2
  echo "$text_options:" >&2

  echo "  -h    --help       $text_help" >&2
  echo "  -V    --version    $text_version" >&2

  echo "" >&2
  exit $1 >&2
}

# Print ILang version.
# Usage: print_version
print_version() {
  text_license="$(_ "License")"
  text_license_more="$(_ "GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>")"
  text_nowarranty="$(_ "This is free software; you are free to change and redistribute it."$'\n'"There is NO WARRANTY, to the extent permitted by law.")"
  text_version="$(_ "version")"

  echo "$PROGRAM_NAME, $text_version $VERSION" >&2
  echo "$COPYRIGHT" >&2
  echo "$text_license $LICENSE: $text_license_more"
  echo "" >&2
  echo "$text_nowarranty" >&2
  exit 0
}

# Parse options
while true; do
  case "$1" in
    -h|--help)
      print_help 0
      ;;
    -V|--version)
      print_version
      ;;
    --)
      shift
      break
      ;;
    *)
      break
      ;;
  esac
  shift
done

if [ "$*" = "" ]; then
  print_help 2
fi

input_file="$1"
shift
language_file="$@"

# Test file exists.
if [ "$input_file" = "" ] | [ "$language_file" = "" ]; then
  print_help 2
fi
input_data=$(cat "$input_file") && cat "$language_file" > /dev/null
saved_ret=$?
if [ $saved_ret -ne 0 ]; then
  exit $saved_ret
fi

# Load ILang file
load_lang_file "file" "$language_file"

# Start translation
for i in "${!messages[@]}"; do
  if [[ "$i" == file,* ]]
  then
    msgid="${i#"file,"}"
    input_data="${input_data//"$msgid"/"$(get_message "file" "$msgid")"}"
  fi
done

echo "$input_data"
echo "$(_ "Translation completed"): $input_file" >&2

exit 0
