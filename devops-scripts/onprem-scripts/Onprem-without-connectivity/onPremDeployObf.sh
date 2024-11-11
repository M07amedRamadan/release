#!/bin/bash

yum update -y

#creating the keys
if [ ! -f ".docker-compose.yml" ]; then
  mkdir ./.key
  openssl rand -base64 32 > ./.key/keyfile
  chmod 600 ./.key/keyfile
else
   echo "already encrypted"
fi

if [ ! -f ".docker-compose.yml" ]; then
  gpg --batch --yes --passphrase-file "./.key/keyfile" -c -o ./.docker-compose.yml docker-compose.yml
  multiline_code="vultara_up() {
    gpg --batch --yes --passphrase-file "$PWD/.key/keyfile" -d "$PWD/.docker-compose.yml" > "$PWD/docker-compose.yml"
    sudo docker compose -f $PWD/docker-compose.yml up -d
    rm $PWD/docker-compose.yml
  }"
  echo "$multiline_code" >> /etc/bashrc
  source /etc/bashrc
else
   echo "docker compose file is already created"
fi

yum install unzip -y
unzip awscliv2.zip
echo "please wait till installing aws"
./aws/install >> /dev/null

echo "please wait till installing docker"
rpm -i containerd.io-1.6.28-3.1.el9.x86_64.rpm docker-buildxplugin-0.13.0-1.el9.x86_64.rpm docker-ce-25.0.4-1.el9.x86_64.rpm docker-ce-cli-25.0.4-1.el9.x86_64.rpm docker-compose-plugin-2.24.7-1.el9.x86_64.rpm


docker load -i authentication-server.tar
docker load -i vultara-main-app-backend.tar
docker load -i vultara-main-app-frontend.tar
docker load -i scheduler.tar
docker load -i vultaradb.tar

#running the docker containers and adding the data
docker compose up -d
docker exec vultaradb mongorestore --nsInclude="librariesCustomer.*" --nsFrom="librariesCustomer.*" --nsTo="librariesCustomer.*" --drop /etc/dump
docker exec vultaradb rm -rf /etc/dump
