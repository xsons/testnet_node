<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img width="100" height="auto" src="https://user-images.githubusercontent.com/50621007/165930080-4f541b46-1ae3-461c-acc9-de72d7ab93b7.png">
</p>

## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 8 cores (Intel Xeon Skylake or newer) |
| RAM | 32GB RAM  |
| Penyimpanan  | 300GB |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 18.04 atau lebih tinggi | 

# Pendaftaran Aptos AIT3
Untuk berpartisipasi dalam program AIT-3, ikuti langkah-langkah di bawah ini. Gunakan langkah-langkah ini sebagai daftar periksa untuk melacak kemajuan Anda. Klik tautan di setiap langkah untuk dokumentasi terperinci.

## Pendaftaran Komunitas Aptos 
> https://aptoslabs.com/incentivized-testnet
## Buat Wallet di Petra
> https://github.com/aptos-labs/aptos-core/releases/tag/wallet-v0.1.6

## Install Aptos Validator 
Gunakan skrip di bawah ini untuk instalasi cepat
```console
wget -qO validator.sh https://raw.githubusercontent.com/xsons/TestnetNode/main/Aptos/validator.sh && chmod +x validator.sh && ./validator.sh
```
Ketika instalasi sudah selesai, silahkan muat variable ke dalam sistem 
```console
source $HOME/.bash_profile
```
## Aktifkan Port
```console
apt install ufw -y
ufw allow ssh && ufw allow https && ufw allow http && ufw allow 6180 && ufw allow 80 && ufw allow 9101 && ufw allow 6181 && ufw allow 6182 && ufw allow 8080 && ufw allow 9103
ufw enable
```
## Cek Kesehatan Node
- Buka https://node.aptos.zvalid.com/
- Masukan IP VPS
- Maka kalian akan melihat seperti ini

![Screenshot_60](https://user-images.githubusercontent.com/108946833/185748598-d4a864d4-b382-49d8-9c26-a67eb2e225c9.png)
