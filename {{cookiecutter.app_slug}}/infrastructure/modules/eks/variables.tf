variable "cluster_name" {
  default = "hsaab-cluster"
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
} 