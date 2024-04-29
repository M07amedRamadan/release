data "aws_iam_role" "vultara_role" {
  name = "scheduler-server-role"  # Replace with the name of your existing IAM role
}
 
#IAM Instance Profile Used to attach IAM role with ec2 
resource "aws_iam_instance_profile" "instance_profile" {
  name = "Ec2-instance-profile"
  role = data.aws_iam_role.vultara_role.name
}

