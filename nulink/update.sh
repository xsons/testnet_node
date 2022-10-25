# stop node
docker stop ursula
docker rm ursula
sleep 2

# Pull the latest NuLink image :
docker pull nulink/nulink:latest
sleep 2

# relaunch the node
docker run --restart on-failure -d \
 --name ursula \
 -p 9151:9151 \
 -v /root/nulink:/code \
 -v /root/nulink:/home/circleci/.local/share/nulink \
 -e NULINK_KEYSTORE_PASSWORD \
 -e NULINK_OPERATOR_ETH_PASSWORD \
 nulink/nulink nulink ursula run --no-block-until-ready
 
sleep 1
