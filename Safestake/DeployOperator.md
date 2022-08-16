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
