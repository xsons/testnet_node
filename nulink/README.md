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
sudo su && sudo ufw enable && sudo ufw allow 9151
```
## Siapkan Nulink Fullnode Anda
Anda dapat mengatur nulink fullnode Anda dalam beberapa menit dengan menggunakan skrip otomatis di bawah ini. Ini akan meminta Anda untuk memasukkan nama node validator Anda!
```
wget -O nulink.sh https://raw.githubusercontent.com/xsons/testnet_node/main/nulink/nulink.sh && chmod +x nulink.sh && ./nulink.sh
```
Setelah selesai instalasi jangan lupa isi password,, dan simpan output yang keluar dan kirim BNB TESTNET ke `Public address of the key:  0x09F8D521efcdED0aeee152xxxxxxxxxxxxxxxxxx
` 
![image](https://user-images.githubusercontent.com/108946833/197748078-7244b4a0-eb71-46e3-9eb1-95172ffe9b17.png)

## Instalasi Pekerja NuLink
- Salin file keystore akun Worker ke direktori host yang dipilih pada langkah di atas. File pribadi yang dihasilkan oleh NuLink Worker juga akan disimpan di direktori ini. Harap pastikan bahwa direktori ini memiliki 777 izin.
```
chmod -R 777 /root/nulink
```
- lalu ketik cp xxxxxxxx /root/nulink

- Ganti `xxxxxxx`dengan Jalan Andasecret key file

![image](https://user-images.githubusercontent.com/108946833/197749979-7acde69d-0a3d-4194-976b-95a311d994b9.png)

## Tetapkan variabel

memuat variabel ke dalam sistem

```
export NULINK_KEYSTORE_PASSWORD=YOUR PASSWORD

export NULINK_OPERATOR_ETH_PASSWORD=YOUR PASSWORD
```
Ganti `YOUR PASSWORD`dengan kata sandi yang Anda masukkan sebelumnya agar Anda dapat mengingatnya.

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
--signer keystore:///code/UTC--2022-10-20T13-04-13.493677917Z--04e0decdd3e9510964XXXXXXXXXXXXXXX \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address 0xB045627Fd6c57577Bba32192d8EXXXXXXXXXXXXXXX \
--max-gas-price 100
```

<p align="center">
  <img width="900" height="auto" src="https://user-images.githubusercontent.com/108946833/196959804-6e771ae0-ea90-40d6-905a-451f7a14dae3.png">
</p>


Yang ada di kotak itu harus di save.. Itu mnemonic punya sendiri.. 

## Penting!

- Setelah itu Anda akan mendapatkan output dari frase benih Anda`DONT FORGET TO COPY AND SAVE IT` !!!
- Dan Anda akan diminta untuk Mengonfirmasi frasa benih Anda, Salin/Tempel frasa benih yang Anda simpan.
- Setelah itu Anda akan mendapatkan konfirmasi, Cukup ketik `y`dan enter

Ini adalah output setelah Anda menyelesaikan Konfigurasi

Anda dapat membagikan alamat Publik Anda dengan siapa pun
<p align="center">
  <img width="1000" height="auto" src="https://user-images.githubusercontent.com/108946833/196960479-7644f448-8ab9-4f31-8d40-68fd4d99988b.png">
</p>

## Mulai Node
Kemudian kita memulai node dengan perintah berikut (One Command)
```
docker run --restart on-failure -d \
--name ursula \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready
```
## Keamanan
### Keamanan Firewall Dasar
Mulailah dengan memeriksa status ufw.
```
sudo ufw status
```
Setel default untuk mengizinkan koneksi keluar, tolak semua yang masuk kecuali ssh dan 26656. Batasi upaya login SSH
```
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow ${GRAVITY_PORT}656,${GRAVITY_PORT}660/tcp
sudo ufw enable
```

## Update node
```
wget -O update.sh https://raw.githubusercontent.com/xsons/testnet_node/main/nulink/update.sh && chmod +x update.sh && ./update.sh
```

## Periksa log
```
docker logs -f ursula
```
keluaran:
<p align="center">
  <img width="1000" height="auto" src="https://user-images.githubusercontent.com/108946833/196962686-1afddabd-760d-4530-a603-fe6c3179cc42.png">
</p>

Setelah itu tugas Anda untuk menjalankan node selesai sekarang mari kita lanjutkan ke langkah berikutnya.

## Mempertaruhkan
- Buka halaman Staking https://test-staking.nulink.org/faucet
- Hubungkan Metamask Anda, Anda dapat menggunakan akun Metamask apa pun
- Dapatkan token BSC Testnet di [Faucet BNB](https://testnet.binance.org/faucet-smart)
- Saat Anda mendapatkan tes BSC, sekarang minta faucet di Nulink Faucet
- Buka Halaman [Staking](https://test-staking.nulink.org/) dan Taruh Nulink Anda dan Tekan Konfirmasi dan setujui transaksi di Metamask Anda

<p align="center">
  <img width="1000" height="auto" src="https://user-images.githubusercontent.com/108946833/196966897-42296628-c89e-4619-a89a-86098e696c07.png">
</p>

## Bond Worker
Gulir ke bawah dan klik `Bond Worker`
<p align="center">
  <img width="1000" height="auto" src="https://user-images.githubusercontent.com/108946833/196967833-ff31b1ef-9832-439d-9496-8911adf8e7fc.png">
</p>

Isi formulir:
- `Worker Adress`Harus menjadi alamat publik Anda
- `Node Url`Harus menjadi `https://IP:9151/`Contoh Anda `https://12.452.36.234:9151/`(Pastikan untuk Menyalin semuanya! jangan lewatkan `/`atau Anda akan mendapatkan kesalahan)
- Klik Bond dan Setujui Transaksi di Metamask Anda

Setelah itu akan muncul node anda Online, jika masih muncul `Offline`Jangan khawatir akan `Online`segera muncul.

![image](https://user-images.githubusercontent.com/108946833/196969560-6403f300-b26d-4973-8b92-4400eef4ca2f.png)

## Hapus Node
```
cd $HOME && docker stop ursula && docker rm ursula && rm -rf ~/{geth-linux-amd64-1.10.24-972007a5,geth-linux-amd64-1.10.24-972007a5.tar.gz,nulink,nulink.sh}
```
