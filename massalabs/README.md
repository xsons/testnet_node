<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Telegram Beritacryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter Beritacryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

# setup node massalabs untuk testnet

Guide Source :
>- [@massacaptain](https://medium.com/@massacaptain/tutorial-praktis-testnet-berinsentif-massa-eps-13-d7d5f19f1462)

Dokumentasi Ofisial:
>- [Official](https://massa.readthedocs.io/en/latest/testnet/install.html)

Explorer:
>- https://massa.net/testnet/
## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4CORE |
| RAM | 8GB RAM  |
| Penyimpanan  | 200GB Disk |
| koneksi | Port 1 Gbit/dtk |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 atau lebih tinggi | 


## Siapkan fullnode massalabs Anda
### Open Port
```
ufw allow 31244 && ufw allow 31245 && ufw allow 22 && ufw allow ssh && ufw enable
```

### Gunakan perintah dibawah ini jika anda belum memiliki `Wallet Address Massa`.
```
wget -O massa.sh https://raw.githubusercontent.com/xsons/testnet_node/main/massalabs/massa.sh && chmod +x massa.sh && ./massa.sh
```
Masukan IP VPS kalian dan password. Jika Muncul sleep... langsung aja CTRL A + D

### Gunakan perintah dibawah ini jika anda sudah memiliki `Wallet Address Massa` dan ingin mengimport `Secret Key`.
```
wget -O import.sh https://raw.githubusercontent.com/xsons/testnet_node/main/massalabs/import.sh && chmod +x import.sh && ./import.sh
```
## Request faucet
Join discord [MASSALABS](https://discord.gg/massa), masuk ke chanel **#testnet-faucet**, paste address kalian.

## Buka info wallet kalian
```
cd massa/massa-client
./massa-client -p <passsword>
```
Ubah <password> menggunakan password kalian.

Setelah berada di folder `massa-client` jalankan perintah berikut:
```
wallet_generate_secret_key
```
Gunakan Perintah berikut untuk save SecretKeys, Public key, Address:
```
wallet_info
```
## Import wallet
Jika kalian telah membuat wallet sebelumnya gunakan perintah ini:
```
wallet_add_secret_keys <your_secret_key>
```
```
wallet_info
```




