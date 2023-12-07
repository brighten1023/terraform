#Save tfstate to s3
terraform {
  backend "s3" {
    bucket = "project_s3_storage"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}