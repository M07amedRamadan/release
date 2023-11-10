#!/bin/bash
sudo apt-get update -y
apt install unzip -y
apt-get install -y docker.io
usermod -aG docker ubuntu
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
