provider "aws" {
  region = "us-east-2"
  shared_credentials_files = ["/Users/hsaab/.aws/credentials"]
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

# Create EKS cluster
# module "eks" {
#   source = "./modules/eks"

#   cluster_name    = var.cluster_name
#   vpc_id         = var.vpc_id
#   subnet_ids     = var.subnet_ids
#   environment    = var.environment
# }

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
  subnet_ids          = var.subnet_ids
  environment         = var.environment
} 