#!/bin/bash
source ./function.sh

 AWS_REGION="us-east-1"
 SENDER_EMAIL="no-reply@vultara.com"
 RECIPIENT_EMAIL=""
 EMAIL_SUBJECT=""
 date=$(date +"%Y-%m-%d")
 EMAIL_BODY="Deployment version update on date ${date} has failed"
 repo=<repo-name>

update-image() {
  imageName=$1
  try=$2
  docker pull $repo/$imageName > /dev/null 2>&1
  if [[ $try -gt 3 ]];then
    echo "update failed"
    vultara_up
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
    if [[ "$originalImageName" == "scheduler" || "$originalImageName" == "report-generator" ]]; then
      docker tag $repo/$imageName $originalImageName:onprem
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


export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
/usr/local/bin/aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $repo  > /dev/null 2>&1

export report_sha=$(/usr/local/bin/aws ecr describe-images --repository-name report-generator --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text)
export scheduler_sha=$(/usr/local/bin/aws ecr describe-images --repository-name scheduler --query 'sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]' --output text)

vultara_images=("vultara-main-app:proxy" "vultara-main-app:frontend" "vultara-main-app:backend" "soc-app:frontend" "soc-app:backend" "datasync:backend" "authentication-server:backend" "report-generator":$report_sha "scheduler":$scheduler_sha)

vultara_down

for imageName in "${vultara_images[@]}"; do
  echo "Processing image: $imageName"
  update-image $imageName 1
done

vultara_up

echo "Updating the configrations"
/usr/local/bin/aws s3 cp s3://onsite-images0401/<customer-name>/docker-compose.yml ./docker-compose.yml > /dev/null 2>&1
Encrypt

EMAIL_SUBJECT="BorgWarner deployment"
EMAIL_BODY="Deployment version update on date ${date} has been successful"
/usr/local/bin/aws ses send-email \
    --region $AWS_REGION \
    --from "$SENDER_EMAIL" \
    --destination "ToAddresses=$RECIPIENT_EMAIL" \
    --message "Subject={Data=\"$EMAIL_SUBJECT\"},Body={Text={Data=\"$EMAIL_BODY\"}}" > /dev/null 2>&1
