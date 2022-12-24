sudo apt update
sudo apt install snapd -y
sudo snap install lz4

sudo systemctl stop humansd

humansd tendermint unsafe-reset-all --home $HOME/.humans --keep-addr-book

curl -L https://snap.nodeist.net/t/humans/humans.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.humans --strip-components 2

sudo systemctl start humansd && journalctl -u humansd -f --no-hostname -o cat
