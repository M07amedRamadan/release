#!/bin/bash
docker compose down

docker image prune -af
docker rmi $(docker images -q)

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 837491041518.dkr.ecr.us-east-1.amazonaws.com
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

/usr/local/bin/aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 837491041518.dkr.ecr.us-east-1.amazonaws.com
export report_sha=$(/usr/local/bin/aws ecr describe-images --repository-name report-generator --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text)
export scheduler_sha=$(/usr/local/bin/aws ecr describe-images --repository-name scheduler --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text)
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:frontend
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:backend-obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:proxy
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/report-generator:obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/scheduler:backend-obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/authentication-server:backend-obf
docker pull 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultaradb:prod

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

docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:frontend
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:backend
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultara-main-app:proxy
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/report-generator:$report_sha
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/scheduler:$scheduler_sha
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/soc-app:frontend
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/soc-app:backend
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/authentication-server:backend
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/datasync:backend
docker rmi -f 837491041518.dkr.ecr.us-east-1.amazonaws.com/vultaradb:prod

rm -rf ./images/*

echo "mongo.tar"
docker save mongo -o ./images/mongo.tar
echo "authentication.tar"
docker save authentication-server:backend -o ./images/authentication-server.tar
echo "report-generator.tar"
docker save report-generator:onprem -o ./images/report-generator.tar
echo "datasync.tar"
docker save datasync:backend -o ./images/datasync.tar
echo "scheduler.tar"
docker save scheduler:onprem -o ./images/scheduler.tar
echo "soc-app-backend.tar"
docker save soc-app:backend -o ./images/soc-app-backend.tar
echo "soc-app-frontend.tar"
docker save soc-app:frontend -o ./images/soc-app-frontend.tar
echo "vultara-main-app-proxy.tar"
docker save vultara-main-app:proxy -o ./images/vultara-main-app-proxy.tar
echo "vultara-main-app-frontend.tar"
docker save vultara-main-app:frontend -o ./images/vultara-main-app-frontend.tar
echo "vultara-main-app-backend.tar"
docker save vultara-main-app:backend -o ./images/vultara-main-app-backend.tar

echo "downloading docker dependencies"
wget -P ./onsite-dependencies https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/containerd.io-1.6.28-3.1.el9.x86_64.rpm
wget -P ./onsite-dependencies https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-buildx-plugin-0.13.0-1.el9.x86_64.rpm
wget -P ./onsite-dependencies https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-ce-25.0.4-1.el9.x86_64.rpm
wget -P ./onsite-dependencies https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-ce-cli-25.0.4-1.el9.x86_64.rpm
wget -P ./onsite-dependencies https://download.docker.com/linux/rhel/9/x86_64/stable/Packages/docker-compose-plugin-2.24.7-1.el9.x86_64.rpm

echo "downloading aws dependencies"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "./onsite-dependencies/awscliv2.zip"

/usr/local/bin/aws s3 cp ./images/ s3://onsite-images0401/ --recursive
/usr/local/bin/aws s3 cp ./images/ s3://onsite-dependencies/ --recursive

sleep 20

#this is the number of seconds the presigned urls would be vaild for. you can make them valid for up to 7 days
valid_time=86400 

echo "printing the presigned urls"
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/vultara-main-app-frontend.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/vultara-main-app-backend.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/vultara-main-app-proxy.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/soc-app-frontend.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/soc-app-backend.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/scheduler.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/datasync.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/report-generator.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/authentication-server.tar --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/containerd.io-1.6.28-3.1.el9.x86_64.rpm --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/docker-buildx-plugin-0.13.0-1.el9.x86_64.rpm --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/docker-ce-25.0.4-1.el9.x86_64.rpm --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/docker-ce-cli-25.0.4-1.el9.x86_64.rpm --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/docker-compose-plugin-2.24.7-1.el9.x86_64.rpm --expires-in $valid_time
echo " "
/usr/local/bin/aws s3 presign s3://onsite-images0401/awscliv2.zip --expires-in $valid_time