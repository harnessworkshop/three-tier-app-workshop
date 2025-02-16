variable "identifier" {
  description = "RDS identifier"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp2"
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "14"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "username" {
  description = "Database username"
  type        = string
}

variable "password" {
  description = "Database password"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
} 