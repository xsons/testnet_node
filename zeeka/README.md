<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
<img height="150" height="auto" src="https://user-images.githubusercontent.com/108946833/187458173-b6e71c5a-2b1e-4de8-9fb1-c4b69a6b4bd1.jpg">
</p>

# Zeeka Testnet

### Install Otomatis
```console
wget -O zk.sh https://raw.githubusercontent.com/xsons/TestnetNode/main/zeeka/zk.sh && chmod +x zk.sh && ./zk.sh
```
## Tambah Wallet
```
bazuka init --seed 'PHARSE_WALLET' --network debug --node IP_VPS:8765
```

### Create service
```
sudo tee <<EOF >/dev/null /etc/systemd/system/zeeka.service
[Unit]
Description=Zeeka node
After=network.target

[Service]
User=$USER
ExecStart=`RUST_LOG=info which bazuka` node --listen 0.0.0.0:8765 --external YOUR_IP_VPS:8765 --network debug --db ~/.bazuka-debug --bootstrap 152.228.155.120:8765 --bootstrap 95.182.120.179:8765 --bootstrap 195.2.80.120:8765 --bootstrap 195.54.41.148:8765 --bootstrap 65.108.244.233:8765 --bootstrap 195.54.41.130:8765 --bootstrap 185.213.25.229:8765 --bootstrap 195.54.41.115:8765 --bootstrap 62.171.188.69:8765 --bootstrap 49.12.229.140:8765 --bootstrap 213.202.238.77:8765 --bootstrap 5.161.152.123:8765 --bootstrap 65.108.146.132:8765 --bootstrap 65.108.250.158:8765 --bootstrap 195.2.73.130:8765 --bootstrap 188.34.167.3:8765 --bootstrap 188.34.166.77:8765 --bootstrap 45.88.106.199:8765 --bootstrap 79.143.188.183:8765 --bootstrap 62.171.171.11:8765 --bootstrap 65.108.201.41:8765 --bootstrap 159.203.176.252:8765 --bootstrap 194.163.191.80:8765 --bootstrap 146.19.207.4:8765 --bootstrap 135.181.43.174:8765 --bootstrap 95.111.234.205:8765 --bootstrap 192.241.131.113:8765 --bootstrap 45.67.217.16:8765 --bootstrap 65.108.157.67:8765 --bootstrap 65.108.251.175:8765 --bootstrap 95.216.204.235:8765 --bootstrap 45.82.178.159:8765 --bootstrap 161.97.111.145:8765 --bootstrap 149.102.133.130:8765 --bootstrap 65.108.61.32:8765 --bootstrap 95.216.204.32:8765 --bootstrap 188.34.160.74:8765 --bootstrap 185.245.183.246:8765 --bootstrap 213.246.39.14:8765 --discord-handle “YOUR DISCORD”
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
Ganti `YOUR_IP_VPS` dengan `IP VPS KALIAN`, dan ganti discord-handle `"YOUR DISCORD"` dengan user discord kalian

## Update Path
```console
cd bazuka
git pull origin master
cargo install --path .
```

### Start service
```console
sudo systemctl daemon-reload
sudo systemctl enable zeeka
sudo systemctl restart zeeka
```
## Check Log
```console
sudo journalctl -fu zeeka -o cat
```
- Paste IP Address Kalian di Discord: https://discord.gg/fPhwPzjs
- Isi Form: https://s.id/1gad7

## Backup Address
```
Internet endpoint: http://IPVPS:8765

Peer public-key: 0x76fb6baxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx6039c3

Wallet address: 0x76fb6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx039c3

Wallet zk address: 0x3402xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx9aa55d
```
## Hapus Node
```console
rustup self uninstall -y
rm -rf bazuka
rm -rf zk.sh
```
