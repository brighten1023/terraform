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
  bucket_name = "project_s3_storage"
  file_name = "aws_picture.png"
  file_path = "./aws_picture.png"
}

