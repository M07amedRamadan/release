# No change required in this file

resource "aws_s3_bucket" "New_Customer_Bucket" {
  bucket = "${var.CUSTOMER_NAME}.vultara.com"
}

#Public Access
resource "aws_s3_bucket_public_access_block" "Permissions_Block" {
  bucket = aws_s3_bucket.New_Customer_Bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#ACL
#resource "aws_s3_bucket_acl" "my-bucket" {
 # bucket = aws_s3_bucket.New_Customer_Bucket.id
  #acl    = "private"
#}
