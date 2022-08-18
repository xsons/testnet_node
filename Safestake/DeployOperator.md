<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/38981255/184852284-08b36261-236b-4027-bdc3-487858eb09c7.png">
</p>

# Safestake Incentivized Testnet By ParaState

## Project SafeStake Operator Node

**Deskripsi**:  
SafeStake adalah kerangka validasi terdesentralisasi untuk melakukan tugas ETH2 dan backendnya dirancang di atas Lighthouse (klien konsensus ETH2) dan Hotstuff (pustaka konsensus BFT)

## Minimal Spek dan Software yang di butuhkan
### Server 

 * Public Static Network IP 
 * Hardware(recommend)
   * CPU: 4
   * Memory: 8G
   * Disk: 500GB
 * OS
   * Unix
 * Software
   * Docker
   * Docker Compose 


## Update Sistem
```
sudo apt-get update
sudo apt install git sudo unzip wget -y
```
## Add All Port

***Untuk yang menggunakan vps dari azure, harus add manual di portal azure.***

```
sudo ufw allow 25000:25003/tcp
sudo ufw allow 9000/tcp
sudo ufw allow 8545:8547/tcp
sudo ufw allow 25004/udp
sudo ufw allow 22/tcp
sudo ufw allow 3000:3001/tcp
sudo ufw allow 80/tcp
sudo ufw allow 30303/tcp
sudo ufw allow 9000/udp
sudo ufw enable
```
## Instal Docker Engine
```
sudo apt-get install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```
## Install Docker Compose
```
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
sudo chown $USER /var/run/docker.sock
```
## Create local volume directory
```
sudo mkdir -p /data/geth
sudo mkdir -p /data/lighthouse
sudo mkdir -p /data/jwt
sudo mkdir -p /data/operator
```
## Generate your jwt secret to jwt dirctory
```
openssl rand -hex 32 | tr -d "\n" | sudo tee /data/jwt/jwtsecret
```
## Clone operator code from github
```
git clone --recurse-submodules https://github.com/ParaState/SafeStakeOperator.git dvf
```
## konfigurasikan Ini memiliki nilai default dalam kode sumber terbaru
```
cd dvf
vim .env
```
simpan dan Buat keluar Mode ini Ketik `ESC` Ketik `:wq` dan `ENTER`

## Build operator image 
Proses Ini Membutuhkan waktu kurang lebih 1 jam tergantung spek VPS
```
sudo docker compose -f docker-compose-operator.yml build
```
![Screenshot_54](https://user-images.githubusercontent.com/108946833/185299149-022b6653-ce39-4be4-9edb-9c2048721024.png)

## Run Your Operator
```
sudo docker compose -f docker-compose-operator.yml up -d
```
![Screenshot_55](https://user-images.githubusercontent.com/108946833/185299370-0ea4fdcb-376f-41bd-8535-ad1548620f04.png)

Untuk Check log (OPTIONAL)
```
sudo docker compose -f docker-compose-operator.yml logs -f
```

## Get your operator public key
```
sudo docker compose -f docker-compose-operator.yml logs -f operator | grep "node public key"
```
Simpan OUTPUT `node public key` 

## Back up your operator private key file

```
cd 
cat /data/operator/ropsten/node_key.json
```
Simpan output `node_key.json`

## Daftar Menjadi Operator

- Ubah Jaringan ke Ropsten ETH
- Claim Faucet: [https://faucet.egorfine.com/](https://faucet.egorfine.com/ "https://faucet.egorfine.com/")
- Buka Web Testnet Operator : [https://testnet.safestake.xyz/](https://testnet.safestake.xyz/ "https://testnet.safestake.xyz/")
- Connect Wallet
- Klik `Join As Operator`
- Klik `Regist Operator`
- Display Name (Masukan Nama Operator Bebas)
- Publik Key (Masukan Publik Key yang Sudah di Simpan)
- Klik Next dan Register Operator
- Approve Transaksi
- Check di Explorer: https://explorer-testnet.safestake.xyz/
- Done
