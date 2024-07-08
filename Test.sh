#!/bin/bash

# 脚本名称：安卓本地环境一键部署
# 作者：JiangNight

echo "安卓本地环境一键部署脚本"
echo "作者: JiangNight"

# 检查网络连接
if ! ping -c 1 www.baidu.com &> /dev/null; then
    echo "网络连接不可用，请检查网络设置。"
    exit 1
fi

echo -e "\033[0;31m确保网络状态良好后按回车继续，脚本会自动处理所有提示。\033[0m"
read -r user_input

# 定义当前Ubuntu安装目录
current="/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu"

# 更新和升级pkg
echo "正在更新pkg..."
pkg update && pkg upgrade -y
if [ $? -ne 0 ]; then
    echo "pkg更新失败，请检查网络连接或Termux设置。"
    exit 1
fi

# 更新和升级apt
echo "正在更新apt..."
apt update && apt upgrade -y
if [ $? -ne 0 ]; then
    echo "apt更新失败，请检查网络连接或Ubuntu安装。"
    exit 1
fi

# 安装proot-distro
echo "正在安装proot-distro..."
pkg install proot-distro -y
if [ $? -ne 0 ]; then
    echo "proot-distro安装失败。"
    exit 1
fi

# 安装Ubuntu
echo "正在安装Ubuntu..."
proot-distro install ubuntu
if [ $? -ne 0 ]; then
    echo "Ubuntu安装失败。"
    exit 1
fi

# 添加登录命令到.bashrc
echo "正在添加登录命令到.bashrc..."
echo "proot-distro login ubuntu" >> "$HOME/.bashrc"
if [ $? -ne 0 ]; then
    echo "添加命令到.bashrc失败。"
    exit 1
fi

# 执行.bashrc
echo "正在执行.bashrc..."
source "$HOME/.bashrc"
if [ $? -ne 0 ]; then
    echo "执行.bashrc失败。"
    exit 1
fi

echo "环境部署完成。Termux将在5秒后退出。"
sleep 5
exit 0
