<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/108946833/188787002-658bf009-a004-447d-979d-cf57e07b1ba1.jpg">
</p>

# Source Testnet

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4 or more physical CPU cores  |
| RAM | At least 8GB of memory (RAM) |
| Penyimpanan  | At least 160GB of SSD disk storage |
| koneksi | At least 100mbps network bandwidth |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 | 

## Install Otomatis
```console
wget -O source.sh https://raw.githubusercontent.com/xsons/TestnetNode/main/Source/source.sh && chmod +x source.sh && ./source.sh
```
Opsi 2 (manual)

Anda dapat mengikuti [panduan manual](https://github.com/xsons/TestnetNode/blob/main/Source/Manual.md) jika Anda lebih suka mengatur node secara manual

## Pasca Instalasi
Selanjutnya Anda harus memastikan validator Anda menyinkronkan blok. Anda dapat menggunakan perintah di bawah ini untuk memeriksa status sinkronisasi
```console
sourced status 2>&1 | jq .SyncInfo
```
## Membuat Wallet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```console
sourced keys add $SRC_WALLET
```
(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```console
sourced keys add $SRC_WALLET --recover
```
Untuk mendapatkan daftar dompet saat ini
```console
sourced keys list
```

## Simpan info dompet
Tambahkan alamat dompet dan valoper dan muat variabel ke dalam sistem
```console
SRC_WALLET_ADDRESS=$(sourced keys show $SRC_WALLET -a)
SRC_VALOPER_ADDRESS=$(sourced keys show $SRC_WALLET --bech val -a)
echo 'export SRC_WALLET_ADDRESS='${SRC_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export SRC_VALOPER_ADDRESS='${SRC_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```
Dapatkan Token Faucet Di Discord
>- [Discord Official Source](https://discord.gg/MgcfAgrD)

Untuk memeriksa saldo dompet Anda:
```console
sourced query bank balances $SRC_WALLET_ADDRESS
```
### Buat Validator
```console
sourced tx staking create-validator \
  --amount 999750usource \
  --from $SRC_WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(sourced tendermint show-validator) \
  --moniker $SRC_NODENAME \
  --chain-id $SRC_ID \
  --fees 250usource
```
## Perintah yang berguna
### Manajemen Pelayanan
Periksa log
```console
journalctl -fu sourced -o cat
```
Memulai layanan
```console
sudo systemctl start sourced
```
Hentikan layanan
```console
sudo systemctl stop sourced
```
Mulai ulang layanan
```console
sudo systemctl restart sourced
```
## Informasi simpul
Informasi sinkronisasi
```console
sourced status 2>&1 | jq .SyncInfo
```
Info validator
```console
seid status 2>&1 | jq .ValidatorInfo
```
Informasi simpul
```console
sourced status 2>&1 | jq .NodeInfo
```
Tampilkan id simpul
```console
sourced tendermint show-node-id
```
### Operasi dompet
Daftar dompet
```console
sourced keys list
```
Pulihkan dompet
```console
sourced keys add <wallet name> --recover
```
Hapus dompet
```console
sourced keys delete <wallet name>
```
Cadangan Kunci Pribadi
```console
sourced keys export <wallet name> --unarmored-hex --unsafe
```
Dapatkan saldo dompet
```console
sourced query bank balances <wallet address>
```
Transfer dana
```console
sourced tx bank send <wallet address> <to sei wallet address> 10000000usource
```
Pemungutan suara
```console
sourced tx gov vote 1 yes --from <wallet name> --chain-id=sourcechain-testnet
```
### Staking, Delegasi, dan Hadiah
Delegasikan saham
```console
sourced tx staking delegate <valoper address> 10000000usource --from=<waller name> --chain-id=sourcechain-testnet --gas=auto
```
Delegasikan ulang stake dari validator ke validator lain
```console
sourced tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usource --from=<wallet name> --chain-id=sourcechain-testnet --gas=auto
```
Tarik semua hadiah
```console
sourced tx distribution withdraw-all-rewards --from=<wallet name> --chain-id=sourcechain-testnet1 --gas=auto
```
Tarik hadiah dengan komisi
```console
sourced tx distribution withdraw-rewards <your valoper address> --from=<wallet name> --commission --chain-id=sourcechain-testnet
```

### Manajemen Validator
Edit validator
```console
sourced tx staking edit-validator \
  --moniker=<your moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=sourcechain-testnet \
  --from=<wallet name>
 ```
Unjail validator
```console
sourced tx slashing unjail \
  --broadcast-mode=block \
  --from=<your wallet name> \
  --chain-id=sourcechain-testnet \
  --gas=auto
 ```
## Hapus node

Hapus node Perintah ini akan menghapus node sepenuhnya dari server. Gunakan dengan risiko Anda sendiri!
```console
sudo systemctl stop sourced
sudo systemctl disable sourced
sudo rm /etc/systemd/system/sourced* -rf
sudo rm $(which sourced) -rf
sudo rm $HOME/.source* -rf
sudo rm $HOME/source -rf
sed -i '/SRC_/d' ~/.bash_profile
```
