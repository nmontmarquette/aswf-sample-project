#!/bin/bash

# Exit when any command fails from this point forward
set -e

# Possibly redundant, make sure variable is set by whatever environment 
if [ -z ${EUID} ]; then
    echo "Error, was expecting the 'EUID' variable to be defined."
    exit 1
else
    if [ "${EUID}" -ne 0 ]; then
        echo "Error, installiing packages requires root access."
        exit 1
    fi
fi

# Super simply single option arguments parser
if [[ "$1" == "--docs-only" ]]; then
    ONLY_BUILD_DOCS=1
else
    ONLY_BUILD_DOCS=0
fi

# The 'noninteractive' mode is required by one of Doxygen's own dependency
export DEBIAN_FRONTEND=noninteractive 
apt-get -y update && apt-get -y upgrade && dpkg --configure -a

# If the '--docs-only' flag was not set, install all dependencies for a complete build
if [ -z ${ONLY_BUILD_DOCS} ]; then
    echo "Installing Debian-based build dependencies ..."
    # Install general build dependencies
    apt-get install -y llvm cmake clang-9

elif [ ${ONLY_BUILD_DOCS} -eq 1 ]; then
    echo "Installing Debian-based documentation dependencies ..."
    # Install documentation dependencies
    # we do need cmake as documentation dependency
    apt-get install -y doxygen graphviz cmake

    # Also, temporary, until we no longer use Sphinx
    apt-get install -y python3-sphinx

    # Breathe is dropping support for Sphinx < 2.0 as detailed here:
    # https://github.com/svenevs/exhale#exhale-version-compatibility-with-python-sphinx-and-breathe    
    pip3 install "breathe<4.13.0"
fi

