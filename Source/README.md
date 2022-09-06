<p style="font-size:14px" align="right">
<a href="https://t.me/BeritaCryptoo" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>
<a href="https://twitter.com/BeritaCryptoo" target="_blank">Join our twitter <img src="https://user-images.githubusercontent.com/108946833/184274157-08210464-fa03-493d-b01c-2420c67a524f.jpg" width="30"/></a>
</p>

<p align="center">
  <img height="150" height="auto" src="https://user-images.githubusercontent.com/44331529/183239082-09722b8d-9cc7-49a1-9d93-15ce3ab8d752.png">
</p>

# Source Testnet

|  Komponen |  Persyaratan Minimum |
| ------------ | ------------ |
| CPU  | 4 or more physical CPU cores  |
| RAM | At least 8GB of memory (RAM) |
| Penyimpanan  | At least 160GB of SSD disk storage |
| koneksi | At least 100mbps network bandwidth |

## Perangkat Lunak

|Komponen | Persyaratan Minimum |
| ------------ | ------------ |
| OS | Ubuntu 20.04 | 

## Install Otomatis
```console
wget -O haqq.shhttps://raw.githubusercontent.com/xsons/TestnetNode/main/Source/source.sh && chmod +x source.sh && ./source.sh
```
Opsi 2 (manual)

Anda dapat mengikuti [panduan manual](https://github.com/xsons/TestnetNode/blob/main/Source/Manual.md) jika Anda lebih suka mengatur node secara manual

## Install Snapshots
```bash
# install the node as standard, but do not launch. Then we delete the .data directory and create an empty directory
sudo systemctl stop sourced
rm -rf $HOME/.source/data/
mkdir $HOME/.source/data/

# download archive
cd $HOME
wget http://116.202.236.115:8000/sourcedata.tar.gz

# unpack the archive
tar -C $HOME/ -zxvf sourcedata.tar.gz --strip-components 1
# !! IMPORTANT POINT. If the validator was created earlier. Need to reset priv_validator_state.json  !!
wget -O $HOME/.source/data/priv_validator_state.json "https://raw.githubusercontent.com/xsons/StateSync-snapshots/main/priv_validator_state.json"
cd && cat .source/data/priv_validator_state.json
{
  "height": "0",
  "round": 0,
  "step": 0
}

# after unpacking, run the node
# don't forget to delete the archive to save space
cd $HOME
rm sourcedata.tar.gz
# start the node
sudo systemctl restart sourced && journalctl -u sourced -f -o cat
```
### Create Wallet or Restore Wallet
```
sourced keys add <wallet name>
  or
sourced keys add <wallet name> --recover
```
### Check Set Wallet
```
sourced debug addr <wallet address>
```
Get Faucet Token On Discord 
>- [Discord Official Source](https://discord.gg/MgcfAgrD)

### Create Validator
```console
sourced tx staking create-validator \
--amount=1000000usource \
--pubkey=$(sourced tendermint show-validator) \
--moniker=<moniker> \
--chain-id=sourcechain-testnet \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.1" \
--min-self-delegation="1" \
--fees=100usource \
--from=<walletName> \
--identity="" \
--website="" \
--details="" \
-y
```
### Get list of validators
- For Active Validators
```console
sourced q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
- For Inactive Validators
```console
sourced q staking validators -o json --limit=3000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
## Usefull commands
### Service management
Check logs
```console
journalctl -fu sourced -o cat
```
Start service
```console
sudo systemctl start sourced
```
Stop service
```console
sudo systemctl stop sourced
```
Restart service
```console
sudo systemctl restart sourced
```
## Node info
Synchronization info
```console
sourced status 2>&1 | jq .SyncInfo
```
Validator info
```console
seid status 2>&1 | jq .ValidatorInfo
```
Node info
```console
sourced status 2>&1 | jq .NodeInfo
```
Show node id
```console
sourced tendermint show-node-id
```
### Wallet operations
List of wallets
```console
sourced keys list
```
Recover wallet
```console
sourced keys add <wallet name> --recover
```
Delete wallet
```console
sourced keys delete <wallet name>
```
Backup Private Key
```console
sourced keys export <wallet name> --unarmored-hex --unsafe
```
Get wallet balance
```console
sourced query bank balances <wallet address>
```
Transfer funds
```console
sourced tx bank send <wallet address> <to sei wallet address> 10000000usource
```
Voting
```console
sourced tx gov vote 1 yes --from <wallet name> --chain-id=sourcechain-testnet
```
### Staking, Delegation and Rewards
Delegate stake
```console
sourced tx staking delegate <valoper address> 10000000usource --from=<waller name> --chain-id=sourcechain-testnet --gas=auto
```
Redelegate stake from validator to another validator
```console
sourced tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000usource --from=<wallet name> --chain-id=sourcechain-testnet --gas=auto
```
Withdraw all rewards
```console
sourced tx distribution withdraw-all-rewards --from=<wallet name> --chain-id=sourcechain-testnet1 --gas=auto
```
Withdraw rewards with commision
```console
sourced tx distribution withdraw-rewards <your valoper address> --from=<wallet name> --commission --chain-id=sourcechain-testnet
```

### Validator Management
Edit validator
```console
sourced tx staking edit-validator \
  --moniker=<your moniker> \
  --identity=<your_keybase_id> \
  --website="<your_website>" \
  --details="<your_validator_description>" \
  --chain-id=sourcechain-testnet \
  --from=<wallet name>
 ```
Unjail validator
```console
sourced tx slashing unjail \
  --broadcast-mode=block \
  --from=<your wallet name> \
  --chain-id=sourcechain-testnet \
  --gas=auto
 ```
Delete node
This commands will completely remove node from server. Use at your own risk!
```console
sudo systemctl stop sourced && \
sudo systemctl disable sourced && \
rm /etc/systemd/system/sourced.service && \
sudo systemctl daemon-reload && \
cd $HOME && \
rm -rf .source && \
rm -rf source && \
rm -rf source.sh \
rm -rf $(which sourced)
```
