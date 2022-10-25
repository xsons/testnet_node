<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join Our Telegram BeritaCryptoo <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Follow Twitter BeritaCryptoo <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img width="250" height="auto" src="https://user-images.githubusercontent.com/108946833/197696918-150127d1-9054-416c-9208-2c8c70997b27.jpg">
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

# wormholes node setup for testnet 
## Pra-Instalasi
```
sudo apt-get update && apt-get install wget
```
## Instal Docker untuk instalasi lebih cepat
```
sudo apt-get install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```
## Instal komposisi Docker
```
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
sudo chown $USER /var/run/docker.sock
```
## Kloning wormholes dari repository
```
git clone https://github.com/wormholes-org/wormholes
```
## Memulai menjalankan node
Pull the latest NuLink image
```
docker pull wormholestech/wormholes:v1
```
```
docker run -d -p 30303:30303 -p 8545:8545 --name wormholes wormholestech/wormholes:v1
```
Masukan Perintah ini:
```
docker exec -it wormholes /usr/bin/cat /wm/.wormholes/wormholes/nodekey
```
![image](https://user-images.githubusercontent.com/108946833/197738085-2190f731-ea02-4803-b039-84fb2d6cda2f.png)

Output yang dihasilkan harap di simpan, dan import ke web [wallet wormholes](https://www.limino.com/#/wallet)

## Skrip Pemantauan
```
wget -O skrip.sh https://raw.githubusercontent.com/xsons/testnet_node/main/wormholes/skrip.sh && chmod +x skrip.sh && ./skrip.sh
```
Untuk keluar nya, tekan CTRL+C

Untuk Memulainya kembali gunakan perintah ini:
```
bash ./skrip.sh
```
![image](https://user-images.githubusercontent.com/108946833/197741940-b06591e0-9c84-401e-9717-88e01e52f1a1.png)

Screanshot output yang keluar dan kirim email wormholes market@wormholes.com

