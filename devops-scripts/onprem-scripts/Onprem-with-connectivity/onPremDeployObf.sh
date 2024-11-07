#!/bin/bash

yum update -y

if [ ! -f "awscliv2.zip" ]; then
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   yum install unzip -y
   unzip awscliv2.zip
   echo "please wait till installing aws"
   ./aws/install >> /dev/null
else
   echo "AWS already exists. Skipping download."
fi


if ! command -v docker &> /dev/null; then
  yum install -y yum-utils
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  systemctl start docker
else
  echo "Docker is already installed"
fi

#login ecr and pulling the images
/usr/local/bin/aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 837491041518.dkr.ecr.us-east-1.amazonaws.com
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:frontend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:backend-obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/report-generator:obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/scheduler:backend-obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/authentication-server:backend-obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultaradb:data-prod

#modifing the tag
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/report-generator:obf report-generator:onprem
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/scheduler:backend-obf scheduler:onprem
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:frontend vultara-main-app:frontend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:backend-obf vultara-main-app:backend 
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/authentication-server:backend-obf authentication-server:backend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultaradb:data-prod vultaradb:data

#running the docker containers and adding the data
DECRYPTED_CONTENT=$(/usr/local/bin/aws kms decrypt \
    --ciphertext-blob fileb://docker-compose.yml \
    --output text \
    --query Plaintext \
    | base64 --decode)

# Check if decryption was successful
if [ -z "$DECRYPTED_CONTENT" ]; then
  echo "Decryption failed"
  exit 1
fi

# Run docker-compose with the decrypted content using stdin
echo "$DECRYPTED_CONTENT" | docker compose -f - up -d

docker exec vultaradb mongorestore --nsInclude="librariesCustomer.*" --nsFrom="librariesCustomer.*" --nsTo="librariesCustomer.*" --drop /etc/dump

docker exec vultaradb rm -rf /etc/dump

