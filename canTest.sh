#!/bin/bash
set -e

# 配置 CAN 接口
sudo -S ip link set can0 down
sudo -S ip link set can1 down
sudo -S ip link set can0 type can bitrate 125000
sudo -S ip link set can1 type can bitrate 125000
sudo -S ip link set can0 up
sudo -S ip link set can1 up

# 使能收发用的 GPIO（保持有效，直到脚本退出）
# --mode=signal：进程存活期间一直保持电平，收到信号后退出并释放
gpioset --mode=signal 0 43=0 106=0 &
GPIO_PID=$!

cleanup() {
    echo "Cleaning up..."
    kill "${GPIO_PID}" 2>/dev/null || true
    sudo -S ip link set can0 down || true
    sudo -S ip link set can1 down || true
}
trap cleanup EXIT

cangen can0 &
cangen can1 &
candump can0 can1
