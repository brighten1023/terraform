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
    access_key = "ASIATWC6KBPQXSUTQZPF"
    secret_key = "ekDwJxtdjPxvnzOdMBfYTM2yPrN6R7GJlQHK/l0m"
}

#Create VPC and subnets
module "shared_networking" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  counter = 2
}