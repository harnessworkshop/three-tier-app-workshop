module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name     = var.cluster_name
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  # Disable CloudWatch logging
  cluster_enabled_log_types = []

  vpc_id     = var.vpc_id #hsaab-vpc
  subnet_ids = var.subnet_ids #hsaab-subnet-2a-public, hsaab-subnet-2b-private

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

  # Add security group rules for NodePorts
  node_security_group_additional_rules = {
    ingress_nodeport_32321 = {
      description = "NodePort 32321"
      protocol    = "tcp"
      from_port   = 32321
      to_port     = 32321
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress_nodeport_32322 = {
      description = "NodePort 32322"
      protocol    = "tcp"
      from_port   = 32322
      to_port     = 32322
      type        = "ingress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}