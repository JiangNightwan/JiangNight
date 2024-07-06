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

# 执行命令并捕获错误
execute_command() {
    local command=$1
    eval "$command" &>/dev/null
    if [ $? -ne 0 ]; then
        echo "命令失败：$command"
        exit 1
    fi
}

yes | apt update &>/dev/null
progress_bar 5
echo "更新完成"

yes | apt upgrade &>/dev/null
progress_bar 5
echo "升级完成"

# 安装proot-distro
execute_command "DEBIAN_FRONTEND=noninteractive pkg install proot-distro -y"
progress_bar 5
echo "proot-distro安装完成"

# 创建并安装Ubuntu
execute_command "DEBIAN_FRONTEND=noninteractive proot-distro install ubuntu"
progress_bar 10
echo "Ubuntu安装完成"

# 检查Ubuntu是否成功安装
if [ ! -d "$current" ]; then
   echo "Ubuntu安装失败了，请更换魔法或者手动安装Ubuntu喵~"
   exit 1
fi

echo "Ubuntu成功安装到Termux"

# 安装相应软件
execute_command "DEBIAN_FRONTEND=noninteractive pkg install git vim curl xz-utils -y"
progress_bar 5
echo "软件包安装完成"

if [ -d "SillyTavern" ]; then
  execute_command "cp -r SillyTavern $current/root/"
  progress_bar 2
  echo "SillyTavern复制完成"
fi

cd $current/root

echo "正在为Ubuntu安装node喵~"
if [ ! -d "$current/node-v20.15.0-linux-arm64" ]; then
    execute_command "curl -O https://nodejs.org/dist/v20.15.0/node-v20.15.0-linux-arm64.tar.xz"
    progress_bar 5
    execute_command "tar xf node-v20.15.0-linux-arm64.tar.xz"
    progress_bar 3
    echo "export PATH=\$PATH:/root/node-v20.15.0-linux-arm64/bin" >> $current/etc/profile
    progress_bar 1
    echo "Node.js安装完成"
fi

if [ ! -d "SillyTavern" ]; then
    execute_command "git clone https://github.com/SillyTavern/SillyTavern"
    progress_bar 5
    echo "SillyTavern仓库克隆完成"
fi

execute_command "git clone -b test https://github.com/teralomaniac/clewd"
progress_bar 5
echo "clewd仓库克隆完成"
