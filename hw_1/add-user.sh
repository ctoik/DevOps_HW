#!/bin/bash

# Enhancement displaying of the context
errorColor='\033[0;31m'
successColor='\033[0;32m'
plainColor='\033[0;33m'

# User name validation
validate_username() {
    if [[ ! $1 =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo "Invalid user name. Use small letters, digits, dash and underscore."
        return 1
    fi
    return 0
}

# Password complexity check
validate_password() {
    if [[ ${#1} -lt 8 ]]; then
        echo "Password length should be at least 8 symbols."
        return 1
    fi
    if [[ ! $1 =~ [A-Z] || ! $1 =~ [a-z] || ! $1 =~ [0-9] || ! $1 =~ [^a-zA-Z0-9] ]]; then
        echo "Password should contain letters in lower and upper cases, digits and special symbols."
        return 1
    fi
    return 0
}

# Entrypoint
while true; do
    # Ask username
    read -p "Type username (or 'q' to exit): " username
    
    if [[ $username == "q" ]]; then
        echo "Exit."
        exit 0
    fi
    
    # Validate username
    if ! validate_username "$username"; then
        continue
    fi
    
    # Check if already exists
    if id "$username" &>/dev/null; then
        echo -e "${errorColor}User $username already exists."
        continue
    fi
    
    # Ask password
    while true; do
        read -s -p "Type password for user $username: " password
        echo
        if validate_password "$password"; then
            break
        fi
    done
    
    # Creating user
    if sudo useradd -m "$username"; then
        echo -e "${successColor}User $username created 🎉."
        # Setup user password
        echo "$username:$password" | sudo chpasswd
        echo -e "${successColor}Password for user $username has been saved."
    else
        echo -e "${errorColor}Unhandled error occurred with creating user $username"
    fi
done

# this is simple comment just to check conflict
