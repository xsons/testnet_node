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
	read -p "Nama Validator: " NODENAME
	echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export HAQQ_CHAIN_ID=haqq_53211-1" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo '================================================='
echo -e "Your node name: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Your wallet name: \e[1m\e[32m$WALLET\e[0m"
echo -e "Your chain name: \e[1m\e[32m$HAQQ_CHAIN_ID\e[0m"
echo '================================================='
sleep 2

echo -e "\e[1m\e[32m1. Updating packages... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32m2. Installing dependencies... \e[0m" && sleep 1
# packages
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y

# install go
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

echo -e "\e[1m\e[32m3. Downloading and building binaries... \e[0m" && sleep 1
# download binary
cd $HOME
git clone https://github.com/haqq-network/haqq.git && cd haqq
make install

# config
haqqd config chain-id $HAQQ_CHAIN_ID
haqqd config keyring-backend test

# init
haqqd init $NODENAME --chain-id $HAQQ_CHAIN_ID

# download genesis
curl -OL https://storage.googleapis.com/haqq-testedge-snapshots/genesis.json
mv genesis.json $HOME/.haqqd/config/genesis.json
haqqd validate-genesis

# State Sync
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0aISLM\"/" $HOME/.haqqd/config/app.toml
curl -OL https://raw.githubusercontent.com/haqq-network/testnets/main/TestEdge/state_sync.sh
chmod +x state_sync.sh && ./state_sync.sh

# create service
sudo tee /etc/systemd/system/haqqd.service > /dev/null <<EOF
[Unit]
Description=haqq
After=network-online.target

[Service]
User=$USER
ExecStart=$(which haqqd) start --home $HOME/.haqqd
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# start service
sudo systemctl daemon-reload
sudo systemctl enable haqqd
sudo systemctl restart haqqd

echo '=============== SETUP FINISHED ==================='
echo -e 'To check logs: \e[1m\e[32msudo journalctl -u haqqd -f -o cat\e[0m'
echo -e "To check sync status: \e[1m\e[32mhaqqd status 2>&1 | jq .SyncInfo\e[0m" && sleep 1
