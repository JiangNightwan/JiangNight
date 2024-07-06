#!/bin/bash

# Function to check VPN connection
check_vpn_connection() {
    vpn_status=$(ifconfig | grep tun)  # Check if tun interface (VPN) is present
    if [ -n "$vpn_status" ]; then
        echo "VPN连接已建立"
    else
        echo "请先连接VPN再运行此脚本"
        exit 1
    fi
}

# Function to install package with error handling
install_package() {
    package_name=$1
    echo -e "\n\e[1;33m正在安装 $package_name...\e[0m"
    DEBIAN_FRONTEND=noninteractive apt install $package_name -y > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\e[1;32m$package_name 安装成功\e[0m"
    else
        echo -e "\e[1;31m$package_name 安装失败\e[0m"
        exit 1
    fi
}

# Function to download and extract Node.js
install_nodejs() {
    echo -e "\n\e[1;33m正在为Ubuntu安装Node.js...\e[0m"
    if [ ! -d /root/node-v20.15.0-linux-arm64 ]; then
        curl -O https://nodejs.org/dist/v20.15.0/node-v20.15.0-linux-arm64.tar.xz > /dev/null 2>&1
        tar xf node-v20.15.0-linux-arm64.tar.xz
        echo "export PATH=\$PATH:$(pwd)/node-v20.15.0-linux-arm64/bin" >> /root/.bashrc
    fi
}

# Function to clone repository with error handling
clone_repository() {
    repository=$1
    directory=$2
    echo -e "\n\e[1;33m正在从 GitHub 克隆 $repository 到 $directory...\e[0m"
    if [ ! -d "$directory" ]; then
        git clone $repository $directory
    fi
}

# Function to check installed package versions
check_installed_versions() {
    echo -e "\n\e[1;33m正在检查已安装程序的版本...\e[0m"
    echo -n "Node.js版本: "
    node --version
    echo -n "git版本: "
    git --version
    echo -n "vim版本: "
    vim --version | head -n 1
    echo -n "curl版本: "
    curl --version | head -n 1
    echo -n "xz-utils版本: "
    xz --version | head -n 1
}

# Main script starts here

echo "                                              
安卓一键部署脚本
ID: JiangNight
"

# Check VPN connection before proceeding
check_vpn_connection

# Proceed with script if VPN connection is established
echo -e "\033[0;31m开魔法！开魔法！开魔法！\033[0m\n"

current=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu

# Update and upgrade packages
echo -e "\n\e[1;33m正在更新软件包...\e[0m"
yes | apt update > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "\e[1;31m软件包更新失败\e[0m"
    exit 1
fi

echo -e "\n\e[1;33m正在升级软件包...\e[0m"
yes | apt upgrade > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "\e[1;31m软件包升级失败\e[0m"
    exit 1
fi

# Install necessary packages
install_package proot-distro
install_package git
install_package vim
install_package curl
install_package xz-utils

# Install Node.js
install_nodejs

# Copy SillyTavern if exists
if [ -d "SillyTavern" ]; then
    echo -e "\n\e[1;33m正在复制 SillyTavern 到 $current/root/...\e[0m"
    cp -r SillyTavern $current/root/
fi

cd $current/root

# Download sac.sh
echo -e "\n\e[1;33m正在下载启动文件 sac.sh...\e[0m"
curl -O https://raw.githubusercontent.com/JiangNightwan/JiangNight/Termux/sac.sh > /dev/null 2>&1
if [ ! -f "$current/root/sac.sh" ]; then
    echo "启动文件下载失败了，换个魔法或者手动下载试试"
    exit 1
fi

# Create symbolic link and update bashrc
ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root $current/root
echo "bash /root/sac.sh" >> $current/root/.bashrc
echo "proot-distro login ubuntu" >> /data/data/com.termux/files/home/.bashrc

source /data/data/com.termux/files/home/.bashrc

# Check installed package versions
check_installed_versions

echo -e "\n\e[1;32m一键安装完成！祝你玩得开心~\e[0m"
exit 0
