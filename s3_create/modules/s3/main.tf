# file modules/s3/main.tf

resource "aws_s3_bucket" "storage" {
  bucket = var.bucket_name
  acl    = "public-read-write"
}

resource "aws_s3_bucket_object" "write_object" {
  bucket = var.bucket_name
  key    = aws_s3_bucket.storage.file_name
  source = aws_s3_bucket.storage.file_path
  acl    = "public-read" 
}