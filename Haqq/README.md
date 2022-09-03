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
Import Private Key kalian ke metamask, dan gunakan wallet yang di bikin untuk meminta faucet
- Open Web: https://testedge.haqq.network/

## Membuat Validator
Sebelum membuat validator, pastikan Anda memiliki setidaknya 1 ISLM = 1000000 aISLM,dan node Anda tersinkronisasi

Untuk memeriksa saldo dompet Anda:
```console
haqqd query bank balances $HAQQ_WALLET_ADDRESS
```
> Jika dompet Anda tidak menunjukkan saldo apa pun, kemungkinan simpul Anda masih disinkronkan. Silahkan tunggu sampai selesai untuk sinkronisasi lalu lanjutkan
Untuk membuat perintah jalankan validator Anda di bawah ini
```console
haqqd tx staking create-validator \
  --amount 1000000aISLM \
  --pubkey $(haqqd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $HAQQ_CHAIN_ID \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1000000" \
  --gas-prices="0.025aISLM" \
  --from $WALLET \
  --node https://rpc.tm.testedge.haqq.network:443
  --keyring-backend file
```
Explorer: https://exp.nodeist.net/Haqq/staking

## Edit Validator
```console
haqqd tx staking edit-validator \
 --chain-id $HAQQ_CHAIN_ID \
 --identity="EB7784D8888B8552" \
 --details="Ente Emang Kadang Kadang Ente" \
 --website="www.bangpateng.com" \
 --from $WALLET \
 --fees 0.025aISLM \
 --keyring-backend file
```
## Hapus Node
```console
sudo systemctl stop haqqd
sudo systemctl disable haqqd
sudo rm /etc/systemd/system/haqq* -rf
sudo rm $(which haqqd) -rf
sudo rm $HOME/.haqqd* -rf
sudo rm $HOME/haqq -rf
sed -i '/HAQQ_/d' ~/.bash_profile
```
