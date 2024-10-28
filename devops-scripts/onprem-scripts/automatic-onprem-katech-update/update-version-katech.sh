#!/bin/bash

cd $1

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=us-east-1
AWS_REGION="us-east-1"
SENDER_EMAIL="no-reply@vultara.com"
RECIPIENT_EMAIL="" #add the email you see fit.
EMAIL_SUBJECT="Katech deployment"
date=$(date +"%Y-%m-%d")
EMAIL_BODY="Deployment version update on date ${date} has failed"
DECRYPTED_CONTENT=$(/usr/local/bin/aws kms decrypt \
    --key-id alias/onprem-test \
    --ciphertext-blob fileb://docker-compose.yml.encrypted \
    --output text \
    --query Plaintext \
    | base64 --decode)

update-image() {
  imageName=$1
  try=$2
  repo=837491041518.dkr.ecr.us-east-1.amazonaws.com
  docker pull $repo/$imageName > /dev/null 2>&1
  if [[ $try -gt 3 ]];then
    echo "update failed"
    echo "$DECRYPTED_CONTENT" | docker compose -f - up -d
    /usr/local/bin/aws ses send-email \
        --region $AWS_REGION \
        --from "$SENDER_EMAIL" \
        --destination "ToAddresses=$RECIPIENT_EMAIL" \
        --message "Subject={Data=\"$EMAIL_SUBJECT\"},Body={Text={Data=\"$EMAIL_BODY\"}}" > /dev/null 2>&1
    exit 1
  elif [[ $(docker images -q "${repo}/${imageName}") != "" ]]; then
    echo "Image ${imageName} downloaded successfully."
    docker rmi -f ${imageName} > /dev/null 2>&1
    originalImageName="${imageName%%:*}"
    originalImageTag="${imageName#*:}"
    if [[ "$originalImageName" == "scheduler" ]]; then
      docker tag $repo/$imageName $originalImageName:onprem
    elif [[ "$originalImageName" == "report-generator" ]]; then
      docker tag $repo/$imageName report:obf
    elif [[ "$originalImageTag" == "backend-obf" ]]; then
      docker tag $repo/$imageName $originalImageName:backend
    else
      docker tag $repo/$imageName $imageName
    fi
    docker rmi -f ${repo}/${imageName} > /dev/null 2>&1
    echo "Image ${imageName} updated successfully"
  else
    echo "Image ${imageName} does not exist, trail no. $try"
    update-image $imageName $(($try + 1))
  fi
}

/usr/local/bin/aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 837491041518.dkr.ecr.us-east-1.amazonaws.com  > /dev/null 2>&1

vultara_images=("vultara-main-app:frontend" "vultara-main-app:backend-obf" "authentication-server:backend-obf" "report-generator:obf" "scheduler:backend-obf" "vultaradb:data-prod")

echo "$DECRYPTED_CONTENT" | docker compose -f - down

for imageName in "${vultara_images[@]}"; do
  echo "Processing image: $imageName"
  update-image $imageName 1
done

echo "Updating the configrations"
/usr/local/bin/aws s3 cp s3://obf-image/katech-onprem-config/docker-compose.yml.encrypted ./docker-compose.yml.encrypted > /dev/null 2>&1

echo "$DECRYPTED_CONTENT" | docker compose -f - up -d

EMAIL_SUBJECT="Katech deployment"
EMAIL_BODY="Deployment version update on date ${date} has been successful"
/usr/local/bin/aws ses send-email \
    --region $AWS_REGION \
    --from "$SENDER_EMAIL" \
    --destination "ToAddresses=$RECIPIENT_EMAIL" \
    --message "Subject={Data=\"$EMAIL_SUBJECT\"},Body={Text={Data=\"$EMAIL_BODY\"}}" > /dev/null 2>&1
