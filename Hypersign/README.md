<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/108946833/189469748-93a12fe9-f5ad-4186-ad69-df75539434f8.jpg">
</p>


# Setting up a Validator Node for Jagrat Testnet
## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 1.4 GHz x2 CPU or 2.0 GHz x4 CPU |
| RAM | 4 GB RAM or 8 GB RAM |
| Penyimpanan  | 250 GB SSD or 500 GB SDD|
| koneksi | At least 100mbps network bandwidth |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 atau lebih tinggi | 

## Langkah-langkah Instalasi
```
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y
```

## Install GO
```
wget https://golang.org/dl/go1.18.1.linux-amd64.tar.gz; \
rm -rv /usr/local/go; \
tar -C /usr/local -xzf go1.18.1.linux-amd64.tar.gz && \
rm -v go1.18.1.linux-amd64.tar.gz && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version
```
## Installation Steps

- Kloning repositori dan Bangun node
```
git clone https://github.com/hypersign-protocol/hid-node.git
cd hid-node
make install
```

- Jalankan yang berikut ini untuk memeriksa apakah node berhasil diinstal
```
hid-noded version
```

## Membuat wallet
```
hid-noded keys add <key-name>
```
atau
```
hid-noded keys add <key-name> --recover
```
untuk membuat ulang kunci dengan mnemonic [BIP39](https://github.com/bitcoin/bips/tree/master/bip-0039) mnemonic

Anda dapat melihat informasi alamat kunci menggunakan perintah: 
```
hid-noded keys list
```
## Penyiapan Validator (Tahap Pra Kejadian)

> Catatan: Beberapa direktori yang disebutkan dalam langkah-langkah di bawah ini akan segera dibuat.

### Sebelum Rilis Final Genesis

- Inisialisasi Node
```
hid-noded init <validator-name> --chain-id jagrat
```
- Jalankan yang berikut ini untuk mengubah denom koin dari `stake` menjadi `uhid` di yang dihasilkan `genesis.json`
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom" ]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="uhid"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
- Tentukan namespace rantai dengan menjalankan perintah berikut:
```
cat $HOME/.hid-node/config/genesis.json | jq '.app_state["ssi"]["chain_namespace"]="jagrat"' > $HOME/.hid-node/config/tmp_genesis.json && mv $HOME/.hid-node/config/tmp_genesis.json $HOME/.hid-node/config/genesis.json
```
- Buat akun gentx
```
hid-noded add-genesis-account <key-name> 100000000000uhid
```
- Buat transaksi gentx. `<stake-amount-in-uhid>` seharusnya di `uhid`. Contoh: `100000000000uhid`
```
hid-noded gentx <key-name> 100000000000uhid \
--chain-id jagrat \
--moniker="<validator-name>" \
--commission-max-change-rate=0.01 \
--commission-max-rate=1.0 \
--commission-rate=0.07 \
--min-self-delegation=100000000000 \
--details="XXXXXXXX" \
--security-contact="XXXXXXXX" \
--website="XXXXXXXX"
```
- Fork the [repository](https://github.com/hypersign-protocol/networks)
- Salin isi dari `${HOME}/.hid-node/config/gentx/gentx-XXXXXXXX.json`.
- Buat file `gentx-<validator-name-without-spaces>.json`di bawah `testnet/jagrat/gentxs`folder di repo bercabang dan tempel teks yang disalin dari langkah terakhir ke dalam file.
- Buat file p`eers-<validator-name>`.txtdi bawah `testnet/jagrat/peers`direktori di repo bercabang.
- Jalankan `hid-noded tendermint show-node-id`dan salin ID Node Anda.
- Jalankan `ifconfig`atau curl `ipinfo.io/ip`dan salin alamat IP Anda yang dapat dijangkau secara publik.
- Bentuk alamat simpul lengkap dalam format: `<node-id>@<publicly-reachable-ip>:<p2p-port>`. Contoh: `31a2699a153e60fcdbed8a47e060c1e1d4751616@<publicly-reachable-ip>:26656`. Catatan: Port P2P default adalah 26656. Jika Anda ingin mengubah konfigurasi port, buka `${HOME}/.hid-node/config/config.toml`dan di bawah , ubah atribut `[p2p]`port in .laddr
- Tempel alamat simpul lengkap dari langkah terakhir ke dalam file `testnet/jagrat/peers/peer-<validator-name-without-spaces>.txt`.
- Buat Permintaan Tarik ke `main` cabang [repository](https://github.com/hypersign-protocol/networks)
>**CATATAN:** Pull Request akan digabungkan oleh pengelola untuk mengonfirmasi penyertaan validator di genesis. File genesis akhir akan diterbitkan di bawah file `testnet/jagrat/final_genesis.json`.

### Setelah Rilis Genesis Terakhir

> Cosmovisor adalah alat yang akan memungkinkan pemutakhiran otomatis blockchain, setelah proposal tata kelola pemutakhiran perangkat lunak disahkan. Informasi lebih lanjut tentang Cosmovisor [disini](https://docs.cosmos.network/v0.45/run-node/cosmovisor.html).

- Unduh dan Instal Cosmovisor
```
wget https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.2.0/cosmovisor-v1.2.0-linux-amd64.tar.gz && tar -C /usr/local/bin/ -xzf cosmovisor-v1.2.0-linux-amd64.tar.gz
```
- Ekspor variabel lingkungan berikut
```
export DAEMON_PATH=<complete path of hid-noded binary>
export DAEMON_HOME=$HOME/.hid-node
```
- Buat `cosmovisor` direktori dan salin biner blockchain yang ada ke lokasi berikut
```
mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
cp $DAEMON_PATH $DAEMON_HOME/cosmovisor/genesis/bin
```
- Setelah `final_genesis.json`file diterbitkan, ganti konten Anda `${HOME}/.hid-node/config/genesis.json`dengan`testnet/jagrat/final_genesis.json.`
- Salin semua rekan persisten yang ada `testnet/jagrat/final_peers.json`dan tempel di atribut `persistent_peers`, yang ada di `${HOME}/.hid-node/config/config.toml`file.
- Setel minimum-gas-price di `${HOME}/.hid-node/config/app.toml`. Contoh nilai:0.02uhid
- Mulai simpul menggunakan Cosmovisor
```sh
cosmovisor run start
```

## Penyiapan Validator (Tahap Pasca Kejadian)

- Ikuti langkah-langkah untuk menginstal `hid-node` binary [disini](#installation-steps)
- Inisialisasi simpul
```sh
hid-noded init <validator-name>
```
- Ganti konten Anda ${HOME}/.hid-noded/config/genesis.jsondengan konten testnet/jagrat/final_genesis.jsondari mastercabang [repository](https://github.com/hypersign-protocol/networks).
- Tambahkan persistent_peersatau seedsmasuk `${HOME}/.hid-noded/config/config.toml`dari `testnet/jagrat/final_peers.json`dari `master` cabang [repository](https://github.com/hypersign-protocol/networks).
- Setel `minimum-gas-price`di `${HOME}/.hid-node/config/app.toml`. Contoh nilai:`0.02uhid`
- Unduh dan Instal Cosmovisor
```
wget https://github.com/cosmos/cosmos-sdk/releases/download/cosmovisor%2Fv1.2.0/cosmovisor-v1.2.0-linux-amd64.tar.gz && tar -C /usr/local/bin/ -xzf cosmovisor-v1.2.0-linux-amd64.tar.gz
```
- Ekspor variabel lingkungan berikut
```
export DAEMON_PATH=<complete path of hid-noded binary>
export DAEMON_HOME=$HOME/.hid-node
```
- Buat `cosmovisor`direktori dan salin biner blockchain yang ada ke lokasi berikut
```
mkdir -p $DAEMON_HOME/cosmovisor/genesis/bin
cp $DAEMON_PATH $DAEMON_HOME/cosmovisor/genesis/bin
```
- Mulai simpul menggunakan Cosmovisor
```shell
cosmovisor run start
```
- Hasilkan kunci dengan menjalankan `hid-noded keys add <key-name>`atau `hid-noded keys add <key-name> --recover`membuat ulang kunci dengan mnemonik [BIP39 Anda](https://github.com/bitcoin/bips/tree/master/bip-0039)
- Dapatkan beberapa $HID
- Kirim transaksi pembuatan validator
```
hid-noded tx staking create-validator \
--from <key-name> \
--amount 1000000000000uhid \
--pubkey "$(hid-noded tendermint show-validator)" \
--chain-id jagrat \
--moniker="<validator-name>" \
--commission-max-change-rate=0.01 \
--commission-max-rate=1.0 \
--commission-rate=0.07 \
--min-self-delegation="500000000000" \
--details="XXXXXXXX" \
--security-contact="XXXXXXXX" \
--website="XXXXXXXX"
```
