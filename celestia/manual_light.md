<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Our Telegram BeritaCryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter BeritaCryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img width="100" height="auto" src="https://user-images.githubusercontent.com/50621007/170463282-576375f8-fa1e-4fce-8350-6312b415b50d.png">
</p>

# Instal simpul Cahaya
Untuk mengatur simpul cahaya ikuti langkah-langkah di bawah ini

## Persyaratan perangkat keras
Persyaratan minimum perangkat keras berikut direkomendasikan untuk menjalankan light node:
- Memory: 2 GB RAM
- CPU: Single Core
- Disk: 5 GB SSD Storage
- Bandwidth: 56 Kbps for Download/56 Kbps for Upload

## Perbarui paket
```
sudo apt update && sudo apt upgrade -y
```

## Instal dependensi
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y
```

## Install go
```
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
```

## Instal Celestia Node
```
cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
make install
```

## Inisialisasi simpul cahaya
```
celestia light init --core.remote tcp://<validator_node_ip>:26657 --core.grpc tcp://<validator_node_ip>:9090
```

## Buat layanan ringan
```
tee /etc/systemd/system/celestia-light.service > /dev/null <<EOF
[Unit]
Description=celestia-light Cosmos daemon
After=network.target
[Service]
Type=simple
User=$USER
ExecStart=$HOME/go/bin/celestia light start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

## Daftar dan mulai layanan ringan
```
sudo systemctl daemon-reload
sudo systemctl enable celestia-light
sudo systemctl restart celestia-light
```

## Periksa log simpul cahaya
```
journalctl -u celestia-light -f -o cat
```
