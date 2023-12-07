# file modules/s3/main.tf

resource "aws_s3_bucket" "storage" {
  bucket = var.bucket_name
  acl    = "public-read-write"
}

