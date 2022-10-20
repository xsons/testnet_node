<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Our Telegram BeritaCryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter BeritaCryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img width="700" height="auto" src="https://user-images.githubusercontent.com/107190154/190568136-14f5a7d8-5b15-46fb-8132-4d38a0779171.gif">
</p>

## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 2-4vCPU |
| RAM | 4 GB RAM  |
| Penyimpanan  | 30GB SSD |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 | 


## Pra-Instalasi

**PERINGATAN!!** Untuk menjalankan Nulink, Anda memerlukan IPV4 statis, saat ini nulink tidak mendukung IPV6

Jalankan pertama sebagai pengguna Super dan buka port

```
sudo su && sudo ufw enable &&sudo ufw allow 9151
```
## Siapkan Nulink Fullnode Anda
Anda dapat mengatur nulink fullnode Anda dalam beberapa menit dengan menggunakan skrip otomatis di bawah ini. Ini akan meminta Anda untuk memasukkan nama node validator Anda!
```
wget -O nulink.sh https://raw.githubusercontent.com/xsons/testnet_node/main/nulink/nulink.sh && chmod +x nulink.sh && ./nulink.sh
```

## Pasca-Instalasi
Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```
source $HOME/.bash_profile
```
Setelah menjalankan Instalasi otomatis, Anda harus memasang `Password`Twice. Anda akan mendapatkan Informasi tentang kunci Anda jangan lupa SAVE IT ! Pertunjukannya hanya sekali.

## Mempersiapkan
Setelah menjalankan perintah instal otomatis, Anda akan melihat output bahwa file keystore Anda disimpan di`/root/geth-linux-amd64-1.10.24-972007a5/keystore/UTC-XXXXX`

Ubah nama keystore `UTC-XXXX`menjadi keydengan perintah `mv`misalnya`mv UTC--2022-09-17T05-27-00.315775527Z--b045627fd6c57577bba32192d8XXXXXXXX key`

Salin file keystore ke direktori nulink yang baru saja kita buat
```
cp <keystore path> /root/nulink
```
Contoh :
```
cp /root/geth-linux-amd64-1.10.24-972007a5/keystore/key /root/nulink
```
**CATATAN** : JIKA ERROR COBALAH MEMBUAT DIRECTORY NULINK DENGAN COMMAND BERIKUT , `cd /root`setelah `mkdir nulink`itu coba copy lagi file tersebut.

## Izin
Berikan akses root, jika tidak, Anda akan mengalami kesalahan!
```
chmod -R 777 /root/nulink
```

## Tetapkan variabel

memuat variabel ke dalam sistem

```
export NULINK_KEYSTORE_PASSWORD=<YOUR PASSWORD>

export NULINK_OPERATOR_ETH_PASSWORD=<YOUR PASSWORD>
```
Ganti `<YOUR PASSWORD>`dengan kata sandi yang Anda masukkan sebelumnya agar Anda dapat mengingatnya.

## Konfigurasi
Atur konfigurasi buruh pelabuhan
```
docker run -it --rm \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/<Path of the secret key file> \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address <YOUR PUBLIC ADDRESS> \
--max-gas-price 100
```
Ubah `<Path of the secret key file>`Dengan jalur keystore Anda. Ubah `<YOUR PUBLIC ADDRESS>`Dengan alamat publik Anda yang dihasilkan setelah Anda menggunakan skrip pemasangan otomatis

Contoh :
```
docker run -it --rm \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/key \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address 0xB045627Fd6c57577Bba32192d8EXXXXXXXXXXXXXXX \
--max-gas-price 100
```
## Penting!

- Setelah itu Anda akan mendapatkan output dari frase benih Anda`DONT FORGET TO COPY AND SAVE IT` !!!
- Dan Anda akan diminta untuk Mengonfirmasi frasa benih Anda, Salin/Tempel frasa benih yang Anda simpan.
- Setelah itu Anda akan mendapatkan konfirmasi, Cukup ketik `y`dan enter

Ini adalah output setelah Anda menyelesaikan Konfigurasi

Anda dapat membagikan alamat Publik Anda dengan siapa pun









