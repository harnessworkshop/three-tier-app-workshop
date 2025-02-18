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
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

# Add this data source
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

# Create VPC
# module "vpc" {
#   source = "./modules/vpc"
  
#   cluster_name = var.cluster_name
#   azs         = ["${var.aws_region}a", "${var.aws_region}b"]
# }

# Create EKS cluster
module "eks" {
  source = "./modules/eks"

  cluster_name = var.cluster_name
  # vpc_id       = module.vpc.vpc_id # commented out for now as we've already created the VPC.
  vpc_id       = "vpc-02578312775ff80dc"
  # subnet_ids   = module.vpc.public_subnet_ids # commented out for now as we've already created the VPC.
  subnet_ids   = ["subnet-0f588596c65f1eeb8", "subnet-0c7cd4215e8f8da4a"]
  environment  = var.environment
}

# Create RDS instance
module "rds" {
  source = "./modules/rds"

  identifier        = var.db_name
  allocated_storage = 20
  db_name           = var.db_name
  password          = var.db_password
  username          = var.db_username
  # vpc_id       = module.vpc.vpc_id # commented out for now as we've already created the VPC.
  vpc_id       = "vpc-02578312775ff80dc"
  # subnet_ids   = module.vpc.public_subnet_ids # commented out for now as we've already created the VPC.
  subnet_ids   = ["subnet-0f588596c65f1eeb8", "subnet-0c7cd4215e8f8da4a"]
  environment       = var.environment
} 

# Create Harness Delegate and K8s Connector
module "harness" {
  source = "./modules/harness"

  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca_cert  = module.eks.cluster_certificate_authority_data
  cluster_name     = module.eks.cluster_name
  cluster_token    = data.aws_eks_cluster_auth.cluster.token
  
  account_id       = var.harness_account_id
  delegate_token   = var.harness_delegate_token
  delegate_name    = "${var.cluster_name}delegate"
  manager_endpoint = "https://app.harness.io/gratis"
  delegate_image   = "harness/delegate:25.01.85000"

  rds_endpoint = module.rds.db_instance_endpoint
  db_name      = module.rds.db_name

  # Add new variables
  github_repo_name     = var.github_repo_name
  harness_project_name = var.harness_project_name
  namespace            = var.namespace

  # Pass dependency IDs
  eks_cluster_id = module.eks.cluster_id
  rds_instance_id = module.rds.db_instance_id
}