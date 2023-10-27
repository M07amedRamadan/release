# No change required in this file

resource "aws_s3_bucket" "New_Customer_Bucket" {
  bucket = "${var.CUSTOMER_NAME}.vultara.com"
  force_destroy = true
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



#######################################################CVE&CPEBucket######################################################


resource "aws_s3_bucket" "cve-cpe-bucket" {
  bucket = "${var.CUSTOMER_NAME}-cve-cpe-bucket"
  force_destroy = true
}



resource "aws_s3_bucket_ownership_controls" "ownership-cve-cpe-bucket" {
  bucket = aws_s3_bucket.cve-cpe-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "acl-cve-cpe-bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership-cve-cpe-bucket]

  bucket = aws_s3_bucket.cve-cpe-bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-cve-cpe-bucket" {
   
  bucket = aws_s3_bucket.cve-cpe-bucket.id
  rule {
    id      = "Expire current versions of objects After 7 Days"
    status  = "Enabled"



    expiration {
      days = 7
    }
  }
}

###################################################################################################

resource "aws_s3_bucket" "help-doc-bucket" {
  bucket = "${var.CUSTOMER_NAME}-help-doc-bucket"
  force_destroy = true
}



resource "aws_s3_bucket_ownership_controls" "ownership-help-doc-bucket" {
  bucket = aws_s3_bucket.help-doc-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "acl-help-doc-bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.ownership-help-doc-bucket]

  bucket = aws_s3_bucket.help-doc-bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle-help-doc-bucket" {
   
  bucket = aws_s3_bucket.help-doc-bucket.id
  rule {
    id      = "Expire current versions of objects After 7 Days"
    status  = "Enabled"



    expiration {
      days = 7
    }
  }
}
