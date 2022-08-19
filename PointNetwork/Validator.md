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
Jika Ingin Recover wallet
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

Ingat dompet yang Anda kirimkan kepada kami untuk didanai? Di formulir? Sekarang dompet tersebut memiliki 1024 XPOINT.

Impor dompet dengan kunci pribadi ke dalam dompet Anda (misalnya Metamask), dan Anda akan melihat 1024 XPOINT di sana. Tapi ini adalah dompet dana Anda, bukan dompet validator.

### Cari tahu alamat mana yang merupakan dompet validator Anda

Evmos memiliki dua format dompet: Format Cosmos, dan format Ethereum. Format Cosmos dimulai dengan awalan `evmos`, dan format Ethereum dimulai dengan `0x`. Kebanyakan orang tidak perlu tahu tentang format Cosmos, tetapi validator harus memiliki cara untuk mengubah dari satu format ke format lainnya.

Jalankan ```evmosd keys list --keyring-backend file```, dan Anda akan melihat daftar key yang terpasang pada node Anda. Lihatlah salah satu yang memiliki nama `validatorkey``, dan catat alamatnya (harus dalam format Cosmos dan dimulai dengan awalan `evmos`).

(Dalam kebanyakan kasus, hal ini tidak diperlukan, tetapi jika terjadi kesalahan dan jika anda ingin mengimpor dompet validator anda di Metamask anda, anda akan memerlukan private key. Anda bisa mendapatkannya dengan perintah ini: `evmosd keys unsafe-export-eth-key validatorkey --keyring-backend file`)

Gunakan alat ini untuk mengubahnya ke format Ethereum: https://evmos.me/utils/tools

Ini adalah alamat validator Anda dalam format Ethereum.

### Danai validator

Terakhir, gunakan dompet untuk mengirim berapa pun yang Anda butuhkan dari alamat dana Anda ke alamat validator (Anda dapat mengirim semua 1024 atau memilih strategi yang berbeda).

## Stake XPOINT dan Bergabunglah sebagai Validator

Sekarang Anda harus menunggu node untuk sepenuhnya tersinkronisasi, karena jika tidak, node tidak akan menemukan Anda.

Setelah node sepenuhnya disinkronkan, dan Anda punya beberapa XPOINT untuk dipertaruhkan, periksa saldo Anda di node, Anda akan melihat saldo Anda di Metamask. 
Anda akan melihat saldo Anda di Metamask atau Anda dapat memeriksa saldo Anda dengan perintah ini:

- Untuk Check Saldo
```console
evmosd query bank balances <evmosaddress>
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
## Menghapus Node
```console
sudo systemctl stop evmosd
sudo systemctl disable evmosd
sudo rm /etc/systemd/system/evmos* -rf
sudo rm $(which evmosd) -rf
sudo rm $HOME/.evmosd -rf
sudo rm $HOME/point-chain -rf
````
