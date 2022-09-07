[Install Node](https://github.com/xsons/TestnetNode/tree/main/Source)
=
# SnapShot 06.09.22 (0.1 GB) block height --> 2226618
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
wget -O $HOME/.source/data/priv_validator_state.json "https://raw.githubusercontent.com/obajay/StateSync-snapshots/main/priv_validator_state.json"
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
