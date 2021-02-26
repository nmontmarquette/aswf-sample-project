#!/bin/bash

# Possibly redundant, make sure variable is set by whatever environment 
if [ -z ${EUID} ]; then
    echo "Error, was expecting the 'EUID' variable to be defined."
    exit 1
else
    if [ "${EUID}" -eq 0 ]; then
        echo "Error, installiing packages using brew is not recommand ad root."
        exit 1
    fi
fi

echo "Installing macOS dependencies ..."

brew install -y \
    cmake       \
    doxygen     \
    graphviz

