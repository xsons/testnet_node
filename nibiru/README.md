<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Telegram Beritacryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter Beritacryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/199199328-32dcdc7c-db06-4519-827f-6c6af09228f9.png">
</p>

# Okp4 node setup for testnet — Okp4 Nemeton

Guide Source :
>- [Obajay](https://github.com/obajay/nodes-Guides/tree/main/OKP4)

Explorer:
>- https://explorer.stavr.tech/okp4

## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4x CPUs; the faster clock speed the better |
| RAM | 8GB RAM  |
| Penyimpanan  | 100GB of storage (SSD or NVME) |
| koneksi | Port 1 Gbit/dtk |

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 8x CPUs; the faster clock speed the better |
| RAM | 64GB RAM |
| Penyimpanan  | 1TB of storage (SSD or NVME) |
| koneksi | 100 Mbit/s port |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 atau lebih tinggi | 


## Siapkan fullnode okp4 Anda
```
wget -O okp4.sh https://raw.githubusercontent.com/xsons/testnet_node/main/okp4/okp4.sh && chmod +x okp4.sh && ./okp4.sh
```
## Opsi 2 (manual)
Anda dapat mengikuti [panduan manual](https://github.com/xsons/testnet_node/blob/main/okp4/manual_install.md) jika Anda lebih suka mengatur node secara manual

## Pasca instalasi

Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```
source $HOME/.bash_profile
```
Selanjutnya Anda harus memastikan validator Anda menyinkronkan blok. Anda dapat menggunakan perintah di bawah ini untuk memeriksa status sinkronisasi
```
okp4d status 2>&1 | jq .SyncInfo
```

## (OPSIONAL) Gunakan Sinkronisasi Cepat dengan memulihkan data dari snapshot
```
sudo apt update
sudo apt install lz4 -y

sudo systemctl stop okp4d

cp $HOME/.okp4d/data/priv_validator_state.json $HOME/.okp4d/priv_validator_state.json.backup
okp4d tendermint unsafe-reset-all --home $HOME/.okp4d --keep-addr-book

rm -rf $HOME/.okp4d/data 
rm -rf $HOME/.okp4d/wasm

SNAP_NAME=$(curl -s https://snapshots2-testnet.nodejumper.io/okp4-testnet/ | egrep -o ">okp4-nemeton.*\.tar.lz4" | tr -d ">")
curl https://snapshots2-testnet.nodejumper.io/okp4-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.okp4d

mv $HOME/.okp4d/priv_validator_state.json.backup $HOME/.okp4d/data/priv_validator_state.json

sudo systemctl restart okp4d
sudo journalctl -u okp4d -f --no-hostname -o cat
```
### Buat dompet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```
okp4d keys add $WALLET
```

(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```
okp4d keys add $WALLET --recover
```

Untuk mendapatkan daftar dompet saat ini
```
okp4d keys list
```

### Simpan info dompet
Tambahkan alamat dompet dan valoper dan muat variabel ke dalam sistem
```
OKP4D_WALLET_ADDRESS=$(okp4d keys show $WALLET -a)
OKP4D_VALOPER_ADDRESS=$(okp4d keys show $WALLET --bech val -a)
echo 'export OKP4D_WALLET_ADDRESS='${OKP4D_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export OKP4D_VALOPER_ADDRESS='${OKP4D_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Danai dompet Anda
Untuk membuat validator terlebih dahulu, Anda perlu mendanai dompet Anda dengan token testnet di sini https://faucet.okp4.network/

### Buat validator
Sebelum membuat validator, pastikan Anda memiliki setidaknya 1 tia (1 okp4 sama dengan 1000000uknow) dan node Anda tersinkronisasi

Untuk memeriksa saldo dompet Anda:
```
okp4d query bank balances $OKP4D_WALLET_ADDRESS
```
> Jika dompet Anda tidak menunjukkan saldo apa pun, kemungkinan simpul Anda masih disinkronkan. Silahkan tunggu sampai selesai untuk sinkronisasi lalu lanjutkan 

Untuk membuat perintah jalankan validator Anda di bawah ini
```
okp4d tx staking create-validator \
  --amount 100000000uknow \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(okp4d tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id okp4-nemeton
```

## Keamanan
### Basic Firewall security
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
sudo ufw allow ${OKP4_PORT}656,${OKP4_PORT}660/tcp
sudo ufw enable
```
## Periksa kunci validator Anda
```
[[ $(okp4d q staking validator $OKP4D_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(okp4d status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
## Dapatkan daftar validator
```
okp4d q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Perintah yang berguna
### Manajemen Pelayanan
Periksa log
```
journalctl -fu okp4d -o cat
```

Memulai layanan
```
sudo systemctl start okp4d
```

Hentikan layanan
```
sudo systemctl stop okp4d
```

Mulai ulang layanan
```
sudo systemctl restart okp4d
```

### Node info
Informasi sinkronisasi
```
sudo systemctl restart okp4d
```

Info validator
```
okp4d status 2>&1 | jq .SyncInfo
```

Node info
```
okp4d status 2>&1 | jq .ValidatorInfo
```

Show node id
```
okp4d status 2>&1 | jq .NodeInfo
```

### Operasi dompet
Daftar dompet
```
okp4d keys list
```

Pulihkan dompet
```
okp4d keys add $WALLET --recover
```

Hapus dompet
```
okp4d keys delete $WALLET
```

Dapatkan saldo dompet
```
okp4d query bank balances $OKP4D_WALLET_ADDRESS
```

Transfer dana
```
okp4d tx bank send $OKP4D_WALLET_ADDRESS <TO_OKP4D_WALLET_ADDRESS> 10000000uknow
```

### Pemungutan suara
```
okp4d tx gov vote 1 yes --from $WALLET --chain-id=$OKP4D_CHAIN_ID
```

### Staking, Delegasi, dan Hadiah
Delegasikan saham
```
okp4d tx staking delegate $OKP4D_VALOPER_ADDRESS 10000000uknow --from=$WALLET --chain-id=$OKP4D_CHAIN_ID --gas=auto
```

Delegasikan ulang stake dari validator ke validator lain
```
okp4d tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uknow --from=$WALLET --chain-id=$OKP4D_CHAIN_ID --gas=auto
```

Tarik semua hadiah
```
okp4d tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$OKP4D_CHAIN_ID --gas=auto
```
Tarik hadiah dengan komisi
```
okp4d tx distribution withdraw-rewards $OKP4D_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$OKP4D_CHAIN_ID
```
### Manajemen validator
Edit validator
```
okp4d tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$OKP4D_CHAIN_ID \
  --from=$WALLET
```
Unjail validator
```
okp4d tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$OKP4D_CHAIN_ID \
  --gas=auto
```
### Delete node
Perintah ini akan sepenuhnya menghapus node dari server. Gunakan dengan risiko Anda sendiri!
```
sudo systemctl stop okp4d && \
sudo systemctl disable okp4d && \
rm /etc/systemd/system/okp4d.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf okp4d && \
rm -rf .okp4d && \
rm -rf $(which okp4d)
```
