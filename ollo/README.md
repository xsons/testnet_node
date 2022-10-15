<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Our Telegram BeritaCryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter BeritaCryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img width="100" height="auto" src="https://user-images.githubusercontent.com/50621007/192699071-461d8ff6-6ddf-4d4f-aba7-d3ddcc4a5563.png">
</p>

## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4 |
| RAM | 8GB RAM  |
| Penyimpanan  | 100GB |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 | 


## Siapkan fullnode ollo Anda
```
wget -O ollo.sh https://raw.githubusercontent.com/xsons/testnet_node/main/ollo/ollo.sh && chmod +x dwb.sh && ./ollo.sh
```

## Pasca instalasi

Ketika instalasi selesai, silakan muat variabel ke dalam sistem
```
source $HOME/.bash_profile
```
Selanjutnya Anda harus memastikan validator Anda menyinkronkan blok. Anda dapat menggunakan perintah di bawah ini untuk memeriksa status sinkronisasi
```
ollod status 2>&1 | jq .SyncInfo
```

## (OPSIONAL) Sinkronisasi Status
Anda dapat menyatakan sinkronisasi simpul Anda dalam hitungan menit dengan menjalankan perintah di bawah ini
```
sudo systemctl stop ollod
ollod tendermint unsafe-reset-all --home $HOME/.ollo --keep-addr-book

SNAP_RPC="https://node.ollo.zone:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

PEERS="2a8f0fada8b8b71b8154cf30ce44aebea1b5fe3d@145.239.31.245:26656,1173fe561814f1ecb8b8f19d1769b87cd576897f@185.173.157.251:26656,489daf96446f104d822fae34cd4aa7a9b5cebf65@65.21.131.215:26626,f43435894d3ae6382c9cf95c63fec523a2686345@167.235.145.255:26656,2eeb90b696ba9a62a8ad9561f39c1b75473515eb@77.37.176.99:26656,9a3e2725e02d1c420a5d500fa17ce0ef45ddc9e8@65.109.30.117:29656,91f1889f22975294cfbfa0c1661c63150d2b9355@65.108.140.222:30656,d38fcf79871189c2c430473a7e04bd69aeb812c2@78.107.234.44:16656,f795505ac42f18e55e65c02bb7107b08d83ad837@65.109.17.86:37656,6368702dd71e69035dff6f7830eb45b2bae92d53@65.109.57.161:15656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ollo/config/config.toml

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.ollo/config/config.toml

sudo systemctl restart ollod
sudo journalctl -u ollod -f --no-hostname -o cat
```

### Buat dompet
Untuk membuat dompet baru Anda dapat menggunakan perintah di bawah ini. Jangan lupa simpan mnemonicnya
```
ollod keys add $WALLET
```

(OPSIONAL) Untuk memulihkan dompet Anda menggunakan frase seed
```
ollod keys add $WALLET --recover
```

Untuk mendapatkan daftar dompet saat ini
```
ollod keys list
```

### Simpan info dompet
Tambahkan alamat dompet dan valoper dan muat variabel ke dalam sistem
```
OLLO_WALLET_ADDRESS=$(ollod keys show $WALLET -a)
OLLO_VALOPER_ADDRESS=$(ollod keys show $WALLET --bech val -a)
echo 'export OLLO_WALLET_ADDRESS='${OLLO_WALLET_ADDRESS} >> $HOME/.bash_profile
echo 'export OLLO_VALOPER_ADDRESS='${OLLO_VALOPER_ADDRESS} >> $HOME/.bash_profile
source $HOME/.bash_profile
```

