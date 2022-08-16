<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/38981255/184852284-08b36261-236b-4027-bdc3-487858eb09c7.png">
</p>

# Safestake Incentivized Testnet By ParaState

### Membuat direktori volume lokal

```
cd
sudo mkdir -p /data/geth
sudo mkdir -p /data/lighthouse
sudo mkdir -p /data/jwt
sudo mkdir -p /data/operator
```
### Hasilkan rahasia jwt Anda ke direktori jwt
```
openssl rand -hex 32 | tr -d "\n" | sudo tee /data/jwt/jwtsecret
```
![Screenshot_45](https://user-images.githubusercontent.com/108946833/184942966-ed7ed81d-9df4-4a23-9338-de0f10769c2c.png)

***SIMPAN BUAT JAGA-JAGA***

```
cd SafeStakeOperator
vim .env
```
Check lagi apakah sudah sama, dengan `Output` yang ada di step sebelumnya, kalau sudah sama keluar dari mode ini tekan `ESC`, lalu masukkan perintah `:wq` lalu `ENTER`

## Build operator image 
```
sudo docker compose -f  docker-compose-operator.yml build
```

![Screenshot_46](https://user-images.githubusercontent.com/108946833/184956197-faffdbef-1e13-4bb4-987e-c39e6d08830a.png)


**Ditahap ini membutuhkan waktu Sekitar 1 Jam Lebih**

```
sudo docker compose -f docker-compose-operator.yml up -d
```

```
sudo docker compose -f docker-compose-operator.yml logs -f operator | grep "node public key"
```
***SIMPAN `node public key`***

## Back up your operator private key file

```
cat /data/operator/ropsten/node_key.json
```
## Daftar Menjadi Operator

- Ubah Jaringan ke Ropsten ETH
- Claim Faucet: [https://faucet.egorfine.com/]( "https://faucet.egorfine.com/")
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
