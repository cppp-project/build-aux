#!/usr/bin/env python3

# Copyright (C) 2023 The C++ Plus Project.
# This file is part of the build-aux Library.
#
# The build-aux Library is free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# The build-aux Library is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with the build-aux Library; see the file COPYING.
# If not, see <https://www.gnu.org/licenses/>.

# Update m4 scripts and autoconf scripts

import os
import shutil
import logging
import sys
import git
import git.remote

cwd = os.getcwd()

stream_handler = logging.StreamHandler(sys.stderr)
stream_handler.setLevel(logging.DEBUG)


formatter = logging.Formatter("[%(levelname)s %(name)s %(asctime)s] %(message)s")
stream_handler.setFormatter(formatter)

def get_logger(name:str):
    log = logging.getLogger(name)
    log.setLevel(logging.DEBUG)
    log.addHandler(stream_handler)
    return log

class ProgressPrinter(git.RemoteProgress):
    
    def __init__(self, log:logging.Logger, *args, **kwargs):
        self.log = log
        super().__init__(*args , **kwargs)
    
    def update(self, op_code, cur_count, max_count=None, message=''):
        if isinstance(max_count, float):
            pgs = str(int((cur_count / max_count)*100)) + "%"
            if op_code & self.COMPRESSING:
                self.log.info(f"Compressing: {pgs} {message}")
            elif op_code & self.RECEIVING:
                self.log.info(f"Receiving: {pgs} {message}")
            elif op_code & self.RESOLVING:
                self.log.info(f"Resolving: {pgs} {message}")
            else:
                self.log.debug(f"Unknown operate: {op_code} {pgs} {message}")

def clone(repository:str):
    log = get_logger("GIT")
    log.info(f"Cloning repository {repository} ...")
    
    url = f"https://git.savannah.gnu.org/git/{repository}.git"
    to_path = os.path.join(cwd, repository)
    if os.path.exists(to_path):
        shutil.rmtree(to_path)
    log.debug(f"Cloning \"{url}\" into \"{to_path}\" ...")
    return git.Repo.clone_from(url, to_path, progress = ProgressPrinter(log))

def build(dir:str, prefix:str):
    os.chdir(dir)
    if os.path.exists("bootstrap"):
        assert os.system("./bootstrap") == 0
    if os.path.exists("autogen.sh"):
        assert os.system("./autogen.sh") == 0
    assert os.system(f"./configure --prefix={os.path.abspath(prefix)}") == 0
    assert os.system("make -j") == 0
    assert os.system("make install -j") == 0
    os.chdir(cwd)

def copy_from(fromfile:str, todir:str):
    log = get_logger("FILE")
    log.info(f"Copying file \"{os.path.basename(fromfile)}\"")
    shutil.copyfile(fromfile, os.path.join(todir,os.path.basename(fromfile)))

clone("automake")
clone("libtool")

build("automake", os.path.join(cwd, "build"))
build("libtool", os.path.join(cwd, "build"))

copy_from("build/share/automake-1.16/ar-lib", "autoconf")
copy_from("build/share/automake-1.16/compile", "autoconf")
copy_from("build/share/automake-1.16/config.guess", "autoconf")
copy_from("build/share/automake-1.16/config.sub", "autoconf")
copy_from("build/share/automake-1.16/install-sh", "autoconf")
copy_from("build/share/automake-1.16/missing", "autoconf")
copy_from("build/share/automake-1.16/mkinstalldirs", "autoconf")
copy_from("build/share/libtool/build-aux/ltmain.sh", "autoconf")
