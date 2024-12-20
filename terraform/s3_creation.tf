# No change required in this file

resource "aws_s3_bucket" "New_Customer_Bucket" {
  for_each = toset(local.resources)
  bucket = "${each.value}.vultara.com"
  force_destroy = true
}

#Public Access
resource "aws_s3_bucket_public_access_block" "New_Customer_Bucket_Permissions_Block" {
  for_each = toset(local.resources)
  bucket = each.key

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
  for_each = toset(local.resources)
  bucket = "${each.value}.vultara.com"

  # Ensure that the CloudFront Origin Access Identity is created before applying the updated bucket policy
  lifecycle {
    create_before_destroy = true
  }

  policy = jsonencode({
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
      {
        "Sid": "1",
        "Effect": "Allow",
        "Principal": {
          "AWS": "${aws_cloudfront_origin_access_identity.new_oai[each.value].iam_arn}"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${each.value}.vultara.com/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.New_Customer_Bucket_Permissions_Block]
}
