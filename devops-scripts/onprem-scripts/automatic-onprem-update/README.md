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
4) don't forget to change the permission for both files:-

    ```bash
    chmod 700 ./function.sh && chmod 700 ./update-version.sh
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

2. Add a new cron job to execute the script at your desired schedule. For example, to run the script every day at 2 AM, add:
    ```bash
    0 2 * * * /path/to/your/update-version.sh
    ```

    Here’s a breakdown of the schedule format:
    ```
    * * * * * command_to_execute
    - - - - -
    | | | | |
    | | | | ----- Day of the week (0 - 7) (Sunday is both 0 and 7)
    | | | ------- Month (1 - 12)
    | | --------- Day of the month (1 - 31)
    | ----------- Hour (0 - 23)
    ------------- Minute (0 - 59)
    ```

3. Save and exit the editor. The cron job is now scheduled to run the script every day at 2 AM.

### 2. Verify the Cron Job

To verify that your cron job has been added, list all cron jobs for the current user:
```bash
crontab -l
