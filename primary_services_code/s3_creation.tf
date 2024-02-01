# No change required in this file

resource "aws_s3_bucket" "New_Customer_Bucket" {
  bucket = "${var.CUSTOMER_NAME}.vultara.com"
  force_destroy = true
}

#Public Access
resource "aws_s3_bucket_public_access_block" "New_Customer_Bucket_Permissions_Block" {
  bucket = aws_s3_bucket.New_Customer_Bucket.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#########################################s3 report bucket#######################################


resource "aws_s3_bucket" "reports-bucket" {
  bucket = "${var.CUSTOMER_NAME}-reports-bucket"
  force_destroy = true
}



resource "aws_s3_bucket_ownership_controls" "ownership-reports-bucket" {
  bucket = aws_s3_bucket.reports-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "acl-reports-bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership-reports-bucket]

  bucket = aws_s3_bucket.reports-bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-reports-bucket" {
   
  bucket = aws_s3_bucket.reports-bucket.id
  rule {
    id      = "Expire current versions of objects After 7 Days"
    status  = "Enabled"



    expiration {
      days = 7
    }
  }
}



######################################Production File Storage######################################
resource "aws_s3_bucket" "production-file-bucket" {
  bucket = "${var.CUSTOMER_NAME}-production-file-bucket"
  force_destroy = true
}
#####################################import bucket##################################################
resource "aws_s3_bucket" "import-bucket" {
  bucket = "${var.CUSTOMER_NAME}-import-bucket"
  force_destroy = true
} 

resource "aws_s3_bucket_public_access_block" "Block-public-access" {
  bucket = aws_s3_bucket.import-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}
