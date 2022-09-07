### Preparing the server

    sudo apt update && sudo apt upgrade -y && \
    sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y

## GO 18.3 (one command)
```
ver="1.18.3" && \
cd $HOME && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```

# Binary   01.08.22
```console 
git clone -b testnet https://github.com/Source-Protocol-Cosmos/source.git
cd ~/source
make install
```
`sourced version --long | head`
- version: v1.0.0-2-ge06b810
- commit: e06b810e842e57ec8f5432c9cdd57883a69b3cee 

## Initialisation
```console
sourced init <moniker-name> --chain-id=sourcechain-testnet
```
## Add wallet
```console
sourced keys add <walletName>
sourced keys add <walletName> --recover
```
# Genesis
```console
curl -s  https://raw.githubusercontent.com/Source-Protocol-Cosmos/testnets/master/sourcechain-testnet/genesis.json > ~/.source/config/genesis.json
```

`sha256sum $HOME/.source/config/genesis.json`
- 2bf556b50a2094f252e0aac75c8018a9d6c0a77ba64ce39811945087f6a5165d  genesis.json

### Pruning (optional) one command
```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.source/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.source/config/app.toml
```
### Indexer (optional) one command
    indexer="null" && \
    sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.source/config/config.toml

### Set up the minimum gas price and Peers/Seeds/Filter peers
```console
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0usource\"/;" ~/.source/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.source/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.source/config/config.toml

peers="6ca675f9d949d5c9afc8849adf7b39bc7fccf74f@164.92.98.17:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.source/config/config.toml

seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.source/config/config.toml

sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.source/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.source/config/config.toml
```

## Download addrbook
```console
wget -O $HOME/.source/config/addrbook.json "https://raw.githubusercontent.com/obajay/nodes-Guides/main/Source/addrbook.json"
```

# Create a service file
```console
sudo tee /etc/systemd/system/sourced.service > /dev/null <<EOF
[Unit]
Description=source
After=network-online.target

[Service]
User=$USER
ExecStart=$(which sourced) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

# start the node
```console
sudo systemctl daemon-reload && \
sudo systemctl enable sourced && \
sudo systemctl restart sourced && \
sudo journalctl -u sourced -f -o cat
```

