#!/usr/bin/env pwsh

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

# C++ Plus Include Language Tools for PowerShell.

# Usage: ./ilang.ps1 [--help] [--version] [input-file] [language-file] ...
#
# Options:
#   --help              Show this help message.
#   --version           Show the version.

# Get script located directory.
$sld = Split-Path -Parent $MyInvocation.MyCommand.Path

# Init version info.
$PROGRAM_NAME = "C++ Plus Include Language Tools"
$VERSION = "v0.0.1-rc1"
$COPYRIGHT = "Copyright (C) 2023 The C++ Plus Project."
$LICENSE = "GPLv3"

# Include Getmessage.
. "$sld/getmsg.ps1"

# Autodetect local language and init Getmessage.
$LANGDIR = "$sld/lang"
$LANGFILE = Join-Path $LANGDIR (GetLocalLanguage)
$LANGFILE += ".ilang.gm"
if (Test-Path $LANGFILE) {
  LoadLanguageFile "output" "$LANGFILE"
}
function _($msgid) {
  GetMessage "output" $msgid
}

# Print ILang help messages.
function PrintHelp($return_value) {
  $text_usage = _("Usage")
  $text_options = _("Options")
  $text_help = _("Show this help message.")
  $text_version = _("Show the version.")

  Write-Host "${text_usage}: ilang.ps1 [--help] [--version] [input-file] [language-file] ..."
  Write-Host ""

  Write-Host "${text_options}:"

  Write-Host "  -h    --help       $text_help"
  Write-Host "  -V    --version    $text_version"

  Write-Host ""
  Exit $return_value
}

# Print ILang version.
function PrintVersion() {
  $text_license = _("License")
  $text_license_more = _("GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>")
  $text_nowarranty = _("This is free software; you are free to change and redistribute it." + "`n" + "There is NO WARRANTY, to the extent permitted by law.")
  $text_version = _("version")

  Write-Host "$PROGRAM_NAME, $text_version $VERSION"
  Write-Host $COPYRIGHT
  Write-Host "$text_license ${LICENSE}: $text_license_more"
  Write-Host ""
  Write-Host $text_nowarranty
  Exit 0
}

# Parse options
$remainingArgs = $args
while ($remainingArgs) {
  $arg = $remainingArgs[0]
  $remainingArgs = $remainingArgs[1..($remainingArgs.Length - 1)]
  if (!$arg.StartsWith("-")) {
    Break
  }
  switch ($arg) {
    "-h" {
      PrintHelp 0
    }
    "--help" {
      PrintHelp 0
    }
    "-V" {
      PrintVersion
    }
    "--version" {
      PrintVersion
    }
    "--" {
      Break
    }
    Default {
      Break
    }
  }
}

if (-not $args -or $args.Length -lt 2) {
  PrintHelp 2
}

$input_file = $args[0]
$language_file = $args[1..($args.Length - 1)]

# Test file exists.
if (-not $input_file -or -not $language_file) {
  PrintHelp 2
}
$input_data = Get-Content "$input_file" -Raw
$null = Get-Content "$language_file" -ErrorAction SilentlyContinue
$saved_ret = $LASTEXITCODE
if ($saved_ret -ne 0) {
  Exit $saved_ret
}

# Load ILang file
LoadLanguageFile "file" "$language_file"

# Start translation
foreach ($msgid in $messages["file"].Keys) {
  $input_data = $input_data -replace "$msgid", (GetMessage "file" "$msgid")
}

Write-Output $input_data
Write-Host $(_ "Translation completed"): $input_file

Exit 0
