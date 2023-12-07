resource "aws_s3_bucket_object" "write_object" {
  bucket = var.bucket_name
  key    = var.file_name
  source = var.file_path
  acl    = "public-read" 
}