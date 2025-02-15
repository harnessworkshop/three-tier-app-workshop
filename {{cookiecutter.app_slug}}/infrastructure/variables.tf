variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_access_key" {
  type = string
  description = "aws access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type = string
  description = "aws secret key"
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-0f9710017e7c769e6" # hsaab-vpc
}

variable "public_subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
  default     = ["subnet-051ebd2b574ef4d57", "subnet-0e6a9895450c14535"] # hsaab-vpc public subnets
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "hsaab-eks-cluster"
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  default     = "hsaabpostgresdb"
}

variable "db_name" {
  description = "Name of the database"
  default     = "hsaabpostgresdb"
}

variable "db_username" {
  description = "Database master username"
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  sensitive   = true
} 