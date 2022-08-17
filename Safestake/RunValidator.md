## Panduan tentang cara bergabung dengan testnet Ropsten
#TestingTheMerge adalah inisiatif komunitas Ethereum untuk menguji upgrade gabungan dengan berbagai testnet. Tombak itu dipimpin oleh Marius van der Wijden dan Parithosh Jayanthi . Ini dimaksudkan untuk menguji fitur eksperimental terbaru yang ditambahkan ke berbagai klien Ethereum yang mendukung peningkatan protokol ini.

Panduan ini ditujukan untuk orang-orang dengan sedikit atau sedikit pengalaman dalam menjalankan klien Ethereum dan menggunakan antarmuka baris perintah (CLI). Ini akan menunjukkan kepada Anda langkah demi langkah bagaimana mengatur mesin Anda untuk bergabung dengan testnet Ropsten dengan memberi Anda petunjuk untuk menginstal dan mengkonfigurasi semua alat yang diperlukan. Ini akan menganggap Anda menggunakan distribusi linux modern dengan systemd dan APT (seperti Ubuntu 20.04 atau Ubuntu 22.04, tetapi harus bekerja pada turunan debian terbaru) pada CPU x86 modern (Intel, AMD). Lebih baik menginstal sistem operasi Anda pada mesin khusus atau mesin virtual sebelum melanjutkan.

## Ringkasan 

Kami akan menggunakan versi terbaru untuk Geth dan versi terbaru untuk Lighthouse. Kami akan mengonfigurasinya untuk terhubung ke testnet Ropsten.

## Menjalankan perintah

Hampir semua perintah ini akan dilakukan di terminal. Mulai aplikasi Terminal Anda. Setiap baris yang dimulai dengan tanda dolar ( `$`) adalah perintah yang perlu dijalankan di terminal Anda. Jangan masukkan tanda dolar ( `$`) di terminal Anda, hanya teks yang muncul setelah itu.

Menjalankan perintah dengan `sudo` kadang-kadang akan menanyakan kata sandi Anda. Pastikan untuk memasukkan kata sandi akun Anda dengan benar. Anda dapat menjalankan perintah lagi jika Anda gagal memasukkan kata sandi yang benar setelah beberapa kali mencoba.

## Menjalankan perintah 

Hampir semua perintah ini akan dilakukan di terminal. Mulai aplikasi Terminal Anda. Setiap baris yang dimulai dengan tanda dolar ( `$`) adalah perintah yang perlu dijalankan di terminal Anda. Jangan masukkan tanda dolar ( `$`) di terminal Anda, hanya teks yang muncul setelah itu.

Menjalankan perintah dengan `sudo` kadang-kadang akan menanyakan kata sandi Anda. Pastikan untuk memasukkan kata sandi akun Anda dengan benar. Anda dapat menjalankan perintah lagi jika Anda gagal memasukkan kata sandi yang benar setelah beberapa kali mencoba.

## Menginstal Prasyarat
```
sudo apt -y update
sudo apt -y upgrade
```
```
sudo apt -y install software-properties-common wget curl ccze
```
## Installing Geth
```
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt -y install geth
```

## Installing Lighthouse

```
cd ~
wget https://github.com/sigp/lighthouse/releases/download/v2.4.0/lighthouse-v2.4.0-x86_64-unknown-linux-gnu.tar.gz
tar xvf lighthouse-v2.4.0-x86_64-unknown-linux-gnu.tar.gz
rm lighthouse-v2.4.0-x86_64-unknown-linux-gnu.tar.gz
```
Instal versi Lighthouse ini secara global.
```
sudo cp ~/lighthouse /usr/local/bin
rm ~/lighthouse
```
## Membuat file token JWT
Buat file token JWT di lokasi netral dan buat agar dapat dibaca oleh semua orang. Kami akan menggunakan `/var/lib/ethereum/jwttoken` untuk menyimpan file token JWT.
```
sudo mkdir -p /var/lib/ethereum
openssl rand -hex 32 | tr -d "\n" | sudo tee /var/lib/ethereum/jwttoken
sudo chmod +r /var/lib/ethereum/jwttoken
```
