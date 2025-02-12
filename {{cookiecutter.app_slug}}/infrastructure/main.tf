provider "aws" {
  region = "us-east-1"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = "default"
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

# Create VPC
module "vpc" {
  source = "./modules/vpc"
  
  cluster_name = var.cluster_name
  azs         = ["${var.aws_region}a", "${var.aws_region}b"]
}

# Create EKS cluster
module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnet_ids
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
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
  environment         = var.environment
} 