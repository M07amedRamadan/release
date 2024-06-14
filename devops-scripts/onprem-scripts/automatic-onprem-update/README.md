# Onprem Automatic Update Script

This script will update the version of the application automatically using crontab. You will find this script in the DevOps repo. We will discuss what this script does and how to run it on the customer servers.

## Prerequisites
For this script to work, we will need the customer to be able to reach both the ECR and S3. If this isn’t the case, please refer to onsite documentation.

## How does it work?

### ECR
The customer will use the ECR to pull images to update their application. Note to only give the customer access to pull the images.

### S3
The customer will have a directory on the S3 bucket that contains the Docker Compose file. In any update, if we need to add any environment variables before the update, we will be able to. The customer will only have access to this directory and can only read this file.

### SES
SES is used as a notification to tell us if the deployment has failed or succeeded. The customer will only have access to send the emails from `no-reply@vultara.com`.

### Important Note
The script handles the case where the customer had an issue with pulling the image or a connectivity issue. In that case, the script will run the application on the old version.

## Images
The above images show the services the customer uses to update their application.

## How to run it?
You need to put both the `function.sh` and `update-version.sh` in the same directory you put the docker-compose.yml file. Don't forget to add the value of the following: -
1) RECIPIENT_EMAIL
2) repo (example <aws_account_id>.dkr.ecr.<region>.amazonaws.com)
3) modify the rest of the directory <enter the rest of the directory> in line 63
