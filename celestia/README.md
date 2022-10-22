<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Our Telegram BeritaCryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter BeritaCryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img width="100" height="auto" src="https://user-images.githubusercontent.com/50621007/170463282-576375f8-fa1e-4fce-8350-6312b415b50d.png">
</p>


# Celestia node setup for testnet — mamaki

Official documentation:
>- [Validator setup instructions](https://docs.celestia.org/nodes/overview)

Explorer:
>- https://celestia.explorers.guru/
>- https://testnet.mintscan.io/celestia-testnet

## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | Quad-Core |
| RAM | 8GB RAM  |
| Penyimpanan  | 250GB |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 | 

Panduan Manual:
- [Jalankan Validator dan Bridge Node di mesin yang sama](https://github.com/xsons/testnet_node/blob/main/celestia/manual_install.md)
- [Jalankan Bridge Node secara terpisah](https://github.com/xsons/testnet_node/blob/main/celestia/manual_bridge.md)

## Siapkan fullnode Celestia Anda
```
wget -O celestia.sh https://raw.githubusercontent.com/xsons/testnet_node/main/celestia/celestia.sh && chmod +x celestia.sh && ./celestia.sh
```
## Opsi 2 (manual)
Anda dapat mengikuti [panduan manual](https://github.com/xsons/testnet_node/blob/main/celestia/manual_install.md) jika Anda lebih suka mengatur node secara manual

## Pasca instalasi

Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```
source $HOME/.bash_profile
```
Selanjutnya Anda harus memastikan validator Anda menyinkronkan blok. Anda dapat menggunakan perintah di bawah ini untuk memeriksa status sinkronisasi
```
celestia-appd status 2>&1 | jq .SyncInfo
```

## (OPSIONAL) Nonaktifkan dan bersihkan pengindeksan
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.celestia-app/config/config.toml
sudo systemctl restart celestia-appd
sleep 3
sudo rm -rf $HOME/.celestia-app/data/tx_index.db
```
## (OPSIONAL) Gunakan Sinkronisasi Cepat dengan memulihkan data dari snapshot
```
systemctl stop celestia-appd
celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app
cd $HOME
rm -rf ~/.celestia-app/data
mkdir -p ~/.celestia-app/data
SNAP_NAME=$(curl -s https://snaps.qubelabs.io/celestia/ | egrep -o ">mamaki.*tar" | tr -d ">")
wget -O - https://snaps.qubelabs.io/celestia/${SNAP_NAME} | tar xf - -C ~/.celestia-app/data/
systemctl restart celestia-appd && journalctl -fu celestia-appd -o cat
```
### Buat dompet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```
celestia-appd keys add $WALLET
```

(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```
celestia-appd keys add $WALLET --recover
```

Untuk mendapatkan daftar dompet saat ini
```
celestia-appd keys list
```

### Simpan info dompet
Tambahkan alamat dompet dan valoper dan muat variabel ke dalam sistem
```
CELESTIA_WALLET_ADDRESS=$(celestia-appd keys show $WALLET -a)
CELESTIA_VALOPER_ADDRESS=$(celestia-appd keys show $WALLET --bech val -a)
echo 'export CELESTIA_WALLET_ADDRESS='${CELESTIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export CELESTIA_VALOPER_ADDRESS='${CELESTIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Danai dompet Anda
Untuk membuat validator terlebih dahulu, Anda perlu mendanai dompet Anda dengan token testnet.
Anda dapat meminta token testnet dari faucet testnet TIA di [CELESTIA DISCORD](https://discord.gg/TDBGZT29)
- #faucet untuk meminta token uji

Untuk meminta faucet:
```
$request <YOUR_WALLET_ADDRESS>
```
Untuk memeriksa saldo dompet:
```
$balance <YOUR_WALLET_ADDRESS>
```

### Buat validator
Sebelum membuat validator, pastikan Anda memiliki setidaknya 1 tia (1 tia sama dengan 1000000 utia) dan node Anda tersinkronisasi

Untuk memeriksa saldo dompet Anda:
```
celestia-appd query bank balances $CELESTIA_WALLET_ADDRESS
```
> Jika dompet Anda tidak menunjukkan saldo apa pun, kemungkinan simpul Anda masih disinkronkan. Silahkan tunggu sampai selesai untuk sinkronisasi lalu lanjutkan 

Untuk membuat perintah jalankan validator Anda di bawah ini
```
celestia-appd tx staking create-validator \
  --amount 1000000utia \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(celestia-appd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $CELESTIA_CHAIN_ID
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
sudo ufw allow ${CELESTIA_PORT}656,${CELESTIA_PORT}660/tcp
sudo ufw enable
```

## Perintah yang berguna
### Manajemen Pelayanan
Periksa log
```
journalctl -fu celestia-appd -o cat
```

Memulai layanan
```
sudo systemctl start celestia-appd
```

Hentikan layanan
```
sudo systemctl stop celestia-appd
```

Mulai ulang layanan
```
sudo systemctl restart celestia-appd
```

### Node info
Informasi sinkronisasi
```
celestia-appd status 2>&1 | jq .SyncInfo
```

Info validator
```
celestia-appd status 2>&1 | jq .ValidatorInfo
```

Node info
```
celestia-appd status 2>&1 | jq .NodeInfo
```

Show node id
```
celestia-appd tendermint show-node-id
```

### Operasi dompet
Daftar dompet
```
celestia-appd keys list
```

Pulihkan dompet
```
celestia-appd keys add $WALLET --recover
```

Hapus dompet
```
celestia-appd keys delete $WALLET
```

Dapatkan saldo dompet
```
celestia-appd query bank balances $CELESTIA_WALLET_ADDRESS
```

Transfer dana
```
celestia-appd tx bank send $CELESTIA_WALLET_ADDRESS <TO_CELESTIA_WALLET_ADDRESS> 10000000utia
```

### Pemungutan suara
```
celestia-appd tx gov vote 1 yes --from $WALLET --chain-id=$CELESTIA_CHAIN_ID
```

### Staking, Delegasi, dan Hadiah
Delegasikan saham
```
celestia-appd tx staking delegate $CELESTIA_VALOPER_ADDRESS 10000000utia --from=$WALLET --chain-id=$CELESTIA_CHAIN_ID --gas=auto
```

Delegasikan ulang stake dari validator ke validator lain
```
celestia-appd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utia --from=$WALLET --chain-id=$CELESTIA_CHAIN_ID --gas=auto
```

Tarik semua hadiah
```
celestia-appd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$CELESTIA_CHAIN_ID --gas=auto
```

Tarik hadiah dengan komisi
```
celestia-appd tx distribution withdraw-rewards $CELESTIA_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$CELESTIA_CHAIN_ID
```

### Manajemen validator
Edit validator
```
celestia-appd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$CELESTIA_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
celestia-appd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$CELESTIA_CHAIN_ID \
  --gas=auto
```

### Delete node
Perintah ini akan sepenuhnya menghapus node dari server. Gunakan dengan risiko Anda sendiri!
```
sudo systemctl stop celestia-appd
sudo systemctl disable celestia-appd
sudo rm /etc/systemd/system/celestia* -rf
sudo rm $(which celestia-appd) -rf
sudo rm $HOME/.celestia-app* -rf
sudo rm $HOME/celestia -rf
sed -i '/CELESTIA_/d' ~/.bash_profile
```

