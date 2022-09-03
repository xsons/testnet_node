<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img width="100" height="auto" src="https://user-images.githubusercontent.com/38981255/187036471-e23ab080-2e03-46b7-8513-23e1f6612b4a.png">
</p>

# Haqq Testnet
## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4 cores (Intel Xeon Skylake or newer) |
| RAM | 32GB RAM  |
| Penyimpanan  | 500GB |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 | 

## Install Otomatis
```console
wget -O haqq.sh https://raw.githubusercontent.com/xsons/TestnetNode/main/Haqq/haqq.sh && chmod +x haqq.sh && ./haqq.sh
```
Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```console
source $HOME/.bash_profile
```
Selanjutnya Anda harus memastikan validator Anda menyinkronkan blok. Anda dapat menggunakan perintah di bawah ini untuk memeriksa status sinkronisasi
```console
haqqd status 2>&1 | jq .SyncInfo
```
Jika log status kosong, gunakan perintah ini
```console
sudo systemctl stop haqqd 
haqqd tendermint unsafe-reset-all --home $HOME/.haqqd --keep-addr-book 
pruning="custom" 
pruning_keep_recent="100" 
pruning_keep_every="0" 
pruning_interval="10" 
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.haqqd/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.haqqd/config/app.toml 
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.haqqd/config/app.toml 
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.haqqd/config/app.toml 
cd 
rm -rf ~/.haqqd/data; \ 
wget -O - http://snap.stake-take.com:8000/haqq.tar.gz | tar xf - 
mv $HOME/root/.haqqd/data $HOME/.haqqd 
rm -rf $HOME/root 
wget -O $HOME/.haqqd/config/addrbook.json "https://raw.githubusercontent.com/StakeTake/guidecosmos/main/haqq/haqq_53211-1/addrbook.json" 
sudo systemctl restart haqqd && journalctl -u haqqd -f -o cat
```
## Membuat wallet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```console
haqqd keys add $WALLET
```
(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```console
haqqd keys add $WALLET --recover
```
Untuk mendapatkan daftar dompet saat ini
```console
haqqd keys list
```
## Simpan info dompet
Tambahkan dompet dan alamat valoper ke dalam variabel
```console
HAQQ_WALLET_ADDRESS=$(haqqd keys show $WALLET -a)
HAQQ_VALOPER_ADDRESS=$(haqqd keys show $WALLET --bech val -a)
echo 'export HAQQ_WALLET_ADDRESS='${HAQQ_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export HAQQ_VALOPER_ADDRESS='${HAQQ_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Faucet haqq
Jalankan Perintah Untuk Mendapatkan Private Key
```console
haqqd keys unsafe-export-eth-key $WALLET --keyring-backend file
```
