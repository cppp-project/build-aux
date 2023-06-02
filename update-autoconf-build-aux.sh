#!/usr/bin/env sh

# Update autoconf build-aux from automake.git
#
# This script requires curl program in the PATH.

# Copyright (C) 2023 The C++ Plus Project.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Usage: ./update-autoconf-build-aux.sh
# 

FILE_LIST="ar-lib compile config.guess config.sub install-sh"

UPDATE_LIST=

update()
{
    echo "-- Updating $2..."
    mv $3/$2 $3/$2.old
    curl "https://git.savannah.gnu.org/gitweb/?p=$1;a=blob_plain;f=lib/$2;hb=HEAD" > $3/$2 2> /dev/null
    if [ $? -ne 0 ]; then
        echo "-- $3/$2 Update failed."
        mv $3/$2.old $3/$2
        return 0
    fi
    diff $3/$2 $3/$2.old
    if [ "$!" = "" ]; then
        UPDATE_LIST="$UPDATE_LIST $2"
    fi
    rm $3/$2.old
    chmod +x $3/$2
}

# Main
echo "Updating autoconf build-aux scripts..."
rm -f autoconf/*.old

for i in $FILE_LIST
do
    update automake.git $i autoconf
done

COMMIT_MSG="Chore: Update autoconf build scripts:$UPDATE_LIST"

echo "$COMMIT_MSG"

git add .
git commit -m "$COMMIT_MSG"
