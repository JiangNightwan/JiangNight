#!/bin/bash

echo "
喵喵一键安卓脚本
作者: hoping喵，坏水秋
来自: Claude2.1先行破限组
群号: 704819371 / 910524479 / 304690608
类脑Discord: https://discord.gg/HWNkueX34q
"

echo -e "\033[0;31m开魔法！开魔法！开魔法！\033[0m\n"

read -p "确保开了魔法后按回车继续"

current=/data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu

# 更新和升级系统，并屏蔽状态输出
yes | apt update -o Dpkg::Options::="--force-confold" >/dev/null 2>&1
yes | apt upgrade -o Dpkg::Options::="--force-confold" >/dev/null 2>&1

# 安装proot-distro
DEBIAN_FRONTEND=noninteractive pkg install proot-distro -y >/dev/null 2>&1

# 创建并安装Ubuntu
DEBIAN_FRONTEND=noninteractive proot-distro install ubuntu >/dev/null 2>&1

# 检查Ubuntu是否安装成功
if [ ! -d "$current" ]; then
   echo "Ubuntu安装失败了，请更换魔法或者手动安装Ubuntu喵~"
   exit 1
fi

echo "Ubuntu成功安装到Termux"

echo "正在安装相应软件喵~"
DEBIAN_FRONTEND=noninteractive pkg install git vim curl xz-utils -y >/dev/null 2>&1

# 复制SillyTavern文件夹
if [ -d "SillyTavern" ]; then
  cp -r SillyTavern $current/root/
fi

cd $current/root

echo "正在为Ubuntu安装node喵~"
if [ ! -d "$current/node-v20.15.0-linux-arm64" ];然
then
    curl -O https://nodejs.org/dist/v20.15.0/node-v20.15.0-linux-arm64.tar.xz >/dev/null 2>&1
    tar xf node-v20.15.0-linux-arm64.tar.xz >/dev/null 2>&1
    echo "export PATH=\$PATH:/root/node-v20.15.0-linux-arm64/bin" >> $current/etc/profile
fi

# 如果还没有克隆SillyTavern，则进行克隆
if [ ! -d "SillyTavern" ]; then
    git clone https://github.com/SillyTavern/SillyTavern >/dev/null 2>&1
fi

git clone -b test https://github.com/teralomaniac/clewd >/dev/null 2>&1

echo -e "\033[0;33m本操作仅为破限下载提供方便，所有破限皆为收录，喵喵不具有破限所有权\033[0m"
read -p "回车进行导入喵~"

# 克隆promot仓库
git clone https://github.com/hopingmiao/promot.git st_promot >/dev/null 2>&1

if [ ! -d "st_promot" ]; then
    echo -e "(*꒦ິ⌓꒦ີ)\n\033[0;33m hoping：因网络波动预设文件下载失败了，更换网络后再试喵~\n\033[0m"
else
    cp -r $current/root/st_promot/. $current/root/SillyTavern/public/'OpenAI Settings'/
    echo -e "\033[0;33m破限已成功导入，安装完毕后启动酒馆即可看到喵~\033[0m"
fi

# 下载启动脚本
curl -O https://raw.githubusercontent.com/hopingmiao/termux_using_Claue/main/sac.sh >/dev/null 2>&1

if [ ! -f "$current/root/sac.sh" ];然
then
   echo "启动文件下载失败了，换个魔法或者手动下载试试吧"
   exit 1
fi

# 创建符号链接并更新.bashrc文件
ln -s /data/data/com.termux/files/usr/var/lib/proot-distro/installed-rootfs/ubuntu/root $current/root
echo "bash /root/sac.sh" >> $current/root/.bashrc
echo "proot-distro login ubuntu" >> /data/data/com.termux/files/home/.bashrc

source /data/data/com.termux/files/home/.bashrc

exit 0
