variable "identifier" {
  default = "hsaab-rds"
  description = "RDS identifier"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
}

variable "storage_type" {
  description = "Storage type"
}

variable "engine" {
  description = "Database engine"
}

variable "engine_version" {
  description = "Database engine version"
}

variable "instance_class" {
  description = "RDS instance class"
}

variable "db_name" {
  description = "Database name"
}

variable "username" {
  description = "Database username"
}

variable "password" {
  description = "Database password"
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