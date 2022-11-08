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
## SnapShot 28.10.22 (0.1 GB) block height --> 2981026 by [obajay](https://github.com/obajay/nodes-Guides/tree/main/Source#snapshot-281022-01-gb-block-height----2981026)
```
# install the node as standard, but do not launch. Then we delete the .data directory and create an empty directory
sudo systemctl stop sourced
rm -rf $HOME/.source/data/
mkdir $HOME/.source/data/

# download archive
cd $HOME
wget http://116.202.236.115:7150/sourcedata.tar.gz

# unpack the archive
tar -C $HOME/ -zxvf sourcedata.tar.gz --strip-components 1
# !! IMPORTANT POINT. If the validator was created earlier. Need to reset priv_validator_state.json  !!
wget -O $HOME/.source/data/priv_validator_state.json "https://raw.githubusercontent.com/obajay/StateSync-snapshots/main/priv_validator_state.json"
cd && cat .source/data/priv_validator_state.json
{
  "height": "0",
  "round": 0,
  "step": 0
}

# after unpacking, run the node
# don't forget to delete the archive to save space
cd $HOME
rm sourcedata.tar.gz
# start the node
sudo systemctl daemon-reload && \
sudo systemctl enable sourced && \
sudo systemctl restart sourced && \
sudo journalctl -u sourced -f -o cat
```

## Membuat Wallet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```console
sourced keys add wallet
```
(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```console
sourced keys add wallet --recover
```
Untuk mendapatkan daftar dompet saat ini
```console
sourced keys list
```

## Simpan info dompet
Tambahkan alamat dompet dan valoper dan muat variabel ke dalam sistem
```console
SRC_WALLET_ADDRESS=$(sourced keys show wallet -a)
SRC_VALOPER_ADDRESS=$(sourced keys show wallet --bech val -a)
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
--amount=1000000usource \
--pubkey=$(sourced tendermint show-validator) \
--moniker=<moniker> \
--chain-id=sourcechain-testnet \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.1" \
--min-self-delegation="1" \
--fees=100usource \
--from=<walletName> \
--identity="" \
--website="" \
--details="" \
-y
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
sourced keys add $SRC_WALLET --recover
```
Hapus dompet
```console
sourced keys delete $SRC_WALLET
```
Cadangan Kunci Pribadi
```console
sourced keys export $SRC_WALLET --unarmored-hex --unsafe
```
Dapatkan saldo dompet
```console
sourced query bank balances $SRC_WALLET_ADDRESS
```
Transfer dana
```console
sourced tx bank send $SRC_WALLET_ADDRESS <TO_WALLET_ADDRESS> 10000000usource
```
Pemungutan suara
```console
sourced tx gov vote 1 yes --from $SRC_WALLET --chain-id=$SRC_ID
```
### Staking, Delegasi, dan Hadiah
Delegasikan saham
```console
sourced tx staking delegate $SRC_VALOPER_ADDRESS 10000000usource --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```
Delegasikan ulang stake dari validator ke validator lain
```console
sourced tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usource --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```
Tarik semua hadiah
```console
sourced tx distribution withdraw-all-rewards --from=$SRC_WALLET --chain-id=$SRC_ID --gas=auto --fees 250usource
```
Tarik hadiah dengan komisi
```console
sourced tx distribution withdraw-rewards $SRC_VALOPER_ADDRESS --from=$SRC_WALLET --commission --chain-id=$SRC_ID
```

### Manajemen Validator
Edit validator
```console
sourced tx staking edit-validator \
--moniker=NEWNODENAME \
--chain-id=$SRC_ID \
--from=$SRC_WALLET
 ```
Unjail validator
```console
sourced tx slashing unjail \
  --broadcast-mode=block \
  --from=$SRC_WALLET \
  --chain-id=$SRC_ID \
  --gas=auto --fees 250usource
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
