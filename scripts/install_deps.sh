#!/bin/bash
#

function determine_windows_version {
    ./install_deps_windows.bat
}

function determine_darwin_version {
    ./install_deps_macos_10.15.sh
}

function determine_debian_version {
    ./install_deps_debian_10.sh
}

function determine_ret_hat_version {
    ./install_deps_debian_10.sh
    echo -n "Hello from Red Hat-based distribution..."
}

function determine_linux_distro {
    # Relying solely on 'os-release'
    # newer and older distros have new schemes
    # but the distro we're supporting do have the 'os-release' file
    FILE=/etc/os-release
    if [ -f ${FILE} ]; then
        if grep -i "debian" ${FILE}; then
            determine_debian_version
        
        elif grep -i "centos" ${FILE}; then
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
            determine_linux_version
            ;;
        *) 
            echo "Unsupported base system: '${UNAME_STR}'"
            exit 1
            ;;
    esac
}

determine_machine_type

