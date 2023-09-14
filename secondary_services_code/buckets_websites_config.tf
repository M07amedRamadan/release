# No change required in this file
# Website Config for S3 # 1

resource "aws_s3_bucket_website_configuration" "New_Customer_website_configuration_1" {
  bucket = aws_s3_bucket.Service_Bucket_1.id

  index_document {
    suffix = "index.html"
  }
}


# Website Config for S3 # 2

resource "aws_s3_bucket_website_configuration" "New_Customer_website_configuration_2" {
  bucket = aws_s3_bucket.Service_Bucket_2.id

  index_document {
    suffix = "index.html"
  }
}


# Website Config for S3 # 3

resource "aws_s3_bucket_website_configuration" "New_Customer_website_configuration_3" {
  bucket = aws_s3_bucket.Service_Bucket_3.id

  index_document {
    suffix = "index.html"
  }
}


# Website Config for S3 # 4

resource "aws_s3_bucket_website_configuration" "New_Customer_website_configuration_4" {
  bucket = aws_s3_bucket.Service_Bucket_4.id

  index_document {
    suffix = "index.html"
  }
}