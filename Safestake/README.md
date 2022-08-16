# Safestake Incentivized Testnet By ParaState
## Get Started
In our eco-system, validators are delegating their tasks to operators and there is no need for deployment of validators. Therefore, we will discuss below two relevant deployment sections, one for *SafeStake Service Provider*, and one for *Operator*. Please only read the corresponding section for your deployment.

### Depoly SafeStake Service Provider

SafeStake service provider contains several components:

- A web server and frontend

- A nodejs backend (for necessary communication with operators)

- A root node service (for peer discovery in a p2p network)

#### Root Node Service

The duty agreement (using Hotstuff) among operators requires that these operators know IP of each other in a p2p network. Therefore, SafeSake provides a root node such that operators can consult and join the p2p network.

#### Dependencies
 * Public Static Network IP 
 * Hardware(recommend)
   * CPU: 4
   * Memory: 8G
   * Disk: 200GB
 * OS
   * Unix
 * Software
   * Docker
   * Docker Compose 


## Installation

Clone this repository:
```
git clone --recurse-submodules https://github.com/ParaState/SafeStakeOperator
cd SafeStakeOperator
```
## Install Docker
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```
## Install Docker Compose
```
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose
sudo chown $USER /var/run/docker.sock
```
## Jalankan Docker
```
sudo docker compose -f docker-compose-boot.yml build
```
```
sudo docker compose build -f docker-compose-boot.yml up -d
```
```
docker-compose -f docker-compose-boot.yml logs -f dvf_root_node | grep enr
```
#### Output
> dvf-dvf_root_node-1  | Base64 ENR: *enr:-IS4QNa-kpJM1eWfueeEnY2iXlLAL0QY2gAWAhmsb4c8VmrSK9J7N5dfXS_DgSASCDrUTHMqMUlP4OXSYEVh-Z7zFHkBgmlkgnY0gmlwhAMBnbWJc2VjcDI1NmsxoQPKY0yuDUmstAHYpMa2_oxVtw0RW_QAdpzBQA8yWM0xOIN1ZHCCIy0*

CATATAN: ***SafeStake harus memelihara ENR node root tersebut di situs webnya, sehingga pengguna yang mendaftar sebagai operator dapat menggunakannya untuk memulai node operator.***
## Deploy Operator
