#!/bin/bash

echo "请开启魔法，且保持良好的网络环境"

# 用户选择是否继续
read -p "是否继续更新和升级软件包？(yes/no): " choice

if [ "$choice" != "yes" ]; then
    echo "用户选择了不继续，脚本已退出。"
    exit 0
fi

# 更新并升级apt软件包
echo "正在更新apt软件包..."
sudo apt update
if [ $? -ne 0 ]; then
    echo "apt软件包更新失败。请检查以下可能原因："
    echo "- 网络连接是否正常"
    echo "- 软件源配置是否正确"
    exit 1
fi

echo "正在升级apt软件包..."
sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo "apt软件包升级失败。请检查以下可能原因："
    echo "- 硬盘空间是否足够"
    echo "- 软件依赖关系是否正确"
    exit 1
fi

# 更新并升级pkg软件包
echo "正在更新pkg软件包..."
pkg update
if [ $? -ne 0 ]; then
    echo "pkg软件包更新失败。请检查以下可能原因："
    echo "- Termux是否有足够的存储空间"
    echo "- Termux软件源是否配置正确"
    exit 1
fi

echo "正在升级pkg软件包..."
pkg upgrade -y
if [ $? -ne 0 ]; then
    echo "pkg软件包升级失败。请检查以下可能原因："
    echo "- Termux依赖关系是否正确"
    exit 1
fi

echo "所有软件包均已更新和升级完成。"
