<p style="font-size:14px" align="center">
<img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/> <a href="https://twitter.com/BeritaCryptoo" target="_blank">Twitter BeritaCryptoo</a>
<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/BeritaCryptoo" target="_blank">Telegram BeritaCryptoo</a>
<img src="https://user-images.githubusercontent.com/108946833/201040868-61a5cfb9-f39e-4fd1-a3a6-2c15c1b47424.png" width="30"/> <a href="https://discord.gg/Q2M54pCK" target="_blank">Discrod BeritaCryptoo</a>
</p><hr>

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/50621007/192454529-b8070948-6592-4022-96d9-b2adf7169243.png">
</p>

# nois node setup for testnet — nois-testnet-002

Dokumentasi resmi:
>- [Validator setup instructions](https://docs.nois.network/use-cases/for-validators)

Explorer:
>- https://explorer.stavr.tech/nois/staking
>- https://explorer.kjnodes.com/nois

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
wget -O nois.sh https://raw.githubusercontent.com/xsons/testnet_node/main/nois/nois.sh && chmod +x nois.sh && ./nois.sh
```

## Pasca instalasi

Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```
source $HOME/.bash_profile
```

Next you have to make sure your validator is syncing blocks. You can use command below to check synchronization status
```
noisd status 2>&1 | jq .SyncInfo
```

### (OPSIONAL) Sinkronisasi Status
Anda dapat menyatakan sinkronisasi simpul Anda dalam hitungan menit dengan menjalankan perintah di bawah ini
```
peers="8073bd66d5fa581c7b3d0a08d0df1fe318d70d99@135.181.35.46:55656"; \
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noisd/config/config.toml

SNAP_RPC="http://135.181.35.46:55657"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.noisd/config/config.toml

sudo systemctl stop noisd && \
noisd tendermint unsafe-reset-all --home $HOME/.noisd && \
sudo systemctl restart noisd
```

### Buat dompet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```
noisd keys add $WALLET
```

(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```
noisd keys add $WALLET --recover
```

Untuk mendapatkan daftar dompet saat ini
```
noisd keys list
```

### Simpan info dompet
Tambahkan dompet dan alamat valoper ke dalam variabel
```
NOIS_WALLET_ADDRESS=$(noisd keys show $WALLET -a)
NOIS_VALOPER_ADDRESS=$(noisd keys show $WALLET --bech val -a)
echo 'export NOIS_WALLET_ADDRESS='${NOIS_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export NOIS_VALOPER_ADDRESS='${NOIS_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Danai dompet Anda
Untuk membuat validator terlebih dahulu, Anda perlu mendanai dompet Anda dengan token testnet.
```
curl --header "Content-Type: application/json" \
--request POST \
--data '{"denom":"unois","address":"'$NOIS_WALLET_ADDRESS'"}' \
http://faucet.noislabs.com/credit
```

### Buat validator
Sebelum membuat validator, pastikan Anda memiliki setidaknya 1 strd (1 strd sama dengan 1000000 unois) dan simpul Anda disinkronkan

Untuk memeriksa saldo dompet Anda:
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```
> Jika dompet Anda tidak menunjukkan saldo apa pun, kemungkinan simpul Anda masih disinkronkan. Silahkan tunggu sampai selesai untuk sinkronisasi lalu lanjutkan

Untuk membuat perintah jalankan validator Anda di bawah ini:
```
noisd tx staking create-validator \
  --amount 100000000unois \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(noisd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $NOIS_CHAIN_ID
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
sudo ufw allow ${NOIS_PORT}656,${NOIS_PORT}660/tcp
sudo ufw enable
```

## Pemantauan
Untuk memantau dan mendapatkan peringatan tentang status kesehatan validator Anda, Anda dapat menggunakan panduan saya tentang [Mengatur pemantauan dan peringatan untuk validator kebisingan](https://github.com/nodesxploit/testnet/blob/main/nois/monitoring/README.md)

### Periksa kunci validator Anda
```
[[ $(noisd q staking validator $NOIS_VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(noisd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```

### Dapatkan daftar validator
```
noisd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```

## Dapatkan daftar rekan yang saat ini terhubung dengan id
```
curl -sS http://localhost:${NOIS_PORT}657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```

## Perintah yang berguna
### Manajemen Pelayanan
Periksa log
```
journalctl -fu noisd -o cat
```

Memulai layanan
```
sudo systemctl start noisd
```

Hentikan layanan
```
sudo systemctl stop noisd
```

Mulai ulang layanan
```
sudo systemctl restart noisd
```

### Informasi simpul
Informasi sinkronisasi
```
noisd status 2>&1 | jq .SyncInfo
```

Info validator
```
noisd status 2>&1 | jq .ValidatorInfo
```

Informasi simpul
```
noisd status 2>&1 | jq .NodeInfo
```

Tampilkan id simpul
```
noisd tendermint show-node-id
```

### Operasi dompet
Daftar dompet
```
noisd keys list
```

Pulihkan dompet
```
noisd keys add $WALLET --recover
```

Hapus dompet
```
noisd keys delete $WALLET
```

Dapatkan saldo dompet
```
noisd query bank balances $NOIS_WALLET_ADDRESS
```

Transfer dana
```
noisd tx bank send $NOIS_WALLET_ADDRESS <TO_NOIS_WALLET_ADDRESS> 10000000unois
```

### Pemungutan suara
```
noisd tx gov vote 1 yes --from $WALLET --chain-id=$NOIS_CHAIN_ID
```

### Staking, Delegasi, dan Hadiah
Delegasikan saham
```
noisd tx staking delegate $NOIS_VALOPER_ADDRESS 10000000unois --from=$WALLET --chain-id=$NOIS_CHAIN_ID --gas=auto
```

Delegasikan ulang stake dari validator ke validator lain
```
noisd tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000unois --from=$WALLET --chain-id=$NOIS_CHAIN_ID --gas=auto
```

Tarik semua hadiah
```
noisd tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$NOIS_CHAIN_ID --gas=auto
```

Tarik hadiah dengan komisi
```
noisd tx distribution withdraw-rewards $NOIS_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$NOIS_CHAIN_ID
```

### Manajemen validator
Edit validator
```
noisd tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$NOIS_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
noisd tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$NOIS_CHAIN_ID \
  --gas=auto
```

### Hapus simpul
Perintah ini akan sepenuhnya menghapus node dari server. Gunakan dengan risiko Anda sendiri!
```
sudo systemctl stop noisd
sudo systemctl disable noisd
sudo rm /etc/systemd/system/nois* -rf
sudo rm $(which noisd) -rf
sudo rm $HOME/.noisd* -rf
sudo rm $HOME/nois -rf
sed -i '/NOIS_/d' ~/.bash_profile
```

### Pemangkasan untuk simpul sinkronisasi negara
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="2000"
pruning_interval="50"
snapshot_interval="2000"
snapshot_keep_recent="5"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^snapshot-interval *=.*/snapshot-interval = \"$snapshot_interval\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^snapshot-keep-recent *=.*/snapshot-keep-recent = \"$snapshot_keep_recent\"/" $HOME/.noisd/config/app.toml
```
