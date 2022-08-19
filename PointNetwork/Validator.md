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
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```
## Install GO
```console 
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
## Jalankan Node
```console
screen -R Point
evmosd start
```
Untuk Kembali ke screen 
```console
screen -Rd Point
```
