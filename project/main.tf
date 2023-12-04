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
