
### Edit Jumlah Maximal Client
```
cd inery-node/inery.setup/master.node/blockchain/config/
```
```
nano config.ini
```
Cari `Max-Client = 25` (Ganti Menjadi 100) Lalu Simpan `CTRL X Y ENTER`

<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/108946833/196743582-c7a6225e-86c3-4071-a61c-b576031ec4f6.png">
</p>

Jika menggunakan MobaXtrem cari folder `inery-node/inery.setup/master.node/blockchain/config/config.ini`dan save

### Stop Node
```
cd
cd inery-node/inery.setup/master.node/
```
```
./stop.sh
```

### Tambahkan Peer
```
nano start.sh
```
Masukan Semua Peer List

```
--p2p-peer-address 5.189.138.167:9010 \
--p2p-peer-address 38.242.234.139:9010 \
--p2p-peer-address 86.48.0.180:9010 \
--p2p-peer-address 185.169.252.86:9010 \
--p2p-peer-address 185.207.250.86:9010 \
--p2p-peer-address 38.242.130.28:9010 \
--p2p-peer-address 95.217.134.209:9010 \
--p2p-peer-address 78.46.123.82:9010 \
--p2p-peer-address 161.97.153.16:9010 \
--p2p-peer-address 38.242.154.67:9010 \
--p2p-peer-address 45.10.154.235:9010 \
--p2p-peer-address 45.84.138.8:9010 \
--p2p-peer-address 45.84.138.118:9010 \
--p2p-peer-address 38.242.248.157:9010 \
--p2p-peer-address 45.84.138.209:9010 \
--p2p-peer-address 95.217.236.223:9010 \
--p2p-peer-address 86.48.2.195:9010 \
--p2p-peer-address 135.181.254.255:9010 \
--p2p-peer-address 5.161.118.114:9010 \
--p2p-peer-address 78.47.159.172:9010 \
--p2p-peer-address 45.10.154.239:9010 \
--p2p-peer-address 45.84.138.9:9010 \
--p2p-peer-address 194.163.172.119:9010 \
--p2p-peer-address 45.84.138.119:9010 \
--p2p-peer-address 45.84.138.153:9010 \
--p2p-peer-address 130.185.118.73:9010 \
--p2p-peer-address 45.84.138.247:9010 \
--p2p-peer-address 185.202.238.240:9010 \
--p2p-peer-address 194.163.161.151:9010 \
--p2p-peer-address 65.109.15.147:9010 \
--p2p-peer-address 80.65.211.208:9010 \
--p2p-peer-address 149.102.140.38:9010 \
--p2p-peer-address 38.242.149.97:9010 \
--p2p-peer-address 38.242.156.49:9010 \
--p2p-peer-address 78.187.25.69:9010 \
--p2p-peer-address 212.68.44.36:9010 \
--p2p-peer-address 38.242.159.125:9010 \
--p2p-peer-address 77.92.132.67:9010 \
--p2p-peer-address 20.213.8.11:9010 \
--p2p-peer-address 74.208.142.87:9010 \
--p2p-peer-address 38.242.235.150:9010 \
--p2p-peer-address 65.108.82.31:9010 \
--p2p-peer-address 10.182.0.15:9010 \
--p2p-peer-address 185.249.225.183:9010 \
--p2p-peer-address 167.235.141.121:9010 \
--p2p-peer-address 194.163.162.47:9010 \
--p2p-peer-address 88.198.164.163:9010 \
--p2p-peer-address 193.46.243.16:9010 \
--p2p-peer-address 38.242.159.140:9010 \
--p2p-peer-address 149.102.143.144:9010 \
--p2p-peer-address 161.97.169.27:9010 \
--p2p-peer-address 38.242.219.100:9010 \
--p2p-peer-address bis.blockchain-servers.world \
--p2p-peer-address 193.111.198.52 \
--p2p-peer-address 62.210.245.223 \
--p2p-peer-address 185.144.99.30 \
--p2p-peer-address 38.242.153.15 \
--p2p-peer-address 192.46.226.189 \
--p2p-peer-address 194.5.152.187 \
```
<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/108946833/196744620-3b85f0d3-aa9c-46e2-8c5e-bbe988dba821.png">
</p>

Simpan CTRL X Y ENTER

Jika menggunakan MobaXtrem cari folder `inery-node/inery.setup/master.node/start.sh`dan save


### Jalankan Lagi Node Nya
```
./hard_replay.sh
```

```
screen -Rd master
```
<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/108946833/196746111-5647ad91-dc96-4229-974c-82722b0f5e8c.png">
</p>

<p align="center">
  <img height="auto" height="auto" src="https://user-images.githubusercontent.com/108946833/196746252-bbacb3c4-7a2e-4120-8caa-162dfa4adcaa.jpg">
</p>

Jika seperti gambar di atas sudah update peers, dan sync ulang.. 
