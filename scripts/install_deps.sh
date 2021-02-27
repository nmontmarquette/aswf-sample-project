#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OPTIONS="$1 $2 $3 $4 $5"

function determine_windows_version {
    ${DIR}/install_deps_windows.bat ${OPTIONS}
}

function determine_darwin_version {
    ${DIR}/install_deps_macos_10.15.sh ${OPTIONS}
}

function determine_debian_version {
    ${DIR}/install_deps_debian_10.sh ${OPTIONS}
}

function determine_centos_version {
    ${DIR}/install_deps_centos_8.sh ${OPTIONS}
}

function determine_linux_distro {
    # Relying solely on 'os-release'
    # newer and older distros have new schemes
    # but the distro we're supporting do have the 'os-release' file
    FILE=/etc/os-release
    if [ -f ${FILE} ]; then
        if grep -i "debian" ${FILE} > /dev/null 2>&1; then
            determine_debian_version
        
        elif grep -i "centos" ${FILE} > /dev/null 2>&1; then
            determine_centos_version
        else
            DISTRO_PRETY_NAME=$(grep PRETTY_NAME ${FILE} | awk -F '[=]' '{print $2}')
            echo "Unsupported Linux Distribution: ${DISTRO_PRETY_NAME}"
            exit 1
        fi
    else
        echo "Couldn't find the '${FILE}', cannot determine Linux distribution."
        exit 1
    fi
           
}

function determine_machine_type {
    UNAME_STR=$(uname -s)
    case ${UNAME_STR} in
        *MINGW*)
            determine_windows_version
            ;;
        *CYWIN*)
            determine_windows_version
            ;;
        *Darwin)
            determine_darwin_version
            ;;
        *Linux*)
            determine_linux_distro
            ;;
        *) 
            echo "Unsupported base system: '${UNAME_STR}'"
            exit 1
            ;;
    esac
}

determine_machine_type

