# No change required in this file
# S3 Bucket # 1

resource "aws_s3_bucket" "Service_Bucket_1" {
  bucket = "${var.SERVICE_NAME_1}.vultara.com"
  force_destroy = true
}

#Public Access
resource "aws_s3_bucket_public_access_block" "Permissions_Block_1" {
  bucket = aws_s3_bucket.Service_Bucket_1.bucket

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

# S3 Bucket # 2

resource "aws_s3_bucket" "Service_Bucket_2" {
  bucket = "${var.SERVICE_NAME_2}.vultara.com"
  force_destroy = true
}

#Public Access
resource "aws_s3_bucket_public_access_block" "Permissions_Block_2" {
  bucket = aws_s3_bucket.Service_Bucket_2.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#S3 Bucket # 3

resource "aws_s3_bucket" "Service_Bucket_3" {
  bucket = "${var.SERVICE_NAME_3}.vultara.com"
  force_destroy = true
}

#Public Access
resource "aws_s3_bucket_public_access_block" "Permissions_Block_3" {
  bucket = aws_s3_bucket.Service_Bucket_3.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket # 4

resource "aws_s3_bucket" "Service_Bucket_4" {
  bucket = "${var.SERVICE_NAME_4}.vultara.com"
  force_destroy = true
}

#Public Access
resource "aws_s3_bucket_public_access_block" "Permissions_Block_4" {
  bucket = aws_s3_bucket.Service_Bucket_4.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
