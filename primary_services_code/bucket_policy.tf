# No change required in this file

resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
  bucket = aws_s3_bucket.New_Customer_Bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.CUSTOMER_NAME}.vultara.com/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.Permissions_Block]
}