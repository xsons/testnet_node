# NuLink  Phase 2 Worker  update 
```
sudo ufw allow ssh && sudo ufw allow 9151 && sudo ufw allow 9152
```
### List containers in tabular structure
```
docker ps
``` 
<p align="center">
  <img width="700" height="auto" src="https://user-images.githubusercontent.com/108946833/197376579-4e7cc04a-eb93-4aff-a3c8-7ec7e42cdc31.png">
</p>

Salin container id

## Hentikan node yang sedang berjalan di Docker
```
docker kill <container ID>
```
Contoh: 
``` 
docker kill 123abcd456
```

<img width="368" alt="4" src="https://user-images.githubusercontent.com/108946833/197376876-5dfe3ac9-fd5c-40a4-b5cc-df8bea47488c.png">

### Tarik gambar NuLink terbaru:
```
docker pull nulink/nulink:latest
```
<img width="518" alt="6" src="https://user-images.githubusercontent.com/108946833/197377083-387e1ad3-0465-4275-abe4-6c338084f9ea.png">

### Luncurkan kembali node pekerja:
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
### Akun staking atau akun pekerja hilang
Kasus #2 Sedikit rumit karena Anda harus mengganti port ke 9152

Jika akun staking atau akun pekerja hilang (ini berarti Anda tidak dapat login akun staking Anda di Metamask atau file keystore Anda di direktori host dihapus), maka prosedur pembaruan sedikit rumit. Berikut adalah cara menyarankan.

## Hentikan dan hapus node yang sedang berjalan di Docker
```
docker ps
```
- Kill containerID yang sedang berjalan
```
docker kill <containerID>
```
**Contoh Seperti yang sudah ada di atas**

- Hapus Docker node yang sedang berjalan
```
docker rm ursula
```
### Tarik gambar nulink terbaru
```
docker pull nulink/nulink:latest
```
### Hapus direktori host lama dan buat direktori host baru
```
cd /root
rm -rf nulink
```
- Buat folder nulink baru
```
mkdir nulink
```
### Salin file keystore dari akun Worker ke direktori host
```
cp <keystore path> /root/nulink
```
ubah `<keystore path>`dengan jalur keystore dari kunci Anda`CONTOH PERINTAH SAYA`:
```
cp /root/geth-linux-amd64-1.10.24-972007a5/keystore/key /root/nulink
```
Cari dulu di folder `/root/geth-linux-amd64-1.10.24-972007a5/keystore/` apakah punya kalian `KEY` atau `UTC--2022-09-17T05-27-00.315775527Z--b045627fd6c57577bba32192d8XXXXXXX`

- Kemudian beri izin `/root/nulink`
```
chmod -R 777 /root/nulink
```
### OPSIONAL !!!! (jika Anda kehilangan akun pekerja lama, Anda dapat membuat yang baru menggunakan perintah sederhana ini lalu salin file keystore )
```
wget -O nulink.sh https://raw.githubusercontent.com/xsons/testnet_node/main/nulink/nulink.sh && chmod +x nulink.sh && ./nulink.sh
```
Anda akan diminta untuk memasukkan kata sandi Keystore, gunakan kata sandi yang sederhana dan kuat yang dapat Anda ingat

## Tetapkan Variabel
```
export NULINK_KEYSTORE_PASSWORD=<YOUR PASSWORD>
```
```
export NULINK_OPERATOR_ETH_PASSWORD=<YOUR PASSWORD>
```
ubah `<YOUR PASSWORD>`dengan kata sandi yang Anda masukkan sebelumnya agar Anda dapat mengingatnya.

## Inisialisasi Konfigurasi Node dengan port 9152 karena Anda kehilangan akun dan url lama selalu terikat
```
docker run -it --rm \
-p 9152:9152 \
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
Ubah `<Path of the secret key file>`Dengan jalur keystore Anda, Hanya Salin nama setelah UTC ,`UTC--2022-09-17T05-27-00.315775527Z--b045627fd6c57577bba32192d8e47XXXXXXXX` jika `KEY` isi aja `KEY`

Ubah `<YOUR PUBLIC ADDRESS>`Dengan alamat publik Anda yang dihasilkan setelah Anda Menggunakan skrip instal otomatis

CONTOH PERINTAH SAYA:
```
docker run -it --rm \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/key \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545  \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address 0x04E0DECDd3E95109641XXXXXXXXXXXXXXXXXX \
--max-gas-price 100
```
**DISI JANGAN LUPA SAVE MNEMONIC 24 KATA NYA, JANGAN KETIK Y DULU SEBELUM MENYIMPAN.. HARAP TELITI!!**

## Luncurkan node dengan konfigurasi baru
```
docker run --restart on-failure -d \
--name ursula \
-p 9152:9152 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run \
--rest-port 9152 \
--config-file /home/circleci/.local/share/nulink/ursula.json \
 --no-block-until-ready
 ```


### Periksa log:
```
docker logs -f ursula
```
Jika ada error seperti ini, gunakan cara berikut:
![image](https://user-images.githubusercontent.com/108946833/197377237-48cfe048-1880-49b5-be63-fa2abbf5852d.png)


**NOTE** Pastikan memasukkan sejumlah kecil BNB(test) ke akun pekerja untuk mengirim satu transaksi konfirmasi.
