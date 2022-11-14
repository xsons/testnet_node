<p style="font-size:14px" align="center">
<img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/> <a href="https://twitter.com/BeritaCryptoo" target="_blank">Twitter BeritaCryptoo</a>
<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/BeritaCryptoo" target="_blank">Telegram BeritaCryptoo</a>
<img src="https://user-images.githubusercontent.com/108946833/201040868-61a5cfb9-f39e-4fd1-a3a6-2c15c1b47424.png" width="30"/> <a href="https://discord.gg/Q2M54pCK" target="_blank">Discrod BeritaCryptoo</a>
</p><hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/108946833/201699963-0398094b-330b-465b-b3ad-252ae93bc5ad.png">
</p>

# penyiapan node gitopia untuk testnet — gitopia-janus-testnet-2

Dokumentasi resmi:
>- [Instruksi penyiapan validator](https://docs.gitopia.com/installation/index.html)

Explorer:
>- https://gitopia.explorers.guru/

## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4x CPUs; the faster clock speed the better |
| RAM | 8GB RAM |
| Penyimpanan  | 100GB of storage (SSD or NVME) |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 |

## Siapkan fullnode Mande Anda
Anda dapat mengatur nois fullnode Anda dalam beberapa menit dengan menggunakan skrip otomatis di bawah ini. Ini akan meminta Anda untuk memasukkan nama node validator Anda!
```
wget -O gitopia.sh https://raw.githubusercontent.com/Megumiiiiii/Gitopia/main/gitopia.sh && chmod +x gitopia.sh && ./gitopia.sh
```

## Pasca instalasi

Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
gitopiad status 2>&1 | jq .SyncInfo
```

### (OPSIONAL) Sinkronisasi Status
Anda dapat menyatakan sinkronisasi simpul Anda dalam hitungan menit dengan menjalankan perintah di bawah ini
```
SNAP_RPC=https://gitopia-testnet-rpc.polkachu.com:443

peers="fbe3b1e34e1dfe9ae2cd0db471b0a807bbb3c5f2@65.109.90.178:11356"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.gitopia/config/config.toml
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"| ; \
s|^(seeds[[:space:]]+=[[:space:]]+).*$|\1\"\"|" $HOME/.gitopia/config/config.toml
gitopiad tendermint unsafe-reset-all --home /root/.gitopia
systemctl restart gitopiad && journalctl -u gitopiad -f -o cat
```

### Buat dompet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```
gitopiad keys add $WALLET
```

(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```
gitopiad keys add $WALLET --recover
```

Untuk mendapatkan daftar dompet saat ini
```
gitopiad keys list
```

### Simpan info dompet
Tambahkan dompet dan alamat valoper ke dalam variabel
```
GITOPIA_WALLET_ADDRESS=$(gitopiad keys show $WALLET -a)
GITOPIA_VALOPER_ADDRESS=$(gitopiad keys show $WALLET --bech val -a)
echo 'export GITOPIA_WALLET_ADDRESS='${GITOPIA_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export GITOPIA_VALOPER_ADDRESS='${GITOPIA_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Danai dompet Anda
Untuk membuat validator terlebih dahulu, Anda perlu mendanai dompet Anda dengan token testnet.
>- https://gitopia.com/home

### Buat validator
Sebelum membuat validator, pastikan Anda memiliki setidaknya 1 tlore (1 tlore sama dengan 1000000 tlore) dan simpul Anda disinkronkan

Untuk memeriksa saldo dompet Anda:
```
gitopiad query bank balances $GITOPIA_WALLET_ADDRESS
```
> Jika dompet Anda tidak menunjukkan saldo apa pun, kemungkinan simpul Anda masih disinkronkan. Silahkan tunggu sampai selesai untuk sinkronisasi lalu lanjutkan

Untuk membuat perintah jalankan validator Anda di bawah ini:
```
gitopiad tx staking create-validator \
  --amount 1000000utlore \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(gitopiad tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $GITOPIA_CHAIN_ID
```

## Keamanan
Untuk melindungi kunci Anda, pastikan Anda mengikuti aturan keamanan dasar

### Siapkan kunci ssh untuk otentikasi
Tutorial yang bagus tentang cara mengatur kunci ssh untuk otentikasi ke server Anda dapat ditemukan [disini](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04)

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
sudo ufw allow ${GITOPIA_PORT}656,${GITOPIA_PORT}660/tcp
sudo ufw enable
```

## Pemantauan
Untuk memantau dan mendapatkan peringatan tentang status kesehatan validator Anda, Anda dapat menggunakan panduan saya tentang [Mengatur pemantauan dan peringatan untuk validator kebisingan](https://github.com/nodesxploit/testnet/blob/main/nois/monitoring/README.md)

### Periksa kunci validator Anda
```
gitopiad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

### Dapatkan daftar validator
```
gitopiad q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Dapatkan daftar rekan yang saat ini terhubung dengan id
```
curl -sS http://localhost:${GITOPIA_PORT}657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Perintah yang berguna
### Manajemen Pelayanan
Periksa log
```
journalctl -fu gitopiad -o cat
```

Memulai layanan
```
sudo systemctl start gitopiad
```

Hentikan layanan
```
sudo systemctl stop gitopiad
```

Mulai ulang layanan
```
sudo systemctl restart gitopiad
```

### Informasi simpul
Informasi sinkronisasi
```
gitopiad status 2>&1 | jq .SyncInfo
```

Info validator
```
gitopiad status 2>&1 | jq .ValidatorInfo
```

Informasi simpul
```
gitopiad status 2>&1 | jq .NodeInfo
```

Tampilkan id simpul
```
gitopiad tendermint show-node-id
```

### Operasi dompet
Daftar dompet
```
gitopiad keys list
```

Pulihkan dompet
```
gitopiad keys add $WALLET --recover
```

Hapus dompet
```
gitopiad keys delete $WALLET
```

Dapatkan saldo dompet
```
gitopiad query bank balances $GITOPIA_WALLET_ADDRESS
```

Transfer dana
```
gitopiad tx bank send $GITOPIA_WALLET_ADDRESS <TO_GITOPIA_WALLET_ADDRESS> 10000000utlore
```

### Pemungutan suara
```
gitopiad tx gov vote 1 yes --from $WALLET --chain-id=$GITOPIA_CHAIN_ID
```

### Staking, Delegasi, dan Hadiah
Delegasikan saham
```
gitopiad tx staking delegate $GITOPIA_VALOPER_ADDRESS 10000000utlore --from=$WALLET --chain-id=$GITOPIA_CHAIN_ID --gas=auto
```

Delegasikan ulang stake dari validator ke validator lain
```
gitopiad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utlore --from=$WALLET --chain-id=$GITOPIA_CHAIN_ID --gas=auto
```

Tarik semua hadiah
```
gitopiad tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$GITOPIA_CHAIN_ID --gas=auto
```

Tarik hadiah dengan komisi
```
gitopiad tx distribution withdraw-rewards $GITOPIA_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$GITOPIA_CHAIN_ID
```

### Manajemen validator
Edit validator
```
gitopiad tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$GITOPIA_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
gitopiad tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$GITOPIA_CHAIN_ID \
  --gas=auto
```

### Hapus simpul
Perintah ini akan sepenuhnya menghapus node dari server. Gunakan dengan risiko Anda sendiri!
```
sudo systemctl stop gitopiad
sudo systemctl disable gitopiad
sudo rm /etc/systemd/system/gitopia* -rf
sudo rm $(which gitopiad) -rf
sudo rm $HOME/.gitopia* -rf
sudo rm $HOME/gitopia -rf
sed -i '/GITOPIA_/d' ~/.bash_profile
```
