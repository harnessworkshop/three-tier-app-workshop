provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Configure terraform backend
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Create VPC - commented out for now as we've already created the VPC.
# module "vpc" {
#   source = "./modules/vpc"
  
#   cluster_name = var.cluster_name
#   azs         = ["${var.aws_region}a", "${var.aws_region}b"]
# }

# Create EKS cluster
module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  vpc_id       = var.vpc_id
  subnet_ids   = var.public_subnet_ids
  environment  = var.environment
}

# Create RDS instance
module "rds" {
  source = "./modules/rds"

  identifier           = var.db_identifier
  allocated_storage    = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  vpc_id              = var.vpc_id
  subnet_ids          = var.public_subnet_ids
  environment         = var.environment
} 