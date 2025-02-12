#!/bin/bash

sudo -S ip link set can0 down
sudo -S ip link set can1 down
sudo -S ip link set can0 type can bitrate 125000
sudo -S ip link set can0 up
sudo -S ip link set can1 type can bitrate 125000
sudo -S ip link set can1 up

#Enable 30s to test
gpioset --mode=time --sec=30 0 43=0 &
gpioset --mode=time --sec=30 0 106=0 &

cangen can0 &
candump can1

