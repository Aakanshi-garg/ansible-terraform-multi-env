terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "aakanshi-remote-backend"
    key = "terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "aakanshi-remote-backend-table"
  }
}
