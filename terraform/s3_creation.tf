# No change required in this file

resource "aws_s3_bucket" "New_Customer_Bucket" {
  for_each = toset(
    var.Application_type == "Vultara" ? ["${var.CUSTOMER_NAME}.vultara.test.com"] :
    var.Application_type == "SOC" ? ["${var.CUSTOMER_NAME}.soc.vultara.test.com"] : 
    [["${var.CUSTOMER_NAME}.vultara.test.com"],"${var.CUSTOMER_NAME}.soc.vultara.test.com"]
  )
  bucket = each.value
  force_destroy = true
}

#Public Access
resource "aws_s3_bucket_public_access_block" "New_Customer_Bucket_Permissions_Block" {
  # bucket = aws_s3_bucket.New_Customer_Bucket[each.value]
  for_each = aws_s3_bucket.New_Customer_Bucket
  bucket = each.key

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#########################################s3 report bucket#######################################

# resource "aws_s3_bucket" "reports-bucket" {
#   bucket = "${var.CUSTOMER_NAME}-reports-bucket"
#   force_destroy = true
# }

# resource "aws_s3_bucket_ownership_controls" "ownership-reports-bucket" {
#   bucket = aws_s3_bucket.reports-bucket.id
#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }

# resource "aws_s3_bucket_acl" "acl-reports-bucket" {
#   depends_on = [aws_s3_bucket_ownership_controls.ownership-reports-bucket]

#   bucket = aws_s3_bucket.reports-bucket.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-reports-bucket" {
   
#   bucket = aws_s3_bucket.reports-bucket.id
#   rule {
#     id      = "Expire current versions of objects After 7 Days"
#     status  = "Enabled"

#     expiration {
#       days = 7
#     }
#   }
# }

#####################################import bucket##################################################
# resource "aws_s3_bucket" "import-bucket" {
#   bucket = "${var.CUSTOMER_NAME}-import-bucket"
#   force_destroy = true
# } 

# #still, the import bucket is private but can be accessed through the policy only.
# resource "aws_s3_bucket_public_access_block" "Block-public-access" {
#   bucket = aws_s3_bucket.import-bucket.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }