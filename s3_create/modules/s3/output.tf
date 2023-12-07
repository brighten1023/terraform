# file modules/s3/output.tf

output "bucket_name" {
 value = aws_s3_bucket.storage.name
}

output "bucket_id" {
    value = aws_s3_bucket.storage.id
}