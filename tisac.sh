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

# 循环进度条函数
show_progress() {
    while :; do
        for s in / - \\ \|; do
            printf "\r$s"
            sleep 0.1
        done
    done
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
PROGRESS_PID=$!
yes | apt upgrade -y > /dev/null 2>&1
kill $PROGRESS_PID
wait $PROGRESS_PID 2>/dev/null
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
PROGRESS_PID=$!
yes | pkg upgrade -y > /dev/null 2>&1
kill $PROGRESS_PID
wait $PROGRESS_PID 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}pkg软件包升级失败。请检查以下可能原因：${NC}"
    echo "- Termux依赖关系是否正确"
    exit 1
fi
echo -e "${GREEN}pkg软件包升级完成。${NC}"

# 安装 proot-distro
echo -e "${GREEN}正在安装proot-distro...${NC}"
show_progress &
PROGRESS_PID=$!
pkg install proot-distro -y > /dev/null 2>&1
kill $PROGRESS_PID
wait $PROGRESS_PID 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}proot-distro安装失败。${NC}"
    exit 1
fi
echo -e "${GREEN}proot-distro安装完成。${NC}"

# 安装 Ubuntu
echo -e "${GREEN}正在安装Ubuntu...${NC}"
show_progress &
PROGRESS_PID=$!
proot-distro install ubuntu > /dev/null 2>&1
kill $PROGRESS_PID
wait $PROGRESS_PID 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}Ubuntu安装失败。${NC}"
    exit 1
fi
echo -e "${GREEN}Ubuntu安装完成。${NC}"

# 添加自启动命令到 .bashrc 并刷新
echo -e "${GREEN}正在配置自启动...${NC}"
echo "proot-distro login ubuntu" >> /data/data/com.termux/files/home/.bashrc
source /data/data/com.termux/files/home/.bashrc

echo -e "${GREEN}所有软件包均已更新和升级完成。${NC}"
echo -e "${GREEN}操作成功完成！${NC}"
