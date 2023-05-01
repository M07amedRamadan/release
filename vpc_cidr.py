import boto3

# Create a boto3 client for the VPC service
vpc_client = boto3.client('ec2', region_name='us-east-1')

# Retrieve a list of all VPCs in the account
response = vpc_client.describe_vpcs()

# Filter the list of VPCs to include only those with a CIDR block in the 10.1.x.x/24 range
vpcs = [vpc for vpc in response['Vpcs'] if vpc['CidrBlock'].startswith('10.1.')]

# Sort the filtered VPCs based on their CIDR block in descending order
vpcs.sort(key=lambda vpc: vpc['CidrBlock'], reverse=True)

# Iterate over the filtered and sorted list of VPCs and print their VPC ID, name, and CIDR block
for vpc in vpcs:
    print("VPC ID:", vpc['VpcId'])
    print("VPC Name:", vpc.get('Tags', [{'Key': 'Name', 'Value': ''}])[0]['Value'])
    print("CIDR Block:", vpc['CidrBlock'])

