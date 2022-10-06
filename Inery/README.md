<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="50" height="auto" src="https://user-images.githubusercontent.com/38981255/184088981-3f7376ae-7039-4915-98f5-16c3637ccea3.PNG">
</p>

# Tutorial Become a Master Node

## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | Intel Core i7-8700 Hexa-Core  |
| RAM | DDR4 64 GB  |
| Penyimpanan  | 2x1 TB NVMe SSD |
| koneksi | Port 1 Gbit/dtk |

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | Intel Core i3 or i5 |
| RAM | 4 GB DDR4 RAM |
| Penyimpanan  | 500 GB HDD|
| koneksi | 100 Mbit/s port |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 18.04 atau lebih tinggi | 

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 16.04 | 

## Sebelum Menjalankan Node Register Akun Testnet
>- [Register](https://testnet.inery.io/)

Dokumen Official :
> [Node Lite & Master](https://docs.inery.io/docs/category/lite--master-nodes)

Explorer :
> [Explorer Inary](https://explorer.inery.io/ "Explorer Inary")

## Open Port
```
ufw allow 22 && ufw allow ssh && ufw allow 8888 && ufw allow 9010 && ufw enable
```

## Mengisntall Dependencies
```
sudo apt-get update && sudo apt install git && sudo apt install screen 
```
```
sudo apt-get install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5
```
## Install Node
- Unduh paket Inery Node
```
git clone  https://github.com/inery-blockchain/inery-node
```

## Explorer BIN
```
cd inery-node
```
## Beri Izin File

```
cd inery.setup
```
```
chmod +x ine.py
```
```
./ine.py --export
```
```
cd; source .bashrc; cd -
```
<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/108946833/194111185-74b2ea9d-d3db-4b5f-879e-eabc4eb1aa63.png">
</p>

## Konfigurasi Master Node

```
cd tools
```
```
nano config.json
```
temukan "MASTER_ACCOUNT" dan ganti placeholder IP = IP atau alamat DNS server
```
"MASTER_ACCOUNT":
"NAME": "AccountName",
"PUBLIC_KEY": "PublicKey",
"PRIVATE_KEY": "PrivateKey",
"PEER_ADDRESS": "IP:9010",
"HTTP_ADDRESS": "0.0.0.0:8888",
"HOST_ADDRESS": "0.0.0.0:9010"
```
Kemudian ganti account name, publickey, privatekey, ip (sesuai kan dengan yang ada di web testnetnya)

**Simpan (ctrl+S), Ketik "Y" dan keluar (ctrl+X)**

Jika kalian menggunakan [mobaxterm](https://mobaxterm.mobatek.net/download.html) bisa cari folder `/root/inery-node/inery.setup/tools/config.json`, Lalu simpan yang sudah di edit.
## Running Node
```
cd inery.setup
```
```
screen -S inery
```
```
./ine.py --master
```
<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/108946833/194216311-9c4238d2-3a6a-4aaf-ab39-cb4eeb9c4265.png">
</p>

**Ketik CTRL + A + D** Untuk jalan di Background dan Untuk Kembali lagi Ke Screen Gunakan Perintah `screen -rd inery`
