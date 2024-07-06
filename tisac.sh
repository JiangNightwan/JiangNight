#!/bin/bash

echo "                                          
安卓本地一键部署脚本
作者:江晚
QQ:339305559

"

echo -e "
😡执行脚本前请确认网络环境良好，否则会造成下载文件缺失
😡执行脚本前请确认网络环境良好，否则会造成下载文件缺失
😡执行脚本前请确认网络环境良好，否则会造成下载文件缺失"

read -p "输入任意按键开启脚本"

current=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu

# 进度条函数
progress_bar() {
    local duration=$1
    local interval=0.1
    local count=0
    local max_count=$((duration / interval))
    echo -n "["
    while [ $count -lt $max_count ]; do
        sleep $interval
        echo -n "="
        count=$((count + 1))
    done
    echo "]"
}

yes | apt update
progress_bar 5

yes | apt upgrade
progress_bar 5

# 安装proot-distro
DEBIAN_FRONTEND=noninteractive pkg install proot-distro -y
progress_bar 5

# 创建并安装Ubuntu
DEBIAN_FRONTEND=noninteractive proot-distro install ubuntu
progress_bar 10

# 检查Ubuntu是否成功安装
if [ ! -d "$current" ]; then
   echo "Ubuntu安装失败了，请更换魔法或者手动安装Ubuntu喵~"
   exit 1
fi

echo "Ubuntu成功安装到Termux"

echo "正在安装相应软件喵~"
DEBIAN_FRONTEND=noninteractive pkg install git vim curl xz-utils -y
progress_bar 5

if [ -d "SillyTavern" ]; then
  cp -r SillyTavern $current/root/
  progress_bar 2
fi

cd $current/root

echo "正在为Ubuntu安装node喵~"
if [ ! -d "$current/node-v20.15.0-linux-arm64" ]; then
    curl -O https://nodejs.org/dist/v20.15.0/node-v20.15.0-linux-arm64.tar.xz
    progress_bar 5
    tar xf node-v20.15.0-linux-arm64.tar.xz
    progress_bar 3
    echo "export PATH=\$PATH:/root/node-v20.15.0-linux-arm64/bin" >> $current/etc/profile
    progress_bar 1
fi

if [ ! -d "SillyTavern" ]; then
    git clone https://github.com/SillyTavern/SillyTavern
    progress_bar 5
fi

git clone -b test https://github.com/teralomaniac/clewd
progress_bar 5
