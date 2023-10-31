#!/bin/bash
apt update -y
apt install unzip -y
apt install -y docker.io
usermod -aG docker ubuntu
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# Start Docker service
systemctl start docker
systemctl enable docker
