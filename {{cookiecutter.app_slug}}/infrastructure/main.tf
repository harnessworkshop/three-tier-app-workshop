# Configure terraform backend
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    harness = {
      source  = "harness/harness"
      version = "0.35.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "harness" {
  endpoint         = "https://app.harness.io/gateway"
  account_id       = var.harness_account_id
  platform_api_key = var.harness_platform_api_key
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
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

# Create Harness Delegate and K8s Connector
module "harness" {
  source = "./modules/harness"

  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_cert  = module.eks.cluster_certificate_authority_data
  cluster_name     = module.eks.cluster_name
  
  account_id       = var.harness_account_id
  delegate_token   = var.harness_delegate_token
  delegate_name    = "${var.cluster_name}delegate"
  manager_endpoint = "https://app.harness.io/gratis"
  delegate_image   = "harness/delegate:25.01.85000"
}

# Create RDS instance
module "rds" {
  source = "./modules/rds"

  identifier        = var.db_name
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  environment       = var.environment
} 