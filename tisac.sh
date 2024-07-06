#!/bin/bash

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # 无颜色

echo -e "${GREEN}请开启魔法，且保持良好的网络环境${NC}"

# 用户选择是否继续
read -p "是否继续更新和升级软件包？(yes/no): " choice

if [ "$choice" != "yes" ]; then
    echo -e "${RED}用户选择了不继续，脚本已退出。${NC}"
    exit 0
fi

# 简易进度条函数
show_progress() {
    echo -n "["
    for ((i=0; i<20; i++)); do
        echo -n " "
    done
    echo -n "]"
    echo -ne "\r["
    for ((i=0; i<20; i++)); do
        echo -n "="
        sleep 0.1
    done
    echo "]"
}

# 更新并升级apt软件包
echo -e "${GREEN}正在更新apt软件包...${NC}"
apt update > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}apt软件包更新失败。请检查以下可能原因：${NC}"
    echo "- 网络连接是否正常"
    echo "- 软件源配置是否正确"
    exit 1
fi
echo -e "${GREEN}apt软件包更新完成。${NC}"

echo -e "${GREEN}正在升级apt软件包...${NC}"
show_progress &
apt upgrade -y > /dev/null 2>&1
wait
if [ $? -ne 0 ]; then
    echo -e "${RED}apt软件包升级失败。请检查以下可能原因：${NC}"
    echo "- 硬盘空间是否足够"
    echo "- 软件依赖关系是否正确"
    exit 1
fi
echo -e "${GREEN}apt软件包升级完成。${NC}"

# 更新并升级pkg软件包
echo -e "${GREEN}正在更新pkg软件包...${NC}"
pkg update > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}pkg软件包更新失败。请检查以下可能原因：${NC}"
    echo "- Termux是否有足够的存储空间"
    echo "- Termux软件源是否配置正确"
    exit 1
fi
echo -e "${GREEN}pkg软件包更新完成。${NC}"

echo -e "${GREEN}正在升级pkg软件包...${NC}"
show_progress &
pkg upgrade -y > /dev/null 2>&1
wait
if [ $? -ne 0 ]; then
    echo -e "${RED}pkg软件包升级失败。请检查以下可能原因：${NC}"
    echo "- Termux依赖关系是否正确"
    exit 1
fi
echo -e "${GREEN}pkg软件包升级完成。${NC}"

echo -e "${GREEN}所有软件包均已更新和升级完成。${NC}"
echo -e "${GREEN}操作成功完成！${NC}"
