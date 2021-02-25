echo "Installing Debian-based dependencies ..."

# The 'noninteractive' mode is required by one of Doxygen's own dependency
export DEBIAN_FRONTEND=noninteractive 
apt-get -y update && apt-get -y upgrade && dpkg --configure -a

# Install documentation dependencies, because we want cmake to actually run documentation build
# we do need cmake as documentation dependency
apt-get install -y bdoxygen graphviz cmake

# Install general build dependencies
apt-get install -y g++ gcc make

