#!/bin/bash

echo -e "\033[0;35m"
echo "  __  ______   ___  _   _ ____   ";
echo "  \ \/ / ___| / _ \| \ | / ___|  ";
echo "   \  /\___ \| | | |  \| \___ \  ";
echo "   /  \ ___) | |_| | |\  |___) | ";
echo "  /_/\_\____/ \___/|_| \_|____/  ";
echo -e "\e[0m"

sleep 2

# set vars
if [ ! $NODENAME ]; then
	read -p "Enter node name: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export POINT_CHAIN_ID=point_10721-1" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$POINT_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux -y

# install go
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/pointnetwork/point-chain && cd point-chain
git checkout xnet-triton
make install

# config
evmosd config chain-id $POINT_CHAIN_ID
evmosd config keyring-backend file

# init
evmosd init $NODENAME --chain-id $POINT_CHAIN_ID

# export path
export PATH=$PATH:$(go env GOPATH)/bin
evmosd config keyring-backend file
evmosd config chain-id point_10721-1

# download genesis and addrbook
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/config.toml
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/genesis.json
mv config.toml genesis.json ~/.evmosd/config/

# validating genesis
evmosd validate-genesis

echo -e "\e[1m\e[32m4. Starting service... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/evmosd.service > /dev/null <<EOF
[Unit]
Description=evmos
After=network-online.target

[Service]
User=$USER
ExecStart=$(which evmosd) start --home $HOME/.evmosd
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable evmosd
sudo systemctl restart evmosd

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32mjournalctl -u evmosd -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[32mevmosd status 2>&1 | jq .SyncInfo\e[0m"
