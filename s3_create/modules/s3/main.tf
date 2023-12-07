# file modules/s3/main.tf

resource "aws_s3_bucket" "storage" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "control" {
  bucket = aws_s3_bucket.storage.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  depends_on = [aws_s3_bucket_ownership_controls.control]

  bucket = aws_s3_bucket.storage.id
  acl    = "public-read-write"
}