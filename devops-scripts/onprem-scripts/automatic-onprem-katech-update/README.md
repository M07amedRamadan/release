# Onprem katech Update Script

This script will update the version of the application automatically using crontab. You will find this script in the DevOps repo. We will discuss what this script does and how to run it on the customer servers.

## Prerequisites
For this script to work, we will need the customer to be able to reach both the ECR and S3. If this isn’t the case, please refer to onsite documentation. you also need to change the bash script to an executable file for security reasons using shc utility. for that to work you will need to have a C compliler.

## How does it work?

### ECR
The customer will use the ECR to pull images to update their application. Note to only give the customer access to pull the images.

### S3
The customer will have a directory on the S3 bucket that contains the Docker Compose file. In any update, if we need to add any environment variables before the update, we will be able to. The customer will only have access to this directory and can only read this file.

### SES
SES is used as a notification to tell us if the deployment has failed or succeeded. The customer will only have access to send the emails from `no-reply@vultara.com`.

### encrypting docker-compose.yml
 in this case the docker-compose.yml is encrypted via kms. to encrypt it use the following cmd
 

    /usr/local/bin/aws kms encrypt \
    --key-id alias/<put the key alias here> \
    --plaintext fileb://docker-compose.yml \
    --output text \
    --query CiphertextBlob \
    | base64 --decode > docker-compose.yml.encrypted


### transform the file to executable files
to transform the file to executable files use the shc utility.
    ```bash
    shc -r -f update-version-katech.sh
    ```
This will produce 2 files `update-version-katech.sh.c` and `update-version-katech.sh.x`. The `update-version-katech.sh.x` is the executable file we want.

### Important Note
The script handles the case where the customer had an issue with pulling the image or a connectivity issue. In that case, the script will run the application on the old version.

## How to run it?
You need to put `update-version-katech.sh.x` in the same directory you put the docker-compose.yml.encrypted file. Don't forget to add the value of the following: -
1) RECIPIENT_EMAIL
2) repo (example <aws_account_id>.dkr.ecr.<region>.amazonaws.com)
3) don't forget to change the permission for the file:-

    ```bash
    chmod 700 ./update-version-katech.sh.x
    ```

Here's the steps to setup a crontab on centos: -

# Setting Up a Cron Job on CentOS to Download a File

This guide explains how to create a cron job on a CentOS system that downloads a file using a script.

## Steps

### 1. Schedule the Script with Cron

1. Open the crontab editor:
    ```bash
    crontab -e
    ```

2. Add a new cron job to execute the script at your desired schedule. For example, to run the script at 2 AM at sunday and wensday, add:
    ```bash
    0 2 * * 0 /path/to/your/update-version-katech.sh.x /path/to/your/executablefile
    0 2 * * 3 /path/to/your/update-version-katech.sh.x /path/to/your/executablefile
    ```
note in this step you must know what timeline does the server use (mostly it will be UTC so you need to consider that).
    Here’s a breakdown of the schedule format:

    * * * * * command_to_execute
    - - - - -
    | | | | |
    | | | | ----- Day of the week (0 - 7) (Sunday is both 0 and 7)
    | | | ------- Month (1 - 12)
    | | --------- Day of the month (1 - 31)
    | ----------- Hour (0 - 23)
    ------------- Minute (0 - 59)

also note that the file takes the path it's currently in as an input. this is done to give the flexibility to put the file any where on the server.
3. Save and exit the editor. The cron job is now scheduled to run the script every day at 2 AM.

### 2. Verify the Cron Job

To verify that your cron job has been added, list all cron jobs for the current user:
```bash
crontab -l
