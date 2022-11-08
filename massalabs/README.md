<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Telegram Beritacryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter Beritacryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

# setup node massalabs untuk testnet

Guide Source :
>- [@massacaptain](https://medium.com/@massacaptain/tutorial-praktis-testnet-berinsentif-massa-eps-13-d7d5f19f1462)
>- [mdlog](https://github.com/mdlog/testnet-mdlog/tree/main/massa)

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
## Request faucet
Join discord [MASSALABS](https://discord.gg/massa), masuk ke chanel **#testnet-faucet**, paste address kalian.
Setelah meminta faucet cek `wallet_info`, tunggu sampai balance kalian terpotong, karena menggunakan script otomatis, jika tidak gunakan secara manual:
```
buy_rolls <address> <roll count> <fee>
```
Contoh:
```
buy_rolls A12P7TtoTt4fv2arKt1SUdHvpgiTac5FX8fffjojniiWcgtRJtJd 1 0
```

## Menambahkan Staking address
```
node_add_staking_secret_keys <your_secret_key>
```
## Registrasi di bot discord massalabs
Masuk ke chanel **#testnet-rewards-registration**
![image](https://user-images.githubusercontent.com/108946833/200548458-923c89aa-117c-4603-bbd4-213bfc2f33a6.png)
Cek DM di bot massalabs
![image](https://user-images.githubusercontent.com/108946833/200548950-2545d09b-ad03-4374-b91e-eed5e484a756.png)

## Registrasi testnet Reward
Gunakan perintah ini folder `massa-client`:
```
node_testnet_rewards_program_ownership_proof your_staking_address discord ID
```
Contoh:
```
node_testnet_rewards_program_ownership_proof abcdeefeahgaghagagyaahvanawtu 5488946548795651
```
Copy balasan yang diterima di vps, kemudian paste ke bot `massabot`
![image](https://user-images.githubusercontent.com/108946833/200550287-100369ed-21e8-4cf6-bcb0-64f027d6074a.png)

## Input IP VPS
Paste IP VPS kalian ke `massabot`
![image](https://user-images.githubusercontent.com/108946833/200550598-f8b0c1fd-ac30-42c3-b6ae-6ef371ce6438.png)
Untuk memeriksa skoring ketik `info` di bot `massabot`

## Cek open port
>- https://www.yougetsignal.com/tools/open-ports/

## Cek logs
```
sudo tail -f /root/massa/massa-node/logs.txt
```
## Bot telegram
>- https://t.me/massacheck_bot




