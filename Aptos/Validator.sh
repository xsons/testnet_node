bash_profile=$HOME/.bash_profile
# setupVars
if [ ! $USERNAME ]; then
	read -p "Enter username: " USERNAME
	echo 'export USERNAME='$USERNAME >> $HOME/.bash_profile
fi
if [ ! $YOUR_IP ]; then
        read -p "Enter your VPS IP / DNS : " YOUR_IP
        echo 'export YOUR_IP='$YOUR_IP >> $HOME/.bash_profile
fi
echo "export WORKSPACE=testnet" >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

echo -e "\e[1m\e[32m [1]. Updating paket... \e[0m" && sleep 1
# update
sudo apt update && sudo apt upgrade -y
sudo apt install unzip

echo -e "\e[1m\e[32m [2]. Checking dependencies... \e[0m" && sleep 1
if ! command  jq –version &> /dev/null
then
    echo -e "\e[1m\e[32m [2.1] Installing dependencies... \e[0m" && sleep 1
    # packages
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.23.1/yq_linux_amd64 && chmod +x /usr/local/bin/yq
    sudo apt-get install jq -y
fi

echo -e "\e[1m\e[32m [3]. Checking if Docker is installed... \e[0m" && sleep 1
if ! command -v docker &> /dev/null
then
    echo -e "\e[1m\e[32m3.1 Installing Docker... \e[0m" && sleep 1
    sudo apt-get install ca-certificates curl gnupg lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
fi

echo -e "\e[1m\e[32m [4]. Checking if docker compose is installed ... \e[0m" && sleep 1
if ! command docker compose version &> /dev/null
then 
   docker_compose_version=$(wget -qO- https://api.github.com/repos/docker/compose/releases/latest | jq -r ".tag_name")
   sudo wget -O /usr/bin/docker-compose "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m`"
   sudo chmod +x /usr/bin/docker-compose
fi

echo -e "\e[1m\e[32m [5]. Install aptos CLI ... \e[0m" && sleep 1
wget -qO aptos-cli.zip https://github.com/aptos-labs/aptos-core/releases/download/aptos-cli-v0.3.1/aptos-cli-0.3.1-Ubuntu-x86_64.zip
sudo unzip -o aptos-cli.zip -d /usr/local/bin
chmod +x /usr/local/bin/aptos
rm aptos-cli.zip
aptos -V

echo -e "\e[1m\e[32m [6]. Creating workspace directory ... \e[0m" && sleep 1
export WORKSPACE=testnet
mkdir ~/$WORKSPACE
cd ~/$WORKSPACE

echo -e "\e[1m\e[32m [7]. Download validator.yaml & docker-compose.yaml ... \e[0m" && sleep 1
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/docker-compose.yaml
wget https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/aptos-node/validator.yaml

echo -e "\e[1m\e[32m [8]. Generate key pairs ... \e[0m" && sleep 1\
mkdir -p ~/$WORKSPACE/keys
aptos genesis generate-keys --output-dir ~/$WORKSPACE/keys

echo -e "\e[1m\e[32m [9].  Set-validator-configuration ... \e[0m" && sleep 1
cd ~/$WORKSPACE
aptos genesis set-validator-configuration \
    --local-repository-dir ~/$WORKSPACE \
    --username $USERNAME \
    --owner-public-identity-file ~/$WORKSPACE/keys/public-keys.yaml \
    --validator-host $YOUR_IP:6180 \
    --stake-amount 100000000000000

if ! [ -f "$WORKSPACE/layout.yaml" ]
then
sudo tee layout.yaml > /dev/null <<EOF
---
root_key: "D04470F43AB6AEAA4EB616B72128881EEF77346F2075FFE68E14BA7DEBD8095E"
users: ["$USERNAME"]
chain_id: 43
allow_new_validators: false
epoch_duration_secs: 7200
is_test: true
min_stake: 100000000000000
min_voting_threshold: 100000000000000
max_stake: 100000000000000000
recurring_lockup_duration_secs: 86400
required_proposer_stake: 100000000000000
rewards_apy_percentage: 10
voting_duration_secs: 43200
voting_power_increase_limit: 20
EOF
fi

echo -e "\e[1m\e[32m [10].  Download the Aptos Framework ... \e[0m" && sleep 1
wget https://github.com/aptos-labs/aptos-core/releases/download/aptos-framework-v0.3.0/framework.mrb

echo -e "\e[1m\e[32m [11].  Compile genesis blob and waypoint ... \e[0m" && sleep 1 
aptos genesis generate-genesis --local-repository-dir ~/$WORKSPACE --output-dir ~/$WORKSPACE

echo -e "\e[1m\e[32m  Start running \e[0m" && sleep 1 
cd ~/testnet
docker-compose up -d
