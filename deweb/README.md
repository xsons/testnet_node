<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/50621007/166676803-ee125d04-dfe2-4c92-8f0c-8af357aad691.png">
</p>


# Deweb node setup untuk Testnet — deweb-testnet-2
## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 3x CPUs or 4x CPUs |
| RAM | 4 GB RAM or 8 GB RAM |
| Penyimpanan  | 80 GB SSD or 500 GB SDD|
| koneksi | At least 100mbps network bandwidth |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 atau lebih tinggi | 

Official documentation:
>- [Validator setup instructions](https://docs.deweb.services/guides/validator-setup-guide)

Explorer:
>-  https://dws.explorers.guru/

## Pasca instalasi

Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```
source $HOME/.bash_profile
```

Selanjutnya Anda harus memastikan validator Anda menyinkronkan blok. Anda dapat menggunakan perintah di bawah ini untuk memeriksa status sinkronisasi
```
dewebd status 2>&1 | jq .SyncInfo
```

### Buat dompet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```
dewebd keys add $WALLET
```

(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```
dewebd keys add $WALLET --recover
```

Untuk mendapatkan daftar dompet saat ini
```
dewebd keys list
```

### Simpan info dompet
Tambahkan alamat dompet dan valoper dan muat variabel ke dalam sistem
```
DEWEB_WALLET_ADDRESS=$(dewebd keys show $WALLET -a)
DEWEB_VALOPER_ADDRESS=$(dewebd keys show $WALLET --bech val -a)
echo 'export DEWEB_WALLET_ADDRESS='${DEWEB_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export DEWEB_VALOPER_ADDRESS='${DEWEB_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Danai dompet Anda
In order to create validator first you need to fund your wallet with testnet tokens.
To top up your wallet join DWS discord server and navigate to:
- **#faucet** for DWS tokens

Untuk meminta faucet:
```
$request <YOUR_WALLET_ADDRESS> menkar
```

### Buat validator
Sebelum membuat validator, pastikan Anda memiliki setidaknya 1 dws (1 dws sama dengan 1000000 udws) dan simpul Anda disinkronkan

Untuk memeriksa saldo dompet Anda:

To check your wallet balance:
```
dewebd query bank balances $DEWEB_WALLET_ADDRESS
```
> Jika dompet Anda tidak menunjukkan saldo apa pun, kemungkinan simpul Anda masih disinkronkan. Silahkan tunggu sampai selesai untuk sinkronisasi lalu lanjutkan 

Untuk membuat perintah jalankan validator Anda di bawah ini
```
dewebd tx staking create-validator \
  --amount 1000000udws \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(dewebd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $DEWEB_CHAIN_ID
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
sudo ufw allow ${DEWEB_PORT}656,${DEWEB_PORT}660/tcp
sudo ufw enable
```

## Perintah yang berguna
### Manajemen Pelayanan
Periksa log
```
journalctl -fu dewebd -o cat
```

Memulai layanan
```
sudo systemctl start dewebd
```

Hentikan layanan
```
sudo systemctl stop dewebd
```

Mulai ulang layanan
```
sudo systemctl restart dewebd
```

### Node info
Informasi sinkronisasi
```
dewebd status 2>&1 | jq .SyncInfo
```

Info validator
```
dewebd status 2>&1 | jq .ValidatorInfo
```

Node info
```
dewebd status 2>&1 | jq .NodeInfo
```

Show node id
```
dewebd tendermint show-node-id
```

### Operasi dompet
Daftar dompet
```
dewebd keys list
```

Pulihkan dompet
```
dewebd keys add $WALLET --recover
```

Hapus dompet
```
dewebd keys delete $WALLET
```

Dapatkan saldo dompet
```
dewebd query bank balances $DEWEB_WALLET_ADDRESS
```

Transfer dana
```
dewebd tx bank send $DEWEB_WALLET_ADDRESS <TO_DEWEB_WALLET_ADDRESS> 10000000udws
```

### Pemungutan suara
```
dewebd tx gov vote 1 yes --from $WALLET --chain-id=$DEWEB_CHAIN_ID
```

### Staking, Delegasi, dan Hadiah
Delegasikan saham
```
dewebd tx staking delegate $DEWEB_VALOPER_ADDRESS 10000000udws --from=$WALLET --chain-id=$DEWEB_CHAIN_ID --gas=auto
```

Delegasikan ulang stake dari validator ke validator lain
```
dewebd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000udws --from=$WALLET --chain-id=$DEWEB_CHAIN_ID --gas=auto
```

Tarik semua hadiah
```
dewebd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$DEWEB_CHAIN_ID --gas=auto
```

Tarik hadiah dengan komisi
```
dewebd tx distribution withdraw-rewards $DEWEB_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$DEWEB_CHAIN_ID
```

### Manajemen validator
Edit validator
```
dewebd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$DEWEB_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
dewebd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$DEWEB_CHAIN_ID \
  --gas=auto
```

### Delete node
Perintah ini akan sepenuhnya menghapus node dari server. Gunakan dengan risiko Anda sendiri!
```
sudo systemctl stop dewebd
sudo systemctl disable dewebd
sudo rm /etc/systemd/system/deweb* -rf
sudo rm $(which dewebd) -rf
sudo rm $HOME/.deweb* -rf
sudo rm $HOME/deweb -rf
sed -i '/DEWEB_/d' ~/.bash_profile
```
