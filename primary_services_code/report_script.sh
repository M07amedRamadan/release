#!/bin/bash
sudo apt-get update -y
apt install unzip -y
apt-get install -y docker.io
usermod -aG docker ubuntu
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# Retrieve the instance ID and instance name using the AWS CLI
instance_id=$(ec2metadata --instance-id)
instance_name=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[0].Instances[0].Tags[?Key==`Name`].Value' --output text)
echo "The Instance ID is : ${instance_id}"
echo "The Instance Name is : ${instance_name}"
#Download  CloudWatch Agent
sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
#Install amazon-cloudwatch-agent
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
# Create CloudWatch configuration file
sudo touch /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
# Write the CloudWatch Agent configuration file
sudo bash -c "cat <<EOF > '/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json'
{
  \"logs\": {
    \"logs_collected\": {
      \"files\": {
        \"collect_list\": [
          {
            \"file_path\": \"/var/log/syslog\",
            \"log_group_name\": \"${instance_name}-Logs\"
          }
        ]
      }
    }
  },
  \"metrics\": {
    \"append_dimensions\": {
      \"InstanceId\": \"${instance_id}\"
    },
    \"metrics_collected\": {
      \"statsd\": {
        \"service_address\": \":8125\",
        \"metrics_collection_interval\": 10,
        \"metrics_aggregation_interval\": 60
      }
    }
  }
}
EOF"
# Start the CloudWatch Agent service
sudo systemctl start amazon-cloudwatch-agent
# Enable the CloudWatch Agent service to start on boot
sudo systemctl enable amazon-cloudwatch-agent
sudo mkdir /home/ubuntu/newdir
sudo touch /home/ubuntu/newdir/file.txt
echo "${var.region}" >> /home/ubuntu/newdir/file.txt
