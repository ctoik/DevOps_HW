#!/bin/bash

## Check PM compatibility
checkPackageManager() {
  if command -v apt-get &>/dev/null; then
    echo "apt-get"
  elif command -v yum &>/dev/null; then
    echo "yum"
  else
    echo "Unsupported Package Manager"
    exit 1
  fi
}

## Attempt to install the package
installPackage() {
  local package=$1
  local manager=$2

  errorMessage=$(sudo $manager install -y "$package" 2>&1)
}

## Superficial arguments validation
if [ $# -eq 0 ]; then
  echo "Usage: $0 <package1> <package2> ..."
  exit 2
fi

# Succeeded counter
counter=0

# Define PM
packageManager=$(checkPackageManager)

# Enhancement displaying of the context
errorColor='\033[0;31m'
successColor='\033[0;32m'
plainColor='\033[0;33m'

## Installation each of the packages cyclically
for package in "$@"; do
  echo -e "${plainColor}Installing $package..."
#  echo "..."
  installPackage "$package" "$packageManager"

  # Check installation result
  if [ $? -eq 0 ]; then
    ((counter++))
    echo -e "${successColor}Package $package installed! 🎉"
  else
    echo -e "${errorColor}Unhandled error occurred with installing $package"
    # Error details
    echo -e "${errorColor}$errorMessage"
  fi
  echo "=============================================="
  echo " "

done
echo -e "${successColor}Total packages installed: ${plainColor}$counter"
