<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://discord.gg/JqQNcwff2e" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="50" height="auto" src="https://user-images.githubusercontent.com/38981255/184088981-3f7376ae-7039-4915-98f5-16c3637ccea3.PNG">
</p>

# Tutorial Become a Lite Node

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
Register: 

## Mengisntall Dependencies
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
- Ekspor jalur bin
Setelah unduhan selesai, buka direktori `inery.node`
```
cd inery-node 
```
Di dalam inery-node ada direktori inery dan `inery.setup` direktori inery berisi semua binari agar protokol blockchain berfungsi, jalur binari tersebut harus diekspor ke lingkungan OS
```
ls    
inery inery.setup
```
Buka direktori `inery.setup`
```
cd inery.setup
```
Di dalam inery.setup ada direktori ine.py dan tools
Berikan izin skrip ine.py untuk dieksekusi dengan perintah `"chmod"`:
```
chmod +x ine.py
```
Untuk mengekspor jalur ke lingkungan os lokal untuk binari inery, di dalam inery.setup jalankan skrip `ine.py` dengan opsi `--export`
```
./ine.py --export
```
Skrip telah menulis jalur ke file `.bashrc`, sekarang agar dapat berfungsi, Anda menempelkan baris ini di terminal, itu akan menyegarkan variabel jalur lingkungan untuk sesi terminal saat ini
```
cd; source .bashrc; cd -
```
## Menjadi Simpul Ringan
- Konfigurasikan IP
untuk mengonfigurasi node dengan informasi IP server Anda, buka `inery-node/inery.setup/tools/` buka `config.json`
```
cd tools
nano config.json
```
temukan `"LITE_NODE"` dan ganti placeholder
IP = IP atau alamat DNS server
```
 "LITE_NODE" : {
        "PEER_ADDRESS" : "IP:9010",
        "HTTP_ADDRESS": "0.0.0.0:8888",
        "HOST_ADDRESS": "0.0.0.0:9010"
    },
```
