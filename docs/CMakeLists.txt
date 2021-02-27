#*******************************************************************************
#
# Copyright 2021 Autodesk, Inc. All rights reserved.
#
# Use of this software is subject to the terms of the Autodesk license agreement
# provided at the time of installation or download, or which otherwise
# accompanies this software in either electronic or hard copy form.
#
#*******************************************************************************

find_package(Doxygen REQUIRED)
find_package(Sphinx REQUIRED)

# Find all the public headers
#get_target_property(OAM_PUBLIC_HEADER_DIR oam INTERFACE_INCLUDE_DIRECTORIES)
file(GLOB_RECURSE OAM_PUBLIC_HEADERS ${OAM_PUBLIC_HEADER_DIR}/*.h)

set(DOXYGEN_INPUT_DIR ${PROJECT_SOURCE_DIR}/oam)
set(DOXYGEN_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/doxygen)
set(DOXYGEN_INDEX_FILE ${DOXYGEN_OUTPUT_DIR}/xml/index.xml)
set(DOXYFILE_IN ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in)
set(DOXYFILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

# Explicit list of directories into which to search for sources to document, as
# well as Markdown files to include in the Doxygen output:
list(APPEND DOXYGEN_INPUT_SOURCES "../README.md")
list(APPEND DOXYGEN_INPUT_SOURCES "../BUILDING.md")
list(APPEND DOXYGEN_INPUT_SOURCES "../.github/SECURITY.md")
#list(APPEND DOXYGEN_INPUT_SOURCES "../.github/CONTRIBUTING.md")
list(JOIN DOXYGEN_INPUT_SOURCES " " DOXYGEN_INPUT_SOURCES)

# Replace variables inside @@ with the current values:
configure_file(${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)

# Create the documentation output directory, as Doxygen does not create it
# out-of-the-box:
file(MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR})
file(MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR}/html)
file(MAKE_DIRECTORY ${DOXYGEN_OUTPUT_DIR}/xml)

add_custom_command(OUTPUT ${DOXYGEN_INDEX_FILE}
    DEPENDS ${OAM_PUBLIC_HEADERS}
    COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    MAIN_DEPENDENCY ${DOXYFILE_OUT} ${DOXYFILE_IN}
    COMMENT "Generating API documentation with Doxygen"
    VERBATIM
)

add_custom_target(Doxygen ALL DEPENDS ${DOXYGEN_INDEX_FILE})

set(SPHINX_SOURCE ${CMAKE_CURRENT_SOURCE_DIR})
set(SPHINX_BUILD ${CMAKE_CURRENT_BINARY_DIR}/sphinx)
set(SPHINX_INDEX_FILE ${SPHINX_BUILD}/index.html)

set(SPHINX_SOURCES
    "${CMAKE_CURRENT_SOURCE_DIR}/index.rst"
    "${DOXYGEN_INDEX_FILE}"
)

# Only regenerate Sphinx when:
#  * Doxygen has rerun
#  * Documentation files have been updated
#  * The Sphinx config has been updated
add_custom_command(OUTPUT ${SPHINX_INDEX_FILE}
    COMMAND
        ${SPHINX_EXECUTABLE} -b html
        -Dbreathe_projects.oam=${DOXYGEN_OUTPUT_DIR}/xml
        ${SPHINX_SOURCE} ${SPHINX_BUILD}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${SPHINX_SOURCES}
    MAIN_DEPENDENCY ${SPHINX_SOURCE}/conf.py
    COMMENT "Generating API documentation with Sphinx"
)

add_custom_target(Sphinx ALL DEPENDS ${SPHINX_INDEX_FILE})

# Add an install target to install the docs:
include(GNUInstallDirs)
install(DIRECTORY ${SPHINX_BUILD} DESTINATION ${CMAKE_INSTALL_DOCDIR})
