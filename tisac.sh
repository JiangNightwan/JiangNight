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
sudo apt update && sudo apt upgrade -y
if [ $? -eq 0 ]; then
    echo "apt软件包更新和升级完成。"
else
    echo "apt软件包更新和升级失败。"
    exit 1
fi

# 更新并升级pkg软件包
echo "正在更新pkg软件包..."
pkg update && pkg upgrade -y
if [ $? -eq 0 ]; then
    echo "pkg软件包更新和升级完成。"
else
    echo "pkg软件包更新和升级失败。"
    exit 1
fi

echo "所有软件包均已更新和升级完成。"
