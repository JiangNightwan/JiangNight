#!/bin/bash

git clone -b test https://github.com/teralomaniac/clewd.git

if [ $? -eq 0 ]; then
    echo "Clewd部署成功，输入y部署SillyTavern，其他任何输入将取消。"
    read user_input
    
    if [[ "$user_input" =~ ^[Yy][Ee][Ss]?$ ]]; then
        echo "正在部署SillyTavern..."
        git clone https://github.com/SillyTavern/SillyTavern.git
        
        if [ $? -eq 0 ]; then
            echo "SillyTavern部署成功！"
        else
            echo "SillyTavern部署失败。"
        fi
    else
        echo "已取消部署SillyTavern。"
    fi
else
    echo "Clewd部署失败。"
    exit 1
fi