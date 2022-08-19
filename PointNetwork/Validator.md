<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/108946833/185566136-53e35398-2c9c-4eb3-99af-b93d150ab885.jpg">
</p>


# Join Point-XNet-Triton as a Validator
## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4 or more physical CPU cores  |
| RAM | At least 32GB of memory (RAM) |
| Penyimpanan  | At least 500GB of SSD disk storage |
| koneksi | At least 100mbps network bandwidth |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 18.04 atau lebih tinggi | 

 Sebelum Memulai jalanin NODE, kalian harus mempunyai dulu Faucet, dan isi form untuk melanjutkan ketahap berikutnya, dan add RPC XPOINT Ke metamask
- https://pointnetwork.io/testnet-form
```console 
Network Title: Point XNet Triton
RPC URL: https://xnet-triton-1.point.space/
Chain ID: 10721
SYMBOL: XPOINT
```

## Mempersiapkan server
```console 
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl build-essential git wget jq make gcc tmux -y
```
## Install GO
```console 
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
go version
```
## Unduh dan bangun binari
```console
cd $HOME
git clone https://github.com/pointnetwork/point-chain && cd point-chain
git checkout xnet-triton
make install
```
## Install Node
```console
export PATH=$PATH:$(go env GOPATH)/bin
evmosd config keyring-backend file
evmosd config chain-id point_10721-1
```
## Instalasi
```console
evmosd init [myvalidator] --chain-id point_10721-1
```
Di mana `[myvalidator]` adalah nama kustom validator Anda yang akan terlihat secara publik.
## Membuat Wallet 
```console
evmosd keys add validatorkey --keyring-backend file
```
- Jika address faucet kalian ingin di pakai silahkan gunakan cara ini:
```console
evmosd keys add validatorkey --recover
```
Rubah `validatorkey` dengan nama `validator` kalian.

## Unduh genesis dan addrbook
```console
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/config.toml
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/genesis.json
mv config.toml genesis.json ~/.evmosd/config/
```
## Validasi
```console
evmosd validate-genesis
```
## membuat Service
```console
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
```
## Daftar dan Mulai Layanan
```console
sudo systemctl daemon-reload && \
sudo systemctl enable evmosd && \
sudo systemctl restart evmosd && \
sudo journalctl -u evmosd -f -o cat
```
- Check SyncInfo

```console
evmosd status 2>&1 | jq .SyncInfo
```
Anda akan mendapatkan `"latest_block_height"` dari node Anda.

### Tambahkan dompet dengan 1024 XPOINT Anda

Supaya wallet evmos kita bisa di import ke metamask, gunakan perintah ini:
```console
evmosd keys unsafe-export-eth-key validatorkey --keyring-backend file
```
Ubah `validatorkey` dengan nama validator kalian.
![Screenshot_57](https://user-images.githubusercontent.com/108946833/185661523-a65e0667-13d5-4be7-b4ea-870405734b38.png)

Import `privatekey` yang di hasilkan ke metamask.
Selanjutnya kalian bisa send address dari address faucet ke address yang sudah di import ke metamask.
![Screenshot_58](https://user-images.githubusercontent.com/108946833/185662187-4098dbde-c35f-4015-94a2-7689c837bac9.png)

Jika sudah false kalian bisa check balance, dengan menggunkan cara ini:

- Untuk Check balances
```console
evmosd query bank balances <evmosaddress>
```
- Untuk Melihat Wallet
```console
evmosd keys list
```
## Membuat Validator
```console
evmosd tx staking create-validator \
  --amount 1000000000000000000000apoint \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1000000000000000000000" \
  --pubkey  $(evmosd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $POINT_CHAIN_ID
```
## Explorer
https://explorer-xnet-triton.point.space/

## Menghapus Node
```console
sudo systemctl stop evmosd
sudo systemctl disable evmosd
sudo rm /etc/systemd/system/evmos* -rf
sudo rm $(which evmosd) -rf
sudo rm $HOME/.evmosd -rf
sudo rm $HOME/point-chain -rf
````
