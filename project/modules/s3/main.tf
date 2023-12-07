# file modules/s3/main.tf

resource "aws_s3_bucket" "storage" {
  bucket = var.bucket_name
  acl    = "public-read-write"
}

resource "aws_s3_bucket_object" "write_object" {
  bucket = var.bucket_id
  key    = var.file_name
  source = var.file_path
  acl    = "public-read" 
}