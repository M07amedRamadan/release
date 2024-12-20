# No change required in this file
# S3 bucket Policy for Bucket # 1

resource "aws_s3_bucket_policy" "hosting_bucket_policy_1" {
  bucket = aws_s3_bucket.Service_Bucket_1.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.SERVICE_NAME_1}.vultara.com/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.Permissions_Block_1]
}


# S3 bucket Policy for Bucket # 2

resource "aws_s3_bucket_policy" "hosting_bucket_policy_2" {
  bucket = aws_s3_bucket.Service_Bucket_2.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.SERVICE_NAME_2}.vultara.com/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.Permissions_Block_2]
}


# S3 bucket Policy for Bucket # 3

resource "aws_s3_bucket_policy" "hosting_bucket_policy_3" {
  bucket = aws_s3_bucket.Service_Bucket_3.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.SERVICE_NAME_3}.vultara.com/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.Permissions_Block_3]
}


# S3 bucket Policy for Bucket # 4

resource "aws_s3_bucket_policy" "hosting_bucket_policy_4" {
  bucket = aws_s3_bucket.Service_Bucket_4.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.SERVICE_NAME_4}.vultara.com/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.Permissions_Block_4]
}
