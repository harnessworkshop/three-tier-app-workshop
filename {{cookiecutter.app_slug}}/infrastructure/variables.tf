# AWS Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

# Environment & Network
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# EKS Configuration
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "hsaabekscluster"
}

# Harness Delegate Configuration
variable "harness_account_id" {
  description = "Harness Platform Account ID"
  type        = string
  sensitive   = true
}

variable "harness_delegate_token" {
  description = "Harness Platform Delegate Token (raw token from Harness UI)"
  type        = string
  sensitive   = true
}

# RDS Configuration
variable "db_name" {
  description = "Name of the database and RDS identifier"
  type        = string
  default     = "hsaabpostgresdb"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

# Harness Configuration
variable "harness_platform_api_key" {
  description = "Harness Platform API Key"
  type        = string
  sensitive   = true
}

# Harness Project Configuration
variable "github_repo_name" {
  description = "Name of the GitHub repository"
  type        = string
}

variable "harness_project_name" {
  description = "Name of the Harness project"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "hsaab"
}