#!/bin/bash

cd $1

source ./function.sh

images=("vultara-main-app-backend.tar" "vultara-main-app-frontend.tar" "soc-app-frontend.tar" "soc-app-backend.tar" "scheduler.tar" "datasync.tar" "report-generator.tar" "authentication-server.tar")

#load the docker images
for item in "${images[@]}"
do
   imageLink=$(/usr/local/bin/aws cloudfront sign \
    --url "https://<cloudfront-id>.cloudfront.net/$item" \
    --key-pair-id "<enter your key id>" \ 
    --private-key file://<enter-the-key-path> \
    --date-less-than $(date -d "+20 minutes" -u +"%Y-%m-%dT%H:%M:%SZ"))

   wget -O ../images/$item "$imageLink"

done

vultara_down

for tar_file in ../images/*.tar; do
  docker load -i "$tar_file"
done

echo "Updating the configrations"
/usr/local/bin/aws s3 cp s3://onsite-images0401/<customer-name>/docker-compose.yml ./docker-compose.yml > /dev/null 2>&1

Encrypt

vultara_up