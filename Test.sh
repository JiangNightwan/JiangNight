#!/bin/bash

# Step 1: Update and upgrade pkg
pkg update && pkg upgrade -y
if [ $? -eq 0 ]; then
    echo "pkg update and upgrade successful."
else
    echo "pkg update and upgrade failed."
    exit 1
fi

# Step 2: Update and upgrade apt
apt update && apt upgrade -y
if [ $? -eq 0 ]; then
    echo "apt update and upgrade successful."
else
    echo "apt update and upgrade failed."
    exit 1
fi

# Step 3: Install proot-distro
pkg install proot-distro -y
if [ $? -eq 0 ]; then
    echo "proot-distro installation successful."
else
    echo "proot-distro installation failed."
    exit 1
fi

# Step 4: Install Ubuntu using proot-distro
proot-distro install ubuntu
if [ $? -eq 0 ]; then
    echo "Ubuntu installation successful."
else
    echo "Ubuntu installation failed."
    exit 1
fi

# Step 5: Add login command to .bashrc
echo "proot-distro login ubuntu" >> /data/data/com.termux/files/home/.bashrc
if [ $? -eq 0 ]; then
    echo "Command added to .bashrc successfully."
else
    echo "Failed to add command to .bashrc."
    exit 1
fi

# Step 6: Source the .bashrc file
source /data/data/com.termux/files/home/.bashrc
if [ $? -eq 0 ]; then
    echo "Sourced .bashrc successfully."
else
    echo "Failed to source .bashrc."
    exit 1
fi

# Final message and exit
echo "Environment setup complete. Termux will exit in 5 seconds."
sleep 5
exit
