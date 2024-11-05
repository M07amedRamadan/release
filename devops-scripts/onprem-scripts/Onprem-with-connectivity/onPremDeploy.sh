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

if [ ! -f "awscliv2.zip" ]; then
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   yum install unzip -y
   unzip awscliv2.zip
   echo "please wait till installing aws"
   ./aws/install >> /dev/null
else
   echo "AWS already exists. Skipping download."
fi


#adding aws credentials
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=


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
export report_sha=$(/usr/local/bin/aws ecr describe-images --repository-name report-generator --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text)
export scheduler_sha=$(/usr/local/bin/aws ecr describe-images --repository-name scheduler --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text)
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:frontend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:backend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:proxy
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/report-generator:$report_sha
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/scheduler:$scheduler_sha
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/soc-app:frontend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/soc-app:backend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/authentication-server:backend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/datasync:backend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultaradb:prod

#modifing the tag
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/report-generator:$report_sha report-generator:onprem
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/scheduler:$scheduler_sha scheduler:onprem
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:frontend vultara-main-app:frontend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:backend vultara-main-app:backend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:proxy vultara-main-app:proxy 
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/soc-app:frontend soc-app:frontend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/soc-app:backend soc-app:backend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/authentication-server:backend authentication-server:backend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/datasync:backend datasync:backend
docker tag 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultaradb:prod mongo:latest

#running the docker containers and adding the data
docker compose up -d
docker cp ./mongo-restore.sh vultaradb:/etc
docker exec -u 0 vultaradb sh -c 'cd /etc && chmod 700 ./mongo-restore.sh && ./mongo-restore.sh && rm -rf dump && rm -rf mongo-restore.sh'
rm ./docker-compose.yml
rm ./mongo-restore.sh