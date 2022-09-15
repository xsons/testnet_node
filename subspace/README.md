<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>
 
<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/50621007/171398816-7e0432f4-4d39-42ad-a72e-cd8dd008028f.png">
</p>


# Subspace node setup for Gemini 2 Incentivized Testnet
## Perangkat Keras

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 2 Core+ |
| RAM | 4GB+ (Rec. 8GB) |
| Penyimpanan  | 150GB |
| koneksi | At least 100mbps network bandwidth |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 atau lebih tinggi | 

Dokumentasi resmi:
- Manual resmi: https://github.com/subspace/subspace/blob/main/docs/farming.md
- Telemetri: https://telemetry.subspace.network/#list/0x43d10ffd50990380ffe6c9392145431d630ae67e89dbc9c014cac2a417759101
- Blokir penjelajah: https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Feu-1.gemini-2a.subspace.network%2Fws#/explorer

## Port yang diperlukan
Saat ini, port TCP `30333`perlu diekspos agar node berfungsi dengan baik. Jika Anda memiliki server tanpa firewall, tidak ada yang harus dilakukan, tetapi pastikan untuk membuka port TCP `30333`untuk koneksi masuk.

## Buat dompet Polkadot.js
Cara membuat dompet polkadot:
1. Unduh dan instal [Browser Extension](https://polkadot.js.org/extension/)
2. Arahkan ke [Subspace Explorer](https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Feu-1.gemini-2a.subspace.network%2Fws#/accounts) dan tekan tombol `Add account`
3. Simpan `mnemonic` dan buat dompet
4. Ini akan menghasilkan alamat dompet yang harus Anda gunakan nanti. Contoh alamat dompet: `st7QseTESMmUYcT5aftRJZ3jg357MsaAa93CFQL5UKsyGEk53`

## Siapkan node penuh Subspace Anda
Node penuh tidak menyimpan riwayat dan status seluruh blockchain, hanya bertahan 1024 blok
```
```
