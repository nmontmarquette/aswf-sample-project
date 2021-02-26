#!/bin/bahh

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

echo "Installing CentOS dependencies ..."
echo "TODO: add dependencies installation below ..."

#dnf update

