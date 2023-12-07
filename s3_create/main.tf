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


#Create s3 bucket,and save image to s3 
module "s3_storage" {
  source = "./modules/s3"
  bucket_name = "project-s3-storage-li-qian"
}

module "upload" {
  source = "./modules/upload_image"
  bucket_name = module.s3_storage.bucket_id
  file_name = "aws_picture.png"
  file_path = "./aws_picture.png"
}