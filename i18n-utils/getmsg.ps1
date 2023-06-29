#!/usr/bin/env pwsh

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
# License along with the util-i18n Library; see the file COPYING.LIB.
# If not, see <https://www.gnu.org/licenses/>.

# C++ Plus Getmessage tools for PowerShell.

# Messages areas root.
$messages = @{}

# Load messages from language file.
# Usage: LoadLanguageFile(message-area, file-path)
function LoadLanguageFile($message_area, $file_path) {
    $state = ""
    $id = ""
    $content = ""

    Get-Content -Path $file_path | ForEach-Object {
        # Ignore notes and empty line.
        if ($_ -match '^\s*#|^$') {
            return
        }

        # Switch state to 'Reading ID'.
        if ($_ -eq "'''") {
            if ($state -eq "") {
                $state = "id"
            }
            elseif ($state -eq "id") {
                $state = "content"
            }
            elseif ($state -eq "content") {
                # Save content and state into messages and clear temp.
                if ($null -eq $messages[$message_area]) {
                    # Message area not exists, create it.
                    $messages[$message_area] = @{}
                }
                $messages[$message_area][$id.Trim()] = $content.Trim()
                $state = ""
                $content = ""
                $id = ""
            }
            return
        }

        if ($state -eq "id") {
            $id += $_ + "`n"
        }
        elseif ($state -eq "content") {
            $content += $_ + "`n"
        }

        # Check syntax errors.
        if ($state -eq "" -and $_.Trim() -ne "") {
            Write-Warning "There is content that is not within the message unit：$($_.Trim())"
        }
    }
}

# Get message form Message ID to stdout, if not exists, print Message ID.
# Usage: GetMessage(message-area, message-id) -> MESSAGE_CONTENTS_OR_MESSAGE_ID
function GetMessage($message_area, $message_id) {
    $ma = $messages[$message_area]
    if ($null -eq $ma) {
        # Message Area not exists, return Message ID.
        return $message_id
    }
    $msg = $ma[$message_id]
    if ($null -eq $msg) {
        # Message ID not exists, return it.
        return $message_id
    }
    else {
        # Message ID exists, return Message Contents.
        return $msg
    }
}

# Get local language name.
# Usage: GetLocalLanguage -> LOCAL_LANGUAGE_NAME
function GetLocalLanguage() {
    $language = (Get-Culture).Name
    return $language.Replace("-","_")
}
