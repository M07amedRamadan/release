# No change required in this file

resource "aws_s3_bucket_website_configuration" "New_Customer_website_configuration" {
  bucket = aws_s3_bucket.New_Customer_Bucket.id

  index_document {
    suffix = "index.html"
  }
}
