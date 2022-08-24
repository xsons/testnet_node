<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/108946833/185566136-53e35398-2c9c-4eb3-99af-b93d150ab885.jpg">
</p>


# Join Point-XNet-Triton as a Validator

## Menyiapkan vars
```console
NODENAME=NAMA_MONIKER
```
Ganti `NAMA_MONIKER` dengan nama validator kalian
```console
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export EVMOS_CHAIN_ID=point_10721-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Mempersiapkan server
```console 
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl build-essential git wget jq make gcc tmux -y
```
## Install GO
```console 
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
go version
```
## Unduh dan bangun binari
```console
cd $HOME
git clone https://github.com/pointnetwork/point-chain && cd point-chain
git checkout xnet-triton
make install
```
## Install Node
```console
export PATH=$PATH:$(go env GOPATH)/bin
evmosd config keyring-backend file
evmosd config chain-id point_10721-1
```
## Instalasi
```console
evmosd init [myvalidator] --chain-id point_10721-1
```
Di mana `[myvalidator]` adalah nama kustom validator Anda yang akan terlihat secara publik.
## Membuat Wallet 
```console
evmosd keys add validatorkey --keyring-backend file
```
- Jika address faucet kalian ingin di pakai silahkan gunakan cara ini:
```console
evmosd keys add validatorkey --recover
```
Rubah `validatorkey` dengan nama `validator` kalian.

## Unduh genesis dan addrbook
```console
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/config.toml
wget https://raw.githubusercontent.com/pointnetwork/point-chain-config/main/testnet-xNet-Triton-1/genesis.json
mv config.toml genesis.json ~/.evmosd/config/
```
## Validasi
```console
evmosd validate-genesis
```
## membuat Service
```console
sudo tee /etc/systemd/system/evmosd.service > /dev/null <<EOF
[Unit]
Description=evmos
After=network-online.target

[Service]
User=$USER
ExecStart=$(which evmosd) start --home $HOME/.evmosd
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```
## Daftar dan Mulai Layanan
```console
sudo systemctl daemon-reload && \
sudo systemctl enable evmosd && \
sudo systemctl restart evmosd && \
sudo journalctl -u evmosd -f -o cat
```
- Check SyncInfo

```console
evmosd status 2>&1 | jq .SyncInfo
```
Anda akan mendapatkan `"latest_block_height"` dari node Anda.

### Tambahkan dompet dengan 1024 XPOINT Anda

Supaya wallet evmos kita bisa di import ke metamask, gunakan perintah ini:
```console
evmosd keys unsafe-export-eth-key validatorkey --keyring-backend file
```
Ubah `validatorkey` dengan nama validator kalian.

![Screenshot_57](https://user-images.githubusercontent.com/108946833/185661523-a65e0667-13d5-4be7-b4ea-870405734b38.png)

Import `privatekey` yang di hasilkan ke metamask.

Selanjutnya kalian bisa send address dari address faucet ke address yang sudah di import ke metamask.

![Screenshot_58](https://user-images.githubusercontent.com/108946833/185662187-4098dbde-c35f-4015-94a2-7689c837bac9.png)

Jika sudah false kalian bisa check balance, dengan menggunkan cara ini:

- Untuk Check balances
```console
evmosd query bank balances <evmosaddress>
```
- Untuk Melihat Wallet
```console
evmosd keys list
```
## Membuat Validator
```console
evmosd tx staking create-validator \
--amount=1000000000000000000000apoint \
--pubkey=$(evmosd tendermint show-validator) \
--moniker="<myvalidator>" \
--chain-id=point_10721-1 \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1000000000000000000000" \
--gas="400000" \
--gas-prices="0.025apoint" \
--from=validatorkey \
--keyring-backend file
```
Rubah `<myvalidator>` dengan nama validator kalian, `from=validatorkey` dengan address evmos

Untuk memeriksa txhash bisa menggunakan cara berikut:
```console
evmosd query tx <txhash>
```
`txhash` ganti dengan output yang di hasilkan

Untuk Sekarang belum bisa cek di website apakah validator kalian aktif atau tidak, yang bisa di lihat `voting power` jika lebih besar dari 0 maka validator kalian sudah terdaftar, untuk melihat nya:
```console
evmosd status
```
![Screenshot_65](https://user-images.githubusercontent.com/108946833/185779191-4e3c516d-4f41-4433-bfba-8c20e804596c.png)


## Explorer
https://explorer-xnet-triton.point.space/

## Menghapus Node
```console
sudo systemctl stop evmosd
sudo systemctl disable evmosd
sudo rm /etc/systemd/system/evmos* -rf
sudo rm $(which evmosd) -rf
sudo rm $HOME/.evmosd -rf
sudo rm $HOME/point-chain -rf
````
