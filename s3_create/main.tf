terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
      }
    }
}

#AWS Provider
provider "aws" {
    region = "us-east-1"
    shared_credentials_file = ".aws/credentials"
}


#Create s3 bucket 
module "s3_storage" {
  source = "./modules/s3"
  bucket_name = "project_s3_storage"
}

#Save image to s3
module "upload_image" {
  source = "./modules/s3"
  bucket_id = module.s3_storage.bucket_id
  file_name = "aws_picture.png"
  file_path = "./aws_picture.png"
}