resource "aws_s3_bucket_cors_configuration" "s3-cors" {
  bucket = aws_s3_bucket.import-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "DELETE", "GET"]
    allowed_origins = ["https://${var.CUSTOMER_NAME}.vultara.com"]
    expose_headers  = []
  }
}
