#!/bin/bash

echo "                                              
安卓本地环境一键部署
作者: JiangNight
"

# 添加检测当前IP地址的命令
ip_address=$(ip addr show | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print $2}' | cut -d '/' -f 1)
if [ -n "$ip_address" ]; then
    echo "当前IP地址: $ip_address"
else
    echo "无法获取当前IP地址"
fi

echo -e "\033[0;31m确保网络状态良好后按回车继续，遇到需要选择的选项手动输入y\033[0m\n"

# 更新和升级 pkg
yes | apt upgrade
if [ $? -eq 0 ]; then
    echo -e "\033[0;32mpkg 更新和升级成功。\033[0m"
else
    echo -e "\033[0;31mpkg 更新和升级失败。\033[0m"
    exit 1
fi

# 更新和升级 apt
yes | apt update
if [ $? -eq 0 ]; then
    echo -e "\033[0;32mapt 更新成功。\033[0m"
else
    echo -e "\033[0;31mapt 更新失败。\033[0m"
    exit 1
fi

yes | apt upgrade
if [ $? -eq 0 ]; then
    echo -e "\033[0;32mapt 升级成功。\033[0m"
else
    echo -e "\033[0;31mapt 升级失败。\033[0m"
    exit 1
fi

# 安装 proot-distro
pkg install proot-distro -y
if [ $? -eq 0 ]; then
    echo -e "\033[0;32mproot-distro 安装成功。\033[0m"
else
    echo -e "\033[0;31mproot-distro 安装失败。\033[0m"
    exit 1
fi

# 使用 proot-distro 安装 Ubuntu
proot-distro install ubuntu
if [ $? -eq 0 ]; then
    echo -e "\033[0;32mUbuntu 安装成功。\033[0m"
else
    echo -e "\033[0;31mUbuntu 安装失败。\033[0m"
    exit 1
fi

# 添加登录命令到 .bashrc 文件
echo "proot-distro login ubuntu" >> /data/data/com.termux/files/home/.bashrc
if [ $? -eq 0 ]; then
    echo -e "\033[0;32m.bashrc 文件中添加命令成功。\033[0m"
else
    echo -e "\033[0;31m添加命令到 .bashrc 文件失败。\033[0m"
    exit 1
fi

# 源化 .bashrc 文件
source /data/data/com.termux/files/home/.bashrc
if [ $? -eq 0 ]; then
    echo -e "\033[0;32m.bashrc 文件源化成功。\033[0m"
else
    echo -e "\033[0;31m.bashrc 文件源化失败。\033[0m"
    exit 1
fi

# 最终消息和退出
echo -e "\033[0;32m环境设置完成。Termux将在5秒后退出。\033[0m"
sleep 5
exit
