# library.cmake

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

# C++ Plus library utils for CMake

check_have_visibility()

# Import API.
if(WIN32)
    set(CPPP_IMPORT_API "__declspec(dllimport)")
elseif(HAVE_VISIBILITY)
    set(CPPP_IMPORT_API "__attribute__((visibility(\"default\")))")
else()
    set(CPPP_IMPORT_API "")
endif()
add_compile_definitions(CPPP_IMPORT_API=${CPPP_IMPORT_API})

# Export API.
if(WIN32)
    set(CPPP_EXPORT_API "__declspec(dllexport)")
elseif(HAVE_VISIBILITY)
    set(CPPP_EXPORT_API "__attribute__((visibility(\"default\")))")
else()
    set(CPPP_EXPORT_API "")
endif()
add_compile_definitions(CPPP_EXPORT_API=${CPPP_EXPORT_API})

# Build library
macro(cppp_build_library name sources enable_shared enable_static resource_file)
    if(${enable_shared})
        if(MSVC)
            set(RCFILE "${resource_file}")
        else()
            set(RCFILE "")
        endif()
        add_library(lib${name}.shared SHARED ${sources} "${RCFILE}")
        set_target_properties(lib${name}.shared PROPERTIES
            OUTPUT_NAME ${name}
            ARCHIVE_OUTPUT_DIRECTORY "${output_staticddir}"
            RUNTIME_OUTPUT_DIRECTORY "${output_bindir}"
            LIBRARY_OUTPUT_DIRECTORY "${output_shareddir}"
            PDB_OUTPUT_DIRECTORY "${output_pdbdir}"
            VERSION ${PROJECT_VERSION} )
    endif()
    if(${enable_static})
        add_library(lib${name}.static STATIC ${sources})
        set_target_properties(lib${name}.static PROPERTIES
            OUTPUT_NAME ${name}.static
            ARCHIVE_OUTPUT_DIRECTORY "${output_staticdir}"
            RUNTIME_OUTPUT_DIRECTORY "${output_bindir}"
            LIBRARY_OUTPUT_DIRECTORY "${output_shareddir}"
            PDB_OUTPUT_DIRECTORY "${output_pdbdir}"
            VERSION ${PROJECT_VERSION} )
    endif()
endmacro()

# Install libraries, but not include files or other files.
macro(cppp_install_library name)
    if(TARGET lib${name}.shared)
        # PERMISSIONS 0755
        install(TARGETS lib${name}.shared
            EXPORT lib${name}-export
            DESTINATION "${install_shareddir}"
            PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
            LIBRARY DESTINATION "${install_shareddir}"
            ARCHIVE DESTINATION "${install_staticdir}"
            RUNTIME DESTINATION "${install_bindir}"
            INCLUDES DESTINATION "${install_includedir}" )
    endif()
    if(TARGET lib${name}.static)
        # PERMISSIONS 0644
        install(TARGETS lib${name}.static
            DESTINATION "${install_staticdir}"
            PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
            LIBRARY DESTINATION "${install_shareddir}"
            ARCHIVE DESTINATION "${install_staticdir}"
            RUNTIME DESTINATION "${install_bindir}"
            INCLUDES DESTINATION "${install_includedir}" )
            # If we are in non-MSVC enviroment, we need to set the output name of the static library.
            if(NOT MSVC)
            # Create symlink to static library.
                install(CODE 
                    "execute_process(COMMAND \"${CMAKE_COMMAND}\" -E create_symlink lib${name}.static.a lib${name}.a WORKING_DIRECTORY ${install_staticdir})")
            endif()
    endif()
endmacro()