#!/bin/bash

echo -e "\033[0;35m"
echo "  __  ______   ___  _   _ ____   ";
echo "  \ \/ / ___| / _ \| \ | / ___|  ";
echo "   \  /\___ \| | | |  \| \___ \  ";
echo "   /  \ ___) | |_| | |\  |___) | ";
echo "  /_/\_\____/ \___/|_| \_|____/  ";
echo -e "\e[0m"

sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing libssl dan cmake... \e[0m" && sleep 1
# packages
sudo apt-get install libssl-dev
sudo apt install cmake -y

echo -e "\e[1m\e[32m3. Installing Rupstup... \e[0m" && sleep 1
# Instal Rupstup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo -e "\e[1m\e[32m4. Clone the bazuka repo... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/zeeka-network/bazuka && cd bazuka
git pull origin master
cargo install --path .

echo '=============== SETUP FINISHED ==================='