### Danai dompet Anda
Untuk membuat validator terlebih dahulu, Anda perlu mendanai dompet Anda dengan token testnet.
Anda dapat meminta token testnet dari faucet testnet OLLO di [OLLO DISCORD](https://discord.gg/5YE4tYP7)
- Dapatkan terverifikasi
- Masuk saluran `Testnet Explorers role_#roles`
- Pindah ke `#testnet-faucet`dan minta token

Untuk meminta faucet:
```
!request YOUR_WALLET_ADDRESS
```

### Buat validator
Sebelum membuat validator, pastikan Anda memiliki setidaknya 1 ollo (1 ollo sama dengan 1000000 ollos) dan simpul Anda disinkronkan

Untuk memeriksa saldo dompet Anda:

To check your wallet balance:
```
ollod query bank balances $OLLO_WALLET_ADDRESS
```
> Jika dompet Anda tidak menunjukkan saldo apa pun, kemungkinan simpul Anda masih disinkronkan. Silahkan tunggu sampai selesai untuk sinkronisasi lalu lanjutkan 

Untuk membuat perintah jalankan validator Anda di bawah ini
```
ollod tx staking create-validator \
  --amount 2000000utollo \
  --from $WALLET \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(ollod tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $OLLO_CHAIN_ID
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
sudo ufw allow ${OLLO_PORT}656,${OLLO_PORT}660/tcp
sudo ufw enable
```

## Perintah yang berguna
### Manajemen Pelayanan
Periksa log
```
journalctl -fu ollod -o cat
```

Memulai layanan
```
sudo systemctl start ollod
```

Hentikan layanan
```
sudo systemctl stop ollod
```

Mulai ulang layanan
```
sudo systemctl restart ollod
```

### Node info
Informasi sinkronisasi
```
ollod status 2>&1 | jq .SyncInfo
```

Info validator
```
ollod status 2>&1 | jq .ValidatorInfo
```

Node info
```
ollod status 2>&1 | jq .NodeInfo
```

Show node id
```
ollod tendermint show-node-id
```

### Operasi dompet
Daftar dompet
```
ollod keys list
```

Pulihkan dompet
```
ollod keys add $WALLET --recover
```

Hapus dompet
```
ollod keys delete $WALLET
```

Dapatkan saldo dompet
```
ollod query bank balances $OLLO_WALLET_ADDRESS
```

Transfer dana
```
ollod tx bank send $OLLO_WALLET_ADDRESS <TO_OLLO_WALLET_ADDRESS> 10000000utollo
```

### Pemungutan suara
```
ollod tx gov vote 1 yes --from $WALLET --chain-id=$OLLO_CHAIN_ID
```

### Staking, Delegasi, dan Hadiah
Delegasikan saham
```
ollod tx staking delegate $OLLO_VALOPER_ADDRESS 10000000utollo --from=$WALLET --chain-id=$OLLO_CHAIN_ID --gas=auto
```

Delegasikan ulang stake dari validator ke validator lain
```
ollod tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000utollo --from=$WALLET --chain-id=$OLLO_CHAIN_ID --gas=auto
```

Tarik semua hadiah
```
ollod tx distribution withdraw-all-rewards --from=$WALLET --chain-id=$OLLO_CHAIN_ID --gas=auto
```

Tarik hadiah dengan komisi
```
ollod tx distribution withdraw-rewards $OLLO_VALOPER_ADDRESS --from=$WALLET --commission --chain-id=$OLLO_CHAIN_ID
```

### Manajemen validator
Edit validator
```
ollod tx staking edit-validator \
  --moniker=$NODENAME \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=$OLLO_CHAIN_ID \
  --from=$WALLET
```

Unjail validator
```
ollod tx slashing unjail \
  --broadcast-mode=block \
  --from=$WALLET \
  --chain-id=$OLLO_CHAIN_ID \
  --gas=auto
```

### Delete node
Perintah ini akan sepenuhnya menghapus node dari server. Gunakan dengan risiko Anda sendiri!
```
sudo systemctl stop ollod
sudo systemctl disable ollod
sudo rm /etc/systemd/system/ollo* -rf
sudo rm $(which ollod) -rf
sudo rm $HOME/.ollo* -rf
sudo rm $HOME/ollo -rf
sed -i '/OLLO_/d' ~/.bash_profile
```
