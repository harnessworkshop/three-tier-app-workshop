variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_ca_cert" {
  description = "EKS cluster CA certificate"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "account_id" {
  description = "Harness Platform Account ID"
  type        = string
}

variable "delegate_token" {
  description = "Harness Platform Delegate Token"
  type        = string
}

variable "delegate_name" {
  description = "Name of the Harness Delegate"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the delegate"
  type        = string
  default     = "harness-delegate-ng"
}

variable "manager_endpoint" {
  description = "Harness Manager URL"
  type        = string
}

variable "delegate_image" {
  description = "Harness Delegate Docker image"
  type        = string
}
