terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.42.0"
    }
  }
}

provider "aws" {
    region = "us-east-2"
}

# Finding and filtering out Redhat 8 image
data "aws_ami" "app" {
    most_recent = true
    filter {
      name = "name"
      values = ["RHEL_HA-8.4.0_HVM-20210504-x86_64-2-*"]
    }
    owners = ["309956199498"] # RedHat images
}