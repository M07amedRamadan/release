name: "Destroy IAC Deployment"

on:
  workflow_dispatch:
    # Inputs the workflow accepts.
    inputs:
      name:
        description: 'Enter Customer Name'
        default: 'automation'
        required: true

      vpc-cidr:
        description: 'Enter the VPC CIDR'
        default: '10.1.7.0/24'
        required: true

      region:
        description: 'Enter the Region for Deployment'
        default: 'us-east-1'
        required: true
      
      public_subnet-1:
        description: 'Enter the CIDRs for Public Subnet 1'
        default: '10.1.7.0/26'
        required: true

      public_subnet-2:
        description: 'Enter the CIDRs for Public Subnet 2'
        default: '10.1.7.64/26'
        required: true

      private_subnet-1:
        description: 'Enter the CIDRs for Private Subnet 1'
        default: '10.1.7.128/26'
        required: true

      private_subnet-2:
        description: 'Enter the CIDRs for Private Subnet 2'
        default: '10.1.7.192/26'
        required: true

      instance-type:
        description: 'Enter the Intance Type for EC2 Instance Scheduler'
        default: 't2.small'
        required: true
        type: choice
        options:
          - 't2.small'
          - 't2.medium'
          - 't2.large'
          - 't3.small'
          - 't3.medium'
          - 't3.large'

      ami-type:
        description: 'Enter the AMI Type for EC2 Instance Scheduler'
        default: 'ami-007855ac798b5175e'
        required: true
        type: choice
        options:
          - 'ami-007855ac798b5175e' #Ubuntu 22.04
          - 'ami-06878d265978313ca' #Amazon Linux 2 

      key-name:
        description: 'Enter the KeyPair Name for EC2 Instance Scheduler'
        default: 'automation_test'
        required: true


jobs:
  terraform:
    name: "Terraform"
    runs-on: ubuntu-latest
    environment:
      name: Dev
    env:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      
    steps:

      - name: Checkout
        uses: actions/checkout@v2

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1

      - name: Terraform Init
        id: init
        run: |
          cd primary_services_code
          terraform init -reconfigure -backend-config="bucket=vultara-terraform.tfstate-bucket" -backend-config="key=${{ github.event.inputs.name }}" -backend-config="region=${{ github.event.inputs.region }}"


      - name: Terraform Destroy
        run: |
          cd primary_services_code
          terraform destroy -auto-approve -var="CUSTOMER_NAME=${{ github.event.inputs.name }}" -var="cidr=${{ github.event.inputs.vpc-cidr }}" -var="region=${{ github.event.inputs.region }}" -var="public_subnet_1=${{ github.event.inputs.public_subnet-1 }}" -var="public_subnet_2=${{ github.event.inputs.public_subnet-2 }}" -var="key_name=${{ github.event.inputs.key-name }}" -var="ami=${{ github.event.inputs.ami-type }}" -var="instance_type=${{ github.event.inputs.instance-type }}" -var="private_subnet_1=${{ github.event.inputs.private_subnet-1 }}" -var="private_subnet_2=${{ github.event.inputs.private_subnet-2 }}"
    
