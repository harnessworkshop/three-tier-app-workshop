variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability zones"
 default     = ["us-east-1a", "us-east-1b"]
}

variable "cluster_name" {
 type        = string
 description = "Name of the EKS cluster"
}