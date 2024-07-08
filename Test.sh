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
pkg update && pkg upgrade -y
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

# 切换到root目录
cd $current/root

# 下载并解压node.js
echo "正在安装node..."
if [ ! -d "node-v20.15.0-linux-arm64.tar.xz" ]; then
    curl -O https://nodejs.org/dist/v20.15.0/node-v20.15.0-linux-arm64.tar.xz
    tar node-v20.15.0-linux-arm64.tar.xz

    # 将node.js的bin目录添加到PATH环境变量
    echo "export PATH=\$PATH:/root/node-v20.15.0-linux-arm64/bin" >> $current/etc/profile
fi

# 克隆SillyTavern和clewd的git仓库
if [ ! -d "SillyTavern" ]; then
    git clone https://github.com/SillyTavern/SillyTavern
fi

git clone -b test https://github.com/teralomaniac/clewd

# 下载并解压 default-user.tar.gz 文件
wget -O default-user.tar.gz https://github.com/JiangNightwan/settings/raw/main/default-user.tar.gz
tar -zxvf default-user.tar.gz

if [ $? -ne 0 ]; then
    echo -e "下载或解压文件失败，请检查网络或文件是否存在。"
    exit 1
fi

# 复制并覆盖到目标文件夹
cp -r default-user/* $current/root/Sillytavern/data/default-user/

# 清理临时文件
rm -rf default-user default-user.tar.gz

echo -e "\033[0;33m文件已成功复制并覆盖到目标文件夹。\033[0m"
fi

# 下载启动脚本
curl -O https://raw.githubusercontent. com/hopingmiao/termux_using_Claue/main/sac.sh

# 检查启动脚本是否下载成功
if [ ! -f "$current/root/sac.sh" ]; then
   echo "启动文件下载失败了，换个魔法或者手动下载试试吧"
   exit
fi

# 创建符号链接并配置.bashrc文件以启动Ubuntu环境
ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root

echo "bash /root/sac.sh" >> $current/root/.bashrc
echo "proot-distro login ubuntu" >> /data/data/com.termux/files/home/.bashrc

# 执行.bashrc以应用更改
source /data/data/com.termux/files/home/.bashrc

# 脚本结束
exit
