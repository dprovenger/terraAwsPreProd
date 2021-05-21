terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.42.0"
    }
  }
}

# Documentation related to aws provider https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
    region = "us-east-2"
}

# Finding and filtering out Redhat 8 image
data "aws_ami" "app" {
    most_recent = true
    filter {
      name = "name"
      values = ["RHEL_HA-8.4.0_HVM-20210504-x86_64-2-Hourly2-GP2*"]
    }
    owners = ["309956199498"] # RedHat images
}

resource "aws_instance" "Redhat_8" {
  ami = data.aws_ami.app.id
  instance_type = "t2.micro"
  
  root_block_device {
    volume_size = 10 # Gigs
  }

  tags = {
    Name = "thepensivemind"
    Environment = "preProd"
    ManagedBy = "terraform"
  }
}

# Adding elastic IP to ec2
resource "aws_eip" "app_eip" {
  #instance = aws_instance.Redhat_8.id -> commenting out due to association below
  vpc = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "thepensivemind"
    Environment = "preProd"
    ManagedBy = "terraform"
  }
}

# Removing association to make sure terraform doesn't delete this IP with ec2
resource "aws_eip_association" "app_eip_assoc" {
  instance_id = aws_instance.Redhat_8.id
  allocation_id = aws_eip.app_eip.id
}