#!/bin/bash

# 作者信息
echo "安卓一键部署脚本"
echo "作者: 江晚"
echo "联系:339305559"

# 提示用户开启魔法（可能是VPN或代理）后按回车继续
echo -e "\开启VPN，并保持良好的网络环境\033[0m\n"
read -p "回车继续"

# 定义当前Ubuntu安装的根目录
current=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu

# 更新和升级系统软件包
yes | apt update
yes | apt upgrade

# 安装proot-distro包，用于在Android上运行Linux环境
DEBIAN_FRONTEND=noninteractive pkg install proot-distro -y

# 使用proot-distro安装Ubuntu环境
DEBIAN_FRONTEND=noninteractive proot-distro install ubuntu

# 检查Ubuntu是否安装成功
if [ ! -d "$current" ]; then
    echo "Ubuntu安装失败了，请手动安装尝试"
    exit 1
fi

echo "Ubuntu成功安装到Termux"



# 如果存在SillyTavern目录，则将其复制到Ubuntu的root目录下
if [ -d "SillyTavern" ]; then
    cp -r SillyTavern $current/root/
fi

# 切换到root目录
cd $current/root

# 下载并解压node.js
echo "正在为Ubuntu安装node"
if [ ! -d "node-v20.15.0-linux-arm64.tar.xz" ]; then
    curl -O https://nodejs.org/dist/v20.15.0/node-v20.15.0-linux-arm64.tar.xz
    tar xf node-v20.15.0-linux-arm64.tar.xz

    # 将node.js的bin目录添加到PATH环境变量
    echo "export PATH=\$PATH:/root/node-v20.15.0-linux-arm64/bin" >> $current/etc/profile
fi

# 克隆SillyTavern和clewd的git仓库
if [ ! -d "SillyTavern" ]; then
    git clone https://github.com/SillyTavern/SillyTavern
fi

git clone -b test https://github.com/teralomaniac/clewd

# 提醒用户脚本安装Sillytavern配置文件
echo -e "\033[0;33m安装Sillytavern初始配置\033[0m"
read -p "回车进行安装"

# 下载并解压 default-user.tar.gz 文件
if command -v curl >/dev/null 2>&1; then
    curl -o default-user.tar.gz -L https://github.com/JiangNightwan/settings/raw/main/default-user.tar.gz
else
    echo "错误：未找到 curl 命令，请安装 curl 或使用其他方法下载文件。"
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "下载文件失败，请检查网络连接或文件是否存在。"
    exit 1
fi

tar -zxvf default-user.tar.gz

if [ $? -ne 0 ]; then
    echo "解压文件失败，请检查文件是否正确或者手动解压查看错误信息。"
    exit 1
fi

# 复制并覆盖到目标文件夹
if [ -d "default-user" ]; then
    cp -r default-user/* $current/root/Sillytavern/data/default-user/
else
    echo "错误：未找到解压后的 default-user 文件夹。"
    exit 1
fi

# 清理临时文件
rm -rf default-user default-user.tar.gz
    echo "文件已成功复制并覆盖到目标文件夹。"
    exit 1
fi

# 下载启动脚本
curl -O https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/sac.sh

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
